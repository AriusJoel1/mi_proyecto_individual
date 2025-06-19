#!/bin/bash
set -e

echo "INFO: Testing Builder Module..."

echo "INFO: Terraform init..."
terraform init -upgrade >/dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Terraform init failed."
  exit 1
fi
echo "INFO: Terraform init complete."

echo "INFO: Terraform validate..."
terraform validate >/dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Terraform validate failed."
  exit 1
fi
echo "INFO: Terraform validate complete."

echo "INFO: Terraform apply..."
terraform apply -auto-approve \
  -var="project_identifier=test-project" \
  -var="deployment_region=test-region" >/dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Terraform apply failed."
  terraform destroy -auto-approve >/dev/null # Attempt cleanup
  exit 1
fi
echo "INFO: Terraform apply complete."

echo "INFO: Validating output 'builder_deployment_info'..."
OUTPUT_VALUE=$(terraform output -raw builder_deployment_info 2>/dev/null)
if [ -z "$OUTPUT_VALUE" ]; then
  echo "ERROR: Output 'builder_deployment_info' not found or is empty."
  terraform destroy -auto-approve >/dev/null
  exit 1
else
  echo "SUCCESS: Output 'builder_deployment_info' found: $OUTPUT_VALUE"
fi

echo "INFO: Terraform destroy..."
terraform destroy -auto-approve >/dev/null
if [ $? -ne 0 ]; then
  echo "WARN: Terraform destroy failed. Manual cleanup might be needed."
  # Not exiting with error here as the main test might have passed.
fi
echo "INFO: Terraform destroy complete."

echo "SUCCESS: Builder Module test finished."