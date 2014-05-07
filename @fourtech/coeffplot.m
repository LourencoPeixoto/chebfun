function varargout = coeffplot(f, varargin)
%COEFFPLOT   Display Fourier coefficients graphically.
%
%   COEFFPLOT(F) plots the Fourier coefficients of a FOURTECH F on a
%   semilogy scale. A horizontal line at the EPSLEVEL of F is also plotted. If F
%   is an array-valued FOURTECH then a curve is plotted for each component
%   (column) of F.
%
%   COEFFPLOT(F, S) allows further plotting options, such as linestyle,
%   linecolor, etc, in the standard MATLAB manner. If S contains a string
%   'LOGLOG', the coefficients will be displayed on a log-log scale. If S
%   contains a string 'NOEPSLEVEL', the EPSLEVEL is not plotted.
%
%   H = COEFFPLOT(F) returns a column vector of handles to lineseries
%   objects. The final entry is that of the EPSLEVEL plot.
%
%   Note: to make the COEFPLOT easier to read, zero coefficients have a
%   small value added to them (typically F.EPSLEVEL) so that the curve displayed
%   is continuous.
%
% See also PLOT.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Deal with an empty input:
if ( isempty(f) )
    if ( nargout == 1 )
        varargout{1} = plot([]);
    end
    return
end

% Set defaults:
loglogPlot = false;
plotEpsLevel = true;

% Copy input arguments:
args = varargin;

% Check inputs for 'loglog' or 'noepslevel'.
j = 1;
while ( j <= length(args) )
    if ( strcmpi(args{j}, 'loglog') )
        loglogPlot = true; 
        args(j) = [];
    elseif ( strcmpi(args{j}, 'noepslevel') )
        plotEpsLevel = false; 
        args(j) = [];
    else
        j = j + 1;
    end
end

% Store the hold state of the current axis:
holdState = ishold;

% The coefficients:
absCoeffs = abs(f.coeffs);

% Get the size:
[n, m] = size(absCoeffs);

% Need to handle odd/even cases separately
isEven = ~mod(n,2);
if isEven
    coeffIndex = -n/2+1:n/2;
else
    coeffIndex = -(n-1)/2:(n-1)/2;
end

% Add a tiny amount to zeros to make plots look nicer:
if ( f.vscale > 0 )
    % (Min of epslevel*vscale and the miniumum non-zero coefficient)
    absCoeffs(~absCoeffs) = min( f.epslevel*min(f.vscale), ...
                                 min(absCoeffs(logical(absCoeffs))) );
else
    % (add epslevel for zero FOURTECHs)
    absCoeffs = absCoeffs + f.epslevel;
end

if ( ~loglogPlot )
    if ( plotEpsLevel )
        % Plot the coeffs AND the epslevel:
        h = semilogy(coeffIndex, absCoeffs, args{:});
        hold on
        h2 = semilogy([-coeffIndex(1) coeffIndex(1)], repmat(f.vscale, 2, 1)*f.epslevel, args{:});
        h = [h ; h2];
        for k = 1:m
            c = get(h(k), 'color');
            set(h(m+k), 'linestyle', ':', 'linewidth', 1, 'marker', 'none', 'color', c);
        end
    else
        % Plot just the coefficients:
        h = semilogy(coeffIndex, absCoeffs, args{:});
    end
else
    if isEven
        % In this case the positive cofficients have an additional term
        % corresponding to the cos(N/2*x) coefficient. 
        cPos = absCoeffs(n/2:n,:);
        cNeg = absCoeffs(n/2-1:-1:1,:);
    else
        cPos = absCoeffs((n+1)/2:n,:);
        cNeg = absCoeffs((n+1)/2-1:-1:1,:);
    end
    coeffIndexPos = 1:size(cPos,1);
    coeffIndexNeg = 2:size(cNeg,1)+1;
    % Plot the coefficients for the positive and negative fourier modes
    % separately.
    if ( plotEpsLevel )
        h = loglog(coeffIndexPos, cPos, args{:});
        set(h,'linestyle','-');
        hold on
        h2 = loglog([1 coeffIndexPos(end)], repmat(f.vscale, 2, 1)*f.epslevel, args{:});
        h = [h ; h2];
        for k = 1:m
            c = get(h(k), 'color');
            set(h(m+k), 'linestyle', ':', 'linewidth', 1, 'marker', 'none', 'color', c);
        end        
        h2 = loglog(coeffIndexNeg, cNeg, args{:});
        set(h2,'linestyle','--');
        h = [h; h2];
    else
        % Plot just the coefficients:
        h = loglog(coeffIndexPos, cPos, args{:});
        set(h,'linestyle','-');
        hold on;
        h2 = loglog(coeffIndexNeg, cNeg, args{:});
        set(h2,'linestyle','--');
        h = [h; h2];
    end
end

% For constant functions, plot a dot:
if ( n == 1 )
    set(h, 'marker', 'o');
end

% Return hold state to what it was before:
if ( ~holdState )
    hold off
end

% Give an output if one was requested:
if ( nargout > 0 )
    varargout{1} = h;
end

end