import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { transferOwnership } from '@/utils/stake/admin';
import { Address, isAddress } from 'viem';

export default function TransferOwnershipView() {
    const [address, setAddress] = React.useState('');
    const handleTransferOwnership = async () => {
        if (isAddress(address) == false) {
            toast.error('invalid address');
            return;
        }
        toast.info('transfer ownership');
        const res = await transferOwnership(address as Address);
        if (res == -1) {
            toast.error('transfer ownership failed');
            return;
        }
        toast.info('transfer ownership finished');
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
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleTransferOwnership}>
                Transfer Ownership
            </Button>

        </div>
    );
}