### getRSS

RSS source parse tool

### Dependencise

* [node-readability](https://github.com/luin/readability) 

a readability tool in NodeJS

```
  npm install node-readability
``` 

* [rmmseg](https://github.com/pluskid/rmmseg-cpp)

a Chinese word segmentation library in Ruby

### Usage

* clone this project

```
  git clone https://github.com/metrue/getRSS
```

* install dependencies

```
  cd getRSS
  bundle install
```

### One more thing need to do

since rmmseg is a great tool for Chinese segmentation library in Ruby, but there is a little issue when your Ruby version is big than 1.9, it's no need depend on 'jcode' anymore, so after install rmmseg, you add follow line into your gems lib of rmmseg.

```
require 'jcode' if RUBY_VERSION < '1.9'
```

and the emerator has no length, need to

```
  algorithm.rb: 18 
  @chars = text.each_char.to_a  
```

### Ok, go get your RSS

```
  rake -T # show what tasks suported
```


### Step

1. bundle install
2. redis-server config
3. emotion map,run save
4. npm install node-readability
