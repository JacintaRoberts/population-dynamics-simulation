function ParasiteModel = ParasiteModelFn(t,X,k1,k2,k3,k4,k5)
    ParasiteModel = zeros(2,1);
    ParasiteModel(1) = X(1)*((k1*X(2)) - k2);
    ParasiteModel(2) = k3 - (k4*X(2)) - (k5*X(1));
end