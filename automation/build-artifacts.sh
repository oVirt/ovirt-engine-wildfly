#!/bin/sh -e

# WildFly version specification
WF_VERSION="23.0.2"
WF_QUALIFIER="Final"

# RPM version specification
RPM_VERSION="${WF_VERSION}"
RPM_RELEASE="1"

export WF_VERSION WF_QUALIFIER RPM_VERSION RPM_RELEASE

# Cleanup
rm -rf exported-artifacts
rm -rf output

# Build SRPMs
automation/build-wildfly.sh
automation/build-wildfly-overlay.sh

# Install any build requirements
dnf builddep output/*src.rpm

# Build RPMs
rpmbuild \
    -D "_rpmdir $PWD/output" \
    -D "_topdir $PWD/rpmbuild" \
    --rebuild output/*.src.rpm

# Store any relevant artifacts in exported-artifacts for the ci system to
# archive
[[ -d exported-artifacts ]] || mkdir -p exported-artifacts
find output -iname \*rpm | xargs mv -t exported-artifacts
