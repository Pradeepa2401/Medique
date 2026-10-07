<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userRole = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    if (userRole == null && request.getCookies() != null) {

        for (javax.servlet.http.Cookie cookie : request.getCookies()) {

            if ("preferredRole".equals(cookie.getName())) {

                userRole = cookie.getValue();

                session.setAttribute("role", userRole);

                break;
            }
        }
    }

    if (username == null && request.getCookies() != null) {

        for (javax.servlet.http.Cookie cookie : request.getCookies()) {

            if ("loggedInUser".equals(cookie.getName())) {

                username = cookie.getValue();

                session.setAttribute("username", username);

                break;
            }
        }
    }

    if (!"admin".equals(userRole)) {

        response.sendRedirect("login.jsp");

        return;
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin | MediQueue</title>

    <link rel="stylesheet"
          href="css/style.css">

</head>


<body>


<nav>

    <b>🏥 MediQueue</b>

    <span>
        Admin / Receptionist
    </span>

    <span>
        Welcome,
        <%= username == null ? "Admin" : username %>
    </span>

    <a href="logout">
        Logout
    </a>

</nav>


<main class="grid">


    <!-- Dashboard -->

    <section class="card">

        <h2>
            Dashboard
        </h2>


        <div class="stats">

            <div>

                <small>
                    Current Token
                </small>

                <strong id="adminCurrent">
                    —
                </strong>

            </div>


            <div>

                <small>
                    Waiting
                </small>

                <strong id="adminWaiting">
                    —
                </strong>

            </div>


            <div>

                <small>
                    Departments
                </small>

                <strong id="adminDepartments">
                    —
                </strong>

            </div>

        </div>


        <div id="adminQueue">

            Loading queue...

        </div>

    </section>


    <!-- Patients -->

    <section class="card">

        <h2>
            Patient Database
        </h2>


        <div
            id="adminPatients">

            Loading patients...

        </div>

    </section>


    <!-- Help Requests -->

    <section class="card">

        <h2>
            Patient Help Requests
        </h2>


        <div id="helpRequests">

            No requests yet.

        </div>


        <button
            class="btn"
            onclick="loadHelp()">

            Refresh Requests

        </button>

    </section>


</main>


<script src="js/app.js"></script>

</body>

</html>
