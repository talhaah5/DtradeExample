/**
 *Submitted for verification at Etherscan.io on 2020-12-02
*/

/*

⚠⚠⚠ WARNING WARNING WARNING ⚠⚠⚠

This is a TARGET contract - DO NOT CONNECT TO IT DIRECTLY IN YOUR CONTRACTS or DAPPS!

This contract has an associated PROXY that MUST be used for all integrations - this TARGET will be REPLACED in an upcoming dTrade release!
The proxy for this contract can be found here:

https://contracts.dtrade.org/rinkeby/ProxyFeePool

*//*
		________            __   
	___/ /_  __/______ ____/ /__ 
	/ _  / / / / __/ _ `/ _  / -_)
	\_,_/ /_/ /_/  \_,_/\_,_/\__/ 
								
* dTrade: FeePool.sol
*
* Latest source (may be newer): https://github.com/dtradeorg/stakr/tree/master/contracts/contracts/FeePool.sol
* Docs: FeePool
*
* Contract Dependencies: 
*	- EternalStorage
*	- IAddressResolver
*	- LimitedSetup
*	- MixinResolver
*	- Owned
*	- SelfDestructible
*	- State
* Libraries: 
*	- SafeDecimalMath
*	- SafeMath
*
* MIT License
* ===========
*
* Copyright (c) 2020 dTrade
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/



pragma solidity ^0.5.16;

// https://docs.dtrade.org/contracts/Owned
contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor(address _owner) public {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(
            msg.sender == nominatedOwner,
            "You must be nominated before you can accept ownership"
        );
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        _onlyOwner();
        _;
    }

    function _onlyOwner() private view {
        require(
            msg.sender == owner,
            "Only the contract owner may perform this action"
        );
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}


// Inheritance


// Internal references


// https://docs.dtrade.org/contracts/Proxy
contract Proxy is Owned {
    Proxyable public target;

    constructor(address _owner) public Owned(_owner) {}

    function setTarget(Proxyable _target) external onlyOwner {
        target = _target;
        emit TargetUpdated(_target);
    }

    function _emit(
        bytes calldata callData,
        uint256 numTopics,
        bytes32 topic1,
        bytes32 topic2,
        bytes32 topic3,
        bytes32 topic4
    ) external onlyTarget {
        uint256 size = callData.length;
        bytes memory _callData = callData;

        assembly {
            /* The first 32 bytes of callData contain its length (as specified by the abi).
             * Length is assumed to be a uint256 and therefore maximum of 32 bytes
             * in length. It is also leftpadded to be a multiple of 32 bytes.
             * This means moving call_data across 32 bytes guarantees we correctly access
             * the data itself. */
            switch numTopics
                case 0 {
                    log0(add(_callData, 32), size)
                }
                case 1 {
                    log1(add(_callData, 32), size, topic1)
                }
                case 2 {
                    log2(add(_callData, 32), size, topic1, topic2)
                }
                case 3 {
                    log3(add(_callData, 32), size, topic1, topic2, topic3)
                }
                case 4 {
                    log4(
                        add(_callData, 32),
                        size,
                        topic1,
                        topic2,
                        topic3,
                        topic4
                    )
                }
        }
    }

    // solhint-disable no-complex-fallback
    function() external payable {
        // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
        target.setMessageSender(msg.sender);

        assembly {
            let free_ptr := mload(0x40)
            calldatacopy(free_ptr, 0, calldatasize)

            /* We must explicitly forward ether to the underlying contract as well. */
            let result := call(
                gas,
                sload(target_slot),
                callvalue,
                free_ptr,
                calldatasize,
                0,
                0
            )
            returndatacopy(free_ptr, 0, returndatasize)

            if iszero(result) {
                revert(free_ptr, returndatasize)
            }
            return(free_ptr, returndatasize)
        }
    }

    modifier onlyTarget {
        require(Proxyable(msg.sender) == target, "Must be proxy target");
        _;
    }

    event TargetUpdated(Proxyable newTarget);
}


// Inheritance


// Internal references


// https://docs.dtrade.org/contracts/Proxyable
contract Proxyable is Owned {
    // This contract should be treated like an abstract contract

    /* The proxy this contract exists behind. */
    Proxy public proxy;
    Proxy public integrationProxy;

    /* The caller of the proxy, passed through to this contract.
     * Note that every function using this member must apply the onlyProxy or
     * optionalProxy modifiers, otherwise their invocations can use stale values. */
    address public messageSender;

    constructor(address payable _proxy) internal {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");

        proxy = Proxy(_proxy);
        emit ProxyUpdated(_proxy);
    }

    function setProxy(address payable _proxy) external onlyOwner {
        proxy = Proxy(_proxy);
        emit ProxyUpdated(_proxy);
    }

    function setIntegrationProxy(address payable _integrationProxy)
        external
        onlyOwner
    {
        integrationProxy = Proxy(_integrationProxy);
    }

    function setMessageSender(address sender) external onlyProxy {
        messageSender = sender;
    }

    modifier onlyProxy {
        _onlyProxy();
        _;
    }

    function _onlyProxy() private view {
        require(
            Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy,
            "Only the proxy can call"
        );
    }

    modifier optionalProxy {
        _optionalProxy();
        _;
    }

    function _optionalProxy() private {
        if (
            Proxy(msg.sender) != proxy &&
            Proxy(msg.sender) != integrationProxy &&
            messageSender != msg.sender
        ) {
            messageSender = msg.sender;
        }
    }

    modifier optionalProxy_onlyOwner {
        _optionalProxy_onlyOwner();
        _;
    }

    // solhint-disable-next-line func-name-mixedcase
    function _optionalProxy_onlyOwner() private {
        if (
            Proxy(msg.sender) != proxy &&
            Proxy(msg.sender) != integrationProxy &&
            messageSender != msg.sender
        ) {
            messageSender = msg.sender;
        }
        require(messageSender == owner, "Owner only function");
    }

    event ProxyUpdated(address proxyAddress);
}


// Inheritance


// https://docs.dtrade.org/contracts/SelfDestructible
contract SelfDestructible is Owned {
    uint256 public constant SELFDESTRUCT_DELAY = 4 weeks;

    uint256 public initiationTime;
    bool public selfDestructInitiated;

    address public selfDestructBeneficiary;

    constructor() internal {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");
        selfDestructBeneficiary = owner;
        emit SelfDestructBeneficiaryUpdated(owner);
    }

    /**
     * @notice Set the beneficiary address of this contract.
     * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
     * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
     */
    function setSelfDestructBeneficiary(address payable _beneficiary)
        external
        onlyOwner
    {
        require(_beneficiary != address(0), "Beneficiary must not be zero");
        selfDestructBeneficiary = _beneficiary;
        emit SelfDestructBeneficiaryUpdated(_beneficiary);
    }

    /**
     * @notice Begin the self-destruction counter of this contract.
     * Once the delay has elapsed, the contract may be self-destructed.
     * @dev Only the contract owner may call this.
     */
    function initiateSelfDestruct() external onlyOwner {
        initiationTime = now;
        selfDestructInitiated = true;
        emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
    }

    /**
     * @notice Terminate and reset the self-destruction timer.
     * @dev Only the contract owner may call this.
     */
    function terminateSelfDestruct() external onlyOwner {
        initiationTime = 0;
        selfDestructInitiated = false;
        emit SelfDestructTerminated();
    }

    /**
     * @notice If the self-destruction delay has elapsed, destroy this contract and
     * remit any ether it owns to the beneficiary address.
     * @dev Only the contract owner may call this.
     */
    function selfDestruct() external onlyOwner {
        require(selfDestructInitiated, "Self Destruct not yet initiated");
        require(
            initiationTime + SELFDESTRUCT_DELAY < now,
            "Self destruct delay not met"
        );
        emit SelfDestructed(selfDestructBeneficiary);
        selfdestruct(address(uint160(selfDestructBeneficiary)));
    }

    event SelfDestructTerminated();
    event SelfDestructed(address beneficiary);
    event SelfDestructInitiated(uint256 selfDestructDelay);
    event SelfDestructBeneficiaryUpdated(address newBeneficiary);
}


// https://docs.dtrade.org/contracts/LimitedSetup
contract LimitedSetup {
    uint256 public setupExpiryTime;

    /**
     * @dev LimitedSetup Constructor.
     * @param setupDuration The time the setup period will last for.
     */
    constructor(uint256 setupDuration) internal {
        setupExpiryTime = now + setupDuration;
    }

    modifier onlyDuringSetup {
        require(
            now < setupExpiryTime,
            "Can only perform this action during setup"
        );
        _;
    }
}


interface IAddressResolver {
    function getAddress(bytes32 name) external view returns (address);

    function getSynth(bytes32 key) external view returns (address);

    function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
}


interface ISynth {
    // Views
    function currencyKey() external view returns (bytes32);

    function transferableSynths(address account)
        external
        view
        returns (uint256);

    // Mutative functions
    function transferAndSettle(address to, uint256 value)
        external
        returns (bool);

    function transferFromAndSettle(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    // Restricted: used internally to dTrade
    function burn(address account, uint256 amount) external;

    function issue(address account, uint256 amount) external;
}


interface IIssuer {
    // Views
    function anySynthOrDETRateIsInvalid()
        external
        view
        returns (bool anyRateInvalid);

    function availableCurrencyKeys() external view returns (bytes32[] memory);

    function availableSynthCount() external view returns (uint256);

    function availableSynths(uint256 index) external view returns (ISynth);

    function canBurnSynths(address account) external view returns (bool);

    function collateral(address account) external view returns (uint256);

    function collateralisationRatio(address issuer)
        external
        view
        returns (uint256);

    function collateralisationRatioAndAnyRatesInvalid(address _issuer)
        external
        view
        returns (uint256 cratio, bool anyRateIsInvalid);

    function debtBalanceOf(address issuer, bytes32 currencyKey)
        external
        view
        returns (uint256 debtBalance);

    function issuanceRatio() external view returns (uint256);

    function lastIssueEvent(address account) external view returns (uint256);

    function maxIssuableSynths(address issuer)
        external
        view
        returns (uint256 maxIssuable);

    function minimumStakeTime() external view returns (uint256);

    function remainingIssuableSynths(address issuer)
        external
        view
        returns (
            uint256 maxIssuable,
            uint256 alreadyIssued,
            uint256 totalSystemDebt
        );

    function synths(bytes32 currencyKey) external view returns (ISynth);

    function synthsByAddress(address synthAddress)
        external
        view
        returns (bytes32);

    function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral)
        external
        view
        returns (uint256);

    function transferabledTradeAndAnyRateIsInvalid(
        address account,
        uint256 balance
    ) external view returns (uint256 transferable, bool anyRateIsInvalid);

    function getTokenAddress(bytes32 tokenName) external view returns (address);

    // Restricted: used internally to dTrade
    function issueSynths(address from, uint256 amount) external;

    function issueSynthsForERC20(
        address from,
        bytes32 tokenName,
        uint256 amount
    ) external;

    function issueSynthsOnBehalf(
        address issueFor,
        address from,
        uint256 amount
    ) external;

    function issueMaxSynths(address from) external;

    function issueMaxSynthsOnBehalf(address issueFor, address from) external;

    function burnSynths(address from, uint256 amount) external;

    function burnSynthsOnBehalf(
        address burnForAddress,
        address from,
        uint256 amount
    ) external;

    function burnSynthsToTarget(address from) external;

    function getAllowedTokenNames() external view returns (bytes32[] memory);

    function getAllowedTokenNamesAndAddresses() external view returns (bytes32[] memory, address[] memory) ;

    function burnSynthsToTargetOnBehalf(address burnForAddress, address from)
        external;

    function subIssuedSynthsByERC(
        address account,
        bytes32 tokenName,
        uint256 newDebtOwnership,
        uint256 tokenStaked
    ) external;

    function liquidateDelinquentAccount(
        address account,
        uint256 dusdAmount,
        address liquidator
    ) external returns (uint256 totalRedeemed, uint256 amountToLiquidate);
}


// Inheritance


// https://docs.dtrade.org/contracts/AddressResolver
contract AddressResolver is Owned, IAddressResolver {
    mapping(bytes32 => address) public repository;

    constructor(address _owner) public Owned(_owner) {}

    /* ========== MUTATIVE FUNCTIONS ========== */

    function importAddresses(
        bytes32[] calldata names,
        address[] calldata destinations
    ) external onlyOwner {
        require(
            names.length == destinations.length,
            "Input lengths must match"
        );

        for (uint256 i = 0; i < names.length; i++) {
            repository[names[i]] = destinations[i];
        }
    }

    /* ========== VIEWS ========== */

    function getAddress(bytes32 name) external view returns (address) {
        return repository[name];
    }

    function requireAndGetAddress(bytes32 name, string calldata reason)
        external
        view
        returns (address)
    {
        address _foundAddress = repository[name];
        require(_foundAddress != address(0), reason);
        return _foundAddress;
    }

    function getSynth(bytes32 key) external view returns (address) {
        IIssuer issuer = IIssuer(repository["Issuer"]);
        require(address(issuer) != address(0), "Cannot find Issuer address");
        return address(issuer.synths(key));
    }
}


// Inheritance


// Internal references


// https://docs.dtrade.org/contracts/MixinResolver
contract MixinResolver is Owned {
    AddressResolver public resolver;

    mapping(bytes32 => address) private addressCache;

    bytes32[] public resolverAddressesRequired;

    uint256 public constant MAX_ADDRESSES_FROM_RESOLVER = 24;

    constructor(
        address _resolver,
        bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache
    ) internal {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");

        for (uint256 i = 0; i < _addressesToCache.length; i++) {
            if (_addressesToCache[i] != bytes32(0)) {
                resolverAddressesRequired.push(_addressesToCache[i]);
            } else {
                // End early once an empty item is found - assumes there are no empty slots in
                // _addressesToCache
                break;
            }
        }
        resolver = AddressResolver(_resolver);
        // Do not sync the cache as addresses may not be in the resolver yet
    }

    /* ========== SETTERS ========== */
    function setResolverAndSyncCache(AddressResolver _resolver)
        external
        onlyOwner
    {
        resolver = _resolver;

        for (uint256 i = 0; i < resolverAddressesRequired.length; i++) {
            bytes32 name = resolverAddressesRequired[i];
            // Note: can only be invoked once the resolver has all the targets needed added
            addressCache[name] = resolver.requireAndGetAddress(
                name,
                "Resolver missing target"
            );
        }
    }

    /* ========== VIEWS ========== */

    function requireAndGetAddress(bytes32 name, string memory reason)
        internal
        view
        returns (address)
    {
        address _foundAddress = addressCache[name];
        require(_foundAddress != address(0), reason);
        return _foundAddress;
    }

    // Note: this could be made external in a utility contract if addressCache was made public
    // (used for deployment)
    function isResolverCached(AddressResolver _resolver)
        external
        view
        returns (bool)
    {
        if (resolver != _resolver) {
            return false;
        }

        // otherwise, check everything
        for (uint256 i = 0; i < resolverAddressesRequired.length; i++) {
            bytes32 name = resolverAddressesRequired[i];
            // false if our cache is invalid or if the resolver doesn't have the required address
            if (
                resolver.getAddress(name) != addressCache[name] ||
                addressCache[name] == address(0)
            ) {
                return false;
            }
        }

        return true;
    }

    // Note: can be made external into a utility contract (used for deployment)
    function getResolverAddressesRequired()
        external
        view
        returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
    {
        for (uint256 i = 0; i < resolverAddressesRequired.length; i++) {
            addressesRequired[i] = resolverAddressesRequired[i];
        }
    }

    /* ========== INTERNAL FUNCTIONS ========== */
    function appendToAddressCache(bytes32 name) internal {
        resolverAddressesRequired.push(name);
        require(
            resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER,
            "Max resolver cache size met"
        );
        // Because this is designed to be called internally in constructors, we don't
        // check the address exists already in the resolver
        addressCache[name] = resolver.getAddress(name);
    }
}


interface IFlexibleStorage {
    // Views
    function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);

    function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);

    function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);

    function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);

    function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);

    function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);

    function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);

    function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);

    function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);

    function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);

    // Mutative functions
    function deleteUIntValue(bytes32 contractName, bytes32 record) external;

    function deleteIntValue(bytes32 contractName, bytes32 record) external;

    function deleteAddressValue(bytes32 contractName, bytes32 record) external;

    function deleteBoolValue(bytes32 contractName, bytes32 record) external;

    function deleteBytes32Value(bytes32 contractName, bytes32 record) external;

    function setUIntValue(
        bytes32 contractName,
        bytes32 record,
        uint value
    ) external;

    function setUIntValues(
        bytes32 contractName,
        bytes32[] calldata records,
        uint[] calldata values
    ) external;

    function setIntValue(
        bytes32 contractName,
        bytes32 record,
        int value
    ) external;

    function setIntValues(
        bytes32 contractName,
        bytes32[] calldata records,
        int[] calldata values
    ) external;

    function setAddressValue(
        bytes32 contractName,
        bytes32 record,
        address value
    ) external;

    function setAddressValues(
        bytes32 contractName,
        bytes32[] calldata records,
        address[] calldata values
    ) external;

    function setBoolValue(
        bytes32 contractName,
        bytes32 record,
        bool value
    ) external;

    function setBoolValues(
        bytes32 contractName,
        bytes32[] calldata records,
        bool[] calldata values
    ) external;

    function setBytes32Value(
        bytes32 contractName,
        bytes32 record,
        bytes32 value
    ) external;

    function setBytes32Values(
        bytes32 contractName,
        bytes32[] calldata records,
        bytes32[] calldata values
    ) external;
}


// Internal references


contract MixinSystemSettings is MixinResolver {
    bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";

    bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
    bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
    bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
    bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
    bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
    bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
    bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
    bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
    bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
    bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
    bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
    bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
    bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";

    bytes32 private constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";

    constructor() internal {
        appendToAddressCache(CONTRACT_FLEXIBLESTORAGE);
    }

    function flexibleStorage() internal view returns (IFlexibleStorage) {
        return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE, "Missing FlexibleStorage address"));
    }

    function getTradingRewardsEnabled() internal view returns (bool) {
        return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
    }

    function getWaitingPeriodSecs() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
    }

    function getPriceDeviationThresholdFactor() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
    }

    function getIssuanceRatio() internal view returns (uint) {
        // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
    }

    function getFeePeriodDuration() internal view returns (uint) {
        // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
    }

    function getTargetThreshold() internal view returns (uint) {
        // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
    }

    function getLiquidationDelay() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
    }

    function getLiquidationRatio() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
    }

    function getLiquidationPenalty() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
    }

    function getRateStalePeriod() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
    }

    function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
        return
            flexibleStorage().getUIntValue(
                SETTING_CONTRACT_NAME,
                keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
            );
    }

    function getMinimumStakeTime() internal view returns (uint) {
        return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
    }

    function getAggregatorWarningFlags() internal view returns (address) {
        return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
    }
}


interface IFeePool {
    // Views

    // solhint-disable-next-line func-name-mixedcase
    function FEE_ADDRESS() external view returns (address);

    function feesAvailable(address account)
        external
        view
        returns (uint256, uint256);

    function feePeriodDuration() external view returns (uint256);

    function isFeesClaimable(address account) external view returns (bool);

    function targetThreshold() external view returns (uint256);

    function totalFeesAvailable() external view returns (uint256);

    function totalRewardsAvailable() external view returns (uint256);

    // Mutative Functions
    function claimFees() external returns (bool);

    function claimOnBehalf(address claimingForAddress) external returns (bool);

    function closeCurrentFeePeriod() external;

    // Restricted: used internally to dTrade
    function appendAccountIssuanceRecord(
        address account,
        uint256 lockedAmount,
        uint256 debtEntryIndex
    ) external;

    function recordFeePaid(uint256 dUSDAmount) external;

    function setRewardsToDistribute(uint256 amount) external;
}


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


// Libraries


// https://docs.dtrade.org/contracts/SafeDecimalMath
library SafeDecimalMath {
    using SafeMath for uint256;

    /* Number of decimal places in the representations. */
    uint8 public constant decimals = 18;
    uint8 public constant highPrecisionDecimals = 27;

    /* The number representing 1.0. */
    uint256 public constant UNIT = 10**uint256(decimals);

    /* The number representing 1.0 for higher fidelity numbers. */
    uint256 public constant PRECISE_UNIT = 10**uint256(highPrecisionDecimals);
    uint256 private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 **
        uint256(highPrecisionDecimals - decimals);

    /**
     * @return Provides an interface to UNIT.
     */
    function unit() external pure returns (uint256) {
        return UNIT;
    }

    /**
     * @return Provides an interface to PRECISE_UNIT.
     */
    function preciseUnit() external pure returns (uint256) {
        return PRECISE_UNIT;
    }

    /**
     * @return The result of multiplying x and y, interpreting the operands as fixed-point
     * decimals.
     *
     * @dev A unit factor is divided out after the product of x and y is evaluated,
     * so that product must be less than 2**256. As this is an integer division,
     * the internal division always rounds down. This helps save on gas. Rounding
     * is more expensive on gas.
     */
    function multiplyDecimal(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        /* Divide by UNIT to remove the extra factor introduced by the product. */
        return x.mul(y) / UNIT;
    }

    /**
     * @return The result of safely multiplying x and y, interpreting the operands
     * as fixed-point decimals of the specified precision unit.
     *
     * @dev The operands should be in the form of a the specified unit factor which will be
     * divided out after the product of x and y is evaluated, so that product must be
     * less than 2**256.
     *
     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
     * Rounding is useful when you need to retain fidelity for small decimal numbers
     * (eg. small fractions or percentages).
     */
    function _multiplyDecimalRound(
        uint256 x,
        uint256 y,
        uint256 precisionUnit
    ) private pure returns (uint256) {
        /* Divide by UNIT to remove the extra factor introduced by the product. */
        uint256 quotientTimesTen = x.mul(y) / (precisionUnit / 10);

        if (quotientTimesTen % 10 >= 5) {
            quotientTimesTen += 10;
        }

        return quotientTimesTen / 10;
    }

    /**
     * @return The result of safely multiplying x and y, interpreting the operands
     * as fixed-point decimals of a precise unit.
     *
     * @dev The operands should be in the precise unit factor which will be
     * divided out after the product of x and y is evaluated, so that product must be
     * less than 2**256.
     *
     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
     * Rounding is useful when you need to retain fidelity for small decimal numbers
     * (eg. small fractions or percentages).
     */
    function multiplyDecimalRoundPrecise(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return _multiplyDecimalRound(x, y, PRECISE_UNIT);
    }

    /**
     * @return The result of safely multiplying x and y, interpreting the operands
     * as fixed-point decimals of a standard unit.
     *
     * @dev The operands should be in the standard unit factor which will be
     * divided out after the product of x and y is evaluated, so that product must be
     * less than 2**256.
     *
     * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
     * Rounding is useful when you need to retain fidelity for small decimal numbers
     * (eg. small fractions or percentages).
     */
    function multiplyDecimalRound(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return _multiplyDecimalRound(x, y, UNIT);
    }

    /**
     * @return The result of safely dividing x and y. The return value is a high
     * precision decimal.
     *
     * @dev y is divided after the product of x and the standard precision unit
     * is evaluated, so the product of x and UNIT must be less than 2**256. As
     * this is an integer division, the result is always rounded down.
     * This helps save on gas. Rounding is more expensive on gas.
     */
    function divideDecimal(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        /* Reintroduce the UNIT factor that will be divided out by y. */
        return x.mul(UNIT).div(y);
    }

    /**
     * @return The result of safely dividing x and y. The return value is as a rounded
     * decimal in the precision unit specified in the parameter.
     *
     * @dev y is divided after the product of x and the specified precision unit
     * is evaluated, so the product of x and the specified precision unit must
     * be less than 2**256. The result is rounded to the nearest increment.
     */
    function _divideDecimalRound(
        uint256 x,
        uint256 y,
        uint256 precisionUnit
    ) private pure returns (uint256) {
        uint256 resultTimesTen = x.mul(precisionUnit * 10).div(y);

        if (resultTimesTen % 10 >= 5) {
            resultTimesTen += 10;
        }

        return resultTimesTen / 10;
    }

    /**
     * @return The result of safely dividing x and y. The return value is as a rounded
     * standard precision decimal.
     *
     * @dev y is divided after the product of x and the standard precision unit
     * is evaluated, so the product of x and the standard precision unit must
     * be less than 2**256. The result is rounded to the nearest increment.
     */
    function divideDecimalRound(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return _divideDecimalRound(x, y, UNIT);
    }

    /**
     * @return The result of safely dividing x and y. The return value is as a rounded
     * high precision decimal.
     *
     * @dev y is divided after the product of x and the high precision unit
     * is evaluated, so the product of x and the high precision unit must
     * be less than 2**256. The result is rounded to the nearest increment.
     */
    function divideDecimalRoundPrecise(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return _divideDecimalRound(x, y, PRECISE_UNIT);
    }

    /**
     * @dev Convert a standard decimal representation to a high precision one.
     */
    function decimalToPreciseDecimal(uint256 i)
        internal
        pure
        returns (uint256)
    {
        return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
    }

    /**
     * @dev Convert a high precision decimal to a standard decimal representation.
     */
    function preciseDecimalToDecimal(uint256 i)
        internal
        pure
        returns (uint256)
    {
        uint256 quotientTimesTen = i /
            (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);

        if (quotientTimesTen % 10 >= 5) {
            quotientTimesTen += 10;
        }

        return quotientTimesTen / 10;
    }
}


interface IERC20 {
    // ERC20 Optional Views
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    // Views
    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    // Mutative functions
    function transfer(address to, uint value) external returns (bool);

    function approve(address spender, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    // Events
    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);
}


interface ISystemStatus {
    struct Status {
        bool canSuspend;
        bool canResume;
    }

    struct Suspension {
        bool suspended;
        // reason is an integer code,
        // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
        uint248 reason;
    }

    // Views
    function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);

    function requireSystemActive() external view;

    function requireIssuanceActive() external view;

    function requireExchangeActive() external view;

    function requireSynthActive(bytes32 currencyKey) external view;

    function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;

    function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);

    // Restricted functions
    function suspendSynth(bytes32 currencyKey, uint256 reason) external;

    function updateAccessControl(
        bytes32 section,
        address account,
        bool canSuspend,
        bool canResume
    ) external;
}


interface IdTrade {
    // Views
    function anySynthOrDETRateIsInvalid()
        external
        view
        returns (bool anyRateInvalid);

    function availableCurrencyKeys() external view returns (bytes32[] memory);

    function availableSynthCount() external view returns (uint256);

    function availableSynths(uint256 index) external view returns (ISynth);

    function collateral(address account) external view returns (uint256);

    function collateralisationRatio(address issuer)
        external
        view
        returns (uint256);

    function debtBalanceOf(address issuer, bytes32 currencyKey)
        external
        view
        returns (uint256);

    function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);

    function maxIssuableSynths(address issuer)
        external
        view
        returns (uint256 maxIssuable);

    function remainingIssuableSynths(address issuer)
        external
        view
        returns (
            uint256 maxIssuable,
            uint256 alreadyIssued,
            uint256 totalSystemDebt
        );

    function synths(bytes32 currencyKey) external view returns (ISynth);

    function synthsByAddress(address synthAddress)
        external
        view
        returns (bytes32);

    function totalIssuedSynths(bytes32 currencyKey)
        external
        view
        returns (uint256);

    function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey)
        external
        view
        returns (uint256);

    function transferabledTrade(address account)
        external
        view
        returns (uint256 transferable);

    // Mutative Functions
    function burnSynths(uint256 amount) external;

    function burnSynthsOnBehalf(address burnForAddress, uint256 amount)
        external;

    function burnSynthsToTarget() external;

    function burnSynthsToTargetOnBehalf(address burnForAddress) external;

    function exchange(
        bytes32 sourceCurrencyKey,
        uint256 sourceAmount,
        bytes32 destinationCurrencyKey
    ) external returns (uint256 amountReceived);

    function exchangeOnBehalf(
        address exchangeForAddress,
        bytes32 sourceCurrencyKey,
        uint256 sourceAmount,
        bytes32 destinationCurrencyKey
    ) external returns (uint256 amountReceived);

    function exchangeWithTracking(
        bytes32 sourceCurrencyKey,
        uint256 sourceAmount,
        bytes32 destinationCurrencyKey,
        address originator,
        bytes32 trackingCode
    ) external returns (uint256 amountReceived);

    function exchangeOnBehalfWithTracking(
        address exchangeForAddress,
        bytes32 sourceCurrencyKey,
        uint256 sourceAmount,
        bytes32 destinationCurrencyKey,
        address originator,
        bytes32 trackingCode
    ) external returns (uint256 amountReceived);

    function issueMaxSynths() external;

    function issueMaxSynthsOnBehalf(address issueForAddress) external;

    function issueSynths(uint256 amount) external;
    function issueSynthsForERC20(bytes32 tokenName,uint256 amount) external; 

    function issueSynthsOnBehalf(address issueForAddress, uint256 amount)
        external;

    function mint() external returns (bool);

    function settle(bytes32 currencyKey)
        external
        returns (
            uint256 reclaimed,
            uint256 refunded,
            uint256 numEntries
        );


    function checkBackToken(uint256 amount) external returns(uint256);

    function liquidateDelinquentAccount(address account, uint256 dusdAmount)
        external
        returns (bool);
}


// Inheritance


// Libraries


// Internal references


// https://docs.dtrade.org/contracts/FeePoolState
contract FeePoolState is Owned, SelfDestructible, LimitedSetup {
    using SafeMath for uint256;
    using SafeDecimalMath for uint256;

    /* ========== STATE VARIABLES ========== */

    uint8 public constant FEE_PERIOD_LENGTH = 6;

    address public feePool;

    // The IssuanceData activity that's happened in a fee period.
    struct IssuanceData {
        uint256 debtPercentage;
        uint256 debtEntryIndex;
    }

    // The IssuanceData activity that's happened in a fee period.
    mapping(address => IssuanceData[FEE_PERIOD_LENGTH])
        public accountIssuanceLedger;

    constructor(address _owner, IFeePool _feePool)
        public
        Owned(_owner)
        SelfDestructible()
        LimitedSetup(6 weeks)
    {
        feePool = address(_feePool);
    }

    /* ========== SETTERS ========== */

    /**
     * @notice set the FeePool contract as it is the only authority to be able to call
     * appendAccountIssuanceRecord with the onlyFeePool modifer
     * @dev Must be set by owner when FeePool logic is upgraded
     */
    function setFeePool(IFeePool _feePool) external onlyOwner {
        feePool = address(_feePool);
    }

    /* ========== VIEWS ========== */

    /**
     * @notice Get an accounts issuanceData for
     * @param account users account
     * @param index Index in the array to retrieve. Upto FEE_PERIOD_LENGTH
     */
    function getAccountsDebtEntry(address account, uint256 index)
        public
        view
        returns (uint256 debtPercentage, uint256 debtEntryIndex)
    {
        require(
            index < FEE_PERIOD_LENGTH,
            "index exceeds the FEE_PERIOD_LENGTH"
        );

        debtPercentage = accountIssuanceLedger[account][index].debtPercentage;
        debtEntryIndex = accountIssuanceLedger[account][index].debtEntryIndex;
    }

    /**
     * @notice Find the oldest debtEntryIndex for the corresponding closingDebtIndex
     * @param account users account
     * @param closingDebtIndex the last periods debt index on close
     */
    function applicableIssuanceData(address account, uint256 closingDebtIndex)
        external
        view
        returns (uint256, uint256)
    {

            IssuanceData[FEE_PERIOD_LENGTH] memory issuanceData
         = accountIssuanceLedger[account];

        // We want to use the user's debtEntryIndex at when the period closed
        // Find the oldest debtEntryIndex for the corresponding closingDebtIndex
        for (uint256 i = 0; i < FEE_PERIOD_LENGTH; i++) {
            if (closingDebtIndex >= issuanceData[i].debtEntryIndex) {
                return (
                    issuanceData[i].debtPercentage,
                    issuanceData[i].debtEntryIndex
                );
            }
        }
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice Logs an accounts issuance data in the current fee period which is then stored historically
     * @param account Message.Senders account address
     * @param debtRatio Debt of this account as a percentage of the global debt.
     * @param debtEntryIndex The index in the global debt ledger. dtrade.dtradeState().issuanceData(account)
     * @param currentPeriodStartDebtIndex The startingDebtIndex of the current fee period
     * @dev onlyFeePool to call me on dtrade.issue() & dtrade.burn() calls to store the locked DET
     * per fee period so we know to allocate the correct proportions of fees and rewards per period
      accountIssuanceLedger[account][0] has the latest locked amount for the current period. This can be update as many time
      accountIssuanceLedger[account][1-2] has the last locked amount for a previous period they minted or burned
     */
    function appendAccountIssuanceRecord(
        address account,
        uint256 debtRatio,
        uint256 debtEntryIndex,
        uint256 currentPeriodStartDebtIndex
    ) external onlyFeePool {
        // Is the current debtEntryIndex within this fee period
        if (
            accountIssuanceLedger[account][0].debtEntryIndex <
            currentPeriodStartDebtIndex
        ) {
            // If its older then shift the previous IssuanceData entries periods down to make room for the new one.
            issuanceDataIndexOrder(account);
        }

        // Always store the latest IssuanceData entry at [0]
        accountIssuanceLedger[account][0].debtPercentage = debtRatio;
        accountIssuanceLedger[account][0].debtEntryIndex = debtEntryIndex;
    }

    /**
     * @notice Pushes down the entire array of debt ratios per fee period
     */
    function issuanceDataIndexOrder(address account) private {
        for (uint256 i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
            uint256 next = i + 1;
            accountIssuanceLedger[account][next]
                .debtPercentage = accountIssuanceLedger[account][i]
                .debtPercentage;
            accountIssuanceLedger[account][next]
                .debtEntryIndex = accountIssuanceLedger[account][i]
                .debtEntryIndex;
        }
    }

    /**
     * @notice Import issuer data from dtradeState.issuerData on FeePeriodClose() block #
     * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
     * @param accounts Array of issuing addresses
     * @param ratios Array of debt ratios
     * @param periodToInsert The Fee Period to insert the historical records into
     * @param feePeriodCloseIndex An accounts debtEntryIndex is valid when within the fee peroid,
     * since the input ratio will be an average of the pervious periods it just needs to be
     * > recentFeePeriods[periodToInsert].startingDebtIndex
     * < recentFeePeriods[periodToInsert - 1].startingDebtIndex
     */
    function importIssuerData(
        address[] calldata accounts,
        uint256[] calldata ratios,
        uint256 periodToInsert,
        uint256 feePeriodCloseIndex
    ) external onlyOwner onlyDuringSetup {
        require(accounts.length == ratios.length, "Length mismatch");

        for (uint256 i = 0; i < accounts.length; i++) {
            accountIssuanceLedger[accounts[i]][periodToInsert]
                .debtPercentage = ratios[i];
            accountIssuanceLedger[accounts[i]][periodToInsert]
                .debtEntryIndex = feePeriodCloseIndex;
            emit IssuanceDebtRatioEntry(
                accounts[i],
                ratios[i],
                feePeriodCloseIndex
            );
        }
    }

    /* ========== MODIFIERS ========== */

    modifier onlyFeePool {
        require(
            msg.sender == address(feePool),
            "Only the FeePool contract can perform this action"
        );
        _;
    }

    /* ========== Events ========== */
    event IssuanceDebtRatioEntry(
        address indexed account,
        uint256 debtRatio,
        uint256 feePeriodCloseIndex
    );
}


// Inheritance


// https://docs.dtrade.org/contracts/State
contract State is Owned {
    // the address of the contract that can modify variables
    // this can only be changed by the owner of this contract
    address public associatedContract;

    constructor(address _associatedContract) internal {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner != address(0), "Owner must be set");

        associatedContract = _associatedContract;
        emit AssociatedContractUpdated(_associatedContract);
    }

    /* ========== SETTERS ========== */

    // Change the associated contract to a new address
    function setAssociatedContract(address _associatedContract)
        external
        onlyOwner
    {
        associatedContract = _associatedContract;
        emit AssociatedContractUpdated(_associatedContract);
    }

    /* ========== MODIFIERS ========== */

    modifier onlyAssociatedContract {
        require(
            msg.sender == associatedContract,
            "Only the associated contract can perform this action"
        );
        _;
    }

    /* ========== EVENTS ========== */

    event AssociatedContractUpdated(address associatedContract);
}


// Inheritance


/**
 * @notice  This contract is based on the code available from this blog
 * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
 * Implements support for storing a keccak256 key and value pairs. It is the more flexible
 * and extensible option. This ensures data schema changes can be implemented without
 * requiring upgrades to the storage contract.
 */
// https://docs.dtrade.org/contracts/EternalStorage
contract EternalStorage is Owned, State {
    constructor(address _owner, address _associatedContract)
        public
        Owned(_owner)
        State(_associatedContract)
    {}

    /* ========== DATA TYPES ========== */
    mapping(bytes32 => uint256) internal UIntStorage;
    mapping(bytes32 => string) internal StringStorage;
    mapping(bytes32 => address) internal AddressStorage;
    mapping(bytes32 => bytes) internal BytesStorage;
    mapping(bytes32 => bytes32) internal Bytes32Storage;
    mapping(bytes32 => bool) internal BooleanStorage;
    mapping(bytes32 => int256) internal IntStorage;

    // UIntStorage;
    function getUIntValue(bytes32 record) external view returns (uint256) {
        return UIntStorage[record];
    }

    function setUIntValue(bytes32 record, uint256 value)
        external
        onlyAssociatedContract
    {
        UIntStorage[record] = value;
    }

    function deleteUIntValue(bytes32 record) external onlyAssociatedContract {
        delete UIntStorage[record];
    }

    // StringStorage
    function getStringValue(bytes32 record)
        external
        view
        returns (string memory)
    {
        return StringStorage[record];
    }

    function setStringValue(bytes32 record, string calldata value)
        external
        onlyAssociatedContract
    {
        StringStorage[record] = value;
    }

    function deleteStringValue(bytes32 record) external onlyAssociatedContract {
        delete StringStorage[record];
    }

    // AddressStorage
    function getAddressValue(bytes32 record) external view returns (address) {
        return AddressStorage[record];
    }

    function setAddressValue(bytes32 record, address value)
        external
        onlyAssociatedContract
    {
        AddressStorage[record] = value;
    }

    function deleteAddressValue(bytes32 record)
        external
        onlyAssociatedContract
    {
        delete AddressStorage[record];
    }

    // BytesStorage
    function getBytesValue(bytes32 record)
        external
        view
        returns (bytes memory)
    {
        return BytesStorage[record];
    }

    function setBytesValue(bytes32 record, bytes calldata value)
        external
        onlyAssociatedContract
    {
        BytesStorage[record] = value;
    }

    function deleteBytesValue(bytes32 record) external onlyAssociatedContract {
        delete BytesStorage[record];
    }

    // Bytes32Storage
    function getBytes32Value(bytes32 record) external view returns (bytes32) {
        return Bytes32Storage[record];
    }

    function setBytes32Value(bytes32 record, bytes32 value)
        external
        onlyAssociatedContract
    {
        Bytes32Storage[record] = value;
    }

    function deleteBytes32Value(bytes32 record)
        external
        onlyAssociatedContract
    {
        delete Bytes32Storage[record];
    }

    // BooleanStorage
    function getBooleanValue(bytes32 record) external view returns (bool) {
        return BooleanStorage[record];
    }

    function setBooleanValue(bytes32 record, bool value)
        external
        onlyAssociatedContract
    {
        BooleanStorage[record] = value;
    }

    function deleteBooleanValue(bytes32 record)
        external
        onlyAssociatedContract
    {
        delete BooleanStorage[record];
    }

    // IntStorage
    function getIntValue(bytes32 record) external view returns (int256) {
        return IntStorage[record];
    }

    function setIntValue(bytes32 record, int256 value)
        external
        onlyAssociatedContract
    {
        IntStorage[record] = value;
    }

    function deleteIntValue(bytes32 record) external onlyAssociatedContract {
        delete IntStorage[record];
    }
}


// Inheritance


// https://docs.dtrade.org/contracts/FeePoolEternalStorage
contract FeePoolEternalStorage is EternalStorage, LimitedSetup {
    bytes32 internal constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";

    constructor(address _owner, address _feePool)
        public
        EternalStorage(_owner, _feePool)
        LimitedSetup(6 weeks)
    {}

    function importFeeWithdrawalData(
        address[] calldata accounts,
        uint256[] calldata feePeriodIDs
    ) external onlyOwner onlyDuringSetup {
        require(accounts.length == feePeriodIDs.length, "Length mismatch");

        for (uint8 i = 0; i < accounts.length; i++) {
            this.setUIntValue(
                keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, accounts[i])),
                feePeriodIDs[i]
            );
        }
    }
}


interface IExchanger {
    // Views
    function calculateAmountAfterSettlement(
        address from,
        bytes32 currencyKey,
        uint amount,
        uint refunded
    ) external view returns (uint amountAfterSettlement);

    function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);

    function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);

    function settlementOwing(address account, bytes32 currencyKey)
        external
        view
        returns (
            uint reclaimAmount,
            uint rebateAmount,
            uint numEntries
        );

    function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);

    function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
        external
        view
        returns (uint exchangeFeeRate);

    function getAmountsForExchange(
        uint sourceAmount,
        bytes32 sourceCurrencyKey,
        bytes32 destinationCurrencyKey
    )
        external
        view
        returns (
            uint amountReceived,
            uint fee,
            uint exchangeFeeRate
        );

    function priceDeviationThresholdFactor() external view returns (uint);

    function waitingPeriodSecs() external view returns (uint);

    // Mutative functions
    function exchange(
        address from,
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey,
        address destinationAddress
    ) external returns (uint amountReceived);

    function exchangeOnBehalf(
        address exchangeForAddress,
        address from,
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey
    ) external returns (uint amountReceived);

    function exchangeWithTracking(
        address from,
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey,
        address destinationAddress,
        address originator,
        bytes32 trackingCode
    ) external returns (uint amountReceived);

    function exchangeOnBehalfWithTracking(
        address exchangeForAddress,
        address from,
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey,
        address originator,
        bytes32 trackingCode
    ) external returns (uint amountReceived);

    function settle(address from, bytes32 currencyKey)
        external
        returns (
            uint reclaimed,
            uint refunded,
            uint numEntries
        );

    function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;

    function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
}


interface IdTradeState {
    // Views
    function debtLedger(uint256 index) external view returns (uint256);

    function issuanceData(address account)
        external
        view
        returns (uint256 initialDebtOwnership, uint256 debtEntryIndex);

    function debtLedgerLength() external view returns (uint256);

    function hasIssued(address account) external view returns (bool);

    function lastDebtLedgerEntry() external view returns (uint256);

    // Mutative functions
    function incrementTotalIssuerCount() external;

    function decrementTotalIssuerCount() external;

    function setCurrentIssuanceData(
        address account,
        uint256 initialDebtOwnership
    ) external;

    function addIssuedSynthsByERC(
        address account,
        bytes32 tokenName,
        uint256 newDebtOwnership,
        uint256 tokenStaked
    ) external;
    
    function subIssuedSynthsByERC(
        address account,
        bytes32 tokenName,
        uint256 newDebtOwnership,
        uint256 tokenStaked
    ) external;

    function appendDebtLedgerValue(uint256 value) external;

    function clearIssuanceData(address account) external;

    function getTokenIssuanceState(address account, bytes32 tokenName)
        external
        view
        returns (uint256, uint256);
}


interface IRewardEscrow {
    // Views
    function balanceOf(address account) external view returns (uint);

    function numVestingEntries(address account) external view returns (uint);

    function totalEscrowedAccountBalance(address account) external view returns (uint);

    function totalVestedAccountBalance(address account) external view returns (uint);

    // Mutative functions
    function appendVestingEntry(address account, uint quantity) external;

    function vest() external;
}


interface IDelegateApprovals {
    // Views
    function canBurnFor(address authoriser, address delegate) external view returns (bool);

    function canIssueFor(address authoriser, address delegate) external view returns (bool);

    function canClaimFor(address authoriser, address delegate) external view returns (bool);

    function canExchangeFor(address authoriser, address delegate) external view returns (bool);

    // Mutative
    function approveAllDelegatePowers(address delegate) external;

    function removeAllDelegatePowers(address delegate) external;

    function approveBurnOnBehalf(address delegate) external;

    function removeBurnOnBehalf(address delegate) external;

    function approveIssueOnBehalf(address delegate) external;

    function removeIssueOnBehalf(address delegate) external;

    function approveClaimOnBehalf(address delegate) external;

    function removeClaimOnBehalf(address delegate) external;

    function approveExchangeOnBehalf(address delegate) external;

    function removeExchangeOnBehalf(address delegate) external;
}


interface IRewardsDistribution {
    // Structs
    struct DistributionData {
        address destination;
        uint amount;
    }

    // Views
    function authority() external view returns (address);

    function distributions(uint index) external view returns (address destination, uint amount); // DistributionData

    function distributionsLength() external view returns (uint);

    // Mutative Functions
    function distributeRewards(uint amount) external returns (bool);
}


interface IEtherCollateraldUSD {
    // Views
    function totalIssuedSynths() external view returns (uint256);

    function totalLoansCreated() external view returns (uint256);

    function totalOpenLoanCount() external view returns (uint256);

    // Mutative functions
    function openLoan(uint256 _loanAmount)
        external
        payable
        returns (uint256 loanID);

    function closeLoan(uint256 loanID) external;

    function liquidateUnclosedLoan(
        address _loanCreatorsAddress,
        uint256 _loanID
    ) external;

    function depositCollateral(address account, uint256 loanID)
        external
        payable;

    function withdrawCollateral(uint256 loanID, uint256 withdrawAmount)
        external;

    function repayLoan(
        address _loanCreatorsAddress,
        uint256 _loanID,
        uint256 _repayAmount
    ) external;
}


// Inheritance


// Libraries


// Internal references


// https://docs.dtrade.org/contracts/FeePool
contract FeePool is
    Owned,
    Proxyable,
    SelfDestructible,
    LimitedSetup,
    MixinResolver,
    MixinSystemSettings,
    IFeePool
{
    using SafeMath for uint256;
    using SafeDecimalMath for uint256;

    // Where fees are pooled in dUSD.
    address
        public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;

    // dUSD currencyKey. Fees stored and paid in dUSD
    bytes32 private dUSD = "dUSD";

    // This struct represents the issuance activity that's happened in a fee period.
    struct FeePeriod {
        uint64 feePeriodId;
        uint64 startingDebtIndex;
        uint64 startTime;
        uint256 feesToDistribute;
        uint256 feesClaimed;
        uint256 rewardsToDistribute;
        uint256 rewardsClaimed;
    }

    // A staker(mintr) can claim from the previous fee period (7 days) only.
    // Fee Periods stored and managed from [0], such that [0] is always
    // the current active fee period which is not claimable until the
    // public function closeCurrentFeePeriod() is called closing the
    // current weeks collected fees. [1] is last weeks feeperiod
    uint8 public constant FEE_PERIOD_LENGTH = 2;

    FeePeriod[FEE_PERIOD_LENGTH] private _recentFeePeriods;
    uint256 private _currentFeePeriod;

    /* ========== ADDRESS RESOLVER CONFIGURATION ========== */

    bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
    bytes32 private constant CONTRACT_DTRADE = "dTrade";
    bytes32 private constant CONTRACT_FEEPOOLSTATE = "FeePoolState";
    bytes32
        private constant CONTRACT_FEEPOOLETERNALSTORAGE = "FeePoolEternalStorage";
    bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
    bytes32 private constant CONTRACT_ISSUER = "Issuer";
    bytes32 private constant CONTRACT_DTRADESTATE = "dTradeState";
    bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrow";
    bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
    bytes32
        private constant CONTRACT_ETH_COLLATERAL_SUSD = "EtherCollateraldUSD";
    bytes32
        private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";

    bytes32[24] private addressesToCache = [
        CONTRACT_SYSTEMSTATUS,
        CONTRACT_DTRADE,
        CONTRACT_FEEPOOLSTATE,
        CONTRACT_FEEPOOLETERNALSTORAGE,
        CONTRACT_EXCHANGER,
        CONTRACT_ISSUER,
        CONTRACT_DTRADESTATE,
        CONTRACT_REWARDESCROW,
        CONTRACT_DELEGATEAPPROVALS,
        CONTRACT_ETH_COLLATERAL_SUSD,
        CONTRACT_REWARDSDISTRIBUTION
    ];

    /* ========== ETERNAL STORAGE CONSTANTS ========== */

    bytes32 private constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";

    constructor(
        address payable _proxy,
        address _owner,
        address _resolver
    )
        public
        Owned(_owner)
        SelfDestructible()
        Proxyable(_proxy)
        LimitedSetup(3 weeks)
        MixinResolver(_resolver, addressesToCache)
        MixinSystemSettings()
    {
        // Set our initial fee period
        _recentFeePeriodsStorage(0).feePeriodId = 1;
        _recentFeePeriodsStorage(0).startTime = uint64(now);
    }

    /* ========== VIEWS ========== */

    function systemStatus() internal view returns (ISystemStatus) {
        return
            ISystemStatus(
                requireAndGetAddress(
                    CONTRACT_SYSTEMSTATUS,
                    "Missing SystemStatus address"
                )
            );
    }

    function dtrade() internal view returns (IdTrade) {
        return
            IdTrade(
                requireAndGetAddress(CONTRACT_DTRADE, "Missing dTrade address")
            );
    }

    function feePoolState() internal view returns (FeePoolState) {
        return
            FeePoolState(
                requireAndGetAddress(
                    CONTRACT_FEEPOOLSTATE,
                    "Missing FeePoolState address"
                )
            );
    }

    function feePoolEternalStorage()
        internal
        view
        returns (FeePoolEternalStorage)
    {
        return
            FeePoolEternalStorage(
                requireAndGetAddress(
                    CONTRACT_FEEPOOLETERNALSTORAGE,
                    "Missing FeePoolEternalStorage address"
                )
            );
    }

    function exchanger() internal view returns (IExchanger) {
        return
            IExchanger(
                requireAndGetAddress(
                    CONTRACT_EXCHANGER,
                    "Missing Exchanger address"
                )
            );
    }

    function etherCollateraldUSD()
        internal
        view
        returns (IEtherCollateraldUSD)
    {
        return
            IEtherCollateraldUSD(
                requireAndGetAddress(
                    CONTRACT_ETH_COLLATERAL_SUSD,
                    "Missing EtherCollateraldUSD address"
                )
            );
    }

    function issuer() internal view returns (IIssuer) {
        return
            IIssuer(
                requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address")
            );
    }

    function dtradeState() internal view returns (IdTradeState) {
        return
            IdTradeState(
                requireAndGetAddress(
                    CONTRACT_DTRADESTATE,
                    "Missing dTradeState address"
                )
            );
    }

    function rewardEscrow() internal view returns (IRewardEscrow) {
        return
            IRewardEscrow(
                requireAndGetAddress(
                    CONTRACT_REWARDESCROW,
                    "Missing RewardEscrow address"
                )
            );
    }

    function delegateApprovals() internal view returns (IDelegateApprovals) {
        return
            IDelegateApprovals(
                requireAndGetAddress(
                    CONTRACT_DELEGATEAPPROVALS,
                    "Missing DelegateApprovals address"
                )
            );
    }

    function rewardsDistribution()
        internal
        view
        returns (IRewardsDistribution)
    {
        return
            IRewardsDistribution(
                requireAndGetAddress(
                    CONTRACT_REWARDSDISTRIBUTION,
                    "Missing RewardsDistribution address"
                )
            );
    }

    function issuanceRatio() external view returns (uint256) {
        return getIssuanceRatio();
    }

    function feePeriodDuration() external view returns (uint256) {
        return getFeePeriodDuration();
    }

    function targetThreshold() external view returns (uint256) {
        return getTargetThreshold();
    }

    function recentFeePeriods(uint256 index)
        external
        view
        returns (
            uint64 feePeriodId,
            uint64 startingDebtIndex,
            uint64 startTime,
            uint256 feesToDistribute,
            uint256 feesClaimed,
            uint256 rewardsToDistribute,
            uint256 rewardsClaimed
        )
    {
        FeePeriod memory feePeriod = _recentFeePeriodsStorage(index);
        return (
            feePeriod.feePeriodId,
            feePeriod.startingDebtIndex,
            feePeriod.startTime,
            feePeriod.feesToDistribute,
            feePeriod.feesClaimed,
            feePeriod.rewardsToDistribute,
            feePeriod.rewardsClaimed
        );
    }

    function _recentFeePeriodsStorage(uint256 index)
        internal
        view
        returns (FeePeriod storage)
    {
        return
            _recentFeePeriods[(_currentFeePeriod + index) % FEE_PERIOD_LENGTH];
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice Logs an accounts issuance data per fee period
     * @param account Message.Senders account address
     * @param debtRatio Debt percentage this account has locked after minting or burning their synth
     * @param debtEntryIndex The index in the global debt ledger. dtradeState.issuanceData(account)
     * @dev onlyIssuer to call me on dtrade.issue() & dtrade.burn() calls to store the locked DET
     * per fee period so we know to allocate the correct proportions of fees and rewards per period
     */
    function appendAccountIssuanceRecord(
        address account,
        uint256 debtRatio,
        uint256 debtEntryIndex
    ) external onlyIssuer {
        feePoolState().appendAccountIssuanceRecord(
            account,
            debtRatio,
            debtEntryIndex,
            _recentFeePeriodsStorage(0).startingDebtIndex
        );

        emitIssuanceDebtRatioEntry(
            account,
            debtRatio,
            debtEntryIndex,
            _recentFeePeriodsStorage(0).startingDebtIndex
        );
    }

    /**
     * @notice The Exchanger contract informs us when fees are paid.
     * @param amount dusd amount in fees being paid.
     */
    function recordFeePaid(uint256 amount) external onlyInternalContracts {
        // Keep track off fees in dUSD in the open fee pool period.
        _recentFeePeriodsStorage(0).feesToDistribute = _recentFeePeriodsStorage(
            0
        )
            .feesToDistribute
            .add(amount);
    }

    /**
     * @notice The RewardsDistribution contract informs us how many DET rewards are sent to RewardEscrow to be claimed.
     */
    function setRewardsToDistribute(uint256 amount) external {
        address rewardsAuthority = address(rewardsDistribution());
        require(
            messageSender == rewardsAuthority || msg.sender == rewardsAuthority,
            "Caller is not rewardsAuthority"
        );
        // Add the amount of DET rewards to distribute on top of any rolling unclaimed amount
        _recentFeePeriodsStorage(0)
            .rewardsToDistribute = _recentFeePeriodsStorage(0)
            .rewardsToDistribute
            .add(amount);
    }

    /**
     * @notice Close the current fee period and start a new one.
     */
    function closeCurrentFeePeriod() external issuanceActive {
        require(getFeePeriodDuration() > 0, "Fee Period Duration not set");
        require(
            _recentFeePeriodsStorage(0).startTime <=
                (now - getFeePeriodDuration()),
            "Too early to close fee period"
        );

        // Note:  when FEE_PERIOD_LENGTH = 2, periodClosing is the current period & periodToRollover is the last open claimable period
        FeePeriod storage periodClosing = _recentFeePeriodsStorage(
            FEE_PERIOD_LENGTH - 2
        );
        FeePeriod storage periodToRollover = _recentFeePeriodsStorage(
            FEE_PERIOD_LENGTH - 1
        );

        // Any unclaimed fees from the last period in the array roll back one period.
        // Because of the subtraction here, they're effectively proportionally redistributed to those who
        // have already claimed from the old period, available in the new period.
        // The subtraction is important so we don't create a ticking time bomb of an ever growing
        // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
        _recentFeePeriodsStorage(FEE_PERIOD_LENGTH - 2)
            .feesToDistribute = periodToRollover
            .feesToDistribute
            .sub(periodToRollover.feesClaimed)
            .add(periodClosing.feesToDistribute);
        _recentFeePeriodsStorage(FEE_PERIOD_LENGTH - 2)
            .rewardsToDistribute = periodToRollover
            .rewardsToDistribute
            .sub(periodToRollover.rewardsClaimed)
            .add(periodClosing.rewardsToDistribute);

        // Shift the previous fee periods across to make room for the new one.
        _currentFeePeriod = _currentFeePeriod.add(FEE_PERIOD_LENGTH).sub(1).mod(
            FEE_PERIOD_LENGTH
        );

        // Clear the first element of the array to make sure we don't have any stale values.
        delete _recentFeePeriods[_currentFeePeriod];

        // Open up the new fee period.
        // Increment periodId from the recent closed period feePeriodId
        _recentFeePeriodsStorage(0).feePeriodId = uint64(
            uint256(_recentFeePeriodsStorage(1).feePeriodId).add(1)
        );
        _recentFeePeriodsStorage(0).startingDebtIndex = uint64(
            dtradeState().debtLedgerLength()
        );
        _recentFeePeriodsStorage(0).startTime = uint64(now);

        emitFeePeriodClosed(_recentFeePeriodsStorage(1).feePeriodId);
    }

    /**
     * @notice Claim fees for last period when available or not already withdrawn.
     */
    function claimFees() external issuanceActive optionalProxy returns (bool) {
        return _claimFees(messageSender);
    }

    /**
     * @notice Delegated claimFees(). Call from the deletegated address
     * and the fees will be sent to the claimingForAddress.
     * approveClaimOnBehalf() must be called first to approve the deletage address
     * @param claimingForAddress The account you are claiming fees for
     */
    function claimOnBehalf(address claimingForAddress)
        external
        issuanceActive
        optionalProxy
        returns (bool)
    {
        require(
            delegateApprovals().canClaimFor(claimingForAddress, messageSender),
            "Not approved to claim on behalf"
        );

        return _claimFees(claimingForAddress);
    }

    function _claimFees(address claimingAddress) internal returns (bool) {
        uint256 rewardsPaid = 0;
        uint256 feesPaid = 0;
        uint256 availableFees;
        uint256 availableRewards;

        // Address won't be able to claim fees if it is too far below the target c-ratio.
        // It will need to burn synths then try claiming again.
        (
            bool feesClaimable,
            bool anyRateIsInvalid
        ) = _isFeesClaimableAndAnyRatesInvalid(claimingAddress);

        require(feesClaimable, "C-Ratio below penalty threshold");

        require(!anyRateIsInvalid, "A synth or DET rate is invalid");

        // Get the claimingAddress available fees and rewards
        (availableFees, availableRewards) = feesAvailable(claimingAddress);

        require(
            availableFees > 0 || availableRewards > 0,
            "No fees or rewards available for period, or fees already claimed"
        );

        // Record the address has claimed for this period
        _setLastFeeWithdrawal(
            claimingAddress,
            _recentFeePeriodsStorage(1).feePeriodId
        );

        if (availableFees > 0) {
            // Record the fee payment in our recentFeePeriods
            feesPaid = _recordFeePayment(availableFees);

            // Send them their fees
            _payFees(claimingAddress, feesPaid);
        }

        if (availableRewards > 0) {
            // Record the reward payment in our recentFeePeriods
            rewardsPaid = _recordRewardPayment(availableRewards);

            // Send them their rewards
            _payRewards(claimingAddress, rewardsPaid);
        }

        emitFeesClaimed(claimingAddress, feesPaid, rewardsPaid);

        return true;
    }

    /**
     * @notice Admin function to import the FeePeriod data from the previous contract
     */
    function importFeePeriod(
        uint256 feePeriodIndex,
        uint256 feePeriodId,
        uint256 startingDebtIndex,
        uint256 startTime,
        uint256 feesToDistribute,
        uint256 feesClaimed,
        uint256 rewardsToDistribute,
        uint256 rewardsClaimed
    ) public optionalProxy_onlyOwner onlyDuringSetup {
        require(
            startingDebtIndex <= dtradeState().debtLedgerLength(),
            "Cannot import bad data"
        );

        _recentFeePeriods[_currentFeePeriod.add(feePeriodIndex).mod(
            FEE_PERIOD_LENGTH
        )] = FeePeriod({
            feePeriodId: uint64(feePeriodId),
            startingDebtIndex: uint64(startingDebtIndex),
            startTime: uint64(startTime),
            feesToDistribute: feesToDistribute,
            feesClaimed: feesClaimed,
            rewardsToDistribute: rewardsToDistribute,
            rewardsClaimed: rewardsClaimed
        });
    }

    /**
     * @notice Owner can escrow DET. Owner to send the tokens to the RewardEscrow
     * @param account Address to escrow tokens for
     * @param quantity Amount of tokens to escrow
     */
    function appendVestingEntry(address account, uint256 quantity)
        public
        optionalProxy_onlyOwner
    {
        // Transfer DET from messageSender to the Reward Escrow
        IERC20(address(dtrade())).transferFrom(
            messageSender,
            address(rewardEscrow()),
            quantity
        );

        // Create Vesting Entry
        rewardEscrow().appendVestingEntry(account, quantity);
    }

    /**
     * @notice Record the fee payment in our recentFeePeriods.
     * @param dUSDAmount The amount of fees priced in dUSD.
     */
    function _recordFeePayment(uint256 dUSDAmount) internal returns (uint256) {
        // Don't assign to the parameter
        uint256 remainingToAllocate = dUSDAmount;

        uint256 feesPaid;
        // Start at the oldest period and record the amount, moving to newer periods
        // until we've exhausted the amount.
        // The condition checks for overflow because we're going to 0 with an unsigned int.
        for (uint256 i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
            uint256 feesAlreadyClaimed = _recentFeePeriodsStorage(i)
                .feesClaimed;
            uint256 delta = _recentFeePeriodsStorage(i).feesToDistribute.sub(
                feesAlreadyClaimed
            );

            if (delta > 0) {
                // Take the smaller of the amount left to claim in the period and the amount we need to allocate
                uint256 amountInPeriod = delta < remainingToAllocate
                    ? delta
                    : remainingToAllocate;

                _recentFeePeriodsStorage(i).feesClaimed = feesAlreadyClaimed
                    .add(amountInPeriod);
                remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
                feesPaid = feesPaid.add(amountInPeriod);

                // No need to continue iterating if we've recorded the whole amount;
                if (remainingToAllocate == 0) return feesPaid;

                // We've exhausted feePeriods to distribute and no fees remain in last period
                // User last to claim would in this scenario have their remainder slashed
                if (i == 0 && remainingToAllocate > 0) {
                    remainingToAllocate = 0;
                }
            }
        }

        return feesPaid;
    }

    /**
     * @notice Record the reward payment in our recentFeePeriods.
     * @param detAmount The amount of DET tokens.
     */
    function _recordRewardPayment(uint256 detAmount)
        internal
        returns (uint256)
    {
        // Don't assign to the parameter
        uint256 remainingToAllocate = detAmount;

        uint256 rewardPaid;

        // Start at the oldest period and record the amount, moving to newer periods
        // until we've exhausted the amount.
        // The condition checks for overflow because we're going to 0 with an unsigned int.
        for (uint256 i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
            uint256 toDistribute = _recentFeePeriodsStorage(i)
                .rewardsToDistribute
                .sub(_recentFeePeriodsStorage(i).rewardsClaimed);

            if (toDistribute > 0) {
                // Take the smaller of the amount left to claim in the period and the amount we need to allocate
                uint256 amountInPeriod = toDistribute < remainingToAllocate
                    ? toDistribute
                    : remainingToAllocate;

                _recentFeePeriodsStorage(i)
                    .rewardsClaimed = _recentFeePeriodsStorage(i)
                    .rewardsClaimed
                    .add(amountInPeriod);
                remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
                rewardPaid = rewardPaid.add(amountInPeriod);

                // No need to continue iterating if we've recorded the whole amount;
                if (remainingToAllocate == 0) return rewardPaid;

                // We've exhausted feePeriods to distribute and no rewards remain in last period
                // User last to claim would in this scenario have their remainder slashed
                // due to rounding up of PreciseDecimal
                if (i == 0 && remainingToAllocate > 0) {
                    remainingToAllocate = 0;
                }
            }
        }
        return rewardPaid;
    }

    /**
     * @notice Send the fees to claiming address.
     * @param account The address to send the fees to.
     * @param dUSDAmount The amount of fees priced in dUSD.
     */
    function _payFees(address account, uint256 dUSDAmount)
        internal
        notFeeAddress(account)
    {
        // Grab the dUSD Synth
        ISynth dUSDSynth = issuer().synths(dUSD);

        // NOTE: we do not control the FEE_ADDRESS so it is not possible to do an
        // ERC20.approve() transaction to allow this feePool to call ERC20.transferFrom
        // to the accounts address

        // Burn the source amount
        dUSDSynth.burn(FEE_ADDRESS, dUSDAmount);

        // Mint their new synths
        dUSDSynth.issue(account, dUSDAmount);
    }

    /**
     * @notice Send the rewards to claiming address - will be locked in rewardEscrow.
     * @param account The address to send the fees to.
     * @param detAmount The amount of DET.
     */
    function _payRewards(address account, uint256 detAmount)
        internal
        notFeeAddress(account)
    {
        // Record vesting entry for claiming address and amount
        // DET already minted to rewardEscrow balance
        rewardEscrow().appendVestingEntry(account, detAmount);
    }

    /**
     * @notice The total fees available in the system to be withdrawnn in dUSD
     */
    function totalFeesAvailable() external view returns (uint256) {
        uint256 totalFees = 0;

        // Fees in fee period [0] are not yet available for withdrawal
        for (uint256 i = 1; i < FEE_PERIOD_LENGTH; i++) {
            totalFees = totalFees.add(
                _recentFeePeriodsStorage(i).feesToDistribute
            );
            totalFees = totalFees.sub(_recentFeePeriodsStorage(i).feesClaimed);
        }

        return totalFees;
    }

    /**
     * @notice The total DET rewards available in the system to be withdrawn
     */
    function totalRewardsAvailable() external view returns (uint256) {
        uint256 totalRewards = 0;

        // Rewards in fee period [0] are not yet available for withdrawal
        for (uint256 i = 1; i < FEE_PERIOD_LENGTH; i++) {
            totalRewards = totalRewards.add(
                _recentFeePeriodsStorage(i).rewardsToDistribute
            );
            totalRewards = totalRewards.sub(
                _recentFeePeriodsStorage(i).rewardsClaimed
            );
        }

        return totalRewards;
    }

    /**
     * @notice The fees available to be withdrawn by a specific account, priced in dUSD
     * @dev Returns two amounts, one for fees and one for DET rewards
     */
    function feesAvailable(address account)
        public
        view
        returns (uint256, uint256)
    {
        // Add up the fees
        uint256[2][FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);

        uint256 totalFees = 0;
        uint256 totalRewards = 0;

        // Fees & Rewards in fee period [0] are not yet available for withdrawal
        for (uint256 i = 1; i < FEE_PERIOD_LENGTH; i++) {
            totalFees = totalFees.add(userFees[i][0]);
            totalRewards = totalRewards.add(userFees[i][1]);
        }

        // And convert totalFees to dUSD
        // Return totalRewards as is in DET amount
        return (totalFees, totalRewards);
    }

    function _isFeesClaimableAndAnyRatesInvalid(address account)
        internal
        view
        returns (bool, bool)
    {
        // Threshold is calculated from ratio % above the target ratio (issuanceRatio).
        //  0  <  10%:   Claimable
        // 10% > above:  Unable to claim
        (uint256 ratio, bool anyRateIsInvalid) = issuer()
            .collateralisationRatioAndAnyRatesInvalid(account);
        uint256 targetRatio = getIssuanceRatio();

        // Claimable if collateral ratio below target ratio
        if (ratio < targetRatio) {
            return (true, anyRateIsInvalid);
        }

        // Calculate the threshold for collateral ratio before fees can't be claimed.
        uint256 ratio_threshold = targetRatio.multiplyDecimal(
            SafeDecimalMath.unit().add(getTargetThreshold())
        );

        // Not claimable if collateral ratio above threshold
        if (ratio > ratio_threshold) {
            return (false, anyRateIsInvalid);
        }

        return (true, anyRateIsInvalid);
    }

    function isFeesClaimable(address account)
        external
        view
        returns (bool feesClaimable)
    {
        (feesClaimable, ) = _isFeesClaimableAndAnyRatesInvalid(account);
    }

    /**
     * @notice Calculates fees by period for an account, priced in dUSD
     * @param account The address you want to query the fees for
     */
    function feesByPeriod(address account)
        public
        view
        returns (uint256[2][FEE_PERIOD_LENGTH] memory results)
    {
        // What's the user's debt entry index and the debt they owe to the system at current feePeriod
        uint256 userOwnershipPercentage;
        uint256 debtEntryIndex;
        FeePoolState _feePoolState = feePoolState();

        (userOwnershipPercentage, debtEntryIndex) = _feePoolState
            .getAccountsDebtEntry(account, 0);

        // If they don't have any debt ownership and they never minted, they don't have any fees.
        // User ownership can reduce to 0 if user burns all synths,
        // however they could have fees applicable for periods they had minted in before so we check debtEntryIndex.
        if (debtEntryIndex == 0 && userOwnershipPercentage == 0) {
            uint256[2][FEE_PERIOD_LENGTH] memory nullResults;
            return nullResults;
        }

        // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
        // fees owing for, so we need to report on it anyway.
        uint256 feesFromPeriod;
        uint256 rewardsFromPeriod;
        (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(
            0,
            userOwnershipPercentage,
            debtEntryIndex
        );

        results[0][0] = feesFromPeriod;
        results[0][1] = rewardsFromPeriod;

        // Retrieve user's last fee claim by periodId
        uint256 lastFeeWithdrawal = getLastFeeWithdrawal(account);

        // Go through our fee periods from the oldest feePeriod[FEE_PERIOD_LENGTH - 1] and figure out what we owe them.
        // Condition checks for periods > 0
        for (uint256 i = FEE_PERIOD_LENGTH - 1; i > 0; i--) {
            uint256 next = i - 1;
            uint256 nextPeriodStartingDebtIndex = _recentFeePeriodsStorage(next)
                .startingDebtIndex;

            // We can skip the period, as no debt minted during period (next period's startingDebtIndex is still 0)
            if (
                nextPeriodStartingDebtIndex > 0 &&
                lastFeeWithdrawal < _recentFeePeriodsStorage(i).feePeriodId
            ) {
                // We calculate a feePeriod's closingDebtIndex by looking at the next feePeriod's startingDebtIndex
                // we can use the most recent issuanceData[0] for the current feePeriod
                // else find the applicableIssuanceData for the feePeriod based on the StartingDebtIndex of the period
                uint256 closingDebtIndex = uint256(nextPeriodStartingDebtIndex)
                    .sub(1);

                // Gas optimisation - to reuse debtEntryIndex if found new applicable one
                // if applicable is 0,0 (none found) we keep most recent one from issuanceData[0]
                // return if userOwnershipPercentage = 0)
                (userOwnershipPercentage, debtEntryIndex) = _feePoolState
                    .applicableIssuanceData(account, closingDebtIndex);

                (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(
                    i,
                    userOwnershipPercentage,
                    debtEntryIndex
                );

                results[i][0] = feesFromPeriod;
                results[i][1] = rewardsFromPeriod;
            }
        }
    }

    /**
     * @notice ownershipPercentage is a high precision decimals uint based on
     * wallet's debtPercentage. Gives a precise amount of the feesToDistribute
     * for fees in the period. Precision factor is removed before results are
     * returned.
     * @dev The reported fees owing for the current period [0] are just a
     * running balance until the fee period closes
     */
    function _feesAndRewardsFromPeriod(
        uint256 period,
        uint256 ownershipPercentage,
        uint256 debtEntryIndex
    ) internal view returns (uint256, uint256) {
        // If it's zero, they haven't issued, and they have no fees OR rewards.
        if (ownershipPercentage == 0) return (0, 0);

        uint256 debtOwnershipForPeriod = ownershipPercentage;

        // If period has closed we want to calculate debtPercentage for the period
        if (period > 0) {
            uint256 closingDebtIndex = uint256(
                _recentFeePeriodsStorage(period - 1)
                    .startingDebtIndex
            )
                .sub(1);
            debtOwnershipForPeriod = _effectiveDebtRatioForPeriod(
                closingDebtIndex,
                ownershipPercentage,
                debtEntryIndex
            );
        }

        // Calculate their percentage of the fees / rewards in this period
        // This is a high precision integer.
        uint256 feesFromPeriod = _recentFeePeriodsStorage(period)
            .feesToDistribute
            .multiplyDecimal(debtOwnershipForPeriod);

        uint256 rewardsFromPeriod = _recentFeePeriodsStorage(period)
            .rewardsToDistribute
            .multiplyDecimal(debtOwnershipForPeriod);

        return (
            feesFromPeriod.preciseDecimalToDecimal(),
            rewardsFromPeriod.preciseDecimalToDecimal()
        );
    }

    function _effectiveDebtRatioForPeriod(
        uint256 closingDebtIndex,
        uint256 ownershipPercentage,
        uint256 debtEntryIndex
    ) internal view returns (uint256) {
        // Figure out their global debt percentage delta at end of fee Period.
        // This is a high precision integer.
        IdTradeState _dtradeState = dtradeState();
        uint256 feePeriodDebtOwnership = _dtradeState
            .debtLedger(closingDebtIndex)
            .divideDecimalRoundPrecise(_dtradeState.debtLedger(debtEntryIndex))
            .multiplyDecimalRoundPrecise(ownershipPercentage);

        return feePeriodDebtOwnership;
    }

    function effectiveDebtRatioForPeriod(address account, uint256 period)
        external
        view
        returns (uint256)
    {
        require(period != 0, "Current period is not closed yet");
        require(period < FEE_PERIOD_LENGTH, "Exceeds the FEE_PERIOD_LENGTH");

        // If the period being checked is uninitialised then return 0. This is only at the start of the system.
        if (_recentFeePeriodsStorage(period - 1).startingDebtIndex == 0)
            return 0;

        uint256 closingDebtIndex = uint256(
            _recentFeePeriodsStorage(period - 1)
                .startingDebtIndex
        )
            .sub(1);

        uint256 ownershipPercentage;
        uint256 debtEntryIndex;
        (ownershipPercentage, debtEntryIndex) = feePoolState()
            .applicableIssuanceData(account, closingDebtIndex);

        // internal function will check closingDebtIndex has corresponding debtLedger entry
        return
            _effectiveDebtRatioForPeriod(
                closingDebtIndex,
                ownershipPercentage,
                debtEntryIndex
            );
    }

    /**
     * @notice Get the feePeriodID of the last claim this account made
     * @param _claimingAddress account to check the last fee period ID claim for
     * @return uint of the feePeriodID this account last claimed
     */
    function getLastFeeWithdrawal(address _claimingAddress)
        public
        view
        returns (uint256)
    {
        return
            feePoolEternalStorage().getUIntValue(
                keccak256(
                    abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)
                )
            );
    }

    /**
     * @notice Calculate the collateral ratio before user is blocked from claiming.
     */
    function getPenaltyThresholdRatio() public view returns (uint256) {
        return
            getIssuanceRatio().multiplyDecimal(
                SafeDecimalMath.unit().add(getTargetThreshold())
            );
    }

    /**
     * @notice Set the feePeriodID of the last claim this account made
     * @param _claimingAddress account to set the last feePeriodID claim for
     * @param _feePeriodID the feePeriodID this account claimed fees for
     */
    function _setLastFeeWithdrawal(
        address _claimingAddress,
        uint256 _feePeriodID
    ) internal {
        feePoolEternalStorage().setUIntValue(
            keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)),
            _feePeriodID
        );
    }

    /* ========== Modifiers ========== */
    modifier onlyInternalContracts {
        bool isExchanger = msg.sender == address(exchanger());
        bool isSynth = issuer().synthsByAddress(msg.sender) != bytes32(0);
        bool isEtherCollateraldUSD = msg.sender ==
            address(etherCollateraldUSD());

        require(
            isExchanger || isSynth || isEtherCollateraldUSD,
            "Only Internal Contracts"
        );
        _;
    }

    modifier onlyIssuer {
        require(
            msg.sender == address(issuer()),
            "FeePool: Only Issuer Authorised"
        );
        _;
    }

    modifier notFeeAddress(address account) {
        require(account != FEE_ADDRESS, "Fee address not allowed");
        _;
    }

    modifier issuanceActive() {
        systemStatus().requireIssuanceActive();
        _;
    }

    /* ========== Proxy Events ========== */

    event IssuanceDebtRatioEntry(
        address indexed account,
        uint256 debtRatio,
        uint256 debtEntryIndex,
        uint256 feePeriodStartingDebtIndex
    );
    bytes32 private constant ISSUANCEDEBTRATIOENTRY_SIG = keccak256(
        "IssuanceDebtRatioEntry(address,uint256,uint256,uint256)"
    );

    function emitIssuanceDebtRatioEntry(
        address account,
        uint256 debtRatio,
        uint256 debtEntryIndex,
        uint256 feePeriodStartingDebtIndex
    ) internal {
        proxy._emit(
            abi.encode(debtRatio, debtEntryIndex, feePeriodStartingDebtIndex),
            2,
            ISSUANCEDEBTRATIOENTRY_SIG,
            bytes32(uint256(uint160(account))),
            0,
            0
        );
    }

    event FeePeriodClosed(uint256 feePeriodId);
    bytes32 private constant FEEPERIODCLOSED_SIG = keccak256(
        "FeePeriodClosed(uint256)"
    );

    function emitFeePeriodClosed(uint256 feePeriodId) internal {
        proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
    }

    event FeesClaimed(address account, uint256 dUSDAmount, uint256 detRewards);
    bytes32 private constant FEESCLAIMED_SIG = keccak256(
        "FeesClaimed(address,uint256,uint256)"
    );

    function emitFeesClaimed(
        address account,
        uint256 dUSDAmount,
        uint256 detRewards
    ) internal {
        proxy._emit(
            abi.encode(account, dUSDAmount, detRewards),
            1,
            FEESCLAIMED_SIG,
            0,
            0,
            0
        );
    }
}
