import { Address } from "viem";
/*
    struct StakingPool {
        address stakingAddress;
        IERC20 rewardToken;
        uint256 stakingTokenDecimals;
        uint256 rewardTokenDecimals;
        uint256 rewardTokenAmount;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint256 maxStakePerWallet;
        uint256 maxTotalStake;
        bool isActive;
        PoolType poolType;
        bool isSharedPool;
        uint256 penaltyPercentageNumerator;
        uint256 penaltyPercentageDenominator;
        uint256 bonusPercentageNumerator;
        uint256 bonusPercentageDenominator;
        uint256 poolPeriod;
    }
    */
export interface StakingPool {
    stakingAddress: Address;
    rewardToken: Address;
    stakingTokenDecimals: bigint;
    rewardTokenDecimals: bigint;
    rewardTokenAmount: bigint;
    totalStaked: bigint;
    startDate: bigint;
    endDate: bigint;
    creator: Address;
    maxStakePerWallet: bigint;
    maxTotalStake: bigint;
    isActive: boolean;
    poolType: PoolType;
    isSharedPool: boolean;
    bonusPercentageNumerator: bigint;
    bonusPercentageDenominator: bigint;
    penaltyPercentageNumerator: bigint;
    penaltyPercentageDenominator: bigint; 
    poolPeriod: bigint;
}
export enum PoolType {
    TOKEN,
    NFT,
    COIN
}