1-Rewards calculation for shared and not shared pools
NOT SHARED (FALSE)
user rewards will be calculated like that:
bonus in % per period applied to staked amount
not considering the other staked amounts
it will consider the maximum amount that a pool can have

SHARED (TRUE):
shared poool calculation=
total rewards per period / total staked tokens = reward per each staked token,

but when you stake = you will join the pool during second period
on shared pool it's total staked tokens by all users
if new user joins = it ill be added on next period

example:
i stake on period 1 = no rewards on period 1
on period 2 i'll start earning the reward tokens
if you stake on period 2, you will start earning on period 3
on period 3 there will be both my and your staked tokens considered
if we both staked on period 0= period 1 no rewards
period 1 = both earn but if you unstake before period 1 ends = no rewards and obviously claim rewards (if available), stop rewarding
charge penalty if applicable, charge unstaking fee
obviously if i stake and you stake the total rewards per period must be calculated based on our total staked tokens
proportionally to the staked amount

2-Rewards are not allocated, so someone could stake when all the rewards are earned but not claimed.

ask the creator to input max staked tokens amount possible and to fund all the rewards for maximum partecipants for pool not shared,
for shared pools when someone stakes doesn't join current period but next one.
+Put function that let the creator withdraw balance after 30 days after pool is ended to prevent having fraudulent actors.

3-The staking and unstaking fees must be allocated to the owner meaning that the creator cannot withdraw the owner fees and the unclaimed tokens that should've been reserved to the stakers.

4-Creator should be able to withdraw only the unallocated tokens (rewards and fees )

5-how can i have the counting of all users (among all pools)
6-how can i have the counting of all staking and unstaking fees for each individual pool

7-how can i have the counting of all stakes (ex: i stake = 1, you stake = 2, i stake again = 3 and so on)

8-penalty must go to creator
9.help testing to make sure everything's good