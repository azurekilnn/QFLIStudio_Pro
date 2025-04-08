package com.luastudio.azure.widget;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.app.Activity;
import android.app.Dialog;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.WindowManager;

public class MyBottomDialog extends Dialog {
    private Activity act;
    private float offsety,lasty,y,childHeight=0;
    private int height,width;
    private WindowManager.LayoutParams params;
    private boolean canclose,isbottom=true;
    private View CustomView;
    private float minHeight=0;
    private String title;

    public void setMinHeight(float mjnHeight) {
        this.minHeight = height-mjnHeight;
    }

    public float getMinHeight()
    {
        return minHeight;
    }

    public void setHeight(int height)
    {
        this.height = height;

        params = this.getWindow().getAttributes();
        params.width = this.width;
        params.height = this.height;
        this.getWindow().setAttributes(params);
    }

    @Override
    public void setCanceledOnTouchOutside(boolean cancel)
    {
        this.canclose = cancel;
        super.setCanceledOnTouchOutside(cancel);
    }



    public int getHeight()
    {

        return height;
    }

    public void setWidth(int width)
    {
        this.width = width;
        this.getWindow().getAttributes().width = width;

        params = this.getWindow().getAttributes();
        params.width = this.width;
        params.height = this.height;
        this.getWindow().setAttributes(params);

    }

    public float getWidth()
    {
        return width;
    }



    public void setGravity(int z) {
        this.getWindow().setGravity(z);
    }
    public void setTitle(String title1) {
        title = title1;
        super.setTitle(title);
    }
    public void setView(View view)
    {
        CustomView = view;
        super.setContentView(view);
    }

    private void ontouch()
    {
        this.getWindow().getDecorView().setOnTouchListener(new OnTouchListener(){
            @Override
            public boolean onTouch(View p1, MotionEvent motion_event)
            {

                switch (motion_event.getAction())
                {
                  case MotionEvent.ACTION_DOWN:
                        y = motion_event.getRawY();
                        offsety = y - lasty;
                        lasty = y;
                        break;
                    case MotionEvent.ACTION_MOVE:
                        y = motion_event.getRawY();
                        offsety = y - lasty;
                        if (p1.getY() + offsety >= 0 && act.getWindowManager().getDefaultDisplay().getHeight()- minHeight<act.getWindowManager().getDefaultDisplay().getHeight()-(p1.getY()+offsety))
                        {
                            p1.setY(p1.getY() + offsety);
                            isbottom=false;
                        }else if (p1.getY() + offsety >= 0 && act.getWindowManager().getDefaultDisplay().getHeight()- minHeight>=act.getWindowManager().getDefaultDisplay().getHeight()-(p1.getY()+offsety))
                        {
                            isbottom=true;
                        }




                        lasty = y;
                        break;
                    case MotionEvent.ACTION_UP:
                        if (canclose && motion_event.getY()<p1.getY()){
                            dismiss();
                            return true;
                        }

                        if (p1.getY() >= p1.getHeight() * 0.7 && isbottom==false)
                        {

                            MyBottomDialog.this.dismiss();

                        }
                        else if (p1.getY() <= p1.getHeight() * 0.7 && isbottom==false)

                        {
                            ObjectAnimator.ofFloat(p1, "y", new float[]{p1.getY(),0}).setDuration(200).start();
                        }

                        break;
                }
                return true;
            }

        });
    }


    private void d()
    {
        super.dismiss();
    }

    public void setView(int resid)
    {
        this.setView(LayoutInflater.from(act).inflate(resid, null, false));
    }

    private void showanim()
    {
        ObjectAnimator m= ObjectAnimator.ofFloat(this.getWindow().getDecorView(), "y", new float[]{act.getWindowManager().getDefaultDisplay().getHeight(),0})
                .setDuration(200);
        m.start();
    }

    private void closeanim()
    {
        ObjectAnimator zs= ObjectAnimator.ofFloat(this.getWindow().getDecorView(), "y", new float[]{this.getWindow().getDecorView().getY(),act.getWindowManager().getDefaultDisplay().getHeight()})
                .setDuration(200);
        zs.addListener(new AnimatorListenerAdapter(){
            public void onAnimationEnd(Animator m)
            {
                MyBottomDialog.this.d();
            }

        });
        zs.start();
    }

    public MyBottomDialog(Activity a)
    {
        super(a);
        act = a;
        ontouch();
        WindowManager.LayoutParams par=this.getWindow().getAttributes();
        par.height=act.getWindowManager().getDefaultDisplay().getHeight();
        this.getWindow().setAttributes(par);
        setGravity(Gravity.BOTTOM);
    }

    @Override
    public void show()
    {
        if (CustomView != null)
        {
            CustomView.post(new Runnable(){
                @Override
                public void run()
                {
                    MyBottomDialog.this.childHeight = MyBottomDialog.this.CustomView.getHeight();
                }

            });
        }
        super.show();
        showanim();
    }





    @Override
    public void dismiss()
    {
        closeanim();
    }



    public void setRadius(int a, int c)
    {
        GradientDrawable draw=new GradientDrawable();
        draw.setShape(GradientDrawable.RECTANGLE);
        draw.setColor(c);
        draw.setCornerRadii(new float[]{a,a,a,a,0,0,0,0});
        this.getWindow().setBackgroundDrawable(draw);

    }





}
