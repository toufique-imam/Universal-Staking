// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is
    Ownable,
    Pausable,
    ReentrancyGuard,
    IERC721Receiver
{
    // Structure to represent staking pools
    uint256 stakingFeePercentageDenominator = 1;
    uint256 stakingFeePercentageNumerator = 100;
    uint256 unstakingFeePercentageDenominator = 2;
    uint256 unstakingFeePercentageNumerator = 100;
    uint256 poolCreationFee = 0.001 ether;

    struct StakingPool {
        address stakingAddress;
        IERC20 rewardToken;
        uint256 stakingTokenDecimals;
        uint256 rewardTokenDecimals;
        uint256 rewardTokenAmount;
        uint256 totalStaked;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint256 maxStakePerWallet;
        uint256 maxTotalStake;
        bool isActive;
        bool isNFT;
        bool isSharedPool;
        uint256 penaltyPercentageNumerator;
        uint256 penaltyPercentageDenominator;
        uint256 bonusPercentageNumerator;
        uint256 bonusPercentageDenominator;
        uint256 poolPeriod;
    }

    struct Stake {
        uint256 poolId;
        uint256 tokenId;
        uint256 timestamp;
        address owner;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;
    //maps how the user stake/unstake effects on periods
    // maps to address -> poolId -> period -> amount
    mapping(uint256 => mapping(uint256 => uint256)) stakePoolHelper;

    //mapping nft token id to stake
    mapping(address => mapping(uint256 => Stake)) public vaults;
    //for nft, staking address => token id => stake
    // for token, user => poolId => stake and tokenID = token amount

    uint256 public poolCount = 1;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;
    mapping(address => uint256) public tokenWithdrawBalances;

    event PoolCreated(uint256 poolId);
    event PoolStatusChanged(uint256 poolId, bool status);
    event Staked(address indexed user, uint256 indexed poolId, uint256 amount);
    event NFTStaked(address owner, uint256 poolId, uint256 tokenId);
    event NFTUnstaked(address owner, uint256 poolId, uint256 tokenId);
    event Unstaked(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount,
        uint256 penalty
    );
    event RewardClaimed(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount
    );

    constructor() {}

    /**
     * @dev Function to create a new staking pool, pool creator pays a fee to create the pool
     * @param _stakingAddress address of the staking token/nft
     * @param _rewardTokenAddress address of the reward token
     * @param _startDate start date of the staking period
     * @param _endDate end date of the staking period
     * @param _maxStakePerWallet maximum amount of tokens/nft that can be staked per wallet
     * @param _maxTotalStake maximum amount of tokens/nft that can be staked in the pool
     * @param isShared true if the pool is shared, false means APR pool
     * @param isNFT true if the pool is for NFTs
     * @param penaltyPercentageN penalty Numerator for early unstaking
     * @param penaltyPercentageD penalty Denominator for early unstaking
     * @param bonusPercentageN bonus Numerator for shared pool
     * @param bonusPercentageD bonus Denominator for shared pool
     * @param poolPeriod pool period in seconds
     * @param amount amount of reward tokens to be added to the pool
     */
    function createStakingPool(
        address _stakingAddress,
        address _rewardTokenAddress,
        uint256 _stakingTokenDecimals,
        uint256 _rewardTokenDecimals,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _maxStakePerWallet,
        uint256 _maxTotalStake,
        bool isShared,
        bool isNFT,
        uint256 penaltyPercentageN,
        uint256 penaltyPercentageD,
        uint256 bonusPercentageN,
        uint256 bonusPercentageD,
        uint256 poolPeriod,
        uint256 amount
    ) external payable whenNotPaused nonReentrant {
        require(msg.value >= poolCreationFee, "Insufficient fee");
        require(
            _stakingAddress != address(0),
            "Staking address cannot be zero address"
        );
        require(
            _rewardTokenAddress != address(0),
            "Reward token address cannot be zero address"
        );
        require(
            _startDate > block.timestamp,
            "Start date cannot be in the past"
        );
        require(_endDate > _startDate, "End date cannot be before start date");
        require(
            _maxStakePerWallet > 0,
            "Maximum stake per wallet cannot be zero"
        );
        require(
            penaltyPercentageN < penaltyPercentageD,
            "Penalty Numerator cannot be greater than Denominator"
        );
        require(
            bonusPercentageN < bonusPercentageD,
            "Bonus Numerator cannot be greater than Denominator"
        );
        require(poolPeriod > 0, "Pool period cannot be zero");
        require(_maxTotalStake > 0, "Maximum total stake cannot be zero");

        //bonusPercentageD tokens will get bonusPercentageN tokens per poolPeriod
        // max total stake will get bonusPercentageN * max total stake / bonusPercentageD tokens per poolPeriod
        if (!isShared) {
            amount = getRequiredRewardTokenAmount(
                _startDate,
                _endDate,
                _maxTotalStake,
                bonusPercentageN,
                bonusPercentageD,
                poolPeriod,
                _stakingTokenDecimals,
                _rewardTokenDecimals
            );
        }
        require(amount > 0, "Reward Amount cannot be zero");

        IERC20 rewardToken = IERC20(_rewardTokenAddress);
        // Make sure to approve the contract to spend the tokens beforehand
        require(
            rewardToken.allowance(msg.sender, address(this)) >= amount,
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        rewardToken.transferFrom(msg.sender, address(this), amount);
        if (isShared) {
            uint256 _periodCount = (_endDate - _startDate) / poolPeriod;
            amount = amount / _periodCount; // total reward per period
        }
        uint256 poolId = poolCount;
        stakingPools[poolId] = StakingPool(
            _stakingAddress,
            rewardToken,
            _stakingTokenDecimals,
            _rewardTokenDecimals,
            amount,
            0,
            _startDate,
            _endDate,
            msg.sender,
            _maxStakePerWallet,
            _maxTotalStake,
            true,
            isNFT,
            false,
            penaltyPercentageN,
            penaltyPercentageD,
            bonusPercentageN,
            bonusPercentageD,
            poolPeriod
        );
        // isActivePool[poolId] = true;
        poolCount++;

        emit PoolCreated(poolId);
    }

    function getPeriodNumber(
        uint256 _poolId,
        uint256 _currentTime
    ) public view returns (uint256) {
        StakingPool memory pool = stakingPools[_poolId];
        if (_currentTime < pool.startDate) return 0;
        if (_currentTime > pool.endDate) {
            _currentTime = pool.endDate;
        }
        return (_currentTime - pool.startDate) / pool.poolPeriod;
    }

    function getRequiredRewardTokenAmount(
        uint256 _startDate,
        uint256 _endDate,
        uint256 _maxTotalStake,
        uint256 bonusPercentageN,
        uint256 bonusPercentageD,
        uint256 poolPeriod,
        uint256 stakingTokenDecimals,
        uint256 rewardTokenDecimals
    ) public pure returns (uint256) {
        uint256 totalRewardAmount = ((_endDate - _startDate) *
            bonusPercentageN *
            _maxTotalStake) / (bonusPercentageD * poolPeriod);

        return
            convertAmountToDecimal(
                totalRewardAmount,
                stakingTokenDecimals,
                rewardTokenDecimals
            );
    }

    /**
     * @dev Function for users to stake tokens
     * @param _poolId pool id to stake in
     * @param _amount amount of tokens to stake
     */
    function stakeToken(
        uint256 _poolId,
        uint256 _amount
    ) public whenNotPaused nonReentrant {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        // Check if the pool is not NFT
        require(!pool.isNFT, "This function is for Tokens only");
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "The pool isn't active yet."
        );
        // Check if the pool has any reward tokens
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");
        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + _amount <=
                pool.maxStakePerWallet,
            "Maximum Stake Limit exceeded."
        );
        // Make sure to approve the contract to spend the tokens beforehand
        require(
            IERC20(pool.stakingAddress).allowance(msg.sender, address(this)) >=
                _amount,
            "Please approve the contract to spend the tokens first"
        );

        //claim unclaim rewards if any
        if (stakedBalances[msg.sender][_poolId] > 0) {
            _claimToken(
                _poolId,
                msg.sender,
                stakedBalances[msg.sender][_poolId],
                false
            );
        }

        // Transfer staking tokens from the user to the contract
        IERC20(pool.stakingAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Calculate staking fee
        uint256 stakingFee = (_amount * stakingFeePercentageNumerator) /
            stakingFeePercentageDenominator;

        // update token withdraw balance
        tokenWithdrawBalances[pool.stakingAddress] += stakingFee;

        // Calculate net staked amount
        uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] += netStakedAmount;
        stakingPools[_poolId].totalStaked += netStakedAmount;
        // Update total staked tokens in the pool
        uint256 totalUserStaked = stakedBalances[msg.sender][_poolId];
        // Update user's vault
        vaults[msg.sender][_poolId] = Stake({
            poolId: _poolId,
            tokenId: totalUserStaked,
            timestamp: block.timestamp,
            owner: msg.sender
        });

        // Emit stake event
        emit Staked(msg.sender, _poolId, _amount);
    }

    /**
     * @dev Function for users to stake NFTs
     * @param _poolId pool id to stake in
     * @param tokenIds Array of token ids to stake
     */
    function stakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) public whenNotPaused nonReentrant {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        // Check if the pool is NFT
        require(pool.isNFT, "This function is for NFT stake only");
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "The pool isn't active yet."
        );
        // Check if the pool has any reward tokens
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");
        require(tokenIds.length > 0, "No NFT token to stake");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + tokenIds.length <=
                pool.maxStakePerWallet,
            "Maximum Stake Limit exceeded."
        );

        IERC721 nft = IERC721(pool.stakingAddress);
        uint256 tokenId;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            // check if token is owned by user
            require(nft.ownerOf(tokenId) == msg.sender, "not your token");
            // check if token is approved
            require(nft.getApproved(tokenId) == address(this), "not approved");
            // check if token is not already staked
            require(
                vaults[pool.stakingAddress][tokenId].tokenId == 0,
                "already staked"
            );
            // Transfer staking tokens from the user to the contract
            nft.safeTransferFrom(msg.sender, address(this), tokenId);
            // Update user's staked balance
            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp,
                owner: msg.sender
            });
            emit NFTStaked(msg.sender, _poolId, tokenId);
        }
        // Update total staked tokens in the pool
        stakedBalances[msg.sender][_poolId] += tokenIds.length;
        stakingPools[_poolId].totalStaked += tokenIds.length;
    }

    /**
     * @dev Function for users to unstake tokens
     * @param _poolId pool id to unstake from
     * @param _amount amount of tokens to unstake
     */
    function unstakeToken(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        _claimToken(_poolId, msg.sender, _amount, true);
    }

    /**
     * @dev Function for users to claim reward tokens
     * @param _poolId pool id to claim rewards from
     */
    function claimToken(uint256 _poolId) external nonReentrant whenNotPaused {
        // claim all rewards
        _claimToken(
            _poolId,
            msg.sender,
            stakedBalances[msg.sender][_poolId],
            false
        );
    }

    /**
     * @dev Internal Function to unstake tokens
     * @param _poolId pool id to unstake from
     * @param account address of the user
     * @param _amount amount of tokens to unstake
     */
    function _unstakeToken(
        uint256 _poolId,
        address account,
        uint256 _amount
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from unstaking after the pool is set inactive

        // Check if the user has enough staked tokens
        require(
            stakedBalances[account][_poolId] >= _amount,
            "Insufficient staked balance"
        );
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );
        // Calculate unstaking fee
        uint256 unstakingFee = (_amount * unstakingFeePercentageNumerator) /
            unstakingFeePercentageDenominator;
        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < pool.endDate) {
            penalty =
                (_amount * pool.penaltyPercentageNumerator) /
                pool.penaltyPercentageDenominator;
        }
        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;
        // update token withdraw balance
        tokenWithdrawBalances[pool.stakingAddress] += unstakingFee + penalty;

        // Transfer staking tokens back to the user
        IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);
        // Update user's staked balance
        stakedBalances[account][_poolId] -= _amount;
        stakingPools[_poolId].totalStaked -= _amount;
        // update vault
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: stakedBalances[account][_poolId],
            timestamp: block.timestamp, // update timestamp to current time
            owner: account
        });
        emit Unstaked(account, _poolId, _amount, penalty);
    }

    /**
     * @dev Internal Function to claim reward tokens
     * @param _poolId pool id to claim rewards from
     * @param account address of the user
     * @param _amount amount of tokens to unstake
     * @param _unstake true if user wants to unstake
     */
    function _claimToken(
        uint256 _poolId,
        address account,
        uint256 _amount,
        bool _unstake
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        // require(pool.isActive, "This pool is not active"); adding this check will prevent users from claiming rewards after the pool is set inactive
        // Check if the pool is not NFT
        require(!pool.isNFT, "This function is for Tokens only");
        require(
            block.timestamp >= pool.startDate,
            "Claiming is not allowed before the staking period starts"
        );
        Stake memory staked = vaults[account][_poolId];
        if (staked.timestamp >= pool.endDate) {
            //already claimed
            if (_unstake) {
                // unstake tokens if user wants to unstake
                _unstakeToken(_poolId, account, _amount);
            }
            return;
        }
        require(staked.timestamp < pool.endDate, "Already claimed");
        // Check if the user has staked tokens
        if (staked.owner == address(0) || staked.tokenId == 0) return;

        // Calculate earned reward tokens
        uint256 earned = 0;
        uint256 _tokenAmountInRewardDecimals = convertAmountToDecimal(
            staked.tokenId,
            pool.stakingTokenDecimals,
            pool.rewardTokenDecimals
        );
        if (pool.isSharedPool) {
            uint256 periodStarted = getPeriodNumber(_poolId, staked.timestamp) +
                1;
            uint256 periodNow = getPeriodNumber(_poolId, block.timestamp);

            //reward tokens distributed based on total reward tokens and amount staked
            uint256 totalStakeAmount;
            uint256 totalInRewardAmount;
            for (uint256 i = periodStarted; i < periodNow; i++) {
                totalStakeAmount += stakePoolHelper[_poolId][i];
                totalInRewardAmount = convertAmountToDecimal(
                    totalStakeAmount,
                    pool.stakingTokenDecimals,
                    pool.rewardTokenDecimals
                );
                earned =
                    earned +
                    (_tokenAmountInRewardDecimals * pool.rewardTokenAmount) /
                    (totalInRewardAmount);
            }
            // update vault
            vaults[account][_poolId] = Stake({
                poolId: _poolId,
                tokenId: staked.tokenId,
                timestamp: periodNow * pool.poolPeriod + pool.startDate - 1,
                owner: account
            });
        } else {
            //reward tokens distributed based on bonus percentage and amount staked
            uint256 _periodStaked;
            {
                if (block.timestamp < pool.endDate)
                    _periodStaked =
                        (block.timestamp - staked.timestamp) /
                        pool.poolPeriod;
                else
                    _periodStaked =
                        (pool.endDate - staked.timestamp) /
                        pool.poolPeriod;
            }
            earned =
                _tokenAmountInRewardDecimals *
                pool.bonusPercentageNumerator *
                _periodStaked;
            earned = earned / pool.bonusPercentageDenominator;
            // update vault
            vaults[account][_poolId] = Stake({
                poolId: _poolId,
                tokenId: staked.tokenId,
                timestamp: block.timestamp, // update timestamp to current time
                owner: account
            });
        }

        require(_unstake || earned > 0, "nothing to unstake or claim");

        // transfer reward tokens to user
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            stakingPools[_poolId].rewardTokenAmount -= earned;
        }
        if (_unstake) {
            // unstake tokens if user wants to unstake
            _unstakeToken(_poolId, account, _amount);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    /**
     * @dev Function for users to unstake NFTs
     * @param _poolId pool id to unstake from
     * @param tokenIds Array of token ids to unstake
     */
    function unstakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, true);
    }

    /**
     * @dev Function for users to claim reward tokens
     * @param _poolId Pool id to claim rewards from
     * @param tokenIds Array of token ids to claim rewards from
     */
    function claimNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, false);
    }

    /**
     * @dev Internal Function to unstake NFTs
     * @param _poolId pool id to unstake from
     * @param account address of the user
     * @param tokenIds Array of token ids to unstake
     */
    function _unstakeNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds
    ) internal {
        uint256 tokenId;
        StakingPool memory pool = stakingPools[_poolId];
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from unstaking after the pool is set inactive
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );
        // update total staked tokens in the pool
        stakingPools[_poolId].totalStaked -= tokenIds.length;
        // update user's staked balance
        stakedBalances[account][_poolId] -= tokenIds.length;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");

            delete vaults[pool.stakingAddress][tokenId];

            // Transfer staking tokens back to the user
            IERC721(pool.stakingAddress).safeTransferFrom(
                address(this),
                account,
                tokenId
            );
            emit NFTUnstaked(account, _poolId, tokenId);
        }
    }

    /**
     * @dev Internal Function to claim reward tokens
     * @param _poolId pool id to claim rewards from
     * @param account address of the user
     * @param tokenIds Array of token ids to claim rewards from
     * @param _unstake true if user wants to unstake
     */
    function _claimNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds,
        bool _unstake
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from claiming rewards after the pool is set inactive
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate,
            "Claiming is not allowed before the staking period starts"
        );
        uint256 tokenId;
        uint256 earned = 0;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");
            if (staked.timestamp > pool.endDate) continue; // already claimed

            if (pool.isSharedPool) {
                uint256 periodStarted = getPeriodNumber(
                    _poolId,
                    staked.timestamp
                ) + 1;
                uint256 periodNow = getPeriodNumber(_poolId, block.timestamp);
                uint256 totalStakeAmount;
                for (uint256 _i = periodStarted; _i < periodNow; _i++) {
                    totalStakeAmount += stakePoolHelper[_poolId][_i];
                    earned = earned + pool.rewardTokenAmount / totalStakeAmount;
                }
                // update vault
                vaults[account][_poolId] = Stake({
                    poolId: _poolId,
                    tokenId: staked.tokenId,
                    timestamp: periodNow * pool.poolPeriod + pool.startDate - 1,
                    owner: account
                });
            } else {
                uint256 _periodStaked;
                {
                    if (block.timestamp < pool.endDate)
                        _periodStaked =
                            (block.timestamp - staked.timestamp) /
                            pool.poolPeriod;
                    else
                        _periodStaked =
                            (pool.endDate - staked.timestamp) /
                            pool.poolPeriod;
                }
                // reward tokens distributed based on bonus percentage and amount staked
                earned =
                    earned +
                    (pool.bonusPercentageNumerator * _periodStaked) /
                    pool.bonusPercentageDenominator;
                vaults[pool.stakingAddress][tokenId] = Stake({
                    poolId: _poolId,
                    tokenId: tokenId,
                    timestamp: block.timestamp, // update timestamp to current time
                    owner: account
                });
            }
        }
        uint256 penaltyFee = 0;
        uint256 unstakingFee = 0;
        if (_unstake) {
            // calculate penalty
            if (pool.endDate < block.timestamp) {
                penaltyFee =
                    (earned * pool.penaltyPercentageNumerator) /
                    pool.penaltyPercentageDenominator;
            }
            // calculate unstaking fee
            unstakingFee =
                (earned * unstakingFeePercentageNumerator) /
                unstakingFeePercentageDenominator;
            tokenWithdrawBalances[address(pool.rewardToken)] +=
                penaltyFee +
                unstakingFee;
        }
        // calculate net earned amount
        earned = earned - penaltyFee - unstakingFee;
        require(_unstake || earned > 0, "nothing to unstake or claim");
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);

            stakingPools[_poolId].rewardTokenAmount -= earned;
        }
        if (_unstake) {
            _unstakeNFT(_poolId, account, tokenIds);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    /**
     * @dev Function to convert amount to decimal
     * @param amount amount to convert
     * @param currentDecimals current decimals of the token
     * @param targetDecimals target decimals of the token
     */
    function convertAmountToDecimal(
        uint256 amount,
        uint256 currentDecimals,
        uint256 targetDecimals
    ) public pure returns (uint256) {
        if (currentDecimals == targetDecimals) return amount;
        return (amount * (10 ** targetDecimals)) / (10 ** currentDecimals);
    }

    /**
     * @dev Function to check if a pool exists
     * @param _poolId pool id
     * @return bool true if pool exists, false otherwise
     */
    function poolExists(uint256 _poolId) external view returns (bool) {
        return _poolId < poolCount;
    }

    /**
     * @dev Function to check if a pool is active
     * @param _poolId pool id
     * @return bool true if pool is active, false otherwise
     */
    function poolIsActive(uint256 _poolId) external view returns (bool) {
        return
            stakingPools[_poolId].isActive &&
            block.timestamp >= stakingPools[_poolId].startDate &&
            block.timestamp <= stakingPools[_poolId].endDate;
    }

    /**
     * @dev Function to get pool info
     * @param _poolId pool id
     * @return StakingPool struct
     */
    function getPoolInfo(
        uint256 _poolId
    ) external view returns (StakingPool memory) {
        return stakingPools[_poolId];
    }

    /**
     * @dev Function to get user's reward info for staked nfts
     * @param _poolId pool id
     * @param tokenIds array of token ids
     */
    function earningInfoNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) public view returns (uint256) {
        uint256 tokenId;
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isNFT == false) return earned;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            if (staked.timestamp > pool.endDate) continue; // already claimed

            if (pool.isSharedPool) {
                uint256 periodStarted = getPeriodNumber(
                    _poolId,
                    staked.timestamp
                ) + 1;
                uint256 periodNow = getPeriodNumber(_poolId, block.timestamp);
                uint256 totalStakeAmount;
                for (uint256 _i = periodStarted; _i < periodNow; _i++) {
                    totalStakeAmount += stakePoolHelper[_poolId][_i];
                    earned = earned + pool.rewardTokenAmount / totalStakeAmount;
                }
            } else {
                uint256 _periodStaked;
                {
                    if (block.timestamp < pool.endDate)
                        _periodStaked =
                            (block.timestamp - staked.timestamp) /
                            pool.poolPeriod;
                    else
                        _periodStaked =
                            (pool.endDate - staked.timestamp) /
                            pool.poolPeriod;
                }
                // reward tokens distributed based on bonus percentage and amount staked
                earned =
                    earned +
                    (pool.bonusPercentageNumerator * _periodStaked) /
                    pool.bonusPercentageDenominator;
            }
        }
        return earned;
    }

    /**
     * @dev Function to get user's reward info for staked tokens
     * @param _poolId pool id
     * @param account address of the user
     */
    function earningInfoToken(
        uint256 _poolId,
        address account
    ) public view returns (uint256) {
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isNFT == true) return earned;
        Stake memory staked = vaults[account][_poolId];
        if (staked.timestamp > pool.endDate) return earned; // already claimed
        uint256 _tokenAmountInRewardDecimals = convertAmountToDecimal(
            staked.tokenId,
            pool.stakingTokenDecimals,
            pool.rewardTokenDecimals
        );
        uint256 periodStarted = getPeriodNumber(_poolId, staked.timestamp) + 1;
        uint256 periodNow = getPeriodNumber(_poolId, block.timestamp);

        // Calculate earned reward tokens
        if (pool.isSharedPool) {
            //reward tokens distributed based on total reward tokens and amount staked
            uint256 totalStakeAmount;
            uint256 totalInRewardAmount;
            for (uint256 i = periodStarted; i < periodNow; i++) {
                totalStakeAmount += stakePoolHelper[_poolId][i];
                totalInRewardAmount = convertAmountToDecimal(
                    totalStakeAmount,
                    pool.stakingTokenDecimals,
                    pool.rewardTokenDecimals
                );
                earned =
                    earned +
                    (_tokenAmountInRewardDecimals * pool.rewardTokenAmount) /
                    (totalInRewardAmount);
            }
        } else {
            //reward tokens distributed based on bonus percentage and amount staked
            uint256 _periodStaked;
            {
                if (block.timestamp < pool.endDate)
                    _periodStaked =
                        (block.timestamp - staked.timestamp) /
                        pool.poolPeriod;
                else
                    _periodStaked =
                        (pool.endDate - staked.timestamp) /
                        pool.poolPeriod;
            }
            earned =
                _tokenAmountInRewardDecimals *
                pool.bonusPercentageNumerator *
                _periodStaked;
            earned = earned / pool.bonusPercentageDenominator;
        }
        return earned;
    }

    /**
     * @dev Changes pool status, can only be called by the creator of the pool.
     * @param _poolId pool id
     * @param status true for active and false for inactive
     */
    function setPoolStatus(uint256 _poolId, bool status) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(
            pool.creator == msg.sender,
            "Only creator can change pool status"
        );
        require(pool.isActive != status, "Pool is already in the same state");
        pool.isActive = status;
        emit PoolStatusChanged(_poolId, status);
    }

    /**
     * @dev withdraws reward tokens from contract, can only be called by the creator of the pool.
     * @param _poolId pool id
     */
    function withdrawStake(uint256 _poolId) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.creator == msg.sender, "Only creator can withdraw");
        require(
            pool.isActive == false || pool.endDate < block.timestamp,
            "Pool is active or not ended yet"
        );
        pool.rewardToken.transfer(msg.sender, pool.rewardTokenAmount);
        pool.rewardTokenAmount = 0;
    }

    /**
     * @dev Withdraws ERC20 tokens from contract, can only be called by the owner.
     * can be used to withdraw staking and reward tokens
     * amount of token to withdraw is tracked in tokenWithdrawBalances mapping
     * @param token address of token to withdraw
     */
    function withdrawToken(address token) external onlyOwner nonReentrant {
        uint256 amount = tokenWithdrawBalances[token];
        require(amount > 0, "No token to withdraw");
        IERC20(token).transfer(msg.sender, amount);
        tokenWithdrawBalances[token] = 0;
    }

    /**
     * @dev Withdraws ETH from contract, can only be called by the owner.
     */
    function withdraw() external onlyOwner nonReentrant {
        payable(msg.sender).transfer(address(this).balance);
    }

    /**
     * @dev pause and unpause contract, can only be called by the owner.
     * @param state true for pause and false for unpause
     */
    function changeContractState(bool state) external onlyOwner {
        if (state == true) _pause();
        else _unpause();
    }

    /**
     * @dev function to receive ERC721 tokens, when safeTransferFrom is called on ERC721 contract
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            IERC721Receiver.onERC721Received.selector ^ this.stakeNFT.selector;
    }

    /**
     * @dev set staking fee percentage, can only be called by the owner.
     * @param _stakingFeePercentageN Staking fee percentage nominator
     * @param _stakingFeePercentageD Staking fee percentage dominator
     */
    function setStakingFeePercentage(
        uint256 _stakingFeePercentageN,
        uint256 _stakingFeePercentageD
    ) external onlyOwner {
        require(
            _stakingFeePercentageN < _stakingFeePercentageD,
            "Invalid staking fee percentage"
        );
        stakingFeePercentageNumerator = _stakingFeePercentageN;
        stakingFeePercentageDenominator = _stakingFeePercentageD;
    }

    /**
     * @dev set unstaking fee percentage, can only be called by the owner.
     * @param _unstakingFeePercentageN Unstaking fee percentage nominator
     * @param _unstakingFeePercentageD Unstaking fee percentage dominator
     */
    function setUnstakingFeePercentage(
        uint256 _unstakingFeePercentageN,
        uint256 _unstakingFeePercentageD
    ) external onlyOwner {
        require(
            _unstakingFeePercentageN < _unstakingFeePercentageD,
            "Invalid unstaking fee percentage"
        );
        unstakingFeePercentageNumerator = _unstakingFeePercentageN;
        unstakingFeePercentageDenominator = _unstakingFeePercentageD;
    }

    function getStakingFeePercentage()
        external
        view
        returns (uint256, uint256)
    {
        return (stakingFeePercentageNumerator, stakingFeePercentageDenominator);
    }

    function getUnstakingFeePercentage()
        external
        view
        returns (uint256, uint256)
    {
        return (
            unstakingFeePercentageNumerator,
            unstakingFeePercentageDenominator
        );
    }

    function setPoolCreationFee(uint256 _poolCreationFee) external onlyOwner {
        poolCreationFee = _poolCreationFee;
    }

    function getPoolCreationFee() external view returns (uint256) {
        return poolCreationFee;
    }
}
