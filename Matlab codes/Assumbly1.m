function result = Assumbly1(layers, cmw, mats_eval)
%先直觉模糊融合，再证据融合,
%输入参数依次为（各一级指标下二级指标个数、一级指标综合权重、二级指标风险评估IFM）

P=length(mats_eval);%专家数
for k=1:P
    [m,n]=size(mats_eval{1,k});
    if sum(layers) ~= m
        disp("请检查第专家直觉模糊评估矩阵.");
        k
    end
end
CW3 = EX_weights(mats_eval);%获取各专家关于二级指标的权重
merge_EVL = IF_aggregation(CW3,mats_eval);%IFWA算子合成所有专家矩阵
[m,n] = size(merge_EVL);%m--二级指标个数，n--风险分级个数
fcount = length(layers);%一级指标个数

mcell_EVL = mat2cell(merge_EVL,layers,n);%按一级指标切分为多个子矩阵

mass_EVL = cell(1,fcount);%初始化mass函数数组
for i = 1:fcount
    temp_mat = mcell_EVL{i};
    temp_cel = zeros(layers(i),n+2);%初始化对应mass函数矩阵
    for j = 1:layers(i)
        v_denom = 0;%mass函数分母累和
        u_mole = zeros(1,n);%mass函数分子
        for jj = 1:n
             u = temp_mat{j,jj}(1);
             v = temp_mat{j,jj}(2);
             u_mole(jj) = u;%u
             v_denom = v_denom + 1 - v;%sum(1-v)
        end
        t_m = u_mole./v_denom;
        temp_cel(j,:) = [t_m 1-sum(t_m,2) 0];
    end
    mass_EVL{i} = temp_cel;
end

%证据折扣与合成


mass_res = zeros(fcount,n+2);
for i=1:fcount
mass_func = mass_EVL{i};%取出待融合的证据矩阵
mass_res(i,:) = mass_func(1,:);
    for jj = 1:layers(i)-1
        mass_res(i,:) = DS_fusion(mass_res(i,:),mass_func(jj+1,:));
    end 
end

%证据折扣
dis_mass = zeros(fcount,n+2);
max_w = max(cmw);
ci = cmw./max_w;
for i=1:fcount
    dis_mass(i,1:n) = ci(i).*mass_res(i,1:n);
    temp = ci(i)*mass_res(i,n+1)+1-ci(i);
    dis_mass(i,n+1:n+2) = [temp zeros(1,1)];
end
    
result0 = mass_res(1,:);
for j = 1:fcount-1
    result0 = DS_fusion(result0,mass_res(j+1,:));
end
%继续融合
result = dis_mass(1,:);
for j = 1:fcount-1
    result = DS_fusion(result,dis_mass(j+1,:));
end




