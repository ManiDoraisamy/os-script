<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.orangescape.script.entity.*" %>
<%@ page import="com.orangescape.script.execution.*" %>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Script workbench</title>
    <jsp:include page="style.jsp" />
  </head>
  <body>
    <jsp:include page="header.jsp" />
<%
    Script script = (Script)request.getAttribute("script");
    Object result = request.getAttribute("result");
    if(script == null)
    {
%>
		<div>Script not selected!</div>
<%
    }
    else
    {
%>
		<form class="view" action="/edit/<%=script.key%>" method="post">
			<div>
				<span>Name</span>
				<span><input type="text" name="name" value="<%=script.name%>"/></span>
				<span>&nbsp;</span>
				<span>Language</span>
				<span>
				<!--
				<input type="text" name="language" value="<%=script.language%>"/>
				-->
					<select name="language">
						<%
						    for(String language : Language.languages)
						    {
						%>
							<option <%=language.equalsIgnoreCase(script.language)?"selected":""%>>
								<%=language%>
							</option>
						<%
						    }
						%>
					</select>
				</span>
			</div>
			<div>
				<textarea class="script" name="code"><%=script.code==null?"":script.getCode()%></textarea>
			</div>
			<div>
				<%=request.getAttribute("error")==null?(result==null?"":result):request.getAttribute("error")%>
				<span class="modified">
					<a href="/" class="name" style="text-decoration:none">< Back</a>
					Last modified on <%=script.lastmodified%>
				</span>
				<input type="submit" class="submit" style="margin-left: 200px;" value="Save"/>
				<span style="margin-left: 200px;">
					<a href="/test/<%=script.key%>" class="name" style="text-decoration:none">Proceed to testing ></a>
				</span>
			</div>
			
		</form>
<%
    }
%>
  </body>
</html>
