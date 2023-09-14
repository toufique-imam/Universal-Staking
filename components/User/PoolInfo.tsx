import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { poolExists, poolIsActive, getPoolInfo } from '@/utils/stake/user';
import { Typography } from '@mui/material';

export default function PoolInfoView() {
    const [poolId, setPoolId] = React.useState('');
    const [loading, setLoading] = React.useState(false);
    const [result, setResult] = React.useState('');
    const handleCheckPoolExists = async () => {
        setLoading(true);
        const res = await poolExists(BigInt(poolId));
        setResult(res ? 'true' : 'false');
        setLoading(false);
    }
    const handleCheckPoolActive = async () => {
        setLoading(true);
        const res = await poolIsActive(BigInt(poolId));
        setResult(res ? 'true' : 'false');
        setLoading(false);
    }
    const handlePoolInfo = async () => {
        setLoading(true);
        const res = await getPoolInfo(BigInt(poolId));
        const _res = (JSON.stringify(res, (key, value) => typeof value === 'bigint' ? value.toString() : value));
        toast.info(_res);
        setLoading(false);
    }
    return (
        <div>
            <TextField
                autoFocus
                margin="dense"
                id="pool_id"
                label="Pool id"
                type="number"
                fullWidth
                value={poolId}
                onChange={(e) => setPoolId(e.target.value)}
                variant="standard"
            />
            <Button variant="outlined" onClick={handleCheckPoolExists}>
                Check Pool Exists
            </Button>
            <br />
            <Button variant="outlined" onClick={handleCheckPoolActive}>
                Check Pool Active
            </Button>
            <br />
            <Button variant="outlined" onClick={handlePoolInfo}>
                Pool info
            </Button>
            <Typography variant="body1" component="h6" color={"black"}>
                {loading ? 'loading' : result}
            </Typography>

        </div>
    );
}