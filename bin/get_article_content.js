#!/usr/bin/env node

if (process.argv.length >= 3) {
    var url = process.argv[2];
} else {
    console.log("Error: no URL of article given");
    process.exit(1);
}
var read = require('node-readability');
 
try {
    read(url, function(err, article, meta) {
        if (err) {
            //console.log("Error: " + err);
            //process.exit(1);
            console.log("");
        } else {
            console.log(article.content);
            article.close();
        }
    });
} catch(err) {

} finally {
    console.log("");
}

