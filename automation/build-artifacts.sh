#!/bin/sh -e

# WildFly version specification
version="10.1.0"
qualifier="Final"


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
    --define="_srcrpmdir ${PWD}" \
    --define="_rpmdir ${PWD}" \
    "${name}.spec"

# Install any build requirements
yum-builddep *src.rpm

# Build RPMs
rpmbuild \
    -D "_rpmdir $PWD/output" \
    -D "_topmdir $PWD/rpmbuild" \
    -D "release_suffix ${SUFFIX}" \
    --rebuild *.src.rpm

# Store any relevant artifacts in exported-artifacts for the ci system to
# archive
[[ -d exported-artifacts ]] || mkdir -p exported-artifacts
find . -iname \*rpm -exec mv "{}" exported-artifacts/ \;
