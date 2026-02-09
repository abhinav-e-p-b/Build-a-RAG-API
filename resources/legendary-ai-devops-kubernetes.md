<img src="https://cdn.prod.website-files.com/677c400686e724409a5a7409/6790ad949cf622dc8dcd9fe4_nextwork-logo-leather.svg" alt="NextWork" width="300" />

# Deploy a RAG API to Kubernetes

**Project Link:** [View Project](http://learn.nextwork.org/projects/ai-devops-kubernetes)

**Author:** Abhinave P.B  
**Email:** abhinavepb12@gmail.com

---

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_y7z8a9b0)

---

## Introducing Today's Project!

In this project, I will deploy a containerized application using Kubernetes. I am doing this project to gain hands-on experience with container orchestration and understand how applications are managed in a real-world cloud-native environment. Kubernetes will help me automate deployment, scaling, and networking of the application, giving me practical exposure to how modern distributed systems are built and managed.

### Key services and concepts

Key concepts I learnt include container orchestration, self-healing, and service abstraction in Kubernetes. Kubernetes provides a platform to deploy, manage, and scale containerized applications automatically while ensuring reliability and availability.

Deployments manage the desired state of the application by defining how many pod replicas should be running and by automatically recreating pods when failures occur. This ensures that the application continues to run without manual intervention.

Services route network traffic to the appropriate pods using label selectors, providing a stable endpoint even when pods are recreated or their IP addresses change. This decouples the application from individual pod lifecycles and enables seamless communication within and outside the cluster.

### Challenges and wins

This project took me approximately [X hours/days] to complete, including learning the basics of Kubernetes, deploying the application, and testing its behavior under failure conditions. The most challenging part was understanding how Pods, Deployments, and Services work together, especially debugging networking and service exposure in a Kubernetes environment.

It was most rewarding to see the application remain available even after deleting a running pod, as this clearly demonstrated Kubernetes’ self-healing capabilities in a real, practical scenario. Completing this project helped me gain hands-on experience with container orchestration and improved my confidence in deploying production-ready applications.

### Why I did this project

I did this project because I wanted to learn how real-world applications are deployed and managed beyond just running containers locally. I wanted to understand how Kubernetes handles failures, networking, and application availability in a production-like environment.

One thing I’ll apply from this project is designing applications with resilience in mind, using Deployments and Services to ensure that applications can automatically recover from failures and remain accessible without manual intervention.

---

## Setting Up My Docker Image

In this step, I'm setting up Docker image. I need a Docker image because Kubernetes Kubernetes can only run things that are already packaged.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_i9j0k1l2)

### What the Docker image contains

I ran docker images and saw my images. The image size was 1.34 GB  The IMAGE ID was 2e281b6fd4ec 

### Docker image vs container

---

## Installing Kubernetes Tools

In this step, I’m installing Minikube and kubectl. I need these tools because Minikube lets me run a local Kubernetes cluster on my computer, and kubectl allows me to interact with and manage that cluster from the command line. Together, they provide everything I need to deploy, test, and control my containerized application locally.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_u1v2w3x4)

### Verifying the tools are installed

I installed Minikube using the winget install -e --id Kubernetes.minikube command in Windows PowerShell. I installed kubectl using the winget install -e --id Kubernetes.kubectl command. I could tell both installations were successful because PowerShell displayed a “Successfully installed” message for each package, and the tools became available after restarting the shell, which allowed their versions to be verified using minikube version and kubectl version --client.

### Minikube vs kubectl

---

## Starting My Kubernetes Cluster

In this step, I’m starting Minikube using the Docker driver. Minikube will create a local, single-node Kubernetes cluster using Docker containers instead of a virtual machine. I also need to load the required container images so that Kubernetes can run pods and services inside the cluster.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_g3h4i5j6)

### Loading the Docker image into Minikube

I started the Kubernetes cluster by running the appropriate Minikube command and verified that the cluster was running successfully. Then, I loaded my Docker image into the Minikube environment so that Kubernetes could access it. After that, I ran kubectl get nodes, which showed the node status as Ready, confirming that the cluster was fully initialized and able to run containers.

### Why load image into Minikube

eval $(minikube docker-env) makes your Docker commands talk directly to Minikube, so Kubernetes can use your images without pulling them from the internet.

---

## Deploying to Kubernetes

In this step, I'm deployin my container using Kubernetes. I need a Deployment because that's how Kubernetes takes over application

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_s5t6u7v8)

### How the Deployment keeps my app running

The deployment.yaml file tells Kubernetes how to run and manage your application as a Deployment. The key parts are the metadata, spec, selector, template, and container configuration. The image field specifies which container image Kubernetes should run for your app. The replicas field means how many identical copies (pods) of your application should be running at the same time.
After that opening idea, here’s what your specific file is doing in simple terms:
apiVersion: apps/v1 & kind: Deployment
This tells Kubernetes you are creating a Deployment using the stable apps API.
metadata.name: rag-app-deployment
This is just the name of the Deployment inside the cluster.
replicas: 1
Kubernetes will keep exactly one pod running. If it crashes, Kubernetes will recreate it.
selector.matchLabels.app: rag-api
This tells the Deployment which pods it owns. It must match the labels in the pod template.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_a3b4c5d6)

### What did you observe when checking your pods?

The pod was created successfully, but Kubernetes could not start the container because it failed to find or pull the Docker image. As a result, the container is not running, and the pod is not ready.

---

## Creating a Service

In this step, I'm creating a Kubernetes Service. I need a Service because it runs the app

### What does the service.yaml file do?

The service.yaml file tells Kubernetes to create a stable network endpoint that exposes your RAG API and manages traffic to the correct Pods, even if those Pods restart or change IP addresses.

The selector finds Pods by matching labels—specifically app=rag-api—so the Service knows exactly which Pods should receive incoming requests. This label must match the labels defined in your Deployment, otherwise no traffic will be routed.

The port configuration allows the Service to listen on port 8000 and forward all incoming traffic to port 8000 inside the selected Pods, which is where the RAG API application is running.

NodePort enables access from outside by opening a high-numbered port (between 30000–32767) on each node in the cluster and forwarding traffic from that port to the Service, making the API reachable from your local machine when using Minikube.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_m5n6o7p8)

### What kubectl commands did you run to create the service?

I applied my Service file by running kubectl apply -f service.yaml. I then verified that the Service was created by kubectl get services

---

## Accessing My API Through Kubernetes

In this step, I'm testing my API is running in Kubernetes

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_y7z8a9b0)

### How I accessed my API

I tested my API by running POST requests to the exposed service endpoint using curl. The response returned valid data from the /query and /add endpoints, indicating that the API was reachable and functioning as expected. This confirms that the application was successfully deployed in the Kubernetes cluster, the pod was running correctly, and the service was properly exposing the application through a NodePort.The main difference between Docker and Kubernetes deployment is that Docker focuses on running a single containerized application, while Kubernetes is responsible for orchestrating and managing multiple containers across a cluster. Docker ensures that the application runs consistently inside a container, whereas Kubernetes handles scalability, service discovery, load balancing, self-healing, and rolling updates. In this deployment, Docker was used to package the RAG API, and Kubernetes ensured that the application remained available and accessible even in a distributed environment

### Request flow through Kubernetes

The request flow went from my computer to the Kubernetes node using the node’s IP address and NodePort. NodePort enabled external access by exposing the Service on a specific port of the node. The node then forwarded the request to the Kubernetes Service. The Service routed traffic by using its selector to identify the matching Pods and load-balancing the request to one of them. The selected Pod passed the request to the container where the API was running, and the response traveled back through the same path to the client.

---

## Testing Self-Healing

In this project extension, I’m demonstrating Kubernetes’ self-healing capability by manually deleting a running pod and observing how the system automatically creates a replacement pod without any manual intervention. Even though the pod was terminated, Kubernetes continuously monitored the desired state defined in the Deployment and ensured that a new pod was started to maintain application availability.

Self-healing is important because it allows applications to remain highly available and resilient to failures. In real-world systems, pods can fail due to crashes, resource limits, or node issues. Kubernetes detects these failures and automatically restarts or replaces the affected pods, ensuring minimal downtime. This reduces the need for manual monitoring and intervention, making applications more reliable and suitable for production environments.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_w8x9y0z1)

### What did you observe when you deleted the pod?

When I deleted the pod, I saw the status change from running to terminating to ContainerCreating A new pod was created because of Reconciliation loop

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-kubernetes_sm3j8k9l)

### How the Service routed traffic to the new pod

he Service automatically redirected traffic to the newly created pod because Kubernetes Services use label selectors to dynamically track healthy pods rather than relying on fixed IP addresses. When the original pod was deleted, the Service detected the replacement pod with the same labels and immediately began routing requests to it without requiring any configuration changes.

Without Kubernetes, this would have required manual intervention, such as restarting the application, updating IP addresses, or reconfiguring networking and load-balancing rules, which could lead to downtime and service disruption.

Self-healing is critical in production because applications must remain available despite unexpected failures. Kubernetes’ ability to automatically detect failures and recover ensures high availability, fault tolerance, and consistent user experience, making it suitable for large-scale, real-world systems.

---

---
