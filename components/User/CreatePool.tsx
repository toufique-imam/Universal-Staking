import * as React from 'react';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import { toast } from 'react-toastify';
import { Address, isAddress, parseEther } from 'viem';
import { createStakingPool } from '@/utils/stake/user';
import { Switch, Typography } from '@mui/material';

const label = { inputProps: { 'aria-label': 'isNFT?' } };
export default function CreatePoolView() {
    const [stakingToken, setStakingToken] = React.useState('');
    const [rewardToken, setRewardToken] = React.useState('');

    const [startDate, setStartDate] = React.useState('');
    const [endDate, setEndDate] = React.useState('');

    const [stakingFeePercentage, setStakingFeePercentage] = React.useState(0);
    const [unstakingFeePercentage, setUnstakingFeePercentage] = React.useState(0);
    const [maxStakingFeePercentage, setMaxStakingFeePercentage] = React.useState(0);
    const [bonusPercentage, setBonusPercentage] = React.useState('');
    const [maxStakePerWallet, setMaxStakePerWallet] = React.useState('');
    const [penaltyPercentage, setPenaltyPercentage] = React.useState('');
    const [isNFT, setIsNFT] = React.useState(false);

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
        if (stakingFeePercentage == 0) {
            toast.error('invalid staking fee percentage');
            return false;
        }
        if (unstakingFeePercentage == 0) {
            toast.error('invalid unstaking fee percentage');
            return false;
        }
        if (maxStakingFeePercentage == 0) {
            toast.error('invalid max staking fee percentage');
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
            BigInt(bonusPercentage),
            BigInt(new Date(startDate).getTime() / 1000),
            BigInt(new Date(endDate).getTime() / 1000),
            stakingFeePercentage,
            unstakingFeePercentage,
            maxStakingFeePercentage,
            BigInt(maxStakePerWallet),
            BigInt(penaltyPercentage),
            isNFT
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
            <TextField autoFocus margin="dense" id="staking_fee_percentage" label="Staking Fee Percentage" type="number" fullWidth value={stakingFeePercentage} onChange={(e) => setStakingFeePercentage(parseInt(e.target.value))} variant="standard" />
            <TextField autoFocus margin="dense" id="unstaking_fee_percentage" label="Unstaking Fee Percentage" type="number" fullWidth value={unstakingFeePercentage} onChange={(e) => setUnstakingFeePercentage(parseInt(e.target.value))} variant="standard" />
            <TextField autoFocus margin="dense" id="max_staking_fee_percentage" label="Max Staking Fee Percentage" type="number" fullWidth value={maxStakingFeePercentage} onChange={(e) => setMaxStakingFeePercentage(parseInt(e.target.value))} variant="standard" />
            <TextField autoFocus margin="dense" id="max_stake_per_wallet" label="Max Stake Per Wallet" type="number" fullWidth value={maxStakePerWallet} onChange={(e) => setMaxStakePerWallet(e.target.value)} variant="standard" />
            <TextField autoFocus margin="dense" id="penalty_percentage" label="Penalty Percentage" type="number" fullWidth value={penaltyPercentage} onChange={(e) => setPenaltyPercentage(e.target.value)} variant="standard" />
            <Typography variant="h6">Is NFT?</Typography>
            <Switch {...label} checked={isNFT} onChange={(e) => setIsNFT(e.target.checked)} />
            <br />
            <Button variant="outlined" onClick={handleCreatePool}>
                Create Staking Pool
            </Button>
        </div>
    );
}