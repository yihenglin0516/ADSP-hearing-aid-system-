function y = freq_shaping (audio,fs) 
    % frequency shaping
    l=length(audio);
    N=2^nextpow2(length(audio));
    gain = zeros (1 , N) ; 
    X=fft(audio,N).';
    % ==== first stage ========================================================
    first = 1000 ;
    k1=0;
    k2=floor(( (first-1) * N + (fs-first) ) / (fs-1));
    g=50;
    T=1/fs;
    firstC= .3*(g-1)/first ;
    gain(k1+1:k2)=firstC*(k1+1:1:k2)/(N*T)+1;
    gain(N-k2+1:N-k1)=firstC*(k1+1:1:k2)/(N*T)+1;
    k1=k2;
    % ==== second stage =======================================================
    second=1500;
    secondC = firstC * first+1  ;
    secondC2 = (second-first) / 5 ;
    k2 = floor(( (second-1) * N + (fs-second) ) / (fs-1));
    gain(k1+1:k2)= 1 + (secondC-1) .*exp(-(((k1+1:1:k2)/(N*T))-first)/secondC2);
    gain(N-k2+1:N-k1)= 1 + (secondC-1)*exp(-(((k1+1:1:k2)/(N*T))-first)/secondC2);
    k1=k2;
    % ==== third stage ========================================================
    third = 2550; 
    k2 = floor(( (third-1) * N + (fs-third) ) / (fs-1));
    thirdC = 1 + (secondC-1)*exp(-second/secondC2); 
    thirdC2=(third-second)/5;
    gain(k1+1:k2)=g + (thirdC-g)*exp(-(((k1+1:1:k2)/(N*T)-second))/thirdC2);
    gain(N-k2+1:N-k1)=g + (thirdC-g).*exp(-(((k1+1:k2)/(N*T)-second))/thirdC2);
    k1=k2;
    
    % ==== fourth stage =======================================================
    fourth=5000;
    k2 = floor(( (fourth-1) * N + (fs-fourth) ) / (fs-1));
    gain(k1+1:k2)=g;
    gain(N-k2+1:N-k1)=g;
    k1=k2;
    % === fifth stage =========================================================
    fifthC = g ;
    k2=floor(N/2);
    fifthC2 = (fs/2-fourth)/5;
    gain(k1+1:k2) = 1 + (fifthC-1)*exp(-(((k1+1:k2)./(N*T))-fourth)/fifthC2);
    gain(N-k2+1:N-k1) = 1 + (fifthC-1)*exp(-(((k1+1:k2)./(N*T))-fourth)/fifthC2);
    Y = X.*gain; 
    y = real(ifft(Y,N));
    y= y (1:l);
end 