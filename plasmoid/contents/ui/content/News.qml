import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
// import org.kde.plasma.components 2.0 as PlasmaComponents
// import org.kde.plasma.core 2.0

Item{
  id: wrapper
  width: parent.width

  property url iconImageUrl

  Column{
    anchors.fill: parent
    spacing: 2

    Row{
      spacing: 5

      Image{
        id: feedImage
        width: 16
        height: 16
        source: iconImageUrl
      }

      Label{
        text: "Extra more text goes here"
        wrapMode: Text.WordWrap
        font.bold: true
      }
    }

    Label{
      width: wrapper.width
      text: modelData["Title"]
      textFormat: Text.StyledText
      wrapMode: Text.WordWrap
    }
  }
}
