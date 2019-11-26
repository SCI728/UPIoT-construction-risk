%%����Ϊ����ר�Ҹ�����ֱ��ģ���жϾ�����ɵ����飬���Ϊ����ר�ҹ������Ե�Ȩ��
function CW = EX_weights(M)
%M=mats_AHP;
P = length(M);%ר������
for i = 1:P
    [m,n] = size(M{1,1});
    if [m,n]~=size(M{1,i})
        disp("����ר���жϾ���");
        return;
    end
end
[m,n] = size(M{1,1});%�жϾ�����������mΪ���Ը���
CW = zeros(m,P);%��ʼ��ר���ۺ�Ȩ�����飬Ԫ��Ϊm*1����
%--��ר��ֱ��ģ���жϾ���ת��Ϊ��Ӧ��mass��������--
mass_cell  = cell(1,P);%�洢ת����mass��������
for i=1:P
    temp_mass = zeros(m,n+1);
    for ii = 1:m
        v_denom = 0;%mass������ĸ�ۺ�
        u_mole = zeros(1,n);%mass��������
        for jj = 1:n
            u = M{1,i}{ii,jj}(1);
            v = M{1,i}{ii,jj}(2);
            u_mole(jj) = u;%u
            v_denom = v_denom + 1 - v;%sum(1-v)
        end
        t_m = u_mole(:)./v_denom;
        temp_mass(ii,:) = [t_m' 1-sum(t_m)];
    end
    mass_cell{1,i} = temp_mass;
end

%--������ר����ԥ��ȷ����ר�ҹ�������i��Ȩ��--
mat_entropy = zeros(m,P);%����ר��ר�ҹ������Ե���
for i=1:P
    temp_vec = zeros(m,1);%ĳר�ҹ������Ե�������
    for ii=1:m
        sum_col=0;
        for jj=1:n
            sum_col = sum_col + IF_entropy(M{1,i}{ii,jj});
        end
        temp_vec(ii) = sum_col/n;
    end 
    mat_entropy(:,i) = temp_vec;
end
ew = zeros(m,P);%ר�ҹ�������i����Ȩ��
for i = 1:m
    for j = 1:P
        ew(i,j) = (1-mat_entropy(i,j))/(P-sum(mat_entropy(i,:)));
    end
end

%--����֤�����ۼ���ר��֧��Ȩ��--
sw = zeros(m,P);
for prop = 1:m
    prop_cell = cellfun(@(x) x(prop,:),mass_cell,'un',0);%ȡ�����Ӱ��ĵ�prop�У����Ԫ������
    mass = cell2mat(prop_cell');%��ÿλר�ҹ�������prop��mass�����������һ�������
    [mm,nn] = size(mass);
    NC = 2^(nn-1)-1;%�ǿ��Ӽ����� 
    set1 = 1:nn-1;
    BIcells = cell(1,mm);%�洢����ר�ҵ�BI
    for i = 1:mm
        BIcells{i} = zeros(NC,2);
    end     
    for ii = 1:mm
        t=1;
        for i = 1:nn-1
            comb = nchoosek(set1,i);%ʶ����Ԫ�ص����
            [p,q] = size(comb);
            for j = 1:p
                if q ~= nn-1
                    Bel = sum(mass(ii,comb(j,:)));%���ζȺ���
                    Pl = Bel + mass(ii,nn);%��Ȼ�Ⱥ���
                    BIcells{ii}(t,:) = [Bel Pl];%��������
                    t = t+1;
                else
                    BIcells{ii}(t,:) = [1 1];
                    t = t+1;
                end
            end
        end
    end
    set2 = 1:mm;
    subs = nchoosek(set2,2);%ר���������
    zero = zeros(1,mm);
    distance = diag(zero);%��ͻ����
    kd = diag(zero);%��ͻϵ��
    cf = diag(zero);%ר��֤�ݳ�ͻ��
    for i = 1:length(subs)
        p = subs(i,1);
        q = subs(i,2);
        kd(p,q) = 1-sum(mass(p,:).*mass(q,:));
        BI1 = BIcells{p};
        BI2 = BIcells{q};
        count=zeros(NC,1);
        for j = 1:NC
            a1 = BI1(j,1);
            b1 = BI1(j,2);
            a2 = BI2(j,1);
            b2 = BI2(j,2);
            count(j) = sqrt(((a1+b1)/2-(a2+b2)/2)^2+(1/3)*((b1-a1)/2-(b2-a2)/2)^2);%�����������
        end
        distance(p,q) = sqrt((1/NC)*sum(count.^2));
        pmax = find(mass(p,:)==max(mass(p,:)));
        qmax = find(mass(q,:)==max(mass(q,:)));
        if  pmax ~= qmax
            cf(p,q) = sqrt((kd(p,q)+distance(p,q))/2);
        else
            cf(p,q) = (kd(p,q)+distance(p,q))/2;
        end
    end
    sw_exp = sum(1-cf)'./sum(sum(cf));
    sw(prop,:) = normalizerow(sw_exp')';
end
%CW = (ew+sw)./2;
CW=sw;


