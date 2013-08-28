# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon-gstreamer/phonon-gstreamer-9999.ebuild,v 1.15 2013/03/10 10:12:23 kensington Exp $

EAPI=4

[[ ${PV} == *9999 ]] && git_eclass="git-2"
EGIT_REPO_URI="git://anongit.kde.org/${PN}"

MY_PN="phonon-backend-gstreamer"
MY_P=${MY_PN}-${PV}

inherit cmake-utils multilib ${git_eclass}

DESCRIPTION="Phonon GStreamer backend"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon/phonon-gstreamer"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/src/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
fi
SLOT="0"
IUSE="alsa debug +network +qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	media-libs/gstreamer:0.10
	media-plugins/gst-plugins-meta:0.10[alsa?,ogg,vorbis]
	>=media-libs/phonon-4.6.0
	qt4? (
		>=dev-qt/qtcore-4.6.0:4[glib]
		>=dev-qt/qtgui-4.6.0:4[glib]
		>=dev-qt/qtopengl-4.6.0:4
	)
	qt5? (
		>=dev-qt/qtcore-5.0.0:5[glib]
		>=dev-qt/qtgui-5.0.0:5[glib]
		>=dev-qt/qtopengl-5.0.0:5
	)
	virtual/opengl
	network? ( media-plugins/gst-plugins-soup:0.10 )
"
DEPEND="${RDEPEND}
	qt4? ( >=dev-util/automoc-0.9.87 )
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		local mycmakeargs=(
			$(cmake-utils_use_with alsa)
			-DPHONON_BUILD_PHONON4QT5=OFF
		)
		cmake-utils_src_configure
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		local mycmakeargs=(
			$(cmake-utils_use_with alsa)
			-DPHONON_BUILD_PHONON4QT5=ON
		)
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		cmake-utils_src_compile
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		cmake-utils_src_compile
	fi
}

src_install() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		cmake-utils_src_install
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		cmake-utils_src_install
	fi
}

src_test() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		cmake-utils_src_test
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		cmake-utils_src_test
	fi
}