%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating files with random seeds (x1000) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileIDseed1 = fopen('seed1.txt','w');
FileIDseed2 = fopen('seed2.txt','w');

rng('shuffle');

seed1 = roundn((rand*10000),0);
seed2 = roundn((rand*10000),0);

fprintf(FileIDseed1,'%1.0f',seed1);
fprintf(FileIDseed2,'%1.0f',seed2);

fclose(FileIDseed1);
fclose(FileIDseed2);
