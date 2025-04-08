
--Account_System--
--保存账号密码
function save_account(username,password)
  activity.setSharedData("login_username",username)
  activity.setSharedData("login_password",password)
end

--保存用户信息
function save_user_info(objectId,token)
  local info_table={}
  info_table["objectId"]=objectId
  info_table["sessionToken"]=token

  write_file(login_info_filesrc,dump(info_table))
  activity.setSharedData("login_objectId",objectId)
  activity.setSharedData("login_token",token)
end

--清除用户数据
function clear_user_info()
  LuaUtil.rmDir(File(login_info_filesrc))
  activity.setSharedData("login_objectId",nil)
  activity.setSharedData("login_token",nil)
end

--检验账号是否激活
function verify_account(database_key,objectId,callback)
  database_key:query("_User",objectId,function(code,json)
    local taccount_status=json["account_status"]
    if taccount_status=="" or taccount_status=="activated" then
      callback(true)
      --return true
     else
      callback(false)
      --return false
    end
  end)
end


--[[注册用户
function register_account(database_key,user_name,password,email,phonenum)
  --将其他数据存入 account_info 表内
  function create_info_table(username,password,objectId)
    local this_device_imei=activity.getSystemService(Context.TELEPHONY_SERVICE).getDeviceId()
    import "android.provider.Settings$Secure"
    local this_device_id = Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID)

    local account_info_table={}
    --account_info_table["account_status"]="activated" --账号状态
    account_info_table["user_name"]=username --用户名
    account_info_table["nick_name"]=tostring("user_"..os.time()) --昵称
    account_info_table["password"]=password --密码
    account_info_table["user_type"]="Common" --用户类型
    account_info_table["v_expiration_time"]="not_opened" --VIP到期时间
    --account_info_table.email=email --邮箱
    --account_info_table.mobilePhoneNumber=phonenum --手机号
    account_info_table["birthday"]="" --生日
    account_info_table["age"]="" --年龄
    account_info_table["head_image"]="defalut" --头像
    account_info_table["integral"]="100" --积分
    --account_info_table.check_in="" --登记
    account_info_table["sex"]=gets("sex_defalut_text") --性别
    --account_info_table.sexual_o="" --性取向
    account_info_table["signed_time"]=tostring(os.date("%Y")) --签到时间
    account_info_table["device_imei"]=this_device_imei --设备IMEI
    account_info_table["device_id"]=this_device_id --设备ID
    account_info_table["per_introduction"]=gets("per_introduction_text") --个人信息
    --account_info_table.reg_time=reg_time --注册时间
    account_info_table["user_objectId"]=objectId --_User数据表标识码
    return account_info_table
  end

  function read_code(json)
    if (json["error"]:find("Bad Request")) then
      system_print(gets("bad_request_tip").."\t"..dump(json))
    elseif json["code"]==202 then
      system_print(gets("username_already_tip").."\t"..dump(json))
    elseif json["code"]==203 then
      system_print(gets("email_already_tip").."\t"..dump(json))
    elseif json["code"]==204 then
      system_print(gets("email_invalid_tip").."\t"..dump(json))
    elseif json["code"]==205 then
      system_print(gets("email_or_username_does_not_exist_tip").."\t"..dump(json))
    elseif json["code"]==206 then
      system_print(gets("login_status_has_expired").."\t"..dump(json))
    elseif json["code"]==209 then
      system_print(gets("pn_already_tip").."\t"..dump(json))
    elseif json["code"]==301 then
      system_print(gets("incomplete_info_tip").."\t"..dump(json))
    else
      system_print(dump(json))
    end
  end

  --检查注册状态
  function check_sign_status(json)
    if json["objectId"] and json["sessionToken"] then
      return true
    elseif json["error"] then
      read_code(json)
      return false
    end
  end

  if user_name and password and email and phonenum then
    local tsuser_name=tostring(user_name)
    local tspassword=tostring(password)
    local tsemail=tostring(email)
    local reg_time=os.date("%Y-%m-%d %H:%M:%S")

    database_key:sign2(user_name,password,email,phonenum,function(code,json) 
      if check_sign_status(json) then

        database_key:login(user_name,password,function(code2,json2)
          if json2["objectId"] and json2["sessionToken"] then

            local register_obid=json2["objectId"]
            local register_sessionToken=json2["sessionToken"]

            local user_info_table={}
            user_info_table["account_status"]="activated" 
            --user_info_table["mobilePhoneNumber"]=phonenum 

            database_key:update("_User",register_obid,user_info_table,function(code3,json3) 
              if json3["updatedAt"] then
                local account_info_table=create_info_table(user_name,password,register_obid)
                database_key:insert("account_info",account_info_table,function(code,json) 
                  if json["createdAt"] then
                    system_print(gets("register_successfully_tip"))
                    save_user_info(register_obid,register_sessionToken) 
                    save_account(user_name,password)

                    register_panel.setVisibility(8)
                    account_info_panel.setVisibility(8)
                    login_panel.setVisibility(0) 

                    login_username_edittext.setText(user_name)
                    login_password_edittext.setText(password)

                  else
                    system_print(gets("register_unsuccessfully_tip"))
                  end 
                end)
              end 
            end)
          end
        end)
      end
    end)
  else
    system_print(gets("check_input_info_tip"))
    return false
  end
end]]

--将其他数据存入 account_info 表内
function create_userinfo_table(username,password,objectId)
  local this_device_imei=activity.getSystemService(Context.TELEPHONY_SERVICE).getDeviceId()
  import "android.provider.Settings$Secure"
  local this_device_id = Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID)

  local account_info_table={}
  --account_info_table["account_status"]="activated" --账号状态
  account_info_table["user_name"]=username --用户名
  account_info_table["nick_name"]=tostring("user_"..os.time()) --昵称
  account_info_table["password"]=password --密码
  account_info_table["user_type"]="Common" --用户类型
  account_info_table["v_expiration_time"]="not_opened" --VIP到期时间
  --account_info_table.email=email --邮箱
  --account_info_table.mobilePhoneNumber=phonenum --手机号
  account_info_table["birthday"]="" --生日
  account_info_table["age"]="" --年龄
  account_info_table["head_image"]="defalut" --头像
  account_info_table["integral"]="100" --积分
  --account_info_table.check_in="" --登记
  account_info_table["sex"]=gets("sex_defalut_text") --性别
  --account_info_table.sexual_o="" --性取向
  account_info_table["signed_time"]=tostring(os.date("%Y")) --签到时间
  account_info_table["device_imei"]=this_device_imei --设备IMEI
  account_info_table["device_id"]=this_device_id --设备ID
  account_info_table["per_introduction"]=gets("per_introduction_text") --个人信息
  --account_info_table.reg_time=reg_time --注册时间
  account_info_table["user_objectId"]=objectId --_User数据表标识码
  return account_info_table
end


--注册用户
function register_account(database_key,user_name,password,email,phonenum)

  function read_code(json)
    if (json["error"]:find("Bad Request")) then
      system_print(gets("bad_request_tip").."\t"..dump(json))
     elseif json["code"]==202 then
      system_print(gets("username_already_tip").."\t"..dump(json))
     elseif json["code"]==203 then
      system_print(gets("email_already_tip").."\t"..dump(json))
     elseif json["code"]==204 then
      system_print(gets("email_invalid_tip").."\t"..dump(json))
     elseif json["code"]==205 then
      system_print(gets("email_or_username_does_not_exist_tip").."\t"..dump(json))
     elseif json["code"]==206 then
      system_print(gets("login_status_has_expired").."\t"..dump(json))
     elseif json["code"]==209 then
      system_print(gets("pn_already_tip").."\t"..dump(json))
     elseif json["code"]==301 then
      system_print(gets("incomplete_info_tip").."\t"..dump(json))
     else
      system_print(dump(json))
    end
  end

  --检查注册状态
  function check_sign_status(json)
    if json["objectId"] and json["sessionToken"] then
      return true
     elseif json["error"] then
      read_code(json)
      return false
    end
  end

  if user_name and password and email then
    local tsuser_name=tostring(user_name)
    local tspassword=tostring(password)
    local tsemail=tostring(email)
    local reg_time=os.date("%Y-%m-%d %H:%M:%S")

    database_key:sign2(user_name,password,email,phonenum,function(code,json)
      if check_sign_status(json) then

        database_key:login(user_name,password,function(code2,json2)
          if json2["objectId"] and json2["sessionToken"] then

            local register_obid=json2["objectId"]
            local register_sessionToken=json2["sessionToken"]

            local user_info_table={}
            user_info_table["account_status"]="activated"
            --user_info_table["mobilePhoneNumber"]=phonenum

            database_key:update("_User",register_obid,user_info_table,function(code3,json3)
              if json3["updatedAt"] then
                local account_info_table=create_userinfo_table(user_name,password,register_obid)
                database_key:insert("account_info",account_info_table,function(code,json)
                  if json["createdAt"] then
                    system_print(gets("register_successfully_tip"))
                    save_user_info(register_obid,register_sessionToken)
                    save_account(user_name,password)

                    register_panel.setVisibility(8)
                    account_info_panel.setVisibility(8)
                    login_panel.setVisibility(0)

                    login_username_edittext.setText(user_name)
                    login_password_edittext.setText(password)

                   else
                    system_print(gets("register_unsuccessfully_tip"))
                  end
                end)
              end
            end)
          end
        end)
      end
    end)
   else
    system_print(gets("check_input_info_tip"))
    return false
  end
end

--登录账号
function login_account(database_key,user_name,password)
  if user_name and password then
    local tsuser_name=tostring(user_name)
    local tspassword=tostring(password)

    database_key:login(user_name,password,function(code,json)

      local login_obid=json["objectId"]
      local login_sessionToken=json["sessionToken"]

      verify_account(bmob_key,login_obid,function(status)
        if status then
          save_user_info(login_obid,login_sessionToken)
          if code==200 then
            local info={}
            info.where={}
            info.where.user_name=json["username"]
            database_key:query("account_info",info,function(code2,json2)
              --print(dump(json2))
              local nickname=json2["results"][1]["nick_name"]
              local head_image=json2["results"][1]["head_image"]
              if head_image=="defalut" then
                setImage(header_img,activity.getLuaDir().."/system/defalut_header.png")
                setImage(home_header_img,activity.getLuaDir().."/system/defalut_header.png")
               else
                setImage(header_img,head_image)
                setImage(home_header_img,head_image)
              end
              nickname_text.setText(nickname)

              account_info_panel.setVisibility(0)
              login_panel.setVisibility(8)
              register_panel.setVisibility(8)

              system_print(gets("login_successfully_tip"))
            end)
           else
            system_print(gets("login_unsuccessfully_tip"))
          end
         else
          system_print(gets("login_unsuccessfully_tip"))
        end
      end)
    end)
  end
end

function logout_account()
  activity.setSharedData("auto_login_status",false)
end

function set_edittext(edit_id,hint_id,text)
  edit_id.setText(text)
  edit_id.setFocusable(false);
  edit_id.setFocusableInTouchMode(true);

  hint_id.startAnimation(TranslateAnimation(0,0,0,-dp2px(48/2)).setDuration(100).setFillAfter(true))
  hint_id.setTextColor(parseColor(basic_color))
end

function edittext_set(id)
  id.setFocusable(false);
  id.setFocusableInTouchMode(true);
end
--Account_System END--
--[[login_info_filesrc=activity.getLuaDir().."/system/login_info"
  lg_username=activity.getSharedData("login_username") or nil
  lg_password=activity.getSharedData("login_password") or nil
  if lg_username and lg_password then
    set_edittext(login_username_edittext,login_username_hint,lg_username)
    set_edittext(login_password_edittext,login_password_hint,lg_password)
  end
  --自动登录
  auto_login_status=activity.getSharedData("auto_login_status") or nil
  if auto_login_status then
    edittext_set(login_username_edittext)
    edittext_set(login_password_edittext)
  
    if login_username_edittext.text~="" and login_password_edittext.text~="" then 
      login_account(bmob_key,login_username_edittext.text,login_password_edittext.text)
    end
  end
  ]]

