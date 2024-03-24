function [EEG_happy, EEG_angry, EEG_sad] =  eeglab_EGI129_prepro (datapath, logpath)

     %read data into eeglab
     EEG = pop_fileio(datapath, 'dataformat','auto');
     EEG.setname='temp';
     EEG = eeg_checkset( EEG );
     
     % bandpass filter
     EEG = pop_eegfiltnew(EEG, 'locutoff',3,'hicutoff',34,'plotfreqz',1);
     EEG = eeg_checkset( EEG );

     % add electrode locations
     EEG=pop_chanedit(EEG, 'lookup','/Users/andreaskeil/matlab_as/eeglab2022.1/plugins/dipfit/standard_BEM/elec/standard_1005.elc');
     EEG = eeg_checkset( EEG );
    
     %read conditions from log file
      conditionvec= getcon_wurz(logpath);

      % now replace the triggers with the actual events
      counter =1; 
      for x = 1:size(EEG.event,2)
          if strcmp(EEG.event(x).type, 'DIN4'), EEG.event(x).type = num2str(conditionvec(counter)); 
              counter = counter+1; 
          end
      end

     % happy
     EEG_happy = pop_epoch( EEG, {  '1'  }, [-0.4 10], 'newname', 't epochs', 'epochinfo', 'yes');
     EEG_happy = eeg_checkset( EEG_happy );
     EEG_happy = pop_rmbase( EEG_happy, [-600 0] ,[]);
     EEG_happy = eeg_checkset( EEG_happy );
     EEG_happy = pop_autorej(EEG_happy, 'nogui','on','threshold',500,'electrodes',[1:31] ,'eegplot','on');
     EEG_happy = eeg_checkset( EEG_happy );
     EEG_happy = pop_rejepoch( EEG_happy, 13,0);
     
     % angry
     EEG_angry = pop_epoch( EEG, {  '2'  }, [-0.4 10], 'newname', 't epochs', 'epochinfo', 'yes');
     EEG_angry = eeg_checkset( EEG_angry );
     EEG_angry = pop_rmbase( EEG_angry, [-600 0] ,[]);
     EEG_angry = eeg_checkset( EEG_angry );
     EEG_angry = pop_autorej(EEG_angry, 'nogui','on','threshold',500,'electrodes',[1:31] ,'eegplot','on');
     EEG_angry = eeg_checkset( EEG_angry );
     EEG_angry = pop_rejepoch( EEG_angry, 13,0);
     
     % sad
     EEG_sad = pop_epoch( EEG, {  '3'  }, [-0.4 10], 'newname', 't epochs', 'epochinfo', 'yes');
     EEG_sad = eeg_checkset( EEG_sad );
     EEG_sad = pop_rmbase( EEG_sad, [-600 0] ,[]);
     EEG_sad = eeg_checkset( EEG_sad );
     EEG_sad = pop_autorej(EEG_sad, 'nogui','on','threshold',500,'electrodes',[1:31] ,'eegplot','on');
     EEG_sad = eeg_checkset( EEG_sad );
     EEG_sad = pop_rejepoch( EEG_sad, 13,0);

     save([logpath(1:end-4) '.cleaneeg.mat'],  'EEG_angry', 'EEG_sad', 'EEG_happy', '-mat')
