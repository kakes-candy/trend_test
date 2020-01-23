

-- resultaatquery

select
tests_per_dossier.dossier_type
,year(tests_per_dossier.slotsessie_datum) as jaar
, month(tests_per_dossier.slotsessie_datum) as maand
, avg(tests_per_dossier.aantal_ingevuld_sq48 * 1.0) as gemiddeld_aantal_tests
from (
select 
d.dossier_id
,d.dossier_type
,count(*) as aantal_ingevuld_sq48
,max(afgesloten.datum_slotsessie) as slotsessie_datum
from dbo.vw_dossiers as d
left join #tmp_vragenlijsten as v on d.dossier_id = v.dossier_id
inner join ( select Dossier 
					,max(s.StartTijd) as datum_slotsessie
				from dbo.Sessie as s 
				inner join dbo.Product as p on s.Product = p.ID
				where s.slotsessie = 1
				group by p.Dossier
) as afgesloten on afgesloten.Dossier = d.dossier_id
where v.test_naam = 'sq-48' 
and v.test_datum_ingevuld is not null
and afgesloten.datum_slotsessie between '@param_begindatum' and getdate()
group by d.dossier_id, d.dossier_type
) as tests_per_dossier
group by tests_per_dossier.dossier_type, 
	year(tests_per_dossier.slotsessie_datum)
	, month(tests_per_dossier.slotsessie_datum)
order by 
tests_per_dossier.dossier_type, 
	year(tests_per_dossier.slotsessie_datum)
	, month(tests_per_dossier.slotsessie_datum)

