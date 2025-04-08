package com.luastudio.azure.adapter;

import android.annotation.*;
import android.content.*;
import android.content.res.*;
import android.graphics.*;
import android.graphics.drawable.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.view.animation.*;
import android.widget.*;

import androidx.recyclerview.widget.RecyclerView;

import com.androlua.*;
import com.luajava.*;
import java.io.*;
import java.lang.reflect.*;
import java.util.*;

public class LuaRecyclerViewAdapter extends RecyclerView.Adapter<LuaRecyclerViewAdapter.LuaViewHolder> implements Filterable {

	private LuaTable<Integer, LuaTable<String, Object>> mBaseData;
	private LuaTable<Integer, LuaTable<String, Object>> mData;
	private HashMap<String, Boolean> loaded = new HashMap<String, Boolean>();
	private HashMap<View, Boolean> mStyleCache = new HashMap<View, Boolean>();
	private HashMap<View, Animation> mAnimCache = new HashMap<View, Animation>();
	private LuaFunction<Animation> mAnimationUtil;
	private LuaTable<String, Object> mTheme;
	private LuaContext mContext;
	private LuaFunction<View> loadlayout;
	private LuaFunction<?> insert;
	private LuaFunction<?> remove;
	private LuaState L;
	private LuaTable mLayout;
	private Resources mRes;
	private BitmapDrawable mDraw;
	private boolean mNotifyOnChange = true;
	private ArrayFilter mFilter;
    private LuaFunction mLuaFilter;
	private boolean updateing;
	private CharSequence mPrefix;
	private Context activity;



    /**
     * 构造方法
     * 
     * @param 上下文,布局表
     *       
     */
	public LuaRecyclerViewAdapter(LuaContext context, LuaTable layout) throws LuaException {

        this(context, null, layout);
        
    }

    /**
     * 构造方法
     * 
     * @param 上下文,数据表,布局表
     *       
     */
	public LuaRecyclerViewAdapter(LuaContext context, LuaTable<Integer, LuaTable<String, Object>> data, LuaTable layout) throws LuaException {
		
        mContext = context;
        
		activity = (Context) mContext;
        
        mLayout = layout;
        
        mRes = mContext.getContext().getResources();
        
		mDraw = new BitmapDrawable(mRes, getClass().getResourceAsStream("/res/drawable/icon.png"));
        
        mDraw.setColorFilter(0x88ffffff, PorterDuff.Mode.SRC_ATOP);

		L = context.getLuaState();
        
		if (data == null)
            data = new LuaTable<Integer, LuaTable<String, Object>>(L);
            
        mData = data;
        
		mBaseData = mData;
        
        //获得loadlayout方法
		loadlayout = (LuaFunction<View>) L.getLuaObject("loadlayout").getFunction();
        
        insert = L.getLuaObject("table").getField("insert").getFunction();
        
        remove = L.getLuaObject("table").getField("remove").getFunction();
        
        L.newTable();
        
        //生成布局
		loadlayout.call(mLayout, L.getLuaObject(-1), ViewGroup.class);
        
		L.pop(1);
        
	}

    
    
    
	@Override
	public LuaViewHolder onCreateViewHolder(ViewGroup p1, int p2) {
		
        View view = null;
		
        LuaObject holder = null;
		
        try {
            
			L.newTable();
            
			holder = L.getLuaObject(-1);
            
			L.pop(1);
            
			view = loadlayout.call(mLayout, holder, ViewGroup.class);
            
		} catch (Exception e) {
            
			view = new View(mContext.getContext());
            
		}
        
		LuaTable<String, Object> hm = mData.get(p2 + 1);

        if (hm == null) {
            
            return new LuaViewHolder(view);
            
        }
        
		boolean bool = mStyleCache.get(view) == null;
        
        if (bool)
            mStyleCache.put(view, true);

        Set<Map.Entry<String, Object>> sets = hm.entrySet();
        
        for (Map.Entry<String, Object> entry : sets) {
            try {
                String key = entry.getKey();
                Object value = entry.getValue();
                LuaObject obj = holder.getField(key);
                if (obj.isJavaObject()) {
                    if (mTheme != null && bool) {
                        setHelper((View) obj.getObject(), mTheme.get(key));
                    }
                    setHelper((View) obj.getObject(), value);
                }
            } catch (Exception e) {
                Log.i("lua", e.getMessage());
            }
        }

        if (updateing) {
            return new LuaViewHolder(view);
        }

        if (mAnimationUtil != null && view != null) {
            Animation anim = mAnimCache.get(view);
            if (anim == null) {
                try {
                    anim = mAnimationUtil.call();
                    mAnimCache.put(view, anim);
                } catch (Exception e) {
                    mContext.sendError("setAnimation", e);
                }
            }
            if (anim != null) {
                view.clearAnimation();
                view.startAnimation(anim);
            }
        }

		return new LuaViewHolder(view);
	}

	@Override
	public void onBindViewHolder(LuaViewHolder p1, int p2) {
	}

	@Override
	public long getItemId(int position) {
		return position + 1;
	}

	@Override
	public int getItemViewType(int position) {
		return position;
	}

	@Override
	public int getItemCount() {
		return mData.length();
	}

	public LuaTable<Integer, LuaTable<String, Object>> getData() {
        return mData;
    }

	public void chageData() {
		super.notifyDataSetChanged();
        if (updateing == false) {
            updateing = true;
            new Handler().postDelayed(new Runnable() {
					@Override
					public void run() {
						updateing = false;
					}
				}, 500);
        }
    }

    public void add(LuaTable<String, Object> item) throws Exception {
        insert.call(mBaseData, item);
        if (mNotifyOnChange) notifyDataSetChanged();
    }

    public void addAll(LuaTable<Integer,LuaTable<String, Object>> items) throws Exception {
        int len=items.length();
        for (int i=1;i <= len;i++)
            insert.call(mBaseData, items.get(i));
        if (mNotifyOnChange) notifyDataSetChanged();
    }

    public void insert(int position, LuaTable<String, Object> item) throws Exception {
        insert.call(mBaseData, position + 1, item);
        if (mNotifyOnChange) chageData();
    }

    public void remove(int position) throws Exception {
        remove.call(mBaseData, position + 1);
        if (mNotifyOnChange) notifyDataSetChanged();
    }

    public void clear() {
        mBaseData.clear();
        if (mNotifyOnChange) notifyDataSetChanged();
    }

    public void setNotifyOnChange(boolean notifyOnChange) {
        mNotifyOnChange = notifyOnChange;
        if (mNotifyOnChange) notifyDataSetChanged();
    }

	public void setAnimation(LuaFunction<Animation> animation) {
        setAnimationUtil(animation);
    }

    public void setAnimationUtil(LuaFunction<Animation> animation) {
        mAnimCache.clear();
        mAnimationUtil = animation;
    }
	public void setStyle(LuaTable<String, Object> theme) {
        mStyleCache.clear();
        mTheme = theme;
    }

	private void setFields(View view, LuaTable<String, Object> fields) throws LuaException {
        Set<Map.Entry<String, Object>> sets = fields.entrySet();
        for (Map.Entry<String, Object> entry2 : sets) {
            String key2 = entry2.getKey();
            Object value2 = entry2.getValue();
            if (key2.toLowerCase().equals("src"))
                setHelper(view, value2);
            else
                javaSetter(view, key2, value2);

        }
    }

	private void setHelper(View view, Object value) {
        try {
            if (value instanceof LuaTable) {
                setFields(view, (LuaTable<String, Object>) value);
            } else if (view instanceof TextView) {
                if (value instanceof CharSequence)
                    ((TextView) view).setText((CharSequence) value);
                else
                    ((TextView) view).setText(value.toString());
            } else if (view instanceof ImageView) {
                if (value instanceof Bitmap)
                    ((ImageView) view).setImageBitmap((Bitmap) value);
                else if (value instanceof String)
                    ((ImageView) view).setImageDrawable(new AsyncLoader().getBitmap(mContext, (String) value));
                else if (value instanceof Drawable)
                    ((ImageView) view).setImageDrawable((Drawable) value);
                else if (value instanceof Number)
                    ((ImageView) view).setImageResource(((Number) value).intValue());
            }
        } catch (Exception e) {
            mContext.sendError("setHelper", e);
        }
    }
	private int javaSetter(Object obj, String methodName, Object value) throws LuaException {

        if (methodName.length() > 2 && methodName.substring(0, 2).equals("on") && value instanceof LuaFunction)
            return javaSetListener(obj, methodName, value);

        return javaSetMethod(obj, methodName, value);
    }

    private int javaSetListener(Object obj, String methodName, Object value) throws LuaException {
        String name = "setOn" + methodName.substring(2) + "Listener";
        ArrayList<Method> methods = LuaJavaAPI.getMethod(obj.getClass(), name, false);
        for (Method m : methods) {

            Class<?>[] tp = m.getParameterTypes();
            if (tp.length == 1 && tp[0].isInterface()) {
                L.newTable();
                L.pushObjectValue(value);
                L.setField(-2, methodName);
                try {
                    Object listener = L.getLuaObject(-1).createProxy(tp[0]);
                    m.invoke(obj, listener);
                    return 1;
                } catch (Exception e) {
                    throw new LuaException(e);
                }
            }
        }
        return 0;
    }

    private int javaSetMethod(Object obj, String methodName, Object value) throws LuaException {
        try {
			LuaFunction<View> checkValue = (LuaFunction<View>) L.getLuaObject("javaSetMethod").getFunction();
			checkValue.call(obj, methodName, value);
		} catch (Exception e) {
			throw new LuaException(e);
		}
		return 1;
    }

	private class AsyncLoader extends Thread {

        private String mPath;

        private LuaContext mContext;

        public Drawable getBitmap(LuaContext context, String path) throws IOException {
            // TODO: Implement this method
            mContext = context;
            mPath = path;
            if (!path.startsWith("http://"))
                return new BitmapDrawable(mRes, LuaBitmap.getBitmap(context, path));
            if (LuaBitmap.checkCache(context, path))
                return new BitmapDrawable(mRes, LuaBitmap.getBitmap(context, path));
            if (!loaded.containsKey(mPath)) {
                start();
                loaded.put(mPath, true);
            }

            return mDraw;
        }

        @Override
        public void run() {
            // TODO: Implement this method
            try {
                LuaBitmap.getBitmap(mContext, mPath);
                mHandler.sendEmptyMessage(0);
            } catch (Exception e) {
                mContext.sendError("AsyncLoader", e);
            }

        }
    }

	@SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == 0) {
                notifyDataSetChanged();
            } else {
                try {
                    LuaTable<Integer, LuaTable<String, Object>> newValues = new LuaTable<Integer, LuaTable<String, Object>>(mData.getLuaState());
                    mLuaFilter.call(mBaseData, newValues, mPrefix);
                    mData = newValues;
                    notifyDataSetChanged();
                } catch (Exception e) {
                    e.printStackTrace();
                    mContext.sendError("performFiltering", e);
                }
            }
        }

    };

	@Override
    public Filter getFilter() {
        if (mFilter == null) {
            mFilter = new ArrayFilter();
        }
        return mFilter;
    }

    public void filter(CharSequence constraint) {
        getFilter().filter(constraint);
    }

    public void setFilter(LuaFunction filter) {
        mLuaFilter = filter;
    }

	private class ArrayFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence prefix) {
            FilterResults results = new FilterResults();
            mPrefix = prefix;
            if (mData == null)
                return results;
            if (mLuaFilter != null) {
                mHandler.sendEmptyMessage(1);
				return null;
            }

            results.values = mData;
            results.count = mData.size();
            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            /*noinspection unchecked
			 mData = (LuaTable<Integer, LuaTable<String, Object>>) results.values;
			 if (results.count > 0) {
			 notifyDataSetChanged();
			 } else {
			 notifyDataSetInvalidated();
			 }*/
        }
    }

	class LuaViewHolder extends RecyclerView.ViewHolder {
		View ItemView;
		public LuaViewHolder(View view) {
			super(view);
			ItemView = view;
		}
	}

}

