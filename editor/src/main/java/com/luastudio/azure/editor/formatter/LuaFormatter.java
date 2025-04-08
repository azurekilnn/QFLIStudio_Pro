package com.luastudio.azure.editor.formatter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.luastudio.azure.textwarrior.common.AutoIndent;

import io.github.rosemoe.sora.lang.format.Formatter;
import io.github.rosemoe.sora.text.Content;
import io.github.rosemoe.sora.text.TextRange;

public class LuaFormatter implements Formatter {
    private FormatResultReceiver receiver;

    public final static LuaFormatter INSTANCE = new LuaFormatter();

    @Override
    public void format(@NonNull Content text, @NonNull TextRange cursorRange) {
        CharSequence formattedText = AutoIndent.format(text, 2);
        this.receiver.onFormatSucceed(formattedText, cursorRange);
    }

    @Override
    public void formatRegion(@NonNull Content text, @NonNull TextRange rangeToFormat, @NonNull TextRange cursorRange) {
        CharSequence formattedText = AutoIndent.format(text, 2);
        this.receiver.
                onFormatSucceed(formattedText, cursorRange);
    }

    @Override
    public void setReceiver(@Nullable FormatResultReceiver receiver) {
        this.receiver = receiver;
    }

    @Override
    public boolean isRunning() {
        return false;
    }

    @Override
    public void destroy() {

    }
}