package com.orangescape.script.execution;

import java.util.*;

import org.python.core.PyObject;
import org.python.util.PythonInterpreter;

import com.orangescape.script.entity.Script;

public class Python extends Language
{
	PythonInterpreter interpreter;
	public Python(Script script) throws Exception
	{
		super(script);
		interpreter = new PythonInterpreter();
	}
	
	public void execute(Map input) throws Exception
	{
        Iterator it = input.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            interpreter.set((String)pairs.getKey(), pairs.getValue());
        }
        
        interpreter.exec(getCode());
	}
	
	public List getVariables()
	{
		List variables = new ArrayList();
		PyObject locals = interpreter.getLocals();
		for(PyObject local : locals.asIterable())
			variables.add(local.asString());
		return variables;
	}
	
	protected Object getOutputValue(String name)
	{
		return interpreter.get(name);
	}

	public void close()
	{
		interpreter.cleanup();
	}
}
