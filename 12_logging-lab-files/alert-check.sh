#!/usr/bin/env bash
# Polls Elasticsearch for ERROR-level log volume in the last 5 minutes
# and prints an alert if it's above a threshold. Run manually, or on a
# schedule via cron for a standing alert check:
#   */5 * * * * /path/to/alert-check.sh >> /var/log/alert-check.log 2>&1
set -euo pipefail

ES_HOST="http://localhost:9200"
THRESHOLD=5

count=$(curl -s -X GET "${ES_HOST}/logs-app-*/_count" \
  -H 'Content-Type: application/json' -d '{
    "query": {
      "bool": {
        "must": [
          { "match": { "level": "ERROR" } },
          { "range": { "@timestamp": { "gte": "now-5m" } } }
        ]
      }
    }
  }' | python3 -c "import sys, json; print(json.load(sys.stdin).get('count', 0))")

echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") ERROR count in last 5m: ${count}"

if [ "${count}" -gt "${THRESHOLD}" ]; then
  echo "ALERT: ${count} ERROR logs in the last 5 minutes (threshold: ${THRESHOLD})"
  # Replace this with a real notification, e.g.:
  # curl -X POST -H 'Content-Type: application/json' \
  #   -d "{\"text\":\"High error rate: ${count} errors in 5m\"}" \
  #   "$SLACK_WEBHOOK_URL"
fi
