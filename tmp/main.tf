#!/bin/bash
# This script automates the Terraform workflow for multiple directories.

# Accept the environment name as an optional command-line argument.
env_name=$1

# Set a default environment name if it's not provided.
if [ -z "$env_name" ]; then
  env_name="non-prod"
fi

# Loop through each subdirectory in the current directory.
for dir in $(ls -d */ | cut -f1 -d '/'); do
  echo ""
  echo "Entering Directory: ${dir}"
  cd "${dir}"

  echo ""
  echo "Executing 'terraform init'..."
  terraform init

  echo ""
  echo "Executing 'terraform plan -var-file=envs/${env_name}.tfvars -out=${dir}-tfplan'..."
  terraform plan -var-file=envs/${env_name}.tfvars -out=${dir}-tfplan

  # Check if the plan contains any changes (non-empty "refresh" or "apply" actions)
  plan_output=$(terraform show -json ${dir}-tfplan)
  if [[ $plan_output == *"refresh"* || $plan_output == *"apply"* ]]; then
    echo ""
    echo "Executing 'terraform apply -input=false ${dir}-tfplan'..."
    terraform apply -input=false ${dir}-tfplan
  else
    echo ""
    echo "No changes detected, skipping 'terraform apply'."
  fi

  # Clean up the plan file.
  rm "${dir}-tfplan"

  echo ""
  echo "Exiting Directory: ${dir}"
  cd ..
done
