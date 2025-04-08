local cjson_m=require("cjson")
local JsonUtil={}
JsonUtil.parseJson=function(content)
  local status,str=pcall(function()return cjson_m.decode(content)end)
  return status,str
end
return JsonUtil