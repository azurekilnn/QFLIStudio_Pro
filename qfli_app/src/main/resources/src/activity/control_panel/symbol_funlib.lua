--保存符号数据
function save_symbol_data()
  if editor_data then
    editor_data["new_symbol_content"]=symbol_data
    write_file(extconfig_path,"config="..dump(config))
   else
    system_print(gets("save_failed_tips"))
  end
end


function create_add_symbol_dlg()
  import "system.system_dialogs"
  local layout_add_symbol_dlg = import "layout.layout_dialogs.layout_add_symbol_dialog"
  local add_symbol_dlg = BottomSheetDialog(activity,R.style.BottomSheetDialogTheme)
  add_symbol_dlg.setContentView(loadlayout(layout_add_symbol_dlg))

  dialog_corner(layout_add_symbol_dlg_background,pc(get_theme_color("background_color")),radiu)
  widget_radius(add_symbol_dlg_ok_button,basic_color_num,radiu)

  add_symbol_dlg_edittext_helpertext_1.setVisibility(8)
  return add_symbol_dlg
end

--显示新建添加符号对话框
function show_add_symbol_dlg(index)
  if add_symbol_dlg then
   else
    add_symbol_dlg=create_add_symbol_dlg()
  end
  add_symbol_dlg_ok_button.onClick=function()
    if add_symbol_dlg_edittext.text~="" then
      local new_symbol=add_symbol_dlg_edittext.text
      if (index and symbol_data[index]) then
        change_symbol_rv_adp_data[index]["symbol"]=new_symbol
        symbol_data[index]=new_symbol
       else
        table.insert(symbol_data,new_symbol)
        table.insert(change_symbol_rv_adp_data,{symbol=new_symbol})
      end
      change_symbol_rv_adp.notifyDataSetChanged()
      add_symbol_dlg.dismiss()
      save_symbol_data()
    end
  end
  add_symbol_dlg.show()
  add_symbol_dlg_edittext.setText(symbol_data[index] or "")
end

function init_symbol_rv_adapter()
  rv_item={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="-2";
    {
      LinearLayoutCompat;
      layout_width="fill";
      layout_height="fill";
      orientation="vertical";
      layoutTransition=newLayoutTransition();
      {
        MaterialCardView;
        layout_margin="8dp";
        layout_width="-1";
        layout_height="wrap";
        CardBackgroundColor=get_theme_color("background_color");
        id="itemParent";
        {
          LinearLayoutCompat;
          layout_width="fill";
          layout_height="fill";
          orientation="vertical";
          layoutTransition=newLayoutTransition();
          {
            LinearLayoutCompat;
            layout_width="-1";
            layout_height="-1";
            padding="8dp";
            id="item";
            gravity="center",
            layoutTransition=newLayoutTransition();
            {
              AppCompatTextView,
              id="symbol_tv",
              gravity="center",
            };
          };
        };
      };

    };
  };
  local data={}
  local adapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount = function()
      return #data
    end,
    getItemViewType = function(position) return 0 end,
    onCreateViewHolder = function(parent,viewType)
      local views={}
      local holder_view=loadlayout(rv_item,views)
      local holder=LuaRecyclerHolder(holder_view)
      holder_view.setTag(views)

      views.item.onClick=function()
        local tag_data=views["tag_data"]
        local position=tag_data["position"]
        show_add_symbol_dlg(position)
      end

      return holder
    end,
    onBindViewHolder = function(holder,position)
      local views=holder.view.getTag()
      local tag_data=data[position+1]
      local symbol=tag_data["symbol"]
      views["tag_data"]=tag_data
      views["tag_data"]["position"]=position+1
      views.symbol_tv.setText(symbol)
      system_ripple({views.item},"circular_theme")
      return holder
    end,
  }))
  return adapter,data
end

function table_move(data,from_position,to_position)
  local origin_data=data[from_position]
  table.remove(data,from_position)
  table.insert(data,to_position,origin_data)
end

function load_symbols_data(symbol_data)
  for index,content in ipairs(symbol_data) do
    table.insert(change_symbol_rv_adp_data,{symbol=content})
  end
  change_symbol_rv_adp.notifyDataSetChanged()
end