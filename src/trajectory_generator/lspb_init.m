% Title:        ME5402 Project 1-2: Trajectory Planning
% File:         lspb_init.m
% Date:         2017-04-20
% Author:       Nicolai Domingo Nielsen (A0164015R)
%               Paul-Edouard Sarlin (A0153124U)
% Description:  Initializer for the Linear Segments with Parabolic Blends
%               generator handler.

function [ lspb, T_tot ] = lspb_init( p, v_max, a_max )

% Initialise parameters
[n,d] = size(p);
t_blend = zeros(1,n);
T = zeros(1,n-1);
v_lin = zeros(n+1,d);
a_blend = zeros(n,d);

% Compute duration of linear segments
for i = 1:n-1
    T(i) = max( abs(p(i+1,:) - p(i,:))./v_max );
end
T = [1 T 1]; % dummy, will be replaced later
p = [p(1,:); p; p(end,:)]; % duplicate ends

% Compute velocities and parabolic blends considering limits
i = 1;
while i <= n
    
    v_lin(i,:) = (p(i+1,:) - p(i,:))/T(i);
    v_lin(i+1,:) = (p(i+2,:) - p(i+1,:))/T(i+1);
    t_blend(i) = max( abs(v_lin(i+1,:) - v_lin(i,:))./a_max );

    if i==1
        T(1) = t_blend(1)/2;
    elseif i==n
        T(end) = t_blend(n)/2;
    end
    
    % Check if overlap of the blends
    if ( (t_blend(i) > T(i+1)) && (i < n) ) || ...
       ( (t_blend(i) > T(i)) && (i > 1))
        f = sqrt(min(T(i), T(i+1))/t_blend(i));
        T(i) = T(i)/f;
        T(i+1) = T(i+1)/f;
        i = 1;
    else
        a_blend(i,:) = (v_lin(i+1,:) - v_lin(i,:))/t_blend(i);
        i = i + 1;
    end
end

T_stamps = cumsum(T);
T_tot = T_stamps(end);

% Pack initilialisation structure
lspb = struct();
lspb.n = n;
lspb.d = d;
lspb.p = p;
lspb.T_stamps = T_stamps;
lspb.v_lin = v_lin;
lspb.a_blend = a_blend;
lspb.t_blend = t_blend;

end

