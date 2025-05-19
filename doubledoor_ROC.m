clc;
clear;
 
% sourcefilefolder='D:\����ƪ���Ĵ���\cut_bmp8';
% aimfilefolder='D:\����ƪ���Ĵ���\���Ƚ��\bj';%bj
% aimfilefolder1='D:\����ƪ���Ĵ���\���Ƚ��';%chafen

% sourcefilefolder='H:\Postgraduate_information\paper\test\test_RPCA\inexact_alm_rpca\target\target9';%
% aimfilefolder='D:\����ƪ���Ĵ���\image\bj';%bj
% aimfilefolder1='D:\����ƪ���Ĵ���\image\chafen';%chafen


sourcefilefolder='E:\Academic\paper\contrast\vntfra\target\data3\roc';
aimfilefolder='E:\Academic\paper\contrast\vntfra\target\data3\roc\17';

dirOutput = dir(fullfile(sourcefilefolder, '*.bmp'));
fileNames = {dirOutput.name};
num_images = numel(fileNames);
thresh=17;
for t=1:num_images
    t
im= imread([sourcefilefolder,'\',fileNames{t}]);
    [p q ch]=size(im);
    if ch==3
        im=rgb2gray(im);
    end
[m,n]=size(im);
result=logical(zeros(m,n));
k1=5;%�ⴰ7x7  round(7/2)
k2=1;%�ڴ�3x3  floor(3/2)

for hang=k1:m-(k1-1)
    for lie=k1:n-(k1-1)
        c1=0;
        c2=0;
        temp1=zeros(2*(k1-1)+1,2*(k1-1)+1);%��ʼ�����ⴰ�ڵĽṹ7*7
        temp2=zeros(k2*2+1,k2*2+1);%�����ڴ��ڵĽṹ3*3
        data1=0;
        data2=0;
        data=0;
        data_cha=0;
        temp1=im(hang-(k1-1):hang+(k1-1),lie-(k1-1):lie+(k1-1));%��ͼ�����ʼ���뵽temp��������У��ⴰ��ȡ
        temp2=im(hang-k2:hang+k2,lie-k2:lie+k2); %ͼ���ȡ���ڴ���ȡ
        data1=sum(temp1(:));%�ⴰ�������ֵ
        data2=sum(temp2(:));%�ڴ��������ֵ
        data=data1-data2; %�ⴰ���ؼ�ȥ�ڴ����صõ��ⴰԭ������
        data_cha=data/((2*(k1-1)+1)*(2*(k1-1)+1)-(2*k2+1)*(2*k2+1));%�õ�ƽ���ҶȲ�ֵͼ��
        data2_mid=data2/((2*k2+1)*(2*k2+1));%�ڴ�������ƽ���Ҷ�ֵ
        data2_cha=abs(data2_mid-data_cha);%����������ֵ�Ҷ�ֵ�Ĳ����ԭͼ������ص㣬�õ�ƽ���ҶȲ�ֵͼ��
        if data2_cha<=thresh  %��ʼ������ֵ��ıȽ��ж�ͼ��
            result(hang,lie)=0;
        else
            result(hang,lie)=1;
        end
    end
end
% figure(1)
% imshow(result,[]),title('Target image')
     imwrite(result,[aimfilefolder '\' fileNames{t}]);

end


