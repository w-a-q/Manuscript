function [ avg_data,snr,snr2 ] = jisuan_snr( f,mt,nt )%%ͼ������ȼ������


               
               target=f(mt-2:mt+2,nt-2:nt+2);%3x3
               %target=f(mt-1:mt+1,nt-1:nt+1);%%������ģ-�����ۼ�
               %target=f(mt-1:mt+1,nt-1:nt+1);%%�����ۼ�-������ģ               
               %target=f(mt-2:mt+2,nt-2:nt+2);%5x5  
               avg_data=mean(target(:));
               target1=double(f(:));
               Ps=double(double(mean(target(:)))-double(mean(target1(:))));
               Pn=double(std(target1(:))); %.^2  
               snr=10*log10(Ps/Pn);
               %snr=Ps/Pn;
               aa=isreal(snr);%%%  aaΪ1��ʵ����Ϊ0�Ǹ���
               if aa==1
                   snr=roundn(snr,-2);
               else
                   snr=roundn(real(snr),-2);  %shibu=real(a)  ;xubu=imag(a)
               end
               
               target2=double(f(mt-4:mt+4,nt-4:nt+4));%9x9
               %target2=double(f(mt-1:mt+1,nt-3:nt+1));%������ģ-�����ۼ�
               %target2=double(f(mt-1:mt+1,nt-3:nt+3));%�����ۼ�-������ģ
               
               %target2=double(f(mt-7:mt+7,nt-7:nt+7));%15x15
               %Ps=double(mean(target(:)));
               
               Ps2=double(double(mean(target(:)))-double(mean(target2(:))));
               Pn2=double(std(target2(:))); %.^2  
               snr2=10*log10(Ps2/Pn2);
               %snr2=(Ps2/Pn2);
               aa=isreal(snr2);%%%  aaΪ1��ʵ����Ϊ0�Ǹ���
               if aa==1
                   snr2=roundn(snr2,-2);
               else
                   snr2=roundn(real(snr2),-2);  %shibu=real(a)  ;xubu=imag(a)
               end
               


end

