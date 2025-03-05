#!/bin/sh
# shellcheck shell=dash

if [ -z "$SBOM_PATH" ] || [ -z "$LICENSE_POLICY_PATH" ] || [ -z "$BREAK_ENABLED" ]; then
  echo "Missing variables in check script. Please check SBOM_PATH or LICENSE_POLICY_PATH or BREAK_ENABLED"
  exit 1
fi
sudo /sbom-utility license list --input-file="$SBOM_PATH" --format=csv --summary --config-license="$LICENSE_POLICY_PATH" -o=evaluated_sbom.csv
python3 /check_usage_policy.py --pipelinebreak "$BREAK_ENABLED" evaluated_sbom.csv
