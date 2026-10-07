<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!"admin".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Admin Dashboard | MediQueue</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="app-page">
<nav class="topbar glass"><div class="brand"><span class="brand-mark">✚</span>Medi<span>Queue</span></div><div class="nav-user"><span class="status-dot"></span> Admin / Reception <a href="logout">Logout</a></div></nav>
<main class="app-wrap">
  <div class="page-heading"><div><div class="pill">ADMIN CONTROL CENTER</div><h1>Hospital operations, <em>at a glance.</em></h1><p>Monitor patients, queues, departments and assistance requests.</p></div></div>

  <section class="admin-stats">
    <div class="stat-card glass-strong"><span>🎟️</span><small>Current token</small><b id="adminCurrent">—</b></div>
    <div class="stat-card glass-strong"><span>👥</span><small>Waiting patients</small><b id="adminWaiting">—</b></div>
    <div class="stat-card glass-strong"><span>🏥</span><small>Departments</small><b id="adminDepartments">—</b></div>
    <div class="stat-card glass-strong"><span>📋</span><small>Total patients</small><b id="adminTotal">—</b></div>
  </section>

  <section class="admin-grid">
    <div class="panel glass-strong wide-panel"><div class="panel-title"><span><b>Patient database</b><small>Registered patients and queue status</small></span><button class="btn btn-small btn-secondary" onclick="loadAdmin()">Refresh</button></div><div class="table-wrap"><table><thead><tr><th>Token</th><th>Patient</th><th>Age</th><th>Phone</th><th>Department</th><th>Doctor</th><th>Status</th></tr></thead><tbody id="patientTable"><tr><td colspan="7">Loading...</td></tr></tbody></table></div></div>
    <div class="panel glass-strong"><div class="panel-title"><span><b>Departments</b><small>Available hospital services</small></span><span class="panel-icon">🏥</span></div><div id="departmentList" class="department-list"></div></div>
    <div class="panel glass-strong"><div class="panel-title"><span><b>Help requests</b><small>Messages from patients</small></span><button class="btn btn-small btn-secondary" onclick="loadHelp()">Refresh</button></div><div id="helpRequests">No requests yet.</div></div>
    <div class="panel glass-strong"><div class="panel-title"><span><b>Live queue</b><small>Current patient flow</small></span><span class="live-badge">● LIVE</span></div><div id="adminQueue" class="queue-list"></div></div>
  </section>
</main>
<script src="js/app.js"></script>
</body>
</html>