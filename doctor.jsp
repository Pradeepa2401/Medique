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

    if (!"doctor".equals(userRole)) {

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

    <title>Doctor | MediQueue</title>

    <link rel="stylesheet"
          href="css/style.css">

</head>


<body>


<nav>

    <b>🏥 MediQueue</b>

    <span>
        Doctor Portal
    </span>

    <span>
        Welcome,
        <%= username == null ? "Doctor" : username %>
    </span>

    <a href="logout">
        Logout
    </a>

</nav>


<main class="grid">


    <section class="card">

        <h2>
            Live Queue
        </h2>


        <div class="stats">

            <div>

                <small>
                    Current
                </small>

                <strong id="doctorCurrent">
                    —
                </strong>

            </div>


            <div>

                <small>
                    Waiting
                </small>

                <strong id="doctorWaiting">
                    —
                </strong>

            </div>

        </div>


        <button
            class="btn"
            onclick="callNext()">

            Call Next Patient

        </button>


        <button
            class="btn secondary"
            onclick="completePatient()">

            Mark Consultation Complete

        </button>


        <div
            id="doctorMsg"
            class="notice">
        </div>


        <div id="doctorQueue">
            Loading queue...
        </div>

    </section>


    <section class="card">

        <h2>
            Current Patient
        </h2>

        <div id="doctorPatientDetails">

            No patient currently called.

        </div>

    </section>


</main>


<script src="js/app.js"></script>

</body>

</html>
