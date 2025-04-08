package com.luastudio.azure.adapter;

import android.view.ViewGroup;
import androidx.recyclerview.widget.RecyclerView;

public interface AdapterCreator {
    long getItemCount();
    long getItemViewType(int i);
    void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int i);
    RecyclerView.ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i);
}