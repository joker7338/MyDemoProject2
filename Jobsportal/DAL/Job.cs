﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Web;

namespace DAL
{

    public class Job
    {
        public int JobNo { get; set; }

        public String JobTitle { get; set; }

        public String JobDesc { get; set; }

        public DateTime PostedDate { get; set; }

        public String Qualification { get; set; }

        public String Events { get; set; }

        public DateTime EventDateTime { get; set; }

        public String Users { get; set; }

        public String Comments { get; set; }

        public DateTime Date { get; set; }

        public List<Job> JobList { get; set; }

        public List<Job> JobNotes { get; set; }

        public String Title { get; set; }

        public String DownloadLink { get; set; }

        public String ApplyLink { get; set; }

        public List<Job> ImportantDT { get; set; }



        private const String DBOp = "@i_DBOP";
        private const String JobNum = "@JobNumber";


        public static List<Job> GetJobList()
        {

            List<Job> records = new List<Job>();

            String connstring = Connection.GetConnectionString();



            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.usp_Job_GetJobDetails, dbCon))
                {

                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add(DBOp, SqlDbType.VarChar).Value = 0;
                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            var p = new Job()
                            {
                                JobNo = (Int32)wizReader["JOBNO"],
                                JobTitle = (String)wizReader["JOBTITLE"],
                                JobDesc = (String)wizReader["JOBDESC"],
                                PostedDate = (DateTime)wizReader["POSTEDDATE"],
                                Qualification = (String)wizReader["QUALIFICATION"],
                            };

                            records.Add(p);
                        }
                    }
                }
            }

            return records;
        }

        public static Job GetJobDescription(Int32 JobNumber)
        {
            String connstring = Connection.GetConnectionString();
            Job J = null;

            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.usp_Job_GetJobDetails, dbCon))
                {

                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add(DBOp, SqlDbType.VarChar).Value = JobNumber;
                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            J = new Job()
                            {
                                JobNo = (Int32)wizReader["JOBNO"],
                                JobTitle = (String)wizReader["JOBTITLE"],
                                JobDesc = HttpUtility.HtmlDecode((String)wizReader["JOBDESC"]),
                                PostedDate = (DateTime)wizReader["POSTEDDATE"],
                                Qualification = (String)wizReader["QUALIFICATION"],
                            };

                            J.JobList = Job.GetEventDateList(JobNumber);
                            J.JobNotes = Job.GetJobNotesList(JobNumber);
                        }
                    }
                }

            }

            return J;
        }

        public static List<Job> GetEventDateList(Int32 JobNumber)
        {
            List<Job> records = new List<Job>();

            String connstring = Connection.GetConnectionString();



            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.usp_JOBIMPDATES_GetEventDateTime, dbCon))
                {

                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add(JobNum, SqlDbType.VarChar).Value = JobNumber;
                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            var K = new Job()
                            {
                                Events = (String)wizReader["EVENTS"],
                                EventDateTime = (DateTime)wizReader["EVENTSDATETIME"],
                            };

                            records.Add(K);
                        }
                    }
                }
            }

            return records;
        }

        public static List<Job> GetJobNotesList(Int32 JobNumber)
        {
            List<Job> records = new List<Job>();

            String connstring = Connection.GetConnectionString();



            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(StoredProcedure.usp_JOBIMNOTES_GetJobNotes, dbCon))
                {

                    dbCom.CommandType = CommandType.StoredProcedure;
                    dbCom.Parameters.Add(JobNum, SqlDbType.VarChar).Value = JobNumber;
                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            var K = new Job()
                            {
                                Title = (String)wizReader["TITLE"],
                                DownloadLink = (String)wizReader["DOWNLOADLINK"],
                            };

                            records.Add(K);

                        }
                    }
                }
            }

            return records;
        }

        public static String FetchJobApplyURL(Int32 JobNo)
        {
           
            String sql_select = String.Format("SELECT APPLYLINK FROM JOB WHERE JOBNO = {0}", JobNo);
            String connstring = Connection.GetConnectionString();
            String ApplyLinkURL = string.Empty;

            using (SqlConnection dbCon = new SqlConnection(connstring))
            {
                dbCon.Open();

                using (SqlCommand dbCom = new SqlCommand(sql_select, dbCon))
                {

                    dbCom.CommandType = CommandType.Text;
                    
                    using (SqlDataReader wizReader = dbCom.ExecuteReader())
                    {
                        while (wizReader.Read())
                        {
                            ApplyLinkURL = Convert.ToString(wizReader[0]);
                        }
                    }
                }
            }
            return ApplyLinkURL;
        }
    }
}
