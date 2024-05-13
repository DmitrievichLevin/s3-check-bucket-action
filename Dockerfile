FROM python:3.7-alpine

LABEL version="0.1.0"
LABEL repository="https://github.com/dmitrievichlevin/s3-check-bucket-action"
LABEL maintainer="Dmitrievich Levin <jhowar39@emich.edu>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.16.254'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
