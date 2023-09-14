import * as React from 'react';
import Button from '@mui/material/Button';
import { toast } from 'react-toastify';
import { unpauseStake } from '@/utils/stake/admin';

export default function UnpauseStakeView() {
    const handleUnpause = async () => {
        toast.info('handle Pause');
        const res = await unpauseStake();
        if (res == -1) {
            toast.error('unpause failed');
            return;
        }
        toast.info('unpause finished');
    }
    return (
        <div>
            <Button variant="outlined" onClick={handleUnpause}>
                Unpause Staking
            </Button>

        </div>
    );
}