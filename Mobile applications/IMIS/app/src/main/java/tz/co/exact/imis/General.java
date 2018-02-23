package tz.co.exact.imis;

import java.util.Locale;


import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.util.DisplayMetrics;

import java.util.Locale;

/**
 * Created by Hiren on 12/6/2017.
 */

public class General {
    private String _Domain = "http://imis-mv.swisstph-mis.ch/";
    public String getDomain(){
        return _Domain;
    }

    public int isSDCardAvailable(){
        String State = Environment.getExternalStorageState();
        if (State.equals(Environment.MEDIA_MOUNTED_READ_ONLY)){
            return 0;
        }else if(!State.equals(Environment.MEDIA_MOUNTED)){
            return -1;
        }else{
            return 1;
        }
    }

    public boolean isNetworkAvailable(Context ctx){
        ConnectivityManager cm = (ConnectivityManager) ctx.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo ni = cm.getActiveNetworkInfo();

        return (ni != null && ni.isConnected());


    }

    public void ChangeLanguage(Context ctx,String Language){
        Resources res = ctx.getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        android.content.res.Configuration config = res.getConfiguration();
        config.locale = new Locale(Language.toLowerCase());
        res.updateConfiguration(config, dm);
    }

    public String getVersion(Context ctx, String PackageName){
        String VersionName = "";

        PackageManager manager = ctx.getPackageManager();
        try {
            PackageInfo info = manager.getPackageInfo(PackageName, 0);
            //int Code = info.versionCode;
            VersionName = info.versionName;


        } catch (PackageManager.NameNotFoundException e) {
            // TODO Auto-generated catch block

        }
        return VersionName;

    }

    public boolean isNewVersionAvailable(String Field,Context ctx, String PackageName){
        String result;
        CallSoap cs = new CallSoap();
        cs.setFunctionName("GetCurrentVersion");
        result = cs.GetCurrentVersion(Field);
        if (result == "") return false;
        return (!getVersion(ctx,PackageName).toString().equals(result));

    }
}
