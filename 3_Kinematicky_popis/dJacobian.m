function dJ = dJacobian(Q,dQ,par)
%DJACOBIAN Summary of this function goes here
%   Detailed explanation goes here

[a1,a2,a3] = deal(par(1),par(2),par(3));
[Theta1,Theta2,Theta3] = deal(Q(1),Q(2),Q(3));
[dTheta1,dTheta2,dTheta3] = deal(dQ(1),dQ(2),dQ(3));

s1 = sin(Theta1);
s12 = sin(Theta1 + Theta2);
s123 = sin(Theta1 + Theta2 + Theta3);

c1 = cos(Theta1);
c12 = cos(Theta1 + Theta2);
c123 = cos(Theta1 + Theta2 + Theta3);

dJ = [- a3*c123*(dTheta1 + dTheta2 + dTheta3) - a1*c1*dTheta1 - a2*c12*(dTheta1 + dTheta2), - a3*c123*(dTheta1 + dTheta2 + dTheta3) - a2*c12*(dTheta1 + dTheta2), -a3*c123*(dTheta1 + dTheta2 + dTheta3);
    - a3*s123*(dTheta1 + dTheta2 + dTheta3) - a1*s1*dTheta1 - a2*s12*(dTheta1 + dTheta2), - a3*s123*(dTheta1 + dTheta2 + dTheta3) - a2*s12*(dTheta1 + dTheta2), -a3*s123*(dTheta1 + dTheta2 + dTheta3);
    0, 0, 0];
end

