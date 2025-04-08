-- webdav/init.lua
module("webdav",package.seeall)
require "system.webdav.object"
import "com.paul623.wdsyncer.*"
import "com.paul623.wdsyncer.api.*"

class "Info" {
  static {
    MODULE_NAME="WebDav",
    MODULE_VERSION="2.0"
  }
}

class "WebDav" {
  static {
    meta {
      __tostring=function(...)
        return "class "..string.format("%p",self)
      end
    },
    __init=function(server,user,pass)
      self.server=server or 'https://dav.jianguoyun.com/dav/'
      self.user=user or ''
      self.pass=pass or ''
      config=SyncConfig(this)
      manager=SyncManager(this)
    end
  },
  public {
    meta {
      __tostring=function(...)
        return "class "..string.format("%p",self.class).." @object "..string.format("%p",self)
      end
    },

    upload=function(path,data,callback)
      self.reset()
      local p,f=path:match('^(.+)/([^/]+)$')
      if type(data)=="string"
        self.execute("uploadString",{f,p,data},callback)
       else
        self.execute("uploadFile",{f,p,data},callback)
      end
      return self
    end,
    download=function(path,is,callback)
      self.reset()
      if !callback
        callback=is
        is=false
      end
      local p,f=path:match('^(.+)/([^/]+)$')
      if is
        self.execute("downloadFile",{f,p},callback)
       else
        self.execute("downloadString",{f,p},callback)
      end
      return self
    end,
    delete=function(path,callback)
      self.reset()
      self.execute("deleteFile",{path},callback)
      return self
    end,
    list=function(path,callback)
      self.reset()
      if !callback
        callback=path
        path=""
      end
      self.execute("listAllFile",{path},callback)
      return self
    end,
    setServer=function(url)
      self.server=url
      return self
    end,
    setUser=function(str)
      self.user=str
      return self
    end,
    setPass=function(str)
      self.pass=str
      return self
    end,
    getManager=function()
      return manager
    end,
    getServer=function()
      return self.server
    end,
    getUser=function()
      return self.user
    end,
    getPass=function()
      return self.pass
    end,
    reset=function()
      config
      .setServerUrl(self.server)
      .setUserAccount(self.user)
      .setPassWord(self.pass)
      return self
    end,
    execute=function(m,d,callback)
      local a,b
      if m=="listAllFile"
        a=OnListFileListener
        b="listAll"
        local f=callback
        callback=function(code,data,...)
          if code==200
            local tab={}
            for i=0,#data-1
              local v,t=data[i]
              if v.getCreation()
                t=v.getCreation().getTime()/1000
              end

              tab[i+1]={
                state=v.getStatusCode(),
                createTime=t,
                modifyTime=tointeger(v.getModified().getTime()/1000),
                type=v.getContentType(),
                length=v.getContentLength(),
                tag=v.getEtag(),
                name=v.getDisplayName(),
                isDir=v.isDirectory(),
                path=v.getPath():sub(6,-1)
              }

              luajava.clear(v)
            end
            f(code,tab,...)
           else
            f(code,data,...)
          end
        end
       else
        a=OnSyncResultListener
        b="onSuccess"
      end

      d[#d+1]=a{
        [b]=function(data,...)
          local args={...}
          if this==activity
            this.runOnUiThread(function()
              callback(200,data,table.unpack(args))
            end)
           else
            callback(200,data,table.unpack(args))
          end
        end,
        onError=function(data,...)
          local args={...}
          if this==activity
            this.runOnUiThread(function()
              callback(-1,data,table.unpack(args))
            end)
           else
            callback(-1,data,table.unpack(args))
          end
        end
      }
      manager[m](table.unpack(d))
    end
  }
}

_G.WebDav=WebDav
return WebDav