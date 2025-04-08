package com.luastudio.azure.adapter;

import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;

import java.util.List;

public class LuaBasePagerAdapter extends PagerAdapter {
     List<View> mViews;
     List<String> mTitles;

    public LuaBasePagerAdapter(List<View> views) {
        this.mViews = views;
    }
    public LuaBasePagerAdapter(List<View> views,List<String> titles) {
        this.mViews = views;
        this.mTitles = titles;

    }

    public List<View> getViews() {
        return mViews;
    }
    public List<String> getTitles() {
        return mTitles;
    }

    public void add(View view,String title) {
        this.mViews.add(view);
        this.mTitles.add(title);
        notifyDataSetChanged();
    }

    public void remove(int position) {
        this.mTitles.remove(position);
        this.mViews.remove(position);
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return mViews.size();
    }

    @NonNull
    public Object instantiateItem(@NonNull ViewGroup view_group, int i) {
        view_group.addView(mViews.get(i));
        return mViews.get(i);
    }

    public void destroyItem(@NonNull ViewGroup container, int i, @NonNull Object obj) {
        container.removeView((View)obj);
    }
    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view == object;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        // TODO Auto-generated method stub
        return mTitles.get(position);
    }
    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }
}
