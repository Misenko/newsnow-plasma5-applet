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
  property bool failed: false

  Component.onCompleted: {
    displayNews();
  }

  NoNews {
    id: noNews
    visible: false
  }

  BusyIndicator {
    id: indicator
    anchors.fill: parent
    running: true
  }

  PathView {
    id: view
    property url iconImage:
    {
      if ((typeof dataSource.data[url] != 'undefined') && (typeof dataSource.data[url]["Image"] != 'undefined') && dataSource.data[url]["Image"] != "NO_ICON") {
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
      iconImageUrl: view.iconImage
      feedTitle: dataSource.data[url]["Title"]
      numberOfNews: dataSource.data[url]["Items"].length
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
      onClicked: nextNews();
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
      onClicked: previousNews();
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onWheel: {
      if (wheel.angleDelta.y < 0){
        //down
        nextNews();
      }
      else{
        //up
        previousNews();
      }
    }
    onClicked: {
      if (failed) {
        return;
      }
      Qt.openUrlExternally(view.model[view.currentIndex]["Link"]);
    }
    onEntered: {
      if (failed) {
        return;
      }
      view.currentItem.feedTitleToFuzzyDate();
      hovered = true;
      rightArrow.opacity = 1;
      leftArrow.opacity = 1;
    }
    onExited: {
      if (failed) {
        return;
      }
      view.currentItem.feedTitleToFeedTitle();
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

    if (typeof(dataSource.data[url]["Items"]) == 'undefined'){
      console.log("No items found, setting NoNews to visible")
      noNews.visible = true;
      view.visible = false;
      failed = true;
    } else {
      view.model = dataSource.data[url]["Items"];
    }
  }

  function feedReady(){
    return ((typeof dataSource.data[url] != 'undefined') && (typeof dataSource.data[url]["Title"] != 'undefined'));
  }

  function next(){
    if (hovered || !feedReady()){
      return;
    }

    view.incrementCurrentIndex();
  }

  function nextNews(){
    if (failed) {
      return;
    }
    view.currentItem.feedTitleToFeedTitle();
    view.incrementCurrentIndex();
    view.currentItem.feedTitleToFuzzyDate();
  }

  function previousNews(){
    if (failed) {
      return;
    }
    view.currentItem.feedTitleToFeedTitle();
    view.decrementCurrentIndex();
    view.currentItem.feedTitleToFuzzyDate();
  }

  function allItemsToFuzzyDate(){

  }
}
