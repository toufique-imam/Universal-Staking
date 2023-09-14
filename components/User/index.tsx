import CreatePoolView from "./CreatePool";
import StakeView from "./Stake";
import UnstakeView from "./Unstake";
import MintTokenView from "./MintToken";
import PoolInfoView from "./PoolInfo";

export default function UserView() {
    return (
        <div>
            <CreatePoolView />
            <hr/>
            <br/>
            <StakeView />
            <hr />
            <br />

            <UnstakeView />
            <hr />
            <br />

            <MintTokenView />
            <hr />
            <br />

            <PoolInfoView />
        </div>
    );
}