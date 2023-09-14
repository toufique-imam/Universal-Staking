import { Address } from "viem";

export interface StakingPool {
    stakingToken: Address;
    stakingTokenDecimals: number;
    totalRewards: bigint;
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
}