x,y,p=0,0,[(0,0)]
for l in open(0).read().split("\n")[:-1]:
 for c in range(int(l[2:])):
  x,y={"U":(x,y+1),"D":(x,y-1),"R":(x+1,y),"L":(x-1,y)}[l[0]]
  i,j=p[-1]
  if((x-i)**2+(y-j)**2)>2:p.append((i if x==i else i+((x-i)/abs(x-i)),j if y==j else j+((y-j)/abs(y-j))))
print(len(set(p)))

# 288 bytes, part1 only, run with `python3 golf.py < input.txt`
