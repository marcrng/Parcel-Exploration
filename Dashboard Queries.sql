use parcel_data;

# Selecting total property value of Single-Family residential grouped by zip
create table tb_zip_total
(
    cityname varchar(255),
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
