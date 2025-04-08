require("http_funlib")

local JsonUtil = require("JsonUtil")
local domain_name = "lqsxm666.top"
local emblog_main_api = "https://"..domain_name.."/?rest-api="
--登录接口
local account_api="https://"..domain_name.."/admin/account.php?action="
local siginin_url="https://"..domain_name.."/admin/account.php?action=dosignin"
local checkcode_url="https://"..domain_name.."/include/lib/checkcode.php"

--通用查询接口
function get_query_url(method) 
  return emblog_main_api..method
end

function get_account_url(method)
  return account_api..method
end

--获取验证码
function get_code_bitmap(url,cookies)
  import "java.net.HttpURLConnection"
  import "java.net.URL"
  import "java.net.URLConnection"
  import "java.io.FileInputStream"
  local img_url = URL(url);
  local img_connection = img_url.openConnection();
  img_connection.setDoInput(true);
  img_connection.setRequestProperty('User-Agent',system_user_agent)
  if type(cookies)=="table" then
    for index,content in ipairs(cookies) do
      img_connection.addRequestProperty("Cookie",content)
    end
  elseif type(cookies)=="string" then
    img_connection.setRequestProperty("Cookie",cookies)
  end
  img_connection.connect();

  local is = img_connection.getInputStream();

  import "android.graphics.BitmapFactory"
  local bitmap = BitmapFactory.decodeStream(is);
  is.close();
  import "android.graphics.Matrix"
  import "android.graphics.Bitmap"
  local matrix = Matrix()
  matrix.postScale(3.0,3.0)
  local bitmap=Bitmap.createBitmap(bitmap,0,0,bitmap.getWidth(),bitmap.getHeight(),matrix,true)
  return bitmap;
end

--获取用户信息
function get_user_info(cookies,callback)
  okhttp_request(get_query_url("userinfo"),{cookies=cookies},function(code,content)
    local status,json_data=JsonUtil.parseJson(content)
    if (status and json_data["code"]==0) then
      local code=json_data["code"]
      local msg=json_data["msg"]
      local data=json_data["data"] or {}
      local user_info=data["userinfo"] or {}
      callback(true,msg,user_info,cookies)
     else
      callback(false,msg)
    end
  end)
end

--Emblog 登录
function emblog_login(user,pass,login_code,hist_cookies,callback)
  if hist_cookies then
    get_user_info(hist_cookies,callback)
   else
    okhttp_request(get_account_url("dosignin"),{postbody="user="..user.."&pw="..pass.."&login_code="..login_code.."&resp=json"},function(code,content,cookies)
      local status,json_data=JsonUtil.parseJson(content)
      if (status and json_data["code"]==0) then
        local code=json_data["code"]
        local msg=json_data["msg"]
        get_user_info(cookies,callback)
       else
        local msg=json_data["msg"]
        callback(false,msg)
      end
    end)
  end
end

function emblog_register(email,pass,code,login_code,cookies,callback)
  okhttp_request(get_account_url("dosignup"),{postbody="mail="..email.."&passwd="..pass.."&mail_code="..code.."&login_code="..login_code.."&repasswd="..pass.."&resp=json",cookies=cookies},function(code,content,cookies)
    local status,json_data=JsonUtil.parseJson(content)
    if (status and json_data["code"]==0) then
      local code=json_data["code"]
      local msg=json_data["msg"]
      callback(true,msg)
     else
      local msg=json_data["msg"]
      callback(false,msg)
    end
  end)
end

function callback_handler(code,content,cookies)

end

function emblog_send_email_code(email,callback)
  okhttp_request(get_account_url("send_email_code"),{postbody="mail="..email},function(code,content,cookies)
    local status,json_data=JsonUtil.parseJson(content)
    if (status and json_data["code"]==0) then
      local code=json_data["code"]
      local msg=json_data["msg"]
      callback(true,msg,cookies)
     else
      local msg=json_data["msg"]
      callback(false,msg,cookies)
    end
  end)
end

function get_article_list(sort_id,callback)
  okhttp_request(get_query_url("article_list").."&sort_id="..sort_id,{},function(code,content)
    local status,json_data=JsonUtil.parseJson(content)
    if (status and json_data["code"]==0) then
      local code=json_data["code"]
      local msg=json_data["msg"]
      local data=json_data["data"]
      local articles=data["articles"]
      callback(true,msg,data,articles)
     else
      local msg=json_data["msg"]
      callback(false,msg)
    end
  end)
end


--[[get_article_list(function(status,msg,data,articles)
if status then
print(dump(articles))
else
system_print("获取文章失败")  
end
end)]]

--[[
Http.get("https://www.lqsxm666.top/?rest-api=article_detail&id=6",function(code,content)
      local status,json_data=JsonUtil.parseJson(content)
print(dump(json_data))
end)]]


--[[Http.get("https://www.lqsxm666.top/?rest-api=article_detail&id=6",function(code,content)
  local status,json_data=JsonUtil.parseJson(content)
  content=json_data["data"]["article"]["content"]
  io.open(activity.getLuaDir().."/cache.html","w"):write(content):close()
  loadLocalUrl(webView,"cache.html")
end)]]

function post_article(title,content,cookies,other_data,callback)
  local excerpt=((other_data and other_data["excerpt"]) or "")
  local cover=((other_data and other_data["cover"]) or "")
  local sort_id=((other_data and other_data["sort_id"]) or "")
  local tags=((other_data and other_data["tags"]) or "")
  local draft=((other_data and other_data["draft"]) or "")
  local postbody=[[title=%s&content=%s&excerpt=%s&cover=%s&sort_id=%s&tags=%s&draft=%s]]
  local postbody=string.format(postbody,title,content,excerpt,cover,sort_id,tags,draft)
  okhttp_request(get_query_url("article_post"),{postbody=postbody,cookies=cookies},function(code,content)
    local status,json_data=JsonUtil.parseJson(content)
    if (status and json_data["code"]==0) then
      local code=json_data["code"]
      local msg=json_data["msg"]
      local data=json_data["data"]
      local article_id=data["article_id"]
      callback(true,msg,data,article_id)
     else
      local msg=json_data["msg"]
      callback(false,msg)
    end
  end)
end


function get_saved_user_info()
  if activity.getSharedData("account_info") then
    local user_info_json=activity.getSharedData("account_info")
    local status,json_data=JsonUtil.parseJson(user_info_json)
    return status,json_data
   else
    return false
  end
end

--[[local status,user_info=get_saved_user_info()
cookies=user_info["cookies"]]

--[[post_article("title","content",cookies,nil,function(status,msg,data,article_id)
print(status,msg,data,article_id)
end)]]

--[[post_article("title","content",cookies,{sort_id="1"},function(status,msg,data,article_id)
  print(status,msg,data,article_id)
end)]]