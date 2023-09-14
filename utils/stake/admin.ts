import { StakingContractABI } from "@/consts/ABI/StakingContractABI";
import { writeContract, waitForTransaction, readContract, prepareWriteContract } from "wagmi/actions"
import { Address } from "viem";
import { bscTestnet } from "viem/chains";
import { stakeTokenAddress } from "@/consts/contractAddresses";
export const withdraw = async (token: Address) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "withdraw",
            chainId: bscTestnet.id,
            args: [token]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const withdrawRewardToken = async () => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "withdrawRewardToken",
            chainId: bscTestnet.id
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
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
            chainId: bscTestnet.id,
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
export const pauseStake = async () => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "pause",
            chainId: bscTestnet.id
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const unpauseStake = async () => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "unpause",
            chainId: bscTestnet.id
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const transferOwnership = async (newOwner: Address) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "transferOwnership",
            chainId: bscTestnet.id,
            args: [newOwner]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
