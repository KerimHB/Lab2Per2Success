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

<%!
    public static double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();

        long factor = (long) Math.pow(10, places);
        value = value * factor;
        long tmp = Math.round(value);
        return (double) tmp / factor;
    }
%>
<!DOCTYPE html>
<html>
<body>
<div class="container text-center">

    <h1>Salario promedio por departamento</h1>
    <table class="table table-striped table-hover">
        <tr>
            <td>ID</td>
            <td>Departamento</td>
            <td>Localizacion</td>
            <td>Promedio Salario</td>
            <td>Numero de Empleados</td>
        </tr>
        <%
            try{
                connection = DriverManager.getConnection(connectionUrl+database, userid, password);
                statement=connection.createStatement();
                String sql ="select dept_no, dnombre, loc, (select (SUM(empleado.salario) / count(empleado.emp_no)) from empleado where empleado.dept_no = departamentos.dept_no ) as 'promedio', (select count(empleado.emp_no) from empleado where empleado.dept_no = departamentos.dept_no ) as 'n_empleados' from departamentos;";
                resultSet = statement.executeQuery(sql);
                while(resultSet.next()){
        %>
        <tr>
            <td><%=resultSet.getString("dept_no") %></td>
            <td><%=resultSet.getString("dnombre") %></td>
            <td><%=resultSet.getString("loc") %></td>
            <td><strong>$<%= resultSet.getString("promedio") != null ? round(Double.parseDouble(resultSet.getString("promedio")), 2) : 0.0 %></strong></td>
            <td><%=resultSet.getString("n_empleados") %></td>


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
