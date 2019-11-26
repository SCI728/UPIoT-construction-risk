%%construct perfect multiplicative consistent intuitionistic preference relation
function MCR = algo1(R)
%input IF preference relation(IPR),output a  perfect multiplicative consistent IPR

[m,n]=size(R);
if m~=n
    disp("Check it out!");
    return;
end

MCR = cell(n);
for i = 1:n
    for k = i:n
        if k == i
            MCR{i,k} = R{i,k};%�Խ���Ԫ�ز���
        end
        if k==i+1
            MCR{i,k} = R{i,k};
            MCR{k,i} = fliplr(R{i,k});%ģ������
        end
        if k > i+1
            row = k-i-1;
            uM = zeros(row,2);
            vM = zeros(row,2);
            for t=i+1:k-1
                uM(t-i,1) = R{i,t}(1);
                uM(t-i,2) = R{t,k}(1);
                vM(t-i,1) = R{i,t}(2);
                vM(t-i,2) = R{t,k}(2);
            end
            mole = [prod(uM(:,1).*uM(:,2)) prod(vM(:,1).*vM(:,2))].^(1/(k-i-1));%�۳˲���k-i-1�θ���
            deno = mole+[prod((1-uM(:,1)).*(1-uM(:,2))) prod((1-vM(:,1)).*(1-vM(:,2)))].^(1/(k-i-1));%��ĸ����
            MCR{i,k} = mole./deno;%MCR��uik\vik�ļ���
            MCR{k,i} = fliplr(MCR{i,k});%ģ������
        end
    end
end

