    Tab = readtable('D:\Blood Presure\Data File\Raw Data\ID85-93.csv','HeaderLines',3); 
    Data=Tab(:,3:7);
    Data=table2array(Data);
    Data(isnan(Data(:,1)))=0;
    Data(isnan(Data(:,2)))=0;
    PPG=Data(:,1:2);
    Data=(PPG(:,1));
    fs=100; 
    Data=Data(10*fs:end);
    figure
    t=0:1/fs:length(Data)/fs-1/fs;
    plot(t,Data,'b');
    title('Original PPG');
    grid on
    %% Removing Noise
    lw=0.2;
    hw=5;
    w1=lw/(fs/2);
    w2=hw/(fs/2);
    [b,a]=butter(2,[w1,w2]);
    filteredData=filtfilt(b,a,Data);
    filteredData=filteredData+max(Data)-max(filteredData);
    t=0:1/fs:length(filteredData)/fs-1/fs;
    figure
    plot(t,filteredData,'m')
    title('filteredPPG');
    grid on
%% Removing Motion Artifact
% % diffData=diff(filteredData);
% % avgDiffData=mean(abs(diffData));
% % filteredData(abs(diffData)>2*avgDiffData)=[];
% % [filteredData,TF] = rmoutliers(filteredData);  
% % filteredData=rmoutliers(filteredData);
% %filteredData=rmoutliers(filteredData);
% peakMed=median(findpeaks(filteredData));
% [values,~]=findvalleys(filteredData);
% valleyMed=median(values);
% filteredData(filteredData>peakMed+(peakMed-valleyMed))=[];
% filteredData(filteredData<valleyMed-(peakMed-valleyMed))=[];
% %     filteredData(filteredData(:)>mean(filteredData)+1500)=[];
% %     filteredData(filteredData(:)<mean(filteredData)-1500)=[];
%      t=0:1/fs:length(filteredData)/fs-1/fs;
%      figure
%      plot(t,filteredData);
%      title('Motion Removal');
%      grid on

%% Windowing
% [pks,locs]=findpeaks(filteredData);
% [Pk,ind]=max(pks);

%% Reflection
    invertedData = -1*filteredData;
    invertedData=invertedData+abs(min(invertedData));
    figure
    plot(0:1/fs:length(invertedData)/fs-1/fs,invertedData)
%% Remove Baseline
    invertedData2= max(invertedData) - invertedData;
    [valleyValues, indexes] = findpeaks(invertedData2,'MinPeakProminence',1000);
    l=length(indexes);
    t=0:1/fs:length(invertedData)/fs-1/fs;
    y=interp1(t(indexes),valleyValues',t);
    figure
    plot(t,invertedData,'c');
    title('Inverted PPG');
    grid on
    hold on 
    valleys=max(y)-y;
    plot(t,valleys);
    hold off
    figure
    newData=invertedData'- valleys;
    newData=newData(indexes(1):indexes(end));
    t=0:1/fs:length(newData)/fs-1/fs;
    plot(t,newData);
    
% % % end
% %     
