import { Address } from "viem";

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
    isActive: boolean;
    isNFT: boolean;
    isSharedPool: boolean;
    bonusPercentageNumerator: bigint;
    bonusPercentageDenominator: bigint;
    penaltyPercentageNumerator: bigint;
    penaltyPercentageDenominator: bigint; 
    poolPeriod: bigint;
}