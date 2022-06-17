%% main 
[audio,fs ]=audioread("voice_test.wav");
audio_denoise = spectral_subtraction(audio);
y = freq_shaping (audio_denoise.',fs);

sound(y/4,fs) % divide by 4 to lower the sound 
