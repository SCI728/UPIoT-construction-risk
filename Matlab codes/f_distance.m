function D = f_distance(R1,R2)
%求解两直觉模糊偏好矩阵的距离
 [m,n] = size(R1);
if(m~=n)
    disp('error！');
    return;
end
para = 1/(2*(n-1)*(n-2));
sum = 0;
for i = 1:n
    temp = 0;
    for k = 1:n
        u1 = R1{i,k}(1);
        u2 = R2{i,k}(1);
        v1 = R1{i,k}(2);
        v2 = R2{i,k}(2);
        pi1 = 1-u1-v1;
        pi2 = 1-u2-v2;
        temp = temp+abs(u1-u2)+abs(v1-v2)+abs(pi1-pi2);
    end
    sum = sum + temp;
end
D = para*sum;
end

