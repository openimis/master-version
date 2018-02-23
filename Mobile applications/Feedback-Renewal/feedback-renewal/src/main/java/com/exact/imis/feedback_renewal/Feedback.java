package com.exact.imis.feedback_renewal;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Environment;
import android.util.Xml;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RatingBar;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;
import com.exact.uploadfile.UploadFile;

import org.xmlpull.v1.XmlSerializer;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;


public class Feedback extends Activity {

    General _General = new General();
    Global global;
    EditText etOfficer, etClaimCode, etCHFID;
    RadioGroup rg1,rg2,rg3,rg4;
    RadioButton rbYes1,rbYes2,rbYes3,rbYes4,rbNo1,rbNo2,rbNo3,rbNo4;
    RatingBar rb1;
    ProgressDialog pd;
    Button btnSubmit;

    int ClaimId;
    File FeedbackXML;
    String FileName;
    final String Path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/IMIS/";

    int msgType;
    //-1: FTP Connection failed
    // 1: Feedback uploaded on server successfully.
    // 2: Feedback uploaded but rejected by the server
    // 3: Saved on External storage device

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.feedback);

        global = (Global)getApplicationContext();

        etOfficer = (EditText)findViewById(R.id.etOfficer);
        etClaimCode = (EditText)findViewById(R.id.etClaimCode);
        etCHFID = (EditText)findViewById(R.id.etCHFID);

        rbYes1 = (RadioButton)findViewById(R.id.rYes1);
        rbYes2 = (RadioButton)findViewById(R.id.rYes2);
        rbYes3 = (RadioButton)findViewById(R.id.rYes3);
        rbYes4 = (RadioButton)findViewById(R.id.rYes4);
        rbNo1 = (RadioButton)findViewById(R.id.rNo1);
        rbNo2 = (RadioButton)findViewById(R.id.rNo2);
        rbNo3 = (RadioButton)findViewById(R.id.rNo3);
        rbNo4 = (RadioButton)findViewById(R.id.rNo4);
        btnSubmit = (Button)findViewById(R.id.btnSubmit);

        etOfficer.setText(global.getOfficerCode().toString());
        ClaimId = Integer.parseInt(getIntent().getStringExtra("ClaimId"));
        etClaimCode.setText(getIntent().getStringExtra("ClaimCode"));
        etCHFID.setText(getIntent().getStringExtra("CHFID"));

        btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Check if all the required fields have data

                if (isValidate() == false) return;

                pd = ProgressDialog.show(Feedback.this, "", getResources().getString(R.string.UploadingFeedback));

                new Thread(){
                    public void run(){

                        String Answers = Answers();
                        try {
                            WriteXML(String.valueOf(etOfficer.getText()), String.valueOf(ClaimId),etCHFID.getText().toString(),Answers);
                        } catch (IllegalArgumentException e) {
                            e.printStackTrace();
                            return;
                        } catch (IllegalStateException e) {
                            e.printStackTrace();
                            return;
                        } catch (IOException e) {
                            e.printStackTrace();
                            return;
                        }

                        //Upload if internet is available

                        if(_General.isNetworkAvailable(Feedback.this)){
                            if(!isValidPhone()) return;
                            UploadFile uf = new UploadFile();
                            //String FileName = "feedback_" + etClaim.getText() + ".xml";
                            //File file = new File(Path + FileName);
                            if(uf.uploadFileToServer(Feedback.this,FeedbackXML)){
                                if(ServerResponse()){
                                    msgType = 1;
                                }else{
                                    msgType = 2;
                                }
                            }else{
                                msgType = 3;
                            }
                        }else{
                            msgType = 3;
                        }

                        File file = FeedbackXML;
                        MoveFile(file);

                        runOnUiThread(new Runnable() {
                            public void run() {
                                switch (msgType){
                                    case 1:
                                        DeleteRow(ClaimId);
                                        ShowDialog(getResources().getString(R.string.UploadedSuccessfully));
                                        break;
                                    case 2:
                                        DeleteRow(ClaimId);
                                        ShowDialog(getResources().getString(R.string.ServerRejected));
                                        break;
                                    case 3:
                                        UpdateRow(ClaimId);
                                        ShowDialog(getResources().getString(R.string.SavedOnSDCard));
                                        break;
                                }

                                //Go back to the previous activity.
                                finish();

                            }


                        });



                        pd.dismiss();
                    }

                }.start();


            }
        });

    }


    private void DeleteRow(int ClaimId){
        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);
        String TableName = "tblFeedbacks";
        String Where = "ClaimId = " + ClaimId;

        myDBHelper.CleanTable(TableName,Where);

    }

    private void UpdateRow(int ClaimId){
        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);
        String TableName = "tblFeedbacks";
        String Updates = "isDone = 'Y'";
        String Where = "ClaimId = " + ClaimId;

        myDBHelper.UpdateTable(TableName,Updates,Where);
    }

    private boolean isValidPhone(){
        global = (Global)getApplicationContext();
        int result;
        CallSoap cs = new CallSoap();
        cs.setFunctionName("isValidPhone");
        //result = cs.isValidPhone(global.getOfficerCode().toString(), global.getIMEI());
        result = cs.isValidPhone(global.getOfficerCode().toString(), global.getPhoneNumber());

        if (result==0) {
            ShowDialog(getResources().getString(R.string.InvalidPhone) + " " + global.getOfficerCode().toString());
            return false;
        } else if(result==1) {
            return true;
        } else {
            ShowDialog(getResources().getString(R.string.ConnectionFail));
            return false;
        }
    }
    protected void WriteXML(String Officer,String ClaimID,String CHFID,String Answers) throws IllegalArgumentException, IllegalStateException, IOException{
        //Here we are creating a directory
        File MyDir = new File(Path);
        MyDir.mkdir();

        File DirRejected = new File(Path + "RejectedFeedback");
        DirRejected.mkdir();

        File DirAccepted = new File(Path + "AcceptedFeedback");
        DirAccepted.mkdir();

        //Here we are giving name to the XML file
        FileName = "feedback_" + etClaimCode.getText() + ".xml";

        //Here we are creating file in that directory
        FeedbackXML = new File(MyDir,FileName);


        //Here we are creating outputstream
        FileOutputStream fos = new FileOutputStream(FeedbackXML);


        XmlSerializer serializer = Xml.newSerializer();

        serializer.setOutput(fos, "UTF-8");
        serializer.startDocument(null, Boolean.valueOf(true));
        serializer.setFeature("http://xmlpull.org/v1/doc/features.html#indent-output", true);
        serializer.startTag(null, "feedback");

        serializer.startTag(null, "Officer");
        serializer.text(Officer);
        serializer.endTag(null, "Officer");

        serializer.startTag(null, "ClaimID");
        serializer.text(ClaimID);
        serializer.endTag(null,"ClaimID");

        serializer.startTag(null, "CHFID");
        serializer.text(CHFID);
        serializer.endTag(null, "CHFID");

        serializer.startTag(null, "Answers");
        serializer.text(Answers);
        serializer.endTag(null, "Answers");

        serializer.startTag(null, "Date");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        String d = formatter.format(cal.getTime());
        serializer.text(d);
        serializer.endTag(null, "Date");

        serializer.endTag(null, "feedback");
        serializer.endDocument();
        serializer.flush();
        fos.close();


    }
    private boolean ServerResponse(){
        CallSoap cs = new CallSoap();
        cs.setFunctionName("isValidFeedback");
        return cs.isFeedbackAccepted(FeedbackXML.getName().toString());
    }
    private void MoveFile(File file){
        switch(msgType){
            case 1:
                file.renameTo(new File(Path + "AcceptedFeedback/" + file.getName()));
                break;
            case 2:
                file.renameTo(new File(Path + "RejectedFeedback/" + file.getName()));
                break;
        }
    }
    protected String Answers(){
        String Ans = "";
        rg1 = (RadioGroup)findViewById(R.id.radioGroup1);
        int Ans1 = rg1.getCheckedRadioButtonId();
        rg2 = (RadioGroup)findViewById(R.id.radioGroup2);
        int Ans2 = rg2.getCheckedRadioButtonId();
        rg3 = (RadioGroup)findViewById(R.id.radioGroup3);
        int Ans3 = rg3.getCheckedRadioButtonId();
        rg4 = (RadioGroup)findViewById(R.id.radioGroup4);
        int Ans4 = rg4.getCheckedRadioButtonId();

        if (Ans1 == R.id.rYes1)Ans = "1"; else Ans = "0";
        if (Ans2 == R.id.rYes2)Ans = Ans + "1"; else Ans = Ans + "0";
        if (Ans3 == R.id.rYes3)Ans = Ans + "1"; else Ans = Ans + "0";
        if (Ans4 == R.id.rYes4)Ans = Ans + "1"; else Ans = Ans + "0";

        //Read rating
        rb1 = (RatingBar)findViewById(R.id.ratingBar1);
        Ans = Ans + String.valueOf((int)rb1.getRating());
        return Ans;
    }
    private boolean isValidate(){

        if(etOfficer.getText().length() == 0){
            ShowDialog(getResources().getString(R.string.MissingOfficer));
            etOfficer.requestFocus();
            return false;
        }
        if(etClaimCode.getText().length() == 0){
            ShowDialog(getResources().getString(R.string.MissingClaimID));
            etClaimCode.requestFocus();
            return false;
        }
        if(etCHFID.getText().length() == 0){
            ShowDialog(getResources().getString(R.string.MissingCHFID));
            etCHFID.requestFocus();
            return false;
        }
        if((!rbYes1.isChecked() && !rbNo1.isChecked()) || (!rbYes2.isChecked() && !rbNo2.isChecked()) || (!rbYes3.isChecked() && !rbNo3.isChecked()) || (!rbYes4.isChecked() && !rbNo4.isChecked())){
            ShowDialog(getResources().getString(R.string.MissingAnswers));
            return false;
        }

        return true;
    }

    protected AlertDialog ShowDialog(String msg){
        return new AlertDialog.Builder(this)
                .setMessage(msg)
                .setCancelable(false)
                .setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //et.requestFocus();
                        return;
                    }
                }).show();

    }
}
