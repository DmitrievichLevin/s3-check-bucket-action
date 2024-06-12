# GitHub Action to check if a file exists in an S3 Bucket

> **⚠️ Note:** To use this action, you must have access to the [GitHub Actions](https://github.com/features/actions) feature. GitHub Actions are currently only available in public beta. You can [apply for the GitHub Actions beta here](https://github.com/features/actions/signup/).

This simple action uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to check if a file exists in an S3 bucket, and set an output to true or false. This is useful to "short-circuit" a job and not do unnecessary subsequent steps.


## Usage

This action is particularly useful for multiple deployments.
It will assume the supplied AWS IAM Role and check if a S3 bucket exists, and if not create it.

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
name: S3 Bucket Check AWS Example

on:
  push:
    branches:
      - main
      - master
env:
    AWS_REGION: 'us-east-2'
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    AWS_S3_BUCKET: ${{ env.AWS_S3_BUCKET }}
permissions:
  contents: write 
jobs:
  AssumeRoleAndCallIdentity:
    runs-on: ubuntu-latest
    permissions:
          id-token: write
          contents: read
    steps:
      - uses: actions/checkout@v4
      - name: configure aws credentials
        id: creds
        uses: aws-actions/configure-aws-credentials@v1.7.0
        with:
          role-to-assume: ${{ env.AWS_ROLE }} 
          role-session-name: GitHub_to_AWS_via_FederatedOIDC
          aws-region: ${{ env.AWS_REGION }}
      - name: Sts GetCallerIdentity
        run: |
          aws sts get-caller-identity
      - name: S3 Bucket Verification
        id: bucket_check
        uses: dmitrievichlevin/s3-check-bucket-action@master
        with:
          AWS_ACCESS_KEY_ID: ${{ steps.creds.outputs.aws-access-key-id }}
          AWS_SECRET_ACCESS_KEY: ${{ steps.creds.outputs.aws-secret-access-key }}
      - name: Echo AWS VARS
        id: s3_output
        run: |
            aws s3api head-bucket --bucket ${{env.AWS_S3_BUCKET}} --output 'text'
      - run: |
          aws s3 mb s3://${{env.AWS_S3_BUCKET}} --region ${{env.AWS_REGION}}
      
```


### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | `secret` | **Yes** |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | `secret` | **Yes** |
| `AWS_S3_BUCKET` | The name of the bucket you're syncing to. For example, `jarv.is`. | `secret` | **Yes** |
| `AWS_ROLE` | ARN of AWS IAM User. For example, `arn:aws:iam::000000000:role/github_workflow_example `. | `secret` | **Yes** |
| `AWS_REGION` | The region where you created your bucket in. For example, `us-east-1`. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | `env` | **Yes** |
| `FILE` | The file to check | `env` | **Yes** |


## License

This project is distributed under the [MIT license](LICENSE.md).
