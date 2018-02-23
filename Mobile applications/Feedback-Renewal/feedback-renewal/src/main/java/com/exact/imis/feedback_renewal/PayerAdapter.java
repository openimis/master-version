package com.exact.imis.feedback_renewal;

import android.widget.AdapterView;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.TextView;
/**
 * Created by Hiren on 29/11/2016.
 */

public class PayerAdapter extends CursorAdapter implements AdapterView.OnItemClickListener {
    DataBaseHelper sql;
    SQLiteDatabase db;
    public PayerAdapter(Context context, Cursor cursor){
        super(context,null);
        sql = new DataBaseHelper(context);
        sql.onOpen(db);
    }
    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent) {
        final LayoutInflater inflater = LayoutInflater.from(context);
        final View view = inflater.inflate(R.layout.payer_list,parent, false);
        return view;
    }

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
        final int descColumnIndex = cursor.getColumnIndexOrThrow("PayerName");
        final int IdColumnIndex = cursor.getColumnIndexOrThrow("PayerId");
               String Suggestion = cursor.getString(descColumnIndex);
        TextView text1 = (TextView) view.findViewById(R.id.text1);
        text1.setText(Suggestion);

    }

    @Override
    public Cursor runQueryOnBackgroundThread(CharSequence constraint) {
        if (getFilterQueryProvider() != null) {
            return getFilterQueryProvider().runQuery(constraint);
        }
        Cursor cursor = sql.SearchPayer(
                (constraint != null ? constraint.toString() : ""));

        return cursor;
    }

    @Override
    public CharSequence convertToString(Cursor cursor) {
        final int columnIndex = cursor.getColumnIndexOrThrow("PayerName");
        final String str = cursor.getString(columnIndex);
        return str;
    }


    @Override
    public void onItemClick(AdapterView<?> listView, View view, int position, long id) {
//        Cursor cursor = (Cursor) listView.getItemAtPosition(position);
//
//        // Get the Item Number from this row in the database.
//        String itemNumber = cursor.getString(cursor.getColumnIndexOrThrow("Code"));


    }
}


