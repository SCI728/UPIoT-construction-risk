%%计算直觉模糊数的熵
function entr = IF_entropy(IFN)
u = IFN(1);
v = IFN(2);
if length(IFN)==3
    pi = IFN(3);
else
    pi = 1-u-v;
end
entr = (1-abs(u-v)+pi)/(1+abs(u-v)+pi);