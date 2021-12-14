#!/bin/sh -e

# The name and source of the package
name="ovirt-engine-wildfly"
src="wildfly-${WF_VERSION}.${WF_QUALIFIER}.zip"
url="https://download.jboss.org/wildfly/${WF_VERSION}.${WF_QUALIFIER}/${src}"

# Download the source:
curl -o rpmbuild/SOURCES/"${src}" "${url}"

# Generate the spec from the template:
sed \
    -e "s/@VERSION@/${RPM_VERSION}/g" \
    -e "s/@RELEASE@/${RPM_RELEASE}/g" \
    -e "s/@QUALIFIER@/${WF_QUALIFIER}/g" \
    -e "s/@SRC@/${src}/g" \
    < "${name}.spec.in" \
    > "${name}.spec"

# Build the source and binary packages:
rpmbuild \
    -bs \
    -D "_topdir rpmbuild" \
    "${name}.spec"

