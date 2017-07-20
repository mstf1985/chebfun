function disp(F)
%DISP   Display a SPHCAPFUN to the command line.
% 
% See also SPHCAPFUN/DISPLAY.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

loose = strcmp( get(0, 'FormatSpacing'), 'loose' );

% Get display style and remove trivial empty SPHCAPFUN case. 
if ( isempty(F) )
    fprintf('    empty sphcapfun\n')
    if ( loose )
        fprintf('\n');
    end
    return
end

% Get information that we want to display:
len = length(F);                          % Numerical rank
vscl = vscale(F);                         % vertical scale

% Display the information: 
disp('     sphcapfun object ')
fprintf('       domain        rank    vertical scale\n');
fprintf(' spherical cap   %6i          %3.2g\n', len, vscl);

if ( loose )
    fprintf('\n');
end

end