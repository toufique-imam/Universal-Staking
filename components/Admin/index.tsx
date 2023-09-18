import PauseStakeView from "./PauseStake";
import UnpauseStakeView from "./UnpauseStake";
import TransferOwnershipView from "./TransferOwnership";
import WithdrawTokenView from "./WithdrawToken";

export default function AdminView() {
    return (
        <div>
            <h2>Admin Functions </h2>
            <br />
            <br />
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
        </div>
    );
}