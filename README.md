<img src="https://cdn.prod.website-files.com/677c400686e724409a5a7409/6790ad949cf622dc8dcd9fe4_nextwork-logo-leather.svg" alt="NextWork" width="300" />

# Build and Containerize a RAG API with FastAPI and Docker

**Author:** Abhinave P.B  
**Email:** abhinavepb12@gmail.com

---

## Table of Contents
- [Project Overview](#project-overview)
- [Part 1: Building the RAG API](#part-1-building-the-rag-api)
  - [Setting Up Python and Ollama](#setting-up-python-and-ollama)
  - [Setting Up a Python Workspace](#setting-up-a-python-workspace)
  - [Setting Up a Knowledge Base](#setting-up-a-knowledge-base)
  - [Building the RAG API](#building-the-rag-api)
  - [Testing the RAG API](#testing-the-rag-api)
  - [Adding Dynamic Content](#adding-dynamic-content)
- [Part 2: Containerizing with Docker](#part-2-containerizing-with-docker)
  - [Installing Docker Desktop](#installing-docker-desktop)
  - [Creating the Dockerfile](#creating-the-dockerfile)
  - [Building and Running the Container](#building-and-running-the-container)
  - [Pushing to Docker Hub](#pushing-to-docker-hub)
- [Key Takeaways](#key-takeaways)

---

## Project Overview

This comprehensive project demonstrates how to design, build, and containerize a Retrieval-Augmented Generation (RAG) system using FastAPI and Docker. The API allows users to submit natural language questions, retrieves the most relevant information from a custom document knowledge base stored in Chroma, and generates accurate, context-aware responses using Ollama.

### What I Built

A production-ready RAG API that:
- Accepts natural language queries through REST endpoints
- Retrieves relevant information from a vector database
- Generates context-aware responses using a local LLM
- Supports dynamic content addition to the knowledge base
- Runs consistently across any environment through Docker containerization

### Why This Project

I undertook this project to learn how modern AI systems combine information retrieval with large language models, and how to expose such systems through real-world APIs. Through this journey, I gained hands-on experience with vector databases, embeddings, FastAPI backend development, integrating local LLMs, and containerization with Docker.

### Technologies Used

**Core Services:**
- Python - Backend programming language
- FastAPI - Modern, high-performance web framework for building APIs
- ChromaDB - Vector database for storing and retrieving embeddings
- Ollama - Platform for running LLMs locally
- TinyLlama - Lightweight language model for text generation
- Uvicorn - ASGI server for serving the FastAPI application
- Docker - Containerization platform
- Docker Hub - Cloud-based registry for Docker images

**Key Concepts:**
- API development and REST endpoints
- Retrieval-Augmented Generation (RAG)
- Vector embeddings and semantic search
- Virtual environment and dependency management
- Containerization and cross-environment consistency
- Interactive API documentation with Swagger UI
- Versioning and distribution via Docker Hub

### Project Timeline

**Part 1 (FastAPI Development):** ~2 hours  
**Part 2 (Docker Containerization):** ~2 hours  
**Total:** ~4 hours

---

## Part 1: Building the RAG API

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_g3h4i5j6)

### Setting Up Python and Ollama

In this step, I set up the foundational tools required for the project. Python is a popular high-level programming language widely used for backend development and API creation. Ollama is an open-source platform that allows large language models (LLMs) to run locally on a device.

#### Python and Ollama Setup

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_i9j0k1l2)

#### Why Ollama and TinyLlama?

Ollama is a local LLM runtime that allows developers to easily download, manage, and run large language models on their own machines without relying on cloud-based services.

I downloaded the TinyLlama model because it is:
- Lightweight and resource-efficient
- Can run smoothly on systems with limited computational power
- Provides reasonable natural language understanding and generation capabilities

The model helps my RAG API by:
- Generating accurate, context-aware responses using retrieved information
- Improving response relevance
- Reducing hallucinations
- Enabling faster, cost-effective local inference

---

### Setting Up a Python Workspace

This step involves creating a proper Python development environment with isolated dependencies.

#### Creating a Virtual Environment

A virtual environment is an isolated Python workspace that allows a project to use its own set of libraries and dependencies without affecting other Python projects on the same system.

**Why I created one:**
- Avoid dependency conflicts
- Ensure consistent package versions
- Maintain a clean and stable development environment
- All packages are limited to this project only

**To create a virtual environment:**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

#### Installing Dependencies

The packages I installed are FastAPI, Chroma, Uvicorn, and Ollama.

**FastAPI** - Used for building the backend API of the application, allowing fast, efficient handling of HTTP requests and responses for the RAG system.

**Chroma** - Used as a vector database to store and retrieve embeddings, enabling efficient similarity search over documents for retrieval-augmented generation.

**Uvicorn** - Used as an ASGI server to run and serve the FastAPI application with high performance.

**Ollama** - Used to run large language models locally, which generate natural language responses based on the retrieved context in the RAG pipeline.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_u1v2w3x4)

```bash
pip install fastapi chromadb uvicorn ollama
```

---

### Setting Up a Knowledge Base

In this step, I created a knowledge base that stores all the documents and information my RAG system uses to answer user queries.

#### What is a Knowledge Base?

A knowledge base is a structured collection of text data (such as notes, documents, or FAQs) that can be processed, indexed, and searched by an AI model.

**Why it's needed:**
The RAG API retrieves relevant information from this knowledge base and provides accurate, context-aware answers instead of relying only on the model's general knowledge.

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_t1u2v3w4)

#### Understanding Embeddings

**What are embeddings?**
Embeddings are numerical vector representations of text that capture the semantic meaning of the content, allowing the AI to understand and compare text based on meaning rather than exact words.

**How I created them:**
- Processed knowledge base content using an embedding model
- Converted each text chunk into vectors
- Stored them in the `db/` folder

**Why embeddings are important for RAG:**
- Enable fast similarity search
- Allow efficient retrieval of relevant information
- Help the system find semantically similar content
- Provide context to the language model for generating accurate responses

---

### Building the RAG API

In this step, I built the core RAG API that connects user queries with the knowledge base and language model.

#### What is FastAPI?

FastAPI is a modern, high-performance Python web framework used to build APIs quickly and efficiently, with automatic documentation and async support.

**Why I'm using it:**
The RAG API acts as the backend service that receives user queries, retrieves relevant information from the knowledge base, and generates accurate answers using the language model.

#### How the RAG API Works

My RAG API works by combining information retrieval with text generation:

1. User sends a question to the API
2. API converts the query into an embedding
3. Embedding is compared with stored embeddings in the vector database
4. Most relevant documents are retrieved from the knowledge base
5. Retrieved content is passed as context to the language model
6. Model generates a clear and relevant response

**Main Components:**

- **Knowledge Base** - Stores the source documents with domain-specific information
- **Embedding Model** - Converts both documents and user queries into vector representations
- **Vector Database (Chroma / db folder)** - Stores embeddings and enables fast similarity search
- **Retriever** - Finds the most relevant documents based on query embedding
- **Language Model (Ollama / TinyLlama)** - Generates the final response using retrieved context

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_f3g4h5i6)

---

### Testing the RAG API

Testing is crucial to verify that the API works correctly and returns accurate responses.

#### Testing with Swagger UI

Swagger UI is an interactive web-based interface automatically generated by FastAPI that allows developers to:
- View API endpoints
- Send sample requests
- Inspect responses directly from the browser
- Test without writing client-side code

#### Testing with curl

I also tested the API using curl commands:

```bash
curl -X POST "http://localhost:8000/query" -H "Content-Type: application/json" -d '{"question":"Your question here"}'
```

**Understanding the command:**
- Uses the POST method to send data to the server
- Server processes the data and returns a response
- Confirms the endpoint is working correctly

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_g3h4i5j6)

#### Benefits of Swagger UI

The best part about using Swagger UI:
- Provides real-time API testing
- Shows clear request and response formats
- Makes debugging and verification easy
- No need to write additional test code

---

### Adding Dynamic Content

In this extension, I added functionality to dynamically update the knowledge base in real-time.

#### The /add Endpoint

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-api_w9x0y1z2)

The `/add` endpoint allows me to submit new content directly to the knowledge base via an API.

**Why this is useful:**
- Updates the system in real time
- No manual file editing required
- No server restart needed
- Mimics production API behavior
- Enables continuous knowledge base expansion

**How it works:**
1. Send a POST request with new content
2. Content is processed and converted to embeddings
3. Embeddings are stored in the vector database
4. Content immediately becomes searchable
5. Future queries can retrieve this new information

---

## Part 2: Containerizing with Docker

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_x7y8z9a0)

### Installing Docker Desktop

#### What is Docker Desktop?

Docker Desktop is a tool that allows me to run and manage Docker containers on my system, providing a consistent and isolated development environment.

**Why I installed it:**
- Ensures consistent environment across different machines
- Avoids compatibility and setup issues
- Simplifies dependency management
- Eliminates "it works on my machine" problems

#### Benefits of Containerization

Containerization helps my project by:
- Ensuring consistency across development, testing, and production
- Simplifying dependency management
- Making the application easier to test and scale
- Enabling easy deployment
- Packaging everything needed to run the application

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_i9j0k1l2)

#### Verifying Docker Installation

I verified Docker is working by running the hello-world container:

```bash
docker run hello-world
```

This proves that:
- Docker is correctly installed
- The Docker daemon is running
- Images can be pulled from Docker Hub
- Containers can be created and executed successfully

---

### Creating the Dockerfile

#### What is a Dockerfile?

A Dockerfile is a text file that contains a set of instructions used by Docker to build a Docker image.

#### Key Dockerfile Instructions

**FROM** - Tells Docker to use a specific base image as the starting point

**COPY** - Copies files and folders from the host machine into the Docker image

**RUN** - Executes commands during the image build process (installing packages, dependencies, etc.)

**CMD** - Defines the default command that runs when a container starts from the image

#### Project Structure for Containerization

Files created:
- `main.py` - Defines the API endpoints
- `rag.py` - Implements the retrieval and generation logic
- `requirements.txt` - Manages dependencies
- `Dockerfile` - Containerizes the API for consistent deployment

---

### Building and Running the Container

#### Building the Docker Image

Building a Docker image involves:
1. Writing a Dockerfile that defines the base environment
2. Installing all required dependencies
3. Copying the application code
4. Executing necessary setup steps
5. Packaging everything into a single image

```bash
docker build -t rag-app:latest .
```

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_p9q0r1s2)

#### Verifying the Build

I verified my Docker image was built successfully by:
```bash
docker images
```

This confirms that:
- The `rag-app:latest` image appeared with a valid image ID and size
- The entire application, its dependencies, and precomputed embeddings are packaged
- The image can run consistently on any system using Docker

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_x7y8z9a0)

#### Running the Containerized API

```bash
docker run -p 8000:8000 rag-app:latest
```

#### Testing Results

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_o1p2q3r4)

Testing the containerized API revealed:

**What worked:**
- FastAPI application runs consistently with all dependencies packaged
- Reproducible across environments

**Challenges discovered:**
- Host-specific services (like Ollama) not directly reachable from inside the container
- Container isolation requires `host.docker.internal` to reach host services

**Key differences between local and Docker:**

| Local Execution | Docker Container |
|----------------|------------------|
| Direct localhost access | Isolated environment |
| Depends on system setup | Self-contained |
| Manual dependency management | All dependencies packaged |
| Environment-specific issues | Consistent across systems |

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_c9d0e1f2)

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_v5w6x7y8)

---

### Pushing to Docker Hub

#### What is Docker Hub?

Docker Hub is a cloud-based registry where you can store and share Docker images.

#### Pushing to Docker Hub

Steps I followed:
1. Tagged my local Docker image with my Docker Hub repository name
2. Used `docker push` to upload it

```bash
docker tag rag-app:latest username/rag-app:latest
docker push username/rag-app:latest
```

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_m5n6o7p8)

#### Why Docker Hub is Useful

Advantages of pushing to a registry:
- Easy distribution of images
- Ensures consistency across environments
- Supports versioning
- Allows teams or deployment pipelines to pull and run the exact same image anywhere
- Central, cloud-based storage
- Facilitates collaboration

#### Pulling from Docker Hub

![Image](http://learn.nextwork.org/ecstatic_white_trusty_gecko/uploads/ai-devops-docker_f5g6h7i8)

Pulling an image means downloading a pre-built Docker image from Docker Hub to your local machine:

```bash
docker pull username/rag-app:latest
```

**Difference between building and pulling:**

| Building Locally | Pulling from Docker Hub |
|-----------------|------------------------|
| Creates new image from Dockerfile | Downloads pre-built image |
| Done on your machine | Fetched from cloud registry |
| Requires source code | Only needs image name |
| Takes time to build | Quick download |

---

## Key Takeaways

### What I Learned

**Technical Skills:**
- Building production-ready REST APIs with FastAPI
- Implementing Retrieval-Augmented Generation (RAG) systems
- Working with vector databases and embeddings
- Running local LLMs with Ollama
- Containerizing applications with Docker
- Publishing and distributing Docker images

**Best Practices:**
- Importance of virtual environments for dependency isolation
- Benefits of containerization for consistency
- Value of interactive API documentation
- Real-time knowledge base updates
- Cross-platform deployment strategies

### Challenges Faced

**Most Challenging Part (Part 1):** Understanding the basics of RAG systems and how embeddings work

**Most Challenging Part (Part 2):** Docker build process and container networking

### Most Rewarding Moments

**Part 1:** Building a hands-on FastAPI project and seeing the RAG system generate accurate responses

**Part 2:** Seeing the final containerized application run consistently across different environments

### Project Goals Achievement

✅ Learned about RAG systems and how they work  
✅ Built a functional FastAPI application  
✅ Implemented vector database for semantic search  
✅ Integrated local LLM for text generation  
✅ Created dynamic knowledge base functionality  
✅ Containerized the application with Docker  
✅ Successfully pushed to Docker Hub  
✅ Understood the benefits of containerization  

**Did it meet my goals?** Yes! This project certainly met all my learning goals and provided valuable hands-on experience with modern AI and DevOps technologies.

---

## Running the Project

### Local Development

1. Clone the repository
2. Create and activate virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Start Ollama and pull TinyLlama model
5. Run the application:
   ```bash
   uvicorn main:app --reload
   ```
6. Access Swagger UI at `http://localhost:8000/docs`

### Using Docker

1. Pull the image from Docker Hub:
   ```bash
   docker pull username/rag-app:latest
   ```
2. Run the container:
   ```bash
   docker run -p 8000:8000 rag-app:latest
   ```
3. Access the API at `http://localhost:8000`

---

## Future Enhancements

- Add authentication and authorization
- Implement caching for faster responses
- Support multiple LLM models
- Add monitoring and logging
- Deploy to cloud platforms
- Implement API rate limiting
- Add comprehensive test suite

---

**Project Links:**
- Part 1: [Build a RAG API with FastAPI](http://learn.nextwork.org/projects/ai-devops-api)
- Part 2: [Containerize a RAG API with Docker](http://learn.nextwork.org/projects/ai-devops-docker)

---

*This project was completed as part of learning modern AI development and DevOps practices.*
