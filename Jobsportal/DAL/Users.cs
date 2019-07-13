﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace DAL
{
    public class Users
    {
        public string Username { get; set; }
        public string Password { get; set; }

        public string Roles { get; set; }

        public string Displayname { get; set; }

        public String Mobile { get; set; }

        public String Email { get; set; }

        public String Message { get; set; }

        public Int32 Success { get; set; }


        private const String UserName = "@STR_NAME";
        private const String UserMobile = "@STR_MOBILE";
        private const String UserEmail = "@STR_EMAIL";
        private const String UserPassword = "@STR_PASSWORD";

        public static string TrySignIn(string username, string password)
        {
            string sp = "sp_TrySignIn";
            string Role = "Invalid";

            if (!(string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password)))
            {
                String EncryptedPassword = PortalEncryption.Encrypt(password);
                string connstring = Connection.GetConnectionString();

                using (SqlConnection dbCon = new SqlConnection(connstring))
                {
                    dbCon.Open();

                    using (SqlCommand dbCom = new SqlCommand(sp, dbCon))
                    {
                        dbCom.CommandType = CommandType.StoredProcedure;
                        dbCom.Parameters.Add("@username", SqlDbType.VarChar).Value = username;
                        dbCom.Parameters.Add("@password", SqlDbType.VarChar).Value = EncryptedPassword;
                        using (SqlDataReader wizReader = dbCom.ExecuteReader())
                        {


                            while (wizReader.Read())
                            {
                                Role = (string)wizReader["Roles"];
                            }





                        }
                    }
                }
            }

            return Role;
        }


        public static Users GetUserDetail(string username)
        {
            string sp = "sp_GetUserDetail";
            string connstring = Connection.GetConnectionString();
            var p = new Users();
            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(sp, dbCon))
                {
                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add("@username", SqlDbType.VarChar).Value = username;

                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {

                            {
                                p.Username = (string)wizReader["Username"];

                                p.Displayname = (string)wizReader["Displayname"];
                                p.Roles = (string)wizReader["Roles"];

                            };


                        }
                    }
                }
            }

            return p;
        }

        public static Users CandidateSignUp(Users USROBJ)
        {
            Users Usr = new Users();
            String EncryptedPassword = PortalEncryption.Encrypt(USROBJ.Password);
            String connstring = Connection.GetConnectionString();
            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.USP_SIGNUP, dbCon))
                {

                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.AddWithValue(UserName, USROBJ.Username);
                    dbCom.Parameters.AddWithValue(UserMobile, USROBJ.Mobile);
                    dbCom.Parameters.AddWithValue(UserEmail, USROBJ.Email);
                    dbCom.Parameters.AddWithValue(UserPassword, EncryptedPassword);

                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            Usr.Success = Convert.ToInt32(wizReader["Success"]);
                            Usr.Message = Convert.ToString(wizReader["Message"]);
                        }
                    }


                }
                return Usr;
            }
        }

        public static String GetResetPassword(String ResetPasswordvalue)
        {
            string connstring = Connection.GetConnectionString();
            String Msg = String.Empty;

            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.USP_RESETPASSWPRD, dbCon))
                {
                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add("@MOBILENUMBER", SqlDbType.VarChar).Value = ResetPasswordvalue;

                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {


                        while (wizReader.Read())
                        {
                            if (Convert.ToBoolean(wizReader["ReturnCode"]))
                            {
                                SendPasswordResetEmail(wizReader["Email"].ToString(), wizReader["USERNAME"].ToString(), wizReader["UniqueId"].ToString());

                                Msg = "An email with instructions to reset your password is sent to your " + wizReader["Email"].ToString() + " email id";
                            }
                            else
                            {

                                Msg = "Mobile Number is not found!";
                            }
                        }





                    }
                }
            }
            return Msg;
        }


        private static void SendPasswordResetEmail(string ToEmail, string UserName, string UniqueId)
        {

            String EmailTemplatepath = Convert.ToString(HttpContext.Current.Server.MapPath("~/Content/ForgetPasswordEmailHtmlFile.html"));
            String EmailTemplate = String.Empty;

            EmailTemplate = ReadHtmlFile(EmailTemplatepath);
            EmailTemplate = EmailTemplate.Replace("@@UserName@@", UserName);
            EmailTemplate = EmailTemplate.Replace("@@GUID@@", UniqueId);
            String MSubject = "Reset Password";

            EmailServer emailconfigdata = EmailServer.GetEmailConfiguration();
            SmtpClient client = new SmtpClient();
            client.Port = Convert.ToInt32(emailconfigdata.Port);
            client.Host = emailconfigdata.Host;
            client.EnableSsl = emailconfigdata.SSL;
            client.Timeout = 10000;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential(emailconfigdata.Email, emailconfigdata.Password);

            MailMessage mm = new MailMessage(emailconfigdata.Email, ToEmail, MSubject, EmailTemplate);

            mm.BodyEncoding = UTF8Encoding.UTF8;
            mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
            mm.Subject = MSubject;
            mm.Body = EmailTemplate;
            mm.IsBodyHtml = true;

            try
            {

                client.Send(mm);
            }
            catch (Exception ex)
            {
                DALError.LogError("Users.SendPasswordResetEmail", ex);


            }

        }

        

        private static String ReadHtmlFile(String htmlFilePath)
        {
            StringBuilder store = new StringBuilder();

            try
            {
                using (StreamReader htmlReader = new StreamReader(htmlFilePath))
                {
                    String line;
                    while ((line = htmlReader.ReadLine()) != null)
                    {
                        store.Append(line);
                    }
                }
            }
            catch (Exception ex) { }

            return store.ToString();
        }

        public static String GetLogo()
        {
            return Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["Drashtalogourl"]);
        }

        public static bool IsPasswordResetLinkIsvalid(String QueryStringVal)
        {
            List<SqlParameter> paramList = new List<SqlParameter>()
            {
                new SqlParameter()
                {
                    ParameterName = "@GUID",
                    Value = QueryStringVal
                }
            };

            return ExecuteSP(StoredProcedure.USP_ISPASSWORDRESETLINKISVALID, paramList);
        }

        private static bool ExecuteSP(string SPName, List<SqlParameter> SPParameters)
        {
            string connstring = Connection.GetConnectionString();

            using (SqlConnection con = new SqlConnection(connstring))
            {
                SqlCommand cmd = new SqlCommand(SPName, con);
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (SqlParameter parameter in SPParameters)
                {
                    cmd.Parameters.Add(parameter);
                }

                con.Open();
                return Convert.ToBoolean(cmd.ExecuteScalar());
            }
        }

        public static bool ChangeUserPassword(String GUID, String PasswordValue)
        {
            List<SqlParameter> paramList = new List<SqlParameter>()
            {
                new SqlParameter()
                {
                    ParameterName = "@GUID",
                    Value = GUID
                },
                new SqlParameter()
                {
                    ParameterName = "@Password",
                    Value = PasswordValue
                }
            };

            return ExecuteSP(StoredProcedure.USP_CHANGEPASSWORD, paramList);
        }
    }
}
