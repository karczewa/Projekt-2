from fastapi import APIRouter

router = APIRouter(prefix="/citizens/{citizen_id}/documents", tags=["documents"])

# US-06  · Add identity document        — POST   /citizens/{id}/documents
# US-06b · Series/number validation     — handled in POST via Pydantic
# US-07  · View document history        — GET    /citizens/{id}/documents
