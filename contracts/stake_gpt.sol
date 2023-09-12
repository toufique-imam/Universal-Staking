// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
contract StakingContract is Ownable {
    // Structure to represent staking pools
    struct StakingPool {
        address stakingToken;
        uint8 stakingTokenDecimals;
        address rewardToken;
        uint8 rewardTokenDecimals;
        uint256 totalRewards;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint8 stakingFeePercentage;
        uint8 unstakingFeePercentage;
        uint8 maxStakingFeePercentage;
        uint256 maxStakePerWallet;
        bool isActive;
        uint256 penaltyPercentage;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;
    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

    // Mapping to track user unstaked balances
    mapping(address => mapping(uint256 => uint256)) public unstakedBalances;

    // Mapping to track active pools
    mapping(uint256 => bool) public isActivePool;
    event PoolCreated(uint256 poolId);
    event Staked(address indexed user, uint256 indexed poolId, uint256 amount);
    event Unstaked(address indexed user, uint256 indexed poolId, uint256 amount, uint256 penalty);
    event RewardClaimed(address indexed user, uint256 indexed poolId, uint256 amount);
    // Constructor to set the contract owner
    constructor() {
    }

    // Function to create a staking pool
    function createStakingPool(
        address _stakingToken,
        uint8 _stakingTokenDecimals,
        address _rewardToken,
        uint8 _rewardTokenDecimals,
        uint256 _totalRewards,
        uint256 _startDate,
        uint256 _endDate,
        uint8 _stakingFeePercentage,
        uint8 _unstakingFeePercentage,
        uint8 _maxStakingFeePercentage,
        uint256 _maxStakePerWallet,
        uint256 _penaltyPercentage
    ) external {
        require(_stakingFeePercentage <= 1, "Staking fee cannot exceed 1%");
        require(_unstakingFeePercentage <= 100, "Unstaking fee cannot exceed 100%");
        require(_maxStakingFeePercentage <= 1, "Max staking fee cannot exceed 1%");

        uint256 poolId = poolCount;
        stakingPools[poolId] = StakingPool(
            _stakingToken,
            _stakingTokenDecimals,
            _rewardToken,
            _rewardTokenDecimals,
            _totalRewards,
            _startDate,
            _endDate,
            msg.sender,
            _stakingFeePercentage,
            _unstakingFeePercentage,
            _maxStakingFeePercentage,
            _maxStakePerWallet,
            true,
            _penaltyPercentage
        );
        isActivePool[poolId] = true;
        poolCount++;

        emit PoolCreated(poolId);
    }

    // Function for users to stake tokens
    function stake(uint256 _poolId, uint256 _amount) external {
        // Check if the pool is active
        require(isActivePool[_poolId], "This pool is not active");

        // Check if the staking period is valid
        require(block.timestamp >= stakingPools[_poolId].startDate && block.timestamp <= stakingPools[_poolId].endDate, "Staking period is not valid");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(stakedBalances[msg.sender][_poolId] + _amount <= stakingPools[_poolId].maxStakePerWallet, "Exceeded maximum stake limit");

        // Transfer staking tokens from the user to the contract
        // Make sure to approve the contract to spend the tokens beforehand

        // Calculate staking fee
        uint256 stakingFee = (_amount * stakingPools[_poolId].stakingFeePercentage) / 100;

        // Calculate net staked amount
        uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] += netStakedAmount;

        // Update total staked tokens in the pool
        stakingPools[_poolId].totalRewards += netStakedAmount;

        // Emit stake event
        emit Staked(msg.sender, _poolId, _amount);
    }

    // Function for users to unstake tokens
    function unstake(uint256 _poolId, uint256 _amount) external {
        // Check if the pool is active
        require(isActivePool[_poolId], "This pool is not active");

        // Check if the user has enough staked tokens
        require(stakedBalances[msg.sender][_poolId] >= _amount, "Insufficient staked balance");

        // Check if the staking period is valid
        require(block.timestamp >= stakingPools[_poolId].startDate, "Unstaking is not allowed before the staking period starts");

        // Calculate unstaking fee
        uint256 unstakingFee = (_amount * stakingPools[_poolId].unstakingFeePercentage) / 100;

        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < stakingPools[_poolId].endDate) {
            penalty = (_amount * stakingPools[_poolId].penaltyPercentage) / 100;
        }

        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;

        // Transfer staking tokens back to the user
        // Transfer rewards to the user

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] -= _amount;

        // Update total staked tokens in the pool
        stakingPools[_poolId].totalRewards -= _amount;

        // Emit unstake event
        emit Unstaked(msg.sender, _poolId, _amount, penalty);
    }

    // Function to auto-claim rewards
    function autoClaimRewards(uint256 _poolId) external {
        // Auto-claim rewards logic here

        // Emit reward claimed event
        emit RewardClaimed(msg.sender, _poolId, amount);
    }

    // Function to check if a pool exists
    function poolExists(uint256 _poolId) external view returns (bool) {
        return _poolId < poolCount;
    }

    // Function to check if a pool is active
    function poolIsActive(uint256 _poolId) external view returns (bool) {
        return isActivePool[_poolId];
    }

    // Function to get pool information
    function getPoolInfo(uint256 _poolId)
        external
        view
        returns (
            address,
            uint8,
            address,
            uint8,
            uint256,
            uint256,
            uint256,
            address,
            uint8,
            uint8,
            uint8,
            uint256,
            bool
        )
    {
        StakingPool storage pool = stakingPools[_poolId];
        return (
            pool.stakingToken,
            pool.stakingTokenDecimals,
            pool.rewardToken,
            pool.rewardTokenDecimals,
            pool.totalRewards,
            pool.startDate,
            pool.endDate,
            pool.creator,
            pool.stakingFeePercentage,
            pool.unstakingFeePercentage,
            pool.maxStakingFeePercentage,
            pool.maxStakePerWallet,
            pool.isActive
        );
    }

    // Function to set a pool as inactive (emergency shutdown)
    function setPoolInactive(uint256 _poolId) external onlyOwner {
        isActivePool[_poolId] = false;
    }
}
