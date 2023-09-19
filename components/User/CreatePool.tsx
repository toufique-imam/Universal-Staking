import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { Address, isAddress, parseEther } from 'viem';
import { createStakingPool } from '@/utils/stake/user';
import { Switch, Typography } from '@mui/material';

const labelNFT = { inputProps: { 'aria-label': 'isNFT?' } };
const labelPool = { inputProps: { 'aria-label': 'isPool?' } };
export default function CreatePoolView() {
    const [stakingToken, setStakingToken] = React.useState('');
    const [rewardToken, setRewardToken] = React.useState('');

    const [startDate, setStartDate] = React.useState('');
    const [endDate, setEndDate] = React.useState('');

    const [bonusPercentage, setBonusPercentage] = React.useState('');
    const [maxStakePerWallet, setMaxStakePerWallet] = React.useState('');
    const [penaltyPercentage, setPenaltyPercentage] = React.useState('');
    const [isNFT, setIsNFT] = React.useState(false);
    const [isSharedPool, setIsSharedPool] = React.useState(false);

    const checkValues = () => {
        if (isAddress(stakingToken) == false) {
            toast.error('invalid staking token address');
            return false;
        }
        if (isAddress(rewardToken) == false) {
            toast.error('invalid reward token address');
            return false;
        }
        if (bonusPercentage == '') {
            toast.error('invalid bonus percentage');
            return false;
        }
        if (startDate == '') {
            toast.error('invalid start date');
            return false;
        }
        if (endDate == '') {
            toast.error('invalid end date');
            return false;
        }
        if (maxStakePerWallet == '') {
            toast.error('invalid max stake per wallet');
            return false;
        }
        if (penaltyPercentage == '') {
            toast.error('invalid penalty percentage');
            return false;
        }
        return true;
    }
    const handleCreatePool = async () => {
        if (checkValues() == false) {
            return;
        }
        toast.info('Creating Staking Pool');
        const res = await createStakingPool(
            stakingToken as Address,
            rewardToken as Address,
            BigInt(new Date(startDate).getTime() / 1000),
            BigInt(new Date(endDate).getTime() / 1000),
            BigInt(maxStakePerWallet),
            isNFT,
            isSharedPool,
            BigInt(penaltyPercentage),
            BigInt(bonusPercentage)
        );
        if (res == -1) {
            toast.error('create pool failed');
            return;
        }
        toast.info('create pool finished');
    }
    return (
        <div>
            <TextField autoFocus margin="dense" id="stake_token_address" label="Stake token/NFT Address" type="text" fullWidth value={stakingToken} onChange={(e) => setStakingToken(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="stake_token_decimals" label="Reward Token address" type="text" fullWidth value={rewardToken} onChange={(e) => setRewardToken(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="bonus_percentage" label="Bonus Percentage" type="number" fullWidth value={bonusPercentage} onChange={(e) => setBonusPercentage(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="start_date" label="Start Date" type="date" fullWidth value={startDate} onChange={(e) => setStartDate(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="end_date" label="End Date" type="date" fullWidth value={endDate} onChange={(e) => setEndDate(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="max_stake_per_wallet" label="Max Stake Per Wallet" type="number" fullWidth value={maxStakePerWallet} onChange={(e) => setMaxStakePerWallet(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="penalty_percentage" label="Penalty Percentage" type="number" fullWidth value={penaltyPercentage} onChange={(e) => setPenaltyPercentage(e.target.value)} variant="standard" />
            <Typography variant="h6">Is NFT?</Typography>
            <Switch {...labelNFT} checked={isNFT} onChange={(e) => setIsNFT(e.target.checked)} />
            <br />
            <Typography variant="h6">Is Shared Pool?</Typography>
            <Switch {...labelPool} checked={isSharedPool} onChange={(e) => setIsSharedPool(e.target.checked)} />
            <br />

            <Button variant="outlined" onClick={handleCreatePool}>
                Create Staking Pool
            </Button>
        </div>
    );
}