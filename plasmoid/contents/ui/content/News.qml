import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Component{
  Rectangle{
    anchors.fill: parent
    color: theme.backgroundColor
    clip: true

    ColumnLayout{
      anchors.fill: parent

      RowLayout{
        Layout.fillHeight: true
        Layout.fillWidth: true

        // Image{
        //   source: iconSource
        //   height: 16
        //   width: 16
        // }
      }

      RowLayout{
        Label{
          Layout.fillHeight: true
          Layout.fillWidth: true
          text: modelData["Title"]
          wrapMode: Text.WordWrap
        }
      }
    }
  }
}
