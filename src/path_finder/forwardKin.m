% Title:        AWP Trajectory Planning and Control
% File:         forwardKin.m
% Date:         2017-04-20
% Authors:      Nicolai Domingo Nielsen
%               Paul-Edouard Sarlin
% Description:  Perform forward (direct) kinematics.

function [ xy2, xy1 ] = forwardKin(robot, th1th2)

th1 = th1th2(:,1);
th2 = th1th2(:,2);

xy1 = robot.l1 * [cos(th1), sin(th1)];
xy2 = xy1 + robot.l2 * [cos(th1 + th2), sin(th1 + th2)];

end

