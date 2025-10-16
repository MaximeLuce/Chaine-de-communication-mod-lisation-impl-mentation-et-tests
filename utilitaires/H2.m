function [r] = H2(p)
    r = p*log(p)+(1-p)*log(1-p);
end