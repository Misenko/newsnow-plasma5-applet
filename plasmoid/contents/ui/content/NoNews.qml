import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Item {
  id: wrapper
  width: parent.width

  NewsBody {
    id: newsBody
    icon: "../img/rss-orange.svg"
    title: "Failed to fetch the feed..."
    body: ""
    wrapperWidth: wrapper.width
  }
}
