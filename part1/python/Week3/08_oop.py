class Brand:
    def __init__(self, values=None):
        self.dict = {}
        if values is not None:
            for brand in values:
                self.dict.update({brand:values[brand]})

    def __repr__(self):
        return "Brand : "+str(self.dict.keys())

    def add(self,brand,product):
        self.dict[brand] = product

    def contains(self, brand):
        return brand in self.dict.keys()

    def remove(self, brand):
        del self.dict[brand]


test_brand = Brand({"klairs":1,"skinmiso":3})

print test_brand
test_brand.add("test",2)
print test_brand
print