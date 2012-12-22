<%@ page import="com.google.appengine.api.users.*" %>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
%>
    <div id="top"></div>
	<div id="banner">
    	<span id="title">Script workbench</span>
    	<span style="width:400px;height:20px;"></span>
    	<span id="login">
    		Welcome, <span><%=user.getEmail()%></span> |
    		<a href="/">Home</a> |
    		<a href="<%=userService.createLogoutURL(request.getRequestURI())%>">Logout</a>
    	</span>
	</div>