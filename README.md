## <b>Demo project for skills demonstration</b>

### About project: 
Deploy cluster k8s and web page in AWS using Terraform and Ansible.<br /> 
Using Ingress-Nginx Controller with Network Load Balancer(AWS) and GoDaddy.com<br />
There's a certificate(Let's Encrypt).<br />
There's monitoring using Prometheus and Grafana (not yet)<br />

**You only need to run one command:** 
```
terraform apply 
```
Needed keys for AWS from your account to run:<br />
<details><summary>(example)</summary>
export AWS_ACCESS_KEY_ID=<br />
export AWS_SECRET_ACCESS_KEY=<br />
</details>

**Technology stack:**
- AWS
- Kubernetes
- Terraform
- Ansible
- Prometheus (not yet)
- Grafana (not yet)

<details><summary>
<b>What's happening:</b>
</summary>
__1. Terrafrom__<br />
--- Creating <em>VPC</em>, <em>Subnet</em>, <em>ECR</em>, <em>Instances</em>, <em>NLB</em> etc in AWS.<br /> 
--- Creating necessary files for Ansible.<br /> 
--- Then Ansible runs.<br />
2. Ansible<br />
--- Deploing cluster k8s with CRI-O.<br />
--- Install Ingress-Nginx Controller.<br />
--- Build and push image in AWS ECR.<br />
--- Install Cert-manager.<br />
--- Deploing our web(simple - 1 html) using Helm.<br />
--- Updating DNS Records in GoDaddy.<br />
--- Deploing Prometheus.<br />
</details>


- variables.tf - all necessary parameters
- ansible/role_k8s_deploy/files/.aws/credentials - keys for your account AWS, needed for work with ECR AWS and secret for Amazon Elastic Block Store (EBS) CSI driver
- ansible/role_k8s_deploy/files/.godaddy/godaddy.txt - key for your account GoDaddy.com, needed for update DNS Record
