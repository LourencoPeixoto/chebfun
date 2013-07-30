function g = cot(f, pref)
%COT   Cotangent of a chebfun.
%
% See also ACOT, COTD.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Obtain preferences:
if ( nargin == 1 )
    pref = chebfun.pref();
end

% if ( ~isfinite(f) )
%     error('CHEBFUN:cot:inf',...
%         'COT is not defined for functions which diverge to infinity');
% end

% Call the compose method:
g = compose(f, @cot, pref);

end