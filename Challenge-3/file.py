object1 = {"x":
           {"y":
            {"z":
             "a"}
            }
           }

def getValue():
    for i in object1:
        if i == "x":
            object2 = object1[i]
            for j in object2:
                if j == "y":
                    object3 = object2[j]
                    value = object3["z"]
                    print(value)
                
getValue()