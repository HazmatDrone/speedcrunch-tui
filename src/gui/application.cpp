// This file is part of the SpeedCrunch project
// Copyright (C) 2009 Helder Correia <helder.pereira.correia@gmail.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.

#include "gui/application.hxx"

#include <QtCore/QByteArray>
#include <QtCore/QSharedMemory>
#include <QtNetwork/QLocalServer>
#include <QtNetwork/QLocalSocket>

#include <cstring>

#define GUI_APPLICATION_SHARED_MEMORY_KEY    "speedcrunch"
#define GUI_APPLICATION_LOCAL_SOCKET_TIMEOUT 1000

struct Application::Private
{
    bool          isRunning;
    QLocalServer  localServer;
    QSharedMemory sharedMemory;
};

Application::Application( int & argc, char * argv[] )
    : QApplication( argc, argv ), d( new Application::Private )
{
    d->sharedMemory.setKey( GUI_APPLICATION_SHARED_MEMORY_KEY );

    if ( d->sharedMemory.attach() ) {
        d->isRunning = true;
    } else {
        d->isRunning = false;

        if ( ! d->sharedMemory.create(1) )
            return;

        connect( &d->localServer, SIGNAL(newConnection()), SLOT(receiveMessage()) );
        d->localServer.listen( GUI_APPLICATION_SHARED_MEMORY_KEY );
    }
}

Application::~Application()
{
}

void Application::receiveMessage()
{
    QLocalSocket * localSocket = d->localServer.nextPendingConnection();

    if ( ! localSocket->waitForReadyRead(GUI_APPLICATION_LOCAL_SOCKET_TIMEOUT) )
        return;

    QByteArray byteArray = localSocket->readAll();
    const QString message = QString::fromUtf8( byteArray.constData() );

    if ( message == "raise" )
        emit raiseRequested();

    localSocket->disconnectFromServer();
}

bool Application::isRunning()
{
    return d->isRunning;
}

bool Application::sendRaiseRequest()
{
    if ( ! d->isRunning )
        return false;

    QLocalSocket localSocket;
    localSocket.connectToServer( GUI_APPLICATION_SHARED_MEMORY_KEY, QIODevice::WriteOnly );

    if ( ! localSocket.waitForConnected(GUI_APPLICATION_LOCAL_SOCKET_TIMEOUT) )
        return false;

    localSocket.write( QString("raise").toUtf8() );

    if ( ! localSocket.waitForBytesWritten(GUI_APPLICATION_LOCAL_SOCKET_TIMEOUT) )
        return false;

    localSocket.disconnectFromServer();
    return true;
}
