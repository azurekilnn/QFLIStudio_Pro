-- webdav/object.lua

local _=1
while true
  _=_+1
  local e=debug.getinfo(_)
  if e
    local k,v=debug.getupvalue(e.func,1)
    if k=="_ENV" and v
      debug.setupvalue(debug.getinfo(1).func,1,v)
      break
    end
  end
end

local name,block

function static(tab)
  tab.__type="static"
  return tab
end

function public(tab)
  tab.__type="public"
  return tab
end

function meta(tab)
  tab.__type="meta"
  return tab
end



class={extends=extends}
setmetatable(class,class)
function class:__call(val)
  super=nil
  if type(val)=="string"
    name=val
    return block
   else
    name=nil
    return block(val)
  end
end

function block(tab)
  when !tab.__init tab.__init=lambda:;
  local cla={_M={}}
  local obj={_M={}}
  setmetatable(cla,cla._M).self=cla
  local cla_env=setmetatable({self=cla},{__index=_ENV})

  for k,v ipairs(tab)--static
    if v.__type=="static"
      for k1,v1 pairs(v)
        when k1=="__type" continue

        if k1=="__init"

          cla._M.__call=function(self,...)

            local obj=table.clone(obj)
            obj.class=cla
            setmetatable(obj,obj._M).self=obj
            local obj_env=setmetatable({self=obj},{__index=_ENV})

            for k2,v2 pairs(obj)
              when type(v2)~="function" continue
              v2=load(string.dump(v2),nil,nil,obj_env)
              obj[k2]=v2
            end
            for k2,v2 pairs(obj._M)
              when type(v2)~="function" continue
              v2=load(string.dump(v2),nil,nil,obj_env)
              obj._M[k2]=lambda _,...:v2(...)
            end

            v1=load(string.dump(v1),nil,nil,obj_env)
            return v1(...) or obj
          end

          continue
        end

        if type(v1)=="table"--meta
          if v1.__type=="meta"
            for k2,v2 pairs(v1)
              when k2=="__type" continue
              if type(v2)=="function"
                v2=load(string.dump(v2),nil,nil,cla_env)
                cla._M[k2]=lambda _,...:v2(...)
               else
                cla._M[k2]=v2
              end
            end
          end
        end
        when type(v1)=="function" v1=load(string.dump(v1),nil,nil,cla_env)
        cla[k1]=v1
      end

     else

      for k1,v1 pairs(v)
        when k1=="__type" continue
        if type(v1)=="table"--meta
          if v1.__type=="meta"
            for k2,v2 pairs(v1)
              when k2=="__type" continue
              obj._M[k2]=v2
            end
          end
        end
        obj[k1]=v1
      end
    end
  end

  when name _ENV[name]=cla
  return cla
end