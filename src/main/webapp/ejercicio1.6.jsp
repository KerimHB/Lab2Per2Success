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

<%

    if (request.getParameter("emp_no_delete") != null) {
        Statement st=connection.createStatement();
        String query = "DELETE FROM empleado where emp_no="+request.getParameter("emp_no_delete");
        int i=st.executeUpdate(query);
        userDeleted = true;
    }

    if(request.getParameter("emp_no_edit")!=null && !request.getParameter("emp_no_edit").equals("noedited")){
        String apellido = request.getParameter("apellido");
        String oficio = request.getParameter("oficio");
        String dir = request.getParameter("dir");
        String salario = request.getParameter("salario");
        String comision = request.getParameter("comision");
        String dept_no = request.getParameter("combo");
        String emp_no = request.getParameter("emp_no_edit");
        Statement st=connection.createStatement();
        String query = "UPDATE `empleado` SET\n" +
                "\t`apellido` = \""+apellido+"\",\n" +
                "\t  `oficio` = \""+oficio+"\",\n" +
                "\t     `dir` = \""+dir+"\",\n" +
                "\t `salario` = \""+salario+"\",\n" +
                "\t`comision` = \""+comision+"\",\n" +
                "\t `dept_no` = \""+dept_no+"\" WHERE emp_no="+emp_no+";";
        int i=st.executeUpdate(query);
        userModified=true;
        request.removeAttribute("apellido");
        request.removeAttribute("oficio");
        request.removeAttribute("dir");
        request.removeAttribute("salario");
        request.removeAttribute("comision");
        request.removeAttribute("combo");
        request.removeAttribute("emp_no_edit");
    }

    String no_emp = request.getParameter("emp_no_edit");

    if ( no_emp != null && no_emp.equals("noedited")){
        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String currentDate = formatter.format(new Date());
        Statement st=connection.createStatement();
        String query = "INSERT INTO empleado ( apellido, oficio, dir, fecha_alt, salario, comision, dept_no) \n" +
                "VALUES (\""+request.getParameter("apellido")+"\", \""+request.getParameter("oficio")+"\", "+request.getParameter("dir")+", \""+currentDate+"\", "+request.getParameter("salario")+", "+request.getParameter("comision")+", "+request.getParameter("combo")+" );";
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
        <strong>Holy guacamole!</strong> a user was deleted
    </div>
    <%
        }
    %>
   <%
       if (newUserWasAdded){
   %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <strong>Holy guacamole!</strong> a new user was added
    </div>
    <%
        }
   %>

    <%
        if (userModified){
    %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <strong>Holy guacamole!</strong> a user was modified
    </div>
    <%
        }
    %>
    <form action="" method="post" name="formulario">

        <input type="hidden" id="noedited" name="emp_no_edit" value="<%= request.getParameter("emp_no") != null && userModified == false ? request.getParameter("emp_no") : "noedited"%>">
        <div class="mb-3">
            <label  class="form-label">Apellido</label>
            <input type="text" class="form-control" name="apellido" value="<%= request.getParameter("apellido")!=null && userModified == false ?request.getParameter("apellido"):""%>"  placeholder="Apellido">

        </div>
        <div class="mb-3">
            <label  class="form-label text-left">Oficio</label>
            <input type="text" class="form-control" name="oficio" value="<%= request.getParameter("oficio")!=null && userModified == false ?request.getParameter("oficio"):""%>" required placeholder="Oficio">
        </div>
        <div class="mb-3">
            <label  class="form-label text-left">Dir</label>
            <input type="number" class="form-control" name="dir" value="<%= request.getParameter("dir")!=null && userModified == false?request.getParameter("dir"):""%>" required placeholder="Dir">
        </div>
        <div class="mb-3">
            <label  class="form-label text-left">Salario</label>
            <input type="number" step="0.01" class="form-control" name="salario" value="<%= request.getParameter("salario")!=null && userModified == false?request.getParameter("salario"):""%>" placeholder="Salario">
        </div>
        <div class="mb-3">
            <label  class="form-label text-left">comision</label>
            <input type="number" step="0.01" class="form-control" name="comision" value="<%= request.getParameter("comision")!=null && userModified == false?request.getParameter("comision"):""%>" placeholder="Salario">
        </div>
        <label  class="form-label text-left">Departamento</label>
        <select class="form-select" name="combo" aria-label="Default select example">
            <%
                try{
                    statement=connection.createStatement();
                    String sql ="select * from departamentos";
                    resultSet = statement.executeQuery(sql);
                    while(resultSet.next()){
                        if(request.getParameter("combo")!=null && request.getParameter("emp_no_edit")!=null){


            %>
            <option  <%= request.getParameter("combo")!=null?request.getParameter("combo").equals(resultSet.getString("dept_no"))?"selected":"id=1":"id=0"%> value="<%=resultSet.getString("dept_no") %>"><%=resultSet.getString("dnombre") %></option>
            <%
                        }else {
            %>
            <option   value="<%=resultSet.getString("dept_no") %>"><%=resultSet.getString("dnombre") %></option>
            <%
            }
                    }
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>
        <div class="text-center">
            <br>
            <input class="btn btn-outline-dark" type="submit" value="Actualizar">
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
            <td>Comision</td>
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
            <td><%=resultSet.getString("comision") %></td>
            <td>
                <form name="modificar" action="" method="post">
                    <input type="hidden" name="emp_no" value="<%=resultSet.getString("emp_no") %>">
                    <input type="hidden" name="apellido" value="<%=resultSet.getString("apellido") %>">
                    <input type="hidden" name="oficio" value="<%=resultSet.getString("oficio") %>">
                    <input type="hidden" name="dir" value="<%=resultSet.getString("dir") %>">
                    <input type="hidden" name="fecha_alt" value="<%=resultSet.getString("fecha_alt") %>">
                    <input type="hidden" name="salario" value="<%=resultSet.getString("salario") %>">
                    <input type="hidden" name="comision" value="<%=resultSet.getString("comision") %>">
                    <input type="hidden" name="combo" value="<%=resultSet.getString("dept_no") %>">
                    <input type="submit" value="Editar">
                </form>
            </td>
            <td>
                <form name="eliminar" action="" method="get">
                    <input type="hidden" name="emp_no_delete" value="<%=resultSet.getString("emp_no") %>">
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
