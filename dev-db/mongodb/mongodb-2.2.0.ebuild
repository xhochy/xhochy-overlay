# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mongodb/mongodb-2.2.0.ebuild,v 1.4 2012/09/11 17:47:10 ultrabug Exp $

EAPI=4
SCONS_MIN_VERSION="1.2.0"

inherit eutils multilib pax-utils scons-utils user versionator

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz
	mms-agent? ( http://dev.gentoo.org/~ultrabug/20120830-10gen-mms-agent.zip )"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mms-agent static-libs v8 ssl"

PDEPEND="mms-agent? ( dev-python/pymongo )"
RDEPEND="!v8? ( <dev-lang/spidermonkey-1.8[unicode] )
	v8? ( dev-lang/v8 )
	dev-libs/boost
	dev-libs/libpcre[cxx]
	dev-util/google-perftools
	net-libs/libpcap
	app-arch/snappy"
DEPEND="${RDEPEND}
	sys-libs/readline
	sys-libs/ncurses"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	scons_opts=" --cxx=$(tc-getCXX) --use-system-all"
	if use v8; then
		scons_opts+=" --usev8"
	else
		scons_opts+=" --usesm"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.2-fix-scons.patch"
	epatch "${FILESDIR}/${PN}-2.2-fix-sconscript.patch"

	# FIXME: apply only this fix [1] on x86 boxes as it breaks /usr/lib symlink
	# on amd64 machines [2].
	# [1] https://jira.mongodb.org/browse/SERVER-5575
	# [2] https://bugs.gentoo.org/show_bug.cgi?id=434664
	if [ "$(get_libdir)" == "lib" ]; then
		epatch "${FILESDIR}/${PN}-2.2-fix-x86client.patch"
	fi

	sed -e 's@third_party/js-1.7/@/usr/include/js/@g' \
		-i src/mongo/scripting/engine_spidermonkey.h  \
		-i src/mongo/scripting/engine_spidermonkey.cpp || die

	if use v8; then
		sed -e "s/LIBS=\['js',/LIBS=\[/g" -i SConstruct || die
	fi
}

src_compile() {
	escons ${scons_opts} all
}

src_install() {
	escons ${scons_opts} --full --nostrip install --prefix="${D}"/usr

	use static-libs || rm "${D}/usr/$(get_libdir)/libmongoclient.a"

	use v8 && pax-mark m "${D}"/usr/bin/{mongo,mongod}

	for x in /var/{lib,log,run}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd" ${PN/db/s}

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use mms-agent; then
		local MY_PN="mms-agent"
		local MY_D="/opt/${MY_PN}"
		insinto ${MY_D}
		doins "${WORKDIR}/${MY_PN}/"*
		fowners -R mongodb:mongodb ${MY_D}
		newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}
		newconfd "${FILESDIR}/${MY_PN}.confd" ${MY_PN}
	fi
}

src_test() {
	escons ${scons_opts} test
	"${S}"/test --dbpath=unittest || die
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 1.8 ]]; then
		ewarn "You just upgraded from a previous version of mongodb !"
		ewarn "Make sure you run 'mongod --upgrade' before using this version."
	fi
	elog "Journaling is now enabled by default, see /etc/conf.d/${PN}"
}
