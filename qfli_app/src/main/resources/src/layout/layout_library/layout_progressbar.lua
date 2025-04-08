function create_progressbar(id,hide)
  local function hide_widget(hide)
    if hide then
      return View.GONE
     else
      return View.VISIBLE
    end
  end
  return {
    LinearLayoutCompat;
    id=id.."_background";
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    gravity="center";
    Visibility=hide_widget(hide);
    {
      ProgressBar;
      layout_gravity="center";
      id=id;
    }
  };
end