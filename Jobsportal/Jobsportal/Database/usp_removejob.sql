CREATE PROC USP_REMOVEJOB
(
	@JOBNUMBER INT
)
AS
	BEGIN
		
		SET NOCOUNT ON
		
		UPDATE JOB SET IsDeleted=1 WHERE JOBNO=@JOBNUMBER

		
	END