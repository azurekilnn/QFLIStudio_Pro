package com.qflistudio.azure.ui.fragment.pages

import FileListItem
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.tabs.TabLayoutMediator
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.BaseViewPagerAdapter
import com.qflistudio.azure.adapter.BaseViewPagerAdapter2
import com.qflistudio.azure.databinding.FragmentMainThirdBinding
import com.qflistudio.azure.ui.fragment.components.PluginFragment
import com.qflistudio.azure.ui.fragment.components.SysCpeFragment
import com.qflistudio.azure.ui.fragment.components.SysToolFragment
import java.io.File

// 外层主页 第3页
class ThirdFragment : Fragment() {
    // 定义 ViewBinding 对象
    private var _binding: FragmentMainThirdBinding? = null
    private val binding get() = _binding!!
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // 使用 ViewBinding 来绑定视图
        _binding = FragmentMainThirdBinding.inflate(inflater, container, false)

        //val rootPath = "/storage/emulated/0/"
        //val rootFolder = File(rootPath)
        //val fileItems = loadFileTree(rootFolder)

        //binding.recyclerView.adapter = FileListAdapter(fileItems)
        // 初始化功能页面
        initModeViewPager()
        return binding.root
    }

    private fun loadFileTree(folder: File): List<FileListItem> {
        val items = mutableListOf<FileListItem>()
        folder.listFiles()?.forEach { file ->
            val children = if (file.isDirectory) loadFileTree(file) else emptyList()
            items.add(FileListItem(file.name, file.isDirectory, children))
        }
        return items
    }

    fun initModeViewPager() {
        val modeFragments = listOf(
            SysCpeFragment(),
            PluginFragment(),
            SysToolFragment(),
        )
        val modeTitles = listOf(
            R.string.system_component,
            R.string.plugin,
            R.string.configuration_tools,
        )
        // 创建 ViewPager 适配器
        val modeViewPagerAdapter = BaseViewPagerAdapter2(requireActivity(), modeFragments, modeTitles)
        // 绑定适配器到 ViewPager
        binding.modeViewPager.adapter = modeViewPagerAdapter
        // 绑定 ViewPager2 到 TabLayout
        TabLayoutMediator(binding.modeTabLayout, binding.modeViewPager) { tab, position ->
            tab.text = modeViewPagerAdapter.getTitle(position)
        }.attach()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null  // 防止内存泄漏
    }

}