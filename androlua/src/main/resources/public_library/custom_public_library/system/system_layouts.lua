function create_empty_tips(background_id,textview_id,tips)
  if background_id and textview_id and tips then
    return {
      LinearLayoutCompat;
      layout_width='fill';
      layout_height='fill';
      id=background_id;
      layoutTransition=newLayoutTransition();
      {
        TextView;
        layout_height='fill';
        gravity='center';
        layout_gravity='center';
        textSize='15sp';
        layout_width='fill';
        id=textview_id;
        text=tips;
        textColor=text_color;
      };
    };
  end
end

function create_linearlayout(id)
  return {
    LinearLayoutCompat;
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    id=id;
  };
end

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

function create_common_cardview(layout,id)
  return {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="wrap";
    layout_gravity="center";
    {
      LinearLayoutCompat;
      orientation="vertical";
      layout_height='fill';
      layout_width='fill';
      {
        CardView;
        CardElevation="0dp";
        CardBackgroundColor="#FFE0E0E0";
        Radius="8dp";
        layout_width="fill";
        layout_height="wrap";
        layout_margin="16dp";
        layout_marginTop="5dp";
        {
          CardView;
          CardElevation="0dp";
          CardBackgroundColor=background_color;
          Radius=dp2px(8)-2;
          layout_margin="2px";
          layout_width="-1";
          layout_height="-1";
          {
            LinearLayoutCompat;
            layout_height='fill';
            layout_width='fill';
            orientation="vertical";
            padding="10dp";
            id=(id or "main_cardview");
            layout;
          }
        }
      }
    }
  }
end