import { StakingContractABI } from "@/consts/ABI/StakingContractABI";
import { writeContract, waitForTransaction, readContract, prepareWriteContract } from "wagmi/actions"
import { Address, zeroAddress } from "viem";
import { stakeTokenAddress } from "@/consts/contractAddresses";
import { StakingPool } from "../types";
import { chains } from "../wagmi";

export const createStakingPool = async (stakingToken: Address, rewardToken: Address,
    bonusPercentage: bigint,
    startDate: bigint, endDate: bigint,
    stakingFeePercentage: number, unstakingFeePercentage: number, maxStakingFeePercentage: number,
    maxStakePerWallet: bigint, penaltyPercentage: bigint,
    isNFT: boolean
) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "createStakingPool",
            chainId: chains[0].id,
            args: [stakingToken, rewardToken, bonusPercentage, startDate, endDate, stakingFeePercentage, unstakingFeePercentage,
                maxStakingFeePercentage, maxStakePerWallet, penaltyPercentage, isNFT]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const stakeNFT = async (poolId: bigint, tokenIds: [bigint]) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "stakeNFT",
            chainId: chains[0].id,
            args: [poolId, tokenIds]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const stakeToken = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "stakeToken",
            chainId: chains[0].id,
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
export const unstakeToken = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "unstakeToken",
            chainId: chains[0].id,
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

export const unstakeNFT = async (poolId: bigint, tokenIds: [bigint]) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "unstakeNFT",
            chainId: chains[0].id,
            args: [poolId, tokenIds]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const claimToken = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "claimToken",
            chainId: chains[0].id,
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

export const claimNFT = async (poolId: bigint, tokenIds: [bigint]) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "claimNFT",
            chainId: chains[0].id,
            args: [poolId, tokenIds]
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
            chainId: chains[0].id,
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
            chainId: chains[0].id,
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
            chainId: chains[0].id,
            args: [poolId]
        })
        return result as StakingPool;
    } catch (e) {
        console.error(e)
        return {
            stakingAddress: zeroAddress,
            rewardToken: zeroAddress,
            rewardTokenAmount: BigInt(0),
            totalStaked: BigInt(0),
            startDate: BigInt(0),
            endDate: BigInt(0),
            creator: zeroAddress,
            stakingFeePercentage: 0,
            unstakingFeePercentage: 0,
            maxStakingFeePercentage: 0,
            bonusPercentage: BigInt(0),
            maxStakePerWallet: BigInt(0),
            isActive: false,
            penaltyPercentage: BigInt(0),
            isNFT: false
        } as StakingPool;
    }
}
export const 