﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DAL
{
    public class StoredProcedure
    {
        public const String sp_LogError = "sp_LogError";

        public const String usp_Job_GetJobDetails = "usp_GetJobDetails";

        public const String usp_JOBIMPDATES_GetEventDateTime = "usp_GetJobImpDates";

        public const String usp_JOBIMNOTES_GetJobNotes = "usp_GetJobImpNotes";

        public const String USP_JOBEVENTDATETIME_INSERTJOBDETAILS = "usp_SaveJobImpDates";

        public const String USP_PERSON_CANDIDATEINSERTUPDATE = "usp_SavePerson";

        public const String USP_JOB_INSERTJOBDETAILS = "usp_SaveJob";

        public const String USP_SIGNUP = "usp_signup";

        public const String USP_PERSON_GETPERSONDETAILS = "usp_GetPersonDetails";

        public const String USP_JOBIMNOTES_INSERTIMNOTES = "usp_SaveJobImpNotes";

        public const String USP_RESETPASSWPRD = "usp_ResetPassword";

        public const String USP_ISPASSWORDRESETLINKISVALID = "usp_IsPwdResetLinkValid";

        public const String USP_MODIFYPASSWORD = "usp_ModifyPassword";
        public const String USP_CHANGEPASSWORDVIARESET = "usp_ChangePasswordViaReset";
        

        public const String USP_FETCHDISSCUSSIONTEXT = "usp_FetchDiscussion";

        public const String USP_INSERTDISSCUSSIONTEXT = "usp_SaveDiscussion";

        public const String USP_REMOVEJOB = "USP_REMOVEJOB";
    }
}