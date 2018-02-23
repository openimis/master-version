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

public class RenewList extends AppCompatActivity {
    private General _general = new General();

    private ListView lv;
    private SwipeRefreshLayout swipe;
    private ArrayList<HashMap<String, String>> RenewalList = new ArrayList<>();
    private String OfficerCode;
    private ClientAndroidInterface ca;
    private Global global;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ca = new ClientAndroidInterface(this);
        setContentView(R.layout.renewals);
        //noinspection ConstantConditions
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        global = (Global)getApplicationContext();
        OfficerCode = global.getOfficerCode();

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
                swipe.setRefreshing(true);
                (new Handler()).postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            RefreshRenewals();

                            // FetchPayers();
                        } catch (IOException | XmlPullParserException e) {
                            e.printStackTrace();
                        }
                        swipe.setRefreshing(false);
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

                Intent intent = new Intent(getApplicationContext(), Renewal.class);

                HashMap<String, String> oItem;
                //noinspection unchecked
                oItem = (HashMap<String, String>) parent.getItemAtPosition(position);
                intent.putExtra("CHFID", oItem.get("CHFID"));
                intent.putExtra("ProductCode", oItem.get("ProductCode"));
                intent.putExtra("RenewalId", oItem.get("RenewalId"));
                intent.putExtra("OfficerCode", OfficerCode);
                intent.putExtra("LocationId", oItem.get("LocationId"));
                intent.putExtra("PolicyValue",oItem.get("PolicyValue"));
                startActivityForResult(intent, 0);

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

    private void fillRenewals() {

        ClientAndroidInterface ca = new ClientAndroidInterface(this);
        String result = ca.OfflineRenewals(OfficerCode);
        JSONArray jsonArray = null;
        JSONObject object;

        try {
            jsonArray = new JSONArray(result);

            if (jsonArray.length() == 0) {
                RenewalList.clear();
               Toast.makeText(this, getResources().getString(R.string.NoRenewalFound), Toast.LENGTH_LONG).show();
            } else {
                RenewalList.clear();
                for (int i = 0; i < jsonArray.length(); i++) {

                    object = jsonArray.getJSONObject(i);

                    HashMap<String, String> Renewal = new HashMap<>();
                    Renewal.put("RenewalId", object.getString("RenewalId"));
                    Renewal.put("CHFID", object.getString("CHFID"));
                    Renewal.put("FullName", object.getString("LastName") + " " + object.getString("OtherNames"));
                    Renewal.put("Product", object.getString("ProductCode") + " : " + object.getString("ProductName"));
                    Renewal.put("VillageName", object.getString("VillageName"));
                    Renewal.put("RenewalPromptDate", object.getString("RenewalPromptDate"));
                    Renewal.put("PolicyId", object.getString("PolicyId"));
                    Renewal.put("ProductCode", object.getString("ProductCode"));
                    Renewal.put("LocationId", object.getString("LocationId"));
                    Renewal.put("PolicyValue",object.getString("PolicyValue"));
                    RenewalList.add(Renewal);
                }
            }


            ListAdapter adapter = new SimpleAdapter(this, RenewalList, R.layout.renewallist,
                    new String[]{"CHFID", "FullName", "Product", "VillageName", "RenewalPromptDate"},
                    new int[]{R.id.tvCHFID, R.id.tvFullName, R.id.tvProduct, R.id.tvVillage, R.id.tvTime});

            lv.setAdapter(adapter);

            setTitle("Renewals (" + String.valueOf(lv.getCount()) + ")");

        } catch (JSONException e) {
            e.printStackTrace();
        }

    }



    private void RefreshRenewals() throws IOException, XmlPullParserException {

        if (_general.isNetworkAvailable(this)) {
            new Thread() {
                public void run() {
                    String result = null;
                    CallSoap cs = new CallSoap();
                    cs.setFunctionName("getRenewalsNew");
                    try {
                        result = cs.getFeedbackRenewals(OfficerCode);
                    } catch (IOException | XmlPullParserException e) {
                        e.printStackTrace();
                    }
                    ca.InsertRenewals(result);

                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            fillRenewals();
                        }
                    });
                }
            }.start();


        } else {

            Toast.makeText(this, getResources().getString(R.string.NoInternet), Toast.LENGTH_LONG).show();
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
                Intent stats = new Intent(this, Statistics.class);
                stats.putExtra("Title", "Renewal Statistics");
                stats.putExtra("Caller", "R");
                startActivity(stats);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

}
