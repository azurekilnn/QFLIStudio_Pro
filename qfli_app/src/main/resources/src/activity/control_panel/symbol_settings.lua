setCommonView("layout.layout_symbol_settings",gets("symbol_bar_settings_text"),"back_with_more_mode")

system_ripple({add_symbol_button},"circular_theme")

default_symbol_data={"FUN","(",")","[","]","{","}","<",">","=",'"',"'",",",".",":",";","_","+","-","*","/","|","\\","%","#","?","重做",'""'}
symbol_data=(editor_data["new_symbol_content"] or default_symbol_data)
import "symbol_funlib"

change_symbol_rv_adp,change_symbol_rv_adp_data=init_symbol_rv_adapter()
change_symbol_rv.setAdapter(change_symbol_rv_adp)
change_symbol_rv.layoutManager = StaggeredGridLayoutManager(5, StaggeredGridLayoutManager.VERTICAL);

MyItemTouchHelperCallback=luajava.override(ItemTouchHelper.Callback,{
  getMovementFlags=function(super,recyclerView, viewHolder)
    dragFlags = ItemTouchHelper.UP | ItemTouchHelper.DOWN |
    ItemTouchHelper.LEFT | ItemTouchHelper.RIGHT;
    swipeFlags = 0;
    return int(ItemTouchHelper.Callback.makeMovementFlags(dragFlags, swipeFlags))
  end,
  onMove=function(super,recyclerView, viewHolder, target)
    from_position = viewHolder.getAdapterPosition();
    --//拿到当前拖拽到的item的viewHolder
    to_position = target.getAdapterPosition();
    change_symbol_rv_adp.notifyItemMoved(from_position, to_position);
    table_move(symbol_data,from_position+1,to_position+1)
    save_symbol_data()
    return true
  end,
  isLongPressDragEnabled=function()
    return true
  end
})

change_symbol_rv_helper = ItemTouchHelper(MyItemTouchHelperCallback)
change_symbol_rv_helper.attachToRecyclerView(change_symbol_rv);

add_symbol_button.onClick=function()
  show_add_symbol_dlg()
end

more_button.onClick=function()
  pop=PopupMenu(activity,more_lay)
  menu=pop.Menu
  menu.add(gets("save_and_exit_text")).onMenuItemClick=function(a)
    save_symbol_data()
    activity.finish()
  end
  menu.add(gets("reset_text")).onMenuItemClick=function(a)
    symbol_data=default_symbol_data
    save_symbol_data()
    load_symbols_data(symbol_data)
  end
  pop.show()
end

load_symbols_data(symbol_data)