function [rouEQTA, EQTzA] = SolverM(ave_fxQC,zCQ,sum_dens,ddz,AA, kb,T) 
%--- linear solver to solve for density -----
    id = find(ave_fxQC);
    EQTfxA = ave_fxQC(id(1)-2:id(end)+2);
    EQTfxA1 = - EQTfxA;
    EQTfxAF = [EQTfxA(1:end/2);EQTfxA1(end/2+1:end)];

    EQTzA = zCQ(id(1)-2:id(end)+2);
    % EQTfxA = ave_fxQC;
    % EQTzA = zCQ;
    EQTfxL = EQTfxA(1:end/2);
    [fxM ,idfm] =  max(EQTfxL);
    EQTfxL(1:idfm) = fxM;
    % sfxL = EQTfxL(end/2:end);
    % sfxL1 = movmean(sfxL,3);
    % EQTfxL(end/2:end) = sfxL1;
    EQTfxR = EQTfxA(end/2+1:end);
    EQTfxR = flipud(EQTfxR);
    [fxRM ,idRfm] =  max(EQTfxR);
    EQTfxR(1:idRfm) = fxRM;
    EQTzL = EQTzA(1:end/2);
    EQTzR = EQTzA(end/2:end);
    NN = length(EQTfxL(:));
    NNa = length(EQTfxA);
    vecB = zeros(NNa,1);
    coeM = zeros(NNa,NNa);
    vecBL(1,1) = sum_dens/2 ;
    vecBR(1,1) = sum_dens/2 ;

    vecB(1,1) = sum_dens/ddz;
    coeM(1,2:end) = 1;
    coeM(2:end,1) = 1;
    for i = 2:NNa
            if(i==2)
                coeM(i,i) = AA;
                coeM(i,i+1) = - ( AA/2 - EQTfxAF(i+1)/(2*kb*T*ddz)); %B
            end

            if(i<NNa&&i>2)
                coeM(i,i) = AA;
                coeM(i,i-1) = -( AA/2 + EQTfxAF(i-1)/(2*kb*T*ddz)); %C
                coeM(i,i+1) = - ( AA/2 - EQTfxAF(i+1)/(2*kb*T*ddz)); %B
            end
            if(i==NNa)
                coeM(i,i) = AA;
                coeM(i,i-1) = -( AA/2 + EQTfxAF(i-1)/(2*kb*T*ddz));
            end
    end

    rouEQTA = linsolve(coeM,vecB);