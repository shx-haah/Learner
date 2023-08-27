n = 0;
N = 0 : 1 : 20;
x = 10;
for i = 1 : 1 : 21
    SN(i) = 0;
    for n = 0 : 1 : i
        SN(i) = SN(i) + (x^n) / prod(1 : n);
    end
    Er(i) = abs((SN(i) - exp(x)) / exp(x));
end
plot(N,Er);
