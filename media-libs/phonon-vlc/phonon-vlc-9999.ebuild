# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/phonon-vlc/phonon-vlc-9999.ebuild,v 1.12 2013/03/17 16:48:38 kensington Exp $

EAPI=5

MY_PN="phonon-backend-vlc"
MY_P="${MY_PN}-${PV}"
EGIT_REPO_URI="git://anongit.kde.org/${PN}"
[[ ${PV} == 9999 ]] && git_eclass=git-2
inherit cmake-utils ${git_eclass}
unset git_eclass

DESCRIPTION="Phonon VLC backend"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/phonon/phonon-vlc"
[[ ${PV} == 9999 ]] || SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd"

SLOT="0"
IUSE="debug +qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	=media-libs/phonon-9999[qt4=,qt5=]
	>=media-video/vlc-2.0.1[dbus,ogg,vorbis]
	qt4? (
		>=dev-qt/qtcore-4.6.0:4
		>=dev-qt/qtdbus-4.6.0:4
		>=dev-qt/qtgui-4.6.0:4
	)
	qt5? (
		>=dev-qt/qtcore-5.0.0:5
		>=dev-qt/qtdbus-5.0.0:5
		>=dev-qt/qtgui-5.0.0:5
	)
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	qt4? ( >=dev-util/automoc-0.9.87 )
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS )

_qt4_qt5_wrapper() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		"${@}"
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		"${@}"
	fi
}

src_configure() {
	if use qt4; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt4
		local mycmakeargs=(
			-DPHONON_BUILD_PHONON4QT5=OFF
		)
		cmake-utils_src_configure
	fi

	if use qt5; then
		BUILD_DIR=${WORKDIR}/${P}_build-qt5
		local mycmakeargs=(
			-DPHONON_BUILD_PHONON4QT5=ON
		)
		cmake-utils_src_configure
	fi
}

src_compile() {
	_qt4_qt5_wrapper cmake-utils_src_compile
}

src_install() {
	_qt4_qt5_wrapper cmake-utils_src_install
}

src_test() {
	_qt4_qt5_wrapper cmake-utils_src_test
}

pkg_postinst() {
	elog "For more verbose debug information, export the following variables:"
	elog "PHONON_DEBUG=1"
	elog ""
	elog "To make KDE detect the new backend without reboot, run:"
	elog "kbuildsycoca4 --noincremental"
}
