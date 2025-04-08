set_style()
content_view={
  LinearLayoutCompat;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  backgroundColor=gray_color;
  {
    ListView;
    layout_width="fill";
    layout_height="fill";
    backgroundColor=gray_color;
    layout_margin="10dp";
    id="logcat_lv";
    DividerHeight="0";
    FastScrollEnabled=false;
  };
};

import "shared_codes"

if not dlg_mode then
  setCommonView(content_view,"LogCat","back_with_more_mode")
  function setWinTitle(title)
    setWindowTitle(title)
  end
  load_shared_codes()
end