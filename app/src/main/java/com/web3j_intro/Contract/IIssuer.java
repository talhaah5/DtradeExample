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
public class IIssuer extends Contract {
    public static final String BINARY = "";

    public static final String FUNC_ANYSYNTHORDETRATEISINVALID = "anySynthOrDETRateIsInvalid";

    public static final String FUNC_AVAILABLECURRENCYKEYS = "availableCurrencyKeys";

    public static final String FUNC_AVAILABLESYNTHCOUNT = "availableSynthCount";

    public static final String FUNC_AVAILABLESYNTHS = "availableSynths";

    public static final String FUNC_BURNSYNTHS = "burnSynths";

    public static final String FUNC_BURNSYNTHSONBEHALF = "burnSynthsOnBehalf";

    public static final String FUNC_BURNSYNTHSTOTARGET = "burnSynthsToTarget";

    public static final String FUNC_BURNSYNTHSTOTARGETONBEHALF = "burnSynthsToTargetOnBehalf";

    public static final String FUNC_CANBURNSYNTHS = "canBurnSynths";

    public static final String FUNC_COLLATERAL = "collateral";

    public static final String FUNC_COLLATERALISATIONRATIO = "collateralisationRatio";

    public static final String FUNC_COLLATERALISATIONRATIOANDANYRATESINVALID = "collateralisationRatioAndAnyRatesInvalid";

    public static final String FUNC_DEBTBALANCEOF = "debtBalanceOf";

    public static final String FUNC_GETALLOWEDTOKENNAMES = "getAllowedTokenNames";

    public static final String FUNC_GETALLOWEDTOKENNAMESANDADDRESSES = "getAllowedTokenNamesAndAddresses";

    public static final String FUNC_GETTOKENADDRESS = "getTokenAddress";

    public static final String FUNC_ISSUANCERATIO = "issuanceRatio";

    public static final String FUNC_ISSUEMAXSYNTHS = "issueMaxSynths";

    public static final String FUNC_ISSUEMAXSYNTHSONBEHALF = "issueMaxSynthsOnBehalf";

    public static final String FUNC_ISSUESYNTHS = "issueSynths";

    public static final String FUNC_ISSUESYNTHSFORERC20 = "issueSynthsForERC20";

    public static final String FUNC_ISSUESYNTHSONBEHALF = "issueSynthsOnBehalf";

    public static final String FUNC_LASTISSUEEVENT = "lastIssueEvent";

    public static final String FUNC_LIQUIDATEDELINQUENTACCOUNT = "liquidateDelinquentAccount";

    public static final String FUNC_MAXISSUABLESYNTHS = "maxIssuableSynths";

    public static final String FUNC_MINIMUMSTAKETIME = "minimumStakeTime";

    public static final String FUNC_REMAININGISSUABLESYNTHS = "remainingIssuableSynths";

    public static final String FUNC_SUBISSUEDSYNTHSBYERC = "subIssuedSynthsByERC";

    public static final String FUNC_SYNTHS = "synths";

    public static final String FUNC_SYNTHSBYADDRESS = "synthsByAddress";

    public static final String FUNC_TOTALISSUEDSYNTHS = "totalIssuedSynths";

    public static final String FUNC_TRANSFERABLEDTRADEANDANYRATEISINVALID = "transferabledTradeAndAnyRateIsInvalid";

    @Deprecated
    protected IIssuer(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected IIssuer(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected IIssuer(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected IIssuer(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public RemoteFunctionCall<Boolean> anySynthOrDETRateIsInvalid() {
        final Function function = new Function(FUNC_ANYSYNTHORDETRATEISINVALID, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<List> availableCurrencyKeys() {
        final Function function = new Function(FUNC_AVAILABLECURRENCYKEYS, 
                Arrays.<Type>asList(), 
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

    public RemoteFunctionCall<BigInteger> availableSynthCount() {
        final Function function = new Function(FUNC_AVAILABLESYNTHCOUNT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<String> availableSynths(BigInteger index) {
        final Function function = new Function(FUNC_AVAILABLESYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(index)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<TransactionReceipt> burnSynths(String from, BigInteger amount) {
        final Function function = new Function(
                FUNC_BURNSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, from), 
                new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> burnSynthsOnBehalf(String burnForAddress, String from, BigInteger amount) {
        final Function function = new Function(
                FUNC_BURNSYNTHSONBEHALF, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, burnForAddress), 
                new org.web3j.abi.datatypes.Address(160, from), 
                new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> burnSynthsToTarget(String from) {
        final Function function = new Function(
                FUNC_BURNSYNTHSTOTARGET, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, from)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> burnSynthsToTargetOnBehalf(String burnForAddress, String from) {
        final Function function = new Function(
                FUNC_BURNSYNTHSTOTARGETONBEHALF, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, burnForAddress), 
                new org.web3j.abi.datatypes.Address(160, from)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<Boolean> canBurnSynths(String account) {
        final Function function = new Function(FUNC_CANBURNSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bool>() {}));
        return executeRemoteCallSingleValueReturn(function, Boolean.class);
    }

    public RemoteFunctionCall<BigInteger> collateral(String account) {
        final Function function = new Function(FUNC_COLLATERAL, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> collateralisationRatio(String issuer) {
        final Function function = new Function(FUNC_COLLATERALISATIONRATIO, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issuer)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple2<BigInteger, Boolean>> collateralisationRatioAndAnyRatesInvalid(String _issuer) {
        final Function function = new Function(FUNC_COLLATERALISATIONRATIOANDANYRATESINVALID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, _issuer)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}));
        return new RemoteFunctionCall<Tuple2<BigInteger, Boolean>>(function,
                new Callable<Tuple2<BigInteger, Boolean>>() {
                    @Override
                    public Tuple2<BigInteger, Boolean> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<BigInteger, Boolean>(
                                (BigInteger) results.get(0).getValue(), 
                                (Boolean) results.get(1).getValue());
                    }
                });
    }

    public RemoteFunctionCall<BigInteger> debtBalanceOf(String issuer, byte[] currencyKey) {
        final Function function = new Function(FUNC_DEBTBALANCEOF, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issuer), 
                new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<List> getAllowedTokenNames() {
        final Function function = new Function(FUNC_GETALLOWEDTOKENNAMES, 
                Arrays.<Type>asList(), 
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

    public RemoteFunctionCall<Tuple2<List<byte[]>, List<String>>> getAllowedTokenNamesAndAddresses() {
        final Function function = new Function(FUNC_GETALLOWEDTOKENNAMESANDADDRESSES, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Bytes32>>() {}, new TypeReference<DynamicArray<Address>>() {}));
        return new RemoteFunctionCall<Tuple2<List<byte[]>, List<String>>>(function,
                new Callable<Tuple2<List<byte[]>, List<String>>>() {
                    @Override
                    public Tuple2<List<byte[]>, List<String>> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<List<byte[]>, List<String>>(
                                convertToNative((List<Bytes32>) results.get(0).getValue()), 
                                convertToNative((List<Address>) results.get(1).getValue()));
                    }
                });
    }

    public RemoteFunctionCall<String> getTokenAddress(byte[] tokenName) {
        final Function function = new Function(FUNC_GETTOKENADDRESS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(tokenName)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<BigInteger> issuanceRatio() {
        final Function function = new Function(FUNC_ISSUANCERATIO, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<TransactionReceipt> issueMaxSynths(String from) {
        final Function function = new Function(
                FUNC_ISSUEMAXSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, from)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> issueMaxSynthsOnBehalf(String issueFor, String from) {
        final Function function = new Function(
                FUNC_ISSUEMAXSYNTHSONBEHALF, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issueFor), 
                new org.web3j.abi.datatypes.Address(160, from)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> issueSynths(String from, BigInteger amount) {
        final Function function = new Function(
                FUNC_ISSUESYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, from), 
                new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> issueSynthsForERC20(String from, byte[] tokenName, BigInteger amount) {
        final Function function = new Function(
                FUNC_ISSUESYNTHSFORERC20, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, from), 
                new org.web3j.abi.datatypes.generated.Bytes32(tokenName), 
                new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> issueSynthsOnBehalf(String issueFor, String from, BigInteger amount) {
        final Function function = new Function(
                FUNC_ISSUESYNTHSONBEHALF, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issueFor), 
                new org.web3j.abi.datatypes.Address(160, from), 
                new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> lastIssueEvent(String account) {
        final Function function = new Function(FUNC_LASTISSUEEVENT, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<TransactionReceipt> liquidateDelinquentAccount(String account, BigInteger dusdAmount, String liquidator) {
        final Function function = new Function(
                FUNC_LIQUIDATEDELINQUENTACCOUNT, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account), 
                new org.web3j.abi.datatypes.generated.Uint256(dusdAmount), 
                new org.web3j.abi.datatypes.Address(160, liquidator)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> maxIssuableSynths(String issuer) {
        final Function function = new Function(FUNC_MAXISSUABLESYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issuer)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> minimumStakeTime() {
        final Function function = new Function(FUNC_MINIMUMSTAKETIME, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple3<BigInteger, BigInteger, BigInteger>> remainingIssuableSynths(String issuer) {
        final Function function = new Function(FUNC_REMAININGISSUABLESYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, issuer)), 
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

    public RemoteFunctionCall<TransactionReceipt> subIssuedSynthsByERC(String account, byte[] tokenName, BigInteger newDebtOwnership, BigInteger tokenStaked) {
        final Function function = new Function(
                FUNC_SUBISSUEDSYNTHSBYERC, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account), 
                new org.web3j.abi.datatypes.generated.Bytes32(tokenName), 
                new org.web3j.abi.datatypes.generated.Uint256(newDebtOwnership), 
                new org.web3j.abi.datatypes.generated.Uint256(tokenStaked)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<String> synths(byte[] currencyKey) {
        final Function function = new Function(FUNC_SYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<byte[]> synthsByAddress(String synthAddress) {
        final Function function = new Function(FUNC_SYNTHSBYADDRESS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, synthAddress)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Bytes32>() {}));
        return executeRemoteCallSingleValueReturn(function, byte[].class);
    }

    public RemoteFunctionCall<BigInteger> totalIssuedSynths(byte[] currencyKey, Boolean excludeEtherCollateral) {
        final Function function = new Function(FUNC_TOTALISSUEDSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Bytes32(currencyKey), 
                new org.web3j.abi.datatypes.Bool(excludeEtherCollateral)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<Tuple2<BigInteger, Boolean>> transferabledTradeAndAnyRateIsInvalid(String account, BigInteger balance) {
        final Function function = new Function(FUNC_TRANSFERABLEDTRADEANDANYRATEISINVALID, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(160, account), 
                new org.web3j.abi.datatypes.generated.Uint256(balance)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}, new TypeReference<Bool>() {}));
        return new RemoteFunctionCall<Tuple2<BigInteger, Boolean>>(function,
                new Callable<Tuple2<BigInteger, Boolean>>() {
                    @Override
                    public Tuple2<BigInteger, Boolean> call() throws Exception {
                        List<Type> results = executeCallMultipleValueReturn(function);
                        return new Tuple2<BigInteger, Boolean>(
                                (BigInteger) results.get(0).getValue(), 
                                (Boolean) results.get(1).getValue());
                    }
                });
    }

    @Deprecated
    public static IIssuer load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new IIssuer(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static IIssuer load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new IIssuer(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static IIssuer load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new IIssuer(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static IIssuer load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new IIssuer(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<IIssuer> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IIssuer.class, web3j, credentials, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IIssuer> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IIssuer.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<IIssuer> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IIssuer.class, web3j, transactionManager, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IIssuer> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IIssuer.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }
}
