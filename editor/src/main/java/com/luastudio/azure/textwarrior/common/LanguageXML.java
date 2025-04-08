package com.luastudio.azure.textwarrior.common;

/*
 * Copyright (c) 2013 Tah Wei Hoon.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Apache License Version 2.0,
 * with full text available at http://www.apache.org/licenses/LICENSE-2.0.html
 *
 * This software is provided "as is". Use at your own risk.
 */
/**
 * Singleton class containing the symbols and operators of the C language
 */
public class LanguageXML extends Language{
	private static Language _theOne = null;

	private final static String XmlKeywordsTarget="-|<|>|/|?|xml|version|string|style|color|id|item|resources|dimen|path|menu|application|uses|sdk|permission|intent|filter|manifest|xmlns|intent|action|sevice|category|shape|data|receiver|service|activity|include|meta";
	
	String keywords[]=XmlKeywordsTarget.split("\\|");
	String name[]={""};
	private final static char[] LUA_OPERATORS = {
		'(', ')', '{', '}', ',', ';', '=', '+', '-',
		'/', '*', '&', '!', '|', ':', '[', ']', '<', '>',
		'?', '~', '%', '^'
	};	
	public static Language getInstance(){
		if(_theOne == null){
			_theOne = new LanguageXML();
		}
		return _theOne;
	}

	private LanguageXML(){
		super.setOperators(LUA_OPERATORS);
		super.setKeywords(keywords);
		super.setNames(name);
	}
}
