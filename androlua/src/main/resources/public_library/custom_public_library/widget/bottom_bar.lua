local BottomBar={}
function BottomBar:new()
  import "android.animation.ObjectAnimator"
  import "android.animation.ArgbEvaluator"
  import "Azure"
  return table.clone(self._new)
end
BottomBar._new={}
BottomBar._new.Views={}
function BottomBar._new:initPageView(view)
  self._pageView=view
  pageview_id.addOnPageChangeListener{
    onPageSelected=function(position)
      self:switchView(position,false)
      if self.onPageSelected then
        self.onPageSelected(position)
      end
    end}
  return self
end
function BottomBar._new:initBar(view)
  self._bar=view
  return self
end
function BottomBar._new:addItem(text,icon1,icon2,select)
  local countid=self._bar.getChildCount()
  if select==nil then
    self.Views[text]={
      id=countid;
      Views={},
      icons={
        icon1=icon1,
        icon2=icon2,
      },
      Select=false;
    }
   else
    self.Views[text]={
      id=countid;
      Views={},
      icons={
        icon1=icon1,
        icon2=icon2,
      },
      Select=select;
    }
  end
  self._bar.addView(loadlayout({
    LinearLayoutCompat;
    --layout_weight="1";
    layout_height="fill";
    orientation="vertical";
    gravity="center";
    onClick=function()
      self:switchView(countid,true)
    end;
    id="Dad";
    Background=Ripple(nil,common_ripple);
    {
      ImageView;
      layout_width="24dp";
      layout_height="24dp";
      id="icon";
    };
  },self.Views[text].Views))
  AutoSetToolTip(self.Views[text].Views.Dad,text)

  local layoutParams=self.Views[text].Views.Dad.getLayoutParams()
  layoutParams.weight=1
  self.Views[text].Views.Dad.setLayoutParams(layoutParams)
  if select then
    self.Views[text].Views.icon.colorFilter=basic_color_num
   else
    self.Views[text].Views.icon.colorFilter=paratext_color_num
  end
  setImage(self.Views[text].Views.icon,icon2)
  return self
end

function BottomBar._new:switchView(id,show)
  if show then
    self._pageView.setCurrentItem(id)
  end
  for index,content in pairs(self.Views) do
    if content.id==id and content.Select==false then
      content.Select=true
      ObjectAnimator.ofInt(content.Views.icon,"colorFilter",{paratext_color_num,basic_color_num})
      .setEvaluator(ArgbEvaluator())
      .setDuration(250)
      .start()
      setImage(content.Views.icon,content.icons.icon1)
     elseif content.id~=id and content.Select==true then
      content.Select=false
      ObjectAnimator.ofInt(content.Views.icon,"colorFilter",{basic_color_num,paratext_color_num})
      .setEvaluator(ArgbEvaluator())
      .setDuration(250)
      .start()
      setImage(content.Views.icon,content.icons.icon2)
    end
  end
  return self
end
return BottomBar