function [V, policy, cpu_time] = mdp_finite_seghorizon_SL(opt,NX, NY, MAXD, K, r, c, h, s, discount, N, hv)


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
                        PM(NX+1-ox, NX+1-nx, y+1) = poisspdf(st-nx,f_demand(N-n)) ; 
                        sum = sum + PM(NX+1-ox, NX+1-nx, y+1) ;
                    end
                        
                end
                
                PM(NX+1-ox, NX+1, y+1) = 1-sum ;
               
            end
		end
        
        
        % update PR    
		% %  PR caculation
        PR = zeros(NX+1, NY+1) ;
		for y = 0:NY
            for x = NX:-1:0
				reward = 0 ;
				if x+y > NX
                    reward = -8000;
                else
				
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

                end; 
                
				PR(NX-x+1, y+1) = reward ;
            end
		end

    
        PR = mdp_computePR(PM,PR);
    
        [W,X]=mdp_bellman_operator(PM,PR,discount,V(:,N-n+1));
        V(:,N-n)=W; 
        policy(:,N-n) = X;
        if mdp_VERBOSE
            disp(['stage:' num2str(N-n) '      policy transpose : ' num2str(policy(:,N-n)')]); 
        end;
    end
    
end;

cpu_time = cputime - cpu_time;

