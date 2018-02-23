package com.exact.imis.feedback_renewal;

//import android.app.Application;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class DataBaseHelper extends SQLiteOpenHelper {

    private final Context myContext;
    private static String DB_PATH = "/data/data/com.exact.imis.feedback_renewal/databases/";
    private static String DB_NAME = "Feedback-Renewal.db3";
    private SQLiteDatabase myDataBase;



    public DataBaseHelper(Context context){
        super(context,DB_NAME,null,1);
        this.myContext = context;
    }

    //Create empty database on the system and rewrites it with our own database
    public void createDatabase() throws IOException{
        boolean dbExists = checkDatabase();
        if (dbExists){
            //Do nothing - Database already exists
        }else{
            //Now by calling following method an empty database will be created on the system default path
           //And then we will overwrite that empty database with our database

            this.getReadableDatabase();
            try{
                copyDatabase();
            }catch (IOException e){
                throw new Error("Error copying database");
            }
        }
    }

    //We will copy our empty database definition from the assets folder. This will be done by transferring byte stream
    private void copyDatabase() throws IOException {
        //Open local db as the input stream
        InputStream myInput = myContext.getAssets().open(DB_NAME);

        //Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;
        //String outFileName = myContext.getFilesDir().getPath() + DB_NAME;

        //Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(outFileName);

        //Transfer bytes from the input file to the output file
        byte[] buffer = new byte[1024];
        int length;
        while((length = myInput.read(buffer)) > 0){
            myOutput.write(buffer,0,length);
        }

        //Close the stream
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    //Check if database already exists to avoid re-copying the file each time we open the application
    private boolean checkDatabase() {
        SQLiteDatabase checkDB = null;
        try{
            String myPath =  DB_PATH + DB_NAME;
            checkDB = SQLiteDatabase.openDatabase(myPath,null,SQLiteDatabase.OPEN_READONLY);
            //SQLiteDatabase.openOrCreateDatabase(Renewal.Path + "Feedback-Renewal.db3",null);
        }catch (SQLiteException e){
            //Database doesn't exist
        }
        if(checkDB != null){
            checkDB.close();
        }

        return checkDB != null ? true : false;
    }

    public void openDatabase() throws SQLiteException{
        //Open the database
        //if (myDataBase != null) return;
        String myPath = DB_PATH + DB_NAME;
        //String myPath = myContext.getFilesDir().getPath() + DB_NAME;

        myDataBase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READWRITE);

    }

    @Override
    public synchronized void close(){
        if(myDataBase != null)
            myDataBase.close();

        super.close();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public String getData(String TableName, String[] Columns, String Where){
        String result = "";
        openDatabase();
        Cursor c  = myDataBase.query(TableName,Columns,Where,null,null,null,null);


        if (c.getCount()==0) return "[]";

        JSONArray array = new JSONArray();
        if(c != null && c.getCount() > 0){
            while(c.moveToNext()){
                JSONObject object = new JSONObject();
                for(int i = 0;i < c.getColumnCount(); i++){
                    try {
                        object.put(c.getColumnName(i),c.getString(i));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                array.put(object);
            }
        }

        return array.toString();
    }

    public void CleanTable(String TableName, String Where){
        openDatabase();
        myDataBase.execSQL("DELETE FROM " + TableName + " WHERE " + Where);
        myDataBase.close();
    }
    public void InsertData(String TableName,String[] Columns,String data) throws JSONException {
        openDatabase();

        JSONArray array = null;
        JSONObject object;

        array = new JSONArray(data);

        if(array.length()==0)
            return;

        for(int i= 0;i < array.length();i++){
            try {
                object = array.getJSONObject(i);
                ContentValues cv = new ContentValues();
                for(String c: Columns){
                    cv.put(c, object.getString(c));
                }
                myDataBase.insert(TableName,null,cv);

            } catch (JSONException e) {
                e.printStackTrace();
            }

        }
            myDataBase.close();
    }

    public void UpdateTable(String TableName, String Updates, String Where){
        openDatabase();
        myDataBase.execSQL("UPDATE "+ TableName +" SET "+ Updates +" WHERE "+ Where +"");
        myDataBase.close();
    }

    public Cursor SearchPayer(String InputText){
        //Cursor c = db.rawQuery("SELECT Code as _id,Code, Name,Code + ' ' + Name AS Disease FROM tblReferences WHERE Type = 'D' AND (Code LIKE '%"+ InputText +"%' OR Name LIKE '%"+ InputText +"%')",null);
        myDataBase = SQLiteDatabase.openOrCreateDatabase(DB_PATH + DB_NAME,null);
        Cursor c = myDataBase.rawQuery("SELECT PayerId _id, PayerName,PayerId  FROM tblPayers WHERE PayerName   LIKE '%"+ InputText + "%'",null);
        if (c != null){
            c.moveToFirst();
        }

        return c;
    }

}

