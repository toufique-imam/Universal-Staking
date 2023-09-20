import { StakingContractABI } from "@/consts/ABI/StakingContractABI";
import { writeContract, waitForTransaction } from "wagmi/actions"
import { Address } from "viem";
import { stakeTokenAddress } from "@/consts/contractAddresses";
import { chains } from "../wagmi";

export const withdrawToken = async (token: Address) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "withdrawToken",
            chainId: chains[0].id,
            args: [token]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}

export const withdraw = async () => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "withdraw",
            chainId: chains[0].id,
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
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
            chainId: chains[0].id
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
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
            chainId: chains[0].id
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
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
            chainId: chains[0].id,
            args: [newOwner]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const setPoolCreationFee = async (fee: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "setPoolCreationFee",
            chainId: chains[0].id,
            args: [fee]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}
export const setUnstakingFeePercentage = async (numerator: bigint, denominator: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "setUnstakingFeePercentage",
            chainId: chains[0].id,
            args: [numerator, denominator]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
} 
export const setStakingFeePercentage = async (numerator: bigint, denominator: bigint) => {
    try {
        const { hash } = await writeContract({
            address: stakeTokenAddress,
            abi: StakingContractABI,
            functionName: "setStakingFeePercentage",
            chainId: chains[0].id,
            args: [numerator, denominator]
        })
        const tx = await waitForTransaction({ hash })
        console.log(tx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}