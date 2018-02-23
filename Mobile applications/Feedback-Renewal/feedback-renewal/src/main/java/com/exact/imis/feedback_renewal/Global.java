package com.exact.imis.feedback_renewal;

import android.app.Application;

public class Global extends Application {
    private String OfficerCode;
    private String IMEI;
    private String PhoneNumber;

    public String getOfficerCode() {
        return OfficerCode;
    }

    public void setOfficerCode(String officerCode) {
        OfficerCode = officerCode;
    }

    public String getIMEI() {
        return IMEI;
    }

    public void setIMEI(String IMEI) {
        this.IMEI = IMEI;
    }

    public String getPhoneNumber() {
        return PhoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        PhoneNumber = phoneNumber;
    }
}


