$(function() {
  $("a.flickr").each(function(element) {
    url = 'http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=a6993e6ae34fd0a7540f770a9302a818&format=json&jsoncallback=?&photo_id=' + this.id.substring(6);
    $.getJSON(url, function(data) {
      p = data['photo'];
      img = '<img src="http://farm' + p['farm'] + '.static.flickr.com/' + p['server'] + '/' + p['id'] + '_' + p['secret'] + '.jpg"/>';
      $('#flickr' + p['id']).prepend(img).addClass('embed');
    });
  });
});