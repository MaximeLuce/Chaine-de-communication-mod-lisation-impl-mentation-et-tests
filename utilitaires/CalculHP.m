function [H] =CalculHP(proba) % entropie à partir des probas
    n = length(proba);
    H=0;
    for i=1:n
        H = H - proba(i)*log(proba(i));
    end

end