<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="plantilla/menu.jspf"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%
    String driver = "com.mysql.cj.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "empresa";
    String userid = "root";
    String password = "";
    try {
        Class.forName(driver);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
%>
<!DOCTYPE html>
<html>
<body>
<div class="container text-center">

    <h1>Empleados de la esmpresa</h1>
    <table class="table table-striped table-hover">
        <tr>
            <td>Codigo</td>
            <td>Apellido</td>
            <td>Oficio</td>
            <td>Direccion</td>
            <td>Fecha Alt</td>
            <td>Salario</td>
        </tr>
        <%
            try{
                connection = DriverManager.getConnection(connectionUrl+database, userid, password);
                statement=connection.createStatement();
                String sql ="select * from empleado";
                resultSet = statement.executeQuery(sql);
                while(resultSet.next()){
        %>
        <tr>
            <td><%=resultSet.getString("emp_no") %></td>
            <td><%=resultSet.getString("apellido") %></td>
            <td><%=resultSet.getString("oficio") %></td>
            <td><%=resultSet.getString("dir") %></td>
            <td><%=resultSet.getString("fecha_alt") %></td>
            <td><%=resultSet.getString("salario") %></td>

        </tr>
        <%
                }
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>

</div>
</body>
</html>