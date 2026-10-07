<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String role = (String) session.getAttribute("role");

    if (role == null || !"doctor".equalsIgnoreCase(role)) {
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

    <title>Doctor - MediQueue</title>

    <link rel="stylesheet" href="css/style.css">

    <style>

        .doctor-container {
            width: 92%;
            max-width: 1100px;
            margin: 30px auto;
        }

        .doctor-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .doctor-card h2 {
            margin-top: 0;
            color: #087f73;
        }

        .stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-box {
            background: #f1f5f9;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }

        .stat-box small {
            display: block;
            margin-bottom: 8px;
        }

        .stat-box strong {
            font-size: 30px;
        }

        .button-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            border: none;
            border-radius: 8px;
            padding: 12px 20px;
            background: #087f73;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover {
            background: #05665c;
        }

        .btn-secondary {
            background: #4f6078;
        }

        .btn-secondary:hover {
            background: #39485d;
        }

        .message {
            margin-top: 15px;
            padding: 12px;
            border-radius: 8px;
            background: #e6f7f4;
            min-height: 20px;
        }

        .patient-details {
            display: none;
            margin-top: 20px;
        }

        .patient-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .detail-box {
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #087f73;
        }

        .detail-box.full {
            grid-column: 1 / -1;
        }

        .detail-box small {
            display: block;
            color: #666;
            margin-bottom: 5px;
        }

        .detail-box strong {
            font-size: 16px;
        }

        .no-patient {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th,
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #087f73;
            color: white;
        }

        @media (max-width: 700px) {

            .stats,
            .patient-grid {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>

<nav>

    <b>🏥 MediQueue</b>

    <span>Doctor Portal</span>

    <a href="logout">Logout</a>

</nav>


<div class="doctor-container">


    <!-- LIVE QUEUE -->

    <div class="doctor-card">

        <h2>👨‍⚕️ Live Queue</h2>

        <div class="stats">

            <div class="stat-box">

                <small>Current Token</small>

                <strong id="doctorCurrent">—</strong>

            </div>


            <div class="stat-box">

                <small>Waiting Patients</small>

                <strong id="doctorWaiting">0</strong>

            </div>

        </div>


        <div class="button-row">

            <button
                type="button"
                class="btn"
                onclick="callNext()">

                📢 Call Next Patient

            </button>


            <button
                type="button"
                class="btn btn-secondary"
                onclick="completePatient()">

                ✅ Mark Consultation Complete

            </button>

        </div>


        <div
            id="doctorMsg"
            class="message">
        </div>

    </div>


    <!-- CURRENT PATIENT -->

    <div class="doctor-card">

        <h2>👤 Current Patient</h2>


        <div
            id="noPatient"
            class="no-patient">

            No patient is currently called.

        </div>


        <div
            id="patientDetails"
            class="patient-details">


            <div class="patient-grid">


                <div class="detail-box">

                    <small>Token Number</small>

                    <strong id="patientToken">—</strong>

                </div>


                <div class="detail-box">

                    <small>Patient Name</small>

                    <strong id="patientName">—</strong>

                </div>


                <div class="detail-box">

                    <small>Age</small>

                    <strong id="patientAge">—</strong>

                </div>


                <div class="detail-box">

                    <small>Gender</small>

                    <strong id="patientGender">—</strong>

                </div>


                <div class="detail-box">

                    <small>Phone Number</small>

                    <strong id="patientPhone">—</strong>

                </div>


                <div class="detail-box">

                    <small>Department</small>

                    <strong id="patientDepartment">—</strong>

                </div>


                <div class="detail-box">

                    <small>Doctor</small>

                    <strong id="patientDoctor">—</strong>

                </div>


                <div class="detail-box full">

                    <small>Address</small>

                    <strong id="patientAddress">—</strong>

                </div>


            </div>

        </div>

    </div>


    <!-- WAITING QUEUE -->

    <div class="doctor-card">

        <h2>📋 Waiting Queue</h2>

        <table>

            <thead>

                <tr>

                    <th>Token</th>

                    <th>Patient</th>

                    <th>Department</th>

                    <th>Doctor</th>

                    <th>Status</th>

                </tr>

            </thead>


            <tbody id="doctorQueue">

                <tr>

                    <td colspan="5">
                        Loading...
                    </td>

                </tr>

            </tbody>

        </table>

    </div>


</div>


<script>


/* LOAD QUEUE */

function loadDoctorQueue() {

    fetch("api?action=queue")

    .then(function(response) {

        return response.json();

    })

    .then(function(data) {


        const currentToken =
            Number(data.currentToken || 0);


        const waiting =
            Number(
                data.waitingCount ||
                data.waiting ||
                0
            );


        document.getElementById(
            "doctorCurrent"
        ).textContent =
            currentToken > 0
                ? currentToken
                : "—";


        document.getElementById(
            "doctorWaiting"
        ).textContent =
            waiting;


        const tokens =
            data.tokens || [];


        displayQueue(tokens);


        displayCurrentPatient(
            tokens,
            currentToken
        );

    })

    .catch(function(error) {

        console.error(
            "Queue error:",
            error
        );

        document.getElementById(
            "doctorMsg"
        ).textContent =
            "Unable to load queue.";

    });

}


/* DISPLAY WAITING QUEUE */

function displayQueue(tokens) {

    const table =
        document.getElementById(
            "doctorQueue"
        );


    table.innerHTML = "";


    if (tokens.length === 0) {

        table.innerHTML =
            "<tr>" +
            "<td colspan='5'>" +
            "No patients in queue." +
            "</td>" +
            "</tr>";

        return;

    }


    tokens.forEach(function(patient) {

        const row =
            document.createElement("tr");


        row.innerHTML =

            "<td>" +
            escapeHtml(patient.token) +
            "</td>" +

            "<td>" +
            escapeHtml(
                patient.name ||
                patient.patient ||
                "Patient"
            ) +
            "</td>" +

            "<td>" +
            escapeHtml(
                patient.department || "-"
            ) +
            "</td>" +

            "<td>" +
            escapeHtml(
                patient.doctor || "-"
            ) +
            "</td>" +

            "<td>" +
            escapeHtml(
                patient.status || "-"
            ) +
            "</td>";


        table.appendChild(row);

    });

}


/* DISPLAY CURRENT PATIENT */

function displayCurrentPatient(
    tokens,
    currentToken
) {

    const details =
        document.getElementById(
            "patientDetails"
        );

    const noPatient =
        document.getElementById(
            "noPatient"
        );


    if (currentToken <= 0) {

        details.style.display = "none";

        noPatient.style.display = "block";

        return;

    }


    let currentPatient = null;


    for (
        let i = 0;
        i < tokens.length;
        i++
    ) {

        if (
            Number(tokens[i].token) ===
            currentToken
        ) {

            currentPatient =
                tokens[i];

            break;

        }

    }


    if (currentPatient === null) {

        details.style.display = "none";

        noPatient.style.display = "block";

        return;

    }


    noPatient.style.display = "none";

    details.style.display = "block";


    document.getElementById(
        "patientToken"
    ).textContent =
        currentPatient.token || "—";


    document.getElementById(
        "patientName"
    ).textContent =
        currentPatient.name ||
        currentPatient.patient ||
        "—";


    document.getElementById(
        "patientAge"
    ).textContent =
        currentPatient.age || "—";


    document.getElementById(
        "patientGender"
    ).textContent =
        currentPatient.gender || "—";


    document.getElementById(
        "patientPhone"
    ).textContent =
        currentPatient.phone || "—";


    document.getElementById(
        "patientDepartment"
    ).textContent =
        currentPatient.department || "—";


    document.getElementById(
        "patientDoctor"
    ).textContent =
        currentPatient.doctor || "—";


    document.getElementById(
        "patientAddress"
    ).textContent =
        currentPatient.address || "—";

}


/* CALL NEXT PATIENT */

function callNext() {

    fetch("api", {

        method: "POST",

        headers: {
            "Content-Type":
                "application/x-www-form-urlencoded"
        },

        body: "action=next"

    })

    .then(function(response) {

        return response.json();

    })

    .then(function(data) {

        document.getElementById(
            "doctorMsg"
        ).textContent =
            data.message ||
            "Next patient called.";

        loadDoctorQueue();

    })

    .catch(function(error) {

        console.error(error);

        document.getElementById(
            "doctorMsg"
        ).textContent =
            "Unable to call next patient.";

    });

}


/* COMPLETE CONSULTATION */

function completePatient() {

    fetch("api", {

        method: "POST",

        headers: {
            "Content-Type":
                "application/x-www-form-urlencoded"
        },

        body: "action=complete"

    })

    .then(function(response) {

        return response.json();

    })

    .then(function(data) {

        document.getElementById(
            "doctorMsg"
        ).textContent =
            data.message ||
            "Consultation completed.";

        loadDoctorQueue();

    })

    .catch(function(error) {

        console.error(error);

        document.getElementById(
            "doctorMsg"
        ).textContent =
            "Unable to complete consultation.";

    });

}


/* HTML ESCAPE */

function escapeHtml(value) {

    if (
        value === null ||
        value === undefined
    ) {
        return "";
    }


    return String(value)

        .replace(/&/g, "&amp;")

        .replace(/</g, "&lt;")

        .replace(/>/g, "&gt;")

        .replace(/"/g, "&quot;")

        .replace(/'/g, "&#039;");

}


/* INITIAL LOAD */

loadDoctorQueue();


/* LIVE UPDATE */

setInterval(
    loadDoctorQueue,
    3000
);

</script>


</body>
  
</html>
