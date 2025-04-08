local JsonUtil = require("JsonUtil")

--保存账号密码
function save_account(username,password,status)
  activity.setSharedData("login_username",username)
  activity.setSharedData("login_password",password)
  if (!status) then
    activity.setSharedData("auto_login",false)
   else
    activity.setSharedData("auto_login",true)
  end
end

--保存用户信息
function save_user_info(cookies,user_info)
  local info_table={}
  info_table["user_info"]=user_info
  info_table["cookies"]=cookies
  local cjson=require("cjson")
  local account_info_json=cjson.encode(info_table)
  activity.setSharedData("account_info",account_info_json)
end

--清除历史信息数据
function clear_history_user_info()
  activity.setSharedData("account_info",nil)
end

function update_member_info(user_info)
  local uid=user_info["uid"]
  local nickname=user_info["nickname"]
  local role=user_info["role"]
  local avatar=((user_info["avatar"]~="" and user_info["avatar"]) or activity.getLuaDir().."/system/defalut_header.png")
  local email=user_info["email"]
  local description=user_info["description"]
  local ip=user_info["ip"]
  local create_time=user_info["create_time"]
  activity.setSharedData("my_account_header",avatar)

  info_nickname_tv.setText(nickname)
  info_email_tv.setText(email)
  info_uid_tv.setText(tostring(int(uid)))
  info_role_tv.setText(tostring(role))
  info_desc_tv.setText(tostring(description))
  info_ip_tv.setText(ip)
  info_create_time_tv.setText(os.date("%Y-%m-%d %H:%M:%S",create_time))
  local avatar=((avatar~="" and avatar) or activity.getLuaDir().."/system/defalut_header.png")
  setImage(header_img,avatar)
  setImage(home_header_img,avatar)
  nickname_text.setText(nickname)
  login_panel.setVisibility(8)
  account_info_panel.setVisibility(0)
end

--登录
function login(user,pass,code,cookies,refresh)
  emblog_login(user,pass,code,cookies,function(status,msg,user_info,cookies)
    if login_dialog then
      login_dialog.dismiss()
    end
    if status then
      local nickname=user_info["nickname"]
      save_account(user,pass)
      if refresh then
        system_print(gets("login_successfully_tip").."\t"..gets("welcome_tips")..nickname.."!")
       else
        system_print(gets("refresh_login_status_successfully_tips"))
      end
      update_member_info(user_info)
      save_user_info(cookies,user_info)
     else
      clear_history_user_info()
      save_account(user,"",false)
      system_print(gets("login_unsuccessfully_tip").."\t"..(msg or "null"))
    end
  end)
end

--注销登录
function logout()
  login_panel.setVisibility(0)
  account_info_panel.setVisibility(8)
  activity.setSharedData("auto_login",false)
end

function send_mail_code(email)
  send_mail_button.setEnabled(false)
  emblog_send_email_code(email,function(status,content,cookies)
    if status then
      send_mail_code_cookies=cookies
      system_print("send_code_successfully_tips")
      send_mail_button.setEnabled(false)
      send_mail_button_tv.setText(gets("resend_code_text").."(30)")
      send_code_time=30
      send_code_ticker=Ticker()
      send_code_ticker.Period=1000
      send_code_ticker.onTick=function()
        send_code_time=send_code_time-1
        send_mail_button_tv.setText(gets("resend_code_text").."("..tostring(send_code_time)..")")
        if send_code_time==0 then
          send_code_ticker.stop()
          send_mail_button.setEnabled(true)
          send_mail_button_tv.setText(gets("resend_code_text"))
        end
      end
      send_code_ticker.start()
     else
      send_mail_button.setEnabled(true)
      system_print(gets("send_code_successfully_tips").."\t"..content)
    end
  end)
end