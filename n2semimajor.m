function semiMajor = n2semimajor(n)
    mu=3.986004418e+14;
    Rearth = 6.371e+6;
    semiMajor = (mu^(1/3))/(((2*n*pi)/86400)^(2/3)) - Rearth;
end