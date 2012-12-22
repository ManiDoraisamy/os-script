package com.orangescape.script;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

import com.google.appengine.repackaged.org.json.JSONObject;
import com.orangescape.script.entity.DataAccess;
import com.orangescape.script.entity.Script;
import com.orangescape.script.execution.Language;

@SuppressWarnings("serial")
public class ScriptServlet extends HttpServlet 
{
	private static final Logger log = Logger.getLogger(ScriptServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		this.doPost(req, resp);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException 
	{
		int serviceIndex = req.getRequestURI().indexOf("/");
		int keyIndex = req.getRequestURI().lastIndexOf("/");
		String service = req.getRequestURI().substring(serviceIndex+1, keyIndex);
		String key = req.getRequestURI().substring(keyIndex+1);
		log.info("Received "+service+" request - "+req.getRequestURI());
		
		Script script = DataAccess.pmfInstance.getPersistenceManager().getObjectById(Script.class, key);

		if(service.equalsIgnoreCase("soap"))
		{
			resp.setContentType("text/xml");
			Element body = null;
			try
			{
				Language lang = Language.create(script);
				SAXBuilder parser = new SAXBuilder();
				Document doc = parser.build(req.getInputStream());
				Namespace soapenv = 
				    Namespace.getNamespace("http://schemas.xmlsoap.org/soap/envelope/");
				body = doc.getRootElement().getChild("Body", soapenv);
				if(body == null)
					throw new Exception("Body tag not found in SOAP");
				else
				{
					Namespace urn = 
					    Namespace.getNamespace("free");
					Element scrElem = body.getChild(script.name, urn);
					if(scrElem == null)
						throw new Exception(script.name+" tag not found in SOAP");
					else
					{
					    HashMap input = new HashMap();
					    List elems = scrElem.getContent();
					    for(int i = 0; i < elems.size(); i++)
					    {
					    	Object obj = elems.get(i);
					    	if(obj instanceof Element)
					    	{
						    	Element nameval = (Element)obj;
						    	input.put(nameval.getName(), 
						    			lang.convert(nameval.getName(), nameval.getText()));
						    	scrElem.removeContent(nameval);
					    	}
					    }
					    Map output = lang.evaluate(input);
					    for(Object name : output.keySet())
					    {
					    	Object value = output.get(name);
					    	if(value != null)
					    	{
					    		Element outElem = new Element((String)name);
					    		outElem.setText(value.toString());
					    		scrElem.addContent(outElem);
					    		outElem.setNamespace(scrElem.getNamespace());
					    	}
					    }
					}
				}
				resp.getWriter().println(new XMLOutputter().outputString(doc));
			}
			catch(Exception e)
			{
			    resp.setHeader("status", e.toString());
			    resp.setStatus(500);
			    if(body == null)
			    	throw new IOException(e);
			    else
			    {
			    	body.removeChild(script.name);
			    	Element fault = new Element("Fault");
			    	fault.addContent(new Element("faultcode").setText("Server"));
			    	fault.addContent(new Element("faultstring").setText(e.toString()));
			    	body.addContent(fault);
					resp.getWriter().println(new XMLOutputter().outputString(body.getDocument()));
			    }
			}
		}
		else
		{
			try
			{
				Language lang = Language.create(script);
			    HashMap input = new HashMap();
			    Map params = req.getParameterMap();
			    for(Object nkey : params.keySet())
			    {
			    	if(lang.inputTypes.has(nkey.toString()))
			    	{
				    	String nvalue = req.getParameter(nkey.toString());
				    	input.put(nkey, lang.convert(nkey.toString(), nvalue));
			    	}
			    }
			    Map output = lang.evaluate(input);
				resp.getWriter().println(req.getParameter("callback")+"("+new JSONObject(output).toString()+")");
			}
			catch(Exception e)
			{
			    resp.setHeader("status", e.toString());
			    resp.setStatus(500);
			    resp.getWriter().print(e.toString());
			}
		}
		
	}
}
