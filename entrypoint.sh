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
echo "Checking for bucket at s3://${AWS_S3_BUCKET}"

# Execute a head-object command
aws s3api head-object --bucket ${AWS_S3_BUCKET}

# XXX: we are just checking the error code, but should check the result for a 404, and raise error in other cases
if [ $? == 0 ]
then
  echo "exists=true" >> $GITHUB_OUTPUT
else
  echo "exists=false" >> $GITHUB_OUTPUT
fi
