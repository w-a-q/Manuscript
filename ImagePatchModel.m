%----------------------------------------%
%     Infrared Patch Image Model(IPI Model)      %
%
%                                        Date:  Dec,2015
%  Reference:
% Gao, Chenqiang, et al. "Infrared patch-image model for small target detection in a single image." 
% IEEE Transactions on Image Processing 22.12 (2013): 4996-5009.
%----------------------------------------%

function [New_I,EndRow,EndColumn]=ImagePatchModel(I,wx,wy,sliding_step_x,sliding_step_y)
[m,n]=size(I);

column_length=wx*wy;        %vector length of each patch

Nx=length(1:sliding_step_x:n-wx+1);
Ny=length(1:sliding_step_y:m-wy+1);

if mod(n-wx,sliding_step_x)==0
    Nx=Nx;
else
    Nx=Nx+1;
end
if mod(m-wy,sliding_step_y)==0
    Ny=Ny;
else
    Ny=Ny+1;
end

EndColumn=(Nx-1)*sliding_step_x+wx;
EndRow=(Ny-1)*sliding_step_y+wy;
 
Up=[I,repmat(I(:,n),1,EndColumn-n)];
ImageExpand=[Up;repmat(Up(m,:),EndRow-m,1)];
%% Model construction
for yy=1:sliding_step_y:(Ny-1)*sliding_step_y+1
    for xx=1:sliding_step_x:(Nx-1)*sliding_step_x+1
        
        temp=zeros(wy,wx);
        index_row=(yy-1)/sliding_step_y+1;        
        index_column=(xx-1)/sliding_step_x+1;
        
        yy_end=yy+wy-1;
        xx_end=xx+wx-1;

        temp(:,:)=ImageExpand(yy:yy_end,xx:xx_end);      
        New_column=(index_row-1)*Nx+index_column;       
        New_I(:,New_column)=reshape(temp,column_length,1);      %vectorize each patch as a column of a new image
    end
end
end