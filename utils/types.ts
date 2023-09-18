import { Address } from "viem";

export interface StakingPool {
    stakingAddress: Address;
    rewardToken: Address;
    rewardTokenAmount: bigint;
    totalStaked: bigint;
    startDate: bigint;
    endDate: bigint;
    creator: Address;
    stakingFeePercentage: number;
    unstakingFeePercentage: number;
    maxStakingFeePercentage: number;
    bonusPercentage: bigint;
    maxStakePerWallet: bigint;
    isActive: boolean;
    penaltyPercentage: bigint;
    isNFT: boolean;
}