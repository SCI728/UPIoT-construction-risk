%%群体模糊层次分析法,获取综合价值权重
function  VW = IF_AHP(mats_ahp)

%--根据专家判断矩阵确定各专家关于属性的权重，加权得到综合判断矩阵--
CW1 = EX_weights(mats_ahp);%根据用于AHP的专家判断矩阵确定其关于属性的权重
[m,P] = size(CW1);
w_cell = cell(1,P);%初始化每位专家评判下的价值权重数组
mats_cons = cell(1,P);%初始化一致性处理后的价值比较判断矩阵
for k=1:P
    mats_cons{k} = algo2(mats_ahp{k});
    w_cell{k} = valueWeight(mats_cons{k});
end
w_merge = cell2mat(IF_aggregation(CW1,w_cell));
H = (1-w_merge(:,2))./(1+1-w_merge(:,1)-w_merge(:,2));
VW = H./sum(H);

