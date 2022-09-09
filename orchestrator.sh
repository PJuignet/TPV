#!/bin/bash

echo -n "Infra Name : "
read INFRA_NAME

cp -r TEMPLATE DEPLOYED/${INFRA_NAME}
cd DEPLOYED/${INFRA_NAME}

sed -i "s|<##INFRA_NAME##>|${INFRA_NAME}|g" *

terraform init
terraform apply -auto-approve

cat << EOF
############################################################
############################################################
########                                           #########
########                                           #########
########    Web App Available at : $(cat temp_ip)   #########
########                                           #########
########                                           #########
############################################################
############################################################
EOF

rm temp_ip
exit
