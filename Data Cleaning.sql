# uszips.csv sourced from https://simplemaps.com/data/us-zips
# This didn't
# change even after living in Seattle for a few years, where you can drive down SODO's
# industrial district, and be in the middle of Seattle's International District within a few
# minutes (depending on traffic!).
# Above saved for readme

use parcel_data;

# Drop 'major', 'minor' columns
alter table kcparcels
    drop column MAJOR;

alter table kcparcels
    drop column MINOR;

# Set OBJECTID as primary key for kcparcels
alter table kcparcels
    add primary key (OBJECTID);

# Create sitetype description table
create table site_types
(
    id          varchar(50),
    description varchar(255),
    PRIMARY KEY (id)
);

# Populate site_types table
insert site_types(id)
select distinct SITETYPE
from kcparcels;

# Set SITETYPE data type to varchar
alter table kcparcels
    modify SITETYPE varchar(50);

# Add foreign key to kcparcels
alter table kcparcels
    add foreign key (SITETYPE) references site_types (id);

# Add missing site_type classifiers
insert into site_types
values ('V', 'Vacant');

insert into site_types
values ('E', 'Easement');

insert into site_types
values ('PL', 'Parking Lot');

# Update SITETYPE for rows where SITETYPE is null using info from PREUSE_DESC
update kcparcels
set SITETYPE = 'V'
where PREUSE_DESC like '%vacant%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'U1'
where PREUSE_DESC like '%utility%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'R1'
where PREUSE_DESC like '%Single Family%'
   or PREUSE_DESC like '%houseboat%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'R2'
where PREUSE_DESC like '%Apartment%'
   or PREUSE_DESC like '%triplex%'
   or PREUSE_DESC like '%duplex%'
   or PREUSE_DESC like '%condo%'
   or PREUSE_DESC like '%4-plex%'
   or PREUSE_DESC like '%rooming house%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'E'
where PREUSE_DESC like '%easement%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'P4'
where PREUSE_DESC like '%school%'
   or PREUSE_DESC like '%dorm%'
   or PREUSE_DESC like '%daycare%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'PL'
where PREUSE_DESC like '%parking%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'DV'
where PREUSE_DESC like 'Townhouse Plat'
   or PREUSE_DESC like '%open space%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'P8'
where PREUSE_DESC like '%park, public%'
   or PREUSE_DESC like '%river/creek/stream%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'C1'
where PREUSE_DESC like '%office building%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'P2'
where PREUSE_DESC like '%medical/dental%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'P3'
where PREUSE_DESC like '%church/welfare%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'R3'
where PREUSE_DESC like '%mobile home%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'C1'
where PREUSE_DESC like '%retail store%'
   or PREUSE_DESC like '%restaurant%'
   or PREUSE_DESC like '%conv store without gas%'
   or PREUSE_DESC like '%service building%'
   or PREUSE_DESC like '%shopping ctr%'
   or PREUSE_DESC like '%terminal%'
   or PREUSE_DESC like '%golf course%'
   or PREUSE_DESC like '%retail%'
   or PREUSE_DESC like '%bank%'
   or PREUSE_DESC like '%sport facility%'
   or PREUSE_DESC like '%marina%'
   or PREUSE_DESC like '%shell structure%'
   or PREUSE_DESC like '%auto showroom%'
   or PREUSE_DESC like '%vet/animal control%'
   or PREUSE_DESC like '%historic prop%'
   or PREUSE_DESC like '%hotel/motel%'
   or PREUSE_DESC like '%health club%'
   or PREUSE_DESC like '%grocery store%'
   or PREUSE_DESC like '%service station%'
   or PREUSE_DESC like '%conv store with gas%'
   or PREUSE_DESC like '%high tech%'
   or PREUSE_DESC like '%tavern%'
   or PREUSE_DESC like '%car wash%'
   or PREUSE_DESC like '%gas station%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'P2'
where PREUSE_DESC like '%retirement facility%'
   or PREUSE_DESC like '%hospital%'
   or PREUSE_DESC like '%nursing home%'
   or PREUSE_DESC like '%group home%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = '98'
where PREUSE_DESC like '%transferable dev rights'
   or PREUSE_DESC like '%tideland%'
   or PREUSE_DESC like '%park, private%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'P0'
where PREUSE_DESC like '%Mortuary/Cemetery/Crematory%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'P8'
where PREUSE_DESC like '%reserve/wilderness%'
   or PREUSE_DESC like '%auditorium%'
   or PREUSE_DESC like '%art gallery%'
   or PREUSE_DESC like '%water body%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'P1'
where PREUSE_DESC like '%governmental service%'
   or PREUSE_DESC like '%post office%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'I1'
where PREUSE_DESC like '%industrial%'
   or PREUSE_DESC like '%mining/quarry%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'C9'
where PREUSE_DESC like '%warehouse%'
   or PREUSE_DESC like '%greenhse%'
    and SITETYPE is null;

update kcparcels
set SITETYPE = 'CL'
where PREUSE_DESC like '%lodge%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'CF'
where PREUSE_DESC like '%farm%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'B4'
where PREUSE_DESC like '%campground%'
  and SITETYPE is null;

update kcparcels
set SITETYPE = 'R3'
where LEGALDESC like '%mobile%';

delete
from kcparcels
where SITETYPE is null
  and PREUSE_DESC is null;

# Create table to hold address info (Shouldn't have done this)
create table addresses
(
    object_id       int primary key,
    housenum        int,
    dir_prefix      varchar(50),
    street_type     varchar(50),
    street_name     varchar(50),
    strtype_suffix  varchar(50),
    dir_suffix      varchar(50),
    address         varchar(255),
    zip5            int,
    zip_ext         int,
    cityname        varchar(100),
    cityname_postal varchar(100),
    KCTP_city       varchar(100),
    foreign key (object_id) references kcparcels (OBJECTID)
);


# Insert address info from kcparcels into addresses
insert into addresses
select OBJECTID,
       ADDR_HN,
       ADDR_PD,
       ADDR_PT,
       ADDR_SN,
       ADDR_ST,
       ADDR_SD,
       ADDR_FULL,
       ZIP5,
       PLUS4,
       CTYNAME,
       POSTALCTYNAME,
       KCTP_CITY
from kcparcels;

# Drop address info from kcparcels
alter table kcparcels
    drop ADDR_HN,
    drop ADDR_PD,
    drop ADDR_PT,
    drop ADDR_SN,
    drop ADDR_ST,
    drop ADDR_SD,
    drop FULLNAME,
    drop ZIP5,
    drop PLUS4,
    drop CTYNAME,
    drop POSTALCTYNAME,
    drop KCTP_CITY,
    drop ADDR_FULL,
    drop ADDR_NUM;

# Drop unused columns from kcparcels
alter table kcparcels
    drop ALIAS1,
    drop ALIAS2,
    drop SITEID,
    drop LAT,
    drop LON,
    drop POINT_X,
    drop POINT_Y,
    drop kroll,
    drop PLSS,
    drop PLAT_LOT,
    drop PLAT_BLOCK,
    drop TAXVAL_RSN,
    drop APPRLNDVAL,
    drop Shape_Length,
    drop Shape_Area,
    drop ANNEXING_CITY,
    drop COUNTY;

# Append PROP_NAME into addresses
update addresses
set name = (
    select PROP_NAME
    from kcparcels
    where object_id = kcparcels.OBJECTID
);

# Drop prop_name from main table
alter table kcparcels
    drop PROP_NAME;

alter table kcparcels
    drop KCTP_STATE,
    drop LEVY_JURIS;

#***** Created levycodes.csv from raw data using python
# import levycodes.csv
create table levycodes
(
    levycode   int unique,
    levyrate   double,
    seniorrate double,
    primary key (levycode)
);

# Identify which levycodes are not present in levycodes table
# *******************************DISCOVERY: Parcels in Kent had a significant number of missing levycode information
select distinct LEVYCODE, PREUSE_DESC, a.cityname, a.cityname_postal, count(cityname)
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
where LEVYCODE not in (
    select levycode
    from levycodes
)
group by cityname
order by count(cityname) desc;

select OBJECTID, PREUSE_DESC, a.cityname, LEVYCODE
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
where LEVYCODE not in (
    select levycode
    from levycodes
);

# Fill in missing levycodes information using cityname data
update kcparcels
set LEVYCODE = 1526
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'KENT'
)
    and LEVYCODE is null
   or LEVYCODE = 0;

update kcparcels
set LEVYCODE = 2100
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'renton'
)
    and LEVYCODE is null
   or LEVYCODE = 0;

update kcparcels
set LEVYCODE = 1526
where LEVYCODE not in (
    select levycode
    from levycodes
)
  and OBJECTID in (
    select object_id
    from addresses
    where cityname = 'Kent'
);

# Fix above mistake where all incorrect values were set to 1526
update kcparcels
set LEVYCODE = 2100
where LEVYCODE = 1526
  and OBJECTID in (
    select object_id
    from addresses
    where cityname = 'Renton'
);

# Figure out which cities were incorrectly labeled from previous mistake
select cityname, count(cityname)
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
where cityname <> 'Kent'
  and LEVYCODE = 1526
group by cityname
order by count(cityname) desc;

select LEVYCODE, count(LEVYCODE)
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
where cityname = 'woodinville'
group by LEVYCODE;

# Correct last of mislabeled levycodes
update kcparcels
set LEVYCODE = 2505
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'woodinville'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0851
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'bothell'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1064
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'covington'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0133
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'AUBURN'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1442
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'KENMORE'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 2025
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'REDMOND'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1405
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'ISSAQUAH'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 2202
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'SAMMAMISH'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0010
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'SEATTLE'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0937
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'BURIEN'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 2263
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'SHORELINE'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1872
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'NEWCASTLE'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1031
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'MERCER ISLAND'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 2413
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'TUKWILA'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0330
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'BELLEVUE'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 0051
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'ALGONA'
)
  and LEVYCODE = 1526;

update kcparcels
set LEVYCODE = 1701
where OBJECTID in (
    select object_id
    from addresses
    where cityname = 'KIRKLAND'
)
  and LEVYCODE = 1526;

# Create relationship between levycode and main table
alter table kcparcels
    add foreign key (LEVYCODE) references levycodes (levycode);

# Add levijuris from kcparcels to levycodes
# **NOTE: Should have looked for this earlier, could have automated above steps (didn't need multiple 'updates')
# e.g. set LEVYCODE = l.levycode where a.city = k.levy_juris
alter table levycodes
    add levycity varchar(50);

update levycodes l
    inner join kcparcels k on l.levycode = k.LEVYCODE
set l.levycity = k.LEVY_JURIS;

# Remove redundant rows from kcparcels
alter table kcparcels
    drop LEVY_JURIS;

# Create details table to further reduce kcparcels (one-to-one relationship)
# NOTE: text has a fixed size of 65,535 while varchar has a max size of 65,535

# Shouldn't have done this either
create table details
(
    object_id     int primary key,
    parcel_num    double,
    comments      varchar(255),
    plat_name     varchar(255),
    new_constr    text,
    acct_num      double,
    taxyr         int,
    qtr_sect      text,
    plss_sect     int,
    plss_township int,
    plss_range    int,
    legal_desc    text,
    paa_name      varchar(255),
    proptype      text,
    kca_zoning    varchar(50),
    kca_acres     double,
    preuse_code   int,
    preuse_desc   varchar(50)
);

# Populate details table
insert into details
select OBJECTID,
       PIN,
       COMMENTS,
       PLAT_NAME,
       NEW_CONSTR,
       ACCNT_NUM,
       KCTP_TAXYR,
       QTS,
       SEC,
       TWP,
       RNG,
       LEGALDESC,
       PAAUNIQUENAME,
       PROPTYPE,
       KCA_ZONING,
       KCA_ACRES,
       PREUSE_CODE,
       PREUSE_DESC
from kcparcels;

# Drop primary_addr, kctp_state, and above fields from kcparcels
alter table kcparcels
    drop PIN,
    drop COMMENTS,
    drop PLAT_NAME,
    drop NEW_CONSTR,
    drop ACCNT_NUM,
    drop KCTP_TAXYR,
    drop QTS,
    drop SEC,
    drop TWP,
    drop RNG,
    drop LEGALDESC,
    drop PAAUNIQUENAME,
    drop PROPTYPE,
    drop KCA_ZONING,
    drop KCA_ACRES,
    drop PREUSE_CODE,
    drop PREUSE_DESC,
    drop PRIMARY_ADDR,
    drop KCTP_STATE;

# Add UNIT_NUM, BLDG_NUM, CONDOSITUS to addresses
alter table addresses
    add unit_num     varchar(100),
    add building_num varchar(100),
    add condo_addr   text;

update addresses
set unit_num = (
    select UNIT_NUM
    from kcparcels
    where object_id = OBJECTID
);

update addresses
set building_num = (
    select BLDG_NUM
    from kcparcels
    where object_id = OBJECTID
);

update addresses
set condo_addr = (
    select CONDOSITUS
    from kcparcels
    where object_id = OBJECTID
);

# Drop UNIT_NUM, BLDG_NUM, CONDOSITUS from kcparcels
alter table kcparcels
    drop UNIT_NUM,
    drop BLDG_NUM,
    drop CONDOSITUS;

# Create geodata table
create table geodata
(
    object_id int primary key,
    lat       double,
    lon       double,
    x_point   double,
    y_point   double,
    len       double,
    area      double
);

# Populate geodata table
insert into geodata (object_id, lat, lon, x_point, y_point, len, area)
SELECT OBJECTID,
       LAT,
       LON,
       POINT_X,
       POINT_Y,
       Shape_Length,
       Shape_area
from kcparcels;

# Drop geodata from kcparcels
alter table kcparcels
    drop LAT,
    drop LON,
    drop POINT_X,
    drop POINT_Y,
    drop Shape_Length,
    drop Shape_area

# Create FK for geodata and details
# NOTE: Would generally not have primary key also be a FK, but acceptable this time due to 1 to 1 relationship
#   Rationale for doing this is to make joins relevant for this project, as well as avoiding having one
#   extremely large table.
alter table kcparcels
    add foreign key (OBJECTID) references geodata (object_id);

alter table details
    add foreign key (object_id) references kcparcels (OBJECTID)

# Create val_total by adding land value and improvement value in main table
alter table kcparcels
    add val_total int;

update kcparcels
set kcparcels.val_total = (
    select sum(TAX_LNDVAL + TAX_IMPR)
    group by OBJECTID);

# Create uszips table to update addresses with missing zip5
create table uszips
(
    city       varchar(255),
    zip        int,
    population int,
    density    double,
    county     varchar(255)
);

# Delete unnecessary rows from uszips
delete
from uszips
where county != 'King';

# Update missing zip5 in addresses using uszips
update addresses
set addresses.cityname = (
    select CTYNAME
    from tbl_master
    where OBJECTID = OBJECTID
);

update addresses a
set cityname = KCTP_city
where cityname is null;

update addresses a
set cityname = (
    select city
    from uszips
    where zip = zip5
)
where cityname is null;

select cityname
from addresses
where zip5 = 98011

# Fix cityname typos
# DISCOVERY: Many cityname errors for Milton
update addresses
set cityname = (
    select city
    from uszips
    where zip5 = zip
);

# Function to capitalize each word  http://joezack.com/2008/10/20/mysql-capitalize-function/
CREATE FUNCTION CAP_FIRST(input VARCHAR(255))
    RETURNS VARCHAR(255)
    DETERMINISTIC

BEGIN
    DECLARE len INT;
    DECLARE i INT;

    SET len = CHAR_LENGTH(input);
    SET input = LOWER(input);
    SET i = 0;

    WHILE (i < len)
        DO
            IF (MID(input, i, 1) = ' ' OR i = 0) THEN
                IF (i < len) THEN
                    SET input = CONCAT(
                            LEFT(input, i),
                            UPPER(MID(input, i + 1, 1)),
                            RIGHT(input, len - i - 1)
                        );
                END IF;
            END IF;
            SET i = i + 1;
        END WHILE;

    RETURN input;
END;

update addresses
set cityname = CAP_FIRST(cityname);

select distinct cityname, zip5
from addresses
group by cityname

# Add/populate county, state field to addresses for Tableau mapping
alter table addresses
    add column county varchar(255),
    add column state  varchar(50);

update addresses
set county = 'King';

update addresses
set state = 'WA';

# Change details.parcel_num type to string for Tableau
alter table details
modify column parcel_num varchar(255);

# Set val_totals of parcels without any valuation info to null
update kcparcels
set val_total = null
where val_total = 0;

# Some parcels don't have traditional values (government, educational, etc.)
# Update these using appr_impr
update kcparcels
set val_total = APPR_IMPR
where val_total is null;

# Make sure parcel numbers are 10 digits total
update details
set parcel_num = lpad(parcel_num, 10, 0);


describe tbl_master
