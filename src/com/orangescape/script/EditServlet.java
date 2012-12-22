package com.orangescape.script;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.orangescape.script.entity.DataAccess;
import com.orangescape.script.entity.Script;
import com.orangescape.script.execution.Language;

@SuppressWarnings("serial")
public class EditServlet extends HttpServlet 
{
	private static final Logger log = Logger.getLogger(EditServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		try
		{
		    DataAccess access = new DataAccess();
		    Script script = access.get(getKey(req));
			req.setAttribute("script", script);
			boolean test = getMethod(req).equalsIgnoreCase("test");
			if(test) evaluate(req, Language.create(script));
		    String jsp = test ? "/test.jsp" : "/view.jsp";
			RequestDispatcher dispatcher = getServletConfig()
				.getServletContext().getRequestDispatcher(jsp);
			dispatcher.forward(req, resp);
			access.close();
		}
		catch(Throwable th)
		{
			th.printStackTrace();
			th.printStackTrace(resp.getWriter());
		}
	}
	
	private void evaluate(HttpServletRequest req, Language lang )
	{
		try{
			req.setAttribute("outputData", lang.evaluate());
		}
		catch(Throwable th){
			req.setAttribute("error", th.toString()); log(th);
		}

		try{
			req.setAttribute("variables", lang.getVariables());
		}
		catch(Throwable th){
			req.setAttribute("variables", Arrays.asList());
			log(th);
		}
		finally{
			lang.close();
		}
	}
	
	private void log(Throwable th)
	{
		th.printStackTrace();
		StringWriter sw = new StringWriter();
		th.printStackTrace(new PrintWriter(sw));
		log.severe(sw.toString());
		log.throwing(this.getClass().getName(), "evaluate", th);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException 
	{
		try
		{
			DataAccess access = new DataAccess();
		    Script script = null;
		    String method = getMethod(req);
		    String jsp = "/view.jsp";
			if(method.equalsIgnoreCase("create"))
				script = access.create();
			else
			{
				script = access.get(getKey(req));
				if(method.equalsIgnoreCase("edit"))
				{
					script.update(req.getParameter("name"),
							req.getParameter("language"), req.getParameter("code"));
				}
				else if(method.equalsIgnoreCase("test"))
				{
					jsp = "/test.jsp";
					script.updateMetaData(req.getParameter("inputTypes"), 
							req.getParameter("outputTypes"), req.getParameter("inputData"));
					evaluate(req, Language.create(script));
				}
			}
			req.setAttribute("script", script);
			access.close();
			RequestDispatcher dispatcher = getServletConfig().getServletContext()
				.getRequestDispatcher(jsp);
			dispatcher.forward(req, resp);
		}
		catch(Throwable th)
		{
			th.printStackTrace(resp.getWriter());
		}
	}
	
	private String getMethod(HttpServletRequest req)
	{
		int methodIndex = req.getRequestURI().indexOf("/");
		int keyIndex = req.getRequestURI().lastIndexOf("/");
		if(keyIndex == 0)
			return req.getRequestURI().substring(methodIndex+1);
		else
			return req.getRequestURI().substring(methodIndex+1, keyIndex);
	}
	
	private String getKey(HttpServletRequest req)
	{
		int keyIndex = req.getRequestURI().lastIndexOf("/");
		return req.getRequestURI().substring(keyIndex+1);
	}
	
	
}
