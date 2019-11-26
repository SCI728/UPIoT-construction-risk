function CR = algo2 (R)
%ALGO1 �������Ϊԭ��ƫ�þ���һ���Լ��鲢�����õ��������
%R = mats_AHP{3};
[m,n] = size(R);
pr = algo1(R);%��ȡ����ƫ�þ���

ciga = 0.8;%���ÿ��Ʋ���
t = 0.1;%һ������ֵ
p = 1;
pmax =100;

while p<=pmax
    if f_distance(pr,R)<t%ͨ��һ���Լ���
        CR = R;
        return;
    else%δͨ��һ���Լ��飬ʹ��ciga��������ԭ����
        tR = cell(m,n);
        for i = 1:n
            for k = 1:n
                temp = zeros(1,2);
                u = [R{i,k}(1) pr{i,k}(1)];
                v = [R{i,k}(2) pr{i,k}(2)];
                mole = [u(1)^(1-ciga)*u(2)^ciga v(1)^(1-ciga)*v(2)^ciga];
                temp(1)=mole(1)/(mole(1)+(1-u(1))^(1-ciga)*(1-u(2))^ciga);
                temp(2)=mole(2)/(mole(2)+(1-v(1))^(1-ciga)*(1-v(2))^ciga);
                tR{i,k} = temp;
            end
        end
        R = tR;
        p=p+1;
    end
end

