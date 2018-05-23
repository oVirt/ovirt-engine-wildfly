#!/bin/sh -e

# WildFly version specification
version="13.0.0"
qualifier="Final"

# Cleanup
rm -rf exported-artifacts

# The name and source of the package
name="ovirt-engine-wildfly"
src="wildfly-${version}.${qualifier}.zip"
url="http://download.jboss.org/wildfly/${version}.${qualifier}/${src}"

# Download the source:
if [ ! -f "${src}" ]
then
    wget -O "${src}" "${url}"
fi

# Generate the spec from the template:
sed \
    -e "s/@VERSION@/${version}/g" \
    -e "s/@QUALIFIER@/${qualifier}/g" \
    -e "s/@SRC@/${src}/g" \
    < "${name}.spec.in" \
    > "${name}.spec"

# Build the source and binary packages:
rpmbuild \
    -bs \
    --define="_sourcedir ${PWD}" \
    --define="_srcrpmdir ${PWD}/output" \
    --define="_rpmdir ${PWD}" \
    "${name}.spec"

# Install any build requirements
yum-builddep output/*src.rpm

# Build RPMs
rpmbuild \
    -D "_rpmdir $PWD/output" \
    -D "_topdir $PWD/rpmbuild" \
    --rebuild output/*.src.rpm

# Store any relevant artifacts in exported-artifacts for the ci system to
# archive
[[ -d exported-artifacts ]] || mkdir -p exported-artifacts
find output -iname \*rpm | xargs mv -t exported-artifacts
