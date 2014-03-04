function err = valueTesting(f, numOut)
% ERR = VALUETESTING(F, NUMOUT)  Test that ADCHEBFUN is calling the correct
%   method for the function part of the methods.
%
% Here, the inputs are:
%   F       -- a function handle
%   numOut  -- an optional argument, used for methods with more than one outputs
%       (in particular, ellipj)
%
% and the output is
%   err     --  a vector containing the infinity norm of the difference between
%               applying F to a CHEBFUN and an ADCHEBFUN.
%
% % See also: valueTestingBinary, taylorTesting.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

% This method proceeds as follows:
%   1. Construct an arbitrary CHEBFUN U, and a corresponding ADCHEBFUN V.
%   2. Evaluate the function handle F on both U and V.
%   3. Return the infinity norm of the difference between the results (which we
%      should expect to be zero).



% Default value of NUMOUT
if ( nargin == 1)
    numOut = 1;
end

% Seed random generator to ensure same values.
seedRNG(6179);

% Length of test functions:
N = 8;

% Generate an arbitrary CHEBFUN to evaluate the function at:
u = 0.1*chebfun(rand(N, 1)) + .5;

% Construct a corresponding ADCHEBFUN:
v = adchebfun(u);

% Evaluate f at both u and v. FU will be a CHEBFUN, while FV will be an
% ADCHEBFUN
[fu{1:numOut}] = f(u);
[fv{1:numOut}] = f(v);

% We should expect that the FUNC field of FV matches the FU
err = max(cellfun(@(fu, fv) norm(fu - fv.func,'inf'), fu, fv));

end