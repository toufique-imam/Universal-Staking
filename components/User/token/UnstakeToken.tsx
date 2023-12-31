import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { parseEther } from 'viem';
import { unstakeToken } from '@/utils/stake/user';

export default function UnstakeTokenView() {
    const [stakeAmount, setStakeAmount] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const handleUnstake = async () => {
        toast.info('un Stake');
        const res = await unstakeToken(BigInt(poolId), parseEther(stakeAmount));
        if (res == -1) {
            toast.error('unstake failed');
            return;
        }
        toast.info('unstake finished');
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
            <TextField
                autoFocus
                margin="dense"
                id="stake_amount"
                label="Unstake Amount"
                type="number"
                fullWidth
                value={stakeAmount}
                onChange={(e) => setStakeAmount(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleUnstake}>
                Un Stake
            </Button>

        </div>
    );
}