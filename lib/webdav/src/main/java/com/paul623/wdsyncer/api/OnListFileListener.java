package com.paul623.wdsyncer.api;

import com.paul623.wdsyncer.model.DavData;
import com.thegrizzlylabs.sardineandroid.DavResource;

import java.util.List;

public interface OnListFileListener {
    public void listAll(List<DavData> davResourceList);
    public void onError(String errorMsg);
}
