import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
// import org.kde.plasma.components 2.0 as PlasmaComponents
// import org.kde.plasma.core 2.0

Item{
  id: wrapper
  width: parent.width

  property url iconImageUrl
  property string feedTitle
  property int numberOfNews
  property string newsNumber: "(" + (index + 1) + "/" + numberOfNews + ") "

  Column{
    anchors.fill: parent
    spacing: 2

    Row{
      spacing: 5

      Image{
        id: feedImage
        width: 16
        height: 16
        source: iconImageUrl
      }

      Label{
        id: feedLabel
        text: newsNumber + feedTitle
        wrapMode: Text.WordWrap
        font.bold: true
        width: wrapper.width - 21
        maximumLineCount: 1
        elide: Text.ElideRight
      }
    }

    Label{
      id: newsLabel
      width: wrapper.width
      text: modelData["Title"]
      textFormat: Text.StyledText
      wrapMode: Text.WordWrap
    }
  }

  function feedTitleToFuzzyDate(){
    feedLabel.text = newsNumber + dateToFuzzyDate(modelData["DatePublished"])
  }

  function feedTitleToFeedTitle(){
    feedLabel.text = newsNumber + feedTitle
  }

  function dateToFuzzyDate(date){
    var nowDate = new Date()
    var nowMS = nowDate.getTime();
    var newsDate = new Date(date * 1000)
    var nestMS = newsDate.getTime();

    nowDate.setMilliseconds(0);
    nowDate.setSeconds(0);
    nowDate.setMinutes(0);
    nowDate.setHours(0);
    newsDate.setMilliseconds(0);
    newsDate.setSeconds(0);
    newsDate.setMinutes(0);
    newsDate.setHours(0);

    if (nowMS < (nestMS + 3600000)) {
      return i18np("%1 minute ago", "%1 minutes ago", (Math.floor((nowMS - nestMS)/60000)));
    } else if (+nowDate === +newsDate.setDate(newsDate.getDate() + 1)) {
      return i18n("yesterday");
    } else if (nowDate < newsDate) {
      return i18np("%1 hour ago", "%1 hours ago", (Math.floor((nowMS - nestMS)/3600000)));
    } else if (nowDate < newsDate.setDate(newsDate.getDate() + 6)) {
      return i18np("%1 day ago", "%1 days ago", (Math.floor((nowMS - nestMS)/86400000)));
    } else if (nowDate < newsDate.setDate(newsDate.getDate() + 23)) {
      return i18np("%1 week ago", "%1 weeks ago", (Math.floor((nowMS - nestMS)/604800000)));
    } else {
      return i18np("%1 month ago", "%1 months ago", (Math.floor((nowMS - nestMS)/2592000000)));
    }
  }
}
