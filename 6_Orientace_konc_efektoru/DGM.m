function X = DGM(par,Q)
%DGM primy geometricky model
%   vypocitava z kloubovych souradnic manipulatoru vyslednou polohu
%   koncoveho efektoru
%   par - parametry manipulatoru (pole delek ramen od zakladny k efektoru)
%   Q - jednotlive kloubove souradnice manipulatoru od baze k efektoru

%degrees - pokus o zpracovani ve stupnich
% di = zeros(1,length(par));
% Thetai = Q;
% ai = par;
% alphai = zeros(1,length(par));
% Tn = eye(4);
%     for i=1:length(di)
%         tempMat = transf(di(i),Thetai(i),ai(i),alphai(i));
%         Tn = Tn*tempMat;
%     end
% X = [Tn(1,4);
%      Tn(2,4);
%      atan2d(Tn(2,1),Tn(1,1))];

%rad - zpracovani v radianech
di = zeros(1,length(par));
Thetai = Q;
ai = par;
alphai = zeros(1,length(par));
Tn = eye(4);
    for i=1:length(di)
        tempMat = transf(di(i),Thetai(i),ai(i),alphai(i));
        Tn = Tn*tempMat;
    end
%navrat vysledne polohy koncoveho efektoru
X = [Tn(1,4);
     Tn(2,4);
     atan2(Tn(2,1),Tn(1,1))];
end

%pomocna funkce pro vypocet transformacni matice z jednoho s.s. do druheho
function Tn = transf(d,Theta, a, alpha)
%stupne - pokus o vypocet ve stupnich
%     %translace v ose Z
%     TtransZ = eye(4);
%     TtransZ(3,4) = d;
%     %rotace kolem osy Z
%     TrotZ = zeros(4,4);
%     TrotZ(1:3,1:3) = [cosd(Theta),-sind(Theta),0;
%                       sind(Theta),cosd(Theta) ,0;
%                      0          ,0           ,1];
%     TrotZ(4,4) = 1;
%     
%     %translace v ose X
%     TtransX = eye(4);
%     TtransX(1,4) = a;
%     %rotace kolem osy X
%     TrotX = zeros(4,4);
%     TrotX(1:3,1:3) = [1,          0,           0;
%                     0,cosd(alpha),-sind(alpha);
%                     0,sind(alpha),cosd(alpha)];
%     TrotX(4,4) = 1;
%     %vypocet homogenni transformacni matice z n-1 do nteho s.s.
%     Tn = TtransZ*TrotZ*TtransX*TrotX

%rad
    %translace v ose Z
    TtransZ = eye(4);
    TtransZ(3,4) = d;
    %rotace kolem osy Z
    TrotZ = zeros(4,4);
    TrotZ(1:3,1:3) = [cos(Theta),-sin(Theta),0;
                      sin(Theta),cos(Theta) ,0;
                     0          ,0           ,1];
    TrotZ(4,4) = 1;
    
    %translace v ose X
    TtransX = eye(4);
    TtransX(1,4) = a;
    %rotace kolem osy X
    TrotX = zeros(4,4);
    TrotX(1:3,1:3) = [1,          0,           0;
                    0,cos(alpha),-sin(alpha);
                    0,sin(alpha),cos(alpha)];
    TrotX(4,4) = 1;
    %vypocet homogenni transformacni matice z n-1 do nteho s.s.
    Tn = TtransZ*TrotZ*TtransX*TrotX;
end

