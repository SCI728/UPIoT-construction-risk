%%按照IF-DEMATEL方法计算属性综合权重,aw为if-ahp确定的属性权重
function cmp_w = IF_DEMATEL(aw,mats_dematel)

P = length(mats_dematel);%专家人数
CW2 = EX_weights(mats_dematel);%根据用于DEMATEL的专家判断矩阵确定其关于属性的权重
mats_cons = cell(1,P);%初始化一致性检验、修正后矩阵
for k = 1:P
    mats_cons{k} = algo2(mats_dematel{k});
end
m = length(aw);%属性个数
cmp_w = zeros(1,m);
cmp_mat = IF_aggregation(CW2,mats_dematel);%直觉模糊加成所有影响矩阵
gama = 0.8;%风险偏好系数
B = zeros(m,m);%去模糊化后影响矩阵
for i=1:m
    for j=1:m
        if i~=j
            u = cmp_mat{i,j}(1);
            v = cmp_mat{i,j}(2);
            B1(i,j) = u+(2*gama-1)*(1-u-v);
            B(i,j) = (u+(2*gama-1)*(1-u-v));%去模糊,每列乘以权重
        end
    end
end

B_e = B./max(max(sum(B)),max(sum(B,2)));%单位化
B_cm = B_e*inv(eye(m)-B_e);%综合影响矩阵

Imp1 = sum(B_cm,2);%影响度
Bim1 = sum(B_cm);%被影响度
% d = Imp*Bim;
% for i=1:m
%     cmp_w(i) = d(i,i)/sum(diag(d));
% end
M1 = Imp1+Bim1';%中心度
N1 = Imp1-Bim1';%原因度
cmp_w1 = M1./sum(M1);
for i = 1:m
    B_m(:,i)=B_cm(:,i).*aw(i);
end
Imp2 = sum(B_m,2);%影响度
Bim2 = sum(B_m);%被影响度
M2 = Imp2+Bim2';%中心度
N2 = Imp2-Bim2';%原因度
cmp_w2 = M2./sum(M2); 

%---
% Be = [0 0.5 0.7;0.1 0 0.6;0.2 0.25 0];
% w=[0.3,0.6,0.1];
% m=3;
% for j=1:m
%     B(:,j)=w(j)*Be(:,j);
% end
%---
%B = Be;





        