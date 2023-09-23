1. Rename the token to "DepositRewardToken" instead of receivetokens.
2. Change the error message when attempting to stake when the pool is inactive from "Staking period is not valid" to:
"The pool isn't active yet."
2B. Modify "Exceeded maximum stake limit" to:
"Maximum Stake Limit exceeded."
3. Rename "SetPoolInactive" to "SetPoolisActive."
4. Combine the "pause" and "unpause" write functions into one function, with a boolean parameter to define the isPausedStatus.
5. Eliminate the possibility to claim rewards if the reward balance is 0.
6. Remove the restriction that prevents the creator from staking.
7. Allow the owner to claim fees even if the contract is not paused.
8. Rename "Staking period is not valid" to:
"Staking Ended, cannot stake."
9. Eliminate the bug that allows farming if staking has ended (both token and nft), as long as the pool is still active.
10. How can the creator remove the extra deposited tokens as rewards? Currently, it doesn't seem to be working: (https://testnet.bscscan.com/tx/0x7771713f219019616e5a62437de70783935a8964985249e51ac7553dba122a91).
___
11. Fix:
You may need to deactivate the pool.
Why isn't it automatically deactivated when the end time is reached?

Or what's the scope of the end time?

Well, it was added earlier to stop staking before the end time in case of an emergency shutdown, as you mentioned. If you want, I can adjust the condition.

12. Allow the ability to set a penalty of 0 as well.
13. Enable to set the coin's chain as reward and or stake token
14.nft staking: Error: Internal JSON-RPC error. unable to call the read contract get nft staked rewards (function2) when the pool ends, but this read functions must be always reacheable.
15:nft staking rewards can't be claimed after pool is ended, why? https://testnet.bscscan.com/tx/0x9c0067a852d8cd2924dbaf04d11ffaaa41e22b93716459bf8016d34863cb7b06