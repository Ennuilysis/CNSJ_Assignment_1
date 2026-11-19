function CNSJ1204_Assignment1_template
%for Matlab beginners, note that %indicates comments and text/functions
%following the symbol are not evaluated 

%part 1: spectra from continuous data
%task 1.1: estimate and plot the power spectra for eyes closed and open conditions
%task 1.2: test how varying the parameters of spectral estimation influence
%the estimates
%task 1.3: evaluate how robust the observed phenomena are within the data,
%i.e., whether they prevail across the whole recording

%first, load the data
load spont_data.mat;
%the mat-file contains the following
%ec_data: data from eyes closed condition, number of channels x time points
%eo_data: data from eyes open condition, number of channels x time points
%there is 62 seconds of data in both conditions, sampled at 600Hz (variable
%sff)
%variable channs gives the channel names of the 16 MEG channels

%hints for the analysis
%1.spectral estimation can be done with the function pwelch
%[Pxx,F] = pwelch(X,WINDOW,NOVERLAP,NFFT,Fs)
%where X is the data, window the window find function, noverlap the amount
%of overlap between consecutive windows, nfft is te fft-size, and Fs the
%sampling freuqnecy
%e.g. [Pxx,F] = pwelch(ec_data',hanning(1024),1024/2,1024,sff)
%note that for matrix data (multiple channels) the first dimension of the
%data is time. Hence, the MEG data are frist transposed with '
%help with matlab-function are obtained with the help command, e.g. help pwlech 
%2. for visualization, the spectra from different channels can be
%considered individually or averaged (with function: mean)
%3. the parameters that are typically varied are the fft-size (1024 inthe example) and the
%windowing function (hanning in the example)
%4. continuous segments of data can be selected in Matlab by defining a
%range with the help of : (e.g., data_short=data_ec(:,1:10000]) would take
%the first 10000 samples of the data). Here the first : indicates selecting
%all MEG channels. For individual channels replace it with a number between
%1 and 16
%5. for visualization with the function plot the first input parameter is the
%frequency (F). For plotting multiple spectra to the same plot, 
%the current plot should be held after plotting the first spectra (command
%hold). The plot-function allows disticnt visualization of different spectra
%by changing either the color or style of the plots.
%After visualizing the spectra, the inspected frequency range can be
%restricted by setting X-axis limits with the set command
%(e.g.: set(gca,'xlim',[1 20])

%part 2: evoked responses from event-related:data
%task 2.1: compute and plot the evoked responses from event-related
%data for sound played to the left and right eye. Do you see the expected
%effects? That is, sound played to left ear lead to a faster response in
%the right auditory cortex and vice versa
%task 2.2: The data contains 175 trials/repetitions of both sounds. How
%many trials do you need to observe the effects? Are the effects the same
%across the trials or are there differences between trials across the
%experiment (e.g. the first 50 or the last 50 trials
%task 2.3 (bonus): both filtered and unfiltered data are given. Tasks 2.1
%and 2.2 can be done with filtered data (60Hz low pass-filter), but you can
%also test different filtering schemes (see e.g. functions butter and
%filtfilt)) to see how they indluece the outcome.

%first, load the data
load evoked_data.mat;

%data (data_sound_left/data_sound_right and data_sound_left_filtered/data_sound_right_filtered) for both sound played to left
%and right ears at in the form:
%2 x 175 x 901
%where the first dimension indicates different MEG channels, the second
%different trials and the third different time points
%time instanses are given in the variable timess (in milliseconds)
%channel names are given in variables chann1 and chann2
%note, chann1 (=first row of the MEG data) is over left auditory cortex, 
%chann2(=second row of the MEG data) right

%hints for the analysis
%1. you can also see for the individual trials look like, but for this data
%averaging is necessary to observed the effects of interest
%2. the averaging is straigforward enough with the function mean. But note
%that each dimension (channels, trials, times) is "full" meaning that it is
%critical to do the averaging across the right dimension
%e.g.: data_mean=mean(data_sound_left_filtered,1) would average the data
%across the first dimension which is channels
%3. when plotting the data , it is useful to manually select individual
%channels so that the color of the curves can be determined. Also, the plot
%function does not accept multiple dimension, so the singleton dimensions that are
%either averaged away or from which parts (one channel) are selected must
%be removed with the command squeeze
%e.g. data_mean_squeezed=squeeze(data_mean) would change the data from
%1x175x901 to 175x901
%4. the selction of trials and limitin the visualized time interval can be
%done as for the spectral estiamtion (: for interval selection, set for
%setting the X-axis limits. Also remembed to hold the plots for overlaying
%two (or multiple) response types in the same plot
%a meaningful time interval can be set with e.g. set(gca,'xlim',[-20 150]);

