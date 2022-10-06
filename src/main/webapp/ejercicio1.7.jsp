<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="plantilla/menu.jspf"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
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
    boolean newUserWasAdded = false;
    boolean userModified=false;
    boolean userDeleted= false;

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

<%

    if (request.getParameter("emp_no_delete") != null) {
        Statement st=connection.createStatement();
        String query = "DELETE FROM departamentos where dept_no="+request.getParameter("emp_no_delete");
        int i=st.executeUpdate(query);
        userDeleted = true;
    }

    if(request.getParameter("emp_no_edit")!=null && !request.getParameter("emp_no_edit").equals("noedited")){
        String dnombre = request.getParameter("dnombre");
        String loc = request.getParameter("loc");
        String emp_no = request.getParameter("emp_no_edit");
        Statement st=connection.createStatement();
        String query = "UPDATE `departamentos` SET\n" +
                "\t`dnombre` = \""+dnombre+"\",\n" +
                "\t    `loc` = \""+loc+"\" \n" +
                "WHERE\n" +
                "\t`dept_no` = "+emp_no;
        int i=st.executeUpdate(query);
        userModified=true;
        request.removeAttribute("dnombre");
        request.removeAttribute("loc");
        request.removeAttribute("emp_no_edit");
    }

    String no_emp = request.getParameter("emp_no_edit");

    if ( no_emp != null && no_emp.equals("noedited")){
        Statement st=connection.createStatement();
        String query = "INSERT INTO `departamentos` ( `dnombre`, `loc`) \n" +
                "VALUES ( \""+request.getParameter("dnombre")+"\", \""+request.getParameter("loc")+"\" );";
        int i=st.executeUpdate(query);
        System.out.println(i);
        newUserWasAdded = true;
    }
%>
<html>
<head>
    <title>Dynamic Drop Down List Demo - CodeJava.net</title>
</head>
<body>


<div class="container text-left">

    <%
        if (userDeleted){
    %>
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <strong>Holy guacamole!</strong> a department was deleted
    </div>
    <%
        }
    %>
    <%
        if (newUserWasAdded){
    %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <strong>Holy guacamole!</strong> a new department was added
    </div>
    <%
        }
    %>

    <%
        if (userModified){
    %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <strong>Holy guacamole!</strong> a deparment was modified
    </div>
    <%
        }
    %>
    <form action="" method="post" name="formulario">

        <input type="hidden" id="noedited" name="emp_no_edit" value="<%= request.getParameter("dept_no") != null && userModified == false ? request.getParameter("dept_no") : "noedited"%>">
        <div class="mb-3">
            <label  class="form-label">Nombre departamento</label>
            <input type="text" class="form-control" name="dnombre" value="<%= request.getParameter("dnombre")!=null && userModified == false ?request.getParameter("dnombre"):""%>"  placeholder="Nombre departamento">

        </div>
        <div class="mb-3">
            <label  class="form-label text-left">Localizacion</label>
            <input type="text" class="form-control" name="loc" value="<%= request.getParameter("loc")!=null && userModified == false ?request.getParameter("loc"):""%>" required placeholder="Localización">
        </div>

        <div class="text-center">
            <input class="btn btn-outline-dark" type="submit" value="Actualizar">
        </div>
    </form>

    <table class="table table-striped table-hover">
        <tr>
            <td>ID</td>
            <td>Departamento</td>
            <td>Localizacion</td>
            <td>Promedio Salario</td>
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
            <td>$<%= resultSet.getString("promedio") != null ? round(Double.parseDouble(resultSet.getString("promedio")), 2) : 0.0 %></td>
            <td>
                <form name="modificar" action="" method="post">
                    <input type="hidden" name="dept_no" value="<%=resultSet.getString("dept_no") %>">
                    <input type="hidden" name="dnombre" value="<%=resultSet.getString("dnombre") %>">
                    <input type="hidden" name="loc" value="<%=resultSet.getString("loc") %>">
                    <input type="submit" value="Editar">
                </form>
            </td>
            <td>
                <form name="eliminar" action="" method="get">
                    <input type="hidden" name="emp_no_delete" value="<%=resultSet.getString("dept_no") %>">
                    <input type="submit" value="eliminar">
                </form>
            </td>

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