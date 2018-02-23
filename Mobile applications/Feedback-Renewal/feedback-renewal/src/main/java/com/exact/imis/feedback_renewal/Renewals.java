package com.exact.imis.feedback_renewal;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;


public class Renewals extends Activity {

    ListView lv;
    SwipeRefreshLayout swipe;
    ArrayList<HashMap<String, String>> RenewalList = new ArrayList<HashMap<String, String>>();
    String OfficerCode, IMEI, PhoneNumber;
    Global global;
    General _general = new General();


    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.renewals);

        global = (Global) getApplicationContext();
        OfficerCode = global.getOfficerCode();
        IMEI = global.getIMEI();
        PhoneNumber = global.getPhoneNumber();

        lv = (ListView) findViewById(R.id.lvRenewals);
        fillRenewals();

        swipe = (SwipeRefreshLayout) findViewById(R.id.swipe);
        swipe.setColorSchemeResources(
                R.color.DarkBlue,
                R.color.Maroon,
                R.color.LightBlue,
                R.color.Red);

        swipe.setEnabled(false);

        swipe.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {

//                try {
//                    RefreshRenewals();
//                    swipe.setRefreshing(false);
//                } catch (IOException e) {
//                    e.printStackTrace();
//                } catch (XmlPullParserException e) {
//                    e.printStackTrace();
//                }

                swipe.setRefreshing(true);
                (new Handler()).postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            RefreshRenewals();
                            swipe.setRefreshing(false);
                        } catch (IOException e) {
                            e.printStackTrace();
                        } catch (XmlPullParserException e) {
                            e.printStackTrace();
                        }

                    }
                }, 3000);
            }
        });

        lv.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {

            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                if (firstVisibleItem == 0)
                    swipe.setEnabled(true);
                else
                    swipe.setEnabled(false);
            }
        });

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Intent intent = new Intent(Renewals.this, Renewal.class);

                HashMap<String, String> oItem;
                oItem = (HashMap<String, String>) parent.getItemAtPosition(position);

                intent.putExtra("CHFID", oItem.get("CHFID"));
                intent.putExtra("ProductCode", oItem.get("ProductCode"));
                intent.putExtra("RenewalId", oItem.get("RenewalId"));

                Renewals.this.startActivityForResult(intent, 0);

            }
        });

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 0) {
            fillRenewals();
        }
    }

    protected AlertDialog ShowDialog(String msg) {
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

    private void FetchPayers() throws IOException, XmlPullParserException {
        if (_general.isNetworkAvailable(Renewals.this)) {
            //Caller has the check alraeady
            // if (!isValidPhone()) return;

            global = (Global) getApplicationContext();
            String result;
            CallSoap cs = new CallSoap();
            cs.setFunctionName("GetPayers");

            result = cs.getPayers(global.getOfficerCode().toString());

            DataBaseHelper myDBHelper = new DataBaseHelper(this);
            myDBHelper = new DataBaseHelper(this);

            String TableName = "tblPayers";
            String[] Columns = {"PayerId", "PayerType", "PayerTypeDescription", "PayerName", "OfficerCode"};
            String Where = "OfficerCode = '" + global.getOfficerCode() + "' ";

            myDBHelper.CleanTable(TableName, Where);

            try {
                myDBHelper.InsertData(TableName, Columns, result);
            } catch (JSONException e) {
                e.printStackTrace();
                ShowDialog(getResources().getString(R.string.ErrorOccurred));
            }


        } else {
            ShowDialog(getResources().getString(R.string.NoInternet));
        }

    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    private void RefreshRenewals() throws IOException, XmlPullParserException {

        if (_general.isNetworkAvailable(Renewals.this)) {

            if (!isValidPhone()) return;

            FetchPayers();

            global = (Global) getApplicationContext();
            String result;
            CallSoap cs = new CallSoap();
            cs.setFunctionName("getRenewals");
            //result = cs.getFeedbackRenewals(global.getOfficerCode().toString(), global.getIMEI());
            result = cs.getFeedbackRenewals(global.getOfficerCode().toString(), global.getPhoneNumber());

            DataBaseHelper myDBHelper = new DataBaseHelper(this);
            myDBHelper = new DataBaseHelper(this);

            String TableName = "tblRenewals";
            String[] Columns = {"RenewalId", "PolicyId", "OfficerId", "OfficerCode", "CHFID", "LastName", "OtherNames", "ProductCode", "ProductName", "VillageName", "RenewalPromptDate", "IMEI", "Phone"};
            String Where = "isDone = 'N'";

            myDBHelper.CleanTable(TableName, Where);
            try {
                myDBHelper.InsertData(TableName, Columns, result);
            } catch (JSONException e) {
                ShowDialog(getResources().getString(R.string.ErrorOccurred));
            } finally {
                swipe.setRefreshing(false);
            }

            fillRenewals();
        } else {
            ShowDialog(getResources().getString(R.string.NoInternet));
        }


    }

    private void fillRenewals() {

        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);

        String TableName = "tblRenewals";
        String[] Columns = {"RenewalId", "PolicyId", "OfficerId", "OfficerCode", "CHFID", "LastName", "OtherNames", "ProductCode", "ProductName", "VillageName", "RenewalPromptDate", "IMEI", "Phone"};
        //String Where = "OfficerCode = '" + OfficerCode + "' AND IMEI = '" + IMEI + "' AND isDone = 'N'";
        String Where = "OfficerCode = '" + OfficerCode + "' AND Phone = '" + PhoneNumber + "' AND isDone = 'N'";

        String result = myDBHelper.getData(TableName, Columns, Where);

        JSONArray jsonArray = null;
        JSONObject object;

        try {
            jsonArray = new JSONArray(result);

            if (jsonArray.length() == 0) {
               RenewalList.clear();
//                if (RenewalList.size() == 1) {
//                    RenewalList.removeAll(RenewalList);
//                }
                Toast.makeText(this, getResources().getString(R.string.NoRenewalFound), Toast.LENGTH_LONG).show();

               // return;
            } else {
                RenewalList.clear();
                for (int i = 0; i < jsonArray.length(); i++) {

                    object = jsonArray.getJSONObject(i);

                    HashMap<String, String> Renewal = new HashMap<String, String>();
                    Renewal.put("RenewalId", object.getString("RenewalId"));
                    Renewal.put("CHFID", object.getString("CHFID"));
                    Renewal.put("FullName", object.getString("LastName") + " " + object.getString("OtherNames"));
                    Renewal.put("Product", object.getString("ProductCode") + " : " + object.getString("ProductName"));
                    Renewal.put("VillageName", object.getString("VillageName"));
                    Renewal.put("RenewalPromptDate", object.getString("RenewalPromptDate"));
                    Renewal.put("PolicyId", object.getString("PolicyId"));
                    Renewal.put("ProductCode", object.getString("ProductCode"));


                    RenewalList.add(Renewal);
                }
            }


            ListAdapter adapter = new SimpleAdapter(Renewals.this, RenewalList, R.layout.renewallist,
                    new String[]{"CHFID", "FullName", "Product", "VillageName", "RenewalPromptDate"},
                    new int[]{R.id.tvCHFID, R.id.tvFullName, R.id.tvProduct, R.id.tvVillage, R.id.tvTime});

            lv.setAdapter(adapter);

            setTitle("Renewals (" + String.valueOf(lv.getCount()) + ")");

        } catch (JSONException e) {
            e.printStackTrace();
        }

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater menuInflater = new MenuInflater(this);
        menuInflater.inflate(R.menu.menu_statistics, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.mnuStatistics:
                Intent stats = new Intent(Renewals.this, Statistics.class);
                stats.putExtra("Title", "Renewal Statistics");
                stats.putExtra("Caller", "R");
                Renewals.this.startActivity(stats);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}