package com.luastudio.azure.markwon;

import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.RequestBuilder;
import com.bumptech.glide.RequestManager;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import io.noties.markwon.image.AsyncDrawable;
import io.noties.markwon.image.glide.GlideImagesPlugin;

public class GifGlideStore implements GlideImagesPlugin.GlideStore {
    private final RequestManager requestManager;

    public GifGlideStore(RequestManager requestManager) {
        this.requestManager = requestManager;
    }

    @NonNull
    @Override
    public RequestBuilder<Drawable> load(@NonNull AsyncDrawable drawable) {
        // NB! Strange behaviour: First time a resource is requested - it fails, the next time it loads fine
        final String destination = drawable.getDestination();
        return requestManager
                // it is enough to call this (in order to load GIF and non-GIF)
                .asDrawable()
                .addListener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        // we must start GIF animation manually
                        if (resource instanceof Animatable) {
                            ((Animatable) resource).start();
                        }
                        return false;
                    }
                })
                .load(destination);
    }

    @Override
    public void cancel(@NonNull Target<?> target) {
        requestManager.clear(target);
    }
}