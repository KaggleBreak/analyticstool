#-*- coding: utf-8 -*-

s = set()
s.add("coupang")
s.add("wemakeprice")
s.add("ticketmonster")
s.add("auction")
s.add("gmarket")
s.add("auction")
s.add("wemakeprice")
s.add("auction")

print len(s)

for market in s:
    print market

market_list = list(s)
print market_list[0]
print "coupang" in s
print "lottehomeshopping" in s


#values = {"test1":1,"test2":2}
#print {"test1":1,"test2":2}.keys()