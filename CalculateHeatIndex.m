function HeatIndex = CalculateHeatIndex(fahrenheit, RH)

fahrenheit = (9/5) * fahrenheit + 32; 
c1 = -42.379;          % This is the formula provided
c2 = 2.04901523;       % by the National Weather Service
c3 = 10.14333127;
c4 = -0.22475541;
c5 = -6.83783 * 10^(-3);
c6 = -5.481717 * 10^(-2);
c7 = 1.22874 * 10^(-3);
c8 = 8.5282 * 10^(-4);
c9 = -1.99 * 10^(-6);

HeatIndex = c1 + c2 .* fahrenheit + c3 .* RH + c4 .* fahrenheit .* RH + c5 .* fahrenheit.^2 + c6 .* RH.^2 + c7 .* fahrenheit.^2 .* RH + c8 .* fahrenheit .* RH.^2 + c9 .* fahrenheit.^2 .* RH.^2;
end