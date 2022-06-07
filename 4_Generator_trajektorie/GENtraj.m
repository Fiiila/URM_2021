function MCSstar = GENtraj(s,v,a)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%parametry generatoru
A = [2;0.5];
B = [0;1];
C = [2;2.5];
r = 0.3;

%smerove vektory primek
nBA = (A-B)/norm(A-B);
nBC = (C-B)/norm(C-B);
%stred bodu kruznice
nBS = (nBA+nBC)/norm(nBA+nBC);
K1 = nBA*nBA'*nBS-nBS;
l = r/(sqrt(K1'*K1));
S = B+nBS*l;
%body dotyku
%k...polomer kruznice
PA = A - nBA*nBA'*(A-S);
PC = B + norm(PA-B)*nBC;
%dulezita podminka nBA'*(PA-S)==0
%pohyb po primce AB
%pAB = A - k1 * nBA
%pohyb po kruznici
temp = PA-S;
PhiPA = atan2(temp(2),temp(1));
dir = -1;%+/-1 podle smeru rotace
%pK = (r*cos(PhiPA+dir*phi))
deltaPhi = acos(((PC - S)'*(PA - S))/(r^2));

%vypocteni nastaveni drah
s1 = norm(PA-A);%celkova draha po primce AB
s2 = r*deltaPhi;%celkova draha po kruznici
s3 = norm(PC-C);%celkova draha po primce BC
smax = s1+s2+s3;%celkova vykonana draha koncoveho bodu
X = zeros(2,1);
dX = zeros(2,1);
ddX = zeros(2,1);
%vysledne prirazeni parametru
if((0 <= s) && (s < s1))
    k1 = s;
    dk1 = v;
    ddk1 = a;
    %vykreslovani primky
    X = A -k1*nBA;
    dX = -dk1*nBA;
    ddX = -ddk1*nBA;
    
elseif((s1 <= s) && (s < (s1+s2)))
    phi = (s - s1)/r;
    dphi = v/r;
    ddphi = a/r;
    %vykreslovani kruznice
    X = r*[cos(PhiPA + dir*phi);
        sin(PhiPA + dir*phi)] + S;
    dX = r*[-sin(PhiPA + dir*phi);
        cos(PhiPA + dir*phi)]*dir*dphi;
    ddX = r*[-cos(PhiPA + dir*phi);
        -sin(PhiPA + dir*phi)]*dphi*dphi + r*[-sin(PhiPA + dir*phi);
        cos(PhiPA + dir*phi)]*dir*ddphi;
        
elseif(((s1+s2) <= s) && (s < smax))
    k2 = s - s1 - s2;
    dk2 = v;
    ddk2 = a;
    %vykreslovani primky
    X = PC + k2*nBC;
    dX = dk2*nBC;
    ddX = ddk2*nBC;
else
    X = C;
    dX = [0;0];
    ddX = [0;0];
end
%uhelEfektoru = pocUhel + (s/smax)*(koncUhel-pocUhel);
%dUhelEfektoru = (koncUhel - pocUhel)/smax
%ddUhelEfektoru = -(koncUhel - pocUhel)/smax^2

%kvadraticky pokus
%uhly koncoveho efektoru
% phiStart = pi/2;
% phiC = -pi/5;
% phiEnd = 0;
% Smax = smax;
% Sc = smax/2;
% uhelEfektoru =  - (Sc*phiEnd - Sc*phiStart - Smax*phiC + Smax*phiStart)/(Sc*Smax*(Sc - Smax))*s^2 + (Sc^2*phiEnd - Sc^2*phiStart - Smax^2*phiC + Smax^2*phiStart)/(Sc*Smax*(Sc - Smax))*s + phiStart;%phiStart + (s^2*(phiC - phiStart + (Sc*((phiC - phiStart)/Sc - (Sc*(phiEnd - phiStart))/Smax^2))/(Sc + 1)))/Sc^2 - (s*((phiC - phiStart)/Sc - (Sc*(phiEnd - phiStart))/Smax^2))/(Sc + 1);
% dUhelEfektoru = - (Sc*phiEnd - Sc*phiStart - Smax*phiC + Smax*phiStart)/(Sc*Smax*(Sc - Smax))*2*s + s^2 + (Sc^2*phiEnd - Sc^2*phiStart - Smax^2*phiC + Smax^2*phiStart)/(Sc*Smax*(Sc - Smax)) + s +1;%(2*s*(phiC - phiStart + (Sc*((phiC - phiStart)/Sc - (Sc*(phiEnd - phiStart))/Smax^2))/(Sc - 1)))/Sc^2 + s^2 - (((phiC - phiStart)/Sc - (Sc*(phiEnd - phiStart))/Smax^2))/(Sc - 1) + s;
% ddUhelEfektoru = - (Sc*phiEnd - Sc*phiStart - Smax*phiC + Smax*phiStart)/(Sc*Smax*(Sc - Smax))*2 + s + 2*s +1+1 ;

%udrzovani konc. efektoru stale ve stejne poloze
uhelEfektoru =  0;
dUhelEfektoru = 0;
ddUhelEfektoru = 0;
MCSstar = [[X;uhelEfektoru],[dX;dUhelEfektoru],[ddX;ddUhelEfektoru]];

end

