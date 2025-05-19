clear;
clc
close all;

sourcefilefolder='E:\Academic\paper1\waq\target\data1';%
aimfilefolder='E:\Academic\paper\IRCUR-master\target\data3\roc';


dirOutput = dir(fullfile(sourcefilefolder, '*.bmp'));
fileNames = {dirOutput.name};
num_images = numel(fileNames);

I= imread([sourcefilefolder,'\',fileNames{1}]);
[p q ch]=size(I);
if ch==3
    I=rgb2gray(I);
end
% wx=10; wy=10;
% SlidingStepX=5;SlidingStepY=5;%%%Scene1


for cur = 1:2
    cur
%     img = img(:,:,1);
img = imread([sourcefilefolder,'\',fileNames{cur}]);
    [p q ch]=size(img);
    if ch==3
        img=rgb2gray(img);
    end


wx=10; wy=10;
SlidingStepX=11;SlidingStepY=11;%%%Scene2-5,7
% wx=10; wy=10;
% SlidingStepX=6;SlidingStepY=6;%%%Scene6
[D,EndRow,EndColumn]=ImagePatchModel(img,wx,wy,SlidingStepX,SlidingStepY);
 
[m,n]=size(D);    
r=rank(D);
%% IRCUR-R    % Resample row/column version
disp('Running IRCUR-R now.')
para.beta_init = 1.5*max(abs(D(:)));
para.beta = para.beta_init;
para.tol  = 1e-5;
para.con = 3;
para.resample  = true;
para.eta = 0.7;

mt = 112;
nt = 56;

clear pars
pars.MAXITER=50;       % Max Iter
pars.tv='l1'; % The value can be 'iso' or 'l1'; Default is 'iso';
pars.epsilon=1e-2;  % Stop criteria
pars.print=0;  % Show the iteration detail; If ==0, the detaile will not be showed

% T=gaijingexiangyixing(I);
% [L_cols,S_cols] = IRCUR7(D, r,para);
[L_cols,S_cols] = IRCUR_k2(D,para);
% [L_cols,S_cols] = eRPCA_Y(D,para);

background=ImagePatchReconstructionV2(L_cols,I,EndRow,EndColumn,wx,wy,SlidingStepX,SlidingStepY);
corrupted=ImagePatchReconstructionV2(S_cols,I,EndRow,EndColumn,wx,wy,SlidingStepX,SlidingStepY);
 E=mat2gray(corrupted);
 figure(2); imshow(E,[]);title('target');

end

% E2=doubledoor1(corrupted,8.1)*255;%%%Scene6



% 
%     bw = double(I) - E2;
%         bsf=BSF(E2,I);
%         ssim=SSIM(I,bw);
%         bsf
%         ssim
%         [ avg_data,snr,snr2 ] = jisuan_snr(E2,mt,nt);
% snr
% 
% % figure; imshow(background,[]);title('background')
% 
% % E1=double(I)-background;
% % T=doubledoor1(E,1);


% imwrite(E,[aimfilefolder '\' 'result.bmp']);

% % figure; imshow(I);




