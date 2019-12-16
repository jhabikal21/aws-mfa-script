#!/bin/bash

account="123456789"
read -p "Enter Your AWS UserName : "  username
read -p "Enter Your AWS Prod CLI Profile. If you don't have it yet, please add it before running this script. Command: aws configure --profile my-profile: "  profile
read -p "Enter Your MFA Token: "  mfa_token

profile_mfa="${profile}-mfa"

cat ~/.aws/credentials | grep $profile_mfa

if [ `echo $?` -eq 0 ]; then
    echo "Replacing mfa credentials"

    linenum=$(awk "/$profile_mfa/{print NR}" ~/.aws/credentials)
    changeline=`expr "$linenum" + "3"`
    endofline="${changeline}d"
    sed -i.bak -e "$linenum,$endofline" ~/.aws/credentials
    aws sts get-session-token --serial-number arn:aws:iam::$account:mfa/$username --profile $profile --duration 129600 --token-code $mfa_token --output text  | awk '{printf("[qube-ksprod-mfa]\naws_access_key_id=\ %s\ \naws_secret_access_key=\ %s\ \naws_session_token=\ %s\ \n",$2,$4,$5)}' >>  ~/.aws/credentials
else
    echo "Creating new mfa credentials"
    aws sts get-session-token --serial-number arn:aws:iam::$account:mfa/$username --profile $profile --duration 129600 --token-code $mfa_token --output text  | awk '{printf("[qube-ksprod-mfa]\naws_access_key_id=\ %s\ \naws_secret_access_key=\ %s\ \naws_session_token=\ %s\ \n",$2,$4,$5)}' >>  ~/.aws/credentials 
fi
