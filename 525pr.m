
% caculator PR
% NX: the upbound of x =5
% NY: the upbound of y =5
% MAXD: the upbound of demand, MAXD =5
% x: St
% y: how much order
% K: the fixed fee of placing order
% r: the selling price per unit
% c: ordering price
% h: holding cost per unit
% s: shortage cost per unit
% u: demand-propability matrix 



function [P,PR] = c525pr(NX, NY, MAXD, K, r, c, h, s)

LAMBDA = 2; 

%  P caculation
P = zeros(NX, NX, NY); 
for y = NY:0
    for ox = NX:0
        for nx = NX:0
            if nx > (ox + y)
                P(NX+1-ox, NX+1-nx, y) = 0;
            elseif nx == 0
                temp = 0 ;
                for i = (ox + y):NX
                    temp = temp + poisspdf(i) ;
                end ;
                P(NX+1-ox, NX+1-nx, y) = temp ;

            else
                P(NX+1-ox, NX+1-nx, y) = poisspdf(ox+y-nx) ;
            end
                
        end
    end
end

%  end P caculation

%  PR caculation
% A: ordering cost
% B: fixed ordering cost
% C: revenue
% D: holding cost
% E: shortage cost

PR = zeros(NY+1,NX+1) ;
for y = NY:0
    for x = NX:0
		reward = 0 ;
		if x+y > NX
            PR = -1000;
            return ;
		end
		
		for i = 0:MAXD
            u = i ;
            pu = poisspdf(i,2) ;
            
            A = y * C; 
            
            if y == 0
                B = 0;
            else
                B = K;
            end
            
            sellnum = min(u, x+y);
            C = sellnum * R ;
            
            D = ((x+y) + max(0, x+y-u))/2; 
            
            E = max(0, u-x-y) * s ;
            
            reward = reward + (C-A-B-D-E) * pu ;
		end ;
		
		PR[y,x] = reward ;
    end
end
%  end PR caculation 
end