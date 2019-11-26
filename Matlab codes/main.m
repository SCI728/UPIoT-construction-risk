%%���ڵ�����������������main����
%addpath(genpath(pwd));
clc;
clear;
p=10;%�趨�������ר�Ҹ���
layer = [5 5 4 3];%��һ��������ָ�꣬���ǵ���ָ��ֱ�Ϊ2��3��
mats_AHP = cell(1,p);%��ʼ��AHP�жϾ���
for i=1:p
    [temp] = xlsread('matsforAHP.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("�����жϾ���");
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

mats_DEMATEL = cell(1,p);%��ʼ��DEMATEL�жϾ���
for i=1:p
    [temp] = xlsread('matsforDEMATEL.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("�����жϾ���");
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

mats_EVALUATE = cell(1,p);%��ʼ��EVALUATE�жϾ���
for i=1:p
    [temp] = xlsread('matsforEVALUATE.xlsx',i);
    [m,n] = size(temp);
    if rem(n,2) ~= 0
        disp("������������");
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

vw = IF_AHP(mats_AHP);%��IF-AHP�����ֵȨ��
CMW = IF_DEMATEL(vw,mats_DEMATEL);%����һ��ָ���ۺ�Ȩ��
layer = [5 5 4 3];
cmw = [0.25,0.27,0.24,0.24];
fl_mass = Assumbly1(layer, cmw, mats_EVALUATE);%����ۺ��ۺ�Ȩ�ؼ���������Ϣ


