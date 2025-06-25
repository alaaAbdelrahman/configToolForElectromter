cmake_minimum_required(VERSION 3.16)

project(ConfigGenerator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick         QuickControls2
)


qt_add_executable(appConfigGenerator
    main.cpp
)

qt_add_qml_module(appConfigGenerator
    URI ConfigGenerator
    VERSION 1.0
    QML_FILES

        QML_FILES DevicePage.qml
        QML_FILES DLMSPage.qml
        QML_FILES
        QML_FILES Main.qml
        QML_FILES CommunicationPage.qml
        QML_FILES ControlPage.qml
        QML_FILES TariffPage.qml
        QML_FILES MeteringPage.qml
        QML_FILES MemoryPage.qml

        RESOURCES qml.qrc

    SOURCES
        SOURCES ConfigGenerator.h
        SOURCES ConfigGenerator.cpp
)

qt_add_resources(QML_RESOURCES qml.qrc)
target_sources(appConfigGenerator PRIVATE ${QML_RESOURCES})


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appConfigGenerator PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appConfigGenerator
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appConfigGenerator
    PRIVATE Qt6::Quick
    Qt6::QuickControls2

)

include(GNUInstallDirs)
install(TARGETS appConfigGenerator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
