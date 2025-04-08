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