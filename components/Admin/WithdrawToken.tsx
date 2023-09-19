import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { withdrawToken } from '@/utils/stake/admin';
import { Address, isAddress } from 'viem';

export default function WithdrawTokenView() {
    const [withdrawAddress, setWithdrawAddress] = React.useState('');
    const handleWithdrawToken = async () => {
        if(isAddress(withdrawAddress) == false){
            toast.error('invalid address');
            return;
        }
        toast.info('Withdraw token');
        const res = await withdrawToken(withdrawAddress as Address);
        if (res == -1) {
            toast.error('withdraw failed');
            return;
        }
        toast.info('withdraw finished');   
    }
    return (
        <div>
            <TextField
                autoFocus
                margin="dense"
                id="wallet_address"
                label="Wallet Address"
                type="text"
                fullWidth
                value={withdrawAddress}
                onChange={(e) => setWithdrawAddress(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleWithdrawToken}>
                Withdraw token
            </Button>

        </div>
    );
}