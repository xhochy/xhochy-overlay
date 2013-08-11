# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt5-build

# makeqpf don't build without qtbase source around
SRC_URI+=" http://releases.qt-project.org/qt5/${PV}/submodules/qtbase-opensource-src-${PV}.tar.xz"

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ "${QT5_BUILD_TYPE}" == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

IUSE="+accessibility"

DEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	~dev-qt/qtgui-${PV}[accessibility=,debug=]
	~dev-qt/qtwidgets-${PV}[debug=]
	~dev-qt/qtnetwork-${PV}[debug=]
	~dev-qt/qtsql-${PV}[debug=]
	~dev-qt/qtprintsupport-${PV}[debug=]
	~dev-qt/qtxml-${PV}[debug=]
"
RDEPEND="${DEPEND}"

# Somehow, order changes may break some builds
QT5_TARGET_SUBDIRS=(
	src/assistant
	src/pixeltool
	src/qtestlib
	src/designer
	src/linguist
	src/qdbus
	src/makeqpf

	src/qtconfig
	src/qev
	src/qconfig
	src/kmap2qmap
)

# Can't work on Linux
# src/macdeployqt

# Seemingly those should be included in qtconcurrent?
# src/qtconcurrent/codegenerator
# src/qtconcurrent/generaterun

PATCHES=( "${FILESDIR}/${P}-qtconfig.patch" )

src_unpack() {
	qt5-build_src_unpack

	# Hard link qtbase files over
	cp -lrn "${WORKDIR}/qtbase-opensource-src-${PV}/"* "${S}" || die
}

src_prepare() {
	# Fix sandbox violation when building with qt-tools already installed
	find "${S}" -name '*.pro' -exec sed -i 's/\$\$QT\.designer\.bins//' '{}' + || die

	# Fix sandbox violation when runing qmake
	sed -i 's+\$\$eval(QT\.uitools\.libs)/++' "${S}/src/linguist/linguist.pro" || die

	qt5-build_src_prepare
}

src_configure() {
	local myconf=(
		$(qt_use accessibility)
	)

	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	into /usr/lib/qt5

	#dobin \
	#	"${QT5_BUILD_DIR}/src/kmap2qmap/kmap2qmap" \
#		"${QT5_BUILD_DIR}/src/qconfig/qconfig" \
#		"${QT5_BUILD_DIR}/src/qev/qev"
}
