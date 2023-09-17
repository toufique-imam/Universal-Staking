// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";

contract NFTStaking is Ownable, IERC721Receiver {
    uint256 public totalStaked;

    struct StakePool {
        uint256 poolID;
        IERC20 token;
        IERC721 nft;
        address creator;
        bool isActive;
        uint256 startDate;
        uint256 endDate;
        uint256 rewardPerDay;
        uint256 stakingFee;
        uint256 unstakingFee;
        uint256 maxStakePerWallet;
        uint256 penaltyPercentage;
        uint256 totalRewardBalance;
    }
    // struct to store a stake's token, owner, and earning values
    struct Stake {
        uint256 poolId;
        uint24 tokenId;
        uint48 timestamp;
        address owner;
    }

    event PoolCreated(address creator, uint256 poolId);
    event NFTStaked(address owner, uint256 tokenId, uint256 value);
    event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
    event Claimed(address owner, uint256 amount);
    
    mapping (address => uint256) public totalUserStakes;
    // maps tokenId to stake
    mapping(uint256 => Stake) public vault;
    // maps poolId to stake pool
    mapping(uint256 => StakePool) public pools;
    uint256 public poolCount;

    constructor() {}

    function createStakingPool(
        address _token,
        address _nft,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _rewardPerDay,
        uint256 _stakingFee,
        uint256 _unstakingFee,
        uint256 _maxStakePerWallet,
        uint256 _penaltyPercentage
    ) external onlyOwner {
        require(_endDate > _startDate, "end date must be after start date");
        require(_endDate > block.timestamp, "end date must be in the future");
        require(_stakingFee < 100, "staking fee must be less than 100%");
        require(_unstakingFee < 100, "unstaking fee must be less than 100%");
        require(
            _penaltyPercentage < 100,
            "penalty percentage must be less than 100%"
        );
        require(
            _maxStakePerWallet > 0,
            "max stake per wallet must be greater than 0"
        );
        require(
            _rewardPerDay > 0,
            "reward per day must be greater than 0"
        );
        require(
            _endDate - _startDate <= 365 days,
            "staking period must be less than or equal to 365 days"
        );
        require(
            _endDate - _startDate >= 1 days,
            "staking period must be greater than or equal to 1 day"
        );
        poolCount++;
        uint256 poolId = poolCount;
        pools[poolId] = StakePool({
            poolID: poolId,
            token: IERC20(_token),
            nft: IERC721(_nft),
            creator: msg.sender,
            isActive: true,
            startDate: _startDate,
            endDate: _endDate,
            rewardPerDay: _rewardPerDay,
            stakingFee: _stakingFee,
            unstakingFee: _unstakingFee,
            maxStakePerWallet: _maxStakePerWallet,
            penaltyPercentage: _penaltyPercentage,
            totalRewardBalance: 0
        });

        emit PoolCreated(msg.sender, poolId);
    }
    function receiveToken(uint256 _poolId, uint256 amount) public {
        StakePool storage pool = pools[_poolId];
        require(pool.isActive, "This pool is not active");
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        pool.token.transferFrom(msg.sender, address(this), amount);
        pool.totalRewardBalance += amount;
    }

    function stake(uint256 _stakePoolId, uint256[] calldata tokenIds) external {
        StakePool memory pool = pools[_stakePoolId];
        //check 
        require(pool.isActive, "This pool is not active");
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        require(
            totalUserStakes[msg.sender] + tokenIds.length <= pool.maxStakePerWallet,
            "exceeds max stake per wallet"
        );
        require(
            pool.nft.isApprovedForAll(msg.sender, address(this)),
            "not approved"
        );
        require(
            pool.nft.balanceOf(msg.sender) >= tokenIds.length,
            "not enough tokens"
        );
        uint256 tokenId;
        totalStaked += tokenIds.length;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            require(pool.nft.ownerOf(tokenId) == msg.sender, "not your token");
            require(vault[tokenId].tokenId == 0, "already staked");

            pool.nft.transferFrom(msg.sender, address(this), tokenId);
            emit NFTStaked(msg.sender, tokenId, block.timestamp);

            vault[tokenId] = Stake({
                poolId: _stakePoolId,
                owner: msg.sender,
                tokenId: uint24(tokenId),
                timestamp: uint48(block.timestamp)
            });
            totalUserStakes[msg.sender]++;
        }
    }

    function _unstakeMany(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds
    ) internal {
        uint256 tokenId;
        StakePool memory pool = pools[_poolId];
        // check 
        require(pool.isActive, "This pool is not active");
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "Staking period is not valid"
        );
        totalStaked -= tokenIds.length;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == msg.sender, "not an owner");
            totalUserStakes[msg.sender]--;
            delete vault[tokenId];
            emit NFTUnstaked(account, tokenId, block.timestamp);
            pool.nft.safeTransferFrom(address(this), account, tokenId);
        }
    }

    function claim(uint256 poolId, uint256[] calldata tokenIds) external {
        _claim(poolId, msg.sender, tokenIds, false);
    }

    function claimForAddress(
        uint256 poolId,
        address account,
        uint256[] calldata tokenIds
    ) external {
        _claim(poolId, account, tokenIds, false);
    }

    function unstake(uint256 poolId, uint256[] calldata tokenIds) external {
        _claim(poolId, msg.sender, tokenIds, true);
    }

    function _claim(
        uint256 poolId,
        address account,
        uint256[] calldata tokenIds,
        bool _unstake
    ) internal {
        StakePool memory pool = pools[poolId];
        uint256 tokenId;
        uint256 earned = 0;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == account, "not an owner");
            uint256 stakedAt = staked.timestamp;
            earned =
                earned +
                (pool.rewardPerDay * (block.timestamp - stakedAt)) /
                1 days;
            vault[tokenId] = Stake({
                poolId: poolId,
                owner: account,
                tokenId: uint24(tokenId),
                timestamp: uint48(block.timestamp)
            });
        }
        // check penalty
        if (earned > 0 && pool.endDate < block.timestamp) {
            earned = (earned * (100 - pool.penaltyPercentage)) / 100;
        }
        //unstake fee
        if (earned > 0 && _unstake) {
            earned = (earned * (100 - pool.unstakingFee)) / 100;
        }
        if (earned > 0) {
            earned = earned / 10;
            pool.token.transfer(account, earned);
        }
        if (_unstake) {
            _unstakeMany(poolId, account, tokenIds);
        }
        emit Claimed(account, earned);
    }

    function earningInfo(
        uint256[] calldata tokenIds
    ) external view returns (uint256 info) {
        uint256 tokenId;
        // uint256 totalScore = 0;
        uint256 earned = 0;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            uint256 stakedAt = staked.timestamp;
            earned += (pools[staked.poolId].rewardPerDay * (block.timestamp - stakedAt)) / 1 days;
        }
        return earned;
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
}
