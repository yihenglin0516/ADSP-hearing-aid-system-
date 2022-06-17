%% VAD
%% ==== read audio ========================================================
clear;
[audio,fs ]=audioread("voice_test.wav");
L=length(audio);
N = 100;  % 100 samples per frame 
VAD = voiceActivityDetector;
isVoice=zeros(1,round(L/N));
for i = 1 : L/N
    buffer = audio(1+(i-1)*N:i*N);
    probability=VAD(buffer );
    isVoice(i) = probability >0.9  ; 
end 
isVoice = reshape(isVoice .* ones(1,100).', 1,[] ) ;
t = 1/fs:1/fs:length(isVoice)/fs;
plot(t,isVoice)
title("VAD result of test case without loud noise ")
