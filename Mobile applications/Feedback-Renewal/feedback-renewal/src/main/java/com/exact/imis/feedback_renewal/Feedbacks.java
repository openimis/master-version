package com.exact.imis.feedback_renewal;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
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


public class Feedbacks extends Activity {

    ListView lv;
    SwipeRefreshLayout swipe;
    ArrayList<HashMap<String, String>> FeedbackList = new ArrayList<HashMap<String, String>>();
    String OfficerCode,IMEI, PhoneNumber;
    Global global;
    General _general = new General();


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(resultCode ==0){
            fillFeedbacks();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.feedbacks);

        global = (Global)getApplicationContext();
        OfficerCode = global.getOfficerCode();
        IMEI = global.getIMEI();
        PhoneNumber = global.getPhoneNumber();

        lv = (ListView) findViewById(R.id.lvFeedbacks);
        fillFeedbacks();

        swipe =  (SwipeRefreshLayout) findViewById(R.id.swipe);
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
//                    RefreshFeedbacks();
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
                            swipe.setRefreshing(false);
                            RefreshFeedbacks();
                        } catch (IOException e) {
                            e.printStackTrace();
                        } catch (XmlPullParserException e) {
                            e.printStackTrace();
                        }


                    }
                },  3000);
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

        lv.setOnItemClickListener( new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Intent intent = new Intent(Feedbacks.this,Feedback.class);

                HashMap<String, String> oItem;
                oItem = (HashMap<String, String>) parent.getItemAtPosition(position);

                intent.putExtra("CHFID", oItem.get("CHFID"));
                intent.putExtra("ClaimId", oItem.get("ClaimId"));
                intent.putExtra("ClaimCode", oItem.get("ClaimCode"));

                Feedbacks.this.startActivityForResult(intent, 0);
            }
        });



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

    private void RefreshFeedbacks() throws IOException, XmlPullParserException {
        if(_general.isNetworkAvailable(Feedbacks.this)) {
            if (!isValidPhone()) return;

            global = (Global) getApplicationContext();
            String result;
            CallSoap cs = new CallSoap();
            cs.setFunctionName("getFeedbacks");
            //result = cs.getFeedbackRenewals(global.getOfficerCode().toString(), global.getIMEI());
            result = cs.getFeedbackRenewals(global.getOfficerCode().toString(), global.getPhoneNumber());

            DataBaseHelper myDBHelper = new DataBaseHelper(this);
            myDBHelper = new DataBaseHelper(this);

            String TableName = "tblFeedbacks";
            String[] Columns = {"ClaimId", "OfficerId", "OfficerCode", "CHFID", "LastName", "OtherNames", "HFCode", "HFName", "ClaimCode", "DateFrom", "DateTo", "IMEI", "Phone", "FeedbackPromptDate"};
            String Where = "isDone = 'N'";

            myDBHelper.CleanTable(TableName, Where);
            try {
                myDBHelper.InsertData(TableName, Columns, result);
            } catch (JSONException e) {
                ShowDialog(getResources().getString(R.string.ErrorOccurred));
            }finally {
                swipe.setRefreshing(false);
            }

            fillFeedbacks();
        }else{
            ShowDialog(getResources().getString(R.string.NoInternet));
        }
    }

    private void fillFeedbacks() {

        DataBaseHelper myDBHelper = new DataBaseHelper(this);
        myDBHelper = new DataBaseHelper(this);

        String TableName = "tblFeedbacks";
        String[] Columns = {"ClaimId","OfficerId","OfficerCode","CHFID","LastName","OtherNames","HFCode","HFName","ClaimCode","DateFrom","DateTo","IMEI", "Phone","FeedbackPromptDate"};

        //String Where = "OfficerCode = '"+ OfficerCode +"' AND IMEI = '"+ IMEI +"' AND isDone = 'N'";
        String Where = "OfficerCode = '"+ OfficerCode +"' AND Phone = '"+ PhoneNumber +"' AND isDone = 'N'";

        String result = myDBHelper.getData(TableName,Columns,Where);

        JSONArray jsonArray = null;
        JSONObject object;

        try {
            jsonArray = new JSONArray(result);
            if(jsonArray.length()==0){
                FeedbackList.clear();
                Toast.makeText(this,getResources().getString(R.string.NoFeedbackFound),Toast.LENGTH_LONG).show();
                return;
            }else{
                FeedbackList.clear();

                for(int i= 0;i < jsonArray.length();i++){
                    object = jsonArray.getJSONObject(i);

                    HashMap<String, String> feedback = new HashMap<String, String>();
                    feedback.put("CHFID", object.getString("CHFID"));
                    feedback.put("FullName", object.getString("LastName") + " " + object.getString("OtherNames"));
                    feedback.put("HFName", object.getString("HFCode") + ":" + object.getString("HFName"));
                    feedback.put("ClaimCode", object.getString("ClaimCode"));
                    feedback.put("DateFromTo", object.getString("DateFrom") +" - " + object.getString("DateTo"));
                    feedback.put("FeedbackPromptDate", object.getString("FeedbackPromptDate"));
                    feedback.put("ClaimId", object.getString("ClaimId"));
                    FeedbackList.add(feedback);
                }

                ListAdapter adapter = new SimpleAdapter(Feedbacks.this, FeedbackList, R.layout.feedbacklist,
                        new String[]{"CHFID", "FullName", "HFName","ClaimCode", "DateFromTo", "FeedbackPromptDate"},
                        new int[]{R.id.tvCHFID, R.id.tvFullName, R.id.tvHFName, R.id.tvClaimCode,R.id.tvDates, R.id.tvTime});


                lv.setAdapter(adapter);

                setTitle("Feedbacks (" + String.valueOf(lv.getCount()) + ")");
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

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


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater menuInflater = new MenuInflater(this);
        menuInflater.inflate(R.menu.menu_statistics,menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.mnuStatistics:
                if(!_general.isNetworkAvailable(Feedbacks.this)){
                    ShowDialog(getResources().getString(R.string.InternetRequired));
                    return false;
                }

                if (!isValidPhone()) return false;

                Intent Stats = new Intent(Feedbacks.this,Statistics.class);
                Stats.putExtra("Title","Feedback Statistics");
                Stats.putExtra("Caller","F");
                Feedbacks.this.startActivity(Stats);
                return true;
            default:
                super.onOptionsItemSelected(item);
        }
        return false;

    }
}
