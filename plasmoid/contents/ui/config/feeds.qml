import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Item {
  id: feedsPage

  property string feedList
  property alias cfg_feedList: feedsPage.feedList
  property bool loaded: false

  ListModel {
    id: feedModel
  }

  onFeedListChanged: {
    if(loaded){
      return;
    }

    var feedArray = feedList.split(",");
    for(var index=0; index<feedArray.length; index++){
      feedModel.append({"feed": feedArray[index]});
    }
    loaded = true;
  }

  function addFeed() {
    feedModel.append({"feed": addFeedField.text});
    addFeedField.text = "";
    feedList = viewToStringList();
    updateViewSelection();
  }

  function removeFeed() {
    feedModel.remove(feedView.currentRow,1);
    feedList = viewToStringList();
    updateViewSelection();
  }

  function moveFeedUp() {
    feedModel.move(feedView.currentRow, feedView.currentRow - 1, 1);
    feedList = viewToStringList();
    updateViewSelection();
  }

  function moveFeedDown() {
    feedModel.move(feedView.currentRow, feedView.currentRow + 1, 1);
    feedList = viewToStringList();
    updateViewSelection();
  }

  function viewToStringList() {
    var feedArray = [];
    for(var index=0; index<feedModel.count; index++){
      feedArray.push(feedModel.get(index).feed);
    }

    return feedArray.join();
  }

  function updateViewSelection() {
    var enabled = false
    if (feedView.currentRow >= 0) {
      enabled = true;
      feedView.selection.clear();
      feedView.selection.select(feedView.currentRow,feedView.currentRow);
    }

    removeButton.enabled = enabled;
    upButton.enabled = enabled;
    downButton.enabled = enabled;

    if (feedView.currentRow == 0) {
      upButton.enabled = false;
    }

    if (feedView.currentRow == feedModel.count - 1) {
      downButton.enabled = false;
    }
  }

  ColumnLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    GroupBox {
      Layout.fillWidth: true
      title: i18n("Feeds")
      flat: true

      ColumnLayout {
        anchors.fill: parent
        RowLayout {
          Layout.fillWidth: true

          Label {
            text: i18n("Add feed:")
          }

          TextField {
            id: addFeedField
            Layout.fillWidth: true
            validator: RegExpValidator{
              regExp: /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/
            }
            onTextChanged: {
              if (acceptableInput) {
                addButton.enabled = true;
              } else {
                addButton.enabled = false;
              }
            }
          }
        }

        RowLayout {
          Layout.fillWidth: true
          Layout.fillHeight: true

          TableView {
            Layout.fillWidth: true
            id: feedView
            TableViewColumn {
              role: "feed"
            }
            headerVisible: false
            model: feedModel
            alternatingRowColors: false
            selectionMode: SelectionMode.SingleSelection;
            onCurrentRowChanged: updateViewSelection()
          }

          ColumnLayout {
            Button {
              Layout.fillWidth: true
              Layout.maximumWidth: 100
              id: addButton
              enabled: false
              text: i18n("Add feed")
              onClicked: addFeed()
            }
            Button {
              Layout.fillWidth: true
              Layout.maximumWidth: 100
              id: removeButton
              enabled: false
              text: i18n("Remove feed")
              onClicked: removeFeed()
            }
            Button {
              Layout.alignment: Qt.AlignHCenter
              id: upButton
              enabled: false
              iconName: "go-up"
              onClicked: moveFeedUp()
            }
            Button {
              Layout.alignment: Qt.AlignHCenter
              id: downButton
              enabled: false
              iconName: "go-down"
              onClicked: moveFeedDown()
            }
          }
        }
      }
    }
  }
}
