from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from database import init_db
from routers import audit, citizens, documents, registration


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(title="Kartoteka Mieszkańca", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # React/Vite dev server
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(citizens.router)
app.include_router(documents.router)
app.include_router(registration.router)
app.include_router(audit.router)


@app.get("/health")
def health():
    return {"status": "ok"}
