function result = Assumbly1(layers, cmw, mats_eval)
%��ֱ��ģ���ںϣ���֤���ں�,
%�����������Ϊ����һ��ָ���¶���ָ�������һ��ָ���ۺ�Ȩ�ء�����ָ���������IFM��

P=length(mats_eval);%ר����
for k=1:P
    [m,n]=size(mats_eval{1,k});
    if sum(layers) ~= m
        disp("�����ר��ֱ��ģ����������.");
        k
    end
end
CW3 = EX_weights(mats_eval);%��ȡ��ר�ҹ��ڶ���ָ���Ȩ��
merge_EVL = IF_aggregation(CW3,mats_eval);%IFWA���Ӻϳ�����ר�Ҿ���
[m,n] = size(merge_EVL);%m--����ָ�������n--���շּ�����
fcount = length(layers);%һ��ָ�����

mcell_EVL = mat2cell(merge_EVL,layers,n);%��һ��ָ���з�Ϊ����Ӿ���

mass_EVL = cell(1,fcount);%��ʼ��mass��������
for i = 1:fcount
    temp_mat = mcell_EVL{i};
    temp_cel = zeros(layers(i),n+2);%��ʼ����Ӧmass��������
    for j = 1:layers(i)
        v_denom = 0;%mass������ĸ�ۺ�
        u_mole = zeros(1,n);%mass��������
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

%֤���ۿ���ϳ�


mass_res = zeros(fcount,n+2);
for i=1:fcount
mass_func = mass_EVL{i};%ȡ�����ںϵ�֤�ݾ���
mass_res(i,:) = mass_func(1,:);
    for jj = 1:layers(i)-1
        mass_res(i,:) = DS_fusion(mass_res(i,:),mass_func(jj+1,:));
    end 
end

%֤���ۿ�
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
%�����ں�
result = dis_mass(1,:);
for j = 1:fcount-1
    result = DS_fusion(result,dis_mass(j+1,:));
end




