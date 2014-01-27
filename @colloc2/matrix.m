function varargout = matrix(disc,dimension,domain)
%MATRIX    Convert operator to matrix using COLLOC2 discretization.
%   MATRIX(DISC) uses the parameters in DISC to discretize DISC.source as a
%   matrix using COLLOC2. 
%
%   MATRIX(DISC,DIM,DOMAIN) overrides the native 'dimension' and 'domain'
%   properties in DISC.
%
%   [PA,P,B,A] = MATRIX(...) returns the additional component matrices resulting
%   from boundary condition manipulations, as described in
%   COLLOC2.APPLYCONSTRAINTS.

%  Copyright 2013 by The University of Oxford and The Chebfun Developers.
%  See http://www.chebfun.org for Chebfun information.

if ( nargin > 1 )
    disc.dimension = dimension;
    if ( nargin > 2 )
        disc.domain = domain;
    end
end

% Check subinterval compatibility of domain and dimension.
if ( (length(disc.domain)-1) ~= length(disc.dimension) )
    error('Must specify one dimension value for each subinterval.')
end

L = disc.source;
if isa(L,'chebmatrix')
    A = instantiate(disc,L.blocks);
    if isa(L,'linop')
        [out{1:4}] = applyConstraints(disc,A);
    else
        out{1} = cell2mat(A);
    end
    m = max(1,nargout);
    varargout(1:m) = out(1:m);
else
    % The source must be a chebfun, or...?
    % TODO: Figure out if this is ever called.
    [varargout{1:nargout}] = instantiate(disc,L);
end

end