#!/bin/bash
export pass=`grep OPENMRS_DB_PASSWORD /etc/bahmni-installer/bahmni.conf |cut -f 2 -d =`

mysql -uroot -p${pass} openmrs << EOF
start transaction;
update idgen_seq_id_gen set next_sequence_value = Concat(substring(now(), 3, 2),'0001') where prefix like 'CHK';
update idgen_seq_id_gen set first_identifier_base = Concat(substring(now(), 3, 2),'0000') where prefix like 'CHK';
update idgen_seq_id_gen set next_sequence_value = Concat(substring(now(), 3, 2),'0001') where prefix like 'CP';
update idgen_seq_id_gen set first_identifier_base = Concat(substring(now(), 3, 2),'0000') where prefix like 'CP';
commit;
EOF

ret=$?

if [ ${ret} == 0 ]; then
  echo "Successfully updated Identifier" >> /var/log/id.txt
else
  echo "Failed to update Identifier" >> /var/log/id.txt
fi

exit ${ret}
