use parcel_data;

# Selecting total property value divided by population of Single-Family residential grouped by zip
create table tb_zip_total
(
    cityname  varchar(255),
    zip5      int,
    zip_total bigint
);

insert into tb_zip_total (cityname, zip5, zip_total)
select distinct cityname, zip5, sum(val_total)
from addresses a
         join kcparcels k on a.object_id = k.OBJECTID
         join site_types st on k.SITETYPE = st.id
where description = 'Single Family'
group by zip5;

select cityname, zip5
from addresses
group by cityname;

select a.zip5, zip_total / population as ratio
from addresses a
         join tb_zip_total tzt on a.zip5 = tzt.zip5
         join uszips u on a.zip5 = u.zip
group by zip5;

# Query for Parcel Valuations - Detail
#   Query execution was too slow without a custom query
#   could be faster if tables were broken down more logically
#   (one-to-one relationships kept in same table, many to one separated, etc.)
select parcel_num, objectid, name, cityname, address, description, val_total
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
         join geodata g on k.OBJECTID = g.object_id
         join site_types st on k.SITETYPE = st.id
         join details d on k.OBJECTID = d.object_id;

select val_total, APPR_IMPR, TAX_LNDVAL, TAX_IMPR
from kcparcels k
         join addresses a on k.OBJECTID = a.object_id
where cityname = 'Bellevue'
  and SITETYPE = 'R1'
  and val_total > 1000
order by val_total desc
limit 100;

# Add parcel values to uszips, dtop tb_zip_total
alter table uszips
    add val_zip bigint;

update uszips
set val_zip = (
    select zip_total
    from tb_zip_total
    where zip5 = zip
);

drop table tb_zip_total;

# Add parcel count to uszips
alter table uszips
    add parcel_count int;

update uszips u
set u.parcel_count = (
    select count(*)
    from addresses a
             join kcparcels k on k.OBJECTID = a.object_id
    where SITETYPE = 'R1'
      and a.zip5 = u.zip
    group by zip5
);

# Considering comparing zip codes by percentage of whole market
select city, cast(val_zip as decimal) / 311843474361 as ratio
from uszips
group by zip;
