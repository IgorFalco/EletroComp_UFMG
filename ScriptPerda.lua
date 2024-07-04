-- Definir a condutividade original do aço M-45
    original_sigma = 2.9 -- Substitua este valor com a condutividade correta do aço M-45
    
    -- Algoritmo para investigar a influência de diferentes frequências e condutividades no trafo
    for sigma_factor = 1, 6 do  -- Variação da condutividade do aço M-45
        sigma = sigma_factor * original_sigma  -- Onde original_sigma é a condutividade do aço M-45
    
        -- Atualizando a condutividade do material no FEMM
        mi_modifymaterial("M-45 Steel", 5, sigma)
    
        for f = 60, 300, 60 do  -- Variação da frequência de 60 Hz a 300 Hz
            mi_probdef(f, "inches", "planar", 1e-008, 1.625, 20, "Succ.")
            mi_analyze(0)
            mi_loadsolution()
            
            -- Selecionar o grupo específico de blocos (garantir que o bloco está corretamente agrupado)
            mo_groupselectblock(0) -- Certifique-se de que o bloco com grupo 1 existe no modelo
            
            -- Verificar se a seleção de bloco foi feita corretamente
            if mo_blockintegral(1) ~= 0 then  -- Verificar se há alguma área selecionada
                perda_total = mo_blockintegral(6)
                print(f, sigma_factor, perda_total)
            else
                print("Nenhuma área selecionada para a frequência: ", f, " e condutividade: ", sigma_factor)
            end
        end
    end