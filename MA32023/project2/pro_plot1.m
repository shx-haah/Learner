function pro_plot1(n)
h = 10 / n ;
for i = 1 : n + 1
    x(i) = -5 - h + i * h ;
    y(i) = 1 / (1 + x(i)^2) ;
end

fplot(@(x) 1 / (1 + x^2)) ;
hold on
plot(x,y) ;
