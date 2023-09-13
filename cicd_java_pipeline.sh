#!/bin/bash

set -eox pipefail

export ARTIFACTORY_REPO_BASE_URL=${ARTIFACTORY_REPO_BASE_URL:-"http://localhost:8081/artifactory"}  # Local Artifactory URL
export BRANCH_NAME=${BRANCH_NAME:-"develop"}

# Set your deployer credentials here (replace placeholders with actual values)
export DEPLOYER_USERNAME="your_deployer_username" # admin
export DEPLOYER_PASSWORD="your_deployer_password" # password

# Check if the branch is a release, master, or main branch
if [[ "$BRANCH_NAME" =~ ^release.*|^master.*|^main.* ]]; then
    RELEASE=true
else
    RELEASE=false
fi

# Use the Maven Release Plugin for building and releasing
if [ "$RELEASE" = true ]; then
    echo "[INFO] Performing a release build"
    mvn release:clean release:prepare release:perform -Dusername="$DEPLOYER_USERNAME" -Dpassword="$DEPLOYER_PASSWORD" \
        -Durl=${ARTIFACTORY_REPO_BASE_URL}/my-maven-release

    # Additional steps if needed for release

else
    echo "[INFO] Performing a snapshot build"
    mvn clean deploy -DskipTests=true -DrepositoryId=snapshot-repo \
        -Durl=${ARTIFACTORY_REPO_BASE_URL}/my-maven-snapshot
fi
