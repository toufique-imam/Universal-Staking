import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { parseEther } from 'viem';
import { getTokenAllowanceByPoolId, stakeToken, updateStakeTokenAllowance } from '@/utils/stake/user';
import { useAccount } from 'wagmi';

export default function StakeTokenView() {
    const [stakeAmount, setStakeAmount] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const { address } = useAccount();
    const handleStake = async () => {
        toast.info('Stake');
        if (!address) {
            toast.error('please connect wallet');
            return;
        }
        const _poolId = BigInt(poolId);
        const etherAmount = parseEther(stakeAmount);
        const allowance = await getTokenAllowanceByPoolId(address, _poolId);
        if (allowance < etherAmount) {
            const res1 = await updateStakeTokenAllowance(_poolId, etherAmount);
            if (res1 == -1) {
                toast.error('update allowance failed');
                return;
            }
        }
        const res = await stakeToken(_poolId, etherAmount);
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