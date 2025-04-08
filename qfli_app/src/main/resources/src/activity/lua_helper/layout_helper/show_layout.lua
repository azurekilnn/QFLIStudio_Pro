require "system_actionbar"
import "loadlayout3"

activity.setTitle(gets("preview_layout"))

layout_table=...
if layout_table then
  activity.setContentView(loadlayout3(loadstring("return "..layout_table)(),{}))
end