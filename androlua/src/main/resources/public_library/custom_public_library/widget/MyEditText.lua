
import "android.graphics.Color"
import "android.util.TypedValue"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.graphics.drawable.GradientDrawable"


function math.dp2int(dpValue)
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, activity.getResources().getDisplayMetrics())
end

function math.px2sp(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity;
  return pxValue / scale + 0.5
end

local function ButtonFrame(view,Thickness,FrameColor,InsideColor,radiu)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setStroke(Thickness, FrameColor)
  drawable.setColor(InsideColor)
  local radiu=radiu or 0
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end


local function isDarkColor(color)
  return (0.299 * Color.red(color) + 0.587 * Color.green(color) + 0.114 * Color.blue(color)) <192
end

local MyEditText={}
MyEditText._defaultConfig={}
local array = activity.getTheme().obtainStyledAttributes({
  android.R.attr.windowBackground,
  android.R.attr.colorAccent,
})

MyEditText._defaultConfig.backgroundColor=array.getColor(0, 0xFF00FF)
MyEditText._defaultConfig.colorAccent=array.getColor(1, 0xFF00FF)
MyEditText._defaultConfig.editH=math.dp2int(24)-1



function MyEditText.OpenAnim(id)
  ObjectAnimator.ofFloat(id.HintView,"TranslationY",{0})
  .setInterpolator(DecelerateInterpolator())
  .setDuration(150)
  .start()
  ObjectAnimator.ofFloat(id.HintTextView,"textSize",{math.px2sp(id.EditText.textSize),12})
  .setInterpolator(DecelerateInterpolator())
  .setDuration(150)
  .start()
end

function MyEditText.CloseAnim(id)
  ObjectAnimator.ofFloat(id.HintView,"TranslationY",{MyEditText._defaultConfig.editH})
  --.setInterpolator(DecelerateInterpolator())
  .setDuration(150)
  .start()
  ObjectAnimator.ofFloat(id.HintTextView,"textSize",{math.px2sp(id.HintTextView.textSize),math.px2sp(id.EditText.textSize)})
  --.setInterpolator(DecelerateInterpolator())
  .setDuration(150)
  .start()
end

function MyEditText.DrawCloseLine(id,config)
  ButtonFrame(id.HintLine,math.dp2int(1),config.HintTextColor or MyEditText.AutoHintColor(config),config.backgroundColor or MyEditText._defaultConfig.backgroundColor,config.radius or math.dp2int(4))
end
function MyEditText.DrawOpenLine(id,config,colorAccent)
  ButtonFrame(id.HintLine,math.dp2int(2),basic_color_num or config.HintTextColor or MyEditText._defaultConfig.colorAccent,config.backgroundColor or MyEditText._defaultConfig.backgroundColor,config.radius or math.dp2int(4))
end


function MyEditText.AutoHintColor(config)
  if isDarkColor(config.backgroundColor or MyEditText._defaultConfig.backgroundColor) then
    return 0xFFFFFFFF
   else
    return 0x70000000
  end
end




MyEditText._build={}

function MyEditText._build:getText()
  return self.EditText.text
end
function MyEditText._build:setText(text)
  self.EditText.text=text
  return self
end
function MyEditText._build:setTextSize(size)
  self.EditText.setTextSize(size)
  if not(self.EditText.hasFocus() and self.EditText.text=="") then
    self.HintTextView.setTextSize(size)
  end
  return self
end
function MyEditText._build:getHint()
  return self.HintTextView.text
end
function MyEditText._build:setHint(text)
  if text and text~="" then
    self.HintView.setVisibility(View.VISIBLE)
   else
    self.HintView.setVisibility(View.GONE)
  end
  self.HintTextView.text=text or ""
  return self
end

function MyEditText._build:getView()
  return self.EditText
end

function MyEditText._build:setFocusable(...)
  self.EditText.setFocusable(...)
  return self
end
function MyEditText._build:setFocusableInTouchMode(...)
  self.EditText.setFocusableInTouchMode(...)
  return self
end


function MyEditText:build(config)
  local et_id
  local localid=table.clone(self._build)
  if config.id then
    _G[config.id]=localid
  end
  if config.et_id then
    et_id=config.et_id
   else
    et_id="edittext_defalut"
  end
  local my_edit_text_layout={
    LinearLayout;
    --layout_width="fill";
    --layout_height="fill";
    {
      FrameLayout;
      layout_width="fill";
      layout_height="fill";
      {
        LinearLayout;
        layout_margin="8dp";
        --layout_marginBottom="16dp";
        layout_height="fill";
        layout_width="fill";
      };
      {
        LinearLayout;
        layout_height="fill";
        layout_width="fill";
        orientation="vertical";
        {
          EditText;
          layout_margin="8dp";
          padding="16dp";
          --paddingLeft="14dp";
          paddingRight="12dp";
          backgroundColor=0;
          layout_weight=1;
          layout_width="fill";
          textSize="16sp";
          gravity="top|left";
          id=et_id;
          --includeFontPadding=false;
          --textColor=info.textColor or (function() if isDarkColor(info.backgroundColor or windowBackground) then return 0xFFFFFFFF else return 0xFF000000 end end)()
        };
      };
      {
        LinearLayout;
        layout_marginLeft="20dp";
        layout_marginRight="20dp";
        layout_gravity="top|left";
        backgroundColor=array.getColor(0, 0xFF00FF);
        {
          TextView;
          layout_marginLeft="4dp";
          layout_marginRight="4dp";
          textSize="12sp";
        };
      };
    };
  }
  localid.MainView=loadlayout(my_edit_text_layout)
  localid.EditText=localid.MainView.getChildAt(0).getChildAt(1).getChildAt(0)
  localid.HintView=localid.MainView.getChildAt(0).getChildAt(2)
  localid.HintTextView=localid.MainView.getChildAt(0).getChildAt(2).getChildAt(0)
  localid.HintLine=localid.MainView.getChildAt(0).getChildAt(0)

  localid.MainView.onClick=function()
    localid.EditText.requestFocus()
  end

  localid.HintTextView.textColor=config.HintTextColor or MyEditText.AutoHintColor(config)
  MyEditText.DrawCloseLine(localid,config)
  localid.HintView.backgroundColor=config.backgroundColor or MyEditText._defaultConfig.backgroundColor
  if config.text or config.Text then
    localid:setText(config.text or config.Text)
  end
  localid:setHint(config.Hint)

  if (config.focusable or config.Focusable)~=nil then
    localid.setFocusable(config.focusable or config.Focusable)
  end

  if (config.focusableInTouchMode or config.FocusableInTouchMode)~=nil then
    localid.setFocusableInTouchMode(config.focusableInTouchMode or config.FocusableInTouchMode)
  end
  localid:setTextSize(config.textSize or 16)

  if localid.EditText.text=="" then
    MyEditText.CloseAnim(localid)
   else
    MyEditText.OpenAnim(localid)
  end

  localid.EditText.setOnFocusChangeListener{
    onFocusChange=function(view,hasFocus)
      if hasFocus then--判断焦点是否存在
        localid.HintTextView.textColor=config.HintTextColor or basic_color_num or MyEditText._defaultConfig.colorAccent
        MyEditText.DrawOpenLine(localid,config)
        if view.text=="" then
          MyEditText.OpenAnim(localid)
        end
       else
        localid.HintTextView.textColor=config.HintTextColor or MyEditText.AutoHintColor(config)
        MyEditText.DrawCloseLine(localid,config)
        if view.text=="" then
          MyEditText.CloseAnim(localid)
        end
      end

      if localid.onFocusChange then
        localid.onFocusChange(text,a,b)
      end
    end}

  localid.EditText.addTextChangedListener{
    onTextChanged=function(text,a,b)
      if not(localid.EditText.hasFocus()) then
        --从有到无
        if #text==0 then
          MyEditText.CloseAnim(localid)
        end
        --从无到有
        if a==0 and b==0 then
          MyEditText.OpenAnim(localid)
        end
      end

      if localid.onTextChanged then
        localid.onTextChanged(text,a,b)
      end
    end
  }

  return function() return localid.MainView end
end
return MyEditText