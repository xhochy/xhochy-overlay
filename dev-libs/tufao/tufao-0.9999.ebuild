# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [ "${PV#0.9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/vinipsmaker/${PN}.git"
	EGIT_BRANCH="0.x"
else
	SRC_URI="https://github.com/vinipsmaker/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake-utils multibuild ${SCM}

DESCRIPTION="An asynchronous web framework for C++ built on top of Qt"
HOMEPAGE="http://vinipsmaker.github.io/tufao/"

LICENSE="BSD"
SLOT="0"
IUSE="qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtnetwork:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	if use qt4; then
		MULTIBUILD_VARIANTS+=(qt4)
	fi
	if use qt5; then
		MULTIBUILD_VARIANTS+=(qt5)
	fi
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
		)
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(-DUSE_QT5=OFF)
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(-DUSE_QT5=ON)
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}
