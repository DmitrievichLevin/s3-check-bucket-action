#!/bin/sh

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is not set. Quitting."
  exit 1
fi

# log
echo "Checking for bucket at $(aws s3api list-buckets --query 'Buckets[?Name == `c1edd274-32f7-4c87-aa18-720e1e3379e7`].[Name]' --output text) $AWS_S3_BUCKET"

if [[ $(aws s3api list-buckets --query 'Buckets[?starts_with(Name,`${AWS_S3_BUCKET}`)].[Name]' --output text) = `${AWS_S3_BUCKET}` ]] 
then 
    echo "You're a specific genius. Now do something useful"
    echo 'BUCKET_EXISTS=true' >> $GITHUB_STATE
else
    echo "You're a specific genius. it's false"
    echo 'BUCKET_EXISTS=false' >> $GITHUB_STATE
fi

# log
echo "${AWS_S3_BUCKET} exists ${BUCKET_EXISTS}"

