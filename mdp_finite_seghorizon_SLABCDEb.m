function [V, policy, cpu_time, VA, VB, VC, VD, VE, VSL] = mdp_finite_seghorizon_SLABCDEb(opt,NX, NY, MAXD, K, r, c, h, s, discount, N, hv)


cpu_time = cputime;

global mdp_VERBOSE;
if ~exist('mdp_VERBOSE'); mdp_VERBOSE=0; end;

% check of arguments
if N < 1
    disp('--------------------------------------------------------')
    disp('ERROR: N must be upper than 0')
    disp('--------------------------------------------------------')
elseif discount <= 0 | discount > 1
    disp('--------------------------------------------------------')
    disp('ERROR: Discount rate must be in ]0; 1]')
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
        
        PR = zeros(NX+1, NX+1, NY+1); 
        PA = zeros(NX+1, NX+1, NY+1); 
        PB = zeros(NX+1, NX+1, NY+1); 
        PC = zeros(NX+1, NX+1, NY+1); 
        PD = zeros(NX+1, NX+1, NY+1); 
        PE = zeros(NX+1, NX+1, NY+1); 
        PSL = zeros(NX+1, NX+1, NY+1); 
        
		for y = 0:NY
            for ox = NX:-1:0
                
                sum = 0 ;
                reward = 0 ;
                for nx = NX:-1:1
                    aftery = ox+y; 
                    
                    % cannot happen
                    if nx > (ox + y)
                        PM(NX+1-ox, NX+1-nx, y+1) = 0;
                        PR(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        
                        PA(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        PB(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        PC(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        PD(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        PE(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        PSL(NX+1-ox, NX+1-nx, y+1) = 0 ;
                        
                    else
                        st = ox+y ;
                        if(ox+y >= NX)
                            st = NX ;
                        end ;
                        PM(NX+1-ox, NX+1-nx, y+1) = poisspdf(st-nx,f_demand(N-n)) ; 
                        sum = sum + PM(NX+1-ox, NX+1-nx, y+1) ;
                        
                        u = st-nx ;
                        A = y * c; 
                        
                        if y == 0
                            B = 0;
                        else
                            B = K;
                        end
                        
                        C = u * f_price(N-n) ;
                        
                        D = ((ox+y) + nx) * 0.5 * h ; 
                        
                        E = 0 ;
                        
                        PR(NX+1-ox, NX+1-nx, y+1) = (C-A-B-D-E) * PM(NX+1-ox, NX+1-nx, y+1) ;
                        
                        PA(NX+1-ox, NX+1-nx, y+1) = A * PM(NX+1-ox, NX+1-nx, y+1) ;
                        PB(NX+1-ox, NX+1-nx, y+1) = B * PM(NX+1-ox, NX+1-nx, y+1) ;
                        PC(NX+1-ox, NX+1-nx, y+1) = C * PM(NX+1-ox, NX+1-nx, y+1) ;
                        PD(NX+1-ox, NX+1-nx, y+1) = D * PM(NX+1-ox, NX+1-nx, y+1) ;
                        PE(NX+1-ox, NX+1-nx, y+1) = E * PM(NX+1-ox, NX+1-nx, y+1) ;
                        PSL(NX+1-ox, NX+1-nx, y+1) = 1 * PM(NX+1-ox, NX+1-nx, y+1) ;
                    end
                        
                end
                
                %shortage 
                PM(NX+1-ox, NX+1, y+1) = 1-sum ;
                
                A = y * c; 
                
                if y == 0
                    B = 0;
                else
                    B = K;
                end
            
                C = (ox + y) * f_price(N-n) ;
            
                D = ((ox+y) + 0) * 0.5 * h ; 
%               E = 0 ;
% 				PR(NX+1-ox, NX+1, y+1) = (C-A-B-D-E) * PM(NX+1-ox, NX+1, y+1) ;
% 				PA(NX+1-ox, NX+1, y+1) = A * PM(NX+1-ox, NX+1, y+1) ;
% 				PB(NX+1-ox, NX+1, y+1) = B * PM(NX+1-ox, NX+1, y+1) ;
% 				PC(NX+1-ox, NX+1, y+1) = C * PM(NX+1-ox, NX+1, y+1) ;
% 				PD(NX+1-ox, NX+1, y+1) = D * PM(NX+1-ox, NX+1, y+1) ;
% 				PE(NX+1-ox, NX+1, y+1) = E * PM(NX+1-ox, NX+1, y+1) ;


                for  i = ox + y : MAXD
                    E = (i-ox-y) * s ;
                    pu = poisspdf(i,f_demand(N-n)) ;
                    PR(NX+1-ox, NX+1, y+1) = PR(NX+1-ox, NX+1, y+1) + (C-A-B-D-E) * pu ;
                    PA(NX+1-ox, NX+1, y+1) = PA(NX+1-ox, NX+1, y+1) + A * pu ;
                    PB(NX+1-ox, NX+1, y+1) = PB(NX+1-ox, NX+1, y+1) + B * pu ;
                    PC(NX+1-ox, NX+1, y+1) = PC(NX+1-ox, NX+1, y+1) + C * pu ;
                    PD(NX+1-ox, NX+1, y+1) = PD(NX+1-ox, NX+1, y+1) + D * pu ;
                    PE(NX+1-ox, NX+1, y+1) = PE(NX+1-ox, NX+1, y+1) + E * pu ;
                    if i == 0 
                        PSL(NX+1-ox, NX+1, y+1) = PSL(NX+1-ox, NX+1, y+1) + 1 * pu ;
                    else 
                        PSL(NX+1-ox, NX+1, y+1) = PSL(NX+1-ox, NX+1, y+1) + ((ox + y)/i) * pu ;
                    end 
                end ;
                    
            end
		end

    
        [PR,PA,PB,PC,PD,PE,PSL] = mdp_computePRb(PM,PR,PA,PB,PC,PD,PE,PSL);
    
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

