function [V, cpu_time] = mdp_finite_p(opt,NX, NY, MAXD, K, r, c, h, s, discount, N, R, hv)


cpu_time = cputime;

global mdp_VERBOSE;
if ~exist('mdp_VERBOSE'); mdp_VERBOSE=0; end;

% check of arguments
if N < 1
    disp('--------------------------------------------------------')
    disp('MDP Toolbox ERROR: N must be upper than 0')
    disp('--------------------------------------------------------')
elseif discount <= 0 | discount > 1
    disp('--------------------------------------------------------')
    disp('MDP Toolbox ERROR: Discount rate must be in ]0; 1]')
    disp('--------------------------------------------------------')
else

    




V = zeros(NX+1,N+1);
if nargin == 5; V(:,N+1) = hv; end;

  
    for n=0:N-1
        
		% update P    
		% %  P caculation
		PM = zeros(NX+1, NX+1); 
        for ox = NX:-1:0
            sum = 0 ;
            for nx = NX:-1:1
                if ox >= R
                    aftery = ox ;
                else
                    aftery = R ;
                end 
                
                if nx > aftery
                        PM(NX+1-ox, NX+1-nx) = 0;
                else
                    PM(NX+1-ox, NX+1-nx) = poisspdf(aftery-nx,f_demand(N-n)) ; 
                    sum = sum + PM(NX+1-ox, NX+1-nx) ;
                end
                
            end
            PM(NX+1-ox, NX+1) = 1-sum ;
        end 
        
        % update PR    
		% %  PR caculation
        PR = zeros(NX+1,1) ;

        for x = NX:-1:0
			reward = 0 ;
            if x >= R
                y = 0 ;
            else
                y = R-x ;
            end 
            
            sum = 0 ;
			for i = 0:MAXD
                u = i ;
                pu = poisspdf(i,f_demand(N-n)) ;
                sum = sum + pu ;
                
                A = y * c; 
                
                if y == 0
                    B = 0;
                else
                    B = K;
                end
                
                sellnum = min(u, x+y);
                C = sellnum * f_price(N-n) ;
                
                D = ((x+y) + max(0, x+y-u)) * 0.5 * h ; 
                
                E = max(0, u-x-y) * s ;
                
                reward = reward + (C-A-B-D-E) * pu ;
			end ;
            
            %if u > MAXD
            pu = 1 - sum ;
            A = y * c; 
            if y == 0
                B = 0;
            else
                B = K;
            end
            sellnum = x+y;
            C = sellnum * f_price(N-n) ;
            D = ((x+y) + 0) * 0.5 * h ; 
            
            E = max(0, MAXD-x-y) * s ;
            
            reward = reward + (C-A-B-D-E) * pu ;
                
            
            
			PR(NX-x+1) = reward ;
        end

        Q= PR + discount * PM * V(:,N-n+1);
        V(:,N-n)= Q; 

    end
    
end;

cpu_time = cputime - cpu_time;

