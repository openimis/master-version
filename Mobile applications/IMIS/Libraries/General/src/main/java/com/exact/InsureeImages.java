package com.exact;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.MarshalBase64;
import org.ksoap2.serialization.PropertyInfo;

import java.util.Hashtable;
import java.util.Vector;

/**
 * Created by Hiren on 3/20/2018.
 */

public class InsureeImages extends Vector<String> implements KvmSerializable {

    public String ImageName = null;
    public byte[] ImageContent;

    public InsureeImages(){};

    public InsureeImages(String ImageName, byte[] ImageContent)
    {
        this.ImageName = ImageName;
        this.ImageContent = ImageContent;
    }
    @Override
    public Object getProperty(int i) {
        switch (i)
        {
            case 0:
                return ImageName;
            case 1:
                return ImageContent;
        }
        return  null;
    }

    @Override
    public int getPropertyCount() {
        return 2;
    }

    @Override
    public void setProperty(int i, Object o) {
        switch (i)
        {
            case 0:
                ImageName = o.toString();
                break;
            case 1:
                ImageContent = (byte[]) o;
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
                propertyInfo.type = PropertyInfo.STRING_CLASS;
                propertyInfo.name = "ImageName";
                break;
            case 1:
                propertyInfo.type = MarshalBase64.BYTE_ARRAY_CLASS;
                propertyInfo.name = "ImageContent";
                break;
            default:
                break;
        }
    }
}

