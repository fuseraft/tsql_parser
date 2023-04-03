#   __               .__
# _/  |_  ___________|  |           ___________ _______  ______ ___________
# \   __\/  ___/ ____/  |    ______ \____ \__  \\_  __ \/  ___// __ \_  __ \
#  |  |  \___ < <_|  |  |__ /_____/ |  |_> > __ \|  | \/\___ \\  ___/|  | \/
#  |__| /____  >__   |____/         |   __(____  /__|  /____  >\___  >__|
#            \/   |__|              |__|       \/           \/     \/
#
# A very light-weight T-SQL parser and formatter.
#
# github.com/scstauf
#
# path:
#   parsing/keyword.rb
# object:
#   TSqlParser::Parsing::Keyword

module TSqlParser::Parsing
  class Keyword
    def self.get_keywords
      [].concat(self.get_reserved_keywords)
        .concat(self.get_special_variables)
        .concat(self.get_functions)
        .concat(self.get_types)
    end

    def self.get_new_node_keywords
      %w[CREATE ALTER DROP RENAME SELECT INSERT UPDATE DELETE WHILE IF ELSE DECLARE SET WITH BEGIN FROM WHERE INNER LEFT JOIN END GO GROUP ORDER CASE PRINT RETURN GOTO OPEN CLOSE DEALLOCATE FETCH USE EXEC] \
        - %w[WITH LEFT RIGHT]
    end

    def self.get_begin_keyword
      "BEGIN"
    end

    def self.get_end_keyword
      "END"
    end

    def self.get_join_keywords
      %w[INNER OUTER LEFT RIGHT FULL CROSS JOIN]
    end

    def self.get_join_type_keywords
      %w[INNER LEFT RIGHT CROSS FULL]
    end

    def self.get_newline_keywords
      %w[INSERT UPDATE DELETE SELECT CREATE IF RETURN PRINT WHILE]
    end

    def self.get_reserved_keywords
      %w[ADD ALL ALTER AND ANY AS ASC AUTHORIZATION BACKUP BEGIN BETWEEN BREAK BROWSE BULK BY CASCADE CASE CHECK CHECKPOINT CLOSE CLUSTERED COALESCE COLLATE COLUMN COMMIT COMPUTE CONSTRAINT CONTAINS CONTAINSTABLE CONTINUE CONVERT CREATE CROSS CURRENT CURRENT_DATE CURRENT_TIME CURRENT_TIMESTAMP CURRENT_USER CURSOR DATABASE DBCC DEALLOCATE DECLARE DEFAULT DELETE DENY DESC DISK DISTINCT DISTRIBUTED DOUBLE DROP DUMP ELSE END ERRLVL ESCAPE EXCEPT EXEC EXECUTE EXISTS EXIT EXTERNAL FETCH FILE FILLFACTOR FOR FOREIGN FREETEXT FREETEXTTABLE FROM FULL FUNCTION GOTO GRANT GROUP HAVING HOLDLOCK IDENTITY IDENTITY_INSERT IDENTITYCOL IF IN INDEX INNER INSERT INTERSECT INTO IS JOIN KEY KILL LEFT LIKE LINENO LOAD MERGE NATIONAL NOCHECK NONCLUSTERED NOT NULL NULLIF OF OFF OFFSETS ON OPEN OPENDATASOURCE OPENQUERY OPENROWSET OPENXML OPTION OR ORDER OUTER OVER PERCENT PIVOT PLAN PRECISION PRIMARY PRINT PROC PROCEDURE PUBLIC RAISERROR READ READTEXT RECONFIGURE REFERENCES REPLICATION RESTORE RESTRICT RETURN REVERT REVOKE RIGHT ROLLBACK ROWCOUNT ROWGUIDCOL RULE SAVE SCHEMA SECURITYAUDIT SELECT SEMANTICKEYPHRASETABLE SEMANTICSIMILARITYDETAILSTABLE SEMANTICSIMILARITYTABLE SESSION_USER SET SETUSER SHUTDOWN SOME STATISTICS SYSTEM_USER TABLE TABLESAMPLE TEXTSIZE THEN TO TOP TRAN TRANSACTION TRIGGER TRUNCATE TRY_CONVERT TSEQUAL UNION UNIQUE UNPIVOT UPDATE UPDATETEXT USE USER VALUES VARYING VIEW WAITFOR WHEN WHERE WHILE WITH WITHIN WRITETEXT]
    end

    def self.get_special_variables
      %w[@@ERROR @@FETCH_STATUS @@IDENTITY @@LOCK_TIMEOUT @@NESTLEVEL @@ROWCOUNT @@SERVERNAME @@SPID @@SQLSTATUS @@TRANCOUNT @@VERSION]
    end

    def self.get_types
      %w[BIGINT BINARY BIT CHAR CURSOR DATE DATETIME DATETIME2 DATETIMEOFFSET DECIMAL FLOAT HIERARCHYID IMAGE INT MONEY NCHAR NTEXT NUMERIC NVARCHAR REAL ROWVERSION SMALLDATETIME SMALLINT SMALLMONEY SQL_VARIANT TABLE TEXT TIME TINYINT UNIQUEIDENTIFIER VARBINARY VARCHAR XML]
    end

    def self.get_functions
      [].concat(self.get_math_functions)
        .concat(self.get_conversion_functions)
        .concat(self.get_string_functions)
        .concat(self.get_aggregate_functions)
        .concat(self.get_date_functions)
    end

    # Functions

    def self.get_math_functions
      %w[ABS ACOS ASIN ATAN ATN2 CEILING COS COT DEGREES EXP FLOOR LOG LOG10 PI POWER RADIANS RAND ROUND SIGN SIN SQRT SQUARE TAN]
    end

    def self.get_conversion_functions
      %w[CAST CONVERT PARSE TRY_CAST TRY_CONVERT TRY_PARSE]
    end

    def self.get_string_functions
      %w[ASCII CHAR CHARINDEX CONCAT CONCAT_WS DIFFERENCE FORMAT LEFT LEN LOWER LTRIM NCHAR PATINDEX QUOTENAME REPLACE REPLICATE REVERSE RIGHT RTRIM SOUNDEX SPACE STR STRING_AGG STRING_ESCAPE STRING_SPLIT STUFF SUBSTRING TRANSLATE TRIM UNICODE UPPER]
    end

    def self.get_aggregate_functions
      %w[APPROX_COUNT_DISTINCT AVG CHECKSUM_AGG COUNT COUNT_BIG GROUPING GROUPING_ID MAX MIN STDEV STDEVP STRING_AGG SUM VAR VARP]
    end

    def self.get_date_functions
      %w[CURRENT_TIMESTAMP CURRENT_TIMEZONE CURRENT_TIMEZONE_ID DATE_BUCKET DATEADD DATEDIFF DATEDIFF_BIG DATEFROMPARTS DATENAME DATEPART DATETIME2FROMPARTS DATETIMEFROMPARTS DATETIMEOFFSETFROMPARTS DATETRUNC DAY EOMONTH FORMAT GETDATE GETUTCDATE ISDATE MONTH SMALLDATETIMEFROMPARTS SWITCHOFFSET SYSDATETIME SYSDATETIMEOFFSET SYSUTCDATETIME TIMEFROMPARTS TODATETIMEOFFSET YEAR]
    end
  end
end
