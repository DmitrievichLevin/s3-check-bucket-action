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

if [[ $(aws s3api list-buckets --query "Buckets[?Name == '${AWS_S3_BUCKET}'].[Name]" --output text) == "$AWS_S3_BUCKET" ]] 
then 
    echo 'BUCKET_EXISTS=true' >> $GITHUB_ENV
else
    echo 'BUCKET_EXISTS=false' >> $GITHUB_ENV
fi

# log
echo "${AWS_S3_BUCKET} exists ${BUCKET_EXISTS}"

