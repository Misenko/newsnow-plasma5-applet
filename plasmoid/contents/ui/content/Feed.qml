import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Rectangle {
  color: theme.backgroundColor
  Layout.fillWidth: true
  Layout.fillHeight: true
  clip: true

  property string url
  property bool hovered: false

  Component.onCompleted: {
    displayNews();
  }

  BusyIndicator {
    id: indicator
    anchors.fill: parent
    running: true
  }

  PathView {
    id: view
    property url iconImage :
    {
      if (dataSource.data[url] && dataSource.data[url]["FeedReady"] && dataSource.data[url]["Image"]) {
        dataSource.data[url]["Image"];
      }
      else {
        "../img/rss.svg";
      }
    }
    anchors.fill: parent
    preferredHighlightBegin: 1.0 / view.count
    preferredHighlightEnd: 1
    delegate: News
    {
      iconImageUrl : view.iconImage
    }
    path: Path {
      startX: - (view.width/2.0)
      startY: 0
      PathLine { x: (view.width * view.count) - (view.width/2.0); y: 0 }
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
      onClicked: view.incrementCurrentIndex();
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
      onClicked: view.decrementCurrentIndex();
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onWheel: {
      if (wheel.angleDelta.y < 0){
        //down
        view.incrementCurrentIndex();
      }
      else{
        //up
        view.decrementCurrentIndex();
      }
    }
    onClicked: {
      Qt.openUrlExternally(view.model[view.currentIndex]["Link"]);
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
    interval: 1000
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
    indicator.visible = false;

    view.model = dataSource.data[url]["Items"];

    // set the Interval to smaller value after the initial loading has finished
    dataSource.interval = updateInterval;
  }

  function feedReady(){
    return (dataSource.data[url] && dataSource.data[url]["FeedReady"]);
  }

  function next(){
    if (hovered || !feedReady()){
      return;
    }

    view.incrementCurrentIndex();
  }
}
