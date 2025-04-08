import("android.text.InputType")

activity.setTitle(gets("control_panel"))
memory_file_path=activity.getLuaDir().."/memory_file/public_sign_keystore"
choose_file_func=function(file_path,file_name)
  keystore_path_id.setText(file_path)
end
choose_file("/storage/emulated/0",choose_file_func,"keystore")
choose_file_dialog.dismiss()


activity.setContentView(loadlayout("layout.layout_control_panel.layout_sign_keystore_setting"))

main_title_id.setText(gets("control_panel"))
system_ripple({path_background,edit_background},"方主题")
path_background.onClick=function()end
edit_background.onClick=function()end
menu_button.setVisibility(8)
more_button.setVisibility(8)

spinner_table={}
signature_algorithm_table={"SHA1withRSA","SHA224withRSA","SHA256withRSA","SHA384withRSA","SHA512withRSA"}
for k,v in ipairs(signature_algorithm_table) do
  table.insert(spinner_table,tostring(v))
end
array_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1,String(spinner_table))
signature_algorithm_spinner.setAdapter(array_adp)
signature_algorithm_spinner.onItemSelected=function(a,b,c,d)
  signature_algorithm=b.Text
  spinner_selection_value=d
end

local function get_content()
  pull.setRefreshing(true);
  if File(memory_file_path).exists() then
    local public_keystore_information={}
    pcall(loadfile(memory_file_path,"bt",public_keystore_information))
    local pki=public_keystore_information
    local public_keystore_checked=pki["public_keystore_checked"]
    local keystore_path=pki["keystore_path"]
    local keystore_password=pki["keystore_password"]
    local keystore_ailas=pki["keystore_ailas"]
    local keystore_ailas_password=pki["keystore_ailas_password"]
    local signature_algorithm=pki["signature_algorithm"]
    local spinner_selection=pki["spinner_selection"]

    public_keystore_switch.setChecked(public_keystore_checked)
    keystore_path_id.setText(keystore_path)
    keystore_password_id.setText(keystore_password)
    keystore_ailas_id.setText(keystore_ailas)
    keystore_ailas_password_id.setText(keystore_ailas_password)
    signature_algorithm_spinner.setSelection(int(spinner_selection))

    keystore_password_id.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
    keystore_ailas_password_id.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)

  end
  task(1000,function()
    pull.setRefreshing(false);
  end)
end

get_content()

pull.setColorSchemeColors({basic_color_num});
pull.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    get_content()
  end
})

memory_file_template=[[public_keystore_checked=%s
keystore_path="%s"
keystore_password="%s"
keystore_ailas="%s"
keystore_ailas_password="%s"
signature_algorithm="%s"
spinner_selection=%s]]

choose_button.onClick=function()
  choose_file_dialog.show()
end

check_box.onClick=function()
  if check_box.isChecked() then
    keystore_password_id.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
    keystore_ailas_password_id.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD)
   else
    keystore_password_id.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
    keystore_ailas_password_id.setInputType(InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_VARIATION_PASSWORD)
  end
end

save_button.onClick=function()
  local keystore_password=keystore_password_id.Text
  local keystore_ailas=keystore_ailas_id.Text
  local keystore_ailas_password=keystore_ailas_password_id.Text
  if keystore_password=="" or keystore_ailas=="" or keystore_ailas_password=="" then
    system_print(gets("input_nil"))
   else
    local save_content=string.format(memory_file_template,public_keystore_switch.isChecked(),keystore_path_id.Text,keystore_password,keystore_ailas,keystore_ailas_password,signature_algorithm,spinner_selection_value)
    io.open(memory_file_path,"w"):write(save_content):close()
    get_content()
    system_print(gets("save_succeed"))
  end
end