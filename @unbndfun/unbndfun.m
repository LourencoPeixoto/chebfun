classdef unbndfun < fun
%UNBNDFUN    Represent global functions on an unbounded interval [-inf inf] or
% a semi-infinite interval [-inf b] or [a inf].
%
% Constructor inputs:
%   UNBNDFUN(OP, DOMAIN) constructs an UNBNDFUN object from the function handle
%   OP by mapping the DOMAIN to [-1 1], and constructing an ONEFUN object to
%   represent the function prescribed by OP. DOMAIN should be a row vector with
%   two elements in increasing order and at least one entry of this two-entry
%   vector should be inf or -inf. OP should be vectorised (i.e., accept a vector
%   input) and output a vector of the same length as its input.
%
%   UNBNDFUN(OP, DOMAIN, VSCALE, HSCALE) allows the constructor of the ONEFUN of
%   the UNBNDFUN to use information about vertical and horizontal scales. If not
%   given (or given as empty), the VSCALE defaults to 0 initially, and HSCALE
%   defaults to 1.
%
%   UNBNDFUN(OP, DOMAIN, VSCALE, HSCALE, PREF) overrides the default behavior
%   with that given by the preference structure PREF. See CHEBPREF.
%
%   UNBNDFUN(VALUES, DOMAIN, VSCALE, HSCALE, PREF) returns a UNBNDFUN object
%   with a ONEFUN constructed by the data in the columns of VALUES (if supported
%   by ONEFUN class constructor).
%
% See ONEFUN for further documentation of the ONEFUN class.
%
% See also FUN, CHEBPREF, ONEFUN.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNBNDFUN Class Description:
%
% The UNBNDFUN class represents global functions on the infinite or
% semi-infinite interval [-inf, b], [a, inf], or [-inf, inf]. It achieves this
% by taking a onefun on [-1, 1] and applying a nonlinear mapping.
%
% Note that all binary UNBNDFUN operators (methods which can take two UNBNDFUN
% arguments) assume that the domains of the UNBNDFUN objects agree. The methods
% will not throw warnings if assumption is violated, but the results will not be
% meaningful under that circumstance.
%
% Class diagram: [<<FUN>>] <>-- [<<onefun>>]
%                    ^
%                    |
%                [unbndfun]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% CLASS CONSTRUCTOR:   
    methods
        
        function obj = unbndfun(op, domain, vscale, hscale, pref)
            
            % Construct an empty unbndfun
            if ( (nargin == 0) || isempty(op) )
                return
            end
            
            % Obtain preferences if none given:
            if ( (nargin < 5) || isempty(pref))
                pref = chebpref();
            else
                pref = chebpref(pref);
            end
            
            % Use default domain if none given:
            if ( (nargin < 2) || isempty(domain) )
                domain = pref.unbndfun.domain;
            end
            
            % Check domain
            if ( (nargin < 2) || isempty(domain) )
                domain = pref.unbndfun.domain;
            elseif ( ~any(isinf(domain)) )
                error('CHEBFUN:UNBNDFUN:BoundedDomain',...
                    'Domain argument should be unbounded.');
            elseif ( ~all(size(domain) == [1, 2]) )
                error('CHEBFUN:UNBNDFUN:domain',...
                    'Domain argument should be a row vector with two entries.');
            end
            
            % Define scales if none given.
            if ( (nargin < 3) || isempty(vscale) )
                vscale = 0;
            end
            
            if ( (nargin < 4) || isempty(hscale) )
                % The hscale of an unbounded domain is always 1.
                % [TODO]: Why?
                hscale = 1;
            end

            unbndmap = unbndfun.createMap(domain);
            % Include nonlinear mapping from [-1,1] to [a,b] in the op:
            if ( isa(op, 'function_handle') )
                op = @(x) op(unbndmap.for(x));
            elseif ( isnumeric(op) )
                % [TODO]: Does this make sense for an UNBNDFUN?
            end
            
            % Preprocess the exponents supplied by the user:
            if ( ~isempty(pref.singPrefs.exponents) )
                % Since the exponents provided by the user are in the sense of
                % unbounded domain, we need to negate them when the domain of
                % the original operator/function handle is mapped to [-1 1]
                % using the forward map, i.e., UNBNDMAP.FOR().
                ind = isinf(domain);
                pref.singPrefs.exponents(ind) = -pref.singPrefs.exponents(ind);
            end
            
            % Call the ONEFUN constructor:
            obj.onefun = onefun.constructor(op, vscale, hscale, pref);
            
            % Add the domain and mapping:
            obj.domain = domain;
            obj.mapping = unbndmap;
            
        end

    end
    
    %% STATIC METHODS IMPLEMENTED BY UNBNDFUN CLASS.
    methods ( Static = true ) 
        
        % Retrieve and modify preferences for this class.
        prefs = pref(varargin);
        
        % Noninear map from [-1, 1] to the domain of the UNBNDFUN.
        m = createMap(domain);
        
        % Make a UNBNDFUN (constructor shortcut):
        f = make(varargin); 
        
    end
       
    %% METHODS IMPLEMENTED BY THIS CLASS.
    methods
        
        % Compose an UNBNDFUN with an operator or another FUN.
        f = compose(f, op, g, pref)
        
        % Indefinite integral of an UNBNDFUN.
        f = cumsum(f, m, dim, shift)
        
        % Derivative of an UNBNDFUN.
        f = diff(f, k, dim)
       
        % Change of domains of an UNBNDFUN via linear change of variables.
        f = changeMap(f,newdom)
        
        % Evaluate an UNBNDFUN.
        y = feval(f, x)
        
        % Flip/reverse an UNBNDFUN object.
        f = flipud(f)
        
        % Compute the inner product of two UNBNDFUN objects.
        out = innerProduct(f, g)
        
        % Left matrix divide for UNBNDFUN objects.
        X = mldivide(A, B)

        % Right matrix divide for an UNBNDFUN.
        X = mrdivide(B, A)
        
        % Estimate the Inf-norm of an UNBNDFUN
        out = normest(f);
        
        % Data for plotting an UNBNDFUN
        data = plotData(f, g);
                
        % Polynomial coefficients of an UNBNDFUN.
        out = poly(f)
        
        % UNBNDFUN power function.
        f = power(f, b)
        
        % QR factorisation for UNBNDFUN object is not supported.
        [f, R, E] = qr(f, flag)

        % Restrict an UNBNDFUN to a subinterval.
        f = restrict(f, s)
        
        % Definite integral of an UNBNDFUN on the its domain.
        out = sum(f, dim)
    end    
end
   