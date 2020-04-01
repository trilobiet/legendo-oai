<jsp:forward page="/"/>


<%-- 

  To prevent access to certain file types,
  put this in (Railo) WEB-INF web.xml: 

 <servlet>
   <servlet-name>forbidden</servlet-name>
   <jsp-file>/nosuch.jsp</jsp-file>
 </servlet>
 
 <servlet-mapping>
   <servlet-name>forbidden</servlet-name>
   <url-pattern>*.ini</url-pattern>
 </servlet-mapping>  

--%>