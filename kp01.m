function [fmax,x] = kp01(w,p,c,maxit)
%KP01 Solve the 0-1 knapsack problem.
%   [FMAX,X] = KP01(W,P,C) solves the combinatorial optimization problem
%   to maximize the total profit F = SUM(P.*X), subject to the constraint
%   SUM(W.*X) <= C, where the solution X is a binary vector of 0s and 1s.
%
%   The vectors W and P contains weigths and profits for each item.
%   Weights must be positive integers. C is the capacity of the knapsack.
%
%   The algorithm uses preprocessing with estimation of lower and upper
%   bounds to reduce the problem to a core problem. The core problem is
%   solved by standard dynamic programming.
%
%   [FMAX,X] = KP01(W,[],C) solves the problem for P = W. This is a so
%   called subset-sum problem. The subset-sum solver uses preprocessing
%   with small random perturbations to reduce (if possible) the problem
%   size.
%
%   [FMAX,X] = KP01(W,[],C,MAXIT), where MAXIT is positive integer, sets
%   max iterations in the preprocessor step for the subset-sum solver.
%   Default is MAXIT = 256.
%
%   % Example 1: Knapsack problem
%       w = ceil(4000*rand(1000,1));
%       p = rand(1000,1);
%       [fmax,x] = kp01(w,p,1e6);
%
%   % Example 2: Subset-sum problem
%       w = ceil(4000*rand(1000,1));
%       [fmax,x] = kp01(w,[],1e6);
%
%   % Example 3: Hard subset-sum, increase MAXIT
%       w = ceil(4e5*rand(1000,1));
%       [fmax,x] = kp01(w,[],1e8,5000);
%
%   % Example 4: 2010 as a sum of squares
%       w = (1:44).^2;
%       [fmax,x] = kp01(w,[],2010);
%       find(x)
%
%   % Example 5: 2010 as a sum of squares (few terms)
%       w = (1:44).^2;
%       [fmax,x] = kp01(w,w-1,2010);
%       find(x)

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

%   2010-04-13  First published
%   2010-04-20  Subfunction mygcd updated
%   2010-12-08  Improved subset-sum solver
%   2011-02-08  One example added

if nargin < 4 || isempty(maxit), maxit = 256; end

% Subset-sum problem?
subsum = isempty(p);
if subsum, p = w; end

% Check input
sizew = size(w);
w = w(:);
p = p(:);
c = floor(c(1));

if numel(w) ~= numel(p)
    error('kp01:badlengths','Not the same number of weights and profits!')
end
if any(w <= 0 | w > floor(w))
    error('kp01:badweights','Weights must be positive integers!')
end
maxit = max(maxit,1);

% Remove items with nonpositive profits and large weights
include = p > 0 & w <= c;
w = w(include);
p = p(include);
n = numel(w);

% Trivial solution
if n == 0 || sum(w) <= c
    fmax = sum(p);
    x = reshape(include,sizew);
    return
end

% Reduce weights by common divisor
d = mygcd(w);
if d > 1
    w = w/d;
    c = floor(c/d);
end

% Reduce problem size
if subsum
    % Subset-sum problem
    % Find a "smallest" core by adding random perturbations to profits
    ncmin = inf;
    nclim = sqrt(3600 + 7*n);
    for k = 1:maxit
        % Random perturbations
        dp = w.*rand(n,1);
        dp = dp/sum(dp);
        % Find core problem
        [bk,ick,isk] = findcore(w,p+dp,c);
        nc = sum(ick);
        % Keep smallest core
        if nc < ncmin
            b = bk;
            icore = ick;
            isort = isk;
            %fprintf('%8d%8d\n',k,nc)
            if nc < nclim, break, end
            ncmin = nc;
        end
    end
else
    % Knapsack problem
    [b,icore,isort] = findcore(w,p,c);
end

% Preselected items
ipre = ~icore;
ipre(b:n) = false;

% Unsort items
icore(isort) = icore;
ipre(isort) = ipre;

% Remaining capacity of knapsack
ccore = c - sum(w(ipre));
icore = icore & w <= ccore;

% Solve core problem by dynamic programming
if subsum
    [fmax,x] = subsetsum(w(icore),ccore);
    fmax = d*fmax;
else
    [fmax,x] = knapsack(w(icore),p(icore),ccore);
end

% Add preselected items to solution
icore(icore) = x;
x = icore | ipre;
fmax = fmax + sum(p(ipre));

% Expand solution
include(include) = x;
x = reshape(include,sizew);


%--------------------------------------------------------------------------
function [b,icore,isort] = findcore(w,p,c)
%FINDCORE Find knapsack core problem

% Sort items by decreasing efficiency
n = numel(w);
e = p./w;
[e,isort] = sort(e,1,'descend');
p = p(isort);
w = w(isort);

% Cumulative arrays
pc = cumsum(p);
wc = cumsum(w);

% Find the break item
b = find(wc > c, 1);

% Trivial solution
if wc(b-1) == c
    icore = false(n,1);
    return
end

% Estimate a lower bound L for fmax
% k <= b: Include break item and exclude item k
% k > b: Exclude break item and include item k
wsum = [wc(b)-w(1:b); wc(b-1)+w(b+1:n)];
psum = [pc(b)-p(1:b); pc(b-1)+p(b+1:n)];
L = max(psum(wsum <= c));

% Piecewise linear upper bound function g(c)
% such that fmax(c) <= g(c), c = 1,...,sum(w)
breaks = [0, wc'];
coefs = [e, [0; pc(1:n-1)]];

% Conditional upper bounds U(k) for fmax
% k < b: Upper bound if item k is excluded
% k > b: Upper bound if item k is included
w(b+1:n) = -w(b+1:n);
p(b+1:n) = -p(b+1:n);
U = myppval(breaks,coefs,w+c) - p;
% Break item belongs to the core
U(b) = L + 1;

% U(k) < L implies x(k) = 1 for k < b and x(k) = 0 for k > b
% The core problem are items with U(k) >= L
icore = U >= L;


%--------------------------------------------------------------------------
function [fmax,x] = subsetsum(w,c)
%SUBSETSUM Solve subset-sum problem by dynamic programming

% Initiate arrays
n = numel(w);
x = false(n,1);
F = zeros(1,c+1);
G = false(1,c+1);
G(1) = true;

% Forward part
for k = 1:n
    H = [false(1,w(k)), G(1:end-w(k))];
    H = G < H;
    j = find(H);
    F(j) = k;
    G(j) = true;
    if G(c+1), break, end
end
j = find(G,1,'last');
fmax = j - 1;

% Backtracking part
while j > 1
    k = F(j);
    x(k) = true;
    j = j - w(k);
end


%--------------------------------------------------------------------------
function [fmax,x] = knapsack(w,p,c)
%KNAPSACK Solve 0-1 knapsack problem by dynamic programming

% Initiate arrays
n = numel(w);
x = false(n,1);
if all(p == floor(p)) && sum(p) < intmax('int32')
    % Integer profits
    F = zeros(c+1,n,'int32');
    G = zeros(c+1,1,'int32');
else
    F = zeros(c+1,n);
    G = zeros(c+1,1);
end

% Forward part
for k = 1:n
    F(:,k) = G;
    H = [zeros(w(k),1); G(1:end-w(k)) + p(k)];
    G = max(G,H);
end
fmax = double(G(end));

% Backtracking part
f = fmax;
j = c+1;
for k = n:-1:1
    if F(j,k) < f
        x(k) = true;
        j = j - w(k);
        f = F(j,k);
    end
end


%--------------------------------------------------------------------------
function d = mygcd(a)
%MYGCD Greatest common divisor of positive integer array A
if any(a == 1), d = 1; return, end
while numel(a) > 1
    d = min(a);
    a = rem(a,d);
    if any(a == 1), d = 1; return, end
    a = [a(a>0); d];
end


%--------------------------------------------------------------------------
function y = myppval(breaks,coefs,x)
%MYPPVAL Simplified verison of PPVAL
[junk,ibin] = histc(x,[-inf,breaks(2:end-1),inf]); %#ok
c = coefs(ibin,:);
h = x - breaks(ibin)';
y = c(:,1).*h + c(:,2);

