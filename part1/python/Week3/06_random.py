import random

random.seed(10)
print random.random()
print random.random()

print "\n\n\n\n"
random.seed(10)
print random.random()
print random.random()








print "\n\n\n\n"
for i in range(20):
    print random.randrange(15)

print "\n\n\n\n"






def getRandom(seed):
    random.seed(seed)
    while True:
        yield random.randrange(10)

random_number = getRandom(100)
print random_number
print random_number.next()
print random_number.next()
print random_number.next()

# next to 01_word_count for shuffle