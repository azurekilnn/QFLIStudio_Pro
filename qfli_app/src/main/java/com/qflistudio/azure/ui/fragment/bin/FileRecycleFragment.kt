package com.qflistudio.azure.ui.fragment.bin

import android.os.Bundle
import android.view.View
import com.qflistudio.azure.base.BaseFileListFragment

// 内层 第1页
class FileRecycleFragment : BaseFileListFragment() {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        relativeDir = "bin"

        // 加载数据
        viewModel.binFileRecycleList.observe(viewLifecycleOwner) { list ->
            updateList(list)
        }
    }
}
