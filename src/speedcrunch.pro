equals(QT_MAJOR_VERSION, 5) {
    lessThan(QT_MINOR_VERSION, 2) {
        error(Qt 5.2 or newer is required but version $$[QT_VERSION] was detected.)
    }

    QT += widgets
    CONFIG += c++11
}

equals(QT_MAJOR_VERSION, 4) {
    lessThan(QT_MINOR_VERSION, 8) {
        error(Qt 4.8 or newer is required but version $$[QT_VERSION] was detected.)
    }

    !win32|win32-g++ {
        QMAKE_CXXFLAGS += -std=c++0x
    }
}

win32-g++:QMAKE_LFLAGS += -static

DEFINES += SPEEDCRUNCH_VERSION=\\\"master\\\"
DEFINES += QT_USE_QSTRINGBUILDER
win32:DEFINES += _USE_MATH_DEFINES

TEMPLATE = app
TARGET = speedcrunch
QT += network help

DEPENDPATH += . \
              core \
              gui \
              locale \
              math \
              resources

INCLUDEPATH += . math core gui

win32:RC_FILE = resources/speedcrunch.rc
win32-msvc*:LIBS += User32.lib
!macx {
    !win32 {
        DEPENDPATH += thirdparty
        INCLUDEPATH += thirdparty
        LIBS += -lX11
        target.path = "/bin"
        menu.path = "/share/applications"
        icon.path = "/share/pixmaps"
        icon.files += resources/speedcrunch.png
        menu.files += ../pkg/speedcrunch.desktop
        INSTALLS += target icon menu
    }
}

macx {
    ICON = resources/speedcrunch.icns
    QMAKE_INFO_PLIST = ../pkg/Info.plist
    TARGET = SpeedCrunch
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.5
}

manual.target = $$OUT_PWD/doc/manual.qrc
win32:PY_COMMAND = py
else:PY_COMMAND = python
manual.commands = $$PY_COMMAND $$PWD/../doc/manual/doc-tool.py \
        --source-dir=$$PWD/../doc/manual \
        build-bundled-docs --build-dir=$$OUT_PWD/doc
QMAKE_EXTRA_TARGETS = manual

HEADERS += core/book.h \
           core/constants.h \
           core/evaluator.h \
           core/functions.h \
           core/session.h \
           core/errors.h \
           core/numberformatter.h \
           core/manualserver.h\
           core/pageserver.h \
           core/settings.h \
           core/opcode.h \
           core/sessionhistory.h \
           core/variable.h \
           core/userfunction.h \
           gui/aboutbox.h \
           gui/bitfieldwidget.h \
           gui/bookdock.h \
           gui/constantsdock.h \
           gui/constantswidget.h \
           gui/resultdisplay.h \
           gui/editor.h \
           gui/functionsdock.h \
           gui/functionswidget.h \
           gui/historydock.h \
           gui/historywidget.h \
           gui/tipwidget.h \
           gui/variablesdock.h \
           gui/variablelistwidget.h \
           gui/userfunctionsdock.h \
           gui/userfunctionlistwidget.h \
           gui/manualwindow.h \
           gui/mainwindow.h \
           gui/syntaxhighlighter.h \
           math/floatcommon.h \
           math/floatconfig.h \
           math/floatconst.h \
           math/floatconvert.h \
           math/floaterf.h \
           math/floatexp.h \
           math/floatgamma.h \
           math/floathmath.h \
           math/floatincgamma.h \
           math/floatio.h \
           math/floatipower.h \
           math/floatlog.h \
           math/floatlogic.h \
           math/floatlong.h \
           math/floatnum.h \
           math/floatpower.h \
           math/floatseries.h \
           math/floattrig.h \
           math/hmath.h \
           math/number.h \
           math/rational.h \
           math/units.h

SOURCES += main.cpp \
           core/book.cpp \
           core/constants.cpp \
           core/evaluator.cpp \
           core/functions.cpp \
           core/numberformatter.cpp \
           core/manualserver.cpp\
           core/pageserver.cpp \
           core/settings.cpp \
           core/session.cpp \
           core/sessionhistory.cpp \
           core/variable.cpp \
           core/userfunction.cpp \
           core/opcode.cpp \
           gui/aboutbox.cpp \
           gui/bitfieldwidget.cpp \
           gui/bookdock.cpp \
           gui/constantsdock.cpp \
           gui/constantswidget.cpp \
           gui/resultdisplay.cpp \
           gui/editor.cpp \
           gui/functionsdock.cpp \
           gui/functionswidget.cpp \
           gui/historydock.cpp \
           gui/historywidget.cpp \
           gui/syntaxhighlighter.cpp \
           gui/tipwidget.cpp \
           gui/variablesdock.cpp \
           gui/variablelistwidget.cpp \
           gui/userfunctionsdock.cpp \
           gui/userfunctionlistwidget.cpp \
           gui/mainwindow.cpp \
           gui/manualwindow.cpp \
           math/floatcommon.c \
           math/floatconst.c \
           math/floatconvert.c \
           math/floaterf.c \
           math/floatexp.c \
           math/floatgamma.c \
           math/floathmath.c \
           math/floatio.c \
           math/floatipower.c \
           math/floatlog.c \
           math/floatlogic.c \
           math/floatlong.c \
           math/floatnum.c \
           math/floatpower.c \
           math/floatseries.c \
           math/floattrig.c \
           math/floatincgamma.c \
           math/hmath.cpp \
           math/number.c \
	   math/cmath.cpp \
	   math/cnumberparser.cpp \
           math/rational.cpp \
           math/units.cpp

RESOURCES += resources/speedcrunch.qrc $$OUT_PWD/doc/manual.qrc
TRANSLATIONS += resources/locale/ar.ts \
                resources/locale/ca_ES.ts \
                resources/locale/cs_CZ.ts \
                resources/locale/da.ts \
                resources/locale/de_DE.ts \
                resources/locale/el.ts \
                resources/locale/en_US.ts \
                resources/locale/es_AR.ts \
                resources/locale/es_ES.ts \
                resources/locale/et_EE.ts \
                resources/locale/eu_ES.ts \
                resources/locale/fi_FI.ts \
                resources/locale/fr_FR.ts \
                resources/locale/he_IL.ts \
                resources/locale/hu_HU.ts \
                resources/locale/id_ID.ts \
                resources/locale/it_IT.ts \
                resources/locale/ja_JP.ts \
                resources/locale/ko_KR.ts \
                resources/locale/lt.ts \
                resources/locale/lv_LV.ts \
                resources/locale/nb_NO.ts \
                resources/locale/nl_NL.ts \
                resources/locale/pl_PL.ts \
                resources/locale/pt_BR.ts \
                resources/locale/pt_PT.ts \
                resources/locale/ro_RO.ts \
                resources/locale/ru_RU.ts \
                resources/locale/sk.ts \
                resources/locale/sv_SE.ts \
                resources/locale/tr_TR.ts \
                resources/locale/uz@Latn.ts \
                resources/locale/vi.ts \
                resources/locale/zh_CN.ts
