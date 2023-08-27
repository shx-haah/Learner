function hermit(fx , fy , fyp)

nn = 2 * length(fx) ;
for i = 2 : 2 : nn
    z(i) = fx(i / 2) ;
    z(i - 1) = fx(i / 2) ;
    Df(1 , i) = fy(i / 2) ;
    Df(1 , i - 1) = fy(i / 2) ;
end

for i = 2 : 2 : nn
    Df(2 , i) = fyp(i / 2) ;
end

for i = 2 : nn
    for j = 2 : i
        if z(i) == z(i - j + 1)     continue;end
        Df(j , i) = (Df(j - 1 , i) - Df(j - 1 , i - 1)) / (z(i) - z(i - j + 1)) ;
    end
end

for i = 1 : nn
    b(i) = Df(i , i) ;
end

fh = (fx(nn / 2) - fx(1)) / 100 ;
for k = 1 : 101
    xx = fx(1) + (k - 1) * fh ;
    yy(k) = 0 ;
    for i = 1 : nn
        tem = b(i) ;
        for j = 1 : i - 1
            tem = tem * (xx - z(j)) ;
        end
        yy(k) = yy(k) + tem ;
    end
end
plot(fx(1) : fh : fx(nn / 2) , yy) ;

