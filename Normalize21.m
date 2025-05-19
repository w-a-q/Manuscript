function OutImg = Normalize21(InImg,bian) 
[m,n]=size(InImg);
OutImg=zeros(m,n);

x_center=round(m/2);
y_center=round(n/2);
% Radius=80;
IMG_Out=zeros(m,n);
IMG_Out(bian+1:m-bian,bian+1:n-bian)=InImg(bian+1:m-bian,bian+1:n-bian);
data=[];
for i=1:m%mcenter-window_r:mcenter+window_r
    for j=1:n%ncenter-window_r:ncenter+window_r       
        if IMG_Out(i,j)>0 %& IMG_Out(i,j)<580
            data=[data,IMG_Out(i,j)];
        end
    end
end
max1=double(max(data(:)));%InImg
min1=double(min(data(:)));
for i=1:m%mcenter-window_r:mcenter+window_r
    for j=1:n%ncenter-window_r:ncenter+window_r     
        if IMG_Out(i,j)>0 %& IMG_Out(i,j)<580
            a=double(IMG_Out(i,j));
            outImage2(i,j)=double(((a-min1)/(max1-min1))*255);%((zuhe_img4(i,j)-min1)/(max1-min1))*255
        else
            outImage2(i,j)=0;
        end
    end
end
OutImg=uint8(outImage2);
end