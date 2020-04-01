CREATE TABLE  `skopeo`.`OAIResumption` (
  `id` varchar(35) NOT NULL,
  `params` mediumtext NOT NULL,
  `startrow` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `prevId` varchar(35) DEFAULT NULL,
  `verb` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;