<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.orangescape.script.entity.*" %>
<%@ page import="com.orangescape.script.execution.*" %>
<%@ page import="com.google.appengine.repackaged.org.json.*" %>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Script workbench</title>
    <link href="http://trial.orangescape.com/portal/css/portal.css" rel="stylesheet" type="text/css">
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
    <jsp:include page="style.jsp" />
    <script src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.2.js" type="text/javascript"></script><link rel="stylesheet" type="text/css" href="http://jquery.com/files/social/jquery.tabs.css" /> 
    <script src="http://ajax.microsoft.com/ajax/jquery.templates/beta1/jquery.tmpl.js" type="text/javascript"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
    <script src="/js/json2.js"></script>
  </head>
  <body>
    <jsp:include page="header.jsp" />
<%
    Script script = (Script)request.getAttribute("script");
	List variables = (List)request.getAttribute("variables");
    if(script == null)
    {
%>
		<div>Script not selected for testing!</div>
<%
    }
    else if(variables == null)
    {
%>
		<div>Variables not available for testing!</div>
		<div><%=request.getAttribute("error")==null?"":request.getAttribute("error")%></div>
<%
    }
    else
    {
	    String vars = "{";
	    for(int i = 0; i < variables.size(); i++)
	    {
	    	if(i > 0) vars += ", ";
	    	vars += "'" + variables.get(i) + "': '" + variables.get(i) + "'";
	    }
	    vars += "}";
	    Map outputData = (Map)request.getAttribute("outputData");
%>

<script id="template" type="text/x-jquery-tmpl">
<div class="vars flow" style="width:240px;">
	<div class="name">Script variables (auto-detected)</div>
	{{each(i, svar) variables}}
		{{if inputTypes[svar] || outputTypes[svar]}}
		{{else}}
		<div class="break">
			<div class="flow"><input type="checkbox" name="svars" value="${svar}"/></div>
			<div>${svar}</div>
		</div>
		{{/if}}
	{{/each}}
	<div class="break"><br/><br/>
		<div class="name">Add undetected variable :</div>
		<input type="text" id="undetected"/>
		<input type="button" value="Add" onclick="addNew()"/>
	</div>
</div>
<div class="flow">
	<div class="vars break">
		<div class="move flow">
			<div>
				<input type="button" value=">" onclick="add(data.inputTypes)"/><br/>
				<input type="button" value="<" onclick="remove('inputTypes')"/>
			</div>
		</div>
		<div class="flow">
			<div class="name">Input variables (that needs to be passed to the script):</div>
			<table class="inout" width="400">
			<tr class="top">
			<td><input type="checkbox"/></td><td>Variable</td><td>Datatype</td><td>Input</td>
			</tr>
			{{each(name, typ) inputTypes}}
				<tr>
					<td><input type="checkbox" name="inputTypes" value="${name}"/></td>
					<td>${name}</td>
					<td>
						<select onchange="update(this, data.inputTypes)" name="${name}">
							{{each(i, val) ['Number','Text','Boolean']}}
								<option {{html val==typ?"selected":""}}>${val}</option>
							{{/each}}
						</select>
					</td>
					<td>
						{{if typ=="Text"}}
							<textarea class="text" name="${name}"
							onchange="update(this, data.inputData)">{{html $item.data.inputData[name]}}</textarea>
						{{/if}}
						{{if typ=="Number"}}
							<input type="text" class="number" onchange="update(this, data.inputData)"
							name="${name}" value="{{html $item.data.inputData[name]}}"/>
						{{/if}}
						{{if typ=="Date"}}
							<input type="text" class="date" onchange="update(this, data.inputData)"
							name="${name}" value="{{html $item.data.inputData[name]}}"/>
						{{/if}}
						{{if typ=="Boolean"}}
							{{if $item.data.inputData[name]}}
								<input type="checkbox"/>
							{{else}}
								<input type="checkbox"/>
							{{/if}}
						{{/if}}
					</td>
				</tr>
			{{/each}}
			</table>
		</div>
	</div>
	<div class="vars break">
		<div class="move flow">
			<div>
				<input type="button" value=">" onclick="add(data.outputTypes)"/><br/>
				<input type="button" value="<" onclick="remove('outputTypes')"/>
			</div>
		</div>
		<div class="flow">
			<div class="name">Output variables (that the script needs to return back):</div>
			<table class="inout" width="400">
			<tr class="top">
			<td><input type="checkbox"/></td><td>Variable</td><td>Datatype</td><td>Output</td>
			</tr>
			{{each(name, typ) outputTypes}}
				<tr>
					<td><input type="checkbox" name="outputTypes" value="${name}"/></td>
					<td>${name}</td>
					<td>
						<select onchange="update(this, data.outputTypes)" name="${name}">
							{{each(i, val) ['Number','Text','Boolean']}}
								<option {{html val==typ?"selected":""}}>${val}</option>
							{{/each}}
						</select>
					</td>
					<td>
						{{html $item.data.outputData[name]}}
					</td>
				</tr>
			{{/each}}
			</table>
		</div>
	</div>
</div>
<form id="testForm" action="/test/<%=script.key%>" method="post">
<div class="name break">
	(Select the script variables and use <span>></span> button to make them input/output variables.)
</div>
<div><%=outputData==null?"":"Executed the test successfully"%></div>
<div><%=request.getAttribute("error")==null?"":request.getAttribute("error")%></div>
<div>
	<a href="/edit/<%=script.key%>" class="name" style="text-decoration:none">< Back to scripting</a>
	<textarea name="inputTypes">{{html JSON.stringify(data.inputTypes)}}</textarea>
	<textarea name="outputTypes">{{html JSON.stringify(data.outputTypes)}}</textarea>
	<textarea name="inputData">{{html JSON.stringify(data.inputData)}}</textarea>
	<input type="submit" class="submit" style="margin-left:150px" value="Go!"/>
</div>
</form>
<div id="preview">
	<h3><a href="#">Preview (for OrangeScape Studio)</a></h3>
	<div>
	<table class="PropertySheet">
        <tbody>
        <tr><td colspan="2" class="sect">Web Service Configuration</td></tr>
        <tr height="2px"></tr>
        <tr><td>URL</td><td><input type="text" value="http://script.orangescape.com/soap/<%=script.key%>"></td></tr>
        <tr><td>NameSpace</td><td><input type="text" value="free"></td></tr>
        <tr><td>Action</td><td><input type="text" value="<%=script.name%>"></td></tr>
        <tr><td>Root</td><td><input type="text" value="<%=script.name%>"></td></tr>
        <tr><td>ResponseHeader</td><td><input type="text" value="<%=script.name%>"></td></tr>
        <tr><td>Allow Null</td><td><select><option>Yes</option></select></td></tr>
        <tr height="5px"></tr>
        <tr><td colspan="2" class="sect">Input Parameters</td></tr>
        <tr>
        	<td><img src="http://trial.orangescape.com/portal/images/processdesign/icons/add.png">Add new parameter</td>
        	<td><img src="http://trial.orangescape.com/portal/images/processdesign/icons/add.png">Add new hierarchy</td>
        </tr>
		{{each(name, typ) inputTypes}}
			<tr><td>${name}</td><td><select><option>${typ} parameter</option></select></td></tr>
		{{/each}}
        <tr height="5px"></tr>
        <tr><td colspan="2" class="sect">Output Parameters</td></tr>
        <tr>
        	<td><img src="http://trial.orangescape.com/portal/images/processdesign/icons/add.png">Add new parameter</td>
        	<td><img src="http://trial.orangescape.com/portal/images/processdesign/icons/add.png">Add new hierarchy</td>
        </tr>
		{{each(name, typ) outputTypes}}
			<tr><td><select><option>${typ} parameter</option></select></td><td>${name}</td></tr>
		{{/each}}
        </tbody>
	</table>
	</div>
	<h3><a href="#">Preview (for SOAP clients)</a></h3>
	<div>
		<span class="modified">Endpoint:</span><br/>
		<span class="soap">http://script.orangescape.com/soap/<%=script.key%></span>
		
		<div class="modified">SOAP Request:</div>
		<div class="soap">
			&lt;soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="free"&gt;<br/>
			&lt;soap:Header/&gt;<br/>
			&lt;soap:Body&gt;<br/>
			&lt;urn:<%=script.name%>&gt;<br/>
			{{each(name, typ) inputTypes}}
			&lt;urn:${name}&gt;{{html $item.data.inputData[name]}}&lt;/urn:${name}&gt;<br/>
			{{/each}}
			&lt;/urn:<%=script.name%>&gt;<br/>
			&lt;/soap:Body&gt;<br/>
			&lt;/soap:Envelope&gt;<br/>
		</div>
		<br/>
		<div class="modified">SOAP Response:</div>
		<div class="soap">
			&lt;soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="free"&gt;<br/>
			&lt;soap:Header/&gt;<br/>
			&lt;soap:Body&gt;<br/>
			&lt;urn:<%=script.name%>&gt;<br/>
			{{each(name, typ) outputTypes}}
			&lt;urn:${name}&gt;{{html $item.data.outputData[name]}}&lt;/urn:${name}&gt;<br/>
			{{/each}}
			&lt;/urn:<%=script.name%>&gt;<br/>
			&lt;/soap:Body&gt;<br/>
			&lt;/soap:Envelope&gt;<br/>
		</div>
	</div>
	<h3><a href="#">Preview (for JSONP clients)</a></h3>
	<div>
		<div class="modified">Javascript:</div>
		<div class="soap">
	    	&lt;script src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.2.js" type="text/javascript"&gt;&lt;/script&gt;<br/>
	    	&lt;script&gt;<br/>
				$.ajax({<br/>
					url: "http://script.orangescape.com/rest/<%=script.key%>",<br/>
					data: {
						{{each(name, typ) inputTypes}}
						${name}: "{{html $item.data.inputData[name]}}",
						{{/each}}
						key: "free"
					},<br/>
					dataType: 'jsonp',<br/>
					success: function(content){alert(content);}<br/>
				});<br/>
	    	&lt;/script&gt;<br/>
		</div>
		<br/>
		<div class="modified">Output:</div>
		<div class="soap">
			{
				{{each(name, typ) outputTypes}}
				${name}: "{{html $item.data.outputData[name]}}",
				{{/each}}
			}
		</div>
	</div>
</div>
</script>

<div class="topic">Time to test! Define test data for your script: <span><%=script.name%></span></div>
<div id="canvas">
</div>

<script>
	var data = {
	variables:<%=vars%>,
	inputTypes:<%=script.inputTypes==null?"{}":script.inputTypes%>,
	outputTypes:<%=script.outputTypes==null?"{}":script.outputTypes%>,
	inputData:<%=script.inputData==null?"{}":script.inputData%>,
	outputData:<%=outputData==null?"{}":new JSONObject(outputData).toString()%>
	};
	
	$("#template").template("template");
	function render()
	{
		//console.dir(map);
		$("#canvas").empty();
		$.tmpl("template", data).appendTo("#canvas");
		$("#preview").accordion();
		//$("#testForm").validate();
	}
	function addNew()
	{
		var value = $("#undetected").val();
		data.variables[value] = value;
		render();
	}
	function add(types)
	{
		var str = "input:checkbox[name=svars]:checked";
		$(str).each(function() {
		   var val = $(this).val();
		   types[val] = "Text";
		   delete data.variables[val];
		});
		render();
	}
	function remove(vars)
	{
		var str = "input:checkbox[name="+vars+"]:checked";
		$(str).each(function() {
		   var val = $(this).val();
		   data.variables[val] = val;
		   delete data[vars][val];
		});
		render();
	}
	function update(widget, map)
	{
		var name = widget.name;
		var value;
		if(widget.options)
			value = widget.options[widget.selectedIndex].value;
		else
			value = widget.value;
		map[name] = value;
		render();
	}
	render();
</script>
<%
    }
%>
  </body>
</html>
