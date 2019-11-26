%%定义两个直觉模糊数的距离
function d = IF_distance(f1,f2)
d = (abs(f1(1)-f2(1))+abs(f1(2)-f2(2)))/2;