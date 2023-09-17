// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is Ownable, Pausable, ReentrancyGuard {
    // Structure to represent staking pools
    struct StakingPool {
        address stakingAddress;
        address rewardTokenAddress;
        uint256 rewardTokenAmount;
        uint256 totalRewards;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint8 stakingFeePercentage;
        uint8 unstakingFeePercentage;
        uint8 maxStakingFeePercentage;
        uint256 bonusPercentage;
        uint256 maxStakePerWallet;
        bool isActive;
        uint256 penaltyPercentage;
        bool isNFT;
    }
    struct Stake {
        uint256 poolId;
        uint24 tokenId;
        uint48 timestamp;
        address owner;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;
    
    //mapping nft token id to stake
    mapping(address => mapping(uint256 => Stake)) public vaults;

    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

    // Mapping to track user unstaked balances
    mapping(address => mapping(uint256 => uint256)) public unstakedBalances;

    event PoolCreated(uint256 poolId);
    event Staked(address indexed user, uint256 indexed poolId, uint256 amount);
    
    event NFTStaked(address owner, uint256 indexed poolId, uint256[] tokenIds, uint256 value);
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
    constructor() {}

    // Function to create a staking pool
    function createStakingPool(
        address _stakingAddress,
        address _rewardTokenAddress,
        uint256 _bonusPercentage,
        uint256 _startDate,
        uint256 _endDate,
        uint8 _stakingFeePercentage,
        uint8 _unstakingFeePercentage,
        uint8 _maxStakingFeePercentage,
        uint256 _maxStakePerWallet,
        uint256 _penaltyPercentage,
        bool isNFT
    ) external whenNotPaused nonReentrant {
        require(_stakingFeePercentage <= 1, "Staking fee cannot exceed 1%");
        require(
            _unstakingFeePercentage <= 100,
            "Unstaking fee cannot exceed 100%"
        );
        require(
            _maxStakingFeePercentage <= 1,
            "Max staking fee cannot exceed 1%"
        );

        uint256 poolId = poolCount;
        stakingPools[poolId] = StakingPool(
            _stakingAddress,
            _rewardTokenAddress,
            0,
            0,
            _startDate,
            _endDate,
            msg.sender,
            _stakingFeePercentage,
            _unstakingFeePercentage,
            _maxStakingFeePercentage,
            _bonusPercentage,
            _maxStakePerWallet,
            true,
            _penaltyPercentage,
            isNFT
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
            IERC20(pool.rewardTokenAddress).allowance(
                msg.sender,
                address(this)
            ) >= amount,
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        IERC20(pool.rewardTokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );
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

        // Transfer staking tokens from the user to the contract

        IERC20(pool.stakingAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Calculate staking fee
        uint256 stakingFee = (_amount * pool.stakingFeePercentage) / 100;

        // Calculate net staked amount
        uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] += netStakedAmount;

        // Update total staked tokens in the pool
        pool.totalRewards += netStakedAmount;

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

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + tokenIds.length <=
                pool.maxStakePerWallet,
            "Exceeded maximum stake limit"
        );
        
        IERC721 nft = IERC721(pool.stakingAddress);
        // Make sure to approve the contract to spend the tokens beforehand
        require(
           nft.isApprovedForAll(
                msg.sender,
                address(this)
            ),
            "not approved"
        );
        
        uint256 tokenId;
        pool.totalRewards += tokenIds.length;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            require(nft.ownerOf(tokenId) == msg.sender, "not your token");
            require(vaults[pool.stakingAddress][tokenId].tokenId == 0, "already staked");

            nft.transferFrom(msg.sender, address(this), tokenId);
            emit NFTStaked(msg.sender, _poolId, tokenId, block.timestamp);

            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: uint24(tokenId),
                timestamp: uint48(block.timestamp),
                owner: msg.sender
            });
            stakedBalances[msg.sender][_poolId]++;

            // totalUserStakes[msg.sender]++;
        }
        // Transfer staking tokens from the user to the contract
        // IERC721(pool.stakingAddress).safeTransferFrom(
        //     msg.sender,
        //     address(this),
        //     _amount
        // );


        // Calculate staking fee
        // uint256 stakingFee = (_amount * pool.stakingFeePercentage) / 100;

        // Calculate net staked amount
        // uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        // stakedBalances[msg.sender][_poolId] += netStakedAmount;

        // Update total staked tokens in the pool
        pool.totalRewards += tokenIds.length;

        // Emit stake event
        emit NFTStaked(msg.sender, _poolId, tokenIds, value);
    }

    // Function for users to unstake tokens
    function unstake(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];

        // Check if the pool is active
        require(pool.isActive, "This pool is not active");

        // Check if the user has enough staked tokens
        require(
            stakedBalances[msg.sender][_poolId] >= _amount,
            "Insufficient staked balance"
        );

        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );

        // Calculate unstaking fee
        uint256 unstakingFee = (_amount * pool.unstakingFeePercentage) / 100;

        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < pool.endDate) {
            penalty = (_amount * pool.penaltyPercentage) / 100;
        }

        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;

        // Transfer staking tokens back to the user
        IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);

        //calculate rewards based on amount of time the user staked and amount staked
        uint256 timeStaked = (pool.endDate - pool.startDate);
        if (pool.endDate > block.timestamp)
            timeStaked = block.timestamp - pool.startDate;

        uint256 timeStakedInDays = timeStaked / 86400;
        uint256 reward = (timeStakedInDays *
            netUnstakedAmount *
            pool.bonusPercentage) / 100;

        // Transfer rewards to the user
        IERC20(pool.rewardTokenAddress).transfer(msg.sender, reward);

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] -= _amount;

        // Update total staked tokens in the pool
        pool.totalRewards -= _amount;

        // Emit unstake event
        emit Unstaked(msg.sender, _poolId, _amount, penalty);
    }

    /** @dev Basis of how long it's been during the most recent snapshot/block */
    // function rewardPerToken(uint256 _poolId) public view returns (uint256) {
    //     StakingPool memory pool = stakingPools[_poolId];
    //     if (pool.totalRewards == 0) {
    //         return 0;
    //     } else {
    //         return
    //             pool.rewardPerTokenStored +
    //             (((block.timestamp - pool.endDate) *
    //                 pool.bonusPercentage *
    //                 1e18) / pool.totalRewards);
    //     }
    // }

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

    // Function to set a pool as inactive (emergency shutdown)
    function setPoolInactive(uint256 _poolId, bool status) external onlyOwner {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive != status, "Pool is already in the same state");
        pool.isActive = status;
    }

    function withdraw(address token) external onlyOwner whenPaused {
        IERC20(token).transfer(
            msg.sender,
            IERC20(token).balanceOf(address(this))
        );
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
