/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.DAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utility.Utilities;

/**
 *
 * @author asus
 */
@WebServlet(name = "ChangePass", urlPatterns = {"/change"})
public class ChangePass extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChangePass</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePass at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses = request.getSession();
        String changeId = (String) ses.getAttribute("changeCode");
        String changeIdRaw = request.getParameter("changeId");
        System.out.println("changeId:" + changeId);
        System.out.println("changeIdRaw: " + changeIdRaw);
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("changeCode")) {
                    String cookieValue = cookie.getValue();
                    boolean check = cookieValue.equals(changeIdRaw);
                    request.setAttribute("checkVerifyLink", check);
                }
            }
        }
        ses.setAttribute("user", (User) ses.getAttribute("user"));
        request.getRequestDispatcher("changePass.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses = request.getSession();
        DAO d = new DAO();
        Utilities ut = new Utilities();
        String pass = request.getParameter("pass");
        String repass = request.getParameter("repass");
        User user = (User) ses.getAttribute("user");
        if (!pass.equals(repass)) {
            request.setAttribute("error", "Password do not match!");
            request.getRequestDispatcher("changePass.jsp").forward(request, response);
        } else if (ut.validPass(pass) != null) {
            request.setAttribute("invalidpass", ut.validPass(pass));
            request.getRequestDispatcher("changePass.jsp").forward(request, response);
        } else if (user == null) {
            User u = (User) ses.getAttribute("email");
            int userid = d.getIdByEmail(u.getEmail());
            d.updatePass(pass, userid);
            response.sendRedirect("login");
        } else if (user != null) {
            int userid = d.getIdByEmail(user.getEmail());
            d.updatePass(pass, userid);
            response.sendRedirect("home");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
