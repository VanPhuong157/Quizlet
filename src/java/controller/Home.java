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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Folder;
import model.StudySet;
import model.User;
import model.Class;

/**
 *
 * @author LENOVO
 */
@WebServlet(name="home", urlPatterns={"/home"})
public class Home extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet home</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet home at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        DAO d = new DAO();
        HttpSession ses = request.getSession();
        User user = (User)ses.getAttribute("user");
        ArrayList<StudySet> listS = d.getAllStudySet();
        ArrayList<StudySet> listN = new ArrayList<StudySet>();
        ses.setAttribute("listS", listS);
        for(StudySet s: listS) {
            if(s.getUserId() == user.getId()) {
                listN.add(s);
            }
        }
        ArrayList<StudySet> listSet = d.getFiveStudySet(user.getId());
        ses.setAttribute("nameS", d.getUserByUserId(user.getId()).getName());
        ses.setAttribute("listSet", listSet);
        ArrayList<Class> listClass = d.getTopFiveClass(user.getId());
        ses.setAttribute("nameC", d.getUserByUserId(user.getId()).getName());
        ses.setAttribute("listClass", listClass);
        ses.setAttribute("d", d);
        ArrayList<Folder> listFd = d.getTopFiveFolder(user.getId());
        ses.setAttribute("nameF", d.getUserByUserId(user.getId()).getName());
        ses.setAttribute("listFd", listFd);
        ses.setAttribute("listN", listN);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
