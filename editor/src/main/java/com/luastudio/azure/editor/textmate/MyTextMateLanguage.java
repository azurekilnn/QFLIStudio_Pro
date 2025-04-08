package com.luastudio.azure.editor.textmate;

import org.eclipse.tm4e.core.grammar.IGrammar;

import io.github.rosemoe.sora.langs.textmate.TextMateLanguage;
import io.github.rosemoe.sora.langs.textmate.registry.GrammarRegistry;
import io.github.rosemoe.sora.langs.textmate.registry.ThemeRegistry;
import org.eclipse.tm4e.languageconfiguration.internal.model.LanguageConfiguration;

public class MyTextMateLanguage extends TextMateLanguage {
    protected MyTextMateLanguage(IGrammar grammar, LanguageConfiguration languageConfiguration, GrammarRegistry grammarRegistry, ThemeRegistry themeRegistry, boolean createIdentifiers) {
        super(grammar, languageConfiguration, grammarRegistry, themeRegistry, createIdentifiers);
    }
}
