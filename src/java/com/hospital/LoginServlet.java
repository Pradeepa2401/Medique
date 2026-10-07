package com.hospital;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        boolean validLogin =
                ("patient".equals(role)
                        && "patient".equals(username)
                        && "patient123".equals(password))
                ||
                ("doctor".equals(role)
                        && "doctor".equals(username)
                        && "doctor123".equals(password))
                ||
                ("admin".equals(role)
                        && "admin".equals(username)
                        && "admin123".equals(password));

        if (!validLogin) {
            res.sendRedirect("login.jsp?error=1");
            return;
        }

        // Store logged-in role in session
        req.getSession(true).setAttribute("role", role);

        // Remember preferred role for 30 days
        Cookie cookie = new Cookie("preferredRole", role);
        cookie.setMaxAge(60 * 60 * 24 * 30);
        res.addCookie(cookie);

        // Redirect according to role
        if ("patient".equals(role)) {
            res.sendRedirect("patient.jsp");
        } else if ("doctor".equals(role)) {
            res.sendRedirect("doctor.jsp");
        } else {
            res.sendRedirect("admin.jsp");
        }
    }
}