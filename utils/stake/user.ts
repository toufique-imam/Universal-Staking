import { StakingContractABI } from "@/consts/ABI/StakingContractABI";
import { writeContract, waitForTransaction, readContract, prepareWriteContract } from "wagmi/actions"
import { Address, zeroAddress } from "viem";
import { stakeTokenAddress } from "@/consts/contractAddresses";
import { StakingPool } from "../types";
import { chains } from "../wagmi";
import { erc20ABI, erc721ABI } from "wagmi";

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
export const stakeNFT = async (poolId: bigint, tokenIds: Array<bigint>) => {
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

export const unstakeNFT = async (poolId: bigint, tokenIds: Array<bigint>) => {
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

export const claimNFT = async (poolId: bigint, tokenIds: Array<bigint>) => {
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
export const getEarningInfoNFT = async (poolId: bigint, tokenIds: [bigint]) => {
    try {
        const result = await readContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "earningInfoNFT",
            chainId: chains[0].id,
            args: [poolId, tokenIds]
        })
        return result;
    } catch (e) {
        console.error(e)
        return 0n;
    }
}

export const getEarningInfoToken = async (poolId: bigint, account: Address) => {
    try {
        const result = await readContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "earningInfoToken",
            chainId: chains[0].id,
            args: [poolId, account]
        })
        return result;
    } catch (e) {
        console.error(e)
        return 0n;
    }
}

export const withdraw = async (poolId: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "withdrawStake",
            chainId: chains[0].id,
            args: [poolId]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const setPoolInactive = async (poolId: bigint, status: boolean) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "setPoolInactive",
            chainId: chains[0].id,
            args: [poolId, status]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const updateTokenAllowance = async (poolId: bigint, amount: bigint) => {
    try {
        const data = await getPoolInfo(poolId)
        if(data.isNFT) return -1;
        await updateTokenAllowanceByAddress(data.rewardToken, amount)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const updateTokenAllowanceByAddress = async (tokenAddress: Address, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: tokenAddress,
            abi: erc20ABI,
            functionName: "approve",
            chainId: chains[0].id,
            args: [stakeTokenAddress, amount]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const receiveToken = async (poolId: bigint, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "receiveToken",
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

export const updateStakeNFTAllowance = async (poolId: bigint) => {
    try {
        const data = await getPoolInfo(poolId)
        if(!data.isNFT) return -1;
        const { hash } = await writeContract({
            address: data.stakingAddress,
            abi: erc721ABI,
            functionName: "setApprovalForAll",
            chainId: chains[0].id,
            args: [stakeTokenAddress, true]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const updateStakeTokenAllowance = async (poolId: bigint, amount: bigint) => {
    try {
        const data = await getPoolInfo(poolId)
        if(!data.isNFT) return -1;
        await updateTokenAllowanceByAddress(data.stakingAddress, amount)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const getTokenAllowanceByPoolId = async (account: Address, poolId: bigint) => {
    try {
        const data = await getPoolInfo(poolId)
        if(data.isNFT) return -1;
        const result = await readContract({
            address: data.stakingAddress,
            abi: erc20ABI,
            functionName: "allowance",
            chainId: chains[0].id,
            args: [account, stakeTokenAddress]
        })
        return result;
    } catch (e) {
        console.error(e)
        return 0n;
    }
}
export const getNFTAllowanceByPoolId = async (account: Address, poolId: bigint) => {
    try {
        const data = await getPoolInfo(poolId)
        if (!data.isNFT) return -1;
        const result = await readContract({
            address: data.stakingAddress,
            abi: erc721ABI,
            functionName: "isApprovedForAll",
            chainId: chains[0].id,
            args: [account, stakeTokenAddress]
        })
        return result;
    } catch (e) {
        console.error(e)
        return false;
    }
}