import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';

export default function Admin() {
    const [withdrawAddress, setWithdrawAddress] = React.useState('');
    const handleWithdrawToken = async () => {

    }
    return (
        <div>
            <Button variant="outlined" onClick={handleWithdrawToken}>
                Withdraw reward tokens
            </Button>

        </div>
    );
}