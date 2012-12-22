<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.orangescape.script.entity.*" %>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Script workbench</title>
    <jsp:include page="style.jsp" />
	<script type="text/javascript">
  		var _gaq = _gaq || [];
  		_gaq.push(['_setAccount', 'UA-20890902-1']);
  		_gaq.push(['_trackPageview']);

  		(function() {
    		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  		})();
	</script>
  </head>
  <body>
    <jsp:include page="header.jsp" />
<%
    DataAccess access = new DataAccess();
    List<Script> scripts = access.listScripts();
    if(scripts.size() > 0)
    {
%>
	<div class="topic">
		You have created <span><%=scripts.size()%></span> script<%=scripts.size()>1?"s":""%>:
	</div>
<%
	int i = 0;
    for(Script script : scripts)
    {
%>
	<div class="item">
		<div>
			<span class="count"><%=++i%></span>
			<span class="name"><%=script.name%></span>
			<i>(<%=script.language%>)</i>
			<a href="/view/<%=script.key%>">Edit</a>
		</div>
		<div class="code"><%=script.code%></div>
	</div>
<%
    }
    }
    else
    {
%>
		<div class="topic" style="width:700px;">
			Hi, <span><%=UserServiceFactory.getUserService().getCurrentUser().getEmail()%></span>.
			Welcome to Script workbench!
			<br/>
			<div class="nested">
			You can use this to build scripts using your favourite dynamic language - Javascript, Python, Ruby
			and invoke them from OrangeScape applications or from webservice callable applications.
			Watch this video, and learn to build one. Enjoy!
			</div>
			<div class="nested">
			<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/S8BxAxyGEuk?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/S8BxAxyGEuk?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>
			</div>
		</div>
<%
    }
%>
	<div class="topic">
		<form action="/create" method="post">
			Create <%=scripts.size()>0?"one more":"your first"%> script <span>></span> 
			<input type="submit" class="submit" style="margin-left: 10px;" value="Go!"/>
		</form>
	</div>
  </body>
</html>
