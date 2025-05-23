function [X_den,iter,fun_all]=denoise_bound(Xobs,lambda,l,u,pars)
%This function implements the FISTA method for TV-based denoising problems
%
% Based on the paper
% Amir Beck and Marc Teboulle, "Fast Gradient-Based Algorithms for Constrained
% Total Variation Image Denoising and Deblurring Problems"
% -----------------------------------------------------------------------
% Copyright (2008): Amir Beck and Marc Teboulle
% 
% FISTA is distributed under the terms of 
% the GNU General Public License 2.0.
% 
% Permission to use, copy, modify, and distribute this software for
% any purpose without fee is hereby granted, provided that this entire
% notice is included in all copies of any software which is or includes
% a copy or modification of this software and in all copies of the
% supporting documentation for such software.
% This software is being provided "as is", without any express or
% implied warranty.  In particular, the authors do not make any
% representation or warranty of any kind concerning the merchantability
% of this software or its fitness for any particular purpose."
% ----------------------------------------------------------------------
% INPUT
% Xobs ..............................an observed noisy image.
% lambda ........................ parameter
% l ..................................... lower bound on the pixels' values
% u ..................................... upper bound on the pixels' values
% pars.................................parameters structure
% pars.MAXITER ..................... maximum number of iterations
%                                                      (Default=100)
% pars.epsilon ..................... tolerance for relative error used in
%                                                       the stopping criteria (Default=1e-4)
% pars.print ..........................  1 if a report on the iterations is
%                                                       given, 0 if the  report is silenced
% pars.tv .................................. type of total variation
%                                                      penatly.  'iso' for isotropic (default)
%                                                      and 'l1' for nonisotropic
%  
% OUTPUT
% X_den ........................... The solution of the problem 
%                                            min{||X-Xobs||^2+2*lambda*TV(X
%                                            ) : l <= X_{i,j} <=u} 
% iter .............................  Number of iterations required to get
%                                            an optimal solution (up to a tolerance)
% fun_all ......................   An array containing all the function
%                                             values obtained during the
%                                             iterations


%Define the Projection onto the box
if((l==-Inf)&(u==Inf))
    project=@(x)x;
elseif (isfinite(l)&(u==Inf))
    project=@(x)(((l<x).*x)+(l*(x<=l)));
elseif (isfinite(u)&(l==-Inf))
     project=@(x)(((x<u).*x)+((x>=u)*u));
elseif ((isfinite(u)&isfinite(l))&(l<u))
    project=@(x)(((l<x)&(x<u)).*x)+((x>=u)*u)+(l*(x<=l));
else
    error('lower and upper bound l,u should satisfy l<u');
end

% Assigning parameres according to pars and/or default values
flag=exist('pars');%若pars存在则flag=1，反之为0；
if (flag&isfield(pars,'MAXITER'))%判断结构体中是否包含MAXITER字符，是返回1；否返回0.
    MAXITER=pars.MAXITER;
else
    MAXITER=100;
end
if (flag&isfield(pars,'epsilon'))
    epsilon=pars.epsilon;
else
    epsilon=1e-4;
end
if(flag&isfield(pars,'print'))
    prnt=pars.print;
else
    prnt=1;
end
if(flag&isfield(pars,'tv'))
    tv=pars.tv;
else
    tv='iso';
end

[m,n]=size(Xobs);
clear P
P{1}=zeros(m-1,n);
P{2}=zeros(m,n-1);
clear R
R{1}=zeros(m-1,n);
R{2}=zeros(m,n-1);
tk=1;
tkp1=1;
count=0;
i=0;

D=zeros(m,n);
fval=inf;
fun_all=[];
if(prnt)
        fprintf('***********************************\n');
        fprintf('*Solving with FGP/FISTA**\n');
        fprintf('***********************************\n');
        fprintf('#iteration  function-value  relative-difference\n');
        fprintf('---------------------------------------------------------------------------------------\n');
    end
while((i<MAXITER)&(count<5))
    fold=fval;
    %%%%%%%%%
    % updating the iteration counter
    i=i+1;
    %%%%%%%%%
    % Storing the old value of the current solution
    Dold=D;
    %%%%%%%%%%
    %Computing the gradient of the objective function
    Pold=P;
    tk=tkp1;
    D=project(Xobs-lambda*Lforward(R));
    Q=Ltrans(D);%前一个减去后面一个

    %%%%%%%%%%
    % Taking a step towards minus of the gradient
    P{1}=R{1}+1/(8*lambda)*Q{1};
    P{2}=R{2}+1/(8*lambda)*Q{2};
    
    %%%%%%%%%%
    % Peforming the projection step
    switch tv
        case 'iso'
            A=[P{1};zeros(1,n)].^2+[P{2},zeros(m,1)].^2;
            A=sqrt(max(A,1));
            P{1}=P{1}./A(1:m-1,:);
            P{2}=P{2}./A(:,1:n-1);
        case 'l1'
            P{1}=P{1}./(max(abs(P{1}),1));
            P{2}=P{2}./(max(abs(P{2}),1));
        otherwise
            error('unknown type of total variation. should be iso or l1');
    end

    %%%%%%%%%%
    %Updating R and t
    tkp1=(1+sqrt(1+4*tk^2))/2;
    
    R{1}=P{1}+(tk-1)/(tkp1)*(P{1}-Pold{1});
    R{2}=P{2}+(tk-1)/tkp1*(P{2}-Pold{2});
    
    re=norm(D-Dold,'fro')/norm(D,'fro');
    if (re<epsilon)
        count=count+1;
    else
        count=0;
    end
    
    C=Xobs-lambda*Lforward(P);
    PC=project(C);
    fval=-norm(C-PC,'fro')^2+norm(C,'fro')^2;
    fun_all=[fun_all;fval];
    if(prnt)
        fprintf('          %5d                   %10.10f              %10.10f',i,fval,norm(D-Dold,'fro')/norm(D,'fro'));
        if (fval>fold)
            fprintf('  *\n');
        else
            fprintf('   \n');
        end
    end
end
X_den=D;
iter=i;

