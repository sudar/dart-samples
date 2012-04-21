/**
 * Code sample to use YQL from Dart
 * This explains how you can access Twitter from YQL
 *
 * @author: Sudar (http://sudarmuthu.com/)
 * 
 * Copyright 2012  Sudar Muthu  (email : sudar@sudarmuthu.com)
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <sudar@sudarmuthu.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer or coffee in return - Sudar
 * ----------------------------------------------------------------------------
 */
#import('dart:html');
#import("dart:json");
#import("EncodeDecode.dart");

// the main class
class Twitter {

  InputElement _screenname = null;
  ButtonElement _check = null;
  Element _result = null;
  Element _tweets = null;  
  
  // constructor
  Twitter() {
    _screenname = document.query('#screenname');
    _check = document.query('#check');
    
    _result = document.query('#result');
    _tweets = document.query('#tweets');
    
    _result.hidden = true;
  }

  
  void run() {
    _check.on.click.add(_(Event clickEvent) {
      
      if (_screenname.value != '') {
        // make a Twitter request
        XMLHttpRequest request = new XMLHttpRequest();
        
        String baseurl = "http://query.yahooapis.com/v1/public/yql?format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&q=";
        String query = ''' select * from twitter.user.timeline where screen_name="${_screenname.value}" ''';
        
        request.open("GET", baseurl + encodeURI(query), true);

        request.on.load.add((e) {
          _result.hidden = false;
          
          var response = JSON.parse(request.responseText);
          var tweets = response['query']['results']['statuses']['status'];
          for (final tweet in tweets) {
            write (tweet);
          }
        });
        request.send();              
      }      
    });    
  }

  // write the result
  void write(tweet) {
    Element li = new Element.tag('li');
    li.innerHTML = '''<img src = "${tweet['user']['profile_image_url']}">${tweet['text']}''';
    _result.elements.add(li);
  }
}

// the main function
void main() {
  new Twitter().run();
}