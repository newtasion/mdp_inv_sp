clear;
% P(:,:,1) = load('p1.data');
% P(:,:,2) = load('p2.data');
% P(:,:,3) = load('p3.data');
% R = load('r.data');

NX = 8;
NY = 8 ;
MAXD = 20 ; 
K = 30 ; 
r = 125 ; 
c = 80 ; 
h = 1 ; 
s = 10 ;

LAMBDA = 4; 

[V, cpu_time] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 6) ;
% 
% [PM,PR] = c525pr(1,NX, NY, MAXD, K, r, c, h, s, LAMBDA);
% 
% [V, policy, cpu_time] = mdp_finite_horizon(PM, PR, 0.95, 7) ;