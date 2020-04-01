------------------------------------------------------------------------------------
-- Written by Mikel 2-2012
--
-- These triggers detect changes, additions and deletions on any record related 
-- to a beeldarchief record and update its timestamp field accordingly.
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- Create trgger as root, not as sww_owner.
-- sww_owner does not have the SUPER privilege
------------------------------------------------------------------------------------

delimiter |


------------------------------------------------------------------------------------
-- Trigger  for direct masters
------------------------------------------------------------------------------------

CREATE  DEFINER = CURRENT_USER TRIGGER auteursrecht_upd BEFORE UPDATE ON auteursrecht
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_are_id = OLD.are_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER auteur_upd BEFORE UPDATE ON auteur
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_aut_id = OLD.aut_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER beeldtype_upd BEFORE UPDATE ON beeldtype
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_bty_id = OLD.bty_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER collectie_upd BEFORE UPDATE ON collectie
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_col_id = OLD.col_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER drukker_upd BEFORE UPDATE ON drukker
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_drk_id = OLD.drk_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER eigendom_upd BEFORE UPDATE ON eigendom
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_eig_id = OLD.eig_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER gezichtspunt_upd BEFORE UPDATE ON gezichtspunt
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_gzp_id = OLD.gzp_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER instelling_upd BEFORE UPDATE ON instelling
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_ins_id = OLD.ins_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER status_upd BEFORE UPDATE ON status
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_sts_id = OLD.sts_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER uitgever_upd BEFORE UPDATE ON uitgever
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_ugv_id = OLD.ugv_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER verwerving_upd BEFORE UPDATE ON verwerving
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE a.bar_vwv_id = OLD.vwv_id;
  END;
|

------------------------------------------------------------------------------------
-- Triggers for indirect masters
------------------------------------------------------------------------------------
CREATE  DEFINER = CURRENT_USER TRIGGER bedrijf_upd BEFORE UPDATE ON bedrijf
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2bdf_bar_id
                         FROM   bar2bdf ab
                         WHERE  ab.bar2bdf_bdf_id = OLD.bdf_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER bedrijf_del BEFORE DELETE ON bedrijf
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2bdf_bar_id
                         FROM   bar2bdf ab
                         WHERE  ab.bar2bdf_bdf_id = OLD.bdf_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER geografie_upd BEFORE UPDATE ON geografie
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2geo_bar_id
                         FROM   bar2geo ab
                         WHERE  ab.bar2geo_geo_id = OLD.geo_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER geografie_del BEFORE DELETE ON geografie
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2geo_bar_id
                         FROM   bar2geo ab
                         WHERE  ab.bar2geo_geo_id = OLD.geo_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER persoon_upd BEFORE UPDATE ON persoon
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2per_bar_id
                         FROM   bar2per ab
                         WHERE  ab.bar2per_per_id = OLD.per_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER persoon_del BEFORE DELETE ON persoon
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2per_bar_id
                         FROM   bar2per ab
                         WHERE  ab.bar2per_per_id = OLD.per_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER straat_upd BEFORE UPDATE ON straat
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2str_bar_id
                         FROM   bar2str ab
                         WHERE  ab.bar2str_str_id = OLD.str_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER straat_del BEFORE DELETE ON straat
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2str_bar_id
                         FROM   bar2str ab
                         WHERE  ab.bar2str_str_id = OLD.str_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER term_upd BEFORE UPDATE ON term
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2trm_bar_id
                         FROM   bar2trm ab
                         WHERE  ab.bar2trm_trm_id = OLD.trm_id);
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER term_del BEFORE DELETE ON term
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE  ba.bar_id in (SELECT ab.bar2trm_bar_id
                         FROM   bar2trm ab
                         WHERE  ab.bar2trm_trm_id = OLD.trm_id);
  END;
|


------------------------------------------------------------------------------------
-- Triggers for tussentabellen
------------------------------------------------------------------------------------
CREATE  DEFINER = CURRENT_USER TRIGGER bar2bdf_ins BEFORE INSERT ON bar2bdf
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_id = NEW.bar2bdf_bar_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER bar2geo_ins BEFORE INSERT ON bar2geo
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_id = NEW.bar2geo_bar_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER bar2per_ins BEFORE INSERT ON bar2per
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_id = NEW.bar2per_bar_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER bar2str_ins BEFORE INSERT ON bar2str
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_id = NEW.bar2str_bar_id;
  END;
|

CREATE  DEFINER = CURRENT_USER TRIGGER bar2trm_ins BEFORE INSERT ON bar2trm
  FOR EACH ROW BEGIN
    UPDATE beeldarchief ba SET ba.bar_dtcreation = CURRENT_TIMESTAMP
    WHERE ba.bar_id = NEW.bar2trm_bar_id;
  END;
|


delimiter ;

 
