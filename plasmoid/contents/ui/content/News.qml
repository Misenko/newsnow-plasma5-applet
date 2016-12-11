import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
// import org.kde.plasma.components 2.0 as PlasmaComponents
// import org.kde.plasma.core 2.0

Component{
  Item{
    id: wrapper
    width: parent.width
    // anchors.fill: parent
    // color: theme.backgroundColor
    // clip: true
    // width: parent.width

    // ColumnLayout{
    //   anchors.fill: parent
    //
    //   RowLayout{
    //     Layout.fillHeight: true
    //     Layout.fillWidth: true

        // Image{
        //   source: iconSource
        //   height: 16
        //   width: 16
        // }
      // }
      //
      // RowLayout{
      //   Layout.fillWidth: true

        Label{
          anchors.fill: parent
          text: modelData["Title"]
          wrapMode: Text.WordWrap
          width: wrapper.PathView.width
        }
    //   }
    // }
  }
}
