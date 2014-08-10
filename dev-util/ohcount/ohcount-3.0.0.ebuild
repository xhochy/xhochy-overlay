# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Source code line counter"
HOMEPAGE="http://labs.ohloh.net/ohcount"
SRC_URI="https://github.com/blackducksw/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# TODO RUBY dev-lang/swig
RDEPEND="
	dev-util/ragel
	dev-libs/libpcre"
DEPEND="${RDEPEND}"

src_compile() {
	# TODO RUBY ./build ruby
	./build ohcount || die './build failed'
}

src_install() {
	dobin bin/ohcount || die 'dobin failed'
}
