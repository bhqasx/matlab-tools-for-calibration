function [V, A] = Comp2CsVol(cs1, cs2, zw)
    Area1 = 0.0;
    Width1 = 0.0;
    for j = 1:cs1.numnd - 1
        zb_mean = 0.5 * (cs1.ZBIJ(j) + cs1.ZBIJ(j+1));
        da = (zw - zb_mean) * cs1.dbij(j);
        db = cs1.dbij(j);

        if zb_mean >= zw
            da = 0.0;
            db = 0.0;
        end

        Area1 = Area1 + da;
        Width1 = Width1 + db;
    end

    Area2 = 0.0;
    Width2 = 0.0;
    for j = 1:cs2.numnd - 1
        zb_mean = 0.5 * (cs2.ZBIJ(j) + cs2.ZBIJ(j+1));
        da = (zw - zb_mean) * cs2.dbij(j);
        db = cs2.dbij(j);

        if zb_mean >= zw
            da = 0.0;
            db = 0.0;
        end

        Area2 = Area2 + da;
        Width2 = Width2 + db;
    end

    dist = (cs2.dist - cs1.dist) * 1000;  % 两断面间距离(m)
    V = (Area1 + Area2 + sqrt(Area1 * Area2)) * dist / 3.0;

    if Width1 == 0.0 && Width2 ~= 0.0
        A = Width2 * dist;  % 20160228
    elseif Width1 ~= 0.0 && Width2 == 0.0
        A = Width1 * dist;
    else
        A = (Width1 + Width2) * dist / 2.0;  % 水面面积 between 2CS
    end

    V = V / 1e8;  % 亿立方米
    A = A / 1e6;  % km^2
end
