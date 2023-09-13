export const StakingContractABI = [
    {
        inputs: [
            {
                internalType: "address",
                name: "_rewardToken",
                type: "address"
            }
        ],
        stateMutability: "nonpayable",
        type: "constructor"
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
                internalType: "address",
                name: "_stakingToken",
                type: "address"
            },
            {
                internalType: "uint8",
                name: "_stakingTokenDecimals",
                type: "uint8"
            },
            {
                internalType: "uint256",
                name: "_bonusPercentage",
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
                internalType: "uint8",
                name: "_stakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint8",
                name: "_unstakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint8",
                name: "_maxStakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint256",
                name: "_maxStakePerWallet",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "_penaltyPercentage",
                type: "uint256"
            }
        ],
        name: "createStakingPool",
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
        name: "getPoolInfo",
        outputs: [
            {
                components: [
                    {
                        internalType: "address",
                        name: "stakingToken",
                        type: "address"
                    },
                    {
                        internalType: "uint8",
                        name: "stakingTokenDecimals",
                        type: "uint8"
                    },
                    {
                        internalType: "uint256",
                        name: "totalRewards",
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
                        internalType: "uint8",
                        name: "stakingFeePercentage",
                        type: "uint8"
                    },
                    {
                        internalType: "uint8",
                        name: "unstakingFeePercentage",
                        type: "uint8"
                    },
                    {
                        internalType: "uint8",
                        name: "maxStakingFeePercentage",
                        type: "uint8"
                    },
                    {
                        internalType: "uint256",
                        name: "bonusPercentage",
                        type: "uint256"
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
                        internalType: "uint256",
                        name: "penaltyPercentage",
                        type: "uint256"
                    },
                    {
                        internalType: "uint256",
                        name: "rewardPerTokenStored",
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
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "rewardPerToken",
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
                name: "",
                type: "address"
            },
            {
                internalType: "uint256",
                name: "",
                type: "uint256"
            }
        ],
        name: "rewards",
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
                internalType: "bool",
                name: "status",
                type: "bool"
            }
        ],
        name: "setPoolInactive",
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
        name: "stake",
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
                name: "stakingToken",
                type: "address"
            },
            {
                internalType: "uint8",
                name: "stakingTokenDecimals",
                type: "uint8"
            },
            {
                internalType: "uint256",
                name: "totalRewards",
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
                internalType: "uint8",
                name: "stakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint8",
                name: "unstakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint8",
                name: "maxStakingFeePercentage",
                type: "uint8"
            },
            {
                internalType: "uint256",
                name: "bonusPercentage",
                type: "uint256"
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
                internalType: "uint256",
                name: "penaltyPercentage",
                type: "uint256"
            },
            {
                internalType: "uint256",
                name: "rewardPerTokenStored",
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
                internalType: "uint256",
                name: "_amount",
                type: "uint256"
            }
        ],
        name: "unstake",
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
        name: "unstakedBalances",
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
                name: "token",
                type: "address"
            }
        ],
        name: "withdraw",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    },
    {
        inputs: [],
        name: "withdrawRewardToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    }
] as const;