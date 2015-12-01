from collections import Counter
brands = ["cosrx","klairs","skinmiso","klairs","c21.5","klairs","skinmiso"]
brands_count = Counter(brands)
# {"cosrx":1, "klairs":3}
sorted_brand = sorted(brands_count.items(),
                      key=lambda (brand,count):count,
                      reverse=True)

for brand,count in sorted_brand:
    print brand,count

print "\n\n\n\n\n"
sorted_brand2 = sorted(brands_count.items(),
                      key=lambda (brand,count):count,
                      reverse=False)

for brand,count in sorted_brand2:
    print brand,count