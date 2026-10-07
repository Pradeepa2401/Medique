<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!"doctor".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Doctor Portal | MediQueue</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="app-page">
<nav class="topbar glass"><div class="brand"><span class="brand-mark">✚</span>Medi<span>Queue</span></div><div class="nav-user"><span class="status-dot"></span> Doctor Portal <a href="logout">Logout</a></div></nav>
<main class="app-wrap">
  <div class="page-heading"><div><div class="pill">DOCTOR PORTAL</div><h1>Run your queue with <em>clarity.</em></h1><p>Call patients, review details and complete consultations.</p></div></div>
  <section class="doctor-grid">
    <div class="panel glass-strong">
      <div class="panel-title"><span><b>Queue control</b><small>Real-time department queue</small></span><span class="live-badge">● LIVE</span></div>
      <div class="doctor-current"><small>CURRENT PATIENT</small><strong id="doctorCurrent">—</strong><div id="doctorPatientName">No patient called</div><span id="doctorPatientDetails">Call the next patient to begin.</span></div>
      <div class="doctor-actions"><button class="btn btn-primary" onclick="callNext()">Call next patient →</button><button class="btn btn-secondary" onclick="completePatient()">Mark consultation complete ✓</button></div>
      <div id="doctorMsg" class="notice"></div>
    </div>
    <div class="panel glass-strong">
      <div class="panel-title"><span><b>Queue overview</b><small>Patients currently registered</small></span><span class="panel-icon">📊</span></div>
      <div class="stats-grid"><div><small>Current</small><b id="doctorStatCurrent">—</b></div><div><small>Waiting</small><b id="doctorStatWaiting">—</b></div><div><small>Total today</small><b id="doctorStatTotal">—</b></div></div>
      <div id="doctorQueue" class="queue-list"></div>
    </div>
  </section>
</main>
<script src="js/app.js"></script>
</body>
</html>
