USE [Jobsportal]
GO
/****** Object:  StoredProcedure [dbo].[usp_Job_GetJobDetails]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Job_GetJobDetails]

 @i_DBOP INT,
 @Keyword nvarchar(100)='',
   @Location nvarchar(100)='All',
    @Posted INT='-365'

AS

	BEGIN



		BEGIN TRY

		--SET NOCOUNT ON;
			IF(@i_DBOP=0)
			IF(LEN(@Keyword)>0)
				BEGIN
							SELECT JOBNO,JOBTITLE,JOBDESC,POSTEDDATE,QUALIFICATION,APPLYLINK,POINT = 2*(LEN(JOBTITLE) - LEN(REPLACE(JOBTITLE, @Keyword, '')))/LEN(@Keyword)+1 * (LEN(JOBDESC) - LEN(REPLACE(JOBDESC, @Keyword, '')))/LEN(@Keyword)+ 2 * (LEN(QUALIFICATION) - LEN(REPLACE(QUALIFICATION, @Keyword, '')))/LEN(@Keyword) FROM JOB
					where POSTEDDATE>DATEADD(DAY,@Posted,GETDATE()) and 1=1   order by POINT desc,posteddate desc
				END
ELSE
SELECT JOBNO,JOBTITLE,JOBDESC,POSTEDDATE,QUALIFICATION,APPLYLINK,0 as POINT FROM JOB where POSTEDDATE>DATEADD(DAY,@Posted,GETDATE()) and 1=1 order by posteddate desc
			ELSE

				BEGIN

					SELECT JOBNO,JOBTITLE,JOBDESC,POSTEDDATE,QUALIFICATION,APPLYLINK FROM JOB WHERE JOBNO=@i_DBOP

				END


		END TRY



		BEGIN CATCH

			DECLARE @ErrorMessage NVARCHAR(4000) ;

				DECLARE @ErrorSeverity INT ;

				DECLARE @ErrorState INT ;

				SELECT  @ErrorMessage = ERROR_MESSAGE() ,

						@ErrorSeverity = ERROR_SEVERITY() ,

						@ErrorState = ERROR_STATE()

				RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;

		END CATCH		



	END





GO
/****** Object:  StoredProcedure [dbo].[USP_JOB_INSERTJOBDETAILS]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[USP_JOB_INSERTJOBDETAILS]

(

	@STR_JOBTITLE NVARCHAR(100),

	@STR_JOBDESC NVARCHAR(MAX),

	@DT_JOBPOSTEDDATE DATETIME,

	@STR_QUALIFICATION NVARCHAR(300),

	@STR_APPLYLINK VARCHAR(500),
	@i_intJOBNO INT

)

AS

	BEGIN

		BEGIN TRY

			DECLARE @BIT_SUCCESS INT = 0;

			DECLARE @JOBNUMBER INT;
			if not exists (select JOBTITLE from JOB  where JOBNO =@i_intJOBNO)
			BEGIN
					INSERT INTO JOB(JOBTITLE,JOBDESC,POSTEDDATE,QUALIFICATION,APPLYLINK) VALUES (@STR_JOBTITLE,@STR_JOBDESC,@DT_JOBPOSTEDDATE,@STR_QUALIFICATION,@STR_APPLYLINK)

					SET @BIT_SUCCESS = 1;

					SET @JOBNUMBER= SCOPE_IDENTITY();

			SELECT @JOBNUMBER AS JOB_NUMBER, @BIT_SUCCESS AS SUCCESS 
			END
			ELSE

			BEGIN
								UPDATE JOB SET JOBTITLE=@STR_JOBTITLE,JOBDESC=@STR_JOBDESC,POSTEDDATE=@DT_JOBPOSTEDDATE,QUALIFICATION=@STR_QUALIFICATION, APPLYLINK=@STR_APPLYLINK WHERE JOBNO = @i_intJOBNO
								SET @JOBNUMBER=@i_intJOBNO
								SET @BIT_SUCCESS = 1;

								SELECT @JOBNUMBER AS JOB_NUMBER, @BIT_SUCCESS AS SUCCESS 

			END



		END TRY
		

		BEGIN CATCH

			DECLARE @ErrorMessage NVARCHAR(4000) ;

            DECLARE @ErrorSeverity INT ;

            DECLARE @ErrorState INT ;



            SELECT  @ErrorMessage = ERROR_MESSAGE() ,

                    @ErrorSeverity = ERROR_SEVERITY() ,

                    @ErrorState = ERROR_STATE()



            RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;


       END CATCH

	END



GO
/****** Object:  StoredProcedure [dbo].[USP_JOB_INSERTUPDATE]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_JOB_INSERTUPDATE]
(
	@i_strJOBTITLE NVARCHAR(100),
	@i_strJOBDESC NVARCHAR(MAX),
	@i_dt_POSTEDDATE DATE,
	@i_str_QUALIFICATION NVARCHAR(300),
	@i_intJOBNO INT

)
AS
	BEGIN
		BEGIN TRY

			DECLARE @i_strMessage VARCHAR(200);
			DECLARE @i_bitSuccess BIT = 0;

			if not exists (select JOBTITLE from JOB  where JOBNO =@i_intJOBNO)
				BEGIN

					INSERT INTO JOB(JOBTITLE,JOBDESC,POSTEDDATE,QUALIFICATION) VALUES (@i_strJOBTITLE,@i_strJOBDESC,@i_dt_POSTEDDATE,@i_str_QUALIFICATION)

					SET @i_strMessage = 'Insert Success';
					SET @i_bitSuccess = 1;

				END
			ELSE
				BEGIN

					UPDATE JOB SET JOBTITLE=@i_strJOBTITLE,JOBDESC=@i_strJOBDESC,POSTEDDATE=@i_dt_POSTEDDATE,QUALIFICATION=@i_str_QUALIFICATION  WHERE JOBNO = @i_intJOBNO

					SET @i_strMessage = 'Update Success';
					SET @i_bitSuccess = 1;

				END


			SELECT @i_strMessage AS Message, @i_bitSuccess AS Success 

		END TRY
		
		BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) ;
            DECLARE @ErrorSeverity INT ;
            DECLARE @ErrorState INT ;

            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE()

            RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;
	
       END CATCH
	END

GO
/****** Object:  StoredProcedure [dbo].[USP_JOBEVENTDATETIME_INSERTJOBDETAILS]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[USP_JOBEVENTDATETIME_INSERTJOBDETAILS]
(
	@JobNumber INT,
	@STR_EVENTS NVARCHAR(300),
	@DT_EVENTSDATETIME DATETIME,
	@INT_INSERT INT
	--@STR_JOBTITLE NVARCHAR(100)

)
AS
	BEGIN
		BEGIN TRY

			DECLARE @STR_MESSAGE VARCHAR(200);
			DECLARE @BIT_SUCCESS INT = 0;

			IF @INT_INSERT = 0 
				BEGIN
				--BEGIN TRANSACTION
				Delete JOBIMPDATES where JOBNO=@JobNumber
					INSERT INTO JOBIMPDATES(JOBNO,EVENTS,EVENTSDATETIME) VALUES (@JobNumber,@STR_EVENTS, @DT_EVENTSDATETIME)
					SET @STR_MESSAGE = 'Insert Success';
					SET @BIT_SUCCESS = 1;
				--COMMIT TRANSACTION

				END
			ELSE
				BEGIN

					--UPDATE JOB SET JOBTITLE=@i_strJOBTITLE,JOBDESC=@i_strJOBDESC,POSTEDDATE=@i_dt_POSTEDDATE,QUALIFICATION=@i_str_QUALIFICATION  WHERE JOBNO = @i_intJOBNO

					SET @STR_MESSAGE = 'Update Success';
					SET @BIT_SUCCESS = 1;

				END


			SELECT @STR_MESSAGE AS MESSAGE, @BIT_SUCCESS AS SUCCESS 

		END TRY
		
		BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) ;
            DECLARE @ErrorSeverity INT ;
            DECLARE @ErrorState INT ;

            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE()

            RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;
		--	ROLLBACK TRANSACTION
       END CATCH
	END


GO
/****** Object:  StoredProcedure [dbo].[usp_JOBIMNOTES_GetJobNotes]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_JOBIMNOTES_GetJobNotes]



@JobNumber INT



AS







	BEGIN





		BEGIN TRY





			SELECT TITLE,DOWNLOADLINK FROM JOBIMNOTES WHERE JOBNO=@JobNumber ORDER BY TITLE







		END TRY







		BEGIN CATCH







			DECLARE @ErrorMessage NVARCHAR(4000) ;







				DECLARE @ErrorSeverity INT ;







				DECLARE @ErrorState INT ;







				SELECT  @ErrorMessage = ERROR_MESSAGE() ,







						@ErrorSeverity = ERROR_SEVERITY() ,







						@ErrorState = ERROR_STATE()







				RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;







		END CATCH		





	END
GO
/****** Object:  StoredProcedure [dbo].[USP_JOBIMNOTES_INSERTIMNOTES]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[USP_JOBIMNOTES_INSERTIMNOTES]
(
	@JobNumber INT,
	@STR_TITLE NVARCHAR(300),
	@DT_UPLODEDDATE DATETIME,
	@STR_DOWNLOADLINK NVARCHAR(500),
	@STR_UPLODEDBY VARCHAR(100),
	@INT_INSERT INT

)
AS
	BEGIN
		BEGIN TRY

			DECLARE @STR_MESSAGE VARCHAR(200);
			DECLARE @BIT_SUCCESS INT = 0;

			IF @INT_INSERT = 0 
				BEGIN
				--BEGIN TRANSACTION
				   Delete JOBIMNOTES where JOBNO=@JobNumber
					INSERT INTO JOBIMNOTES(JOBNO,TITLE,DOWNLOADLINK,UPLODEDBY,UPLODEDDATE) VALUES (@JobNumber,@STR_TITLE, @STR_DOWNLOADLINK,@STR_UPLODEDBY,@DT_UPLODEDDATE)
					SET @STR_MESSAGE = 'InsertSuccess';
					SET @BIT_SUCCESS = 1;
				--COMMIT TRANSACTION

				END
			ELSE
				BEGIN

					--UPDATE JOB SET JOBTITLE=@i_strJOBTITLE,JOBDESC=@i_strJOBDESC,POSTEDDATE=@i_dt_POSTEDDATE,QUALIFICATION=@i_str_QUALIFICATION  WHERE JOBNO = @i_intJOBNO

					SET @STR_MESSAGE = 'Update Success';
					SET @BIT_SUCCESS = 1;

				END


			SELECT @STR_MESSAGE AS MESSAGE, @BIT_SUCCESS AS SUCCESS 

		END TRY
		
		BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000) ;
            DECLARE @ErrorSeverity INT ;
            DECLARE @ErrorState INT ;

            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE()

            RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;
		--	ROLLBACK TRANSACTION
       END CATCH
	END



GO
/****** Object:  StoredProcedure [dbo].[usp_JOBIMPDATES_GetEventDateTime]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_JOBIMPDATES_GetEventDateTime]

@JobNumber INT

AS



	BEGIN


		BEGIN TRY


			SELECT EVENTS,EVENTSDATETIME FROM JOBIMPDATES WHERE JOBNO=@JobNumber ORDER BY EVENTSDATETIME



		END TRY



		BEGIN CATCH



			DECLARE @ErrorMessage NVARCHAR(4000) ;



				DECLARE @ErrorSeverity INT ;



				DECLARE @ErrorState INT ;



				SELECT  @ErrorMessage = ERROR_MESSAGE() ,



						@ErrorSeverity = ERROR_SEVERITY() ,



						@ErrorState = ERROR_STATE()



				RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;



		END CATCH		


	END



	--exec usp_JOBIMPDATES_GetEventDateTime
GO
/****** Object:  StoredProcedure [dbo].[USP_PERSON_CANDIDATEINSERTUPDATE]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [dbo].[USP_PERSON_CANDIDATEINSERTUPDATE]



(



	@STR_NAME VARCHAR(100),



	@STR_GENDER VARCHAR(10),



	@DT_DOB DATETIME,



	@STR_ADDRESS VARCHAR(500),



	@STR_EMAIL VARCHAR(50),



	@STR_MOBILE VARCHAR(50),



	@STR_QUALIFICATION NVARCHAR(MAX),



	@STR_EXPERIANCE NVARCHAR(MAX),



	@STR_INTEREST NVARCHAR(500),



	@INT_DBOPERATION INT,



	@STR_CANDIDATEIMG VARCHAR(200)



)



AS



BEGIN



BEGIN TRY







DECLARE @STR_MESSAGE VARCHAR(200);



DECLARE @INT_SUCCESS INT = 0;



DECLARE @INT_MAXID INT=0;



IF @INT_DBOPERATION = 0 



BEGIN

	

	SELECT @INT_MAXID = MAX(ID) FROM PERSON



	IF @INT_MAXID IS NULL

		BEGIN 



			SET @INT_MAXID=10000



		END



    ELSE



	   BEGIN 



			SET @INT_MAXID = @INT_MAXID + 1



	   END



	

	if not exists (select USERNAME from Users  where USERNAME =@STR_MOBILE )
	BEGIN

	INSERT INTO PERSON (PERSONID,NAME,GENDER,DOB,ADDRESS,EMAIL,MOBILE,QUALIFICATION,EXPERIANCE,INTEREST,IMGPATH) VALUES (@INT_MAXID,@STR_NAME,@STR_GENDER,@DT_DOB,@STR_ADDRESS,@STR_EMAIL,@STR_MOBILE,@STR_QUALIFICATION,@STR_EXPERIANCE,@STR_INTEREST,@STR_CANDIDATEIMG)


	END
	ELSE
	BEGIN
	Update person set  NAME=@STR_NAME,GENDER=@STR_GENDER,DOB=@DT_DOB,ADDRESS=@STR_ADDRESS,EMAIL=@STR_EMAIL,QUALIFICATION=@STR_QUALIFICATION,EXPERIANCE=@STR_EXPERIANCE,INTEREST=@STR_INTEREST,IMGPATH=@STR_CANDIDATEIMG where PERSONID=(select PERSONID from Users  where USERNAME =@STR_MOBILE)

	END

	SET @STR_MESSAGE = 'InsertSuccess';



	SET @INT_SUCCESS = 1;







	END



	ELSE



	BEGIN







		UPDATE PERSON SET NAME=@STR_NAME WHERE PERSONID='00000'







		SET @STR_MESSAGE = 'Update Success';



	SET @INT_SUCCESS = 1;







	END











	SELECT @STR_MESSAGE AS Message,



	@INT_SUCCESS AS Success 







	END TRY



	BEGIN CATCH



	   DECLARE @ErrorMessage NVARCHAR(4000) ;



            DECLARE @ErrorSeverity INT ;



            DECLARE @ErrorState INT ;







            SELECT  @ErrorMessage = ERROR_MESSAGE() ,



                    @ErrorSeverity = ERROR_SEVERITY() ,



                    @ErrorState = ERROR_STATE()







            RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;



	



       END CATCH



END















GO
/****** Object:  StoredProcedure [dbo].[USP_PERSON_GETPERSONDETAILS]    Script Date: 06  /29  /2019 21:04:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[USP_PERSON_GETPERSONDETAILS](@phoneno nvarchar(100))

AS

	BEGIN

		BEGIN TRY

			SELECT ID,PERSONID,NAME,GENDER,ISNULL(DOB,'') DOB,ADDRESS,EMAIL,MOBILE,QUALIFICATION,EXPERIANCE,INTEREST,IMGPATH FROM PERSON WHERE PERSONID=(select PERSONID from USERS where USERNAME=@phoneno)


		END TRY

		BEGIN CATCH

			DECLARE @ErrorMessage NVARCHAR(4000) ;







				DECLARE @ErrorSeverity INT ;







				DECLARE @ErrorState INT ;







				SELECT  @ErrorMessage = ERROR_MESSAGE() ,







						@ErrorSeverity = ERROR_SEVERITY() ,







						@ErrorState = ERROR_STATE()







				RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) ;







		END CATCH		





	END




GO
