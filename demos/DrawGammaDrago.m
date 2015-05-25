function E = DrawGammaDrago(L, start, slope, gamma)
    L1 = (0 < L <= start);
    L2 = (L >  start);
    
    E(L1) = slope * L(L1);
    E(L2) = L(L2).^(0.9/gamma) * 1.099 - 0.099;
end