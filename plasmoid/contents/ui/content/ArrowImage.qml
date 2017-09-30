import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Image {
  readonly property int iconSize: 14
  readonly property int zAxis: 42

  id: leftArrow
  width: iconSize
  height: iconSize
  opacity: 0
  z: zAxis
  Behavior on opacity { PropertyAnimation {} }
  source: "../img/arrows.svgz"
}
