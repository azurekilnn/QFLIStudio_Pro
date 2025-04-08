import "java.util.concurrent.Executors"
import "java.util.concurrent.ScheduledExecutorService"
import "java.util.concurrent.TimeUnit"

local ThreadPoolExecutor = luajava.bindClass("java.util.concurrent.ThreadPoolExecutor")
local executor = Executors.newScheduledThreadPool(3) -- 创建一个包含3个线程的线程池

executor.schedule(Runnable{
  run=function()
    local errorBuffer=build_pro(info)
    if errorBuffer then
      build.updateContent(gets("build_failed_tips").."\n " ..errorBuffer.toString().."\n ")
    end
  end
}, 50, TimeUnit.MILLISECONDS);