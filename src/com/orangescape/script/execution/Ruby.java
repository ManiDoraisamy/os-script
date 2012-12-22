package com.orangescape.script.execution;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jruby.embed.LocalContextScope;
import org.jruby.embed.ScriptingContainer;

import com.orangescape.script.entity.Script;

public class Ruby extends Language
{
	private ScriptingContainer container;
    
	public Ruby(Script script) throws Exception
	{
		super(script);
		container = new ScriptingContainer(LocalContextScope.THREADSAFE);
	}
	
	public void execute(Map input) throws Exception
	{
        Iterator it = input.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            container.put((String)pairs.getKey(), pairs.getValue());
        }
        
        container.runScriptlet(getCode());
	}
	
	public List getVariables()
	{
        return container.getVarMap().getNames();
	}
	
	protected Object getOutputValue(String name)
	{
		return container.get(name);
	}

	public void close()
	{
		container.terminate();
	}
	
	public static void main(String[] args) throws Exception
	{
		Script script = new Script();
		script.inputData = "{'$name':'man'}";
		script.setCode("$full = $name+' dorai'");
		Ruby ruby = new Ruby(script);
		ruby.evaluate();
		System.out.println(ruby.getVariables()+" - "+ruby.getOutputValue("$full"));
	}
}
