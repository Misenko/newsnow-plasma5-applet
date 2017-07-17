import QtQuick 2.7
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import "./content"

Item{
  id: mainWindow
  clip: true

  Layout.minimumWidth: 250
  Layout.minimumHeight: 200

  property string sourceList: plasmoid.configuration.feedList
  property int updateInterval: plasmoid.configuration.updateInterval * 60000
  property int switchInterval: plasmoid.configuration.switchInterval * 1000
  property bool showLogo: plasmoid.configuration.logo
  property bool showDropTarget: plasmoid.configuration.dropTarget
  property bool animations: plasmoid.configuration.animations
  property bool userConfiguring: plasmoid.userConfiguring

  property int logoHeight: 96
  property int logoWidth: 192
  property int dropTargetHeight: 50

  property int cascadingIndex: 0

  onShowLogoChanged: setMinimumHeight()
  onShowDropTargetChanged: setMinimumHeight()

  Component.onCompleted: {
    connectSources(sourceList.split(','));
    setMinimumHeight();
  }

  onUserConfiguringChanged: {
    if(userConfiguring){
      return;
    }

    var newSources = sourceList.split(',');
    if(!identicalSources(dataSource.connectedSources, newSources)){
      disconnectSources();
      connectSources(newSources);
    }

    setMinimumHeight();
  }

  PlasmaCore.DataSource {
    id: dataSource
    engine: "newsfeeds"
    interval: updateInterval
    onSourceAdded: {
      checkAllReady();
    }
  }

  Timer {
    id: allReadyWait
    interval: 2000
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
    interval: 200
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
        source: "img/logo.svg"
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
            if(drop.hasUrls){
              for(var i=0; i<drop.urls.length; i++){
                connectSource(drop.urls[i]);
                plasmoid.configuration.feedList += ("," + drop.urls[i]);
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

  function setMinimumHeight(){
    if(typeof dataSource.connectedSources == 'undefined'){
      return;
    }

    Layout.minimumHeight = (50 * dataSource.connectedSources.length);
    if(showLogo){
      Layout.minimumHeight = Layout.minimumHeight + 100;
    }
    if(showDropTarget){
      Layout.minimumHeight = Layout.minimumHeight + 50;
    }
  }

  function identicalSources(oldSources, newSources){
    if(oldSources.length != newSources.length){
      return false;
    }

    for(var i=0; i<oldSources.length; i++){
      if(oldSources[i] != newSources[i]){
        return false;
      }
    }

    return true;
  }

  function connectSources(sources){
    for(var i=0; i<sources.length; i++){
      if (!sources[i]){
        continue;
      }

      connectSource(sources[i]);
    }
  }

  function disconnectSources(){
    var sources = dataSource.connectedSources.slice(0);
    for(var i=0; i<sources.length; i++){
      dataSource.disconnectSource(sources[i]);
    }
  }

  function connectSource(source){
    dataSource.connectSource(source);
    setMinimumHeight();
  }

  function switchNews(){
    if (feeds.count < 1){
      return;
    }

    if (cascadingIndex >= feeds.count){
      cascadingIndex = 0;
      return;
    }

    feeds.itemAt(cascadingIndex).next();
    cascadingIndex++;
    switchCascade.running = true
  }

  function checkAllReady(){
    if(allReadyWait.running){
      return;
    }

    var feedsReady = true
    for(var i=0; i<dataSource.connectedSources.length; i++){
      feedsReady = feedsReady &&
                   (typeof dataSource.data[dataSource.connectedSources[i]] != 'undefined') &&
                   (typeof dataSource.data[dataSource.connectedSources[i]]["Title"] != 'undefined') &&
                   (typeof dataSource.data[dataSource.connectedSources[i]]["Image"] != 'undefined');
    }

    if(feedsReady){
      dataSource.interval = updateInterval;
    }
    else{
      dataSource.interval = 2000;
      allReadyWait.running = true;
    }
  }
}
