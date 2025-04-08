require 'system'

welcome_layout={
  LinearLayoutCompat;
  orientation="vertical";
  layout_height="fill";
  layout_width="fill";
  {
    ImageView;
    scaleType="centerCrop";
    id="image_view";
    layout_height="fill";
    layout_width="fill";
  };
};
activity.setContentView(loadlayout(welcome_layout))
--hide status bar
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

image_src=...
if image_src then
  image_view.setImageBitmap(loadbitmap(image_src))
end

t=timer(function()
  require "import"
  luaproj = activity.getLuaDir().."/lua.proj"
  pcall(dofile, luaproj)
  luaproject=luaproject
  activity.newLSActivity(luaproject.."/app/src/main/assets/main.lua",android.R.anim.slide_in_left,android.R.anim.slide_out_right)
  activity.finish()
  --t.Enabled=false
end,2000,0)
t.Enabled=true

function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    return true
  end
end