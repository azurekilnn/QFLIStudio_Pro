set_style()
content_view={
  LinearLayoutCompat;
  orientation="vertical";
  layout_height="fill";
  layout_width="fill";
  {
    MyWebView;
    layout_width="fill";
    id="webView";
    layout_margin="5dp";
  };
};

if not dlg_mode then
  setCommonView(content_view,"lua_doc_title","back_with_more_mode")
  activity_dir=activity.getLuaDir()
  import "shared_codes"
  pcall(load_shared_codes)
end