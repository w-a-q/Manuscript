function u = primal_dual_TGVL2 (f, lambda, maxiter)

  % Algorithm parameters
  L = sqrt(12);
  theta = 1;
  tau = 1/L*0.1;
  sigma = 1/L/0.1;
  
  % initialization
  [M,N] = size(f);
  u = f;
  u_ = u;
  v = zeros(M,N,2);
  v_ = v;
  p = zeros(M,N,2);
  q = zeros(M,N,4);

  iter = 0;
  while(true) 
    iter = iter + 1;

    % update dual
    u_x = dxp(u_);
    u_y = dyp(u_);
    v1_x = dxp(v_(:,:,1));
    v1_y = dyp(v_(:,:,1));
    v2_x = dxp(v_(:,:,2));
    v2_y = dyp(v_(:,:,2));
    p(:,:,1) = p(:,:,1) + sigma.*(u_x-v_(:,:,1));
    p(:,:,2) = p(:,:,2) + sigma.*(u_y-v_(:,:,2));
    q(:,:,1) = q(:,:,1) + sigma.*(v1_x);
    q(:,:,2) = q(:,:,2) + sigma.*(v1_y);
    q(:,:,3) = q(:,:,3) + sigma.*(v2_x);
    q(:,:,4) = q(:,:,4) + sigma.*(v2_y);
    reproj = max(1.0, sqrt(p(:,:,1).^2+p(:,:,2).^2));
    p(:,:,1) = p(:,:,1)./reproj;
    p(:,:,2) = p(:,:,2)./reproj;   
    reproj = max(1.0, sqrt(q(:,:,1).^2+q(:,:,2).^2+q(:,:,3).^2+q(:,:,4).^2));
    q(:,:,1) = q(:,:,1)./reproj;
    q(:,:,2) = q(:,:,2)./reproj;
    q(:,:,3) = q(:,:,3)./reproj;
    q(:,:,4) = q(:,:,4)./reproj;
           
    % remember u
    u_ = u;
    v_ = v;
    
    % update primal
    div = cat(3, dxm(q(:,:,1)) + dym(q(:,:,2)), dxm(q(:,:,3)) + dym(q(:,:,4)) );     
    v = v + tau*(div+p);
    div = dxm(p(:,:,1)) + dym(p(:,:,2));     
    u = (u + tau*(div+lambda*f))./(1+tau*lambda);     
          
    % extra-gradient step 
    u_ = u + theta*(u-u_);
    v_ = v + theta*(v-v_);
    
    % show
    if (mod(iter,10)==0)
        fprintf('iter: %g\n', iter);
    end
    
    % breaking condition for outer itations
    if (iter > maxiter); break; end
  end

end

