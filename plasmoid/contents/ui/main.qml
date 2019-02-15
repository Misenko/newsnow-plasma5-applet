import QtQuick 2.7
import QtQuick.Controls 1.5
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Layouts 1.3
import "./content"
import "./js/utils.js" as Utils

Item{
  id: mainWindow
  clip: true

  // constants
  readonly property int minimumWidth: 250
  readonly property int minimumHeight: 250
  readonly property int logoHeight: 100
  readonly property int logoWidth: 190
  readonly property int dropTargetHeight: 50
  readonly property int newsDefaultHeight: 50
  readonly property int cascadeInterval: 200
  readonly property int quickUpdateInterval: 2000
  readonly property string dataSourceEngine: "newsfeeds"

  Layout.minimumWidth: minimumWidth
  Layout.minimumHeight: minimumHeight

  property string sourceList: plasmoid.configuration.feedList
  property int updateInterval: plasmoid.configuration.updateInterval * 60000
  property int switchInterval: plasmoid.configuration.switchInterval * 1000
  property bool showLogo: plasmoid.configuration.logo
  property bool showDropTarget: plasmoid.configuration.dropTarget
  property bool animations: plasmoid.configuration.animations
  property bool userConfiguring: plasmoid.userConfiguring

  property int cascadingIndex: 0

  onShowLogoChanged: setMinimumHeight()
  onShowDropTargetChanged: setMinimumHeight()

  Component.onCompleted: {
    connectSources(Utils.splitList(sourceList));
    setMinimumHeight();
  }

  onUserConfiguringChanged: {
    if (userConfiguring) {
      return;
    }

    var newSources = Utils.splitList(sourceList);
    if (!Utils.identicalSources(dataSource.connectedSources, newSources)) {
      disconnectSources();
      connectSources(newSources);
    }

    setMinimumHeight();
  }

  PlasmaCore.DataSource {
    id: dataSource
    engine: dataSourceEngine
    interval: updateInterval
    onSourceAdded: {
      checkAllReady();
    }
    onNewData: {
      for(var i=0; i<feeds.count; i++){
        feeds.itemAt(i).displayNews();
      }
    }
  }

  Timer {
    id: allReadyWait
    interval: quickUpdateInterval
    repeat: false
    onTriggered: checkAllReady()
  }

  Timer {
    id: newsSwitch
    interval: switchInterval
    repeat: true
    running: true
    onTriggered: switchNews()
  }

  Timer {
    id: switchCascade
    interval: cascadeInterval
    running: false
    onTriggered: switchNews()
  }

  ColumnLayout {
    anchors.fill: parent

    ColumnLayout{
      id: feedsLayout
      Layout.fillWidth: true
      Layout.fillHeight: true

      Image{
        id: logoImage
        source: {
          if (Utils.isDarkTheme()) {
            "img/logo-light.svg";
          } else {
            "img/logo-dark.svg";
          }
        }
        width: logoWidth
        height: logoHeight

        states: [
        State {
          name: "showLogo"
          when: showLogo
          PropertyChanges {
            target: logoImage
            visible: true
            height: logoHeight
          }
        },
        State {
          name: "hideLogo"
          when: !showLogo
          PropertyChanges {
            target: logoImage
            visible: false
            height: 0
          }
        }
        ]
      }

      Repeater {
        id: feeds
        model: dataSource.connectedSources
        Feed {
          url: modelData
        }
      }

      DropTarget {
        id: dropTarget
        Layout.fillWidth: true
        height: dropTargetHeight

        DropArea {
          anchors.fill: parent
          onDropped: {
            if(drop.hasUrls) {
              for(var i=0; i<drop.urls.length; i++) {
                addSource(drop.urls[i]);
              }
              accept();
            }
          }
        }

        states: [
        State {
          name: "showDropTarget"
          when: showDropTarget
          PropertyChanges {
            target: dropTarget
            visible: true
            height: dropTargetHeight
          }
        },
        State {
          name: "hideDropTarget"
          when: !showDropTarget
          PropertyChanges {
            target: dropTarget
            visible: false
            height: 0
          }
        }
        ]
      }
    }
  }

  function setMinimumHeight() {
    console.debug("Setting applet's minimum height...");

    if (typeof dataSource.connectedSources == 'undefined') {
      return;
    }

    Layout.minimumHeight = (newsDefaultHeight * dataSource.connectedSources.length);
    if (showLogo) {
      Layout.minimumHeight = Layout.minimumHeight + logoHeight;
    }
    if (showDropTarget) {
      Layout.minimumHeight = Layout.minimumHeight + dropTargetHeight;
    }
  }

  function connectSources(sources) {
    console.debug("Connecting sources...");

    for (var i=0; i<sources.length; i++) {
      if (!sources[i]) {
        continue;
      }

      connectSource(sources[i]);
    }
  }

  function disconnectSources() {
    console.debug("Disconnecting sources...");

    var sources = dataSource.connectedSources.slice(0);
    for(var i=0; i<sources.length; i++){
      disconnectSource(sources[i]);
    }
  }

  function disconnectSource(source) {
    console.debug("Disconnecting source '" + source + "'");

    dataSource.disconnectSource(source);
  }

  function addSource(source) {
    console.debug("Adding new source '" + source + "'");

    connectSource(source);
    plasmoid.configuration.feedList += ("," + source);
  }

  function connectSource(source) {
    console.debug("Connecting source '" + source + "'");

    dataSource.connectSource(source);
    setMinimumHeight();
  }

  function switchNews() {
    if (feeds.count < 1) {
      return;
    }

    if (cascadingIndex >= feeds.count) {
      cascadingIndex = 0;
      return;
    }

    console.debug("Switching news with index " + cascadingIndex);

    feeds.itemAt(cascadingIndex).next();
    cascadingIndex++;
    switchCascade.running = true
  }

  function checkAllReady() {
    console.debug("Checking whether all feeds are ready");

    if (allReadyWait.running) {
      return;
    }

    var feedsReady = true
    for (var i=0; i<dataSource.connectedSources.length; i++) {
      feedsReady = feedsReady &&
      (typeof dataSource.data[dataSource.connectedSources[i]] != 'undefined') &&
      (typeof dataSource.data[dataSource.connectedSources[i]]["Title"] != 'undefined') &&
      (typeof dataSource.data[dataSource.connectedSources[i]]["Image"] != 'undefined');
    }

    if (feedsReady) {
      console.debug("All feeds ready!");

      dataSource.interval = updateInterval;
    } else {
      console.debug("Not ready yet");

      dataSource.interval = quickUpdateInterval;
      allReadyWait.running = true;
    }
  }
}
