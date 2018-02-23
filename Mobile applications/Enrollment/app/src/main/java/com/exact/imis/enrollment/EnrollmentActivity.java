package com.exact.imis.enrollment;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.exact.CallSoap.CallSoap;
import com.exact.general.General;
import com.exact.uploadfile.UploadFile;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Vibrator;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class EnrollmentActivity extends Activity {
    /** Called when the activity is first created. */
	General _General = new General();
	UploadFile uf = new UploadFile();
	ImageButton btnScan,btnTakePhoto;
	Button btnSubmit;
	EditText etOfficer,etCHFID;
	ImageView iv;
	ProgressDialog pd;
	NotificationManager mNotificationManager;
	Vibrator vibrator;
	
	static String Language;
	Bitmap theImage;
	
	final int SIMPLE_NOTIFICATION_ID = 2;
	final String VersionField = "AppVersionEnroll";
	final String ApkFileLocation = _General.getDomain() + "/Apps/Enrollment.apk";
	final String Path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/IMIS/";
	final CharSequence[] lang = {"English","Français"};
	int result = 0;
	//-1 = FTP Connection failed
	//0 = Saved on memory card
	//1 = Uploaded on server
	//2 = Could not uploaded on server
	
	
	String msg = "";
	File[] Images;
	int TotalImages;
	int UploadCounter;

	double Longitude, Latitude;
	LocationManager lm;
	String towers;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        
      new AlertDialog.Builder(this)
      .setTitle("Select Language")
      .setCancelable(false)
      .setItems(lang, new DialogInterface.OnClickListener() {

		@Override
		public void onClick(DialogInterface dialog, int which) {
			if(lang[which].toString()=="English")Language="en";else Language="fr";
//        Language="en";
			_General.ChangeLanguage(EnrollmentActivity.this, Language);
			setContentView(R.layout.main);
			
			//Close the application if SD card is not available or set to reaonly mode.
			isSDCardAvailable();
			
			//Check if network available
			if (_General.isNetworkAvailable(EnrollmentActivity.this)){
//	        	tvMode.setText(Html.fromHtml("<font color='green'>Online mode.</font>"));
	        	
	        }else{
//	        	tvMode.setText(Html.fromHtml("<font color='red'>Offline mode.</font>"));
	        	setTitle(getResources().getString(R.string.app_name) + "-" + getResources().getString(R.string.OfflineMode));
	        	setTitleColor(R.color.Red);
	    	}
			
			//Check if any updates available on the server.
			new Thread(){
				public void run(){
					CheckForUpdates();
				}
			
			}.start();
			
			
			etOfficer = (EditText)findViewById(R.id.etofficer);
			etCHFID = (EditText)findViewById(R.id.etCHFID);
			iv = (ImageView)findViewById(R.id.imageView);
			btnTakePhoto = (ImageButton)findViewById(R.id.btnTakePhoto);
			btnScan = (ImageButton)findViewById(R.id.btnScan);
			btnSubmit = (Button)findViewById(R.id.btnSubmit);

			lm = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
			Criteria c = new Criteria();
			towers = lm.getBestProvider(c,false);
			Location loc = lm.getLastKnownLocation(towers);

			if (loc != null){
				Longitude = loc.getLongitude();
				Latitude = loc.getLatitude();
			}

			btnTakePhoto.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
					startActivityForResult(intent, 0);
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
			
			btnSubmit.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					
					if (!isValidate())return;
					
					pd = ProgressDialog.show(EnrollmentActivity.this, "", getResources().getString(R.string.Uploading));
					new Thread(){
						public void run(){
							try {
								result = SubmitData();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
							runOnUiThread(new Runnable() {
								public void run() {
									switch(result){
									case 0:
										msg = getResources().getString(R.string.SavedOnMemoryCard);
										break;
									case 1:
										msg = getResources().getString(R.string.Uploaded);
										break;
									case 2:
										msg = getResources().getString(R.string.CouldNotUpload);
										break;
									}
									
									Toast.makeText(EnrollmentActivity.this, msg, Toast.LENGTH_LONG).show();
									
									etCHFID.setText("");
									iv.setImageResource(R.drawable.noimage);
									theImage = null;
									etCHFID.requestFocus();
									
								}
							});
							
							pd.dismiss();
						}
					}.start();
					
				}
			});
			
		}
	}).show();
     
        
    }
    
    private void CheckForUpdates(){
    	if(_General.isNetworkAvailable(EnrollmentActivity.this)){
			if(_General.isNewVersionAvailable(VersionField,EnrollmentActivity.this,getApplicationContext().getPackageName())){
				//Show notification bar
				mNotificationManager = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
				
				final Notification NotificationDetails = new Notification(R.drawable.ic_launcher, getResources().getString(R.string.NotificationAlertText), System.currentTimeMillis());
				
				NotificationDetails.flags = Notification.FLAG_SHOW_LIGHTS | Notification.FLAG_AUTO_CANCEL | Notification.DEFAULT_SOUND | Notification.DEFAULT_VIBRATE; 
					
				Context context = getApplicationContext();
				CharSequence ContentTitle = getResources().getString(R.string.ContentTitle);
				CharSequence ContentText = getResources().getString(R.string.ContentText);
				
				Intent NotifyIntent = new Intent(android.content.Intent.ACTION_VIEW,Uri.parse(ApkFileLocation));
					
				PendingIntent  intent = PendingIntent.getActivity(EnrollmentActivity.this, 0, NotifyIntent,0);
				NotificationDetails.setLatestEventInfo(context, ContentTitle, ContentText, intent);
				
				mNotificationManager.notify(SIMPLE_NOTIFICATION_ID, NotificationDetails);
				
				vibrator = (Vibrator)getSystemService(VIBRATOR_SERVICE);
				vibrator.vibrate(500);
				
			} 
		}
    }
    
   @Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
   		try {
   			switch(requestCode){
   			case 0:
   				theImage = (Bitmap)data.getExtras().get("data");
				iv.setImageBitmap(theImage);
   				break;
   			case 1:
   				if (resultCode == RESULT_OK){
   					String CHFID = data.getStringExtra("SCAN_RESULT");
   					etCHFID.setText(CHFID);
   				}
   				break;
   				
   			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
   
   protected boolean isValidate(){
   	
   	if(etOfficer.getText().length()==0){
   		ShowDialog(etOfficer, getResources().getString(R.string.MissingOfficer));
   		return false;
   	}
   	if(etCHFID.getText().length()==0){
   		ShowDialog(etCHFID, getResources().getString(R.string.MissingCHFID));
   		return false;
   	}
   	//Toast.makeText(this, theImage.getWidth(), Toast.LENGTH_LONG).show();
   	if(theImage==null){
   		ShowDialog(iv, getResources().getString(R.string.MissingImage));
   		return false;
   		
   	}
   	
   	if (!isValidCHFID()){
   		ShowDialog(etCHFID,getResources().getString(R.string.InvalidCHFID));
   		return false;
   	}
   	
   	return true;
   }
   
   protected AlertDialog ShowDialog(final TextView tv,String msg){
   	return new AlertDialog.Builder(this)
   	.setMessage(msg)
   	.setCancelable(false)
		.setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				tv.requestFocus();
			}
		}).show();
   }
   
   protected AlertDialog ShowDialog(final ImageView tv,String msg){
   	return new AlertDialog.Builder(this)
   	.setMessage(msg)
   	.setCancelable(false)
		.setPositiveButton("Ok", new android.content.DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				tv.requestFocus();
			}
		}).show();
   }
   
   private int SubmitData() throws IOException{
	   
	   //Create folder if folder is not exists
	   File myDir = new File(Path);
	   myDir.mkdir();
	   
	   //Get current date and format it in yyyyMMdd format
	   SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
	   Calendar cal = Calendar.getInstance();
	   String d = format.format(cal.getTime());

	   String fName = etCHFID.getText() + "_" + etOfficer.getText() + "_" + d + "_" + Double.toString(Latitude) + "_" + Double.toString( Longitude)+ ".jpg";
	   
	   //Create file and delete if exists
	   File file = new File(myDir,fName);
	   if(file.exists())file.delete();
	   
	   FileOutputStream out = new FileOutputStream(file);
	   theImage.compress(Bitmap.CompressFormat.JPEG, 90, out);
	   
	   out.flush();
	   out.close();
	   
	   //Upload image to the server if network is available
	   if(_General.isNetworkAvailable(this)){
		   
		   if(uf.uploadFileToServer(this,file)){
			   //File uploaded to server successfully
               RegisterUploadDetails(file.getName());
			   file.delete();
			   return 1;
		   }else
		   {
			   //Network is available but file not uploaded
			   return 2;
		   }
	   }else{
		   //Network is not available so file is stored on external memory
		   return 0;
	   }
	   
   }
   
   //create menu 
   
   @Override
   public boolean onCreateOptionsMenu(Menu menu){
	   MenuInflater mif = getMenuInflater();
	   mif.inflate(R.menu.menu, menu);
	   return true;
   }
   
   @Override
   public boolean onOptionsItemSelected(MenuItem item) {
	   switch(item.getItemId()){
	    case R.id.Upload:
	   
		   //Get the total number of files to upload
		   Images = GetListOfFiles(Path);
		   TotalImages = Images.length;
		   
		   //If there are no files to upload give the message and exit 
		   if (TotalImages == 0){
			   ShowDialog(getResources().getString(R.string.NoImages));
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
					   UploadAllImages();
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
							ShowDialog(getResources().getString(R.string.Uploaded));
						}
					}
				});
				   
				   pd.dismiss();
			   }
			   
		   }.start();
		   
	   return true;

           case R.id.mnuStatistics:

               if(!_General.isNetworkAvailable(EnrollmentActivity.this)){
                   ShowDialog(getResources().getString(R.string.InternetRequired));
                   return false;
               }
               if(etOfficer.getText().toString().length() == 0){
                   ShowDialog(getResources().getString(R.string.MissingOfficer));
                   return false;
               }

               Intent Stats = new Intent(EnrollmentActivity.this,Statistics.class);
               Stats.putExtra("Title",getResources().getString(R.string.Statistics));
               Stats.putExtra("OfficerCode",etOfficer.getText().toString());
               EnrollmentActivity.this.startActivity(Stats);

               return true;
	   }
	return super.onOptionsItemSelected(item);
}
   
   private File[] GetListOfFiles(String DirectoryPath){
	   File Directory = new File(DirectoryPath);
	   FilenameFilter filter = new FilenameFilter() {
		
		@Override
		public boolean accept(File dir, String filename) {
			return filename.endsWith(".jpg");
		}
	};
	return Directory.listFiles(filter);
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
   
   private boolean ConnectsFTP(){
	   
	   return uf.isValidFTPCredentials();
	   
   }
   
   private void UploadAllImages(){
	   for(int i=0;i<Images.length;i++){
		   UploadCounter = i + 1;
		   runOnUiThread(ChangeMessage);
		   if(uf.uploadFileToServer(this,Images[i])){
               RegisterUploadDetails(Images[i].getName());
			   Images[i].delete();
		   }
	   }
   }
   
   Runnable ChangeMessage = new Runnable() {
	
	@Override
	public void run() {
		//Change progress dialog message here
		pd.setMessage(UploadCounter + " " + getResources().getString(R.string.Of) + " " + TotalImages + " " + getResources().getString(R.string.Uploading));
		
	}
};

	private void RegisterUploadDetails(String ImageName){
        String[] FileName = ImageName.split("_");
        String CHFID,OfficerCode;


        if (FileName.length > 0){
            CHFID = FileName[0];
            OfficerCode = FileName[1];

            CallSoap cs = new CallSoap();
            cs.setFunctionName("InsertPhotoEntry");
            cs.InsertPhotoEntry(CHFID,OfficerCode,ImageName);
        }
	}

private boolean isValidCHFID(){
//	if (etCHFID.getText().toString().length() != 9) return false;
//	String chfid;
//	int Part1, Part2;
//	Part1 = Integer.parseInt(etCHFID.getText().toString())/10;
//	Part2 = Part1 % 7;
//
//	chfid = etCHFID.getText().toString().substring(0, 8) + Integer.toString(Part2);
//	return etCHFID.getText().toString().equals(chfid);
	return true;
}
   
}