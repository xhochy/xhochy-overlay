# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild was submitted as Bug #440226 to the Gentoo Bug tracker.
# It features the addition from
# https://bugs.gentoo.org/show_bug.cgi?id=440226#c4

EAPI=4

inherit	eutils multilib

DESCRIPTION="Hiredis is a minimalistic C client library for the Redis database."
HOMEPAGE="https://github.com/redis/hiredis"
SRC_URI="https://github.com/redis/hiredis/archive/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"
	mv redis-hiredis-*/ ${P}
}

src_prepare() {
	# disable custom optimization compile flags and some meaninglesses places
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_install() {
	into /usr

	dolib.a libhiredis.a
	newlib.so libhiredis.so libhiredis.so.0.10

	dosym libhiredis.so.0.10 /usr/$(get_libdir)/libhiredis.so.0
	dosym libhiredis.so.0 /usr/$(get_libdir)/libhiredis.so

	insinto /usr/include/hiredis

	doins hiredis.h async.h
	doins -r adapters
}
