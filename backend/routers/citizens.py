from fastapi import APIRouter

router = APIRouter(prefix="/citizens", tags=["citizens"])

# US-01 · Register a new citizen        — POST   /citizens
# US-02 · View citizen record           — GET    /citizens/{id}
# US-03 · Update citizen data           — PUT    /citizens/{id}
# US-04 · Delete citizen record         — DELETE /citizens/{id}
# US-05a · Search by name               — GET    /citizens?first_name=&last_name=
# US-05b · Search by PESEL              — GET    /citizens?pesel=
# US-05c · Search by address            — GET    /citizens?city=&street=
