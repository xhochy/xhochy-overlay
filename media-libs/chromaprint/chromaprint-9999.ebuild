# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/chromaprint/chromaprint-1.1.ebuild,v 1.5 2014/03/04 20:17:40 ago Exp $

EAPI=5

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://bitbucket.org/acoustid/chromaprint.git"
else
	SRC_URI="https://bitbucket.org/acoustid/${PN}/downloads/${P}.tar.gz"
fi

inherit cmake-utils ${SCM}

DESCRIPTION="A client-side library that implements a custom algorithm for extracting fingerprints"
HOMEPAGE="http://acoustid.org/chromaprint"

LICENSE="LGPL-2.1"
SLOT="0"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="amd64 ~ppc x86 ~amd64-fbsd"
else
	KEYWORDS=""
fi
IUSE="test tools"

# note: use ffmpeg instead of fftw because it's recommended and required for tools
RDEPEND="
	>=virtual/ffmpeg-0.10
	tools? ( >=media-libs/taglib-1.6 )"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-libs/boost
	)
	tools? ( dev-libs/boost )"

DOCS="NEWS.txt README.md"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build tools EXAMPLES)
		$(cmake-utils_use_build test TESTS)
		-DWITH_AVFFT=ON
		)
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	emake check
}

src_install() {
	cmake-utils_src_install
}
