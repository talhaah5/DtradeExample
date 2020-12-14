package com.web3j_intro.Contract;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Bool;
import org.web3j.abi.datatypes.DynamicArray;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Bytes32;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.RemoteFunctionCall;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tuples.generated.Tuple2;
import org.web3j.tuples.generated.Tuple3;
import org.web3j.tuples.generated.Tuple5;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.gas.ContractGasProvider;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 4.5.16.
 */
@SuppressWarnings("rawtypes")
public class IExchangeRates extends Contract {
    public static final String BINARY = "";

    public static final String FUNC_AGGREGATORWARNINGFLAGS = "aggregatorWarningFlags";

    public static final String FUNC_AGGREGATORS = "aggregators";

    public static final String FUNC_ANYRATEISINVALID = "anyRateIsInvalid";

    public static final String FUNC_CANFREEZERATE = "canFreezeRate";

    public static final String FUNC_CURRENCIESUSINGAGGREGATOR = "currenciesUsingAggregator";

    public static final String FUNC_CURRENTROUNDFORRATE = "currentRoundForRate";

    public static final String FUNC_EFFECTIVEVALUE = "effectiveValue";

    public static final String FUNC_EFFECTIVEVALUEANDRATES = "effectiveValueAndRates";

    public static final String FUNC_EFFECTIVEVALUEATROUND = "effectiveValueAtRound";

    public static final String FUNC_FREEZERATE = "freezeRate";

    public static final String FUNC_GETCURRENTROUNDID = "getCurrentRoundId";

    public static final String FUNC_GETLASTROUNDIDBEFOREELAPSEDSECS = "getLastRoundIdBeforeElapsedSecs";

    public static final String FUNC_INVERSEPRICING = "inversePricing";

    public static final String FUNC_LASTRATEUPDATETIMES = "lastRateUpdateTimes";

    public static final String FUNC_ORACLE = "oracle";

    public static final String FUNC_RATEANDTIMESTAMPATROUND = "rateAndTimestampAtRound";

    public static final String FUNC_RATEANDUPDATEDTIME = "rateAndUpdatedTime";

    public static final String FUNC_RATEFORCURRENCY = "rateForCurrency";

    public static final String FUNC_RATEISFLAGGED = "rateIsFlagged";

    public static final String FUNC_RATEISFROZEN = "rateIsFrozen";

    public static final String FUNC_RATEISINVALID = "rateIsInvalid";

    public static final String FUNC_RATEISSTALE = "rateIsStale";

    public static final String FUNC_RATESTALEPERIOD = "rateStalePeriod";

    public static final String FUNC_RATESANDINVALIDFORCURRENCIES = "ratesAndInvalidForCurrencies";

    public static final String FUNC_RATESANDUPDATEDTIMEFORCURRENCYLASTNROUNDS = "ratesAndUpdatedTimeForCurrencyLastNRounds";

    public static final String FUNC_RATESFORCURRENCIES = "ratesForCurrencies";

    public static final String FUNC_RATESFORCURRENCIESSORTED = "ratesForCurrenciesSorted";

    @Deprecated
    protected IExchangeRates(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected IExchangeRates(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected IExchangeRates(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected IExchangeRates(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public RemoteFunctionCall<String> aggregatorWarningFlags() {
        final Function function = new Function(FUNC_AGGREGATORWARNINGFLAGS, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<String> aggregators(byte[] currencyKey) {
        final Function function = new Function(FUNC_AGGREGATORS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<Boolean> anyRateIsInvalid(List<byte[]> currencyKeys) {
        final Function function = new Function(FUNC_ANYRATEISINVALID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.DynamicArray<org.web3j.abi.datatypes.generated.Bytes32>(
                        org.web3j.abi.datatypes.generated.Bytes32.class,
                        org.web3j.abi.Utils.typeMap(currencyKeys, org.web3j.abi.datatypes.generated.Bytes32.class))), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<Boolean> canFreezeRate(byte[] currencyKey) {
        final Function function = new Function(FUNC_CANFREEZERATE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<List> currenciesUsingAggregator(String aggregator) {
        final Function function = new Function(FUNC_CURRENCIESUSINGAGGREGATOR, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, aggregator)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Bytes32>>() {}));
        return new RemoteFunctionCall<List>(function,
                new Callable<List>() {
                    @Override
                    @SuppressWarnings("unchecked")
                    public List call() throws Exception {
                        List<Type> result = (List<Type>) executeCallSingleValueReturn(function, List.class);
                        return convertToNative(result);
                    }
                });
    }

    public RemoteFunctionCall<BigInteger> currentRoundForRate(byte[] currencyKey) {
        final Function function = new Function(FUNC_CURRENTROUNDFORRATE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> effectiveValue(byte[] sourceCurrencyKey, BigInteger sourceAmount, byte[] destinationCurrencyKey) {
        final Function function = new Function(FUNC_EFFECTIVEVALUE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(sourceCurrencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(sourceAmount), 
                new org.web3j.abi.datatypes.generated.Bytes32(destinationCurrencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple3<BigInteger, BigInteger, BigInteger>> effectiveValueAndRates(byte[] sourceCurrencyKey, BigInteger sourceAmount, byte[] destinationCurrencyKey) {
        final Function function = new Function(FUNC_EFFECTIVEVALUEANDRATES, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(sourceCurrencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(sourceAmount), 
                new org.web3j.abi.datatypes.generated.Bytes32(destinationCurrencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteFunctionCall<Tuple3<BigInteger, BigInteger, BigInteger>>(function,
                new Callable<Tuple3<BigInteger, BigInteger, BigInteger>>() {
                    @Override
                    public Tuple3<BigInteger, BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple3<BigInteger, BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (BigInteger) results.get(1).getValue(), 
                                (BigInteger) results.get(2).getValue());
                    }
                });
    }

    public RemoteFunctionCall<BigInteger> effectiveValueAtRound(byte[] sourceCurrencyKey, BigInteger sourceAmount, byte[] destinationCurrencyKey, BigInteger roundIdForSrc, BigInteger roundIdForDest) {
        final Function function = new Function(FUNC_EFFECTIVEVALUEATROUND, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(sourceCurrencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(sourceAmount), 
                new org.web3j.abi.datatypes.generated.Bytes32(destinationCurrencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(roundIdForSrc), 
                new org.web3j.abi.datatypes.generated.Uint256(roundIdForDest)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<TransactionReceipt> freezeRate(byte[] currencyKey) {
        final Function function = new Function(
                FUNC_FREEZERATE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> getCurrentRoundId(byte[] currencyKey) {
        final Function function = new Function(FUNC_GETCURRENTROUNDID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> getLastRoundIdBeforeElapsedSecs(byte[] currencyKey, BigInteger startingRoundId, BigInteger startingTimestamp, BigInteger timediff) {
        final Function function = new Function(FUNC_GETLASTROUNDIDBEFOREELAPSEDSECS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(startingRoundId), 
                new org.web3j.abi.datatypes.generated.Uint256(startingTimestamp), 
                new org.web3j.abi.datatypes.generated.Uint256(timediff)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple5<BigInteger, BigInteger, BigInteger, Boolean, Boolean>> inversePricing(byte[] currencyKey) {
        final Function function = new Function(FUNC_INVERSEPRICING, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}, new TypeReference<Bool>() {}));
        return new RemoteFunctionCall<Tuple5<BigInteger, BigInteger, BigInteger, Boolean, Boolean>>(function,
                new Callable<Tuple5<BigInteger, BigInteger, BigInteger, Boolean, Boolean>>() {
                    @Override
                    public Tuple5<BigInteger, BigInteger, BigInteger, Boolean, Boolean> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple5<BigInteger, BigInteger, BigInteger, Boolean, Boolean>(
                                (BigInteger) results.get(0).getValue(), 
                                (BigInteger) results.get(1).getValue(), 
                                (BigInteger) results.get(2).getValue(), 
                                (Boolean) results.get(3).getValue(), 
                                (Boolean) results.get(4).getValue());
                    }
                });
    }

    public RemoteFunctionCall<BigInteger> lastRateUpdateTimes(byte[] currencyKey) {
        final Function function = new Function(FUNC_LASTRATEUPDATETIMES, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<String> oracle() {
        final Function function = new Function(FUNC_ORACLE, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<Tuple2<BigInteger, BigInteger>> rateAndTimestampAtRound(byte[] currencyKey, BigInteger roundId) {
        final Function function = new Function(FUNC_RATEANDTIMESTAMPATROUND, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(roundId)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteFunctionCall<Tuple2<BigInteger, BigInteger>>(function,
                new Callable<Tuple2<BigInteger, BigInteger>>() {
                    @Override
                    public Tuple2<BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (BigInteger) results.get(1).getValue());
                    }
                });
    }

    public RemoteFunctionCall<Tuple2<BigInteger, BigInteger>> rateAndUpdatedTime(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEANDUPDATEDTIME, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Uint256>() {}));
        return new RemoteFunctionCall<Tuple2<BigInteger, BigInteger>>(function,
                new Callable<Tuple2<BigInteger, BigInteger>>() {
                    @Override
                    public Tuple2<BigInteger, BigInteger> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<BigInteger, BigInteger>(
                                (BigInteger) results.get(0).getValue(), 
                                (BigInteger) results.get(1).getValue());
                    }
                });
    }

    public RemoteFunctionCall<BigInteger> rateForCurrency(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEFORCURRENCY, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Boolean> rateIsFlagged(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEISFLAGGED, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<Boolean> rateIsFrozen(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEISFROZEN, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<Boolean> rateIsInvalid(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEISINVALID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<Boolean> rateIsStale(byte[] currencyKey) {
        final Function function = new Function(FUNC_RATEISSTALE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<BigInteger> rateStalePeriod() {
        final Function function = new Function(FUNC_RATESTALEPERIOD, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple2<List<BigInteger>, Boolean>> ratesAndInvalidForCurrencies(List<byte[]> currencyKeys) {
        final Function function = new Function(FUNC_RATESANDINVALIDFORCURRENCIES, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.DynamicArray<org.web3j.abi.datatypes.generated.Bytes32>(
                        org.web3j.abi.datatypes.generated.Bytes32.class,
                        org.web3j.abi.Utils.typeMap(currencyKeys, org.web3j.abi.datatypes.generated.Bytes32.class))), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Uint256>>() {}, new TypeReference<Bool>() {}));
        return new RemoteFunctionCall<Tuple2<List<BigInteger>, Boolean>>(function,
                new Callable<Tuple2<List<BigInteger>, Boolean>>() {
                    @Override
                    public Tuple2<List<BigInteger>, Boolean> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<List<BigInteger>, Boolean>(
                                convertToNative((List<Uint256>) results.get(0).getValue()), 
                                (Boolean) results.get(1).getValue());
                    }
                });
    }

    public RemoteFunctionCall<Tuple2<List<BigInteger>, List<BigInteger>>> ratesAndUpdatedTimeForCurrencyLastNRounds(byte[] currencyKey, BigInteger numRounds) {
        final Function function = new Function(FUNC_RATESANDUPDATEDTIMEFORCURRENCYLASTNROUNDS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey), 
                new org.web3j.abi.datatypes.generated.Uint256(numRounds)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Uint256>>() {}, new TypeReference<DynamicArray<Uint256>>() {}));
        return new RemoteFunctionCall<Tuple2<List<BigInteger>, List<BigInteger>>>(function,
                new Callable<Tuple2<List<BigInteger>, List<BigInteger>>>() {
                    @Override
                    public Tuple2<List<BigInteger>, List<BigInteger>> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<List<BigInteger>, List<BigInteger>>(
                                convertToNative((List<Uint256>) results.get(0).getValue()), 
                                convertToNative((List<Uint256>) results.get(1).getValue()));
                    }
                });
    }

    public RemoteFunctionCall<List> ratesForCurrencies(List<byte[]> currencyKeys) {
        final Function function = new Function(FUNC_RATESFORCURRENCIES, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.DynamicArray<org.web3j.abi.datatypes.generated.Bytes32>(
                        org.web3j.abi.datatypes.generated.Bytes32.class,
                        org.web3j.abi.Utils.typeMap(currencyKeys, org.web3j.abi.datatypes.generated.Bytes32.class))), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Uint256>>() {}));
        return new RemoteFunctionCall<List>(function,
                new Callable<List>() {
                    @Override
                    @SuppressWarnings("unchecked")
                    public List call() throws Exception {
                        List<Type> result = (List<Type>) executeCallSingleValueReturn(function, List.class);
                        return convertToNative(result);
                    }
                });
    }

    public RemoteFunctionCall<Tuple2<List<BigInteger>, List<byte[]>>> ratesForCurrenciesSorted(List<byte[]> currencyKeys) {
        final Function function = new Function(FUNC_RATESFORCURRENCIESSORTED, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.DynamicArray<org.web3j.abi.datatypes.generated.Bytes32>(
                        org.web3j.abi.datatypes.generated.Bytes32.class,
                        org.web3j.abi.Utils.typeMap(currencyKeys, org.web3j.abi.datatypes.generated.Bytes32.class))), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Uint256>>() {}, new TypeReference<DynamicArray<Bytes32>>() {}));
        return new RemoteFunctionCall<Tuple2<List<BigInteger>, List<byte[]>>>(function,
                new Callable<Tuple2<List<BigInteger>, List<byte[]>>>() {
                    @Override
                    public Tuple2<List<BigInteger>, List<byte[]>> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<List<BigInteger>, List<byte[]>>(
                                convertToNative((List<Uint256>) results.get(0).getValue()), 
                                convertToNative((List<Bytes32>) results.get(1).getValue()));
                    }
                });
    }

    @Deprecated
    public static IExchangeRates load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new IExchangeRates(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static IExchangeRates load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new IExchangeRates(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static IExchangeRates load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new IExchangeRates(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static IExchangeRates load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new IExchangeRates(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<IExchangeRates> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IExchangeRates.class, web3j, credentials, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IExchangeRates> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IExchangeRates.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<IExchangeRates> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IExchangeRates.class, web3j, transactionManager, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IExchangeRates> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IExchangeRates.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }
}
