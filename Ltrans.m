function P=Ltrans(X)

[m,n]=size(X);

    f=double(X);   %���ڿɼ��⣬��������ȡ����
    
    g=double(zeros(m,n));%�������˫���Ⱦ���
    k=120;          %min-120;max-20
    step=4;        %�����ݶȲ���
    
    for i= 1:m-1          %���򱳾�Ԥ��
       if i<step+1 | m-i<step+1  %�Ա�Ե�����˲�����
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
            if j<step+1 | n-j<step+1  %�Ա�Ե�����˲�����
                g(:,j)=0;
                continue;
            end
          
            up=abs(f(:,j)-f(:,j-step));
            down=abs(f(:,j)-f(:,j+step));

            cn=exp(-(mean(up)/k)^2);     %�������ϵ��
            cs=exp(-(mean(down)/k)^2);

            csum=cn*up+cs*down;

            g(:,j)=csum/2;      %  
            
        end
    P{1}=f(1:m-1,:)-g(1:m-1,:);
    P{2}=f(:,1:n-1)-g(:,1:n-1); 