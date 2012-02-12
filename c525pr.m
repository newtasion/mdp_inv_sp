
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



function [PM,PR] = c525pr(opt,NX, NY, MAXD, K, r, c, h, s, LAMBDA)


% %  P caculation
PM = zeros(NX+1, NX+1, NY+1); 
for y = 0:NY
    for ox = NX:-1:0
        
        sum = 0 ;
        for nx = NX:-1:1
            aftery = ox+y; 
            if nx > (ox + y)
                PM(NX+1-ox, NX+1-nx, y+1) = 0;
            else
                st = ox+y ;
                if(ox+y >= NX)
                    st = NX ;
                end ;
                PM(NX+1-ox, NX+1-nx, y+1) = poisspdf(st-nx,LAMBDA) ; 
                sum = sum + PM(NX+1-ox, NX+1-nx, y+1) ;
            end
                
        end
        
        PM(NX+1-ox, NX+1, y+1) = 1-sum ;
       
    end
end

%  end P caculation



%  PR caculation
% A: ordering cost
% B: fixed ordering cost
% C: revenue
% D: holding cost
% E: shortage cost

%cost analysis
if (opt == 1)
	PR = zeros(NX+1, NY+1) ;
	for y = 0:NY
        for x = NX:-1:0
			reward = 0 ;
			if x+y > NX
                reward = -1000;
            else
			
				for i = 0:MAXD
                    u = i ;
                    pu = poisspdf(i,LAMBDA) ;
                    
                    A = y * c; 
                    
                    if y == 0
                        B = 0;
                    else
                        B = K;
                    end
                    
                    sellnum = min(u, x+y);
                    C = sellnum * r ;
                    
                    D = ((x+y) + max(0, x+y-u)) * 0.5 * h ; 
                    
                    E = max(0, u-x-y) * s ;
                    
                    reward = reward + (C-A-B-D-E) * pu ;
				end ;
            
            end; 
            
			PR(NX-x+1, y+1) = reward ;
	% 		PR[y+1,x+1] = reward ;
        end
	end
	%  end PR caculation 

% service level analysis
else
    PR = zeros(NX+1, NY+1) ;
    for y = 0:NY
        PR(NX+1, y+1) = 1; 
    end; 
end;

end