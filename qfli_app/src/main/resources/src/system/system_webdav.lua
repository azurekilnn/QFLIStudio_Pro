import "system.webdav"
function load_webdav_config()
  local webdav_serve=activity.getSharedData("webdav_serve") or nil
  local webdav_user=activity.getSharedData("webdav_user") or nil
  local webdav_pass=activity.getSharedData("webdav_pass") or nil

  if webdav_user and webdav_pass and webdav_serve then
    project_webdav=WebDav()
    project_webdav.setServer(webdav_serve)
    project_webdav.setUser(webdav_user)
    project_webdav.setPass(webdav_pass)
  end
  webdav_status=true
end