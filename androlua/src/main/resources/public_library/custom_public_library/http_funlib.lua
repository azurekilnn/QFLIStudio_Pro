--检测VPN
function check_vpn()
  if (NetworkUtil.isVpnUsed()) then
    return false
   else
    return true
  end
end

--设置全局UserAgent
function set_global_ua()
  import "android.webkit.WebView"
  system_user_agent=WebView(activity).getSettings().getUserAgentString()
  return system_user_agent
end

--初始化okHttp客户端
function init_okhttp_client()
  --设置最大线程池
  maxRequests = activity.getSharedData("okttp_max_requets")
  if maxRequests == nil then
    maxRequests=10
  end
  import "okhttp3.*"
  import "java.util.concurrent.*"
  --okHttpClient = OkHttpClient()
  okHttpClientBuilder = OkHttpClient.Builder()
  okHttpClientBuilder.retryOnConnectionFailure(false)
  okHttpClientBuilder.followRedirects(false)
  okHttpClientBuilder.readTimeout(10, TimeUnit.SECONDS)
  --okHttpClientBuilder.setConnectTimeout(3,TimeUnit.SECONDS);
  okHttpClient = okHttpClientBuilder.build()
  okHttpClient.dispatcher().setMaxRequests(tointeger(maxRequests));--设置最大线程池
  --okHttpClient.dispatcher().setMaxRequestsPerHost(8);--设置当个服务器连接次数
end



--okHttp请求
function okhttp_request(url,args,callback)
  if (check_vpn()) then
    if okHttpClient then
     else
      init_okhttp_client()
    end
    local request_builder = Request.Builder()
    request_builder.url(url)
    if args["user_agent"] then
      request_builder.header('User-Agent',args["user_agent"])
     else
      if system_user_agent then
       else
        system_user_agent=set_global_ua()
      end
      request_builder.header('User-Agent',system_user_agent)
    end
    if args["cookies"] then
      if type(args["cookies"])=="string" then
        request_builder.header('Cookie',args["cookies"])
       elseif type(args["cookies"])=="table" then
        for index,content in ipairs(args["cookies"]) do
          if type(content)=="string" then
            request_builder.addHeader('Cookie',content)
          end
        end
      end
    end

    local socketUrl=import("socket.url")
    request_builder.header("Referer",socketUrl.escape(url))
    local requestMediaType=(args["postbody"]~=nil and MediaType.parse('application/x-www-form-urlencoded; charset=UTF-8'))
    local post_request_body=(args["postbody"]~=nil and RequestBody.create(requestMediaType,args["postbody"]))

    local request = ((args["postbody"]~=nil and post_request_body and request_builder.post(post_request_body)) or request_builder.get())
    local request = request.build()

    local call_back = okHttpClient.newCall(request)
    call_back.enqueue(Callback({
      onFailure=function(call,e)
        activity.runOnUiThread(function()
          local content=tostring(e.getMessage())
          call.cancel();
          callback(404,{content=content})
        end)
      end,
      onResponse=function(call,response)
        activity.runOnUiThread(function()
          local status,str=pcall(function()
            local code=tonumber(response.code())
            local content=tostring(response.body().string())
            if code==200 then
              local headers = response.headers();
              local cookies = headers.values("Set-Cookie");
              callback({code=code,content=content,response=response,cookies=cookies,headers=headers})
             else
              callback({code=code,content=content,response=response})
            end
          end)
        end)
      end
    }))
   else
    callback(404)
  end
end

function init_cookie_manager()
  import "android.webkit.CookieManager"
  --import "com.tencent.smtt.sdk.CookieManager"
  cookie_manager = CookieManager.getInstance()
  return cookie_manager
end

function get_cookies(url)
  --分割字符串函数
  local function split_string(str, delimeter)
    local find, sub, insert = string.find, string.sub, table.insert
    local res = {}
    local start, start_pos, end_pos = 1, 1, 1
    while true do
      start_pos, end_pos = find(str, delimeter, start, true)
      if not start_pos then
        break
      end
      insert(res, sub(str, start, start_pos - 1))
      start = end_pos + 1
    end
    insert(res, sub(str,start))
    return res
  end

  if cookie_manager then
   else
    cookie_manager = init_cookie_manager()
  end
  if url then
    local cookies = cookie_manager.getCookie(url)
    if cookies then
      local split_cookies = split_string(cookies,";")
      return true,split_cookies
     else
      return false
    end
   else
    return false
  end
end

function clear_cookies()
  if cookie_manager then
   else
    cookie_manager = init_cookie_manager()
  end
  --  cookie_manager.removeAllCookies(null);
  --  cookie_manager.flush();
end

function get_domain_name(url)
  local domain_name=((url and (url:find("https") and ("https://"..url:match("//(.-)/")) or url:find("http") and ("http://"..url:match("//(.-)/")))) or url)
  return domain_name
end


function upload_file(url,path,callback)
  if okHttpClient then
   else
    init_okhttp_client()
  end
  if path then
    local file=File(path)
    local post_request_body_builder = MultipartBody.Builder()
    post_request_body_builder.setType(MultipartBody.FORM)
    post_request_body_builder.addFormDataPart("file",tostring(file["name"]),RequestBody.create(MediaType.parse("multipart/form-data"), file))
    local post_request_body=post_request_body_builder.build()

    local request_builder = Request.Builder()
    request_builder.url(url)

    if system_user_agent then
     else
      system_user_agent=set_global_ua()
    end
    request_builder.header('User-Agent',system_user_agent)

    local request = request_builder.post(post_request_body)
    local request = request.build()
    local call_back = okHttpClient.newCall(request)
    call_back.enqueue(Callback{
      onFailure=function(call,e)
        activity.runOnUiThread(function()
          local content = tostring(e.getMessage())
          call.cancel();
          callback(404,content)
        end)
      end,
      onResponse=function(call, response)--请求成功
        activity.runOnUiThread(function()
          local code = tonumber(response.code())
          local content=tostring(response.body().string())
          local headers = response.headers()
          local uploaded_url = headers.values("Location");
          if uploaded_url and #uploaded_url~=0 then
            local uploaded_url=luajava.astable(uploaded_url)
            callback(code,content,uploaded_url[1])
           else
          end
        end)
      end
    });
  end
end

--链接过滤
function url_filter(url)
  local status,str=pcall(function()return url:match("(.+)%&s")end)
  if status and str then
    return str
   else
    return url
  end
end