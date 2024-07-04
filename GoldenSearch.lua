-- Configurações iniciais da simulação
mi_modifycircprop("Primary", 1, 0.1)
mi_analyze()
mi_loadsolution()
r = {0, 0, 0}
r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
vp1 = abs(r[2])
ip1 = r[1]
vrms = 179.6051

-- Busca de um intervalo [ip1, ip2] que contenha o valor de vrms, utilizando passo 0.01
for k = 1, 10 do
    ip2 = ip1 + 0.01
    mi_modifycircprop("Primary", 1, ip2)
    mi_analyze()
    mi_loadsolution()
    r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
    vp2 = abs(r[2])
    
    if vp2 > vrms then
        -- Condição de parada, para garantir que [ip1, ip2] contenha vrms
        break
    else
        ip1 = ip2
        vp1 = vp2
    end
end

-- Refinamento do resultado, utilizando o algoritmo de busca dourada
if abs(vrms - vp1) < 0.1 then
    print(ip1)
    print(vp1)
elseif abs(vp2 - vrms) < 0.1 then
    print(ip2)
    print(vp2)
else
    x1 = ip2 - 0.618 * (ip2 - ip1)
    mi_modifycircprop("Primary", 1, x1)
    mi_analyze()
    mi_loadsolution()
    r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
    y1 = abs(r[2])
    
    x2 = ip1 + 0.618 * (ip2 - ip1)
    mi_modifycircprop("Primary", 1, x2)
    mi_analyze()
    mi_loadsolution()
    r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
    y2 = abs(r[2])
    
    epoca = 0
    maxepocas = 100
    
    -- Condições de parada:
    -- 1. Limite de épocas
    -- 2. Erro menor que 0.1
    while ((abs(vrms - vp1) > 0.1) and (epoca < maxepocas)) do
        if vrms > y1 then
            ip1 = x1
            vp1 = y1
            x1 = x2
            y1 = y2
            x2 = ip1 + 0.618 * (ip2 - ip1)
            mi_modifycircprop("Primary", 1, x2)
            mi_analyze()
            mi_loadsolution()
            r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
            y2 = abs(r[2])
        else
            ip2 = x2
            vp2 = y2
            x2 = x1
            y2 = y1
            x1 = ip2 - 0.618 * (ip2 - ip1)
            mi_modifycircprop("Primary", 1, x1)
            mi_analyze()
            mi_loadsolution()
            r[1], r[2], r[3] = mo_getcircuitproperties("Primary")
            y1 = abs(r[2])
        end
        epoca = epoca + 1
    end
    print(ip1)
    print(vp1)
end
