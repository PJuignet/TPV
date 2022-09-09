#!/bin/bash
INFRA_NAME=$1
KEY_NAME=$2
TEMPLATE_NAME=$3
cp -r TEMPLATE/${TEMPLATE_NAME} DEPLOYED/${TEMPLATE_NAME}/${INFRA_NAME}
cd DEPLOYED/${INFRA_NAME}
sed -i "s|<##INFRA_NAME##>|${INFRA_NAME}|g" *
sed -i "s|<##KEY_NAME##>|${KEY_NAME}|g" *
terraform init && terraform apply -auto-approve
IP=$(cat temp_ip)

NB_SPACE=$(( 16 - $(echo ${IP} | wc -c) ))
SPACES=""
I=0
while [ $I -lt $NB_SPACE ]
do
        SPACES=${SPACES}" "
        I=$(( $I + 1 ))
done
cat << EOF
############################################################
############################################################
########                                           #########
########                                           #########
########    Web App Available at : ${IP}${SPACES}#########
########                                           #########
########                                           #########
############################################################
############################################################
EOF
rm temp_ip
exit
