#!/bin/sh -e

# WildFly version specification
WF_VERSION="24.0.1"
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
