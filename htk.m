% HTK-TIMIT Phone Recognition
% Tae-Jin Yoon
% tyoon@uvic.ca
% 
% The script is taken from somewhere on the web, which is now defunct.
% I modified the script to run on my Windows Vista computer.
% So, to run this you need to have a TIMIT corpus and need to change the
% configuration that are specific to my computer.
% I resampled the sampling rate of the TIMIT corpus to 16kHz.

htkdir = ['E:\htk\'];
homedir = ['E:\PhD\PhDWork\Mine\PhDRelatedIdea\timit\'];
traindir = ['E:\PhD\PhDWork\Mine\PhDRelatedIdea\timit\TIMIT\TRAIN\'];
testdir = ['E:\PhD\PhDWork\Mine\PhDRelatedIdea\timit\TIMIT\TEST\'];


eval(['!']);
eval(['!mkdir label']);
eval(['!mkdir mfcc']);
eval(['!mkdir model']);

for i=0:23
    eval(['!mkdir model\hmm', num2str(i)])
end


%% Make a gram file and rune HParse
disp('make a gram file');

fid = fopen('gram', 'w');
fprintf(fid, '%s\n', ['$beginend = h#;']);
fprintf(fid, '%s', ['$phone = bcl | b | dcl | d | gcl | g | pcl | p | tcl | t | kcl | k | ']);
fprintf(fid, '%s', ['dx | q | jh | ch | s | sh | z | zh | f | th | v | dh | m | n | ng | em | en | eng | ']);
fprintf(fid, '%s', ['nx | l | r | w | y | hh | hv | el | ']);
fprintf(fid, '%s', ['iy | ih | eh | ey | ae | aa | aw | ay | ah | ao | oy | ow | ']);
fprintf(fid, '%s\n', ['uh | uw | ux | er | ax | ix | axr | ax-h | pau | epi;']);
fprintf(fid, '%s\n', ['($beginend <$phone> $beginend)']);
fclose(fid);

%input('Press enter to continue');
eval(['!E:\htk\HParse.exe -T 1 gram wdnet']);

disp('Make a monophones0 file. The file contains phone symobls');

fid = fopen('monophones0', 'w');
    fprintf(fid, '%s\n', 'b');
    fprintf(fid, '%s\n', 'd');
    fprintf(fid, '%s\n', 'g');
    fprintf(fid, '%s\n', 'p');
    fprintf(fid, '%s\n', 't');
    fprintf(fid, '%s\n', 'k');
    fprintf(fid, '%s\n', 'dx');
    fprintf(fid, '%s\n', 'q');
    fprintf(fid, '%s\n', 'jh');
    fprintf(fid, '%s\n', 'ch');
    fprintf(fid, '%s\n', 's');
    fprintf(fid, '%s\n', 'sh');
    fprintf(fid, '%s\n', 'z');
    fprintf(fid, '%s\n', 'zh');
    fprintf(fid, '%s\n', 'f');
    fprintf(fid, '%s\n', 'th');
    fprintf(fid, '%s\n', 'v');
    fprintf(fid, '%s\n', 'dh');
    fprintf(fid, '%s\n', 'm');
    fprintf(fid, '%s\n', 'n');
    fprintf(fid, '%s\n', 'ng');
    fprintf(fid, '%s\n', 'em');
    fprintf(fid, '%s\n', 'en');
    fprintf(fid, '%s\n', 'eng');
    fprintf(fid, '%s\n', 'nx');
    fprintf(fid, '%s\n', 'l');
    fprintf(fid, '%s\n', 'r');
    fprintf(fid, '%s\n', 'w');
    fprintf(fid, '%s\n', 'y');
    fprintf(fid, '%s\n', 'hh');
    fprintf(fid, '%s\n', 'hv');
    fprintf(fid, '%s\n', 'el');
    fprintf(fid, '%s\n', 'iy');
    fprintf(fid, '%s\n', 'ih');
    fprintf(fid, '%s\n', 'eh');
    fprintf(fid, '%s\n', 'ey');
    fprintf(fid, '%s\n', 'ae');
    fprintf(fid, '%s\n', 'aa');
    fprintf(fid, '%s\n', 'aw');
    fprintf(fid, '%s\n', 'ay');
    fprintf(fid, '%s\n', 'ah');
    fprintf(fid, '%s\n', 'ao');
    fprintf(fid, '%s\n', 'oy');
    fprintf(fid, '%s\n', 'ow');
    fprintf(fid, '%s\n', 'uh');
    fprintf(fid, '%s\n', 'uw');
    fprintf(fid, '%s\n', 'ux');
    fprintf(fid, '%s\n', 'er');
    fprintf(fid, '%s\n', 'ax');
    fprintf(fid, '%s\n', 'ix');
    fprintf(fid, '%s\n', 'axr');
    fprintf(fid, '%s\n', 'ax-h');
    fprintf(fid, '%s\n', 'bcl');
    fprintf(fid, '%s\n', 'dcl');
    fprintf(fid, '%s\n', 'gcl');
    fprintf(fid, '%s\n', 'pcl');
    fprintf(fid, '%s\n', 'tcl');
    fprintf(fid, '%s\n', 'kcl');
    fprintf(fid, '%s\n', 'pau');
    fprintf(fid, '%s\n', 'epi');
    fprintf(fid, '%s\n', 'h#');
fclose(fid)


%% PREPARING TRAINING DATA %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid1 = fopen('codetr.scp', 'w');
fid2 = fopen('train.scp', 'w');
%fid3 = fopen('fname.praat', 'w');

for n0=1:8
    D = dir([traindir, 'DR', num2str(n0)]);
    for n1=3:size(D,1)
        D2 = dir([traindir, 'DR', num2str(n0),'\',D(n1).name,'\*.wav']);
        D3 = dir([traindir, 'DR', num2str(n0),'\',D(n1).name, '\*.phn']);
        for n2 = 1:size(D2,1)
            filename = [traindir, 'DR', num2str(n0), '\', D(n1).name, '\' D2(n2).name];
            
%             fprintf(fid3, '%s\n', ['Read from file... ', filename]);
%             fprintf(fid3, '%s\n', ['Write to WAV file... ', filename]);
%             fprintf(fid3, '%s\n', 'Remove');
             
            handdefname = [traindir, 'DR', num2str(n0), '\',D(n1).name, '\' D3(n2).name];
            
            newfname=D2(n2).name;
            newfname=[newfname(1:end-4) '_tr.mfc'];
            mfcfname = [homedir, 'mfcc\', 'DR', num2str(n0), '_', D(n1).name, '_', newfname];
            
            fprintf(fid1, '%s\n', [filename, ' ', mfcfname]);
            fprintf(fid2, '%s\n', mfcfname);
            
            newlname = D3(n2).name;
            newlname = [newlname(1:end-4) '_tr.lab'];
            labfname = [homedir, 'label\', 'DR', num2str(n0), '_', D(n1).name, '_', newlname];
            
            eval(['!copy ', handdefname, ' ', labfname]);
            
        end
        
    end
end
fclose(fid1);
fclose(fid2);
% fclose(fid3);

disp('The original TIMIT wav files need to be converted to MSWAVE file format');
disp('Make a praat script');
input('Press enter to continue');

%% PREPARE TIMIT configuration file & run HCopy

fid = fopen('configTIMIT', 'w');
fprintf(fid, '%s\n', ['SOURCEKIND = WAVEFORM']);
fprintf(fid, '%s\n', ['SOURCEFORMAT = WAV']);
fprintf(fid, '%s\n', ['SOURCERATE = 625']);
fprintf(fid, '%s\n', ['TARGETKIND = MFCC_0_D_A']);
fprintf(fid, '%s\n', ['TARGETRATE = 100000.0']);
fprintf(fid, '%s\n', ['WINDOWSIZE = 250000.0']);
fprintf(fid, '%s\n', ['USEHAMMING = T']);
fprintf(fid, '%s\n', ['PREEMCOEF = 0.97']);
fprintf(fid, '%s\n', ['NUMCHANS = 20']);
fprintf(fid, '%s\n', ['CEPLIFTER = 22']);
fprintf(fid, '%s\n', ['NUMCEPS = 12']);
fclose(fid);

eval(['!E:\htk\HCopy.exe -T 1 -C configTIMIT -S codetr.scp']);


%% PREPARING TESTING DATA %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid1 = fopen('codete.scp', 'w');
fid2 = fopen('test.scp', 'w');
%fid3 = fopen('test.praat', 'w');

for n0 = 1:8

    D = dir([testdir, 'DR', num2str(n0)]);
    for n1 = 3:size(D, 1)
      
        D2 = dir([testdir, 'DR', num2str(n0), '\', D(n1).name, '\*.wav']);
        D3 = dir([testdir, 'DR', num2str(n0), '\', D(n1).name, '\*.phn']);
        
        %#%disp(D2(n1).name);
        for n2 = 1:size(D2, 1)
            filename=[testdir, 'DR', num2str(n0), '\', D(n1).name, '\' D2(n2).name];
            
%             fprintf(fid3, '%s\n', ['Read from file... ', filename]);
%             fprintf(fid3, '%s\n', ['Write to WAV file... ', filename]);
%             fprintf(fid3, '%s\n', 'Remove');

            handdefname = [testdir, 'DR', num2str(n0), '\', D(n1).name, '\' D3(n2).name];
            
            newfname = D2(n2).name;
            newfname=[newfname(1:end-4) '_te.mfc'];
            mfcfname = [homedir, 'mfcc\', 'DR', num2str(n0), '_', D(n1).name, '_', newfname];
            
            fprintf(fid1, '%s\n', [filename, ' ', mfcfname]);
            fprintf(fid2, '%s\n', mfcfname);
            
            newlname = D3(n2).name;
            newlname = [newlname(1:end-4) '_te.lab'];
            labfname = [homedir, 'label\', 'DR', num2str(n0), '_', D(n1).name, '_', newlname];
            
            eval(['!copy ', handdefname, ' ', labfname]);
        end
    end
end

fclose(fid1);
fclose(fid2);
% fclose(fid3);

eval(['!E:\htk\HCopy.exe -T 1 -C configTIMIT -S codete.scp']);

%% PREPARE configuration file
fid = fopen('config', 'w');
fprintf(fid, '%s\n', ['TARGETKIND = MFCC_0_D_A']);
fprintf(fid, '%s\n', ['TARGETRATE = 100000.0']);
fprintf(fid, '%s\n', ['WINDOWSIZE = 250000.0']);
fprintf(fid, '%s\n', ['USEHAMMING = T']);
fprintf(fid, '%s\n', ['PREEMCOEF = 0.97']);
fprintf(fid, '%s\n', ['NUMCHANS = 20']);
fprintf(fid, '%s\n', ['CEPLIFTER = 22']);
fprintf(fid, '%s\n', ['NUMCEPS = 12']);
fclose(fid)



disp('Make proto file');

fid = fopen('proto', 'w');
    fprintf(fid, '%s\n', ['~o <VecSize> 39 <MFCC_0_D_A>']);
    fprintf(fid, '%s\n', ['~h "proto"']);
    fprintf(fid, '%s\n', ['<BeginHMM>']);
    fprintf(fid, '\t%s\n', ['<NumStates> 5']);
    fprintf(fid, '\t%s\n', ['<State> 2']);
    fprintf(fid, '\t\t%s\n', ['<Mean> 39']);
    fprintf(fid, '\t\t\t%s\n', ['0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0']);
    fprintf(fid, '\t\t%s\n', ['<Variance> 39']);
    fprintf(fid, '\t\t\t%s\n', ['1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1']);
    fprintf(fid, '\t%s\n', ['<State> 3']);
    fprintf(fid, '\t\t%s\n', ['<Mean> 39']);
    fprintf(fid, '\t\t\t%s\n', ['0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0']);
    fprintf(fid, '\t\t%s\n', ['<Variance> 39']);
    fprintf(fid, '\t\t\t%s\n', ['1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1']);
    fprintf(fid, '\t%s\n', ['<State> 4']);
    fprintf(fid, '\t\t%s\n', ['<Mean> 39']);
    fprintf(fid, '\t\t\t%s\n', ['0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0']);
    fprintf(fid, '\t\t%s\n', ['<Variance> 39']);
    fprintf(fid, '\t\t\t%s\n', ['1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1']);
    fprintf(fid, '\t%s\n', ['<TransP> 5']);
    fprintf(fid, '\t\t%s\n', ['0 1 0 0 0']);
    fprintf(fid, '\t\t%s\n', ['0 0.6 0.4 0 0']);
    fprintf(fid, '\t\t%s\n', ['0 0 0.6 0.4 0']);
    fprintf(fid, '\t\t%s\n', ['0 0 0 0.7 0.3']);
    fprintf(fid, '\t\t%s\n', ['0 0 0 0 0']);    
    fprintf(fid, '%s\n', ['<EndHMM>']);
fclose(fid)

eval(['!E:\htk\HCompV.exe -T 1 -C config -f 0.01 -m -S train.scp -M model/hmm0 proto']);

fid = fopen('model/hmm0/proto', 'r');
F = fread(fid);
S = char(F');
SHMM = S( strfind(upper(S), '<BEGINHMM>') :end);
S1st3 =S(1: strfind(S, '~h') -1);
fclose(fid);

fid = fopen('model/hmm0/vFloors', 'r');
F = fread(fid);
SvFloors = char(F');
fclose(fid);

fid = fopen('model/hmm0/macros', 'w');
fprintf(fid, S1st3);
fprintf(fid, SvFloors);
fclose(fid);

fid1 = fopen('monophones0', 'r');
fid2 = fopen('model/hmm0/hmmdefs', 'w');
fid3 = fopen('dict', 'w');
fid4 = fopen('monophones1', 'w');

while 1
    tline = fgetl(fid1);
    disp(tline);
    if ~ischar(tline)
        break;
    end
    
    fprintf(fid2, ['~h "', tline, '"\n']);
    fprintf(fid2, SHMM);
    fprintf(fid2, '\n');
    
    fprintf(fid3, [tline, ' ', tline, '\n']);
    
    fprintf(fid4, [tline, '\n']);
end

fprintf(fid4,['!ENTER\n']);
fprintf(fid4,['!EXIT\n']);

fprintf(fid3,['!ENTER []\n']);
fprintf(fid3,['!EXIT []\n']);

fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);

% input('Press enter to continue');


fid1=fopen('phones0.mlf','w');
fid3=fopen('HLStatslist','w');

fprintf(fid1,'%s\n',['#!MLF!#']);
D=dir(['label/*tr.lab']);
for n=1:size(D,1)
    fprintf(fid1,'%s\n',['"*/',D(n).name,'"']);
    fprintf(fid3,[D(n).name,'\n']);
    
    fid2=fopen(['label/',D(n).name],'r');
    while 1
        tline=fgetl(fid2); 
        if ~ischar(tline)
            break;
        end;
        if (tline(1)=='#')|(tline(1)=='"')
            fprintf(fid1,'%s\n',tline);
        else
            Tmat=sscanf(tline,'%d %d %s');
            Tstring=[char(Tmat(3:end))]';
            fprintf(fid1,'%s\n',Tstring);
        end
    end
    fprintf(fid1,'%s\n','.');
    fclose(fid2);
end
fprintf(fid1,'\n');
fclose(fid1);
fclose(fid3);

% input('Press enter to continue');

eval(['!E:\htk\HLStats.exe -T 1 -b bigfn -o -I phones0.mlf monophones0 -S HLStatslist']);
eval(['!E:\htk\HBuild.exe -T 1 -n bigfn monophones1 outLatFile']);

fid1 = fopen('testref.mlf','w');
fprintf(fid1, '%s\n', ['#!MLF!#']);
D = dir(['label/*te.lab']);
for n = 1:size(D, 1)
    fprintf(fid1, '%s\n', ['"*\', D(n).name, '"']);
    fid2 = fopen(['label\', D(n).name], 'r')
    while 1
        tline = fgetl(fid2);
        if ~ischar(tline)
            break;
        end
        if (tline(1) == '#') | (tline(1) == '"')
            fprintf(fid1, '%s\n', tline);
        else
            Tmat=sscanf(tline,'%d %d %s');
            Tstring=[char(Tmat(3:end))]';
            fprintf(fid1,'%s\n',Tstring);
        end
    end
    fprintf(fid1, '%s\n', '.');
    fclose(fid2);
end
fprintf(fid1, '\n');
fclose(fid1);


for i = 1:3
    eval(['!E:\htk\HERest.exe -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H model/hmm', num2str(i-1), '/macros -H model/hmm', num2str(i-1), '/hmmdefs -M model/hmm', num2str(i), ' monophones0']);
end


fid = fopen('sil.hed', 'w');
fprintf(fid, ['AT 2 4 0.2 {pau.transP}\n']);
fprintf(fid, ['AT 4 2 0.2 {pau.transP}\n']);
fprintf(fid, ['AT 2 4 0.2 {h#.transP}\n']);
fprintf(fid, ['AT 4 2 0.2 {h#.transP}\n']);
fclose(fid);

eval(['!E:\htk\HHEd.exe -T 1 -H model/hmm3/macros -H model/hmm3/hmmdefs -M model/hmm4 sil.hed monophones0']);


for i = 5:7
    eval(['!E:\htk\HERest -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H model/hmm', num2str(i-1), '/macros -H model/hmm', num2str(i-1), '/hmmdefs -M model/hmm', num2str(i), ' monophones0']);
end

fid = fopen('MU2.hed', 'w');
fprintf(fid, ['MU 2 {*.state[2-4].mix}\n']);
fclose(fid);

eval(['!E:\htk\HHEd.exe -T 1 -H model/hmm7/macros -H model/hmm7/hmmdefs -M model/hmm8 MU2.hed monophones0']);

for i=9:11
    eval(['!E:\htk\HERest -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H model/hmm',num2str(i-1),'/macros -H model/hmm',num2str(i-1),'/hmmdefs -M model/hmm',num2str(i),' monophones0']);
end

fid=fopen('MU4.hed','w');
fprintf(fid,['MU 4 {*.state[2-4].mix}\n']);
fclose(fid);

%input('Press enter to continue');
eval(['!E:\htk\HHEd.exe -T 1 -H model/hmm11/macros -H model/hmm11/hmmdefs -M model/hmm12 MU4.hed monophones0']);

% input('Press enter to continue');
 for i=13:15
     eval(['!E:\htk\HERest.exe -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H model/hmm',num2str(i-1),'/macros -H model/hmm',num2str(i-1),'/hmmdefs -M model/hmm',num2str(i),' monophones0']);
 end
 
fid=fopen('MU8.hed','w');
fprintf(fid,['MU 8 {*.state[2-4].mix}\n']);
fclose(fid);


eval(['!E:\htk\HHEd.exe -T 1 -H model/hmm15/macros -H model/hmm15/hmmdefs -M model/hmm16 MU8.hed monophones0']);

for i=17:23
    eval(['!E:\htk\HERest.exe -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H model/hmm',num2str(i-1),'/macros -H model/hmm',num2str(i-1),'/hmmdefs -M model/hmm',num2str(i),' monophones0']);
end


eval(['!E:\htk\HVite.exe -T 1 -H model/hmm23/macros -H model/hmm23/hmmdefs -S test.scp -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict monophones0']);
%input('Press enter to continue');
disp('With bigram language model:');
eval(['!E:\htk\HVite.exe -T 1 -H model/hmm23/macros -H model/hmm23/hmmdefs -S test.scp -i recout_bigram.mlf -w outLatFile -p 0.0 -s 5.0 dict monophones0']);


disp('Error occurs in recout.mlf');
disp('Need to change mfcc to label in recout.mlf');
disp('A hacky way using Vim:.,$,s/mfcc/label/g');


eval(['!E:\htk\HResults.exe -T 1 -I testref.mlf monophones0 recout.mlf']);
eval(['!E:\htk\HResults.exe -T 1 -e n en -e aa ao -e ah ax-h -e ah ax -e ih ix -e l el -e sh zh -e uw ux -e er axr -e m em -e n nx -e ng eng -e hh hv -e pau pcl -e pau tcl -e pau kcl -e pau q -e pau bcl -e pau dcl -e pau gcl -e pau epi -e pau h# -I testref.mlf monophones0 recout.mlf']);

%input('Press enter to continue');
% disp('With bigram language model:');
%eval(['!HResults -T 1 -I testref.mlf monophones0 recout_bigram.mlf']);
% eval(['!E:\htk\HResults -T 1 -e n en -e aa ao -e ah ax-h -e ah ax -e ih ix -e l el -e sh zh -e uw ux -e er axr -e m em -e n nx -e ng eng -e hh hv -e pau pcl -e pau tcl -e pau kcl -e pau q -e pau bcl -e pau dcl -e pau gcl -e pau epi -e pau h# -I testref.mlf monophones0 recout_bigram.mlf > results_bigram']);

