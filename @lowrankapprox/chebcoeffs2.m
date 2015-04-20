function varargout = chebcoeffs2(f)
%CHEBCOEFFS2    Bivariate expansion coefficients
%   X = CHEBCOEFFS2(F) returns the matrix of bivariate coefficients such that
%       F= sum_i ( sum_j X(i,j) T_i(y) T_j(x) ). 
%
%   [A, D, B] = CHEBCOEFFS2( f ) returns the same coefficients keeping them in
%   low rank form, i.e., X = A * D * B'.
%
% See also PLOTCOEFFS2, CHEBCOEFFS.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if ( isempty(f) )
    varargout = { [ ] }; 
    return
end

if ( iszero(f) ) 
    varargout = { 0 } ; 
    return
end

% Get the low rank representation for f:
[cols, d, rows] = cdr(f);

% Get the coeffs of the rows and the columns:
cols_coeffs = chebcoeffs(cols);
rows_coeffs = chebcoeffs(rows);

if ( nargout <= 1 )
    % Return the matrix of coefficients
    varargout = { cols_coeffs * d * rows_coeffs.' }; 
elseif ( nargout <= 3 )
    varargout = { cols_coeffs, d, rows_coeffs };
else
    % Two output variables are not allowed.
    error('CHEBFUN:LOWRANKAPPROX:chebcoeffs2:outputs', ...
        'Incorrect number of outputs.');
end

end