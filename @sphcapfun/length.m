function varargout = length( f )
%LENGTH   The rank of a SPHCAPFUN.
%   K = LENGTH(F) returns the rank of the SPHCAPFUN representation.
%
%   [M, N] = LENGTH( F ) returns the length of the column and 
%   row slices employed in the separable model.  The interpretation 
%   of this quantity depends on the underlying representation. 
%
% See also SPHCAPFUN/RANK.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

[varargout{1:nargout}] = length( f.diskFunction );

end