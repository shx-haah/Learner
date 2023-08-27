function re = deltaLin(n)
h = 2 / (n - 1) ;
[x,y] = meshgrid(-1 : h : 1) ;
z = sin(2 * pi * x) .* cos(3 * pi * y) ;

global nn hh m
m = 3 ;
nn = m * (n - 1) + 1 ;
hh = 2 / (nn - 1) ;
[xx , yy] = meshgrid(-1 : hh : 1) ;%chazhi grid
zz = zeros(nn) ;
for i = 1 : m : nn
    j = (i - 1) / m + 1 ;
    zz(i ,:) = interp1(xx(i , 1 : m : nn) , z(j ,:) , xx(i ,:)) ;
    zz(:, i) = interp1(yy(1 : m : nn , i) , z(:, j) , yy(:, i)) ;
end

for i = 1 : m : nn - 1
    for j = 1 : m - 1
        zz(i + j ,:) = interp1(xx(i + j ,1 : m : nn) , zz(i + j ,1 : m : nn) , xx(i + j , :)) ;
    end
end

zz0 = sin(2 * pi * xx) .* cos(3 * pi * yy) ;
re = max(max(abs(zz0-zz))) ;