%计算两直觉模糊数的相似度
function s = IF_similarity(f1,f2)
f2_c = [f2(2),f2(1)];
if (f1==f2)==(f1==f2_c)
    s = 0.5;
else
    s = IF_distance(f1,f2_c)/(IF_distance(f1,f2)+IF_distance(f1,f2_c));
end
