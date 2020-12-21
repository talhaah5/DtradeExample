package com.web3j_intro;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.web3j_intro.Contract.AddressBook;
import com.web3j_intro.Contract.AddressResolver;
import com.web3j_intro.Contract.Depot;
import com.web3j_intro.Contract.IERC20;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.web3j.abi.datatypes.generated.Bytes32;
import org.web3j.crypto.Bip32ECKeyPair;
import org.web3j.crypto.CipherException;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.MnemonicUtils;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.Transfer;
import org.web3j.utils.Convert;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.PrivateKey;
import java.security.Provider;
import java.security.Security;

import static org.web3j.crypto.Bip32ECKeyPair.HARDENED_BIT;

public class MainActivity extends AppCompatActivity {

    private Web3j web3;
    //FIXME: Add your own password here
    private final String password = "medium";
    private String walletPath;
    private File walletDir;
    private final static String PRIVATE_KEY = "1bd00a5c7a86562428dd117ee42fe43a2c3573e59062b3a8998f09973fc4fdf1";
    AddressResolver addressBook;
    private final static BigInteger GAS_LIMIT = BigInteger.valueOf(6721975L);
    private final static BigInteger GAS_PRICE = BigInteger.valueOf(20000000000L);

    private final static String RECIPIENT = "0x466B6E82CD017923298Db45C5a3Db7c66Cd753C8";

    private static String CONTRACT_ADDRESS = "0x7D6c36Bd3d5C977bd9eF7565d1b8FD2d5060C598";
    private final static String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setupBouncyCastle();
        walletPath = getFilesDir().getAbsolutePath();
//        Web3j web3j = Web3j.build(new HttpService());
        Web3j web3j = Web3j.build(new HttpService("https://rinkeby.infura.io/v3/69ee326bc0634f43b061987860870e21"));
        mnemonicCredentials();
        Credentials credentials = getCredentialsFromPrivateKey();
//        CONTRACT_ADDRESS = deployContract(web3j, credentials);
        System.out.println(CONTRACT_ADDRESS);
        addressBook = loadContract(CONTRACT_ADDRESS, web3j, credentials);
        new RetrieveFeedTask().execute(CONTRACT_ADDRESS);
        try {
            new RetrieveFeedTask().execute(CONTRACT_ADDRESS);
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void connectToEthNetwork(View v) {
        toastAsync("Connecting to Ethereum network...");
        // FIXME: Add your own API key here
//        https://rinkeby.infura.io/v3/69ee326bc0634f43b061987860870e21
        web3 = Web3j.build(new HttpService(" https://rinkeby.infura.io/v3/69ee326bc0634f43b061987860870e21"));


        try {

//            Byte[] b = "0x45786368616e67655261746573000000";

//            web3.padRight(web3.fromAscii("ExchangeRates"), 34)
//            Log.d(TAG, "connectToEthNetwork:11 " + address.nominatedOwner(""));
            Web3ClientVersion clientVersion = web3.web3ClientVersion().sendAsync().get();
            if(!clientVersion.hasError()){
                toastAsync("Connected!");
                Credentials credentials = Credentials.create(PRIVATE_KEY);
//                new RetrieveFeedTask().execute(CONTRACT_ADDRESS);
                System.out.println(CONTRACT_ADDRESS);
                addressBook = loadContract(CONTRACT_ADDRESS, web3, credentials);
                System.out.println(addressBook.owner().send());


                 credentials = Credentials.create("dbc56c53e03838ee1a36198f653866a29b5d33eaac80f41c65ed03197184e13c");
                Log.d(TAG, "connectToEthNetwork:11 start");
                Depot address = Depot.load("0x17D729cb3545dA1985538F5cE210a43F0FfFda0A",web3,credentials,GAS_PRICE,GAS_LIMIT);
                Log.d(TAG, "connectToEthNetwork:11 load");
                String abc = address.resolver().send();
                Log.d(TAG, "connectToEthNetwork:11 resolver");
                System.out.println(abc);
            }
            else {
                toastAsync(clientVersion.getError().getMessage());
            }
        } catch (Exception e) {
            Log.d(TAG, "connectToEthNetwork: "+ e.getMessage());
            toastAsync(e.getMessage());
        }
    }

    public void createWallet(View v){

        try{
//            String fileName =  WalletUtils.generateLightNewWalletFile(password,walletDir);
//            walletDir = new File(walletPath + "/" + fileName);
//            toastAsync("Wallet generated");
//            String a = addressBook.resolver().send();
//            System.out.println("addressBook.resolver()");
//            System.out.println(a);
        }
        catch (Exception e){
            toastAsync(e.getMessage());
        }
    }

    public void getAddress(View v){
//        try {
//            Credentials credentials = WalletUtils.loadCredentials(password, walletDir);
//            toastAsync("Your address is " + credentials.getAddress());
//        }
//        catch (Exception e){
//            toastAsync(e.getMessage());
//        }


    }

    public void sendTransaction(View v){
        try{
            Credentials credentials = Credentials.create("dbc56c53e03838ee1a36198f653866a29b5d33eaac80f41c65ed03197184e13c");
            TransactionReceipt receipt = Transfer.sendFunds(web3,credentials,"0x17D729cb3545dA1985538F5cE210a43F0FfFda0A",new BigDecimal(100000),Convert.Unit.ETHER).sendAsync().get();
            toastAsync("Transaction complete: " +receipt.getTransactionHash());
        }
        catch (Exception e){
            toastAsync(e.getMessage());
        }
    }


    public void toastAsync(String message) {
        runOnUiThread(() -> {
            Toast.makeText(this, message, Toast.LENGTH_LONG).show();
            Log.d("MAINACTIVITY", "toastAsync: "+message);
        });
    }

    // Workaround for bug with ECDA signatures.
    private void setupBouncyCastle() {
      final Provider provider = Security.getProvider(BouncyCastleProvider.PROVIDER_NAME);
      if (provider == null) {
        // Web3j will set up the provider lazily when it's first used.
        return;
      }
      if (provider.getClass().equals(BouncyCastleProvider.class)) {
        // BC with same package name, shouldn't happen in real life.
        return;
      }
      // Android registers its own BC provider. As it might be outdated and might not include
      // all needed ciphers, we substitute it with a known BC bundled in the app.
      // Android's BC has its package rewritten to "com.android.org.bouncycastle" and because
      // of that it's possible to have another BC implementation loaded in VM.
      Security.removeProvider(BouncyCastleProvider.PROVIDER_NAME);
      Security.insertProviderAt(new BouncyCastleProvider(), 1);
    }
    // String to 64 length HexString (equivalent to 32 Hex lenght)
    public static Bytes32 stringToBytes32(String string) {
        byte[] byteValue = string.getBytes();
        byte[] byteValueLen32 = new byte[32];
        System.arraycopy(byteValue, 0, byteValueLen32, 0, byteValue.length);
        return new Bytes32(byteValueLen32);
    }
    private void printWeb3Version(Web3j web3j) {
        Web3ClientVersion web3ClientVersion = null;
        try {
            web3ClientVersion = web3j.web3ClientVersion().send();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String web3ClientVersionString = web3ClientVersion.getWeb3ClientVersion();
        System.out.println("Web3 client version: " + web3ClientVersionString);
    }

    private Credentials getCredentialsFromWallet() throws IOException, CipherException {
        return WalletUtils.loadCredentials(
                "passphrase",
                "wallet/path"
        );
    }

    private Credentials getCredentialsFromPrivateKey() {
        return Credentials.create(PRIVATE_KEY);
    }

    private void transferEthereum(Web3j web3j, Credentials credentials) throws Exception {
        TransactionManager transactionManager = new RawTransactionManager(
                web3j,
                credentials
        );

        Transfer transfer = new Transfer(web3j, transactionManager);

        TransactionReceipt transactionReceipt = transfer.sendFunds(
                RECIPIENT,
                BigDecimal.ONE,
                Convert.Unit.ETHER,
                GAS_PRICE,
                GAS_LIMIT
        ).send();

        System.out.print("Transaction = " + transactionReceipt.getTransactionHash());
    }

    private String deployContract(Web3j web3j, Credentials credentials) throws Exception {
        return AddressBook.deploy(web3j, credentials, GAS_PRICE, GAS_LIMIT)
                .send()
                .getContractAddress();
    }

    private AddressResolver loadContract(String contractAddress, Web3j web3j, Credentials credentials) {
        return AddressResolver.load(contractAddress, web3j, credentials, GAS_PRICE, GAS_LIMIT);
    }

    private void addAddresses(AddressBook addressBook) throws Exception {
        addressBook
                .addAddress("0x256a04B9F02036Ed2f785D8f316806411D605285", "Tom")
                .send();

        addressBook
                .addAddress("0x82CDf5a3192f2930726637e9C738A78689a91Be3", "Susan")
                .send();

        addressBook
                .addAddress("0x95F57F1DD015ddE7Ec2CbC8212D0ae2faC9acA11", "Bob")
                .send();
    }

    private void printAddresses(AddressBook addressBook) throws Exception {
        for (Object address : addressBook.getAddresses().send()) {
            String addressString = address.toString();
            String alias = addressBook.getAlias(addressString).send();
            System.out.println("Address " + addressString + " aliased as " + alias);
        }
    }

    private void removeAddress(AddressBook addressBook) throws Exception {
        addressBook
                .removeAddress("0x256a04B9F02036Ed2f785D8f316806411D605285")
                .send();
    }
    class RetrieveFeedTask extends AsyncTask<String, Void, String> {

        private Exception exception;

        protected String doInBackground(String... urls) {
            try {
//                Credentials credentials = Credentials.create(PRIVATE_KEY);
                System.out.println("addressBook.owner().send()");
                System.out.println(addressBook.owner().send());
                System.out.println("addressBook.owner().send()");

                return CONTRACT_ADDRESS;
            } catch (Exception e) {
                this.exception = e;
                System.out.println(e);

                return null;
            } finally {

            }
        }

        protected void onPostExecute(String feed) {
            // TODO: check this.exception
            // TODO: do something with the feed
        }
    }
    private void mnemonicCredentials(){
        Bip32ECKeyPair masterKeypair = Bip32ECKeyPair.generateKeyPair(MnemonicUtils.generateSeed("draw fade cargo ice runway spy flock detail ranch eyebrow scorpion repair", null));
        int[] path = {44 | HARDENED_BIT, 60 | HARDENED_BIT, 0 | HARDENED_BIT, 0,0};
        Bip32ECKeyPair  x = Bip32ECKeyPair.deriveKeyPair(masterKeypair, path);
        Credentials credentials = Credentials.create(x);
        System.out.println("credentials.getAddress()");
        System.out.println(credentials.getAddress());
    }
}
