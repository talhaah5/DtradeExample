package com.web3j_intro.Contract;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.RemoteFunctionCall;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
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
public class IDepot extends Contract {
    public static final String BINARY = "";

    public static final String FUNC_DEPOSITSYNTHS = "depositSynths";

    public static final String FUNC_DTRADERECEIVEDFORETHER = "dtradeReceivedForEther";

    public static final String FUNC_DTRADERECEIVEDFORSYNTHS = "dtradeReceivedForSynths";

    public static final String FUNC_EXCHANGEETHERFORDET = "exchangeEtherForDET";

    public static final String FUNC_EXCHANGEETHERFORDETATRATE = "exchangeEtherForDETAtRate";

    public static final String FUNC_EXCHANGEETHERFORSYNTHS = "exchangeEtherForSynths";

    public static final String FUNC_EXCHANGEETHERFORSYNTHSATRATE = "exchangeEtherForSynthsAtRate";

    public static final String FUNC_EXCHANGESYNTHSFORDET = "exchangeSynthsForDET";

    public static final String FUNC_FUNDSWALLET = "fundsWallet";

    public static final String FUNC_MAXETHPURCHASE = "maxEthPurchase";

    public static final String FUNC_MINIMUMDEPOSITAMOUNT = "minimumDepositAmount";

    public static final String FUNC_SYNTHSRECEIVEDFORETHER = "synthsReceivedForEther";

    public static final String FUNC_TOTALSELLABLEDEPOSITS = "totalSellableDeposits";

    public static final String FUNC_WITHDRAWMYDEPOSITEDSYNTHS = "withdrawMyDepositedSynths";

    public static final String FUNC_WITHDRAWDTRADE = "withdrawdTrade";

    @Deprecated
    protected IDepot(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected IDepot(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, credentials, contractGasProvider);
    }

    @Deprecated
    protected IDepot(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    protected IDepot(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        super(BINARY, contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public RemoteFunctionCall<TransactionReceipt> depositSynths(BigInteger amount) {
        final Function function = new Function(
                FUNC_DEPOSITSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<BigInteger> dtradeReceivedForEther(BigInteger amount) {
        final Function function = new Function(FUNC_DTRADERECEIVEDFORETHER, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> dtradeReceivedForSynths(BigInteger amount) {
        final Function function = new Function(FUNC_DTRADERECEIVEDFORSYNTHS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<TransactionReceipt> exchangeEtherForDET(BigInteger weiValue) {
        final Function function = new Function(
                FUNC_EXCHANGEETHERFORDET, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteFunctionCall<TransactionReceipt> exchangeEtherForDETAtRate(BigInteger guaranteedRate, BigInteger guaranteeddTradeRate, BigInteger weiValue) {
        final Function function = new Function(
                FUNC_EXCHANGEETHERFORDETATRATE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(guaranteedRate), 
                new org.web3j.abi.datatypes.generated.Uint256(guaranteeddTradeRate)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteFunctionCall<TransactionReceipt> exchangeEtherForSynths(BigInteger weiValue) {
        final Function function = new Function(
                FUNC_EXCHANGEETHERFORSYNTHS, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteFunctionCall<TransactionReceipt> exchangeEtherForSynthsAtRate(BigInteger guaranteedRate, BigInteger weiValue) {
        final Function function = new Function(
                FUNC_EXCHANGEETHERFORSYNTHSATRATE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(guaranteedRate)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function, weiValue);
    }

    public RemoteFunctionCall<TransactionReceipt> exchangeSynthsForDET(BigInteger synthAmount) {
        final Function function = new Function(
                FUNC_EXCHANGESYNTHSFORDET, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(synthAmount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<String> fundsWallet() {
        final Function function = new Function(FUNC_FUNDSWALLET, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteFunctionCall<BigInteger> maxEthPurchase() {
        final Function function = new Function(FUNC_MAXETHPURCHASE, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> minimumDepositAmount() {
        final Function function = new Function(FUNC_MINIMUMDEPOSITAMOUNT, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> synthsReceivedForEther(BigInteger amount) {
        final Function function = new Function(FUNC_SYNTHSRECEIVEDFORETHER, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<BigInteger> totalSellableDeposits() {
        final Function function = new Function(FUNC_TOTALSELLABLEDEPOSITS, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeRemoteCallSingleValueReturn(function, BigInteger.class);
    }

    public RemoteFunctionCall<TransactionReceipt> withdrawMyDepositedSynths() {
        final Function function = new Function(
                FUNC_WITHDRAWMYDEPOSITEDSYNTHS, 
                Arrays.<Type>asList(), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteFunctionCall<TransactionReceipt> withdrawdTrade(BigInteger amount) {
        final Function function = new Function(
                FUNC_WITHDRAWDTRADE, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.generated.Uint256(amount)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    @Deprecated
    public static IDepot load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new IDepot(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    @Deprecated
    public static IDepot load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new IDepot(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public static IDepot load(String contractAddress, Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return new IDepot(contractAddress, web3j, credentials, contractGasProvider);
    }

    public static IDepot load(String contractAddress, Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return new IDepot(contractAddress, web3j, transactionManager, contractGasProvider);
    }

    public static RemoteCall<IDepot> deploy(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IDepot.class, web3j, credentials, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IDepot> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IDepot.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<IDepot> deploy(Web3j web3j, TransactionManager transactionManager, ContractGasProvider contractGasProvider) {
        return deployRemoteCall(IDepot.class, web3j, transactionManager, contractGasProvider, BINARY, "");
    }

    @Deprecated
    public static RemoteCall<IDepot> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(IDepot.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }
}
