function materials = getCommonMaterials()

%source: http://en.wikipedia.org/wiki/Earth%27s_atmosphere
m.name = 'Dry air';
m.formulas = {['(N2)780840(O2)209460Ar9340(CO2)383Ne18.18He5.24'...
    '(CH4)1.745Kr1.14(H2)0.55']};
m.density = 1.2;
m.relativeWeights = 1;
materials = m;

%source: common knowledge
m.name = 'Water';
m.formulas = {'H2O'};
m.density = 1000;
m.relativeWeights = 1;
materials(end+1) = m;

%source: goodfellow.com and 
m.name = 'Low density polyethylene';
m.formulas = {'CH2'};
m.density = 920;
m.relativeWeights = 1;
materials(end+1) = m;

%source: common knowledge
m.name = 'Carbon Dioxide';
m.formulas = {'CO2'};
m.density = 2;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Polystyrene
m.name = 'Polystyrene';
m.formulas = {'C8H8'};
m.density = 1050;
m.relativeWeights = 1;
materials(end+1) = m;

%source: Richard Tjörnhammar
m.name = 'Nylon';
m.formulas = {'H36C18N3O4'};
m.relativeWeights = 1;
m.density = 1150;
materials(end+1) = m;

%source: http://www.chemindustry.com/chemicals/2530136.html
%and http://en.wikipedia.org/wiki/Fluorinated_ethylene_propylene
m.name = 'FEP';
m.formulas = {'C18H20F4O6P2'};
m.relativeWeights = 1;
m.density = 2150;
materials(end+1) = m;

%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Adipose Tissue (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'S', 'Cl'};
m.relativeWeights = [0.114000 0.598000 0.007000 0.278000 0.001000 0.001000 0.001000];
m.density = 950;
materials(end+1) = m;

%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Bone, Cortical (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'Mg', 'P', 'S', 'Ca'};
m.relativeWeights = [0.034000 0.155000 0.042000 0.435000 0.001000 0.002000 0.103000 0.003000 0.225000];
m.density = 1920;
materials(end+1) = m;

%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Breast Tissue (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl'};
m.relativeWeights = [0.106000 0.332000 0.030000 0.527000 0.001000 0.001000 0.002000 0.001000];
m.density = 1020;
materials(end+1) = m;

%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Muscle, Skeletal (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.102000 0.143000 0.034000 0.710000 0.001000 0.002000 0.003000 0.001000 0.004000];
m.density = 1050;
materials(end+1) = m;

%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Tissue, Soft (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.102000 0.143000 0.034000 0.708000 0.002000 0.003000 0.003000 0.002000 0.003000];
m.density = 1060;
materials(end+1) = m;

%source: Blood: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
%Iodine injection volume 500-1000 ul Iomeprol 400 mg I/ml from 
%"Volumetric computed tomography (VCT): a new technology for noninvasive,
%high-resolution monitoring of tumor angiogenesis", Kiessling et.al.,
%Nature Medicine october 2004.
%Mouse blood volume 1.5 ml from google, e.g.
%http://www.nc3rs.org.uk/bloodsamplingmicrosite/page.asp?id=419
%This gives up to 130-270 mg I/ml blood which cannot be correct. In fig. 1
%the iodinated blood clearly has less contrast than bone. The iodine
%concentration therefore cannot be higher than 45 mg I/ml blood, since that
%gives the same contrast as bone (NIST).
m.name = 'Iodinated mouse blood, (Kiessling)';
m.formulas = {'I','(H)0.1012(C)0.0091585(N)0.002356(O)0.046564(Na)4.3498e-005(P)3.2285e-005(S)6.2373e-005(Cl)8.4619e-005(K)5.1153e-005(Fe)1.7907e-005'};
m.density = 1060;
m.relativeWeights = [45 1060-45];
materials(end+1) = m;

%source: Mukundan S Jr., Ghaghada K B, Badea C T, Kao C Y, Hedlund L W,
%Provenzale J M, Johnson G A, Chen E, Bellamkonda R V and Annapragada A
%2006 A liposomal nanoscale contrast agent for preclinical CT in mice
%AJR Am. J. Roentgenol. 186 300–7, http://dx.doi.org/10.2214/AJR.05.0523
%source: Blood: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
%Där används jod innesluten i 100 nm stora liposomer. Mössen injicerades
%med 0.5 ml jodliposomlösning per 25 g mus. Jodliposomlösningen innehöll
%83–105 mg I/mL. Om vi då antar att en mus har 77-80 ml blod per kg mus
%(http://jaxmice.jax.org/faq/withdrawingblood_amounts.html) kommer blodet
%innehålla 21-27 mg I/ml blod. Här använder vi 27 mg I/ml blod.
%Den maximala ökningen i absorption anges vara 900 HU.
m.name = 'Iodinated mouse blood (Mukundan)';
m.formulas = {'I','(H)0.1012(C)0.0091585(N)0.002356(O)0.046564(Na)4.3498e-005(P)3.2285e-005(S)6.2373e-005(Cl)8.4619e-005(K)5.1153e-005(Fe)1.7907e-005'};
m.density = 1060;
m.relativeWeights = [27 1060-27];
materials(end+1) = m;

%source: Rabin O, Manuel Perez J, Grimm J,Wojtkiewicz G andWeissleder R
%2006 An X-ray computed tomography imaging agent based on long-circulating
%bismuth sulphide nanoparticles Nat. Mater. 5 118–22 http://dx.doi.org/10.1038/nmat1571
%57 ?mol Bi3+ , corresponds to 11.9 mg. Diluted in 1.5 ml of mouse blood
%this is is 7.9 mg Bi/ml blood.
m.name = 'Bi in mouse blood (Rabin)';
m.formulas = {'Bi','(H)0.1012(C)0.0091585(N)0.002356(O)0.046564(Na)4.3498e-005(P)3.2285e-005(S)6.2373e-005(Cl)8.4619e-005(K)5.1153e-005(Fe)1.7907e-005'};
m.density = 1060;
m.relativeWeights = [7.9 1060-7.9];
materials(end+1) = m;


%source: http://en.wikipedia.org/wiki/Aluminium
m.name = 'Aluminium';
m.formulas = {'Al'};
m.density = 2700;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Gold
m.name = 'Gold';
m.formulas = {'Au'};
m.density = 19300;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://www.goodfellow.com/
m.name = 'Tungsten';
m.formulas = {'W'};
m.density = 19300;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://www.goodfellow.com/
m.name = 'Lead';
m.formulas = {'Pb'};
m.density = 11350;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Borosilicate_glass
m.name = 'Borosilicate glass';
m.formulas = {'B','O','Na','Al','Si','K'};
m.density = 2230;
m.relativeWeights = [0.040064 0.539562 0.028191 0.011644 0.377220 0.003321];
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Galinstan
m.name = 'Galinstan';
m.formulas = {'Ga','In','Sn'};
m.density = 6440;
m.relativeWeights = [.685 .215 .100];
materials(end+1) = m;

%source: combination of adipose tissue from NIST, 
%http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
%and calcium concentration and density from Rahdert
%http://www.sciencedirect.com/science/article/B6VRN-40BG4R2-8/2/4c1cc13b2a2753d8b570789b7f17330c
m.name = 'Plaque';
m.formulas = {'Ca', 'H', 'C', 'N', 'O', 'Na', 'S', 'Cl'};
m.relativeWeights = [.1 .9*[0.114000 0.598000 0.007000 0.278000 0.001000 0.001000 0.001000]];
m.density = 1400;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Silicon
m.name = 'Silicon';
m.formulas = {'Si'};
m.density = 2329;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Beryllium
m.name = 'Beryllium';
m.formulas = {'Be'};
m.density = 1850;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Copper
m.name = 'Copper';
m.formulas = {'Cu'};
m.density = 8960;
m.relativeWeights = 1;
materials(end+1) = m;

%source: http://en.wikipedia.org/wiki/Earth%27s_atmosphere and 
%http://www.smhi.se/cmp/jsp/polopoly.jsp?d=6526&l=sv
m.name = 'Air';
m.formulas = {['(N2)780840(O2)209460Ar9340(CO2)383Ne18.18He5.24'...
    '(CH4)1.745Kr1.14(H2)0.55'] 'H2O'};
m.density = 1.2;
m.relativeWeights = [1 1e-3];
materials(end+1) = m;

%source: Richard Tjörnhammar, based on article written by Maughan.
%Tumor model cannot be found in standard NIST databases.
m.name = 'Tumor';
m.formulas = {['H.06055' 'C.1143' 'N.0261' 'O.2491' 'Na.0007' 'P.0014'...
    'S.0014' 'Cl.0007' 'K.0007']}; %sum is not 1.
m.relativeWeights = 1;
m.density = 1040;
materials(end+1) = m;

%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'AgBr';
m.formulas = {'AgBr'};
m.density = 6473;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'AlAs';
m.formulas = {'AlAs'};
m.density = 3810;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Sapphire';
m.formulas = {'Al2O3'};
m.density = 3970;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'AlP';
m.formulas = {'AlP'};
m.density = 2420;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'B4C';
m.formulas = {'B4C'};
m.density = 2520;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'BeO';
m.formulas = {'BeO'};
m.density = 3010;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'BN';
m.formulas = {'BN'};
m.density = 2250;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Polyimide';
m.formulas = {'C22H10N2O5'};
m.density = 1430;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Polypropylene';
m.formulas = {'C3H6'};
m.density = 900;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'PMMA';
m.formulas = {'C5H8O2'};
m.density = 1190;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Polycarbonate';
m.formulas = {'C16H14O3'};
m.density = 1200;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Kimfol';
m.formulas = {'C16H14O3'};
m.density = 1200;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Mylar';
m.formulas = {'C10H8O4'};
m.density = 1400;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Teflon';
m.formulas = {'C2F4'};
m.density = 2200;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Parylene-C';
m.formulas = {'C8H7Cl'};
m.density = 1290;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Parylene-N';
m.formulas = {'C8H8'};
m.density = 1110;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Fluorite';
m.formulas = {'CaF2'};
m.density = 3180;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'CdWO4';
m.formulas = {'CdWO4'};
m.density = 7900;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'CdS';
m.formulas = {'CdS'};
m.density = 4826;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'CoSi2';
m.formulas = {'CoSi2'};
m.density = 5300;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Cr2O3';
m.formulas = {'Cr2O3'};
m.density = 5210;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'CsI';
m.formulas = {'CsI'};
m.density = 4510;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'CuI';
m.formulas = {'CuI'};
m.density = 5630;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'InN';
m.formulas = {'InN'};
m.density = 6880;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'In2O3';
m.formulas = {'In2O3'};
m.density = 7179;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'InSb';
m.formulas = {'InSb'};
m.density = 5775;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'GaAs';
m.formulas = {'GaAs'};
m.density = 5316;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'GaN';
m.formulas = {'GaN'};
m.density = 6100;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'GaP';
m.formulas = {'GaP'};
m.density = 4130;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'LiF';
m.formulas = {'LiF'};
m.density = 2635;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'LiH';
m.formulas = {'LiH'};
m.density = 783;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'LiOH';
m.formulas = {'LiOH'};
m.density = 1430;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MgO';
m.formulas = {'MgO'};
m.density = 3580;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Mg2Si';
m.formulas = {'Mg2Si'};
m.density = 1940;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Mica';
m.formulas = {'KAl3Si3O12H2'};
m.density = 2830;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MnO';
m.formulas = {'MnO'};
m.density = 5440;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MnO2';
m.formulas = {'MnO2'};
m.density = 5030;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MoO2';
m.formulas = {'MoO2'};
m.density = 6470;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MoO3';
m.formulas = {'MoO3'};
m.density = 4690;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'MoSi2';
m.formulas = {'MoSi2'};
m.density = 6310;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Salt';
m.formulas = {'NaCl'};
m.density = 2165;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'NiO';
m.formulas = {'NiO'};
m.density = 6670;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Ni2Si';
m.formulas = {'Ni2Si'};
m.density = 7200;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Ru2Si3';
m.formulas = {'Ru2Si3'};
m.density = 6960;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'SiC';
m.formulas = {'SiC'};
m.density = 3217;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Si3N4';
m.formulas = {'Si3N4'};
m.density = 3440;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Silica';
m.formulas = {'SiO2'};
m.density = 2200;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Quartz';
m.formulas = {'SiO2'};
m.density = 2650;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'TaN';
m.formulas = {'TaN'};
m.density = 16300;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'TiN';
m.formulas = {'TiN'};
m.density = 5220;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Ta2Si';
m.formulas = {'Ta2Si'};
m.density = 14000;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Rutile';
m.formulas = {'TiO2'};
m.density = 4260;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'ULE';
m.formulas = {'Si.925Ti.075O2'};
m.density = 2205;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'UO2';
m.formulas = {'UO2'};
m.density = 10960;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'VN';
m.formulas = {'VN'};
m.density = 6130;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Water';
m.formulas = {'H2O'};
m.density = 1000;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Zerodur';
m.formulas = {'Si.56Al.5P.16Li.04Ti.02Zr.02Zn.03O2.46'};
m.density = 2530;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'ZnO';
m.formulas = {'ZnO'};
m.density = 5675;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'ZnS';
m.formulas = {'ZnS'};
m.density = 4079;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'ZrN';
m.formulas = {'ZrN'};
m.density = 7090;
m.relativeWeights = 1;
materials(end+1) = m;
 
%source: http://henke.lbl.gov/cgi-bin/density.pl
m.name = 'Zirconia';
m.formulas = {'ZrO2'};
m.density = 5600;
m.relativeWeights = 1;
materials(end+1) = m;



%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'A-150 Tissue-Equivalent Plastic (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'F', 'Ca'};
m.relativeWeights = [0.101330 0.775498 0.035057 0.052315 0.017423 0.018377];
m.density = 1130;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Adipose Tissue (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'S', 'Cl'};
m.relativeWeights = [0.114000 0.598000 0.007000 0.278000 0.001000 0.001000 0.001000];
m.density = 950;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Air, Dry (near sea level) (NIST)';
m.formulas = {'C', 'N', 'O', 'Ar'};
m.relativeWeights = [0.000124 0.755268 0.231781 0.012827];
m.density = 1.21;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Alanine (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.079192 0.404437 0.157213 0.359157];
m.density = 1420;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'B-100 Bone-Equivalent Plastic (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'F', 'Ca'};
m.relativeWeights = [0.065473 0.536942 0.021500 0.032084 0.167415 0.176585];
m.density = 1450;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Bakelite (NIST)';
m.formulas = {'H', 'C', 'O'};
m.relativeWeights = [0.057444 0.774589 0.167968];
m.density = 1250;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Blood, Whole (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K', 'Fe'};
m.relativeWeights = [0.102000 0.110000 0.033000 0.745000 0.001000 0.001000 0.002000 0.003000 0.002000 0.001000];
m.density = 1060;
materials(end+1) = m;
%wikipedia on blood:
%density 1060 kg/m^3
%blood is 45% red blood cells, 55% blood plasma.
%blood plasma is 92% water and 8% proteins.
%red blood cells: 2 um thick and 6-8 um in diameter, 33% hemoglobin
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Bone, Cortical (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'Mg', 'P', 'S', 'Ca'};
m.relativeWeights = [0.034000 0.155000 0.042000 0.435000 0.001000 0.002000 0.103000 0.003000 0.225000];
m.density = 1920;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Brain, Grey/White Matter (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.107000 0.145000 0.022000 0.712000 0.002000 0.004000 0.002000 0.003000 0.003000];
m.density = 1040;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Breast Tissue (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl'};
m.relativeWeights = [0.106000 0.332000 0.030000 0.527000 0.001000 0.001000 0.002000 0.001000];
m.density = 1020;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'C-552 Air-equivalent Plastic (NIST)';
m.formulas = {'H', 'C', 'O', 'F', 'Si'};
m.relativeWeights = [0.024681 0.501610 0.004527 0.465209 0.003973];
m.density = 1760;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Cadmium Telluride (NIST)';
m.formulas = {'Cd', 'Te'};
m.relativeWeights = [0.468358 0.531642];
m.density = 6200;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Calcium Fluoride (NIST)';
m.formulas = {'F', 'Ca'};
m.relativeWeights = [0.486672 0.513328];
m.density = 3180;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Calcium Sulfate (NIST)';
m.formulas = {'O', 'S', 'Ca'};
m.relativeWeights = [0.470081 0.235534 0.294385];
m.density = 2960;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = '15 mmol L-1 Ceric Ammonium Sulfate Solution (NIST)';
m.formulas = {'H', 'N', 'O', 'S', 'Ce'};
m.relativeWeights = [0.107694 0.000816 0.875172 0.014279 0.002040];
m.density = 1030;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Cesium Iodide (NIST)';
m.formulas = {'I', 'Cs'};
m.relativeWeights = [0.488451 0.511549];
m.density = 4510;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Concrete, Ordinary (NIST)';
m.formulas = {'H', 'C', 'O', 'Na', 'Mg', 'Al', 'Si', 'K', 'Ca', 'Fe'};
m.relativeWeights = [0.022100 0.002484 0.574930 0.015208 0.001266 0.019953 0.304627 0.010045 0.042951 0.006435];
m.density = 2300;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Concrete, Barite (TYPE BA) (NIST)';
m.formulas = {'H', 'O', 'Mg', 'Al', 'Si', 'S', 'Ca', 'Fe', 'Ba'};
m.relativeWeights = [0.003585 0.311622 0.001195 0.004183 0.010457 0.107858 0.050194 0.047505 0.463400];
m.density = 3350;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Eye Lens (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl'};
m.relativeWeights = [0.096000 0.195000 0.057000 0.646000 0.001000 0.001000 0.003000 0.001000];
m.density = 1070;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Ferrous Sulfate Standard Fricke (NIST)';
m.formulas = {'H', 'O', 'Na', 'S', 'Cl', 'Fe'};
m.relativeWeights = [0.108376 0.878959 0.000022 0.012553 0.000035 0.000055];
m.density = 1020;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Gadolinium Oxysulfide (NIST)';
m.formulas = {'O', 'S', 'Gd'};
m.relativeWeights = [0.084527 0.084704 0.830769];
m.density = 7440;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Gafchromic Sensor (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.089700 0.605800 0.112200 0.192300];
m.density = 1300;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Gallium Arsenide (NIST)';
m.formulas = {'Ga', 'As'};
m.relativeWeights = [0.482030 0.517970];
m.density = 5310;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Glass, Borosilicate (Pyrex) (NIST)';
m.formulas = {'B', 'O', 'Na', 'Al', 'Si', 'K'};
m.relativeWeights = [0.040066 0.539559 0.028191 0.011644 0.377220 0.003321];
m.density = 2230;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Glass, Lead (NIST)';
m.formulas = {'O', 'Si', 'Ti', 'As', 'Pb'};
m.relativeWeights = [0.156453 0.080866 0.008092 0.002651 0.751938];
m.density = 6220;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Lithium Fluride (NIST)';
m.formulas = {'Li', 'F'};
m.relativeWeights = [0.267585 0.732415];
m.density = 2640;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Lithium Tetraborate (NIST)';
m.formulas = {'Li', 'B', 'O'};
m.relativeWeights = [0.082081 0.255715 0.662204];
m.density = 2440;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Lung Tissue (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.103000 0.105000 0.031000 0.749000 0.002000 0.002000 0.003000 0.003000 0.002000];
m.density = 1050;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Magnesium Tetroborate (NIST)';
m.formulas = {'B', 'O', 'Mg'};
m.relativeWeights = [0.240870 0.623762 0.135367];
m.density = 2530;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Mercuric Iodide (NIST)';
m.formulas = {'I', 'Hg'};
m.relativeWeights = [0.558560 0.441440];
m.density = 6360;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Muscle, Skeletal (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.102000 0.143000 0.034000 0.710000 0.001000 0.002000 0.003000 0.001000 0.004000];
m.density = 1050;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Ovary (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.105000 0.093000 0.024000 0.768000 0.002000 0.002000 0.002000 0.002000 0.002000];
m.density = 1050;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Photographic Emulsion (Kodak Type AA) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Br', 'Ag'};
m.relativeWeights = [0.030500 0.210700 0.072100 0.163200 0.222800 0.300700];
m.density = 2200;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Photographic Emulsion (Standard Nuclear) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'S', 'Br', 'Ag', 'I'};
m.relativeWeights = [0.014100 0.072261 0.019320 0.066101 0.001890 0.349104 0.474105 0.003120];
m.density = 3820;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Plastic Scintillator, Vinyltoluene (NIST)';
m.formulas = {'H', 'C'};
m.relativeWeights = [0.085000 0.915000];
m.density = 1030;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polyethylene (NIST)';
m.formulas = {'H', 'C'};
m.relativeWeights = [0.143716 0.856284];
m.density = 930;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polyethylene Terephthalate, (Mylar) (NIST)';
m.formulas = {'H', 'C', 'O'};
m.relativeWeights = [0.041960 0.625016 0.333024];
m.density = 1380;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polymethyl Methacrylate (NIST)';
m.formulas = {'H', 'C', 'O'};
m.relativeWeights = [0.080541 0.599846 0.319613];
m.density = 1190;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polystyrene (NIST)';
m.formulas = {'H', 'C'};
m.relativeWeights = [0.077421 0.922579];
m.density = 1060;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polytetrafluoroethylene, (Teflon) (NIST)';
m.formulas = {'C', 'F'};
m.relativeWeights = [0.240183 0.759818];
m.density = 2250;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Polyvinyl Chloride (NIST)';
m.formulas = {'H', 'C', 'Cl'};
m.relativeWeights = [0.048382 0.384361 0.567257];
m.density = 1410;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Radiochromic Dye Film, Nylon Base (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.101996 0.654396 0.098915 0.144693];
m.density = 1080;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Testis (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.106000 0.099000 0.020000 0.766000 0.002000 0.001000 0.002000 0.002000 0.002000];
m.density = 1040;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Tissue, Soft (ICRU-44) (NIST)';
m.formulas = {'H', 'C', 'N', 'O', 'Na', 'P', 'S', 'Cl', 'K'};
m.relativeWeights = [0.102000 0.143000 0.034000 0.708000 0.002000 0.003000 0.003000 0.002000 0.003000];
m.density = 1060;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Tissue, Soft (ICRU Four-Component) (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.101174 0.111000 0.026000 0.761826];
m.density = 1000;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Tissue-Equivalent Gas, Methane Based (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.101873 0.456177 0.035172 0.406778];
m.density = 1.06;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Tissue-Equivalent Gas, Propane Based (NIST)';
m.formulas = {'H', 'C', 'N', 'O'};
m.relativeWeights = [0.102676 0.568937 0.035022 0.293365];
m.density = 1.83;
materials(end+1) = m;
 
%source: NIST, http://physics.nist.gov/PhysRefData/XrayMassCoef/tab2.html
m.name = 'Water, Liquid (NIST)';
m.formulas = {'H', 'O'};
m.relativeWeights = [0.111898 0.888102];
m.density = 1000;
materials(end+1) = m;
 