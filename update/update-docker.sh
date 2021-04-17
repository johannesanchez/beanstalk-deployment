#!/bin/bash
applicationName="CFNBeanstalk-ebApplication-1DZ3U6KCPBTYO"
environmentName="CFNB-ebEn-18CWVZ8BYPSTR"
bucketName="teravision-eb-test3-jsanchez"
packageName="deploy.zip"
region="us-east-1"
image_version="1.0.9"

rm -rf deploy.zip
# Build the Dockerrun.aws.json
# mkdir ./update
# cp -rp ./docker/Dockerfile.dev update/Dockerfile
# cp -rp ./docker/docker-compose-dev.yml update/docker-compose.yml
# cd update

# # Generate Header Dockerrun.aws.json

# # Convert to Dockerrun.json
# cat docker-compose.yml | docker run --rm -i micahhausler/container-transform >> Dockerrun.aws.json

# zip the file
# cd update
zip -r deploy.zip Dockerfile
aws s3 cp deploy.zip s3://$bucketName


# Create New Version
aws elasticbeanstalk create-application-version \
          --application-name $applicationName  \
          --version-label $image_version     \
          --source-bundle S3Bucket="$bucketName",S3Key="$packageName" \
          --auto-create-application \
          --region $region

  
aws elasticbeanstalk update-environment \
          --application-name $applicationName \
          --environment-name $environmentName \
          --version-label $image_version \
          --region $region

#   steps:
#   - name: Generating Header



#   - name: Convert from docker-compose to Dockerrun.json
#     run: 


# aws elasticbeanstalk update-environment --application-name beanstalk-jsanchez-stack-ga-sampleApplication-KVEAGSDB6E12     --environment-name bean-samp-1HEGBZE9IZ3V3     --version-label v1.0.3 --region us-east-1