package com.luastudio.azure.adapter;

import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class LuaRecyclerAdapter extends RecyclerView.Adapter {
    AdapterCreator adapterCreator;

    public LuaRecyclerAdapter(AdapterCreator adapterCreator) {
        this.adapterCreator = adapterCreator;
    }

    @Override
    public int getItemCount() {
        return (int) this.adapterCreator.getItemCount();
    }

    @Override
    public int getItemViewType(int i) {
        return (int) this.adapterCreator.getItemViewType(i);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int i) {
        this.adapterCreator.onBindViewHolder(viewHolder, i);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        return this.adapterCreator.onCreateViewHolder(viewGroup, i);
    }
}