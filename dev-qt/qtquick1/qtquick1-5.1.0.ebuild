# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="+opengl +webkit"

DEPEND="
	>=dev-qt/qtcore-${PV}:5[debug=]
	>=dev-qt/qtgui-${PV}:5[debug=,opengl]
	>=dev-qt/qtscript-${PV}:5[debug=]
	>=dev-qt/qtnetwork-${PV}:5[debug=]
	>=dev-qt/qttest-${PV}:5[debug=]
	>=dev-qt/qtwidgets-${PV}:5[debug=]
	opengl? ( >=dev-qt/qtopengl-${PV}:5[debug=] )
	webkit? ( >=dev-qt/qtwebkit-${PV}:5[debug=,widgets] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt5-build_src_prepare

	use opengl || sed -i -e '/shaders/d' \
		src/imports/imports.pro || die

	use webkit || sed -i -e '/webkit/d' \
		src/imports/imports.pro || die
}
