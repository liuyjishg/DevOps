SELECT
	a.host_group,
	a. HOST,
	a.`triggers`,
	a.count
FROM
	(
		SELECT
			g.`name` AS "host_group",
			h.`name` AS "host",
			p.`name` AS "triggers",
			count(*) AS count
		FROM
			`events` p,
			functions f,
			items i,
			`hosts` h,
			hosts_groups hg,
			hstgrp g
		WHERE
			p.objectid = f.triggerid
		AND f.itemid = i.itemid
		AND i.hostid = h.hostid
		AND hg.hostid = h.hostid
		AND hg.groupid = g.groupid
		AND p.severity <> 0
		AND p.clock > (
			UNIX_TIMESTAMP(NOW()) - 2678400
		)
		GROUP BY
			g.`name`,
			h.`name`,
			p.`name`
	) a
ORDER BY
	a.count DESC
