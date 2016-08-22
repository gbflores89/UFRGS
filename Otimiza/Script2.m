clc; % limpar console
clear; % limpar variáveis

% Condição dos valoes iniciais: 1 = [0..2]; 2 = [-2..4]
inicialValues=2;

% Algoritmos
iFinal = 4;

% Problemas
jFinal = 13;
% Dimensão do problema j
jDim = zeros(1,jFinal);

% Probelmas resolvidos com o algotitmo i
Ni = zeros(1,iFinal);
% Tempo computacional para resolver o problema j utilizando o algoritmo i (100x)
Tij = zeros(iFinal,jFinal);
% Número total de iterações resolver o problema j utilizando o algoritmo i (100x)
Sij = zeros(iFinal,jFinal);
% Melhor valor da Função Objetivo encontrado (em 100x)
Optij = zeros(iFinal,jFinal);

% precisão da máquina
epsilon = eps; % (default)
% precisão na tolerância na variável independente
epsilonx = 1e-4; % (default)
% precisão na função objetivo
epsilonS = 1e-4; % (default)

% Valor da Função objetivo no ótimo do problema j
OtStar = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; -3.25 ];

% Local do òtimo do problema j
xijStar = [1 1 0 0; 1 1 0 0; 1 1 0 0; 1 1 0 0; 3 0.5 0 0; 1 1 1 1; 0 0 0 0; 0 1 1 1; 1 1 0 0; 0 0 0 0; 0.5 -1 0 0; 5 6 0 0; 2.5 0 0 0 ];

% Qualidade solução do problema j utilizando o algoritmo i
dij = zeros(iFinal,jFinal);

% Problema j
for j = 1:jFinal
    
    % Definição da Função Objetivo
    S=str2func(['test',num2str(j)]);
    % Definição do Gradiente (se existir)
    G=str2func(['gtest',num2str(j)]);
    % Definição da Hessiana (se existir)
    H=str2func(['htest',num2str(j)]);
    
    % boleana se o problema foi resolvido (reset)
    error = 0;
    
    % Algotitmo i
    for i = 1:iFinal
        %boleana se o problema foi resolvido (reset)
        error = 0;
        
        % tempo computacional
        tic;
        
        % número de interações para resolver o problema j 100x com o método i
        nS1 = 0;
        
        % Variável independente no ponto ótimo
        x1 = [1 1];
        
        % Função objetivo no ponto ótimo
        opt = Inf;
        
        % n vezes cada problema para cada método e cada
        for n = 1:100
            
            if inicialValues==1
                % Valores iniciais (1)
                rand1 =  rand*2;
                rand2 =  rand*2;
                rand3 =  rand*2;
                rand4 =  rand*2;
            else
                % Valores iniciais (2)
                rand1 =  rand*6 - 2;
                rand2 =  rand*6 - 2;
                rand3 =  rand*6 - 2;
                rand4 =  rand*6 - 2;
            end
            
            % valor inicial para cada função
            if(j==6||j==7||j==8)
                x0=[rand1 rand2 rand3 rand4];
                jDim(j)=4;
            else
                x0=[rand1 rand2];
                jDim(j)=2;
            end
            
            try
                if i==1
                    [xo,Ot,nS]=hkjeeves(S,x0,[],[],[],[],[],1e5);
                end
                if i==2
                    [xo,Ot,nS]=cgrad(S,x0,[],G);
                end
                if i==3
                    [xo,Ot,nS]=newton(S,x0,[],G,H);
                end
                if i==4
                    [xo,Ot,nS]=lmarqua(S,x0,[],G,H);
                end
            catch
                error = 1;
            end
            
            % Soma do número total de iterações
            nS1 = nS1+nS;
            
            % Salvar o melhor valor ótimo do método entre as n iterações
            if (opt>Ot)
                opt = Ot;
                for k=1:4
                    try
                        x1(k) = xo(k);
                    catch
                        x1(k) = 0;
                    end
                end
            end
        end
        
        if (error == 0)
            % Caso o método execute normalmente
            time = toc;
            Tij(i,j) = time;
            Sij(i,j) = nS1;
            Ni(i) = Ni(i)+1;
            Optij(i,j) = opt;
        else
            % Caso o método não execute o problema
            Tij(i,j) = Inf;
            Sij(i,j) = Inf;
            Optij(i,j) = Inf;
        end
        dij(i,j) = norm (x1-xijStar(j,:))/epsilonx + norm((Optij(i,j)-OtStar(j)),1)/epsilonS;
    end
end

clc;

%-------------------------------------------%
% Eficácia (theta)
theta = zeros(1,iFinal);
TjStar = min(Tij,[],2);
for i=1:iFinal
    t = 0;
    for j=1:jFinal
        sum1 = TjStar(i)/Tij(i,j);
        t = t+sum1;
    end
    theta(i) = (100/jFinal)*t;
end

%-------------------------------------------%
% Eficiência (chi)
chi = zeros(1,iFinal);
SjStar = min(Sij,[],2);
for i=1:iFinal
    t = 0;
    for j=1:jFinal
        sum2 = + SjStar(i)/Sij(i,j);
        t = t+sum2;
    end
    chi(i) = (100/jFinal)*t;
end

%-------------------------------------------%
% Robustez (eta)
eta = zeros(1,iFinal);
for i=1:iFinal
    eta(i) = 100*(sum(Ni(i))/jFinal);
end

%-------------------------------------------%
% Qualidade da solução obtida (xi)
xi = zeros(1,iFinal);
djStar = min(dij,[],2);
for i=1:iFinal
    t = 0;
    for j=1:jFinal
        sum3 = + (djStar(i)+epsilon)/(dij(i,j)+epsilon);
        t = t+sum3;
    end
    xi(i) = (100/jFinal)*t;
end


%-------------------------------------------%
% Métrica para o melhor método
total = zeros(1,iFinal);
for i=1:iFinal
    total(i) = theta(i)+chi(i)+eta(i)+xi(i);
end

disp(theta)
disp(chi)
disp(eta)
disp(xi)
disp(total)


