function output = IF_aggregation(CW,mats_cell)
%按照专家关于属性权重，使用直觉模糊加权算子合成所有评估矩阵

[m,P] = size(CW);%m-属性个数，P-专家个数
[p,q] = size(mats_cell{1});%查看是否为对称阵
if p == q
    output = cell(m,m);%初始化合成矩阵
    for i=1:m
        %temp_row = [0,0];
        for j = 1:m
            if i~=j
                temp = [1 1];
                for k = 1:P
                    temp(1) = temp(1)*(1-mats_cell{1,k}{i,j}(1))^CW(i,k);
                    temp(2) = temp(2)*mats_cell{1,k}{i,j}(2)^CW(i,k);
                end
                %temp_row = temp_row + bigram;
                output{i,j} = [1-temp(1) temp(2)];
            else
                output{i,j} = [0.5,0.5];
            end
        end
    end
else
    output = cell(p,q);
    for i=1:p
        %temp_row = [0,0];
        for j = 1:q
            bigram = [1 1];
            for k = 1:P
                bigram(1) = bigram(1)*(1-mats_cell{1,k}{i,j}(1))^CW(i,k);
                bigram(2) = bigram(2)*mats_cell{1,k}{i,j}(2)^CW(i,k);
            end
            %temp_row = temp_row + bigram;
            output{i,j} = [1-bigram(1) bigram(2)];
        end
    end
end

