// Sources flattened with hardhat v2.17.3 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File @openzeppelin/contracts/interfaces/IERC20.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)

pragma solidity ^0.8.0;


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts/interfaces/IERC721.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)

pragma solidity ^0.8.0;


// File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


// File @openzeppelin/contracts/interfaces/IERC721Receiver.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Receiver.sol)

pragma solidity ^0.8.0;


// File @openzeppelin/contracts/security/Pausable.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}


// File contracts/StakingContract.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;
contract StakingContract is
    Ownable,
    Pausable,
    ReentrancyGuard,
    IERC721Receiver
{
    // Structure to represent staking pools
    uint256 stakingFeePercentageDenominator = 1;
    uint256 stakingFeePercentageNumerator = 100;
    uint256 unstakingFeePercentageDenominator = 2;
    uint256 unstakingFeePercentageNumerator = 100;
    uint256 poolCreationFee = 0.001 ether;

    struct StakingPool {
        address stakingAddress;
        IERC20 rewardToken;
        uint256 stakingTokenDecimals;
        uint256 rewardTokenDecimals;
        uint256 rewardTokenAmount;
        uint256 totalStaked;
        uint256 startDate;
        uint256 endDate;
        address creator;
        uint256 maxStakePerWallet;
        bool isActive;
        bool isNFT;
        bool isSharedPool;
        uint256 penaltyPercentageNumerator;
        uint256 penaltyPercentageDenominator;
        uint256 bonusPercentageNumerator;
        uint256 bonusPercentageDenominator;
        uint256 poolPeriod;
    }
    struct Stake {
        uint256 poolId;
        uint256 tokenId;
        uint256 timestamp;
        address owner;
    }

    // Mapping to track staking pools
    mapping(uint256 => StakingPool) public stakingPools;

    //mapping nft token id to stake
    mapping(address => mapping(uint256 => Stake)) public vaults;
    //for nft, staking address => token id => stake
    // for token, user => poolId => stake and tokenID = token amount

    uint256 public poolCount;

    // Mapping to track user staked balances
    mapping(address => mapping(uint256 => uint256)) public stakedBalances;
    mapping(address => uint256) public tokenWithdrawBalances;

    event PoolCreated(uint256 poolId);
    event PoolStatusChanged(uint256 poolId, bool status);
    event Staked(address indexed user, uint256 indexed poolId, uint256 amount);
    event NFTStaked(address owner, uint256 poolId, uint256 tokenId);
    event NFTUnstaked(address owner, uint256 poolId, uint256 tokenId);
    event Unstaked(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount,
        uint256 penalty
    );
    event RewardClaimed(
        address indexed user,
        uint256 indexed poolId,
        uint256 amount
    );

    constructor() {}

    /**
     * @dev Function to create a new staking pool, pool creator pays a fee to create the pool
     * @param _stakingAddress address of the staking token/nft
     * @param _rewardTokenAddress address of the reward token
     * @param _startDate start date of the staking period
     * @param _endDate end date of the staking period
     * @param _maxStakePerWallet maximum amount of tokens/nft that can be staked per wallet
     * @param isNFT true if the pool is for NFTs
     * @param isSharedPool true if the pool is shared
     * @param penaltyPercentageN penalty Numerator for early unstaking
     * @param penaltyPercentageD penalty Denominator for early unstaking
     * @param bonusPercentageN bonus Numerator for shared pool
     * @param bonusPercentageD bonus Denominator for shared pool
     * @param poolPeriod pool period in seconds
     */
    function createStakingPool(
        address _stakingAddress,
        address _rewardTokenAddress,
        uint256 _stakingTokenDecimals,
        uint256 _rewardTokenDecimals,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _maxStakePerWallet,
        bool isNFT,
        bool isSharedPool,
        uint256 penaltyPercentageN,
        uint256 penaltyPercentageD,
        uint256 bonusPercentageN,
        uint256 bonusPercentageD,
        uint256 poolPeriod
    ) external payable whenNotPaused nonReentrant {
        require(msg.value >= poolCreationFee, "Insufficient fee");
        require(
            _stakingAddress != address(0),
            "Staking address cannot be zero address"
        );
        require(
            _rewardTokenAddress != address(0),
            "Reward token address cannot be zero address"
        );
        require(
            _startDate > block.timestamp,
            "Start date cannot be in the past"
        );
        require(_endDate > _startDate, "End date cannot be before start date");
        require(
            _maxStakePerWallet > 0,
            "Maximum stake per wallet cannot be zero"
        );
        require(
            penaltyPercentageN < penaltyPercentageD,
            "Penalty Numerator cannot be greater than Denominator"
        );
        require(
            bonusPercentageN < bonusPercentageD,
            "Bonus Numerator cannot be greater than Denominator"
        );
        require(poolPeriod > 0, "Pool period cannot be zero");

        uint256 poolId = poolCount;
        stakingPools[poolId] = StakingPool(
            _stakingAddress,
            IERC20(_rewardTokenAddress),
            _stakingTokenDecimals,
            _rewardTokenDecimals,
            0,
            0,
            _startDate,
            _endDate,
            msg.sender,
            _maxStakePerWallet,
            true,
            isNFT,
            isSharedPool,
            penaltyPercentageN,
            penaltyPercentageD,
            bonusPercentageN,
            bonusPercentageD,
            poolPeriod
        );
        // isActivePool[poolId] = true;
        poolCount++;

        emit PoolCreated(poolId);
    }

    /**
     * @dev Function for users to stake tokens
     * @param _poolId pool id to stake in
     * @param amount amount of tokens to stake
     */
    function depositRewardToken(
        uint256 _poolId,
        uint256 amount
    ) public nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        // Check if the staking period is valid
        require(
            block.timestamp <= pool.endDate,
            "Staking Ended, cannot stake."
        );
        // Make sure to approve the contract to spend the tokens beforehand
        require(
            pool.rewardToken.allowance(msg.sender, address(this)) >= amount,
            "Please approve the contract to spend the tokens first"
        );
        // Transfer staking tokens from the user to the contract
        pool.rewardToken.transferFrom(msg.sender, address(this), amount);
        pool.rewardTokenAmount += amount;
    }

    /**
     * @dev Function for users to stake tokens
     * @param _poolId pool id to stake in
     * @param _amount amount of tokens to stake
     */
    function stakeToken(
        uint256 _poolId,
        uint256 _amount
    ) public whenNotPaused nonReentrant {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        // Check if the pool is not NFT
        require(!pool.isNFT, "This function is for Tokens only");
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "The pool isn't active yet."
        );
        // Check if the pool has any reward tokens
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");
        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + _amount <=
                pool.maxStakePerWallet,
            "Maximum Stake Limit exceeded."
        );
        // Make sure to approve the contract to spend the tokens beforehand
        require(
            IERC20(pool.stakingAddress).allowance(msg.sender, address(this)) >=
                _amount,
            "Please approve the contract to spend the tokens first"
        );

        //claim unclaim rewards if any
        if (stakedBalances[msg.sender][_poolId] > 0) {
            _claimToken(
                _poolId,
                msg.sender,
                stakedBalances[msg.sender][_poolId],
                false
            );
        }

        // Transfer staking tokens from the user to the contract
        IERC20(pool.stakingAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        // Calculate staking fee
        uint256 stakingFee = (_amount * stakingFeePercentageNumerator) /
            stakingFeePercentageDenominator;

        // update token withdraw balance
        tokenWithdrawBalances[pool.stakingAddress] += stakingFee;

        // Calculate net staked amount
        uint256 netStakedAmount = _amount - stakingFee;

        // Update user's staked balance
        stakedBalances[msg.sender][_poolId] += netStakedAmount;
        stakingPools[_poolId].totalStaked += netStakedAmount;
        // Update total staked tokens in the pool
        uint256 totalUserStaked = stakedBalances[msg.sender][_poolId];
        // Update user's vault
        vaults[msg.sender][_poolId] = Stake({
            poolId: _poolId,
            tokenId: totalUserStaked,
            timestamp: block.timestamp,
            owner: msg.sender
        });

        // Emit stake event
        emit Staked(msg.sender, _poolId, _amount);
    }

    /**
     * @dev Function for users to stake NFTs
     * @param _poolId pool id to stake in
     * @param tokenIds Array of token ids to stake
     */
    function stakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) public whenNotPaused nonReentrant {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        require(pool.isActive, "This pool is not active");
        // Check if the pool is NFT
        require(pool.isNFT, "This function is for NFT stake only");
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate &&
                block.timestamp <= pool.endDate,
            "The pool isn't active yet."
        );
        // Check if the pool has any reward tokens
        require(pool.rewardTokenAmount > 0, "No reward token in the pool");
        require(tokenIds.length > 0, "No NFT token to stake");

        // Check if the user's staked balance doesn't exceed the maximum allowed
        require(
            stakedBalances[msg.sender][_poolId] + tokenIds.length <=
                pool.maxStakePerWallet,
            "Maximum Stake Limit exceeded."
        );

        IERC721 nft = IERC721(pool.stakingAddress);
        uint256 tokenId;
        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            // check if token is owned by user
            require(nft.ownerOf(tokenId) == msg.sender, "not your token");
            // check if token is approved
            require(nft.getApproved(tokenId) == address(this), "not approved");
            // check if token is not already staked
            require(
                vaults[pool.stakingAddress][tokenId].tokenId == 0,
                "already staked"
            );
            // Transfer staking tokens from the user to the contract
            nft.safeTransferFrom(msg.sender, address(this), tokenId);
            // Update user's staked balance
            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp,
                owner: msg.sender
            });
            emit NFTStaked(msg.sender, _poolId, tokenId);
        }
        // Update total staked tokens in the pool
        stakedBalances[msg.sender][_poolId] += tokenIds.length;
        stakingPools[_poolId].totalStaked += tokenIds.length;
    }

    /**
     * @dev Function for users to unstake tokens
     * @param _poolId pool id to unstake from
     * @param _amount amount of tokens to unstake
     */
    function unstakeToken(
        uint256 _poolId,
        uint256 _amount
    ) external whenNotPaused nonReentrant {
        _claimToken(_poolId, msg.sender, _amount, true);
    }

    /**
     * @dev Function for users to claim reward tokens
     * @param _poolId pool id to claim rewards from
     */
    function claimToken(uint256 _poolId) external nonReentrant whenNotPaused {
        // claim all rewards
        _claimToken(
            _poolId,
            msg.sender,
            stakedBalances[msg.sender][_poolId],
            false
        );
    }

    /**
     * @dev Internal Function to unstake tokens
     * @param _poolId pool id to unstake from
     * @param account address of the user
     * @param _amount amount of tokens to unstake
     */
    function _unstakeToken(
        uint256 _poolId,
        address account,
        uint256 _amount
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from unstaking after the pool is set inactive

        // Check if the user has enough staked tokens
        require(
            stakedBalances[account][_poolId] >= _amount,
            "Insufficient staked balance"
        );
        // Check if the staking period is valid
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );
        // Calculate unstaking fee
        uint256 unstakingFee = (_amount * unstakingFeePercentageNumerator) /
            unstakingFeePercentageDenominator;
        // Calculate penalty for early unstaking
        uint256 penalty = 0;
        if (block.timestamp < pool.endDate) {
            penalty =
                (_amount * pool.penaltyPercentageNumerator) /
                pool.penaltyPercentageDenominator;
        }
        // Calculate net unstaked amount
        uint256 netUnstakedAmount = _amount - unstakingFee - penalty;
        // update token withdraw balance
        tokenWithdrawBalances[pool.stakingAddress] += unstakingFee + penalty;

        // Transfer staking tokens back to the user
        IERC20(pool.stakingAddress).transfer(msg.sender, netUnstakedAmount);
        // Update user's staked balance
        stakedBalances[account][_poolId] -= _amount;
        stakingPools[_poolId].totalStaked -= _amount;
        // update vault
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: stakedBalances[account][_poolId],
            timestamp: block.timestamp, // update timestamp to current time
            owner: account
        });
        emit Unstaked(account, _poolId, _amount, penalty);
    }

    /**
     * @dev Internal Function to claim reward tokens
     * @param _poolId pool id to claim rewards from
     * @param account address of the user
     * @param _amount amount of tokens to unstake
     * @param _unstake true if user wants to unstake
     */
    function _claimToken(
        uint256 _poolId,
        address account,
        uint256 _amount,
        bool _unstake
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // Check if the pool is active
        // require(pool.isActive, "This pool is not active"); adding this check will prevent users from claiming rewards after the pool is set inactive
        // Check if the pool is not NFT
        require(!pool.isNFT, "This function is for Tokens only");
        require(
            block.timestamp >= pool.startDate,
            "Claiming is not allowed before the staking period starts"
        );
        Stake memory staked = vaults[account][_poolId];
        require(staked.timestamp < pool.endDate, "Already claimed");
        // Check if the user has staked tokens
        if (staked.owner == address(0) || staked.tokenId == 0) return;

        // Calculate earned reward tokens
        uint256 earned = 0;
        uint256 _tokenAmountInRewardDecimals = convertAmountToDecimal(
            staked.tokenId,
            pool.stakingTokenDecimals,
            pool.rewardTokenDecimals
        );
        uint256 _periodStaked;
        {
            if (block.timestamp < pool.endDate)
                _periodStaked =
                    (block.timestamp - staked.timestamp) /
                    pool.poolPeriod;
            else
                _periodStaked =
                    (pool.endDate - staked.timestamp) /
                    pool.poolPeriod;
        }
        if (pool.isSharedPool) {
            //reward tokens distributed based on total reward tokens and amount staked
            uint256 totalStakeAmountInRewardDecimals = convertAmountToDecimal(
                pool.totalStaked,
                pool.stakingTokenDecimals,
                pool.rewardTokenDecimals
            );
            earned =
                (_tokenAmountInRewardDecimals *
                    pool.poolPeriod *
                    pool.rewardTokenAmount *
                    _periodStaked) /
                (totalStakeAmountInRewardDecimals *
                    (pool.endDate - pool.startDate));
        } else {
            //reward tokens distributed based on bonus percentage and amount staked
            earned =
                _tokenAmountInRewardDecimals *
                pool.bonusPercentageNumerator *
                _periodStaked;
            earned = earned / pool.bonusPercentageDenominator;
        }
        // update vault
        vaults[account][_poolId] = Stake({
            poolId: _poolId,
            tokenId: staked.tokenId,
            timestamp: block.timestamp, // update timestamp to current time
            owner: account
        });
        // transfer reward tokens to user
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);
            stakingPools[_poolId].rewardTokenAmount -= earned;
        }
        if (_unstake) {
            // unstake tokens if user wants to unstake
            _unstakeToken(_poolId, account, _amount);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    /**
     * @dev Function for users to unstake NFTs
     * @param _poolId pool id to unstake from
     * @param tokenIds Array of token ids to unstake
     */
    function unstakeNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, true);
    }

    /**
     * @dev Function for users to claim reward tokens
     * @param _poolId Pool id to claim rewards from
     * @param tokenIds Array of token ids to claim rewards from
     */
    function claimNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) external nonReentrant whenNotPaused {
        _claimNFT(_poolId, msg.sender, tokenIds, false);
    }

    /**
     * @dev Internal Function to unstake NFTs
     * @param _poolId pool id to unstake from
     * @param account address of the user
     * @param tokenIds Array of token ids to unstake
     */
    function _unstakeNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds
    ) internal {
        uint256 tokenId;
        StakingPool memory pool = stakingPools[_poolId];
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from unstaking after the pool is set inactive
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate,
            "Unstaking is not allowed before the staking period starts"
        );
        // update total staked tokens in the pool
        stakingPools[_poolId].totalStaked -= tokenIds.length;
        // update user's staked balance
        stakedBalances[account][_poolId] -= tokenIds.length;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");

            delete vaults[pool.stakingAddress][tokenId];

            // Transfer staking tokens back to the user
            IERC721(pool.stakingAddress).safeTransferFrom(
                address(this),
                account,
                tokenId
            );
            emit NFTUnstaked(account, _poolId, tokenId);
        }
    }

    /**
     * @dev Internal Function to claim reward tokens
     * @param _poolId pool id to claim rewards from
     * @param account address of the user
     * @param tokenIds Array of token ids to claim rewards from
     * @param _unstake true if user wants to unstake
     */
    function _claimNFT(
        uint256 _poolId,
        address account,
        uint256[] calldata tokenIds,
        bool _unstake
    ) internal {
        StakingPool memory pool = stakingPools[_poolId];
        // require(pool.isActive, "This pool is not active"); // adding this check will prevent users from claiming rewards after the pool is set inactive
        require(pool.isNFT, "This function is for NFT stake only");
        require(
            block.timestamp >= pool.startDate,
            "Claiming is not allowed before the staking period starts"
        );
        uint256 tokenId;
        uint256 earned = 0;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            require(staked.owner == account, "not an owner");
            if (staked.timestamp > pool.endDate) continue; // already claimed

            uint256 _periodStaked;
            {
                if (block.timestamp < pool.endDate)
                    _periodStaked =
                        (block.timestamp - staked.timestamp) /
                        pool.poolPeriod;
                else
                    _periodStaked =
                        (pool.endDate - staked.timestamp) /
                        pool.poolPeriod;
            }
            if (!pool.isSharedPool) {
                // uint256 rewardsPerStakedAmount = totalPoolRewardPerPeriod / pool.totalStaked;
                earned =
                    earned +
                    (pool.poolPeriod * pool.rewardTokenAmount * _periodStaked) /
                    (pool.totalStaked * (pool.endDate - pool.startDate));
            } else {
                // reward tokens distributed based on bonus percentage and amount staked
                earned =
                    earned +
                    (pool.bonusPercentageNumerator * _periodStaked) /
                    pool.bonusPercentageDenominator;
            }
            vaults[pool.stakingAddress][tokenId] = Stake({
                poolId: _poolId,
                tokenId: tokenId,
                timestamp: block.timestamp, // update timestamp to current time
                owner: account
            });
        }
        uint256 penaltyFee = 0;
        uint256 unstakingFee = 0;
        if (_unstake) {
            // calculate penalty
            if (pool.endDate < block.timestamp) {
                penaltyFee =
                    (earned * pool.penaltyPercentageNumerator) /
                    pool.penaltyPercentageDenominator;
            }
            // calculate unstaking fee
            unstakingFee =
                (earned * unstakingFeePercentageNumerator) /
                unstakingFeePercentageDenominator;
            tokenWithdrawBalances[address(pool.rewardToken)] +=
                penaltyFee +
                unstakingFee;
        }
        // calculate net earned amount
        earned = earned - penaltyFee - unstakingFee;
        require(!_unstake || earned > 0, "nothing to unstake or claim");
        if (earned > 0) {
            require(
                pool.rewardTokenAmount >= earned,
                "Not enough reward tokens in the pool"
            );
            pool.rewardToken.transfer(account, earned);

            stakingPools[_poolId].rewardTokenAmount -= earned;
        }
        if (_unstake) {
            _unstakeNFT(_poolId, account, tokenIds);
        }
        emit RewardClaimed(account, _poolId, earned);
    }

    /**
     * @dev Function to convert amount to decimal
     * @param amount amount to convert
     * @param currentDecimals current decimals of the token
     * @param targetDecimals target decimals of the token
     */
    function convertAmountToDecimal(
        uint256 amount,
        uint256 currentDecimals,
        uint256 targetDecimals
    ) public pure returns (uint256) {
        if (currentDecimals == targetDecimals) return amount;
        return (amount * (10 ** targetDecimals)) / (10 ** currentDecimals);
    }

    /**
     * @dev Function to check if a pool exists
     * @param _poolId pool id
     * @return bool true if pool exists, false otherwise
     */
    function poolExists(uint256 _poolId) external view returns (bool) {
        return _poolId < poolCount;
    }

    /**
     * @dev Function to check if a pool is active
     * @param _poolId pool id
     * @return bool true if pool is active, false otherwise
     */
    function poolIsActive(uint256 _poolId) external view returns (bool) {
        return
            stakingPools[_poolId].isActive &&
            block.timestamp >= stakingPools[_poolId].startDate &&
            block.timestamp <= stakingPools[_poolId].endDate;
    }

    /**
     * @dev Function to get pool info
     * @param _poolId pool id
     * @return StakingPool struct
     */
    function getPoolInfo(
        uint256 _poolId
    ) external view returns (StakingPool memory) {
        return stakingPools[_poolId];
    }

    /**
     * @dev Function to get user's reward info for staked nfts
     * @param _poolId pool id
     * @param tokenIds array of token ids
     */
    function earningInfoNFT(
        uint256 _poolId,
        uint256[] calldata tokenIds
    ) public view returns (uint256) {
        uint256 tokenId;
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isNFT == false) return earned;

        for (uint i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vaults[pool.stakingAddress][tokenId];
            if (staked.timestamp > pool.endDate) continue; // already claimed

            uint256 _periodStaked;
            {
                if (block.timestamp < pool.endDate)
                    _periodStaked =
                        (block.timestamp - staked.timestamp) /
                        pool.poolPeriod;
                else
                    _periodStaked =
                        (pool.endDate - staked.timestamp) /
                        pool.poolPeriod;
            }
            if (!pool.isSharedPool) {
                // uint256 rewardsPerStakedAmount = totalPoolRewardPerPeriod / pool.totalStaked;
                earned =
                    earned +
                    (pool.poolPeriod * pool.rewardTokenAmount * _periodStaked) /
                    (pool.totalStaked * (pool.endDate - pool.startDate));
            } else {
                // reward tokens distributed based on bonus percentage and amount staked
                earned =
                    earned +
                    (pool.bonusPercentageNumerator * _periodStaked) /
                    pool.bonusPercentageDenominator;
            }
        }
        return earned;
    }

    /**
     * @dev Function to get user's reward info for staked tokens
     * @param _poolId pool id
     * @param account address of the user
     */
    function earningInfoToken(
        uint256 _poolId,
        address account
    ) public view returns (uint256) {
        uint256 earned = 0;
        StakingPool memory pool = stakingPools[_poolId];
        if (pool.isNFT == true) return earned;
        Stake memory staked = vaults[account][_poolId];
        if (staked.timestamp > pool.endDate) return earned; // already claimed
        uint256 _tokenAmountInRewardDecimals = convertAmountToDecimal(
            staked.tokenId,
            pool.stakingTokenDecimals,
            pool.rewardTokenDecimals
        );
        uint256 _periodStaked;
        {
            if (block.timestamp < pool.endDate)
                _periodStaked =
                    (block.timestamp - staked.timestamp) /
                    pool.poolPeriod;
            else
                _periodStaked =
                    (pool.endDate - staked.timestamp) /
                    pool.poolPeriod;
        }
        if (pool.isSharedPool) {
            //reward tokens distributed based on total reward tokens and amount staked
            uint256 totalStakeAmountInRewardDecimals = convertAmountToDecimal(
                pool.totalStaked,
                pool.stakingTokenDecimals,
                pool.rewardTokenDecimals
            );
            earned =
                (_tokenAmountInRewardDecimals *
                    pool.poolPeriod *
                    pool.rewardTokenAmount *
                    _periodStaked) /
                (totalStakeAmountInRewardDecimals *
                    (pool.endDate - pool.startDate));
        } else {
            //reward tokens distributed based on bonus percentage and amount staked
            earned =
                _tokenAmountInRewardDecimals *
                pool.bonusPercentageNumerator *
                _periodStaked;
            earned = earned / pool.bonusPercentageDenominator;
        }
        return earned;
    }

    /**
     * @dev Changes pool status, can only be called by the creator of the pool.
     * @param _poolId pool id
     * @param status true for active and false for inactive
     */
    function setPoolStatus(uint256 _poolId, bool status) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(
            pool.creator == msg.sender,
            "Only creator can change pool status"
        );
        require(pool.isActive != status, "Pool is already in the same state");
        pool.isActive = status;
        emit PoolStatusChanged(_poolId, status);
    }

    /**
     * @dev withdraws reward tokens from contract, can only be called by the creator of the pool.
     * @param _poolId pool id
     */
    function withdrawStake(uint256 _poolId) external nonReentrant {
        StakingPool storage pool = stakingPools[_poolId];
        require(pool.creator == msg.sender, "Only creator can withdraw");
        require(
            pool.isActive == false || pool.endDate < block.timestamp,
            "Pool is active or not ended yet"
        );
        pool.rewardToken.transfer(msg.sender, pool.rewardTokenAmount);
        pool.rewardTokenAmount = 0;
    }

    /**
     * @dev Withdraws ERC20 tokens from contract, can only be called by the owner.
     * can be used to withdraw staking and reward tokens
     * amount of token to withdraw is tracked in tokenWithdrawBalances mapping
     * @param token address of token to withdraw
     */
    function withdrawToken(address token) external onlyOwner nonReentrant {
        uint256 amount = tokenWithdrawBalances[token];
        require(amount > 0, "No token to withdraw");
        IERC20(token).transfer(msg.sender, amount);
        tokenWithdrawBalances[token] = 0;
    }

    /**
     * @dev Withdraws ETH from contract, can only be called by the owner.
     */
    function withdraw() external onlyOwner nonReentrant {
        payable(msg.sender).transfer(address(this).balance);
    }

    /**
     * @dev pause and unpause contract, can only be called by the owner.
     * @param state true for pause and false for unpause
     */
    function changeContractState(bool state) external onlyOwner {
        if (state == true) _pause();
        else _unpause();
    }

    /**
     * @dev function to receive ERC721 tokens, when safeTransferFrom is called on ERC721 contract
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return
            IERC721Receiver.onERC721Received.selector ^ this.stakeNFT.selector;
    }

    /**
     * @dev set staking fee percentage, can only be called by the owner.
     * @param _stakingFeePercentageN Staking fee percentage nominator
     * @param _stakingFeePercentageD Staking fee percentage dominator
     */
    function setStakingFeePercentage(
        uint256 _stakingFeePercentageN,
        uint256 _stakingFeePercentageD
    ) external onlyOwner {
        require(
            _stakingFeePercentageN < _stakingFeePercentageD,
            "Invalid staking fee percentage"
        );
        stakingFeePercentageNumerator = _stakingFeePercentageN;
        stakingFeePercentageDenominator = _stakingFeePercentageD;
    }

    /**
     * @dev set unstaking fee percentage, can only be called by the owner.
     * @param _unstakingFeePercentageN Unstaking fee percentage nominator
     * @param _unstakingFeePercentageD Unstaking fee percentage dominator
     */
    function setUnstakingFeePercentage(
        uint256 _unstakingFeePercentageN,
        uint256 _unstakingFeePercentageD
    ) external onlyOwner {
        require(
            _unstakingFeePercentageN < _unstakingFeePercentageD,
            "Invalid unstaking fee percentage"
        );
        unstakingFeePercentageNumerator = _unstakingFeePercentageN;
        unstakingFeePercentageDenominator = _unstakingFeePercentageD;
    }

    function getStakingFeePercentage()
        external
        view
        returns (uint256, uint256)
    {
        return (stakingFeePercentageNumerator, stakingFeePercentageDenominator);
    }

    function getUnstakingFeePercentage()
        external
        view
        returns (uint256, uint256)
    {
        return (
            unstakingFeePercentageNumerator,
            unstakingFeePercentageDenominator
        );
    }

    function setPoolCreationFee(uint256 _poolCreationFee) external onlyOwner {
        poolCreationFee = _poolCreationFee;
    }

    function getPoolCreationFee() external view returns (uint256) {
        return poolCreationFee;
    }
}
