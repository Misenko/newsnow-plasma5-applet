import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Column {
  readonly property int iconSize: 16

  property url icon
  property string title
  property string body
  property int wrapperWidth

  anchors.fill: parent
  spacing: 2

  Row {
    spacing: 5

    Image {
      id: feedImage
      width: iconSize
      height: iconSize
      source: icon
    }

    Label {
      id: feedLabel
      text: title
      wrapMode: Text.WordWrap
      font.bold: true
      width: wrapperWidth - 21
      maximumLineCount: 1
      elide: Text.ElideRight
    }
  }

  Label {
    id: newsLabel
    width: wrapperWidth
    text: body
    textFormat: Text.StyledText
    wrapMode: Text.WordWrap
  }
}
