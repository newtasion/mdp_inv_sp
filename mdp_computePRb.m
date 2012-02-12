function [PR,PA,PB,PC,PD,PE,PSL] = mdp_computePRb(P,R,A,B,C,D,E,SL)


% mdp_computePR  Computes the reward for the system in one state 
%                chosing an action
% Arguments --------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA)  = transition matrix 
%   R(SxSxA) or R(SxA) = reward matrix
% Evaluation -------------------------------------------------------------
%   PR(SxA)   = reward matrix
%-------------------------------------------------------------------------
% In verbose mode, no additional display
%-------------------------------------------------------------------------
% MDP Toolbox, INRA, BIA Toulouse, France
%--------------------------------------------------------------------------

if iscell(P)
    % R has the form R(SxSxA)
    T = size(P,1);
    for a=1:T
        PR(:,a) = sum(P{a}.*R{a},2);
    end;
    PR=full(PR);
else
    r = size(size(R));
    if r(1,2) == 3 % test if R has 3 dimension defined (beware S=1 allowed)
        % R has the form R(SxSxA)
        T = size(P,3);
        for a=1:T
            PR(:,a) = sum(R(:,:,a),2);
            PA(:,a) = sum(A(:,:,a),2);
            PB(:,a) = sum(B(:,:,a),2);
            PC(:,a) = sum(C(:,:,a),2);
            PD(:,a) = sum(D(:,:,a),2);
            PE(:,a) = sum(E(:,:,a),2);
            PSL(:,a) = sum(SL(:,:,a),2);
        end
    else
        % R has the form R(SxA)
        PR = full(R);
        PA = full(A);
        PB = full(B);
        PC = full(C);
        PD = full(D);
        PE = full(E);
        PSL = full(SL) ;
    end;
end
