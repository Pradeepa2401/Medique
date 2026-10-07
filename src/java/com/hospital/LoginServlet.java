package com.hospital;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

        // Create session
        HttpSession session = req.getSession(true);
        session.setAttribute("role", role);
        session.setAttribute("username", username);

        // Store role in cookie so it can survive
        // across Vercel container instances.
        Cookie roleCookie = new Cookie("preferredRole", role);
        roleCookie.setMaxAge(60 * 60 * 24 * 30);
        roleCookie.setPath("/");
        res.addCookie(roleCookie);

        // Store username in cookie too.
        Cookie usernameCookie = new Cookie("loggedInUser", username);
        usernameCookie.setMaxAge(60 * 60 * 24 * 30);
        usernameCookie.setPath("/");
        res.addCookie(usernameCookie);

        if ("patient".equals(role)) {
            res.sendRedirect("patient.jsp");
        } else if ("doctor".equals(role)) {
            res.sendRedirect("doctor.jsp");
        } else {
            res.sendRedirect("admin.jsp");
        }
    }
}
