﻿using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Jobsportal.Controllers
{
    public class LoginController : Controller
    {

        // GET: Login
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public JsonResult SignIn(Users userdata)
        {
            string role = Users.TrySignIn(userdata.Mobile, userdata.Password);
            if (!role.Contains("Invalid"))
            {
                userdata.Roles = role;

                FormsAuthentication.SetAuthCookie(userdata.Mobile, false);

                var authTicket = new FormsAuthenticationTicket(1, userdata.Mobile, DateTime.Now, DateTime.Now.AddMinutes(20), false, userdata.Roles);
                string encryptedTicket = FormsAuthentication.Encrypt(authTicket);
                var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                HttpContext.Response.Cookies.Add(authCookie);

                return Json(true);
            }
            else
            {
                return Json(false);
            }

        }


        [HttpGet]
        public ActionResult LoginRegistration()
        {
            Utility.LogActivity("At LoginRegistration", "LoginRegistration");
            return View();
        }
        public ActionResult SignOut()
        {


            FormsAuthentication.SignOut();

            return RedirectToAction("LoginRegistration");


        }

        [HttpPost]
        public JsonResult CandidateSignUp(Users USROBJ)
        {
            Users U = Users.CandidateSignUp(USROBJ);

            SignIn(USROBJ);

            return Json(new { Success = Convert.ToString(U.Success), Message = Convert.ToString(U.Message) }, JsonRequestBehavior.AllowGet);

            
        }


        [HttpGet]
        public ActionResult FooterTemplate()
        {
            return PartialView("_FooterTemplate");
        }

        public String GetResetPassword(String ResetPasswordvalue)
        {
            String Msg = Users.GetResetPassword(ResetPasswordvalue);
            return Msg;
        }

        [HttpGet]
        public ActionResult ResetPassword()
        {
            var QueryStringVal = Request.QueryString["uid"].ToString();
            Boolean Status = Users.IsPasswordResetLinkIsvalid(QueryStringVal);
            if (!Status == true)
            {
                ViewBag.Message = "Link Expired";
            }

            return View();
        }

        [HttpPost]
        public Boolean ChangeUserPassword(String GUID, String PasswordValue)
        {
            Boolean Status = Users.ChangeUserPassword(GUID, PasswordValue);

            return Status;
        }
    }
}