/* Pyramid */
-- Main table containing all Pyramid data (no data is deleted)
SELECT * FROM Pyramid
-- Additional fields:
SELECT TOP 10000
  [Pyramid Asset Code]
  ,dtCreationDate -- Creation Date of the asset
  ,dtModifyDate -- Modification Date - only by BASE or New Leases Load
  ,dtLastModif -- Date of Last modification - any modification made to asset (i.e. not only by data loads)
  ,is_child -- ARA child flag - based on Family_types table
  ,creation_source -- 1 = BASE, 2 = New Leases, 3 = Customer Portal (obsolete)
  ,modifiedBy -- same as above
  ,[Correct Equipment Type]  -- correction of Eq. type, as some assets sometimes have incorrect one (manually, i.e. only when spotted)
  ,asset_code_of_parent -- Pyramid Asset Code of asset that ARA chose as parent for this asset (which has to be child)
  ,dtMapDate -- date when the asset had parent assigned
  ,match_rule -- number representing which specific mapping assigned the parent (two decimal:
				-- first digit represents in which combination of columns does the mapping occur (Schedule Number, PO Number, Invoice, WBS, Location)
				-- second digit represents what mapping type has been used (on equipment type, description or special equipment type)
				-- example: 10 - 1 = SPIWL, 0 = equipment type
  ,correct_serial_number -- if child has no SN, then ARA will assign one based on SN of parent + numeric postfix (example: SGH65202YL-03)
  ,reported -- 1 if asset has been submitted already
  ,Reported_Date -- date when a submission has been sent for this asset
  ,ID -- Automatically assigned ID on load
  ,idAraAccount -- ID from Account_regions table - assigned based on Mapping_Customer_Codes or Mapping_Schedule_Number
  ,idPyrAccount -- ID from Account_regions table - assigned previously based on already filled Responsible Entity Name
  ,idAccount -- computed column = idAraAccount, if null then idPyrAccount
  ,cost_new -- AAR calculated RLS based on Remaining Term, Pyramid Average Montly Rental and actual Currency rate
  dtActive -- date when the record has been present in data load source (set also for ignored records)

  -- obsolete columns
  ,matched -- used to show if asset has been found in ITAM databases (= 1), now only shows that a child has been mapped (= 2)
  ,statusPyr -- if parent assigned in Pyramid (Pyramid Asset Group <> Pyramid Asset Code) was matched, this field reflected this on all children
  ,cost -- first column used for calculating RLS in ARA
  ,source_of_match -- used for identifying specifif ITAM DB where the asset has been found
  ,dtMatchDate -- when ARA found the asset in ITAM DB
  ,[Correct Responsible Entity Name] -- originally used to correct REN (before using Account_regions table)
  ,mark_for_report -- originally used for flagging assets to report (before using Mark_for_report table)
  ,idESL , idCMDB, idDOMS -- IDs of records in those DBs, used when ARA did matching in ITAM Dbs
FROM Pyramid



/* Pyramid_hist */
-- Historical data from Pyramid (when an update by a Load is performed - changes on ARA fields are not reflected here)
SELECT * FROM Pyramid_hist WHERE ID = 12345789 ORDER BY dtHistCreationDate asc
-- Only changed data are stored



/* Family_Types */
-- Setting is_child flag based on equipment type
-- it_rev_gen column = flag indicating if the type is revenue generating type
SELECT * FROM Family_types


/* Currency_Rates */
-- Exchange rates to USD, used to calculate cost_new (i.e. ARA calculated RLS)
SELECT * FROM Currency_rates


/* Account_regions */
-- List of Customer names (Reposnible Entity Names in Pyramid)
SELECT * FROM Account_regions



/* Mapping_Customer_Code */
-- Used in procedure sp_set_REN to assign Responsible Entity Name based on Customer Code
SELECT * FROM Mapping_Customer_Code



/* Mapping_Schedule_Number */
-- Used in procedure sp_set_REN to assign Responsible Entity Name based on presence of a string in Schedule Number
SELECT * FROM Mapping_Schedule_Number


/* Mapping_End_User_Name */
-- Used in procedure sp_set_REN to assign Responsible Entity Name based on presence of a string in End User Name
SELECT * FROM Mapping_End_User_Name



/* Mapping_Regions */
-- Used in views and submissions to map Pyramid Regions to base regions (EMEA, APJ, AMS)
SELECT * FROM Mapping_regions



/* Mapping_brand */
-- Used in mapping procedures to restrict assigning parent from wrong manufacturer (i.e. Cisco switch cannot have HP gbic module)
SELECT * FROM Mapping_brand



/* Mapping_type */
-- Rules for mapping between parent's equipment type and child's eq. type
SELECT * FROM Mapping_type ORDER BY child_eq_type, priority



/* Mapping_desc */
-- Rules for mapping between parent's equipment type and part of child's description
SELECT * FROM Mapping_desc ORDER BY child_eq_type, priority



/* Mapping_type_spcl */
-- table containg child's equipment types, that can be mapped to any parent
SELECT * FROM Mapping_type_spcl



/* Mark_for_report */
-- Auxiliary table used to store some basic fields used in later in submissions
SELECT * FROM Mark_for_report



/* Pyramid_tmp_XYZ */
-- staging tables for data loads (XYZ in (BASE, NL), where BASE = Monthly Pyramid Export, NL = Weekle New Leases)
-- Tables are truncated before every load, and then used for transforming the data into Pyramid table
SELECT * FROM Pyramid_tmp_NL


/* Reported_hist */
-- used to store previously reported assets, where there was a need for resubmitting (i.e. no change has been performed on HPFS side in last 3 months)
SELECT TOP 100 * FROM Reported_hist



/* amiProcessMain */
-- List of each process (= interface) used for monitoring (used either in stored  procedure, or by AR_TaskHandler application)
SELECT * FROM amiProcessMain


/* amiProcess */
-- Specific run of the process with its start date, end date, count of records affected and final status
-- More "user friendly" for checking status of process is however view v_Monitoring
SELECT TOP 100 * FROM amiProcess ORDER BY dtStart desc

