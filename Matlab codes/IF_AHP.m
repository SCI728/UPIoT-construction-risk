%%Ⱥ��ģ����η�����,��ȡ�ۺϼ�ֵȨ��
function  VW = IF_AHP(mats_ahp)

%--����ר���жϾ���ȷ����ר�ҹ������Ե�Ȩ�أ���Ȩ�õ��ۺ��жϾ���--
CW1 = EX_weights(mats_ahp);%��������AHP��ר���жϾ���ȷ����������Ե�Ȩ��
[m,P] = size(CW1);
w_cell = cell(1,P);%��ʼ��ÿλר�������µļ�ֵȨ������
mats_cons = cell(1,P);%��ʼ��һ���Դ����ļ�ֵ�Ƚ��жϾ���
for k=1:P
    mats_cons{k} = algo2(mats_ahp{k});
    w_cell{k} = valueWeight(mats_cons{k});
end
w_merge = cell2mat(IF_aggregation(CW1,w_cell));
H = (1-w_merge(:,2))./(1+1-w_merge(:,1)-w_merge(:,2));
VW = H./sum(H);

