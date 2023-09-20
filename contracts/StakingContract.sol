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
    mapping(address => uint256) public tokenWithdrawBalances;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

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
            penaltyPercentage < 100 && penaltyPercentage >= 0,
            "Penalty percentage cannot be more than 100 and less than 0"
        );
        require(
            bonusPercentage < 100 && bonusPercentage >= 0,
            "Bonus percentage cannot be more than 100 and less than 0"
        );

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
        // Check if the pool is active
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
            "Staking period is not valid"
        );
        // Check if the pool has any reward tokens
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

        //claim unclaim rewards if any
        if(stakedBalances[msg.sender][_poolId] > 0){
            _claimToken(_poolId, msg.sender, stakedBalances[msg.sender][_poolId], false);
        }
        
        // Transfer staking tokens from the user to the contract
        IERC20(pool.stakingAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Calculate staking fee
        uint256 stakingFee = (_amount * stakingFeePercentageNominator) /
            stakingFeePercentageDominator;
        
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

    // Function for users to stake tokens
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
            "Staking period is not valid"
        );
        // Check if the pool has any reward tokens
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + tokenIds.length <=
                pool.maxStakePerWallet,
            "Exceeded maximum stake limit"
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
            // Update total staked tokens in the pool
            stakedBalances[msg.sender][_poolId]++;
            stakingPools[_poolId].totalStaked++;  
            emit NFTStaked(msg.sender, _poolId, tokenId); 
        }
    }

    // Function for users to unstake tokens
    function unstakeToken(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        _claimToken(_poolId, msg.sender, _amount, true);
    }

    // Function for users to claim reward tokens
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
        uint256 unstakingFee = (_amount * unstakingFeePercentageNominator) / unstakingFeePercentageDominator;
        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < pool.endDate) {
            penalty = (_amount * pool.penaltyPercentage) / 100;
        }
        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;
        // update token withdraw balance
        tokenWithdrawBalances[pool.stakingAddress] += unstakingFee + penalty;

        // Transfer staking tokens back to the user
        IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);
        // Update user's staked balance
        stakedBalances[account][_poolId] -= _amount;
        // update vault
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: stakedBalances[account][_poolId],
            timestamp: block.timestamp, // update timestamp to current time
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
        // require(pool.isActive, "This pool is not active"); adding this check will prevent users from claiming rewards after the pool is set inactive
        // Check if the pool is not NFT
        require(!pool.isNFT, "This function is for Tokens only");
        require(
            block.timestamp >= pool.startDate,
            "Claiming is not allowed before the staking period starts"
        );
        Stake memory staked = vaults[account][_poolId];
        // Check if the user has staked tokens
        if(staked.owner == address(0) || staked.tokenId == 0) return;
        
        // Calculate earned reward tokens
        uint256 earned = 0;
        if (pool.isSharedPool) {
            //reward tokens distributed based on bonus percentage and amount staked
            earned = (staked.tokenId * pool.bonusPercentage * (block.timestamp - staked.timestamp)/1 days); 
            earned = earned / 100;
        } else {
            //reward tokens distributed based on total reward tokens and amount staked
            uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount / (pool.endDate - pool.startDate);
            earned = (staked.tokenId * totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
        }  
        // update vault
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: staked.tokenId,
            timestamp: block.timestamp, // update timestamp to current time
            owner: account
        });
        // transfer reward tokens to user
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            pool.rewardTokenAmount -= earned;
        }
        if (_unstake) {
            // unstake tokens if user wants to unstake
            _unstakeToken(_poolId, account, _amount);
        }
        emit RewardClaimed(account, _poolId, earned);
    }
// Function for users to unstake tokens
    function unstakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, true);
    }
// Function for users to claim reward tokens
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
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from unstaking after the pool is set inactive
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );
        // update total staked tokens in the pool
        pool.totalStaked -= tokenIds.length;
        // update user's staked balance
        stakedBalances[account][_poolId]-= tokenIds.length;
        
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");
            
            delete vaults[pool.stakingAddress][tokenId];
            emit NFTUnstaked(account, _poolId, tokenId);

            // Transfer staking tokens back to the user
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
            if (pool.isSharedPool) {
                // reward tokens distributed based on bonus percentage and amount staked
                earned = earned + (pool.bonusPercentage * (block.timestamp - staked.timestamp)/ 1 days );
                earned = earned / 100;
            } else {
                // reward tokens distributed based on total reward tokens and amount staked
                uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount /
                    (pool.endDate - pool.startDate);
                earned = earned + (totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
            }
            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp, // update timestamp to current time
                owner: account
            });
        }
        uint256 penaltyFee = 0;
        uint256 unstakingFee = 0;
        if (_unstake) {
            // calculate penalty
            if (pool.endDate < block.timestamp) {
                penaltyFee = (earned * pool.penaltyPercentage) / 100;
            }
            // calculate unstaking fee
            unstakingFee = (earned * unstakingFeePercentageNominator) / unstakingFeePercentageDominator;
        }
        // calculate net earned amount
        earned = earned - penaltyFee - unstakingFee;
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            pool.rewardTokenAmount -= earned;
            // update token withdraw balance
            tokenWithdrawBalances[address(pool.rewardToken)] += penaltyFee + unstakingFee;
      
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
        if (pool.isNFT == false) return earned;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            if (pool.isSharedPool) {
                earned = earned + (pool.bonusPercentage * (block.timestamp - staked.timestamp) / 1 days);
                earned = earned / 100;
            } else {
                uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount / (pool.endDate - pool.startDate);
                earned = earned + (totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
            }
        }
        return earned;
    }

    function earningInfoToken(
        uint256 _poolId,
        address account
    ) external view returns (uint256) {
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isNFT == true) return earned;

        Stake memory staked = vaults[account][_poolId];
        if (pool.isSharedPool) {
            earned = (staked.tokenId * pool.bonusPercentage * (block.timestamp - staked.timestamp) / 1 days);
            earned = earned / 100;
        } else {
            uint256 totalPoolRewardPerPeriod = pool.rewardTokenAmount / (pool.endDate - pool.startDate);
            earned = (staked.tokenId * totalPoolRewardPerPeriod * (block.timestamp - staked.timestamp)/ 1 days);
        }
        return earned;
    }

    function setPoolInactive(
        uint256 _poolId,
        bool status
    ) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(
            pool.creator == msg.sender,
            "Only creator can change pool status"
        );
        require(pool.isActive != status, "Pool is already in the same state");
        pool.isActive = status;
        emit PoolStatusChanged(_poolId, status);
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
        uint256 amount = tokenWithdrawBalances[token];
        require(amount > 0, "No token to withdraw");
        IERC20(token).transfer(msg.sender, amount);
        tokenWithdrawBalances[token] = 0;
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
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector ^ this.stakeNFT.selector;
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
