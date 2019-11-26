function W = valueWeight(CR)
%计算属性权重向量，输入为最终通过一致性的矩阵

%CR=cr;
[m,n] = size(CR);
intR = cell2mat(CR);

fl = zeros(m,n);
cei = zeros(m,n);
W = cell(m,1);
for i = 1:n
    fl(:,i) = intR(:,2*i-1);%u
    cei(:,i) = intR(:,2*i);%v
end
sum_u = sum(fl,2)./sum(sum(fl));
sum_v =  sum(cei,2)./sum(sum(cei));
for i = 1:n
    W{i} = [roundn(sum_u(i),-4) roundn(sum_v(i),-4)];
end



