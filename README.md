# GITHUB ACTIONS
* Github
    - Create repo
    - Configure aws secrets


# cf-beanstalk-grafana-test

1. Create Makefile.settings (Define the env vars)
2. Create Makefile to define functions: clean, deploy, release



# Create the roles
* Create iam ec2 role with the iam instance profile -- when using console it generates the iam instance profile, through you can define only the iam instance profile without the role
: iam role (ec2)
: iam instance profile -- associated with the iam role ec2


iam instance profile

# Create the bucket
- us-east-1
- Versioning
- acl private

##################################################
## Steps to create beanstalk env|app with AWS CLI
# CREATE THE APPLICATION
aws elasticbeanstalk create-application --application-name myapp --region us-east-1

# 1. Create the environment with custom options
aws elasticbeanstalk create-environment --application-name myapp \
    --environment-name staging \
    --solution-stack-name "64bit Amazon Linux 2018.03 v2.16.6 running Docker 19.03.13-ce" \
    --option-settings file://eb-config.json
    --region us-east-1

:: it genererates all the plattform: s3 bucket(where it stores the beanstalk properties), sg, lb, sg-lb, asg-lc, ec2 (add to asg-lc), asg, asg-ploicy-scale-up, asg-ploicy-scale-up, cloudwatch alarm for lb high, cloudwatch alarm for lb low   



# 2. Upload the .zip
workdir docker
zip -r deploy.zip *
aws s3 cp deploy.zip s3://beanstalk-manual/

# 3. Update the application on beanstalk

* Upload the application version:
aws elasticbeanstalk create-application-version --application-name myapp \
    --version-label v1 \
    --source-bundle S3Bucket="beanstalk-manual",S3Key="deployment.zip" \
    --auto-create-application \
    --region us-east-1

* Deploy the last version

aws elasticbeanstalk update-environment --application-name myapp \
    --environment-name staging \
    --version-label v1 --region us-east-1


* Presets
- High availbale

* Custom options:
- Software
- Instances
- Capacity
- Load Balancer
- Rolling Updates and Deployments
- Security
- Monitoring
- Managed updates
- Notifications
- Network
- Database
- Tags


# Dev User
zip index.zip index.html




* Cloudfront Template:
    - Modification to instance type to save money (tests always with small instances)
    -  

# Improvements
1. Issue:
When deploy stack CFN
Stack:arn:aws:cloudformation:us-east-1:***:stack/beanstalk-jsanchez-stack-ga/5bd66330-9b39-11eb-b04a-0eabd37574d3 is in ROLLBACK_COMPLETE state and can not be updated.

--- If get result ROLLBACK_COMPLETE -->>> create a new stack (move all the app) and delete the old

2. NewFeature:
    EFS to be mounted on EC2 Instances ::: It gives Docker volumes persistence

3. 