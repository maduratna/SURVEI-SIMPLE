-- SIMPLE-SURVEI MySQL schema; compatible with MySQL 8.0+.
CREATE DATABASE IF NOT EXISTS simple_survei CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE simple_survei;

CREATE TABLE IF NOT EXISTS survey_documents (
  collection_name VARCHAR(80) NOT NULL,
  document_id VARCHAR(64) NOT NULL,
  doc JSON NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  email_unique VARCHAR(320) GENERATED ALWAYS AS (
    CASE WHEN collection_name='users'
      THEN NULLIF(LOWER(JSON_UNQUOTE(JSON_EXTRACT(doc, '$.email'))), '') ELSE NULL END
  ) STORED,
  nik_unique VARCHAR(64) GENERATED ALWAYS AS (
    CASE WHEN collection_name='respondents'
      THEN NULLIF(JSON_UNQUOTE(JSON_EXTRACT(doc, '$.nik')), '') ELSE NULL END
  ) STORED,
  reference_unique VARCHAR(80) GENERATED ALWAYS AS (
    CASE WHEN collection_name='respondents'
      THEN NULLIF(JSON_UNQUOTE(JSON_EXTRACT(doc, '$.reference_code')), '') ELSE NULL END
  ) STORED,
  PRIMARY KEY (collection_name, document_id),
  INDEX idx_collection (collection_name),
  UNIQUE INDEX uq_survey_users_email (email_unique),
  UNIQUE INDEX uq_survey_respondents_nik (nik_unique),
  UNIQUE INDEX uq_survey_respondents_reference (reference_unique)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
