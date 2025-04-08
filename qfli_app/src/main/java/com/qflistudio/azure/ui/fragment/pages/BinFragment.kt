package com.qflistudio.azure.ui.fragment.pages

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.google.android.material.tabs.TabLayoutMediator
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.BaseViewPagerAdapter2
import com.qflistudio.azure.databinding.FragmentMainFourthBinding
import com.qflistudio.azure.ui.fragment.bin.FileRecycleFragment
import com.qflistudio.azure.ui.fragment.bin.FormatFileBackupFragment
import com.qflistudio.azure.ui.fragment.bin.HistFileBackupFragment

// 外层主页第四页
class BinFragment : Fragment() {
    // 定义 ViewBinding 对象
    private var _binding: FragmentMainFourthBinding? = null
    private val binding get() = _binding!!
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // 使用 ViewBinding 来绑定视图
        _binding = FragmentMainFourthBinding.inflate(inflater, container, false)

        //val rootPath = "/storage/emulated/0/"
        //val rootFolder = File(rootPath)
        //val fileItems = loadFileTree(rootFolder)

        //binding.recyclerView.adapter = FileListAdapter(fileItems)
        // 初始化功能页面
        initModeViewPager()
        return binding.root
    }


    fun initModeViewPager() {
        val modeFragments = listOf(
            FileRecycleFragment(),
            HistFileBackupFragment(),
            FormatFileBackupFragment(),
        )
        val binTitles = listOf(
            R.string.file_recycle_bin_text,
            R.string.historical_file_backup_text,
            R.string.format_backup_text,
        )
        // 创建 ViewPager 适配器
        val modeViewPagerAdapter = BaseViewPagerAdapter2(requireActivity(), modeFragments, binTitles)
        // 绑定适配器到 ViewPager
        binding.binViewPager.adapter = modeViewPagerAdapter
        // 绑定 ViewPager2 到 TabLayout
        TabLayoutMediator(binding.binTabLayout, binding.binViewPager) { tab, position ->
            tab.text = modeViewPagerAdapter.getTitle(position)
        }.attach()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null  // 防止内存泄漏
    }

}