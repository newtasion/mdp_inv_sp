function [V, policy] = mdp_bellman_operatorABCDE(P, PR, discount, Vprev)


% mdp_bellman_operator Applies the Bellman operator on the value function Vprev
%                      Returns a new value function and a Vprev-improving policy
% Arguments ---------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA) = transition matrix; it can either be a cell array containing sparse
%              matrices or a regular 3-dimensional matrix.
%   PR(SxA) = reward matrix
%   discount = discount rate, in ]0, 1]
%   Vprev(S) = value function
% Evaluation --------------------------------------------------------------
%   V(S)   = new value function
%   policy(S) = Vprev-improving policy
%--------------------------------------------------------------------------
% In verbose mode, no additionnal display
%--------------------------------------------------------------------------
% MDP Toolbox, INRA, BIA Toulouse, France
%--------------------------------------------------------------------------

if discount <= 0 | discount > 1
     disp('--------------------------------------------------------')
     disp('MDP Toolbox ERROR: Discount rate must be in ]0; 1]')
     disp('--------------------------------------------------------')
elseif ((iscell(P)) & (size(Vprev) ~= size(P{1},1)))
    disp('--------------------------------------------------------')
    disp('MDP Toolbox ERROR: Vprev must have the same dimension as P')
    disp('--------------------------------------------------------')
elseif ((~iscell(P)) & (size(Vprev) ~= size(P,1)))
    disp('--------------------------------------------------------')
    disp('MDP Toolbox ERROR: Vprev must have the same dimension as P')
    disp('--------------------------------------------------------') 
else
        
    if iscell(P)
        A = size(P,1);
        for a=1:A           
            Q(:,a)= PR(:,a) + discount*P{a}*Vprev;
        end
    else
        A = size(P,3);
        for a=1:A
            Q(:,a)= PR(:,a) + discount*P(:,:,a)*Vprev;
        end
    end
    [V, policy]=max(Q,[],2);
 
end; 

