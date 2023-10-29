## **Deploy cluster k8s and web in AWS using Terraform and Ansible**

Need run only one command: 
```
terraform apply 
```
(need keys for AWS from your account)
- Example:
```
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

1. Terrafrom
- Creating VPC, Subnet, ECR, Instances, NLB etc in AWS. Creating necessary files for Ansible. Then Ansible runs.
2. Ansible
- Deploing cluster k8s with CRI-O.
- Deploing our web(simple - 1 html).


Using Ingress-Nginx Controller with Network Load Balancer(AWS) and GoDaddy.com
There is a certificate(Let's Encrypt). 

variables.tf - all necessary parameters
ansible/role_k8s_deploy/files/.aws/credentials - keys for AWS, needed for work with ECR AWS
ansible/role_k8s_deploy/files/.godaddy/godaddy.txt - key for GoDaddy.com, needed for update DNS Record
