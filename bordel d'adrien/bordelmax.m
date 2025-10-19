low = 0.192043895747599;
high = 0.193415637860082;

lowFlottant = sprintf('%.10f', low)- '0';


highFlottant = sprintf('%.10f', high)- '0';

diff = highFlottant - lowFlottant

c = 0;

n = length(diff);

for i = 1:n
    diff(n-i+1)
    if diff(n-i+1) ~= 0
        c=n-i+1;
    end
end
c