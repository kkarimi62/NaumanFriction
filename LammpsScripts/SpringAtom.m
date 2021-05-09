%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading the file and extracting paramters  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = delimitedTextImportOptions("NumVariables", 15);

opts.DataLines = [1, Inf];
opts.Delimiter = " ";

opts.VariableNames = ["ITEM", "TIMESTEP", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "Var14", "Var15"];
opts.SelectedVariableNames = ["ITEM", "TIMESTEP", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string"];
opts = setvaropts(opts, [14, 15], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "TrimNonNumeric", true);
opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "ThousandsSeparator", ",");
opts = setvaropts(opts, [14, 15], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.LeadingDelimitersRule = "ignore";
RefAtom = readtable("SliderSubstrate.txt",opts);
clear opts

RefAtom = table2array(RefAtom);

SpringDensity = 1;
SimBoxx_lw = 0.0;
SimBoxx_hg = 1.5;
SimBoxy_lw = 0;
SimBoxy_hg = 0.3 * SimBoxx_hg;
SimBoxz_lw = -0.5;
SimBoxz_hg = 0.5;
SimBoxx_lw = 0.0;
SimBoxx_hg = 1.5;
SimBoxy_lw = 0;
SimBoxy_hg = 0.3 * SimBoxx_hg;
SimBoxz_lw = -0.5;
SpringAtomTag = 1;

VelSpring_x = 0.0;
VelSpring_y = 0.0;
VelSpring_z = 0.0;

AngVelSpring_x = 0.0;
AngVelSpring_y = 0.0;
AngVelSpring_z = 0.0;

AtomType_Spring = 5;
SpringDiameter = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Background Calculations %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refx = RefAtom(length(RefAtom),5);
refy = RefAtom(length(RefAtom),6);
difference = 0.25;
Newx = refx + difference;
Spring_x = Newx;
Spring_y = refy;
Spring_z = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Putting the atom % and % Velocities % % Writing the text file%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileID = fopen('data.SpringAtom.txt','w');

fprintf(FileID,'%-1s\n','LAMMPS data file via MATLAB, version R2019a, timestep = 321001');
fprintf(FileID,'\n%-1.0f %1s\n',SpringAtomTag,'atoms');
fprintf(FileID,'%-1.0f %1s\n',AtomType_Spring,'atom types');
fprintf(FileID,'\n%-1.16e %-1.16e %1s\n',SimBoxx_lw,SimBoxx_hg,'xlo xhi');
fprintf(FileID,'%-1.16e %-1.16e %1s\n',SimBoxy_lw,SimBoxy_hg,'ylo yhi');
fprintf(FileID,'%-1.16e %-1.16e %1s\n',SimBoxz_lw,SimBoxz_hg,'zlo zhi');
fprintf(FileID,'\n%-1s\n','Atoms # sphere');

fprintf(FileID,'\n%-1.0f',SpringAtomTag); %Atom Tag No.
fprintf(FileID,'% 1.0f',AtomType_Spring); %Atom Type
fprintf(FileID,'% 1.16e',SpringDiameter); %Atom Diameter
fprintf(FileID,'% 1.16e',SpringDensity); %Atomic Density
fprintf(FileID,'% 1.16e',Spring_x); %Atom x
fprintf(FileID,'% 1.16e',Spring_y); %Atom y
fprintf(FileID,'% 1.16e\n',Spring_z); %Atom z

fprintf(FileID,'\n%-1s\n','Velocities');

fprintf(FileID,'\n%-1.0f',SpringAtomTag);
fprintf(FileID,'% 1.16e',VelSpring_x);
fprintf(FileID,'% 1.16e',VelSpring_y);
fprintf(FileID,'% 1.16e',VelSpring_z);
fprintf(FileID,'% 1.16e',AngVelSpring_x);
fprintf(FileID,'% 1.16e',AngVelSpring_y);
fprintf(FileID,'% 1.16e\n',AngVelSpring_z);

fclose(FileID);