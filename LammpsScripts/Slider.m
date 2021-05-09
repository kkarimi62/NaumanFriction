%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOWER PARAMETERS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AtomRadiusLower = 0.000125; %Radius of the particels making up the slider
AtomDiameter_Lower = 2.0 * AtomRadiusLower;
AtomType_Slider = 3;
AtomType_Spring = 4;
VolumeLow = (4/3)*pi*(AtomRadiusLower^3);
SimBoxx_lw = 0.0;
SimBoxx_hg = 1.5;
SimBoxy_lw = 0.0;
SimBoxy_hg = 0.3 * SimBoxx_hg;
SimBoxz_lw = 0.5;
SimBoxz_hg = 0.5;
OverLap = 0 * AtomRadiusLower; %Overlap of Atoms

%The slider is dropped xx of box hight.
Slider_xlwLower = 0.1;
Slider_xhgLower = Slider_xlwLower + 0.25; %Length of the slider

%Type
Slider_ylwLower = 0.110;
Slider_yhgLower = Slider_ylwLower + 0.0030; %Hight of the slider

SliderLength = Slider_xhgLower - Slider_xlwLower;
SliderHight = Slider_yhgLower - Slider_ylwLower;

TotalNumberAtoms_xaxisLower = floor(SliderLength/((2.0 * AtomRadiusLower)-(2.0 * OverLap)));
TotalNumberAtoms_yaxisLower = floor(SliderHight/((2.0 * AtomRadiusLower)-(2.0 * OverLap)));
TotalNumberAtomsLower = TotalNumberAtoms_xaxisLower * TotalNumberAtoms_yaxisLower;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For Lower: Putting the atoms % and % Velocities %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AtomNoLower = 1;

AtomFileLower = zeros(TotalNumberAtomsLower,7);
VelocityFileLower = zeros(TotalNumberAtomsLower,7);

% fprintf(FileID,'\n%-1s\n','Atoms # sphere');

for i = 1:TotalNumberAtoms_yaxisLower
    for j = 1:TotalNumberAtoms_xaxisLower

        AtomFileLower(AtomNoLower,1) = AtomNoLower; %Atom-ID

        AtomFileLower(AtomNoLower,2) = AtomType_Slider; %Atom-type

        AtomFileLower(AtomNoLower,3) = AtomDiameter_Lower; %Atom-diameter

        if j == 1
            AtomFileLower(AtomNoLower,5) = Slider_xlwLower + AtomRadiusLower - OverLap;
        else
            AtomFileLower(AtomNoLower,5) = Slider_xlwLower + ((j-1) * AtomDiameter_Lower) + AtomRadiusLower - (2 * j * OverLap);
        end

        if i == 1
            AtomFileLower(AtomNoLower,6) = Slider_ylwLower + AtomRadiusLower - OverLap;
        else
            AtomFileLower(AtomNoLower,6) = Slider_ylwLower + ((i-1) * AtomDiameter_Lower) + AtomRadiusLower - (2 * i * OverLap);
        end

        VelocityFileLower(AtomNoLower,1) = AtomNoLower;

        AtomNoLower = AtomNoLower + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adding Groves %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GroveRadius = 0.0025;
GroveDiameter = GroveRadius*2;
NumGroves = (Slider_xhgLower-Slider_xlwLower)/GroveDiameter;
Groves = cell(round(NumGroves),4);
AtomPerGrove = GroveDiameter/AtomDiameter_Lower;

for i = 1:round(NumGroves)
  Groves{i,1} = i;
  Groves{i,2} = Slider_xlwLower + (i-1)*GroveDiameter + GroveRadius;

  Groves{i,3} = zeros(AtomPerGrove,1);
  Groves{i,4} = zeros(AtomPerGrove,1);

  for j = 1:AtomPerGrove
      Groves{i,3}(j) = AtomFileLower(((i-1)*AtomPerGrove)+j,5);
      Groves{i,4}(j) = Slider_ylwLower+((GroveRadius^2 - (AtomFileLower(((i-1)*AtomPerGrove)+j,5)-Groves{i,2})^2)^(1/2));
  end
  
  if i == round(NumGroves)
      % Manually fixing the last one
      Groves{round(NumGroves),3}(AtomPerGrove) = [];
      Groves{round(NumGroves),4}(AtomPerGrove) = [];
  end
end

x = 0.82;
x = SliderLength*x + Slider_xlwLower;

for j = 1:round(NumGroves)
    for k = 1:AtomPerGrove
        if Groves{j,3}(k) > x
            break
        end 
        i=1;
        while i<=length(AtomFileLower)
            if AtomFileLower(i,5) == Groves{j,3}(k) && AtomFileLower(i,6) < Groves{j,4}(k)
                AtomFileLower(i,:) = [];
                VelocityFileLower(i,:) = [];
                i = i-1;
            end
            i = i+1;
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HIGHER PARAMETERS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AtomRadiusHigher = 0.0005; %Radius of the particels making up the slider
AtomDiameter_Higher = 2.0 * AtomRadiusHigher;
VolumeHigh = (4/3)*pi*(AtomRadiusHigher^3);
OverLap = 0 * AtomRadiusHigher; %Overlap of Atoms

%The slider is dropped xx of box hight.
Slider_xlwHigher = 0.1;
Slider_xhgHigher = Slider_xlwHigher + 0.25; %Length of the slider

%Type
Slider_ylw_Higher = Slider_yhgLower;
Slider_yhg_Higher = Slider_ylw_Higher+0.02; %Hight of the slider

SliderLength = Slider_xhgHigher - Slider_xlwHigher;
SliderHight = Slider_yhg_Higher - Slider_ylw_Higher;

TotalNumberAtoms_xaxisHigher = floor(SliderLength/((2.0 * AtomRadiusHigher)-(2.0 * OverLap)));
TotalNumberAtoms_yaxisHigher = floor(SliderHight/((2.0 * AtomRadiusHigher)-(2.0 * OverLap)));
TotalNumberAtomsHigher = TotalNumberAtoms_xaxisHigher * TotalNumberAtoms_yaxisHigher;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For Upper: Putting the atoms % and % Velocities %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AtomNoHigher = 1;

AtomFileHigher = zeros(TotalNumberAtomsHigher,7);
VelocityFileHigher = zeros(TotalNumberAtomsHigher,7);

% fprintf(FileID,'\n%-1s\n','Atoms # sphere');

for i = 1:TotalNumberAtoms_yaxisHigher
    for j = 1:TotalNumberAtoms_xaxisHigher

        AtomFileHigher(AtomNoHigher,1) = AtomNoHigher; %Atom-ID

        if i == floor(TotalNumberAtoms_yaxisHigher/2) && j == floor(TotalNumberAtoms_xaxisHigher/2)
            AtomFileHigher(AtomNoHigher,2) = AtomType_Slider+1; %Atom-type
        else
            AtomFileHigher(AtomNoHigher,2) = AtomType_Slider; %Atom-type
        end

        AtomFileHigher(AtomNoHigher,3) = AtomDiameter_Higher; %Atom-diameter

        if j == 1
            AtomFileHigher(AtomNoHigher,5) = Slider_xlwHigher + AtomRadiusHigher - OverLap;
        else
            AtomFileHigher(AtomNoHigher,5) = Slider_xlwHigher + ((j-1) * AtomDiameter_Higher) + AtomRadiusHigher - (2 * j * OverLap);
        end

        if i == 1
            AtomFileHigher(AtomNoHigher,6) = Slider_ylw_Higher + AtomRadiusHigher - OverLap;
        else
            AtomFileHigher(AtomNoHigher,6) = Slider_ylw_Higher + ((i-1) * AtomDiameter_Higher) + AtomRadiusHigher - (2 * i * OverLap);
        end

        VelocityFileHigher(AtomNoHigher,1) = AtomNoHigher;

        AtomNoHigher = AtomNoHigher + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Text files %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AtomFile = [AtomFileHigher;AtomFileLower];
VelocityFile = [VelocityFileHigher;VelocityFileLower];

m = (Slider_yhg_Higher - Slider_ylwLower)/(0.253*(Slider_xhgLower - Slider_xlwLower));
i = 1;

while i <= length(AtomFile)
    if AtomFile(i,5) > x
        y = m*AtomFile(i,5);
        if y > AtomFile(i,6)
            AtomFile(i,:) = [];
            VelocityFile(i,:) = [];
            i = i - 1;
        end
    end
    i = i+1;
end

SpringConst = 70; %Spring constatnt from the paper
Mass = 0.085; %Mass of the slider from the paper

AtomDensity = Mass/((TotalNumberAtomsLower * VolumeLow)+(AtomNoHigher * VolumeHigh));
SpringDensity = AtomDensity;

TotalNumberAtoms = length(AtomFile);

SpringAtomTag = TotalNumberAtoms;

for i=1:length(AtomFile)
    AtomFile(i,1) = i;
    AtomFile(i,4) = AtomDensity; %Atom-density
    VelocityFile(i,1) = i;
end

%Removing the slider atoms if below "x", choose x

% x = 0.002; i = 1;
% while i<=length(AtomFile)
%     if AtomFile(i,6) < (Slider_ylwLower+x)
%         AtomFile(i,:) = [];
%         VelocityFile(i,:) = [];
%         i = i-1;
%     end
%     i = i+1;
% end

FileID = fopen('data.Slider.txt','w');

fprintf(FileID,'%-1s\n','LAMMPS data file via MATLAB, version R2019a, timestep = 321001');
fprintf(FileID,'\n%-1.0f %1s\n',length(AtomFile),'atoms');
fprintf(FileID,'%-1.0f %1s\n',AtomType_Spring,'atom types');
fprintf(FileID,'\n%-1.16e %-1.16e %1s\n',SimBoxx_lw,SimBoxx_hg,'xlo xhi');
fprintf(FileID,'%-1.16e %-1.16e %1s\n',SimBoxy_lw,SimBoxy_hg,'ylo yhi');
fprintf(FileID,'%-1.16e %-1.16e %1s\n',SimBoxz_lw,SimBoxz_hg,'zlo zhi');
fprintf(FileID,'\n%-1s\n','Atoms # sphere');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Writing the text file %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:length(AtomFile)

    if k == 1
        fprintf(FileID,'\n%-1.0f',AtomFile(k,1));
    else
        fprintf(FileID,'%-1.0f',AtomFile(k,1));
    end
    fprintf(FileID,'% 1.0f',AtomFile(k,2));
    fprintf(FileID,'% 1.16e',AtomFile(k,3));
    fprintf(FileID,'% 1.16e',AtomFile(k,4));
    fprintf(FileID,'% 1.16e',AtomFile(k,5));
    fprintf(FileID,'% 1.16e',AtomFile(k,6));
    fprintf(FileID,'% 1.16e\n',AtomFile(k,7));

end

fprintf(FileID,'\n%-1s\n','Velocities');

for l = 1:length(AtomFile)

    if l == 1
        fprintf(FileID,'\n%-1.0f',VelocityFile(l,1));
    else
        fprintf(FileID,'%-1.0f',VelocityFile(l,1));
    end
    fprintf(FileID,'% 1.16e',VelocityFile(l,2));
    fprintf(FileID,'% 1.16e',VelocityFile(l,3));
    fprintf(FileID,'% 1.16e',VelocityFile(l,4));
    fprintf(FileID,'% 1.16e',VelocityFile(l,5));
    fprintf(FileID,'% 1.16e',VelocityFile(l,6));
    fprintf(FileID,'% 1.16e\n',VelocityFile(l,7));

end

fclose(FileID);
