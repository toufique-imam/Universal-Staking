import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { parseEther } from 'viem';
import { stake } from '@/utils/stake/user';

export default function StakeView() {
    const [stakeAmount, setStakeAmount] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const handleStake = async () => {
        toast.info('Stake');
        const res = await stake(BigInt(poolId), parseEther(stakeAmount));
        if (res == -1) {
            toast.error('stake failed');
            return;
        }
        toast.info('stake finished');   
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
                label="Stake Amount"
                type="number"
                fullWidth
                value={stakeAmount}
                onChange={(e) => setStakeAmount(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleStake}>
                Stake
            </Button>

        </div>
    );
}