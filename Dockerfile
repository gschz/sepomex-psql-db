# syntax=docker/dockerfile:1
FROM python:3.13-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ src/
COPY data/input/ data/input/
RUN python -m src.main

FROM postgres:16

COPY database/schema.sql    /docker-entrypoint-initdb.d/01_schema.sql
COPY database/views.sql     /docker-entrypoint-initdb.d/02_views.sql
COPY database/indexes.sql   /docker-entrypoint-initdb.d/03_indexes.sql
COPY database/functions.sql /docker-entrypoint-initdb.d/04_functions.sql

COPY --from=builder /build/data/generated_sql_v2/001_insert_estados.sql            /docker-entrypoint-initdb.d/05_001_insert_estados.sql
COPY --from=builder /build/data/generated_sql_v2/002_insert_municipios.sql         /docker-entrypoint-initdb.d/05_002_insert_municipios.sql
COPY --from=builder /build/data/generated_sql_v2/003_insert_tipos_asentamiento.sql /docker-entrypoint-initdb.d/05_003_insert_tipos_asentamiento.sql
COPY --from=builder /build/data/generated_sql_v2/004_insert_zonas.sql              /docker-entrypoint-initdb.d/05_004_insert_zonas.sql
COPY --from=builder /build/data/generated_sql_v2/005_insert_ciudades.sql           /docker-entrypoint-initdb.d/05_005_insert_ciudades.sql
COPY --from=builder /build/data/generated_sql_v2/006_insert_codigos_postales.sql   /docker-entrypoint-initdb.d/05_006_insert_codigos_postales.sql

# 06_refresh_view.sql must run AFTER the data inserts: the view was created and
# refreshed empty by 02_views.sql, so it is stale until refreshed again here.
RUN printf 'REFRESH MATERIALIZED VIEW vm_codigos_postales;\n' \
    > /docker-entrypoint-initdb.d/06_refresh_view.sql
