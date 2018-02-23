package com.exact.imis.feedback_renewal;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Vibrator;
import android.provider.MediaStore;
import android.telephony.PhoneNumberUtils;
import android.telephony.TelephonyManager;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;
import com.exact.uploadfile.UploadFile;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.regex.Pattern;


public class MainActivity extends Activity {

    General _General = new General();
    String VersionName;

    final CharSequence[] lang = {"English","Français"};
    static String Language;
    final String VersionField = "AppVersionFeedbackRenewal";
    final String ApkFileLocation = _General.getDomain() + "/Apps/Feedback_Renewal.apk";
    final int SIMPLE_NOTIFICATION_ID = 83;
    String UniqueId, PhoneNumber;
    String aBuffer = "";//herman

    NotificationManager mNotificationManager;
    Vibrator vibrator;
    TextView tvPhoneNumber;

    EditText etOfficerCode;
    Button btnRenewal, btnFeedback, btnUpload;
    ImageButton btnAddPhone;//herman

    ProgressDialog pd;
    UploadFile uf = new UploadFile();
    File[] files;
    int TotalFiles,UploadCounter;
    String FileName;
    File XMLFile;

    int result;
    //1 = Data uploaded on server and accepted
    //2 = Data uploaded but rejected
    //3 = Data saved on local memory

    final String Path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/IMIS/";

    Runnable ChangeMessage = new Runnable() {

        @Override
        public void run() {
            //Change progress dialog message here
            pd.setMessage(UploadCounter + " " + getResources().getString(R.string.Of) + " " + TotalFiles + " " + getResources().getString(R.string.Uploading));

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new AlertDialog.Builder(this)
                .setTitle("Select Language")
                .setCancelable(false)
                .setItems(lang,new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if(lang[which].toString()=="English")Language = "en";else Language = "fr";
//        Language = "en";
                        _General.ChangeLanguage(MainActivity.this, Language);

                        setContentView(R.layout.activity_main);

                        //Close the application if SD card is not available or set to readonly mode.
                        isSDCardAvailable();

                        //Check if network available
                        if (_General.isNetworkAvailable(MainActivity.this)){

                        }else{
                            setTitle(getResources().getString(R.string.app_name) + "-" + getResources().getString(R.string.OfflineMode));
                            setTitleColor(getResources().getColor(R.color.Red));
                        }

                        //Check if any updates available on the server.
                        new Thread(){
                            public void run(){
                                CheckForUpdates();
                            }
                        }.start();

                        etOfficerCode = (EditText)findViewById(R.id.etOfficerCode);
                        btnFeedback = (Button)findViewById(R.id.btnFeedback);
                        btnRenewal = (Button)findViewById(R.id.btnRenewal);
                        btnUpload = (Button)findViewById(R.id.btnUpload);
                        tvPhoneNumber = (TextView)findViewById(R.id.tvPhoneNumber);
                        btnAddPhone = (ImageButton) findViewById(R.id.btnAddPhone);//herman

                        final Global global = (Global)getApplicationContext();

                        etOfficerCode.addTextChangedListener(new TextWatcher() {
                            @Override
                            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                            }

                            @Override
                            public void onTextChanged(CharSequence s, int start, int before, int count) {
                                global.setOfficerCode(s.toString());
                            }

                            @Override
                            public void afterTextChanged(Editable s) {

                            }
                        });

                        btnFeedback.setOnClickListener(new View.OnClickListener() {

                            @Override
                            public void onClick(View v) {
                                if(isValidData() == false) return;
                                Intent FeedbackIntent = new Intent(MainActivity.this,Feedbacks.class);
                                MainActivity.this.startActivity(FeedbackIntent);
                            }
                        });

                        btnRenewal.setOnClickListener(new View.OnClickListener() {

                            @Override
                            public void onClick(View v) {
                                if(isValidData() == false) return;
                                Intent RenewalIntent = new Intent(MainActivity.this,Renewals.class);
                                MainActivity.this.startActivity(RenewalIntent);
                            }
                        });

                        btnUpload.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                if(isValidData() == false) return;
                                SubmitAllFiles();
                            }
                        });
                        //herman
                        btnAddPhone.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                promptPhone();
                            }
                        });

                        TelephonyManager tm = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
                        UniqueId = tm.getDeviceId();
                        try
                        {

                            if(!tm.getLine1Number().equals("")){
                                PhoneNumber = tm.getLine1Number();// Alternative HERMAN PhoneNumber = tm.getDeviceId();
                            }else if(getXMLPhoneNumber() != ""){
                                PhoneNumber = getXMLPhoneNumber().toString();
                                btnAddPhone.setVisibility(View.VISIBLE);
                            }else {
                                PhoneNumber = getResources().getString(R.string.PhoneMissing);
                                btnAddPhone.setVisibility(View.VISIBLE);
                            }
                        }
                        catch(NullPointerException ex)
                        {
                        }

                        global.setIMEI(UniqueId);
                        global.setPhoneNumber(PhoneNumber);

                        tvPhoneNumber.setText(PhoneNumber);

        VersionName = _General.getVersion(MainActivity.this, getApplicationContext().getPackageName());
        RelativeLayout RL = (RelativeLayout)findViewById((R.id.RL));
        RL.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                ShowDialog(getResources().getString(R.string.ApplicationVersionIs) + ' ' + VersionName);
                return true;
            }
        });
                        CreateDatabase();


                    }
                }).show();

    }
    //herman
    public void promptPhone(){
        // get prompts.xml view
        LayoutInflater li = LayoutInflater.from(this);
        View promptsView = li.inflate(R.layout.prompt, null);

        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
                this);

        // set prompts.xml to alertdialog builder
        alertDialogBuilder.setView(promptsView);

        final EditText userInput = (EditText) promptsView
                .findViewById(R.id.editTextDialogUserInput);

        // set dialog message
        alertDialogBuilder
                .setCancelable(false)
                .setPositiveButton("OK",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,int id) {
                                // get user input and set it to result
                                // edit text
                                PhoneNumber = userInput.getText().toString();
                                Global global = (Global)getApplicationContext();
                                global.setPhoneNumber(PhoneNumber);
                                tvPhoneNumber.setText(PhoneNumber);
                                saveXmlPhone(PhoneNumber);
                            }
                        })
                .setNegativeButton("Cancel",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,int id) {
                                dialog.cancel();
                            }
                        });

        // create alert dialog
        AlertDialog alertDialog = alertDialogBuilder.create();

        // show it
        alertDialog.show();
    }
    //herman
    private void saveXmlPhone(String phone) {
        if (!Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            //handle case of no SDCARD present
        } else {
            String dir = Environment.getExternalStorageDirectory() + File.separator + "IMIS/phone/";
            //create folder
            File folder = new File(dir); //folder name
            folder.mkdirs();

            //create file
            File file = new File(dir, "PhoneNumber.txt");
            try {
                file.createNewFile();
                FileOutputStream fOut = new FileOutputStream(file);
                OutputStreamWriter myOutWriter = new OutputStreamWriter(fOut);
                myOutWriter.append(phone);
                myOutWriter.close();
                fOut.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    //herman
    public String getXMLPhoneNumber(){
        try {
            String dir = Environment.getExternalStorageDirectory() + File.separator + "IMIS/phone/";
            File myFile = new File("/"+dir+"/PhoneNumber.txt");
            FileInputStream fIn = new FileInputStream(myFile);
            BufferedReader myReader = new BufferedReader(new InputStreamReader(fIn));
            aBuffer = myReader.readLine();
            myReader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return aBuffer;
    }
    private void CreateDatabase(){
        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);

        try {
            myDBHelper.createDatabase();
        } catch (IOException e) {
            throw new Error("Unable to create database");
        }

    }
    private void isSDCardAvailable(){
        if (_General.isSDCardAvailable() == 0){
            //Toast.makeText(this, "SD Card is in read only mode.", Toast.LENGTH_LONG);
            new AlertDialog.Builder(this)
                    .setMessage(getResources().getString(R.string.ReadOnly))
                    .setCancelable(false)
                    .setPositiveButton(getResources().getString(R.string.ForceClose), new android.content.DialogInterface.OnClickListener() {

                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            finish();
                        }
                    }).show();

        }else if(_General.isSDCardAvailable() == -1){
            new AlertDialog.Builder(this)
                    .setMessage(getResources().getString(R.string.NoSDCard))
                    .setCancelable(false)
                    .setPositiveButton(getResources().getString(R.string.ForceClose), new android.content.DialogInterface.OnClickListener() {

                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            finish();
                        }
                    }).create().show();
        }else{

        }
    }
    private void CheckForUpdates(){
        if(_General.isNetworkAvailable(MainActivity.this)){
            if(_General.isNewVersionAvailable(VersionField,MainActivity.this,getApplicationContext().getPackageName())){
                //Show notification bar
                mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);

                final Notification NotificationDetails = new Notification(R.drawable.ic_launcher, getResources().getString(R.string.NotificationAlertText), System.currentTimeMillis());

                NotificationDetails.flags = Notification.FLAG_SHOW_LIGHTS | Notification.FLAG_AUTO_CANCEL | Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE;

                Context context = getApplicationContext();
                CharSequence ContentTitle = getResources().getString(R.string.ContentTitle);
                CharSequence ContentText = getResources().getString(R.string.ContentText);

                Intent NotifyIntent = new Intent(android.content.Intent.ACTION_VIEW, Uri.parse(ApkFileLocation));

                PendingIntent intent = PendingIntent.getActivity(MainActivity.this, 0, NotifyIntent,0);
                NotificationDetails.setLatestEventInfo(context, ContentTitle, ContentText, intent);

                mNotificationManager.notify(SIMPLE_NOTIFICATION_ID, NotificationDetails);

                vibrator = (Vibrator)getSystemService(VIBRATOR_SERVICE);
                vibrator.vibrate(500);

            }
        }
    }
    protected AlertDialog ShowDialog(String msg){
        return new AlertDialog.Builder(this)
                .setMessage(msg)
                .setCancelable(false)
                .setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //tv.requestFocus();
                        return;
                    }
                }).show();
    }
    private boolean isValidData(){
        if (etOfficerCode.getText().toString().trim().length() == 0){
            ShowDialog(getResources().getString(R.string.MissingOfficerCode));
            etOfficerCode.requestFocus();
            return false;
        }
        return true;
    }
    private void SubmitAllFiles(){
        //Get the total number of files to upload
        files = GetListOfFiles(Path);
        TotalFiles = files.length;

        //If there are no files to upload give the message and exit
        if (TotalFiles == 0){
            ShowDialog(getResources().getString(R.string.NoFiles));
            //Clean tables in database as well
            DataBaseHelper myDBHelper = new DataBaseHelper(this);
            myDBHelper = new DataBaseHelper(this);
            String Where = "isDone = 'Y'";

            myDBHelper.CleanTable("tblRenewals",Where);
            myDBHelper.CleanTable("tblFeedbacks",Where);

            return;
        }

        //If internet is not available then give message and exit
        if (!_General.isNetworkAvailable(this)){
            ShowDialog(getResources().getString(R.string.CheckInternet));
            return;
        }

        pd = new ProgressDialog(this);
        pd.setCancelable(false);

        pd = ProgressDialog.show(MainActivity.this,"",getResources().getString(R.string.Uploading));

        new Thread(){
            public void run(){

                //Check if valid ftp credentials are available
                if(ConnectsFTP()){
                    if(!isValidPhone()) return;
                    //Start Uploading files
                    UploadAllFiles();
                }else{
                    result = -1;
                }

                runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        switch(result){
                            case -1:
                                ShowDialog(getResources().getString(R.string.FTPConnectionFailed));
                                break;
                            default:
                                ShowDialog(getResources().getString(R.string.BulkUpload));
                        }
                    }
                });

                pd.dismiss();
            }

        }.start();
    }
    private void UploadAllFiles(){
        for(int i=0;i<files.length;i++){
            UploadCounter = i + 1;
            runOnUiThread(ChangeMessage);
            if(uf.uploadFileToServer(this,files[i])){
                XMLFile = files[i];
                if(ServerResponse())
                    result = 1;
                else
                    result = 2;
                MoveFile(XMLFile);
            }
        }
    }
    private boolean ServerResponse(){
        CallSoap cs = new CallSoap();
        if (XMLFile.getName().contains("RenPol_")) {
            cs.setFunctionName("isValidRenewal");
            return cs.isPolicyAccepted(XMLFile.getName().toString());
        }else if(XMLFile.getName().contains("feedback_")){
            cs.setFunctionName("isValidFeedback");
            return cs.isFeedbackAccepted(XMLFile.getName().toString());
        }
        return false;
    }
    private void MoveFile(File file){
        String Accepted = "", Rejected = "";
        if (file.getName().contains("RenPol_")){
            Accepted = "AcceptedRenewal/";
            Rejected = "RejectedRenewal/";
        }else if(file.getName().contains("feedback_")){
            Accepted = "AcceptedFeedback/";
            Rejected = "RejectedFeedback/";
        }

        switch(result){
            case 1:
                file.renameTo(new File(Path + Accepted + file.getName()));
                break;
            case 2:
                file.renameTo(new File(Path + Rejected + file.getName()));
                break;
        }
    }
    private File[] GetListOfFiles(String DirectoryPath){
        File Directory = new File(DirectoryPath);
        final Pattern p = Pattern.compile("(RenPol_)");
        FilenameFilter filter = new FilenameFilter() {

            @Override
            public boolean accept(File dir, String filename) {
                return filename.startsWith("RenPol_") || filename.startsWith("feedback_");
            }
        };
        return Directory.listFiles(filter);
    }
    private boolean ConnectsFTP(){

        return uf.isValidFTPCredentials();

    }
    private boolean isValidPhone(){
       int result;
        CallSoap cs = new CallSoap();
        cs.setFunctionName("isValidPhone");
//        result = cs.isValidPhone(etOfficerCode.getText().toString(), UniqueId);
        result = cs.isValidPhone(etOfficerCode.getText().toString(), PhoneNumber);

        if (result == 0) {
            ShowDialog(getResources().getString(R.string.InvalidPhone) + " " + etOfficerCode.getText().toString());
            return false;
        } else if(result == 1) {
            return true;
        }else{
            ShowDialog(getResources().getString(R.string.ConnectionFail));
            return false;
        }
    }
}
