package com.eventsphere.filter;

import com.eventsphere.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Protect admin paths
        if (path.startsWith("/admin/") || path.equals("/admin")) {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
            if (user == null || !user.isAdmin()) {
                response.sendRedirect(contextPath + "/login?error=admin_required&redirect=" + path);
                return;
            }
        }

        // Protect judge paths
        if (path.startsWith("/judge/") || path.equals("/judge")) {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
            if (user == null || (!user.isJudge() && !user.isAdmin())) {
                response.sendRedirect(contextPath + "/login?error=judge_required&redirect=" + path);
                return;
            }
        }

        // Protect student paths
        if (path.startsWith("/student/") || path.equals("/student")) {
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
            if (user == null) {
                response.sendRedirect(contextPath + "/login?error=login_required&redirect=" + path);
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {}
}
