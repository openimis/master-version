package com.exact.imis.claim;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.Filter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

public class MapItems extends Activity {
	
	SQLHandler sql; 
	
	ListView lvMapItems;
	CheckBox chkAll,chk;
	EditText etSearchItems;
	
	ArrayList<HashMap<String, Object>> ItemsList = new ArrayList<HashMap<String, Object>>();
	
	HashMap<String, Object> oItem;
	ItemAdapter alAdapter;
	ProgressDialog pd;
		
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.mapitesms);
	
	   
	        
	    lvMapItems = (ListView)findViewById(R.id.lvMapItems);
	    chkAll = (CheckBox)findViewById(R.id.chkAll);
	    chk = (CheckBox)findViewById(R.id.chkMap);
		etSearchItems = (EditText)findViewById(R.id.etSearchItems);

		etSearchItems.addTextChangedListener(new TextWatcher() {
			@Override
			public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

			}

			@Override
			public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
				alAdapter.getFilter().filter(charSequence);
			}

			@Override
			public void afterTextChanged(Editable editable) {

			}
		});



	    lvMapItems.setOnItemClickListener(new ListView.OnItemClickListener(){
			
			@Override
			public void onItemClick(AdapterView<?> parent, View view,int position, long id) {
				// TODO Auto-generated method stub
				oItem = (HashMap<String,Object>)parent.getItemAtPosition(position);
				boolean checked = (Boolean) oItem.get("isMapped");
				oItem.put("isMapped", !checked);
				ItemsList.set(position, oItem);
				alAdapter.notifyDataSetChanged();
				
				if (checked){
					chkAll.setChecked(false);
				}
				
			}
		});
	    
	    chkAll.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				CheckUncheckAll(chkAll.isChecked());
			
			}
		});
	   
	    BindItemList();
	   
	}
	    
	public void BindItemList(){
		//String[] Items = {"Item1","Item2","Item3","Item4","Item5"};
		  
		//SQLHandler sql = new SQLHandler(null, null, null, 3);
		SQLHandler sql = new SQLHandler(this);
		
		Cursor c = sql.getMapping("I");
		boolean isMapped=false;
		for(c.moveToFirst();!c.isAfterLast();c.moveToNext()){
			HashMap<String,Object> item = new HashMap<String,Object>();
			item.put("Code", c.getString(0));
			item.put("Name", c.getString(1));
			if((c.getString(2))==null)isMapped = false;else isMapped = true;
			item.put("isMapped", isMapped);
			ItemsList.add(item);
			
		}

		 alAdapter = new ItemAdapter(MapItems.this,ItemsList,R.layout.mappinglist,
				 	new String[]{"Code","Name","isMapped"},
				 	new int[]{R.id.tvMapCode,R.id.tvMapName,R.id.chkMap});

		 
		 	//lvMapItems.setAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_list_item_multiple_choice,Items));
		    
		    
		 try {
			lvMapItems.setAdapter(alAdapter);
			lvMapItems.setItemsCanFocus(false);
		    lvMapItems.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
		}
	}
	
	private void CheckUncheckAll(boolean isChecked){
		for(int i=0;i<ItemsList.size();i++){
			oItem = (HashMap<String,Object>)ItemsList.get(i);
			oItem.put("isMapped", isChecked);
			ItemsList.set(i, oItem);
			alAdapter.notifyDataSetChanged();
		}
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater mif = getMenuInflater();
		mif.inflate(R.menu.mapping, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch(item.getItemId()){
		case R.id.mnuSave:
			pd = new ProgressDialog(this);
			pd.setCancelable(false);
			pd = ProgressDialog.show(this, "", getResources().getString(R.string.Saving));
			new Thread(){
				public void run(){
					Save();
					finish();
					pd.dismiss();
				}
			}.start();
			
			
			//finish();
			return true;
		case R.id.mnuCancel:
			finish();
			return true;
		default:
			return super.onOptionsItemSelected(item);
		}
	}
	
	private void Save(){
		sql = new SQLHandler(this);
		sql.ClearMapping("I");
		for(int i=0;i<ItemsList.size();i++){
			oItem = (HashMap<String,Object>)ItemsList.get(i);
			boolean checked = (Boolean) oItem.get("isMapped");
				if (checked){
					sql.InsertMapping(oItem.get("Code").toString(), oItem.get("Name").toString(), "I");
				}
			}
		}


	private class ItemAdapter extends SimpleAdapter{

		private ArrayList<HashMap<String, Object>> OriginalList,FilteredList;
		private ArrayList<HashMap<String, Object>> ItemList;
		private HashMap<String, Object> TempData;
		private ItemFilter filter;
		//private Context cntx;


		public ItemAdapter(Context context, List<? extends Map<String, ?>> ItemList, int resource, String[] from, int[] to) {
			super(context, ItemList, resource, from, to);
			//this.cntx = context;
			this.ItemList = new ArrayList<HashMap<String, Object>>();
			this.ItemList.addAll((Collection<? extends HashMap<String, Object>>) ItemList);
			this.OriginalList =  new ArrayList<HashMap<String, Object>>();
			this.OriginalList.addAll((Collection<? extends HashMap<String, Object>>) ItemList);

		}


		@Override
		public Filter getFilter() {
			if(filter == null){
				filter = new ItemFilter();
			}
			return filter;
		}

		private class ViewHolder{
			TextView Code;
			TextView Name;
			CheckBox isMapped;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder;
			Log.v("ConvertView", String.valueOf(position));
			if(convertView == null){
				LayoutInflater vi = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				convertView = vi.inflate(R.layout.mappinglist,null);

				holder = new ViewHolder();
				holder.Code = (TextView) convertView.findViewById(R.id.tvMapCode);
				holder.Name = (TextView)convertView.findViewById(R.id.tvMapName);
				holder.isMapped = (CheckBox)convertView.findViewById(R.id.chkMap);

				convertView.setTag(holder);

			}
			else{
				holder = (ViewHolder)convertView.getTag();
			}

			if (position > ItemList.size())
				return convertView;

			TempData = ItemList.get(position);
			holder.Code.setText((String) TempData.get("Code"));
			holder.Name.setText((String) TempData.get("Name"));
			holder.isMapped.setChecked((Boolean) TempData.get("isMapped"));

			return  convertView;
		}

		private class ItemFilter extends Filter{

			@Override
			protected FilterResults performFiltering(CharSequence constraint) {
				constraint = constraint.toString().toLowerCase();
				FilterResults results = new FilterResults();
				ArrayList<HashMap<String, Object>> FilteredItems = new ArrayList<HashMap<String, Object>>();;

				if(constraint != null && constraint.toString().length() > 0){

					for(int i = 0;i < OriginalList.size(); i++){
						HashMap<String, Object> oItem  = OriginalList.get(i);
						if( oItem.get("Code").toString().toLowerCase().contains(constraint) || oItem.get("Name").toString().toLowerCase().contains(constraint)){
							FilteredItems.add(oItem);
						}
						results.count = FilteredItems.size();
						results.values = FilteredItems;
					}
				}else{
					synchronized (this){
						results.values = OriginalList;
						results.count = OriginalList.size();
					}

				}
				return results;
			}

			@SuppressWarnings("unchecked")
			@Override
			protected void publishResults(CharSequence constraint, FilterResults results) {
				ItemList = (ArrayList<HashMap<String, Object>>) results.values;
				notifyDataSetChanged();

				MapItems.this.ItemsList.clear();

				//FilteredList = new ArrayList<HashMap<String, Object>>();
				//FilteredList.clear();
				for(int i = 0;i < ItemList.size(); i++){
					MapItems.this.ItemsList.add(ItemList.get(i));
					notifyDataSetInvalidated();
				}

			}
		}
	}



	}


