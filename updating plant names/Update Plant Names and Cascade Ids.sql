create temp table plantschanged as
with
  renamed as (
    select o.*, n.newgenus, n.newname, n.newname is not null as namechanged
    from plant_species o
    left join plant_name_mapping n on ((n.oldgenus, n.oldname) = (o.genus, o.species))
    ),
  newplants as (
    select id, coalesce(newgenus, genus) as genus, coalesce(newname, species) as species, namechanged
    from renamed
    ),
  plantsnewid as (
    select *, min(id) over(partition by genus, species) as new_id
    from newplants
    )
select *
from plantsnewid
where namechanged or new_id <> id;

create temp table plantsrenamed as (
    SELECT p.id FROM plant_species p
    JOIN plantschanged pc
    on (p.id = pc.id and pc.id = pc.new_id)
    );

update rra_dominant s set tax = pc.new_id
from plantschanged pc
where s.tax = pc.id and pc.id not in (select * from plantsrenamed);

update eplot_woody_plant s set tree_tax = pc.new_id
from plantschanged pc
where s.tree_tax = pc.id and pc.id not in (select * from plantsrenamed);

update eplot_subplot_vegetation s set rank1_tax = pc.new_id
from plantschanged pc
where s.rank1_tax = pc.id and pc.id not in (select * from plantsrenamed);

update eplot_subplot_vegetation s set rank2_tax = pc.new_id
from plantschanged pc
where s.rank2_tax = pc.id and pc.id not in (select * from plantsrenamed);

update eplot_subplot_vegetation s set rank3_tax = pc.new_id
from plantschanged pc
where s.rank3_tax = pc.id and pc.id not in (select * from plantsrenamed);

delete from plant_species
where id in (select id from plantschanged where new_id <> id);

--drop table plantschanged;
--drop table plantsrenamed;
