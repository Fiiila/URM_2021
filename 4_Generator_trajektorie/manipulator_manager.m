close all
clear all
clc

%% obsluzny mfile pro ctvrte zadani semestralni prace

%nastaveni promennych pro nasledujici vypocet homogennich transformacnich
%matic v domovske poloze manipulatoru
di = [0,0,0]; %posuny v ose Z
Thetai = [0,0,0]; %rotace kolem osy Z
ai = [2,1.5,0.5]; %posun v ose X (delky ramen manipulatoru)
alphai = [0,0,0]; %rotace kolem X

T_1_0 = transf(di(1),Thetai(1),ai(1),alphai(1));
T_2_1 = transf(di(2),Thetai(2),ai(2),alphai(2));
T_3_2 = transf(di(3),Thetai(3),ai(3),alphai(3));

T_2_3 = T_3_2;
T_1_2 = T_2_1;
T_0_1 = T_1_0;
xi=ai;


%nastaveni promennych pro simulator
t = 5; % doba simulace
vmax = 1;%maximalni rychlost konc. ef.
a=0;%zrychleni konc. ef.

%ziskani dat ze simulatoru
out = sim('manipulator');
endPosition = find(out.simout.Data(:,31:33)==0,1)-1;%nulova rychlost-->index konce pohybu
startPosition = 2;

%% 1) Overeni POKU a IOKU
model = out.simout.Data(:,1:9);
vystupPOKU = out.simout.Data(:,end-8:end);%(:,10:18);
f = figure();
f.Position(3:4) = [800,600];
% title('Rozdil modelu a vystupu z POKU (model-POKU)')
rozdil = model(:,:)-vystupPOKU(:,:);
subplot(3,1,1)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),(model(startPosition:endPosition,1:3)-vystupPOKU(startPosition:endPosition,1:3)))
legend('x','y','\phi','Location','northeast')
title('Rozdily polohy konc. ef.')
xlabel('t [s]')
ylabel('\Delta X [m]')

subplot(3,1,2)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),(model(startPosition:endPosition,4:6)-vystupPOKU(startPosition:endPosition,4:6)))
legend('\Delta dx','\Delta dy','\Delta d\phi','Location','northeast')
title('Rozdily rychlosti konc. ef.')
xlabel('t [s]')
ylabel('\Delta dX [m/s]')

subplot(3,1,3)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),(model(startPosition:endPosition,7:9)-vystupPOKU(startPosition:endPosition,7:9)))
legend('\Delta ddx','\Delta ddy','\Delta dd\phi','Location','northeast')
title('Rozdily zrychleni konc. ef.')
xlabel('t [s]')
ylabel('\Delta ddX [m/s^2]')
%ulozeni figure
saveas(gcf,'4_Graphics/Srovnani_POKU_model','epsc')%vektor pro pdf
saveas(gcf,'4_Graphics/Srovnani_POKU_model','png')%pro zobrazeni

%% 2)MCS* casove prubehy zobecnenych souradnic generovane generatorem trajekorie s phi=0
figure()
hold on
X = out.simout.Data(:,end-8:end-6);
dX = out.simout.Data(:,end-5:end-3);
ddX = out.simout.Data(:,end-2:end);
subplot(3,1,1)
grid on
plot(out.simout.Time(startPosition:endPosition),X(startPosition:endPosition,1:2))
legend('x','y','Location','southeast')
title('Casove prubehy vystupu generatoru trajektorie - X*')
xlabel('t [s]')
ylabel('y [m]')
subplot(3,1,2)
grid on
plot(out.simout.Time(startPosition:endPosition),dX(startPosition:endPosition,1:2))
legend('dx','dy','Location','southeast')
title('Casove prubehy vystupu generatoru trajektorie - dX*')
xlabel('t [s]')
ylabel('v [m/s]')
subplot(3,1,3)
grid on
plot(out.simout.Time(startPosition:endPosition),ddX(startPosition:endPosition,1:2))
legend('ddx','ddy','Location','southeast')
title('Casove prubehy vystupu generatoru trajektorie - ddX*')
xlabel('t [s]')
ylabel('a [m/s^2]')
%ulozeni figure
saveas(gcf,'4_Graphics/GEN_vystup','epsc')%vektor pro pdf
saveas(gcf,'4_Graphics/GEN_vystup','png')%pro zobrazeni

%% 3) vykresleni kloubovych souradnic ACS
f = figure();
f.Position(3:4) = [800,600];
hold on
grid on
Q = out.simout.Data(:,end-17:end-15);
dQ = out.simout.Data(:,end-14:end-12);
ddQ = out.simout.Data(:,end-11:end-9);

subplot(3,1,1)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),Q(startPosition:endPosition,:))
legend('\theta_1','\theta_2','\theta_3','Location','northwest')
title('Casovy prubeh kloubovych souradnic')
xlabel('t [s]')
ylabel('\Theta [rad]')

subplot(3,1,2)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),dQ(startPosition:endPosition,:))
legend('d\theta_1','d\theta_2','d\theta_3','Location','northwest')
title('Casovy prubeh rychlosti kloubovych souradnic')
xlabel('t [s]')
ylabel('d\Theta [rad/s]')

subplot(3,1,3)
hold on
grid on
plot(out.simout.Time(startPosition:endPosition),ddQ(startPosition:endPosition,:))
legend('dd\theta_1','dd\theta_2','dd\theta_3','Location','northwest')
title('Casovy prubeh zrychleni kloubovych souradnic')
xlabel('t [s]')
ylabel('dd\Theta [rad/s^2]')

%ulozeni figure
saveas(gcf,'4_Graphics/Kloub_souradnice','epsc')%vektor pro pdf
saveas(gcf,'4_Graphics/Kloub_souradnice','png')%pro zobrazeni

%% 4) vykresleni translacni rychlosti vmax
figure()
hold on
grid on
modelV =  model(:,4:6);

modelovaneV = sqrt((modelV(startPosition:endPosition,1).^2)+(modelV(startPosition:endPosition,2)).^2);
pozadovaneV = ones(length(modelovaneV),1)*vmax;
plot(out.simout.Time(startPosition:endPosition),modelovaneV - pozadovaneV,'LineWidth',0.5)
%plot(out.simout.Time(startPosition:endPosition),modelV(startPosition:endPosition,1:2))
%plot(out.simout.Time(startPosition:endPosition),modelovaneV,'Color','green','LineWidth',1.5,'LineStyle','- ')
legend('sqrt(dx^2+dy^2) - vmax ','Location','southeast')
title('Rozdil prubehu rychlosti koncoveho efektoru a vmax')
xlabel('t [s]')
ylabel('\Delta v [m/s]')
%ulozeni figure
saveas(gcf,'4_Graphics/vmax_overeni','epsc')%vektor pro pdf
saveas(gcf,'4_Graphics/vmax_overeni','png')%pro zobrazeni
%% 
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