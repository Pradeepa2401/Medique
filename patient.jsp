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

    if (!"patient".equals(userRole)) {

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

    <title>Patient | MediQueue</title>

    <link rel="stylesheet"
          href="css/style.css">

</head>


<body>


<nav>

    <b>🏥 MediQueue</b>

    <span>
        Patient Portal
    </span>

    <span>
        Welcome,
        <%= username == null ? "Patient" : username %>
    </span>

    <a href="logout">
        Logout
    </a>

</nav>


<main class="grid">


    <!-- Patient Registration -->

    <section class="card">

        <h2>
            Patient Registration
        </h2>

        <p>
            Enter your details to generate a digital token.
        </p>


        <form id="patientForm"
              onsubmit="return bookToken();">


            <input
                id="patientName"
                name="name"
                type="text"
                placeholder="Full Name"
                required>


            <input
                id="patientAge"
                name="age"
                type="number"
                min="1"
                max="120"
                placeholder="Age"
                required>


            <input
                id="patientPhone"
                name="phone"
                type="tel"
                placeholder="Phone Number"
                required>


            <select
                id="patientGender"
                name="gender"
                required>

                <option value="">
                    Select Gender
                </option>

                <option value="Male">
                    Male
                </option>

                <option value="Female">
                    Female
                </option>

                <option value="Other">
                    Other
                </option>

            </select>


            <textarea
                id="patientAddress"
                name="address"
                placeholder="Address"
                required></textarea>


            <select
                id="department"
                name="department"
                required>

                <option value="">
                    Select Department
                </option>

            </select>


            <select
                id="doctor"
                name="doctor"
                required>

                <option value="">
                    Select Doctor
                </option>

            </select>


            <button
                class="btn"
                type="submit">

                Generate Token

            </button>

        </form>

    </section>


    <!-- Token -->

    <section class="card">

        <h2>
            Your Token
        </h2>


        <div class="token-display">

            <small>
                YOUR TOKEN
            </small>

            <strong id="patientToken">
                —
            </strong>

        </div>


        <div class="stats">

            <div>

                <small>
                    Current Token
                </small>

                <strong id="patientCurrent">
                    —
                </strong>

            </div>


            <div>

                <small>
                    Patients Ahead
                </small>

                <strong id="patientAhead">
                    —
                </strong>

            </div>


            <div>

                <small>
                    Estimated Wait
                </small>

                <strong id="patientWait">
                    —
                </strong>

            </div>

        </div>


        <div
            id="patientNotification"
            class="notice">
        </div>


        <div id="patientQueue">
            Loading queue...
        </div>

    </section>


    <!-- Help -->

    <section class="card">

        <h2>
            Need Help?
        </h2>

        <textarea
            id="helpMessage"
            placeholder="Enter your message..."></textarea>

        <button
            class="btn secondary"
            onclick="sendHelp()">

            Contact Receptionist

        </button>

        <div
            id="helpMsg"
            class="notice">
        </div>

    </section>


</main>


<script src="js/app.js"></script>

</body>

</html>
