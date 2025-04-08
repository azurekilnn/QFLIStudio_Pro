package com.luastudio.azure.editor.textmate;

import androidx.annotation.NonNull;
import com.luastudio.azure.editor.formatter.LuaFormatter;
import org.eclipse.tm4e.core.grammar.IGrammar;
import org.eclipse.tm4e.languageconfiguration.internal.model.LanguageConfiguration;

import io.github.rosemoe.sora.lang.format.Formatter;
import io.github.rosemoe.sora.langs.textmate.TextMateLanguage;
import io.github.rosemoe.sora.langs.textmate.registry.GrammarRegistry;
import io.github.rosemoe.sora.langs.textmate.registry.ThemeRegistry;
import io.github.rosemoe.sora.langs.textmate.registry.model.GrammarDefinition;

public class LuaTextMateLanguage extends TextMateLanguage {
    public String TAG = "LuaTextMateLanguage";

    protected LuaTextMateLanguage(IGrammar grammar, LanguageConfiguration languageConfiguration, GrammarRegistry grammarRegistry, ThemeRegistry themeRegistry, boolean createIdentifiers) {
        super(grammar, languageConfiguration, grammarRegistry, themeRegistry, createIdentifiers);
    }

    public static LuaTextMateLanguage create(String languageScopeName, boolean autoCompleteEnabled) {
        return create(languageScopeName, GrammarRegistry.getInstance(), autoCompleteEnabled);
    }

    public static LuaTextMateLanguage create(String languageScopeName, GrammarRegistry grammarRegistry, boolean autoCompleteEnabled) {
        return create(languageScopeName, grammarRegistry, ThemeRegistry.getInstance(), autoCompleteEnabled);
    }

    public static LuaTextMateLanguage create(String languageScopeName, GrammarRegistry grammarRegistry, ThemeRegistry themeRegistry, boolean autoCompleteEnabled) {
        var grammar = grammarRegistry.findGrammar(languageScopeName);
        if (grammar == null) {
            throw new IllegalArgumentException(String.format("Language with %s scope name not found", grammarRegistry));
        }
        var languageConfiguration = grammarRegistry.findLanguageConfiguration(grammar.getScopeName());
        return new LuaTextMateLanguage(grammar, languageConfiguration, grammarRegistry, themeRegistry, autoCompleteEnabled);
    }

    public static LuaTextMateLanguage create(GrammarDefinition grammarDefinition, boolean autoCompleteEnabled) {
        return create(grammarDefinition, GrammarRegistry.getInstance(), autoCompleteEnabled);
    }

    public static LuaTextMateLanguage create(GrammarDefinition grammarDefinition, GrammarRegistry grammarRegistry, boolean autoCompleteEnabled) {
        return create(grammarDefinition, grammarRegistry, ThemeRegistry.getInstance(), autoCompleteEnabled);
    }

    public static LuaTextMateLanguage create(GrammarDefinition grammarDefinition, GrammarRegistry grammarRegistry, ThemeRegistry themeRegistry, boolean autoCompleteEnabled) {
        var grammar = grammarRegistry.loadGrammar(grammarDefinition);
        if (grammar == null) {
            throw new IllegalArgumentException(String.format("Language with %s scope name not found", grammarRegistry));
        }
        var languageConfiguration = grammarRegistry.findLanguageConfiguration(grammar.getScopeName());
        return new LuaTextMateLanguage(grammar, languageConfiguration, grammarRegistry, themeRegistry, autoCompleteEnabled);
    }

    @NonNull
    @Override
    public Formatter getFormatter() {
        return LuaFormatter.INSTANCE;
    }
}
