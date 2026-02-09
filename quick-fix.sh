#!/bin/bash
# Quick Fix Script for RAG App Deployment Issues

set -e  # Exit on error

echo "==================================="
echo "RAG App Deployment Quick Fix Script"
echo "==================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Clean up existing resources
echo -e "${YELLOW}Step 1: Cleaning up existing deployment...${NC}"
kubectl delete deployment rag-app-deployment --ignore-not-found=true
kubectl delete service rag-app-service --ignore-not-found=true
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

# Step 2: Configure Docker to use minikube's daemon
echo -e "${YELLOW}Step 2: Configuring Docker to use minikube's daemon...${NC}"
eval $(minikube docker-env)
echo -e "${GREEN}✓ Docker configured${NC}"
echo ""

# Step 3: Build Docker image in minikube environment
echo -e "${YELLOW}Step 3: Building Docker image in minikube...${NC}"
docker build -t rag-app:latest .
echo -e "${GREEN}✓ Image built successfully${NC}"
echo ""

# Step 4: Verify image exists
echo -e "${YELLOW}Step 4: Verifying image exists in minikube...${NC}"
if docker images | grep -q "rag-app"; then
    echo -e "${GREEN}✓ Image found in minikube's Docker${NC}"
    docker images | grep rag-app
else
    echo -e "${RED}✗ Image not found! Build may have failed.${NC}"
    exit 1
fi
echo ""

# Step 5: Create fixed deployment.yaml if it doesn't exist
echo -e "${YELLOW}Step 5: Creating corrected deployment configuration...${NC}"
cat > deployment-fixed.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rag-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: rag-app
  template:
    metadata:
      labels:
        app: rag-app
    spec:
      containers:
      - name: rag-api-container
        image: rag-app:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 8000
        env:
        - name: OLLAMA_HOST
          value: "host.docker.internal:11434"
EOF
echo -e "${GREEN}✓ Fixed deployment.yaml created${NC}"
echo ""

# Step 6: Apply deployment
echo -e "${YELLOW}Step 6: Deploying to Kubernetes...${NC}"
kubectl apply -f deployment-fixed.yaml
kubectl apply -f service.yaml
echo -e "${GREEN}✓ Deployment and service created${NC}"
echo ""

# Step 7: Wait for pod to be ready
echo -e "${YELLOW}Step 7: Waiting for pod to be ready (max 60s)...${NC}"
kubectl wait --for=condition=ready pod -l app=rag-app --timeout=60s || {
    echo -e "${RED}✗ Pod failed to become ready. Checking logs...${NC}"
    echo ""
    echo "Pod status:"
    kubectl get pods -l app=rag-app
    echo ""
    echo "Pod description:"
    kubectl describe pod -l app=rag-app
    echo ""
    echo "Recent events:"
    kubectl get events --sort-by=.metadata.creationTimestamp | tail -10
    exit 1
}
echo -e "${GREEN}✓ Pod is ready${NC}"
echo ""

# Step 8: Get service URL
echo -e "${YELLOW}Step 8: Getting service URL...${NC}"
SERVICE_URL=$(minikube service rag-app-service --url)
echo -e "${GREEN}✓ Service URL: ${SERVICE_URL}${NC}"
echo ""

# Step 9: Display summary
echo "==================================="
echo -e "${GREEN}Deployment Successful!${NC}"
echo "==================================="
echo ""
echo "Service URL: ${SERVICE_URL}"
echo ""
echo "Test the API with:"
echo "  curl -X POST \"${SERVICE_URL}/query\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"question\":\"What is Kubernetes?\"}'"
echo ""
echo "View pods:"
echo "  kubectl get pods -l app=rag-app"
echo ""
echo "View logs:"
echo "  kubectl logs -l app=rag-app"
echo ""
echo "==================================="
