import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Item {
  id: generalPage

  property alias cfg_dropTarget: dropTargetCheckBox.checked
  property alias cfg_logo: logoCheckBox.checked

  property alias cfg_updateInterval: updateInterval.value
  property alias cfg_switchInterval: switchInterval.value

  ColumnLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    GroupBox {
      Layout.fillWidth: true
      title: i18n("Appearance")
      flat: true

      ColumnLayout {
        anchors.fill: parent
        CheckBox {
          id: dropTargetCheckBox
          text: i18n("Show drop target")
        }

        CheckBox {
          id: logoCheckBox
          text: i18n("Show logo")
        }
      }
    }

    GroupBox {
      Layout.fillWidth: true
      title: i18n("News")
      flat: true

      ColumnLayout {
        anchors.fill: parent
        RowLayout {
          Label {
            id: intervalLabel
            text: i18n("Update interval:")
          }
          SpinBox {
            id: updateInterval
            Layout.minimumWidth: units.gridUnit * 8
            suffix: " "+i18n("minutes")
            stepSize: 1
          }
        }
        RowLayout {
          Label {
            Layout.minimumWidth: intervalLabel.width
            text: i18n("Switch interval:")
          }
          SpinBox {
            id: switchInterval
            Layout.minimumWidth: units.gridUnit * 8
            suffix: " "+i18n("seconds")
            stepSize: 1
          }
        }
      }
    }
  }
}
