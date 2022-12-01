d=sorted([sum(map(int,x))for x in[z.split()for z in open(0).read().split("\n\n")]]);print(d[-1],sum(d[-3:]))

# 108 bytes, requires piped input. `cat input.txt | python3 golf.py`
