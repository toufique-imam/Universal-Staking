import CreatePoolView from "./CreatePool";
import StakeTokenView from "./token/StakeToken";
import ClaimNFTView from "./nft/ClaimNFT";
import UnstakeTokenView from "./token/UnstakeToken";
import PoolActivityView from "./PoolActive";
import StakeNFTView from "./nft/StakeNFT";
import UnstakeNFTView from "./nft/UnstakeNFT";
import ClaimTokenView from "./token/ClaimToken";
import PoolInfoView from "./PoolInfo";

export default function UserView() {
    return (
        <div>
            <h2> 
                User Functions
            </h2>
            <CreatePoolView />
            <hr />
            <br />

            <PoolInfoView />
            <hr />
            <br />
            
            <PoolActivityView />
            
            <StakeTokenView />
            <hr />
            <br />

            <UnstakeTokenView />
            <hr />
            <br />

            <ClaimTokenView />
            <hr />
            <br />

            <StakeNFTView />
            <hr />
            <br />

            <UnstakeNFTView />
            <hr />
            <br />

            <ClaimNFTView />
            <hr />
            <br />
        </div>
    );
}