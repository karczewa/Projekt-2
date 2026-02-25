from fastapi import APIRouter

router = APIRouter(prefix="/audit", tags=["audit"])

# AUD-01 · Log data modifications       — written automatically by other routers
# AUD-02 · Log record access            — written automatically by other routers
# View audit log                        — GET    /audit?date_from=&date_to=
