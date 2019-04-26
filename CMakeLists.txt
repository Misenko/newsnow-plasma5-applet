cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

set(QT_MIN_VERSION "5.5.0")
set(KF5_MIN_VERSION "5.21.0")

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Core
    Qml
)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma)

plasma_install_package(plasmoid org.kde.plasma.newsnow)

install( DIRECTORY icons/breeze DESTINATION ${ICON_INSTALL_DIR})
install( DIRECTORY icons/breeze-dark DESTINATION ${ICON_INSTALL_DIR})
