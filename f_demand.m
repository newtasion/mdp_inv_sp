% t: 1~n
function u = f_demand(t)

    if t <=3
        u = 0.25 * exp(t) ;
    elseif t<=7
        u = 0.25 * exp(3) ;
    else
        u = 0.25 * exp(10-t) ;
    end

end