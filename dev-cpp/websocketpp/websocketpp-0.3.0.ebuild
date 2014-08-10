# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="C++/Boost Asio based websocket client/server library"
HOMEPAGE="http://www.zaphoyd.com/websocketpp"
SRC_URI="https://github.com/zaphoyd/${PN}/archive/${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost" # examples

RDEPEND="
	boost? ( dev-libs/boost )
"
#	examples? ( dev-libs/openssl )

inherit cmake-utils

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable !boost CPP11)
	)
	# Disable EXAMPLES as compilation is broken upstream
	# $(cmake-utils_use_build examples EXAMPLES)
	cmake-utils_src_configure
}
