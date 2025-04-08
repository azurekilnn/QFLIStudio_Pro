package com.qflistudio.azure.ui.fragment.bin

import android.os.Bundle
import android.view.View
import com.qflistudio.azure.base.BaseFileListFragment

class FormatFileBackupFragment : BaseFileListFragment() {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        relativeDir = "format_file"

        // 加载数据
        viewModel.binFormatFileBackupList.observe(viewLifecycleOwner) { list ->
            updateList(list)
        }
    }
}
