# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qtkeychain/qtkeychain-0.1.0.ebuild,v 1.1 2013/05/29 23:20:33 johu Exp $

EAPI=5

DESCRIPTION="Qt API for storing passwords securely"
HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/frankosterfeld/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-2"
	EGIT_REPO_URI="git://github.com/frankosterfeld/${PN}"
	KEYWORDS=""
fi

inherit cmake-utils ${GIT_ECLASS}

LICENSE="BSD"
SLOT="0"
IUSE="debug +qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
    qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4 BUILD_WITH_QT4)
	)

	cmake-utils_src_configure
}
