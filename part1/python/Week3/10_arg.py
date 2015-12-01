def magic(*arg1, **arg2):
    print "unnamed args:", arg1
    print "keyword args:", arg2


magic(1,2,3,key="word",key2="test1",key3="ddd")
