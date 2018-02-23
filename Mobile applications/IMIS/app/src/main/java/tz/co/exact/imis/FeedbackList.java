//Copyright (c) 2016-%CurrentYear% Swiss Agency for Development and Cooperation (SDC)
//
//The program users must agree to the following terms:
//
//Copyright notices
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
//Free Software Foundation, version 3 of the License.
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.
//
//Disclaimer of Warranty
//There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
//holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
//limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
//performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.
//
//Limitation of Liability 
//In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
//conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
//arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
//sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
//advised of the possibility of such damages.
//
//In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.

package tz.co.exact.imis;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by HP on 05/16/2017.
 */

public class FeedbackList extends AppCompatActivity {
    private ListView lv;
    private SwipeRefreshLayout swipe;
    private ArrayList<HashMap<String, String>> FeedbackList = new ArrayList<>();
    private String OfficerCode;

    private General _general = new General();
    private ClientAndroidInterface ca;
    private Global global;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.feedbacks);
        //noinspection ConstantConditions
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        global = (Global) getApplicationContext();
        OfficerCode = global.getOfficerCode();


        lv = (ListView) findViewById(R.id.lvFeedbacks);
        fillFeedbacks();

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

                swipe.setRefreshing(true);
                (new Handler()).postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            swipe.setRefreshing(false);
                            RefreshFeedbacks();

                        } catch (IOException | XmlPullParserException e) {
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
                Intent intent = new Intent(getApplicationContext(), Feedback.class);
                HashMap<String, String> oItem;
                //noinspection unchecked
                oItem = (HashMap<String, String>) parent.getItemAtPosition(position);
                intent.putExtra("CHFID", oItem.get("CHFID"));
                intent.putExtra("ClaimId", oItem.get("ClaimId"));
                intent.putExtra("ClaimCode", oItem.get("ClaimCode"));
                intent.putExtra("OfficerCode", OfficerCode);
                startActivityForResult(intent, 0);
            }
        });


    }

    private void fillFeedbacks() {
        ca = new ClientAndroidInterface(this);
        String result = ca.getOfflineFeedBack(OfficerCode);

        JSONArray jsonArray = null;
        JSONObject object;

        try {
            jsonArray = new JSONArray(result);
            if (jsonArray.length() == 0) {
                FeedbackList.clear();
                Toast.makeText(getApplicationContext(), getResources().getString(R.string.NoFeedbackFound), Toast.LENGTH_LONG).show();
            } else {
                FeedbackList.clear();

                for (int i = 0; i < jsonArray.length(); i++) {
                    object = jsonArray.getJSONObject(i);

                    HashMap<String, String> feedback = new HashMap<>();
                    feedback.put("CHFID", object.getString("CHFID"));
                    feedback.put("FullName", object.getString("LastName") + " " + object.getString("OtherNames"));
                    feedback.put("HFName", object.getString("HFCode") + ":" + object.getString("HFName"));
                    feedback.put("ClaimCode", object.getString("ClaimCode"));
                    feedback.put("DateFromTo", object.getString("DateFrom") + " - " + object.getString("DateTo"));
                    feedback.put("FeedbackPromptDate", object.getString("FeedbackPromptDate"));
                    feedback.put("ClaimId", object.getString("ClaimId"));
                    FeedbackList.add(feedback);
                }



   }
            ListAdapter adapter = new SimpleAdapter(this, FeedbackList, R.layout.feedbacklist,
                    new String[]{"CHFID", "FullName", "HFName", "ClaimCode", "DateFromTo", "FeedbackPromptDate"},
                    new int[]{R.id.tvCHFID, R.id.tvFullName, R.id.tvHFName, R.id.tvClaimCode, R.id.tvDates, R.id.tvTime});
            lv.setAdapter(adapter);

            setTitle("Feedbacks (" + String.valueOf(lv.getCount()) + ")");
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 0) {
            fillFeedbacks();
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
            case android.R.id.home:
                finish();
                return true;
            case R.id.mnuStatistics:
                if (!_general.isNetworkAvailable(this)) {
                    ca.ShowDialog(getResources().getString(R.string.InternetRequired));
                    return false;
                }
                Intent Stats = new Intent(this, Statistics.class);
                Stats.putExtra("Title", "Feedback Statistics");
                Stats.putExtra("Caller", "F");
                startActivity(Stats);
                return true;
            default:
                super.onOptionsItemSelected(item);
        }
        return false;

    }

    private void RefreshFeedbacks() throws IOException, XmlPullParserException {
        if (_general.isNetworkAvailable(this)) {

            //   pd = ProgressDialog.show(this, "", getResources().getString(R.string.Loading));
            new Thread() {
                public void run() {
                    String result = null;
                    CallSoap cs = new CallSoap();
                    cs.setFunctionName("getFeedbacksNew");
                    try {
                        result = cs.getFeedbackRenewals(OfficerCode);
                        if (result.equalsIgnoreCase("[]")|| result ==null ) {
                            FeedbackList.clear();
                            return;
                        }
                    } catch (IOException | XmlPullParserException e) {
                        e.printStackTrace();
                    }
                    Boolean IsInserted = ca.InsertFeedbacks(result);

                    if (!IsInserted) {
                        ca.ShowDialog(getResources().getString(R.string.ErrorOccurred));
                    }

                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            fillFeedbacks();
                        }
                    });

                    //  pd.dismiss();
                    //   swipe.setRefreshing(false);

                }
            }.start();

            //fillFeedbacks();
        } else {
            Toast.makeText(this, getResources().getString(R.string.NoInternet), Toast.LENGTH_LONG).show();
        }
    }


}
