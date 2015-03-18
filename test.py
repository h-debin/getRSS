import newspaper
url = 'http://news.163.com/15/0312/14/AKH0G5LG00014JB6.html'

a = Article(url, language='zh') # Chinese

a.download()
a.parse()

print(a.text[:150])
