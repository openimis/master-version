package com.exact.imis.claim;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.TextView;

public class ItemAdapter extends CursorAdapter {
    SQLHandler sql;
    SQLiteDatabase db;

    public ItemAdapter(Context context, Cursor c) {
        super(context,null);
        sql = new SQLHandler(context);
        sql.onOpen(db);
    }

    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent) {
        final LayoutInflater inflater = LayoutInflater.from(context);
        final View view = inflater.inflate(R.layout.spinneritem,parent, false);
        return view;
    }

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
        final int itemColumnIndex = cursor.getColumnIndexOrThrow("Code");
        final int descColumnIndex = cursor.getColumnIndexOrThrow("Name");
        String Code = cursor.getString(itemColumnIndex);
        TextView tvCode = (TextView) view.findViewById(R.id.tvCode);
        tvCode.setText(Code);

        String Name = cursor.getString(descColumnIndex);
        TextView tvName = (TextView) view.findViewById(R.id.tvName);
        tvName.setText(Name);
    }

    @Override
    public Cursor runQueryOnBackgroundThread(CharSequence constraint) {
        if(getFilterQueryProvider() != null){
            return getFilterQueryProvider().runQuery(constraint);
        }
        Cursor cursor = sql.SearchItems((constraint != null ? constraint.toString() : ""));

        return cursor;
    }

    @Override
    public CharSequence convertToString(Cursor cursor) {
        final  int columnIndex = cursor.getColumnIndexOrThrow("Code");
        final String str = cursor.getString(columnIndex);
        return  str;
    }
}
