package com.qflistudio.azure.editor;

import android.content.Context;
import android.util.AttributeSet;

import java.io.File;

public class CodeEditor extends io.github.rosemoe.sora.widget.CodeEditor {

    public boolean editorInitStatus = false;
    public File currOpenedFile;

    public CodeEditor(Context context) {
        super(context);
    }

    public CodeEditor(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CodeEditor(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public CodeEditor(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    public void setEditorInitStatus(boolean editorInitStatus) {
        this.editorInitStatus = editorInitStatus;
    }


    public boolean getEditorInitStatus() {
        return this.editorInitStatus;
    }

    public boolean getEditorInitState() {
        return this.editorInitStatus && !this.getText().toString().isEmpty();
    }


    public void setCurrOpenedFile(File file) {
         currOpenedFile = file;
    }

    public File getCurrOpenedFile() {
        return currOpenedFile;
    }


}
