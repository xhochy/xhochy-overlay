# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A library for communicating with The Echo Nest"
HOMEPAGE="http://projects.kde.org/projects/playground/libs/libechonest"
GIT_ECLASS="git-r3"
EGIT_REPO_URI="git://github.com/lfranchi/libechonest.git"

inherit cmake-utils ${GIT_ECLASS}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	qt4? (
	>=dev-libs/qjson-0.5[qt4(+)]
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

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 BUILD_WITH_QT4)
	)

	cmake-utils_src_configure
}
