set_style()
setCommonView("layout.MyRecyclerViewLayout","open_license_text","back_mode")
import "licenses"
license_rv_adapter_data={}
license_rv_item=import "layout.layout_items.layout_common_rv_item"
license_rv_adapter=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #license_rv_adapter_data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    local view=loadlayout(license_rv_item,views)
    local holder=LuaRecyclerHolder(view)
    view.setTag(views)
    views.cardViewChild.setBackground(Ripple(nil,0x22000000))
    views.cardViewChild.onClick=function()
      local data=views["tag_data"]
      local url=data["url"]
      if url then
        open_url(url)
      end
    end
    return holder
  end,
  onBindViewHolder=function(holder,position)
    local views=holder.view.getTag()
    local data=license_rv_adapter_data[position+1]
    views["tag_data"]=data
    views["tag_data"]["position"]=position+1

    local name=data["name"]
    local message=data["message"]
    local licenseName=data["licenseName"]

    views.title.setText(name)
    views.sub_title.setText(message)
    views.message.setText(licenseName)
  end,
}))
recyclerView.setAdapter(license_rv_adapter)
layoutManager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
recyclerView.setLayoutManager(layoutManager)

for index,content in ipairs(licenses) do
  table.insert(license_rv_adapter_data,content)
end
license_rv_adapter.notifyDataSetChanged()