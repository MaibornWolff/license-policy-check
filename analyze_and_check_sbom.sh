#!/bin/sh
sudo /sbom-utility license list --input-file=$SBOM_PATH --format=csv --summary --config-license=$LICENSE_POLICY_PATH -o=evaluated_sbom.csv
python3 /check_usage_policy.py --pipelinebreak $BREAK_ENABLED evaluated_sbom.csv
