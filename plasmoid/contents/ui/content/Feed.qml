import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore

Rectangle {
  color: theme.backgroundColor
  Layout.fillWidth: true
  Layout.fillHeight: true
  clip: true

  readonly property int newsCheckInterval: 1000
  readonly property int directionLeft: 1
  readonly property int directionRight: -1

  property string url
  property var feed: dataSource.data[url]
  property bool hovered: false

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
    property url iconImage: {
      if (feedIconAvailable()) {
        feed["Image"];
      } else {
        "../img/rss-orange.svg";
      }
    }
    anchors.fill: parent
    preferredHighlightBegin: 1.0 / view.count
    preferredHighlightEnd: 1
    delegate: News {
      iconUrl: view.iconImage
      feedTitle: feed["Title"]
      numberOfNews: feed["Items"] ? feed["Items"].length : 0
    }
    path: Path {
      startX: - (view.width/2.0)
      startY: 0
      PathLine { x: (view.width * view.count) - (view.width/2.0); y: 0 }
    }
  }

  ArrowImage {
    id: leftArrow
    anchors.right: parent.right
    anchors.top: parent.top
    MouseArea {
      anchors.fill: parent
      onClicked: nextNews();
    }
  }

  ArrowImage {
    id: rightArrow
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    transform: Rotation { origin.x: 7; origin.y: 7; axis { x: 0; y: 0; z: 1 } angle: 180 }
    MouseArea {
      anchors.fill: parent
      onClicked: previousNews();
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onWheel: {
      console.debug("Using wheel on feed with url '" + url + "'");

      if (wheel.angleDelta.y < 0) {
        //down
        nextNews();
      } else {
        //up
        previousNews();
      }
    }
    onClicked: {
      console.debug("Clicking feed with url '" + url + "'");

      Qt.openUrlExternally(view.model[view.currentIndex]["Link"]);
    }
    onEntered: {
      console.debug("Entering feed with url '" + url + "'");

      view.currentItem.feedTitleToFuzzyDate();
      hovered = true;
      rightArrow.opacity = 1;
      leftArrow.opacity = 1;
    }
    onExited: {
      console.debug("Exiting feed with url '" + url + "'");

      view.currentItem.feedTitleToFeedTitle();
      hovered = false;
      rightArrow.opacity = 0;
      leftArrow.opacity = 0;
    }
  }

  Timer {
    id: newsRetrievalTimer
    interval: newsCheckInterval
    running: false
    repeat: false
    onTriggered: displayNews()
  }

  function displayNews() {
    console.debug("Checking whether feed for url '" + url + "' is ready...");

    if (!feedReady()) {
      console.debug("Feed for url '" + url + "' is NOT ready yet");
      newsRetrievalTimer.running = true;
      return;
    }

    console.debug("Feed for url '" + url + "' is ready");
    indicator.running = false;
    indicator.visible = false;

    if (typeof(feed["Items"]) == 'undefined') {
      console.warn("No items for url '" + url + "' found");
      noNews.visible = true;
      view.visible = false;
      mouseArea.enabled = false;

      return;
    }

    noNews.visible = false;
    view.visible = true;
    mouseArea.enabled = true;
    view.model = feed["Items"];
  }

  function feedReady() {
    return ((typeof feed != 'undefined') && (typeof feed["Title"] != 'undefined'));
  }

  function feedIconAvailable() {
    return ((typeof feed != 'undefined') && (typeof feed["Image"] != 'undefined'));
  }

  function next() {
    if (hovered || !feedReady()) {
      return;
    }

    console.debug("Moving to next news");
    view.incrementCurrentIndex();
  }

  function nextNews() {
    moveNews(directionLeft);
  }

  function previousNews() {
    moveNews(directionRight);
  }

  function moveNews(direction) {
    console.debug("Moving news in direction " + direction);

    view.currentItem.feedTitleToFeedTitle();

    if (direction == directionLeft) {
      view.incrementCurrentIndex();
    }

    if (direction == directionRight) {
      view.decrementCurrentIndex();
    }

    view.currentItem.feedTitleToFuzzyDate();
  }
}
