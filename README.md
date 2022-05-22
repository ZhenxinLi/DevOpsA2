# COSC2759 Assignment 2
## Notes App - CD
- Full Name: Zhenxin Li
- Student ID: s3726514

## 1. Assessment of the problem
  The Alpine Inc. has been very exited about the previous CI-pipeline we've made for them, hence they have decided hiring us for their another release, which is the Continuous Deployment.  
  
  Sor far, the Alpine Inc. has been relying on manual deployements, which is prone to human error as well as adding a lot of unnecessary human workloads.   
    
  Considering the given context, we have opted to use SaaS(SSoftware as a service) tools where possible to help reduce the learning curve and workloads for their development team. In our approach, we will follow the best practice principles and make as much of our solution using code, including our CI build configuration and scaffolding scripts.  
  
  Some tools we will be using includes:  
  
#### - Github 
#### - Github Actions
#### - Terraform
#### - Ansible
#### - AWS  

## 2. Solution AWS Structure  

  According to the client's requirements, the purposed solution AWS structure would be configured like the following image:  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsDiagram.jpg?raw=true)  

  A successfully deployed application should look like the following image:  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/Application.jpg?raw=true)  

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

  If the path doesn't exist on their local machine, the user can manually create the path, as well as the config and credentials files.  
  
  Open the credential files with notepad or other compatible IDEs(Visual studio code etc.), then copy the credential details from AWS and paste into the local .aws/credentials file, overwrite it and save the file.  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsCredentials2.jpg?raw=true)
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/awsCredentials3.jpg?raw=true)
  
  Keep in mind that your session will expire every 4 hours, after which you will need to again update your credentials file.
  
* Configure the AWS config file with the following codes:  
  
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


* Configure the github action secrets  
  
  Configure the github action secrets by updating the new credential details. Copy and paste the values for `aws_access_key_id` , `aws_secret_access_key` and `aws_session_token` into the corresponding secrets  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/githubSecrets.jpg?raw=true)  

* Wait for the CD pipeline to work, and finally get the deployed application.  

  The deployed application should show up by clicking the `Assignment 2 web` EC2 instance in the user's aws account.  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/ec2.jpg?raw=true)  
  
  Note that by simply clicking the hyperlink will redirect the user to a `https` site, modify it to `http` so that the application shall show up.  
  
![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/Application.jpg?raw=true)    

## 3. Elements Break down  
 
#### make all-up  
  
  The make all-up command is configured in the Makefile under the root repository. By running make all-up in the terminal it automatically runs a list of terminal commands.
   
    | cd infra && terraform init
  
  This `cd infra` command switches the working directory to the infra folder, then the `&&` connects with the second command `terraformm init` which initializes terraform for its following usage.
  
    | cd infra && terraform apply -lock=false --auto-approve   

  This command tells terrform to pick up the .tf files and automatically configure the corresponding entities in our aws.  
  
* Inside our infra folder, the `vpc.tf` sets the VPC with CIDR block 10.0.0.0/16, 9 subnets with size /22 with 3 layers (named public, private, and data) across 3 availability zones, an Internet gateway connected to the vpc and a default route table which routes 0.0.0.0/0 to the internet gateway.
* The `ec2.tf` configures our deployer keys, which we have managed to automate generate and deploy in our pipeline's virtual machine. If the user wants make modifications locally, the code for deploy key should be relatively modified. We have also configured the EC2 instance for the application in `ec2.tf`, as well as its security group for the application. Finally, we have configured a public load balancer deployed in the public layer (all AZs), with a listener and target group. Note that we have automated the AMI selection for the instance, so that the EC2 instance would always use the latest Amazon Linux 2 64-bit (x86) AMI.   
* The `db.tf` configures our db instance, and its corresponding security group. The db instance also uses automatic filter for the latest Amazon Linux 2 AMI.  
* `main.tf` stores our providers details, as well as the configuration of our S3 backend and region information.
* The `output.tf` reads and inputs the details for our generated instances. 
  
      cd ansible/scripts && ./run-ansible.sh   
      
  The `cd ansible/scripts` command switches the working directory into the `ansible/scripts` folder, then connects with the `./run-ansible.sh` command, which first sends the instances details into a auto generated `inventory.yml` inside the virtual machine, then calls the `playbook.yml` which deploys and configures the application and mongodb instance.  
  
  Within the `playbook.yml`, we deploy and configure our instances in several steps.  

* For database, first we gather the database from an appropriate source, then install and configure it within shell commands, and finally deploys it through the terminal commands.  

![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/db.jpg?raw=true)    

* For our application, we have configured and install node dependencies, as well as the database endpoint and credentials. Also we have copied necessary files for the application to run from our repository to remote. Finally deploy the application through terminal command, which is similar to what we have done for deploying the database. 
* All the tasks has been set to `become=yes`, which allows us to make modifications as a root user.  
* The systemd.tpl has been modified, allowing us to automatically start the database and application if the server is rebooted.   

![alt text](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/systemd.jpg?raw=true)    

  
  
## 4. Limitations of using a single ec2 instance to deploy a database   
  
  With EC2, you can install any database engine and version you want, using a single EC2 instance to deploy a database is mostly suitable for a cost-effective and light traffic application.  
  
  However, when the client threads demanding to scale, which is a common case in real world, then a single EC2 instance database may not be sufficient.  
  
#### Client threads scaling
  
  According to an [benchmark experiment article](https://blog.observu.com/2011/05/rds-vs-mysql-on-ec2-benchmark/), the author has tested the performance on MySQL on the EC2 instance, with the standard and optimized versions, compared with the RDS performance:  
  
![cr: Michiel van Vlaardingen, 2011](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/ec21.jpg?raw=true)  

  We can see that for the first test, when it encounters small client threads the performance is quite similar.  
  
  However, with the client threads increasing to 50:  
  
![cr: Michiel van Vlaardingen, 2011](https://github.com/rmit-computing-technologies/cosc2759-assignment-2-ZhenxinLi/blob/feature/img/ec22.jpg?raw=true)  

  We can see that the RDS performs so much better when the client thread increases.  
  
  Hence, RDS can be a considerable alternative way when the team is going for the realistic loads. 
  
#### Security  

  Under the context of running database using a single EC2 instance, webserver may need to be available for Public internet access and taking untrusted input from anonymous users.

  In that case, if web server gets compromised then there might be high chances that attacker can get root access on database server too.

#### More limitations...  

  There are more limitations on setting database using a single ec2 instance. Such as  
* If the user wants a high availability, the user has to configure the database server in a highly available cluster himself/herself.
* Backups have to be manually enabled by user.
* The user has to pick the right storage volume to get the IOPS and latency needed for the best performance.
...
