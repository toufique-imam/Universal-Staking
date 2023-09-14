import { StakingContractABI } from "@/consts/ABI/StakingContractABI";
import { writeContract, waitForTransaction, readContract, prepareWriteContract } from "wagmi/actions"
import { Address, zeroAddress } from "viem";
import { bscTestnet } from "viem/chains";
import { stakeTokenAddress } from "@/consts/contractAddresses";
import { StakingPool } from "../types";

export const createStakingPool = async (stakingToken: Address, stakingTokenDecimals: number, bonusPercentage: bigint, startDate: bigint, endDate: bigint, stakingFeePercentage: number, unstakingFeePercentage: number, maxStakingFeePercentage: number, maxStakePerWallet: bigint, penaltyPercentage: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "createStakingPool",
            chainId: bscTestnet.id,
            args: [stakingToken, stakingTokenDecimals, bonusPercentage, startDate, endDate, stakingFeePercentage, unstakingFeePercentage, maxStakingFeePercentage, maxStakePerWallet, penaltyPercentage]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const stake = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "stake",
            chainId: bscTestnet.id,
            args: [poolId, amount]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const unstake = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "unstake",
            chainId: bscTestnet.id,
            args: [poolId, amount]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
//read functions

export const poolExists = async (poolId: bigint) => {
    try {
        const result = await readContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "poolExists",
            chainId: bscTestnet.id,
            args: [poolId]
        })
        return result;
    } catch (e) {
        console.error(e)
        return false;
    }
}
export const poolIsActive = async (poolId: bigint) => {
    try {
        const result = await readContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "poolIsActive",
            chainId: bscTestnet.id,
            args: [poolId]
        })
        return result;
    } catch (e) {
        console.error(e)
        return false;
    }
}
export const getPoolInfo = async (poolId: bigint) => {
    try {
        const result = await readContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "getPoolInfo",
            chainId: bscTestnet.id,
            args: [poolId]
        })
        return result as StakingPool;
    } catch (e) {
        console.error(e)
        return { 
            stakingToken: zeroAddress,
            stakingTokenDecimals: 0,
            totalRewards: 0n,
            startDate: 0n,
            endDate: 0n,
            creator: zeroAddress,
            stakingFeePercentage: 0,
            unstakingFeePercentage: 0,
            maxStakingFeePercentage: 0,
            bonusPercentage: 0n,
            maxStakePerWallet: 0n,
            isActive: false,
            penaltyPercentage: 0n
        } as StakingPool;
    }
}