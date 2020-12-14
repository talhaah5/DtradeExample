package com.web3j_intro;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.web3j_intro.Contract.AddressResolver;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.Transfer;
import org.web3j.utils.Convert;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.KeyPairGenerator;
import java.security.Provider;
import java.security.Security;

public class MainActivity extends AppCompatActivity {

    private Web3j web3;
    //FIXME: Add your own password here
    private final String password = "medium";
    private String walletPath;
    private File walletDir;
    private final static BigInteger GAS_LIMIT = BigInteger.valueOf(6721975L);
    private final static BigInteger GAS_PRICE = BigInteger.valueOf(20000000000L);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setupBouncyCastle();
        walletPath = getFilesDir().getAbsolutePath();
//        Web3j web3j = Web3j.build(new HttpService());


    }

    public void connectToEthNetwork(View v) {
        toastAsync("Connecting to Ethereum network...");
        // FIXME: Add your own API key here
        https://rinkeby.infura.io/v3/69ee326bc0634f43b061987860870e21
        web3 = Web3j.build(new HttpService("https://rinkeby.infura.io/v3/69ee326bc0634f43b061987860870e21"));
        try {
            Credentials credentials = Credentials.create("8dca219c3c89eaab65f6edc33a67d3c86b9fb8d58f5a13ede07f7c64f99a6855");
            AddressResolver address = AddressResolver.load("0x0B062174c76dc0cBeA510C8B3C6089FedDE9135C",web3,credentials,GAS_PRICE,GAS_LIMIT);
            address.owner();
            Web3ClientVersion clientVersion = web3.web3ClientVersion().sendAsync().get();
            if(!clientVersion.hasError()){
                toastAsync("Connected!");
            }
            else {
                toastAsync(clientVersion.getError().getMessage());
            }
        } catch (Exception e) {
            toastAsync(e.getMessage());
        }
    }

    public void createWallet(View v){

        try{
            String fileName =  WalletUtils.generateLightNewWalletFile(password,walletDir);
            walletDir = new File(walletPath + "/" + fileName);
            toastAsync("Wallet generated");
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
            Credentials credentials = Credentials.create("8dca219c3c89eaab65f6edc33a67d3c86b9fb8d58f5a13ede07f7c64f99a6855");
            TransactionReceipt receipt = Transfer.sendFunds(web3,credentials,"0x0B062174c76dc0cBeA510C8B3C6089FedDE9135C",new BigDecimal(5),Convert.Unit.ETHER).sendAsync().get();
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
}
