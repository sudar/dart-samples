/**
 * Code sample to use YQL from Dart
 * This explains how you can use the YQL html table 
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
class fetchComments {

  InputElement _url = null;
  ButtonElement _check = null;
  Element _result = null;
  Element _count = null;
  
  // constructor
  fetchComments() {
    _url = document.query('#url');
    _check = document.query('#check');
    
    _result = document.query('#result');
    _count = document.query('#count');
    
    _result.hidden = true;
  }

  
  void run() {
    _check.on.click.add(_(Event clickEvent) {
      
      if (_url.value != '') {
        // make a fetchComments request
        XMLHttpRequest request = new XMLHttpRequest();

        String baseurl = "http://query.yahooapis.com/v1/public/yql?format=json&q=";
        String query = ''' select * from html where url="${_url.value}" and xpath='//*[@id="comments"]' ''';
        
        request.open("GET", baseurl + encodeURI(query), true);

        request.on.load.add((e) {
          var response = JSON.parse(request.responseText);
          var result = response['query']['results']['h4']['content'];
          write (result.split(' ')[0]);
        });
        request.send();              
      }
      
    });    
  }

  // write the result
  void write(String count) {
    _count.innerHTML = count;
    _result.hidden = false;
  }
}

// the main function
void main() {
  new fetchComments().run();
}
