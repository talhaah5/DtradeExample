package io.epirus;

import ch.qos.logback.classic.Level;
import io.epirus.generated.contracts.HelloWorld;
import io.epirus.web3j.Epirus;
import io.epirus.web3j.gas.EpirusGasProvider;
import io.epirus.web3j.gas.GasPrice;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Network;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.gas.ContractGasProvider;

import java.nio.file.Paths;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>This is the generated class for <code>epirus new helloworld</code></p>
 * <p>It deploys the Hello World contract in src/main/solidity/ and prints its address</p>
 * <p>For more information on how to run this project, please refer to our <a href="https://docs.epirus.io/quickstart/#deployment">documentation</a></p>
 */
public class Web3App {

    private static final Logger log = LoggerFactory.getILoggerFactory().getLogger("org.web3j.protocol.http.HttpService");
    private static final boolean epirusDeploy = Boolean.parseBoolean(System.getenv().getOrDefault("EPIRUS_DEPLOY", "false"));
    private static final Network deployNetwork = Network.valueOf(System.getenv().getOrDefault("WEB3J_NETWORK", "rinkeby").toUpperCase());
    private static final String walletPath = System.getenv("WEB3J_WALLET_PATH");
    private static final String walletPassword = System.getenv().getOrDefault("WEB3J_WALLET_PASSWORD", "");
    private static final String nodeUrl = System.getenv().getOrDefault("WEB3J_NODE_URL", System.getProperty("WEB3J_NODE_URL"));


    public static void main(String[] args) {
        try {
            ((ch.qos.logback.classic.Logger) (log)).setLevel(epirusDeploy ? Level.ERROR : Level.INFO);
            if (!epirusDeploy && (walletPath == null || walletPassword.isBlank() || nodeUrl == null)) {
                System.out.println("As the application isn't being run using the Epirus Platform, the following environment variables are expected: " +
                        "WEB3J_WALLET_PATH, WEB3J_WALLET_PASSWORD, WEB3J_NODE_URL. Please ensure these are set and try again.");
                System.exit(-1);
            }
            Credentials credentials = WalletUtils.loadCredentials(walletPassword, Paths.get(walletPath).toFile());
            Web3j web3j = getDeployWeb3j();
            HelloWorld helloWorld = deployHelloWorld(web3j, credentials, new EpirusGasProvider(deployNetwork, GasPrice.High));
            callGreetMethod(helloWorld);
        } catch (Exception e) {
            log.error(e.getMessage());
        }
    }

    private static Web3j getDeployWeb3j() throws Exception {
        if (nodeUrl == null || nodeUrl.isEmpty()) {
            return Epirus.buildWeb3j(deployNetwork);
        } else {
            log.info("Connecting to $nodeUrl");
            return Web3j.build(new HttpService(nodeUrl));
        }
    }

    private static HelloWorld deployHelloWorld(Web3j web3j, Credentials credentials, ContractGasProvider contractGasProvider) throws Exception {
        return HelloWorld.deploy(web3j, credentials, contractGasProvider, "Hello Blockchain World!").send();
    }

    private static void callGreetMethod(HelloWorld helloWorld) throws Exception {
        log.info("Calling the greeting method of contract HelloWorld");
        String response = helloWorld.greeting().send();
        log.info("Contract returned: " + response);
        String contractAddress;
        if(epirusDeploy) {
            contractAddress = "https://" + deployNetwork.getNetworkName() + ".epirus.io/contracts/" + helloWorld.getContractAddress();
        } else {
            contractAddress = helloWorld.getContractAddress();
        }
        System.out.println(String.format("%-20s", "Contract address") + contractAddress);
        System.exit(0);
    }
}
