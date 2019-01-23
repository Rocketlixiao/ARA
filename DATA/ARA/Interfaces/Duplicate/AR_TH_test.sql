
CREATE TABLE AR_TH_TEST (
  ID int identity(1,1) PRIMARY KEY,
  [Name] nvarchar(20) not null,
  [Type] nvarchar(50) null,
  [Number] int null,
  [Anything] float null,
  [Result] float null
)

select * from AR_TH_TEST

GO

CREATE PROCEDURE sp_AR_TH_test_run_sp 
@cnst int = 1
AS
BEGIN

	UPDATE AR_TH_TEST SET
	  [Result] = isnull([Number],1) * [Anything] * @cnst

END

GO

SELECT 
  [Name]
  ,[Type]
  ,isnull([Number],1) AS [Number]
  ,[Anything] AS [Second Number]
  ,[Result]
FROM AR_TH_TEST
