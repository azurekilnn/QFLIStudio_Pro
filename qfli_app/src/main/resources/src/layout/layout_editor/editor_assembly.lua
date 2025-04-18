editor_assembly={
  bottom_bar_layout={
    LinearLayoutCompat,
    layout_height="fill";
    layout_width="fill";
    gravity="bottom|right";
    --layout_weight="1";
    orientation="vertical";
    {
      LinearLayoutCompat,
      layout_height="fill";
      layout_width="wrap";
      gravity="bottom|center";
      layout_weight="1";
      {
        LinearLayoutCompat,
        layout_height="fill";
        layout_width="wrap";
        gravity="bottom|center";
        orientation="vertical";
        id="fast_operation_bar";
        Visibility="8";
        {
          CardView,
          layout_width="42dp";
          layout_height="42dp";
          radius="8dp";
          layout_margin="8dp";
          Elevation="2dp";
          backgroundColor=get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width="fill";
            layout_height="fill";
            id="finsert_code_button";
            {
              ImageView,
              src=load_icon_path("add"),
              layout_height="fill";
              layout_width="fill";
              padding="10dp";
              colorFilter=symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width="42dp";
          layout_height="42dp";
          radius="8dp";
          layout_margin="8dp";
          Elevation="2dp";
          backgroundColor=get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width="fill";
            layout_height="fill";
            id="fcode_operation_button";
            {
              ImageView,
              src=load_icon_path("edit"),
              layout_height="fill";
              layout_width="fill";
              padding="10dp";
              colorFilter=symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width="42dp";
          layout_height="42dp";
          radius="8dp";
          layout_margin="8dp";
          Elevation="2dp";
          backgroundColor=get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width="fill";
            layout_height="fill";
            id="fformat_button";
            {
              ImageView,
              src=load_icon_path("notes"),
              layout_height="fill";
              layout_width="fill";
              padding="10dp";
              colorFilter=symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width="42dp";
          layout_height="42dp";
          radius="8dp";
          layout_margin="8dp";
          Elevation="2dp";
          backgroundColor=get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width="fill";
            layout_height="fill";
            id="fpaste_button";
            {
              ImageView,
              src=load_icon_path("assignment"),
              layout_height="fill";
              layout_width="fill";
              padding="10dp";
              colorFilter=symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width="42dp";
          layout_height="42dp";
          radius="8dp";
          layout_margin="8dp";
          Elevation="2dp";
          backgroundColor=get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width="fill";
            layout_height="fill";
            id="fredo_button";
            {
              ImageView,
              src=load_icon_path("redo"),
              layout_height="fill";
              layout_width="fill";
              padding="10dp";
              colorFilter=symbol_bar_icon_color()
            }
          }
        },
      }
    },
    {
      LinearLayoutCompat,
      layout_height="wrap";
      layout_width="fill";
      layout_gravity="bottom";
      id="symbol_bar_background";
      {
        CardView,
        radius="18dp";
        layout_height="36dp";
        layout_width="fill";
        layout_margin="8dp";
        layout_weight="1";
        Elevation="1dp";
        backgroundColor=get_theme_color("tool_bar_color");
        {
          LinearLayoutCompat,
          layout_width="fill";
          layout_height="wrap";
          {
            HorizontalScrollView,
            id="symbol_bar";
            layout_weight="1";
            layout_width="fill";
            layout_gravity="center";
            horizontalScrollBarEnabled=false,
            layout_height="36dp";
            layout_margin="8dp";
            {
              LinearLayoutCompat,
              layout_width="fill";
              layout_height="fill";
              id="bar";
              orientation="horizontal";
            }
          }
        }
      },
      {
        CardView,
        layout_width="36dp";
        layout_height="36dp";
        radius="16dp";
        Elevation="2dp";
        backgroundColor=get_theme_color("tool_bar_color");
        layout_margin="8dp";
        layout_marginLeft="0";
        {
          LinearLayoutCompat,
          layout_width="fill";
          layout_height="fill";
          id="fast_button_close";
          {
            ImageView,
            src=load_icon_path("keyboard_arrow_up"),
            layout_height="fill";
            layout_width="fill";
            padding="4dp";
            colorFilter=symbol_bar_icon_color(),
            rotation=0,
            id="fast_button_close_icon"
          }
        }
      }
    };
  },

}