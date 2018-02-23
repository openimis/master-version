package tz.co.exact.imis;

import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.MarshalDate;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;
import org.xmlpull.v1.XmlPullParserException;


/**
 * Created by Hiren on 12/6/2017.
 */

class CallSoap {
    private String FunctionName;

    public void setFunctionName(String functionName) {
        FunctionName = functionName;
        SOAP_ACTION = "http://tempuri.org/" + FunctionName;
        OPERATION_NAME = "" + FunctionName;
    }

    General _General = new General();
    public String SOAP_ACTION = "http://tempuri.org/";
    public String OPERATION_NAME = "";
    public final String WSDL_TARGET_NAMESPACE = "http://tempuri.org/";

    public final String SOAP_ADDRESS = _General.getDomain() + "/Services/exactservices.asmx";
    //public final String SOAP_ADDRESS = "http://192.168.10.246/TestService/ExactServices.asmx";

    public CallSoap() {

    }


    public String Call() {
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

    public String getInsureeInfo(String CHFID) {

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

    public String getPayers(String OfficerCode) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
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

    public String GetCurrentVersion(String Field) {

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


    public int isPolicyAccepted(String FileName) {
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
        int Result;
        try {
            httpTransport.call(SOAP_ACTION, envelope);
            response = envelope.getResponse();
            if (Boolean.parseBoolean(response.toString()) == true) {
                Result = 1;
            } else {
                Result = 0;
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            return -1;
        } catch (XmlPullParserException e) {
            // TODO Auto-generated catch block
            return -1;
        }

        return Result;

    }

    public boolean isClaimAccepted(String FileName) {
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

    public int isFeedbackAccepted(String FileName) {
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
        int Result = -1;
        try {
            httpTransport.call(SOAP_ACTION, envelope);
            response = envelope.getResponse();
            if (Boolean.parseBoolean(response.toString()) == true)
                Result = 1;
            else if (Boolean.parseBoolean(response.toString()) == false)
                Result = 0;


        } catch (IOException e) {
            return -1;
        } catch (XmlPullParserException e) {
            return -1;
        }

        return Result;
    }


    public int isValidPhone(String OfficerCode, String PhoneNumber) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("PhoneNumber");
        pi.setValue(PhoneNumber);
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
            return -1;
        } catch (XmlPullParserException e) {
            return -1;
        }
        boolean Res = Boolean.parseBoolean(response.toString());
        if (Res == true) {
            return 1;
        } else {
            return 0;
        }
    }

    public String getFeedbackRenewals(String OfficerCode) throws IOException, XmlPullParserException {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
        request.addProperty(pi);


        request.addProperty(pi);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);

        HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
        Object response = null;


        httpTransport.call(SOAP_ACTION, envelope);
        response = envelope.getResponse();


        return response.toString();
    }

    public boolean isUniqueReceiptNo(String ReceiptNo, String CHFID) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("ReceiptNo");
        pi.setValue(ReceiptNo);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("CHFID");
        pi.setValue(CHFID);
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

    public String GetFeedbackStats(String OfficerCode, Date FromDate, Date ToDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("FromDate");
        pi.setValue(sdf.format(FromDate));
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("ToDate");
        pi.setValue(sdf.format(ToDate));
        request.addProperty(pi);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);

        HttpTransportSE transportSE = new HttpTransportSE(SOAP_ADDRESS);
        Object response = null;

        new MarshalDate().register(envelope);
        try {
            transportSE.call(SOAP_ACTION, envelope);
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

    public String GetRenewalStats(String OfficerCode, Date FromDate, Date ToDate) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("OfficerCode");
        pi.setValue(OfficerCode);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("FromDate");
        pi.setValue(sdf.format(FromDate));
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("ToDate");
        pi.setValue(sdf.format(ToDate));
        request.addProperty(pi);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);

        HttpTransportSE transportSE = new HttpTransportSE(SOAP_ADDRESS);
        Object response = null;

        new MarshalDate().register(envelope);
        try {
            transportSE.call(SOAP_ACTION, envelope);
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

    public int isUserLoggedIn(String LoginName, String Password) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("LoginName");
        pi.setValue(LoginName);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("Password");
        pi.setValue(Password);
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
            return 0;
        } catch (XmlPullParserException e) {
            return 0;
        }

        return Integer.parseInt(response.toString());
    }

    public int EnrollFamily(String Family, String Insuree, String Policy, String Premium, int UserId, int OfficerId) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("Family");
        pi.setValue(Family);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("Insuree");
        pi.setValue(Insuree);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("Policy");
        pi.setValue(Policy);
        request.addProperty(pi);


        pi = new PropertyInfo();
        pi.setName("Premium");
        pi.setValue(Premium);
        request.addProperty(pi);


        pi = new PropertyInfo();
        pi.setName("OfficerId");
        pi.setValue(OfficerId);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("UserId");
        pi.setValue(UserId);
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
            return -1;
        } catch (XmlPullParserException e) {
            return -1;
        }

        return Integer.parseInt(response.toString());

    }


    public void InsertPhotoEntry(String CHFID, String OfficerCode, String FileName) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);


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
            transportSE.call(SOAP_ACTION, envelope);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XmlPullParserException e) {
            e.printStackTrace();
        }

    }

    public String downloadMasterData() {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);

        HttpTransportSE httpTransport = new HttpTransportSE(SOAP_ADDRESS);
        Object response = null;

        try {
            httpTransport.call(SOAP_ACTION, envelope);
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

    public void DiscontinuePolicy(int RenewalId) throws IOException, XmlPullParserException {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);

        PropertyInfo pi = new PropertyInfo();
        pi.setName("RenewalId");
        pi.setValue(RenewalId);
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
            e.printStackTrace();
            throw e;
        } catch (XmlPullParserException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public String GetEnrolmentStats(String OfficerCode, Date FromDate, Date ToDate) {
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
            transportSE.call(SOAP_ACTION, envelope);
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

    public String DownloadFamilyData(String CHFID, int LocationId) {
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(110);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);
        HttpTransportSE httpTransport = new HttpTransportSE(this.SOAP_ADDRESS);
        PropertyInfo pi = new PropertyInfo();
        pi.setName("CHFID");
        pi.setValue(CHFID);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("LocationId");
        pi.setValue(LocationId);
        request.addProperty(pi);

        Object response = null;

        try {
            httpTransport.call(this.SOAP_ACTION, envelope);
            response = envelope.getResponse();
        } catch (IOException var6) {
            var6.printStackTrace();
            return "[]";
        } catch (XmlPullParserException var7) {
            var7.printStackTrace();
            return "[]";
        }

        return response.toString();
    }
    public  int DeleteFromPhone(int Id, int AuditUserID, String DeleteInfo){
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(110);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);
        HttpTransportSE httpTransport = new HttpTransportSE(this.SOAP_ADDRESS);
        PropertyInfo pi = new PropertyInfo();
        pi.setName("Id");
        pi.setValue(Id);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("AuditUserID");
        pi.setValue(AuditUserID);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("DeleteInfo");
        pi.setValue(DeleteInfo);
        request.addProperty(pi);

        Object response = null;

        try {
            httpTransport.call(this.SOAP_ACTION, envelope);
            response = envelope.getResponse();
        } catch (IOException var6) {
            var6.printStackTrace();
            return -1;
        } catch (XmlPullParserException var7) {
            var7.printStackTrace();
            return -1;
        }

        return Integer.parseInt(response.toString());

    }

    public double getPolicyValue( int FamilyId,  int ProdId , int PolicyId , String PolicyStage ,String EnrollDate, int  PreviousPolicyId ){
        SoapObject request = new SoapObject(WSDL_TARGET_NAMESPACE, OPERATION_NAME);
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(110);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);
        HttpTransportSE httpTransport = new HttpTransportSE(this.SOAP_ADDRESS);
        PropertyInfo pi = new PropertyInfo();
        pi.setName("FamilyId");
        pi.setValue(FamilyId);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("ProdId");
        pi.setValue(ProdId);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("PolicyId");
        pi.setValue(PolicyId);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("PolicyStage");
        pi.setValue(PolicyStage);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("EnrollDate");
        pi.setValue(EnrollDate);
        request.addProperty(pi);

        pi = new PropertyInfo();
        pi.setName("PreviousPolicyId");
        pi.setValue(PreviousPolicyId);
        request.addProperty(pi);

        Object response = null;
        try {
            httpTransport.call(this.SOAP_ACTION, envelope);
            response = envelope.getResponse();
        } catch (IOException var6) {
            var6.printStackTrace();
            return -1;
        } catch (XmlPullParserException var7) {
            var7.printStackTrace();
            return -1;
        }
        return Double.parseDouble(response.toString());
    }
}
