import QtQuick 2.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 1.4

Row {
  width: parent.width

  property string url
  property int currentIndex: 0
  property int animationDuration: 500
  property var hovered: false

  Component.onCompleted: {
    displayNews();
  }

  BusyIndicator {
    id: indicator
    anchors.fill: parent
    running: true
  }

  PathView {
    id: path
    anchors.fill: parent
    delegate: News {}
    path: Path {
      startX: 0
      startY: 0
      PathLine { x: (path.width * path.count); y: path.height }
    }
  }

  Image {
    id: leftArrow
    width: 14
    height: 14
    anchors.right: parent.right
    anchors.top: parent.top
    opacity: 0
    z: 42
    Behavior on opacity { PropertyAnimation {} }
    source: "../img/arrows.svgz"
    MouseArea {
      anchors.fill: parent
      onClicked: path.incrementCurrentIndex();
    }
  }

  Image {
    id: rightArrow
    width: 14
    height: 14
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    opacity: 0
    z: 42
    Behavior on opacity { PropertyAnimation {} }
    source: "../img/arrows.svgz"
    transform: Rotation { origin.x: 7; origin.y: 7; axis { x: 0; y: 0; z: 1 } angle: 180 }
    MouseArea {
      anchors.fill: parent
      onClicked: path.decrementCurrentIndex();
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onWheel: {
      if (wheel.angleDelta.y < 0){
        //down
        console.log("down");
        path.incrementCurrentIndex();
      }
      else{
        //up
        console.log("up");
        path.decrementCurrentIndex();
      }
    }
    onClicked: {
      //Qt.openUrlExternally(parent.model.get(currentIndex).link);
    }
    onEntered: {
      //news.feedTitleToFuzzyDate();
      hovered = true;
      rightArrow.opacity = 1;
      leftArrow.opacity = 1;
    }
    onExited: {
      //news.feedTitleToFeedTitle();
      hovered = false;
      rightArrow.opacity = 0;
      leftArrow.opacity = 0;
    }
  }

  Timer{
    id: newsRetrievalTimer
    interval: 500
    running: false
    repeat: false
    onTriggered: displayNews()
  }

  function displayNews(){
    if(!feedReady()){
      newsRetrievalTimer.running = true;
      return;
    }

    indicator.running = false;

    path.model = dataSource.data[url]["Items"]
  }

  function feedReady(){
    return dataSource.data[url]["Ready"]
  }
}
