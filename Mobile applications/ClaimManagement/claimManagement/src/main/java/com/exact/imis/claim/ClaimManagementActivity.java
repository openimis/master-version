package com.exact.imis.claim;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import org.xmlpull.v1.XmlSerializer;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;
import com.exact.uploadfile.UploadFile;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Vibrator;
import android.util.Xml;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

public class ClaimManagementActivity extends Activity {
	SQLiteDatabase db;
	SQLHandler sql;
	String Language;
	General _General = new General();
	UploadFile uf = new UploadFile();
	
	public static final String PREFS_NAME = "CMPref";
	final CharSequence[] lang = {"English","Français"};
	
	final String VersionField = "AppVersionClaim";
	final String ApkFileLocation = _General.getDomain() + "/Apps/ClaimManagement.apk";
	final int SIMPLE_NOTIFICATION_ID = 98029;
	final static String Path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/IMIS/";
	
	NotificationManager mNotificationManager;
	Vibrator vibrator;
	
	static final int StartDate_Dialog_ID = 0;
	static final int EndDate_Dialog_ID = 1;

	final Calendar cal = Calendar.getInstance();
	
	ArrayList<HashMap<String,String>> Disease = new ArrayList<HashMap<String,String>>();
	public static ArrayList<HashMap<String,String>> lvItemList;
	public static ArrayList<HashMap<String,String>> lvServiceList;


	private int year, month, day;
	String FileName;
	File ClaimFile;
	File[] Claims;
	int TotalClaims,UploadCounter,TotalItemService;
	int result;
	//1 = Data uploaded on server and accepted 
	//2 = Data uploaded but rejected
	
	EditText etStartDate, etEndDate,etHealthFacility,etClaimCode, etCHFID,etClaimAdmin;
	AutoCompleteTextView etDiagnosis,etDiagnosis1, etDiagnosis2, etDiagnosis3, etDiagnosis4;
	TextView tvItemTotal,tvServiceTotal;
	Button btnPost,btnNew;
	RadioButton rbEmergency, rbReferral, rbOther;
	RadioGroup rgVisitType;
	ImageButton btnScan;
	ProgressDialog pd;

	//For autoComplete
	private DiseaseAdapter adapter;
	private Cursor mDiseaseCursor;

	
	Runnable ChangeMessage = new Runnable() {
		
		@Override
		public void run() {
			//Change progress dialog message here
			pd.setMessage(UploadCounter + " " + getResources().getString(R.string.Of) + " " + TotalClaims + " " + getResources().getString(R.string.Uploading));
			
		}
	};
	
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

		//Create folder if folder is not exists
		File myDir = new File(Path);
		myDir.mkdir();
		//connection db
		sql = new SQLHandler(this);
		sql.onOpen(db);


		new AlertDialog.Builder(this)
        .setTitle("Select Language")
        .setCancelable(false)
        .setItems(lang,new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				if (lang[which].toString() == "English")Language="en";else Language="fr";
		//Language="en";
				_General.ChangeLanguage(ClaimManagementActivity.this, Language);
				
				setContentView(R.layout.main);
				
				 isSDCardAvailable();
				
				//Check if network available
					if (_General.isNetworkAvailable(ClaimManagementActivity.this)){
//			        	tvMode.setText(Html.fromHtml("<font color='green'>Online mode.</font>"));
			        	
			        }else{
//			        	tvMode.setText(Html.fromHtml("<font color='red'>Offline mode.</font>"));
			        	setTitle(getResources().getString(R.string.app_name) + "-" + getResources().getString(R.string.OfflineMode));
			        	setTitleColor(getResources().getColor(R.color.Red));
			    	}			 
				 
					//Check if any updates available on the server.
					new Thread(){
						public void run(){
							CheckForUpdates();
						}
					
					}.start();




				File DirRejected = new File(Path + "RejectedClaims");
				DirRejected.mkdir();

				File DirAccepted = new File(Path + "AcceptedClaims");
				DirAccepted.mkdir();
					
					lvItemList = new ArrayList<HashMap<String, String>>();
					lvServiceList = new ArrayList<HashMap<String, String>>();
					
					etStartDate = (EditText)findViewById(R.id.etStartDate);
				    etEndDate  = (EditText)findViewById(R.id.etEndDate);
				    etDiagnosis = (AutoCompleteTextView)findViewById(R.id.etDiagnosis);
				    btnNew = (Button)findViewById(R.id.btnNew);
				    btnPost = (Button)findViewById(R.id.btnPost);
				    btnScan = (ImageButton)findViewById(R.id.btnScan);
				    etHealthFacility = (EditText)findViewById(R.id.etHealthFacility);
				    etClaimAdmin = (EditText)findViewById(R.id.etClaimAdmin);
				    etClaimCode = (EditText)findViewById(R.id.etClaimCode);
				    etCHFID = (EditText)findViewById(R.id.etCHFID);
				    tvItemTotal =(TextView)findViewById(R.id.tvItemTotal);
				    tvServiceTotal = (TextView)findViewById(R.id.tvServiceTotal);
				    etDiagnosis1 = (AutoCompleteTextView)findViewById(R.id.etDiagnosis1);
				    etDiagnosis2 = (AutoCompleteTextView)findViewById(R.id.etDiagnosis2);
				    etDiagnosis3 = (AutoCompleteTextView)findViewById(R.id.etDiagnosis3);
				    etDiagnosis4 = (AutoCompleteTextView)findViewById(R.id.etDiagnosis4);
				    rbEmergency = (RadioButton)findViewById(R.id.rbEmergency);
				    rbReferral = (RadioButton)findViewById(R.id.rbReferral);
				    rbOther = (RadioButton)findViewById(R.id.rbOther);
				    rgVisitType = (RadioGroup)findViewById(R.id.rgVisitType);


				    tvItemTotal.setText("0");
					tvServiceTotal.setText("0");


				DiseaseAdapter adapter = new DiseaseAdapter(ClaimManagementActivity.this,null);
				etDiagnosis.setAdapter(adapter);
				etDiagnosis.setThreshold(1);
				etDiagnosis.setOnItemClickListener(adapter);

				etDiagnosis1.setAdapter(adapter);
				etDiagnosis1.setThreshold(1);
				etDiagnosis1.setOnItemClickListener(adapter);

				etDiagnosis2.setAdapter(adapter);
				etDiagnosis2.setThreshold(1);
				etDiagnosis2.setOnItemClickListener(adapter);

				etDiagnosis3.setAdapter(adapter);
				etDiagnosis3.setThreshold(1);
				etDiagnosis3.setOnItemClickListener(adapter);

				etDiagnosis4.setAdapter(adapter);
				etDiagnosis4.setThreshold(1);
				etDiagnosis4.setOnItemClickListener(adapter);

					//Fetch if Healthfacility code is available
					SharedPreferences spHF = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
					String HF = spHF.getString("HF", "");
					if(HF.length() > 0) {
						etHealthFacility.setText(HF);
						etClaimAdmin.requestFocus();
					}else{
						etHealthFacility.requestFocus();
					}
						
				    
				    etStartDate.setOnTouchListener(new OnTouchListener() {
						
						@Override
						public boolean onTouch(View v, MotionEvent event) {
							showDialog(StartDate_Dialog_ID);
							return false;
						}
					});
				    
				    etEndDate.setOnTouchListener(new OnTouchListener() {
						
						@Override
						public boolean onTouch(View v, MotionEvent event) {
							showDialog(EndDate_Dialog_ID);
							return false;
						}
					});
					
				    
				    btnNew.setOnClickListener(new OnClickListener() {
						
						@Override
						public void onClick(View v) {
							if (Float.valueOf(TotalItemService)>0){
								ConfirmDialog(getResources().getString(R.string.ConfirmDiscard));
							}else{
							ClearForm();
							}
						}
					});
				    
				    btnScan.setOnClickListener(new OnClickListener() {
						
						@Override
						public void onClick(View v) {
							Intent intent = new Intent("com.google.zxing.client.android.SCAN");
							intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
							startActivityForResult(intent, 1);
						}
					});
				    
				    btnPost.setOnClickListener(new OnClickListener() {
						
						@Override
						public void onClick(View v) {
							if(!isValidData())return;
							WriteXML();
							ClearForm();
							ShowDialog(getResources().getString(R.string.ClaimPosted));
						}
					});


			}
		}).show();



	}

private void CheckForUpdates(){
    	if(_General.isNetworkAvailable(ClaimManagementActivity.this)){
			if(_General.isNewVersionAvailable(VersionField,ClaimManagementActivity.this,getApplicationContext().getPackageName())){
				//Show notification bar
				mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
				
				final Notification NotificationDetails = new Notification(R.drawable.ic_launcher, getResources().getString(R.string.NotificationAlertText), System.currentTimeMillis());
				
				NotificationDetails.flags = Notification.FLAG_SHOW_LIGHTS | Notification.FLAG_AUTO_CANCEL | Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE; 
					
				Context context = getApplicationContext();
				CharSequence ContentTitle = getResources().getString(R.string.ContentTitle);
				CharSequence ContentText = getResources().getString(R.string.ContentText);
				
				Intent NotifyIntent = new Intent(android.content.Intent.ACTION_VIEW,Uri.parse(ApkFileLocation));
					
				PendingIntent  intent = PendingIntent.getActivity(ClaimManagementActivity.this, 0, NotifyIntent,0);
				NotificationDetails.setLatestEventInfo(context, ContentTitle, ContentText, intent);
				
				mNotificationManager.notify(SIMPLE_NOTIFICATION_ID, NotificationDetails);
				
				vibrator = (Vibrator)getSystemService(VIBRATOR_SERVICE);
				vibrator.vibrate(500);
				
			} 
		}
    }
    
private void isSDCardAvailable(){
    	
    	if (_General.isSDCardAvailable() == 0){
    		//Toast.makeText(this, "SD Card is in read only mode.", Toast.LENGTH_LONG);
    		new AlertDialog.Builder(this)
    			.setMessage(getResources().getString(R.string.SDCardReadOnly))
    			.setCancelable(false)
    			.setPositiveButton("Force close", new android.content.DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						finish();
					}
				}).show();
    		
    	}else if(_General.isSDCardAvailable() == -1){
    		new AlertDialog.Builder(this)
			.setMessage(getResources().getString(R.string.SDCardMissing))
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


    @Override
public boolean onCreateOptionsMenu(Menu menu){
	   MenuInflater mif = getMenuInflater();
	   mif.inflate(R.menu.menu, menu);
	   return true;
}

@Override
public boolean onOptionsItemSelected(MenuItem item){
	switch(item.getItemId()){
	case R.id.mnuAddItems:
		Intent AddItems = new Intent(ClaimManagementActivity.this,AddItems.class);
		ClaimManagementActivity.this.startActivity(AddItems);
		
		return true;
	case R.id.mnuAddServices:
		Intent AddServices = new Intent(ClaimManagementActivity.this,AddServices.class);
		ClaimManagementActivity.this.startActivity(AddServices);
		return true;
	case R.id.mnuMapItems:
		Intent MapItem = new Intent(ClaimManagementActivity.this,MapItems.class);
		ClaimManagementActivity.this.startActivity(MapItem);
		return true;
	case R.id.mnuMapServices:
		Intent MapService = new Intent(ClaimManagementActivity.this,MapServices.class);
		ClaimManagementActivity.this.startActivity(MapService);
		return true;
	case R.id.mnuUploadClaim:
		//Get the total number of files to upload
		   Claims = GetListOfFiles(Path);
		   TotalClaims = Claims.length;
		   
		   //If there are no files to upload give the message and exit 
		   if (TotalClaims == 0){
			   ShowDialog(getResources().getString(R.string.NoClaim));
			   return false;
		   } 
		   
		   //If internet is not available then give message and exit
		   if (!_General.isNetworkAvailable(this)){
			   ShowDialog(getResources().getString(R.string.CheckInternet));
			   return false;
		   }
		   
		  pd = new ProgressDialog(this);
	   pd.setCancelable(false);
	   
	   pd = ProgressDialog.show(this,"",getResources().getString(R.string.Uploading));
	   
	   new Thread(){
		   public void run(){
			   
			   //Check if valid ftp credentials are available
			   if(ConnectsFTP()){
				   //Start Uploading images
				   UploadAllClaims();
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

		return true;

		case R.id.mnuStatistics:

            if(!_General.isNetworkAvailable(ClaimManagementActivity.this)){
                ShowDialog(getResources().getString(R.string.InternetRequired));
                return false;
            }

			if(etHealthFacility.getText().length() == 0){
				ShowDialog(etHealthFacility,getResources().getString(R.string.MissingHealthFacility));
				return false;
			}
			if(etClaimAdmin.getText().length() == 0){
				ShowDialog(etClaimAdmin,getResources().getString(R.string.MissingClaimAdmin));
				return false;
			}

			Intent Stats = new Intent(ClaimManagementActivity.this,Statistics.class);
			Stats.putExtra("HFCode",etHealthFacility.getText());
			Stats.putExtra("ClaimAdmin",etClaimAdmin.getText());
			ClaimManagementActivity.this.startActivity(Stats);
			return true;



	default:
		super.onOptionsItemSelected(item);
	}
	return false;
}

@Override
protected Dialog onCreateDialog(int id){
	switch(id){
	
	case StartDate_Dialog_ID:
		
		year = cal.get(Calendar.YEAR);
		month = cal.get(Calendar.MONTH);
		day = cal.get(Calendar.DAY_OF_MONTH);
		
		return new DatePickerDialog(this, StartdatePickerListener, year, month, day);
		
	case EndDate_Dialog_ID:
		year = cal.get(Calendar.YEAR);
		month = cal.get(Calendar.MONTH);
		day = cal.get(Calendar.DAY_OF_MONTH);
		
		return new DatePickerDialog(this, EndDatePickerListner, year, month, day);
	}
	return null;
} 

private DatePickerDialog.OnDateSetListener StartdatePickerListener = new DatePickerDialog.OnDateSetListener() {
	
	@Override
	public void onDateSet(DatePicker view, int Selectedyear, int SelectedMonth,int SelectedDay) {
		year = Selectedyear;
		month = SelectedMonth;
		day = SelectedDay;
		
		etStartDate.setText(new StringBuilder().append(day).append("/").append(month + 1).append("/").append(year));
		
		if(etEndDate.getText().length()==0){
			etEndDate.setText(etStartDate.getText().toString());
		}
	}
};

private DatePickerDialog.OnDateSetListener EndDatePickerListner = new DatePickerDialog.OnDateSetListener() {
	
@Override
public void onDateSet(DatePicker view, int SelectedYear, int SelectedMonth, int SelectedDay) {
		year = SelectedYear;
		month = SelectedMonth;
		day = SelectedDay;
		
		etEndDate.setText(new StringBuilder().append(day).append("/").append(month + 1).append("/").append(year));
	}
};


@Override
protected void onRestart() {
	// TODO Auto-generated method stub
	super.onRestart();
	
	int TotalItem = getTotalItem();
	int TotalService = getTotalService();
	TotalItemService = TotalItem + TotalService;
	
	tvItemTotal.setText(String.valueOf(TotalItem));
	tvServiceTotal.setText(String.valueOf(TotalService));
	
}
private void ClearForm(){
	etClaimCode.setText("");
	etClaimAdmin.setText("");
	etCHFID.setText("");
	etStartDate.setText("");
	etEndDate.setText("");
	etDiagnosis.setText("");
	lvItemList.clear();
	lvServiceList.clear();
	tvItemTotal.setText("0");
	tvServiceTotal.setText("0");
	TotalItemService = 0;
	etDiagnosis1.setText("");
	etDiagnosis2.setText("");
	etDiagnosis3.setText("");
	etDiagnosis4.setText("");
	rgVisitType.clearCheck();
	etClaimAdmin.requestFocus();
}

private int getTotalItem(){
	int total = 0;
	total = lvItemList.size();
//	for(int i=0;i< lvItemList.size();i++){
//		total = total +  Float.valueOf(lvItemList.get(i).get("Price"));
//	}
	return total;
}

private int getTotalService(){
	int total = 0;
	total = lvServiceList.size();
//	for(int i=0;i< lvServiceList.size();i++){
//		total = total +  Float.valueOf(lvServiceList.get(i).get("Price"));
//	}
	return total;
}

@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	// TODO Auto-generated method stub
	super.onActivityResult(requestCode, resultCode, data);
	switch (requestCode){
		case 1:
			if (resultCode == RESULT_OK){
					String CHFID = data.getStringExtra("SCAN_RESULT");
					etCHFID.setText(CHFID);
				}
			break;
	}
}

private boolean isValidData(){
	
	if(etHealthFacility.getText().length()==0){
   		ShowDialog(etHealthFacility, getResources().getString(R.string.MissingHealthFacility));
   		return false;
   	}
	
	if(etClaimAdmin.getText().length()==0){
   		ShowDialog(etClaimAdmin, getResources().getString(R.string.MissingClaimAdmin));
   		return false;
   	}
	
	if(etClaimCode.getText().length()==0){
   		ShowDialog(etClaimCode, getResources().getString(R.string.MissingClaimCode));
   		return false;
   	}
	
	if(etCHFID.getText().length()==0){
   		ShowDialog(etCHFID, getResources().getString(R.string.MissingCHFID));
   		return false;
   	}
	
	if(!isValidCHFID()){
		ShowDialog(etCHFID, getResources().getString(R.string.InvalidCHFID));
   		return false;
	}
	
	if(etStartDate.getText().length()==0){
   		ShowDialog(etStartDate, getResources().getString(R.string.MissingStartDate));
   		return false;
   	}
	
	
	if(etEndDate.getText().length()==0){
   		ShowDialog(etEndDate, getResources().getString(R.string.MissingEndDate));
   		return false;
   	}
	
	//long CurrentDate;
	//long StartDate;
	//long EndDate;

    //CurrentDate = Date.parse(CurrentDate1);
    //StartDate = Date.parse(etStartDate.getText().toString());
    //EndDate = Date.parse(etEndDate.getText().toString());

//SOLVED BY HERMAN 14/11/2017
	String StartDate;
	String EndDate;
    String CurrentDate1;
    String pattern = "dd/MM/yyyy";

    Date Current_date = null;
    Date Start_date = null;
    Date End_date = null;

    SimpleDateFormat format = new SimpleDateFormat(pattern);

	//CurrentDate = Date.parse(CurrentDate1);
	//StartDate = Date.parse(etStartDate.getText().toString());
	//EndDate = Date.parse(etEndDate.getText().toString());
    CurrentDate1 = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
    StartDate = etStartDate.getText().toString();
    EndDate = etEndDate.getText().toString();

    try {
        Current_date = format.parse(CurrentDate1);
        Start_date = format.parse(StartDate);
        End_date = format.parse(EndDate);

    } catch (ParseException e) {
        e.printStackTrace();
    }
/*	if(EndDate - CurrentDate > 0){
		ShowDialog(etEndDate,getResources().getString(R.string.AfterCurrentDate));
		return false;
	}	
	
	if(StartDate - EndDate > 0){
		ShowDialog(etEndDate, getResources().getString(R.string.BiggerDate));
   		return false;
	}
*/
    if (End_date.after(Current_date)) {
        ShowDialog(etEndDate, getResources().getString(R.string.AfterCurrentDate));
        return false;
    }else {
            if (Start_date.after(End_date)) {
                ShowDialog(etEndDate, getResources().getString(R.string.BiggerDate));
                return false;
//SOLVED BY HERMAN 14/11/2017
            }
            if (etDiagnosis.getText().length() == 0) {
                ShowDialog(etDiagnosis, getResources().getString(R.string.MissingDisease));
                return false;
            }
            if (rgVisitType.getCheckedRadioButtonId() == -1) {
                ShowDialog(rgVisitType, getResources().getString(R.string.MissingVisitType));
                return false;
            }
            //if(tvTotal.getText().length() == 0) tvTotal.setText("0");
            if (Float.valueOf(tvItemTotal.getText().toString()) + Float.valueOf(tvServiceTotal.getText().toString()) == 0) {
                ShowDialog(tvItemTotal, getResources().getString(R.string.MissingClaim));
                return false;
            }
            return true;
	}
}

private boolean isValidCHFID(){
	return true;
//	if (etCHFID.getText().toString().length() != 9) return false;
//	String chfid;
//	int Part1, Part2;
//	Part1 = Integer.parseInt(etCHFID.getText().toString())/10;
//	Part2 = Part1 % 7;
//
//	chfid = etCHFID.getText().toString().substring(0, 8) + Integer.toString(Part2);
//	return etCHFID.getText().toString().equals(chfid);
	
}

protected AlertDialog ShowDialog(final Object tv,String msg){
   	return new AlertDialog.Builder(this)
   	.setMessage(msg)
   	.setCancelable(false)
		.setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				if (tv instanceof EditText) {
					EditText temp = (EditText) tv;
					temp.requestFocus();
				}
			}
			
		}).show();
   }
protected AlertDialog ShowDialog(String msg){
	return new AlertDialog.Builder(this)
		.setMessage(msg)
		.setCancelable(false)
		.setPositiveButton(getResources().getString(R.string.Ok), new android.content.DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				//et.requestFocus();
				return;
			}
		}).show();
}
protected AlertDialog ConfirmDialog(String msg){
	return new AlertDialog.Builder(this)
	.setMessage(msg)
	.setCancelable(true)
	.setPositiveButton(getResources().getString(R.string.Yes), new android.content.DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			ClearForm();
			dialog.dismiss();
		}
		
	
	})
	.setNegativeButton(getResources().getString(R.string.No), new android.content.DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			// TODO Auto-generated method stub
			dialog.dismiss();
		}
	}).show();
	
}
private void WriteXML(){
	
	//Create all the directories required
	File MyDir = new File(Path);
	MyDir.mkdir();
	
	File DirRejected = new File(Path + "RejectedClaims");
	DirRejected.mkdir();
	
	File DirAccepted = new File(Path + "AcceptedClaims");
	DirAccepted.mkdir();
	
	//Create a file name
	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	Calendar cal = Calendar.getInstance();
	String d = format.format(cal.getTime());
	
	FileName = "Claim_" + etHealthFacility.getText().toString() + "_" + etClaimCode.getText().toString() + "_" + d + ".xml";
	
	ClaimFile = new File(MyDir,FileName);
	
	//Get the selected radio button
	int SelectedId;
	SelectedId = rgVisitType.getCheckedRadioButtonId();
	
	RadioButton Rb;
	Rb = (RadioButton)findViewById(SelectedId);
	
	try {
		FileOutputStream fos = new FileOutputStream(ClaimFile);
		
		XmlSerializer serializer = Xml.newSerializer();
		
		serializer.setOutput(fos, "UTF-8");
		
		serializer.startDocument(null, Boolean.valueOf(true));
		
		serializer.setFeature("http://xmlpull.org/v1/doc/features.html#indent-output", true);
		
		//<Claim>
		serializer.startTag(null, "Claim");
		
		//<Details>
		serializer.startTag(null, "Details");
		
		//ClaimDate
		serializer.startTag(null, "ClaimDate");
		format = new SimpleDateFormat("dd/MM/yyyy");
		d = format.format(cal.getTime());
		serializer.text(d);
		serializer.endTag(null, "ClaimDate");

		//HFCOde
		serializer.startTag(null, "HFCode");
		serializer.text(etHealthFacility.getText().toString());
		serializer.endTag(null, "HFCode");
		
		//Claim Admin
		serializer.startTag(null, "ClaimAdmin");
		serializer.text(etClaimAdmin.getText().toString());
		serializer.endTag(null, "ClaimAdmin");
		
		//ClaimCode
		serializer.startTag(null, "ClaimCode");
		serializer.text(etClaimCode.getText().toString());
		serializer.endTag(null, "ClaimCode");
		
		//CHFID
		serializer.startTag(null, "CHFID");
		serializer.text(etCHFID.getText().toString());
		serializer.endTag(null, "CHFID");
		
		//StartDate
		serializer.startTag(null, "StartDate");
		serializer.text(etStartDate.getText().toString());
		serializer.endTag(null, "StartDate");
		
		//EndDate
		serializer.startTag(null, "EndDate");
		serializer.text(etEndDate.getText().toString());
		serializer.endTag(null, "EndDate");
		
		//ICDCode
		serializer.startTag(null, "ICDCode");
		serializer.text(etDiagnosis.getText().toString());
		serializer.endTag(null, "ICDCode");
		
		//Comment
		serializer.startTag(null, "Comment");
		serializer.text(" ");
		serializer.endTag(null, "Comment");
		
		//Total
		serializer.startTag(null,"Total");
		serializer.text(" ");
		serializer.endTag(null,"Total");
		
		//Diagnosis1
		serializer.startTag(null, "ICDCode1");
		serializer.text(etDiagnosis1.getText().toString());
		serializer.endTag(null, "ICDCode1");
		
		//Diagnosis2
		serializer.startTag(null, "ICDCode2");
		serializer.text(etDiagnosis2.getText().toString());
		serializer.endTag(null, "ICDCode2");
		
		//Diagnosis3
		serializer.startTag(null, "ICDCode3");
		serializer.text(etDiagnosis3.getText().toString());
		serializer.endTag(null, "ICDCode3");
		
		//Diagnosis4
		serializer.startTag(null, "ICDCode4");
		serializer.text(etDiagnosis4.getText().toString());
		serializer.endTag(null, "ICDCode4");
		
		//VisitType
		serializer.startTag(null, "VisitType");
		serializer.text(Rb.getTag().toString());
		serializer.endTag(null, "VisitType");
		
		
		serializer.endTag(null, "Details");
		//</Details>
		
		//<Items>
		serializer.startTag(null, "Items");
		
		for(int i=0;i<lvItemList.size();i++){
			//<Item>
			serializer.startTag(null,"Item");			
		
			//Code
			serializer.startTag(null, "ItemCode");
			serializer.text(lvItemList.get(i).get("Code"));
			serializer.endTag(null, "ItemCode");
			
			//Price
			serializer.startTag(null, "ItemPrice");
			serializer.text(lvItemList.get(i).get("Price"));
			serializer.endTag(null, "ItemPrice");
			
			//Quantity
			serializer.startTag(null, "ItemQuantity");
			serializer.text(lvItemList.get(i).get("Quantity"));
			serializer.endTag(null, "ItemQuantity");
			
			serializer.endTag(null,"Item");
			//</Item>
		}
		
		serializer.endTag(null, "Items");
		//</Items>
		
		
		//<Services>
		serializer.startTag(null, "Services");
			
			for(int i=0;i<lvServiceList.size();i++){
				
				//<Service>
				serializer.startTag(null, "Service");
				
				//Code
				serializer.startTag(null, "ServiceCode");
				serializer.text(lvServiceList.get(i).get("Code"));
				serializer.endTag(null, "ServiceCode");
				
				//Price
				serializer.startTag(null, "ServicePrice");
				serializer.text(lvServiceList.get(i).get("Price"));
				serializer.endTag(null, "ServicePrice");
				
				//Quantity
				serializer.startTag(null, "ServiceQuantity");
				serializer.text(lvServiceList.get(i).get("Quantity"));
				serializer.endTag(null, "ServiceQuantity");
				
				//<Service>
				serializer.endTag(null, "Service");
			}
		
		serializer.endTag(null, "Services");
		//</Services>
		
		serializer.endTag(null, "Claim");
		//</Claim>
		
		serializer.endDocument();
		serializer.flush();
		fos.flush();
		fos.close();
		
		
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IllegalArgumentException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IllegalStateException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	
}

private void MoveFile(File file){
	switch(result){
	case 1:
		file.renameTo(new File(Path + "AcceptedClaims/" + file.getName()));
		break;
	case 2:
		file.renameTo(new File(Path + "RejectedClaims/" + file.getName()));
		break;
	}
}
private boolean ConnectsFTP(){
	   
	   return uf.isValidFTPCredentials();
	   
 }
private File[] GetListOfFiles(String DirectoryPath){
	   File Directory = new File(DirectoryPath);
	   FilenameFilter filter = new FilenameFilter() {
		
		@Override
		public boolean accept(File dir, String filename) {
			return filename.startsWith("Claim_");
		}
	};
	return Directory.listFiles(filter);
 }
private void UploadAllClaims(){
	   for(int i=0;i<Claims.length;i++){
		   UploadCounter = i + 1;
		   runOnUiThread(ChangeMessage);
		   if(uf.uploadFileToServer(this,Claims[i])){
			  ClaimFile = Claims[i];
			  if(ServerResponse())
				  result = 1;
			  else
				  result = 2;
			  MoveFile(ClaimFile);
		   }
	   }
 }

private boolean ServerResponse(){
	CallSoap cs = new CallSoap();
	cs.setFunctionName("isValidClaim");
	return cs.isClaimAccepted(ClaimFile.getName().toString());
} 


@Override
protected void onStop() {
	// TODO Auto-generated method stub
	super.onStop();
	//if(etHealthFacility.getText().length() > 0){
	SharedPreferences HF = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
	SharedPreferences.Editor editor = HF.edit();
	editor.putString("HF", etHealthFacility.getText().toString());
	editor.commit();
	//}
}

	}