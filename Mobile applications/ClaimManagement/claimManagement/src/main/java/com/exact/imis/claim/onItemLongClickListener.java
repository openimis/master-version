package com.exact.imis.claim;

import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemLongClickListener;

public abstract class onItemLongClickListener implements OnItemLongClickListener {
	public boolean onItemLongClick(AdapterView<?> parent, View view,int position, long id) {
		return true;
	}
	
}
