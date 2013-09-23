function f = extractColumns(f, colIdx)
%EXTRACTCOLUMNS   Extract columns (or rows) of an array-valued CHEBFUN.
%   G = EXTRACTCOLUMNS(F, COLIDX) extracts the columns specified by the row
%   vector COLIDX from the CHEBFUN F so that G = F(:,COLIDX). COLIDX need not be
%   increasing in order or unique, but it must contain only integers in the
%   range [1, M] where F has M columns.
%
%   If F is a row CHEBFUN, then EXTRACTCOLUMNS(F, ROWIDX) behaves as described
%   above, except that extracts the rows of F so G = F(ROWIDX,: ).
%
% See also MAT2CELL.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Number of columns (or rows if f.isTransposed) of f:
numCols = min(size(f));

% Trivial cases:
if ( isempty(f) )
    return
elseif ( ~isnumeric(colIdx) && strcmp(colIdx, ':') )
    return
elseif ( (numel(colIdx) == numel(numCols)) && all(colIdx == 1:numCols) )
    return
elseif ( max(colIdx) > numCols )
    error('CHEBFUN:subsref:dimensions', 'Index exceeds CHEBFUN dimensions.')    
end

% Extract the columns of the FUNs:
for k = 1:numel(f.funs)
    f.funs{k} = extractColumns(f.funs{k}, colIdx);
end

% Extract the columns from the impulses:
f.impulses = f.impulses(:,colIdx,:);

end
