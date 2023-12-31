export const StakingContractABI = [
    {
        inputs: [],
        stateMutability: "nonpayable",
        type: "constructor"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256"
            }
        ],
        name: "NFTStaked",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "owner",
                type: "address"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256"
            }
        ],
        name: "NFTUnstaked",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address"
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address"
            }
        ],
        name: "OwnershipTransferred",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "account",
                type: "address"
            }
        ],
        name: "Paused",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            }
        ],
        name: "PoolCreated",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "bool",
                name: "status",
                type: "bool"
            }
        ],
        name: "PoolStatusChanged",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "user",
                type: "address"
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "amount",
                type: "uint256"
            }
        ],
        name: "RewardClaimed",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "user",
                type: "address"
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "amount",
                type: "uint256"
            }
        ],
        name: "Staked",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: false,
                internalType: "address",
                name: "account",
                type: "address"
            }
        ],
        name: "Unpaused",
        type: "event"
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "user",
                type: "address"
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "amount",
                type: "uint256"
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "penalty",
                type: "uint256"
            }
        ],
        name: "Unstaked",
        type: "event"
    },
    {
        inputs: [
            {
                internalType: "bool",
                name: "state",
                type: "bool"
            }
        ],
        name: "changeContractState",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256[]",
                name: "tokenIds",
                type: "uint256[]"
            }
        ],
        name: "claimNFT",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "claimToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "currentDecimals",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "targetDecimals",
                type: "uint256"
            }
        ],
        name: "convertAmountToDecimal",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "pure",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_stakingAddress",
                type: "address"
            },
            {
                internalType: "address",
                name: "_rewardTokenAddress",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "_stakingTokenDecimals",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_rewardTokenDecimals",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_startDate",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_endDate",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_maxStakePerWallet",
                type: "uint256"
            },
            {
                internalType: "bool",
                name: "isNFT",
                type: "bool"
            },
            {
                internalType: "bool",
                name: "isSharedPool",
                type: "bool"
            },
            {
                internalType: "uint256",
                name: "penaltyPercentageN",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "penaltyPercentageD",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "bonusPercentageN",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "bonusPercentageD",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "poolPeriod",
                type: "uint256"
            }
        ],
        name: "createStakingPool",
        outputs: [],
        stateMutability: "payable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256"
            }
        ],
        name: "depositRewardToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256[]",
                name: "tokenIds",
                type: "uint256[]"
            }
        ],
        name: "earningInfoNFT",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "address",
                name: "account",
                type: "address"
            }
        ],
        name: "earningInfoToken",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "getPoolCreationFee",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "getPoolInfo",
        outputs: [
            {
                components: [
                    {
                        internalType: "address",
                        name: "stakingAddress",
                        type: "address"
                    },
                    {
                        internalType: "contract IERC20",
                        name: "rewardToken",
                        type: "address"
                    },
                    {
                        internalType: "uint256",
                        name: "stakingTokenDecimals",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "rewardTokenDecimals",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "rewardTokenAmount",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "totalStaked",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "startDate",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "endDate",
                        type: "uint256"
                    },
                    {
                        internalType: "address",
                        name: "creator",
                        type: "address"
                    },
                    {
                        internalType: "uint256",
                        name: "maxStakePerWallet",
                        type: "uint256"
                    },
                    {
                        internalType: "bool",
                        name: "isActive",
                        type: "bool"
                    },
                    {
                        internalType: "bool",
                        name: "isNFT",
                        type: "bool"
                    },
                    {
                        internalType: "bool",
                        name: "isSharedPool",
                        type: "bool"
                    },
                    {
                        internalType: "uint256",
                        name: "penaltyPercentageNumerator",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "penaltyPercentageDenominator",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "bonusPercentageNumerator",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "bonusPercentageDenominator",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "poolPeriod",
                        type: "uint256"
                    }
                ],
                internalType: "struct StakingContract.StakingPool",
                name: "",
                type: "tuple"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "getStakingFeePercentage",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "getUnstakingFeePercentage",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            },
            {
                internalType: "address",
                name: "",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            },
            {
                internalType: "bytes",
                name: "",
                type: "bytes"
            }
        ],
        name: "onERC721Received",
        outputs: [
            {
                internalType: "bytes4",
                name: "",
                type: "bytes4"
            }
        ],
        stateMutability: "pure",
        type: "function"
    },
    {
        inputs: [],
        name: "owner",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "paused",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "poolCount",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "poolExists",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "poolIsActive",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "renounceOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolCreationFee",
                type: "uint256"
            }
        ],
        name: "setPoolCreationFee",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "bool",
                name: "status",
                type: "bool"
            }
        ],
        name: "setPoolStatus",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_stakingFeePercentageN",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_stakingFeePercentageD",
                type: "uint256"
            }
        ],
        name: "setStakingFeePercentage",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_unstakingFeePercentageN",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_unstakingFeePercentageD",
                type: "uint256"
            }
        ],
        name: "setUnstakingFeePercentage",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256[]",
                name: "tokenIds",
                type: "uint256[]"
            }
        ],
        name: "stakeNFT",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_amount",
                type: "uint256"
            }
        ],
        name: "stakeToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        name: "stakedBalances",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        name: "stakingPools",
        outputs: [
            {
                internalType: "address",
                name: "stakingAddress",
                type: "address"
            },
            {
                internalType: "contract IERC20",
                name: "rewardToken",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "stakingTokenDecimals",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "rewardTokenDecimals",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "rewardTokenAmount",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "totalStaked",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "startDate",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "endDate",
                type: "uint256"
            },
            {
                internalType: "address",
                name: "creator",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "maxStakePerWallet",
                type: "uint256"
            },
            {
                internalType: "bool",
                name: "isActive",
                type: "bool"
            },
            {
                internalType: "bool",
                name: "isNFT",
                type: "bool"
            },
            {
                internalType: "bool",
                name: "isSharedPool",
                type: "bool"
            },
            {
                internalType: "uint256",
                name: "penaltyPercentageNumerator",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "penaltyPercentageDenominator",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "bonusPercentageNumerator",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "bonusPercentageDenominator",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "poolPeriod",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            }
        ],
        name: "tokenWithdrawBalances",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "newOwner",
                type: "address"
            }
        ],
        name: "transferOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256[]",
                name: "tokenIds",
                type: "uint256[]"
            }
        ],
        name: "unstakeNFT",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_amount",
                type: "uint256"
            }
        ],
        name: "unstakeToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        name: "vaults",
        outputs: [
            {
                internalType: "uint256",
                name: "poolId",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "timestamp",
                type: "uint256"
            },
            {
                internalType: "address",
                name: "owner",
                type: "address"
            }
        ],
        stateMutability: "view",
        type: "function"
    },
    {
        inputs: [],
        name: "withdraw",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "withdrawStake",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "token",
                type: "address"
            }
        ],
        name: "withdrawToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    }
] as const;