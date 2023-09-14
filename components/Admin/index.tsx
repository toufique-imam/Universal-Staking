import PauseStakeView from "./PauseStake";
import UnpauseStakeView from "./UnpauseStake";
import TransferOwnershipView from "./TransferOwnership";
import WithdrawTokenView from "./WithdrawToken";
import WithdrawRewardTokenView from "./WithdrawReward";
import PoolActivityView from "./PoolActivity";

export default function AdminView() {
    return (
        <div>
            <PauseStakeView />
            <hr />
            <br />

            <UnpauseStakeView />
            <hr />
            <br />

            <TransferOwnershipView />
            <hr />
            <br />

            <WithdrawTokenView />
            <hr />
            <br />

            <WithdrawRewardTokenView />
            <hr />
            <br />

            <PoolActivityView />
        </div>
    );
}