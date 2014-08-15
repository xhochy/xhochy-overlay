# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/vinipsmaker/${PN}.git"
else
	SRC_URI="https://github.com/vinipsmaker/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit cmake-utils ${SCM}

DESCRIPTION="An asynchronous web framework for C++ built on top of Qt"
HOMEPAGE="http://vinipsmaker.github.io/tufao/"

LICENSE="BSD"
SLOT="1"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
"

src_configure() {
	local mycmakeargs=(
	)
	# $(cmake-utils_use_build examples EXAMPLES)
	cmake-utils_src_configure
}
