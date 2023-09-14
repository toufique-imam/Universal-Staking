import * as React from 'react';
import Button from '@mui/material/Button';
import { toast } from 'react-toastify';
import { pauseStake } from '@/utils/stake/admin';

export default function PauseStakeView() {
    const handlePause = async () => {
        toast.info('handle Pause');
        const res = await pauseStake();
        if (res == -1) {
            toast.error('pause failed');
            return;
        }
        toast.info('pause finished');
    }
    return (
        <div>
            <Button variant="outlined" onClick={handlePause}>
                Pause Staking
            </Button>

        </div>
    );
}