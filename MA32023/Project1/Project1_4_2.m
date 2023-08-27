u(1) = 0 ;
u(2) = 1 ;
n = 2 ;
while abs(u(n) - u(n-1)) > 1e-15
    n = n + 1 ;
    u(n) = (6^(n + 1) + 5^(n + 1))/(6^n + 5^n) ;
end
u(n - 1)
