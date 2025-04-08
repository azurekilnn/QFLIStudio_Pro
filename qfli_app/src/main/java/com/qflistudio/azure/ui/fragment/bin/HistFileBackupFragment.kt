package com.qflistudio.azure.ui.fragment.bin

import android.os.Bundle
import android.view.View
import com.qflistudio.azure.base.BaseFileListFragment

class HistFileBackupFragment : BaseFileListFragment() {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        relativeDir = "auto_save"

        // 加载数据
        viewModel.binHistFileBackupList.observe(viewLifecycleOwner) { list ->
            updateList(list)
        }
    }
}
