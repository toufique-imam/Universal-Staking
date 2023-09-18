import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { unstakeNFT } from '@/utils/stake/user';
import { Typography } from '@mui/material';

export default function UnstakeNFTView() {
    const [tokenIds, setTokenIds] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const handleClaim = async () => {
        toast.info('claim nft');
        // convert tokenIDs to array
        const tokenIdsArray = tokenIds.split(',').map((id) => {
            return BigInt(id);
        });
        const res = await unstakeNFT(BigInt(poolId), tokenIdsArray);
        if (res == -1) {
            toast.error('claim nft failed');
            return;
        }
        toast.info('claim nft finished');
    }
    return (
        <div>
            <TextField
                autoFocus
                margin="dense"
                id="pool_id"
                label="Pool id"
                type="number"
                fullWidth
                value={poolId}
                onChange={(e) => setPoolId(e.target.value)}
                variant="standard"
            />
            <Typography variant="body1" gutterBottom>
                Enter token IDs separated by commas
            </Typography>
            <TextField
                autoFocus
                margin="dense"
                id="claim_amount"
                label="Claim rewards"
                type="text"
                fullWidth
                value={tokenIds}
                onChange={(e) => setTokenIds(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleClaim}>
                Claim
            </Button>

        </div>
    );
}