package com.exact.uploadfile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.SocketException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import android.R;
import android.content.Context;

import com.exact.general.getFTPCredentials;

public class UploadFile {
	
	FTPClient f;
	getFTPCredentials ftp = new getFTPCredentials();
	final String Host = ftp.Host;  //"173.192.19.70";
	final int Port = ftp.Port;
	final String UserName = ftp.UserName;
	final String Password = ftp.Password;
	final String FTPEnrollmentFolder = ftp.FTPEnrollmentFolder;
	final String FTPClaimFolder = ftp.FTPClaimFolder;
	final String FTPFeedbackFolder = ftp.FTPFeedbackFolder;
	final String FTPPolicyRenewalFolder = ftp.FTPPolicyRenewalFolder;
	
	public boolean isValidFTPCredentials(){
		f = new FTPClient();
		try {
			f.connect(Host, Port);
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			return f.login(UserName, Password);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean uploadFileToServer(Context ctx,File file){
		boolean result = false;
		try {
			String UploadPath = "";
			String Package = ctx.getApplicationInfo().packageName;
			
			if (Package.equalsIgnoreCase("com.exact.imis.feedback"))
				UploadPath = FTPFeedbackFolder;
			else if (Package.equalsIgnoreCase("com.exact.imis.enrollment"))
				UploadPath = FTPEnrollmentFolder;
			else if (Package.equalsIgnoreCase("com.exact.imis.renewal"))
				UploadPath = FTPPolicyRenewalFolder;
			else if (Package.equalsIgnoreCase("com.exact.imis.Claim"))
				UploadPath = FTPClaimFolder;
			
			
			f = new FTPClient();
			f.connect(Host,Port);
			if(f.login(UserName, Password)){
				f.setFileType(FTP.BINARY_FILE_TYPE);
				f.enterLocalPassiveMode();
							
				FileInputStream in = new FileInputStream(file);
				result = f.storeFile(UploadPath + "/" + file.getName(), in);
				
				in.close();
				 //Log.v("upload result", "succeeded");
			}else{
				return false;
			}
			
			f.logout();
			f.disconnect();
			
		} catch (SocketException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	} 
	


}
