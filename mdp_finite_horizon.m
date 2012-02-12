function [V, policy, cpu_time] = mdp_finite_horizon(P, R, discount, N, h)


% mdp_finite_horizon   Reolution of finite-horizon MDP with backward induction 
% Arguments -------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA) = transition matrix 
%   R(SxSxA) or R(SxA) = reward matrix
%   discount = discount factor, in ]0, 1]
%   N        = number of periods, upper than 0
%   h(S)     = terminal reward, optional (default [0; 0; ... 0] )
% Evaluation -------------------------------------------------------------
%   V(S,N+1)     = optimal value function
%                  V(:,n) = optimal value function at stage n
%                         with stage in 1, ..., N
%                         V(:,N+1) = value function for terminal stage 
%   policy(S,N)  = optimal policy
%                  policy(:,n) = optimal policy at stage n
%                         with stage in 1, ...,N
%                         policy(:,N) = policy for stage N
%   cpu_time = used CPU time
%--------------------------------------------------------------------------
% In verbose mode, displays the current stage and policy transpose.
%-------------------------------------------------------------------------
% MDP Toolbox, INRA, BIA Toulouse, France
%-------------------------------------------------------------------------

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
    
    if iscell(P)
        S = size(P{1},1);     
    else
        S=size(P,1);    
    end 
    
    V = zeros(S,N+1);
    if nargin == 5; V(:,N+1) = h; end;
    
    PR = mdp_computePR(P,R);
    
    for n=0:N-1
        [W,X]=mdp_bellman_operator(P,PR,discount,V(:,N-n+1));
        V(:,N-n)=W; 
        policy(:,N-n) = X;
        if mdp_VERBOSE
            disp(['stage:' num2str(N-n) '      policy transpose : ' num2str(policy(:,N-n)')]); 
        end;
    end
    
end;

cpu_time = cputime - cpu_time;

