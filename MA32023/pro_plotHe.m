function pro_plotHe(n)
%n = 10 ;
h = 10 / n ;
for i = 1 : n + 1
    x(i) = -5 - h + i * h ;
    y(i) = 1 / (1 + x(i)^2) ;
    yp(i) =  -2 * x(i) / (1 + x(i)^2)^2 ;
    %y(i) = x(i)^2 ;
    %yp(i) = 2 * x(i) ;
end

fplot(@(x) 1 / (1 + x^2)) ;
%fplot(@(x) x^2) ;
hold on

for i = 1 : n - 1
    hermit(x(i : i +1) , y(i : i + 1) , yp(i : i + 1)) ;
end

