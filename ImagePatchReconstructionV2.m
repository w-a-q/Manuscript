%----------------------------------------%
%     Infrared Patch Image Model(IPI Model)      %
%                                        Date:  Dec,2015
%  Reference:
% Gao, Chenqiang, et al. "Infrared patch-image model for small target detection in a single image." 
% IEEE Transactions on Image Processing 22.12 (2013): 4996-5009.


function [RecoverI]=ImagePatchReconstructionV2(NewI,OriginImage,EndRow,EndColumn,wx,wy,sliding_step_x,sliding_step_y)
[~, q]=size(NewI);

[m n]=size(OriginImage);


% row_amount=length(1:sliding_step_y:m-wy+1);
column_amount=length(1:sliding_step_x:EndColumn-wx+1);

RecoverI=zeros(EndRow,EndColumn);
A=zeros(EndRow,EndColumn);
AddMatrix=zeros(EndRow,EndColumn);
for ii=1:q         
    temp=zeros(EndRow,EndColumn);
    a=ceil(ii/column_amount);
    b=rem(ii,column_amount);
    if b==0
        b=column_amount;
    end
    xBegin=(b-1)*sliding_step_x+1;
    yBegin=(a-1)*sliding_step_y+1;

    temp(yBegin:yBegin+wy-1,xBegin:xBegin+wx-1)=reshape(NewI(:,ii),wy,wx);

    tempLogical=temp~=0;
    A=A+temp;
    AddMatrix=AddMatrix+tempLogical;
%     A(yBegin:yBegin+wy-1,xBegin:xBegin+wx-1,ii)=reshape(NewI(:,ii),wy,wx);
end
RecoverTemp = divide_nonzero_elements(A(1:EndRow,1:EndColumn),AddMatrix(1:EndRow,1:EndColumn));
% RecoverTemp=A(1:EndRow,1:EndColumn)./AddMatrix(1:EndRow,1:EndColumn);          
RecoverI=RecoverTemp(1:m,1:n);
end

function result = divide_nonzero_elements(A, B)
    % 找到 A 和 B 中不为 0 的元素的位置
    nonzero_A = A ~= 0;
    nonzero_B = B ~= 0;
    
    % 将 A 和 B 中不为 0 的元素相除，注意避免除以 0 的情况
    result = zeros(size(A));
    result(nonzero_A & nonzero_B) = A(nonzero_A & nonzero_B) ./ B(nonzero_A & nonzero_B);
end

















