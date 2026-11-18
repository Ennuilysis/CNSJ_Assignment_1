function CNSJ1204_Assignment1_template
tic
load spont_data.mat;
%the mat-file contains the following
%ec_data: data from eyes closed condition, number of channels x time points
%eo_data: data from eyes open condition, number of channels x time points
%there is 62 seconds of data in both conditions, sampled at 600Hz (variable
%Sampling_R)
%variable channs gives the channel names of the 16 MEG channels
Sampling_R=600;
Trial_Time=62;%seconds;
disp('data loaded')

% part 1: spectra from continuous data
% Ok. Here, I want to first plot the original data, the power spectra, and get some statistics on the data.
% The professor said that I should use welches method, or pwelch
% task 1.1: estimate and plot the power spectra for eyes closed and open
% conditions.

power_section=[1,20];
ec_v_eo={ec_data, eo_data};
figure('Visible', 'off','units','pixels','Position',[300, 100, 5000, 3200],Color=[1 0.5 0]);
% I want it all.
WINDOW=dictionary();

window_len=1024;
for X ={'periodic','symmetric'}
    WINDOW("Hanning "+X{:}) = {hanning(window_len,X{:})};
    WINDOW("Blackman "+X{:}) = {blackman(window_len,X{:})};
    WINDOW("Hamming "+X{:}) = {hamming(window_len,X{:})};
end

WINDOW("Triang") = {triang(window_len)};
WINDOW("Kaiser") = {kaiser(window_len)};
WINDOW("Chebwin") = {chebwin(window_len)};
WINDOW("Rectwin") = {rectwin(window_len)};
WINDOW("Bartlett") = {bartlett(window_len)};
NOVERLAP = 1024/2;
NFFT = 1024;
Fs=Sampling_R;
titles=["ec","eo"];


window_keys=keys(WINDOW);
if ~isfile("1-1_ec_v_eo_v_window.svg")
    tiledlayout(4,length(WINDOW.keys),'TileSpacing','loose', ...
        'Padding', 'compact');
    for X = 1:length(ec_v_eo)
        Data=ec_v_eo{X};
        for Y = 1:length(WINDOW.keys)
            Key=window_keys(Y);
            window=WINDOW(Key);
            [Pxx,F] = pwelch(Data',window{:},NOVERLAP,NFFT,Fs);
            nexttile
            plot(F,Pxx)
            title(Key+" "+titles(X).upper)
            xlim(power_section)
            xlabel("Hz")
        end
    end
    LEG=legend("Ch "+[1:min(size(Data))]);
    LEG.Layout.Tile='east';
    for Y = 1:length(WINDOW.keys)
        Key=window_keys(Y);
        dea=WINDOW(Key);
        nexttile
        plot(dea{:})
        title(Key)
    end
    saveas(gcf,"1-1_ec_v_eo_v_window",'svg')
    close
end

if ~isfile("1-1_ec_diff_eo_v_windows.svg")
    figure('Visible', 'off','units','pixels','Position',[300, 100, 2000, 1000],Color=[1 0.5 0]);
    % Lets see how the difference is represented in raw data.
    Data=abs(ec_v_eo{1}-ec_v_eo{2});
    for Y = 1:length(WINDOW.keys)
        Key=window_keys(Y);
        window=WINDOW(Key);
        [Pxx,F] = pwelch(Data',window{:},NOVERLAP,NFFT,Fs);
        nexttile
        plot(F,Pxx)
        title(Key+" ")
        xlim(power_section)
        xlabel("Hz")
    end
    saveas(gcf,"1-1_ec_diff_eo_v_windows",'svg')
    close
end

if ~isfile("1-1_diff_v_windows.svg")
    figure('Visible', 'off','units','pixels','Position',[300, 100, 2000, 1000],Color=[1 0.5 0]);
    for Y = 1:length(WINDOW.keys)
        Key=window_keys(Y);
        window=WINDOW(Key);
        [Pxx1,F1] = pwelch(ec_v_eo{1}',window{:},NOVERLAP,NFFT,Fs);
        [Pxx2,F2] = pwelch(ec_v_eo{2}',window{:},NOVERLAP,NFFT,Fs);
        disp(F1==F2)
        Pxx=abs(Pxx1-Pxx2);
        nexttile
        plot(F,Pxx)
        title(Key+" ")
        xlim(power_section)
        xlabel("Hz")
        LEG=legend("Ch "+[1:min(size(Data))]);
        LEG.Layout.Tile='east';
    end
    saveas(gcf,"1-1_diff_v_windows",'svg')
    close
end
disp("Completed 1.1 "+toc)
%%
% task 1.2: test how varying the parameters of spectral estimation influence
% the estimates


power_section=[1,20];
for Z = 2:5
    FIG=figure('Visible', 'off','units','pixels','Position',[300, 100, 2000, 800],Color=[1 0 0.5]);
    tiledlayout(3,2)
    if ~isfile("1_2_NOVERLAP_div_"+Z+".svg")
        for Y=["Hanning symmetric","Rectwin","Kaiser"]
            This_Window = WINDOW(Y);
            for X = 1:2
                nexttile
                Data=ec_v_eo{X};
                NOVERLAP = int32(1024/Z);
                NFFT = 1024; %number of discrete fourier transforms
                Fs=Sampling_R;
                [Pxx,F] = pwelch(Data',This_Window{:},NOVERLAP,NFFT,Fs);
                plot(F,Pxx)
                title(Y + X)
                hold on
                xlim(power_section)
                hold off
            end
            LEG=legend("Ch "+[1:min(size(Data))]);
            LEG.Layout.Tile='east';
        end
        saveas(FIG,"1_2_NOVERLAP_div_"+Z,'svg')
        clf
        close
    end
end

for Z = 1:5
    FIG=figure('Visible', 'off','units','pixels','Position',[300, 100, 2000, 800],Color=[0.5 0 0.5]);
    tiledlayout(3,3)
    if ~isfile("1_2_NFFT_div_"+Z+".svg")
        for Y=["Hanning symmetric","Rectwin","Kaiser"]
            This_Window = WINDOW(Y);
            for X = 1:2
                nexttile
                Data=ec_v_eo{X};
                NOVERLAP = 1024/2;
                NFFT = int32(1024/Z); %number of discrete fourier transforms
                Fs=Sampling_R;
                [Pxx,F] = pwelch(Data',This_Window{:},NOVERLAP,NFFT,Fs);
                plot(F,Pxx)
                title(Y + X)
                hold on
                xlim(power_section)
                hold off
            end
            LEG=legend("Ch "+[1:min(size(Data))]);
            LEG.Layout.Tile='east';
        end
        saveas(FIG,"1_2_NFFT_div_"+Z,'svg')
        clf
        close
    end
end

for Z = 2:5
    FIG=figure('Visible', 'off','units','pixels','Position',[300, 100, 2000, 800],Color=[0.5 0 0.5]);
    tiledlayout(3,3)
    if ~isfile("1_2_Both_div_"+Z+".svg")
        for Y=["Hanning symmetric","Rectwin","Kaiser"]
            This_Window = WINDOW(Y);
            for X = 1:2
                nexttile
                Data=ec_v_eo{X};
                NOVERLAP = int32(1024/Z);
                NFFT = int32(1024/Z);
                Fs=Sampling_R;
                [Pxx,F] = pwelch(Data',This_Window{:},NOVERLAP,NFFT,Fs);
                plot(F,Pxx)
                hold on
                xlim(power_section)
                title(Y+X)
                hold off
            end
            LEG=legend("Ch "+[1:min(size(Data))]);
            LEG.Layout.Tile='east';
        end
        saveas(FIG,"1_2_Both_div_"+Z,'svg')
        clf
        close
    end
end

disp("Completed 1.2 "+toc)
%%
% task 1.3: evaluate how robust the observed phenomena are within the data,
% i.e., whether they prevail across the whole recording

%Notes: It would appear eyes closed has a significant detection threshold
%at 0.3 along certain channels. I think its best to find max, get back their
% values and times. Find out significant time differences and values. I
% think I will stick with hanning periodic and keiser, and compare outcomes.
%There is also obvious relational differences between channels, but lets
%keep it simpler. I dont have time to code more.

%NFFT/4 gives a good, clean signal expression. Simple.
%NOOverlap/4 gives sharp peaks, and cleaner difference between channels
%than /2.
%Combined, see 1_2_Both_div_4.svg, they give great, clean signaling.

%0. Normalize all the data after pwelch.
%   Zero all signal that is below a threshold after pwelch, as good principle.
%   Lets say drop anything below the mean value, for each individual channel.
%1. Get max values along each channel within the 20ms at start. EO v EC.
% What was their std distance from the original mean?
%2. Table the difference be e0 vs EC, of 



%The cross term divided by the power*power scale, indicate true
%significance.

%Lets see if its ergodic
X_Title=["EC","EO"];
Y_Title=["Kaiser","Hanning Symmetric"];
for Y=1:2
    for X = 1:2
        Data=ec_v_eo{X};
        This_Window=WINDOW(Y_Title(Y));
        NOVERLAP = 1024/4;
        NFFT = 1024/4;
        Fs=Sampling_R;
        [Pxx,F] = pwelch(Data',This_Window{:},NOVERLAP,NFFT,Fs);
        [Cxx,F]=mscohere(Data',Data',This_Window{:},NOVERLAP,NFFT,Fs);
        plot(Cxx,F)
        
        title(Y_Title(Y)+" "+X_Title(X)+" ")
        LEG=legend("Ch "+[1:min(size(Data))]);
        LEG.Layout.Tile='east';
        plot(F,Pxx)
    end
end

% where X is the data, window the windowfind function, noverlap the amount
% of overlap between consecutive windows, nfft is the fft-size, and Fs the
% sampling freuqnecy
% e.g. [Pxx,F] = pwelch(ec_data',hanning(1024),1024/2,1024,Sampling_R)
% note that for matrix data (multiple channels) the first dimension of the
% data is time. Hence, the MEG data are frist transposed with '
% help with matlab-function are obtained with the help command, e.g. help pwlech
% 2. for visualization, the spectra from different channels can be
% considered individually or averaged (with function: mean)
% 3. the parameters that are typically varied are the fft-size (1024 in the example) and the
% windowing function (hanning in the example)
% 4. continuous segments of data can be selected in Matlab by defining a
% range with the help of : (e.g., data_short=data_ec(:,1:10000]) would take
% the first 10000 samples of the data). Here the first : indicates selecting
% all MEG channels. For individual channels replace it with a number between
% 1 and 16
% 5. for visualization with the function plot the first input parameter is the
% frequency (F). For plotting multiple spectra to the same plot,
% the current plot should be held after plotting the first spectra (command
% hold). The plot-function allows disticnt visualization of different spectra
% by changing either the color or style of the plots.
% After visualizing the spectra, the inspected frequency range can be
% restricted by setting X-axis limits with the set command
% (e.g.: set(gca,'xlim',[1 20])

% part 2: evoked responses from event-related:data
% task 2.1: compute and plot the evoked responses from event-related
% data for sound played to the left and right eye. Do you see the expected
% effects? That is, sound played to left ear lead to a faster response in
% the right auditory cortex and vice versa
% task 2.2: The data contains 175 trials/repetitions of both sounds. How
% many trials do you need to observe the effects? Are the effects the same
% across the trials or are there differences between trials across the
% experiment (e.g. the first 50 or the last 50 trials
% task 2.3 (bonus): both filtered and unfiltered data are given. Tasks 2.1
% and 2.2 can be done with filtered data (60Hz low pass-filter), but you can
% also test different filtering schemes (see e.g. functions butter and
% filtfilt)) to see how they indluece the outcome.

% first, load the data
load evoked_data.mat;

% data (data_sound_left/data_sound_right and data_sound_left_filtered/data_sound_right_filtered) for both sound played to left
% and right ears at in the form:
% 2 x 175 x 901
% where the first dimension indicates different MEG channels, the second
% different trials and the third different time points
% time instanses are given in the variable timess (in milliseconds)
% channel names are given in variables chann1 and chann2
% note, chann1 (=first row of the MEG data) is over left auditory cortex,
% chann2(=second row of the MEG data) right

% hints for the analysis
% 1. you can also see for the individual trials look like, but for this data
% averaging is necessary to observed the effects of interest
% 2. the averaging is straigforward enough with the function mean. But note
% that each dimension (channels, trials, times) is "full" meaning that it is
% critical to do the averaging across the right dimension
% e.g.: data_mean=mean(data_sound_left_filtered,1) would average the data
% across the first dimension which is channels
% 3. when plotting the data , it is useful to manually select individual
% channels so that the color of the curves can be determined. Also, the plot
% function does not accept multiple dimension, so the singleton dimensions that are
% either averaged away or from which parts (one channel) are selected must
% be removed with the command squeeze
% e.g. data_mean_squeezed=squeeze(data_mean) would change the data from
% 1x175x901 to 175x901
% 4. the selction of trials and limitin the visualized time interval can be
% done as for the spectral estiamtion (: for interval selection, set for
% setting the X-axis limits. Also remembed to hold the plots for overlaying
% two (or multiple) response types in the same plot
% a meaningful time interval can be set with e.g. set(gca,'xlim',[-20 150]);
