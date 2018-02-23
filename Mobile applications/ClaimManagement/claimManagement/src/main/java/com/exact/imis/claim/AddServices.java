package com.exact.imis.claim;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Spinner;
import android.widget.TextView;

public class AddServices extends Activity {

	//Spinner spServices;
	ListView lvServices;
	TextView tvCode,tvName;
	EditText etSQuantity, etSAmount;
	Button btnAdd,btnBack;
	SQLiteDatabase db;
	AutoCompleteTextView etServices;

	int Pos;
	
	ArrayList<HashMap<String, String>> ServiceList = new ArrayList<HashMap<String,String>>();
	//ArrayList<HashMap<String,String>> lvItemList;
	
	HashMap<String, String> oService;
	SimpleAdapter alAdapter;
	
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    
	    setContentView(R.layout.addservices);
	    
	    
	    
	    //spServices = (Spinner)findViewById(R.id.spServices);
	    lvServices = (ListView)findViewById(R.id.lvServices);
	    tvCode = (TextView)findViewById(R.id.tvCode);
	    tvName =  (TextView)findViewById(R.id.tvName);
	    //tvPrice = (TextView)findViewById(R.id.tvPrice);
	    etSQuantity = (EditText)findViewById(R.id.etSQuantity);
	    etSAmount = (EditText)findViewById(R.id.etSAmount);
        etServices = (AutoCompleteTextView)findViewById(R.id.etService);

        ServiceAdapter serviceAdapter = new ServiceAdapter(AddServices.this, null);

        etServices.setAdapter(serviceAdapter);
        etServices.setThreshold(1);
        etServices.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long l) {
                if (position >= 0){

                    Cursor cursor = (Cursor)parent.getItemAtPosition(position);
                    final int itemColumnIndex = cursor.getColumnIndexOrThrow("Code");
                    final int descColumnIndex = cursor.getColumnIndexOrThrow("Name");
                    String Code = cursor.getString(itemColumnIndex);
                    String Name = cursor.getString(descColumnIndex);

                    oService = new HashMap<String, String>();
                    oService.put("Code",Code);
                    oService.put("Name",Name);


//					etAmount.setText(oItem.get("Price"));
                    etSQuantity.setText("1");
                    etSAmount.setText("0");
                }
            }
        });
	    
	    //ClaimManagementActivity.lvItemList = new ArrayList<HashMap<String, String>>();

	    alAdapter = new SimpleAdapter(AddServices.this,ClaimManagementActivity.lvServiceList,R.layout.lvitem,
				new String[]{"Code","Name","Price","Quantity"},
				new int[]{R.id.tvLvCode,R.id.tvLvName,R.id.tvLvPrice,R.id.tvLvQuantity});
	    
	    
	  
	    lvServices.setAdapter(alAdapter);
	    
	    btnAdd = (Button)findViewById(R.id.btnAdd);
	   
	    btnAdd.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				try {

					if(oService == null) return;

					String Amount,Quantity = "1";
					
					HashMap<String,String> lvService = new HashMap<String,String>();
					lvService.put("Code", oService.get("Code"));
					lvService.put("Name",oService.get("Name"));
					Amount = etSAmount.getText().toString(); 
					lvService.put("Price", Amount);
					if(etSQuantity.getText().toString().length() == 0) Quantity = "1"; else Quantity = etSQuantity.getText().toString();
					lvService.put("Quantity", Quantity);
					ClaimManagementActivity.lvServiceList.add(lvService);
					
					alAdapter.notifyDataSetChanged();

                    etServices.setText("");
                    etSAmount.setText("");
                    etSQuantity.setText("");
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					Log.d("AddLvError", e.getMessage());
                }
            }
        });

        btnBack = (Button) findViewById(R.id.btnBack);
        btnBack.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				finish();				
			}
		});
	    
	    //BindSpServices();
	    
//	   spServices.setOnItemSelectedListener(new SpinnerOnItemSelected() {
//
//		@Override
//		public void onItemSelected(AdapterView<?> parent, View view,int position, long id) {
//
//			try {
//				if (position >= 0){
//					oService = (HashMap<String, String>)parent.getItemAtPosition(position);
//
//					etSAmount.setText(oService.get("Price"));
//					etSQuantity.setText("1");
//					etSAmount.setText("0");
//				}
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				Log.d("onSelectedError", e.getMessage());
//			}
//
//		}
		   
//		@Override
//		public void onNothingSelected(AdapterView<?> arg0) {
//			// TODO Auto-generated method stub
//
//		}
//	});
	    
	lvServices.setOnItemLongClickListener(new onItemLongClickListener() {
		@Override
        public boolean onItemLongClick(AdapterView<?> parent, View view,int position, long id) {
          try {
        	  
        	  Pos = position;
        	  HideAllDeleteButtons();
        	  
        	  	Button d = (Button)view.findViewById(R.id.btnDelete);
        	  	d.setVisibility(View.VISIBLE); 
        	  	
        	  	d.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						ClaimManagementActivity.lvServiceList.remove(Pos);
						HideAllDeleteButtons();
						alAdapter.notifyDataSetChanged();
					}
				});
        	  	
			    
		} catch (Exception e) {
			Log.d("ErrorOnLongClick", e.getMessage());
		}
		return true;
        }
	});   
	   
	
	
	}
	
	private void HideAllDeleteButtons(){
		for(int i=0;i<=lvServices.getLastVisiblePosition();i++){
	  		Button Delete = (Button)lvServices.getChildAt(i).findViewById(R.id.btnDelete);
	  		Delete.setVisibility(View.GONE);
	  }
	}
	
//	private void BindSpServices(){
//		//List<String> Items = new ArrayList<String>();
//
//		SQLHandler sql = new SQLHandler(this);
//		String Table = "tblMapping";
//		String Columns[] = {"Code","Name","Type"};
//		String Criteria = "Type='S'";
//
//		//db = openOrCreateDatabase(ClaimManagementActivity.Path + "ImisData.db3", SQLiteDatabase.OPEN_READONLY, null);
//
//		Cursor c = sql.getData(Table, Columns, Criteria);
//
//		if (c.getCount()==0 || c == null){
//
//			new AlertDialog.Builder(this)
//			.setMessage(getResources().getString(R.string.MappedServiceMissing))
//			.setCancelable(false)
//			.setTitle(getResources().getString(R.string.NoServiceMapped))
//			.setPositiveButton(getResources().getString(R.string.Ok), new android.content.DialogInterface.OnClickListener() {
//
//				@Override
//				public void onClick(DialogInterface dialog, int which) {
//					finish();
//				}
//			}).create().show();
//
//		}
//
//		//Cursor c = db.query(Table, Columns, Criteria, null, null, null, null);
//
//		for(c.moveToFirst();!c.isAfterLast();c.moveToNext()){
//			//Items.add(c.getString(0));
//			HashMap<String, String> Service = new HashMap<String, String>();
//
//			Service.put("Code", c.getString(0));
//			Service.put("Name", c.getString(1));
//			ServiceList.add(Service);
//		}
//
//		//ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.spinneritem, R.id.tvCode);
//
//
//		SimpleAdapter adapter = new SimpleAdapter(AddServices.this,ServiceList,R.layout.spinneritem,
//				new String[]{"Code","Name"},
//				new int[]{R.id.tvCode,R.id.tvName});
//
//		try {
//			spServices.setAdapter(adapter);
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//
//	}
	
}
