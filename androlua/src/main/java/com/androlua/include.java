package com.androlua;
import android.content.Context;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.widget.AppCompatTextView;

public class include extends AppCompatTextView {
    public include(Context context){
        super(context);
        setText("include : null");
    }

    public void setLayout(String text){
        this.setText("include："+text);
    }

}