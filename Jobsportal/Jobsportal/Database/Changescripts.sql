USE [Jobsportal]
GO
/****** Object:  StoredProcedure [dbo].[usp_ChangePasswordViaReset]    Script Date: 24-07-2019 23:06:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_ChangePasswordViaReset]
	@GUID UNIQUEIDENTIFIER,
	@PASSWORD NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @USERID INT
 
	SELECT @USERID = USERID FROM ResetPasswordRequests WHERE Id= @GUID
 
 IF(@USERID IS NULL)
	 BEGIN
		 
		  SELECT 0 AS IsPasswordChanged
	 END
 ELSE
	 BEGIN
		  Update USERS set PASSWORD = @Password where PERSONID = @UserId
  
		  UPDATE ResetPasswordRequests SET IsDeleted= 0 WHERE ID=@GUID
  
		  SELECT 1 AS IsPasswordChanged

	 END
 
End

GO
/****** Object:  StoredProcedure [dbo].[usp_ModifyPassword]    Script Date: 24-07-2019 23:06:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ModifyPassword]
   @UserName NVARCHAR(100),
	@OldPassword NVARCHAR(100),
	@NewPassword NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON
	
	
 
 IF(@UserName IS NULL)
	 BEGIN
		 
		  SELECT 0 AS IsPasswordChanged
	 END
 ELSE
	 BEGIN
	 IF EXISTS (SELECT USERNAME FROM USERS  where UserName = @UserName and PASSWORD=@OldPassword) 
	 BEGIN
		  Update USERS set PASSWORD = @NewPassword where UserName = @UserName
  
		  SELECT 1 AS IsPasswordChanged

		  END
		  ELSE
		  BEGIN
		  SELECT 0 AS IsPasswordChanged
		  END

	 END
 
End

GO
/****** Object:  StoredProcedure [dbo].[usp_SaveDiscussion]    Script Date: 24-07-2019 23:06:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_SaveDiscussion]
(
	@JobNumber INT,
	@USERNAME NVARCHAR(MAX),
	@MESSAGES NVARCHAR(MAX)
)

AS
 BEGIN

			SET NOCOUNT ON
			DECLARE @CID INT = 0;

			SELECT @CID = MAX(CHATID) FROM DISCUSSION

				IF @CID IS NULL

						BEGIN 

							SET @CID=10000

						END

				ELSE
					   BEGIN 

							SET @CID = @CID + 1


	                   END

			INSERT INTO DISCUSSION(CHATID,USERNAME,JOBNO,MESSAGES,MSGDATETIME) VALUES (@CID,@USERNAME,@JobNumber,@MESSAGES,GETUTCDATE())
 END


GO
