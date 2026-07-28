# Lab Files -- Centralized Logging & Reliability (AWS EC2)

Companion files for the AWS EC2 Lab Documentation PDF. Copy this whole
folder to the EC2 instance (e.g. via `scp -r`) before the session.

## Contents

| File | Purpose |
|---|---|
| `docker-compose.yml` | Full stack: Elasticsearch, Kibana, Logstash, Fluentd, sample-app |
| `fluentd/Dockerfile`, `fluentd/fluent.conf` | Fluentd forwarder: tails the app log, forwards as JSON to Logstash |
| `logstash/pipeline/pipeline.conf` | Logstash pipeline: receives from Fluentd, enriches, writes to Elasticsearch |
| `sample-app/Dockerfile`, `sample-app/generate-logs.sh` | Generates continuous INFO logs plus periodic ERROR logs |
| `alert-check.sh` | Polls Elasticsearch for ERROR volume and prints an alert if over threshold |

## Quick Start (run on the EC2 instance)

```bash
docker compose up -d --build

# Wait ~30-60s for Elasticsearch and Kibana to be ready, then check:
curl -s http://localhost:9200/_cluster/health?pretty
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5601

# Confirm logs are flowing all the way through
curl -s http://localhost:9200/logs-app-*/_search?size=1 | python3 -m json.tool

# Run an alert check manually
bash alert-check.sh
```

See the full **AWS EC2 Lab Documentation PDF** for the step-by-step narrative, expected results at each step, and a verification checklist.

## Cleanup

```bash
docker compose down -v
```
