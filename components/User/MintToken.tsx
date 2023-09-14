import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { Address, isAddress, parseEther } from 'viem';
import { mint } from '@/utils/token/user';

export default function MintTokenView() {
    const [tokenAmount, setTokenAmount] = React.useState('');
    const [address, setAddress] = React.useState('');
    const handleMint = async () => {
        if (isAddress(address) == false) {
            toast.error('invalid address');
            return;
        }
        if (tokenAmount == '') {
            toast.error('invalid token amount');
            return;
        }

        toast.info('Mint');
        const res = await mint(address as Address, parseEther(tokenAmount));
        if (res == -1) {
            toast.error('mint failed');
            return;
        }
        toast.info('mint finished');
    }

    return (
        <div>
            <TextField
                autoFocus
                margin="dense"
                id="send_address"
                label="send address"
                type="text"
                fullWidth
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                variant="standard"
            />
            <TextField
                autoFocus
                margin="dense"
                id="mint_amount"
                label="mint Amount"
                type="number"
                fullWidth
                value={tokenAmount}
                onChange={(e) => setTokenAmount(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleMint}>
                Mint
            </Button>

        </div>
    );
}