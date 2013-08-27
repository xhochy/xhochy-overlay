# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="cyrus-sasl debug doc examples gnupg openssl pkcs11 +qt4 qt5 test"

DEPEND="
	cyrus-sasl? ( dev-libs/cyrus-sasl )
	gnupg? ( app-crypt/gnupg )
	openssl? ( >=dev-libs/openssl-0.9.6 )
	pkcs11? (
		>=dev-libs/openssl-0.9.6
		=dev-libs/pkcs11-helper-1.02
	)
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-libs/extra-cmake-modules
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
		test? ( dev-qt/qttest:5 )
	)"
RDEPEND="${DEPEND}
	!<app-crypt/qca-1.0-r3:0"
REQUIRED_USE="^^ ( qt4 qt5 )"

DOCS=( README )

src_configure() {
	if use qt5; then
		epatch "${FILESDIR}/${PN}-qt5-pc.patch"
	fi

	# Ensure proper rpath
	# export EXTRA_QMAKE_RPATH="${EPREFIX}/usr/$(get_libdir)/qca2"

	local mycmakeargs=(
		$(cmake-utils_use qt4 QT4_BUILD)
		$(cmake-utils_use test BUILD_TESTS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc README TODO || die

	if use doc; then
		dohtml "${S}"/apidocs/html/* || die
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples || die
	fi
}
