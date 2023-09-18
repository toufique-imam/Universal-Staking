import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { getNFTAllowanceByPoolId, stakeNFT, updateStakeNFTAllowance } from '@/utils/stake/user';
import { useAccount } from 'wagmi';
import { Typography } from '@mui/material';

export default function StakeNFTView() {
    const [tokenIds, setTokenIds] = React.useState('');
    const [poolId, setPoolId] = React.useState('');
    const { address } = useAccount();
    const handleStake = async () => {
        toast.info('Stake');
        if (!address) {
            toast.error('please connect wallet');
            return;
        }
        const _poolId = BigInt(poolId);
        const tokenIdsArray = tokenIds.split(',').map((id) => {
            return BigInt(id);
        });

        const allowance = await getNFTAllowanceByPoolId(address, _poolId);
        if (allowance === true) {
        } else {
            const res1 = await updateStakeNFTAllowance(_poolId);
            if (res1 == -1) {
                toast.error('update allowance failed');
                return;
            }
        }

        const res = await stakeNFT(_poolId, tokenIdsArray);
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

            <Typography variant="body1" gutterBottom>
                Enter token IDs separated by commas
            </Typography>
            <TextField
                autoFocus
                margin="dense"
                id="stake_amount"
                label="Stake Amount"
                type="number"
                fullWidth
                value={tokenIds}
                onChange={(e) => setTokenIds(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleStake}>
                Stake
            </Button>

        </div>
    );
}