<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="plantilla/menu.jspf"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%!
    public static double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();

        long factor = (long) Math.pow(10, places);
        value = value * factor;
        long tmp = Math.round(value);
        return (double) tmp / factor;
    }
%>
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
    connection = DriverManager.getConnection(connectionUrl+database, userid, password);

    String salarioPrimedio = "0.0";

    statement=connection.createStatement();
    String sql ="select (sum(salario) / count(emp_no)) as 'promedio' from empleado;";
    resultSet = statement.executeQuery(sql);
    while(resultSet.next()){
        if (resultSet.getString("promedio") != null){
            salarioPrimedio = resultSet.getString("promedio");
        }
    }
    connection.close();

%>
<html>
<head>
    <title>Salario promedio de todos los empleados</title>
</head>
<body>

<div class="jumbotron jumbotron-fluid">
    <div class="container text-center">
        <h1 class="display-4">Salario promedio de todos los empleados</h1>
        <p class="lead">$ <%=round(Double.parseDouble(salarioPrimedio), 2)%></p>
    </div>
</div>
</body>
</html>
