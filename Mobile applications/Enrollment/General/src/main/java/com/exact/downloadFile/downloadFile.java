package com.exact.downloadFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.SocketException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import com.exact.general.getFTPCredentials;

public class downloadFile {
	
	FTPClient f;
	getFTPCredentials ftp = new getFTPCredentials();
	final String Host = ftp.Host;  //"173.192.19.70";
	final int Port = ftp.Port;
	final String UserName = ftp.UserName;
	final String Password = ftp.Password;

	
	InputStream in;
	
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
	
	public InputStream  DownloadFileFromServer(String file){
		try {
			
			f = new FTPClient();
			f.connect(Host,Port);
			if(f.login(UserName, Password)){
				f.setFileType(FTP.BINARY_FILE_TYPE);
				f.enterLocalPassiveMode();
				
				
				in =  f.retrieveFileStream(file);
				
			
				 //Log.v("upload result", "succeeded");
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
		return in;
	} 
	
}
