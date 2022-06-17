function audio_denoise=spectral_subtraction (audio)
    L=length(audio);
    audio_denoise = zeros(1,L);
    N = 100;
    noise_spectrum = zeros(1,100);
    %figure;
    %t=1/fs:1/fs:L/fs;
    %plot(t,audio)
    lambda=0.8;
    % run 20000 frame (450ms) to estimate noise spectral
    past=0;
    for i = 1 : 1000
        buffer= audio (N*(i-1)+1:N*i);
        %buffer = audio(i:i+N-1).*win;
        %noise_spectrum=noise_spectrum+abs(fft(buffer)).';
        noise_spectrum=noise_spectrum+(1-lambda)*abs(fft(buffer)).'+lambda*past; 
        past=abs(fft(buffer)).';
    end
    noise_spectrum=noise_spectrum/1000 ; 
    
   
    %% ==== spectral subtraction ==============================================
    for i = 1 : L/N
        buffer = audio(1+(i-1)*N:i*N);
        Y_spectrum=fft(buffer).';
        phase = angle(Y_spectrum);
        X_spectrum=abs(fft(buffer)).' - noise_spectrum ;
        x=ifft(X_spectrum.*cos(phase)+i.*X_spectrum.*sin(phase));
        audio_denoise(1+(i-1)*N:i*N)=real(x);
    end
    %figure;
    %t=1/fs:1/fs:L/fs;
    %plot(t,audio_denoise)
end 