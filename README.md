# COSC2759 Assignment 2
## Notes App - CD
- Full Name: Zhenxin Li
- Student ID: s3726514

## 1. Abstract
  The Alpine Inc. has been very exited about the previous CI-pipeline we've made for them, hence they have decided hiring us for their another release, which is the Continuous Deployment.  
  
  Sor far, the Alpine Inc. has been relying on manual deployements, which is prone to human error as well as adding a lot of unnecessary human workloads.   
    
  Considering the given context, we have opted to use SaaS(SSoftware as a service) tools where possible to help reduce the learning curve and workloads for their development team. In our approach, we will follow the best practice principles and make as much of our solution using code, including our CI build configuration and scaffolding scripts.  
  
  Some tools we will be using includes:  
  
#### - Github 
#### - Github Actions
#### - Terraform
#### - Ansible
#### - AWS

## 2. How to use
  The terraform files has configured an S3 bucket and DynamoDB table for use. The success state of our CD pipeline relies on a successfully configured S3 backend.  
 
  To initiallize the S3 backend, the user needs to first  

* Install terraform, make and AWS cli,  

  After installing, run `terraform --version` in your terminal to check for your version. Versions above 1.1.9 are supported in our build.  
  Other tools can be checked using the same way, terminal commands and outputs shold look like the following:  
      
       make --version   
          GNU Make 3.81   
       terraform --version  
          Terraform v1.1.9  
       aws --version  
          aws-cli/2.7.0 Python/3.9.12 Darwin/21.4.0 source/x86_64 prompt/off  
  
* Clone the repo into their local machine, 
* Configure the AWS credential files in their ~/.aws/credentials  

  The path should look like this:  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsCredentials.png?raw=true)  

  If the path doesn't exist, you can manually create the path, as well as the config and credentials files.
  Open the credential files with notepad or other compatible IDEs(Visual studio code etc.), then copy the credential details from AWS and paste into the local .aws/credentials file, overwrite it and save the file.  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsCredentials2.jpg?raw=true)
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsCredentials3.jpg?raw=true)
  
  Keep in mind that your session will expire every 4 hours, after which you will need to again update your credentials file.
  
* Configure the AWS config file, 

  Configure the .aws/config file with the following codes:  
  
       [default] 
       region = us-east-1 
       cli_pager=   

  
* Move to the root directory of the cloned repo in terminals
* Run `make bootstrap` in the terminals  
  Your terminal output should end with phrases looking like this:  
  
       dynamoDB_lock_table_name = "rmit-locktable-******"
       state_bucket_name = "rmit-locktable-******"
      
* Copy the output from the previous command, and overwrite them into /infra/main.tf  

  In my case my `make bootstrap`output was `dynamoDB_lock_table_name = "rmit-locktable-tb0nyr"`, replace them into at the corresponding position.   
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/S32.jpg?raw=true)  

  
## 3. Elements breakdowns
