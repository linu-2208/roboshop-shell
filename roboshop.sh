#!/bin/bash

AMI=ami-0b4f379183e5706b9
SG_ID=sg-07078f1c35acb359b
ZONE_ID=Z01032471U3T3F8BDO6LI
DOMAIN_NAME=myver.shop
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do 
    echo "instance is: $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then    
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0b4f379183e5706b9  --instance-type $INSTANCE_TYPE --security-group-ids sg-07078f1c35acb359b --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" 

done