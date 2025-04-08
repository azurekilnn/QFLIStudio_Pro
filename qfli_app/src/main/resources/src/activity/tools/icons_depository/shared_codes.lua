function load_shared_codes()
  proj_path=value
  save_icons_path=activity.getAppExtDir().."/icons"
  save_png_path=activity.getAppExtDir().."/icons/png"
  save_svg_path=activity.getAppExtDir().."/icons/svg"
  File(save_icons_path).mkdirs()
  File(save_png_path).mkdirs()
  File(save_svg_path).mkdirs()

  import "com.caverock.androidsvg.SVGImageView"
  import "com.caverock.androidsvg.SVG"
  --阿里巴巴矢量图标库
  iconfont_api="https://www.iconfont.cn/api/icon/search.json"
  iconfont_api_header={["Cookie"]="ctoken=sh6GKQur-48KjRv0-IDssPrQ"}

  function search_iconfont(key)
    svg_table={}
    --初始化该关键词最大页
    MaxPage=0
    --初始化该关键词第一页
    iconfont_page=1
    --清除适配器,清除GridView所有子项目
    --初始化SVG对象数组
    SvgObjTable={}
    --阿里图标库API地址
    --post传入数据
    local iconfont_api_data="q="..key.."&sortType=updated_at&page=1&pageSize=0&fromCollection=1&fills=null&ctoken=sh6GKQur-48KjRv0-IDssPrQ"

    --异步加载:目的获得图标最大数量
    Http.post(iconfont_api,iconfont_api_data,nil,"utf8",iconfont_api_header,function(code,content,cookie,header)

      local json=cjson.decode(content)
      if json["data"] then
        --SVG图标最大数量
        SvgMaxCount=json["data"]["count"]
        --当图标数量不为0时
        if SvgMaxCount ~= 0 then
          --SVG图标最大数量取整数
          SvgMaxCount,SvgMaxCountXS=math.modf(SvgMaxCount)
          --删除获得的小数变量
          SvgMaxCountXS=nil
          --找到该图标的最大页数
          MaxPage=math.ceil(SvgMaxCount/54)
          get_iconfont(key,iconfont_page)
         else
          --控件配置
          progress_bar_1.setVisibility(8)
          pull_layout_1.loadmoreFinish(0)
        end
      end
    end)
  end

  function get_iconfont(key,n)
    data="q="..key.."&sortType=updated_at&page="..n.."&pageSize=54&fromCollection=1&fills=null&ctoken=sh6GKQur-48KjRv0-IDssPrQ"
    --开启异步加载
    Http.post(iconfont_api,data,cookie,"utf8",iconfont_api_header,function(code,content,cookie,header)
      cjson=import "cjson"
      json=cjson.decode(content)
      --45个或者更少
      SvgCount=#(json["data"]["icons"])
      --解析Json数据,将数据存入table内
      for i=1,SvgCount do
        SvgJsonStr=json["data"]["icons"][i]["show_svg"]
        SvgJsonName=json["data"]["icons"][i]["name"]
        table.insert(svg_table,{name=SvgJsonName,svg_content=SvgJsonStr,svg_dark_content=SvgJsonStr})

        SvgJsonStr=SVG.getFromString(tostring(SvgJsonStr))
        table.insert(SvgObjTable,SvgJsonStr)
      end

      cc=54*(iconfont_page-1)+1
      for i=cc,#SvgObjTable do
        --给GridView添加内容
        grid_adp1.add({item_svg={SVG=SvgObjTable[i]},item_tv=svg_table[i]["name"]})
        --最后一个加载完成,停止加载动画,停止上拉刷新
        if i==(#SvgObjTable) then
          progress_bar_1.setVisibility(8)
          pull_layout_1.loadmoreFinish(0)
        end
      end
      iconfont_page=iconfont_page+1
    end)
  end

  cjson=import "cjson"
  empty_tip_background.setVisibility(8)
  setImage(search_bar_cancel_button_img,load_icon_path("close"))

  local_icons_depository_zip=activity_dir.."/icons.zip"
  local_icons_depository_dir=activity_dir.."/icons"

  grid_item={
    LinearLayoutCompat;
    orientation="vertical",
    layout_height="30%w",
    layout_width="25%w",
    Gravity="center",
    {
      SVGImageView,
      layout_height="20%w",
      layout_width="25%w",
      padding="5%w",
      id="item_svg",
    },
    {
      AppCompatTextView,
      layout_width="25%w",
      singleLine="true",
      ellipsize="end",
      textColor=text_color,
      Gravity="center",
      id="item_tv",
    }
  }
  grid_adp1_data={}
  grid_adp1=LuaAdapter(activity,grid_adp1_data,grid_item)
  gridview_1.setAdapter(grid_adp1)

  iconfont_page=1


  pull_layout_1.onLoadMore=function(v)
    task(10,function()
      if iconfont_page==nil || MaxPage==nil then
        --提示("请发起搜索")
        pull_layout_1.loadmoreFinish(0)
       else
        --网络状态
        NetworkStatus=activity.getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE).getActiveNetworkInfo();
        if NetworkStatus==nil then
          system_print(gets("cannot_connect_tip"))
          pull_layout_1.loadmoreFinish(0)
         else
          if iconfont_page>MaxPage then
            --提示("图标全部加载完毕")
            pull_layout_1.loadmoreFinish(0)
           else
            --如果还有多余图标继续加载图标
            get_iconfont(search_content,iconfont_page)
          end
        end
      end
    end)
  end

  function add_chip(text,tag,chipgroup,status)
    local chip={
      Chip;
      text=text;
      tag=tag;
      checkable=true;
    }
    local chip=loadlayout(chip)
    if status then
      chip.setChecked(true)
    end
    chipgroup.addView(chip)
    return chip
  end
  onlineSearch=false

  add_chip("Twotone","twotone",chipgroup_1,true)
  add_chip("Material","material",chipgroup_1)
  add_chip("Flat","flat",chipgroup_1)
  add_chip("IconFont - 阿里巴巴图标矢量库","iconfont",chipgroup_1)

  search_bar_edit.setHint(gets("search_tip"))

  search_bar_search_button.onClick=function()
    progress_bar_1.setVisibility(0)
    empty_tip_background.setVisibility(8)
    table.clear(grid_adp1_data)
    grid_adp1.notifyDataSetChanged()

    search_content=search_bar_edit.text
    if onlineSearch then
      if search_content~="" then
        pull_layout_1.PullUpEnabled=true
        --控件配置
        progress_bar_1.setVisibility(0)
        empty_tip_background.setVisibility(8)
        grid_adp1.clear()
        search_iconfont(search_content)
       else
        progress_bar_1.setVisibility(8)
        empty_tip_background.setVisibility(0)
      end
     else
      search_local_icons(search_content)
    end
  end

  pull_layout_1.PullUpEnabled=false

  local_icons_depository_table={}
  local_icons_depository_table["twotone"]=local_icons_depository_dir.."/twotone"
  local_icons_depository_table["material"]=local_icons_depository_dir.."/material"
  local_icons_depository_table["flat"]=local_icons_depository_dir.."/flat"

  chipgroup_1.setOnCheckedChangeListener{
    onCheckedChanged=function(chipGroup, selectedId)
      --print(selectedId)
      if selectedId==-1 and selectedId then
        table.clear(grid_adp1_data)
        grid_adp1.notifyDataSetChanged()
        --print(dump(adp_data))
        return
       else
        local chip=chipGroup.findViewById(selectedId)
        if chip then
          local tag_cong=chip.tag
          SelectedDepository=tag_cong
          if local_icons_depository_table[SelectedDepository] then
            progress_bar_1.setVisibility(0)
            empty_tip_background.setVisibility(8)
            task(10,function()
              table.clear(grid_adp1_data)
              grid_adp1.notifyDataSetChanged()
              local path=local_icons_depository_table[SelectedDepository]
              if File(path).exists() then
                load_local_icons_depository(path)
               else
                load_local_icons_depository2(tostring(SelectedDepository))
              end
              if (search_bar_id.getVisibility())==0 then
                local search_content=search_bar_edit.text
                search_local_icons(search_content)
              end
            end)
            onlineSearch=false
            pull_layout_1.PullUpEnabled=onlineSearch
           else
            table.clear(grid_adp1_data)
            grid_adp1.notifyDataSetChanged()
            empty_tip_background.setVisibility(0)

            local search_content=search_bar_edit.text
            if search_content~="" then
              pull_layout_1.PullUpEnabled=true
              --控件配置
              progress_bar_1.setVisibility(0)
              empty_tip_background.setVisibility(8)
              search_iconfont(search_content)
              grid_adp1.clear()
             else
              progress_bar_1.setVisibility(8)
              empty_tip_background.setVisibility(0)
            end

            onlineSearch=true
            pull_layout_1.PullUpEnabled=onlineSearch
          end
          return
        end
      end
    end
  }

  function search_local_icons(search_key)
    table.clear(grid_adp1_data)
    grid_adp1.notifyDataSetChanged()
    --print(#svg_table)
    for i=1,#svg_table do
      local svg_name=svg_table[i]["name"]
      local svg_namelow=ul(svg_name)
      local search_key=ul(search_key)
      if i==(#svg_table) then
        progress_bar_1.setVisibility(8)
      end
      if svg_namelow:find(search_key) then
        local svg_object_show=SVG.getFromString(svg_table[i]["svg_dark_content"])
        --给GridView添加内容
        grid_adp1.add({item_svg={SVG=svg_object_show},item_tv=svg_name})
      end
    end
  end

  function load_local_icons_depository(path)
    pull_layout_1.PullUpEnabled=false

    svg_table={}
    local f_dir=File(path)
    local_table_path=local_icons_depository_dir.."/"..f_dir.name..".table"

    if File(local_table_path).exists() then
      pcall(dofile,local_table_path)
      for i=1,#svg_table do
        local svg_object=SVG.getFromString(svg_table[i]["svg_content"])
        local svg_object_show=SVG.getFromString(svg_table[i]["svg_dark_content"])
        --给GridView添加内容
        grid_adp1.add({item_svg={SVG=svg_object_show},item_tv=svg_table[i]["name"]})
        if i==(#svg_table) then
          progress_bar_1.setVisibility(8)
        end
      end
     else
      local ls=File(path).listFiles()
      if ls~=nil then
        ls=luajava.astable(File(path).listFiles()) --全局文件列表变量
        table.sort(ls,function(a,b)
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
        end)
       else
        ls={}
      end
      for index,c in ipairs(ls) do
        if c.isDirectory() then
         else--如果是文件则
          local svg_content=tostring(io.open(c.path):read("*a"))
          local svg_dark_content=tostring(svg_content:gsub(svg_content:match('fill="(.-)"'),text_color))
          table.insert(svg_table,{name=c.name:match("(.+)%."),path=c.path,svg_content=svg_content,svg_dark_content=svg_dark_content})
        end
      end
      for i=1,#svg_table do
        local svg_object=SVG.getFromString(svg_table[i]["svg_content"])
        local svg_object_show=SVG.getFromString(svg_table[i]["svg_dark_content"])
        --给GridView添加内容
        grid_adp1.add({item_svg={SVG=svg_object_show},item_tv=svg_table[i]["name"]})
        if i==(#svg_table) then
          progress_bar_1.setVisibility(8)
        end
      end
      io.open(local_icons_depository_dir.."/"..File(path).name..".table","w"):write("svg_table="..dump(svg_table)):close()
    end
  end

  function load_local_icons_depository2(key)
    pull_layout_1.PullUpEnabled=false
    svg_table={}

    local content=tostring(String(LuaUtil.readZip(local_icons_depository_zip,tostring(key..".table"))))
    if pcall(loadstring(content)) then
      for i=1,#svg_table do
        local svg_object=SVG.getFromString(svg_table[i]["svg_content"])
        local svg_object_show=SVG.getFromString(svg_table[i]["svg_dark_content"])
        --给GridView添加内容
        grid_adp1.add({item_svg={SVG=svg_object_show},item_tv=svg_table[i]["name"]})
        if i==(#svg_table) then
          progress_bar_1.setVisibility(8)
        end
      end
    end

  end

  progress_bar_1.setVisibility(0)

  task(10,function()
    if File(local_icons_depository_dir).exists() then
      load_local_icons_depository(activity.getLuaDir().."/icons/twotone")
     elseif File(local_icons_depository_zip).exists() then
      load_local_icons_depository2("twotone")
      --[[local status=pcall(LuaUtil.unZip(local_icons_depository_dir..".zip",local_icons_depository_dir))
    if status then
      load_local_icons_depository(activity.getLuaDir().."/icons/twotone") 
    end]]
    end
  end)

  function Svg2Png(svg,size,output_path)
    local svg_object=SVG.getFromString(svg)
    mBitmap = Bitmap.createBitmap(tonumber(size),tonumber(size),Bitmap.Config.ARGB_8888);
    mCanvas = Canvas(mBitmap)
    svg_object.renderToCanvas(mCanvas)
    mBitmap.compress(Bitmap.CompressFormat.PNG,100,FileOutputStream(output_path))
    system_print(gets("save_icon_succeed_tips")..output_path)

  end

  function SaveSvg(svg,name)
    if proj_path then
      local output_dialog=MaterialAlertDialogBuilder(activity)
      output_dialog.setTitle(gets("save"))
      output_dialog.setNegativeButton(gets("save_to_project"),function()
        io.open(proj_path.."/"..name..".svg","w"):write(svg):close()
        system_print(gets("save_icon_succeed_tips")..proj_path.."/"..name..".svg")
      end)
      output_dialog.setPositiveButton(gets("save"),function()
        io.open(save_svg_path.."/"..name..".svg","w"):write(svg):close()
        system_print(gets("save_icon_succeed_tips")..save_svg_path.."/"..name..".svg")
      end)
      output_dialog2=output_dialog.show()
      set_dialog_style(output_dialog2)
     else
      io.open(save_svg_path.."/"..name..".svg","w"):write(svg):close()
      system_print(gets("save_icon_succeed_tips")..save_svg_path.."/"..name..".svg")
    end
  end

  dlg_size_data2={
    ["48x48"]=48,
    ["96x96"]=96,
    ["128x128"]=128,
    ["144x144"]=144,
    ["192x192"]=192,
    ["512x512"]=512
  }

  function SavePng(svg,name)
    output_dlg_layout={
      LinearLayoutCompat;
      orientation="vertical",
      layout_height="30%w",
      layout_width="25%w",
      Gravity="center",
      {
        Spinner;
        id="dlg_size_list";
        layout_width="fill";
        layout_marginTop="4dp";
        layout_marginLeft="12dp";
        layout_marginRight="16dp";
        layout_marginBottom="4dp";
      }
    }
    --print(svg)
    dlg_size_data={"48x48","96x96","128x128","144x144","192x192","512x512"}
    local dlg_size_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1, String(dlg_size_data))

    local output_dialog=MaterialAlertDialogBuilder(activity)
    output_dialog.setTitle(gets("save"))
    output_dialog.setView(loadlayout(output_dlg_layout))
    if proj_path then
      output_dialog.setNegativeButton(gets("save_to_project"),function()
        local show_output_sieze=dlg_size_data[dlg_size_list.getSelectedItemPosition()+1]
        local output_size=dlg_size_data2[show_output_sieze]
        --print(output_size)
        local output_path=proj_path.."/"..name.."_"..show_output_sieze..".png"
        if File(output_path).exists() then
          local output_path=proj_path.."/"..name.."_"..show_output_sieze.."_"..os.time()..".png"
          Svg2Png(svg,output_size,output_path)
         else
          Svg2Png(svg,output_size,output_path)
        end
      end)
    end
    output_dialog.setPositiveButton(gets("save"),function()
      local show_output_sieze=dlg_size_data[dlg_size_list.getSelectedItemPosition()+1]
      local output_size=dlg_size_data2[show_output_sieze]
      --print(output_size)
      local output_path=save_png_path.."/"..name.."_"..show_output_sieze..".png"
      if File(output_path).exists() then
        local output_path=save_png_path.."/"..name.."_"..show_output_sieze.."_"..os.time()..".png"
        Svg2Png(svg,output_size,output_path)
       else
        Svg2Png(svg,output_size,output_path)
      end
    end)
    --output_dialog.setNeutralButton("颜色选择器",nil)
    output_dialog2=output_dialog.show()
    set_dialog_style(output_dialog2)
    dlg_size_list.setAdapter(dlg_size_adp)
  end

  gridview_1.onItemClick=function(p,v,i,s)
    local svg_object=SVG.getFromString(svg_table[s]["svg_content"])
    local svg_object_show=SVG.getFromString(svg_table[s]["svg_dark_content"])

    output_dlg_layout={
      LinearLayoutCompat;
      orientation="vertical",
      layout_height="30%w",
      layout_width="25%w",
      Gravity="center",
      {
        SVGImageView,
        layout_height="20%w",
        layout_width="25%w",
        padding="5%w",
        id="dlg_svg",
      }
    }

    local output_dialog=MaterialAlertDialogBuilder(activity)
    output_dialog.setTitle(gets("save"))
    output_dialog.setView(loadlayout(output_dlg_layout))
    output_dialog.setPositiveButton(gets("save").."Svg",function()
      SaveSvg(svg_table[s]["svg_content"],svg_table[s]["name"])
    end)
    output_dialog.setNegativeButton(gets("save").."Png",function()
      SavePng(svg_table[s]["svg_content"],svg_table[s]["name"])
    end)
    output_dialog2=output_dialog.show()
    set_dialog_style(output_dialog2)
    dlg_svg.setSVG(svg_object_show)
  end
end
