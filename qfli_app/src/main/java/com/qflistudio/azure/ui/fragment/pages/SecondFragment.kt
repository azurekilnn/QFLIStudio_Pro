//HomeFragment
package com.qflistudio.azure.ui.fragment.pages

// 外层主页第二页 LuaStudio

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayoutMediator
import com.qflistudio.azure.R
import com.qflistudio.azure.adapter.BaseViewPagerAdapter2
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.databinding.FragmentMainSecondBinding
import com.qflistudio.azure.manager.SettingsManager
import com.qflistudio.azure.ui.fragment.home.HomeCFragment
import com.qflistudio.azure.ui.fragment.home.HomeCloudFragment
import com.qflistudio.azure.ui.fragment.home.HomeCppFragment
import com.qflistudio.azure.ui.fragment.home.HomeFifthFragment
import com.qflistudio.azure.ui.fragment.home.HomeFirstFragment
import com.qflistudio.azure.ui.fragment.home.HomeJavaFragment
import com.qflistudio.azure.ui.fragment.home.HomePyFragment
import com.qflistudio.azure.ui.fragment.home.HomeSecondFragment
import com.qflistudio.azure.ui.fragment.home.HomeThirdFragment
import com.qflistudio.azure.util.ProjectUtils
import com.qflistudio.azure.viewmodel.MainViewModel

class SecondFragment : Fragment() {
    // 定义 ViewBinding 对象
    private var _binding: FragmentMainSecondBinding? = null
    private val binding get() = _binding!!
    private lateinit var mainViewModel: MainViewModel
    private lateinit var settingsManager: SettingsManager

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // 使用 ViewBinding 来绑定视图
        _binding = FragmentMainSecondBinding.inflate(inflater, container, false)
        // 获取 ViewModel
        mainViewModel = ViewModelProvider(requireActivity()).get(MainViewModel::class.java)
        settingsManager = (requireActivity() as BaseActivity<*, *>).getSmInstance()

        setupHomeViewPager()
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null  // 防止内存泄漏
    }

    // 初始化和设置 homeViewPager 适配器
    private fun setupHomeViewPager() {
        // 定义内层的 Fragment 和标题列表
        val fragments = listOf(
            HomeFirstFragment(),
            HomeJavaFragment(),
            HomePyFragment(),
            HomeCFragment(),
            HomeCppFragment(),
            HomeSecondFragment(),
            HomeThirdFragment(),
            HomeCloudFragment(),
            HomeFifthFragment()
        )

        val titles = listOf(
            R.string.local_lua_projects,
            R.string.local_java_projects,
            R.string.local_py_projects,
            R.string.local_c_projects,
            R.string.local_cpp_projects,
            R.string.error_project_text,
            R.string.collected_project_text,
            R.string.cloud_projects,
            R.string.apk_list
        )

        // 创建 ViewPager 适配器
        val homeViewPagerAdapter = BaseViewPagerAdapter2(requireActivity(), fragments, titles)

        // 绑定适配器到 ViewPager
        val homeViewPager = binding.homeViewPager
        homeViewPager.adapter = homeViewPagerAdapter
        //homeViewPager.setUserInputEnabled(false)

        // 绑定 ViewPager 到 TabLayout
        // binding.homeTabLayout.setupWithViewPager(binding.homeViewPager)
        // 绑定 ViewPager2 到 TabLayout
        TabLayoutMediator(binding.homeTabLayout, homeViewPager) { tab, position ->
            tab.text = homeViewPagerAdapter.getTitle(position)
        }.attach()

        homeViewPager.registerOnPageChangeCallback(object :
            ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)
                val autoRefreshProjList =
                    settingsManager.getSetting("autoRefreshProjList") as Boolean
                if (autoRefreshProjList) {
                    mainViewModel.setListRefreshStatus(true)
                }
            }
        })

        mainViewModel.reloadProjectType.observe(viewLifecycleOwner) { projectType ->
            ProjectUtils().reloadLocalProjectsList(requireContext(), mainViewModel, projectType)
        }

    }

}
