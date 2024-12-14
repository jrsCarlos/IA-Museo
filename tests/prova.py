from random import randint
print("user" + str(randint(1, 100)))
print(randint(1, 4))
print(randint(1, 7))
print(randint(1, 8))
print(randint(1, 4))
print(randint(1, 4))
print(randint(1, 4))
print(randint(1, 4))
print(randint(1, 4))
nums = []
for i in range(randint(1, 55)):
   nums.append(randint(1, 55))
nums.sort()
for num in nums:print(num, end=" ")
print()
nums = []
for i in range(randint(1, 24)):
   nums.append(randint(1, 24))
nums.sort()
for num in nums:print(num, end=" ")
print()
nums = []
for i in range(randint(1, 32)):
   nums.append(randint(1, 32))
nums.sort()
for num in nums:print(num, end=" ")
print()
nums = []
for i in range(randint(1, 8)):
   nums.append(randint(1, 8))
nums.sort()
for num in nums:print(num, end=" ")
print()