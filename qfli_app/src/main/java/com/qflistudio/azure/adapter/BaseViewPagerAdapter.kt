package com.qflistudio.azure.adapter

import android.content.Context
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentStatePagerAdapter

class BaseViewPagerAdapter(
    private val context: Context,
    fragmentManager: FragmentManager,
    private val fragmentList: List<Fragment>,
    private val fragmentTitleList: List<Int>  // 修改为 List<Int>，表示资源ID
) : FragmentStatePagerAdapter(fragmentManager, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT) {

    override fun getItem(position: Int): Fragment {
        return fragmentList[position]
    }

    override fun getCount(): Int {
        return fragmentList.size
    }

    override fun getPageTitle(position: Int): CharSequence? {
        // 使用 context.getString() 获取 R.string 中的字符串
        return context.getString(fragmentTitleList[position])
    }
}
