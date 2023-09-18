import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { parseEther } from 'viem';
import { claimToken } from '@/utils/stake/user';
import { Typography } from '@mui/material';

export default function ClaimTokenView() {
    const [stakeAmount, setStakeAmount] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const handleUnstake = async () => {
        toast.info('claim token');
        const res = await claimToken(BigInt(poolId), parseEther(stakeAmount));
        if (res == -1) {
            toast.error('claim token failed');
            return;
        }
        toast.info('claim token finished');
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
            <Typography variant="h6" component="div" gutterBottom>
                Claim Amount
            </Typography>
            
            <TextField
                autoFocus
                margin="dense"
                id="stake_amount"
                label="Claim Amount"
                type="number"
                fullWidth
                value={stakeAmount}
                onChange={(e) => setStakeAmount(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleUnstake}>
                Claim
            </Button>

        </div>
    );
}