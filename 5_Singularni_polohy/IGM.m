function Q = IGM(par,X)
%IGM inverzni geomerticky model manipulatoru
%   vypocitava jednotlive kloubove souradnice manipulatoru na zaklade
%   zadane koncove polohy efektoru
%   par - parametry manipulatoru (pole delek ramen od zakladny k efektoru)
%   X - vektor [x,y,q] vyjadrujici pozici v souradnicovem systemu a
%   natoceni efektoru q

%degrees - pokus o zpracovani ve stupnich
% a = par;
% cosinus = ((X(1)-a(3)*cosd(X(3)))^2+(X(2)-a(3)*sind(X(3)))^2-a(1)^2-a(2)^2)/(2*a(1)*a(2));
% Theta2 = atan2d(sqrt(1-cosinus^2),cosinus);
% A = [-a(2)*sind(Theta2),(a(2)*cosd(Theta2)+a(1));
%      (a(2)*cosd(Theta2)+a(1)),a(2)*sind(Theta2)];
% B = [X(1)-a(3)*cosd(X(3));
%      X(2)-a(3)*sind(X(3))];
% newX = A\B;%inv(A)*B
% Theta1 = atan2d(newX(1),newX(2));
% Theta3 = X(3) - Theta1 - Theta2;
% Q = [Theta1;Theta2;Theta3];

%rad - zpracovani v radianech
a = par;
cosinus = ((X(1)-a(3)*cos(X(3)))^2+(X(2)-a(3)*sin(X(3)))^2-a(1)^2-a(2)^2)/(2*a(1)*a(2));
Theta2 = atan2(-sqrt(1-cosinus^2),cosinus);
A = [-a(2)*sin(Theta2),(a(2)*cos(Theta2)+a(1));
     (a(2)*cos(Theta2)+a(1)),a(2)*sin(Theta2)];
B = [X(1)-a(3)*cos(X(3));
     X(2)-a(3)*sin(X(3))];
newX = A\B;%inv(A)*B
Theta1 = atan2(newX(1),newX(2));
Theta3 = X(3) - Theta1 - Theta2;
Q = [Theta1;Theta2;Theta3];
end

