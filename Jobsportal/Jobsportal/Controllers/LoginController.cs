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
            string  role = Users.TrySignIn(userdata.Username, userdata.Password);
            if (!role.Contains("Invalid"))
            {
                userdata.Roles = role;
                
                FormsAuthentication.SetAuthCookie(userdata.Username, false);

                var authTicket = new FormsAuthenticationTicket(1, userdata.Username, DateTime.Now, DateTime.Now.AddMinutes(20), false, userdata.Roles);
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
            return View();
        }
        public ActionResult SignOut()
       {


           FormsAuthentication.SignOut();

          return  RedirectToAction("Index");
          

       }
    }
}