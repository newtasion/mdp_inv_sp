function [V, policy, cpu_time, VA, VB, VC, VD, VE, VSL] = mdp_finite_seghorizon_SLABCDE(opt,NX, NY, MAXD, K, r, c, h, s, discount, N, hv)


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
VA = zeros(NX+1,N+1);
VB = zeros(NX+1,N+1);
VC = zeros(NX+1,N+1);
VD = zeros(NX+1,N+1);
VE = zeros(NX+1,N+1);
VSL = zeros(NX+1,N+1);



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
        PA = zeros(NX+1, NY+1) ;
        PB = zeros(NX+1, NY+1) ;
        PC = zeros(NX+1, NY+1) ;
        PD = zeros(NX+1, NY+1) ;
        PE = zeros(NX+1, NY+1) ;
        PSL = zeros(NX+1, NY+1) ;

        
		for y = 0:NY
            for x = NX:-1:0
				reward = 0 ;
                ra = 0 ;
                rb = 0 ;
                rc = 0 ;
                rd = 0 ;
                re = 0 ;
                rsl = 0 ;
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
                        ra = ra + A * pu; 
                        rb = rb + B * pu;
                        rc = rc + C * pu; 
                        rd = rd + D * pu;
                        re = re + E * pu; 
                        
                         
                        if u == 0
                            rsl = rsl + 1 * pu ;
                        else
                            rsl = rsl + (1 - max(0, u-x-y)/u) * pu ;
                        end ;
                        
                        
                        
					end ;

                end; 
                
				PR(NX-x+1, y+1) = reward ;
                PA(NX-x+1, y+1) = ra ;
                PB(NX-x+1, y+1) = rb ;
                PC(NX-x+1, y+1) = rc ;
                PD(NX-x+1, y+1) = rd ;
                PE(NX-x+1, y+1) = re ;
                
                PSL(NX-x+1, y+1) = rsl ;

            end
		end

    
        PR = mdp_computePR(PM,PR);
    
        [W,X]=mdp_bellman_operatorABCDE(PM,PR,discount,V(:,N-n+1));
        V(:,N-n)=W; 
        policy(:,N-n) = X;
        
        for i = 0:NX
            po = X(i+1) ;
            VA(i+1, N-n)= PA(i+1,po) + discount*PM(i+1,:,po)*VA(:,N-n+1);
            VB(i+1, N-n)= PB(i+1,po) + discount*PM(i+1,:,po)*VB(:,N-n+1);
            VC(i+1, N-n)= PC(i+1,po) + discount*PM(i+1,:,po)*VC(:,N-n+1);
            VD(i+1, N-n)= PD(i+1,po) + discount*PM(i+1,:,po)*VD(:,N-n+1);
            VE(i+1, N-n)= PE(i+1,po) + discount*PM(i+1,:,po)*VE(:,N-n+1);
            VSL(i+1, N-n)= PSL(i+1,po) + discount*PM(i+1,:,po)*VSL(:,N-n+1);
        end 
        if mdp_VERBOSE
            disp(['stage:' num2str(N-n) '      policy transpose : ' num2str(policy(:,N-n)')]); 
        end;
    end
    
end;

cpu_time = cputime - cpu_time;

