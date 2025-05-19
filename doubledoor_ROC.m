clc;
clear;
 
% sourcefilefolder='D:\第五篇论文代码\cut_bmp8';
% aimfilefolder='D:\第五篇论文代码\低秩结果\bj';%bj
% aimfilefolder1='D:\第五篇论文代码\低秩结果';%chafen

% sourcefilefolder='H:\Postgraduate_information\paper\test\test_RPCA\inexact_alm_rpca\target\target9';%
% aimfilefolder='D:\第五篇论文代码\image\bj';%bj
% aimfilefolder1='D:\第五篇论文代码\image\chafen';%chafen


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
k1=5;%外窗7x7  round(7/2)
k2=1;%内窗3x3  floor(3/2)

for hang=k1:m-(k1-1)
    for lie=k1:n-(k1-1)
        c1=0;
        c2=0;
        temp1=zeros(2*(k1-1)+1,2*(k1-1)+1);%开始构建外窗口的结构7*7
        temp2=zeros(k2*2+1,k2*2+1);%构建内窗口的结构3*3
        data1=0;
        data2=0;
        data=0;
        data_cha=0;
        temp1=im(hang-(k1-1):hang+(k1-1),lie-(k1-1):lie+(k1-1));%把图像矩阵开始读入到temp的零矩阵中，外窗读取
        temp2=im(hang-k2:hang+k2,lie-k2:lie+k2); %图像读取，内窗读取
        data1=sum(temp1(:));%外窗求和像素值
        data2=sum(temp2(:));%内窗求和像素值
        data=data1-data2; %外窗像素减去内窗像素得到外窗原有像素
        data_cha=data/((2*(k1-1)+1)*(2*(k1-1)+1)-(2*k2+1)*(2*k2+1));%得到平均灰度差值图像
        data2_mid=data2/((2*k2+1)*(2*k2+1));%内窗口像素平均灰度值
        data2_cha=abs(data2_mid-data_cha);%求内外像素值灰度值的差，代替原图像的像素点，得到平均灰度差值图像
        if data2_cha<=thresh  %开始进行阈值间的比较判断图像
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


