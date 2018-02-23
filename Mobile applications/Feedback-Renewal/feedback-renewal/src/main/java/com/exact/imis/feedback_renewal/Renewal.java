package com.exact.imis.feedback_renewal;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.os.Environment;
import android.util.Xml;
import android.view.View;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.SimpleAdapter;
import android.widget.Spinner;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;
import com.exact.uploadfile.UploadFile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlSerializer;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

public class Renewal extends Activity {


    General _General = new General();
    EditText etOfficer, etCHFID, etReceiptNo, etProductCode, etAmount;
    Button btnSubmit;
    ProgressDialog pd;
    CheckBox chkDiscontinue;
    Spinner spPayer;
    AutoCompleteTextView etPayer;
    File[] Renewals;
    String FileName;
    File PolicyXML;

    final static String Path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/IMIS/";

    Global global;
    int RenewalId;
    int result;

    ArrayList<HashMap<String, String>> PayersList = new ArrayList<HashMap<String, String>>();
    SQLiteDatabase db;
    DataBaseHelper sql;
    //1 = Data uploaded on server and accepted
    //2 = Data uploaded but rejected
    //3 = Data saved on local memory



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sql = new DataBaseHelper(this);
        sql.onOpen(db);

        setContentView(R.layout.renewal);

        global = (Global) getApplicationContext();

        etOfficer = (EditText) findViewById(R.id.etofficer);
        etCHFID = (EditText) findViewById(R.id.etCHFID);
        etReceiptNo = (EditText) findViewById(R.id.etReceiptNo);
        etProductCode = (EditText) findViewById(R.id.etProductCode);
        etAmount = (EditText) findViewById(R.id.etAmount);
        btnSubmit = (Button) findViewById(R.id.btnSubmit);
        chkDiscontinue = (CheckBox) findViewById(R.id.chkDiscontinue);

        etOfficer.setText(global.getOfficerCode().toString());
        RenewalId = Integer.parseInt(getIntent().getStringExtra("RenewalId"));
        etCHFID.setText(getIntent().getStringExtra("CHFID"));

        etProductCode.setText(getIntent().getStringExtra("ProductCode"));

        spPayer = (Spinner) findViewById(R.id.spPayer);
         etPayer=(AutoCompleteTextView)findViewById(R.id.etOfficer);
        BindSpinnerPayers();

        PayerAdapter adapter = new PayerAdapter(Renewal.this,null);
        etPayer.setAdapter(adapter);
        etPayer.setThreshold(1);

        etPayer.setOnItemClickListener(adapter);

        chkDiscontinue.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (chkDiscontinue.isChecked())
                    DiscontinuePolicy();
            }
        });

        btnSubmit.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                if (!chkDiscontinue.isChecked())
                    if (isValidate() == false) return;

                pd = ProgressDialog.show(Renewal.this, "", getResources().getString(R.string.Uploading));

                new Thread() {
                    public void run() {
                        WriteXML();

                        //Upload if internet is available
                        if (_General.isNetworkAvailable(Renewal.this)) {
                            if (!isValidPhone()) return;
                            UploadFile uf = new UploadFile();

                            if (uf.uploadFileToServer(Renewal.this, PolicyXML)) {
                                if (ServerResponse()) {
                                    result = 1;
                                } else {
                                    result = 2;
                                }
                            } else {
                                result = 3;
                            }
                        } else {
                            result = 3;
                        }
                        File file = PolicyXML;
                        MoveFile(file);

                        runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                switch (result) {
                                    case 1:
                                        DeleteRow(RenewalId);
                                        ShowDialog(getResources().getString(R.string.UploadedSuccessfully));
                                        break;
                                    case 2:
                                        DeleteRow(RenewalId);
                                        ShowDialog(getResources().getString(R.string.ServerRejected));
                                        break;
                                    case 3:
                                        UpdateRow(RenewalId);
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
                //}else{
                //    DiscontinuePolicy();
                //}
            }
        });

    }

    private boolean isValidPhone() {
        global = (Global) getApplicationContext();
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

    private boolean isValidate() {
        if (etOfficer.getText().length() == 0) {
            ShowDialog(getResources().getString(R.string.MissingOfficer));
            etOfficer.requestFocus();
            return false;
        }

        if (etCHFID.getText().length() == 0) {
            ShowDialog(getResources().getString(R.string.MissingCHFID));
            etCHFID.requestFocus();
            return false;
        }

        if (!isValidCHFID()) {
            ShowDialog(getResources().getString(R.string.InvalidCHFID));
            etCHFID.requestFocus();
            return false;
        }

        if (etReceiptNo.getText().length() == 0) {
            ShowDialog(getResources().getString(R.string.MissingReceiptNo));
            etReceiptNo.requestFocus();
            return false;
        }

        if (etProductCode.getText().length() == 0) {
            ShowDialog(getResources().getString(R.string.MissingProductCode));
            etProductCode.requestFocus();
            return false;
        }

        if (etAmount.getText().length() == 0) {
            ShowDialog(getResources().getString(R.string.MissingAmount));
            etAmount.requestFocus();
            return false;
        }

        if (_General.isNetworkAvailable(Renewal.this)) {
            if (etReceiptNo.getText().toString().trim().length() > 0) {
                if (!isUniqueReceiptNo()) {
                    ShowDialog(getResources().getString(R.string.InvalidReceiptNo));
                    etReceiptNo.requestFocus();
                    return false;
                }
            }
        }
//        if(etPayer.getText().length() ==0){
//          //  ShowDialog(etPayer, getResources().getString(R.string.MissingClaimID));
//            return false;
//        }
        return true;
    }

    private String GetSelectedPayer() {
        String Payer = "";
        HashMap<String, String> P = new HashMap<String, String>();
        P = (HashMap<String, String>) spPayer.getSelectedItem();
        return P.get("PayerId");
    }

    private void WriteXML() {
        try {
            //Create All directories
            File MyDir = new File(Path);
            MyDir.mkdir();

            File DirRejected = new File(Path + "RejectedRenewal");
            DirRejected.mkdir();

            File DirAccepted = new File(Path + "AcceptedRenewal");
            DirAccepted.mkdir();

            //Create File name
            SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
            Calendar cal = Calendar.getInstance();
            String d = format.format(cal.getTime());
            FileName = "RenPol_" + d + "_" + etCHFID.getText().toString() + "_" + etReceiptNo.getText().toString() + ".xml";

            String PayerId = GetSelectedPayer();

            //Create XML file
            PolicyXML = new File(MyDir, FileName);

            FileOutputStream fos = new FileOutputStream(PolicyXML);

            XmlSerializer serializer = Xml.newSerializer();

            serializer.setOutput(fos, "UTF-8");
            serializer.startDocument(null, Boolean.valueOf(true));
            serializer.setFeature("http://xmlpull.org/v1/doc/features.html#indent-output", true);
            serializer.startTag(null, "Policy");

            serializer.startTag(null, "RenewalId");
            serializer.text(String.valueOf(RenewalId));
            serializer.endTag(null, "RenewalId");

            serializer.startTag(null, "Officer");
            serializer.text(etOfficer.getText().toString());
            serializer.endTag(null, "Officer");

            serializer.startTag(null, "CHFID");
            serializer.text(etCHFID.getText().toString());
            serializer.endTag(null, "CHFID");

            serializer.startTag(null, "ReceiptNo");
            serializer.text(etReceiptNo.getText().toString());
            serializer.endTag(null, "ReceiptNo");

            serializer.startTag(null, "ProductCode");
            serializer.text(etProductCode.getText().toString());
            serializer.endTag(null, "ProductCode");

            serializer.startTag(null, "Amount");
            serializer.text(etAmount.getText().toString());
            serializer.endTag(null, "Amount");

            serializer.startTag(null, "Date");
            serializer.text(d);
            serializer.endTag(null, "Date");

            serializer.startTag(null, "Discontinue");
            serializer.text(String.valueOf(chkDiscontinue.isChecked()));
            serializer.endTag(null, "Discontinue");

            serializer.startTag(null, "PayerId");
            serializer.text(PayerId);
            serializer.endTag(null, "PayerId");

            serializer.endTag(null, "Policy");
            serializer.endDocument();
            serializer.flush();
            fos.flush();
            fos.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private boolean ServerResponse() {
        CallSoap cs = new CallSoap();
        cs.setFunctionName("isValidRenewal");
        return cs.isPolicyAccepted(PolicyXML.getName().toString());
    }

    private void MoveFile(File file) {
        switch (result) {
            case 1:
                file.renameTo(new File(Path + "AcceptedRenewal/" + file.getName()));
                break;
            case 2:
                file.renameTo(new File(Path + "RejectedRenewal/" + file.getName()));
                break;
        }
    }
//herman
    protected AlertDialog ShowDialog(String msg) {
        return new AlertDialog.Builder(this)
                .setMessage(msg)
                .setCancelable(false)
                .setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //et.requestFocus();
                        finish();
                        return;
                    }
                }).show();

    }

    private void DeleteRow(int RenewalId) {
        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);
        String TableName = "tblRenewals";
        String Where = "RenewalId = " + RenewalId;

        myDBHelper.CleanTable(TableName, Where);

    }

    private void UpdateRow(int RenewalId) {
        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);
        String TableName = "tblRenewals";
        String Updates = "isDone = 'Y'";
        String Where = "RenewalId = " + RenewalId;

        myDBHelper.UpdateTable(TableName, Updates, Where);
    }

    private boolean isValidCHFID() {

//        if (etCHFID.getText().toString().length() != 9) return false;
//        String chfid;
//        int Part1, Part2;
//        Part1 = Integer.parseInt(etCHFID.getText().toString()) / 10;
//        Part2 = Part1 % 7;
//
//        chfid = etCHFID.getText().toString().substring(0, 8) + Integer.toString(Part2);
//        return etCHFID.getText().toString().equals(chfid);

        return  true;
    }

    private boolean isUniqueReceiptNo() {

        CallSoap cs = new CallSoap();
        cs.setFunctionName("isUniqueReceiptNo");
        return cs.isUniqueReceiptNo(etReceiptNo.getText().toString(), etCHFID.getText().toString());

    }

    private void DiscontinuePolicy() {

        new AlertDialog.Builder(this)
                .setMessage(R.string.DiscontinuePolicyQ)
                .setPositiveButton(R.string.Yes, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //CallSoap cs = new CallSoap();
                        //cs.setFunctionName("DiscontinuePolicy");
                        //cs.DiscontinuePolicy(RenewalId);
                        //DeleteRow(RenewalId);
                        //finish();
                        dialog.dismiss();
                    }
                })
                .setNegativeButton(R.string.No, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        chkDiscontinue.setChecked(false);
                    }
                }).show();
    }

    private void BindSpinnerPayers() {
        DataBaseHelper sql = new DataBaseHelper(this);
        String TableName = "tblPayers";
        String Columns[] = {"PayerId", "PayerName", "PayerTypeDescription"};
        String Where = "OfficerCode = '" + global.getOfficerCode() + "'";

        String result = sql.getData(TableName, Columns, Where);

        JSONArray jsonArray = null;
        JSONObject object;

        try {
            jsonArray = new JSONArray(result);

            PayersList.clear();

            for (int i = 0; i < jsonArray.length(); i++) {
                object = jsonArray.getJSONObject(i);

                HashMap<String, String> Payer = new HashMap<String, String>();
                Payer.put("PayerId", object.getString("PayerId"));
                Payer.put("PayerName", object.getString("PayerName"));
                Payer.put("PayerTypeDescription", object.getString("PayerTypeDescription"));

                PayersList.add(Payer);

                SimpleAdapter adapter = new SimpleAdapter(Renewal.this, PayersList, R.layout.spinnerpayer,
                        new String[]{"PayerId", "PayerName", "PayerTypeDescription"},
                        new int[]{R.id.tvPayerId, R.id.tvPayerName, R.id.tvPayerDescription});

                spPayer.setAdapter(adapter);

            }

        } catch (JSONException e) {
            e.printStackTrace();
        }

    }
}
