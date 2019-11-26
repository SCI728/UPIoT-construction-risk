%%泛在电力物联网风险评估main函数
%addpath(genpath(pwd));
clc;
clear;
p=10;%设定参与决策专家个数
layer = [5 5 4 3];%第一层有两个指标，他们的子指标分别为2和3个
mats_AHP = cell(1,p);%初始化AHP判断矩阵
for i=1:p
    [temp] = xlsread('matsforAHP.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("请检查判断矩阵！");
        return;
    end
    temp_cell = cell(m,n/2);
    for ii = 1:m
        for jj = 1:n/2
            temp_cell{ii,jj} = temp(ii,(2*jj-1):2*jj);
        end
    end 
    mats_AHP{1,i} = temp_cell;
end

mats_DEMATEL = cell(1,p);%初始化DEMATEL判断矩阵
for i=1:p
    [temp] = xlsread('matsforDEMATEL.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("请检查判断矩阵！");
        return;
    end
    temp_cell = cell(m,n/2);
    for ii = 1:m
        for jj = 1:n/2
            temp_cell{ii,jj} = temp(ii,(2*jj-1):2*jj);
        end
    end 
    mats_DEMATEL{1,i} = temp_cell;
end

mats_EVALUATE = cell(1,p);%初始化EVALUATE判断矩阵
for i=1:p
    [temp] = xlsread('matsforEVALUATE.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("请检查评估矩阵！");
        return;
    end
    temp_cell = cell(m,n/2);
    for ii = 1:m
        for jj = 1:n/2
            temp_cell{ii,jj} = temp(ii,(2*jj-1):2*jj);
        end
    end 
    mats_EVALUATE{1,i} = temp_cell;
end

vw = IF_AHP(mats_AHP);%按IF-AHP计算价值权重
CMW = IF_DEMATEL(vw,mats_DEMATEL);%计算一级指标综合权重
layer = [5 5 4 3];
cmw = [0.25,0.27,0.24,0.24];
fl_mass = Assumbly1(layer, cmw, mats_EVALUATE);%结合综合综合权重集结评估信息


