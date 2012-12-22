package com.orangescape.script.execution;

import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.google.appengine.repackaged.org.json.JSONArray;
import com.google.appengine.repackaged.org.json.JSONObject;
import com.orangescape.script.entity.Script;

public abstract class Language
{
	private static final Logger log = Logger.getLogger(Language.class.getName());
	
	public static final List<String> languages = Arrays.asList("JavaScript","Python","Ruby","Groovy");
	public static final List<String> datatypes = Arrays.asList("Text","Number","Boolean");
	
	public static Language create(Script script) throws Exception
	{
		if(languages.get(0).equalsIgnoreCase(script.language))
			return new JavaScript(script);
		else if(languages.get(1).equalsIgnoreCase(script.language))
			return new Python(script);
		else if(languages.get(2).equalsIgnoreCase(script.language))
			return new Ruby(script);
		else if(languages.get(3).equalsIgnoreCase(script.language))
			return new Groovy(script);
		else
			throw new Exception(script.language+" not supported.");
	}
	
	public Script script;
	public JSONObject inputTypes;
	public JSONObject outputTypes;
	
	public Language(Script script) throws Exception
	{
		this.script = script;
		this.inputTypes = script.inputTypes==null ? new JSONObject() : new JSONObject(script.inputTypes);
		this.outputTypes = script.outputTypes==null ? new JSONObject() : new JSONObject(script.outputTypes);
	}
	
	public String getCode()
	{
		return script.getCode();
	}
	
	public abstract void execute(Map input) throws Exception;

	public Map evaluate() throws Exception
	{
		return evaluate(script.inputData==null ? new JSONObject() : new JSONObject(script.inputData));
	}
	
	public Map evaluate(JSONObject inputData) throws Exception
	{
		HashMap input = new HashMap();
		JSONArray inarr = inputData.names();
		if(inarr != null)
		{
			for(int i = 0; i < inarr.length(); i++)
			{
				String name = (String)inarr.get(i);
				String value = inputData.getString(name);
				input.put(name, convert(name, value));
			}
		}
		
		return evaluate(input);
	}
	
	public Map evaluate(HashMap input) throws Exception
	{
		log.info("input : "+input);
		execute(input);
		
		HashMap output = new HashMap();
		JSONArray outarr = outputTypes.names();
		if(outarr != null)
		{
			for(int i = 0; i < outarr.length(); i++)
			{
				String name = (String)outarr.get(i);
				output.put(name, getOutputValue(name));
			}
		}
		log.info("output : "+output);
		
		return output;
	}
	
	public Object convert(String name, String value) throws Exception
	{
		try
		{
			if(inputTypes.has(name))
			{
				String type = inputTypes.getString(name);
				if(type.equalsIgnoreCase("Number"))
					return Double.parseDouble(value);
				else if(type.equalsIgnoreCase("Boolean"))
					return Boolean.parseBoolean(type);
				else
					return value;
			}
			else
				return value;
		}
		catch(Throwable th)
		{
			log.throwing(this.getClass().getName(), "evaluate", th);
			throw new Exception("Error while converting "+value+" of "+name+" to "+inputTypes.getString(name)+". "+th);
		}
	}
	
	/*
	 * These methods will be called only after evaluate.
	 */
	protected abstract Object getOutputValue(String name);
	
	public abstract List getVariables();
	
	public abstract void close();
}
