function [Labels, WeightMatrix] = project3(points, k, sigma, tau)

N=size(points,1);
[G, W] = constructGraph(points,k,sigma);
WeightMatrix = W;

% Calculate the Laplacian matrix
d = sum(G,2) ;
Dinv = diag(1./d);
T = W*Dinv;
T = T./repmat(sum(T),N,1);
L = eye(N)-T;

% Calculate A
e = zeros(size(L,1),1);
e(1) = 1;
x = ones(size(L,1),1);
x = x/norm(x);
v = sign(x(1))*norm(x)*e + x;
v = v/norm(v);
H=eye(length(v))-2*v*v';
S=H*L*H';
A = S(2:end,2:end);

% Use inverse iteration method to find the smallest eigenvalue of A
V = ones(N-1,1);
V = V/norm(V);
Vprev = V;
lambda = 1;

epsilon = 1e-10;
delta = 1; 
[Q, R] = qr(A);
opts.UT = true;
while epsilon < delta
    V = linsolve(R,Q'*Vprev,opts);
    lambda = transpose(V)*A*V;
    V = V/norm(V);
    delta = norm(Vprev-V);
    Vprev = V;
end
%Vprev is the eigenvector of A that corresponds to lambda_2
V(1) = S(1,2:end)*Vprev*lambda;
V(2:N) = Vprev;
%V is the eigenvector of G that corresponds to lambda_2
V = H'*V;
%Now, V is the eigenvector of L that corresponds to lambda_2

% Calculate Labels
Labels = V > tau;

end