function x=DS_fusion(x,y) 
 
%功能：融合x,y两行向量 
 
[nx,mx]=size(x); 
if 1~=nx 
    disp('x应为行向量'); 
    return; 
end 
 
[ny,my]=size(y); 
if 1~=ny 
    disp('y应为行向量'); 
    return; 
end 
 
if mx~=my 
    disp('x,y列数应相等'); 
    return; 
end 
 
temp=0; 
for i=1:mx-1 
    x(1,i)=x(1,i)*y(1,i)+x(1,i)*y(1,mx-1)+y(1,i)*x(1,mx-1); 
    if i==mx-1 
        x(1,i)=x(1,i)*y(1,i); 
    end 
    temp=temp+x(1,i); 
end 
 
for i=1:mx-1 
    x(1,i)=x(1,i)/temp; 
end 
 
x(1,mx)=0; 
    