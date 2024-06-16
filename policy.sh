#!/bin/bash

set -e

POLICY_NAME=$1

POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$POLICY_NAME'].Arn" --output text)

if [ -z "$POLICY_ARN" ]; then
  cat << EoF > access-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "*"
    }
  ]
}
EoF
  aws iam create-policy --policy-name $POLICY_NAME --policy-document file://access-policy.json
else
  echo "Policy $POLICY_NAME already exists"
fi
