function math.dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
function math.dp2int(dpValue)
  import "android.util.TypedValue"
  return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, activity.getResources().getDisplayMetrics())
end
function math.getNavigationBarHeight()
  local resources = activity.getResources()
  local resourceId = resources.getIdentifier("navigation_bar_height","dimen", "android");
  local height = resources.getDimensionPixelSize(resourceId)
  return height
end
function math.getStatusBarHeight()
  local resources = activity.getResources()
  local resourceId = resources.getIdentifier("status_bar_height", "dimen","android")
  local height = resources.getDimensionPixelSize(resourceId)
  return height
end