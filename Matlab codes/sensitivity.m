%四种场景

%%Senario1:no expert weights, no first-indicator weights
alpha = -1;
withfw = 0;
[firstmass1, result1] = integration(alpha,withfw,mats_EVALUATE, mats_AHP, mats_DEMATEL);
sorted1 = sort(firstmass1','descend');
delta1 = sorted1(1,:) - sorted1(2,:);

%%Scenario2:no expert weight correction, with only first-indicator weights
alpha = -1;
withfw = 1;
[firstmass2, result2] = integration(alpha,withfw,mats_EVALUATE,mats_AHP, mats_DEMATEL);
sorted2 = sort(firstmass2','descend');
delta2 = sorted2(1,:) - sorted2(2,:);

%%Scenario3:with varying combination of expert weights, but no first-indicator weights
alpha = 0:0.1:1;
withfw = 0;
delta3 = zeros(4, length(alpha));%不同alpha下4个指标评价值的差异性矩阵
massf1_3 = zeros(10,7); 
for i = 1:length(alpha)
    [firstmass3, result3] = integration(alpha(i),withfw,mats_EVALUATE,mats_AHP, mats_DEMATEL);
    massf1_3(i,:) = firstmass3(1,:);
    sorted3 = sort(firstmass3','descend');
    temp = sorted3(1,:) - sorted3(2,:);
    delta3(:,i) = temp';
end

%%Scenario4:with varying combination of expert weights, and also first-indicator weights
alpha = 0:0.1:1;
withfw = 1;
delta4 = zeros(4, length(alpha));%不同alpha下4个指标评价值的差异性矩阵
massf = cell(1,10);
masss = cell(1,10);
for i = 1:length(alpha)
    [firstmass4, secondmass4, result4] = integration(alpha(i),withfw,mats_EVALUATE,mats_AHP, mats_DEMATEL);
    massf{1,i} = firstmass4;
    masss{1,i} = secondmass4;
    sorted4 = sort(firstmass4','descend');
    temp = sorted4(1,:) - sorted4(2,:);
    delta4(:,i) = temp';
end
%------------------------------
del = zeros(17,11);
for i=1:11
    deltemp = zeros(17,1);
    for j = 1:4
        temp = masss{1,i}{1,j};
        sortt = sort(temp', 'descend');
        diff = sortt(1,:)-sortt(2,:);
        if j==1
            deltemp(1:length(diff),1) = diff';
        elseif j==2
            deltemp(6:5+length(diff),1) = diff';
        elseif j==3
            deltemp(11:5+5+length(diff),1) = diff';
        else
            deltemp(15:17,1) = diff';
        end
    end
    del(:,i) = deltemp;
end
    