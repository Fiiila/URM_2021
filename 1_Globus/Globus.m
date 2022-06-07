% pocatecni inicializace
close all
clear all
clc

% vykresleni globu
[x,y,z] = sphere(50);
x = -x;
y = -y;
load topo
props.FaceColor= 'texture';
props.Cdata = topo;
props.EdgeColor = 'black';
surface(x,y,z,props);
title('Globus s vyznačenou trajektorií')
xlabel('x_0')
ylabel('y_0')
zlabel('z_0')
axis equal
view(115,15)
hold on



% Singapur delka: 103.986306 sirka: 1.351652
% New York delka: −74.168944 sirka: 40.690093

%% vykresleni [Singapuru,NewYorku]
delka = [103.986306,-74.168944];
sirka = [1.351652,40.690093];
polomer = 1;
%vytvoreni prazdne transformacni matice bez deformaci a zmeny velikosti
transfMAT = zeros(4);
transfMAT(end,end) = 1;
for i=1:2
    %vypocet matice rotace
    R2 = rotZ(delka(i))*rotY(-sirka(i));%*transY(polomer)
    %vypocet translacni matice
    translMAT = translX(polomer);
    % doplneni do vysledne transformacni matice
    Tv = transfMAT;
    Tv(1:3,1:3) = R2;
    Tvsave = Tv;
    Tv = Tv*translMAT;
    
    %docasne ulozeni pocatecnich souradnic spendliku
    vectX=[Tv(1,4),0];
    vectY=[Tv(2,4),0];
    vectZ=[Tv(3,4),0];

    % posunuti kvuli vektoru spendliku
    % vektor spendliku je dlouhy 1/4 polomeru spendliku
    translMAT = translX(polomer/4);
    Tv = Tv*translMAT;
    
    % docasne ulozeni konncovych souradnic spendliku, kde se zaroven
    % nachazi hlavicka spendliku
    vectX(2) = Tv(1,4);
    vectY(2) = Tv(2,4);
    vectZ(2) = Tv(3,4);

    % vykresleni spendliku
    plot3([vectX(1) vectX(2)], [vectY(1) vectY(2)], [vectZ(1) vectZ(2)],'Color','k','LineWidth',2.5)
    plot3(Tv(1,4),Tv(2,4),Tv(3,4),'ro','MarkerFaceColor','r','MarkerSize',9)
end

% vykresleni cesty
delkaMezi = linspace(delka(1),delka(2))';
sirkaMezi = linspace(sirka(1),sirka(2))';
pocetPrvku = length(delkaMezi);
x = zeros(1,pocetPrvku);
y = zeros(1,pocetPrvku);
z = zeros(1,pocetPrvku);
for j=1:pocetPrvku
    [x(j),y(j),z(j)] = pointOnGlobe(delkaMezi(j),sirkaMezi(j),polomer);
end
plot3(x,y,z,'Color','r','LineWidth',2)

% BONUSOVY UKOL
% nejkratsi trasa na zemekouli
% vykresleni nejkratsi cesty (rotace kolem Z z prvniho bodu do druheho)
nejkratsiCesta = gcwaypts(sirka(1),delka(1),sirka(2),delka(2),100); % makro pro nalezeni nejkratsi cesty na kulovem povrchu
pocetPrvku = length(nejkratsiCesta);
x = zeros(1,pocetPrvku);
y = zeros(1,pocetPrvku);
z = zeros(1,pocetPrvku);
for j=1:pocetPrvku
    [x(j),y(j),z(j)] = pointOnGlobe(nejkratsiCesta(j,2),nejkratsiCesta(j,1),polomer);
end
plot3(x,y,z,'Color','y','LineWidth',2)

%ulozeni figure
set(gcf,'Renderer','Painter');
saveas(gcf,'1_Graphics/globus.png','png')%pro zobrazeni
saveas(gcf,'1_Graphics/globus.eps','epsc')%vektor pro pdf


%pomocene funkce pro zprehledneni kodu...

% rotace kolem osy Z
function Rz = rotZ(x)
    Rz = [cosd(x),-sind(x),0;
          sind(x),cosd(x) ,0;
          0     ,0      ,1];
end

%rotace kolem osy Y
function Ry = rotY(x)
    Ry = [cosd(x) ,0,sind(x);
          0       ,1,0      ;
          -sind(x),0,cosd(x)];
end

%translace v ose X
function Tx = translX(x)
    Tx = [1,0,0,x;
          0,1,0,0;
          0,0,1,0;
          0,0,0,1];
end

function [Gx,Gy,Gz] = pointOnGlobe(d,s,r)
    % d-zemepisna delka
    % s-zemepisna sirka
    % r-polommer modelu zemekoule
    % vytvoreni prazdne  transformacni matice, ktera nedeformuje perspektivu a
    % zachovava velikost
    transfMAT = zeros(4);
    transfMAT(end,end) = 1;
    % vytvoreni matice rotace postupnou rotaci kolem osy Z a potom kolem osy Y
    % tzn: nejdrive nastaveni zemepisne sirky a pote delky
    R2 = rotZ(d)*rotY(-s);
    %vypocet translacni matice pro pozdejsi nasobeni a ziskani souradnic na
    %povrchu Zemekoule
    translMAT = translX(r);
    % doplneni do vysledne transformacni matice
    Tv = transfMAT;
    Tv(1:3,1:3) = R2;
    Tv = Tv*translMAT;
    Gx = Tv(1,4);
    Gy = Tv(2,4);
    Gz = Tv(3,4);
end

  