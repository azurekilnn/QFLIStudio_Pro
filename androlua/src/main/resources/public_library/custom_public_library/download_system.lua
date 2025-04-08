module("download_system", package.seeall)
require "import"
import "android.content.Context"
import "android.net.Uri"

function new(system, download_url)
  system.url = download_url
  system.down = activity.getSystemService(Context.DOWNLOAD_SERVICE)
end

function create_download(system,path,file_name,return_id)
  local url=Uri.parse(system.url);
  request=DownloadManager.Request(url);
  request.setDestinationInExternalPublicDir(path,file_name);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  download_id=system.down.enqueue(request);
  return_id(download_id);
end

function download_information(system,download_id,return_information)
  ticker=Ticker()
  ticker.onTick = function()
    downloadManager=system.down
    manager_query=DownloadManager.Query()
    manager_query.setFilterById(long({download_id}))
    cursor=downloadManager.query(manager_query)
    if cursor.moveToFirst() then
      download_so_far = cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
      total_size = cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
      status = cursor.getInt(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS))
      func = ticker
      return_information(download_so_far,total_size,status,func)
    end
    cursor.close()
  end
  ticker.start()
end

function pause_download(system,download_id)
  downloadManager=system.down
  downloadManager.pauseDownload(long({download_id}))
end

function resume_download(system,download_id)
  downloadManager=system.down
  downloadManager.resumeDownload(long({download_id}))
end

function remove_download(system,download_id)
  downloadManager=system.down
  downloadManager.remove(long({download_id}))
end

function restart_download(system,download_id)
  downloadManager=system.down
  downloadManager.restartDownload(long({download_id}))
end