package com.qflistudio.azure.adapter

import android.annotation.SuppressLint
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.qflistudio.azure.R
import com.qflistudio.azure.common.ktx.setImage

class HorizontalImageAdapter(private val context: Context) :
    RecyclerView.Adapter<HorizontalImageAdapter.ViewHolder>() {
    private var imagesList: MutableList<String> = mutableListOf()

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val imgView: ImageView = view.findViewById(R.id.card_imgv)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_imgv_card, parent, false)
        return ViewHolder(view)
    }

    @SuppressLint("SetTextI18n")
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val imgUrl = imagesList[position]
        holder.imgView.setImage(imgUrl, context)
        // 跳转到编辑器
        holder.imgView.setOnClickListener {
        }

    }

    override fun getItemCount(): Int = imagesList.size

    @SuppressLint("NotifyDataSetChanged")
    fun clear() {
        imagesList.clear()
        notifyDataSetChanged()
    }

    fun addItem(imgUrl: String) {
        imagesList.add(imgUrl)
        notifyItemInserted(imagesList.size - 1)
    }

}
