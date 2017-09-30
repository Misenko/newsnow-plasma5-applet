import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import "../js/utils.js" as Utils

Item {
  id: wrapper
  width: parent.width

  readonly property int iconSize: 16

  property url iconUrl
  property string feedTitle
  property int numberOfNews
  property string newsNumber: "(" + (index + 1) + "/" + numberOfNews + ") "

  NewsBody {
    id: newsBody
    icon: iconUrl
    title: newsNumber + feedTitle
    body: modelData["Title"]
    wrapperWidth: wrapper.width
  }

  function feedTitleToFuzzyDate() {
    console.debug("Changing feed title to fuzzy date");
    newsBody.title = newsNumber + Utils.dateToFuzzyDate(modelData["DatePublished"])
  }

  function feedTitleToFeedTitle() {
    console.debug("Changing fuzzy date back to feed title");
    newsBody.title = newsNumber + feedTitle
  }
}
