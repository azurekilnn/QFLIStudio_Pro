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