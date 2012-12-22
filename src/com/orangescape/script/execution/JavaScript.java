package com.orangescape.script.execution;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Scriptable;
import org.python.core.PyObject;

import com.orangescape.script.entity.Script;

public class JavaScript extends Language
{
    private Context context;
    private Scriptable scope;
    
	public JavaScript(Script script) throws Exception
	{
		super(script);
		context = Context.enter();
	    scope = context.initStandardObjects();
	}
	
	public void execute(Map input) throws Exception
	{
        Iterator it = input.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            scope.put((String)pairs.getKey(), scope, pairs.getValue());
        }
        
        context.evaluateString(scope, getCode(), "<cmd>", 1, null);
	}
	
	public List getVariables()
	{
        return Arrays.asList(scope.getIds());
	}
	
	protected Object getOutputValue(String name)
	{
		return scope.get(name, scope);
	}

	public void close()
	{
		context.exit();
	}
}
