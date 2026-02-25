from fastapi import APIRouter

router = APIRouter(prefix="/citizens/{citizen_id}/registration", tags=["registration"])

# US-08 · Record address change         — POST   /citizens/{id}/registration
# US-09 · View registration history     — GET    /citizens/{id}/registration
