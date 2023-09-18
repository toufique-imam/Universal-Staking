import * as React from 'react';
import Button from '@mui/material/Button';
import { Switch, TextField } from '@mui/material';
import { toast } from 'react-toastify';
import { setPoolInactive } from '@/utils/stake/user';

const label = { inputProps: { 'aria-label': 'Pool Status' } };

export default function PoolActivityView() {
    const [poolId, setPoolId] = React.useState('');
    const [poolStatus, setPoolStatus] = React.useState(false);
    const handleSetActivePool = async () => {
        toast.info('handle setPoolInactive');
        const res = await setPoolInactive(BigInt(poolId), poolStatus);
        if (res == -1) {
            toast.error('setPoolInactive failed');
            return;
        }
        toast.info('setPoolInactive finished');
    }
    return (
        <div>
            <TextField
                autoFocus
                margin="dense"
                id="pool_id"
                label="Pool id"
                type="text"
                fullWidth
                value={poolId}
                onChange={(e) => setPoolId(e.target.value)}
                variant="standard"
            />
            <Switch {...label} defaultChecked
                onChange={(e) => setPoolStatus(e.target.checked)}
            />
            <Button variant="outlined" onClick={handleSetActivePool}>
                setPool Status
            </Button>

        </div>
    );
}