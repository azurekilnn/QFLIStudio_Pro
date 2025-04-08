package com.luastudio.azure;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.TranslateAnimation;
import android.widget.AbsListView;
import android.widget.ListView;

/**
 * ElasticScrollView有弹性的ListView
 */
public class ElasticListView extends ListView {
    private float y;
    private Rect normal = new Rect();
    private boolean animationFinish = true;

    public ElasticListView(Context context) {
        super(context);
        init();
    }

    public ElasticListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    protected void onScrollChanged(int l, int t, int oldl, int oldt) {

    }

    boolean overScrolled = false;
    private void init() {
        setOnScrollListener(new OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                overScrolled = false;
            }
        });
    }

    @Override
    protected void onOverScrolled(int scrollX, int scrollY, boolean clampedX, boolean clampedY) {
        overScrolled = true;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        commOnTouchEvent(ev);
        return super.onTouchEvent(ev);
    }

    public void commOnTouchEvent(MotionEvent ev) {
        if (animationFinish) {
            int action = ev.getAction();
            switch (action) {
                case MotionEvent.ACTION_DOWN:
                    y = ev.getY();
                    break;
                case MotionEvent.ACTION_UP:
                    y = 0;
                    if (isNeedAnimation()) {
                        animation();
                    }
                    break;
                case MotionEvent.ACTION_MOVE:
                    final float preY = y == 0 ? ev.getY() : y;
                    float nowY = ev.getY();
                    int deltaY = (int) (preY - nowY);

                    y = nowY;
                    // 当滚动到最上或者最下时就不会再滚动，这时移动布局
                    if (isNeedMove(deltaY)) {
                        if (normal.isEmpty()) {
                            // 保存正常的布局位置
                            normal.set(getLeft(), getTop(), getRight(), getBottom());
                        }
                        // 移动布局
                        layout(getLeft(), getTop() - deltaY / 2, getRight(), getBottom() - deltaY / 2);
                    }
                    break;
                default:
                    break;
            }
        }
    }

    // 开启动画移动
    public void animation() {
        // 开启移动动画
        TranslateAnimation ta = new TranslateAnimation(0, 0, 0, normal.top - getTop());
        ta.setDuration(200);
        ta.setAnimationListener(new AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                animationFinish = false;

            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                clearAnimation();
                // 设置回到正常的布局位置
                layout(normal.left, normal.top, normal.right, normal.bottom);
                normal.setEmpty();
                animationFinish = true;
            }
        });
        startAnimation(ta);
    }

    // 是否需要开启动画
    public boolean isNeedAnimation() {
        return !normal.isEmpty();
    }

    // 是否需要移动布局
    public boolean isNeedMove(float deltaY) {
        if (overScrolled && getChildCount() > 0) {
            if (getLastVisiblePosition() == getCount() - 1 && deltaY > 0) {
                return true;
            }
            if (getFirstVisiblePosition() == 0 && deltaY < 0) {
                return true;
            }
        }
        return false;
    }
}