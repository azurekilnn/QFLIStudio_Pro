editor_assembly = {
  bottom_bar_layout = {
    LinearLayoutCompat,
    layout_height = 'fill',
    layout_width = 'fill',
    gravity = 'bottom|right',
    --layout_weight="1";
    orientation = 'vertical',
    {
      LinearLayoutCompat,
      layout_height = 'fill',
      layout_width = 'wrap',
      gravity = 'bottom|center',
      layout_weight = '1',
      {
        LinearLayoutCompat,
        layout_height = 'fill',
        layout_width = 'wrap',
        gravity = 'bottom|center',
        orientation = 'vertical',
        id = 'fast_operation_bar',
        Visibility = '8',
        {
          CardView,
          layout_width = '42dp',
          layout_height = '42dp',
          radius = '8dp',
          layout_margin = '8dp',
          Elevation = '2dp',
          backgroundColor = get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width = 'fill',
            layout_height = 'fill',
            id = 'finsert_code_button',
            {
              ImageView,
              src = load_icon_path('add'),
              layout_height = 'fill',
              layout_width = 'fill',
              padding = '10dp',
              colorFilter = symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width = '42dp',
          layout_height = '42dp',
          radius = '8dp',
          layout_margin = '8dp',
          Elevation = '2dp',
          backgroundColor = get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width = 'fill',
            layout_height = 'fill',
            id = 'fcode_operation_button',
            {
              ImageView,
              src = load_icon_path('edit'),
              layout_height = 'fill',
              layout_width = 'fill',
              padding = '10dp',
              colorFilter = symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width = '42dp',
          layout_height = '42dp',
          radius = '8dp',
          layout_margin = '8dp',
          Elevation = '2dp',
          backgroundColor = get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width = 'fill',
            layout_height = 'fill',
            id = 'fformat_button',
            {
              ImageView,
              src = load_icon_path('notes'),
              layout_height = 'fill',
              layout_width = 'fill',
              padding = '10dp',
              colorFilter = symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width = '42dp',
          layout_height = '42dp',
          radius = '8dp',
          layout_margin = '8dp',
          Elevation = '2dp',
          backgroundColor = get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width = 'fill',
            layout_height = 'fill',
            id = 'fpaste_button',
            {
              ImageView,
              src = load_icon_path('assignment'),
              layout_height = 'fill',
              layout_width = 'fill',
              padding = '10dp',
              colorFilter = symbol_bar_icon_color()
            }
          }
        },
        {
          CardView,
          layout_width = '42dp',
          layout_height = '42dp',
          radius = '8dp',
          layout_margin = '8dp',
          Elevation = '2dp',
          backgroundColor = get_theme_color("tool_bar_color");
          {
            LinearLayoutCompat,
            layout_width = 'fill',
            layout_height = 'fill',
            id = 'fredo_button',
            {
              ImageView,
              src = load_icon_path('redo'),
              layout_height = 'fill',
              layout_width = 'fill',
              padding = '10dp',
              colorFilter = symbol_bar_icon_color()
            }
          }
        }
      }
    },
    {
      LinearLayoutCompat,
      layout_height = 'wrap',
      layout_width = 'fill',
      layout_gravity = 'bottom',
      Visibility = '8',
      id = 'symbol_bar_background',
      {
        CardView,
        radius = '18dp',
        layout_height = '36dp',
        layout_width = 'fill',
        layout_margin = '8dp',
        layout_weight = '1',
        Elevation = '1dp',
        backgroundColor = get_theme_color("tool_bar_color");
        {
          LinearLayoutCompat,
          layout_width = 'fill',
          layout_height = 'wrap',
          {
            HorizontalScrollView,
            id = 'symbol_bar',
            layout_weight = '1',
            layout_width = 'fill',
            layout_gravity = 'center',
            horizontalScrollBarEnabled = false,
            layout_height = '36dp',
            layout_margin = '8dp',
            {
              LinearLayoutCompat,
              layout_width = 'fill',
              layout_height = 'fill',
              id = 'bar',
              orientation = 'horizontal'
            }
          }
        }
      },
      {
        CardView,
        layout_width = '36dp',
        layout_height = '36dp',
        radius = '16dp',
        Elevation = '2dp',
        backgroundColor = get_theme_color("tool_bar_color");
        layout_margin = '8dp',
        layout_marginLeft = '0',
        {
          LinearLayoutCompat,
          layout_width = 'fill',
          layout_height = 'fill',
          id = 'fast_button_close',
          {
            ImageView,
            src = load_icon_path('keyboard_arrow_up'),
            layout_height = 'fill',
            layout_width = 'fill',
            padding = '4dp',
            colorFilter = symbol_bar_icon_color(),
            rotation = 0,
            id = 'fast_button_close_icon'
          }
        }
      }
    }
  },
  new_operation_bar_layout = {
    LinearLayout,
    orientation = 'vertical',
    layout_height = 'wrap',
    layout_width = 'fill',
    {
      TabLayout,
      id = 'new_operation_bar_id',
      TabMode = 2,
      layout_width = 'wrap',
      layout_height = 'wrap',
      layout_gravity = 'left'
    }
  },
  new_file_tab_bar_layout = {
    LinearLayout,
    orientation = 'vertical',
    layout_height = 'wrap',
    layout_width = 'fill',
    {
      TabLayout,
      id = 'new_file_tab_bar_id',
      TabMode = 2,
      layout_width = 'wrap',
      layout_height = 'wrap',
      layout_gravity = 'left'
    }
  },
  operation_bar_layout = {
    HorizontalListView,
    background = get_theme_color("tool_bar_color");
    id = 'operation_bar_id',
    layout_height = 'wrap',
    layout_width = 'fill'
    --layoutTransition=newLayoutTransition();
  },
  tab_bar_layout = {
    HorizontalListView,
    background = get_theme_color("tool_bar_color");
    id = 'tab_bar_id',
    layout_height = 'wrap',
    layout_width = 'fill'
    --layoutTransition=newLayoutTransition();
  },
  fast_mode_bar_layout = {
    LinearLayoutCompat,
    layout_height = 'wrap',
    layout_width = 'fill',
    Visibility = '8',
    layoutTransition = newLayoutTransition(),
    {
      LinearLayoutCompat,
      layout_width = 'fill',
      layout_height = 'wrap',
      {
        HorizontalListView,
        id = 'fast_mode_bar',
        layout_weight = '1',
        layout_width = 'fill',
        layout_gravity = 'center',
        horizontalScrollBarEnabled = false,
        layout_height = '25dp',
        layoutTransition = newLayoutTransition(),
        layout_margin = '4dp'
      }
    }
  },
  error_bar_layout = {
    LinearLayoutCompat,
    layout_height = 'wrap',
    layout_width = 'fill',
    --layout_gravity="center";
    id = 'error_bar',
    layoutTransition = newLayoutTransition(),
    {
      CardView,
      radius = '10dp',
      layout_height = 'wrap',
      layout_width = 'fill',
      layout_margin = '4dp',
      layout_marginRight = '8dp',
      layout_marginLeft = '8dp',
      layout_weight = '1',
      Elevation = '1dp',
      backgroundColor = get_theme_color("tool_bar_color");
      {
        LinearLayoutCompat,
        layout_width = 'fill',
        layout_height = 'wrap',
        layoutTransition = newLayoutTransition(),
        {
          TextView,
          padding = '4dp',
          layout_width = 'fill',
          layout_height = 'fill',
          singleLine = true,
          text = 'No Error.',
          layout_gravity = 'center',
          textColor = text_color,
          textSize = '10dp',
          id = 'error_text_id'
        }
      }
    }
  },
  tool_bar = {
    LinearLayoutCompat,
    layout_width = 'fill',
    orientation = 'vertical',
    layout_height = '56dp',
    backgroundColor = get_theme_color("tool_bar_color");
    id = 'tool_bar_id',
    {
      LinearLayoutCompat,
      layout_width = 'fill',
      layout_height = 'fill',
      gravity = 'center|left',
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'folder_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('folder'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'folder_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'menu_button',
        layout_height = 'fill',
        Visibility = '8',
        {
          LinearLayoutCompat,
          layout_width = '55dp',
          gravity = 'center',
          id = 'menu_back_button',
          Visibility = '8',
          layout_height = 'fill',
          onClick = system_incident['finish'],
          {
            ImageView,
            src = load_icon_path('arrow_back'),
            ColorFilter = system_title_color(),
            layout_width = '32dp',
            layout_height = '32dp',
            padding = '4dp',
            id = 'menu_back_img',
            layout_margin = '8dp'
          }
        },
        {
          LinearLayoutCompat,
          layout_width = '32dp',
          layout_height = '32dp',
          layout_margin = '12dp',
          gravity = 'center',
          orientation = 'vertical',
          id = 'menu_img',
          {
            TextView,
            layout_width = '18.8dp',
            layout_height = '2.2dp',
            BackgroundColor = system_title_color(),
            id = 'menu_1'
          },
          {
            TextView,
            layout_width = '18.8dp',
            layout_height = '2.2dp',
            BackgroundColor = system_title_color(),
            layout_marginTop = '6',
            id = 'menu_2'
          },
          {
            TextView,
            layout_width = '18.8dp',
            layout_height = '2.2dp',
            BackgroundColor = system_title_color(),
            layout_marginTop = '6',
            id = 'menu_3'
          }
        }
      },
      {
        LinearLayoutCompat,
        layout_weight = '1',
        gravity = 'center',
        layout_height = 'fill',
        orientation = 'vertical',
        id = 'title_background',
        {
          TextView,
          Selected = true, --文本可选
          textColor = system_title_color(),
          textSize = '20sp',
          id = 'main_title_id',
          SingleLine = true,
          layout_width = '-1',
          layout_gravity = 'left',
          Typeface = load_font('bold'),
          background = Ripple(nil, 0x22000000, '方'),
          onClick = system_incident['view_copy']
        },
        {
          TextView,
          ellipsize = 'start',
          id = 'opened_file',
          Typeface = load_font('common'),
          layout_gravity = 'left',
          gravity = 'center|left',
          textSize = '12sp',
          SingleLine = true,
          textColor = get_theme_color("paratext_color"),
          background = Ripple(nil, 0x22000000, '方'),
          onClick = system_incident['view_copy']
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'layout_helper_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('panorama'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'layout_helper_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'play_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('play_arrow'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'play_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'undo_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('undo'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'undo_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'redo_button',
        layout_height = 'fill',
        Visibility = '8',
        {
          ImageView,
          src = load_icon_path('redo'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'redo_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'more_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('more'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'more_img',
          layout_margin = '8dp'
        }
      },
      {
        TextView,
        id = 'more_lay',
        layout_width = '0',
        layout_height = '0',
        layout_gravity = 'top'
      }
    }
  },
  control_bar = {
    LinearLayoutCompat,
    layout_width = 'fill',
    orientation = 'vertical',
    layout_height = '56dp',
    backgroundColor = get_theme_color("tool_bar_color");
    id = 'control_bar_id',
    Visibility = '8',
    {
      LinearLayoutCompat,
      layout_width = 'fill',
      layout_height = 'fill',
      gravity = 'center|left',
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'cancel_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('cancel'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'cancel_button_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_weight = '1',
        gravity = 'center',
        layout_height = 'fill',
        orientation = 'vertical',
        {
          TextView,
          textColor = system_title_color(),
          textSize = '20sp',
          id = 'control_bar_title',
          SingleLine = true,
          layout_width = '-1',
          gravity = 'center|left',
          Typeface = load_font('bold')
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'select_all_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('select_all'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'select_all_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'cut_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('cut'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'cut_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'copy_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('copy'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'copy_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'paste_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('clipboard'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'paste_img',
          layout_margin = '8dp'
        }
      }
    }
  },
  search_bar = {
    LinearLayoutCompat,
    layout_width = 'fill',
    orientation = 'vertical',
    layout_height = '56dp',
    backgroundColor = get_theme_color("tool_bar_color");
    id = 'search_bar_id',
    Visibility = '8',
    {
      LinearLayoutCompat,
      layout_width = 'fill',
      layout_height = 'fill',
      gravity = 'center|left',
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'search_bar_cancel_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('cancel'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'search_bar_cancel_button_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_weight = '1',
        gravity = 'center',
        layout_height = 'fill',
        orientation = 'vertical',
        {
          EditText,
          textColor = text_color,
          HintTextColor = get_theme_color("paratext_color"),
          gravity = 'left',
          Typeface = load_font('common'),
          backgroundColor = '0',
          id = 'search_bar_edit',
          layout_gravity = 'center',
          layout_width = 'fill',
          textSize = '20sp',
          singleLine = 'true'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'search_bar_search_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('search'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'search_bar_search_img',
          layout_margin = '8dp'
        }
      }
    }
  },
  toline_bar = {
    LinearLayoutCompat,
    layout_width = 'fill',
    orientation = 'vertical',
    layout_height = '56dp',
    backgroundColor = get_theme_color("tool_bar_color");
    id = 'toline_bar_id',
    Visibility = '8',
    {
      LinearLayoutCompat,
      layout_width = 'fill',
      layout_height = 'fill',
      gravity = 'center|left',
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'toline_bar_cancel_button',
        layout_height = 'fill',
        {
          ImageView,
          src = editor_icons('cancel'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'toline_bar_cancel_button_img',
          layout_margin = '8dp'
        }
      },
      {
        LinearLayoutCompat,
        layout_weight = '1',
        gravity = 'center',
        layout_height = 'fill',
        orientation = 'vertical',
        {
          EditText,
          textColor = text_color,
          HintTextColor = get_theme_color("paratext_color"),
          gravity = 'left',
          Typeface = load_font('common'),
          backgroundColor = '0',
          id = 'toline_bar_edit',
          layout_gravity = 'center',
          layout_width = 'fill',
          textSize = '20sp',
          singleLine = 'true'
        }
      },
      {
        LinearLayoutCompat,
        layout_width = '55dp',
        gravity = 'center',
        id = 'toline_bar_search_button',
        layout_height = 'fill',
        {
          ImageView,
          src = load_icon_path('search'),
          ColorFilter = system_title_color(),
          layout_width = '32dp',
          layout_height = '32dp',
          padding = '4dp',
          id = 'toline_bar_search_img',
          layout_margin = '8dp'
        }
      }
    }
  }
}