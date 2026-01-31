FROM apache/airflow:2.10.3-python3.12

USER root

# 1. Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2. Create directories and set ownership while still ROOT
RUN mkdir -p /opt/airflow/scripts /opt/airflow/data && \
    chown -R airflow:root /opt/airflow/scripts /opt/airflow/data

# Switch to the airflow user for all subsequent steps
USER airflow

# 3. Install python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# 4. Copy your project files
# Since we are USER airflow now, these files will be owned by airflow
COPY --chown=airflow:root scripts/ /opt/airflow/scripts/
COPY --chown=airflow:root data/ /opt/airflow/data/
