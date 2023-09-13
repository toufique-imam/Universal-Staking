import * as React from 'react';
import Button from '@mui/material/Button';
import { Switch } from '@mui/material';

const label = { inputProps: { 'aria-label': 'Color switch demo' } };
export default function Admin() {
    const handleInactivePool = async () => {
        //TODO: mint tokens
    }
    return (
        <div>
            <Switch {...label} defaultChecked />
            <Button variant="outlined" onClick={handleMintToken}>
                Mint reward tokens
            </Button>

        </div>
    );
}