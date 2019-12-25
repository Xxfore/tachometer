TARGET = tachometer
QT = quickcontrols2

equals(QT_ARCH, "arm") {
    QMAKE_CXXFLAGS += -mfp16-format=ieee
}

HEADERS += \
    camera.h

SOURCES += \
    main.cpp \
    camera.cpp

LIBS += -lopencv_core -lopencv_highgui -lopencv_videoio

INCLUDEPATH += /usr/local/include \
               /usr/local/include/opencv4
RESOURCES += \
    main.qrc \
    images/images.qrc

include(app.pri)
