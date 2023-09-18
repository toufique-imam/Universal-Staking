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
            },
            {
                internalType: "uint256",
                name: "_amount",
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
            },
            {
                internalType: "bool",
                name: "isNFT",
                type: "bool"
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
                        internalType: "bool",
                        name: "isNFT",
                        type: "bool"
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
        inputs: [
            {
                internalType: "address",
                name: "",
                type: "address"
            },
            {
                internalType: "address",
                name: "from",
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
        name: "pause",
        outputs: [],
        stateMutability: "nonpayable",
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
        name: "receiveToken",
        outputs: [],
        stateMutability: "nonpayable",
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
                internalType: "bool",
                name: "isNFT",
                type: "bool"
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
        inputs: [],
        name: "unpause",
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
                internalType: "uint48",
                name: "timestamp",
                type: "uint48"
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
        inputs: [
            {
                internalType: "uint256",
                name: "_poolId",
                type: "uint256"
            }
        ],
        name: "withdraw",
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
        name: "withdraw",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function"
    }
] as const;