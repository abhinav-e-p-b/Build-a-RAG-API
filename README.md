# RAG API with FastAPI and Docker

A production-ready Retrieval-Augmented Generation (RAG) system built with FastAPI, ChromaDB, and Ollama. This project demonstrates how to build, containerize, and deploy an AI-powered API that combines information retrieval with large language models.

[![CI Pipeline](https://github.com/yourusername/rag-api/workflows/RAG%20CI%20Pipeline/badge.svg)](https://github.com/yourusername/rag-api/actions)

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project implements a Retrieval-Augmented Generation (RAG) system that:
- Accepts natural language queries through REST API endpoints
- Retrieves relevant information from a vector database (ChromaDB)
- Generates accurate, context-aware responses using a local LLM (TinyLlama via Ollama)
- Supports dynamic knowledge base updates
- Runs consistently across environments through Docker containerization

### What is RAG?

RAG combines the power of information retrieval with generative AI. Instead of relying solely on a language model's training data, RAG:
1. Retrieves relevant documents from a knowledge base
2. Provides this context to the language model
3. Generates responses grounded in the retrieved information

This approach reduces hallucinations and enables the model to answer questions about domain-specific information.

## ✨ Features

- **RESTful API**: FastAPI-based endpoints for querying and adding knowledge
- **Vector Search**: ChromaDB for efficient semantic similarity search
- **Local LLM**: Ollama integration with TinyLlama for text generation
- **Dynamic Updates**: Real-time knowledge base expansion via API
- **Containerized**: Docker support for consistent deployment
- **Kubernetes Ready**: K8s manifests for orchestrated deployment
- **CI/CD Pipeline**: Automated testing and quality checks with GitHub Actions
- **Interactive Docs**: Auto-generated Swagger UI documentation
- **Mock Mode**: Testing support without requiring Ollama

## 🏗️ Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│         FastAPI Application         │
│  ┌───────────┐      ┌────────────┐ │
│  │  /query   │      │   /add     │ │
│  └─────┬─────┘      └─────┬──────┘ │
└────────┼──────────────────┼─────────┘
         │                  │
         ▼                  ▼
┌─────────────────────────────────────┐
│         ChromaDB (Vector DB)        │
│    ┌──────────────────────────┐    │
│    │  Embedded Documents       │    │
│    │  (Semantic Vectors)       │    │
│    └──────────────────────────┘    │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│      Ollama (LLM Runtime)           │
│    ┌──────────────────────────┐    │
│    │     TinyLlama Model       │    │
│    └──────────────────────────┘    │
└─────────────────────────────────────┘
```

### How It Works

1. **Query Processing**: User sends a question to `/query` endpoint
2. **Embedding Generation**: Query is converted to a vector embedding
3. **Semantic Search**: ChromaDB finds most relevant documents
4. **Context Retrieval**: Top matching documents are extracted
5. **LLM Generation**: Ollama generates response using retrieved context
6. **Response**: Formatted answer returned to user

## 📦 Prerequisites

- **Python 3.10+**
- **Docker** (for containerization)
- **Ollama** (for local LLM inference)
- **Minikube/kubectl** (optional, for Kubernetes deployment)

## 🚀 Quick Start

### Option 1: Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/rag-api.git
cd rag-api

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Download and run Ollama with TinyLlama
ollama pull tinyllama

# Generate embeddings from knowledge base
python embed_docs.py

# Start the API server
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Access the API at `http://localhost:8000` and interactive docs at `http://localhost:8000/docs`

### Option 2: Docker

```bash
# Build the Docker image
docker build -t rag-app:latest .

# Run the container
docker run -p 8000:8000 rag-app:latest
```

### Option 3: Docker Hub

```bash
# Pull pre-built image
docker pull abhinavepb/rag-app:latest

# Run the container
docker run -p 8000:8000 abhinavepb/rag-app:latest
```

## 💻 Installation

### Step 1: Clone Repository

```bash
git clone https://github.com/yourusername/rag-api.git
cd rag-api
```

### Step 2: Set Up Python Environment

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

**Core Dependencies:**
- `fastapi` - Web framework for building APIs
- `uvicorn` - ASGI server for running FastAPI
- `chromadb` - Vector database for embeddings
- `ollama` - Python client for Ollama LLM
- `requests` - HTTP library for testing

### Step 4: Install Ollama

**macOS:**
```bash
brew install ollama
```

**Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**Windows:**
Download from [ollama.com](https://ollama.com/download)

### Step 5: Pull TinyLlama Model

```bash
ollama pull tinyllama
```

### Step 6: Prepare Knowledge Base

Add your documents to the `docs/` folder:

```bash
mkdir -p docs
echo "Your knowledge content here" > docs/example.txt
```

### Step 7: Generate Embeddings

```bash
python embed_docs.py
```

This creates the `db/` folder with ChromaDB embeddings.

## 🔧 Usage

### Starting the Server

```bash
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

### API Endpoints

#### 1. Query Endpoint

**POST** `/query`

Query the knowledge base and get AI-generated responses.

```bash
curl -X POST "http://localhost:8000/query?q=What%20is%20Kubernetes?" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "answer": "Kubernetes is a container platform used to manage containers at scale..."
}
```

#### 2. Add Knowledge Endpoint

**POST** `/add`

Dynamically add new content to the knowledge base.

```bash
curl -X POST "http://localhost:8000/add?text=Docker%20is%20a%20containerization%20platform" \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "status": "success",
  "id": "550e8400-e29b-41d4-a716-446655440000"
}
```

### Using Swagger UI

1. Navigate to `http://localhost:8000/docs`
2. Click on an endpoint to expand
3. Click "Try it out"
4. Enter your parameters
5. Click "Execute"
6. View the response below

## 📚 API Documentation

### Interactive Documentation

- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`

### Request/Response Examples

#### Query Request

```json
POST /query?q=What+is+Kubernetes
Content-Type: application/json
```

#### Query Response

```json
{
  "answer": "Kubernetes is a container platform used to manage containers at scale. It provides orchestration, scaling, and deployment capabilities for containerized applications."
}
```

#### Add Knowledge Request

```json
POST /add?text=FastAPI+is+a+modern+web+framework
Content-Type: application/json
```

#### Add Knowledge Response

```json
{
  "status": "success",
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

## 🐳 Docker Deployment

### Building the Image

```bash
docker build -t rag-app:latest .
```

### Running the Container

```bash
docker run -p 8000:8000 rag-app:latest
```

### Using Docker Compose (Optional)

Create `docker-compose.yml`:

```yaml
version: '3.8'
services:
  rag-api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OLLAMA_HOST=http://host.docker.internal:11434
    volumes:
      - ./db:/app/db
```

Run with:
```bash
docker-compose up
```

### Pushing to Docker Hub

```bash
# Tag the image
docker tag rag-app:latest yourusername/rag-app:latest

# Login to Docker Hub
docker login

# Push the image
docker push yourusername/rag-app:latest
```

## ☸️ Kubernetes Deployment

### Prerequisites

- Minikube installed and running
- kubectl configured

### Quick Deploy Script

Use the provided quick-fix script for automated deployment:

```bash
chmod +x quick-fix.sh
./quick-fix.sh
```

### Manual Deployment

#### Step 1: Start Minikube

```bash
minikube start
```

#### Step 2: Configure Docker Environment

```bash
eval $(minikube docker-env)
```

#### Step 3: Build Image in Minikube

```bash
docker build -t rag-app:latest .
```

#### Step 4: Deploy to Kubernetes

```bash
# Apply deployment
kubectl apply -f deployment-fixed.yaml

# Apply service
kubectl apply -f service.yaml
```

#### Step 5: Verify Deployment

```bash
# Check pods
kubectl get pods -l app=rag-app

# Check service
kubectl get service rag-app-service

# Get service URL
minikube service rag-app-service --url
```

#### Step 6: Test the Deployment

```bash
SERVICE_URL=$(minikube service rag-app-service --url)
curl -X POST "$SERVICE_URL/query?q=What%20is%20Kubernetes?"
```

### Kubernetes Resources

The project includes:
- **deployment.yaml**: Defines the pod deployment
- **deployment-fixed.yaml**: Corrected deployment with proper image pull policy
- **service.yaml**: NodePort service for external access

### Troubleshooting K8s Deployment

**Pod not starting:**
```bash
kubectl describe pod -l app=rag-app
kubectl logs -l app=rag-app
```

**Image pull errors:**
- Ensure `imagePullPolicy: Never` is set
- Rebuild image in minikube's Docker daemon

**Service not accessible:**
```bash
minikube service rag-app-service --url
```

## 🔄 CI/CD Pipeline

The project includes three GitHub Actions workflows:

### 1. RAG CI Pipeline (`.github/workflows/ci.yml`)

Triggers on changes to:
- `docs/**` (knowledge base files)
- `app.py` (API code)
- `embed_docs.py` (embedding script)

**Pipeline Steps:**
1. Checkout code
2. Set up Python 3.11
3. Install dependencies
4. Rebuild embeddings from docs
5. Start API in mock mode (no Ollama required)
6. Run semantic tests
7. Validate RAG quality

### 2. Python Application Pipeline (`.github/workflows/python-app.yml`)

Standard Python testing workflow:
- Linting with flake8
- Testing with pytest
- Runs on push/PR to main branch

### 3. Issue Summarization (`.github/workflows/summary.yml`)

Uses GitHub's AI inference action to:
- Automatically summarize new issues
- Post summary as a comment

### Running Tests Locally

```bash
# With mock LLM (no Ollama needed)
USE_MOCK_LLM=1 uvicorn app:app --host 0.0.0.0 --port 8000 &
python semantic_test.py

# With real Ollama
uvicorn app:app --reload &
python semantic_test.py
```

## 📁 Project Structure

```
rag-api/
│
├── .github/
│   └── workflows/
│       ├── ci.yml                 # RAG CI pipeline
│       ├── python-app.yml         # Python linting/testing
│       └── summary.yml            # Issue summarization
│
├── docs/                          # Knowledge base documents
│   └── k8s.txt                    # Example document
│
├── db/                            # ChromaDB vector database (generated)
│
├── app.py                         # Main FastAPI application
├── embed_docs.py                  # Embedding generation script
├── embed.py                       # Legacy embedding script
├── semantic_test.py               # Semantic quality tests
│
├── deployment.yaml                # Kubernetes deployment manifest
├── deployment-fixed.yaml          # Fixed K8s deployment
├── service.yaml                   # Kubernetes service manifest
├── quick-fix.sh                   # K8s deployment automation script
│
├── Dockerfile                     # Docker image definition
├── requirements.txt               # Python dependencies
├── .gitignore                     # Git ignore rules
└── README.md                      # This file
```

### Key Files Explained

- **app.py**: FastAPI application with `/query` and `/add` endpoints
- **embed_docs.py**: Processes all `.txt` files in `docs/` and creates embeddings
- **semantic_test.py**: Validates RAG responses contain expected keywords
- **Dockerfile**: Multi-stage build for containerizing the application
- **deployment-fixed.yaml**: Kubernetes deployment with correct image settings
- **quick-fix.sh**: Automated Kubernetes deployment script with error handling

## ⚙️ Configuration

### Environment Variables

- `OLLAMA_HOST`: Ollama server URL (default: `http://127.0.0.1:11434`)
- `USE_MOCK_LLM`: Set to `1` to enable mock mode for testing without Ollama

### Mock Mode for Testing

The application supports a mock mode for CI/CD testing:

```bash
USE_MOCK_LLM=1 uvicorn app:app --host 0.0.0.0 --port 8000
```

In mock mode:
- No Ollama connection required
- Returns retrieved context directly as the answer
- Useful for testing retrieval without LLM inference

### Docker Configuration

For containers to access Ollama running on the host:

```yaml
env:
  - name: OLLAMA_HOST
    value: "http://host.docker.internal:11434"
```

## 🧪 Testing

### Semantic Tests

The `semantic_test.py` file validates that responses contain expected keywords:

```python
def test_kubernetes_query():
    response = requests.post("http://127.0.0.1:8000/query?q=What is Kubernetes?")
    answer = response.json()["answer"]
    assert "container" in answer.lower()
```

### Running Tests

```bash
# Start the server first
uvicorn app:app --reload &

# Run tests
python semantic_test.py
```

### Expected Output

```
✅ Kubernetes query test passed
✅ NextWork query test passed
All semantic tests passed!
```

### Adding New Tests

1. Add new document to `docs/` folder
2. Run `python embed_docs.py`
3. Add test function to `semantic_test.py`
4. Define expected keywords for validation

## 🔍 Troubleshooting

### Common Issues

#### 1. Ollama Connection Error

**Problem:** `ConnectionError: Failed to connect to Ollama`

**Solution:**
```bash
# Check if Ollama is running
ollama list

# Start Ollama service
ollama serve

# Verify TinyLlama model is available
ollama pull tinyllama
```

#### 2. Empty Database

**Problem:** No results returned from queries

**Solution:**
```bash
# Regenerate embeddings
python embed_docs.py

# Verify database exists
ls -la db/
```

#### 3. Docker Image Not Found in Kubernetes

**Problem:** `ImagePullBackOff` or `ErrImagePull`

**Solution:**
```bash
# Use minikube's Docker daemon
eval $(minikube docker-env)

# Rebuild image
docker build -t rag-app:latest .

# Verify image exists
docker images | grep rag-app

# Use deployment-fixed.yaml with imagePullPolicy: Never
kubectl apply -f deployment-fixed.yaml
```

#### 4. Port Already in Use

**Problem:** `Address already in use: 8000`

**Solution:**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use a different port
uvicorn app:app --port 8001
```

#### 5. Module Not Found Error

**Problem:** `ModuleNotFoundError: No module named 'chromadb'`

**Solution:**
```bash
# Ensure virtual environment is activated
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

### Debug Mode

Enable debug logging:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guidelines
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

### Running Linters

```bash
# Install flake8
pip install flake8

# Run linter
flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
```

## 📝 Future Enhancements

- [ ] Authentication and authorization
- [ ] Rate limiting for API endpoints
- [ ] Caching layer for frequent queries
- [ ] Support for multiple LLM models
- [ ] Advanced embedding models (e.g., sentence-transformers)
- [ ] Monitoring and observability (Prometheus, Grafana)
- [ ] Horizontal pod autoscaling in Kubernetes
- [ ] Document chunking for large files
- [ ] Multi-language support
- [ ] Query history and analytics

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Abhinave P.B**
- Email: abhinavepb12@gmail.com
- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- [FastAPI](https://fastapi.tiangolo.com/) - Modern web framework
- [ChromaDB](https://www.trychroma.com/) - Vector database
- [Ollama](https://ollama.com/) - Local LLM runtime
- [Docker](https://www.docker.com/) - Containerization platform
- [Kubernetes](https://kubernetes.io/) - Container orchestration

## 📚 Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [ChromaDB Documentation](https://docs.trychroma.com/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [RAG Concepts](https://www.pinecone.io/learn/retrieval-augmented-generation/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

---

**Built with ❤️ using FastAPI, ChromaDB, and Ollama**
