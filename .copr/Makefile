# outdir: passed by copr telling where to save the src.rpm
# spec: passed by copr telling which spec file should be used;
#       using for selecting the right src.rpm to be copied.

installdeps:
	dnf -y install coreutils curl dnf-utils git rpmdevtools sed

srpm: installdeps
	$(eval SUFFIX=$(shell sh -c " echo '.master.$$(date -u +%Y%m%d)'"))
	sed "s:%{?release_suffix}:${SUFFIX}:" -i ovirt-engine-wildfly.spec.in
	sed "s:%{?release_suffix}:${SUFFIX}:" -i ovirt-engine-wildfly-overlay.spec.in
	.automation/build-srpm.sh $(shell sh -c "basename '$(spec)'|cut -f1 -d.")
	cp rpmbuild/SRPMS/*.src.rpm $(outdir)
