// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is Ownable, Pausable, ReentrancyGuard {
    // Structure to represent staking pools
    struct StakingPool {
        address stakingToken;
        uint8 stakingTokenDecimals;
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
        // uint256 rewardPerTokenStored;
        // uint256 lastUpdateTime;
    }
    IERC20 rewardToken;

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;
    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

    // Mapping to track user unstaked balances
    mapping(address => mapping(uint256 => uint256)) public unstakedBalances;

    event PoolCreated(uint256 poolId);
    event Staked(address indexed user, uint256 indexed poolId, uint256 amount);
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
    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
    }

    // Function to create a staking pool
    function createStakingPool(
        address _stakingToken,
        uint8 _stakingTokenDecimals,
        uint256 _bonusPercentage,
        uint256 _startDate,
        uint256 _endDate,
        uint8 _stakingFeePercentage,
        uint8 _unstakingFeePercentage,
        uint8 _maxStakingFeePercentage,
        uint256 _maxStakePerWallet,
        uint256 _penaltyPercentage
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
            _stakingToken,
            _stakingTokenDecimals,
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
            _penaltyPercentage
        );
        // isActivePool[poolId] = true;
        poolCount++;

        emit PoolCreated(poolId);
    }

    // Function for users to stake tokens
    function stake(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        // Check if the pool is active
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.isActive, "This pool is not active");

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
            IERC20(pool.stakingToken).allowance(msg.sender, address(this)) >=
                _amount,
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        IERC20(pool.stakingToken).transferFrom(
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
        IERC20(pool.stakingToken).transfer(msg.sender, netUnstakedAmount);

        //calculate rewards based on amount of time the user staked and amount staked
        uint256 timeStaked = (pool.endDate - pool.startDate);
        if (pool.endDate > block.timestamp)
            timeStaked = block.timestamp - pool.startDate;

        uint256 timeStakedInDays = timeStaked / 86400;
        uint256 reward = (timeStakedInDays * netUnstakedAmount * pool.bonusPercentage) /
            100;

        // Transfer rewards to the user
        rewardToken.transfer(msg.sender, reward);

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
    function withdrawRewardToken() external onlyOwner whenPaused {
        rewardToken.transfer(
            msg.sender,
            rewardToken.balanceOf(address(this))
        );
    }
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }
}
