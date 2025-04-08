function load_shared_codes()
  --目录按钮
  setImage(more_img,load_icon_path("book"))
  more_button.onClick=function()
    loadLocalUrl(webView,"lua_doc/contents.html#contents")
  end
  loadLocalUrl(webView,"lua_doc/manual.html")
end