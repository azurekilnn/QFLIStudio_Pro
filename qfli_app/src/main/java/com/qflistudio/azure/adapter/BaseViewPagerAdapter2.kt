package com.qflistudio.azure.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter

class BaseViewPagerAdapter2(
    private val activity: FragmentActivity,
    private val fragmentList: List<Fragment> = emptyList(), // 提供默认值
    private val fragmentTitleList: List<Int> = emptyList() // 提供默认值
) : FragmentStateAdapter(activity) {

    override fun getItemCount(): Int {
        return fragmentList.size
    }

    override fun createFragment(position: Int): Fragment {
        return fragmentList[position]
    }


    fun getTitle(position: Int): String {
        // 使用 context.getString() 获取 R.string 中的字符串
        return activity.getString(fragmentTitleList[position])
    }
}