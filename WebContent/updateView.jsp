<%@ page contentType="text/plain;charset=UTF-8" %>
<%
    String selectedView = request.getParameter("view");
    session.setAttribute("view", selectedView);
    
%>