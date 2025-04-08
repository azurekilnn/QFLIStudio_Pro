package com.luastudio.azure.util;

import android.content.Context;
import android.webkit.WebView;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

public class HttpUtil {
    private static HttpUtil instance;
    public static int mThreadsNum = 64;
    private OkHttpClient.Builder okHttpClientBuilder;
    private static OkHttpClient okHttpClient;

    private HttpUtil() {
        okHttpClientBuilder = new OkHttpClient.Builder();
        okHttpClientBuilder.retryOnConnectionFailure(false);
        okHttpClientBuilder.followRedirects(false);
        okHttpClientBuilder.connectTimeout(0, TimeUnit.SECONDS);
        okHttpClient = okHttpClientBuilder.build();
        okHttpClient.dispatcher().setMaxRequests(mThreadsNum); //设置最大线程池
    }

    public static HttpUtil get() {
        if (instance == null) {
            synchronized (HttpUtil.class) {
                if (instance == null) {
                    instance = new HttpUtil();
                }
            }
        }
        return instance;
    }

    public static void setThreadsNum(int threadsNum) {
        mThreadsNum = threadsNum;
    }
    private Request.Builder createRequest(String url, HashMap<String, String> header, HashMap<String, String> extHeader) {
        Request.Builder requestBuilder = new Request.Builder();
        requestBuilder.url(url);
        //基础请求头
        if (header != null) {
            Set<Map.Entry<String, String>> entries = header.entrySet();
            for (Map.Entry<String, String> entry : entries) {
                requestBuilder.header(entry.getKey(), entry.getValue());
            }
        }
        //额外的请求头
        if (extHeader != null) {
            Set<Map.Entry<String, String>> entries = extHeader.entrySet();
            for (Map.Entry<String, String> entry : entries) {
                requestBuilder.addHeader(entry.getKey(), entry.getValue());
            }
        }
        return requestBuilder;
    }

    private void requestCall(Request request, RequestCallback callback) {
        okHttpClient.newCall(request).enqueue(new Callback() {
            @Override
            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                int statusCode = response.code();
                ResponseBody responseBody = response.body();
                String responseContent = responseBody.string();
                callback.onResponse(call, statusCode, responseContent, response);
            }

            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                callback.onFailure(call,e);
            }
        });
    }

    public OkHttpClient getClient() {
        return okHttpClient;
    }

    public void getUrl(String url, HashMap<String, String> header, HashMap<String, String> extHeader, RequestCallback callback) {
        Request.Builder requestBuilder = createRequest(url, header, extHeader);
        requestBuilder.get();
        Request requestItem = requestBuilder.build();
        requestCall(requestItem, callback);
    }

    public void shutdown() {
        okHttpClient.dispatcher().executorService().shutdown();
        okHttpClient.connectionPool().evictAll();
    }

    public void postUrl(String url, HashMap<String, String> header, HashMap<String, String> extHeader, String postBody, RequestCallback callback) {
        MediaType requestMediaType = MediaType.parse("application/x-www-form-urlencoded; charset=UTF-8");
        RequestBody requestBody = RequestBody.create(requestMediaType,postBody);
        Request.Builder requestBuilder = createRequest(url, header, extHeader);
        requestBuilder.post(requestBody);
        Request requestItem = requestBuilder.build();
        requestCall(requestItem, callback);
    }

    public static String getDefaultUserAgent(Context context) {
        WebView webView = new WebView(context);
        return webView.getSettings().getUserAgentString();
    }

    public static String getRequestUserAgent(Context context, String userAgent) {
        String realUA;
        if (userAgent != null) {
            realUA = userAgent;
        } else {
            realUA = getDefaultUserAgent(context);
        }
        return realUA;
    }

    public interface RequestCallback {
        void onResponse(Call call, int code, String content, Response response);

        void onFailure(Call call, IOException e);
    }

}
