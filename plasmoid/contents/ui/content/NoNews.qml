import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
  id: wrapper
  width: parent.width

  Column{
    anchors.fill: parent
    spacing: 2

    Row{
      spacing: 5

      Image{
        id: feedImage
        width: 16
        height: 16
        source: "../img/rss.svg"
      }

      Label{
        id: feedLabel
        text: "Failed to fetch the feed..."
        wrapMode: Text.WordWrap
        font.bold: true
        width: wrapper.width - 21
        maximumLineCount: 1
        elide: Text.ElideRight
      }
    }
  }
}
