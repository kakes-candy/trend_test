select * 
into 
#tmp_vragenlijsten 
from dbo.vw_vragenlijsten as v 
where v.test_naam = 'sq-48' 
and v.test_datum_ingevuld is not null