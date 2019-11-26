%%����IF-DEMATEL�������������ۺ�Ȩ��,awΪif-ahpȷ��������Ȩ��
function cmp_w = IF_DEMATEL(aw,mats_dematel)

P = length(mats_dematel);%ר������
CW2 = EX_weights(mats_dematel);%��������DEMATEL��ר���жϾ���ȷ����������Ե�Ȩ��
mats_cons = cell(1,P);%��ʼ��һ���Լ��顢���������
for k = 1:P
    mats_cons{k} = algo2(mats_dematel{k});
end
m = length(aw);%���Ը���
cmp_w = zeros(1,m);
cmp_mat = IF_aggregation(CW2,mats_dematel);%ֱ��ģ���ӳ�����Ӱ�����
gama = 0.8;%����ƫ��ϵ��
B = zeros(m,m);%ȥģ������Ӱ�����
for i=1:m
    for j=1:m
        if i~=j
            u = cmp_mat{i,j}(1);
            v = cmp_mat{i,j}(2);
            B1(i,j) = u+(2*gama-1)*(1-u-v);
            B(i,j) = (u+(2*gama-1)*(1-u-v));%ȥģ��,ÿ�г���Ȩ��
        end
    end
end

B_e = B./max(max(sum(B)),max(sum(B,2)));%��λ��
B_cm = B_e*inv(eye(m)-B_e);%�ۺ�Ӱ�����

Imp1 = sum(B_cm,2);%Ӱ���
Bim1 = sum(B_cm);%��Ӱ���
% d = Imp*Bim;
% for i=1:m
%     cmp_w(i) = d(i,i)/sum(diag(d));
% end
M1 = Imp1+Bim1';%���Ķ�
N1 = Imp1-Bim1';%ԭ���
cmp_w1 = M1./sum(M1);
for i = 1:m
    B_m(:,i)=B_cm(:,i).*aw(i);
end
Imp2 = sum(B_m,2);%Ӱ���
Bim2 = sum(B_m);%��Ӱ���
M2 = Imp2+Bim2';%���Ķ�
N2 = Imp2-Bim2';%ԭ���
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





        