% Calculate the firing levels directly as the correlation coefficient between x and the focal point
if model.no_rules > 0
    for i = 1:model.no_rules
        centre = model.rule_focalpoints(i, 1:model.nf);
        v1 = x; %-mean(x);
        v2 = centre; %-mean(centre);
        tau(i) = exp(-(1-v1*v2'/(norm(v1)*norm(v2)))^2/model.zeta_sq);
    end;
    
    s = sum(tau);
    if s == 0
        lambda = tau;
    else
        lambda = tau/s;
    end;
else
    tau = [];
    lambda = [];
end;
