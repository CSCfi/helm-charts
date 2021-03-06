#!/bin/bash
set -e
set -o pipefail

echo "Linting $1..."
echo "Running Helm lint..."
helm lint --strict $1 | grep -vE "linted|Lint"
helm template $1 > deployment.yaml
echo "Running kubeval lint..."
kubeval --strict <deployment.yaml | (grep -v " valid" || true)
echo "Running kubetest lint..."
kubetest --verbose <deployment.yaml | (grep -v "info" || true)
echo "Yay, no errors when linting $1"
