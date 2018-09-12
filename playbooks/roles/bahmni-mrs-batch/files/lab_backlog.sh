#!/bin/bash -e

. /cron_env.sh

if [ "${BAHMNI_SERVER_MODE}" != "active" ]; then
  exit 0
fi

psql -Uclinlims clinlims << EOF
start transaction;
update analysis
set status_id = 15, comment = 'Annulé automatiquement à cause de manque de résultats.'
where status_id = 4
  and (
    (
      lastupdated < (now() - interval '2 months')
      and exists ( select 1
                   from test t
                   where t.id = analysis.test_id
                     and (t.name like 'TB%' or t.name like 'Charge Virale HIV%' or t.name like 'EID (PCR)'))
    ) or (
      lastupdated < (now() - interval '1 week')
      and exists ( select 1
                   from test t
                   where t.id = analysis.test_id
                     and not (t.name like 'TB%' or t.name like 'Charge Virale HIV%' or t.name like 'EID (PCR)'))
    ) or (
      exists ( select 1
               from sample_item si
               inner join sample s on si.samp_id = s.id
               where analysis.sampitem_id = si.id
                 and s.accession_number is null
                 and s.lastupdated < (now() - interval '1 week'))
    )
  );
commit;
EOF

exit $?

