import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import "../js/utils.js" as Utils

Item {
  id: dropTarget

  readonly property int iconSize: 45

  Rectangle {
    anchors.fill: parent
    color: theme.backgroundColor
    clip: true

    RowLayout{
      anchors.fill: parent

      Image {
        source: {
          if (Utils.isDarkTheme()) {
            "../img/rss-white.svg";
          } else {
            "../img/rss-black.svg";
          }
        }
        sourceSize: Qt.size(iconSize, iconSize)
        Image {
            id: img
            source: parent.source
            width: 0
            height: 0
        }
      }

      ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter

        Label {
          Layout.fillWidth: true
          text: "Drop a feed here..."
          wrapMode: Text.WordWrap
          font.bold: true
          color: theme.textColor
        }

        Label {
          Layout.fillWidth: true
          text: "...to add one more entry!"
          wrapMode: Text.WordWrap
          color: theme.textColor
        }
      }
    }
  }
}
