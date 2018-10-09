#!/bin/sh -e

# The name and source of the package
name="ovirt-engine-wildfly"
src="wildfly-${WF_VERSION}.${WF_QUALIFIER}.zip"
url="http://download.jboss.org/wildfly/${WF_VERSION}.${WF_QUALIFIER}/${src}"

# Download the source:
if [ ! -f "${src}" ]
then
    wget -O "${src}" "${url}"
fi

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
    --define="_sourcedir ${PWD}" \
    --define="_srcrpmdir ${PWD}/output" \
    --define="_rpmdir ${PWD}" \
    "${name}.spec"

