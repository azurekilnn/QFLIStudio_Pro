set_style()
setCommonView("layout","dex_viewer","back_mode")

classes_rv_adp_data={}
classes_rv_item=import "layout.layout_items.layout_common_rv_item"
classes_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #classes_rv_adp_data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    local view=loadlayout(classes_rv_item,views)
    local holder=LuaRecyclerHolder(view)
    view.setTag(views)
    views.cardViewChild.setBackground(Ripple(nil,0x22000000))
    views.cardViewChild.onClick=function()
      local data=views["tag_data"]
      local name=data["name"]
      if name then
      copy_text(name)
       -- activity.newLSActivity("java_api_sub_browser",{dex_file_path,name})
        --print(name)
      end
    end
    return holder
  end,
  onBindViewHolder=function(holder,position)
    local views=holder.view.getTag()
    local data=classes_rv_adp_data[position+1]
    views["tag_data"]=data
    views["tag_data"]["position"]=position+1

    local name=data["name"]
    views.title.setText(name)
    views.sub_title.setVisibility(8)
    views.message.setVisibility(8)
  end,
}))
dex_viewer_rv.setAdapter(classes_rv_adapter)
layoutManager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
dex_viewer_rv.setLayoutManager(layoutManager)

local DexFile=luajava.bindClass("dalvik.system.DexFile")
local Enumeration=luajava.bindClass("java.util.Enumeration")
dex_file_path=...
if dex_file_path then
local file=File(dex_file_path)
local dexFile=DexFile(dex_file_path)
local classNames=dexFile.entries()
while classNames.hasMoreElements() do
  local className=classNames.nextElement()
  table.insert(classes_rv_adp_data,{name=className})
end
dexFile.close()
local file_name=file["name"]
local classes_num=#classes_rv_adp_data
local all_classes_num_template="共%s个类" or gets("all_classes_num_text")
local classes_num_text=string.format(all_classes_num_template,tostring(classes_num))
dex_viewer_tv.setText(file_name.."("..classes_num_text..")")
end