function MCS = POKU(par,ACS)
%POKU Prima Okamzita Kinematicka Uloha
%   Uloha, ktera na zaklade poskytnutych kloubovych souradnic vypocte
%   vysledny pohyb efektoru

Q=ACS(:,1);
dQ=ACS(:,2);
ddQ=ACS(:,3);
%extrakce parametru koncoveho efektoru [x,y,q] (POKU pro polohu)
X = DGM(a,Q);
J = Jacobian(Q,par);
dX = J*dQ;
dJ = dJacobian(Q,dQ,par);
ddX = dJ*dQ + J*ddQ;

MCS = [X,dX,ddX];
end

