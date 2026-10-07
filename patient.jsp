<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (!"patient".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Patient Portal | MediQueue</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="app-page">
<nav class="topbar glass">
  <div class="brand"><span class="brand-mark">✚</span>Medi<span>Queue</span></div>
  <div class="nav-user"><span class="status-dot"></span> Patient Portal <a href="logout">Logout</a></div>
</nav>
<main class="app-wrap">
  <div class="page-heading"><div><div class="pill">PATIENT PORTAL</div><h1>Your healthcare journey, <em>simplified.</em></h1><p>Register, get a token and follow your queue in real time.</p></div></div>

  <section class="dashboard-grid">
    <div class="panel glass-strong">
      <div class="panel-title"><span><b>Patient registration</b><small>Enter your details to join the queue</small></span><span class="panel-icon">👤</span></div>
      <form id="tokenForm" class="form-grid">
        <label>Full name<input id="pName" name="name" required placeholder="Your full name"></label>
        <label>Age<input id="pAge" name="age" type="number" min="1" max="120" required placeholder="Age"></label>
        <label>Phone<input id="pPhone" name="phone" required placeholder="Phone number"></label>
        <label>Gender<select id="pGender" name="gender" required><option value="">Select</option><option>Female</option><option>Male</option><option>Other</option></select></label>
        <label class="span2">Address<textarea id="pAddress" name="address" rows="2" placeholder="Address"></textarea></label>
        <label>Department<select id="department" name="department" required><option value="">Select department</option></select></label>
        <label>Doctor<select id="doctor" name="doctor" required><option value="">Select department first</option></select></label>
        <button class="btn btn-primary span2" type="submit">Generate digital token 🎟️</button>
      </form>
      <div id="tokenMessage" class="notice"></div>
    </div>

    <div class="panel glass-strong queue-panel">
      <div class="panel-title"><span><b>Live queue</b><small>Updates automatically</small></span><span class="live-badge">● LIVE</span></div>
      <div class="queue-hero"><small>NOW SERVING</small><strong id="currentToken">—</strong><span id="queueStatus">Waiting for queue updates</span></div>
      <div class="patient-stats"><div><small>Your token</small><b id="myToken">—</b></div><div><small>Patients ahead</small><b id="ahead">—</b></div><div><small>Est. wait</small><b id="waitTime">—</b></div></div>
      <div id="patientNotice" class="alert-box">Your queue information will appear here.</div>
      <div id="queueList" class="queue-list"></div>
    </div>

    <div class="panel glass-strong span2">
      <div class="panel-title"><span><b>Need assistance?</b><small>Send a message to reception</small></span><span class="panel-icon">💬</span></div>
      <div class="help-row"><input id="helpMessage" placeholder="Describe what you need help with"><button class="btn btn-secondary" onclick="sendHelp()">Send request</button></div>
      <div id="helpResult" class="notice"></div>
    </div>
  </section>
</main>
<script src="js/app.js"></script>
</body>
</html>