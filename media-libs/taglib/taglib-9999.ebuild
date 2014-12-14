# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.9.1-r2.ebuild,v 1.11 2014/08/27 09:05:26 ssuominen Exp $

EAPI=5

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
fi

inherit cmake-multilib ${SCM}

LICENSE="LGPL-2.1 MPL-1.1"
SLOT="0"
IUSE="+asf debug examples +mp4 test"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"
RDEPEND="${RDEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20140508-r2
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

DOCS=( AUTHORS NEWS )

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
)

multilib_src_configure() {
	mycmakeargs=(
		$(multilib_is_native_abi && cmake-utils_use_build examples)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_with asf)
		$(cmake-utils_use_with mp4)
	)

	cmake-utils_src_configure
}

multilib_src_test() {
	# ctest does not work
	emake -C "${BUILD_DIR}" check
}
