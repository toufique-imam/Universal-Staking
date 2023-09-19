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
    uint256 stakingFeePercentageDominator;
    uint256 stakingFeePercentageNominator;
    uint256 unstakingFeePercentageDominator;
    uint256 unstakingFeePercentageNominator;
    uint256 poolCreationFee;

    struct StakingPool {
        address stakingAddress;
        IERC20 rewardToken;
        uint256 rewardTokenAmount;
        uint256 totalStaked;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint256 maxStakePerWallet;
        bool isActive;
        bool isNFT;
        bool isSharedPool;
        uint256 penaltyPercentage;
        uint256 bonusPercentage;
    }
    struct Stake {
        uint256 poolId;
        uint256 tokenId;
        uint256 timestamp;
        address owner;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;

    //mapping nft token id to stake
    mapping(address => mapping(uint256 => Stake)) public vaults;
    //for nft, staking address => token id => stake
    // for token, user => poolId => stake and tokenID = token amount

    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

    event PoolCreated(uint256 poolId);
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

    // Constructor to set the contract owner
    constructor(
        uint256 _stakingFeePercentageN,
        uint256 _stakingFeePercentageD,
        uint256 _unstakingFeePercentageN,
        uint256 _unstakingFeePercentageD,
        uint256 _poolCreationFee
    ) {
        stakingFeePercentageNominator = _stakingFeePercentageN;
        stakingFeePercentageDominator = _stakingFeePercentageD;
        unstakingFeePercentageNominator = _unstakingFeePercentageN;
        unstakingFeePercentageDominator = _unstakingFeePercentageD;
        poolCreationFee = _poolCreationFee;
    }

    // Function to create a staking pool
    function createStakingPool(
        address _stakingAddress,
        address _rewardTokenAddress,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _maxStakePerWallet,
        bool isNFT,
        bool isSharedPool,
        uint256 penaltyPercentage,
        uint256 bonusPercentage
    ) external payable whenNotPaused nonReentrant {
        require(msg.value >= poolCreationFee, "Insufficient fee");

        uint256 poolId = poolCount;
        stakingPools[poolId] = StakingPool(
            _stakingAddress,
            IERC20(_rewardTokenAddress),
            0,
            0,
            _startDate,
            _endDate,
            msg.sender,
            _maxStakePerWallet,
            true,
            isNFT,
            isSharedPool,
            penaltyPercentage,
            bonusPercentage
        );
        // isActivePool[poolId] = true;
        poolCount++;

        emit PoolCreated(poolId);
    }

    function receiveToken(uint256 _poolId, uint256 amount) public nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");

        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        // Make sure to approve the contract to spend the tokens beforehand
        require(
            pool.rewardToken.allowance(msg.sender, address(this)) >= amount,
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        pool.rewardToken.transferFrom(msg.sender, address(this), amount);
        pool.rewardTokenAmount += amount;
    }

    // Function for users to stake tokens
    function stakeToken(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        // Check if the pool is active
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");
        require(!pool.isNFT, "This function is for Tokens only");
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + _amount <=
                pool.maxStakePerWallet,
            "Exceeded maximum stake limit"
        );
        // Make sure to approve the contract to spend the tokens beforehand

        require(
            IERC20(pool.stakingAddress).allowance(msg.sender, address(this)) >=
                _amount,
            "Please approve the contract to spend the tokens first"
        );
        //claim unclaim reward
        _claimToken(_poolId, msg.sender, stakedBalances[msg.sender][_poolId], false);

        // Transfer staking tokens from the user to the contract

        IERC20(pool.stakingAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Calculate staking fee
        uint256 stakingFee = (_amount * stakingFeePercentageNominator) /
            stakingFeePercentageDominator;
            
        // Calculate net staked amount
        uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] += netStakedAmount;

        // Update total staked tokens in the pool
        uint256 totalUserStaked = stakedBalances[msg.sender][_poolId];
        vaults[msg.sender][_poolId] = Stake({
            poolId: _poolId,
            tokenId: totalUserStaked,
            timestamp: block.timestamp,
            owner: msg.sender
        });

        // Emit stake event
        emit Staked(msg.sender, _poolId, _amount);
    }

    // Function for users to stake tokens
    function stakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external whenNotPaused nonReentrant {
        // Check if the pool is active
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");
        require(pool.isNFT, "This function is for NFT stake only");

        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );

        require(pool.rewardTokenAmount > 0, "No reward token in the pool");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + tokenIds.length <=
                pool.maxStakePerWallet,
            "Exceeded maximum stake limit"
        );

        IERC721 nft = IERC721(pool.stakingAddress);

        uint256 tokenId;
        pool.totalStaked += tokenIds.length;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            require(nft.ownerOf(tokenId) == msg.sender, "not your token");
            require(nft.getApproved(tokenId) == address(this), "not approved");
            require(
                vaults[pool.stakingAddress][tokenId].tokenId == 0,
                "already staked"
            );

            nft.safeTransferFrom(msg.sender, address(this), tokenId);
            emit NFTStaked(msg.sender, _poolId, tokenId);

            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp,
                owner: msg.sender
            });
            stakedBalances[msg.sender][_poolId]++;
        }
    }

    // Function for users to unstake tokens
    function unstakeToken(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        _claimToken(_poolId, msg.sender, _amount, true);
    }

    function claimToken(
        uint256 _poolId,
        uint256 _amount
    ) external nonReentrant whenNotPaused {
        _claimToken(_poolId, msg.sender, _amount, false);
    }

    function _unstakeToken(
        uint256 _poolId,
        address account,
        uint256 _amount
    ) internal {
        StakingPool storage pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");

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
        uint256 unstakingFee = (_amount * unstakingFeePercentageNominator) /
            unstakingFeePercentageDominator;
        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < pool.endDate) {
            penalty = (_amount * pool.penaltyPercentage) / 100;
        }
        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;

        // Transfer staking tokens back to the user
        IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);
        stakedBalances[account][_poolId] -= _amount;
        //unstakedBalances[account][_poolId] += netUnstakedAmount;
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: stakedBalances[account][_poolId],
            timestamp: block.timestamp,
            owner: account
        });
        emit Unstaked(account, _poolId, _amount, penalty);
    }

    function _claimToken(
        uint256 _poolId,
        address account,
        uint256 _amount,
        bool _unstake
    ) internal {
        StakingPool storage pool = stakingPools[_poolId];

        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        require(!pool.isNFT, "This function is for Tokens only");
        Stake memory staked = vaults[account][_poolId];
        require(staked.owner == account, "not an owner");
        uint256 earned = 0;
        if (pool.isSharedPool) {
            earned = (staked.tokenId * pool.bonusPercentage * (block.timestamp - staked.timestamp)/1 days); 
        } else {
            uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount / (pool.endDate - pool.startDate);
            earned = (staked.tokenId * totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
        }
        earned = earned / 100;
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: staked.tokenId,
            timestamp: uint48(block.timestamp),
            owner: account
        });
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            pool.rewardTokenAmount -= earned;
        }
        if (_unstake) {
            _unstakeToken(_poolId, account, _amount);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    function unstakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, true);
    }

    function claimNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, false);
    }

    function _unstakeNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds
    ) internal {
        uint256 tokenId;
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        pool.totalStaked -= tokenIds.length;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");
            stakedBalances[account][_poolId]--;
            delete vaults[pool.stakingAddress][tokenId];
            emit NFTUnstaked(account, _poolId, tokenId);

            IERC721(pool.stakingAddress).safeTransferFrom(
                address(this),
                account,
                tokenId
            );
        }
    }

    function _claimNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds,
        bool _unstake
    ) internal {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");
        require(pool.isNFT, "This function is for NFT stake only");
        uint256 tokenId;
        uint256 earned = 0;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");
            if (pool.isSharedPool) {
                earned = earned + (pool.bonusPercentage * (block.timestamp - staked.timestamp)/ 1 days );
            } else {
                uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount /
                    (pool.endDate - pool.startDate);
                earned = earned + (totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
            }
            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp,
                owner: account
            });
        }
        earned = earned / 100;
        if (_unstake) {
            if (earned > 0 && pool.endDate < block.timestamp) {
                earned = (earned * (100 - pool.penaltyPercentage)) / 100;
            }
            earned =
                (earned *
                    (unstakingFeePercentageDominator -
                        unstakingFeePercentageNominator)) /
                unstakingFeePercentageDominator;
        }
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            pool.rewardTokenAmount -= earned;
        }
        if (_unstake) {
            _unstakeNFT(_poolId, account, tokenIds);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    // Function to check if a pool exists
    function poolExists(uint256 _poolId) external view returns (bool) {
        return _poolId < poolCount;
    }

    // Function to check if a pool is active
    function poolIsActive(uint256 _poolId) external view returns (bool) {
        return
            stakingPools[_poolId].isActive &&
            block.timestamp >= stakingPools[_poolId].startDate &&
            block.timestamp <= stakingPools[_poolId].endDate;
    }

    // Function to get pool information
    function getPoolInfo(
        uint256 _poolId
    ) external view returns (StakingPool memory) {
        return stakingPools[_poolId];
    }


    function earningInfoNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external view returns (uint256) {
        uint256 tokenId;
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isActive == false) return earned;
        if (pool.isNFT == false) return earned;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            if (pool.isSharedPool) {
                earned =
                    earned +
                    (pool.bonusPercentage *
                        (block.timestamp - staked.timestamp) / 1 days);
            } else {
                uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount /
                    (pool.endDate - pool.startDate);
                earned =
                    earned +
                    (totalPoolRewardPerPeriod *
                        (block.timestamp - staked.timestamp)/ 1 days);
            }
        }
        earned = earned / 100;
        return earned;
    }

    function earningInfoToken(
        uint256 _poolId,
        address account
    ) external view returns (uint256) {
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isActive == false) return earned;
        if (pool.isNFT == true) return earned;

        Stake memory staked = vaults[account][_poolId];
        if (pool.isSharedPool) {
            earned =
                (staked.tokenId *
                    pool.bonusPercentage *
                    (block.timestamp - staked.timestamp)) /
                1 days;
        } else {
            uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount /
                (pool.endDate - pool.startDate);
            earned =
                (staked.tokenId *
                    totalPoolRewardPerPeriod *
                    (block.timestamp - staked.timestamp)) /
                1 days;
        }
        earned = earned / 100;
        return earned;
    }

    function setPoolInactive(
        uint256 _poolId,
        bool status
    ) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(
            pool.creator == msg.sender,
            "Only creator can set pool inactive"
        );
        require(pool.isActive != status, "Pool is already in the same state");
        pool.isActive = status;
    }

    function withdrawStake(uint256 _poolId) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.creator == msg.sender, "Only creator can withdraw");
        require(pool.isActive == false, "Pool is active");
        pool.rewardToken.transfer(msg.sender, pool.rewardTokenAmount);
        pool.rewardTokenAmount = 0;
    }

    function withdrawToken(
        address token
    ) external onlyOwner whenPaused nonReentrant {
        IERC20(token).transfer(
            msg.sender,
            IERC20(token).balanceOf(address(this))
        );
    }

    function withdraw() external onlyOwner nonReentrant {
        payable(msg.sender).transfer(address(this).balance);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        require(from == address(0x0), "Cannot send nfts to Vault directly");
        return IERC721Receiver.onERC721Received.selector;
    }

    function setStakingFeePercentage(
        uint256 _stakingFeePercentageN,
        uint256 _stakingFeePercentageD
    ) external onlyOwner {
        require(
            _stakingFeePercentageN < _stakingFeePercentageD,
            "Invalid staking fee percentage"
        );
        stakingFeePercentageNominator = _stakingFeePercentageN;
        stakingFeePercentageDominator = _stakingFeePercentageD;
    }

    function setUnstakingFeePercentage(
        uint256 _unstakingFeePercentageN,
        uint256 _unstakingFeePercentageD
    ) external onlyOwner {
        require(
            _unstakingFeePercentageN < _unstakingFeePercentageD,
            "Invalid unstaking fee percentage"
        );
        unstakingFeePercentageNominator = _unstakingFeePercentageN;
        unstakingFeePercentageDominator = _unstakingFeePercentageD;
    }
    function getStakingFeePercentage() external view returns (uint256, uint256) {
        return (stakingFeePercentageNominator, stakingFeePercentageDominator);
    }
    function getUnstakingFeePercentage() external view returns (uint256, uint256) {
        return (unstakingFeePercentageNominator, unstakingFeePercentageDominator);
    }

    function setPoolCreationFee(uint256 _poolCreationFee) external onlyOwner {
        poolCreationFee = _poolCreationFee;
    }
    function getPoolCreationFee() external view returns (uint256) {
        return poolCreationFee;
    }
}
