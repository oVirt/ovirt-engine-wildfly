#!/bin/sh -e

# WildFly version specification
WF_VERSION="24.0.1"
WF_QUALIFIER="Final"

# RPM version specification
RPM_VERSION="${WF_VERSION}"
RPM_RELEASE="2"

# Directory, where build artifacts will be stored, should be passed as the 1st parameter
ARTIFACTS_DIR=${1:-exported-artifacts}

# Prepare source archive
[[ -d rpmbuild/SOURCES ]] || mkdir -p rpmbuild/SOURCES


# Build SRPMs
source $(dirname "$(readlink -f "$0")")/build-wildfly.sh
source $(dirname "$(readlink -f "$0")")/build-wildfly-overlay.sh
