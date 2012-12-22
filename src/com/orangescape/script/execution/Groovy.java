package com.orangescape.script.execution;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.orangescape.script.entity.Script;

public class Groovy extends Language
{
	Binding binding;
	GroovyShell shell;
	
	public Groovy(Script script) throws Exception
	{
		super(script);
		binding = new Binding();
		shell = new GroovyShell(binding);
	}
	
	public void execute(Map input) throws Exception
	{
        Iterator it = input.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
    		binding.setVariable((String)pairs.getKey(), pairs.getValue());
        }
		shell.evaluate(getCode());
	}
	
	public List getVariables()
	{
        return Arrays.asList(binding.getVariables().keySet().toArray());
	}
	
	protected Object getOutputValue(String name)
	{
		return binding.getVariable(name);
	}

	public void close()
	{
	}
	
	public static void main(String[] args) throws Exception
	{
		Script script = new Script();
		script.inputData = "{'name':'mani'}";
		script.setCode("String name, full; full = name+' dorai';");
		Groovy gro = new Groovy(script);
		gro.evaluate();
		System.out.println(gro.getVariables());
		//System.out.println(gro.getOutputValue("full"));
	}
}
