function pro_plot3(n)
%n = 10 ;
h = 10 / n ;
for i = 1 : n + 1
    x(i) = -5 - h + i * h ;
    y(i) = 1 / (1 + x(i)^2) ;
    %yp(i) =  -2 * x(i) / (1 + x(i)^2)^2 ;
end

fplot(@(x) 1 / (1 + x^2)) ;
hold on

A =  eye(n + 1) ;
for i = 1 : n
    A(i + 1 , i) = 1/2 ;
end;
A = A' + A ;
A(2,1) = 1 ;
A(n - 1 , n + 1) = 1 ;

for i = 1 : n + 1
    Df(1 , i) = y(i) ;
end

for i = 2 : n + 1
    for j = 2 : min(i , 3)
        Df(j , i) = (Df(j - 1 , i) - Df(j - 1 , i - 1)) / (x(i) - x(i - j + 1)) ;
    end
end

for i = 2 : n
    d(i) = 6 * Df(3 , i + 1) ;
end

d(1) = (Df(2,2) - 2 * x(1) / (1 + x(1)^2)^2) * 6 / h ;
d(n + 1) = -2 * x(n + 1) / (1 + x(n + 1)^2)^2 * 6 / h ;
M = inv(A) * d' ;

for i = 1 : n 
    fh = (x(i + 1) - x(i)) / 10 ;
    for k = 1 : 11
        xx = x(i) + (k - 1) * fh ;
        yy(k) = (x(i + 1) - xx)^3 * M(i) / (6 * h) ; 
        yy(k) = yy(k) + (xx - x(i))^3 * M(i + 1)/ (6 * h) ;
        yy(k) = yy(k) + (y(i) - M(i) * h^2 / 6) * (x(i + 1) - xx) / h ;
        yy(k) = yy(k) + (y(i + 1) - M(i + 1) * h^2 / 6) * (xx - x(i)) / h ;
    end
    plot(x(i) : fh : x(i + 1) , yy) ;      
end




