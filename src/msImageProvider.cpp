//-----------------------------------------------------------------------------
// \file	msImageProvider.cpp
// \date	2018 10 05
//-----------------------------------------------------------------------------

// Qt headers
#include <QDebug>
#include <QPixmap>
#include <QPainter>
#include <QFileInfo>
#include <QString>
#include <QUrlQuery>

// milsymbol-qml headers
#include "msImageProvider.h"

namespace ms { // ::ms

/* Qt Quick Image Provider Interface *///--------------------------------------
ImageProvider::ImageProvider( ) :
    QObject{ nullptr },
    QQuickImageProvider{ QQuickImageProvider::Pixmap }
{
    // Generate a default empty transparent pixmap
    QPixmap errorPixmap{ 10, 10 };
    errorPixmap.fill( QColor( Qt::transparent ) );
    _default = errorPixmap;
}

QPixmap ImageProvider::requestPixmap( const QString &id, QSize* size, const QSize& requestedSize )
{
    Q_UNUSED( requestedSize );

    QPixmap p = QPixmap();
    if ( p.isNull() )
        p = _default;   // Set the default error pixmap
    if ( size != nullptr )
        *size = QSize( p.width( ), p.height( ) );
    return p;
}

void    ImageProvider::clear()
{
}
//-----------------------------------------------------------------------------

} // ::ms

