% pocatecni inicializace
close all
clear all
clc

%% sestaveni primeho geometrickeho modelu
% 3DoF planarni manipulator s delkami ramen a1=2,a2=1.5,a3=0.5

%% DGM
%data pro DGM
di = [0,0,0]; %posuny v ose Z
Thetai = [0.5,0.5,0.5]; %rotace kolem osy Z
ai = [2,1.5,0.5]; %posun v ose X (delky ramen manipulatoru)
alphai = [0,0,0]; %rotace kolem X

%Zjisteni homogennich transformacnich matic pro vyse zadana data
disp('Homogenni transformacni matice')
Tn = DGM_here(di,Thetai,ai,alphai)

%zjisteni polohy koncoveho efektoru
disp('Poloha koncoveho efektoru')
X = [Tn(1,4);
     Tn(2,4);
     atan2(Tn(2,1),Tn(1,1))]
 

%% IGM
Th = IGM_here(ai,X)

%% nastaveni parametru pro simulator
Thetai = [0,0,0];%domovska poloha manipulatoru
%jednotlive homogenni transformacni matice
T_1_0 = transf(di(1),Thetai(1),ai(1),alphai(1));
T_2_1 = transf(di(2),Thetai(2),ai(2),alphai(2));
T_3_2 = transf(di(3),Thetai(3),ai(3),alphai(3));

x = 3;
y = 0.5;
q = 0.5;

%validace spravnosti modelu
simout_porovnani = sim('Geometricky_simulacni_model');
disp('POROVNANI POLOHY KONCOVEHO EFEKTORU')
disp('Pozadovana poloha efektoru')
[x,y,q]
disp('Vystup modelu')
simout_porovnani.simout.Data(1,1:3)
disp('Vystup DGM')
simout_porovnani.simout.Data(1,4:6)

%% vytvoreni grafu pro ruzna phi

phi = [0:1:360]
y1
figure
plot()

%% funkce pro vypocet zde v mfilu

%funkce pro vypocet IGM
function Theta = IGM_here(a,X)
    cosinus = ((X(1)-a(3)*cos(X(3)))^2+(X(2)-a(3)*sin(X(3)))^2-a(1)^2-a(2)^2)/(2*a(1)*a(2));
    Theta2 = atan2(sqrt(1-cosinus^2),cosinus);
    A = [-a(2)*sin(Theta2),(a(2)*cos(Theta2)+a(1));
         (a(2)*cos(Theta2)+a(1)),a(2)*sin(Theta2)];
    B = [X(1)-a(3)*cos(X(3));
         X(2)-a(3)*sin(X(3))];
    newX = A\B;%inv(A)*B
    Theta1 = atan2(newX(1),newX(2));
    Theta3 = X(3) - Theta1 - Theta2;
    Theta = [Theta1;Theta2;Theta3];
end

%funkce pro ziskani DGM
function Tn = DGM_here(di,Thetai,ai,alphai)
    Tn = eye(4);
    for i=1:length(di)
        tempMat = transf(di(i),Thetai(i),ai(i),alphai(i));
        Tn = Tn*tempMat;
    end
end

%funkce pro vypocet transformacni matice z jednoho s.s. do druheho
function Tn = transf(d,Theta, a, alpha)
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