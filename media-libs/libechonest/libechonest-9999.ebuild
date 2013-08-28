# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libechonest/libechonest-2.0.1.ebuild,v 1.2 2012/12/27 23:14:16 hasufell Exp $

EAPI=4

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="http://projects.kde.org/projects/playground/libs/libechonest"
GIT_ECLASS="git-2"
EGIT_REPO_URI="git://github.com/lfranchi/libechonest.git"

inherit cmake-utils ${GIT_ECLASS}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	qt4? (
		|| ( ( >=dev-libs/qjson-0.5 <dev-libs/qjson-9999 ) =dev-libs/qjson-9999[qt4] )
		dev-qt/qtcore:4
	)
	qt5? (
		=dev-libs/qjson-9999[qt5]
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	qt4? ( dev-qt/qttest:4 )
	qt5? ( dev-qt/qttest:5 )
"

RESTRICT="test" # network access required

DOCS=( AUTHORS README TODO )
#PATCHES=( "${FILESDIR}"/${PN}-2.0.2-Werror.patch )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 BUILD_WITH_QT4)
	)

	cmake-utils_src_configure
}
