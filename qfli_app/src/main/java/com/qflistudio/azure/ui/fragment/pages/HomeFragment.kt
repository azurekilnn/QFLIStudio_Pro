// HomeFragment
package com.qflistudio.azure.ui.fragment.pages

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.qflistudio.azure.R
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.databinding.FragmentMainFirstBinding
import com.qflistudio.azure.viewmodel.MainViewModel

import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayoutMediator
import com.qflistudio.azure.adapter.BaseViewPagerAdapter2
import com.qflistudio.azure.manager.SettingsManager
import com.qflistudio.azure.ui.fragment.home.HomeCFragment
import com.qflistudio.azure.ui.fragment.home.HomeCloudFragment
import com.qflistudio.azure.ui.fragment.home.HomeCppFragment
import com.qflistudio.azure.ui.fragment.home.HomeFifthFragment
import com.qflistudio.azure.ui.fragment.home.HomeFirstFragment
import com.qflistudio.azure.ui.fragment.home.HomePyFragment
import com.qflistudio.azure.ui.fragment.home.HomeSecondFragment
import com.qflistudio.azure.ui.fragment.home.HomeThirdFragment
import com.qflistudio.azure.ui.fragment.main.MainCloudListFragment
import com.qflistudio.azure.ui.fragment.main.MainFragment

class HomeFragment : Fragment() {
    // 定义 ViewBinding 对象
    private var _binding: FragmentMainFirstBinding? = null
    private val binding get() = _binding!!
    private lateinit var mainViewModel: MainViewModel
    private lateinit var settingsManager: SettingsManager

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // 使用 ViewBinding 来绑定视图
        _binding = FragmentMainFirstBinding.inflate(inflater, container, false)
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
            MainFragment(),
            MainCloudListFragment(),
        )

        val titles = listOf(
            R.string.home,
            R.string.cloud_text,
        )

        // 创建 ViewPager 适配器
        val homeViewPagerAdapter = BaseViewPagerAdapter2(requireActivity(), fragments, titles)

        // 绑定适配器到 ViewPager
        val homeViewPager = binding.mainViewPager
        homeViewPager.adapter = homeViewPagerAdapter

        // 绑定 ViewPager2 到 TabLayout
        TabLayoutMediator(binding.mainTabLayout, homeViewPager) { tab, position ->
            tab.text = homeViewPagerAdapter.getTitle(position)
        }.attach()

        homeViewPager.registerOnPageChangeCallback(object :
            ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)

            }
        })

    }

}








