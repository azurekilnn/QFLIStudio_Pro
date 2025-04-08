function create_linearlayout(id)
  return {
    LinearLayoutCompat;
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    id=id;
  };
end

function create_configuration_card(args)
  return {
    LinearLayoutCompat;
    layout_height="wrap";
    layout_width="fill";
    {
      MaterialCardView;
      layout_margin="8dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      layout_height="wrap";
      layout_width="fill";
      CardBackgroundColor=get_theme_color("background_color");
      id=args["cardview"] or "";
      {
        LinearLayoutCompat;
        layout_height="wrap";
        layout_width="fill";
        padding="8dp";
        background=Ripple(nil,0x22000000);
        {
          LinearLayoutCompat;
          layout_height="wrap";
          layout_width="fill";
          layout_margin="8dp";
          orientation="vertical";
          {
            AppCompatTextView;
            textSize="16sp";
            layout_marginBottom="8dp";
            textColor=basic_color_num;
            Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
            --text="当前缓存占用";
            text=args["title"] or "";
          };
          {
            AppCompatTextView;
            textColor=text_color;
            textSize="14sp";
            id=args["tv_id"] or "";
            --id="home_cache_size_text";
            Visibility="8";
          };
          {
            LinearLayoutCompat;
            layout_height="wrap";
            layout_width="fill";
            layout_marigin="20dp";
            orientation="horizontal";
            layout_gravity="right";
            gravity="right";
            {
              Button;--按钮控件2
              text=args["button_text_2"] or gets("clear_cache_text");--显示的文本
              --id="query_cache_button";
              id=args["button_id_2"] or "";
              --style="?style/Widget.Azure.Button";
              layout_gravity="right";
              Visibility=((args["button_id_2"] and "0") or "8");
            };
            {
              Button;--按钮控件1
              text=args["button_text"] or gets("clear_cache_text");--显示的文本
              --id="query_cache_button";
              id=args["button_id"] or "";
              --style="?style/Widget.Azure.Button";
              layout_gravity="right";
            };
          };
        };
      };
    };
  };

end