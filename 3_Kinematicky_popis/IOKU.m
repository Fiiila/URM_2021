function ACS = IOKU(par,MCS)
%IOKU Inverzni Okamzita Kinematicka Uloha
%   funkce, ktera pro zadanou polohu koncoveho efektoru a jeho rychlost a
%   zrychleni vypocte hodnoty kloubovych souradnic vcetne rychlosti a
%   zrychleni

%extrakce parametru z MCS
X=MCS(:,1);
dX=MCS(:,2);
ddX=MCS(:,3);

%IOKU pro polohu
Q1 = IGM(a,X);
J = Jacobian(Q1,par);
Q2 = J\dX;
dJ = dJacobian(Q,Q2,par);
Q3 = dJ\dX + J\ddX;

ACS = [Q1,Q2,Q3];
end

