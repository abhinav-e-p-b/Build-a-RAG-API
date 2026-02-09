from fastapi import FastAPI
import chromadb
import ollama
import os

app = FastAPI()

chroma = chromadb.PersistentClient(path="./db")
collection = chroma.get_or_create_collection("docs")

OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://127.0.0.1:11434")
ollama_client = ollama.Client(host=OLLAMA_HOST)


@app.post("/query")
def query(q: str):
    results = collection.query(query_texts=[q], n_results=1)
    docs = results.get("documents", [])
    context = docs[0][0] if docs and docs[0] else ""

    answer = ollama_client.generate(
        model="tinyllama",
        prompt=f"Context:\n{context}\n\nQuestion: {q}\n\nAnswer clearly and concisely:"
    )

    return {"answer": answer["response"]}


@app.post("/add")
def add_knowledge(text: str):
    import uuid
    doc_id = str(uuid.uuid4())
    collection.add(documents=[text], ids=[doc_id])
    return {"status": "success", "id": doc_id}
