local cjson = require("cjson")
import "md5"

baidu_api="https://fanyi-api.baidu.com/api/trans/vip/translate"

appid=""
key=""

function translate(content,from,to)
  local from=(form or "auto")
  local salt=(tostring(os.time()))

  local sign=(appid..content..salt..key)
  local sign_md5=string.md5(sign)
  local sign_md5_low=utf8.lower(sign_md5)

  import "java.net.URLEncoder"
  local encode_text=URLEncoder.encode(string.upper(content),"UTF8")

  Http.post(baidu_api,{q=encode_text,from=from,to=to,appid=appid,salt=salt,sign=sign_md5_low},function(code,content)
    local content=cjson.decode(content)
    print(dump(content))
  end)

end


