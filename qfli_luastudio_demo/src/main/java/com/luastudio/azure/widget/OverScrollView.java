package com.luastudio.azure.widget;

/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.FocusFinder;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.animation.AnimationUtils;
import android.view.animation.OvershootInterpolator;
import android.widget.FrameLayout;
import android.widget.Scroller;
import android.view.View.OnTouchListener;

import java.lang.reflect.Field;
import java.util.List;


/*
 * Layout container for a view hierarchy that can be scrolled by the user,
 * allowing it to be larger than the physical display. A ScrollView is a
 * {@link FrameLayout}, meaning you should place one child in it containing the
 * entire contents to scroll; this child may itself be a layout manager with a
 * complex hierarchy of objects. A child that is often used is a
 * {@link LinearLayout} in a vertical orientation, presenting a vertical array
 * of top-level items that the user can scroll through.
 *
 * <p>
 * The {@link TextView} class also takes care of its own scrolling, so does not
 * require a ScrollView, but using the two together is possible to achieve the
 * effect of a text view within a larger container.
 *
 * <p>
 * ScrollView only supports vertical scrolling.
 */
public class OverScrollView extends FrameLayout implements OnTouchListener
{
    private static final String TAG = OverScrollView.class.getName();
    static final int ANIMATED_SCROLL_GAP = 250;

    static final float MAX_SCROLL_FACTOR = 0.5f;
    private static final float SCROLL_RATIO = 0.3f;// 阻尼系数
    static final float OVERSHOOT_TENSION = 0.75f;

    private long mLastScroll;

    private final Rect mTempRect = new Rect();
    private Scroller mScroller;

    protected Context mContext;

    Field mScrollYField;
    Field mScrollXField;

    boolean hasFailedObtainingScrollFields;
    int prevScrollY;
    boolean isInFlingMode = false;

    DisplayMetrics metrics;
    LayoutInflater inflater;
    protected View child;

    private Runnable overScrollerSpringbackTask;

    /**
     * Flag to indicate that we are moving focus ourselves. This is so the code
     * that watches for focus changes initiated outside this ScrollView knows
     * that it does not have to do anything.
     */
    private boolean mScrollViewMovedFocus;

    /**
     * Position of the last motion event.
     */
    private float mLastMotionY;

    /**
     * True when the layout has changed but the traversal has not come through
     * yet. Ideally the view hierarchy would keep track of this for us.
     */
    private boolean mIsLayoutDirty = true;

    /**
     * The child to give focus to in the event that a child has requested focus
     * while the layout is dirty. This prevents the scroll from being wrong if
     * the child has not been laid out before requesting focus.
     */
    private View mChildToScrollTo = null;

    /**
     * True if the user is currently dragging this ScrollView around. This is
     * not the same as 'is being flinged', which can be checked by
     * mScroller.isFinished() (flinging begins when the user lifts his finger).
     */
    private boolean mIsBeingDragged = false;

    /**
     * Determines speed during touch scrolling
     */
    private VelocityTracker mVelocityTracker;

    /**
     * When set to true, the scroll view measure its child to make it fill the
     * currently visible area.
     */
    private boolean mFillViewport;

    /**
     * Whether arrow scrolling is animated.
     */
    private boolean mSmoothScrollingEnabled = true;

    private int mTouchSlop;
    private int mMinimumVelocity;
    private int mMaximumVelocity;

    /**
     * ID of the active pointer. This is used to retain consistency during
     * drags/flings if multiple pointers are used.
     */
    private int mActivePointerId = INVALID_POINTER;

    /**
     * Sentinel value for no current active pointer. Used by
     * {@link #mActivePointerId}.
     */
    private static final int INVALID_POINTER = -1;

    public OverScrollView(Context context)
    {
        this(context, null);
        mContext = context;
        initBounce();
    }

    public OverScrollView(Context context, AttributeSet attrs)
    {

        this(context, attrs, 0);
        mContext = context;
        initBounce();
    }

    public OverScrollView(Context context, AttributeSet attrs, int defStyle)
    {
        super(context, attrs, defStyle);
        mContext = context;

        initScrollView();
        setFillViewport(true);
        initBounce();
    }

    private void initBounce()
    {
        metrics = this.mContext.getResources().getDisplayMetrics();

        // init the bouncy scroller, and make sure the layout is being drawn
        // after the top padding
        mScroller = new Scroller(getContext(), new OvershootInterpolator(OVERSHOOT_TENSION));
        overScrollerSpringbackTask = new Runnable()
        {
            @Override
            public void run()
            {
                // scroll till after the padding
                mScroller.computeScrollOffset();
                scrollTo(0, mScroller.getCurrY());

                if (!mScroller.isFinished())
                {
                    post(this);
                }
            }
        };
        prevScrollY = getPaddingTop();

        try
        {
            mScrollXField = View.class.getDeclaredField("mScrollX");
            mScrollYField = View.class.getDeclaredField("mScrollY");

        } catch (Exception e)
        {
            hasFailedObtainingScrollFields = true;
        }
    }

    private void SetScrollY(int value)
    {
        if (mScrollYField != null)
        {
            try
            {
                mScrollYField.setInt(this, value);
            } catch (Exception e)
            {
            }
        }
    }

    private void SetScrollX(int value)
    {
        if (mScrollXField != null)
        {
            try
            {
                mScrollXField.setInt(this, value);
            } catch (Exception e)
            {
            }
        }
    }

    public void initChildPointer()
    {
        Log.i(TAG,"initChildPointer");
        child = getChildAt(0);
        child.setPadding(0, 1500, 0, 1500);

    }

    @Override
    protected float getTopFadingEdgeStrength()
    {
        if (getChildCount() == 0)
        {
            return 0.0f;
        }

        final int length = getVerticalFadingEdgeLength();
        if (getScrollY() < length)
        {
            return getScrollY() / (float) length;
        }

        return 1.0f;
    }

    @Override
    protected float getBottomFadingEdgeStrength()
    {
        if (getChildCount() == 0)
        {
            return 0.0f;
        }

        final int length = getVerticalFadingEdgeLength();
        final int bottomEdge = getHeight() - getPaddingBottom();
        final int span = getChildAt(0).getBottom() - getScrollY() - bottomEdge;
        if (span < length)
        {
            return span / (float) length;
        }

        return 1.0f;
    }

    /**
     * @return The maximum amount this scroll view will scroll in response to an
     *         arrow event.
     */
    public int getMaxScrollAmount()
    {
        return (int) (MAX_SCROLL_FACTOR * (getBottom() - getTop()));
    }

    private void initScrollView()
    {
        mScroller = new Scroller(getContext());
        setFocusable(true);
        setDescendantFocusability(FOCUS_AFTER_DESCENDANTS);
        setWillNotDraw(false);
        final ViewConfiguration configuration = ViewConfiguration.get(mContext);
        mTouchSlop = configuration.getScaledTouchSlop();
        mMinimumVelocity = configuration.getScaledMinimumFlingVelocity();
        mMaximumVelocity = configuration.getScaledMaximumFlingVelocity();

        setOnTouchListener(this);

        post(new Runnable()
        {
            public void run()
            {
                scrollTo(0, child.getPaddingTop());
            }
        });
    }

    @Override
    public void addView(View child)
    {
        if (getChildCount() > 0)
        {
            throw new IllegalStateException("ScrollView can host only one direct child");
        }

        super.addView(child);
        initChildPointer();
    }

    @Override
    public void addView(View child, int index)
    {
        if (getChildCount() > 0)
        {
            throw new IllegalStateException("ScrollView can host only one direct child");
        }

        super.addView(child, index);
        initChildPointer();
    }

    @Override
    public void addView(View child, ViewGroup.LayoutParams params)
    {
        if (getChildCount() > 0)
        {
            throw new IllegalStateException("ScrollView can host only one direct child");
        }

        super.addView(child, params);
        initChildPointer();
    }

    @Override
    public void addView(View child, int index, ViewGroup.LayoutParams params)
    {
        if (getChildCount() > 0)
        {
            throw new IllegalStateException("ScrollView can host only one direct child");
        }

        super.addView(child, index, params);
    }

    /**
     * @return Returns true this ScrollView can be scrolled
     */
    private boolean canScroll()
    {
        View child = getChildAt(0);
        if (child != null)
        {
            int childHeight = child.getHeight();
            return getHeight() < childHeight + getPaddingTop() + getPaddingBottom();
        }
        return false;
    }

    /**
     * Indicates whether this ScrollView's content is stretched to fill the
     * viewport.
     *
     * @return True if the content fills the viewport, false otherwise.
     */
    public boolean isFillViewport()
    {
        return mFillViewport;
    }

    /**
     * Indicates this ScrollView whether it should stretch its content height to
     * fill the viewport or not.
     *
     * @param fillViewport
     *            True to stretch the content's height to the viewport's
     *            boundaries, false otherwise.
     */
    public void setFillViewport(boolean fillViewport)
    {
        if (fillViewport != mFillViewport)
        {
            mFillViewport = fillViewport;
            requestLayout();
        }
    }

    /**
     * @return Whether arrow scrolling will animate its transition.
     */
    public boolean isSmoothScrollingEnabled()
    {
        return mSmoothScrollingEnabled;
    }

    /**
     * Set whether arrow scrolling will animate its transition.
     *
     * @param smoothScrollingEnabled
     *            whether arrow scrolling will animate its transition
     */
    public void setSmoothScrollingEnabled(boolean smoothScrollingEnabled)
    {
        mSmoothScrollingEnabled = smoothScrollingEnabled;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec)
    {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        if (!mFillViewport)
        {
            return;
        }

        final int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        if (heightMode == MeasureSpec.UNSPECIFIED)
        {
            return;
        }

        if (getChildCount() > 0)
        {
            final View child = getChildAt(0);
            int height = getMeasuredHeight();
            if (child.getMeasuredHeight() < height)
            {
                final FrameLayout.LayoutParams lp = (LayoutParams) child.getLayoutParams();

                int childWidthMeasureSpec = getChildMeasureSpec(widthMeasureSpec, getPaddingLeft() + getPaddingRight(), lp.width);
                height -= getPaddingTop();
                height -= getPaddingBottom();
                int childHeightMeasureSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);

                child.measure(childWidthMeasureSpec, childHeightMeasureSpec);
            }
        }
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event)
    {
        // Let the focused view and/or our descendants get the key first
        return super.dispatchKeyEvent(event) || executeKeyEvent(event);
    }

    /**
     * You can call this function yourself to have the scroll view perform
     * scrolling from a key event, just as if the event had been dispatched to
     * it by the view hierarchy.
     *
     * @param event
     *            The key event to execute.
     * @return Return true if the event was handled, else false.
     */
    public boolean executeKeyEvent(KeyEvent event)
    {
        mTempRect.setEmpty();

        if (!canScroll())
        {
            if (isFocused() && event.getKeyCode() != KeyEvent.KEYCODE_BACK)
            {
                View currentFocused = findFocus();
                if (currentFocused == this)
                    currentFocused = null;
                View nextFocused = FocusFinder.getInstance().findNextFocus(this, currentFocused, View.FOCUS_DOWN);
                return nextFocused != null && nextFocused != this && nextFocused.requestFocus(View.FOCUS_DOWN);
            }
            return false;
        }

        boolean handled = false;
        if (event.getAction() == KeyEvent.ACTION_DOWN)
        {
            switch (event.getKeyCode())
            {
                case KeyEvent.KEYCODE_DPAD_UP:
                    if (!event.isAltPressed())
                    {
                        handled = arrowScroll(View.FOCUS_UP);
                    } else
                    {
                        handled = fullScroll(View.FOCUS_UP);
                    }
                    break;
                case KeyEvent.KEYCODE_DPAD_DOWN:
                    if (!event.isAltPressed())
                    {
                        handled = arrowScroll(View.FOCUS_DOWN);
                    } else
                    {
                        handled = fullScroll(View.FOCUS_DOWN);
                    }
                    break;
                case KeyEvent.KEYCODE_SPACE:
                    pageScroll(event.isShiftPressed() ? View.FOCUS_UP : View.FOCUS_DOWN);
                    break;
            }
        }

        return handled;
    }

    public boolean inChild(int x, int y)
    {
        if (getChildCount() > 0)
        {
            final int scrollY = getScrollY();
            final View child = getChildAt(0);
            return !(y < child.getTop() - scrollY || y >= child.getBottom() - scrollY || x < child.getLeft() || x >= child.getRight());
        }
        return false;
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev)
    {
        /*
         * This method JUST determines whether we want to intercept the motion.
         * If we return true, onMotionEvent will be called and we do the actual
         * scrolling there.
         */

        /*
         * Shortcut the most recurring case: the user is in the dragging state
         * and he is moving his finger. We want to intercept this motion.
         */
        final int action = ev.getAction();
        if ((action == MotionEvent.ACTION_MOVE) && (mIsBeingDragged))
        {
            return true;
        }

        switch (action & MotionEvent.ACTION_MASK)
        {
            case MotionEvent.ACTION_MOVE:
            {
                /*
                 * mIsBeingDragged == false, otherwise the shortcut would have
                 * caught it. Check whether the user has moved far enough from his
                 * original down touch.
                 */

                /*
                 * Locally do absolute value. mLastMotionY is set to the y value of
                 * the down event.
                 */
                final int activePointerId = mActivePointerId;
                if (activePointerId == INVALID_POINTER)
                {
                    // If we don't have a valid id, the touch down wasn't on
                    // content.
                    break;
                }

                final int pointerIndex = ev.findPointerIndex(activePointerId);
                final float y = ev.getY(pointerIndex);
                final int yDiff = (int) Math.abs(y - mLastMotionY);
                if (yDiff > mTouchSlop)
                {
                    mIsBeingDragged = true;
                    mLastMotionY = y;
                }
                break;
            }

            case MotionEvent.ACTION_DOWN:
            {
                final float y = ev.getY();
                if (!inChild((int) ev.getX(), (int) y))
                {
                    mIsBeingDragged = false;
                    break;
                }

                /*
                 * Remember location of down touch. ACTION_DOWN always refers to
                 * pointer index 0.
                 */
                mLastMotionY = y;
                mActivePointerId = ev.getPointerId(0);

                /*
                 * If being flinged and user touches the screen, initiate drag;
                 * otherwise don't. mScroller.isFinished should be false when being
                 * flinged.
                 */
                mIsBeingDragged = !mScroller.isFinished();
                break;
            }

            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                /* Release the drag */
                mIsBeingDragged = false;
                mActivePointerId = INVALID_POINTER;
                break;
            case MotionEvent.ACTION_POINTER_UP:
                onSecondaryPointerUp(ev);
                break;
        }

        /*
         * The only time we want to intercept motion events is if we are in the
         * drag mode.
         */
        return mIsBeingDragged;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev)
    {

        if (ev.getAction() == MotionEvent.ACTION_DOWN && ev.getEdgeFlags() != 0)
        {
            // Don't handle edge touches immediately -- they may actually belong
            // to one of our
            // descendants.
            return false;
        }

        if (mVelocityTracker == null)
        {
            mVelocityTracker = VelocityTracker.obtain();
        }
        mVelocityTracker.addMovement(ev);

        final int action = ev.getAction();

        switch (action & MotionEvent.ACTION_MASK)
        {
            case MotionEvent.ACTION_DOWN:
            {
                final float y = ev.getY();
                if (!(mIsBeingDragged = inChild((int) ev.getX(), (int) y)))
                {
                    return false;
                }

                /*
                 * If being flinged and user touches, stop the fling. isFinished
                 * will be false if being flinged.
                 */
                if (!mScroller.isFinished())
                {
                    mScroller.abortAnimation();
                }

                // Remember where the motion event started
                mLastMotionY = y;
                mActivePointerId = ev.getPointerId(0);
                break;
            }
            case MotionEvent.ACTION_MOVE:
                if (mIsBeingDragged)
                {
                    // Scroll to follow the motion event
                    final int activePointerIndex = ev.findPointerIndex(mActivePointerId);
                    final float y = ev.getY(activePointerIndex);
                    final int deltaY = (int) (mLastMotionY - y);
                    mLastMotionY = y;

                    if (isOverScrolled())
                    {
                        // when overscrolling, move the scroller just half of the
                        // finger movement, to make it feel like a spring...
                        scrollBy(0,(int)(deltaY * SCROLL_RATIO));
                    } else
                    {
                        scrollBy(0, deltaY);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                if (mIsBeingDragged)
                {
                    final VelocityTracker velocityTracker = mVelocityTracker;
                    velocityTracker.computeCurrentVelocity(1000, mMaximumVelocity);
                    int initialVelocity = (int) velocityTracker.getYVelocity(mActivePointerId);

                    if (getChildCount() > 0 && Math.abs(initialVelocity) > mMinimumVelocity)
                    {
                        fling(-initialVelocity);
                    }

                    mActivePointerId = INVALID_POINTER;
                    mIsBeingDragged = false;

                    if (mVelocityTracker != null)
                    {
                        mVelocityTracker.recycle();
                        mVelocityTracker = null;
                    }
                }
                break;
            case MotionEvent.ACTION_CANCEL:
                if (mIsBeingDragged && getChildCount() > 0)
                {
                    mActivePointerId = INVALID_POINTER;
                    mIsBeingDragged = false;
                    if (mVelocityTracker != null)
                    {
                        mVelocityTracker.recycle();
                        mVelocityTracker = null;
                    }
                }
                break;
            case MotionEvent.ACTION_POINTER_UP:
                onSecondaryPointerUp(ev);
                break;
        }
        return true;
    }

    public boolean isOverScrolled()
    {
        return (getScrollY() < child.getPaddingTop() || getScrollY() > child.getBottom() - child.getPaddingBottom() - getHeight());
    }

    private void onSecondaryPointerUp(MotionEvent ev)
    {
        final int pointerIndex = (ev.getAction() & MotionEvent.ACTION_POINTER_INDEX_MASK) >> MotionEvent.ACTION_POINTER_INDEX_SHIFT;
        final int pointerId = ev.getPointerId(pointerIndex);
        if (pointerId == mActivePointerId)
        {
            // This was our active pointer going up. Choose a new
            // active pointer and adjust accordingly.
            // TODO: Make this decision more intelligent.
            final int newPointerIndex = pointerIndex == 0 ? 1 : 0;
            mLastMotionY = ev.getY(newPointerIndex);
            mActivePointerId = ev.getPointerId(newPointerIndex);
            if (mVelocityTracker != null)
            {
                mVelocityTracker.clear();
            }
        }
    }

    /**
     * <p>
     * Finds the next focusable component that fits in this View's bounds
     * (excluding fading edges) pretending that this View's top is located at
     * the parameter top.
     * </p>
     *
     * @param topFocus
     *            look for a candidate is the one at the top of the bounds if
     *            topFocus is true, or at the bottom of the bounds if topFocus
     *            is false
     * @param top
     *            the top offset of the bounds in which a focusable must be
     *            found (the fading edge is assumed to start at this position)
     * @param preferredFocusable
     *            the View that has highest priority and will be returned if it
     *            is within my bounds (null is valid)
     * @return the next focusable component in the bounds or null if none can be
     *         found
     */
    private View findFocusableViewInMyBounds(final boolean topFocus, final int top, View preferredFocusable)
    {
        /*
         * The fading edge's transparent side should be considered for focus
         * since it's mostly visible, so we divide the actual fading edge length
         * by 2.
         */
        final int fadingEdgeLength = getVerticalFadingEdgeLength() / 2;
        final int topWithoutFadingEdge = top + fadingEdgeLength;
        final int bottomWithoutFadingEdge = top + getHeight() - fadingEdgeLength;

        if ((preferredFocusable != null) && (preferredFocusable.getTop() < bottomWithoutFadingEdge)
                && (preferredFocusable.getBottom() > topWithoutFadingEdge))
        {
            return preferredFocusable;
        }

        return findFocusableViewInBounds(topFocus, topWithoutFadingEdge, bottomWithoutFadingEdge);
    }

    /**
     * <p>
     * Finds the next focusable component that fits in the specified bounds.
     * </p>
     *
     * @param topFocus
     *            look for a candidate is the one at the top of the bounds if
     *            topFocus is true, or at the bottom of the bounds if topFocus
     *            is false
     * @param top
     *            the top offset of the bounds in which a focusable must be
     *            found
     * @param bottom
     *            the bottom offset of the bounds in which a focusable must be
     *            found
     * @return the next focusable component in the bounds or null if none can be
     *         found
     */
    private View findFocusableViewInBounds(boolean topFocus, int top, int bottom)
    {

        List<View> focusables = getFocusables(View.FOCUS_FORWARD);
        View focusCandidate = null;

        /*
         * A fully contained focusable is one where its top is below the bound's
         * top, and its bottom is above the bound's bottom. A partially
         * contained focusable is one where some part of it is within the
         * bounds, but it also has some part that is not within bounds. A fully
         * contained focusable is preferred to a partially contained focusable.
         */
        boolean foundFullyContainedFocusable = false;

        int count = focusables.size();
        for (int i = 0; i < count; i++)
        {
            View view = focusables.get(i);
            int viewTop = view.getTop();
            int viewBottom = view.getBottom();

            if (top < viewBottom && viewTop < bottom)
            {
                /*
                 * the focusable is in the target area, it is a candidate for
                 * focusing
                 */

                final boolean viewIsFullyContained = (top < viewTop) && (viewBottom < bottom);

                if (focusCandidate == null)
                {
                    /* No candidate, take this one */
                    focusCandidate = view;
                    foundFullyContainedFocusable = viewIsFullyContained;
                } else
                {
                    final boolean viewIsCloserToBoundary = (topFocus && viewTop < focusCandidate.getTop())
                            || (!topFocus && viewBottom > focusCandidate.getBottom());

                    if (foundFullyContainedFocusable)
                    {
                        if (viewIsFullyContained && viewIsCloserToBoundary)
                        {
                            /*
                             * We're dealing with only fully contained views, so
                             * it has to be closer to the boundary to beat our
                             * candidate
                             */
                            focusCandidate = view;
                        }
                    } else
                    {
                        if (viewIsFullyContained)
                        {
                            /*
                             * Any fully contained view beats a partially
                             * contained view
                             */
                            focusCandidate = view;
                            foundFullyContainedFocusable = true;
                        } else if (viewIsCloserToBoundary)
                        {
                            /*
                             * Partially contained view beats another partially
                             * contained view if it's closer
                             */
                            focusCandidate = view;
                        }
                    }
                }
            }
        }

        return focusCandidate;
    }

    /**
     * <p>
     * Handles scrolling in response to a "page up/down" shortcut press. This
     * method will scroll the view by one page up or down and give the focus to
     * the topmost/bottommost component in the new visible area. If no component
     * is a good candidate for focus, this scrollview reclaims the focus.
     * </p>
     *
     * @param direction
     *            the scroll direction: {@link android.view.View#FOCUS_UP} to go
     *            one page up or {@link android.view.View#FOCUS_DOWN} to go one
     *            page down
     * @return true if the key event is consumed by this method, false otherwise
     */
    public boolean pageScroll(int direction)
    {
        boolean down = direction == View.FOCUS_DOWN;
        int height = getHeight();

        if (down)
        {
            mTempRect.top = getScrollY() + height;
            int count = getChildCount();
            if (count > 0)
            {
                View view = getChildAt(count - 1);
                if (mTempRect.top + height > view.getBottom())
                {
                    mTempRect.top = view.getBottom() - height;
                }
            }
        } else
        {
            mTempRect.top = getScrollY() - height;
            if (mTempRect.top < 0)
            {
                mTempRect.top = 0;
            }
        }
        mTempRect.bottom = mTempRect.top + height;

        return scrollAndFocus(direction, mTempRect.top, mTempRect.bottom);
    }

    /**
     * <p>
     * Handles scrolling in response to a "home/end" shortcut press. This method
     * will scroll the view to the top or bottom and give the focus to the
     * topmost/bottommost component in the new visible area. If no component is
     * a good candidate for focus, this scrollview reclaims the focus.
     * </p>
     *
     * @param direction
     *            the scroll direction: {@link android.view.View#FOCUS_UP} to go
     *            the top of the view or {@link android.view.View#FOCUS_DOWN} to
     *            go the bottom
     * @return true if the key event is consumed by this method, false otherwise
     */
    public boolean fullScroll(int direction)
    {
        boolean down = direction == View.FOCUS_DOWN;
        int height = getHeight();

        mTempRect.top = 0;
        mTempRect.bottom = height;

        if (down)
        {
            int count = getChildCount();
            if (count > 0)
            {
                View view = getChildAt(count - 1);
                mTempRect.bottom = view.getBottom();
                mTempRect.top = mTempRect.bottom - height;
            }
        }

        return scrollAndFocus(direction, mTempRect.top, mTempRect.bottom);
    }

    /**
     * <p>
     * Scrolls the view to make the area defined by <code>top</code> and
     * <code>bottom</code> visible. This method attempts to give the focus to a
     * component visible in this area. If no component can be focused in the new
     * visible area, the focus is reclaimed by this scrollview.
     * </p>
     *
     * @param direction
     *            the scroll direction: {@link android.view.View#FOCUS_UP} to go
     *            upward {@link android.view.View#FOCUS_DOWN} to downward
     * @param top
     *            the top offset of the new area to be made visible
     * @param bottom
     *            the bottom offset of the new area to be made visible
     * @return true if the key event is consumed by this method, false otherwise
     */
    private boolean scrollAndFocus(int direction, int top, int bottom)
    {
        boolean handled = true;

        int height = getHeight();
        int containerTop = getScrollY();
        int containerBottom = containerTop + height;
        boolean up = direction == View.FOCUS_UP;

        View newFocused = findFocusableViewInBounds(up, top, bottom);
        if (newFocused == null)
        {
            newFocused = this;
        }

        if (top >= containerTop && bottom <= containerBottom)
        {
            handled = false;
        } else
        {
            int delta = up ? (top - containerTop) : (bottom - containerBottom);
            doScrollY(delta);
        }

        if (newFocused != findFocus() && newFocused.requestFocus(direction))
        {
            mScrollViewMovedFocus = true;
            mScrollViewMovedFocus = false;
        }

        return handled;
    }

    /**
     * Handle scrolling in response to an up or down arrow click.
     *
     * @param direction
     *            The direction corresponding to the arrow key that was pressed
     * @return True if we consumed the event, false otherwise
     */
    public boolean arrowScroll(int direction)
    {

        View currentFocused = findFocus();
        if (currentFocused == this)
            currentFocused = null;

        View nextFocused = FocusFinder.getInstance().findNextFocus(this, currentFocused, direction);

        final int maxJump = getMaxScrollAmount();

        if (nextFocused != null && isWithinDeltaOfScreen(nextFocused, maxJump, getHeight()))
        {
            nextFocused.getDrawingRect(mTempRect);
            offsetDescendantRectToMyCoords(nextFocused, mTempRect);
            int scrollDelta = computeScrollDeltaToGetChildRectOnScreen(mTempRect);
            doScrollY(scrollDelta);
            nextFocused.requestFocus(direction);
        } else
        {
            // no new focus
            int scrollDelta = maxJump;

            if (direction == View.FOCUS_UP && getScrollY() < scrollDelta)
            {
                scrollDelta = getScrollY();
            } else if (direction == View.FOCUS_DOWN)
            {
                if (getChildCount() > 0)
                {
                    int daBottom = getChildAt(0).getBottom();

                    int screenBottom = getScrollY() + getHeight();

                    if (daBottom - screenBottom < maxJump)
                    {
                        scrollDelta = daBottom - screenBottom;
                    }
                }
            }
            if (scrollDelta == 0)
            {
                return false;
            }
            doScrollY(direction == View.FOCUS_DOWN ? scrollDelta : -scrollDelta);
        }

        if (currentFocused != null && currentFocused.isFocused() && isOffScreen(currentFocused))
        {
            // previously focused item still has focus and is off screen, give
            // it up (take it back to ourselves)
            // (also, need to temporarily force FOCUS_BEFORE_DESCENDANTS so we
            // are
            // sure to
            // get it)
            final int descendantFocusability = getDescendantFocusability(); // save
            setDescendantFocusability(ViewGroup.FOCUS_BEFORE_DESCENDANTS);
            requestFocus();
            setDescendantFocusability(descendantFocusability); // restore
        }
        return true;
    }

    /**
     * @return whether the descendant of this scroll view is scrolled off
     *         screen.
     */
    private boolean isOffScreen(View descendant)
    {
        return !isWithinDeltaOfScreen(descendant, 0, getHeight());
    }

    /**
     * @return whether the descendant of this scroll view is within delta pixels
     *         of being on the screen.
     */
    private boolean isWithinDeltaOfScreen(View descendant, int delta, int height)
    {
        descendant.getDrawingRect(mTempRect);
        offsetDescendantRectToMyCoords(descendant, mTempRect);

        return (mTempRect.bottom + delta) >= getScrollY() && (mTempRect.top - delta) <= (getScrollY() + height);
    }

    /**
     * Smooth scroll by a Y delta
     *
     * @param delta
     *            the number of pixels to scroll by on the Y axis
     */
    private void doScrollY(int delta)
    {
        if (delta != 0)
        {
            if (mSmoothScrollingEnabled)
            {
                smoothScrollBy(0, delta);
            } else
            {
                scrollBy(0, delta);
            }
        }
    }

    /**
     * Like {@link View#scrollBy}, but scroll smoothly instead of immediately.
     *
     * @param dx
     *            the number of pixels to scroll by on the X axis
     * @param dy
     *            the number of pixels to scroll by on the Y axis
     */
    public final void smoothScrollBy(int dx, int dy)
    {
        if (getChildCount() == 0)
        {
            // Nothing to do.
            return;
        }
        long duration = AnimationUtils.currentAnimationTimeMillis() - mLastScroll;
        if (duration > ANIMATED_SCROLL_GAP)
        {
            final int height = getHeight() - getPaddingBottom() - getPaddingTop();
            final int bottom = getChildAt(0).getHeight();
            final int maxY = Math.max(0, bottom - height);
            final int scrollY = getScrollY();
            dy = Math.max(0, Math.min(scrollY + dy, maxY)) - scrollY;

            mScroller.startScroll(getScrollX(), scrollY, 0, dy);
            invalidate();
        } else
        {
            if (!mScroller.isFinished())
            {
                mScroller.abortAnimation();
            }
            scrollBy(dx, dy);
        }
        mLastScroll = AnimationUtils.currentAnimationTimeMillis();
    }

    public final void smoothScrollToTop()
    {
        smoothScrollTo(0, child.getPaddingTop());
    }

    public final void smoothScrollToBottom()
    {
        smoothScrollTo(0, child.getHeight() - child.getPaddingTop() - getHeight());
    }

    /**
     * Like {@link #scrollTo}, but scroll smoothly instead of immediately.
     *
     * @param x
     *            the position where to scroll on the X axis
     * @param y
     *            the position where to scroll on the Y axis
     */
    public final void smoothScrollTo(int x, int y)
    {
        smoothScrollBy(x - getScrollX(), y - getScrollY());
    }

    /**
     * <p>
     * The scroll range of a scroll view is the overall height of all of its
     * children.
     * </p>
     */
    @Override
    protected int computeVerticalScrollRange()
    {
        final int count = getChildCount();
        final int contentHeight = getHeight() - getPaddingBottom() - getPaddingTop();
        if (count == 0)
        {
            return contentHeight;
        }

        return getChildAt(0).getBottom();
    }

    @Override
    protected int computeVerticalScrollOffset()
    {
        return Math.max(0, super.computeVerticalScrollOffset());
    }

    @Override
    protected void measureChild(View child, int parentWidthMeasureSpec, int parentHeightMeasureSpec)
    {
        ViewGroup.LayoutParams lp = child.getLayoutParams();

        int childWidthMeasureSpec;
        int childHeightMeasureSpec;

        childWidthMeasureSpec = getChildMeasureSpec(parentWidthMeasureSpec, getPaddingLeft() + getPaddingRight(), lp.width);

        childHeightMeasureSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

        child.measure(childWidthMeasureSpec, childHeightMeasureSpec);
    }

    @Override
    protected void measureChildWithMargins(View child, int parentWidthMeasureSpec, int widthUsed, int parentHeightMeasureSpec,
                                           int heightUsed)
    {
        final MarginLayoutParams lp = (MarginLayoutParams) child.getLayoutParams();

        final int childWidthMeasureSpec = getChildMeasureSpec(parentWidthMeasureSpec, getPaddingLeft() + getPaddingRight() + lp.leftMargin
                + lp.rightMargin + widthUsed, lp.width);
        final int childHeightMeasureSpec = MeasureSpec.makeMeasureSpec(lp.topMargin + lp.bottomMargin, MeasureSpec.UNSPECIFIED);

        child.measure(childWidthMeasureSpec, childHeightMeasureSpec);
    }

    @Override
    public void computeScroll()
    {
        // If android implementation has changed and we cannot obtain mScrollY -
        // The default behavior will be applied by the parent.
        if (hasFailedObtainingScrollFields)
        {
            super.computeScroll();
            return;
        }

        if (mScroller.computeScrollOffset())
        {
            // This is called at drawing time by ViewGroup. We don't want to
            // re-show the scrollbars at this point, which scrollTo will do,
            // so we replicate most of scrollTo here.
            //
            // It's a little odd to call onScrollChanged from inside the
            // drawing.
            //
            // It is, except when you remember that computeScroll() is used to
            // animate scrolling. So unless we want to defer the
            // onScrollChanged()
            // until the end of the animated scrolling, we don't really have a
            // choice here.
            //
            // I agree. The alternative, which I think would be worse, is to
            // post
            // something and tell the subclasses later. This is bad because
            // there
            // will be a window where getScrollX()/Y is different from what the
            // app
            // thinks it is.
            //
            int oldX = getScrollX();
            int oldY = getScrollY();
            int x = mScroller.getCurrX();
            int y = mScroller.getCurrY();

            if (getChildCount() > 0)
            {
                View child = getChildAt(0);
                x = clamp(x, getWidth() - getPaddingRight() - getPaddingLeft(), child.getWidth());
                y = clamp(y, getHeight() - getPaddingBottom() - getPaddingTop(), child.getHeight());
                if (x != oldX || y != oldY)
                {
                    SetScrollX(x);
                    // mScrollX = x;
                    SetScrollY(y);
                    // mScrollY = y;
                    onScrollChanged(x, y, oldX, oldY);
                }
            }
            awakenScrollBars();

            // Keep on drawing until the animation has finished.
            postInvalidate();
        }
    }

    /**
     * Scrolls the view to the given child.
     *
     * @param child
     *            the View to scroll to
     */
    private void scrollToChild(View child)
    {
        child.getDrawingRect(mTempRect);

        /* Offset from child's local coordinates to ScrollView coordinates */
        offsetDescendantRectToMyCoords(child, mTempRect);

        int scrollDelta = computeScrollDeltaToGetChildRectOnScreen(mTempRect);

        if (scrollDelta != 0)
        {
            scrollBy(0, scrollDelta);
        }
    }

    /**
     * If rect is off screen, scroll just enough to get it (or at least the
     * first screen size chunk of it) on screen.
     *
     * @param rect
     *            The rectangle.
     * @param immediate
     *            True to scroll immediately without animation
     * @return true if scrolling was performed
     */
    private boolean scrollToChildRect(Rect rect, boolean immediate)
    {
        final int delta = computeScrollDeltaToGetChildRectOnScreen(rect);
        final boolean scroll = delta != 0;
        if (scroll)
        {
            if (immediate)
            {
                scrollBy(0, delta);
            } else
            {
                smoothScrollBy(0, delta);
            }
        }
        return scroll;
    }

    /**
     * Compute the amount to scroll in the Y direction in order to get a
     * rectangle completely on the screen (or, if taller than the screen, at
     * least the first screen size chunk of it).
     *
     * @param rect
     *            The rect.
     * @return The scroll delta.
     */
    protected int computeScrollDeltaToGetChildRectOnScreen(Rect rect)
    {
        if (getChildCount() == 0)
            return 0;

        int height = getHeight();
        int screenTop = getScrollY();
        int screenBottom = screenTop + height;

        int fadingEdge = getVerticalFadingEdgeLength();

        // leave room for top fading edge as long as rect isn't at very top
        if (rect.top > 0)
        {
            screenTop += fadingEdge;
        }

        // leave room for bottom fading edge as long as rect isn't at very
        // bottom
        if (rect.bottom < getChildAt(0).getHeight())
        {
            screenBottom -= fadingEdge;
        }

        int scrollYDelta = 0;

        if (rect.bottom > screenBottom && rect.top > screenTop)
        {
            // need to move down to get it in view: move down just enough so
            // that the entire rectangle is in view (or at least the first
            // screen size chunk).

            if (rect.height() > height)
            {
                // just enough to get screen size chunk on
                scrollYDelta += (rect.top - screenTop);
            } else
            {
                // get entire rect at bottom of screen
                scrollYDelta += (rect.bottom - screenBottom);
            }

            // make sure we aren't scrolling beyond the end of our content
            int bottom = getChildAt(0).getBottom();
            int distanceToBottom = bottom - screenBottom;
            scrollYDelta = Math.min(scrollYDelta, distanceToBottom);

        } else if (rect.top < screenTop && rect.bottom < screenBottom)
        {
            // need to move up to get it in view: move up just enough so that
            // entire rectangle is in view (or at least the first screen
            // size chunk of it).

            if (rect.height() > height)
            {
                // screen size chunk
                scrollYDelta -= (screenBottom - rect.bottom);
            } else
            {
                // entire rect at top
                scrollYDelta -= (screenTop - rect.top);
            }

            // make sure we aren't scrolling any further than the top our
            // content
            scrollYDelta = Math.max(scrollYDelta, -getScrollY());
        }
        return scrollYDelta;
    }

    @Override
    public void requestChildFocus(View child, View focused)
    {
        if (!mScrollViewMovedFocus)
        {
            if (!mIsLayoutDirty)
            {
                scrollToChild(focused);
            } else
            {
                // The child may not be laid out yet, we can't compute the
                // scroll yet
                mChildToScrollTo = focused;
            }
        }
        super.requestChildFocus(child, focused);
    }

    /**
     * When looking for focus in children of a scroll view, need to be a little
     * more careful not to give focus to something that is scrolled off screen.
     *
     * This is more expensive than the default {@link android.view.ViewGroup}
     * implementation, otherwise this behavior might have been made the default.
     */
    @Override
    protected boolean onRequestFocusInDescendants(int direction, Rect previouslyFocusedRect)
    {

        // convert from forward / backward notation to up / down / left / right
        // (ugh).
        if (direction == View.FOCUS_FORWARD)
        {
            direction = View.FOCUS_DOWN;
        } else if (direction == View.FOCUS_BACKWARD)
        {
            direction = View.FOCUS_UP;
        }

        final View nextFocus = previouslyFocusedRect == null ? FocusFinder.getInstance().findNextFocus(this, null, direction) : FocusFinder
                .getInstance().findNextFocusFromRect(this, previouslyFocusedRect, direction);

        if (nextFocus == null)
        {
            return false;
        }

        if (isOffScreen(nextFocus))
        {
            return false;
        }

        return nextFocus.requestFocus(direction, previouslyFocusedRect);
    }

    @Override
    public boolean requestChildRectangleOnScreen(View child, Rect rectangle, boolean immediate)
    {
        // offset into coordinate space of this scroll view
        rectangle.offset(child.getLeft() - child.getScrollX(), child.getTop() - child.getScrollY());

        return scrollToChildRect(rectangle, immediate);
    }

    @Override
    public void requestLayout()
    {
        mIsLayoutDirty = true;
        super.requestLayout();
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b)
    {
        super.onLayout(changed, l, t, r, b);
        mIsLayoutDirty = false;
        // Give a child focus if it needs it
        if (mChildToScrollTo != null && isViewDescendantOf(mChildToScrollTo, this))
        {
            scrollToChild(mChildToScrollTo);
        }
        mChildToScrollTo = null;

        // Calling this with the present values causes it to re-clam them
        scrollTo(getScrollX(), getScrollY());
        post(new Runnable()
        {
            public void run()
            {
                scrollTo(0, child.getPaddingTop());
            }
        });
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh)
    {
        super.onSizeChanged(w, h, oldw, oldh);

        View currentFocused = findFocus();
        if (null == currentFocused || this == currentFocused)
            return;

        // If the currently-focused view was visible on the screen when the
        // screen was at the old height, then scroll the screen to make that
        // view visible with the new screen height.
        if (isWithinDeltaOfScreen(currentFocused, 0, oldh))
        {
            currentFocused.getDrawingRect(mTempRect);
            offsetDescendantRectToMyCoords(currentFocused, mTempRect);
            int scrollDelta = computeScrollDeltaToGetChildRectOnScreen(mTempRect);
            doScrollY(scrollDelta);
        }
    }

    @Override
    protected void onScrollChanged(int leftOfVisibleView, int topOfVisibleView, int oldLeftOfVisibleView, int oldTopOfVisibleView)
    {
        int displayHeight = getHeight();
        int paddingTop = child.getPaddingTop();
        int contentBottom = child.getHeight() - child.getPaddingBottom();

        if (isInFlingMode)
        {

            if (topOfVisibleView < paddingTop || topOfVisibleView > contentBottom - displayHeight)
            {
                if (topOfVisibleView < paddingTop)
                {
                    mScroller.startScroll(0, topOfVisibleView, 0, paddingTop - topOfVisibleView, 1000);
                } else if (topOfVisibleView > contentBottom - displayHeight)
                {
                    mScroller.startScroll(0, topOfVisibleView, 0, contentBottom - displayHeight - topOfVisibleView, 1000);
                }

                // Start animation.
                post(overScrollerSpringbackTask);
                isInFlingMode = false;
                return;

            }
        }
        super.onScrollChanged(leftOfVisibleView, topOfVisibleView, oldLeftOfVisibleView, oldTopOfVisibleView);
    }

    /**
     * Return true if child is an descendant of parent, (or equal to the
     * parent).
     */
    private boolean isViewDescendantOf(View child, View parent)
    {
        if (child == parent)
        {
            return true;
        }

        final ViewParent theParent = child.getParent();
        return (theParent instanceof ViewGroup) && isViewDescendantOf((View) theParent, parent);
    }

    /**
     * Fling the scroll view
     *
     * @param velocityY
     *            The initial velocity in the Y direction. Positive numbers mean
     *            that the finger/cursor is moving down the screen, which means
     *            we want to scroll towards the top.
     */
    public void fling(int velocityY)
    {
        if (getChildCount() > 0)
        {
            int height = getHeight() - getPaddingBottom() - getPaddingTop();
            int bottom = getChildAt(0).getHeight();

            mScroller.fling(getScrollX(), getScrollY(), 0, velocityY, 0, 0, 0, Math.max(0, bottom - height));

            final boolean movingDown = velocityY > 0;

            View newFocused = findFocusableViewInMyBounds(movingDown, mScroller.getFinalY(), findFocus());
            if (newFocused == null)
            {
                newFocused = this;
            }

            if (newFocused != findFocus() && newFocused.requestFocus(movingDown ? View.FOCUS_DOWN : View.FOCUS_UP))
            {
                mScrollViewMovedFocus = true;
                mScrollViewMovedFocus = false;
            }

            invalidate();
        }
    }

    /**
     * {@inheritDoc}
     *
     * <p>
     * This version also clamps the scrolling to the bounds of our child.
     */
    @Override
    public void scrollTo(int x, int y)
    {
        // we rely on the fact the View.scrollBy calls scrollTo.
        if (getChildCount() > 0)
        {
            View child = getChildAt(0);
            x = clamp(x, getWidth() - getPaddingRight() - getPaddingLeft(), child.getWidth());
            y = clamp(y, getHeight() - getPaddingBottom() - getPaddingTop(), child.getHeight());
            if (x != getScrollX() || y != getScrollY())
            {
                super.scrollTo(x, y);
            }
        }
    }

    private int clamp(int n, int my, int child)
    {
        if (my >= child || n < 0)
        {
            /*
             * my >= child is this case: |--------------- me ---------------|
             * |------ child ------| or |--------------- me ---------------|
             * |------ child ------| or |--------------- me ---------------|
             * |------ child ------|
             *
             * n < 0 is this case: |------ me ------| |-------- child --------|
             * |-- getScrollX() --|
             */
            return 0;
        }
        if ((my + n) > child)
        {
            /*
             * this case: |------ me ------| |------ child ------| |--
             * getScrollX() --|
             */
            return child - my;
        }
        return n;
    }

    @Override
    public boolean onTouch(View v, MotionEvent event)
    {
        // Stop scrolling calculation.
        mScroller.forceFinished(true);
        // Stop scrolling animation.
        removeCallbacks(overScrollerSpringbackTask);

        if (event.getAction() == MotionEvent.ACTION_UP)
        {
            return overScrollView();
        }

        else if (event.getAction() == MotionEvent.ACTION_CANCEL)
        {
            return overScrollView();
        }

        return false;
    }

    private boolean overScrollView()
    {

        // The height of scroll view, in pixels
        int displayHeight = getHeight();
        Log.i(TAG , "displayHeight = "+displayHeight);
        // The top of content view, in pixels.
        int contentTop = child.getPaddingTop();
        // The top of content view, in pixels.
        int contentBottom = child.getHeight() - child.getPaddingBottom();
        // The scrolled top position of scroll view, in pixels.
        int currScrollY = getScrollY();
        Log.i(TAG , "currScrollY = "+currScrollY);
        Log.i(TAG , "contentTop = "+contentTop);
        int scrollBy;

        // Scroll to content top
        if (currScrollY < contentTop)
        {

            onOverScroll(currScrollY);
            scrollBy = contentTop - currScrollY;
        } else if (currScrollY + displayHeight > contentBottom)
        {
            // Scroll to content top
            if (child.getHeight() - child.getPaddingTop() - child.getPaddingBottom() < displayHeight)
            {

                scrollBy = contentTop - currScrollY;
            }
            // Scroll to content bottom
            else
            {

                scrollBy = contentBottom - displayHeight - currScrollY;
                // Log.d(Definitions.LOG_TAG, "scrollBy=" + scrollBy);
            }

            // fire onOverScroll event, and update scrollBy if a loadingView has
            // been added to the scroller.
            scrollBy += onOverScroll(currScrollY);
        }
        // scrolling between the contentTop and contentBottom
        else
        {
            isInFlingMode = true;
            return false;
        }
        mScroller.startScroll(0, currScrollY, 0, scrollBy, 500);

        // Start animation.
        post(overScrollerSpringbackTask);

        prevScrollY = currScrollY;

        // consume(to stop fling)
        return true;

    }

    protected int onOverScroll(int scrollY)
    {
        return 0;
    }

}