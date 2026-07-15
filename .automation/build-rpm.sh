#!/bin/bash -e

source "$(dirname "$(readlink -f "$0")")/build-srpm.sh"

# Install build dependencies
dnf builddep -y "${TOPDIR}/SRPMS/"*.src.rpm

# Build binary packages
for srpm in "${TOPDIR}/SRPMS/"*.src.rpm; do
    rpmbuild \
        --define "_topdir ${TOPDIR}" \
        --define "release_suffix ${RELEASE_SUFFIX:-}" \
        --rebuild "${srpm}"
done

# Move RPMs to exported artifacts
[[ -d $ARTIFACTS_DIR ]] || mkdir -p $ARTIFACTS_DIR
find "${TOPDIR}" -iname \*rpm | xargs mv -t $ARTIFACTS_DIR
