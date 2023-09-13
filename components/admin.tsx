import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

export default function Admin() {
    const [mintAddress, setMintAddress] = React.useState('');
    const [mintAmount, setMintAmount] = React.useState(0);
    const handleMintToken = () => {
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
                variant="standard"
            />
            <TextField
                autoFocus
                margin="dense"
                id="token_amount"
                label="Token Amount"
                type="number"
                fullWidth
                variant="standard"
            />
            <Button variant="outlined" onClick={handleClickOpen}>
                Mint reward tokens
            </Button>

        </div>
    );
}