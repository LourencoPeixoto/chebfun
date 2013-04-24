% Test file for chebtech/conj.m

function pass = test_conj(pref)

if ( nargin < 1 )
    pref = chebtech.pref;
end

pass = zeros(2, 2); % Pre-allocate pass matrix
for n = 1:2
    if (n == 1)
        testclass = chebtech1();
    else 
        testclass = chebtech2();
    end

    tol = 10*pref.chebtech.eps;
    
    % Test a scalar-valued function:
    f = testclass.make(@(x) cos(x) + 1i*sin(x), [], [], pref);
    g = testclass.make(@(x) cos(x) - 1i*sin(x), [], [], pref);
    h = conj(f);
    pass(n, 1) = norm(h.values - g.values, inf) < tol;
    
    % Test a multi-valued function:
    f = testclass.make(@(x) [cos(x) + 1i*sin(x), -exp(1i*x)], [], [], pref);
    g = testclass.make(@(x) cos(x) - 1i*sin(x), [], [], pref);
    h = conj(f);
    pass(n, 2) = norm(h.values - [g.values, -(g.values)], inf) < tol;
end

end
