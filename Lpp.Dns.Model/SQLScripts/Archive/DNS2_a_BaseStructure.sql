
/****** Object:  FullTextCatalog [Full_Text_Catalog]    Script Date: 01/05/2012 09:23:10 ******/
CREATE FULLTEXT CATALOG [Full_Text_Catalog]WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION [dbo]
GO
/****** Object:  Table [dbo].[RightsCategories]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RightsCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryDescription] [varchar](200) NULL,
	[CategoryOrder] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[udf_encrypt_password]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_encrypt_password](@password char(10)) RETURNS varchar(50) AS
BEGIN
	
	declare @encrypted_password varchar(50)

	select @encrypted_password = @password

	-- Encrypt and return the password
	exec master..xp_sha1 @password, @encrypted_password OUTPUT
		
	return (@encrypted_password)
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_decrypt_rc4]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_decrypt_rc4](@Data varchar(1000)) RETURNS varchar(50) AS  
BEGIN  
declare @return_code int
exec @return_code = master..xp_rc4_decrypt @Data ,'OtherData', @Data OUTPUT
if @return_code != 0 or @Data is null
begin
Set @Data = null
end
return @Data
END
GO
/****** Object:  Table [dbo].[StratificationCategoryLookUp]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StratificationCategoryLookUp](
	[StratificationType] [varchar](50) NOT NULL,
	[StratificationCategoryId] [int] NOT NULL,
	[CategoryText] [varchar](100) NOT NULL,
	[ClassificationText] [varchar](100) NOT NULL,
	[ClassificationFormat] [varchar](250) NOT NULL,
 CONSTRAINT [PK_StratificationCategoryLookUp] PRIMARY KEY CLUSTERED 
(
	[StratificationType] ASC,
	[StratificationCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StratificationAgeRangeMapping]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[StratificationAgeRangeMapping](
	[SubAgeClassification] [varchar](200) NULL,
	[AgeClassification] [varchar](25) NULL,
	[AgeStratificationCategoryId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split] 
   (  
      @Delimiter varchar(5),
      @List      varchar(8000)
   ) 
   RETURNS @TableOfValues table 
      (  RowID   smallint IDENTITY(1,1), 
         [Value] varchar(50) 
      ) 
AS 
BEGIN
	SET @List = replace(@List, '-', ',')

	  DECLARE @LenString int 

	  WHILE len( @List ) > 0 
		 BEGIN 
	     
			SELECT @LenString = 
			   (CASE charindex( @Delimiter, @List ) 
				   WHEN 0 THEN len( @List ) 
				   ELSE ( charindex( @Delimiter, @List ) -1 )
				END
			   ) 
	                            
			INSERT INTO @TableOfValues 
			   SELECT substring( @List, 1, @LenString )
	            
			SELECT @List = 
			   LTRIM(RTRIM((CASE ( len( @List ) - @LenString ) 
				   WHEN 0 THEN '' 
				   ELSE right( @List, len( @List ) - @LenString - 1 ) 
				END
			   )))
		 END
	  RETURN 
END
GO
/****** Object:  Table [dbo].[SiteThemes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SiteThemes](
	[URLName] [varchar](100) NOT NULL,
	[ThemeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Themes] PRIMARY KEY CLUSTERED 
(
	[URLName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoleTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RoleTypes](
	[RoleTypeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleType] [varchar](200) NULL,
	[Description] [varchar](500) NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueryStatusTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueryStatusTypes](
	[QueryStatusTypeId] [int] NOT NULL,
	[QueryStatusType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_QueryStatusTypes] PRIMARY KEY CLUSTERED 
(
	[QueryStatusTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueriesGroupStratifications]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueriesGroupStratifications](
	[QueryId] [int] NOT NULL,
	[StratificationType] [varchar](50) NOT NULL,
	[StratificationCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_QueriesGroupStratifications] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC,
	[StratificationType] ASC,
	[StratificationCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueryCategory]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueryCategory](
	[QueryCategoryID] [int] NOT NULL,
	[QueryCategory] [varchar](50) NOT NULL,
	[CategoryDescription] [varchar](500) NULL,
	[IsVisibleForSelection] [bit] NULL,
 CONSTRAINT [PK_QueryCategory] PRIMARY KEY CLUSTERED 
(
	[QueryCategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Organizations](
	[OrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationName] [varchar](100) NULL,
	[IsDeleted] [bit] NULL,
	[IsApprovalRequired] [bit] NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Organizations] ADD [OrganizationAcronym] [varchar](100) NULL
ALTER TABLE [dbo].[Organizations] ADD  CONSTRAINT [PK_Organizations_OrganizationId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[GetValueTableOfDelimittedString]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************          
* Name:  [GetValueTableOfDelimittedString]       
* Purpose:  Returns a table output from the string containing the delimited values          
*          
* PARAMETERS          
* Name(Input)        Description               
* -------------    -------------------------------------------          
* @text              Delimited string that needs to be processed          
* @delimchar         Delimitting character          
          
* PARAMETERS          
* Name(Output)        Description               
* -------------    -------------------------------------------          
* @Table            return the table constructed from the Delimitted string          
******************************************************************/          
      
CREATE FUNCTION [dbo].[GetValueTableOfDelimittedString]       
       (      
    @text varchar(max),      
    @delimchar varchar(20)= ''      
       )      
RETURNS @Table TABLE ([Id] int IDENTITY(1, 1) NOT NULL,      
                      [Value]  varchar(100) NOT NULL)       
AS      
BEGIN      
      
  DECLARE @position      int,      
          @textPosition  int,      
          @DelimittedStringLength int,      
          @str      varchar(max),      
          @tmpstr   varchar(max),      
          @leftover varchar(max)        
      
  SET @textPosition = 1      
  SET @leftover = ''      
      
  WHILE @textPosition <= datalength(@text)     
  BEGIN      
      
     SET @DelimittedStringLength = datalength(@text) - datalength(@leftover)      
     SET @tmpstr = ltrim(@leftover + substring(@text, @textPosition, @DelimittedStringLength))      
     SET @textPosition = @textPosition + @DelimittedStringLength      
      
 SET @position = charindex(@delimchar, @tmpstr)      
      
    WHILE @position > 0      
     BEGIN      
       SET @str = substring(@tmpstr, 1, @position - 1)      
       INSERT @Table (Value) VALUES (@str)      
       SET @tmpstr = ltrim(substring(@tmpstr, @position + 1, len(@tmpstr)))      
       SET @position = charindex(@delimchar, @tmpstr)      
     END      
      
 SET @leftover = @tmpstr      
  END      
      
IF ltrim(rtrim(@leftover)) <> ''      
    INSERT @Table (Value) VALUES (@leftover)      
RETURN      
      
END
GO
/****** Object:  UserDefinedFunction [dbo].[CodesToLeft]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CodesToLeft] (@expression VARCHAR(500))
RETURNS VARCHAR(550)
AS
BEGIN
	DECLARE @result VARCHAR(550)
	SET @expression = RTRIM(LTRIM(@expression))
	IF(CHARINDEX('(',@expression)>1)
	BEGIN
		SET @result = SUBSTRING(@expression, (CHARINDEX('(',@expression)), (CHARINDEX(')',@expression))) + ' ' +
				SUBSTRING(@expression, 0, (CHARINDEX('(',@expression)))
	END
	ELSE
	BEGIN
		SET @result = @expression
	END

	RETURN CASE
			WHEN LEN(@result)>0
			THEN @result
			ELSE @expression
			END
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetQueryType]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetQueryType](@QueryTypeId int) RETURNS varchar(20) 
AS
BEGIN
	DECLARE @queryType varchar(20)
	if @QueryTypeId = 8
		Select @queryType = 'File Transfer'
	else if @QueryTypeId > 0 AND @QueryTypeID < 8 
		Select @queryType = 'Summary Table'
	else if @QueryTypeId > 0 AND @QueryTypeID > 8 
		Select @queryType = 'Unknown' 		

    RETURN @queryType
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetKeyValueTableOfDelimittedString]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************          
* Name:  [GetKeyValueTableOfDelimittedString]       
* Purpose:  Returns a table output from the string containing the delimited values          
*          
* PARAMETERS          
* Name(Input)        Description               
* -------------    -------------------------------------------          
* @text              Delimited string that needs to be processed          
* @delimchar         Delimitting character          
          
* PARAMETERS          
* Name(Output)        Description               
* -------------    -------------------------------------------          
* @Table            return the table constructed from the Delimitted string          
******************************************************************/          
      
CREATE FUNCTION [dbo].[GetKeyValueTableOfDelimittedString]       
       (      
    @text varchar(max),      
    @delimchar varchar(20)= ''      
       )      
RETURNS @Table TABLE ([Id] int IDENTITY(1, 1) NOT NULL, 
					  [Key] varchar(100)  NULL,     
                      [Value]  varchar(100) NOT NULL)       
AS      
BEGIN      
      
  DECLARE @position      int,      
          @textPosition  int,      
		  @keyValPosition int,      
          @DelimittedStringLength int,      
          @str      varchar(max),      
          @tmpstr   varchar(max),      
          @leftover varchar(max),        
		  @key		varchar(max),
		  @value	varchar(max)        
      
  SET @textPosition = 1      
  SET @leftover = ''      
      
  WHILE @textPosition <= datalength(@text)     
  BEGIN      
      
     SET @DelimittedStringLength = datalength(@text) - datalength(@leftover)      
     SET @tmpstr = ltrim(@leftover + substring(@text, @textPosition, @DelimittedStringLength))      
     SET @textPosition = @textPosition + @DelimittedStringLength      
      
 SET @position = charindex(@delimchar, @tmpstr)      
      
    WHILE @position > 0      
     BEGIN      
       SET @str = substring(@tmpstr, 1, @position - 1)      
	   --Extract Key,Value from the @str. they are in the form Key=Value 
	   SET @keyValPosition=charindex('=',@str,1)
	   SET @key=substring(@str,1,@keyValPosition-1)
	   SET @value=substring(@str,@keyValPosition+1,datalength(@str)-@keyValPosition) 
       INSERT @Table ([Key],Value) VALUES (@key,@value)      

--       INSERT @Table (Value) VALUES (@str)      
       SET @tmpstr = ltrim(substring(@tmpstr, @position + 1, len(@tmpstr)))      
       SET @position = charindex(@delimchar, @tmpstr)      
     END      
      
 SET @leftover = @tmpstr      
  END      
      
IF ltrim(rtrim(@leftover)) <> ''      
	BEGIN
	   --Extract Key,Value from the @str. they are in the form Key=Value 
	   SET @keyValPosition=charindex('=',@leftover,1)
	   SET @key=substring(@leftover,1,@keyValPosition-1)
	   SET @value=substring(@leftover,@keyValPosition+1,datalength(@leftover)-@keyValPosition) 
       INSERT @Table ([Key],Value) VALUES (@key,@value)      
    END
RETURN      
      
END
GO
/****** Object:  Table [dbo].[LookUpQueryTypeMetrics]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LookUpQueryTypeMetrics](
	[MeticId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
 CONSTRAINT [PK_QueryTypeMetrics] PRIMARY KEY CLUSTERED 
(
	[MeticId] ASC,
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LookUpMetrics]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[LookUpMetrics](
	[MetricId] [int] NOT NULL,
	[MetricDesc] [varchar](50) NULL,
 CONSTRAINT [PK_Metrics] PRIMARY KEY CLUSTERED 
(
	[MetricId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupListValues]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LookupListValues](
	[ListId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[ItemName] [varchar](500) NOT NULL,
	[ItemCode] [varchar](50) NOT NULL,
	[ItemCodeWithNoPeriod] [varchar](50) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_LookupListValues] PRIMARY KEY CLUSTERED 
(
	[ListId] ASC,
	[CategoryId] ASC,
	[ItemName] ASC,
	[ItemCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

CREATE UNIQUE NONCLUSTERED INDEX [ui_ID] ON [dbo].[LookupListValues] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
				
CREATE FULLTEXT INDEX ON LookupListValues
( 
	ItemName
		Language 1033,
	ItemCode
		Language 1033
	) 
KEY INDEX ui_ID; 
GO

/****** Object:  Table [dbo].[LookupLists]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LookupLists](
	[ListId] [int] NOT NULL,
	[ListName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LookupLists] PRIMARY KEY CLUSTERED 
(
	[ListId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupListCategories]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LookupListCategories](
	[ListId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[CategoryName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_LookupListCategories] PRIMARY KEY CLUSTERED 
(
	[ListId] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookUpCategory]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LookUpCategory](
	[LookUpCategoryTypeId] [int] NOT NULL,
	[Name] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[LookUpCategoryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NotificationTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NotificationTypes](
	[NotificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationType] [varchar](50) NULL,
 CONSTRAINT [PK_NotificationTypes_NotificationTypeId] PRIMARY KEY CLUSTERED 
(
	[NotificationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NotificationProcessingConfig]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationProcessingConfig](
	[ConfigName] [nvarchar](255) NOT NULL,
	[ConfigValue] [nvarchar](255) NULL,
 CONSTRAINT [PK_NotificationProcessingConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationFrequency]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NotificationFrequency](
	[FrequencyID] [int] IDENTITY(1,1) NOT NULL,
	[Days] [int] NOT NULL,
	[Description] [varchar](1000) NULL,
 CONSTRAINT [PK_NotificationFrequency_FrequencyID] PRIMARY KEY CLUSTERED 
(
	[FrequencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NewFeatures]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NewFeatures](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CreateDate] [date] NOT NULL,
	[Text] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NetworkResponsesGroups]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NetworkResponsesGroups](
	[ResponseId] [int] NOT NULL,
	[NetworkQueryGroupId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NetworkQueriesGroups]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[NetworkQueriesGroups](
	[NetworkQueryGroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[QueryId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[AggregatedGroupResults] [ntext] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[ApprovedBy] [int] NOT NULL,
	[ApprovedTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NetworkQueryGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EntityTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EntityTypes](
	[EntityTypeID] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EntityTypes] PRIMARY KEY CLUSTERED 
(
	[EntityTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Documents]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Documents](
	[DocId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[Mimetype] [varchar](255) NOT NULL,
	[DocumentContent] [image] NOT NULL,
	[DateAdded] [datetime] NOT NULL,
 CONSTRAINT [Pk_Documents_DocId] PRIMARY KEY CLUSTERED 
(
	[DocId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataMartTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataMartTypes](
	[DataMartTypeId] [int] NOT NULL,
	[DatamartType] [nvarchar](50) NULL,
 CONSTRAINT [PK_DataMartTypes] PRIMARY KEY CLUSTERED 
(
	[DataMartTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventTypeNotificationFrequency]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventTypeNotificationFrequency](
	[EventTypeNotificationFrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[FrequecyId] [int] NOT NULL,
 CONSTRAINT [PK_EventTypeNotificationFrequency] PRIMARY KEY CLUSTERED 
(
	[EventTypeNotificationFrequencyId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventSources]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventSources](
	[EventSourceId] [int] IDENTITY(1,1) NOT NULL,
	[EventSource] [varchar](50) NULL,
 CONSTRAINT [PK_EventSources_EventSourceId] PRIMARY KEY CLUSTERED 
(
	[EventSourceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ICD9Procedures_4_digit]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ICD9Procedures_4_digit](
	[PXNAME] [varchar](200) NULL,
	[Code] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ICD9Procedures]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ICD9Procedures](
	[PXNAME] [varchar](100) NULL,
	[Code] [varchar](4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ICD9Diagnosis_5_digit]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ICD9Diagnosis_5_digit](
	[DXNAME] [varchar](200) NULL,
	[Code] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ICD9Diagnosis_4_digit]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ICD9Diagnosis_4_digit](
	[DXNAME] [varchar](200) NULL,
	[Code] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ICD9Diagnosis]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ICD9Diagnosis](
	[DXNAME] [varchar](200) NULL,
	[Code] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HCPCSProcedures]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HCPCSProcedures](
	[Name] [varchar](250) NULL,
	[Code] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Groups](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](100) NULL,
	[IsDeleted] [bit] NULL,
	[IsApprovalRequired] [bit] NULL,
 CONSTRAINT [PK_Groups_GroupId] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataAvailabilityPeriodCategory]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[DataAvailabilityPeriodCategory](
	[CategoryTypeId] [int] NOT NULL,
	[CategoryType] [varchar](200) NULL,
	[CategoryDescription] [varchar](1000) NULL,
	[IsPublished] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventMessage]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventMessage](
	[EventId] [int] NOT NULL,
	[Message] [varchar](7000) NULL,
 CONSTRAINT [PK_EventMessage] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventTypesCategory]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventTypesCategory](
	[EventTypesCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[EventTypesCategory] [nvarchar](50) NULL,
 CONSTRAINT [PK_DEventTypesCategory] PRIMARY KEY CLUSTERED 
(
	[EventTypesCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventTypes](
	[EventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EventType] [varchar](50) NULL,
	[EventDescription] [varchar](500) NULL,
	[EventOrdinal] [int] NULL,
	[CanbeModified] [bit] NULL,
	[EventTypesCategoryID] [int] NULL,
	[CategoryOrdinal] [int] NULL,
	[AllowSummaryNotification] [bit] NULL,
 CONSTRAINT [PK_EventTypes_EventId] PRIMARY KEY CLUSTERED 
(
	[EventTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[EventTypeNotificationFrequency_view]    Script Date: 01/05/2012 09:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EventTypeNotificationFrequency_view]
AS
SELECT     dbo.EventTypeNotificationFrequency.EventTypeId, dbo.NotificationFrequency.*
FROM         dbo.EventTypeNotificationFrequency INNER JOIN
                      dbo.NotificationFrequency ON dbo.EventTypeNotificationFrequency.FrequecyId = dbo.NotificationFrequency.FrequencyID
GO
/****** Object:  Table [dbo].[DataAvailabilityPeriod]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[DataAvailabilityPeriod](
	[CategoryTypeId] [int] NULL,
	[Period] [varchar](100) NULL,
	[IsPublished] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Events]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[EventSourceId] [int] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[EventDateTime] [datetime] NULL,
 CONSTRAINT [PK_Events_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataMarts](
	[DataMartId] [int] IDENTITY(1,1) NOT NULL,
	[DataMartName] [varchar](200) NULL,
	[Url] [nvarchar](255) NULL,
	[RequiresApproval] [bit] NOT NULL,
	[DataMartTypeId] [int] NOT NULL,
	[AvailablePeriod] [varchar](500) NULL,
	[ContactEmail] [varchar](510) NULL,
	[ContactFirstName] [varchar](100) NULL,
	[ContactLastName] [varchar](100) NULL,
	[ContactPhone] [varchar](15) NULL,
	[SpecialRequirements] [varchar](1000) NULL,
	[UsageRestrictions] [varchar](1000) NULL,
	[isDeleted] [bit] NULL,
	[HealthPlanDescription] [nvarchar](1000) NULL,
	[OrganizationId] [int] NULL,
	[IsGroupDataMart] [bit] NULL,
 CONSTRAINT [PK_DataMarts] PRIMARY KEY CLUSTERED 
(
	[DataMartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookUpValues]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LookUpValues](
	[Name] [varchar](500) NULL,
	[CategoryTypeId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[LookUpQueryTypeMetrics_view]    Script Date: 01/05/2012 09:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Table to associated what metric values are applicable for a selected query type under new query category.
CREATE VIEW [dbo].[LookUpQueryTypeMetrics_view]
AS
SELECT     dbo.LookUpMetrics.*, dbo.LookUpQueryTypeMetrics.QueryTypeId
FROM         dbo.LookUpQueryTypeMetrics INNER JOIN
                      dbo.LookUpMetrics ON dbo.LookUpQueryTypeMetrics.MeticId = dbo.LookUpMetrics.MetricId
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Notifications](
	[NotificationId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationTypeId] [int] NOT NULL,
	[EventId] [int] NULL,
	[UserId] [int] NULL,
	[GeneratedTime] [datetime] NULL,
	[DeliveredTime] [datetime] NULL,
	[OtherData] [varchar](1000) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Notifications] ADD [EncryptedData] [varchar](2000) NULL
ALTER TABLE [dbo].[Notifications] ADD [Priority] [int] NULL
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [PK_Notifications_NotificationId] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NotificationOptions]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationOptions](
	[UserId] [int] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[NotificationTypeId] [int] NOT NULL,
	[FrequencyID] [int] NULL,
	[Days] [int] NULL,
 CONSTRAINT [PK_NotificationOptions_UserId_EventTypeId_NotiFicationTypeId] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[EventTypeId] ASC,
	[NotificationTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationsGroups]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationsGroups](
	[OrganizationId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationsGroups_OrgIdGroupId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[GroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueryTypes](
	[QueryTypeId] [int] identity(1,1) NOT NULL,
	[QueryType] [varchar](50) NOT NULL,
	[QueryDescription] [varchar](500) NULL,
	[IsVisibleForSelection] [bit] NULL,
	[IsAdminQueryType] [bit] NULL,
	[QueryCategoryId] [int] NULL,
 CONSTRAINT [PK_QueryTypes] PRIMARY KEY CLUSTERED 
(
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rights]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rights](
	[RightId] [int] NOT NULL,
	[RightCode] [varchar](100) NULL,
	[Description] [varchar](200) NULL,
	[CategoryId] [int] NULL,
	[CategoryOrdinal] [int] NULL,
 CONSTRAINT [Pk_Rights_RightId] PRIMARY KEY CLUSTERED 
(
	[RightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](100) NULL,
	[isDeleted] [bit] NOT NULL,
	[OrganizationId] [int] NULL,
	[Email] [varchar](50) NULL,
	[RoleTypeId] [int] NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Users] ADD [Title] [varchar](100) NULL
ALTER TABLE [dbo].[Users] ADD [FirstName] [varchar](100) NULL
ALTER TABLE [dbo].[Users] ADD [LastName] [varchar](100) NULL
ALTER TABLE [dbo].[Users] ADD [PasswordEncryptionLength] [int] NULL
ALTER TABLE [dbo].[Users] ADD [Version] [varchar](25) NULL
ALTER TABLE [dbo].[Users] ADD [LastUpdated] [datetime] NULL
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPasswordTrace]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserPasswordTrace](
	[UserId] [int] NOT NULL,
	[Password] [varchar](100) NULL,
	[DateAdded] [datetime] NOT NULL,
	[AddedBy] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserNotificationFrequency]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserNotificationFrequency](
	[UserID] [int] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[FrequencyID] [int] NOT NULL,
 CONSTRAINT [PK_UserNotificationFrequency_UserId_EventTypeId_FrequencyId] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[EventTypeId] ASC,
	[FrequencyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleRightsMap]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleRightsMap](
	[RoleTypeId] [int] NOT NULL,
	[RightId] [int] NOT NULL,
 CONSTRAINT [PK_RoleTypeId_RightId] PRIMARY KEY CLUSTERED 
(
	[RoleTypeId] ASC,
	[RightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationSecureGUID]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[NotificationSecureGUID](
	[NotificationID] [int] NOT NULL,
	[NotificationGUID] [varchar](100) NOT NULL,
	[NotificationUrlParameters] [varchar](1000) NULL,
	[IsActive] [bit] NULL,
UNIQUE NONCLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NotificationGUID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Information]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Information](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QueryTypeId] [int] NULL,
	[Information] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[GetGroupList]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetGroupList](@OrganizationId int) RETURNS varchar(max) 
AS
BEGIN
	DECLARE @groupList varchar(max)

	SELECT @groupList = COALESCE(@groupList + ',', '') + CONVERT(varchar, dbo.Groups.GroupName)
	FROM         dbo.OrganizationsGroups INNER JOIN
                      dbo.Groups ON dbo.OrganizationsGroups.GroupId = dbo.Groups.GroupId
						and isnull(dbo.Groups.isdeleted,0) = 0
	WHERE     (dbo.OrganizationsGroups.OrganizationId = @OrganizationId)

    RETURN @groupList
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUserNameById]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUserNameById](@UserId int) RETURNS varchar(50) 
AS
BEGIN
	DECLARE @userName varchar(50)

	SELECT @userName = dbo.Users.Username 
	FROM dbo.Users
	WHERE dbo.Users.UserId = @UserId

    RETURN @userName
END
GO
/****** Object:  Table [dbo].[Queries]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Queries](
	[QueryId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
	[QueryText] [ntext] NULL,
	[Name] [nvarchar](50) NULL,
	[QueryDescription] [text] NULL,
	[RequestorEmail] [nvarchar](255) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsAdminQuery] [bit] NULL,
	[Priority] [tinyint] NOT NULL,
	[ActivityOfQuery] [varchar](255) NULL,
	[ActivityDescription] [varchar](255) NULL,
	[ActivityPriority] [varchar](50) NULL,
	[ActivityDueDate] [datetime] NULL,
	[IRBApprovalNo] [nvarchar](100) NULL,
 CONSTRAINT [PK_Queries] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PermissionsUsersRights]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsUsersRights](
	[UserId] [int] NOT NULL,
	[RightId] [int] NOT NULL,
 CONSTRAINT [PK_UsersRights_UserIdRightId] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsUsersQueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsUsersQueryTypes](
	[UserId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsUsersQueryTypes] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsUsersDataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsUsersDataMarts](
	[UserId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsUsersDataMarts] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[DataMartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsQueryTypesDataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsQueryTypesDataMarts](
	[DataMartId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsQueryTypesDataMarts_DmartIdQueryTypeId] PRIMARY KEY CLUSTERED 
(
	[DataMartId] ASC,
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsOrganizationsRights]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsOrganizationsRights](
	[OrganizationId] [int] NOT NULL,
	[RightId] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationsRights_OrgIdRightId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[RightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsOrganizationsQueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsOrganizationsQueryTypes](
	[OrganizationId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsOrganizationsQueryTypes_OrgIdQueryTypeId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsOrganizationsDataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsOrganizationsDataMarts](
	[OrganizationId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsOrganizationsDataMarts_OrgIdDatamartId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[DataMartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsGroupsRights]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsGroupsRights](
	[GroupId] [int] NOT NULL,
	[RightId] [int] NOT NULL,
 CONSTRAINT [PK_GroupsRights_GroupIdRightId] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[RightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsGroupsQueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsGroupsQueryTypes](
	[GroupId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsGroupsQueryTypes_GroupIdQueryTypeId] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[QueryTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsGroupsDataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsGroupsDataMarts](
	[GroupId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsGroupsDataMarts_GroupIdDatamartId] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[DataMartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationAdministrators]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationAdministrators](
	[OrganizationId] [int] NOT NULL,
	[AdminUserId] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationAdministrators_OrganizationId_AdminUserId] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[AdminUserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatamartNotifications]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatamartNotifications](
	[DatamartId] [int] NOT NULL,
	[NotificationUserId] [int] NOT NULL,
 CONSTRAINT [PK_DataMartNotifications_DatamartIdAndNotifyUserId] PRIMARY KEY CLUSTERED 
(
	[DatamartId] ASC,
	[NotificationUserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupedDatamartsMap]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupedDatamartsMap](
	[GroupDataMartId] [int] NULL,
	[DataMartId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupAdministrators]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupAdministrators](
	[GroupId] [int] NOT NULL,
	[AdminUserId] [int] NOT NULL,
 CONSTRAINT [PK_GroupAdministrators_GroupId_AdminUserId] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[AdminUserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailNewGroupResult]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailNewGroupResult](
	[EventId] [int] NOT NULL,
	[NetworkQueryGroupId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailEntityAdded]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailEntityAdded](
	[EventID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[DataMartID] [int] NULL,
	[UserID] [int] NULL,
	[OrganizationID] [int] NULL,
	[GroupID] [int] NULL,
	[IsEntityAdded] [bit] NOT NULL,
	[IsSystemEntity] [bit] NULL,
 CONSTRAINT [PK_EventDetailEntityAdded] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailNewResult]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailNewResult](
	[EventId] [int] NOT NULL,
	[ResultId] [int] NOT NULL,
	[DatamartId] [int] NULL,
 CONSTRAINT [PK_EventDetailNewResult_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailQueryTypeDatamartAssociation]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailQueryTypeDatamartAssociation](
	[EventID] [int] NOT NULL,
	[QueryTypeID] [int] NOT NULL,
	[DataMartID] [int] NOT NULL,
	[IsAdded] [bit] NOT NULL,
	[IsRemoved] [bit] NOT NULL,
 CONSTRAINT [PK_EventDetailQueryTypeDatamartAssociation] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailQueryStatusChange]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailQueryStatusChange](
	[EventId] [int] NOT NULL,
	[QueryId] [int] NOT NULL,
	[NewQueryStatusTypeId] [int] NOT NULL,
	[DatamartId] [int] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_EventDetailStatusChange_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailUserUpdated]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailUserUpdated](
	[EventID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_EventDetailUserUpdated] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailViewedResult]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailViewedResult](
	[EventID] [int] NOT NULL,
	[QueryID] [int] NOT NULL,
	[ViewedByID] [int] NOT NULL,
 CONSTRAINT [PK_EventDetailViewedResult] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailSubmitterReminder]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailSubmitterReminder](
	[EventId] [int] NOT NULL,
	[QueryId] [int] NOT NULL,
 CONSTRAINT [PK_EventDetailSubmitterReminder_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailQueryReminder]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailQueryReminder](
	[EventId] [int] NOT NULL,
	[QueryId] [int] NOT NULL,
	[DatamartId] [int] NOT NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_EventDetailQueryReminder_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailNewQueryForQueryAdmin]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailNewQueryForQueryAdmin](
	[EventId] [int] NOT NULL,
	[QueryId] [int] NOT NULL,
	[OrganizationId] [int] NULL,
 CONSTRAINT [PK_EventDetailNewQueryForQueryAdmin_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventDetailNewQuery]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventDetailNewQuery](
	[EventId] [int] NOT NULL,
	[QueryId] [int] NOT NULL,
	[DatamartId] [int] NULL,
 CONSTRAINT [PK_EventDetailNewQuery_EventId] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataMartAvailabilityPeriods]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[DataMartAvailabilityPeriods](
	[QueryId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
	[QueryTypeId] [int] NOT NULL,
	[PeriodCategory] [char](1) NOT NULL,
	[Period] [varchar](10) NULL,
	[isActive] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Query]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Query](
	[QueryId] [int] NOT NULL,
	[QueryXml] [ntext] NOT NULL,
	[Comment] [varchar](500) NULL,
 CONSTRAINT [PK_Query] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueriesDocuments]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueriesDocuments](
	[DocId] [int] NOT NULL,
	[QueryId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QueriesDataMarts]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueriesDataMarts](
	[QueryId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
	[QueryStatusTypeId] [int] NOT NULL,
	[RequestTime] [datetime] NULL,
	[ResponseTime] [datetime] NULL,
	[ErrorMessage] [text] NULL,
	[ErrorDetail] [text] NULL,
	[RejectReason] [text] NULL,
	[IsResultsGrouped] [bit] NULL,
	[RespondedBy] [int] NULL,
 CONSTRAINT [PK_QueriesDataMarts] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC,
	[DataMartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QueriesCachedResults]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueriesCachedResults](
	[QueryId] [int] NOT NULL,
	[AggregatedResultsXml] [ntext] NULL,
	[DateViewed] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUserWithRights]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUserWithRights]  --32,'49'
(  
 @OrganizationId int,
 @RightsTobeChecked varchar (max)
)  
RETURNS @Table TABLE ([UserId] int) 
AS BEGIN
		 If @OrganizationId > 0  
			  
				 --Select RightId From PermissionsUsersRights pur INNER JOIN Users u on pur.UserId = u.UserId and isnull(u.isDeleted,0)= 0 Where pur.UserId = @userId  
				 Insert @Table
				 Select distinct u.userId From RoleRightsMap rrm 
						INNER JOIN Users u 		
						on ISNull(u.IsDeleted,0) = 0	
						AND u.RoleTypeId = rrm.RoleTypeId 
						And rrm.RightId in (Select value from GetValueTableOfDelimittedString(@RightsTobeChecked, ','))			
						Inner JOin Organizations o
						on ISNull(o.IsDeleted,0) = 0
						AND o.OrganizationId = u.OrganizationId
						Where o.OrganizationId = @OrganizationId
						
return
END
GO
/****** Object:  View [dbo].[vw_DataMartNotificationUsers]    Script Date: 01/05/2012 09:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_DataMartNotificationUsers]
AS
SELECT
	dm.DataMartId,
	u.*,o.OrganizationName
FROM DataMarts dm
inner join DatamartNotifications dmf
on dmf.DataMartId = dm.DatamartId
inner join Users u
on u.userId = dmf.NotificationUserId
AND u.isDeleted=0
left join Organizations o
on o.OrganizationId = dm.OrganizationId
and o.isDeleted = 0
WHERE
dm.IsDeleted = 0
GO
/****** Object:  Table [dbo].[QueryOrganizationalDataMart]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueryOrganizationalDataMart](
	[QueryId] [int] NULL,
	[DatMartOrganizationId] [int] NULL,
	[GroupDataMartId] [int] NULL,
	[GroupedBy] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Responses]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Responses](
	[ResponseId] [int] IDENTITY(1,1) NOT NULL,
	[QueryId] [int] NOT NULL,
	[DataMartId] [int] NOT NULL,
	[ResponseXml] [ntext] NULL,
	[UserId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Responses] PRIMARY KEY CLUSTERED 
(
	[ResponseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_SummaryNotification]    Script Date: 01/05/2012 09:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[vw_SummaryNotification]
AS

SELECT
isnull(n.Priority,2) as Priority, 
n.NotificationId,n.NotificationTypeId,n.EventId,et.EventTypeId,et.EventType as 'EventName',n.UserId,n.GeneratedTime,n.Deliveredtime,
n.EncryptedData as OtherData, nGUID.NotificationGUID,nop.FrequencyId,nf.Description as FrequencyDescription
,
Case isnull(nop.FrequencyId,0)
WHEN 10 Then nop.Days
ELSE nf.Days
END 'FrequencyDays'
FROM 
Notifications n
INNER JOIN Events e ON e.EventId = n.EventId
LEFT JOIN EventTypes et on et.EventTypeId=e.EventTypeId
LEFT JOIN NotificationSecureGUID nGUID	on nGUID.NotificationId = n.NotificationId  
LEFT JOIN NotificationOptions nop on nop.EventTypeId=e.EventTypeId and nop.UserId=n.UserId
LEFT JOIN NotificationFrequency nf on nf.FrequencyID = nop.FrequencyId 
WHERE 
DeliveredTime is null and nop.FrequencyId IN(7,8,9,10)
GO
/****** Object:  View [dbo].[vw_Query]    Script Date: 01/05/2012 09:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_Query] as
Select 
q.*,qXML.QueryXml,qXML.Comment 
FROM
Queries q Left Join Query qXML on q.QueryId=qXML.QueryId
GO
/****** Object:  Table [dbo].[QueryResultsViewedStatus]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueryResultsViewedStatus](
	[QueryId] [int] NOT NULL,
	[ResponseId] [int] NOT NULL,
	[ViewedAt] [datetime] NULL,
 CONSTRAINT [PK_QueryId_ResponseId] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC,
	[ResponseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResponsesDocuments]    Script Date: 01/05/2012 09:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResponsesDocuments](
	[DocId] [int] NOT NULL,
	[ResponseId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetQueryStatus]    Script Date: 01/05/2012 09:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetQueryStatus] (@QueryId INT) 
RETURNS VARCHAR(50) 
AS 
BEGIN 

	Declare @TotalQueryDatamarts int
	Declare @TotalCompletedQueryDatamarts int
	Declare @TotalFailedQueryDatamarts int
	Declare @QueryStatusId int = -1

	Select @TotalQueryDatamarts = Count(QueryId) From QueriesDataMarts
	Where QueryId = @QueryId
	and isnull(IsresultsGrouped,0) = 0 -- All
	and QueryStatusTypeId <> 6

	Select @TotalCompletedQueryDatamarts = Count(QueryId) From QueriesDataMarts
	Where QueryId = @QueryId
	and isnull(IsresultsGrouped,0) = 0
	and QueryStatusTypeId = 3 -- Completed
	
	Select @TotalFailedQueryDatamarts = Count(QueryId) From QueriesDataMarts
	Where QueryId = @QueryId
	and isnull(IsresultsGrouped,0) = 0
	and QueryStatusTypeId = 99 -- Failed
	
	Select top 1 @QueryStatusId = QueryStatusTypeId From QueriesDataMarts
	Where QueryId = @QueryId AND QueryStatusTypeId IN(10,11,12)
	
	IF(@QueryStatusId = -1)
		Select top 1 @QueryStatusId = QueryStatusTypeId From QueriesDataMarts
		Where QueryId = @QueryId
		
	Declare @returnStatus varchar(20)

	if (@QueryStatusId = 10)
		set @returnStatus = 'Pending QA Approval'
	else if (@QueryStatusId = 11)
		set @returnStatus = 'Hold'
	else if (@QueryStatusId = 12)
		set @returnStatus = 'Rejected'
	else if (@TotalFailedQueryDatamarts > 0 and @TotalFailedQueryDatamarts =  @TotalQueryDatamarts)
		Set @returnStatus = 'Failed'
	else if (@TotalFailedQueryDatamarts > 0 and @TotalFailedQueryDatamarts <  @TotalQueryDatamarts)
		Set @returnStatus = 'Partially Failed'
	else if (@TotalCompletedQueryDatamarts < @TotalQueryDatamarts)
		Set @returnStatus = Cast(@TotalCompletedQueryDatamarts as varchar(3)) + '/' + cast(@TotalQueryDatamarts as varchar(3)) + ' Completed' 
	else
		Set @returnStatus = 'Completed'

	return @returnStatus

END
GO
/****** Object:  Default [DF__DataAvail__IsPub__0E240DFC]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataAvailabilityPeriod] ADD  DEFAULT ((1)) FOR [IsPublished]
GO
/****** Object:  Default [DF__DataAvail__IsPub__0C3BC58A]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataAvailabilityPeriodCategory] ADD  DEFAULT ((1)) FOR [IsPublished]
GO
/****** Object:  Default [DF__DataMarts__Requi__4E88ABD4]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMarts] ADD  DEFAULT ((0)) FOR [RequiresApproval]
GO
/****** Object:  Default [DF_DataMarts_DataMartType]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMarts] ADD  CONSTRAINT [DF_DataMarts_DataMartType]  DEFAULT ((0)) FOR [DataMartTypeId]
GO
/****** Object:  Default [DF__DataMarts__IsGro__00AA174D]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMarts] ADD  DEFAULT ((0)) FOR [IsGroupDataMart]
GO
/****** Object:  Default [DF__EventType__Canbe__3DE82FB7]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventTypes] ADD  DEFAULT ((1)) FOR [CanbeModified]
GO
/****** Object:  Default [DF__EventType__Event__3EDC53F0]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventTypes] ADD  DEFAULT ((2)) FOR [EventTypesCategoryID]
GO
/****** Object:  Default [DF__EventType__Categ__3FD07829]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventTypes] ADD  DEFAULT ((0)) FOR [CategoryOrdinal]
GO
/****** Object:  Default [DF__Groups__IsApprov__09C96D33]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Groups] ADD  DEFAULT ((0)) FOR [IsApprovalRequired]
GO
/****** Object:  Default [DF__LookupLis__ItemC__6319B466]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[LookupListValues] ADD  DEFAULT ('') FOR [ItemCodeWithNoPeriod]
GO
/****** Object:  Default [DF_NewFeatures_CreateDate]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[NewFeatures] ADD  CONSTRAINT [DF_NewFeatures_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
/****** Object:  Default [DF__Notificat__Encry__53D770D6]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ('') FOR [EncryptedData]
GO
/****** Object:  Default [DF__Notificat__IsAct__55DFB4D9]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[NotificationSecureGUID] ADD  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  Default [DF_Queries_CreatedAt]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Queries] ADD  CONSTRAINT [DF_Queries_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
/****** Object:  Default [DF__Queries__IsDelet__4D2A7347]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Queries] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF__Queries__Priorit__6BCEF5F8]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Queries] ADD  DEFAULT ((0)) FOR [Priority]
GO
/****** Object:  Default [DF__QueriesDa__IsRes__019E3B86]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDataMarts] ADD  DEFAULT ((0)) FOR [IsResultsGrouped]
GO
/****** Object:  Default [DF__QueriesDa__Respo__1A89E4E1]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDataMarts] ADD  DEFAULT (NULL) FOR [RespondedBy]
GO
/****** Object:  Default [DF__QueryType__IsAdm__6BAEFA67]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryTypes] ADD  DEFAULT ((0)) FOR [IsAdminQueryType]
GO
/****** Object:  Default [DF__Responses__IsDel__52E34C9D]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Responses] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
/****** Object:  Default [DF__Users__isDeleted__403A8C7D]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
/****** Object:  Default [DF__Users__PasswordE__6F7F8B4B]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((14)) FOR [PasswordEncryptionLength]
GO
/****** Object:  ForeignKey [FK_DataAvailabilityPeriod_DataAvailabilityPeriodCategory_CategoryTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataAvailabilityPeriod]  WITH CHECK ADD  CONSTRAINT [FK_DataAvailabilityPeriod_DataAvailabilityPeriodCategory_CategoryTypeId] FOREIGN KEY([CategoryTypeId])
REFERENCES [dbo].[DataAvailabilityPeriodCategory] ([CategoryTypeId])
GO
ALTER TABLE [dbo].[DataAvailabilityPeriod] CHECK CONSTRAINT [FK_DataAvailabilityPeriod_DataAvailabilityPeriodCategory_CategoryTypeId]
GO
/****** Object:  ForeignKey [FK_DataMartAvailabilityPeriods_DataMarts_DataMartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMartAvailabilityPeriods]  WITH CHECK ADD  CONSTRAINT [FK_DataMartAvailabilityPeriods_DataMarts_DataMartId] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[DataMartAvailabilityPeriods] CHECK CONSTRAINT [FK_DataMartAvailabilityPeriods_DataMarts_DataMartId]
GO
/****** Object:  ForeignKey [FK_DataMartAvailabilityPeriods_Queries_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMartAvailabilityPeriods]  WITH CHECK ADD  CONSTRAINT [FK_DataMartAvailabilityPeriods_Queries_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[DataMartAvailabilityPeriods] CHECK CONSTRAINT [FK_DataMartAvailabilityPeriods_Queries_QueryId]
GO
/****** Object:  ForeignKey [FK_DataMartAvailabilityPeriods_QueryTypes_QueryTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMartAvailabilityPeriods]  WITH CHECK ADD  CONSTRAINT [FK_DataMartAvailabilityPeriods_QueryTypes_QueryTypeId] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[DataMartAvailabilityPeriods] CHECK CONSTRAINT [FK_DataMartAvailabilityPeriods_QueryTypes_QueryTypeId]
GO
/****** Object:  ForeignKey [FK_DatamartNotifications_Datamarts_DatamartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DatamartNotifications]  WITH CHECK ADD  CONSTRAINT [FK_DatamartNotifications_Datamarts_DatamartId] FOREIGN KEY([DatamartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[DatamartNotifications] CHECK CONSTRAINT [FK_DatamartNotifications_Datamarts_DatamartId]
GO
/****** Object:  ForeignKey [FK_DatamartNotifications_users_NotificationUserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DatamartNotifications]  WITH CHECK ADD  CONSTRAINT [FK_DatamartNotifications_users_NotificationUserId] FOREIGN KEY([NotificationUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[DatamartNotifications] CHECK CONSTRAINT [FK_DatamartNotifications_users_NotificationUserId]
GO
/****** Object:  ForeignKey [FK_DataMarts_DataMartTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[DataMarts]  WITH CHECK ADD  CONSTRAINT [FK_DataMarts_DataMartTypes] FOREIGN KEY([DataMartTypeId])
REFERENCES [dbo].[DataMartTypes] ([DataMartTypeId])
GO
ALTER TABLE [dbo].[DataMarts] CHECK CONSTRAINT [FK_DataMarts_DataMartTypes]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_DataMarts] FOREIGN KEY([DataMartID])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_DataMarts]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_EntityTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_EntityTypes] FOREIGN KEY([EntityTypeID])
REFERENCES [dbo].[EntityTypes] ([EntityTypeID])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_EntityTypes]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_Events]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_Events] FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_Events]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_Groups]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_Groups] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_Groups]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_Organizations]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_Organizations] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_Organizations]
GO
/****** Object:  ForeignKey [FK_EventDetailEntityAdded_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailEntityAdded]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailEntityAdded_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventDetailEntityAdded] CHECK CONSTRAINT [FK_EventDetailEntityAdded_Users]
GO
/****** Object:  ForeignKey [FK_Events_EventDetailNewGroupResult_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewGroupResult]  WITH CHECK ADD  CONSTRAINT [FK_Events_EventDetailNewGroupResult_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailNewGroupResult] CHECK CONSTRAINT [FK_Events_EventDetailNewGroupResult_EventId]
GO
/****** Object:  ForeignKey [FK_Events_EventDetailNewGroupResult_NetworkQueryGroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewGroupResult]  WITH CHECK ADD  CONSTRAINT [FK_Events_EventDetailNewGroupResult_NetworkQueryGroupId] FOREIGN KEY([NetworkQueryGroupId])
REFERENCES [dbo].[NetworkQueriesGroups] ([NetworkQueryGroupId])
GO
ALTER TABLE [dbo].[EventDetailNewGroupResult] CHECK CONSTRAINT [FK_Events_EventDetailNewGroupResult_NetworkQueryGroupId]
GO
/****** Object:  ForeignKey [FK_datamarts_EventDetailNewQuery]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQuery]  WITH CHECK ADD  CONSTRAINT [FK_datamarts_EventDetailNewQuery] FOREIGN KEY([DatamartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailNewQuery] CHECK CONSTRAINT [FK_datamarts_EventDetailNewQuery]
GO
/****** Object:  ForeignKey [FK_EventDetailNewQueryAndEvents_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQuery]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailNewQueryAndEvents_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailNewQuery] CHECK CONSTRAINT [FK_EventDetailNewQueryAndEvents_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailNewQueryAndQueries_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQuery]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailNewQueryAndQueries_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[EventDetailNewQuery] CHECK CONSTRAINT [FK_EventDetailNewQueryAndQueries_QueryId]
GO
/****** Object:  ForeignKey [FK_EventDetailNewQueryAndEventsForQueryAdmin_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailNewQueryAndEventsForQueryAdmin_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin] CHECK CONSTRAINT [FK_EventDetailNewQueryAndEventsForQueryAdmin_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailNewQueryAndQueriesForQueryAdmin_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailNewQueryAndQueriesForQueryAdmin_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin] CHECK CONSTRAINT [FK_EventDetailNewQueryAndQueriesForQueryAdmin_QueryId]
GO
/****** Object:  ForeignKey [FK_Organizations_EventDetailNewQueryForQueryAdmin]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_EventDetailNewQueryForQueryAdmin] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[EventDetailNewQueryForQueryAdmin] CHECK CONSTRAINT [FK_Organizations_EventDetailNewQueryForQueryAdmin]
GO
/****** Object:  ForeignKey [FK_datamarts_EventDetailNewResult]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewResult]  WITH CHECK ADD  CONSTRAINT [FK_datamarts_EventDetailNewResult] FOREIGN KEY([DatamartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailNewResult] CHECK CONSTRAINT [FK_datamarts_EventDetailNewResult]
GO
/****** Object:  ForeignKey [FK_EventDetailNewResultAndEvents_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailNewResult]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailNewResultAndEvents_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailNewResult] CHECK CONSTRAINT [FK_EventDetailNewResultAndEvents_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryReminder_UserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryReminder_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventDetailQueryReminder] CHECK CONSTRAINT [FK_EventDetailQueryReminder_UserId]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryReminderAnddatamarts_DatamartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryReminderAnddatamarts_DatamartId] FOREIGN KEY([DatamartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailQueryReminder] CHECK CONSTRAINT [FK_EventDetailQueryReminderAnddatamarts_DatamartId]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryReminderAndEvents_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryReminderAndEvents_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailQueryReminder] CHECK CONSTRAINT [FK_EventDetailQueryReminderAndEvents_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryReminderAndQueries_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryReminderAndQueries_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[EventDetailQueryReminder] CHECK CONSTRAINT [FK_EventDetailQueryReminderAndQueries_QueryId]
GO
/****** Object:  ForeignKey [FK_datamarts_EventDetailQueryStatusChange]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryStatusChange]  WITH CHECK ADD  CONSTRAINT [FK_datamarts_EventDetailQueryStatusChange] FOREIGN KEY([DatamartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailQueryStatusChange] CHECK CONSTRAINT [FK_datamarts_EventDetailQueryStatusChange]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryStatusChange_Users_UserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryStatusChange]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryStatusChange_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventDetailQueryStatusChange] CHECK CONSTRAINT [FK_EventDetailQueryStatusChange_Users_UserId]
GO
/****** Object:  ForeignKey [FK_EventDetailStatusChangeAndEvents_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryStatusChange]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailStatusChangeAndEvents_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailQueryStatusChange] CHECK CONSTRAINT [FK_EventDetailStatusChangeAndEvents_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryTypeDatamartAssociation_DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_DataMarts] FOREIGN KEY([DataMartID])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation] CHECK CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_DataMarts]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryTypeDatamartAssociation_Events]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_Events] FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation] CHECK CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_Events]
GO
/****** Object:  ForeignKey [FK_EventDetailQueryTypeDatamartAssociation_QueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_QueryTypes] FOREIGN KEY([QueryTypeID])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[EventDetailQueryTypeDatamartAssociation] CHECK CONSTRAINT [FK_EventDetailQueryTypeDatamartAssociation_QueryTypes]
GO
/****** Object:  ForeignKey [FK_EventDetailSubmitterReminder_EventId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailSubmitterReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailSubmitterReminder_EventId] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailSubmitterReminder] CHECK CONSTRAINT [FK_EventDetailSubmitterReminder_EventId]
GO
/****** Object:  ForeignKey [FK_EventDetailSubmitterReminder_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailSubmitterReminder]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailSubmitterReminder_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[EventDetailSubmitterReminder] CHECK CONSTRAINT [FK_EventDetailSubmitterReminder_QueryId]
GO
/****** Object:  ForeignKey [FK_EventDetailUserUpdated_Events]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailUserUpdated]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailUserUpdated_Events] FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailUserUpdated] CHECK CONSTRAINT [FK_EventDetailUserUpdated_Events]
GO
/****** Object:  ForeignKey [FK_EventDetailUserUpdated_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailUserUpdated]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailUserUpdated_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventDetailUserUpdated] CHECK CONSTRAINT [FK_EventDetailUserUpdated_Users]
GO
/****** Object:  ForeignKey [FK_EventDetailViewedResult_Events]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailViewedResult]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailViewedResult_Events] FOREIGN KEY([EventID])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventDetailViewedResult] CHECK CONSTRAINT [FK_EventDetailViewedResult_Events]
GO
/****** Object:  ForeignKey [FK_EventDetailViewedResult_Queries]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailViewedResult]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailViewedResult_Queries] FOREIGN KEY([QueryID])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[EventDetailViewedResult] CHECK CONSTRAINT [FK_EventDetailViewedResult_Queries]
GO
/****** Object:  ForeignKey [FK_EventDetailViewedResult_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[EventDetailViewedResult]  WITH CHECK ADD  CONSTRAINT [FK_EventDetailViewedResult_Users] FOREIGN KEY([ViewedByID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventDetailViewedResult] CHECK CONSTRAINT [FK_EventDetailViewedResult_Users]
GO
/****** Object:  ForeignKey [FK_EventsAndEventSources_EventSourceId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_EventsAndEventSources_EventSourceId] FOREIGN KEY([EventSourceId])
REFERENCES [dbo].[EventSources] ([EventSourceId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_EventsAndEventSources_EventSourceId]
GO
/****** Object:  ForeignKey [FK_EventsAndEventTypes_EventTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_EventsAndEventTypes_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventTypes] ([EventTypeId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_EventsAndEventTypes_EventTypeId]
GO
/****** Object:  ForeignKey [FK_GroupAdministrators_Groups_GroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[GroupAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_GroupAdministrators_Groups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[GroupAdministrators] CHECK CONSTRAINT [FK_GroupAdministrators_Groups_GroupId]
GO
/****** Object:  ForeignKey [FK_GroupAdministrators_Users_AdminUserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[GroupAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_GroupAdministrators_Users_AdminUserId] FOREIGN KEY([AdminUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[GroupAdministrators] CHECK CONSTRAINT [FK_GroupAdministrators_Users_AdminUserId]
GO
/****** Object:  ForeignKey [FK_GroupedDatamartsMap_DataMarts_DataMartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[GroupedDatamartsMap]  WITH CHECK ADD  CONSTRAINT [FK_GroupedDatamartsMap_DataMarts_DataMartId] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[GroupedDatamartsMap] CHECK CONSTRAINT [FK_GroupedDatamartsMap_DataMarts_DataMartId]
GO
/****** Object:  ForeignKey [FK_GroupedDatamartsMap_DataMarts_GroupDataMartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[GroupedDatamartsMap]  WITH CHECK ADD  CONSTRAINT [FK_GroupedDatamartsMap_DataMarts_GroupDataMartId] FOREIGN KEY([GroupDataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[GroupedDatamartsMap] CHECK CONSTRAINT [FK_GroupedDatamartsMap_DataMarts_GroupDataMartId]
GO
/****** Object:  ForeignKey [FK__Informati__Query__151B244E]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Information]  WITH CHECK ADD FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
/****** Object:  ForeignKey [FK__LookUpVal__Categ__10566F31]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[LookUpValues]  WITH CHECK ADD FOREIGN KEY([CategoryTypeId])
REFERENCES [dbo].[LookUpCategory] ([LookUpCategoryTypeId])
GO
/****** Object:  ForeignKey [FK_NotificationOptionsAndNotificationTypes_NotificationTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[NotificationOptions]  WITH CHECK ADD  CONSTRAINT [FK_NotificationOptionsAndNotificationTypes_NotificationTypeId] FOREIGN KEY([NotificationTypeId])
REFERENCES [dbo].[NotificationTypes] ([NotificationTypeId])
GO
ALTER TABLE [dbo].[NotificationOptions] CHECK CONSTRAINT [FK_NotificationOptionsAndNotificationTypes_NotificationTypeId]
GO
/****** Object:  ForeignKey [FK_NotificationsAndNotificationTypes_NotificationTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_NotificationsAndNotificationTypes_NotificationTypeId] FOREIGN KEY([NotificationTypeId])
REFERENCES [dbo].[NotificationTypes] ([NotificationTypeId])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_NotificationsAndNotificationTypes_NotificationTypeId]
GO
/****** Object:  ForeignKey [Fk_NotificationId_Notifications_NotificationSecureGUID]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[NotificationSecureGUID]  WITH CHECK ADD  CONSTRAINT [Fk_NotificationId_Notifications_NotificationSecureGUID] FOREIGN KEY([NotificationID])
REFERENCES [dbo].[Notifications] ([NotificationId])
GO
ALTER TABLE [dbo].[NotificationSecureGUID] CHECK CONSTRAINT [Fk_NotificationId_Notifications_NotificationSecureGUID]
GO
/****** Object:  ForeignKey [FK_OrganizationAdministrators_Organizations_OrganizationId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[OrganizationAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationAdministrators_Organizations_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[OrganizationAdministrators] CHECK CONSTRAINT [FK_OrganizationAdministrators_Organizations_OrganizationId]
GO
/****** Object:  ForeignKey [FK_OrganizationAdministrators_Users_AdminUserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[OrganizationAdministrators]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationAdministrators_Users_AdminUserId] FOREIGN KEY([AdminUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[OrganizationAdministrators] CHECK CONSTRAINT [FK_OrganizationAdministrators_Users_AdminUserId]
GO
/****** Object:  ForeignKey [FK_Groups_OrgsGroups_GroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[OrganizationsGroups]  WITH CHECK ADD  CONSTRAINT [FK_Groups_OrgsGroups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[OrganizationsGroups] CHECK CONSTRAINT [FK_Groups_OrgsGroups_GroupId]
GO
/****** Object:  ForeignKey [FK_Organizations_OrgsGroups_OrgId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[OrganizationsGroups]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_OrgsGroups_OrgId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[OrganizationsGroups] CHECK CONSTRAINT [FK_Organizations_OrgsGroups_OrgId]
GO
/****** Object:  ForeignKey [FK_DataMarts_PermissionsGroupsDataMarts_DatamartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_DataMarts_PermissionsGroupsDataMarts_DatamartId] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[PermissionsGroupsDataMarts] CHECK CONSTRAINT [FK_DataMarts_PermissionsGroupsDataMarts_DatamartId]
GO
/****** Object:  ForeignKey [FK_Groups_PermissionsGroupsDataMarts_GroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_Groups_PermissionsGroupsDataMarts_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[PermissionsGroupsDataMarts] CHECK CONSTRAINT [FK_Groups_PermissionsGroupsDataMarts_GroupId]
GO
/****** Object:  ForeignKey [FK_Groups_PermissionsGroupsQueryTypes_GroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_Groups_PermissionsGroupsQueryTypes_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[PermissionsGroupsQueryTypes] CHECK CONSTRAINT [FK_Groups_PermissionsGroupsQueryTypes_GroupId]
GO
/****** Object:  ForeignKey [FK_QueryType_PermissionsGroupsQueryTypes_QueryTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_QueryType_PermissionsGroupsQueryTypes_QueryTypeId] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[PermissionsGroupsQueryTypes] CHECK CONSTRAINT [FK_QueryType_PermissionsGroupsQueryTypes_QueryTypeId]
GO
/****** Object:  ForeignKey [FK_Groups_GroupsRights_GroupId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsRights]  WITH CHECK ADD  CONSTRAINT [FK_Groups_GroupsRights_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([GroupId])
GO
ALTER TABLE [dbo].[PermissionsGroupsRights] CHECK CONSTRAINT [FK_Groups_GroupsRights_GroupId]
GO
/****** Object:  ForeignKey [FK_Rights_GroupsRights_RightId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsGroupsRights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_GroupsRights_RightId] FOREIGN KEY([RightId])
REFERENCES [dbo].[Rights] ([RightId])
GO
ALTER TABLE [dbo].[PermissionsGroupsRights] CHECK CONSTRAINT [FK_Rights_GroupsRights_RightId]
GO
/****** Object:  ForeignKey [FK_DataMarts_PermissionsOrganizationsDataMarts_DatamartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_DataMarts_PermissionsOrganizationsDataMarts_DatamartId] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsDataMarts] CHECK CONSTRAINT [FK_DataMarts_PermissionsOrganizationsDataMarts_DatamartId]
GO
/****** Object:  ForeignKey [FK_Organizations_PermissionsOrganizationsDataMarts_OrgId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_PermissionsOrganizationsDataMarts_OrgId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsDataMarts] CHECK CONSTRAINT [FK_Organizations_PermissionsOrganizationsDataMarts_OrgId]
GO
/****** Object:  ForeignKey [FK_Organizations_PermissionsOrganizationsQueryTypes_OrgId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_PermissionsOrganizationsQueryTypes_OrgId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsQueryTypes] CHECK CONSTRAINT [FK_Organizations_PermissionsOrganizationsQueryTypes_OrgId]
GO
/****** Object:  ForeignKey [FK_QueryTypes_PermissionsOrganizationsQueryTypes_QueryTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_QueryTypes_PermissionsOrganizationsQueryTypes_QueryTypeId] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsQueryTypes] CHECK CONSTRAINT [FK_QueryTypes_PermissionsOrganizationsQueryTypes_QueryTypeId]
GO
/****** Object:  ForeignKey [FK_Organizations_OrganizationsRights_OrgId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsRights]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_OrganizationsRights_OrgId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsRights] CHECK CONSTRAINT [FK_Organizations_OrganizationsRights_OrgId]
GO
/****** Object:  ForeignKey [FK_Rights_OrganizationsRights_RightId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsOrganizationsRights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_OrganizationsRights_RightId] FOREIGN KEY([RightId])
REFERENCES [dbo].[Rights] ([RightId])
GO
ALTER TABLE [dbo].[PermissionsOrganizationsRights] CHECK CONSTRAINT [FK_Rights_OrganizationsRights_RightId]
GO
/****** Object:  ForeignKey [FK_Organizations_PermissionsQueryTypesDataMarts_DatamartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsQueryTypesDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_PermissionsQueryTypesDataMarts_DatamartId] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[PermissionsQueryTypesDataMarts] CHECK CONSTRAINT [FK_Organizations_PermissionsQueryTypesDataMarts_DatamartId]
GO
/****** Object:  ForeignKey [FK_QueryTypes_PermissionsQueryTypesDataMarts_QueryTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsQueryTypesDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_QueryTypes_PermissionsQueryTypesDataMarts_QueryTypeId] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[PermissionsQueryTypesDataMarts] CHECK CONSTRAINT [FK_QueryTypes_PermissionsQueryTypesDataMarts_QueryTypeId]
GO
/****** Object:  ForeignKey [FK_PermissionsUsersDataMarts_DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_PermissionsUsersDataMarts_DataMarts] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[PermissionsUsersDataMarts] CHECK CONSTRAINT [FK_PermissionsUsersDataMarts_DataMarts]
GO
/****** Object:  ForeignKey [FK_PermissionsUsersDataMarts_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_PermissionsUsersDataMarts_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[PermissionsUsersDataMarts] CHECK CONSTRAINT [FK_PermissionsUsersDataMarts_Users]
GO
/****** Object:  ForeignKey [FK_PermissionsUsersQueryTypes_QueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_PermissionsUsersQueryTypes_QueryTypes] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[PermissionsUsersQueryTypes] CHECK CONSTRAINT [FK_PermissionsUsersQueryTypes_QueryTypes]
GO
/****** Object:  ForeignKey [FK_PermissionsUsersQueryTypes_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersQueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_PermissionsUsersQueryTypes_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[PermissionsUsersQueryTypes] CHECK CONSTRAINT [FK_PermissionsUsersQueryTypes_Users]
GO
/****** Object:  ForeignKey [FK_Rights_UsersRight_RightsId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersRights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_UsersRight_RightsId] FOREIGN KEY([RightId])
REFERENCES [dbo].[Rights] ([RightId])
GO
ALTER TABLE [dbo].[PermissionsUsersRights] CHECK CONSTRAINT [FK_Rights_UsersRight_RightsId]
GO
/****** Object:  ForeignKey [FK_Users_UsersRight_UserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[PermissionsUsersRights]  WITH CHECK ADD  CONSTRAINT [FK_Users_UsersRight_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[PermissionsUsersRights] CHECK CONSTRAINT [FK_Users_UsersRight_UserId]
GO
/****** Object:  ForeignKey [FK_Queries_QueryTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Queries]  WITH CHECK ADD  CONSTRAINT [FK_Queries_QueryTypes] FOREIGN KEY([QueryTypeId])
REFERENCES [dbo].[QueryTypes] ([QueryTypeId])
GO
ALTER TABLE [dbo].[Queries] CHECK CONSTRAINT [FK_Queries_QueryTypes]
GO
/****** Object:  ForeignKey [FK_Queries_Users]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Queries]  WITH CHECK ADD  CONSTRAINT [FK_Queries_Users] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Queries] CHECK CONSTRAINT [FK_Queries_Users]
GO
/****** Object:  ForeignKey [Fk_Queries_ViewedQueriesResults_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesCachedResults]  WITH CHECK ADD  CONSTRAINT [Fk_Queries_ViewedQueriesResults_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[QueriesCachedResults] CHECK CONSTRAINT [Fk_Queries_ViewedQueriesResults_QueryId]
GO
/****** Object:  ForeignKey [FK_QueriesDataMarts_DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_QueriesDataMarts_DataMarts] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[QueriesDataMarts] CHECK CONSTRAINT [FK_QueriesDataMarts_DataMarts]
GO
/****** Object:  ForeignKey [FK_QueriesDataMarts_Queries]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_QueriesDataMarts_Queries] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[QueriesDataMarts] CHECK CONSTRAINT [FK_QueriesDataMarts_Queries]
GO
/****** Object:  ForeignKey [FK_QueriesDataMarts_QueryStatusTypes]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDataMarts]  WITH CHECK ADD  CONSTRAINT [FK_QueriesDataMarts_QueryStatusTypes] FOREIGN KEY([QueryStatusTypeId])
REFERENCES [dbo].[QueryStatusTypes] ([QueryStatusTypeId])
GO
ALTER TABLE [dbo].[QueriesDataMarts] CHECK CONSTRAINT [FK_QueriesDataMarts_QueryStatusTypes]
GO
/****** Object:  ForeignKey [Fk_QueriesDocuments_Documents_DocId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDocuments]  WITH CHECK ADD  CONSTRAINT [Fk_QueriesDocuments_Documents_DocId] FOREIGN KEY([DocId])
REFERENCES [dbo].[Documents] ([DocId])
GO
ALTER TABLE [dbo].[QueriesDocuments] CHECK CONSTRAINT [Fk_QueriesDocuments_Documents_DocId]
GO
/****** Object:  ForeignKey [Fk_QueriesDocuments_Queries_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueriesDocuments]  WITH CHECK ADD  CONSTRAINT [Fk_QueriesDocuments_Queries_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[QueriesDocuments] CHECK CONSTRAINT [Fk_QueriesDocuments_Queries_QueryId]
GO
/****** Object:  ForeignKey [FK_Query_Queries]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Query]  WITH CHECK ADD  CONSTRAINT [FK_Query_Queries] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[Query] CHECK CONSTRAINT [FK_Query_Queries]
GO
/****** Object:  ForeignKey [FK_QueryOrganizationalDataMart_DataMarts_DataMartId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryOrganizationalDataMart]  WITH CHECK ADD  CONSTRAINT [FK_QueryOrganizationalDataMart_DataMarts_DataMartId] FOREIGN KEY([GroupDataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[QueryOrganizationalDataMart] CHECK CONSTRAINT [FK_QueryOrganizationalDataMart_DataMarts_DataMartId]
GO
/****** Object:  ForeignKey [FK_QueryOrganizationalDataMart_Organizations_OrganizationId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryOrganizationalDataMart]  WITH CHECK ADD  CONSTRAINT [FK_QueryOrganizationalDataMart_Organizations_OrganizationId] FOREIGN KEY([DatMartOrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[QueryOrganizationalDataMart] CHECK CONSTRAINT [FK_QueryOrganizationalDataMart_Organizations_OrganizationId]
GO
/****** Object:  ForeignKey [FK_QueryOrganizationalDataMart_Queries_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryOrganizationalDataMart]  WITH CHECK ADD  CONSTRAINT [FK_QueryOrganizationalDataMart_Queries_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[QueryOrganizationalDataMart] CHECK CONSTRAINT [FK_QueryOrganizationalDataMart_Queries_QueryId]
GO
/****** Object:  ForeignKey [FK_QueryResultsViewedStatus_QueryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryResultsViewedStatus]  WITH CHECK ADD  CONSTRAINT [FK_QueryResultsViewedStatus_QueryId] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[QueryResultsViewedStatus] CHECK CONSTRAINT [FK_QueryResultsViewedStatus_QueryId]
GO
/****** Object:  ForeignKey [FK_QueryResultsViewedStatus_ResponseId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryResultsViewedStatus]  WITH CHECK ADD  CONSTRAINT [FK_QueryResultsViewedStatus_ResponseId] FOREIGN KEY([ResponseId])
REFERENCES [dbo].[Responses] ([ResponseId])
GO
ALTER TABLE [dbo].[QueryResultsViewedStatus] CHECK CONSTRAINT [FK_QueryResultsViewedStatus_ResponseId]
GO
/****** Object:  ForeignKey [FK_QueryTypes_QueryCategory_QueryCategoryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[QueryTypes]  WITH CHECK ADD  CONSTRAINT [FK_QueryTypes_QueryCategory_QueryCategoryId] FOREIGN KEY([QueryCategoryId])
REFERENCES [dbo].[QueryCategory] ([QueryCategoryID])
GO
ALTER TABLE [dbo].[QueryTypes] CHECK CONSTRAINT [FK_QueryTypes_QueryCategory_QueryCategoryId]
GO
/****** Object:  ForeignKey [FK_Responses_DataMarts]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Responses]  WITH CHECK ADD  CONSTRAINT [FK_Responses_DataMarts] FOREIGN KEY([DataMartId])
REFERENCES [dbo].[DataMarts] ([DataMartId])
GO
ALTER TABLE [dbo].[Responses] CHECK CONSTRAINT [FK_Responses_DataMarts]
GO
/****** Object:  ForeignKey [FK_Responses_Queries]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Responses]  WITH CHECK ADD  CONSTRAINT [FK_Responses_Queries] FOREIGN KEY([QueryId])
REFERENCES [dbo].[Queries] ([QueryId])
GO
ALTER TABLE [dbo].[Responses] CHECK CONSTRAINT [FK_Responses_Queries]
GO
/****** Object:  ForeignKey [FK_Responses_Users_UserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Responses]  WITH CHECK ADD  CONSTRAINT [FK_Responses_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Responses] CHECK CONSTRAINT [FK_Responses_Users_UserId]
GO
/****** Object:  ForeignKey [Fk_ResponsesDocuments_Documents_DocId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[ResponsesDocuments]  WITH CHECK ADD  CONSTRAINT [Fk_ResponsesDocuments_Documents_DocId] FOREIGN KEY([DocId])
REFERENCES [dbo].[Documents] ([DocId])
GO
ALTER TABLE [dbo].[ResponsesDocuments] CHECK CONSTRAINT [Fk_ResponsesDocuments_Documents_DocId]
GO
/****** Object:  ForeignKey [Fk_ResponsesDocuments_Responses_ResponseId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[ResponsesDocuments]  WITH CHECK ADD  CONSTRAINT [Fk_ResponsesDocuments_Responses_ResponseId] FOREIGN KEY([ResponseId])
REFERENCES [dbo].[Responses] ([ResponseId])
GO
ALTER TABLE [dbo].[ResponsesDocuments] CHECK CONSTRAINT [Fk_ResponsesDocuments_Responses_ResponseId]
GO
/****** Object:  ForeignKey [FK_Rights_CategoryId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Rights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[RightsCategories] ([CategoryId])
GO
ALTER TABLE [dbo].[Rights] CHECK CONSTRAINT [FK_Rights_CategoryId]
GO
/****** Object:  ForeignKey [FK_RoleRightsMap_Rights_RightId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[RoleRightsMap]  WITH CHECK ADD  CONSTRAINT [FK_RoleRightsMap_Rights_RightId] FOREIGN KEY([RightId])
REFERENCES [dbo].[Rights] ([RightId])
GO
ALTER TABLE [dbo].[RoleRightsMap] CHECK CONSTRAINT [FK_RoleRightsMap_Rights_RightId]
GO
/****** Object:  ForeignKey [FK_RoleRightsMap_RoleTypes_RoleTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[RoleRightsMap]  WITH CHECK ADD  CONSTRAINT [FK_RoleRightsMap_RoleTypes_RoleTypeId] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[RoleTypes] ([RoleTypeId])
GO
ALTER TABLE [dbo].[RoleRightsMap] CHECK CONSTRAINT [FK_RoleRightsMap_RoleTypes_RoleTypeId]
GO
/****** Object:  ForeignKey [FK_UserNotificationFrequency_EventTypeID]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[UserNotificationFrequency]  WITH CHECK ADD  CONSTRAINT [FK_UserNotificationFrequency_EventTypeID] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EventTypes] ([EventTypeId])
GO
ALTER TABLE [dbo].[UserNotificationFrequency] CHECK CONSTRAINT [FK_UserNotificationFrequency_EventTypeID]
GO
/****** Object:  ForeignKey [FK_UserNotificationFrequency_FrequencyID]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[UserNotificationFrequency]  WITH CHECK ADD  CONSTRAINT [FK_UserNotificationFrequency_FrequencyID] FOREIGN KEY([FrequencyID])
REFERENCES [dbo].[NotificationFrequency] ([FrequencyID])
GO
ALTER TABLE [dbo].[UserNotificationFrequency] CHECK CONSTRAINT [FK_UserNotificationFrequency_FrequencyID]
GO
/****** Object:  ForeignKey [FK_UserNotificationFrequency_UserID]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[UserNotificationFrequency]  WITH CHECK ADD  CONSTRAINT [FK_UserNotificationFrequency_UserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserNotificationFrequency] CHECK CONSTRAINT [FK_UserNotificationFrequency_UserID]
GO
/****** Object:  ForeignKey [Fk_UserPwdTrace_Users_ChangedBy]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[UserPasswordTrace]  WITH CHECK ADD  CONSTRAINT [Fk_UserPwdTrace_Users_ChangedBy] FOREIGN KEY([AddedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserPasswordTrace] CHECK CONSTRAINT [Fk_UserPwdTrace_Users_ChangedBy]
GO
/****** Object:  ForeignKey [Fk_UserPwdTrace_Users_UserId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[UserPasswordTrace]  WITH CHECK ADD  CONSTRAINT [Fk_UserPwdTrace_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserPasswordTrace] CHECK CONSTRAINT [Fk_UserPwdTrace_Users_UserId]
GO
/****** Object:  ForeignKey [FK_Users_Organizations_OrgId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Organizations_OrgId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Organizations_OrgId]
GO
/****** Object:  ForeignKey [FK_Users_RoleTypes_RoleTypeId]    Script Date: 01/05/2012 09:23:07 ******/
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_RoleTypes_RoleTypeId] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[RoleTypes] ([RoleTypeId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_RoleTypes_RoleTypeId]
GO

/****** Object:  StoredProcedure [dbo].[uspGetAgeGroups]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAgeGroups] 
AS BEGIN
Select AgeGroup
FROM AgeGroup 
ORDER BY Id
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartAuditReport]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartAuditReport]
(
@DataMartId int,
@StartDate datetime,
@EndDate datetime,
@UserId int,
@OrderBy VARCHAR(550),
@LastChangeDate datetime = NULL
)
AS BEGIN
DECLARE @strSELECT VARCHAR(8000)
DECLARE @strFROM VARCHAR(5000)
DECLARE @strWHERE VARCHAR(3000)
DECLARE @strOrder VARCHAR(3000)

SET @strSELECT = 'SELECT dbo.Queries.QueryId, dbo.QueriesDataMarts.DataMartId, dbo.Users.Username AS [QuerySubmitter], dbo.Queries.Name AS [QueryName], dbo.Queries.QueryDescription AS [QueryDescription],
        dbo.GetQueryType(dbo.Queries.QueryTypeId) AS [QueryType], SUBSTRING(dbo.Queries.QueryText, PATINDEX(''%WHERE%'', dbo.Queries.QueryText), 
        DATALENGTH(dbo.Queries.QueryText)) AS [QueryItems], dbo.Queries.CreatedAt AS [DateSubmitted],
         dbo.QueryStatusTypes.QueryStatusType AS [CurrentStatus], dbo.QueryTypes.QueryType AS [QueryTypeDetail],
			
			CASE WHEN dbo.QueriesDataMarts.ResponseTime IS NOT NULL 
				then dbo.QueriesDataMarts.ResponseTime
                   Else
					dbo.QueriesDataMarts.RequestTime END AS [LastChangeDate], ''' + 
					
		CAST(@StartDate AS VARCHAR(25)) + ''' AS [StartDate], ''' + CAST(@EndDate AS VARCHAR(25)) + ''' AS [EndDate],dbo.GetUserNameById(' + CAST(@UserId AS VARCHAR(10)) + ') AS [UserName],
		dbo.DataMarts.DataMartName, dbo.GetUserNameById(dbo.Queries.CreatedByUserId) AS Investigator,
		dbo.GetUserNameById(dbo.Responses.UserId) AS Administrator,
		CASE dbo.QueriesDataMarts.QueryStatusTypeId 
		WHEN 3 THEN DATEDIFF(d,dbo.Queries.CreatedAt, COALESCE (dbo.QueriesDataMarts.ResponseTime,dbo.QueriesDataMarts.RequestTime))
		WHEN 5 THEN DATEDIFF(d,dbo.Queries.CreatedAt, COALESCE (dbo.QueriesDataMarts.RequestTime,GETDATE()))
		WHEN 6 THEN DATEDIFF(d,dbo.Queries.CreatedAt, COALESCE (dbo.QueriesDataMarts.RequestTime,GETDATE()))
		WHEN 99 THEN DATEDIFF(d,dbo.Queries.CreatedAt, COALESCE (dbo.QueriesDataMarts.RequestTime,GETDATE()))
		ELSE DATEDIFF(d,dbo.Queries.CreatedAt, GETDATE())
		END AS OpenDays'
		
SET @strFROM = ' FROM   dbo.QueriesDataMarts INNER JOIN
        dbo.QueryStatusTypes ON dbo.QueriesDataMarts.QueryStatusTypeId = dbo.QueryStatusTypes.QueryStatusTypeId INNER JOIN
         dbo.Queries ON dbo.QueriesDataMarts.QueryId = dbo.Queries.QueryId INNER JOIN
          dbo.Users ON dbo.Queries.CreatedByUserId = dbo.Users.UserId INNER JOIN
            dbo.QueryTypes ON dbo.Queries.QueryTypeId = dbo.QueryTypes.QueryTypeId INNER JOIN
            dbo.DataMarts ON dbo.QueriesDataMarts.DataMartId = dbo.DataMarts.DataMartId LEFT OUTER JOIN 
            dbo.Responses ON dbo.QueriesDataMarts.QueryId = dbo.Responses.QueryId AND dbo.QueriesDataMarts.DataMartId = dbo.Responses.DataMartId'
		
SET @strWHERE = ' WHERE (dbo.QueriesDataMarts.DataMartId =' +  CAST(@DataMartId AS VARCHAR(10)) + ') AND (dbo.QueriesDataMarts.RequestTime BETWEEN ''' + CAST(@StartDate AS VARCHAR(25)) + ''' AND ''' +  CAST(@EndDate AS VARCHAR(25))+ ''')'

SET @OrderBy = CASE @OrderBy
			WHEN 'ID' THEN 'Queries.QueryId, Queries.CreatedAt'
			WHEN 'Date Submitted' THEN 'Queries.CreatedAt'
			WHEN 'Last Change' THEN 'QueriesDataMarts.RequestTime'
			WHEN 'Name' THEN 'Queries.Name'
			WHEN 'Type' THEN 'QueryType, QueryTypes.QueryType, Queries.CreatedAt'
			WHEN 'Query Type Detail' THEN 'QueryTypes.QueryType, Queries.CreatedAt'
			WHEN 'Days Open' THEN 'OpenDays, Queries.QueryId'
			WHEN 'Status' THEN 'Queries.CreatedAt, QueryTypes.QueryType'
			WHEN 'Investigator' THEN 'Investigator, Queries.CreatedAt'
			WHEN 'Administrator' THEN 'Administrator, QueriesDataMarts.RequestTime'
		 END
		 		
SET @strORDER = ' ORDER BY ' + @OrderBy

EXEC(@strSELECT + @strFROM + @strWHERE + @strORDER)

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGender]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGender] 
AS BEGIN
Select Code , Description
FROM Gender 
ORDER BY Id
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetEntitiesByType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetEntitiesByType] 
(
	@entityTypeId int,
	@isSortByText  bit = 1
)
AS BEGIN
if @entityTypeId > 0
BEGIN
	if (@isSortByText = 1)
		SELECT Id, [Name] as Name1, [Code] as Name2, Description, EntityTypeId From Entity 
		Where EntityTypeId = @entityTypeId order by Name asc
	else 
		SELECT Id, [Name] as Name2, [Code] as Name1, Description, EntityTypeId From Entity 
		Where EntityTypeId = @entityTypeId order by Code asc
END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetMFUOutputCritieriaList]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetMFUOutputCritieriaList] 
AS

Declare @tab Table(numrecords int)
Insert @tab select 5
Insert @tab select 10
Insert @tab select 20
Insert @tab select 25
Insert @tab select 50
Insert @tab select 100

Select numrecords as 'OutputRecords' From  @tab
GO
/****** Object:  StoredProcedure [dbo].[uspSearchLookupListValues]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSearchLookupListValues]
	@ListId INT,
	@SearchText VARCHAR(500)
AS 
BEGIN
	DECLARE @index int
	DECLARE @ParseText VARCHAR(500)
	
	SET @ParseText = REPLACE(RTRIM(LTRIM(@SearchText)), '*', '%') -- Replacing * with %
	
	SET @SearchText = REPLACE(RTRIM(LTRIM(@SearchText)), '%', '') -- Removing % sign from original search string
	
	SET @index = PatIndex('%[0-9]%', @SearchText) -- Check if its ItemCode or ItemName
	
	IF (@SearchText = '') GOTO Search_NoSearchText

	--ELSE IF (@ListId = 7 AND (@index = 1 OR @index = 2 OR @index = 3)) GOTO Search_ItemCode
	
	ELSE IF (@index = 1 OR @index = 2) GOTO Search_ItemCode

	ELSE GOTO Search_ItemName

Search_ItemCode:
	IF(@ParseText = '%') -- Find All for that ListId
		BEGIN
			SELECT ItemName, ItemCode, ItemCodeWithNoPeriod
			FROM LookupListValues
			WHERE listid = @ListId
			ORDER BY ItemCode
		END
		
	ELSE IF (CHARINDEX('%', @ParseText)>0 AND LEN(@ParseText)>1)	-- e.g. A1010* or *A1010 or *A10*10*
		BEGIN
			SELECT ItemName, ItemCode, ItemCodeWithNoPeriod
			FROM LookupListValues
			WHERE listid = @ListId AND ItemCode LIKE @ParseText 
			ORDER BY ItemCode
		END
			
	ELSE IF (CHARINDEX(',', @SearchText)>0) -- e.g. G0328,G0260
		BEGIN
			DECLARE @Cnt int
			DECLARE @SearchValue VARCHAR(250)
			DECLARE @tblResult TABLE(ItemName VARCHAR(500), ItemCode varchar(50), ItemCodeWithNoPeriod varchar(50))
			DECLARE @SplitTable TABLE(ROWID INT, value VARCHAR(500))
			
			INSERT INTO @SplitTable SELECT * FROM dbo.Split( ',', @SearchText ) AS s 

			SELECT @Cnt = Count(*) from @SplitTable

			WHILE @Cnt > 0 
			BEGIN 
				SELECT @SearchValue = [value] from  @SplitTable where ROWID = @Cnt
				
				INSERT INTO @tblResult 
				SELECT ItemName, ItemCode, ItemCodeWithNoPeriod
				FROM LookupListValues
				WHERE listid = @ListId AND ItemCode Like @SearchValue
				ORDER BY ItemCode
				SET @Cnt = @Cnt - 1	
			END

			SELECT ItemCode, ItemName,ItemCodeWithNoPeriod FROM @tblResult ORDER BY ItemCode
		END
			
	ELSE IF (CHARINDEX('-', @SearchText)>0) -- e.g. G0328-G0260
		BEGIN
			DECLARE @From VARCHAR(50)
			DECLARE @To VARCHAR(50)
		
			SET @From = SUBSTRING(@SearchText, 1, CAST(CHARINDEX('-', @SearchText) AS INT)-1)
			SET @To = SUBSTRING(@SearchText, CAST(CHARINDEX('-', @SearchText) AS INT)+1, len(@SearchText))
			
			SELECT ItemName, ItemCode,ItemCodeWithNoPeriod
			FROM LookupListValues
			WHERE listid = @ListId AND ItemCode >= @From AND ItemCode <= @To
			ORDER BY ItemCode
			
		END
	ELSE								-- e.g. G0328
		BEGIN
			SELECT ItemName, ItemCode, ItemCodeWithNoPeriod
			FROM LookupListValues
			WHERE listid = @ListId AND ItemCode = @SearchText
			ORDER BY ItemCode
		END
	RETURN
	
Search_ItemName:
	BEGIN
		IF (CHARINDEX('%', @ParseText) = 0) 
			BEGIN
				SET @SearchText = REPLACE(@ParseText, '%', '')
				
				SELECT ItemName, ItemCode,ItemCodeWithNoPeriod FROM LookupListValues  
				WHERE listid = @ListId AND FREETEXT (ItemName, @SearchText )
				GROUP BY ItemName, ItemCode,ItemCodeWithNoPeriod
				ORDER BY ItemCode
			END
		ELSE		
			BEGIN
				SELECT ItemName, ItemCode,ItemCodeWithNoPeriod FROM LookupListValues  
				WHERE listid = @ListId AND ItemName LIKE @ParseText 
				GROUP BY ItemName, ItemCode,ItemCodeWithNoPeriod
				ORDER BY ItemCode
			END
	END
	RETURN
Search_NoSearchText:	
	BEGIN
		SELECT ItemName, ItemCode,ItemCodeWithNoPeriod FROM LookupListValues	
		WHERE 0 = 1;
	END
	RETURN	
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveRole]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveRole] --1
(
	@RoleTypeId int,
	@Role varchar(200),
	@RoleDescription varchar(500),
	@IsDeleted bit
)
AS BEGIN
	If @RoleTypeId > 0
		BEGIN
			UPDATE RoleTypes Set RoleType = @Role,
								 Description  = @RoleDescription,
								 IsDeleted = @IsDeleted
			Where RoleTypeId = @RoleTypeId 
		END
	Else
		BEGIN
			 INSERT INTO RoleTypes Values (@Role,@RoleDescription,@IsDeleted)
		END 
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveNotificationProcessingConfig]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uspSaveNotificationProcessingConfig]
@SettingName nvarchar(255)
,@SettingValue nvarchar(255)
AS

Begin

Declare @return_val int

Update NotificationProcessingConfig Set ConfigValue=@SettingValue Where ConfigName=@SettingName

if(@@ROWCOUNT>0) Set @return_val=0 else Set @return_val=-1

Return(@return_val)

End
GO
/****** Object:  StoredProcedure [dbo].[uspSaveDocument]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveDocument]  
(  
 @DocId int,  
 @Name varchar(255),  
 @FileName varchar(255),  
 @MimeType varchar(255),  
 @Content Image  
)  
AS BEGIN  
  
Declare @Return_Val int  
if @Content Is null  
 Set @Content = 0x0  
  
 If @DocId > 0  
  BEGIN  
   Update Documents Set Name = @Name, fileName = @fileName, MimeType = @MimeType,   
   Documentcontent = @Content, DateAdded = GetDate() Where DocId = @DocId  
     
   Set @Return_Val = @DocId  
  END   
 else  
  BEGIN  
   INSERT INTO Documents (Name, FileName,MimeType,DocumentContent, DateAdded) values  
   (@Name,@fileName,@MimeType, @Content, GetDate())  
  
   Select @Return_Val = SCOPE_IDENTITY()  
  END  
  
Select @Return_Val  
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetStratificationCategoryList]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetStratificationCategoryList]
	@StratificationType VARCHAR(50)
AS BEGIN
	SELECT *, CategoryText + ' ' + ClassificationText as Description from StratificationCategoryLookUp
	WHERE StratificationType = @StratificationType
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSiteTheme]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSiteTheme] 
(
	@URLName varchar(100)
)
AS
BEGIN
	SELECT ThemeName From SiteThemes
	Where URLName = @URLName
END
-------------------------------------------------------------------------------------------------------------
GO
/****** Object:  StoredProcedure [dbo].[uspSaveQueryGroupStratification]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveQueryGroupStratification]
	@QueryId	INT,
	@StratificationType VARCHAR(50),
	@StratificationCategoryId	INT
AS BEGIN

	if (@QueryId > 0)
		BEGIN
			INSERT INTO QueriesGroupStratifications (QueryId, StratificationType, StratificationCategoryId)
			VALUES (@QueryId, @StratificationType, @StratificationCategoryId)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryGroupStratification]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryGroupStratification]
	@QueryId	INT,
	@StratificationType VARCHAR(50)
AS BEGIN

	if (@QueryId > 0)
		BEGIN
			SELECT qgs.*, scl.CategoryText, scl.ClassificationText, scl.ClassificationFormat FROM QueriesGroupStratifications qgs
			LEFT JOIN StratificationCategoryLookUp scl
			ON qgs.StratificationType = scl.StratificationType AND qgs.StratificationCategoryId = scl.StratificationCategoryId
			WHERE qgs.QueryId = @QueryId AND qgs.StratificationType = @StratificationType
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryGroupResponseById]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryGroupResponseById] --39,2
(	
	@QueryId int,
	@QueryGroupIds varchar(1000)= ''
)
AS
BEGIN

if @QueryGroupIds <> ''
	BEGIN
		SELECT 		
			nqg.NetworkQueryGroupId,
			nqg.AggregatedGroupResults
		FROM 
			NetworkQueriesGroups nqg		
		WHERE 		
			 nqg.NetworkQueryGroupId in ( Select value from GetValueTableOfDelimittedString (@QueryGroupIds,','))
	END
else
	BEGIN
		SELECT 		
			nqg.NetworkQueryGroupId,
			nqg.AggregatedGroupResults
		FROM 
			NetworkQueriesGroup nqg		
		WHERE 		
			 nqg.QueryId = @QueryId	
	END

END
GRANT EXEC ON uspGetQueryGroupResponseById TO PUBLIC
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryCategories]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Pass 0 for all
CREATE PROCEDURE [dbo].[uspGetQueryCategories]
	@CategoryId INT = 0,
	@VisibleForSelection INT = 1
AS
BEGIN
	SELECT QueryCategoryId, QueryCategory, CategoryDescription
	FROM QueryCategory
	WHERE QueryCategoryID = CASE @CategoryId 
							WHEN 0 THEN QueryCategoryID
							ELSE @CategoryId
							END
		  AND IsVisibleForSelection = CASE @VisibleForSelection
									  WHEN 2 THEN IsVisibleForSelection
									  ELSE @VisibleForSelection
									  END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRoleTypeById]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetRoleTypeById] --1,0
(
	@RoleTypeId int
)
AS BEGIN
SELECT * FROM RoleTypes where RoleTypeId = @RoleTypeId and isDeleted = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizations]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizations]  --'2', 1    
(@OrganizationIds varchar(500),        
 @ExcludeIdsPassed bit      
)      
AS BEGIN      
 If (@ExcludeIdsPassed = 0)      
  BEGIN      
  -- Get only user details for Ids passed in      
   Select o.OrganizationId, o.OrganizationName,o.isDeleted, o.OrganizationAcronym from Organizations o    
   Where o.OrganizationId in (Select Value From GetValueTableOfDelimittedString (@OrganizationIds,','))       
 AND isnull(o.IsDeleted,0) =0     
  END      
 ELSE      
  BEGIN      
  -- Get User detials for anybody other than passed in Ids      
   Select o.OrganizationId, o.OrganizationName,o.isDeleted, o.OrganizationAcronym from Organizations o    
   Where isnull(o.IsDeleted,0) =0     
   AND o.OrganizationId not in (Select Value From GetValueTableOfDelimittedString (@OrganizationIds,','))       
        
  END      
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetPatientCodes]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetPatientCodes]
(
 @isSortByText  bit = 1  
) 
AS BEGIN
if  (@isSortByText = 1  )
	Select ICD.PXNAME as Name1 , ICD.Code as Name2
	FROM ICD9Procedures ICD
	ORDER BY ICD.PXNAME
Else 
	Select ICD.Code as Name1 , ICD.PXNAME as Name2
	FROM ICD9Procedures ICD
	ORDER BY ICD.Code
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLookupListCategoryValues]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[uspGetLookupListCategoryValues]
	@ListId INT,
	@CategoryId INT
AS 

BEGIN
	SELECT * FROM LookupListValues  
	WHERE listid = @ListId AND CategoryId = @CategoryId
	ORDER by ItemName
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLookupListCategories]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetLookupListCategories]
	@ListId INT
AS 

BEGIN
IF(@ListId<10)
	BEGIN
		select ListId, CategoryId, dbo.CodesToLeft(CategoryName)as CategoryName  from LookupListCategories 
		where listid = @ListId
		order by CategoryName
	END
ELSE
	BEGIN	
		select ListId, CategoryId, CategoryName  from LookupListCategories 
		where listid = @ListId
		order by CategoryId
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLatestFeatures]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetLatestFeatures] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 1 [Text] from NewFeatures order by CreateDate Desc,[ID] desc
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetICD9Diagnosis]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetICD9Diagnosis] --0
(  
 @isSortByText  bit = 1    
)   
	AS BEGIN  
	if  (@isSortByText = 1  )  
	 Select ICD9D.DXNAME as Name1 , ICD9D.Code as Name2  
	 FROM ICD9Diagnosis ICD9D  
	 ORDER BY ICD9D.DXNAME  
	Else   
	 Select ICD9D.Code as Name1 , ICD9D.DXNAME as Name2  
	 FROM ICD9Diagnosis ICD9D  
	 ORDER BY ICD9D.Code  
	END
GO
/****** Object:  StoredProcedure [dbo].[uspGetHCPCSProcedures]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetHCPCSProcedures] --0 
(  
 @isSortByText  bit = 1    
)   
AS BEGIN  
if  (@isSortByText = 1  )  
 Select HCPCS.NAME as Name1 , HCPCS.Code as Name2  
 FROM HCPCSProcedures HCPCS  
 ORDER BY HCPCS.NAME  
Else   
 Select HCPCS.Code as Name1 , HCPCS.NAME as Name2  
 FROM HCPCSProcedures HCPCS  
 ORDER BY HCPCS.Code  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationById]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationById]     
(    
 @OrganizationId int    
)    
AS BEGIN    
 If @OrganizationId > 0    
  BEGIN    
   Select o.OrganizationId, o.OrganizationName, case when isnull(o.IsDeleted,0)= 0 then 'false' else 'true' end as IsDeleted, o.IsApprovalRequired,
   o.OrganizationAcronym    
 from Organizations o Where o.OrganizationId = @OrganizationId and isNull(isDeleted,0) = 0       
  END    
      
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationProcessingSetting]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uspGetNotificationProcessingSetting]
@SettingName nvarchar(255)
AS
BEGIN
Declare @return_val int

Select @SettingName,ConfigValue From NotificationProcessingConfig Where ConfigName = @SettingName

if(@@ROWCOUNT>0) Set @return_val=0 else Set @return_val=-1

return(@return_val)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetEntities]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspGetEntities]
	@EntityTypeId INT = 0
AS
BEGIN
	SELECT et.EntityTypeID, et.EntityType
	FROM EntityTypes et
	WHERE et.EntityTypeID = CASE @EntityTypeId
						 WHEN 0 THEN et.EntityTypeID
						 ELSE @EntityTypeId
						 END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDocument]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDocument] --20
(
	@DocId int	
)
AS BEGIN
	If @DocId > 0
		BEGIN
		SELECT * from Documents d Where d.DocId = @DocId
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupById]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupById]
(
@GroupId int
)
AS BEGIN
	SELECT grp.* from Groups grp Where ISnull(IsDeleted,0) = 0 and GroupId = @GroupId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAvailableDataMartTypes]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAvailableDataMartTypes]
AS BEGIN
Select dmt.DataMartTypeId
	 , dmt.DataMartType	 
FROM DataMartTypes dmt
END

--Select * from DataMartTypes

--Select * from Users

--SP_HelpText uspGetAllDataMarts
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllQueryStatusTypes]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllQueryStatusTypes]
AS

SELECT	*
FROM	QueryStatusTypes
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllRoleTypes]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllRoleTypes]
AS

SELECT	*
FROM	RoleTypes Where isDeleted = 0
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizations]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizations]     
AS BEGIN    
Select o.OrganizationId, o.OrganizationName, case when isnull(IsDeleted,0)= 0 then 'false' else 'true' end as IsDeleted,
o.OrganizationAcronym    
FROM Organizations o    
Where ISNULL(o.IsDeleted,0) = 0    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAgeStartificationMappings]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAgeStartificationMappings]
(
@StratificationCategoryId int
)
AS BEGIN
	Select * from StratificationAgeRangeMapping Where AgeStratificationCategoryId = @StratificationCategoryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroups]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllGroups]
AS BEGIN
	SELECT grp.* from Groups grp Where isnull(IsDeleted,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroupedQueryDataMartsByQueryId]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllGroupedQueryDataMartsByQueryId] --35
	@QueryId INT
AS

SELECT 
	nqg.Name as NetworkQueryGroupName, nqg.ApprovedTime as ResponseTime, nqg.NetworkQueryGroupId, nqg.OrganizationId
FROM NetworkQueriesGroups nqg

WHERE 
	nqg.QueryId=@QueryId
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteOrganization]
(
	@OrganizationId int	
)
AS BEGIN
	If @OrganizationId > 0
		BEGIN
			Update Organizations Set IsDeleted = 1 Where OrganizationId = @OrganizationId
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteDataMart]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteDataMart]  
(@DatamartId int)  
AS BEGIN  
	If (@DatamartId <> 0)  
	 BEGIN  
		Update DataMarts Set IsDeleted = 1 Where DataMartId = @DataMartId
	 END
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateDMClientUpdateEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspCreateDMClientUpdateEvent]
@EventSourceId int,  
@EventTypeId int
AS
BEGIN
	BEGIN TRANSACTION    
	DECLARE @EventId INT
	INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES    
	(@EventSourceId,@EventTypeId,GetDate())  

	IF @@ERROR <> 0  
	BEGIN    
		ROLLBACK    
		SELECT -1 AS returnValue--Error while inserting to events table    
		RETURN  
	END    
	ELSE
	BEGIN  
		COMMIT
		SELECT @EventId = Scope_Identity() 
		SELECT @EventId as returnValue
		RETURN   
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteGroup]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteGroup]
(
	@GroupId int	
)
AS BEGIN
	If @GroupId > 0
		BEGIN
			Update Groups Set IsDeleted = 1 Where GroupId = @GroupId

			If @@Error = 0
			 Delete from OrganizationsGroups Where GroupId = @GroupId			
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewEventForNetworkMessage]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateNewEventForNetworkMessage]
(
@EventSourceId int,
@EventTypeId int,
@NetworMessage varchar(7000)
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
 (@EventSourceId,@EventTypeId,GetDate())

	if @@Error <> 0
	  BEGIN  
		  ROLLBACK  
		  Select -1 as returnValue--Error while inserting to events table  
					--This will be used to trace issue on the part of query caused the issue
		  return
	  END  
	else
		Select @EventId = Scope_Identity()  

if (@EventId > 0)
	BEGIN
		INSERT INTO EventMessage([EventId], [Message])
			VALUES(@EventId, @NetworMessage)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace issue on which part of query caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
--return @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllDataMarts]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllDataMarts] --'DatamartName', 1
(
@SortColumn varchar(20),
@IsDescending bit
)
AS BEGIN
Select dm.DatamartId
	 , dm.DataMartName
	 , dm.Url
	 , dm.RequiresApproval
	 , dm.DataMartTypeId
	 , dm.OrganizationId	 
	 , dm.AvailablePeriod
	 , dm.ContactEmail
	 , dm.ContactFirstName
	 , dm.ContactLastName
	 , dm.ContactPhone
	 , dm.SpecialRequirements
	 , dm.UsageRestrictions
	 , dmt.DataMartType	 
	 , dm.HealthPlanDescription	 
FROM DataMarts dm
inner Join DataMartTypes dmt
on dmt.DataMartTypeId = dm.DataMartTypeId
left join Organizations o
on o.OrganizationId = dm.OrganizationId
Where ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0
Order by CASE @IsDescending                                      
		  WHEN 1 THEN               
				Case  @SortColumn                             
					When 'DatamartName' then dm.DataMartName                           
					When 'Type' then dmt.DataMartType                             
					Else dm.DataMartName                             
				END              
		  END DESC,
		CASE @IsDescending                                      
		  WHEN 0 THEN               
				Case  @SortColumn                             
					When 'DatamartName' then dm.DataMartName                           
					When 'Type' then dmt.DataMartType                             
					Else dm.DataMartName                             
				END              
		  END     
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllActiveUsers]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllActiveUsers] --4
AS BEGIN
SELECT u.*,o.OrganizationName FROM Users u
INNER Join Organizations o
on o.OrganizationId = u.OrganizationId
and ISNull(o.IsDeleted,0) = 0
WHERE Isnull(u.IsDeleted,0) = 0 
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroupsForOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllGroupsForOrganization] --1,0
(
	@OrganizationId int
)
AS BEGIN
Select * from Groups g
Inner join OrganizationsGroups og
on g.GroupId = og.GroupId
and isnull(g.isdeleted,0) = 0
Where og.OrganizationId = @OrganizationId
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[uspDeleteUser]
	@UserId INT
AS

DECLARE @err INT
DECLARE @rc INT

UPDATE
	Users
SET
	isDeleted=1
WHERE
	UserId=@UserId
	
SELECT @err=@@ERROR, @rc=@@ROWCOUNT

IF @err<>0 RETURN -101

IF @rc<>1
BEGIN
	RAISERROR ('Unable to delete user - specified user not found', 16, 1)
	RETURN -201
END

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationByGroupName]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationByGroupName] -- 'HMORN'
(
@GroupName varchar(max)
)
AS BEGIN

DECLARE @GroupId int

SELECT     @GroupId = GroupId
FROM         dbo.Groups
WHERE     (GroupName = @GroupName) AND (ISNULL(dbo.Groups.isdeleted,0) = 0)

SELECT     dbo.Organizations.OrganizationName, dbo.Organizations.OrganizationId, dbo.Organizations.OrganizationAcronym
FROM         dbo.Groups INNER JOIN
              dbo.OrganizationsGroups ON dbo.Groups.GroupId = dbo.OrganizationsGroups.GroupId INNER JOIN
               dbo.Organizations ON dbo.OrganizationsGroups.OrganizationId = dbo.Organizations.OrganizationId AND ISNULL(dbo.Organizations.IsDeleted, 0) = 0
WHERE     (dbo.Groups.GroupId = @GroupId) AND (ISNULL(dbo.Groups.isdeleted,0) = 0)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllRights]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllRights]
AS BEGIN
Select r.RightId,   
    r.RightCode  
    ,r.Description  
    ,c.CategoryId  
    , c.CategoryDescription   
    ,r.CategoryOrdinal  
from Rights r  
inner join RightsCategories c  
on r.CategoryId = c.CategoryId  
order by c.categoryOrder,r.CategoryOrdinal  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllUsers]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllUsers] 
(
@OrganizationId int
)
AS

Declare @OrgIdvarchar varchar(10)

if @OrganizationId > 0
	Set @OrgIdvarchar = @OrganizationId
else 
	Set @OrgIdvarchar = '%'

SELECT
	u.*,o.OrganizationName
FROM
	Users u
INNER join Organizations o
on o.OrganizationId = u.OrganizationId
and isnull(o.isDeleted,0) = 0
WHERE
	isnull(u.isDeleted,0)=0 AND
	cast(u.OrganizationId as varchar(10)) Like @OrgIdvarchar

ORDER BY
	Username
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForUserGroup]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDatamartForUserGroup] --32
(
@OrganizationId int
)
AS BEGIN

Declare @GroupOrganizations table (OrganizationId int)
Insert into @GroupOrganizations values (@OrganizationId) 

Declare @Groups table (GroupId int)
Insert into @Groups Select GroupId from OrganizationsGroups Where OrganizationId = @OrganizationId

Insert into @GroupOrganizations Select OrganizationId from OrganizationsGroups og
										inner join @Groups g
										on g.GroupId = og.GroupId
			Where og.OrganizationId <> @OrganizationId
	
Select dm.DatamartId
	 , dm.DataMartName
	 , dm.Url
	 , dm.RequiresApproval
	 , dm.DataMartTypeId
	 , dm.OrganizationId	 
	 , dm.AvailablePeriod
	 , dm.ContactEmail
	 , dm.ContactFirstName
	 , dm.ContactLastName
	 , dm.ContactPhone
	 , dm.SpecialRequirements
	 , dm.UsageRestrictions
	 , dmt.DataMartType	 
	 , dm.HealthPlanDescription	
FROM DataMarts dm
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DatamartTypeId 
Where dm.OrganizationId in (Select distinct OrganizationId from @GroupOrganizations) 
and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartById]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartById] --1
(
@DatamartId int
)
AS BEGIN
Select dm.DatamartId
	 , dm.DataMartName
	 , dm.Url
	 , dm.RequiresApproval
	 , dm.DataMartTypeId	
	 , dm.AvailablePeriod
	 , dm.ContactEmail
	 , dm.ContactFirstName
	 , dm.ContactLastName
	 , dm.ContactPhone
	 , dm.SpecialRequirements
	 , dm.UsageRestrictions
	 , dmt.DataMartType
	 , dm.HealthPlanDescription
	 , o.OrganizationId	 
FROM DataMarts dm
left join Organizations o
on o.OrganizationId = dm.OrganizationId
left join DatamartTypes dmt
on dm.DataMartTypeId = dmt.DataMartTypeId
And o.IsDeleted = 0
Where dm.DatamartId = @DatamartId

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMart]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMart] 
(@dataMartId int)
AS BEGIN
Select dm.*	 
	 , dmt.DataMartType	 
FROM DataMarts dm
inner Join DataMartTypes dmt
on dmt.DataMartTypeId = dm.DataMartTypeId
Where dm.DataMartId = @dataMartId and isNull(IsDeleted,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAvailablePeriodBycategry]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAvailablePeriodBycategry] --'QUARTERS' , 0
(  
@PeriodCategory Varchar(20),  
@UserId int -- This will not be used at this time however when implementing real   
--functionality to fetch period based on the accessible DataMarts  
)  
AS BEGIN  
if @PeriodCategory != ''  
 BEGIN  
  SELECT Period as Name From DataAvailabilityPeriod dap
  Inner JOIN DataAvailabilityPeriodCategory dapc
  on dapc.CategoryTypeId = dap.CategoryTypeId
  Where dapc.CategoryType = @PeriodCategory
  and dapc.IsPublished = 1 
  and dap.IsPublished = 1
  ORDER by Period
 END  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllQueryTypes]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[uspGetAllQueryTypes]
AS

SELECT	*
FROM	QueryTypes
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForUserOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDatamartForUserOrganization] --1
(
@OrganizationId int
)
AS BEGIN
Select dm.DatamartId
	 , dm.DataMartName
	 , dm.Url
	 , dm.RequiresApproval
	 , dm.DataMartTypeId
	 , dm.OrganizationId	 
	 , dm.AvailablePeriod
	 , dm.ContactEmail
	 , dm.ContactFirstName
	 , dm.ContactLastName
	 , dm.ContactPhone
	 , dm.SpecialRequirements
	 , dm.UsageRestrictions
	 , dmt.DataMartType	 
	 , dm.HealthPlanDescription	
FROM DataMarts dm
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DatamartTypeId 
Where dm.OrganizationId = @OrganizationId and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsByIds]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartsByIds] --'1,2,3'      
(
@DataMartIds varchar(1000)  
)        
AS BEGIN        
 If (@DataMartIds <> '')        
  BEGIN       
  Select dm.* , dmt.DataMartType    
 From DataMarts dm 
 Inner Join DataMartTypes dmt  
  on dmt.DatamartTypeId = dm.DataMartTypeId  
 Where dm.DataMartId in (Select Value From GetValueTableOfDelimittedString (@DataMartIds,','))         
 AND isnull(dm.IsDeleted,0) =0          
  END      
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetFrequencyListForEventType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetFrequencyListForEventType]
@EventTypeID int
AS
/***  NotificationFrequency  ****/
SELECT EventTypeID,FrequencyID,Days as Frequency,Description as FrequencyDescription 
FROM EventTypeNotificationFrequency_view 
WHERE EventTypeID=@EventTypeID


/****** Object:  StoredProcedure [dbo].[uspSaveAllEventTypeNotificationOption]    Script Date: 09/02/2011 17:14:03 ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[uspGetEventById]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetEventById] --1
(
 @EventId bit 
)
AS BEGIN

	Select e.* from Events e where EventId = @EventId	

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrgAcronymForDataMarts]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrgAcronymForDataMarts]  --'1,2,3'    
(@DataMartIds varchar(1000)
)      
AS BEGIN      
 If (@DataMartIds <> '')      
  BEGIN     
	Select coalesce(O.OrganizationAcronym, O.OrganizationName) as OrganizationAcronym, dm.DatamartId
	From DataMarts dm inner join Organizations O
    on O.OrganizationId = dm.OrganizationId
	Where dm.DataMartId in (Select Value From GetValueTableOfDelimittedString (@DataMartIds,','))       
	AND isnull(dm.IsDeleted,0) =0        
  END    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationOptionsByUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetNotificationOptionsByUser] --16
(
	@UserId int
)
AS BEGIN
	if @UserId <> 0 
	BEGIN
		SELECT et.EventTypeId, et.EventType, et.CanbeModified, Case When isNull(NotOp.UserId,0)= 0 Then 'False'
													Else 'True'
											 End as IsNotificationSelected , isNull(NotOp.NotificationTypeId,0) as NotificationTypeId
											,et.EventDescription,et.CategoryOrdinal, et.EventOrdinal,et.EventTypesCategoryID as 'CategoryID'
			--,unf.FrequencyID
			,NotOp.FrequencyId,nf.Days,NotOp.Days as nDays, et.AllowSummaryNotification
		FROM EventTypes et
		LEFT JOIN NotificationOptions NotOp
		ON NotOp.EventTypeId = et.EventTypeId
		AND NotOp.UserId = @UserId AND NotOp.NotificationTypeId = 1--Email Notification at this time
		--LEFT JOIN UserNotificationFrequency unf ON unf.UserID=@UserID AND unf.EventTypeID=et.EventTypeID
		LEFT JOIN NotificationFrequency nf ON nf.FrequencyID=NotOp.FrequencyID
		order by et.CategoryOrdinal,et.EventOrdinal
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLookUpValues]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetLookUpValues]
( 
	@CategoryTypeId int	
)
AS BEGIN
	If @CategoryTypeId > 0
		BEGIN
			SELECT NAME from LookUpValues Where CategoryTypeId = @CategoryTypeId order by Name
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLookupMetricsList]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[uspGetLookupMetricsList]
	@QueryTypeId INT
AS 

BEGIN
	select MetricId, MetricDesc  from LookUpQueryTypeMetrics_view 
	where QueryTypeId= @QueryTypeId
	order by MetricDesc
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupOrganizationsByUserOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetGroupOrganizationsByUserOrganization] 
(
@OrganizationId int,
@FilterByOrganizationId int  
)
AS

Declare @GroupOrganizations table (OrganizationId int)
Insert into @GroupOrganizations values (@OrganizationId) 

Declare @Groups table (GroupId int)
Insert into @Groups Select GroupId from OrganizationsGroups Where OrganizationId = @OrganizationId

Insert into @GroupOrganizations Select OrganizationId from OrganizationsGroups og
										inner join @Groups g
										on g.GroupId = og.GroupId
			Where og.OrganizationId <> @OrganizationId

Declare @OrgIdvarchar varchar(10)  
  
if @FilterByOrganizationId > 0  
 Set @OrgIdvarchar = @FilterByOrganizationId  
else   
 Set @OrgIdvarchar = '%'  

SELECT
	u.*,o.OrganizationName
FROM
	Users u
INNER JOIN @GroupOrganizations go
on u.OrganizationId = go.OrganizationId
INNER join Organizations o
on o.OrganizationId = go.OrganizationId
WHERE
	 isnull(o.isDeleted,0) = 0 and isnull(u.isDeleted,0)=0	
	 AND  cast(u.OrganizationId as varchar(10)) Like @OrgIdvarchar  
ORDER BY
	Username
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupOrganizations]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupOrganizations] --1
(
@GroupId int
)
AS BEGIN
	SELECT org.OrganizationId, org.OrganizationName,org.isDeleted, org.OrganizationAcronym from OrganizationsGroups og
	Inner join Groups grp
	on IsNull(grp.IsDeleted ,0) = 0
	AND grp.GroupId = og.GroupId	
	Inner JOIN Organizations org
	on org.OrganizationId = og.OrganizationId
	and isNull(org.IsDeleted,0) = 0
	Where grp.GroupId = @GroupId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationUsers]  --2,'1',0 
(
 @OrganizationId int,  
 @UserIds varchar(500),  
 @ExcludeIdsPassed bit
)
AS BEGIN
	If (@ExcludeIdsPassed = 0)
		BEGIN
		-- Get only user details for Ids passed in
			Select u.*, o.OrganizationName
			From Users u
			INNER Join Organizations o
			On o.OrganizationId = u.OrganizationId
			and isNull(u.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0
			Where u.OrganizationId = @OrganizationId
			AND u.UserId in (Select Value From GetValueTableOfDelimittedString (@UserIds,',')) 
			order by u.UserName
		END
	ELSE
		BEGIN
		-- Get User detials for anybody other than passed in Ids
			Select u.*, o.OrganizationName
			From Users u
			INNER Join Organizations o
			On o.OrganizationId = u.OrganizationId
			and isNull(u.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0
			Where u.OrganizationId = @OrganizationId
			And u.UserId not in (Select Value From GetValueTableOfDelimittedString (@UserIds,',')) 
			order by u.UserName
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationsInGroupByUserOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetOrganizationsInGroupByUserOrganization] --5
(  
@OrganizationId int   
)  
AS  
  BEGIN
Declare @GroupOrganizations table (OrganizationId int)  
Insert into @GroupOrganizations values (@OrganizationId)   
  
Declare @Groups table (GroupId int)  
Insert into @Groups Select GroupId from OrganizationsGroups Where OrganizationId = @OrganizationId  
  
Insert into @GroupOrganizations Select OrganizationId from OrganizationsGroups og  
          inner join @Groups g  
          on g.GroupId = og.GroupId  
   Where og.OrganizationId <> @OrganizationId  
  
SELECT  
 distinct o.*  
FROM  
@GroupOrganizations go  
INNER join Organizations o  
on o.OrganizationId = go.OrganizationId  
WHERE  
  isnull(o.isDeleted,0) = 0     
  END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRightById]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetRightById] --4
(
	@RightId int
)
AS BEGIN
Select r.RightId,  
    r.RightCode  
  ,r.Description  
  ,c.CategoryId  
  ,c.CategoryDescription  
  ,r.CategoryOrdinal  
 from Rights r  
inner join RightsCategories c  
on r.CategoryId = c.CategoryId  
WHERE r.RightId = @RightId    
END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateUserRole]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspUpdateUserRole]
	@UserId INT,
	@RoleTypeId INT
AS 

UPDATE 
	Users
SET
	RoleTypeId = @RoleTypeId
WHERE
	UserId=@UserId
GO
/****** Object:  StoredProcedure [dbo].[uspGetUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetUser]  
(
 @UserId INT  
)
AS  
 BEGIN 
	SELECT  u.*, o.OrganizationName 
	FROM Users u
	INNER join Organizations o
	on o.OrganizationId = u.organizationId
	and isnull(o.IsDeleted,0) = 0 
	WHERE  
	 UserId = @UserId and isnull(u.isDeleted,0) = 0  
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveAllEventTypeNotificationOption]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[uspSaveAllEventTypeNotificationOption] 
(
@UserId int,
@SelectedEventTypeIds varchar(1000),
@SelectedEventFrequencyIds varchar(1000),
@SelectedEventFDays varchar(1000)
)
AS BEGIN
--Only Email Notification is considered at this time, hence NotificationTypeId = 1(email)
if (@UserId <> 0)
BEGIN
	DELETE FROM NotificationOptions Where userId = @UserId and NotificationTypeId = 1
	--DELETE FROM UserNotificationFrequency WHERE UserID=@UserID /*Not required now*/
	if @@Error = 0
	BEGIN
		INSERT NotificationOptions 
			Select @UserId, a.EventTypeId, 1
				, case 
					when c.Value<>'' then cast(c.Value as int) 
					else null 
				  end as FrequencyId
				, Case 
					When d.Value<>'' Then cast(d.Value as int)
					Else null
				  End as Days 
			From EventTypes a 
				left join (SELECT [Key],[Value] FROM GetKeyValueTableOfDelimittedString(@SelectedEventFrequencyIds,',')) c	on (a.EventTypeId = c.[Key]) 
				left join (SELECT [Key],[Value] FROM GetKeyValueTableOfDelimittedString(@SelectedEventFDays,',')) d on (a.EventTypeId = d.[Key])
			Where Convert(varchar,EventTypeId) 
				in (Select Value from GetValueTableOfDelimittedString(@SelectedEventTypeIds, ','))
		
	END
END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUsersForDMClientUpdateNotification]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspGetUsersForDMClientUpdateNotification]
@strVersion VARCHAR(25)
AS
BEGIN
	SELECT DISTINCT u.UserId
	FROM Users u 
		INNER JOIN RoleTypes rt 
			ON u.RoleTypeId = rt.RoleTypeId AND rt.RoleType = 'Data Mart Administrator'
		INNER JOIN NotificationOptions nop 
			ON u.UserId = nop.UserId AND nop.EventTypeId = 24
	WHERE ISNULL(u.isDeleted,0) = 0 
		AND (u.version != @strVersion OR u.Version IS NULL)
		AND u.UserId NOT IN(SELECT n.UserId
							FROM Notifications n 
							INNER JOIN NotificationOptions nop ON n.UserId = nop.UserId 
							WHERE nop.EventTypeId = 24 
								AND CONVERT(CHAR(8), n.GeneratedTime, 112) = CONVERT(CHAR(8), GetDate(), 112))

END
GO
/****** Object:  StoredProcedure [dbo].[UspGetUsersByRoleType]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[UspGetUsersByRoleType]
@RoleTypeID int
AS

SELECT	u.*,o.OrganizationName,rt.RoleType
FROM	
Users u
INNER JOIN RoleTypes rt
	on rt.RoleTypeID = u.RoleTypeID
INNER JOIN Organizations o
	on o.OrganizationId  = u.OrganizationId AND isnull(o.IsDeleted,0)= 0
WHERE u.RoleTypeID =@RoleTypeID AND isnull(u.IsDeleted,0)= 0
GO
/****** Object:  StoredProcedure [dbo].[uspSaveNotificationOption]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveNotificationOption] 
(
@UserId int,
@SelectedEventTypeIds varchar(100),
@SelectedFrequencyIds varchar(1000)=''
)
AS BEGIN
--Only Email Notification is considered at this time, hence NotificationTypeId = 1(email)
if (@UserId <> 0)
BEGIN
	DELETE FROM NotificationOptions Where userId = @UserId and NotificationTypeId = 1
	DELETE FROM UserNotificationFrequency WHERE UserID=@UserID
	if @@Error = 0
	BEGIN
		INSERT NotificationOptions(UserId,EventTypeId,NotificationTypeId) Select @UserId, EventTypeId, 1 From EventTypes Where Convert(varchar,EventTypeId) in (Select Value from GetValueTableOfDelimittedString(@SelectedEventTypeIds, ','))
		if(@SelectedFrequencyIds<>'')
		BEGIN
			if @@Error = 0
			BEGIN
				INSERT UserNotificationFrequency(UserID,EventTypeID,FrequencyID)
					SELECT @UserID,[Key],[Value] FROM GetKeyValueTableOfDelimittedString(@SelectedFrequencyIds,',')
			END
		END
	END
END
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveNotification]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveNotification]     
(    
@NotificationId int,    
@UserId int,    
@EventId int,    
@NotificationTypeId int,    
@GeneratedTime DateTime,    
@DeliveredTime DateTime,    
@OtherData varchar(1000)=null,
@EncryptedOtherData  varchar (1000) = null,
@NotificationGUID varchar(100),
@Priority int
)    
AS BEGIN  -- Stored Proc Begin Block
	 If @NotificationId  > 0    
		  BEGIN    
			  Update Notifications Set DeliveredTime = @DeliveredTime where     
			  NotificationId = @NotificationId    
		  END    
	 ELSE       
		  BEGIN    
			  If not exists (Select 1 from Notifications Where eventId = @EventID and UserId = @UserId)    
			  BEGIN    				
						Set @OtherData = null										                

						INSERT INTO Notifications(NotificationTypeId,UserId,EventId,GeneratedTime,OtherData,EncryptedData,Priority)    
						VALUES(@NotificationTypeId,@UserId,@EventId,@GeneratedTime,@OtherData,@EncryptedOtherData,@Priority)   
				  
						IF @@Error = 0  
						 -- Add NotificationGUID as NotificationUrlParameter since its a not null field.  
						INSERT INTO NotificationSecureGUID (NotificationId, notificationGUID) values ( SCOPE_IDENTITY(),@NotificationGUID )  
			          
				END          
			END   
	END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveGroup]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveGroup]
(
	@GroupId int,
	@GroupName varchar(100),
	@OrganizationIds varchar(500),
	@IsApprovalRequired bit,
	@ConcatenatedAdminIds varchar(1000)
)
AS BEGIN

Declare @ReturnValue int
Select @ReturnValue=0  
	If @GroupId > 0
		BEGIN
			Update Groups Set GroupName = @GroupName, IsDeleted = 0, IsApprovalRequired = @IsApprovalRequired Where GroupId = @GroupId

			Delete from GroupAdministrators Where GroupId = @GroupId

			If (@IsApprovalRequired = 'true' and @ConcatenatedAdminIds <> '')
			BEGIN	
				Insert into GroupAdministrators Select @GroupId , value from GetValueTableOfDelimittedString(@ConcatenatedAdminIds,',')
			END	

			Delete from OrganizationsGroups Where GroupId = @GroupId
			
		END	
	Else
		BEGIN
			INSERT INTO Groups(GroupName, IsDeleted, IsApprovalRequired) values (@GroupName,0, @IsApprovalRequired)

			SELECT @GroupId=SCOPE_IDENTITY() 			
		END
	
	
	if (@GroupId > 0)
	BEGIN	
	Insert into OrganizationsGroups(OrganizationId,GroupId) Select Value,@GroupId From GetValueTableOfDelimittedString (@OrganizationIds,',')
	END

	Set @ReturnValue =  @GroupId 
	  return @ReturnValue;
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveEntityQueryTypes]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveEntityQueryTypes]
(
@EntityId int,
@ConcatenatedQueryTypeIds varchar(1000),
@EntityType int
)
AS BEGIN

	if (@EntityType = 1 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsUsersQueryTypes where UserId = @EntityId

		if (@ConcatenatedQueryTypeIds <> '')
		INSERT INTO PermissionsUsersQueryTypes (UserId, QueryTypeId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedQueryTypeIds, ',')

		Select @@Error
	END

	if (@EntityType = 2 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsQueryTypes where OrganizationId = @EntityId

		if (@ConcatenatedQueryTypeIds <> '')
		INSERT INTO PermissionsOrganizationsQueryTypes (OrganizationId, QueryTypeId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedQueryTypeIds, ',')

		Select @@Error
	END

	if (@EntityType = 3 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsQueryTypes where GroupId = @EntityId

		if (@ConcatenatedQueryTypeIds <> '')
		INSERT INTO PermissionsGroupsQueryTypes (GroupId, QueryTypeId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedQueryTypeIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveEntityDataMarts]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[uspSaveEntityDataMarts]
(
@EntityId int,
@ConcatenatedDataMartIds varchar(1000),
@EntityType int
)
AS BEGIN

	if (@EntityType = 1 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsUsersDataMarts where UserId = @EntityId

		if (@ConcatenatedDataMartIds <> '')
		INSERT INTO PermissionsUsersDataMarts (UserId, DataMartId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedDataMartIds, ',')

		Select @@Error
	END

	if (@EntityType = 2 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsDataMarts where OrganizationId = @EntityId

		if (@ConcatenatedDataMartIds <> '')
		INSERT INTO PermissionsOrganizationsDataMarts (OrganizationId, DataMartId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedDataMartIds, ',')

		Select @@Error
	END

	if (@EntityType = 3 AND @EntityId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsDataMarts where GroupId = @EntityId

		if (@ConcatenatedDataMartIds <> '')
		INSERT INTO PermissionsGroupsDataMarts (GroupId, DataMartId) SELECT @EntityId, value from 
			GetValueTableOfDelimittedString(@ConcatenatedDataMartIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveRightForUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveRightForUsers]
(
@RightId int,
@UserIds varchar(1000)
)
AS BEGIN

	if (@RightId > 0 )
	BEGIN
		DELETE FROM PermissionsUsersRights where rightId = @RightId
		if (@UserIds <> '')

		INSERT INTO PermissionsUsersRights (rightId,UserId) SELECT @RightId, value from 
			GetValueTableOfDelimittedString(@UserIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveRightForOrganizations]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveRightForOrganizations]
(
@RightId int,
@OrganizationIds varchar(1000)
)
AS BEGIN

	if (@RightId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsRights where rightId = @RightId
		if (@OrganizationIds <> '')

		INSERT INTO PermissionsOrganizationsRights (rightId,OrganizationId) SELECT @RightId, value from 
			GetValueTableOfDelimittedString(@OrganizationIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveRightForGroups]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveRightForGroups]
(
@RightId int,
@GroupIds varchar(1000)
)
AS BEGIN

	if (@RightId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsRights where rightId = @RightId

		if (@GroupIds <> '')
		INSERT INTO PermissionsGroupsRights (rightId,GroupId) SELECT @RightId, value from 
			GetValueTableOfDelimittedString(@GroupIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUserRights]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetUserRights] --1,0
(
	@UserId int,
	@IncludeInherited bit
)
AS BEGIN
	If @UserId > 0
		BEGIN
			IF @IncludeInherited = 'true'
				BEGIN
					Declare @OrgId int	
					
					Set @OrgId = 0				

					Select @OrgId = o.OrganizationId from users u inner join Organizations o on o.OrganizationId = u.OrganizationId where u.UserId = @UserId and isnull(u.isDeleted,0) = 0 and isnull(o.isDeleted,0) = 0
						
					--Select RightId From PermissionsUsersRights pur INNER JOIN Users u on pur.UserId = u.UserId and isnull(u.isDeleted,0)= 0 Where pur.UserId = @userId
					Select rrm.RightId From RoleRightsMap rrm INNER JOIN Users u on u.RoleTypeId = rrm.RoleTypeId Where u.UserId  = @UserId and isnull(u.isDeleted,0)= 0
					UNION
					SELECT RightId From PermissionsOrganizationsRights Where OrganizationId = @OrgId
					UNION
					SELECT RightId From PermissionsGroupsRights Where GroupId in (Select g.GroupId from OrganizationsGroups og inner join groups g on g.GroupId = og.GroupId and isnull(g.isDeleted,0)= 0  where og.OrganizationId = @OrgId)
										
					
				END
			Else
				BEGIN					
					--Select RightId From PermissionsUsersRights Where UserId = @userId
					Select rrm.RightId From RoleRightsMap rrm INNER JOIN Users u on u.RoleTypeId = rrm.RoleTypeId Where u.UserId  = @UserId and isnull(u.isDeleted,0)= 0
				END
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUserQueryTyePermissions]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetUserQueryTyePermissions] --1,0
(
	@UserId int,
	@IncludeInherited bit
)
AS BEGIN
	If @UserId > 0
		BEGIN
			IF @IncludeInherited = 'true'
				BEGIN
					Declare @OrgId int	
					Declare @GroupId int

					Set @OrgId = 0
					Set @GroupId = 0

						Select @OrgId = OrganizationId from users where UserId = @UserId
						Select @GroupId = GroupId from OrganizationsGroups where OrganizationId = @OrgId

					Select QueryTypeId From PermissionsUsersQueryTypes Where UserId = @userId
					UNION
					SELECT QueryTypeId From PermissionsOrganizationsQueryTypes Where OrganizationId = @OrgId
					UNION
					SELECT QueryTypeId From PermissionsGroupsQueryTypes Where GroupId = @GroupId 
										
					
				END
			Else
				BEGIN					
					Select QueryTypeId From PermissionsUsersQueryTypes Where UserId = @userId
				END
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveDataMarts]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveDataMarts]   
(@DatamartId int,  
 @DataMartName varchar(50),  
 @DataMartTypeId int,  
 @DataMartUrl nvarchar(510),  
 @OrganizationId int,  
 @NotificationUserIds nvarchar(500),  
 @DataMartAvailPeriod varchar(500),  
 @DataMartContactEmail nvarchar(510),  
 @DataMartContactFirstName varchar(100),  
 @DataMartContactLastName varchar(100),  
 @DataMartContactPhone varchar(15),  
 @DataMartSpecRequirements nvarchar(1000),  
 @DataMartRestrictions nvarchar(1000),
 @DataMartHealthPlanDescription nvarchar(1000),
 @SupportedQueryTypeIds nvarchar(500),
 @LoggedInUserId int  
 )  
AS BEGIN 
If (@OrganizationId = 0)
return
  
If (@DataMartTypeId <> 0) --Client Type  
 BEGIN  
  Set @DataMartUrl = NULL  
 END  
  
if (@DatamartId = 0)  
	 BEGIN  
		Insert into DataMarts(DatamartName, Url,DatamartTypeId,  
			 OrganizationId,AvailablePeriod,ContactEmail,ContactFirstName,  
			 ContactLastName,ContactPhone,SpecialRequirements,UsageRestrictions,IsDeleted, HealthPlanDescription)  
		 values   
			(@DataMartName,@DataMartUrl,@DataMartTypeId,  
			 @OrganizationId,@DataMartAvailPeriod,@DataMartContactEmail,@DataMartContactFirstName,  
			 @DataMartContactLastName,@DataMartContactPhone,@DataMartSpecRequirements,@DataMartRestrictions,0, @DataMartHealthPlanDescription)    

		
		Set @DatamartId = Scope_Identity()	
		Insert PermissionsUsersDataMarts Select @LoggedInUserId, @DatamartId

	 END  
Else if (@DatamartId <> 0)  
	 BEGIN  
	  Update DataMarts SET   
		DatamartName = @DataMartName,  
		Url = @DataMartUrl,   
		DatamartTypeId = @DataMartTypeId,  
		OrganizationId = @OrganizationId,  
		AvailablePeriod = @DataMartAvailPeriod,  
		ContactEmail = @DataMartContactEmail,  
		ContactFirstName = @DataMartContactFirstName,  
		ContactLastName = @DataMartContactLastName,  
		ContactPhone = @DataMartContactPhone,  
		SpecialRequirements = @DataMartSpecRequirements,  
		UsageRestrictions = @DataMartRestrictions,  
		IsDeleted = 0,
		HealthPlanDescription = @DataMartHealthPlanDescription         
	  WHERE DataMartId = @DataMartId  

		Delete from DataMartNotifications Where DatamartId = @DatamartId

		Delete from PermissionsQueryTypesDataMarts Where DatamartId = @DatamartId
		
	 END  

if (@OrganizationId > 0 and @DataMartTypeId <> 0) -- only for Client based DataMarts
	Insert into DatamartNotifications Select @DatamartId, value from GetValueTableOfDelimittedString(@NotificationUserIds,',');
 
  
if (@SupportedQueryTypeIds <> '')
	Insert into PermissionsQueryTypesDataMarts Select @DatamartId, value from GetValueTableOfDelimittedString(@SupportedQueryTypeIds,',');

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSelfAdministeredDatamarts]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSelfAdministeredDatamarts] --1,1,''
(  
@UserId int
)  
AS BEGIN  
Select dm.DatamartId  
  , dm.DataMartName  
  , dm.Url  
  , dm.RequiresApproval  
  , dm.DataMartTypeId  
  , dm.OrganizationId    
  , dm.AvailablePeriod  
  , dm.ContactEmail  
  , dm.ContactFirstName  
  , dm.ContactLastName  
  , dm.ContactPhone  
  , dm.SpecialRequirements  
  , dm.UsageRestrictions  
  , dmt.DataMartType    
  , dm.HealthPlanDescription   
FROM DataMartNotifications dn
Inner join DataMarts dm  
on dm.DataMartId = dn.DataMartId 
and dn.NotificationUserId = @UserId
inner join DatamartTypes dmt  
on dmt.DatamartTypeId = dm.DatamartTypeId 
Where isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUserDataMartPermissions]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetUserDataMartPermissions] --1,1
(
	@UserId int,
	@IncludeInherited bit
)
AS BEGIN
	If @UserId > 0
		BEGIN
			IF @IncludeInherited = 'true'
				BEGIN
					Declare @OrgId int	
					Declare @GroupId int

					Set @OrgId = 0
					Set @GroupId = 0

						Select @OrgId = OrganizationId from users where UserId = @UserId
						Select @GroupId = GroupId from OrganizationsGroups where OrganizationId = @OrgId

					DECLARE @DatamartsWithAccess TABLE ( DatamartId int)
					INSERT INTO @DatamartsWithAccess
					Select DataMartId From PermissionsUsersDataMarts Where UserId = @userId
					UNION
					SELECT DataMartId From PermissionsOrganizationsDataMarts Where OrganizationId = @OrgId
					UNION
					SELECT DataMartId From PermissionsGroupsDataMarts Where GroupId = @GroupId 
					--Get only datamarts that is not deleted
					Select dwa.DataMartId from @DatamartsWithAccess dwa
					inner join DataMarts dm
					on dm.DataMartId = dwa.DatamartId
					and isDeleted = 0					
					
				END
			Else
				BEGIN
					--Get only datamarts that is not deleted
					Select pud.DataMartId From PermissionsUsersDataMarts pud
					inner join DataMarts dm
					on dm.DataMartId = pud.DatamartId
					and isDeleted = 0
					Where UserId = @userId
				END
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUserDatamartForQueryType]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetUserDatamartForQueryType] --1,16
(
@QueryTypeId int,
@UserId int
)
AS BEGIN

--------------
 Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @UserId
------------

Select distinct dm.*,dmt.DatamartType from Datamarts dm
INNER JOIN (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @UserId  
						 UNION  
						 SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId  
						 UNION  
						 SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  ) dmList
on dm.DatamartId = dmList.DatamartId
INNER JOIN PermissionsQueryTypesDatamarts pqtd
on pqtd.DatamartId = dm.DatamartId
AND pqtd.QueryTypeId = @QueryTypeId
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DataMartTypeId
Left Join Organizations o
on o.OrganizationId = dm.OrganizationId
Where isnull(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSupportedQueryTypesForDataMart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSupportedQueryTypesForDataMart] --31
 (
	@DatamartId int
 )
 AS
 BEGIN
	 Select * From QueryTypes qTypes
	 Inner Join PermissionsQueryTypesDataMarts pqd
	 on pqd.QueryTypeId = qTypes.QueryTypeId  and pqd.DatamartId = @DatamartId
	 and isVisibleForSelection = 1	 
	 Order by qTypes.QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRunOnceInitialPasswordEncryption]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspRunOnceInitialPasswordEncryption] 
AS BEGIN
SET NOCOUNT ON 

-- declare variables to hold values from cursor rows

DECLARE  @UserId  int,
         @Password   varchar(50)

-- declare User cursor

DECLARE UserCursor CURSOR FOR
	SELECT UserId,Password FROM Users
	Where UserId not in (Select Distinct(UserId) From UserPasswordtrace)
 
OPEN UserCursor
 

FETCH UserCursor INTO @UserId,@Password 

-- Update passwords with encrypted password

WHILE @@Fetch_Status = 0

   BEGIN
	
	if (@Password <> '')
		
		BEGIN

			Declare @EncryptedPassword varchar(50)
			Set @EncryptedPassword =  dbo.udf_encrypt_password (@Password)

			Update Users set Password = @EncryptedPassword Where UserId = @UserId
			if @@error = 0
				INSERT into UserPasswordTrace (UserId, Password,DateAdded,AddedBy)
				Values (@UserId,@EncryptedPassword,GetDate(),@UserId) 
				-- as an initial setting defaulting the added by usersId also to the user id
			
		END

	  FETCH UserCursor INTO @UserId,@Password             

   END

CLOSE UserCursor

DEALLOCATE UserCursor

RETURN


END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeUserRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeUserRightPermission]
(
	@UserId int,
	@RightId int
)
AS BEGIN
	Delete From PermissionsUsersRights Where UserId = @UserId and RightId=@RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeUserQueryTypePermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeUserQueryTypePermission]
(
	@UserId int,
	@QueryTypeId int
)
AS BEGIN
	Delete From PermissionsusersQueryTypes Where UserId = @UserId and QueryTypeId=@QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeUserDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeUserDataMartPermission]
(
	@UserId int,
	@DatamartId int
)
AS BEGIN
	Delete From PermissionsUsersDatamarts Where UserId = @UserId and DataMartId = @DataMartId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeOrganizationRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeOrganizationRightPermission]
(
	@OrganizationId int,
	@RightId int
)
AS BEGIN
	Delete from PermissionsOrganizationsRights Where OrganizationId = @OrganizationId and RightId = @RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeOrganizationDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeOrganizationDataMartPermission]
(
	@OrganizationId int,
	@DatamartId int
)
AS BEGIN
	Delete From PermissionsOrganizationsDatamarts where OrganizationId = @OrganizationId and DatamartId = @DataMartId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeGroupRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeGroupRightPermission]
(
	@GroupId int,
	@RightId int
)
AS BEGIN
	Delete From PermissionsGroupsRights Where GroupId = @GroupId and RightId = @RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeGroupQueryTypePermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeGroupQueryTypePermission]
(
	@GroupId int,
	@QueryTypeId int
)
AS BEGIN
	Delete From PermissionsGroupsQueryTypes Where GroupId = @GroupId and QueryTypeId = @QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspRevokeGroupDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRevokeGroupDataMartPermission]
(
	@GroupId int,
	@DatamartId int
)
AS BEGIN
	Delete from PermissionsGroupsDatamarts where GroupId = @GroupId and  DataMartId = @DataMartId
END
GO
/****** Object:  StoredProcedure [dbo].[uspResetPassword]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspResetPassword]   
(  
@Username varchar(50) = '',  
@Email varchar(50) = '',  
@Password varchar(100),
@SetEncryptionAtDatabase BIT = true  
)  
AS  
BEGIN  
  
Declare @UserId int   
Set @UserId = 0  
  
 IF ((@Username <> '' or @Email <> '') and @Password <> '')  
 BEGIN    
   If (@Username <> '')   
    Select @userId = UserId from Users u   
    INNER JOIN Organizations o  
    on IsNull(u.Isdeleted,0) = 0 and   
    o.OrganizationId = u.OrganizationId and   
    IsNull(o.Isdeleted,0) = 0   
    where username = @Username   
   Else   
    Set @userId = (Select Top 1 UserId from Users u   
    INNER JOIN Organizations o  
    on IsNull(u.Isdeleted,0) = 0 and   
    o.OrganizationId = u.OrganizationId and   
    IsNull(o.Isdeleted,0) = 0   
    where Email = @Email)  
  
   if @UserId <> 0   
    BEGIN    
		Declare @EncryptedPassword varchar(100)
		 if @SetEncryptionAtDatabase = 1
			BEGIN			  
			--Set @EncryptedPassword =  dbo.udf_encrypt_password (@Password)    
			exec master..xp_sha1 @password, @EncryptedPassword OUTPUT 
			END
		ELSE
			BEGIN
				SET @EncryptedPassword = @Password
			END  
  
		 If Exists (Select 1 From UserPasswordTrace where UserId = @UserId and Password = @EncryptedPassword)         
			Set @UserId = -102                 
		  Else    
		  BEGIN  
			INSERT INTO UserPasswordTrace (UserId,Password,DateAdded,AddedBy) Values    
			(@UserId,@EncryptedPassword,GetDate(),@UserId)    
			Update Users Set Password = @EncryptedPassword, PasswordEncryptionLength = 14 where UserId = @UserId  
		  END  
    END   
END  
Select @UserId as userId  
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspRemoveRightFromRole]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspRemoveRightFromRole] --1
(
	@RoleTypeId int,
	@RightId int
)
AS BEGIN
	if (@RoleTypeId > 0 and @RightId > 0)
	Delete from RoleRightsMap Where RoleTypeId = @RoleTypeId and RightId = @RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveOrganization]  
(  
 @OrganizationId int,  
 @OrganizationName varchar(100),
 @OrganizationAcronym varchar(100),
 @IsApprovalRequired bit,
 @ConcatenatedAdminIds varchar(1000)
)  
AS BEGIN  
Declare @ReturnValue int  
Select @ReturnValue=0  
	If @OrganizationId > 0  
		BEGIN  
			Update Organizations Set OrganizationName = @OrganizationName, IsApprovalRequired = @IsApprovalRequired, OrganizationAcronym = @OrganizationAcronym Where OrganizationId = @OrganizationId
			
			Delete from OrganizationAdministrators Where OrganizationId = @OrganizationId
			
			If (@IsApprovalRequired = 'true' and @ConcatenatedAdminIds <> '')
			BEGIN	
				Insert into OrganizationAdministrators Select @OrganizationId , value from GetValueTableOfDelimittedString(@ConcatenatedAdminIds,',')
			END	
		END  
	ELSE  
		BEGIN  
			INSERT INTO Organizations(OrganizationName, OrganizationAcronym, IsApprovalRequired, IsDeleted) Values (@OrganizationName, @OrganizationAcronym, @IsApprovalRequired, 0)  
			
			SELECT @OrganizationId=SCOPE_IDENTITY()  
			
			If (@IsApprovalRequired = 'true' and @ConcatenatedAdminIds <> '')
			BEGIN
				Insert into OrganizationAdministrators Select @OrganizationId , value from GetValueTableOfDelimittedString(@ConcatenatedAdminIds,',')
			END
		END  
	Return @ReturnValue   
END
GO
/****** Object:  StoredProcedure [dbo].[uspSetQueryStatusChange]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSetQueryStatusChange] 
(
@QueryId int,
@QueryStatusTypeId int,
@EventSourceId int,
@DatamartId int,
@UserId int
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@QueryId > 0)
	BEGIN
		--Select @EventId = IsNull(EventId,0) FROM EventDetailNewQuery Where QueryId = @QueryId		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,2,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace the part of query that caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailQueryStatusChange (EventId, QueryId, NewQueryStatusTypeId, DatamartId, UserId)
			VALUES(@EventId,@QueryId,@QueryStatusTypeId,@DatamartId, @UserId)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace the part of query that caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspUpdateUser]  
 @UserId INT,  
 @Username VARCHAR(50),  
 @Password VARCHAR(100),  
 @RoleTypeId INT,  
 @OrganizationId int,  
 @Email nvarchar(150),  
 @AddedBy INT,  
 @Title VARCHAR(100),  
 @FirstName varchar(100),  
 @LastName varchar(100), 
 @IsNewOrModifiedPassword BIT,
 @SetEncryptionAtDatabase BIT,  
 @Return_Value int OUTPUT  
AS   
  
Set @Return_Value = 0  
  
IF Exists (Select 1 from Users where UserName = @Username and isDeleted = 0 and userId <> @UserId)    
BEGIN    
Set @Return_Value = -103    
RETURN     
END   
  
Declare @EncryptedPwd varchar(100)   
Declare @PasswordencryptionLength int  
  
set @PasswordencryptionLength = 14
  
Set @EncryptedPwd = @Password  
  
If (@IsNewOrModifiedPassword = 1)
BEGIN
	If (@SetEncryptionAtDatabase = 1)
	BEGIN
		 exec master..xp_sha1 @password, @EncryptedPwd OUTPUT  
	END
END

If (@EncryptedPwd <> (Select Password from Users where UserId = @UserId))    
	BEGIN   
		 If Exists (Select 1 From UserPasswordTrace where UserId = @UserId and Password = @EncryptedPwd)  
			  BEGIN  
			   Set @Return_Value = -102  
			   return  
			  END  
		 Else  
			  INSERT INTO UserPasswordTrace (UserId,Password,DateAdded,AddedBy) Values  
			  (@UserId,@EncryptedPwd,GetDate(),@AddedBy)  
	END  
else  
	BEGIN  
		Select @PasswordencryptionLength = ISNull(PasswordEncryptionLength,10) from Users where UserId = @UserId and isDeleted = 0  
	END  
  
IF @@ERROR<>0   
 BEGIN  
  Set @Return_Value = -101  
  RETURN  
 END   
  
  
UPDATE   
 Users  
SET  
 Username = @Username,  
 Password = @EncryptedPwd,  
 RoleTypeId = @RoleTypeId,  
 OrganizationId = @OrganizationId,  
 Email = @Email,  
 Title = @Title,  
 FirstName = @FirstName,  
 Lastname = @LastName,  
 PasswordEncryptionLength = @PasswordencryptionLength  
WHERE  
 UserId=@UserId
GO
/****** Object:  StoredProcedure [dbo].[uspSetEncryptedUserPassword]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspSetEncryptedUserPassword] --4,63
	@UserId INT, -- userId to whom the password needs to be encrypted
	@AddedBy INT -- userId who changes this password(passwors can be changed by self or administrator)	
AS 

Declare @EncryptedPwd varchar(50) 
Declare @Pwd CHAR(10) 
Select @Pwd = password from Users where UserId = @UserId
--Password rule (not more than 10 characters)
if (@Pwd <> '')
BEGIN	
	Set @EncryptedPwd =  dbo.udf_encrypt_password (@Pwd)
	If Exists (Select 1 From UserPasswordTrace where UserId = @UserId and Password = @EncryptedPwd)
		return
	Else
		BEGIN

		UPDATE Users SET Password = @EncryptedPwd WHERE	UserId=@UserId

		INSERT INTO UserPasswordTrace (UserId,Password,DateAdded,AddedBy) Values
		(@UserId,@EncryptedPwd,GetDate(),@AddedBy)

		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateNotificationSecureGUID]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspUpdateNotificationSecureGUID]   
(  
@NotificationId int,
@NotificationGUID varchar(100),
@NotificationUrlParameters varchar(1000),
@IsActive bit
)  
AS BEGIN  
	 If @NotificationId  > 0  and @NotificationUrlParameters <> ''
	  BEGIN  

		  Update NotificationSecureGUID Set 
					NotificationUrlParameters = @NotificationUrlParameters, 
					NotificationGUID = @NotificationGUID,
					IsActive = @IsActive 
		  where   
		  NotificationId = @NotificationId
	  END   
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantUserRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantUserRightPermission]
(
	@UserId int,
	@RightId int
)
AS BEGIN
If not exists (Select 1 from PermissionsUsersRights where UserId = @UserId and RightId = @RightId)
	INSERT INTO PermissionsUsersRights(UserId, RightId) Values (@UserId,@RightId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantUserQueryTypePermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantUserQueryTypePermission]
(
	@UserId int,
	@QueryTypeId int
)
AS BEGIN
	INSERT INTO PermissionsusersQueryTypes(UserId, QueryTypeId) Values (@UserId,@QueryTypeId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantUserDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantUserDataMartPermission]
(
	@UserId int,
	@DatamartId int
)
AS BEGIN
	INSERT INTO PermissionsusersDatamarts(UserId, DataMartId) Values (@UserId,@DatamartId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantRightsToOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantRightsToOrganization] --1
(
	@OrganizationId int,
	@RightIds varchar(1000)
)
AS BEGIN
if (@OrganizationId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsRights where OrganizationId = @OrganizationId
		if (@RightIds <> '')

		INSERT INTO PermissionsOrganizationsRights SELECT @OrganizationId, value from 
			GetValueTableOfDelimittedString(@RightIds, ',')

		Select @@Error
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantRightsToGroup]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantRightsToGroup] --1
(
	@GroupId int,
	@RightIds varchar(1000)
)
AS BEGIN
if (@GroupId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsRights where GroupId = @GroupId
		if (@RightIds <> '')

		INSERT INTO PermissionsGroupsRights SELECT @GroupId, value from 
			GetValueTableOfDelimittedString(@RightIds, ',')

		Select @@Error
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantQueryTypeForUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantQueryTypeForUsers]
(
@QueryTypeId int,
@UserIds varchar(1000)
)
AS BEGIN

	if (@QueryTypeId > 0 )
	BEGIN
		DELETE FROM PermissionsUsersQueryTypes where QueryTypeId = @QueryTypeId
		if (@UserIds <> '')

		INSERT INTO PermissionsUsersQueryTypes (QueryTypeId,UserId) SELECT @QueryTypeId, value from 
			GetValueTableOfDelimittedString(@UserIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantQueryTypeForOrganizations]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantQueryTypeForOrganizations]
(
@QueryTypeId int,
@OrganizationIds varchar(1000)
)
AS BEGIN

	if (@QueryTypeId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsQueryTypes where QueryTypeId = @QueryTypeId
		if (@OrganizationIds <> '')

		INSERT INTO PermissionsOrganizationsQueryTypes (QueryTypeId,OrganizationId) SELECT @QueryTypeId, value from 
			GetValueTableOfDelimittedString(@OrganizationIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantQueryTypeForGroups]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantQueryTypeForGroups]
(
@QueryTypeId int,
@GroupIds varchar(1000)
)
AS BEGIN

	if (@QueryTypeId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsQueryTypes where QueryTypeId = @QueryTypeId

		if (@GroupIds <> '')
		INSERT INTO PermissionsGroupsQueryTypes (QueryTypeId,GroupId) SELECT @QueryTypeId, value from 
			GetValueTableOfDelimittedString(@GroupIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantOrganizationRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantOrganizationRightPermission]
(
	@OrganizationId int,
	@RightId int
)
AS BEGIN
if not exists( Select 1 from PermissionsOrganizationsRights Where OrganizationId = @OrganizationId and RightId = @RightId)
	INSERT INTO PermissionsOrganizationsRights(OrganizationId, RightId) Values (@OrganizationId,@RightId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantOrganizationDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantOrganizationDataMartPermission]
(
	@OrganizationId int,
	@DatamartId int
)
AS BEGIN
	INSERT INTO PermissionsOrganizationsDatamarts(OrganizationId, DataMartId) Values (@OrganizationId,@DatamartId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantGroupRightPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantGroupRightPermission]
(
	@GroupId int,
	@RightId int
)
AS BEGIN
if not exists(Select 1 from PermissionsGroupsRights Where GroupId = @GroupId and RightId = @RightId)
	INSERT INTO PermissionsGroupsRights(GroupId, RightId) Values (@GroupId,@RightId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantGroupQueryTypePermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantGroupQueryTypePermission]
(
	@GroupId int,
	@QueryTypeId int
)
AS BEGIN
	INSERT INTO PermissionsGroupsQueryTypes(GroupId, QueryTypeId) Values (@GroupId,@QueryTypeId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantGroupDataMartPermission]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantGroupDataMartPermission]
(
	@GroupId int,
	@DatamartId int
)
AS BEGIN
	INSERT INTO PermissionsGroupsDatamarts(GroupId, DataMartId) Values (@GroupId,@DatamartId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantDatamartForUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantDatamartForUsers]
(
@DatamartId int,
@UserIds varchar(1000)
)
AS BEGIN

	if (@DatamartId > 0 )
	BEGIN
		DELETE FROM PermissionsUsersDatamarts where DatamartId = @DatamartId
		if (@UserIds <> '')

		INSERT INTO PermissionsUsersDatamarts (DatamartId,UserId) SELECT @DatamartId, value from 
			GetValueTableOfDelimittedString(@UserIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantDatamartForOrganizations]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantDatamartForOrganizations]
(
@DatamartId int,
@OrganizationIds varchar(1000)
)
AS BEGIN

	if (@DatamartId > 0 )
	BEGIN
		DELETE FROM PermissionsOrganizationsDatamarts where DatamartId = @DatamartId
		if (@OrganizationIds <> '')

		INSERT INTO PermissionsOrganizationsDatamarts (DatamartId,OrganizationId) SELECT @DatamartId, value from 
			GetValueTableOfDelimittedString(@OrganizationIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGrantDatamartForGroups]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGrantDatamartForGroups]
(
@DatamartId int,
@GroupIds varchar(1000)
)
AS BEGIN

	if (@DatamartId > 0 )
	BEGIN
		DELETE FROM PermissionsGroupsDatamarts where DatamartId = @DatamartId

		if (@GroupIds <> '')
		INSERT INTO PermissionsGroupsDatamarts (DatamartId,GroupId) SELECT @DatamartId, value from 
			GetValueTableOfDelimittedString(@GroupIds, ',')

		Select @@Error
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetRightsForRole]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetRightsForRole] --1
(
	@RoleId int
)
AS BEGIN
	If @RoleId > 0
		BEGIN
			Select RightId from RoleRightsMap where RoleTypeId = @RoleId
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryTypesForUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryTypesForUser]
	@UserId INT,
	@CategoryID INT = 0
AS
BEGIN
Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @UserId

SELECT	qt.QueryTypeId, qt.QueryType, qt.QueryDescription, qt.IsVisibleForSelection, qt.IsAdminQueryType, qt.QueryCategoryId
FROM	QueryTypes qt INNER JOIN QueryCategory qc ON qt.QueryCategoryId = qc.QueryCategoryID
WHERE	qt.IsVisibleForSelection = 1 and
qt.QueryTypeId IN 

(Select QueryTypeId From PermissionsUsersQueryTypes Where UserId = @UserId  
						 UNION  
						 SELECT QueryTypeId From PermissionsOrganizationsQueryTypes Where OrganizationId = @OrgId  
						 UNION  
						 SELECT QueryTypeId From PermissionsGroupsQueryTypes Where GroupId in (Select GroupId from OrganizationsGroups where OrganizationId = @OrgId)  )
AND qt.QueryCategoryId = CASE @CategoryID
						 WHEN 0 THEN qt.QueryCategoryId
						 ELSE @CategoryID
						 END
ORDER BY qt.QueryType
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryTypeListWithPermissionsForUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryTypeListWithPermissionsForUser]
(
@UserId int,
@OrganizationId int
)
AS BEGIN

SELECT qt.*
,(SELECT count(*) FROM PermissionsUsersQueryTypes puqt WHERE puqt.UserId = @UserId AND puqt.QueryTypeId = qt.QueryTypeId) AS "UserPermissions" 
,(SELECT count(*) FROM PermissionsOrganizationsQueryTypes poqt WHERE poqt.OrganizationId = @OrganizationId AND poqt.QueryTypeId = qt.QueryTypeId) AS "OrganizationPermissions" 
,(SELECT count(*) FROM PermissionsGroupsQueryTypes poqt WHERE poqt.GroupId in (Select Groupid FROM OrganizationsGroups og WHERE og.OrganizationId = @OrganizationId) AND poqt.QueryTypeId = qt.QueryTypeId) AS "GroupPermissions" 
from querytypes qt


END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryTypeListWithPermissionsForOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryTypeListWithPermissionsForOrganization]
(
@OrganizationId int
)
AS BEGIN

SELECT qt.*
,(SELECT count(*) FROM PermissionsOrganizationsQueryTypes poqt WHERE poqt.OrganizationId = @OrganizationId AND poqt.QueryTypeId = qt.QueryTypeId) AS "OrganizationPermissions" 
,(SELECT count(*) FROM PermissionsGroupsQueryTypes poqt WHERE poqt.GroupId in (Select Groupid FROM OrganizationsGroups og WHERE og.OrganizationId = @OrganizationId) AND poqt.QueryTypeId = qt.QueryTypeId) AS "GroupPermissions" 
from querytypes qt


END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryTypeListWithPermissionsForGroup]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryTypeListWithPermissionsForGroup]
(
@GroupId int
)
AS BEGIN

select qt.*
,(select count(*) from PermissionsGroupsQueryTypes poqt where poqt.GroupId = @GroupId and poqt.QueryTypeId = qt.QueryTypeId) as "GroupPermissions" 
from querytypes qt

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryAttributes]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryAttributes] 
(
	@queryTypeId int
)
AS BEGIN

Select qt.QueryDescription , inf.Information
FROM QueryTypes qt
left Join Information inf
on inf.QueryTypeId = qt.QueryTypeId
WHERE qt.QueryTypeId = @queryTypeId

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationRights]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationRights] 
(
	@OrganizationId int
)
AS BEGIN
	If @OrganizationId > 0
		BEGIN
			SELECT RightId From PermissionsOrganizationsRights por
			Where OrganizationId = @OrganizationId
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationQueryTyePermissions]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationQueryTyePermissions] 
(
	@OrganizationId int
)
AS BEGIN
	If @OrganizationId > 0
		BEGIN
			SELECT QueryTypeId From PermissionsOrganizationsQueryTypes poqt
			Where OrganizationId = @OrganizationId
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationDataMartPermissions]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationDataMartPermissions] --1,1
(
	@OrganizationId int
)
AS BEGIN
	If @OrganizationId > 0
		BEGIN
			SELECT pod.DataMartId From PermissionsOrganizationsDataMarts pod
			--Get only datamarts that is not deleted					
			inner join DataMarts dm
			on dm.DataMartId = pod.DatamartId
			Where dm.OrganizationId = @OrganizationId
			and isDeleted = 0			
		
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupDataMartPermissions]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupDataMartPermissions]
(
	@GroupId int
)
AS BEGIN
	If @GroupId > 0
		BEGIN
			SELECT pgd.DataMartId From PermissionsGroupsDataMarts pgd
			--Get only datamarts that is not deleted					
			inner join DataMarts dm
			on dm.DataMartId = pgd.DatamartId
			Where GroupId = @GroupId
			and isDeleted = 0			
		
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupRights]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupRights] 
(
	@GroupId int
)
AS BEGIN
	If @GroupId > 0
		BEGIN
			SELECT RightId From PermissionsGroupsRights pgr
			Where GroupId = @GroupId
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupQueryTyePermissions]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupQueryTyePermissions] 
(
	@GroupId int
)
AS BEGIN
	If @GroupId > 0
		BEGIN
			SELECT QueryTypeId From PermissionsGroupsQueryTypes pgqt
			Where GroupId = @GroupId
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetOrganizationAdministrators]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetOrganizationAdministrators] --32
(
	@OrganizationId int
)
AS BEGIN
	If @OrganizationId > 0
		BEGIN
			SELECT  u.*,o.OrganizationName  
			FROM OrganizationAdministrators oa			 
			INNER join Users u
			on u.UserId = oa.AdminUserId and 
			isnull(u.isDeleted,0)=0
			INNER JOIN Organizations o
			on o.OrganizationId = oa.OrganizationId  and 
			isnull(o.isDeleted,0)=0						
			WHERE  			 
			 oa.OrganizationId =  @OrganizationId 
		END
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetObserversByUserId]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bruce Swan
-- Create date: 7/26/2011
-- Description:	Return list of users with Observer role for given user's organization
-- =============================================
CREATE PROCEDURE [dbo].[uspGetObserversByUserId] 
	@UserId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Users.*, Organizations.* FROM Users INNER JOIN Organizations on Users.OrganizationId = Organizations.OrganizationId 
	INNER JOIN RoleRightsMap on RoleRightsMap.RoleTypeId = Users.RoleTypeId
	WHERE RoleRightsMap.RightId = 66 AND Users.isDeleted = 0 AND 
	Organizations.OrganizationId = (SELECT Orgs.OrganizationId FROM Organizations Orgs INNER JOIN Users ON Orgs.OrganizationId = Users.OrganizationId WHERE Users.UserId = @UserId) 
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetObserversByOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bruce Swan
-- Create date: 8/3/2011
-- Description:	Return list of users with Observer role for given organization
-- =============================================
CREATE PROCEDURE [dbo].[uspGetObserversByOrganization] 
	@OrganizationId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM Users	
		INNER JOIN Organizations ON Organizations.OrganizationId = Users.OrganizationId
		INNER JOIN RoleRightsMap on RoleRightsMap.RoleTypeId = Users.RoleTypeId	
	WHERE RoleRightsMap.RightId = 66 AND Users.isDeleted = 0 AND @OrganizationId = Users.OrganizationId AND Organizations.IsDeleted = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationUserIdsForDataMart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetNotificationUserIdsForDataMart] --10
(
@DataMartId int
)
AS

SELECT
	u.*,o.OrganizationName
FROM DataMarts dm
inner join DatamartNotifications dmf
on dmf.DataMartId = dm.DatamartId
inner join Users u
on u.userId = dmf.NotificationUserId
AND u.isDeleted=0
left join Organizations o
on o.OrganizationId = dm.OrganizationId
and o.isDeleted = 0
WHERE
dm.DataMartId = @DatamartId AND dm.IsDeleted = 0 

ORDER BY
	Username
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationSecureGUID]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[uspGetNotificationSecureGUID] 
(
@SecureGUId varchar(100),
@userId int
)
AS Begin

Select nsg.NotificationId, nsg.NotificationGUID, nsg.NotificationUrlParameters, nsg.IsActive  from NotificationSecureGUID nsg
			Inner JOIN Notifications n
			on n.notificationId = nsg.NotificationId
			Where nsg.NotificationGUID = @SecureGUId and n.userId = @userId and isActive = 1	

End
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationsByUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetNotificationsByUser]   
(  
@UserId int,  
@IncludeDelivered bit,
@days int = 90   
)  
AS BEGIN  
  
	if (@IncludeDelivered = 0)  
		BEGIN  
			SELECT isnull(n.Priority,2) as Priority, n.NotificationId,n.NotificationTypeId,evtTypes.EventType, n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime, n.Priority,
				n.OtherData as OtherData, nGUID.NotificationGUID,nop.FrequencyId,nop.Days 
			FROM Notifications n
			INNER JOIN Events e ON e.EventId = n.EventId
			LEFT JOIN NotificationSecureGUID nGUID
			on nGUID.NotificationId = n.NotificationId  
			LEFT JOIN NotificationOptions nop on nop.EventTypeId=e.EventTypeId and nop.UserId=n.UserId
			LEFT JOIN  EventTypes evtTypes on e.EventTypeId = evtTypes.EventTypeId
			WHERE DeliveredTime is null AND n.UserId = @UserId
			AND (n.DeliveredTime is null or DateDiff(dd,n.DeliveredTime,GetDate())<@days)
			ORDER BY DeliveredTime Desc
		END  
	ELSE  
		BEGIN  
			SELECT isnull(n.Priority,2) as Priority, n.NotificationId,n.NotificationTypeId,evtTypes.EventType,n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime,n.Priority,
			n.OtherData as OtherData, nGUID.NotificationGUID,nop.FrequencyId,nop.Days 
			FROM Notifications n
			INNER JOIN Events e ON e.EventId = n.EventId
			LEFT JOIN NotificationSecureGUID nGUID
			on nGUID.NotificationId = n.NotificationId			
			LEFT JOIN NotificationOptions nop on nop.EventTypeId=e.EventTypeId and nop.UserId=n.UserId 
			LEFT JOIN  EventTypes evtTypes on e.EventTypeId = evtTypes.EventTypeId
			WHERE n.UserId = @UserId
			AND (n.DeliveredTime is null or DateDiff(dd,n.DeliveredTime,GetDate())<@days)
			ORDER BY DeliveredTime Desc
		END
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupAdministrators]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetGroupAdministrators] --18  
(  
@GroupId int  
)  
AS BEGIN  

 SELECT U.*,o.OrganizationName from GroupAdministrators ga
 Inner join Groups grp  
 on grp.GroupId = ga.GroupId   
 AND IsNull(grp.IsDeleted ,0) = 0  
 Inner JOIN Users u  
 on u.UserId = ga.AdminUserId  
 and isNull(u.IsDeleted,0) = 0 
 Inner join Organizations o
 on o.OrganizationId = u.OrganizationId
 and isNull(o.IsDeleted,0) = 0 
 Where ga.GroupId = @GroupId  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDaysforPasswordExpiry]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDaysforPasswordExpiry] --25,6
	@UserId Int,
	@ConfiguredPasswordExpiryMonths int
AS BEGIN

If @UserId > 0
	BEGIN
		Declare @diffDays int
		Select @diffDays = DateDiff(d,GetDate(),DateAdd(m,@ConfiguredPasswordExpiryMonths,Max(DateAdded))) from UserPasswordTrace Where UserId = @UserId
		if (@diffDays < 0)
			Set @diffDays = -1
		select @diffDays
	END
ELSE
	BEGIN
		select -99
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsByAdminUserId]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDataMartsByAdminUserId] 
	@AdminUserId INT
AS

SELECT	dm.*, usr.UserName as AdminUserName,dmt.DataMartType
FROM	DataMarts dm
INNER JOIN DataMartTypes dmt  
on dmt.DataMartTypeId = dm.DataMartTypeId 
LEFT JOIN users usr  
on usr.userId = @AdminUserId  
WHERE	dm.DatamartId in (Select DatamartId from DatamartNotifications where NotificationUserId = @AdminUserId)
AND dm.IsDeleted = 0
ORDER	BY DataMartId
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsForQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartsForQueryType] --'DatamartName', 1, 16,8
(  
@SortColumn varchar(20),  
@IsDescending bit,  
@LoggedInUser int,
@QueryTypeId int
)  
AS BEGIN  
  
 Declare @OrgId int        
 Set @OrgId = 0        
 Select @OrgId = OrganizationId from users where UserId = @LoggedInUser  
 
if (@QueryTypeId <> 8 AND @QueryTypeId <> 13)
		BEGIN  
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner Join DataMartTypes dmt  
		on dmt.DataMartTypeId = dm.DataMartTypeId  
		left join Organizations o  
		on o.OrganizationId = dm.OrganizationId 

		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
		Where dm.DatamartId in 
			   (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @LoggedInUser    
			   UNION    
			   SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId    
			   UNION    
			   SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 
					Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  
				)  
		AND ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		Order by CASE @IsDescending                                        
			WHEN 1 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END DESC,  
		  CASE @IsDescending                                        
			WHEN 0 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END 
		END  
	ELSE
		BEGIN
			Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner Join DataMartTypes dmt  
		on dmt.DataMartTypeId = dm.DataMartTypeId  
		left join Organizations o  
		on o.OrganizationId = dm.OrganizationId 

		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
		Where dm.DatamartId in 
			   (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @LoggedInUser    
			   UNION    
			   SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId    
			   UNION    
			   SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 
					Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  
				)  
		AND ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		Order by CASE @IsDescending                                        
			WHEN 1 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END DESC,  
		  CASE @IsDescending                                        
			WHEN 0 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END 
		END	    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartsForNotification]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspGetDatamartsForNotification]
@EventTypeId INT
AS
BEGIN
	SELECT DISTINCT dm.DatamartId  
			  , dm.DataMartName  
			  , dm.Url  
			  , dm.RequiresApproval  
			  , dm.DataMartTypeId  
			  , dm.OrganizationId    
			  , dm.AvailablePeriod  
			  , dm.ContactEmail  
			  , dm.ContactFirstName  
			  , dm.ContactLastName  
			  , dm.ContactPhone  
			  , dm.SpecialRequirements  
			  , dm.UsageRestrictions  
			  , dmt.DataMartType    
			  , dm.HealthPlanDescription   
		FROM DataMarts dm
			INNER JOIN DatamartNotifications dn ON dm.DataMartId = dn.DatamartId
			INNER JOIN NotificationOptions nop ON dn.NotificationUserId = nop.UserId
			INNER JOIN DataMartTypes dmt ON dmt.DataMartTypeId = dm.DataMartTypeId
			INNER JOIN PermissionsOrganizationsDataMarts pod ON dm.DataMartId = pod.DataMartId
			INNER JOIN Organizations o ON o.OrganizationId = pod.OrganizationId
			INNER JOIN Users u ON nop.UserId = u.UserId
		WHERE ISNULL(dm.isDeleted,0) = 0 
			 AND ISNULL(o.IsDeleted,0) = 0
			 AND ISNULL(u.isDeleted,0) = 0
			 AND dmt.DataMartTypeId = 1
			 AND nop.EventTypeId = @EventTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsForUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartsForUser] --'DatamartName', 1, 16
(
@SortColumn varchar(20),
@IsDescending bit,
@LoggedInUser int
)
AS BEGIN

 Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @LoggedInUser


Select dm.DatamartId
	 , dm.DataMartName
	 , dm.Url
	 , dm.RequiresApproval
	 , dm.DataMartTypeId
	 , dm.OrganizationId	 
	 , dm.AvailablePeriod
	 , dm.ContactEmail
	 , dm.ContactFirstName
	 , dm.ContactLastName
	 , dm.ContactPhone
	 , dm.SpecialRequirements
	 , dm.UsageRestrictions
	 , dmt.DataMartType	 
	 , dm.HealthPlanDescription	
FROM DataMarts dm
inner Join DataMartTypes dmt
on dmt.DataMartTypeId = dm.DataMartTypeId
left join Organizations o
on o.OrganizationId = dm.OrganizationId
--inner Join PermissionsUsersDataMarts pudm
--on pudm.DataMartId = dm.DataMartId
--AND pudm.UserId = @LoggedInUser
Where dm.DatamartId in (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @LoggedInUser  
						 UNION  
						 SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId  
						 UNION  
						 SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  )
AND ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0
Order by CASE @IsDescending                                      
		  WHEN 1 THEN               
				Case  @SortColumn                             
					When 'DatamartName' then dm.DataMartName                           
					When 'Type' then dmt.DataMartType                             
					Else dm.DataMartName                             
				END              
		  END DESC,
		CASE @IsDescending                                      
		  WHEN 0 THEN               
				Case  @SortColumn                             
					When 'DatamartName' then dm.DataMartName                           
					When 'Type' then dmt.DataMartType                             
					Else dm.DataMartName                             
				END              
		  END     
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllUserWithRight]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllUserWithRight] --1
(
	@RightId int
)
AS BEGIN
Select u.*,o.OrganizationName From Users u
Inner join Organizations o 
on u.OrganizationId = o.OrganizationId and u.isdeleted = 0 and o.isDeleted = 0
where u.RoletypeId in (Select distinct roleTypeId from roleRightsMap rrm where rightId = @rightId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetCumulativeGroupRightsForOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetCumulativeGroupRightsForOrganization] --25
( 
	@OrganizationId int
)
AS BEGIN
SELECT distinct(pgr.RightId) as RightId from PermissionsGroupsRights pgr
INNER Join OrganizationsGroups og
on og.OrganizationId = @OrganizationId
AND pgr.GroupId = og.GroupId
INNER JOIN Groups g
on g.GroupId = og.GroupId and g.IsDeleted = 0
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDatamartForQueryType] 
(
@QueryTypeId int,
@UserId int
)
AS BEGIN

--------------
 Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @UserId
------------

Select distinct dm.*,dmt.DatamartType from Datamarts dm
INNER JOIN (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @UserId  
						 UNION  
						 SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId  
						 UNION  
						 SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  ) dmList
on dm.DatamartId = dmList.DatamartId
INNER JOIN PermissionsQueryTypesDatamarts pqtd
on pqtd.DatamartId = dm.DatamartId
AND pqtd.QueryTypeId = @QueryTypeId
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DataMartTypeId
Left Join Organizations o
on o.OrganizationId = dm.OrganizationId
Where isnull(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartListWithPermissionsForUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDataMartListWithPermissionsForUser]  
(  
@UserId int,  
@OrganizationId int  
)  
AS BEGIN  
  
 select dm.*, dmt.DataMartType    
 ,(select count(*) from PermissionsUsersDataMarts pudm where pudm.UserId = @UserId and pudm.DataMartId = dm.DataMartId) as "UserPermissions"   
 ,(select count(*) from PermissionsOrganizationsDataMarts podm where podm.OrganizationId = @OrganizationId and podm.DataMartId = dm.DataMartId) as "OrganizationPermissions"   
 ,(select count(*) from PermissionsGroupsDataMarts pgdm where pgdm.GroupId in (Select Groupid from OrganizationsGroups og where og.OrganizationId = @OrganizationId) and pgdm.DataMartId = dm.DataMartId) as "GroupPermissions"   
 FROM DataMarts dm  
 inner Join DataMartTypes dmt  
 on dmt.DataMartTypeId = dm.DataMartTypeId  
 left join Organizations o  
 on o.OrganizationId = dm.OrganizationId  
 Where ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0 
 ORDER BY DataMartName  
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartListWithPermissionsForOrganization]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDataMartListWithPermissionsForOrganization]  
(  
@OrganizationId int  
)  
AS BEGIN  
  
 select dm.*, dmt.DataMartType    
 ,(select count(*) from PermissionsOrganizationsDataMarts podm where podm.OrganizationId = @OrganizationId and podm.DataMartId = dm.DataMartId) as "OrganizationPermissions"   
 ,(select count(*) from PermissionsGroupsDataMarts pgdm where pgdm.GroupId in (Select Groupid from OrganizationsGroups og where og.OrganizationId = @OrganizationId) and pgdm.DataMartId = dm.DataMartId) as "GroupPermissions"   
 FROM DataMarts dm  
 inner Join DataMartTypes dmt  
 on dmt.DataMartTypeId = dm.DataMartTypeId  
 left join Organizations o  
 on o.OrganizationId = dm.OrganizationId  
 Where ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0  and isnull(dm.IsGroupDataMart,0) = 0
 ORDER BY DataMartName  
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartListWithPermissionsForGroup]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDataMartListWithPermissionsForGroup]  
(  
@GroupId int  
)  
AS BEGIN  
  
 select dm.*, dmt.DataMartType    
 ,(select count(*) from PermissionsGroupsDataMarts pgdm where pgdm.GroupId = @GroupId and pgdm.DataMartId = dm.DataMartId) as "GroupPermissions"   
 FROM DataMarts dm  
 inner Join DataMartTypes dmt  
 on dmt.DataMartTypeId = dm.DataMartTypeId  
 left join Organizations o  
 on o.OrganizationId = dm.OrganizationId  
 Where ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0  and isnull(dm.IsGroupDataMart,0) = 0
 ORDER BY DataMartName  
  
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllUserForQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllUserForQueryType] --1
(
	@QueryTypeId int
)
AS BEGIN
SELECT u.*,o.OrganizationName FROM PermissionsUsersQueryTypes puqt
INNER JOIN Users u
on u.UserId = puqt.UserId AND isnull(u.IsDeleted,0) = 0
INNER JOIN Organizations o
on o.OrganizationId  = u.OrganizationId AND isnull(o.IsDeleted,0)= 0
WHERE puqt.QueryTypeId = @QueryTypeId

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllUserForDatamart]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllUserForDatamart] --1
(
	@DatamartId int
)
AS BEGIN
SELECT u.*,o.OrganizationName FROM PermissionsUsersDatamarts pudt
INNER JOIN Users u
on u.UserId = pudt.UserId AND isnull(u.IsDeleted,0) = 0
INNER JOIN Organizations o
on o.OrganizationId  = u.OrganizationId AND isnull(o.IsDeleted,0)= 0
WHERE pudt.DatamartId = @DatamartId

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationForQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationForQueryType] --1    
(    
 @QueryTypeId int    
)    
AS BEGIN    
SELECT o.OrganizationId, o.OrganizationName,o.isDeleted, o.OrganizationAcronym FROM PermissionsOrganizationsQueryTypes poqt    
INNER JOIN Organizations o    
on o.OrganizationId  = poqt.OrganizationId AND isnull(o.IsDeleted,0)= 0    
WHERE poqt.QueryTypeId = @QueryTypeId    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationForDatamart]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationForDatamart] --1
(
	@DatamartId int
)
AS BEGIN
SELECT o.* FROM PermissionsOrganizationsDatamarts podt
INNER JOIN Organizations o
on o.OrganizationId  = podt.OrganizationId AND isnull(o.IsDeleted,0)= 0
WHERE podt.DatamartId = @DatamartId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllNotifications]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllNotifications]  --true , 1 
(  
 @IncludeDelivered bit,   
 @IncludeSummaryNotifications bit=0   
)  
AS 
BEGIN  
 
	if (@IncludeDelivered = 0)  
		BEGIN  
			SELECT isnull(n.Priority,2) as Priority,n.NotificationId,n.NotificationTypeId,n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime,
				n.EncryptedData as OtherData, nGUID.NotificationGUID,nop.FrequencyId,nop.Days 
			FROM Notifications n
			INNER JOIN Events e ON e.EventId = n.EventId
			LEFT JOIN NotificationSecureGUID nGUID
			on nGUID.NotificationId = n.NotificationId  
			LEFT JOIN NotificationOptions nop on nop.EventTypeId=e.EventTypeId and nop.UserId=n.UserId 
			WHERE DeliveredTime is null and 
					(
					(nop.FrequencyId is null) 
					or (ISNULL(@IncludeSummaryNotifications,0)=1) --Summary Notifications to be included,Frequency Specified=any,
					or (ISNULL(@IncludeSummaryNotifications,0)=0 and  ISNULL(nop.FrequencyId,0)=6) --Summary Notifications Not to be Included,Frequency Specified=Instant,
					)
		END  
	ELSE  
		BEGIN  
			SELECT isnull(n.Priority,2) as Priority,n.NotificationId,n.NotificationTypeId,n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime,
			n.EncryptedData as OtherData, nGUID.NotificationGUID,nop.FrequencyId,nop.Days 
			FROM Notifications n
			INNER JOIN Events e ON e.EventId = n.EventId
			LEFT JOIN NotificationSecureGUID nGUID
			on nGUID.NotificationId = n.NotificationId			
			LEFT JOIN NotificationOptions nop on nop.EventTypeId=e.EventTypeId and nop.UserId=n.UserId 
			WHERE (
					(nop.FrequencyId is null) 
					or (ISNULL(@IncludeSummaryNotifications,0)=1) --Summary Notifications to be included,Frequency Specified=any,
					or (ISNULL(@IncludeSummaryNotifications,0)=0 and  ISNULL(nop.FrequencyId,0)=6) --Summary Notifications Not to be Included,Frequency Specified=Instant,
					)
		END 
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationsWithGroups]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllOrganizationsWithGroups]    
AS BEGIN    
    
Select o.OrganizationId, o.OrganizationName, dbo.GetGroupList(o.OrganizationId) AS GroupList  
FROM Organizations o    
Where ISNULL(o.IsDeleted,0) = 0    
    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationsForGroup]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationsForGroup]  
(    
@GroupId int    
)    
AS BEGIN    
 SELECT org.OrganizationId, org.OrganizationName,org.OrganizationAcronym,org.isDeleted,dbo.GetGroupList(org.OrganizationId) AS GroupList    
    from OrganizationsGroups og    
 Inner join Groups grp    
 on IsNull(grp.IsDeleted ,0) = 0    
 AND grp.GroupId = og.GroupId     
 Inner JOIN Organizations org    
 on org.OrganizationId = og.OrganizationId    
 and isNull(org.IsDeleted,0) = 0    
 Where grp.GroupId = @GroupId    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationWithRight]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationWithRight] --1
(
	@RightId int
)
AS BEGIN
SELECT o.* FROM PermissionsOrganizationsRights por
INNER JOIN Organizations o
on o.OrganizationId  = por.OrganizationId AND isnull(o.IsDeleted,0)= 0
WHERE por.RightId = @RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateEntityAddedRemovedEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateEntityAddedRemovedEvent]   
(  
@EventSourceId int,  
@EventTypeId int,  
@EntityTypeId int,  
@EntityId int,  
@DatamartId int,  
@IsAdded bit,
@IsSystemEntity bit  
)  
AS BEGIN  
Declare   
 @EventId int   
 ,@UserID int  
 ,@OrganizationID int  
 ,@GroupID int  
  
select   
 @UserID=Case @EntityTypeId WHEN 1 Then @EntityId Else NULL END  
 ,@OrganizationID=Case @EntityTypeId WHEN 2 Then @EntityId Else NULL END  
 ,@GroupID=Case @EntityTypeId WHEN 3 Then @EntityId Else NULL END  
  
BEGIN TRANSACTION    
  
if (@EntityId > 0)  
 BEGIN  
    
  INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES    
   (@EventSourceId,@EventTypeId,GetDate())  
  
   if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -1 as returnValue--Error while inserting to events table    
       --This will be used to trace issue on the part of query caused the issue  
      return  
     END    
   else  
    Select @EventId = Scope_Identity()    
 END  
  
if (@EventId > 0)  
 BEGIN  
  INSERT INTO EventDetailEntityAdded (EventId, EntityTypeID,DatamartId,UserID,OrganizationID,GroupID,IsEntityAdded, IsSystemEntity)  
   VALUES(@EventId,@EntityTypeID, @DatamartId,@UserID,@OrganizationID,@GroupID,@IsAdded,@IsSystemEntity)  
  
  if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -2 as returnValue--Error while inserting to status change table.   
       --This will be used to trace issue on which part of query caused the issue  
      Return  
     END    
  else  
   BEGIN  
    COMMIT  
   END     
 END  
  
  
Select @EventId as returnValue  
Return @EventId  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAdministrativeUsersForQueryApproval]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAdministrativeUsersForQueryApproval]  --1,'28',1   
(@OrganizationId int,    
 @AdminUserIds varchar(1000),        
 @ExcludeIdsPassed bit      
)
AS
BEGIN

If (@ExcludeIdsPassed = 0)
	BEGIN
		SELECT distinct u.*, o.OrganizationName    
		FROM Users u 
			INNER JOIN Organizations o ON u.OrganizationId = o.OrganizationId
			LEFT JOIN RoleRightsMap rrm ON u.RoleTypeId = rrm.RoleTypeId
		WHERE rrm.RightId in (63) 
			AND o.OrganizationId = @OrganizationId
			AND u.UserId in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))
	
		UNION
		
		SELECT distinct u.*, o.OrganizationName    
		FROM Users u 
			INNER JOIN Organizations o ON u.OrganizationId = o.OrganizationId
			LEFT JOIN PermissionsUsersRights pur ON u.UserId = pur.UserId
		WHERE pur.RightId in (63) 
			AND o.OrganizationId = @OrganizationId
			AND u.UserId in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))
	END
ELSE
	BEGIN
		SELECT distinct u.*, o.OrganizationName
		FROM Users u
			INNER JOIN Organizations o ON u.OrganizationId = o.OrganizationId
			LEFT JOIN RoleRightsMap rrm ON u.RoleTypeId = rrm.RoleTypeId
		WHERE rrm.RightId in (63) 
			AND o.OrganizationId = @OrganizationId
			AND u.UserId not in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))
	
		UNION
		
		SELECT distinct u.*, o.OrganizationName    
		FROM Users u 
			INNER JOIN Organizations o ON u.OrganizationId = o.OrganizationId
			LEFT JOIN PermissionsUsersRights pur ON u.UserId = pur.UserId
		WHERE pur.RightId in (63) 
			AND o.OrganizationId = @OrganizationId
			AND u.UserId not in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))
	
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAdministrativeUsersForGroupApproval]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAdministrativeUsersForGroupApproval]  --1,'28',1   
(@GroupId int,    
 @AdminUserIds varchar(1000),        
 @ExcludeIdsPassed bit      
)      
AS BEGIN      
 If (@ExcludeIdsPassed = 0)      
  BEGIN      
  SELECT distinct u.*, o.OrganizationName    
  FROM Users u    
  LEFT JOIN RoleRightsMap rrm     
  on rrm.RoleTypeId = u.RoleTypeId and rrm.RightId in (49) 
  LEFT JOIN PermissionsOrganizationsRights por    
  on por.OrganizationId = u.OrganizationId and por.RightId in (49) 
  LEFT JOIN OrganizationsGroups og    
  on og.OrganizationId = u.OrganizationId    
  Left JOIN PermissionsGroupsRights pgr    
  on pgr.GroupId = og.GroupId and pgr.RightId in (49)
  left join Organizations o    
  on u.OrganizationId = o.OrganizationId    
  inner join Groups g    
  on g.GroupId = og.GroupId    
  WHERE    
  isnull(u.isDeleted,0) = 0    
    and isnull(o.Isdeleted,0) = 0    
    and isnull(g.Isdeleted,0) = 0    
    and Coalesce(rrm.RightId,por.RightId, pgr.RightId,0) in (49)  
    and g.GroupId = @GroupId  
    and u.UserId in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))      
  ORDER BY UserId       
  END      
 ELSE      
  BEGIN      
 SELECT distinct u.*, o.OrganizationName    
  
  FROM Users u    
  LEFT JOIN RoleRightsMap rrm     
  on rrm.RoleTypeId = u.RoleTypeId and rrm.RightId in (49) 
  LEFT JOIN PermissionsOrganizationsRights por    
  on por.OrganizationId = u.OrganizationId and por.RightId in (49) 
  LEFT JOIN OrganizationsGroups og    
  on og.OrganizationId = u.OrganizationId    
  Left JOIN PermissionsGroupsRights pgr    
  on pgr.GroupId = og.GroupId and pgr.RightId in (49)
  left join Organizations o    
  on u.OrganizationId = o.OrganizationId    
  inner join Groups g    
  on g.GroupId = og.GroupId    
  WHERE    
  isnull(u.isDeleted,0) = 0    
    and isnull(o.Isdeleted,0) = 0    
    and isnull(g.Isdeleted,0) = 0    
    and Coalesce(rrm.RightId,por.RightId, pgr.RightId,0) in (49)  
    and g.GroupId = @GroupId  
    and u.UserId not in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))      
  ORDER BY UserId       
        
  END      
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroupWithRight]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllGroupWithRight] --2
(
	@RightId int
)
AS BEGIN
SELECT g.* FROM PermissionsGroupsRights pgr
INNER JOIN Groups g
on g.GroupId  = pgr.GroupId AND isnull(g.IsDeleted,0)= 0
WHERE pgr.RightId = @RightId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroupForQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllGroupForQueryType] --4
(
	@QueryTypeId int
)
AS BEGIN
SELECT g.* FROM PermissionsGroupsQueryTypes pgqt
INNER JOIN Groups g
on g.GroupId  = pgqt.GroupId AND isnull(g.IsDeleted,0)= 0
WHERE pgqt.QueryTypeId = @QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllGroupForDatamart]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllGroupForDatamart] --4
(
	@DatamartId int
)
AS BEGIN
SELECT g.* FROM PermissionsGroupsDatamarts pgdt
INNER JOIN Groups g
on g.GroupId  = pgdt.GroupId AND isnull(g.IsDeleted,0)= 0
WHERE pgdt.DatamartId = @DatamartId
END
GO
/****** Object:  StoredProcedure [dbo].[uspAdminUsersForOrganizationGroup]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAdminUsersForOrganizationGroup]  --2
(@OrganizationId int
)    
AS BEGIN    

	 SELECT distinct u.*, o.OrganizationName  
	 FROM Organizations o  	 
	 INNER JOIN OrganizationsGroups og  
	 on o.OrganizationId = @OrganizationId
	 And og.OrganizationId = o.OrganizationId  
	 Inner join Groups g  
	 on g.GroupId = og.GroupId
	 Inner Join GroupAdministrators ga
	 on ga.GroupId = g.GroupId
	 Inner Join Users u
	 on u.UserId = ga.AdminuserId	     
	 WHERE  
		isnull(u.isDeleted,0) = 0  
	   and isnull(o.Isdeleted,0) = 0  
	   and isnull(g.Isdeleted,0) = 0  	   
	   and o.OrganizationId = @OrganizationId	   
	 ORDER BY UserId     
  
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddRightToRole]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAddRightToRole] --1
(
	@RoleTypeId int,
	@RightId int
)
AS BEGIN
	if not exists(Select 1 from RoleRightsMap Where RoleTypeId = @RoleTypeId and RightId = @RightId)
	INSERT INTO RoleRightsMap values (@RoleTypeId ,@RightId)
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddRightsToRole]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAddRightsToRole] --1
(
	@RoleTypeId int,
	@RightIds varchar(1000)
)
AS BEGIN
if (@RoleTypeId > 0 )
	BEGIN
		DELETE FROM RoleRightsMap where RoleTypeId = @RoleTypeId

		if (@RightIds <> '')

		INSERT INTO RoleRightsMap SELECT @RoleTypeId, value from 
			GetValueTableOfDelimittedString(@RightIds, ',')

		Select @@Error
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[uspCheckUserRight]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCheckUserRight] --25, 13
(
	@UserId int,
	@RightId int
)
AS BEGIN
	--Check rights at the user level
	If Exists (Select 1 From RoleRightsMap rrm inner join Users u on u.UserId = @UserId and u.RoleTypeId = rrm.RoleTypeId Where u.UserId = @UserId and rrm. RightId = @RightId and IsNull(u.IsDeleted,0) = 0)
		BEGIN
			Select 'true' as isRightsAvailable
			return
		END
	--Check rights at the organizational level when one does not exist in the user level
	Declare @OrgId int
	Select @OrgId = ISNULL(u. OrganizationId,0) From Users u inner join Organizations o on o.OrganizationId = u.OrganizationId and isnull(u.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 Where UserId = @UserId
	IF @OrgId = 0
		BEGIN
			Select 'false' as isRightsAvailable
			Return
		END
	Else
		BEGIN
			If Exists (Select 1 From PermissionsOrganizationsRights Where OrganizationId = @OrgId and RightId = @RightId)
				BEGIN
					Select 'true' as isRightsAvailable
					return
				END
		END
				

	If Exists (SELECT 1 From PermissionsGroupsRights Where GroupId in (Select isnull(og.GroupId,0) from OrganizationsGroups og inner join Groups g on g.GroupId = og.GroupId and isnull(g.IsDeleted,0 ) = 0 where OrganizationId = @OrgId ) and RightId = @RightId )
		BEGIN
			Select 'true' as isRightsAvailable
			return
		END
	ELSE
		BEGIN
			Select 'false' as isRightsAvailable
			return
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspAuthenticateUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspAuthenticateUser] 
	@Username VARCHAR(50),
	@Password VARCHAR(100),
	@ConfiguredPasswordExpiryMonths INT,
	@Version VARCHAR(25) = NULL,
	@SetEncryptionAtDatabase  BIT
AS

Declare @EncryptedPwd varchar(100) 
Declare @UserId int
Declare @PasswordEncryptionLength int

Select @userId = UserId, @PasswordEncryptionLength = PasswordEncryptionLength from Users u   
INNER JOIN Organizations o  
on IsNull(u.Isdeleted,0) = 0 and   
o.OrganizationId = u.OrganizationId and   
IsNull(o.Isdeleted,0) = 0   
where username = @Username   

if @UserId = 0  
	return  
else if @SetEncryptionAtDatabase = 1
	BEGIN
		--Encrypt only when the database encyption is enabled
		if @UserId > 0 and IsNull(@PasswordEncryptionLength,10) = 10  
			Set @EncryptedPwd =  dbo.udf_encrypt_password (@Password)  
		Else   
			exec master..xp_sha1 @password, @EncryptedPwd OUTPUT  
	END 
else if @SetEncryptionAtDatabase = 0
		-- Use the password encrypted at the application layer
		SET @EncryptedPwd = @Password

--check if the user password has not expired(rule: password should not be over 6 months old)
if 0 >= (Select DateDiff(d,DateAdd(m,@ConfiguredPasswordExpiryMonths,Max(DateAdded)),GetDate()) from UserPasswordTrace 
Where UserId = (Select UserId from Users where Username = @UserName and Password = @EncryptedPwd and IsNull(IsDeleted,0) = 0))

BEGIN
	IF @Version IS NOT NULL
		UPDATE Users SET Version = @Version, LastUpdated = GETDATE() WHERE UserId = @UserId 
		
--User authentication include, checking authentication up the hierarchy(Organization and group)
	SELECT	TOP 1 u.*, o.OrganizationName
	FROM	Users u
	LEFT JOIN RoleRightsMap rrm 
	on rrm.RoleTypeId = u.RoleTypeId and rrm.RightId = 1 --RightId = 1 (for Portal login right)
	LEFT JOIN PermissionsOrganizationsRights por
	on por.OrganizationId = u.OrganizationId and por.RightId = 1 --RightId = 1 (for Portal login right)
	LEFT JOIN OrganizationsGroups og
	on og.OrganizationId = u.OrganizationId
	LEFT JOIN PermissionsGroupsRights pgr
	on pgr.GroupId = og.GroupId and pgr.RightId = 1--RightId = 1 (for Portal login right)
	left join Organizations o
	on u.OrganizationId = o.OrganizationId
	left join Groups g
	on g.GroupId = og.GroupId
	WHERE	Username=@Username
			AND Password=@EncryptedPwd
			and isnull(u.isDeleted,0) = 0
			and isnull(o.Isdeleted,0) = 0
			and isnull(g.Isdeleted,0) = 0
			and Coalesce(rrm.RightId,por.RightId, pgr.RightId,0) = 1		
	ORDER	BY UserId
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateQueryTypeDatamartAssociationEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateQueryTypeDatamartAssociationEvent] 
(
@EventSourceId int,
@EventTypeId int,
@QueryTypeId int,
@DatamartId int,
@IsAdded bit=null,
@IsRemoved bit=null
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@QueryTypeId > 0 and not(@IsAdded is null and @IsRemoved is null))
	BEGIN
		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,@EventTypeId,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace issue on the part of query caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailQueryTypeDatamartAssociation (EventId, QueryTypeId, DatamartId,IsAdded,IsRemoved)
			VALUES(@EventId,@QueryTypeId, @DatamartId,Isnull(@IsAdded,0),Isnull(@IsRemoved,0))

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace issue on which part of query caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
Return @EventID
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewResult]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateNewResult] 
(
@ResultId int,
@EventSourceId int,
@DatamartId int
)
AS BEGIN

BEGIN TRANSACTION    
	Declare @EventId int
	Set @EventId = 0

	If exists (Select 1 from EventDetailNewResult where resultId = @ResultId and DatamartId = @DatamartId)
	BEGIN
		Select eventId as returnValue from EventDetailNewResult where resultId = @ResultId and DatamartId = @DatamartId
		return;
	END

		if (@ResultId > 0)  
		 BEGIN  
		    
			INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES    
		   (@EventSourceId,4,GetDate())  
		  
			   if @@Error <> 0  
				 BEGIN    
				  ROLLBACK    
				  Select -1 as returnValue--Error while inserting to events table    
				   --This will be used to trace issue on the part of query caused the issue  
				  return  
				 END    
			   else  
				Select @EventId = Scope_Identity()    
		 END  

		if (@ResultId > 0 and @EventId > 0)
			BEGIN		
				INSERT INTO EventDetailNewResult(EventId,ResultId,DatamartId) VALUES (@EventId,@ResultId,@DatamartId)
			
				If @@Error <> 0
					BEGIN
						Select -2 as returnValue
						return
					END	
				Else
					COMMIT						
			END
Select @EventId as returnValue  
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewGroupResult]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateNewGroupResult]   
(  
@EventSourceId int,  
@NetworkGroupId int  
)  
AS BEGIN  
  
BEGIN TRANSACTION      
 Declare @EventId int  
 Set @EventId = 0  
  
 If exists (Select 1 from EventDetailNewGroupResult where NetworkQueryGroupId = @NetworkGroupId)  
 BEGIN  
  Select eventId as returnValue from EventDetailNewGroupResult where NetworkQueryGroupId = @NetworkGroupId  
  return;  
 END  
  
  if (@NetworkGroupId > 0)    
   BEGIN    
        
   INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES      
     (@EventSourceId,4,GetDate())    
      
      if @@Error <> 0    
     BEGIN      
      ROLLBACK      
      Select -1 as returnValue--Error while inserting to events table      
       --This will be used to trace issue on the part of query caused the issue    
      return    
     END      
      else    
    Select @EventId = Scope_Identity()      
   END    
  
  if (@NetworkGroupId > 0 and @EventId > 0)  
   BEGIN    
    INSERT INTO EventDetailNewGroupResult(EventId,NetworkQueryGroupId) VALUES (@EventId, @NetworkGroupId)  
     
    If @@Error <> 0  
     BEGIN  
      Select -2 as returnValue  
      return  
     END   
    Else  
     COMMIT        
   END  
Select @EventId as returnValue    
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateUserUpdatedEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[uspCreateUserUpdatedEvent] 
(
@EventSourceId int,
@EventTypeId int,
@UserID int
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@UserID > 0)
	BEGIN
		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,@EventTypeId,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace issue on the part of query caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailUserUpdated (EventId, UserID)
			VALUES(@EventId,@UserID)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace issue on which part of query caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspCreateUser]   
 @Username VARCHAR(50),  
 @Password VARCHAR(100),  
 @RoleTypeId INT,  
 @OrganizationId INT,  
 @Email nvarchar(150),   
 @Title VARCHAR(100),  
 @FirstName varchar(100),  
 @LastName varchar(100),  
 @AddedBy INT,  
 @IsNewOrModifiedPassword BIT,
 @SetEncryptionAtDatabase BIT, 
 @Return_UserId int OUTPUT  
AS  
  
IF Exists (Select 1 from Users where UserName = @Username and isdeleted = 0)  
BEGIN  
Set @Return_UserId = -103  
RETURN   
END  
  
Declare @EncryptedPwd varchar(100)   
SET @EncryptedPwd = @Password

if @IsNewOrModifiedPassword = 1 and @SetEncryptionAtDatabase = 1
BEGIN
	--Set @EncryptedPwd =  dbo.udf_encrypt_password (@Password)  
	exec master..xp_sha1 @password, @EncryptedPwd OUTPUT  
END
  
IF @@ERROR<>0 BEGIN  
Set @Return_UserId = -101  
RETURN   
END  
  
INSERT Users  
(  
 Username,  
 Password,  
 RoleTypeId,  
 OrganizationId,  
 Email,  
 Title,  
 FirstName,  
 LastName,  
 PasswordEncryptionLength  
)  
VALUES  
(  
 @Username,  
 @EncryptedPwd,  
 @RoleTypeId,  
 @OrganizationId,  
 @Email,  
 @Title,  
 @FirstName,  
 @LastName,  
 14  
)  
  
IF @@ERROR<>0   
BEGIN  
Set @Return_UserId = -101  
RETURN   
END  
  
SELECT @Return_UserId = SCOPE_IDENTITY()  
  
---Add initial password set date------  
  
if @Return_UserId > 0   
 INSERT INTO UserPasswordTrace (UserId,Password,DateAdded,AddedBy) Values  
 (@Return_UserId,@EncryptedPwd,GetDate(),@AddedBy)  
  
IF @@ERROR<>0   
BEGIN  
Set @Return_UserId = -101  
RETURN   
END  
  
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[SetUserPermission]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetUserPermission]
(
	@UserId int,
	@QueryTypeId int
)
AS BEGIN
	INSERT INTO PermissionsusersQueryTypes(UserId, QueryTypeId) Values (@UserId,@QueryTypeId)
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDatamartForQueryType]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetUserDatamartForQueryType] --7,1
(
@QueryTypeId int,
@UserId int
)
AS BEGIN

Select distinct dm.*,dmt.DatamartType from Datamarts dm
Inner Join PermissionsUsersDatamarts pud
on dm.DatamartId = pud.DatamartId
INNER JOIN PermissionsQueryTypesDatamarts pqtd
on pqtd.DatamartId = pud.DatamartId
AND pqtd.QueryTypeId = @QueryTypeId
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DataMartTypeId
Where pud.UserId = @UserId

END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateSubmitterReminderEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateSubmitterReminderEvent]
(  
@EventSourceId int,  
@EventTypeId int,  
@QueryId int  
)  
AS BEGIN  
Declare @EventId int   
BEGIN TRANSACTION    
  
if EXISTS (SELECT 1 FROM EventDetailSubmitterReminder Where QueryId = @QueryId )
	BEGIN
		Select @EventId = EventId FROM EventDetailSubmitterReminder Where QueryId = @QueryId
		If @EventId > 0
		Update Events Set EventDateTime = GetDate() Where EventId = @EventId
		if @@Error <> 0
			BEGIN
				ROLLBACK
				SELECt -3 as returnValue
				return
			END
		ELSE 
			BEGIN
				COMMIT
				Select @EventId as returnValue
				return 
			END
	END
ELSE
 BEGIN    
  INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES    
   (@EventSourceId,@EventTypeId,GetDate())  
  
   if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -1 as returnValue--Error while inserting to events table    
       --This will be used to trace issue on the part of query caused the issue  
      return  
     END    
   else  
    Select @EventId = Scope_Identity()    
 END  
  
if (@EventId > 0)  
 BEGIN  
  INSERT INTO EventDetailSubmitterReminder (EventId, QueryId)
   VALUES(@EventId,@QueryId) 
  
  if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -2 as returnValue--Error while inserting to status change table.   
       --This will be used to trace issue on which part of query caused the issue  
      Return  
     END    
  else  
   BEGIN  
    COMMIT  
   END     
 END  
  
  
Select @EventId as returnValue  
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateResult]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateResult] 
(
@QueryId int,
@ResultId int
)
AS BEGIN
Declare @EventId int
Set @EventId = 0

	if (@QueryId > 0 and @ResultId > 0)
	BEGIN		
		Select @EventId = EventId From EventDetailNewQuery Where QueryId = @QueryId
		If @EventId > 0 
			BEGIN
				INSERT INTO EventDetailNewResult(EventId,ResultId) VALUES (@EventId,@ResultId)
			
				If @@Error <> 0
					Set @EventId = -1			
			END
	END
Select @EventId

END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateResponse]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspCreateResponse]
	@QueryId int,
	@DataMartId int,
	@ResponseXml ntext,
	@UserId int,
	@Return_ResponseId int OUTPUT
AS
IF @UserId = 0
	BEGIN 
		If Exists (Select 1 from Responses Where QueryId = @QueryId and DataMartId = @DataMartId)
			BEGIN
				Update Responses Set ResponseXml = @ResponseXml Where QueryId = @QueryId and DataMartId = @DataMartId 
			END
		ELSE
			BEGIN
				INSERT Responses
				(QueryId,DataMartId,ResponseXml)
				VALUES
				(@QueryId,@DataMartId,@ResponseXml)
			END 
	END
ELSE
	BEGIN
		If Exists (Select 1 from Responses Where QueryId = @QueryId and DataMartId = @DataMartId)
			BEGIN
				Update Responses Set ResponseXml = @ResponseXml, UserId = @UserId Where QueryId = @QueryId and DataMartId = @DataMartId 
			END
		ELSE
			BEGIN
				INSERT Responses
				(QueryId,DataMartId,ResponseXml,UserId)
				VALUES
				(@QueryId,@DataMartId,@ResponseXml,@UserId)
			END
END

IF @@ERROR<>0 RETURN -101

SELECT @Return_ResponseId = ResponseId from Responses where QueryId = @QueryId and DataMartId = @DataMartId

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[uspCreateReminderEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateReminderEvent] --2,3,137,4
(  
@EventSourceId int,  
@EventTypeId int,  
@QueryId int,  
@DatamartId int,
@UserId int
)  
AS BEGIN  
Declare @EventId int   
BEGIN TRANSACTION    
  
if EXISTS (SELECT 1 FROM EventDetailQueryReminder Where QueryId = @QueryId and DatamartId = @DatamartId and UserId=@UserId)
	BEGIN
		Select @EventId = EventId FROM EventDetailQueryReminder Where QueryId = @QueryId and DatamartId = @DatamartId and UserId=@UserId
		If @EventId > 0
		Update Events Set EventDateTime = GetDate() Where EventId = @EventId
		if @@Error <> 0
			BEGIN
				ROLLBACK
				SELECt -3 as returnValue
				return
			END
		ELSE 
			BEGIN
				COMMIT
				Select @EventId as returnValue
				return 
			END
	END
ELSE
 BEGIN    
  INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES    
   (@EventSourceId,@EventTypeId,GetDate())  
  
   if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -1 as returnValue--Error while inserting to events table    
       --This will be used to trace issue on the part of query caused the issue  
      return  
     END    
   else  
    Select @EventId = Scope_Identity()    
 END  
  
if (@EventId > 0)  
 BEGIN  
  INSERT INTO EventDetailQueryReminder (EventId, QueryId, DatamartId,UserId)  
   VALUES(@EventId,@QueryId, @DatamartId,@UserId)  
  
  if @@Error <> 0  
     BEGIN    
      ROLLBACK    
      Select -2 as returnValue--Error while inserting to status change table.   
       --This will be used to trace issue on which part of query caused the issue  
      Return  
     END    
  else  
   BEGIN  
    COMMIT  
   END     
 END  
  
  
Select @EventId as returnValue  
END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewEventForQueryAdmin]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateNewEventForQueryAdmin]
(
@EventSourceId int,
@EventTypeId int,
@QueryId int,
@OrganizationId int
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@QueryId > 0)
	BEGIN
		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,@EventTypeId,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace issue on the part of query caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailNewQueryForQueryAdmin (EventId, QueryId, OrganizationId)
			VALUES(@EventId,@QueryId, @OrganizationId)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace issue on which part of query caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
--return @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteQueryDataMarts]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspDeleteQueryDataMarts] --1,31
(
@QueryId int,
@DataMartIds varchar(1000)
)
AS BEGIN
If @QueryId > 0 and @DataMartIds <> ''
	BEGIN
		  Update QueriesDataMarts Set QueryStatusTypeId = 6 Where QueryId = @QueryId and DataMartId in  
   (Select Value From GetValueTableOfDelimittedString (@DataMartIds,','))    
   
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteQuery]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspDeleteQuery] --138
(
	@QueryId int
)
AS BEGIN

Delete from Responses Where QueryId = @QueryId
Delete From EventDetailNewQuery where QueryId = @QueryId
Delete from EventDetailQueryStatusChange where QueryId = @QueryId
Delete From QueriesDatamarts Where QueryId = @QueryId
Delete from Queries Where QueryId = @QueryId
END

GRANT EXEC ON uspDeleteQuery TO PUBLIC
GO
/****** Object:  StoredProcedure [dbo].[uspCreateQuery]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspCreateQuery]  
 @CreatedByUserId int,  
 @QueryTypeId int,  
 @QueryText ntext,  
 @DataMartIdList varchar(1000)=NULL,  
 @Name nvarchar(50),  
 @QueryDescription text,  
 @RequestorEmail nvarchar(255),  
 @IsAdminQuery bit,  
 @ValidateQueryNameUniquesnessByPerson bit = 0,
 @QueryStatusTypeId int=NULL,
 @QueryXML ntext=NULL,
 @Priority int = 0,
 @ActivityOfQuery nvarchar(255) = NULL,
 @ActivityDescription nvarchar(255) = NULL,
 @ActivityPriority nvarchar(255) = NULL,
 @ActivityDueDate datetime = NULL,
 @IRBApprovalNo nvarchar(100) = ''
AS  
BEGIN

	IF(@QueryStatusTypeId IS NULL OR @QueryStatusTypeId = 0)
		SET @QueryStatusTypeId = 1
		
	Declare @Return_QueryId int
	Set @Return_QueryId = 0

	    if (@ValidateQueryNameUniquesnessByPerson = 1)
		BEGIN
			If 0 < (Select Count(queryId) from Queries Where IsAdminQuery = 0 and Name = @Name and isDeleted = 0 and createdByUserId = @CreatedByUserId)
			BEGIN
			Set @Return_QueryId = -101
			GOTO FinalBlock		
			END
		END	  

		INSERT Queries  
		(  
		 CreatedByUserId,  
		 QueryTypeId,  
		 QueryText,  
		 [Name],  
		 QueryDescription,  
		 RequestorEmail,  
		 IsAdminQuery,
		 Priority,
		 ActivityOfQuery,
		 ActivityDescription,
		 ActivityPriority,
		 ActivityDueDate,
		 IRBApprovalNo
		)  
		VALUES  
		(  
		 @CreatedByUserId,  
		 @QueryTypeId,  
		 @QueryText,  
		 @Name,  
		 @QueryDescription,  
		 @RequestorEmail,  
		 @IsAdminQuery,
		 @Priority,
		 @ActivityOfQuery,
		 @ActivityDescription,
		 @ActivityPriority,
		 @ActivityDueDate,
		 @IRBApprovalNo  
		)  
	  
		IF @@ERROR<>0 
			BEGIN
			Set @Return_QueryId = -102
			GOTO FinalBlock	
			END
	  

		Set @Return_QueryId = SCOPE_IDENTITY()  
		  
		IF @DataMartIdList IS NOT NULL  
			BEGIN  
				 DECLARE @sql VARCHAR(2000)  
				 SELECT @sql = 'INSERT QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId, RequestTime) SELECT ' + STR(@Return_QueryId) + ',DataMartId,' + STR(@QueryStatusTypeId) + ', GetDate() FROM DataMarts WHERE DataMartId IN (' + @DataMartIdList + ')'  
				 EXEC (@sql)  

				 If @@Error <> 0
					BEGIN
						Set @Return_QueryId = -103
						GOTO FinalBlock		
					END 
			END
		
		IF(@QueryTypeId != 8 AND @QueryTypeId != 9 AND @QueryTypeId != 13)
			INSERT INTO Query VALUES(@Return_QueryId, @QueryXML, NULL)

	FinalBlock:
	Select @Return_QueryId
	RETURN 

END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteExpiredQueries]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteExpiredQueries] --21
(
@QueryValidityPeriod int
)
AS BEGIN

Update Queries Set IsDeleted = 1 where 
isnull(IsDeleted, 0) = 0 and DateDiff(m,CreatedAt,GetDate())  > @QueryValidityPeriod

-- Delete the CachedResponses for Queries that are older than the validity period

Update QueriesCachedResults Set AggregatedResultsXml = '' Where QueryId in 
( Select QueryId from Queries where isDeleted = 1 and DateDiff(m,CreatedAt,GetDate())  > @QueryValidityPeriod)

END
GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewEvent]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCreateNewEvent] 
(
@EventSourceId int,
@EventTypeId int,
@QueryId int,
@DatamartId int
)
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@QueryId > 0)
	BEGIN
		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,@EventTypeId,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace issue on the part of query caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailNewQuery (EventId, QueryId, DatamartId)
			VALUES(@EventId,@QueryId, @DatamartId)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace issue on which part of query caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
--return @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[uspApproveResponse]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspApproveResponse] --26,31
(
@QueryId int,
@DataMartId int
)
AS BEGIN
	Declare @responseId int
	Set @responseId = 0
	
	if Exists (Select 1 from QueriesDataMarts Where QueryId = @QueryId and DataMartId = @DataMartId and QueryStatusTypeId = 3)
	BEGIN
	select -1 --Denotes already approved 
	return
	END

	Update QueriesDataMarts Set QueryStatusTypeId = 3 where QueryId = @QueryId and DataMartId = @DataMartId
	If (@@Error = 0)
		BEGIN	
		Select @responseId = ResponseId from Responses where QueryId = @QueryId and DataMartId = @DataMartId
		END
	select @responseId
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddQueryDocumentMap]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAddQueryDocumentMap] --8, '9,10'
(
	@QueryId int,
	@ConcatenatedDocIds varchar(1000)	
)
AS BEGIN
	Declare @returnValue int
	INSERT INTO QueriesDocuments (QueryId, DocId)
	Select @QueryId , Value from GetValueTableOfDelimittedString(@ConcatenatedDocIds, ',')
	Select @@Error
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAggregatedResultsByQueryId]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAggregatedResultsByQueryId] --59  
(  
@QueryId int  
)  
AS BEGIN  

Select r.ResponseXml as ResponseXml from 
QueriesDataMarts qd
inner join Responses r
on qd.DataMartId = r.DataMartId
and qd.QueryId = r.QueryId
Where qd.QueryId = @QueryId and qd.isResultsGrouped = 0 and QueryStatusTypeId = 3 
   
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllOrganizationUsersWithAdminRights]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllOrganizationUsersWithAdminRights]  --32,'0', 1
(@OrganizationId int,
 @AdminUserIds varchar(1000),    
 @ExcludeIdsPassed bit  
)  
AS BEGIN  
 If (@ExcludeIdsPassed = 0)  
  BEGIN  
  -- Get only user details for Ids passed in  
   Select u.*, o.OrganizationName from users u 
	INNER JOIN [GetUserWithRights] (@OrganizationId, '48,49') as rTable --'NetworkAdmin specific rights'
	on rTable.UserId = u.UserId
	INNER JOIN Organizations o
	on u.OrganizationId	= o.OrganizationId
	And u.OrganizationId = @OrganizationId
	and u.UserId in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,','))    
  END  
 ELSE  
  BEGIN  
  -- Get User detials for anybody other than passed in Ids  
 Select u.*, o.OrganizationName from users u 
	INNER JOIN [GetUserWithRights] (@OrganizationId, '48,49') as rTable --'NetworkAdmin specific rights'
	on rTable.UserId = u.UserId
	INNER JOIN Organizations o	
	on u.OrganizationId	= o.OrganizationId
	And u.OrganizationId = @OrganizationId
	and u.UserId not in (Select Value from GetValueTableOfDelimittedString(@AdminUserIds,',')) 
    
  END  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllNotificationDataforDelivery]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetAllNotificationDataforDelivery] --2588
(
	@EventId int
)
AS BEGIN

Declare @DatamartId int
Declare @QueryId int

--Select Query Id
Select @QueryId = coalesce(nq.QueryId,qsc.QueryId,res.QueryId,rem.QueryId,srem.QueryId,vr.QueryID, fqa.QueryId) 
 From Events e
 Left Join EventDetailNewQuery nq
 on e.EventId = nq.EventId
 Left join EventDetailQueryStatusChange qsc
 on e.EventId = qsc.EventId
 Left join EventDetailNewResult nr
 on e.EventId = nr.EventId
 Left join Responses res
 on nr.resultId = res.ResponseId
 Left join EventDetailQueryReminder rem
 on rem.EventId = e.EventId
 Left join EventDetailSubmitterReminder srem
 on srem.EventId = e.EventId
 Left join EventDetailViewedResult vr
 on e.EventID=vr.EventId
 Left join EventDetailEntityAdded en
 on e.EventID=en.EventId
 Left join EventDetailQueryTypeDatamartAssociation qdm
 on e.EventID=qdm.EventId
 Left join EventDetailNewQueryForQueryAdmin fqa
 on e.EventId = fqa.EventId
 
Where e.EventId = @EventID

--Select DatamartId 

Select @DatamartId = coalesce(nq.DatamartId,qsc.DatamartId,res.DatamartId,rem.DatamartId,en.DatamartID,qdm.DatamartID,-1) --Since EventDetailSubmitterReminder is associated with multiple datamarts select -1 here.
 From Events e
 Left Join EventDetailNewQuery nq
 on e.EventId = nq.EventId
 Left join EventDetailQueryStatusChange qsc
 on e.EventId = qsc.EventId
 Left join EventDetailNewResult nr
 on e.EventId = nr.EventId
 Left join Responses res
 on nr.resultId = res.ResponseId
 Left join EventDetailQueryReminder rem
 on rem.EventId = e.EventId 
 Left join EventDetailSubmitterReminder srem
 on srem.EventId = e.EventId
 Left join EventDetailViewedResult vr
 on e.EventID=vr.EventId
 Left join EventDetailEntityAdded en
 on e.EventID=en.EventId
 Left join EventDetailQueryTypeDatamartAssociation qdm
 on e.EventID=qdm.EventId
Where e.EventId = @EventID

--Select Event
Select e.* from Events e Where e.EventId = @EventId

--Select Query
Select q.*, u.UserName as CreatedByUserName, r.QueryXml, r.Comment from Queries q
LEFT JOIN Users u ON u.UserId = q.CreatedByUserId
LEFT OUTER JOIN Query r ON q.QueryId = r.QueryId
Where q.QueryId = @QueryId

--Select Datamart details
Select dm.DatamartId,dm.DatamartName,o.OrganizationName,o.OrganizationAcronym
From Datamarts dm 
LEFT JOIN Organizations o
on isnull(dm.IsDeleted,0) = 0 and dm.OrganizationId = o.OrganizationId 
where dm.DatamartId = @DatamartId

--Select New queryDetails
Select e. *, 'Submitted' as QueryStatusType, '' as StatusChangedBy From Events e 
 Inner JOIN EventDetailNewQuery ednq
 On e.EventId = ednq.EventId and ednq.QueryId = @QueryId and ednq.DatamartId = @DatamartId
union
 Select e. *, 'Pending Query Administrator Approval' as QueryStatusType, '' as StatusChangedBy From Events e 
 Inner JOIN EventDetailNewQueryForQueryAdmin ednq
 On e.EventId = ednq.EventId and ednq.QueryId = @QueryId
union
--Select Status Change event details
Select e. *, qst.QueryStatusType,u.UserName From Events e 
 Inner JOIN EventDetailQueryStatusChange edqsc
 On e.EventId = edqsc.EventId and edqsc.QueryId = @QueryId and edqsc.DatamartId = @DatamartId
 Inner join QueryStatusTypes qst
 on qst.QueryStatusTypeId = edqsc.NewQueryStatusTypeId
 LEFT JOIN Users u
 on u.UserId = edqsc.UserId
Left Join QueriesDataMarts qdm on qdm.QueryId=edqsc.QueryId and qdm.DataMartId=edqsc.DatamartId
union
--Select Status Change event details
Select e. *, qst.QueryStatusType,u.UserName From Events e 
 Inner JOIN EventDetailQueryStatusChange edqsc
 On e.EventId = edqsc.EventId and edqsc.QueryId = @QueryId and edqsc.DatamartId is null
 Inner join QueryStatusTypes qst
 on qst.QueryStatusTypeId = edqsc.NewQueryStatusTypeId
 LEFT JOIN Users u
 on u.UserId = edqsc.UserId
Left Join QueriesDataMarts qdm on qdm.QueryId=edqsc.QueryId and qdm.DataMartId=edqsc.DatamartId
order by e.EventId desc

Select ednr.EventId,res.ResponseId,u.UserName  from
EventDetailNewResult ednr
inner join responses res
on res.ResponseId = ednr.ResultId
Left JOIN Users u
on u.UserId = res.UserId
Where ednr.EventId = @EventId

--Get QueryTypeAdded/Removed event details.
Select edqdm.QueryTypeID  from
EventDetailQueryTypeDatamartAssociation edqdm
Where edqdm.EventId = @EventId

--Get User/Group/Org Added/Removed event details.
Select eden.EntityTypeID,eden.UserID,eden.OrganizationID,eden.GroupID
		,u.UserName,grp.GroupName,org.OrganizationName,org.OrganizationAcronym  from
EventDetailEntityAdded eden
Left join Users u on u.UserID=eden.UserID
Left join Groups grp on grp.GroupID=eden.GroupID
Left join Organizations org on org.OrganizationId=eden.OrganizationID
Where eden.EventId = @EventId

Select edngr.EventId,edngr.NetworkQueryGroupId,nqg.Name, u.UserName from
EventDetailNewGroupResult edngr
inner join NetworkQueriesGroups nqg
on nqg.NetworkQueryGroupId = edngr.NetworkQueryGroupId
Inner join Users u
on u.UserId = nqg.ApprovedBy
Where edngr.EventId = @EventId

Select qdm.RejectReason 
FROM QueriesDataMarts qdm
WHERE qdm.QueryId = @QueryId
	AND qdm.DataMartId = @DatamartId
	
--Select Event Message
Select em.Message from EventMessage em Where em.EventId = @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllSummaryNotificationsForDelivery]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetAllSummaryNotificationsForDelivery]
@UserId int
,@Frequency varchar(1000)
AS
/*
Get All Summary Notifications Pending Delivery Based on Frequency.
For Monthly the @FrequncyID would be 9,etc..
*/
Declare 
	@FrequencyDescription varchar(255)
	,@FrequencyDays int
	,@FrequencyId int

if(LOWER(@Frequency)='everyndays') select @Frequency='Every N days'

Select @FrequencyId=FrequencyID From NotificationFrequency Where lower([Description])=lower(@Frequency)

/*
LOGIC OF GETTING NOTIFICATIONS QUALIFIED FOR DELIVERY.
#1#: Query Reminder(3)/Query Submitter Reminder(5) Notifications: 
	 HubBackground Service Creates these reminder notifications based on configured frequency 
	 and is responsible for processing these on daily basis. 
	 Hence, check for elapsed days from generation time NOT NECESSARY.
#2#: Notifications subscribed FOR DAILY,WEEKLY,MONTHLY delivery: 
	 HubBackground Service Is responsible for processing these on daily/weekly/monthly basis. 
	 Hence, check for elapsed days from generation time NOT NECESSARY.
#3#: Notifications subscribed FOR delivery Every N Days: 
	 HubBackground Service Is responsible for processing these on daily basis. 
	 Hence, check for elapsed days from generation time ABSOLUTELY NECESSARY.
*/

if(isnull(@FrequencyId,0)>0)
Begin
SELECT * FROM
vw_SummaryNotification
WHERE
UserId=@UserId
AND
(
(FrequencyId=@FrequencyId )--AND DateDiff(dd,GeneratedTime,GetDate())> FrequencyDays) 
OR
(FrequencyId=@FrequencyId AND  @Frequency='Every N days' AND DateDiff(dd,GeneratedTime,GetDate())>= FrequencyDays) 
OR
((EventTypeId=5 and lower(@Frequency)='daily'))
OR
((EventTypeId=3 and lower(@Frequency)='daily'))
)
ORDER BY
EventName
,GeneratedTime
End
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllResponsesByQueryId]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllResponsesByQueryId]
	@QueryId int
AS

SELECT	r.*
FROM	Responses r
WHERE	r.QueryId=@QueryId
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForUserOrganizationAndQueryTypePeriod]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDatamartForUserOrganizationAndQueryTypePeriod] --32, 8,''  
(  
@OrganizationId int,
@QueryTypeId int,
@ConcatenatedPeriod varchar(1000)
)  
AS BEGIN 

if (@QueryTypeId <> 8)
		BEGIN   
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner join DatamartTypes dmt  
		on dmt.DatamartTypeId = dm.DatamartTypeId 
		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  

		Inner Join (Select distinct DatamartId from DatamartAvailabilityPeriods   
		where isActive = 1 and QueryTypeId = @QueryTypeId   
		and 
		(
			(@ConcatenatedPeriod <> '' and Period in (Select value from GetValueTableOfDelimittedString (@ConcatenatedPeriod, ','))) or
			(@ConcatenatedPeriod = '' and Period <> '')
		)  ) dap
		on dap.DataMartId = pqtd.DatamartId   
		Where dm.OrganizationId = @OrganizationId and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		END
	ELSE
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner join DatamartTypes dmt  
		on dmt.DatamartTypeId = dm.DatamartTypeId 
		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
		Where dm.OrganizationId = @OrganizationId and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForQueryTypePeriod]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDatamartForQueryTypePeriod] --7,16,'2007,2008'
(
@QueryTypeId int,
@UserId int,
@SelectedPeriod varchar(1000)
)
AS BEGIN

--------------
 Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @UserId
------------

Select distinct dm.*,dmt.DatamartType from Datamarts dm
INNER JOIN (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @UserId  
						 UNION  
						 SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId  
						 UNION  
						 SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  ) dmList
on dm.DatamartId = dmList.DatamartId
INNER JOIN PermissionsQueryTypesDatamarts pqtd
on pqtd.DatamartId = dm.DatamartId
AND pqtd.QueryTypeId = @QueryTypeId
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DataMartTypeId
Left Join Organizations o
on o.OrganizationId = dm.OrganizationId
Inner Join DatamartAvailabilityPeriods dap
on dap.isActive = 1 and dap.QueryTypeId = @QueryTypeId
and dap.Period in (Select value from GetValueTableOfDelimittedString (@SelectedPeriod, ','))
and dap.DataMartId = dm.DataMartId
Where isnull(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetCachedResults]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetCachedResults] --333
(
@QueryId int
)
AS BEGIN

Select AggregatedResultsXml from QueriesCachedResults Where queryId = @QueryId

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartsForResultsViewed]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetDatamartsForResultsViewed] --38
@QueryID int
AS
SELECT   
 dm.* , dmt.DataMartType  
FROM   
 QueriesDataMarts qdm    
 INNER JOIN Datamarts dm  
  ON dm.DatamartId = qdm.DatamartId  
  AND ISNULL(dm.IsDeleted,0) = 0  
 Inner Join DataMartTypes dmt
  on dmt.DatamartTypeId = dm.DataMartTypeId
WHERE   
 qdm.QueryId=@QueryId 
 and qdm.QueryStatusTypeId not in (6,7)
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsForQueryTypePeriod]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartsForQueryTypePeriod] --'DatamartName', 1, 16,8,''
(  
@SortColumn varchar(20),  
@IsDescending bit,  
@LoggedInUser int,
@QueryTypeId int,
@ConcatenatedPeriod varchar(1000)
)  
AS BEGIN  
  
 Declare @OrgId int        
 Set @OrgId = 0        
 Select @OrgId = OrganizationId from users where UserId = @LoggedInUser  
 
if (@QueryTypeId <> 8 AND @QueryTypeId <> 13)
		BEGIN  
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner Join DataMartTypes dmt  
		on dmt.DataMartTypeId = dm.DataMartTypeId  
		left join Organizations o  
		on o.OrganizationId = dm.OrganizationId 

		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  

		Inner Join (Select distinct DatamartId from DatamartAvailabilityPeriods   
		where isActive = 1 and QueryTypeId = @QueryTypeId   
		and 
		(
			(@ConcatenatedPeriod <> '' and Period in (Select value from GetValueTableOfDelimittedString (@ConcatenatedPeriod, ','))) or
			(@ConcatenatedPeriod = '' and Period <> '')
		)  ) dap
		on dap.DataMartId = pqtd.DatamartId 

		Where dm.DatamartId in 
			   (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @LoggedInUser    
			   UNION    
			   SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId    
			   UNION    
			   SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 
					Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  
				)  
		AND ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		Order by CASE @IsDescending                                        
			WHEN 1 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END DESC,  
		  CASE @IsDescending                                        
			WHEN 0 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END 
		END  
	ELSE
		BEGIN
			Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner Join DataMartTypes dmt  
		on dmt.DataMartTypeId = dm.DataMartTypeId  
		left join Organizations o  
		on o.OrganizationId = dm.OrganizationId 

		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
		Where dm.DatamartId in 
			   (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @LoggedInUser    
			   UNION    
			   SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId    
			   UNION    
			   SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 
					Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  
				)  
		AND ISNULL(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		Order by CASE @IsDescending                                        
			WHEN 1 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END DESC,  
		  CASE @IsDescending                                        
			WHEN 0 THEN                 
			Case  @SortColumn                               
			 When 'DatamartName' then dm.DataMartName                             
			 When 'Type' then dmt.DataMartType                               
			 Else dm.DataMartName                               
			END                
			END 
		END	    
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartPeriodsByQueryType]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bruce Swan
-- Create date: 7/21/2011
-- Description:	Returns query periods by DataMart
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDataMartPeriodsByQueryType] 
	@QueryCategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF (@QueryCategoryId = 1)
	BEGIN
		SELECT [DataMartName] as [DataMart],  [Prev: Enrollment] as [Enrollment], [Prev: HCPCS Procedures] as [HCPCS Procedures], [Prev: ICD-9 Diagnoses (3 digit codes)] as[ICD-9 Diagnoses (3 digit)], [Prev: ICD-9 Diagnoses (4 digit codes)] as [ICD-9 Diagnoses (4 digit)], [Prev: ICD-9 Diagnoses (5 digit codes)] as [ICD-9 Diagnoses (5 digit)], [Prev: ICD-9 Procedures (3 digit codes)] as [ICD-9 Procedures (3 digit)], [Prev: ICD-9 Procedure (4 digit codes)] as [ICD-9 Procedure (4 digit)], [Prev: Pharmacy Dispensings by Drug Class] as [Drug Class], [Prev: Pharmacy Dispensings by Generic Name] as [Generic Name]
		FROM	(Select DataMartName, QueryType, (Min(Period) + ' - ' +  MAX(Period))as Period
		From DataMartAvailabilityPeriods 
		inner join DataMarts on DataMartAvailabilityPeriods.DataMartId = DataMarts.DataMartId 
		inner join QueryTypes on QueryTypes.QueryTypeId = DataMartAvailabilityPeriods.QueryTypeId 
		inner join QueryCategory on QueryCategory.QueryCategoryID = QueryTypes.QueryCategoryId
		inner join Organizations on DataMarts.OrganizationId = Organizations.OrganizationId
		Where QueryTypes.QueryCategoryId = @QueryCategoryId and DataMarts.isDeleted = 0 and Organizations.IsDeleted = 0
		Group By DataMarts.DataMartName, QueryType) as QueryPeriods 
		PIVOT (	MAX([Period])  FOR QueryType IN ([Prev: Enrollment], [Prev: HCPCS Procedures], [Prev: ICD-9 Diagnoses (3 digit codes)], [Prev: ICD-9 Diagnoses (4 digit codes)], [Prev: ICD-9 Diagnoses (5 digit codes)], [Prev: ICD-9 Procedure (4 digit codes)], [Prev: ICD-9 Procedures (3 digit codes)], [Prev: Pharmacy Dispensings by Drug Class], [Prev: Pharmacy Dispensings by Generic Name] ))  AS P
		ORDER BY DataMartName
	END
	ELSE
	BEGIN
		SELECT [DataMartName] as [DataMart],  [Inci: Enrollment] as [Enrollment], [Inci: HCPCS Procedures] as [HCPCS Procedures], [Inci: ICD-9 Diagnoses (3 digit codes)] as[ICD-9 Diagnoses (3 digit)], [Inci: ICD-9 Diagnoses (4 digit codes)] as [ICD-9 Diagnoses (4 digit)], [Inci: ICD-9 Diagnoses (5 digit codes)] as [ICD-9 Diagnoses (5 digit)], [Inci: ICD-9 Procedures (3 digit codes)] as [ICD-9 Procedures (3 digit)], [Inci: ICD-9 Procedure (4 digit codes)] as [ICD-9 Procedure (4 digit)], [Inci: Pharmacy Dispensings by Drug Class] as [Drug Class], [Inci: Pharmacy Dispensings by Generic Name] as [Generic Name]
		FROM	(Select DataMartName, QueryType, (Min(Period) + ' - ' +  MAX(Period))as Period
		From DataMartAvailabilityPeriods 
		inner join DataMarts on DataMartAvailabilityPeriods.DataMartId = DataMarts.DataMartId 
		inner join QueryTypes on QueryTypes.QueryTypeId = DataMartAvailabilityPeriods.QueryTypeId 
		inner join QueryCategory on QueryCategory.QueryCategoryID = QueryTypes.QueryCategoryId
		inner join Organizations on DataMarts.OrganizationId = Organizations.OrganizationId
		Where QueryTypes.QueryCategoryId = @QueryCategoryId  and DataMarts.isDeleted = 0 and Organizations.IsDeleted = 0
		Group By DataMarts.DataMartName, QueryType) as QueryPeriods 
		PIVOT (	MAX([Period])  FOR QueryType IN ([Inci: Enrollment], [Inci: HCPCS Procedures], [Inci: ICD-9 Diagnoses (3 digit codes)], [Inci: ICD-9 Diagnoses (4 digit codes)], [Inci: ICD-9 Diagnoses (5 digit codes)], [Inci: ICD-9 Procedure (4 digit codes)], [Inci: ICD-9 Procedures (3 digit codes)], [Inci: Pharmacy Dispensings by Drug Class], [Inci: Pharmacy Dispensings by Generic Name] ))  AS P
		ORDER BY DataMartName
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDatamartForUserGroupAndQueryTypePeriod]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDatamartForUserGroupAndQueryTypePeriod] --32,8,''
(  
@OrganizationId int,
@QueryTypeId int,
@ConcatenatedPeriod varchar(1000)
)  
AS BEGIN  
  
Declare @GroupOrganizations table (OrganizationId int)  
Insert into @GroupOrganizations values (@OrganizationId)   
  
Declare @Groups table (GroupId int)  
Insert into @Groups Select GroupId from OrganizationsGroups Where OrganizationId = @OrganizationId  
  
Insert into @GroupOrganizations Select OrganizationId from OrganizationsGroups og  
          inner join @Groups g  
          on g.GroupId = og.GroupId  
   Where og.OrganizationId <> @OrganizationId  

if (@QueryTypeId <> 8)
BEGIN
			Select dm.DatamartId  
			  , dm.DataMartName  
			  , dm.Url  
			  , dm.RequiresApproval  
			  , dm.DataMartTypeId  
			  , dm.OrganizationId    
			  , dm.AvailablePeriod  
			  , dm.ContactEmail  
			  , dm.ContactFirstName  
			  , dm.ContactLastName  
			  , dm.ContactPhone  
			  , dm.SpecialRequirements  
			  , dm.UsageRestrictions  
			  , dmt.DataMartType    
			  , dm.HealthPlanDescription   
			FROM DataMarts dm  
			inner join DatamartTypes dmt  
			on dmt.DatamartTypeId = dm.DatamartTypeId   
			INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
					(
						(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
						(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
					)) pqtd
			on pqtd.DatamartId = dm.DatamartId  

			Inner Join (Select distinct DatamartId from DatamartAvailabilityPeriods   
			where isActive = 1 and QueryTypeId = @QueryTypeId   
			and 
			(
				(@ConcatenatedPeriod <> '' and Period in (Select value from GetValueTableOfDelimittedString (@ConcatenatedPeriod, ','))) or
				(@ConcatenatedPeriod = '' and Period <> '')
			)  ) dap
			on dap.DataMartId = pqtd.DatamartId 
			Where dm.OrganizationId in (Select distinct OrganizationId from @GroupOrganizations)   
			and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		END
	ELSE
		BEGIN
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMarts dm  
		inner join DatamartTypes dmt  
		on dmt.DatamartTypeId = dm.DatamartTypeId   
		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
 
		Where dm.OrganizationId in (Select distinct OrganizationId from @GroupOrganizations)   
		and isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetDataMartsIncludedInQuery]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetDataMartsIncludedInQuery]
@QueryId INT
AS
BEGIN
	SELECT dm.DataMartName, qdm.DataMartId
	FROM QueriesDataMarts qdm
		INNER JOIN DataMarts dm ON qdm.DataMartId = dm.DataMartId
	WHERE qdm.QueryStatusTypeId NOT IN(6, 7)
	AND qdm.QueryId = @QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetNotificationsByQueryDataMart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetNotificationsByQueryDataMart]  --16, 292, 0, 1  
(      
@UserId int,      
@QueryId int,      
@IncludeDelivered bit        
)      
AS BEGIN      
 if (@IncludeDelivered = 0)      
	  BEGIN 
		  SELECT isnull(n.Priority,2) as Priority, n.NotificationId,n.NotificationTypeId,n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime, n.EncryptedData as OtherData,    
		  nGUID.NotificationGUID    
		  from Notifications n      
		  Left JOIN NotificationSecureGUID nGUID    
		 on nGUID.NotificationId = n.NotificationId      
		  Left Join EventDetailNewQuery ednq      
		  On ednq.QueryId = @QueryId      
		  AND ednq.EventId = n.EventId      
		  WHERE UserId = @UserId AND DeliveredTime  is null  
	   END      
 else         
	   BEGIN   
		  SELECT isnull(n.Priority,2) as Priority, n.NotificationId,n.NotificationTypeId,n.EventId,n.UserId,n.GeneratedTime,n.Deliveredtime,n.EncryptedData as OtherData,    
		  nGUID.NotificationGUID    
		  from Notifications n      
		  Left JOIN NotificationSecureGUID nGUID    
		  on nGUID.NotificationId = n.NotificationId      
		  Left Join EventDetailNewQuery ednq      
		  On ednq.QueryId = @QueryId      
		  AND ednq.EventId = n.EventId      
		  WHERE UserId = @UserId    
	   END  
   
      
  END
GO
/****** Object:  StoredProcedure [dbo].[uspGetGroupedQueryResultStatus]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetGroupedQueryResultStatus]
	@QueryId INT,
	@GroupedBy INT
AS

DECLARE @IsGrouped BIT 
SET @IsGrouped = 0
If Exists (SELECT 1 FROM QueryOrganizationalDataMart WHERE QueryId = @QueryId and GroupedBy = @GroupedBy)
BEGIN
	SET @IsGrouped = 1
END

IF(@IsGrouped = 0 AND @GroupedBy = 0)
BEGIN

	SELECT 
	qdm.*,
	q.*,
	dm.DataMartName,
	isnull(dm.OrganizationId,0) as DataMartOrgId,
	qst.QueryStatusType,
	COALESCE(qdm.ErrorMessage, qdm.RejectReason) AS Message,
	0 as EventId
	
	FROM 
		QueriesDataMarts qdm
		JOIN Queries q ON q.QueryId = qdm.QueryId
		JOIN DataMarts dm ON dm.DataMartId = qdm.DataMartId
		JOIN QueryStatusTypes qst ON qst.QueryStatusTypeId = qdm.QueryStatusTypeId	
		Left JOIN Responses r on r.QueryId = qdm.QueryId and r.DataMartId = qdm.DataMartId
			
	WHERE 
		qdm.QueryId=@QueryId
		and qdm.QueryStatusTypeId not in (7)--where 7 = 'DELETED'
		and qdm.isResultsGrouped = 0
	
END

ELSE IF(@IsGrouped = 0 AND @GroupedBy > 0)
BEGIN

	SELECT 
		qdm.*,
		q.*,
		dm.DataMartName,
		isnull(dm.OrganizationId,0) as DataMartOrgId,
		qst.QueryStatusType,
		COALESCE(qdm.ErrorMessage, qdm.RejectReason) AS Message,
		0 as EventId
		
	FROM 
		QueriesDataMarts qdm
		JOIN Queries q ON q.QueryId = qdm.QueryId
		JOIN DataMarts dm ON dm.DataMartId = qdm.DataMartId
		JOIN QueryStatusTypes qst ON qst.QueryStatusTypeId = qdm.QueryStatusTypeId	
		Left JOIN Responses r on r.QueryId = qdm.QueryId and r.DataMartId = qdm.DataMartId
	WHERE 
		qdm.QueryId=@QueryId
		and qdm.QueryStatusTypeId not in (7)--where 7 = 'DELETED'
		--and qdm.isResultsGrouped = 0
		and qdm.DataMartId not in(select GroupDataMartId from QueryOrganizationalDataMart qs where qs.QueryId = @QueryId)

END

ELSE
BEGIN

	SELECT 
		qdm.*,
		q.*,
		dm.DataMartName,
		isnull(dm.OrganizationId,0) as DataMartOrgId,
		qst.QueryStatusType,
		COALESCE(qdm.ErrorMessage, qdm.RejectReason) AS Message,
		0 as EventId
		
	FROM 
		QueriesDataMarts qdm
		JOIN Queries q ON q.QueryId = qdm.QueryId
		JOIN DataMarts dm ON dm.DataMartId = qdm.DataMartId
		JOIN QueryStatusTypes qst ON qst.QueryStatusTypeId = qdm.QueryStatusTypeId	
		Left JOIN Responses r on r.QueryId = qdm.QueryId and r.DataMartId = qdm.DataMartId
	WHERE 
		qdm.QueryId=@QueryId
		and qdm.QueryStatusTypeId not in (7)--where 7 = 'DELETED'
		and qdm.DataMartId in
		(
		select DataMartId
		FROM QueriesDataMarts qdm1 inner join QueryOrganizationalDataMart qo on qdm1.DataMartId = qo.GroupDataMartId
		where qdm1.QueryId = @QueryId and qo.GroupedBy = @GroupedBy
		union
		select distinct DataMartId
		FROM QueriesDataMarts qdm2
		where qdm2.DataMartId not in (select GroupDataMartId from QueryOrganizationalDataMart where QueryId = @QueryId)
		and qdm2.QueryId = @QueryId and qdm2.IsResultsGrouped = 0
		union
		select distinct qdm3.DataMartId from QueriesDataMarts qdm3
		left join QueryOrganizationalDataMart qo1 on qdm3.DataMartId = qo1.GroupDataMartId
		where qo1.GroupDataMartId is null and 
			qdm3.QueryId = @QueryId and qdm3.DataMartId not in
			(select g.DataMartId from GroupedDatamartsMap g inner join QueryOrganizationalDataMart qo2 
			on g.GroupDataMartId = qo2.GroupDataMartId
		where qo2.QueryId = @QueryId and qo2.GroupedBy = @GroupedBy)
		)
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetPendingQueries]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetPendingQueries]
AS

SELECT 
	qdm.*,
	q.*,
	u.Username AS CreatedByUsername,
	ednq.EventId
FROM 
	QueriesDataMarts qdm
	JOIN Queries q ON q.QueryId = qdm.QueryId
	JOIN Users u ON u.UserId = q.CreatedByUserId
	LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId
WHERE 
	qdm.QueryStatusTypeId=1
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesByUserOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesByUserOrganization] --1,2
(
	@UserId INT,
	@DatamartId int
)
AS

SELECT 
	q.*
FROM Users u
	INNER JOIN DATAMARTS dm on dm.OrganizationId = u.OrganizationId and isnull(dm.IsDeleted,0) = 0
	INNER JOIN QueriesDataMarts qdm ON qdm.DatamartId = dm.DatamartId
	INNER JOIN Queries q ON q.QueryId = qdm.QueryId
	LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId 
	and qdm.DatamartId = ednq.DatamartId 
WHERE 
	u.UserId = @UserId And isnull(u.IsDeleted,0) = 0 and ednq.DatamartId = @DatamartId
ORDER BY
	qdm.QueryId
GO
/****** Object:  StoredProcedure [dbo].[uspGetQuery]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQuery]
	@QueryId int
AS
BEGIN
	SELECT	Queries.*, Query.QueryXml, Query.Comment
	FROM	Queries
	LEFT OUTER JOIN Query ON Queries.QueryId = Query.QueryId
	WHERE	Queries.QueryId=@QueryId

	SELECT	*
	FROM	QueriesDataMarts
	WHERE	QueryId=@QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryDocuments]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryDocuments] --27
(
	@QueryId int	
)
AS BEGIN
	If @QueryId > 0
		BEGIN
		SELECT qd.QueryId, qd.DocId, d.FileName from QueriesDocuments qd
		INNER JOIN Documents d
		on d.DocId = qd.DocId 
		Where qd.QueryId = @QueryId
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryDatamartsIncludedInResults]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryDatamartsIncludedInResults] --47,42  
 @QueryId INT,  
 @DataMartIds varchar(1000)= ''  
AS  
  
if @DataMartIds <> ''  
 BEGIN  
  SELECT     
  dm.DataMartName,   
  qdm.DataMartId,  
  qdm.QueryStatusTypeId  
 FROM   
  QueriesDataMarts qdm   
  INNER JOIN Datamarts dm  
  ON qdm.QueryId = @QueryId     
  AND dm.DataMartId = qdm.DataMartId   
  INNER JOIN Responses r  
   ON r.QueryId = qdm.QueryId  
   And r.DataMartId = qdm.DataMartid   
 WHERE     
   qdm.DataMartId in ( Select value from GetValueTableOfDelimittedString (@DataMartIds,','))  
   and Isnull(qdm.IsResultsGrouped,0) = 0  
 END  
Else  
 BEGIN  
  SELECT     
   dm.DataMartName ,  
   qdm.DataMartId,  
   qdm.QueryStatusTypeId  
  FROM   
   QueriesDataMarts qdm
   Inner join DataMarts dm
   on dm.DatamartId = qdm.DataMartId -- We should not check for deleted DataMart as the grouped results once aggregated, involves the datamarts results that may have been removed in the later stage
   inner join Responses r
   on qdm.DataMartId = r.DataMartId
   and qdm.QueryId = r.QueryId
   Where qdm.QueryId = @QueryId and Isnull(qdm.IsResultsGrouped,0) = 0 and QueryStatusTypeId = 3 
 END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryDatamartsIncludedInQueryGroupResults]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryDatamartsIncludedInQueryGroupResults] --18,'31'
(
	@QueryId INT,
	@QueryGroupIds varchar(1000)= ''
)
AS

if @QueryGroupIds <> ''
	BEGIN
		SELECT 		
		dm.DataMartName,	
		dm.DataMartId,
		3 as QueryStatusTypeId --> grouped results will be set to the Completed status always so eliminating a join with static result
	FROM 
		NetworkQueriesGroups nqg
	INNER JOIN NetworkResponsesGroups nrg
		ON nrg.NetworkQueryGroupId = nqg. NetworkQueryGroupId
	INNER JOIN Responses r
		ON r.ResponseId = nrg.ResponseId
	Inner JOin DataMarts DM
		ON DM.DataMartId = r.DataMartId
		AND IsNull(DM.IsDeleted,0) = 0		
	WHERE 		
		 nqg.NetworkQueryGroupId in ( Select value from GetValueTableOfDelimittedString (@QueryGroupIds,','))
	END

GRANT EXEC ON uspGetQueryDatamartsIncludedInQueryGroupResults TO PUBLIC
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryTypesSupportedByDatamart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryTypesSupportedByDatamart] --1
 (
	@DatamartId int
 )
 AS
 BEGIN
	Select qTypes.QueryTypeId
			, qTypes.QueryType
			, valYearData.MinYear 
			, valYearData.MaxYear 
			, valQuarterData.MinQuarter
			, valQuarterData.MaxQuarter
			, case when (isnull(pqd.QueryTypeId,0) <> 0) then 'True' else 'False' end as IsSupported
			, qTypes.QueryCategoryId 
		 From QueryTypes qTypes
		 Left Join PermissionsQueryTypesDataMarts pqd
		 on  pqd.QueryTypeId = qTypes.QueryTypeId  
		 and pqd.DatamartId = @DatamartId	
		 Left Join  
			(Select ROW_NUMBER() OVER (PARTITION BY QueryTypeId order by QueryTypeId) AS Row
						, max(Period) as MaxYear
						, min(Period) as MinYear	
						, QueryTypeId		
			 FROM DataMartAvailabilityPeriods Where DataMartId = @DatamartId and isActive = 1 and PeriodCategory = 'Y' Group by QueryTypeId ) valYearData
			 On valYearData.QueryTypeId = qTypes.QueryTypeId and valYearData.Row = 1
		Left join
			(Select ROW_NUMBER() OVER (PARTITION BY QueryTypeId order by QueryTypeId) AS Row
						, max(Period) as MaxQuarter
						, min(Period) as MinQuarter	
						, QueryTypeId		
			 FROM DataMartAvailabilityPeriods Where DataMartId = @DatamartId and isActive = 1 and PeriodCategory = 'Q' Group by QueryTypeId ) valQuarterData
			 On valQuarterData.QueryTypeId = qTypes.QueryTypeId and valQuarterData.Row = 1		 
		Where qTypes.IsAdminQueryType  = 0 Order by qTypes.QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryResultStatus]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryResultStatus] --35
	@QueryId INT
AS

SELECT 
	qdm.*,
	q.*,
	dm.DataMartName,
	isnull(dm.OrganizationId,0) as DataMartOrgId,
	qst.QueryStatusType,
	COALESCE(qdm.ErrorMessage, qdm.RejectReason) AS Message,
	0 as EventId
	
FROM 
	QueriesDataMarts qdm
	JOIN Queries q ON q.QueryId = qdm.QueryId
	JOIN DataMarts dm ON dm.DataMartId = qdm.DataMartId
	JOIN QueryStatusTypes qst ON qst.QueryStatusTypeId = qdm.QueryStatusTypeId	
	Left JOIN Responses r on r.QueryId = qdm.QueryId and r.DataMartId = qdm.DataMartId
		
WHERE 
	qdm.QueryId=@QueryId
	and qdm.QueryStatusTypeId not in (7)--where 7 = 'DELETED'
	and qdm.isResultsGrouped = 0
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryByEventId]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryByEventId] --1
(
	@EventId int
)
AS BEGIN

Select q.* from Queries q
Where q.QueryId = 
(Select coalesce(nq.QueryId,qsc.QueryId,res.QueryId) 
 From Events e
 Left Join EventDetailNewQuery nq
 on e.EventId = nq.EventId
 Left join EventDetailQueryStatusChange qsc
 on e.EventId = qsc.EventId
 Left join EventDetailNewResult nr
 on e.EventId = nr.EventId
 Left join Responses res
 on nr.resultId = res.ResponseId
Where e.EventId = @EventID)


END
GO
/****** Object:  StoredProcedure [dbo].[uspGetResultStatus]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetResultStatus] --284  
 @QueryId INT  
AS  
  
SELECT   
 qdm.*,  
 q.*,  
 dm.DataMartName,
 isnull(dm.OrganizationId,0) as DataMartOrgId,  
 qst.QueryStatusType,  
 COALESCE(qdm.ErrorMessage, qdm.RejectReason) AS Message,  
 ednq.EventId  
   
FROM   
 QueriesDataMarts qdm  
 JOIN Queries q ON q.QueryId = qdm.QueryId  
 JOIN DataMarts dm ON dm.DataMartId = qdm.DataMartId  
 JOIN QueryStatusTypes qst ON qst.QueryStatusTypeId = qdm.QueryStatusTypeId  
 --LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = dm.DataMartId  
 LEFT JOIN 
	(Select dnq.* FROM EventDetailNewQuery dnq INNER JOIN Events enq ON enq.EventId= dnq.EventId and enq.EventTypeId=1) ednq 
	ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = dm.DataMartId  
WHERE   
 qdm.QueryId=@QueryId
GO
/****** Object:  StoredProcedure [dbo].[uspSetResultViewedEventAndDetail]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uspSetResultViewedEventAndDetail]
@EventTypeID int,
@EventSourceID int,
@QueryID int,
@ViewByUserID int
AS BEGIN
Declare @EventId int 
BEGIN TRANSACTION  

if (@QueryId > 0)
	BEGIN
		--Select @EventId = IsNull(EventId,0) FROM EventDetailNewQuery Where QueryId = @QueryId		
		INSERT EVENTS(EventSourceId, EventTypeId,EventDatetime) VALUES  
		 (@EventSourceId,@EventTypeID,GetDate())

			if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -1 as returnValue--Error while inserting to events table  
							--This will be used to trace the part of query that caused the issue
				  return
			  END  
			else
				Select @EventId = Scope_Identity()  
	END

if (@EventId > 0)
	BEGIN
		INSERT INTO EventDetailViewedResult (EventId, QueryId, ViewedByID)
			VALUES(@EventId,@QueryId,@ViewByUserID)

		if @@Error <> 0
			  BEGIN  
				  ROLLBACK  
				  Select -2 as returnValue--Error while inserting to status change table. 
							--This will be used to trace the part of query that caused the issue
				  Return
			  END  
		else
			BEGIN
				COMMIT
			END			
	END


Select @EventId as returnValue
Return @EventId
END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateQueryTypeAvailabilityPeriod]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspUpdateQueryTypeAvailabilityPeriod]
(
      @DatamartId int,
      @QueryId int,
      @GenricNamePeriodString varchar(max),
      @DrugClassPeriodString varchar(max),      
      @ICD9DiagnosisPeriodString varchar(max),
      @ICD9ProceduresPeriodString varchar(max),
      @HCPCSPeriodString varchar(max),
      @EligibilityPeriodString varchar(max),
      @ICD9Diagnosis_4_digit_PeriodString varchar(max),
      @ICD9Diagnosis_5_digit_PeriodString varchar(max),
      @ICD9Procedures_4_digit_PeriodString varchar(max),
      @Incident_GenricNamePeriodString varchar(max),
      @Incident_DrugClassPeriodString varchar(max),   
      @Incident_ICD9DiagnosisPeriodString varchar(max),
      @Incident_ICD9ProceduresPeriodString varchar(max),
      @Incident_HCPCSPeriodString varchar(max),
      @Incident_EligibilityPeriodString varchar(max),
      @Incident_ICD9Diagnosis_4_digit_PeriodString varchar(max),
      @Incident_ICD9Diagnosis_5_digit_PeriodString varchar(max),
      @Incident_ICD9Procedures_4_digit_PeriodString varchar(max),
      @MFU_GenricNamePeriodString varchar(max)='',
      @MFU_DrugClassPeriodString varchar(max)='',     
      @MFU_ICD9DiagnosisPeriodString varchar(max)='',
      @MFU_ICD9ProceduresPeriodString varchar(max)='',
      @MFU_HCPCSPeriodString varchar(max)='',
      @MFU_ICD9Diagnosis_4_digit_PeriodString varchar(max)='',
      @MFU_ICD9Diagnosis_5_digit_PeriodString varchar(max)='',
      @MFU_ICD9Procedures_4_digit_PeriodString varchar(max)=''
)
AS
BEGIN
            --Prevalence
            if (@GenricNamePeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  1,'Y',Value,1 From GetValueTableOfDelimittedString(@GenricNamePeriodString, ',')
            END

            if (@DrugClassPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  2,'Y',Value,1 From GetValueTableOfDelimittedString(@DrugClassPeriodString, ',')
            END

            if (@ICD9DiagnosisPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  4,'Y',Value,1 from GetValueTableOfDelimittedString(@ICD9DiagnosisPeriodString, ',')
            END

            if (@ICD9ProceduresPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  5,'Y',Value,1 from GetValueTableOfDelimittedString(@ICD9ProceduresPeriodString, ',')
            END

            if (@HCPCSPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  6,'Y',Value,1 from GetValueTableOfDelimittedString(@HCPCSPeriodString, ',')
            END

            if (@EligibilityPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  7,'Y',Value,1 from GetValueTableOfDelimittedString(@EligibilityPeriodString, ',')
            END

            if (@ICD9Diagnosis_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  10,'Y',Value,1 from GetValueTableOfDelimittedString(@ICD9Diagnosis_4_digit_PeriodString, ',')
            END

            if (@ICD9Diagnosis_5_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  11,'Y',Value,1 from GetValueTableOfDelimittedString(@ICD9Diagnosis_5_digit_PeriodString, ',')
            END

            if (@ICD9Procedures_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  12,'Y',Value,1 from GetValueTableOfDelimittedString(@ICD9Procedures_4_digit_PeriodString, ',')
            END
            
             --Incident
            if (@Incident_GenricNamePeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  14,'Y',Value,1 From GetValueTableOfDelimittedString(@Incident_GenricNamePeriodString, ',')
            END

            if (@Incident_DrugClassPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  15,'Y',Value,1 From GetValueTableOfDelimittedString(@Incident_DrugClassPeriodString, ',')
            END

            if (@Incident_ICD9DiagnosisPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  17,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_ICD9DiagnosisPeriodString, ',')
            END

            if (@Incident_ICD9ProceduresPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  18,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_ICD9ProceduresPeriodString, ',')
            END

            if (@Incident_HCPCSPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  19,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_HCPCSPeriodString, ',')
            END

            if (@Incident_EligibilityPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  20,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_EligibilityPeriodString, ',')
            END

            if (@Incident_ICD9Diagnosis_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  21,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_ICD9Diagnosis_4_digit_PeriodString, ',')
            END

            if (@Incident_ICD9Diagnosis_5_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  22,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_ICD9Diagnosis_5_digit_PeriodString, ',')
            END

            if (@Incident_ICD9Procedures_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  23,'Y',Value,1 from GetValueTableOfDelimittedString(@Incident_ICD9Procedures_4_digit_PeriodString, ',')
            END

            --MFU
            if (@MFU_GenricNamePeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  29,'Y',Value,1 From GetValueTableOfDelimittedString(@MFU_GenricNamePeriodString, ',')
            END

            if (@MFU_DrugClassPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  30,'Y',Value,1 From GetValueTableOfDelimittedString(@MFU_DrugClassPeriodString, ',')
            END

            if (@MFU_ICD9DiagnosisPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  31,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_ICD9DiagnosisPeriodString, ',')
            END

            if (@MFU_ICD9ProceduresPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  32,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_ICD9ProceduresPeriodString, ',')
            END

            if (@MFU_HCPCSPeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  33,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_HCPCSPeriodString, ',')
            END

            if (@MFU_ICD9Diagnosis_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  34,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_ICD9Diagnosis_4_digit_PeriodString, ',')
            END

            if (@MFU_ICD9Diagnosis_5_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  35,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_ICD9Diagnosis_5_digit_PeriodString, ',')
            END

            if (@MFU_ICD9Procedures_4_digit_PeriodString <> '')
            BEGIN
                  INSERT INTO DatamartAvailabilityPeriods Select @QueryId, @DatamartId,
                  36,'Y',Value,1 from GetValueTableOfDelimittedString(@MFU_ICD9Procedures_4_digit_PeriodString, ',')
            END

            Update DatamartAvailabilityPeriods Set PeriodCategory = 'Q' 
            Where DatamartId = @DataMartId and QueryId = @QueryId and Period Like '%Q%'

            Update DatamartAvailabilityPeriods Set isActive = 0 
            Where DatamartId = @DataMartId and QueryId <> @QueryId

END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateQueryDataMart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspUpdateQueryDataMart]  
 @QueryId int,  
 @DataMartId int,  
 @QueryStatusTypeId int,  
 @RequestTime DATETIME=NULL,  
 @ResponseTime DATETIME=NULL,  
 @ErrorMessage TEXT=NULL,  
 @ErrorDetail TEXT=NULL,  
 @RejectReason TEXT=NULL,
 @RespondedByUserId int =NULL  
AS  
BEGIN
	UPDATE QueriesDataMarts  
	SET  QueryStatusTypeId=@QueryStatusTypeId,  
	  RequestTime=@RequestTime,  
	  ResponseTime=@ResponseTime,  
	  ErrorMessage=@ErrorMessage,  
	  ErrorDetail=@ErrorDetail,  
	  RejectReason=@RejectReason,
	  Respondedby = @RespondedByUserId
	    
	WHERE QueryId=@QueryId   
	  AND DataMartId=@DataMartId  
END
GO
/****** Object:  StoredProcedure [dbo].[uspUpdateQueryComment]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspUpdateQueryComment]
@QueryId INT,
@Comment VARCHAR(500)

AS
BEGIN
	UPDATE Query SET Comment = @Comment WHERE QueryId = @QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspSetQueryStatus]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSetQueryStatus]
@QueryId INT,
@QueryStatusTypeId INT,
@Comment VARCHAR(500)

AS
BEGIN
	UPDATE Query SET Comment = @Comment WHERE QueryId = @QueryId
	
	UPDATE QueriesDataMarts
	SET	QueryStatusTypeId=@QueryStatusTypeId,
		ResponseTime= CASE WHEN @QueryStatusTypeId IN(1,2,11,12) THEN NULL ELSE GETDATE() END
	WHERE	QueryId=@QueryId 
	AND QueryStatusTypeId NOT IN(6,7) --(Cancelled, Deleted)

END
GO
/****** Object:  StoredProcedure [dbo].[uspIsQueryResultViewed]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspIsQueryResultViewed] --333
(
@QueryId int
)
AS BEGIN
Declare @IsResultsViewed bit

Set @IsResultsViewed = 0

If Exists (Select 1 from QueriesCachedResults Where QueryId = @QueryId)
	Select 'true' as IsResultsViewed
Else
	Select 'false' as IsResultsViewed

END
GO
/****** Object:  StoredProcedure [dbo].[uspGroupAndApproveResponse]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGroupAndApproveResponse] --26,31
(
@QueryId int,
@ConcatenatedDataMartIds Varchar(1000),
@ApprovedBy int,
@AggregatedXml ntext,
@GroupNamePrefix varchar(20) = ''
)
AS BEGIN
	Declare @VirtualDataMartId int
	Declare @ResponseId int
	Declare @DataMartOrganizationId int
	Declare @DataMartOrganizationName varchar(100)
	Declare @CreatedByUserId int 
	Declare @ApproverOrganizationId int 
	Declare @NumLowCellCounts int
	Declare @NumDataMarts int
	Declare @LowCellCountText varchar(1000)
	
	Select @ApproverOrganizationId = OrganizationId from users where UserId  = @ApprovedBy

	Select @DataMartOrganizationId = o.OrganizationId, @DataMartOrganizationName = o.OrganizationName 
	From Organizations o where o.OrganizationId = @ApproverOrganizationId and isnull(o.isDeleted,0) = 0
	
	If @DataMartOrganizationId is null
	BEGIN		
		Select -1 as VirtualDataMartId, 0 as ResponseId 
		return
	END
		
	Declare @GroupDataMartName varchar(150)
	
	if @GroupNamePrefix <> ''
		Set @GroupNamePrefix = @GroupNamePrefix + '_'

	Select @GroupDataMartName = @GroupNamePrefix + @DataMartOrganizationName + ' '+ Cast(count(QueryId) + 1 as varchar)
	From QueryOrganizationalDataMart Where QueryId = @QueryId and DatMartOrganizationId = @DataMartOrganizationId

	Insert into DataMarts (DataMartName,RequiresApproval,DataMartTypeId, IsDeleted, OrganizationId, IsGroupDataMart) values
	(@GroupDataMartName,0,1,0,@DataMartOrganizationId,1)
	
	--Get Number of DataMarts.
	Select @NumDataMarts=COUNT(*) from GetValueTableOfDelimittedString(@ConcatenatedDataMartIds,',')
	--Get the count of datamart results having low cell count set to zero.
	SELECT @NumLowCellCounts=COUNT(*) FROM [QueriesDataMarts] 
	WHERE  QueryId=@QueryId  and DataMartId in (Select Value from GetValueTableOfDelimittedString(@ConcatenatedDataMartIds,',') ) 
	AND PATINDEX('%Low cell counts have been zeroed%',Isnull(RejectReason,''))>0	
	--Set @LowCellCountText
	if(ISNULL(@NumDataMarts,0)>0 and ISNULL(@NumLowCellCounts,0)>0)
	Begin
		Select @LowCellCountText='Low cell counts have been zeroed in these results.'
	End
		
	If @@Error = 0	
		Select @VirtualDataMartId = SCOPE_IDENTITY()
	Else 
		BEGIn
		Select -2 as VirtualDataMartId, 0 as ResponseId  --( @VirtualDataMartId, ResponseId)
		return
		END

	INsert into QueryOrganizationalDataMart (QueryId, DatMartOrganizationId,GroupDataMartId, GroupedBy) Values 
											(@QueryId, @DataMartOrganizationId, @VirtualDataMartId, @ApprovedBy)

	If @@Error <> 0	
		BEGIN
		Select -3 as VirtualDataMartId, 0 as ResponseId --( @VirtualDataMartId, ResponseId)
		return
		END

	Insert into GroupedDatamartsMap (GroupDataMartId, DataMartId) Select @VirtualDataMartId,Value from GetValueTableOfDelimittedString(@ConcatenatedDataMartIds,',') 
	
	If @@Error <> 0	
		BEGIN
		Select -4 as VirtualDataMartId, 0 as ResponseId  --( @VirtualDataMartId, ResponseId)
		return
		END

	Insert into QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId,RejectReason, Responsetime) Values
				(@QueryId,@VirtualDataMartId,3,@LowCellCountText,getDate())

	If @@Error <> 0	
		BEGIN
		Select -5 as VirtualDataMartId, 0 as ResponseId  --( @VirtualDataMartId, ResponseId)
		return
		END

	INSERT into responses (QueryId, DataMartId,ResponseXml,userid, IsDeleted) values
						(@QueryId,@VirtualDataMartId,@AggregatedXml,@ApprovedBy,0)
	
	If @@Error <> 0	
		BEGIN
		Select -6 as VirtualDataMartId, 0 as ResponseId  --( @VirtualDataMartId, ResponseId)
		return
		END
	else
		Select @ResponseId = SCOPE_IDENTITY()

	Update responses set isDeleted = 0 Where QueryId = @QueryId and DataMartId in (Select Value from GetValueTableOfDelimittedString(@ConcatenatedDataMartIds,',') )

	Update QueriesDataMarts set QueryStatusTypeId = 3, isResultsGrouped = 1 Where QueryId = @QueryId and DataMartId in (Select Value from GetValueTableOfDelimittedString(@ConcatenatedDataMartIds,',') )

Select @VirtualDataMartId as VirtualDataMartId , @ResponseId as ResponseId
return	

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSupportedQueryTypesByQuery]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSupportedQueryTypesByQuery] --71
 (
	@QueryId int	
 )
 AS
 BEGIN
	Select distinct qTypes.QueryTypeId
			, qTypes.QueryType
			, valYearData.MinYear 
			, valYearData.MaxYear 
			, valQuarterData.MinQuarter
			, valQuarterData.MaxQuarter
			, case when (isnull(pqd.QueryTypeId,0) <> 0) then 'True' else 'False' end as IsSupported 
		 From QueryTypes qTypes
		 Left Join PermissionsQueryTypesDataMarts pqd
		 on  pqd.QueryTypeId = qTypes.QueryTypeId  
		 --and pqd.DatamartId = @DatamartId	
		 Left Join  
			(Select ROW_NUMBER() OVER (PARTITION BY QueryTypeId order by QueryTypeId) AS Row
						, max(Period) as MaxYear
						, min(Period) as MinYear	
						, QueryTypeId		
			 FROM DataMartAvailabilityPeriods Where QueryId = @QueryId and isActive = 1 and PeriodCategory = 'Y' Group by QueryTypeId ) valYearData
			 On valYearData.QueryTypeId = qTypes.QueryTypeId and valYearData.Row = 1
		Left join
			(Select ROW_NUMBER() OVER (PARTITION BY QueryTypeId order by QueryTypeId) AS Row
						, max(Period) as MaxQuarter
						, min(Period) as MinQuarter	
						, QueryTypeId		
			 FROM DataMartAvailabilityPeriods Where QueryId = @QueryId and isActive = 1 and PeriodCategory = 'Q' Group by QueryTypeId ) valQuarterData
			 On valQuarterData.QueryTypeId = qTypes.QueryTypeId and valQuarterData.Row = 1		 
		Where qTypes.IsAdminQueryType  = 0 Order by qTypes.QueryTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetSelfAdministeredDatamartForQueryTypeandPeriod]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetSelfAdministeredDatamartForQueryTypeandPeriod] --1,8,''
(  
@UserId int,
@QueryTypeId int,
@ConcatenatedPeriod varchar(1000)
)  
AS BEGIN  

if (@QueryTypeId <> 8)
BEGIN

		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMartNotifications dn
		Inner join DataMarts dm  
		on dm.DataMartId = dn.DataMartId 
		and dn.NotificationUserId = @UserId
		inner join DatamartTypes dmt  
		on dmt.DatamartTypeId = dm.DatamartTypeId 
		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  

		Inner Join (Select distinct DatamartId from DatamartAvailabilityPeriods   
		where isActive = 1 and QueryTypeId = @QueryTypeId   
		and 
		(
			(@ConcatenatedPeriod <> '' and Period in (Select value from GetValueTableOfDelimittedString (@ConcatenatedPeriod, ','))) or
			(@ConcatenatedPeriod = '' and Period <> '')
		)  ) dap
		on dap.DataMartId = pqtd.DatamartId   
		Where isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		END  
ELSE
		BEGIN
		Select dm.DatamartId  
		  , dm.DataMartName  
		  , dm.Url  
		  , dm.RequiresApproval  
		  , dm.DataMartTypeId  
		  , dm.OrganizationId    
		  , dm.AvailablePeriod  
		  , dm.ContactEmail  
		  , dm.ContactFirstName  
		  , dm.ContactLastName  
		  , dm.ContactPhone  
		  , dm.SpecialRequirements  
		  , dm.UsageRestrictions  
		  , dmt.DataMartType    
		  , dm.HealthPlanDescription   
		FROM DataMartNotifications dn
		Inner join DataMarts dm  
		on dm.DataMartId = dn.DataMartId 
		and dn.NotificationUserId = @UserId
		inner join DatamartTypes dmt  
		on dmt.DatamartTypeId = dm.DatamartTypeId 
		INNER JOIN (Select distinct DataMartId from PermissionsQueryTypesDatamarts where  
				(
					(@QueryTypeId = 0 and  QueryTypeId <> @QueryTypeId) or
					(@QueryTypeId <> 0 and  QueryTypeId = @QueryTypeId)
				)) pqtd
		on pqtd.DatamartId = dm.DatamartId  
		Where isnull(dm.IsDeleted,0) = 0 and isnull(dm.IsGroupDataMart,0) = 0  
		END  
END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveAggregatedResults]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveAggregatedResults] --333
(
@QueryId int,
@AggregatedResultsXml ntext
)
AS BEGIN

Insert into QueriesCachedResults values (@QueryId,@AggregatedResultsXml,GetDate())
if (@@Error = 0)
--Update Responses set IsDeleted = 1 ,ResponseXml = '' where Queryid = @QueryId
Update NetworkQueriesGroups Set IsDeleted = 1,AggregatedGroupResults = '' Where Queryid = @QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUserDatamartsForQueryTypeNotInQuery]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetUserDatamartsForQueryTypeNotInQuery] --1,16,1
(
@QueryTypeId int,
@UserId int,
@QueryId int
)
AS BEGIN

--------------
 Declare @OrgId int      
 Set @OrgId = 0      
 Select @OrgId = OrganizationId from users where UserId = @UserId
------------

Select distinct dm.*,dmt.DatamartType from Datamarts dm
INNER JOIN (Select DatamartId From PermissionsUsersDataMarts  pud INNER JOIN Users u on u.UserId = pud.userId and isnull(u.IsDeleted,0)= 0 Where pud.UserId = @UserId  
						 UNION  
						 SELECT DatamartId From PermissionsOrganizationsDataMarts pod INNER JOIN Organizations o on pod.OrganizationId = o.OrganizationId and isnull(o.IsDeleted,0) =0 Where pod.OrganizationId = @OrgId  
						 UNION  
						 SELECT DatamartId From PermissionsGroupsDataMarts pgd inner join Groups g on pgd.GroupId = g.GroupId and isnull(g.IsDeleted,0)=0 Where g.GroupId in (Select og.GroupId from OrganizationsGroups og inner join Organizations o on o.OrganizationId = og.OrganizationId and isnull(o.IsDeleted, 0) = 0 where og.OrganizationId = @OrgId)  ) dmList
on dm.DatamartId = dmList.DatamartId
INNER JOIN PermissionsQueryTypesDatamarts pqtd
on pqtd.DatamartId = dm.DatamartId
AND pqtd.QueryTypeId = @QueryTypeId
inner join DatamartTypes dmt
on dmt.DatamartTypeId = dm.DataMartTypeId
Left Join Organizations o
on o.OrganizationId = dm.OrganizationId
Where dm.DataMartId not in (Select DataMartId from QueriesDataMarts Where QueryId = @QueryId and  QueryStatusTypeId not in (6, 7))
AND isnull(dm.IsDeleted,0) = 0 and isnull(o.IsDeleted,0) = 0


END
GO
/****** Object:  StoredProcedure [dbo].[uspSaveResultViewedStatus]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspSaveResultViewedStatus]
(
@QueryId int
)
AS BEGIN
IF not Exists (select 1 from QueryResultsViewedStatus where queryId = @QueryId)
INSERT INTO QueryResultsViewedStatus (QueryId,ResponseId, ViewedAt)
Select QueryId,ResponseId, GetDate() from Responses where queryId = @QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetResponseDocuments]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetResponseDocuments] --27
(
	@QueryId int,
	@DataMartIds varchar(1000)= ''
)
AS BEGIN
	If (@DataMartIds <> '' AND @DataMartIds <> '0')
		BEGIN
			SELECT r.ResponseId as ResponseId, dm.DataMartName as DataMartName,  d.DocId, d.FileName  
			From Responses r
			INNER JOIN DataMarts dm
			on dm.DataMartId = r.DataMartId
			Inner JOIN ResponsesDocuments rd
			on r.ResponseId = rd.ResponseId
			INNER JOIN Documents d
			On d.DocId = rd.DocId
			Where r.QueryId = @QueryId
			and r.DataMartId in ( Select value from GetValueTableOfDelimittedString (@DataMartIds,','))  
		END
	Else
		BEGIN
			SELECT r.ResponseId as ResponseId, dm.DataMartName as DataMartName,  d.DocId, d.FileName  
			From Responses r
			INNER JOIN DataMarts dm
			on dm.DataMartId = r.DataMartId
			Inner JOIN ResponsesDocuments rd
			on r.ResponseId = rd.ResponseId
			INNER JOIN Documents d
			On d.DocId = rd.DocId			
			Where r.QueryId = @QueryId			
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryStatus]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueryStatus]
@QueryId INT
AS
BEGIN
	SELECT	dbo.GetQueryStatus(QueryId) as QueryStatus, Comment
	FROM	Query
	WHERE QueryId = @QueryId
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueryDataMart]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueryDataMart] -- 313,8
 @QueryId int,  
 @DataMartId int  
AS  
  
SELECT qdm.*, q.*, ednq.EventId,u.Username AS CreatedByUsername, u.RoleTypeId as RoleTypeId, RoleType as CreatedByRoleType ,Isnull(dm.OrganizationId,0) as DataMartOrgId, ru.Username as RespondedByUsername  
FROM QueriesDataMarts qdm  
JOIN vw_Query q ON q.QueryId=qdm.QueryId  
LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId  
INNER JOIN Users u  on u.UserId = q.CreatedByUserId  
INNER JOIN RoleTypes on RoleTypes.RoleTypeId = u.RoleTypeId
INNER JOIN Datamarts dm  on dm.DataMartId = qdm.DataMartId  
and isNull(dm.IsDeleted,0) = 0  
LEFT JOIN Users ru on ru.UserId = qdm.RespondedBy
WHERE qdm.QueryId=@QueryId AND qdm.DataMartId=@DataMartId
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesSubmittedToGroupAdmin]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueriesSubmittedToGroupAdmin] -- 71
@AdminUserId int,
@FromDate datetime = null,
@ToDate datetime = null
AS  
BEGIN  
  
 SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment  
 FROM Queries q  
 INNER JOIN Users u  
 on Isnull(u.IsDeleted,0) = 0 and isnull(q.isdeleted,0) = 0  
 and u.UserId = q.CreatedByUserId
 LEFT OUTER JOIN Query r ON q.QueryId = r.QueryId
 Where q.QueryId in (
	Select Distinct qdm.QueryId from 
		(Select OrganizationId from OrganizationsGroups
		 Where groupId in (Select GroupId from GroupAdministrators where AdminUserId = @AdminUserId)) m
		INNER JOIN Organizations o
		on isnull(o.Isdeleted,0) = 0 
		and o.OrganizationId = m.OrganizationId
		Inner Join DataMarts dm
		on dm.OrganizationId = o.OrganizationId
		and isnull(dm.IsDeleted,0) = 0
		inner join QueriesDataMarts qdm
		on qdm.DataMartId = dm.DataMartId
		Where qdm.QueryStatusTypeId NOT IN(10, 11, 12))
	AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	AND q.QueryTypeId NOT IN(24) --DM Client Notification
	
order by q.QueryId desc   
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesSubmittedByOrganizationUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueriesSubmittedByOrganizationUsers]
@OrganizationID int,
@FromDate datetime = null,
@ToDate datetime = null
AS 
BEGIN

	SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM	Queries q
	INNER JOIN Users u 
		ON q.CreatedbyUserId = u.UserId and isnull(u.isDeleted,0)  = 0 and u.OrganizationID=@OrganizationID
	LEFT OUTER JOIN Query r ON q.QueryId = r.QueryId
	WHERE CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesSubmittedByGroupUsers]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueriesSubmittedByGroupUsers] 
@OrganizationID int,
@FromDate datetime = null,
@ToDate datetime = null
AS
BEGIN

	SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM Queries q
	INNER JOIN Users u
		on Isnull(u.IsDeleted,0) = 0 and isnull(q.isdeleted,0) = 0
		and u.UserId = q.CreatedByUserId
	LEFT OUTER JOIN Query r ON q.QueryId = r.QueryId
	where u.OrganizationId in (
				Select distinct(OrganizationId) from OrganizationsGroups 
				where GroupId in (Select GroupId From OrganizationsGroups where OrganizationId  = @OrganizationID)
				union select @OrganizationID)
		AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
		AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
		AND q.QueryId NOT IN(SELECT QueryId FROM QueriesDataMarts WHERE QueryStatusTypeId IN(10, 11, 12))--Pending QA Approval, Hold, Rejected/Denied
	
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesForSubmitterReminders]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesForSubmitterReminders]  
  
AS  
  
SELECT   
 qdm.*,  
 q.*,  
 u.Username AS CreatedByUsername,  
 ednq.EventId,  
 nf.Days as ReminderOffset  
FROM   
 QueriesDataMarts qdm  
 JOIN Queries q ON q.QueryId = qdm.QueryId  
 JOIN Users u ON u.UserId = q.CreatedByUserId  
 --LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = qdm.DatamartId  
  LEFT JOIN 
	(Select dnq.* FROM EventDetailNewQuery dnq INNER JOIN Events enq ON enq.EventId= dnq.EventId and enq.EventTypeId=1) ednq 
	ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = qdm.DatamartId 
 Left JOIN EventDetailSubmitterReminder edsr On edsr.QueryId  = qdm.QueryId  
 Left Join Events e on e.EventId = edsr.EventId  
 Left Join NotificationOptions unf On unf.UserId=u.UserId and unf.EventTypeId=5--eventtypeid=5 represents squery submitter reminder event
 Left Join NotificationFrequency nf On nf.FrequencyID=unf.FrequencyID  
WHERE   
 qdm.QueryStatusTypeId in (2,4) And (isnull(nf.Days,0) > 0 or ISNULL(unf.Days,0)>0 )
 AND( 
	(lower(nf.Description)<>'every n days' and DateDiff(d,q.CreatedAt,GetDate())> isnull(nf.Days,0))
	OR
	(lower(nf.Description)='every n days' and DateDiff(d,q.CreatedAt,GetDate())> isnull(unf.Days,0))
	)
 AND (edsr.EventId is null or DateDiff(d,e.EventDateTime,GetDate())> isnull(nf.Days,0))
 AND q.QueryId not in (Select distinct (QueryId) from QueryResultsViewedStatus)
  
ORDER BY  
 qdm.QueryID,  
 qdm.DataMartID
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesForReminders]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesForReminders] --1
--(
--@ReminderOffsetDays int
--)
AS

SELECT   
 ISNULL(nu.UserId,0) as UserId,
 nu.UserName as UserName,
 qdm.*,  
 q.*,  
 u.Username AS CreatedByUsername,  
 ednq.EventId,  
 nf.Days as ReminderOffset  
FROM   
 QueriesDataMarts qdm  
 JOIN Queries q ON q.QueryId = qdm.QueryId  
 JOIN Users u ON u.UserId = q.CreatedByUserId  
 JOIN vw_DataMartNotificationUsers nu on nu.DataMartId = qdm.DataMartId
  --LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = qdm.DatamartId  
  LEFT JOIN 
	(Select dnq.* FROM EventDetailNewQuery dnq INNER JOIN Events enq ON enq.EventId= dnq.EventId and enq.EventTypeId=1) ednq 
	ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = qdm.DatamartId 
Left JOIN EventDetailQueryReminder edqr On edqr.QueryId  = qdm.QueryId and edqr.DatamartId = qdm.DatamartId and edqr.UserId = nu.UserId
 Left Join Events e on e.EventId = edqr.EventId  
 Left Join NotificationOptions unf On unf.UserId=nu.UserId and unf.EventTypeId=3--eventtypeid=3 represents query reminder event
 Left Join NotificationFrequency nf On nf.FrequencyID=unf.FrequencyID  
WHERE   
 qdm.QueryStatusTypeId in (2,4) And (isnull(nf.Days,0) > 0 or ISNULL(unf.Days,0)>0 )
 AND( 
	(lower(nf.Description)<>'every n days' and lower(nf.Description)<>'instant' and isnull(nf.Days,0)>0 and DateDiff(d,q.CreatedAt,GetDate())>= isnull(nf.Days,0))
	OR
	(lower(nf.Description)='every n days' and isnull(unf.Days,0)>0 and DateDiff(d,q.CreatedAt,GetDate())>= isnull(unf.Days,0))
	)
 AND (
		(edqr.EventId is null)
		or 
		( lower(nf.Description)<>'every n days' and lower(nf.Description)<>'instant' and isnull(nf.Days,0)>0 and DateDiff(d,e.EventDateTime,GetDate())>= isnull(nf.Days,0))
		or 
		( lower(nf.Description)='every n days' and isnull(unf.Days,0)>0 and DateDiff(d,e.EventDateTime,GetDate())>= isnull(unf.Days,0))
	)
 AND q.QueryId not in (Select distinct (QueryId) from QueryResultsViewedStatus)
ORDER BY  
 qdm.QueryID,  
 qdm.DataMartID,
 UserID

--SELECT 
--	qdm.*,
--	q.*,
--	u.Username AS CreatedByUsername,
--	ednq.EventId
--FROM 
--	QueriesDataMarts qdm
--	JOIN Queries q ON q.QueryId = qdm.QueryId
--	JOIN Users u ON u.UserId = q.CreatedByUserId
--	LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId and ednq.DatamartId = qdm.DatamartId
--	Left JOIN EventDetailQueryReminder edqr On edqr.QueryId  = qdm.QueryId and edqr.DatamartId = qdm.DatamartId
--	Left Join Events e on e.EventId = edqr.EventId
--WHERE 
--	qdm.QueryStatusTypeId in (2,4) and DateDiff(d,q.CreatedAt,GetDate())> @ReminderOffsetDays
--	AND (edqr.EventId is null or DateDiff(d,e.EventDateTime,GetDate())> @ReminderOffsetDays)
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesByUserAndOrganization]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetQueriesByUserAndOrganization]
@OrganizationId int,
@FromDate datetime = null,
@ToDate datetime = null
AS  
BEGIN  
	
SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
FROM Queries q  
INNER JOIN Users u  
	ON u.UserId = q.CreatedByUserId AND ISNULL(u.IsDeleted,0) = 0 AND ISNULL(q.isdeleted,0) = 0 
LEFT OUTER JOIN Query r ON q.QueryId = r.QueryId
	
WHERE q.QueryId IN 
	(
	SELECT QIds.QueryId
	FROM (SELECT DISTINCT qdm.QueryId 
		FROM DataMarts dm	
			INNER JOIN QueriesDataMarts qdm	ON qdm.DataMartId = dm.DataMartId
		WHERE  dm.OrganizationId = @OrganizationId	AND ISNULL(dm.IsDeleted,0) = 0
		UNION
		SELECT QueryId FROM Queries
		INNER JOIN Users
			ON Users.UserId = Queries.CreatedByUserId 
				AND ISNULL(Users.IsDeleted,0) = 0 AND ISNULL(Queries.isdeleted,0) = 0 AND Users.OrganizationID=@OrganizationId)QIds
	WHERE QIds.QueryId NOT IN(SELECT QueryId FROM QueriesDataMarts WHERE QueryStatusTypeId IN(10, 11, 12)) --Pending QA Approval, Hold, Rejected/Denied
		
	)
	AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesByDataMartId]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesByDataMartId] --8, 0  
 @DataMartId INT,  
 @IsActive bit  
AS  
BEGIN  
	Declare @StatusTable Table (QueryStatusTypeId int)  
	  
	if @IsActive = 1  
	 BEGIN  
	  INSERT INTO @StatusTable Select QueryStatusTypeId from QueryStatusTypes Where QueryStatusTypeId not in (6,7)  
	 END  
	Else   
	 BEGIN  
	  INSERT INTO @StatusTable Select QueryStatusTypeId from QueryStatusTypes Where QueryStatusTypeId not in (7)  
	 END  
	  
	SELECT   
	 qdm.*,  
	 q.*,  
	 u.Username AS CreatedByUsername,  
	 0 as EventId--ednq.EventId //Event Id is not required and so removing the join here.
	,ru.Username as RespondedByUsername
	FROM   
	 QueriesDataMarts qdm  
	 JOIN vw_Query q ON q.QueryId = qdm.QueryId  
	 JOIN Users u ON u.UserId = q.CreatedByUserId  
	 --LEFT JOIN EventDetailNewQuery ednq ON ednq.QueryId = qdm.QueryId AND ednq.DatamartId = qdm.DatamartId  
	 INNER JOIN @StatusTable st  
	 on st.QueryStatusTypeId = qdm.QueryStatusTypeId
	 LEFT JOIN Users ru on ru.UserId = qdm.RespondedBy
	  
	WHERE   
	 qdm.DataMartId = @DataMartId   
	         
	ORDER BY  
	 qdm.QueryId desc  
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesByAdminUserId]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesByAdminUserId] --16,31, 0  
 @AdminUserId INT,  
 @DataMartId INT,  
 @IsActive bit  
AS  
  
Declare @StatusTable Table (QueryStatusTypeId int)  
  
if @IsActive = 1  
 BEGIN  
  INSERT INTO @StatusTable Select QueryStatusTypeId from QueryStatusTypes Where QueryStatusTypeId not in (6,7)  
 END  
Else   
 BEGIN  
  INSERT INTO @StatusTable Select QueryStatusTypeId from QueryStatusTypes Where QueryStatusTypeId not in (7)  
 END  
  
SELECT   
 qdm.*,  
 q.*,  
 u.Username AS CreatedByUsername,  
 0 as EventId--ednq.EventId //Event Id is not required and so removing the join here.  
FROM   
 DataMartNotifications dn  
 INNER JOIN dataMarts d  
 on dn.NotificationUserId = @AdminUserId  
 and d.DataMartId = dn.DataMartId and d.isDeleted = 0  
 INNER JOIN QueriesDataMarts qdm  
 on qdm.DataMartId = dn.DataMartId  
 JOIN vw_Query q ON q.QueryId = qdm.QueryId  
 JOIN Users u ON u.UserId = q.CreatedByUserId  
 INNER JOIN @StatusTable st  
 on st.QueryStatusTypeId = qdm.QueryStatusTypeId  
WHERE   
 (qdm.DataMartId not in (@DataMartId ) and (0 = @DataMartId))  
 or   
 (0 <> @DataMartId and qdm.DataMartId = @DataMartId)  
         
ORDER BY  
 qdm.DatamartId, qdm.QueryId desc
GO
/****** Object:  StoredProcedure [dbo].[uspGetQueriesByAdminUser]    Script Date: 01/05/2012 09:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetQueriesByAdminUser] --65,0,3  
 @AdminUserId INT,    
 @DataMartId INT,    
 @QueryStatusTypeId int,  
 @FromDate datetime = null,  
 @ToDate datetime = null  
AS    
BEGIN    
Declare @StatusTable Table (QueryStatusTypeId int)    
    
if @QueryStatusTypeId = 0    
 BEGIN    
  INSERT INTO @StatusTable Select QueryStatusTypeId from QueryStatusTypes Where QueryStatusTypeId Not In(10,11,12)  
 END    
Else     
 BEGIN    
  INSERT INTO @StatusTable Select @QueryStatusTypeId   
 END    
    
SELECT     
 qdm.*,    
 q.*,    
 u.Username AS CreatedByUsername,    
 0 as EventId--ednq.EventId //Event Id is not required and so removing the join here.,
,ru.Username as RespondedByUsername    
FROM     
 DataMartNotifications dn    
 INNER JOIN dataMarts d    
 on dn.NotificationUserId = @AdminUserId    
 and d.DataMartId = dn.DataMartId and d.isDeleted = 0    
 INNER JOIN QueriesDataMarts qdm    
 on qdm.DataMartId = dn.DataMartId    
 JOIN vw_Query q ON q.QueryId = qdm.QueryId    
 JOIN Users u ON u.UserId = q.CreatedByUserId    
 INNER JOIN @StatusTable st    
 on st.QueryStatusTypeId = qdm.QueryStatusTypeId
 LEFT JOIN Users ru on ru.UserId = qdm.RespondedBy    
WHERE     
 ((qdm.DataMartId not in (@DataMartId ) and (0 = @DataMartId))    
 or     
 (0 <> @DataMartId and qdm.DataMartId = @DataMartId))  
 AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))  
 AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))  
           
ORDER BY    
 qdm.DatamartId, qdm.QueryId desc    
END
GO
/****** Object:  StoredProcedure [dbo].[UspGetDocumentsByIds]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UspGetDocumentsByIds] --'20,2'
(
@ConcatenatedDocIds varchar(1000)	
)

AS BEGIN
	If @ConcatenatedDocIds <> ''
		BEGIN
			SELECT d.DocId,d.Name,d.FileName,d.MimeType, 
			qd.QueryId, rd.ResponseId 
			from Documents d
			Left JOIN QueriesDocuments qd
			on qd.DocId = d.DocId
			Left JOIN ResponsesDocuments rd
			on rd.DocId = d.DocId
			Where d.DocId in (SELECT value from GetValueTableOfDelimittedString(@ConcatenatedDocIds, ','))
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllQueriesForUser]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllQueriesForUser] 
(
@UserId int,
@DataMartId int,
@FromDate datetime = null,
@ToDate datetime = null
)
AS BEGIN

if @DataMartId = 0
	BEGIN
	SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM	Queries q
	INNER JOIN Users u 
	on q.CreatedbyUserId = u.UserId
	and isnull(u.isDeleted,0)  = 0
	and isnull(q.isDeleted,0)  = 0
	LEFT OUTER JOIN Query r on q.QueryId = r.QueryId
	Where CreatedByUserId = @UserId
		AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
		AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	ORDER BY q.QueryId DESC
	END
Else
	BEGIN
	SELECT q.*, u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM	Queries q
	INNER JOIN Users u 
	on q.CreatedbyUserId = u.UserId
	and isnull(u.isDeleted,0)  = 0
	and isnull(q.isDeleted,0)  = 0
	INNER JOIN QueriesDataMarts qd
	on qd.QueryId = q.QueryId
	INNER JOIN DataMarts d
	on d.DataMartId = qd.DataMartId
	and isnull(d.isDeleted,0)  = 0
	LEFT OUTER JOIN Query r on q.QueryId = r.QueryId
	Where CreatedByUserId = @UserId
	and qd.DatamartId = @DataMartId
	AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	ORDER BY q.QueryId DESC
	END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllQueries]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetAllQueries]
(
@DatamartId int,
@FromDate datetime = NULL,
@ToDate datetime = NULL
)
AS BEGIN

If (@DatamartId = 0)
	BEGIN
	SELECT	q.*,u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM	Queries q
	INNER JOIN Users u on
	u.UserId = q.CreatedByUserId
	and isnull(q.isdeleted,0) = 0
	and isnull(u.isdeleted,0) = 0
	LEFT OUTER JOIN Query r on q.QueryId = r.QueryId
	WHERE CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
		AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	ORDER BY q.QueryId
	END
Else
	BEGIN
	SELECT	q.*,u.UserName as CreatedByUsername, dbo.GetQueryStatus(q.QueryId) as QueryStatus, r.Comment
	FROM	Queries q
	INNER JOIN Users u on
	u.UserId = q.CreatedByUserId
	and isnull(q.isdeleted,0) = 0
	and isnull(u.isdeleted,0) = 0
	INNER JOIN QueriesDataMarts qd
	on qd.QueryId = q.QueryId
	INNER JOIN DataMarts d
	on d.DataMartId  = qd.DataMartId
	and isnull(d.isdeleted,0) = 0
	LEFT OUTER JOIN Query r
	on q.QueryId = r.QueryId
	Where qd.DataMartId = @DatamartId
		AND CONVERT(CHAR(8), q.CreatedAt, 112) >= ISNULL(@FromDate, CONVERT(CHAR(8), q.CreatedAt, 112))
		AND CONVERT(CHAR(8), q.CreatedAt, 112) <= ISNULL(@ToDate, CONVERT(CHAR(8), q.CreatedAt, 112))
	ORDER BY q.QueryId
	END

END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteUnMappedDocuments]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteUnMappedDocuments]
AS BEGIN
-- Delete all unmapped documents date difference > 0
	Delete from Documents 
	Where DateDiff(d,DateAdded,GetDate()) > 0
	and docId not in (Select distinct(DocId) from QueriesDocuments) 
	and docId not in (Select distinct(DocId) from ResponsesDocuments)  
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteResponse]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteResponse]
(
	@ResponseId int
)
AS BEGIN
			
			Delete From ResponsesDocuments Where ResponseId = @ResponseId
			Delete From Responses Where ResponseId = @ResponseId			
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddQueryDataMarts]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspAddQueryDataMarts] --1,10
(
@QueryId int,
@DataMartIdList Varchar(1000)
)
AS BEGIN
	IF @DataMartIdList IS NOT NULL  
		BEGIN  
		 Declare @TempTable  table (Id int, Value varchar(10))
		 Insert into @TempTable Select Id, value from GetValueTableOfDelimittedString (@DataMartIdList,',') 
		 DECLARE @CurrentStatus INT
		 SET @CurrentStatus = -1
		 Declare @MaxCount int
		 DEclare @counter int
		 Set @counter = 1
		 Select @MaxCount = Count(*) from @TempTable
			While (@Counter <= @MaxCount)
			BEGIN
				Declare @DataMartId int
				Declare @QueryDataMartStatusId int
				SELECT TOP(1) @CurrentStatus = QueryStatusTypeId FROM QueriesDataMarts WHERE QueryId = @QueryId AND QueryStatusTypeId IN(10, 11)
				Select @DataMartId = value from @TempTable Where Id = @Counter
				Select @QueryDataMartStatusId = QueryStatusTypeId  from QueriesDataMarts Where QueryId = @QueryId and DataMartId = @DataMartId
				Set @Counter = @Counter +1
				If ( @QueryDataMartStatusId is null or @QueryDataMartStatusId  = 0 )
					BEGIN
						IF @CurrentStatus = 10 OR @CurrentStatus = 11
							BEGIN
								INSERT INTO QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId, RequestTime) 
								VALUES (@QueryId,@DataMartId,@CurrentStatus, GetDate())
							END
						ELSE
							BEGIN		
								INSERT INTO QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId, RequestTime) 
								VALUES (@QueryId,@DataMartId,1, GetDate())						
							END
					END
				ELSE IF (@QueryDataMartStatusId > 0 and @QueryDataMartStatusId > 5 and @QueryDataMartStatusId < 8)
					BEGIN
						IF @CurrentStatus = 10 OR @CurrentStatus = 11
							BEGIN
								Update QueriesDataMarts Set QueryStatusTypeId = @CurrentStatus Where QueryId = @QueryId and DataMartId = @DataMartId
							END
						ELSE
							BEGIN
								Update QueriesDataMarts Set QueryStatusTypeId = 1 Where QueryId = @QueryId and DataMartId = @DataMartId				
							END
					END 

				IF @@Error = 0
					BEGIN
						IF @CurrentStatus <> 10 AND @CurrentStatus <> 11
						BEGIN
							--Raise event for the newly added Data Mart
							Declare @Event Table (EventId int)
							Insert @Event Exec uspCreateNewEvent 1, 1, @QueryId, @DataMartId

							Declare @EventIdVariable int
							Select @EventIdVariable = EventId from @Event

							if  (@EventIdVariable) > 0
								BEGIN
									--Set Notification if Added DataMart is client based
									Declare @DataMartTypeId int
										Select @DataMartTypeId = DataMartTypeId from DataMarts Where DataMartId = @DataMartId
										if (@DataMartTypeId = 1)
											BEGIN								
												  INSERT INTO Notifications(NotificationTypeId,UserId,EventId,GeneratedTime)  
												  SELECT 1,dn.NotificationUserId,@EventIdVariable,GetDate() From DataMartNotifications dn
													INNER JOIN NotificationOptions no on dn.NotificationUserId = no.UserId 
													and EventTypeId = 1 and NotificationTypeId = 1
													Where dn.DataMartId = @DataMartId
												  
											END		
								END
						END
					END
				Else
					Break
			END
		 
		END  

END
GO
/****** Object:  StoredProcedure [dbo].[uspAddDocumentToResponse]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAddDocumentToResponse] 
(
	@ResponseId int,	
	@FileContent Image,
	@Name varchar(255),
	@FileName varchar(255),
	@MimeType varchar(255)
)
AS BEGIN
			Declare @DocId int 
			Set @DocId = 0		
			INSERT INTO Documents (Name, FileName,MimeType, DocumentContent, DateAdded) values (@Name, @FileName, @MimeType,@FileContent, GetDate())
			Set @DocId = Scope_Identity()

			if (@DocId > 0)
				BEGIN
					INSERT INTO ResponsesDocuments (DocId, ResponseId) values (@DocId,@ResponseId)
					Select @DocId
				END
			Else
				BEGIN
					Delete From ResponsesDocuments Where ResponseId = @ResponseId
					Delete From Responses Where ResponseId = @ResponseId
					Select -101 --Denotes error while saving to database
				END		
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddDocumentResponseMap]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAddDocumentResponseMap] 
(
	@ResponseId int,	
	@DocumentId int
)
AS BEGIN
			
	if (@DocumentId > 0)
		BEGIN
			INSERT INTO ResponsesDocuments (DocId, ResponseId) values (@DocumentId,@ResponseId)
			Select @DocumentId
		END
	Else
		BEGIN
			Delete From ResponsesDocuments Where ResponseId = @ResponseId
			Delete From Responses Where ResponseId = @ResponseId
			Select -101 --Denotes error while deleting from Database
		END		
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspAddDataMartToQuery]    Script Date: 01/05/2012 09:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspAddDataMartToQuery] --1,31,6
(
@QueryId int,
@DataMartIdTobeCancelled int,
@DataMartIdTobeAdded int
)
AS BEGIN
If @DataMartIdTobeAdded > 0
	BEGIN

		Declare @QueryDataMartStatusId int
		DECLARE @CurrentStatus INT
		SET @CurrentStatus = -1
		Set @QueryDataMartStatusId = 0
		Select @QueryDataMartStatusId = QueryStatusTypeId From QueriesDataMarts Where QueryId= @QueryId and DataMartId = @DataMartIdTobeAdded 
		
		SELECT TOP(1) @CurrentStatus = QueryStatusTypeId FROM QueriesDataMarts WHERE QueryId = @QueryId AND QueryStatusTypeId IN(10, 11)
		
		--If query Exists in Cancelled or Deleted state, reset it back to pending		
		 if ( @QueryDataMartStatusId is null or @QueryDataMartStatusId  = 0 )
			BEGIN
				IF @CurrentStatus = 10 OR @CurrentStatus = 11
					BEGIN
						INSERT INTO QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId, RequestTime) 
						VALUES (@QueryId,@DataMartIdTobeAdded,@CurrentStatus, GetDate())
					END
				ELSE
					BEGIN
						INSERT INTO QueriesDataMarts (QueryId,DataMartId,QueryStatusTypeId, RequestTime) 
						VALUES (@QueryId,@DataMartIdTobeAdded,1, GetDate())
					END
				--Raise event for the newly added Data Mart			
			END 
		IF (@QueryDataMartStatusId > 0 and @QueryDataMartStatusId > 5 and @QueryDataMartStatusId < 8)
			BEGIN
				IF @CurrentStatus = 10 OR @CurrentStatus = 11
					BEGIN
						Update QueriesDataMarts Set QueryStatusTypeId = @CurrentStatus Where QueryId = @QueryId and DataMartId = @DataMartIdTobeAdded				
					END
				ELSE
					BEGIN
						Update QueriesDataMarts Set QueryStatusTypeId = 1 Where QueryId = @QueryId and DataMartId = @DataMartIdTobeAdded				
					END
			END

		IF @@Error = 0
					BEGIN
						IF @CurrentStatus <> 10 AND @CurrentStatus <> 11
						BEGIN
							--Raise event for the newly added Data Mart
							Declare @Event Table (EventId int)
							Insert @Event Exec uspCreateNewEvent 1, 1, @QueryId, @DataMartIdTobeAdded
							Declare @EventIdVariable int
							Select @EventIdVariable = EventId from @Event
							if  (@EventIdVariable) > 0
								BEGIN
									--Set Notification if Added DataMart is client based
									Declare @DataMartTypeId int
										Select @DataMartTypeId = DataMartTypeId from DataMarts Where DataMartId = @DataMartIdTobeAdded
										if (@DataMartTypeId = 1)
											BEGIN								
												  INSERT INTO Notifications(NotificationTypeId,UserId,EventId,GeneratedTime)  
												  SELECT 1,dn.NotificationUserId,@EventIdVariable,GetDate() From DataMartNotifications dn
													INNER JOIN NotificationOptions no on dn.NotificationUserId = no.UserId 
													and EventTypeId = 1 and NotificationTypeId = 1
													Where dn.DataMartId = @DataMartIdTobeAdded
												  
											END		
								END
						END
					END
				Else
					return
	END

If @DataMartIdTobeCancelled > 0
	Update QueriesDataMarts Set QueryStatusTypeId = 6 Where QueryId = @QueryId and DataMartId = @DataMartIdTobeCancelled 
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeleteExpiredFiles]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeleteExpiredFiles] --21
(
@DocumentValidityPeriod int
)
AS BEGIN

--Set the document content to ''(i.e by default it will be set to '0X') for 
--those documents that are older than the validity period
Update Documents Set DocumentContent = '' Where DocId in
(SELECT d.DocId From ResponsesDocuments rd
INNER JOIN documents d
on d.DocId = rd.DocId and
DateDiff(d,dateAdded,GetDate())  > @DocumentValidityPeriod)

--Set the IsDeleted Flag for those responses (for file distribution queries) 
--that are older than the validity period
Update responses set IsDeleted = 1 where ResponseId in 
(SELECT rd.ResponseId From documents d
 INNER JOIN ResponsesDocuments rd
on d.DocId = rd.DocId and
DateDiff(d,dateAdded,GetDate()) > @DocumentValidityPeriod)

END
GO
/****** Object:  StoredProcedure [dbo].[UspDeleteDocumentsByIds]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UspDeleteDocumentsByIds] --'53,55'
(
@ConcatenatedDocIds varchar(1000)	
)

AS BEGIN
	If @ConcatenatedDocIds <> ''
		BEGIN
			Delete from QueriesDocuments Where DocId in (SELECT value from GetValueTableOfDelimittedString(@ConcatenatedDocIds, ','))
			if @@Error = 0
				Delete from ResponsesDocuments Where DocId in (SELECT value from GetValueTableOfDelimittedString(@ConcatenatedDocIds, ','))
					if @@Error = 0
						Delete from Documents Where DocId in (SELECT value from GetValueTableOfDelimittedString(@ConcatenatedDocIds, ','))
			Select @@Error
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspCleanUpData]    Script Date: 01/05/2012 09:23:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCleanUpData] 
(
@QueryValidityPeriod int,
@DocumentValidityPeriod int
)
AS BEGIN
	Exec uspDeleteUnMappedDocuments
	Exec uspDeleteExpiredFiles @DocumentValidityPeriod
	Exec uspDeleteExpiredQueries @QueryValidityPeriod
END
GO