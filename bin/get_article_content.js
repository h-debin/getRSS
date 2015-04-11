#!/usr/bin/env node

if (process.argv.length >= 3) {
    var url = process.argv[2];
} else {
    console.log("Error: no URL of article given");
    process.exit(1);
}
var read = require('node-readability');
 
read(url, function(err, article, meta) {
    if (err) {
        //console.log("Error: " + err);
        //process.exit(1);
        console.log("");
    } else {
        console.log(article.content);
    }
  // Main Article 
  //console.log(article.content);
  // Title 
  //console.log(article.title);
 
  // HTML Source Code 
  //console.log(article.html);
  // DOM 
  //console.log(article.document);
 
  // Response Object from Request Lib 
  //console.log(meta);
 
  // Close article to clean up jsdom and prevent leaks 
  article.close();
});
