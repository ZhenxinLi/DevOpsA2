# COSC2759 Assignment 2
## Notes App - CD
- Full Name: Zhenxin Li
- Student ID: s3726514

### Guidance (remove this section before final submission)

1. Refer for assignment specification `Marking Guide` for details of what should appear in this README.

1. Read `TERRAFORM.md` for instructions on running the make commands (install GNU Make 3.81 if you don't have it)

1. If you do not see an `Actions` tab in your GitHub, email ashley.mallia@rmit.edu.au with URL to your repository, so that it can be enabled.

1. Commit images to the `img` directory and add them like 
    ```html
    <img src="img/md.png" style="height: 70px;"/>
    ```
   <img src="img/md.png" style="height: 70px;"/>

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

* Install terraform,
* Clone the repo into their local machine, 
* Configure the AWS credential files in their ~/.aws/
* Move to the root directory of this repo in terminals
* Run 'make bootstrap' in their terminals
    
## 3. Elements breakdowns
