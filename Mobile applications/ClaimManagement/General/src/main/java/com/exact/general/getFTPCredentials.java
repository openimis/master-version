package com.exact.general;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

import com.exact.CallSoap.CallSoap;

public class getFTPCredentials {
	
	public String Host = "";
	public String UserName = "";
	public String Password = "";
	public int Port = 21;
	public String FTPEnrollmentFolder = "";
	public String FTPClaimFolder = "";
	public String FTPFeedbackFolder = "";
	public String FTPPolicyRenewalFolder = "";
	
		
	public getFTPCredentials(){
		String rslt = "";
		
		CallSoap cs = new CallSoap();
		cs.setFunctionName("getFTPCredentials");
		rslt = cs.Call();
		
			try {
				JSONArray jsonArray = new JSONArray(rslt);
				for (int i =0;i < jsonArray.length();i++){
					JSONObject jsonObject = jsonArray.getJSONObject(i);
					Host = jsonObject.getString("Host");
					UserName = jsonObject.getString("UserName");
					Password = jsonObject.getString("Password");
					Port = jsonObject.getInt("Port");
					FTPEnrollmentFolder = jsonObject.getString("FTPEnrollmentFolder");
					FTPClaimFolder = jsonObject.getString("FTPClaimFolder");
					FTPFeedbackFolder = jsonObject.getString("FTPFeedbackFolder");
					FTPPolicyRenewalFolder = jsonObject.getString("FTPPolicyRenewalFolder");
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		
			}
	
	}
	

