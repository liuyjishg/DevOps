CREATE TABLE `event_suppress` (
  `event_suppressid` bigint(20) unsigned NOT NULL,
  `eventid` bigint(20) unsigned NOT NULL,
  `maintenanceid` bigint(20) unsigned DEFAULT NULL,
  `suppress_until` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_suppressid`),
  UNIQUE KEY `event_suppress_1` (`eventid`,`maintenanceid`),
  KEY `event_suppress_2` (`suppress_until`),
  KEY `event_suppress_3` (`maintenanceid`),
  CONSTRAINT `c_event_suppress_1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE CASCADE,
  CONSTRAINT `c_event_suppress_2` FOREIGN KEY (`maintenanceid`) REFERENCES `maintenances` (`maintenanceid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
