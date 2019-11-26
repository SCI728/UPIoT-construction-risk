%%参数为所有专家给出的直觉模糊判断矩阵组成的数组，结果为所有专家关于属性的权重
function CW = EX_weights(M)
%M=mats_AHP;
P = length(M);%专家人数
for i = 1:P
    [m,n] = size(M{1,1});
    if [m,n]~=size(M{1,i})
        disp("请检查专家判断矩阵！");
        return;
    end
end
[m,n] = size(M{1,1});%判断矩阵行列数，m为属性个数
CW = zeros(m,P);%初始化专家综合权重数组，元素为m*1矩阵
%--将专家直觉模糊判断矩阵转换为对应的mass函数矩阵--
mass_cell  = cell(1,P);%存储转化后mass函数矩阵
for i=1:P
    temp_mass = zeros(m,n+1);
    for ii = 1:m
        v_denom = 0;%mass函数分母累和
        u_mole = zeros(1,n);%mass函数分子
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

%--计算由专家犹豫度确定的专家关于属性i的权重--
mat_entropy = zeros(m,P);%所有专家专家关于属性的熵
for i=1:P
    temp_vec = zeros(m,1);%某专家关于属性的熵向量
    for ii=1:m
        sum_col=0;
        for jj=1:n
            sum_col = sum_col + IF_entropy(M{1,i}{ii,jj});
        end
        temp_vec(ii) = sum_col/n;
    end 
    mat_entropy(:,i) = temp_vec;
end
ew = zeros(m,P);%专家关于属性i的熵权重
for i = 1:m
    for j = 1:P
        ew(i,j) = (1-mat_entropy(i,j))/(P-sum(mat_entropy(i,:)));
    end
end

%--基于证据理论计算专家支持权重--
sw = zeros(m,P);
for prop = 1:m
    prop_cell = cellfun(@(x) x(prop,:),mass_cell,'un',0);%取所有子胞的第prop行，组成元胞数组
    mass = cell2mat(prop_cell');%将每位专家关于属性prop的mass函数向量组成一个大矩阵
    [mm,nn] = size(mass);
    NC = 2^(nn-1)-1;%非空子集个数 
    set1 = 1:nn-1;
    BIcells = cell(1,mm);%存储所有专家的BI
    for i = 1:mm
        BIcells{i} = zeros(NC,2);
    end     
    for ii = 1:mm
        t=1;
        for i = 1:nn-1
            comb = nchoosek(set1,i);%识别框架元素的组合
            [p,q] = size(comb);
            for j = 1:p
                if q ~= nn-1
                    Bel = sum(mass(ii,comb(j,:)));%信任度函数
                    Pl = Bel + mass(ii,nn);%似然度函数
                    BIcells{ii}(t,:) = [Bel Pl];%信任区间
                    t = t+1;
                else
                    BIcells{ii}(t,:) = [1 1];
                    t = t+1;
                end
            end
        end
    end
    set2 = 1:mm;
    subs = nchoosek(set2,2);%专家两两组合
    zero = zeros(1,mm);
    distance = diag(zero);%冲突距离
    kd = diag(zero);%冲突系数
    cf = diag(zero);%专家证据冲突度
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
            count(j) = sqrt(((a1+b1)/2-(a2+b2)/2)^2+(1/3)*((b1-a1)/2-(b2-a2)/2)^2);%信任区间距离
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


