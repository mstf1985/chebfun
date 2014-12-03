function varargout = expm(N, t, u0, pref)
%EXPM    Exponential semigroup of a linear CHEBOP.
%   U = EXPM(L, T, U0) uses matrix exponentiation to propagate an initial
%   condition U0 for time T through the differential equation u' = L*u, where L
%   is a linear CHEBOP. Formally, the solution is given by u(t) = exp(t*L)*u0,
%   where exp(t*L) is a semigroup generated by L. Here U0 may be a CHEBFUN or a
%   CHEBMATRIX of appropriate dimensions.
%
%   If T is a vector, then U is a CHEBMATRIX and will have one column for each
%   entry of T. If T is a scalar and U0 is a scalar CHEBFUN or CHEBMATRIX, then
%   U is a CHEBFUN.
%
%   L should have appropriate boundary conditions to make the problem
%   well-posed. Those conditions have zero values; i.e., are represented by
%   B*u(t) = 0 for a linear functional B.
%
%   EXPM(..., PREFS) accepts a preference structure or object like that created
%   by CHEBOPPREF.
%
%   EXAMPLE: Heat equation
%      d = [-1 1];  x = chebfun('x', d);
%      A = chebop(@(u) diff(u, 2), [-1, 1], 0);
%      u0 = exp(-20*(x+0.3).^2);  
%      t = [0 0.001 0.01 0.1 0.5 1];
%      u = expm(A, t, u0);
%      colr = zeros(6, 3); colr(:,1) = 0.85.^(0:5)';
%      clf, set(gcf, 'defaultaxescolororder', colr)
%      plot(chebfun(u), 'linewidth', 2)
%
%   E = EXPM(T*L) is supported for backwards compatibility, and returns a CHEBOP
%   E which can be applied to U0, so that U = E*U0, or U = E(U0). However, this
%   syntax is deprecated and may be removed in future releases. EXPM(L, T, U0)
%   as described above is the preferred syntax.
%
% See also LINOP/EXPM.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Grab a preference if not given one:
isPrefGiven = 1;
if ( nargin < 4 )
    pref = cheboppref();
    isPrefGiven = 0;
end

% Linearize and check whether the CHEBOP is linear:
[L, ignored, fail] = linop(N);

if ( fail )
    error('CHEBFUN:CHEBOP:expm:nonlin', ...
        ['The operator appears to be nonlinear.\n', ...
         'EXPM() supports only linear CHEBOP instances.']);
end

% Determine the discretization.
pref = determineDiscretization(N, L, isPrefGiven, pref);

% Clear boundary conditions if the dicretization uses periodic functions (since
% if we're using periodic basis functions, the boundary conditions will be
% satisfied by construction).
discPreference = pref.discretization();
tech = discPreference.returnTech();
if ( isTrigTech(tech()) )
    [N, L] = clearPeriodicBCs(N, L);
end


if ( nargin >= 3 )
    % Evaluate the matrix exponential for the given u0:
	[varargout{1:nargout}] = expm(L, t, u0, pref);
else
    % For backwards compatibility:
    warning('CHEBFUN:CHEBOP:expm:deprecated', ...
        ['The E = expm(L) syntax is deprecated and may not behave as expected.\n', ...
         'Please review EXPM documentation for details.'])
    varargout{1} = chebop(@(u) expm(L, 1, u), N.domain);
end

end
