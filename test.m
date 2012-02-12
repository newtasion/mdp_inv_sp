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


[V, policy, cpu_time, VA, VB, VC, VD, VE, VSL] = mdp_finite_seghorizon_SLABCDEb(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9) ;
Reward = V ;
RV = VC ;
LO = VA ;
FO = VB ;
H = VD;
S = VE ;
SL = VSL; 

Y = LO/c ;
TY = VA/c ;
Sellingnum = RV/r ;
TS =  VC/r ;
avgSL = SL/9 ;


disp('Reward') ;
disp(Reward) ;
disp('RV') ;
disp(RV) ;
disp('LO') ;
disp(LO) ;
disp('FO') ;
disp(FO) ;
disp('H') ;
disp(H) ;
disp('S') ;
disp(S) ;
disp('Y') ;
disp(Y) ;
disp('Sellingnum') ;
disp(Sellingnum) ;
disp('avgSL') ;
disp(avgSL) ;

%[V1, policy, cpu_time1] = mdp_finite_seghorizon(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9) ;
% VV1 = V1(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV1, '-s') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 2) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '-*') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 4) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '-o') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 5) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '->') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 6) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '-v') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 8) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '-<') ;
% hold on;
% 
% [V2, cpu_time2] = mdp_finite_p(1,NX, NY, MAXD, K, r, c, h, s, 0.95, 9, 9) ;
% VV2 = V2(:,1) ;
% x = NX:-1:0 ;
% plot(x, VV2, '-^') ;



% 
% [PM,PR] = c525pr(1,NX, NY, MAXD, K, r, c, h, s, LAMBDA);
% 
% [V, policy, cpu_time] = mdp_finite_horizon(PM, PR, 0.95, 7) ;