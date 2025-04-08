package com.qflistudio.azure.ui.fragment.home

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.qflistudio.azure.adapter.ProjectListAdapter
import com.qflistudio.azure.base.BaseActivity
import com.qflistudio.azure.databinding.FragmentHomeFourthBinding
import com.qflistudio.azure.manager.EventManager

// 内层主页 第4页
class HomeCloudFragment : Fragment() {
    val TAG = "HomeFourthFragment"
    private var _binding: FragmentHomeFourthBinding? = null
    private val binding get() = _binding!!

    private lateinit var eventManager: EventManager

    override fun onAttach(context: Context) {
        super.onAttach(context)

        // 获取 MainActivity 中的 EventManager 实例
                eventManager = (requireActivity() as BaseActivity<*, *>).getEmInstance()

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.i(TAG, "onCreateView")
        // Inflate the layout for this fragment
        //val view = inflater.inflate(R.layout.fragment_home_fifth, container, false)
        _binding = FragmentHomeFourthBinding.inflate(inflater, container, false)
        var recyclerView = binding.cloudProjectsRvView.recyclerView
        return view
    }
}
