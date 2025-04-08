function load_system_incidents()
  system_incident={}
  system_incident["finish"]=function()
    activity.finish()
  end
  --控件文本复制
  system_incident.view_copy=function(a)
    pcall(copy_text,a.Text)
    system_print(gets("copy_tip"))
  end
end