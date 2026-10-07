<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Sign in | MediQueue</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
<div class="auth-bg"></div>
<div class="auth-shell">
  <div class="auth-brand"><span class="brand-mark">✚</span><b>Medi<span>Queue</span></b></div>
  <div class="auth-card glass-strong">
    <div class="auth-icon">🏥</div>
    <div class="pill">SECURE ACCESS</div>
    <h1>Welcome back</h1>
    <p>Choose your portal and continue to MediQueue.</p>
    <form method="post" action="login" class="form-stack">
      <label>Username<input type="text" name="username" placeholder="Enter username" required></label>
      <label>Password<input type="password" name="password" placeholder="Enter password" required></label>
      <label>Portal<select name="role" required>
        <option value="">Select portal</option>
        <option value="patient">Patient</option>
        <option value="doctor">Doctor</option>
        <option value="admin">Admin / Receptionist</option>
      </select></label>
      <button class="btn btn-primary full" type="submit">Sign in securely →</button>
    </form>
    <div class="demo-box"><b>Demo access</b><br>Patient: patient / patient123<br>Doctor: doctor / doctor123<br>Admin: admin / admin123</div>
    <a class="back-link" href="index.html">← Back to MediQueue</a>
  </div>
</div>
</body>
</html>
