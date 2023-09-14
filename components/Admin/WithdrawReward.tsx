import * as React from 'react';
import Button from '@mui/material/Button';
import { Switch } from '@mui/material';
import { toast } from 'react-toastify';
import { withdrawRewardToken } from '@/utils/stake/admin';

export default function WithdrawRewardTokenView() {
    const handleRewardToken = async () => {
        toast.info('Withdraw reward tokens');
        const res = await withdrawRewardToken();
        if (res == -1) {
            toast.error('withdraw failed');
            return;
        }
        toast.info('withdraw finished');
    }
    return (
        <div>
            <Button variant="outlined" onClick={handleRewardToken}>
                Withdraw reward tokens
            </Button>

        </div>
    );
}