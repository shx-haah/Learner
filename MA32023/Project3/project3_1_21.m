clear ;
for i = 2 : 2 : 30
    d(i / 2) = deltaLin(i) ;
end

j = 0 ;
q = (2 : 2 : 30).^j .* d ;
while j < 4
    plot(q,'LineWidth',5) ;
    hold on
    j = j + 1 ;
    q = q .* (2 : 2 : 30) ;
end
legend('order 1','order 2','order 3','order 4') ;