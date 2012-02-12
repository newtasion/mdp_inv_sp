clear;
% P(:,:,1) = load('p1.data');
% P(:,:,2) = load('p2.data');
% P(:,:,3) = load('p3.data');
% R = load('r.data');

NX = 5;
NY = 5 ;
MAXD = 5 ; 
K = 30 ; 
r = 120 ; 
c = 80 ; 
h = 1 ; 
s = 30 ;

opt = 2; 
[P,PR] = c525pr(opt, NX, NY, MAXD, K, r, c, h, s);

[V, policy, cpu_time] = mdp_finite_horizon(P, PR, 0.95, 5) ;