#!/bin/bash -e

# WildFly version specification
WF_VERSION="24.0.1"
WF_QUALIFIER="Final"

# RPM version specification
# Bump RPM_RELEASE_BASE after each tagged release so that development builds
# sort above the last release (e.g. set to 1 after tagging -1, so dev builds
# get 1.master.<date>.<git> — above -1 but below the future -2 tag).
RPM_VERSION="${WF_VERSION}"
RPM_RELEASE_BASE="3"
RPM_RELEASE="${PACKAGE_RPM_RELEASE:-${RPM_RELEASE_BASE}.master}"

# Directory, where build artifacts will be stored, should be passed as the 1st parameter
ARTIFACTS_DIR=${1:-exported-artifacts}

# Absolute path for the RPM build tree (a relative _topdir causes %{SOURCE0} to
# resolve incorrectly when RPM changes cwd to _builddir during %install).
TOPDIR="$(pwd)/rpmbuild"

# Prepare source archive
[[ -d "${TOPDIR}/SOURCES" ]] || mkdir -p "${TOPDIR}/SOURCES"

# Build SRPMs
if [ "$1" = "ovirt-engine-wildfly" ]; then
    source "$(dirname "$(readlink -f "$0")")/build-wildfly.sh"
elif [ "$1" = "ovirt-engine-wildfly-overlay" ]; then
    source "$(dirname "$(readlink -f "$0")")/build-wildfly-overlay.sh"
else
    source "$(dirname "$(readlink -f "$0")")/build-wildfly.sh"
    source "$(dirname "$(readlink -f "$0")")/build-wildfly-overlay.sh"
fi
