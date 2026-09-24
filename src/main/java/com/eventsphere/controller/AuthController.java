package com.eventsphere.controller;

import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.User;
import com.eventsphere.util.PasswordUtil;
import com.eventsphere.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/profile"})
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?msg=logged_out");
            return;
        }

        if ("/login".equals(path)) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if ("/register".equals(path)) {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        } else if ("/profile".equals(path)) {
            handleProfileUpdate(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "Please provide both email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email.trim());
        if (user == null || !PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(60 * 60); // 1 hour

        if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("/login") && !redirect.contains("/register")) {
            response.sendRedirect(request.getContextPath() + redirect);
            return;
        }

        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if (user.isJudge()) {
            response.sendRedirect(request.getContextPath() + "/judge/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String college = request.getParameter("college");
        String department = request.getParameter("department");
        String phone = request.getParameter("phone");

        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "Please provide a valid name, email, and password.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "An account with this email address already exists. Please log in.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setName(name.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPasswordHash(PasswordUtil.hashPassword(password));
        newUser.setRole("STUDENT");
        newUser.setCollege(ValidationUtil.isNotEmpty(college) ? college.trim() : "Apex Institute of Technology");
        newUser.setDepartment(ValidationUtil.isNotEmpty(department) ? department.trim() : "Computer Science");
        newUser.setPhone(phone != null ? phone.trim() : "");
        newUser.setAvatar("assets/images/avatars/student1.jpg");

        boolean created = userDAO.create(newUser);
        if (created) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", newUser);
            response.sendRedirect(request.getContextPath() + "/student/dashboard?welcome=1");
        } else {
            request.setAttribute("error", "Failed to create account. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = request.getParameter("name");
        String college = request.getParameter("college");
        String department = request.getParameter("department");
        String phone = request.getParameter("phone");

        if (ValidationUtil.isNotEmpty(name)) currentUser.setName(name.trim());
        if (ValidationUtil.isNotEmpty(college)) currentUser.setCollege(college.trim());
        if (ValidationUtil.isNotEmpty(department)) currentUser.setDepartment(department.trim());
        if (phone != null) currentUser.setPhone(phone.trim());

        userDAO.update(currentUser);
        session.setAttribute("currentUser", currentUser);

        if (currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=profile_updated");
        } else if (currentUser.isJudge()) {
            response.sendRedirect(request.getContextPath() + "/judge/dashboard?msg=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?msg=profile_updated");
        }
    }
}
