// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
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
        uint256 stakingFee;
        uint8 unstakingFeePercentage;
        uint256 bonusPercentage;
        uint256 maxStakePerWallet;
        bool isActive;
        uint256 penaltyPercentage;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;
    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedNFTs;

    // Mapping to track user rewards
    mapping(address => mapping(uint256 => uint256)) public rewards;

    // Mapping to track user unstaked balances
    mapping(address => mapping(uint256 => uint256)) public unstakedBalances;

    event PoolCreated(uint256 poolId);
    event Staked(address indexed user, uint256 indexed poolId, uint256 tokenID);
    event Unstaked(
        address indexed user,
        uint256 indexed poolId,
        uint256 tokenID,
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
        uint256 _startDate,
        uint256 _endDate,
        uint256 _stakingFee,
        uint8 _unstakingFeePercentage,
        uint256 _bonusPercentage,
        uint256 _maxStakePerWallet
    ) external onlyOwner {
        // Check if the staking address is a contract
        require(
            Address.isContract(_stakingAddress),
            "Staking address should be a contract"
        );

        // Check if the reward token address is a contract
        require(
            Address.isContract(_rewardTokenAddress),
            "Reward token address should be a contract"
        );

        // Check if the staking fee is valid
        require(
            _stakingFee >= 0 && _stakingFee <= 100,
            "Staking fee should be between 0 and 100"
        );

        // Check if the unstaking fee is valid
        require(
            _unstakingFeePercentage >= 0 && _unstakingFeePercentage <= 100,
            "Unstaking fee should be between 0 and 100"
        );

        // Check if the bonus percentage is valid
        require(
            _bonusPercentage >= 0 && _bonusPercentage <= 100,
            "Bonus percentage should be between 0 and 100"
        );

        // Check if the maximum stake per wallet is valid
        require(
            _maxStakePerWallet > 0,
            "Maximum stake per wallet should be greater than 0"
        );

        // Check if the staking period is valid
        require(
            _startDate < _endDate,
            "Staking period should be greater than 0"
        );
        poolCount++;
        stakingPools[poolCount] = StakingPool(
            _stakingAddress,
            _rewardTokenAddress,
            0,
            0,
            _startDate,
            _endDate,
            msg.sender,
            _stakingFee,
            _unstakingFeePercentage,
            _bonusPercentage,
            _maxStakePerWallet,
            true,
            0
        );
        emit PoolCreated(poolCount);
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
    function stake(
        uint256 _poolId,
        uint256 _tokenID
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
        //check reward token amount
        require(pool.rewardTokenAmount > 0, "No rewards left");
        // Check if the user has enough staked tokens
        require(
            stakedNFTs[msg.sender][_poolId] < pool.maxStakePerWallet,
            "You have already staked the maximum amount"
        );
        require(
            IERC721(pool.stakingAddress).getApproved(_tokenID) == address(this),
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        IERC721(pool.stakingAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenID
        );
        // Update user's staked balance
        stakedNFTs[msg.sender][_poolId] += 1;
        // Update total staked tokens in the pool
        pool.totalRewards += 1;
        // Emit stake event
        emit Staked(msg.sender, _poolId, _tokenID);
    }

    // Function for users to unstake tokens
    function unstake(
        uint256 _poolId,
        uint256 _tokenID
    ) external whenNotPaused nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];

        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        //check reward token amount
        require(pool.rewardTokenAmount > 0, "No rewards left");


        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );

        // Calculate unstaking fee

        // // Calculate penalty for early unstaking
        // uint256 penalty = 0;
        // if (block.timestamp < pool.endDate) {
        //     penalty = (_amount * pool.penaltyPercentage) / 100;
        // }

        // // Calculate net unstaked amount
        // uint256 netUnstakedAmount = _amount - unstakingFee - penalty;

        // // Transfer staking tokens back to the user
        // IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);

        // //calculate rewards based on amount of time the user staked and amount staked
        // uint256 timeStaked = (pool.endDate - pool.startDate);
        // if (pool.endDate > block.timestamp)
        //     timeStaked = block.timestamp - pool.startDate;

        // uint256 timeStakedInDays = timeStaked / 86400;
        // uint256 reward = (timeStakedInDays *
        //     netUnstakedAmount *
        //     pool.bonusPercentage) / 100;

        // // Transfer rewards to the user
        // IERC20(pool.rewardTokenAddress).transfer(msg.sender, reward);

        // // Update user's staked balance
        // stakedBalances[msg.sender][_poolId] -= _amount;

        // // Update total staked tokens in the pool
        // pool.totalRewards -= _amount;

        // // Emit unstake event
        // emit Unstaked(msg.sender, _poolId, _amount, penalty);
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
