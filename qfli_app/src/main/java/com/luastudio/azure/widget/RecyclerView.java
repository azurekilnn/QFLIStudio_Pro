package com.luastudio.azure.widget;

import android.content.Context;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LayoutAnimationController;

import androidx.annotation.NonNull;

import com.qflistudio.azure.R;

public class RecyclerView extends androidx.recyclerview.widget.RecyclerView {

    public RecyclerView(@NonNull Context context) {
        super(context);
        initRecyclerViewAnim(this);
    }

    public void initRecyclerViewAnim(androidx.recyclerview.widget.RecyclerView recyclerView, int resID) {
        Animation animation = AnimationUtils.loadAnimation(getContext(), resID);
        LayoutAnimationController layoutAnimationController = new LayoutAnimationController(animation);
        layoutAnimationController.setOrder(LayoutAnimationController.ORDER_NORMAL);
        layoutAnimationController.setDelay(0.2f);
        recyclerView.setLayoutAnimation(layoutAnimationController);
    }

    public void initRecyclerViewAnim(androidx.recyclerview.widget.RecyclerView recyclerView){
        initRecyclerViewAnim(recyclerView, R.anim.anim_recyclerview);
    }

}
