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

function splitList(list){
  return list.split(",");
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
