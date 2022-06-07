function J = Jacobian(Q, par)
%JACOBIAN Summary of this function goes here
%   Detailed explanation goes here

[a1,a2,a3] = deal(par(1),par(2),par(3));
[Theta1,Theta2,Theta3] = deal(Q(1),Q(2),Q(3));

s1 = sin(Theta1);
s12 = sin(Theta1 + Theta2);
s123 = sin(Theta1 + Theta2 + Theta3);

c1 = cos(Theta1);
c12 = cos(Theta1 + Theta2);
c123 = cos(Theta1 + Theta2 + Theta3);

J = [- a2*s12 - a1*s1 - a3*s123, - a2*s12 - a3*s123, -a3*s123;
    a2*c12 + a1*c1 + a3*c123, a2*c12 + a3*c123, a3*c123;
    1, 1, 1];
end

