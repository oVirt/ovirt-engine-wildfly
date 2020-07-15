#!/bin/sh

NAME="ovirt-engine-wildfly-overlay"

SRC_DIR="${PWD}/overlay"

rm -rf "${SRC_DIR}/noarch" "${SRC_DIR}"/*.rpm "${SRC_DIR}"/*.tar.* "${SRC_DIR}"/*.jar

# Generate the spec from the template:
sed \
    -e "s/@VERSION@/${RPM_VERSION}/g" \
    -e "s/@RELEASE@/${RPM_RELEASE}/g" \
    < "${NAME}.spec.in" \
    > "${NAME}.spec"

spectool --all --get-files --directory "${SRC_DIR}" "${PWD}/${NAME}.spec"

rpmbuild \
    -bs \
    --define="_sourcedir ${SRC_DIR}" \
    --define="_srcrpmdir ${PWD}/output" \
    --define="_rpmdir ${SRC_DIR}" \
    "${PWD}/${NAME}.spec"

