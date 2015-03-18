var ex = require('extractcontent')
ex.extractFromUrl('http://minghe.me', function(error, result){ 
   console.log(result.title); 
   // -> Relaxed in Japan.
   console.log(result.content); 
   // -> last week ... 
});
