# Container_Orchestration
Graded Assignment on Container Orchestration

Solution:
Step1: 
Using Terraform script I created an Ec2 instance where I will install EKSCTL to create the Kubernetes Cluster: This EC2 instance will act like a boot strap instance to proceed further. The Terraform script will automatically download the EKSCTL and will download from the GIT repositories.
 
![image](https://github.com/user-attachments/assets/329784c6-6161-48b6-9fc8-6e1928236290)

Step2:
Create the required Docker files using Docker compose
![image](https://github.com/user-attachments/assets/24711785-b4de-4f4e-aa93-157c3a8ea3f0)

![image](https://github.com/user-attachments/assets/1d382e9f-500d-40f4-9d07-19bb012378a9)

Docker containers are successfully running now 
 ![image](https://github.com/user-attachments/assets/af0b141c-fc0f-4d9c-b36b-75349a9438f0)


Step3:
Create the cluster using EKSCTL – 3 Nodes

eksctl create cluster \
  --name pk1-eks-cluster \
  --region us-west-2 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 3 \
  --managed

 
Cluster is created with 3 Nodes and in active pk1-eks-cluster
![image](https://github.com/user-attachments/assets/8ad74502-84a5-4552-aee4-efd68e44c65e)

![image](https://github.com/user-attachments/assets/27e83a76-54ae-4371-b3d0-c8236d3a8166)
![image](https://github.com/user-attachments/assets/fd5cc97f-e2d0-4b94-b426-0e59ea193d57)


 
Step4:
Installing the nodejs app into the cluster and trying to run it manually. After creating the deployment files.
Frontend and the Backend YAML are deployed successfully 
![image](https://github.com/user-attachments/assets/fd187e50-d5d5-4136-b090-ea1e13831b5d)

 
When I give the external IP of the load balancer front end service the application is displayed as expected 
 ![image](https://github.com/user-attachments/assets/ae109101-70cb-4c29-82ef-55b70274590b)

All the 6 Pods are running as expected 
 
![image](https://github.com/user-attachments/assets/13c35c8b-7345-4cb0-9bda-00d90dd09367)


Step5
Using the HELM for the package deployment:
mern-helm-chart/
  ├── Chart.yaml
  ├── values.yaml
  ├── templates/
      ├── frontend-deployment.yaml
      ├── backend-deployment.yaml
      ├── mongo-deployment.yaml
