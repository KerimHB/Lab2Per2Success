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
    connection = DriverManager.getConnection(connectionUrl+database, userid, password);
%>
<!DOCTYPE html>
<html>
<body>
<div class="container text-center">

    <h1>Filtrado por departamento</h1>

    <form>

        <select class="form-select" name="combo" aria-label="Default select example">
            <option selected value="0">ninguno</option>
            <%
                try{
                    statement=connection.createStatement();
                    String sql ="select * from departamentos";
                    resultSet = statement.executeQuery(sql);
                    while(resultSet.next()){

            %>
            <option value="<%=resultSet.getString("dept_no") %>"><%=resultSet.getString("dnombre") %></option>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <div>
            <input type="submit" value="Filtrar">
        </div>
    </form>

    <table class="table table-striped table-hover">
        <tr>
            <td>Codigo</td>
            <td>Apellido</td>
            <td>Oficio</td>
            <td>Direccion</td>
            <td>Fecha Alt</td>
            <td>Salario</td>
            <td>departamento</td>
        </tr>
        <%
            String where = "";
            if (request.getParameter("combo") != null){
                String dept_no = request.getParameter("combo");
                if (!dept_no.equals("0")){
                    where = "WHERE dept_no="+dept_no;
                }
            }
            try{
                statement=connection.createStatement();
                String sql ="SELECT\n" +
                        "\t*,\n" +
                        "\t`emp_no`,\n" +
                        "\t`apellido`,\n" +
                        "\t`oficio`,\n" +
                        "\t`dir`,\n" +
                        "\t`fecha_alt`,\n" +
                        "\t`salario`,\n" +
                        "\t`comision`,\n" +
                        "\t`dept_no`,\n" +
                        "\t(select dnombre from departamentos where departamentos.dept_no = empleado.dept_no) as 'departamento'\n" +
                        "FROM `empleado` "+where;
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
            <td><%=resultSet.getString("departamento") %></td>

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
