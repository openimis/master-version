package com.exact.imis.claim;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.CursorAdapter;
import android.widget.TextView;

public class DiseaseAdapter extends CursorAdapter implements AdapterView.OnItemClickListener {
    SQLHandler sql;
    SQLiteDatabase db;
    public DiseaseAdapter(Context context, Cursor cursor){
        super(context,null);
        sql = new SQLHandler(context);
        sql.onOpen(db);
    }
    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent) {
        final LayoutInflater inflater = LayoutInflater.from(context);
        final View view = inflater.inflate(R.layout.disease_list,parent, false);
        return view;
    }

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
        final int itemColumnIndex = cursor.getColumnIndexOrThrow("Code");
        final int descColumnIndex = cursor.getColumnIndexOrThrow("Name");
        String Suggestion = cursor.getString(itemColumnIndex) + " " + cursor.getString(descColumnIndex);
        TextView text1 = (TextView) view.findViewById(R.id.text1);
        text1.setText(Suggestion);

    }

    @Override
    public Cursor runQueryOnBackgroundThread(CharSequence constraint) {
        if (getFilterQueryProvider() != null) {
            return getFilterQueryProvider().runQuery(constraint);
        }
        Cursor cursor = sql.SearchDisease(
                (constraint != null ? constraint.toString() : ""));

        return cursor;
    }

    @Override
    public CharSequence convertToString(Cursor cursor) {
        final int columnIndex = cursor.getColumnIndexOrThrow("Code");
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

