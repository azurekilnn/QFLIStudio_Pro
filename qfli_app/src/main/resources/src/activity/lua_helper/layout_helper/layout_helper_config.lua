relative={
  "layout_above","layout_alignBaseline","layout_alignBottom","layout_alignEnd","layout_alignLeft","layout_alignParentBottom","layout_alignParentEnd","layout_alignParentLeft","layout_alignParentRight","layout_alignParentStart","layout_alignParentTop","layout_alignRight","layout_alignStart","layout_alignTop","layout_alignWithParentIfMissing","layout_below","layout_centerHorizontal","layout_centerInParent","layout_centerVertical","layout_toEndOf","layout_toLeftOf","layout_toRightOf","layout_toStartOf"
}

--属性选择列表
checks={}
checks.singleLine={"true","false"}
checks.orientation={"vertical","horizontal"}
checks.gravity={"top","bottom","start","center","end"}
checks.layout_gravity={"left","top","right","bottom","start","center","end"}
--checks.layout_width={"wrap_content","match_parent","layout_width"}
--checks.layout_height={"wrap_content","match_parent","layout_height"}
checks.scaleType={
  "matrix",
  "fitXY",
  "fitStart",
  "fitCenter",
  "fitEnd",
  "center",
  "centerCrop",
  "centerInside"
}

fds_grid={
  gets("add"),gets("delete"),gets("parent_widget"),gets("children_widget"),
  "id","orientation",
  "columnCount","rowCount",
  "layout_width","layout_height","layout_gravity",
  "background","gravity",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

fds_linear={
  gets("add"),gets("delete"),gets("parent_widget"),gets("children_widget"),
  "id","orientation","layout_width","layout_height","layout_gravity",
  "background","gravity",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

fds_group={
  gets("add"),gets("delete"),gets("parent_widget"),gets("children_widget"),
  "id","layout_width","layout_height","layout_gravity",
  "background","gravity",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

fds_text={
  gets("delete"),gets("parent_widget"),
  "id","layout_width","layout_height","layout_gravity",
  "background","text","textColor","Hint","HintTextColor","textSize","singleLine","gravity",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

fds_image={
  gets("delete"),gets("parent_widget"),
  "id","layout_width","layout_height","layout_gravity",
  "background","src","scaleType",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation","colorFilter",
}

fds_view={
  gets("delete"),gets("parent_widget"),
  "id","layout_width","layout_height","layout_gravity",
  "background","gravity",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

fds_card={
  gets("add"),gets("delete"),gets("parent_widget"),gets("children_widget"),
  "id","layout_width","layout_height","layout_gravity",
  "background","gravity","radius",
  "layout_margin","layout_marginStart","layout_marginTop","layout_marginEnd","layout_marginBottom",
  "padding","paddingStart","paddingTop","paddingEnd","paddingButtom","elevation",
}

ns={
  "AdapterView - 适配器视图",
  "AdvancedLayout - 高级布局",
  "AdvancedWidget - 高级控件",
  "CheckView - 检查视图",
  "Layout - 布局",
  "Widget - 小部件",
  "Additional Widget - 附加部件"
}

wds={
  {"RecyclerView","ExpandableListView","GridView","HorizontalListView","ListView","PageView","Spinner"},
  {"CardView","HorizontalScrollView","RadioGroup","ScrollView"},
  {"DatePicker","NumberAnimTextView","NumberPicker","ProgressBar","RatingBar","TextClock","TimePicker","SeekBar"},
  {"CheckBox","RadioButton","Switch","ToggleButton"},
  {"AbsoluteLayout","FrameLayout","GridLayout","LinearLayout","RelativeLayout","RippleLayout","SlidingLayout","TableLayout"},
  {"AutoCompleteTextView","Button","Chronometer","CircleImageView","EditText","ImageButton","ImageView","PhotoView","TextView","SearchView","VideoView"},
  {"LuaEditor","LuaWebView","MarText","PhotoView","PullingLayout"},
}

wds2={
  {"RecyclerView - 列表","ExpandableListView - 多级列表","GridView - 网格视图","HorizontalListView - 横向列表控件","ListView - 列表控件","PageView - 滑动窗口布局","Spinner - 下拉框"},
  {"CardView - 卡片视图","HorizontalScrollView - 滚动视图(横)","RadioGroup - 单选视图","ScrollView - 滚动视图(竖)"},
  {"DatePicker - 日期选择器","NumberAnimTextView - 数字动画文本","NumberPicker - 数字选择器","ProgressBar - 进度条","RatingBar - 评分栏","TextClock - 时间文本","TimePicker - 时间选择器","SeekBar - 拖动条"},
  {"CheckBox - 复选框","RadioButton - 单选按钮","Switch - 开关","ToggleButton - 按钮开关"},
  {"AbsoluteLayout - 绝对布局","FrameLayout - 帧布局","GridLayout - 网格布局","LinearLayout - 线性布局","RelativeLayout - 相对布局","RippleLayout - 水波纹布局","SlidingLayout - 滑动菜单布局","TableLayout - 表格布局"},
  {"AutoCompleteTextView - 自动补全文本框","Button - 按钮","Chronometer - 计时器","CircleImageView - 圆形图片控件","EditText - 编辑框","ImageButton - 图片按钮","ImageView - 图片控件","PhotoView","TextView - 文本","SearchView - 搜索框","VideoView - 视频控件"},
  {"LuaEditor - Lua代码编辑框","LuaWebView - Lua浏览器","MarText - 跑马灯文本","PhotoView - 图片缩放","PullingLayout - Pulling刷新"},
}