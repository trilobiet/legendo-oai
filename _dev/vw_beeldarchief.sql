CREATE VIEW `skopeo`.`vw_beeldarchief` AS
  
select 
	 bar_id
	,bar_dtCreation
	,bar_beeldAanwezig
	,bar_inventarisnummer
	,bar_oudenummer
	,bar_aantal
	,bar_negatiefnummer
	,bar_instellingsnaam
	,bar_kadaster
	,bar_huisnummer
	,bar_annotatie
	,bar_beschrijving
	,bar_samenvatting
	,DATE_ADD('1970-01-01',INTERVAL bar_jaar_verwerving DAY) as bar_datum_verwerving
	,DATE_ADD('1970-01-01',INTERVAL bar_jaar_begin DAY) as bar_datum_begin
	,DATE_ADD('1970-01-01',INTERVAL bar_jaar_eind DAY) as bar_datum_eind

	,gzp_naam
	,col_naam
	,col_code
	,ugv_naam
	,drk_naam
	,sts_naam
	,aut_naam
	,bty_naam
	,ins_naam
	,vwv_naam
	,are_naam
	,eig_naam

	,cast(group_concat(distinct str_naam order by str_naam separator " | ") as char) as str_list
	,cast(group_concat(distinct per_naam order by per_naam separator " | ") as char) as per_list
	,cast(group_concat(distinct bdf_naam order by bdf_naam separator " | ") as char) as bdf_list
	,cast(group_concat(distinct geo_naam order by geo_naam separator " | ") as char) as geo_list
	,cast(group_concat(distinct trm_naam order by trm_naam separator " | ") as char) as trm_list
	
from 
	beeldarchief 

	left join gezichtspunt on bar_gzp_id = gzp_id
	left join collectie on bar_col_id = col_id
	left join uitgever on bar_ugv_id = ugv_id
	left join drukker on bar_drk_id = drk_id
	left join status on bar_sts_id = sts_id
	left join auteur on bar_aut_id = aut_id
	left join beeldtype on bar_bty_id = bty_id
	left join instelling on bar_ins_id = ins_id
	left join verwerving on bar_vwv_id = vwv_id
	left join auteursrecht on bar_are_id = are_id
	left join eigendom on bar_eig_id = eig_id

	left join (bar2str join straat on bar2str_str_id = str_id) on bar2str_bar_id = bar_id 
	left join (bar2per join persoon on bar2per_per_id = per_id) on bar2per_bar_id = bar_id 
	left join (bar2bdf join bedrijf on bar2bdf_bdf_id = bdf_id) on bar2bdf_bar_id = bar_id 
	left join (bar2geo join geografie on bar2geo_geo_id = geo_id) on bar2geo_bar_id = bar_id 
	left join (bar2trm join term on bar2trm_trm_id = trm_id) on bar2trm_bar_id = bar_id 

where 
	bar_publiceren = 1
	and col_publiceren = 1

group by
	bar_id
;
