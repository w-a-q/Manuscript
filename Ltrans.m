function P=Ltrans(X)

[m,n]=size(X);

    f=double(X);   %对于可见光，这样才能取暗点
    
    g=double(zeros(m,n));%设置输出双精度矩阵
    k=120;          %min-120;max-20
    step=4;        %设置梯度步长
    
    for i= 1:m-1          %各向背景预测
       if i<step+1 | m-i<step+1  %对边缘进行了不处理
                g(i,:)=0;
                continue;
       end
       
          
            right=abs(f(i,:)-f(i+step,:));
            left=abs(f(i,:)-f(i-step,:));
            ce=exp(-(mean(right)/k)^2);
            cw=exp(-(mean(left)/k)^2);
            csum=ce*right+cw*left;
            g(i,:)=csum/2;      %  
            
        
    end

        for j=1:n-1
            if j<step+1 | n-j<step+1  %对边缘进行了不处理
                g(:,j)=0;
                continue;
            end
          
            up=abs(f(:,j)-f(:,j-step));
            down=abs(f(:,j)-f(:,j+step));

            cn=exp(-(mean(up)/k)^2);     %求各方向系数
            cs=exp(-(mean(down)/k)^2);

            csum=cn*up+cs*down;

            g(:,j)=csum/2;      %  
            
        end
    P{1}=f(1:m-1,:)-g(1:m-1,:);
    P{2}=f(:,1:n-1)-g(:,1:n-1); 