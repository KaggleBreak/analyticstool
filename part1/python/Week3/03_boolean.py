#-*- coding: utf-8 -*-

print True
print False

print "\n\n\n\n"

print bool(None)
print bool([])
print bool({})
print bool("")
print bool(set())
print bool(0)
print bool(0.0)

print "\n\n\n\n"

print bool(0==False)
print bool(0.0==False)
print bool([]==False)
print bool({}==False)

print "\n\n\n\n"

empty_list = []

if empty_list:
    print "not empty"
else:
    print "empty"


print "\n\n\n\n"

if 0 == False:
    print "0 is False"
else:
    print "0 isn't False"

print "\n\n\n\n"
# all & any
"""
  All은 Falsy 요소가 하나도 없으면 통과, 심지어 비어있어도 됨
  Any는 True 요소가 하나라도 있어야함, 비어있으면 False
"""

print all([True,0])
print all([True,1,{3}])
print any([True,False])
print all([])
print all({})
print any([])