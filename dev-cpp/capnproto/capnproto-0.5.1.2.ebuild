# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-multilib

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="http://capnproto.org"
SRC_URI="https://github.com/sandstorm-io/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~mips"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/c++

src_prepare() {
	epatch "${FILESDIR}/${P}-no-ldconfig.patch"
	eautoreconf
}
