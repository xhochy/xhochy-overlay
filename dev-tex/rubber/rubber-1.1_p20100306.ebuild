# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/rubber/rubber-1.1_p20090819.ebuild,v 1.4 2010/07/08 12:19:02 arfrever Exp $

EAPI=5

# TODO:
# * doc generation is not optional yet

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A LaTeX wrapper for automatically building documents"
HOMEPAGE="https://launchpad.net/rubber/"
MY_P=${PN}-${PV/*_p/}
SRC_URI="https://launchpad.net/rubber/trunk/1.1/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="" # doc
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="virtual/latex-base"
DEPEND="${RDEPEND}"

# Req'd for clean build by each impl
DISTUTILS_IN_SOURCE_BUILD=1

S=${WORKDIR}/${P/_p*/}

python_configure_all() {
	# configure script is not created by GNU autoconf
	./configure --prefix=/usr \
		--bindir=/usr/bin \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info || die
}

python_compile_all() {
	# if use doc; then
		cd doc
		emake all
	# fi
}
