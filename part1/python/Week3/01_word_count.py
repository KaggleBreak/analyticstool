from collections import Counter

brands = ["cosrx","klairs","skinmiso","klairs","c21.5","klairs","skinmiso"]

brands_count = Counter(brands)
print brands_count

for brand, count in brands_count.most_common(3):
    print brand, count












print "\n\n\n\n"
import random
print random.choice(brands)
print random.sample(brands,2)


print "\n\n\n\n\n\n"
random.shuffle(brands)
print brands
random.shuffle(brands)
print brands