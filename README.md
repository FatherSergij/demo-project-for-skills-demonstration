## <b>Demo project for skills demonstration</b>

### About project: 
Deploy cluster k8s and web page in AWS using Terraform and Ansible.<br /> 
Using Ingress-Nginx Controller with Network Load Balancer(AWS) and GoDaddy.com<br />
There's a certificate(Let's Encrypt).<br />
There's monitoring using Prometheus and Grafana (not yet)<br />

You only need to run one command: 
```
terraform apply 
```
Needed keys for AWS from your account to run:<br />
(example)
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

**Technology stack:**
- AWS
- Kubernetes
  - Ingress controller
  - RBAC
- Terraform
- Ansible
- Prometheus (not yet)
- Grafana (not yet)

<details><summary>
<b>What's happening:</b>
</summary>
1. Terrafrom
   - Creating _VPC_, _Subnet_, _ECR_, _Instances_, _NLB_ etc in AWS. Creating necessary files for Ansible. 
   - Then Ansible runs.
2. Ansible
   - Deploing cluster k8s with CRI-O.
   - Deploing our web(simple - 1 html) using Helm.
</details>


- variables.tf - all necessary parameters
- ansible/role_k8s_deploy/files/.aws/credentials - keys for your account AWS, needed for work with ECR AWS and secret for Amazon Elastic Block Store (EBS) CSI driver
- ansible/role_k8s_deploy/files/.godaddy/godaddy.txt - key for your account GoDaddy.com, needed for update DNS Record
