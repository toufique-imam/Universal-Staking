import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

export default function Admin() {
    const [withdrawAddress, setWithdrawAddress] = React.useState('');
    const handleWithdrawToken = async () => {
        
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