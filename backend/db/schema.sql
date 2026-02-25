-- =============================================================
-- Kartoteka Mieszkańca — Database Schema
-- Database: SQLite (file-based)
-- =============================================================

PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- -------------------------------------------------------------
-- USERS
-- System accounts: clerks and administrators
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    role          TEXT    NOT NULL CHECK (role IN ('administrator', 'clerk')),
    is_active     INTEGER NOT NULL DEFAULT 1,  -- 0 = deactivated
    created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- -------------------------------------------------------------
-- CITIZENS
-- Core citizen record. Address fields are embedded.
-- Date of birth and sex are derived from PESEL and stored.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS citizens (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Personal data
    first_name           TEXT NOT NULL,
    last_name            TEXT NOT NULL,
    pesel                TEXT NOT NULL UNIQUE CHECK (length(pesel) = 11),
    date_of_birth        TEXT NOT NULL,  -- ISO 8601: YYYY-MM-DD (derived from PESEL)
    sex                  TEXT NOT NULL CHECK (sex IN ('M', 'K')),  -- derived from PESEL

    -- Contact (optional)
    phone                TEXT,
    email                TEXT,

    -- Registered address (required)
    reg_street           TEXT NOT NULL,
    reg_building_number  TEXT NOT NULL,
    reg_apartment_number TEXT,
    reg_postal_code      TEXT NOT NULL,
    reg_city             TEXT NOT NULL,

    -- Correspondence address (optional, only if different)
    corr_street          TEXT,
    corr_building_number TEXT,
    corr_apartment_number TEXT,
    corr_postal_code     TEXT,
    corr_city            TEXT,

    created_at           TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at           TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_citizens_pesel     ON citizens (pesel);
CREATE INDEX IF NOT EXISTS idx_citizens_last_name ON citizens (last_name);
CREATE INDEX IF NOT EXISTS idx_citizens_city      ON citizens (reg_city);

-- -------------------------------------------------------------
-- IDENTITY DOCUMENTS
-- Multiple documents per citizen; one marked as active.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS identity_documents (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    citizen_id        INTEGER NOT NULL REFERENCES citizens (id) ON DELETE CASCADE,
    document_type     TEXT    NOT NULL CHECK (document_type IN ('dowod_osobisty', 'paszport')),
    series_number     TEXT    NOT NULL,  -- combined series + number (e.g. "ABC 123456")
    issue_date        TEXT    NOT NULL,  -- ISO 8601: YYYY-MM-DD
    expiry_date       TEXT    NOT NULL,  -- ISO 8601: YYYY-MM-DD
    issuing_authority TEXT    NOT NULL,
    is_active         INTEGER NOT NULL DEFAULT 0,  -- only one active per citizen
    created_at        TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_docs_citizen ON identity_documents (citizen_id);

-- -------------------------------------------------------------
-- REGISTRATION HISTORY
-- One entry per address change. Stores new address and
-- a snapshot of the previous address at the time of change.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS registration_history (
    id                       INTEGER PRIMARY KEY AUTOINCREMENT,
    citizen_id               INTEGER NOT NULL REFERENCES citizens (id) ON DELETE CASCADE,
    registration_type        TEXT    NOT NULL CHECK (registration_type IN ('staly', 'tymczasowy')),
    effective_date           TEXT    NOT NULL,  -- ISO 8601: YYYY-MM-DD

    -- New address (at time of registration)
    street                   TEXT NOT NULL,
    building_number          TEXT NOT NULL,
    apartment_number         TEXT,
    postal_code              TEXT NOT NULL,
    city                     TEXT NOT NULL,

    -- Previous address snapshot (NULL for first registration)
    prev_street              TEXT,
    prev_building_number     TEXT,
    prev_apartment_number    TEXT,
    prev_postal_code         TEXT,
    prev_city                TEXT,

    created_at               TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_reg_citizen ON registration_history (citizen_id);

-- -------------------------------------------------------------
-- AUDIT LOG
-- Immutable record of all operations on citizen data.
-- Covers both modifications (FR-028) and reads (NFR-004).
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_log (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER REFERENCES users (id) ON DELETE SET NULL,
    operation   TEXT NOT NULL CHECK (operation IN ('CREATE', 'READ', 'UPDATE', 'DELETE')),
    entity_type TEXT NOT NULL,   -- e.g. 'citizen', 'identity_document', 'registration'
    entity_id   INTEGER,         -- PK of the affected row
    details     TEXT,            -- JSON snapshot of changed fields (optional)
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_audit_user      ON audit_log (user_id);
CREATE INDEX IF NOT EXISTS idx_audit_entity    ON audit_log (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_log (created_at);
