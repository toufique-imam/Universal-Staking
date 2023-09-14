import { RewardTokenABI } from "@/consts/ABI/RewardTokenABI";
import { writeContract, waitForTransaction, readContract, prepareWriteContract } from "wagmi/actions"
import { Address } from "viem";
import { bscTestnet } from "viem/chains";
import { rewardTokenAddress } from "@/consts/contractAddresses";

export const mint = async (to: Address, amount: bigint) => {
    try {
        const { hash } = await writeContract({
            address: rewardTokenAddress,
            abi: RewardTokenABI,
            functionName: "mint",
            chainId: bscTestnet.id,
            args: [to, amount]
        })
        const allowanceTx = await waitForTransaction({ hash })
        console.log(allowanceTx)
        return 1;
    } catch (e) {
        console.error(e)
        return -1;
    }
}