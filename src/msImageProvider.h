//-----------------------------------------------------------------------------
// \file	msImageProvider.h
// \date	2018 10 05
//-----------------------------------------------------------------------------

#pragma once

// Qt headers
#include <QQuickItem>
#include <QQuickImageProvider>

namespace ms { // ::ms

/*! \brief Milsymbol Qt Quick image provider.
 */
class ImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT

    /*! Qt Quick Image Provider Interface *///---------------------------------
    //@{
public:
    ImageProvider( );
    virtual ~ImageProvider() override = default;
    ImageProvider( const ImageProvider& ) = delete;

public:
    virtual QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;

    //! Return the code that must be used for images source URL.
    static QString  providerId( ) { return "ms"; }

    //! Clear all cached symbols.
    void            clear();

private:
    //! Default pixmap when an image fetch error occurs.
    QPixmap         _default;
    //@}
    //-------------------------------------------------------------------------
};

} // ::ms
