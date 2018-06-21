package com.exact;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.MarshalBase64;
import org.ksoap2.serialization.PropertyInfo;

import java.util.Hashtable;

/**
 * Created by DELL on 21/03/2018.
 */

public class Pictures implements KvmSerializable{
    public InsureeImages[]  InsureeImages;

    @Override
    public Object getProperty(int i) {
        switch (i)
        {
            case 0:
                return InsureeImages;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 1;
    }

    @Override
    public void setProperty(int i, Object o) {
        switch (i)
        {
            case 0:
                InsureeImages = (InsureeImages[])o;
                break;
            default:
                break;
        }
    }

    @Override
    public void getPropertyInfo(int i, Hashtable hashtable, PropertyInfo propertyInfo) {
        switch (i)
        {
            case 0:
                propertyInfo.type = PropertyInfo.OBJECT_CLASS;
                propertyInfo.name = "InsureeImages";
                break;
            default:
                break;
        }
    }
}
