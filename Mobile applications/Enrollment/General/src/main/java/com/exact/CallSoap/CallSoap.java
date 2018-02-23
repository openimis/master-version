package com.exact.CallSoap;//
import java.io.IOException;
import java.util.Date;
import java.util.StringTokenizer;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.MarshalDate;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.xmlpull.v1.XmlPullParserException;

import com.exact.general.General;

import android.R.string;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;


public class CallSoap {
	private String FunctionName;
	public void setFunctionName(String functionName) {
		FunctionName = functionName;
		SOAP_ACTION = "http://tempuri.org/" + FunctionName;
		//SOAP_ACTION = _General.getDomain()  + FunctionName;
		OPERATION_NAME = "" + FunctionName;
	}
	General _General = new General();
	public String SOAP_ACTION = "http://tempuri.org/";
	public String OPERATION_NAME = "";
	public final String WSDL_TARGET_NAMESPACE = "http://tempuri.org/";
	
	public final String SOAP_ADDRESS = _General.getDomain() + "/Services/exactservices.asmx";
	//public final String SOAP_ADDRESS = "http://192.168.10.246/TestService/ExactServices.asmx";
	
	public CallSoap(){
		
	}
	
	
	public String Call(){
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
//		PropertyInfo pi = new PropertyInfo();
//		pi.setName("FirstName");
//		pi.setValue(FirstName);
//		pi.setType(String.class);
//		request.addProperty(pi);
//		
//		pi = new PropertyInfo();
//		pi.setName("LastName");
//		pi.setValue(LastName);
//		pi.setType(String.class);
//		request.addProperty(pi);
	
			
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE HttpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			HttpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			response = e.toString();
		} catch (XmlPullParserException e) {
			response = e.toString();
		}
		
		return response.toString();
	}
	
	public String getInsureeInfo(String CHFID){
		
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
		PropertyInfo pi = new PropertyInfo();
		pi.setName("CHFID");
		pi.setValue(CHFID);
		pi.setType(String.class);
		request.addProperty(pi);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			httpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			response = e.toString();
		} catch (XmlPullParserException e) {
			// TODO Auto-generated catch block
			response = e.toString();
		}
		
		
		return response.toString();
		
	}
	
	public String GetCurrentVersion(String Field){
		
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
		
		PropertyInfo pi = new PropertyInfo();
		pi.setName("Field");
		pi.setValue(Field);
		pi.setType(String.class);
		request.addProperty(pi);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			httpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			//response = e.toString();
			response = "";
		} catch (XmlPullParserException e) {
			// TODO Auto-generated catch block
			//response = e.toString();
			response = "";
		}
		
		
		return response.toString();
		
	}
	
	
	public boolean isPolicyAccepted(String FileName){
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
		
		PropertyInfo pi = new PropertyInfo();
		pi.setName("FileName");
		pi.setValue(FileName);
		request.addProperty(pi);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			httpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			return false;
		} catch (XmlPullParserException e) {
			// TODO Auto-generated catch block
			return false;
		}
		
		return Boolean.parseBoolean(response.toString());
		
	}
	
	public boolean isClaimAccepted(String FileName){
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
		
		PropertyInfo pi = new PropertyInfo();
		pi.setName("FileName");
		pi.setValue(FileName);
		request.addProperty(pi);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			httpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			return false;
		} catch (XmlPullParserException e) {
			// TODO Auto-generated catch block
			return false;
		}
		
		return Boolean.parseBoolean(response.toString());
		
	}
	
	public boolean isFeedbackAccepted(String FileName){
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE,OPERATION_NAME);
		
		PropertyInfo pi = new PropertyInfo();
		pi.setName("FileName");
		pi.setValue(FileName);
		request.addProperty(pi);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);
		
		HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
		Object response = null;
		
		try {
			httpTransport.call(SOAP_ACTION, envelope);
			response = envelope.getResponse();
		} catch (IOException e) {
			return false;
		} catch (XmlPullParserException e) {
			return false;
		}
		
		return Boolean.parseBoolean(response.toString());
	}

	public void InsertPhotoEntry(String CHFID, String OfficerCode, String FileName){
		SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE,OPERATION_NAME);


        PropertyInfo pi = new PropertyInfo();
        pi.setName("FileName");
        pi.setValue(FileName);
        request.addProperty(pi);

        pi = new PropertyInfo();
		pi.setName("CHFID");
        pi.setValue(CHFID);
		request.addProperty(pi);

		pi = new PropertyInfo();
		pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
		request.addProperty(pi);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
		envelope.dotNet = true;
		envelope.setOutputSoapObject(request);

		HttpTransportSE transportSE = new HttpTransportSE(SOAP_ADDRESS);


        try {
            transportSE.call(SOAP_ACTION,envelope);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XmlPullParserException e) {
            e.printStackTrace();
        }

    }

    public String GetEnrolmentStats(String OfficerCode, Date FromDate, Date ToDate){
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("FromDate");
        pi.setValue(FromDate);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("ToDate");
        pi.setValue(ToDate);
        request.addProperty(pi);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);

        HttpTransportSE transportSE = new HttpTransportSE(SOAP_ADDRESS);
        Object response = null;

        new MarshalDate().register(envelope);

        try {
            transportSE.call(SOAP_ACTION,envelope);
            response = envelope.getResponse();
        } catch (IOException e) {
            e.printStackTrace();
            return "[]";
        } catch (XmlPullParserException e) {
            e.printStackTrace();
            return "[]";
        }

        return response.toString();
    }
}
