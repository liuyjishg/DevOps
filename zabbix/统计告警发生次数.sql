SELECT
	p.objectid,
	p.`name`,
	p.clock,
	f.itemid,
	i.hostid,
	h.`name`,
	hg.groupid,
	g.`name`
FROM
	problem p,
	functions f,
	items i,
	`hosts` h,
	hosts_groups hg,
	hstgrp g
WHERE
	p.objectid = f.triggerid AND f.itemid=i.itemid AND i.hostid=h.hostid AND hg.hostid=h.hostid and hg.groupid=g.groupid
