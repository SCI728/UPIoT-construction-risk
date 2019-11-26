function CR = algo2 (R)
%ALGO1 传入参数为原来偏好矩阵，一致性检验并修正得到输出矩阵
%R = mats_AHP{3};
[m,n] = size(R);
pr = algo1(R);%获取完美偏好矩阵

ciga = 0.8;%设置控制参数
t = 0.1;%一致性阈值
p = 1;
pmax =100;

while p<=pmax
    if f_distance(pr,R)<t%通过一致性检验
        CR = R;
        return;
    else%未通过一致性检验，使用ciga迭代改造原矩阵
        tR = cell(m,n);
        for i = 1:n
            for k = 1:n
                temp = zeros(1,2);
                u = [R{i,k}(1) pr{i,k}(1)];
                v = [R{i,k}(2) pr{i,k}(2)];
                mole = [u(1)^(1-ciga)*u(2)^ciga v(1)^(1-ciga)*v(2)^ciga];
                temp(1)=mole(1)/(mole(1)+(1-u(1))^(1-ciga)*(1-u(2))^ciga);
                temp(2)=mole(2)/(mole(2)+(1-v(1))^(1-ciga)*(1-v(2))^ciga);
                tR{i,k} = temp;
            end
        end
        R = tR;
        p=p+1;
    end
end

