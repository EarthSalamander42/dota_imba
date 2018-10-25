//Maya ASCII 2016 scene
//Name: kobold_overboss_anim.ma
//Last modified: Thu, May 21, 2015 01:58:46 PM
//Codeset: 1252
file -rdi 1 -ns "RIG" -rfn "RIGRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_rig.ma";
file -rdi 2 -ns "MODEL" -rfn "RIG:MODELRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_model.ma";
file -r -ns "RIG" -dr 1 -rfn "RIGRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_rig.ma";
requires maya "2016";
requires -nodeType "HIKSolverNode" -nodeType "HIKCharacterNode" -nodeType "HIKState2SK"
		 -nodeType "HIKProperty2State" -dataType "HIKCharacter" -dataType "HIKCharacterState"
		 -dataType "HIKEffectorState" -dataType "HIKPropertySetState" "mayaHIK" "1.0_HIK_2014.2";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2016";
fileInfo "version" "2016";
fileInfo "cutIdentifier" "201502261600-953408";
fileInfo "osv" "Microsoft Windows 7 Business Edition, 64-bit Windows 7 Service Pack 1 (Build 7601)\n";
createNode transform -s -n "persp";
	rename -uid "B42D4178-4779-39F1-0BBF-148F1BDFD926";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 81.095029216924345 122.5398384494944 203.79853686289781 ;
	setAttr ".r" -type "double3" -12.338352729623441 22.600000000000463 4.3063792819169707e-016 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 217.83583068840178;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".tp" -type "double3" -23.309835259919947 102.28639146900879 -3.9408299664687334 ;
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "813BB25C-4EF7-C2AC-122D-9A8E99961CBC";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 17.54533323580975 149.63028359131621 11.109145917068011 ;
	setAttr ".r" -type "double3" -89.999999999999986 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "235F767D-4A8B-7BAB-5F98-5C9817FA2A7C";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 286.70148285070962;
	setAttr ".imn" -type "string" "top";
	setAttr ".den" -type "string" "top_depth";
	setAttr ".man" -type "string" "top_mask";
	setAttr ".hc" -type "string" "viewSet -t %camera";
	setAttr ".o" yes;
createNode transform -s -n "front";
	rename -uid "4AF6F5C1-4EF5-43F7-CDDC-1E85AF6D487C";
	setAttr ".v" no;
	setAttr ".t" -type "double3" -6.3729600484388698 86.91636374405239 112.9238398784359 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "13FA7223-4CFC-1E38-1B78-CA8D910A554F";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 111.17155975817978;
	setAttr ".imn" -type "string" "front";
	setAttr ".den" -type "string" "front_depth";
	setAttr ".man" -type "string" "front_mask";
	setAttr ".hc" -type "string" "viewSet -f %camera";
	setAttr ".o" yes;
createNode transform -s -n "side";
	rename -uid "DAA246DC-4DA8-79C9-6EE1-2B8392F9D5A9";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 142.66477704481872 84.69942876059558 -1.059679896182391 ;
	setAttr ".r" -type "double3" 0 89.999999999999986 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "77315F52-4257-77DC-6872-8383153B479D";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 100.1;
	setAttr ".ow" 96.766941399749882;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "C797875B-4612-181B-AAA9-8098FDEF4DBA";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "FBF4C3B9-47E3-BD1C-1CC8-43951017F004";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "CB414403-41C4-0ECF-5DFC-629CEE23CC6F";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "2176905E-4B8D-64F1-3697-C9A6C6860B23";
	setAttr ".g" yes;
createNode reference -n "RIGRN";
	rename -uid "AC5E3B45-47E8-0DD5-42BA-5B9B451E7F50";
	setAttr -s 437 ".phl";
	setAttr ".phl[1]" 0;
	setAttr ".phl[2]" 0;
	setAttr ".phl[3]" 0;
	setAttr ".phl[4]" 0;
	setAttr ".phl[5]" 0;
	setAttr ".phl[6]" 0;
	setAttr ".phl[7]" 0;
	setAttr ".phl[8]" 0;
	setAttr ".phl[9]" 0;
	setAttr ".phl[10]" 0;
	setAttr ".phl[11]" 0;
	setAttr ".phl[12]" 0;
	setAttr ".phl[13]" 0;
	setAttr ".phl[14]" 0;
	setAttr ".phl[15]" 0;
	setAttr ".phl[16]" 0;
	setAttr ".phl[17]" 0;
	setAttr ".phl[18]" 0;
	setAttr ".phl[19]" 0;
	setAttr ".phl[20]" 0;
	setAttr ".phl[21]" 0;
	setAttr ".phl[22]" 0;
	setAttr ".phl[23]" 0;
	setAttr ".phl[24]" 0;
	setAttr ".phl[25]" 0;
	setAttr ".phl[26]" 0;
	setAttr ".phl[27]" 0;
	setAttr ".phl[28]" 0;
	setAttr ".phl[29]" 0;
	setAttr ".phl[30]" 0;
	setAttr ".phl[31]" 0;
	setAttr ".phl[32]" 0;
	setAttr ".phl[33]" 0;
	setAttr ".phl[34]" 0;
	setAttr ".phl[35]" 0;
	setAttr ".phl[36]" 0;
	setAttr ".phl[37]" 0;
	setAttr ".phl[38]" 0;
	setAttr ".phl[39]" 0;
	setAttr ".phl[40]" 0;
	setAttr ".phl[41]" 0;
	setAttr ".phl[42]" 0;
	setAttr ".phl[43]" 0;
	setAttr ".phl[44]" 0;
	setAttr ".phl[45]" 0;
	setAttr ".phl[46]" 0;
	setAttr ".phl[47]" 0;
	setAttr ".phl[48]" 0;
	setAttr ".phl[49]" 0;
	setAttr ".phl[50]" 0;
	setAttr ".phl[51]" 0;
	setAttr ".phl[52]" 0;
	setAttr ".phl[53]" 0;
	setAttr ".phl[54]" 0;
	setAttr ".phl[55]" 0;
	setAttr ".phl[56]" 0;
	setAttr ".phl[57]" 0;
	setAttr ".phl[58]" 0;
	setAttr ".phl[59]" 0;
	setAttr ".phl[60]" 0;
	setAttr ".phl[61]" 0;
	setAttr ".phl[62]" 0;
	setAttr ".phl[63]" 0;
	setAttr ".phl[64]" 0;
	setAttr ".phl[65]" 0;
	setAttr ".phl[66]" 0;
	setAttr ".phl[67]" 0;
	setAttr ".phl[68]" 0;
	setAttr ".phl[69]" 0;
	setAttr ".phl[70]" 0;
	setAttr ".phl[71]" 0;
	setAttr ".phl[72]" 0;
	setAttr ".phl[73]" 0;
	setAttr ".phl[74]" 0;
	setAttr ".phl[75]" 0;
	setAttr ".phl[76]" 0;
	setAttr ".phl[77]" 0;
	setAttr ".phl[78]" 0;
	setAttr ".phl[79]" 0;
	setAttr ".phl[80]" 0;
	setAttr ".phl[81]" 0;
	setAttr ".phl[82]" 0;
	setAttr ".phl[83]" 0;
	setAttr ".phl[84]" 0;
	setAttr ".phl[85]" 0;
	setAttr ".phl[86]" 0;
	setAttr ".phl[87]" 0;
	setAttr ".phl[88]" 0;
	setAttr ".phl[89]" 0;
	setAttr ".phl[90]" 0;
	setAttr ".phl[91]" 0;
	setAttr ".phl[92]" 0;
	setAttr ".phl[93]" 0;
	setAttr ".phl[94]" 0;
	setAttr ".phl[95]" 0;
	setAttr ".phl[96]" 0;
	setAttr ".phl[97]" 0;
	setAttr ".phl[98]" 0;
	setAttr ".phl[99]" 0;
	setAttr ".phl[100]" 0;
	setAttr ".phl[101]" 0;
	setAttr ".phl[102]" 0;
	setAttr ".phl[103]" 0;
	setAttr ".phl[104]" 0;
	setAttr ".phl[105]" 0;
	setAttr ".phl[106]" 0;
	setAttr ".phl[107]" 0;
	setAttr ".phl[108]" 0;
	setAttr ".phl[109]" 0;
	setAttr ".phl[110]" 0;
	setAttr ".phl[111]" 0;
	setAttr ".phl[112]" 0;
	setAttr ".phl[113]" 0;
	setAttr ".phl[114]" 0;
	setAttr ".phl[115]" 0;
	setAttr ".phl[116]" 0;
	setAttr ".phl[117]" 0;
	setAttr ".phl[118]" 0;
	setAttr ".phl[119]" 0;
	setAttr ".phl[120]" 0;
	setAttr ".phl[121]" 0;
	setAttr ".phl[122]" 0;
	setAttr ".phl[123]" 0;
	setAttr ".phl[124]" 0;
	setAttr ".phl[125]" 0;
	setAttr ".phl[126]" 0;
	setAttr ".phl[127]" 0;
	setAttr ".phl[128]" 0;
	setAttr ".phl[129]" 0;
	setAttr ".phl[130]" 0;
	setAttr ".phl[131]" 0;
	setAttr ".phl[132]" 0;
	setAttr ".phl[133]" 0;
	setAttr ".phl[134]" 0;
	setAttr ".phl[135]" 0;
	setAttr ".phl[136]" 0;
	setAttr ".phl[137]" 0;
	setAttr ".phl[138]" 0;
	setAttr ".phl[139]" 0;
	setAttr ".phl[140]" 0;
	setAttr ".phl[141]" 0;
	setAttr ".phl[142]" 0;
	setAttr ".phl[143]" 0;
	setAttr ".phl[144]" 0;
	setAttr ".phl[145]" 0;
	setAttr ".phl[146]" 0;
	setAttr ".phl[147]" 0;
	setAttr ".phl[148]" 0;
	setAttr ".phl[149]" 0;
	setAttr ".phl[150]" 0;
	setAttr ".phl[151]" 0;
	setAttr ".phl[152]" 0;
	setAttr ".phl[153]" 0;
	setAttr ".phl[154]" 0;
	setAttr ".phl[155]" 0;
	setAttr ".phl[156]" 0;
	setAttr ".phl[157]" 0;
	setAttr ".phl[158]" 0;
	setAttr ".phl[159]" 0;
	setAttr ".phl[160]" 0;
	setAttr ".phl[161]" 0;
	setAttr ".phl[162]" 0;
	setAttr ".phl[163]" 0;
	setAttr ".phl[164]" 0;
	setAttr ".phl[165]" 0;
	setAttr ".phl[166]" 0;
	setAttr ".phl[167]" 0;
	setAttr ".phl[168]" 0;
	setAttr ".phl[169]" 0;
	setAttr ".phl[170]" 0;
	setAttr ".phl[171]" 0;
	setAttr ".phl[172]" 0;
	setAttr ".phl[173]" 0;
	setAttr ".phl[174]" 0;
	setAttr ".phl[175]" 0;
	setAttr ".phl[176]" 0;
	setAttr ".phl[177]" 0;
	setAttr ".phl[178]" 0;
	setAttr ".phl[179]" 0;
	setAttr ".phl[180]" 0;
	setAttr ".phl[181]" 0;
	setAttr ".phl[182]" 0;
	setAttr ".phl[183]" 0;
	setAttr ".phl[184]" 0;
	setAttr ".phl[185]" 0;
	setAttr ".phl[186]" 0;
	setAttr ".phl[187]" 0;
	setAttr ".phl[188]" 0;
	setAttr ".phl[189]" 0;
	setAttr ".phl[190]" 0;
	setAttr ".phl[191]" 0;
	setAttr ".phl[192]" 0;
	setAttr ".phl[193]" 0;
	setAttr ".phl[194]" 0;
	setAttr ".phl[195]" 0;
	setAttr ".phl[196]" 0;
	setAttr ".phl[197]" 0;
	setAttr ".phl[198]" 0;
	setAttr ".phl[199]" 0;
	setAttr ".phl[200]" 0;
	setAttr ".phl[201]" 0;
	setAttr ".phl[202]" 0;
	setAttr ".phl[203]" 0;
	setAttr ".phl[204]" 0;
	setAttr ".phl[205]" 0;
	setAttr ".phl[206]" 0;
	setAttr ".phl[207]" 0;
	setAttr ".phl[208]" 0;
	setAttr ".phl[209]" 0;
	setAttr ".phl[210]" 0;
	setAttr ".phl[211]" 0;
	setAttr ".phl[212]" 0;
	setAttr ".phl[213]" 0;
	setAttr ".phl[214]" 0;
	setAttr ".phl[215]" 0;
	setAttr ".phl[216]" 0;
	setAttr ".phl[217]" 0;
	setAttr ".phl[218]" 0;
	setAttr ".phl[219]" 0;
	setAttr ".phl[220]" 0;
	setAttr ".phl[221]" 0;
	setAttr ".phl[222]" 0;
	setAttr ".phl[223]" 0;
	setAttr ".phl[224]" 0;
	setAttr ".phl[225]" 0;
	setAttr ".phl[226]" 0;
	setAttr ".phl[227]" 0;
	setAttr ".phl[228]" 0;
	setAttr ".phl[229]" 0;
	setAttr ".phl[230]" 0;
	setAttr ".phl[231]" 0;
	setAttr ".phl[232]" 0;
	setAttr ".phl[233]" 0;
	setAttr ".phl[234]" 0;
	setAttr ".phl[235]" 0;
	setAttr ".phl[236]" 0;
	setAttr ".phl[237]" 0;
	setAttr ".phl[238]" 0;
	setAttr ".phl[239]" 0;
	setAttr ".phl[240]" 0;
	setAttr ".phl[241]" 0;
	setAttr ".phl[242]" 0;
	setAttr ".phl[243]" 0;
	setAttr ".phl[244]" 0;
	setAttr ".phl[245]" 0;
	setAttr ".phl[246]" 0;
	setAttr ".phl[247]" 0;
	setAttr ".phl[248]" 0;
	setAttr ".phl[249]" 0;
	setAttr ".phl[250]" 0;
	setAttr ".phl[251]" 0;
	setAttr ".phl[252]" 0;
	setAttr ".phl[253]" 0;
	setAttr ".phl[254]" 0;
	setAttr ".phl[255]" 0;
	setAttr ".phl[256]" 0;
	setAttr ".phl[257]" 0;
	setAttr ".phl[258]" 0;
	setAttr ".phl[259]" 0;
	setAttr ".phl[260]" 0;
	setAttr ".phl[261]" 0;
	setAttr ".phl[262]" 0;
	setAttr ".phl[263]" 0;
	setAttr ".phl[264]" 0;
	setAttr ".phl[265]" 0;
	setAttr ".phl[266]" 0;
	setAttr ".phl[267]" 0;
	setAttr ".phl[268]" 0;
	setAttr ".phl[269]" 0;
	setAttr ".phl[270]" 0;
	setAttr ".phl[271]" 0;
	setAttr ".phl[272]" 0;
	setAttr ".phl[273]" 0;
	setAttr ".phl[274]" 0;
	setAttr ".phl[275]" 0;
	setAttr ".phl[276]" 0;
	setAttr ".phl[277]" 0;
	setAttr ".phl[278]" 0;
	setAttr ".phl[279]" 0;
	setAttr ".phl[280]" 0;
	setAttr ".phl[281]" 0;
	setAttr ".phl[282]" 0;
	setAttr ".phl[283]" 0;
	setAttr ".phl[284]" 0;
	setAttr ".phl[285]" 0;
	setAttr ".phl[286]" 0;
	setAttr ".phl[287]" 0;
	setAttr ".phl[288]" 0;
	setAttr ".phl[289]" 0;
	setAttr ".phl[290]" 0;
	setAttr ".phl[291]" 0;
	setAttr ".phl[292]" 0;
	setAttr ".phl[293]" 0;
	setAttr ".phl[294]" 0;
	setAttr ".phl[295]" 0;
	setAttr ".phl[296]" 0;
	setAttr ".phl[297]" 0;
	setAttr ".phl[298]" 0;
	setAttr ".phl[299]" 0;
	setAttr ".phl[300]" 0;
	setAttr ".phl[301]" 0;
	setAttr ".phl[302]" 0;
	setAttr ".phl[303]" 0;
	setAttr ".phl[304]" 0;
	setAttr ".phl[305]" 0;
	setAttr ".phl[306]" 0;
	setAttr ".phl[307]" 0;
	setAttr ".phl[308]" 0;
	setAttr ".phl[309]" 0;
	setAttr ".phl[310]" 0;
	setAttr ".phl[311]" 0;
	setAttr ".phl[312]" 0;
	setAttr ".phl[313]" 0;
	setAttr ".phl[314]" 0;
	setAttr ".phl[315]" 0;
	setAttr ".phl[316]" 0;
	setAttr ".phl[317]" 0;
	setAttr ".phl[318]" 0;
	setAttr ".phl[319]" 0;
	setAttr ".phl[320]" 0;
	setAttr ".phl[321]" 0;
	setAttr ".phl[322]" 0;
	setAttr ".phl[323]" 0;
	setAttr ".phl[324]" 0;
	setAttr ".phl[325]" 0;
	setAttr ".phl[326]" 0;
	setAttr ".phl[327]" 0;
	setAttr ".phl[328]" 0;
	setAttr ".phl[329]" 0;
	setAttr ".phl[330]" 0;
	setAttr ".phl[331]" 0;
	setAttr ".phl[332]" 0;
	setAttr ".phl[333]" 0;
	setAttr ".phl[334]" 0;
	setAttr ".phl[335]" 0;
	setAttr ".phl[336]" 0;
	setAttr ".phl[337]" 0;
	setAttr ".phl[338]" 0;
	setAttr ".phl[339]" 0;
	setAttr ".phl[340]" 0;
	setAttr ".phl[341]" 0;
	setAttr ".phl[342]" 0;
	setAttr ".phl[343]" 0;
	setAttr ".phl[344]" 0;
	setAttr ".phl[345]" 0;
	setAttr ".phl[346]" 0;
	setAttr ".phl[347]" 0;
	setAttr ".phl[348]" 0;
	setAttr ".phl[349]" 0;
	setAttr ".phl[350]" 0;
	setAttr ".phl[351]" 0;
	setAttr ".phl[352]" 0;
	setAttr ".phl[353]" 0;
	setAttr ".phl[354]" 0;
	setAttr ".phl[355]" 0;
	setAttr ".phl[356]" 0;
	setAttr ".phl[357]" 0;
	setAttr ".phl[358]" 0;
	setAttr ".phl[359]" 0;
	setAttr ".phl[360]" 0;
	setAttr ".phl[361]" 0;
	setAttr ".phl[362]" 0;
	setAttr ".phl[363]" 0;
	setAttr ".phl[364]" 0;
	setAttr ".phl[365]" 0;
	setAttr ".phl[366]" 0;
	setAttr ".phl[367]" 0;
	setAttr ".phl[368]" 0;
	setAttr ".phl[369]" 0;
	setAttr ".phl[370]" 0;
	setAttr ".phl[371]" 0;
	setAttr ".phl[372]" 0;
	setAttr ".phl[373]" 0;
	setAttr ".phl[374]" 0;
	setAttr ".phl[375]" 0;
	setAttr ".phl[376]" 0;
	setAttr ".phl[377]" 0;
	setAttr ".phl[378]" 0;
	setAttr ".phl[379]" 0;
	setAttr ".phl[380]" 0;
	setAttr ".phl[381]" 0;
	setAttr ".phl[382]" 0;
	setAttr ".phl[383]" 0;
	setAttr ".phl[384]" 0;
	setAttr ".phl[385]" 0;
	setAttr ".phl[386]" 0;
	setAttr ".phl[387]" 0;
	setAttr ".phl[388]" 0;
	setAttr ".phl[389]" 0;
	setAttr ".phl[390]" 0;
	setAttr ".phl[391]" 0;
	setAttr ".phl[392]" 0;
	setAttr ".phl[393]" 0;
	setAttr ".phl[394]" 0;
	setAttr ".phl[395]" 0;
	setAttr ".phl[396]" 0;
	setAttr ".phl[397]" 0;
	setAttr ".phl[398]" 0;
	setAttr ".phl[399]" 0;
	setAttr ".phl[400]" 0;
	setAttr ".phl[401]" 0;
	setAttr ".phl[402]" 0;
	setAttr ".phl[403]" 0;
	setAttr ".phl[404]" 0;
	setAttr ".phl[405]" 0;
	setAttr ".phl[406]" 0;
	setAttr ".phl[407]" 0;
	setAttr ".phl[408]" 0;
	setAttr ".phl[409]" 0;
	setAttr ".phl[410]" 0;
	setAttr ".phl[411]" 0;
	setAttr ".phl[412]" 0;
	setAttr ".phl[413]" 0;
	setAttr ".phl[414]" 0;
	setAttr ".phl[415]" 0;
	setAttr ".phl[416]" 0;
	setAttr ".phl[417]" 0;
	setAttr ".phl[418]" 0;
	setAttr ".phl[419]" 0;
	setAttr ".phl[420]" 0;
	setAttr ".phl[421]" 0;
	setAttr ".phl[422]" 0;
	setAttr ".phl[423]" 0;
	setAttr ".phl[424]" 0;
	setAttr ".phl[425]" 0;
	setAttr ".phl[426]" 0;
	setAttr ".phl[427]" 0;
	setAttr ".phl[428]" 0;
	setAttr ".phl[429]" 0;
	setAttr ".phl[430]" 0;
	setAttr ".phl[431]" 0;
	setAttr ".phl[432]" 0;
	setAttr ".phl[433]" 0;
	setAttr ".phl[434]" 0;
	setAttr ".phl[435]" 0;
	setAttr ".phl[436]" 0;
	setAttr ".phl[437]" 0;
	setAttr ".ed" -type "dataReferenceEdits" 
		"RIGRN"
		"RIGRN" 0
		"RIG:MODELRN" 0
		"RIGRN" 31
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk0CTRL_HmNUL|RIG:RtArmFk0CTRL_SpaceNUL|RIG:RtArmFk0CTRL_AnimNUL|RIG:RtArmFk0CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk0CTRL_HmNUL|RIG:RtArmFk0CTRL_SpaceNUL|RIG:RtArmFk0CTRL_AnimNUL|RIG:RtArmFk0CTRL|RIG:RtArmCTRL_ATTRIBUTES" 
		"ikBlend" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk0CTRL_HmNUL|RIG:RtArmFk0CTRL_SpaceNUL|RIG:RtArmFk0CTRL_AnimNUL|RIG:RtArmFk0CTRL|RIG:RtArmCTRL_ATTRIBUTES" 
		"fk_vis" " -k 1 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk0CTRL_HmNUL|RIG:RtArmFk0CTRL_SpaceNUL|RIG:RtArmFk0CTRL_AnimNUL|RIG:RtArmFk0CTRL|RIG:RtArmCTRL_ATTRIBUTES" 
		"ik_vis" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk1CTRL_HmNUL|RIG:RtArmFk1CTRL_SpaceNUL|RIG:RtArmFk1CTRL_AnimNUL|RIG:RtArmFk1CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtArm|RIG:RtArmRig_HmNUL|RIG:RtArmFk_HmNUL|RIG:RtArmFk2CTRL_HmNUL|RIG:RtArmFk2CTRL_SpaceNUL|RIG:RtArmFk2CTRL_AnimNUL|RIG:RtArmFk2CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk0CTRL_HmNUL|RIG:LfArmFk0CTRL_SpaceNUL|RIG:LfArmFk0CTRL_AnimNUL|RIG:LfArmFk0CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk0CTRL_HmNUL|RIG:LfArmFk0CTRL_SpaceNUL|RIG:LfArmFk0CTRL_AnimNUL|RIG:LfArmFk0CTRL|RIG:LfArmCTRL_ATTRIBUTES" 
		"ikBlend" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk0CTRL_HmNUL|RIG:LfArmFk0CTRL_SpaceNUL|RIG:LfArmFk0CTRL_AnimNUL|RIG:LfArmFk0CTRL|RIG:LfArmCTRL_ATTRIBUTES" 
		"fk_vis" " -k 1 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk0CTRL_HmNUL|RIG:LfArmFk0CTRL_SpaceNUL|RIG:LfArmFk0CTRL_AnimNUL|RIG:LfArmFk0CTRL|RIG:LfArmCTRL_ATTRIBUTES" 
		"ik_vis" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk1CTRL_HmNUL|RIG:LfArmFk1CTRL_SpaceNUL|RIG:LfArmFk1CTRL_AnimNUL|RIG:LfArmFk1CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfArm|RIG:LfArmRig_HmNUL|RIG:LfArmFk_HmNUL|RIG:LfArmFk2CTRL_HmNUL|RIG:LfArmFk2CTRL_SpaceNUL|RIG:LfArmFk2CTRL_AnimNUL|RIG:LfArmFk2CTRL" 
		"rotate" " -type \"double3\" 0 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__Spine|RIG:SpinespineSpline0_JNT" 
		"visibility" " 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfLeg|RIG:LfLeg_CTRL_HmNUL|RIG:LfLeg_CTRL_SpaceNUL|RIG:LfLeg_CTRL_AnimNUL|RIG:LfLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndLfLegBox_CTRL_HmNUL|RIG:EndLfLegBox_CTRL_SpaceNUL|RIG:EndLfLegBox_CTRL_AnimNUL|RIG:EndLfLegBox_CTRL|RIG:LfLegSwitch" 
		"ikBlend" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfLeg|RIG:LfLeg_CTRL_HmNUL|RIG:LfLeg_CTRL_SpaceNUL|RIG:LfLeg_CTRL_AnimNUL|RIG:LfLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndLfLegBox_CTRL_HmNUL|RIG:EndLfLegBox_CTRL_SpaceNUL|RIG:EndLfLegBox_CTRL_AnimNUL|RIG:EndLfLegBox_CTRL|RIG:LfLegSwitch" 
		"ik_vis" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfLeg|RIG:LfLeg_CTRL_HmNUL|RIG:LfLeg_CTRL_SpaceNUL|RIG:LfLeg_CTRL_AnimNUL|RIG:LfLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndLfLegBox_CTRL_HmNUL|RIG:EndLfLegBox_CTRL_SpaceNUL|RIG:EndLfLegBox_CTRL_AnimNUL|RIG:EndLfLegBox_CTRL|RIG:LfLegSwitch" 
		"fk_vis" " -k 1 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfLeg|RIG:LfLeg_HmNUL|RIG:LfLeg0_JNT|RIG:LfLeg1_JNT|RIG:FkFoot0_CTRL_HmNUL|RIG:FkFoot0_CTRL_SpaceNUL|RIG:FkFoot0_CTRL_AnimNUL|RIG:FkFoot0_CTRL" 
		"rotate" " -type \"double3\" 150 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__LfLeg|RIG:LfLeg_HmNUL|RIG:LfLeg0_JNT1|RIG:FkToe0_CTRL_HmNUL|RIG:FkToe0_CTRL_SpaceNUL|RIG:FkToe0_CTRL_AnimNUL|RIG:FkToe0_CTRL" 
		"rotate" " -type \"double3\" -21 7 -115"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtLeg|RIG:RtLeg_CTRL_HmNUL|RIG:RtLeg_CTRL_SpaceNUL|RIG:RtLeg_CTRL_AnimNUL|RIG:RtLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndRtLegBox_CTRL_HmNUL|RIG:EndRtLegBox_CTRL_SpaceNUL|RIG:EndRtLegBox_CTRL_AnimNUL|RIG:EndRtLegBox_CTRL|RIG:RtLegSwitch" 
		"ikBlend" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtLeg|RIG:RtLeg_CTRL_HmNUL|RIG:RtLeg_CTRL_SpaceNUL|RIG:RtLeg_CTRL_AnimNUL|RIG:RtLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndRtLegBox_CTRL_HmNUL|RIG:EndRtLegBox_CTRL_SpaceNUL|RIG:EndRtLegBox_CTRL_AnimNUL|RIG:EndRtLegBox_CTRL|RIG:RtLegSwitch" 
		"ik_vis" " -k 1 1"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtLeg|RIG:RtLeg_CTRL_HmNUL|RIG:RtLeg_CTRL_SpaceNUL|RIG:RtLeg_CTRL_AnimNUL|RIG:RtLeg_CTRL|RIG:heelPivot_HmNUL|RIG:heelPivot_NUL|RIG:ballTwist_HmNUL|RIG:ballTwist_NUL|RIG:innerPivot_HmNUL|RIG:innerPivot_NUL|RIG:outerPivot_HmNUL|RIG:outerPivot_NUL|RIG:footCtrl_HmNUL|RIG:toePivot_HmNUL|RIG:toePivot_NUL|RIG:EndRtLegBox_CTRL_HmNUL|RIG:EndRtLegBox_CTRL_SpaceNUL|RIG:EndRtLegBox_CTRL_AnimNUL|RIG:EndRtLegBox_CTRL|RIG:RtLegSwitch" 
		"fk_vis" " -k 1 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtLeg|RIG:RtLeg_HmNUL|RIG:RtLeg0_JNT|RIG:RtLeg1_JNT|RIG:FkFoot_CTRL_HmNUL|RIG:FkFoot_CTRL_SpaceNUL|RIG:FkFoot_CTRL_AnimNUL|RIG:FkFoot_CTRL" 
		"rotate" " -type \"double3\" 150 0 0"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:world_CTRL|RIG:fly_CTRL_HmNUL|RIG:fly_CTRL|RIG:scale_CTRL_HmNUL|RIG:scale_CTRL|RIG:Rig_NUL|RIG:__RtLeg|RIG:RtLeg_HmNUL|RIG:RtLeg0_JNT1|RIG:FkToe_CTRL_HmNUL|RIG:FkToe_CTRL_SpaceNUL|RIG:FkToe_CTRL_AnimNUL|RIG:FkToe_CTRL" 
		"rotate" " -type \"double3\" -21 7 -115"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE1|RIG:__Crown|RIG:CrownRig_HmNUL|RIG:CrownFk_HmNUL|RIG:CrownFk0_CTRL_HmNUL|RIG:CrownFk0_CTRL_SpaceNUL|RIG:CrownFk0_CTRL_AnimNUL|RIG:CrownFk0_CTRL" 
		"translate" " -type \"double3\" 124.07235461003552 -4.0369827323594398 3.686509211881654"
		
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE1|RIG:__Crown|RIG:CrownRig_HmNUL|RIG:CrownFk_HmNUL|RIG:CrownFk0_CTRL_HmNUL|RIG:CrownFk0_CTRL_SpaceNUL|RIG:CrownFk0_CTRL_AnimNUL|RIG:CrownFk0_CTRL" 
		"rotate" " -type \"double3\" -2.6160251629711562 -14.516100835727412 13.686295146041628"
		
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE1|RIG:__Chalice|RIG:ChaliceRig_HmNUL|RIG:ChaliceFk_HmNUL|RIG:ChaliceFk0_CTRL_HmNUL|RIG:ChaliceFk0_CTRL_SpaceNUL|RIG:ChaliceFk0_CTRL_AnimNUL|RIG:ChaliceFk0_CTRL" 
		"translate" " -type \"double3\" 54.443816239431079 4.4476505173627787 -52.242385210921015"
		
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE1|RIG:__Chalice|RIG:ChaliceRig_HmNUL|RIG:ChaliceFk_HmNUL|RIG:ChaliceFk0_CTRL_HmNUL|RIG:ChaliceFk0_CTRL_SpaceNUL|RIG:ChaliceFk0_CTRL_AnimNUL|RIG:ChaliceFk0_CTRL" 
		"rotate" " -type \"double3\" 0 0 -74.472067591664043"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE1|RIG:__RtShoulder|RIG:RtShoulderBase_CTRL_HmNUL|RIG:RtShoulderBase_CTRL_SpaceNUL|RIG:RtShoulderBase_CTRL_AnimNUL|RIG:RtShoulderBase_CTRL" 
		"rotate" " -type \"double3\" -6.23 18.329 -1.006"
		2 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE2|RIG:__LfShoulder|RIG:LfShoulderBase_CTRL_HmNUL|RIG:LfShoulderBase_CTRL_SpaceNUL|RIG:LfShoulderBase_CTRL_AnimNUL|RIG:LfShoulderBase_CTRL" 
		"rotate" " -type \"double3\" -6.2295747280891556 18.328614318885197 -1.0059541464785688"
		
		2 "RIG:CTRL" "displayType" " 0"
		2 "RIG:CTRL" "visibility" " 1"
		"RIG:MODELRN" 554
		1 |RIG:MODEL:Root_JNT "Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT "Character" "ch" " -s 0 -ci 1 -at \"message\""
		
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT "Character" 
		"ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT "Character" "ch" " -s 0 -ci 1 -at \"message\""
		
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT "Character" 
		"ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT "Character" "ch" " -s 0 -ci 1 -at \"message\""
		
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT "Character" 
		"ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		1 |RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT 
		"Character" "ch" " -s 0 -ci 1 -at \"message\""
		2 "|RIG:MODEL:Root_JNT" "scale" " -type \"double3\" 1 1 1"
		2 "|RIG:MODEL:Root_JNT" "side" " 0"
		2 "|RIG:MODEL:Root_JNT" "type" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "scale" " -type \"double3\" 0.99999995555128274 0.99999995555128274 1"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "scale" 
		" -type \"double3\" 0.99999999389055183 0.99999999677329032 1.0000000000000004"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "drawStyle" 
		" 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "side" 
		" 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "type" 
		" 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"scale" " -type \"double3\" 0.99999998528040379 0.99999998528040368 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"scale" " -type \"double3\" 0.99999996388058321 0.99999996388058321 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"scale" " -type \"double3\" 1.0000000914263683 1.0000000296760871 1.0000001192092967"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"type" " 7"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"scale" " -type \"double3\" 1.0000000883206768 1.0000000745448281 1.0000000000000018"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"type" " 8"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"scale" " -type \"double3\" 1.0000000254376944 1.00000005734347 1.0000000097582107"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"type" " 9"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"scale" " -type \"double3\" 1.0000000397084912 1.0000000287096635 1.0000000502620736"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"type" " 10"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"scale" " -type \"double3\" 1.0000000726511713 1.0000000247824055 1.0000000674058813"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"type" " 11"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"scale" " -type \"double3\" 1.0000000726511709 1.0000000247824052 1.0000000674058815"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"type" " 12"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"scale" " -type \"double3\" 0.99999989173486048 0.99999995476172643 0.99999996951204084"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"type" " 9"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"scale" " -type \"double3\" 1.0000000816343075 1.0000000107310849 1.0000000404285554"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"type" " 10"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"scale" " -type \"double3\" 0.99999994371336842 0.99999995887371684 0.99999992601907139"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"type" " 11"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"scale" " -type \"double3\" 0.99999994616776855 0.99999997836460086 0.9999999873825528"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"type" " 12"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "scale" " -type \"double3\" 1.0000001556886875 1.0000001266787417 1.0000001819939961"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "type" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "scale" 
		" -type \"double3\" 0.99999996808156077 1.0000000376460778 0.99999998856014682"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "drawStyle" 
		" 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "side" 
		" 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "type" 
		" 3"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"scale" " -type \"double3\" 1.0000000181715569 1.0000000288884752 1.0000000606598662"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"type" " 4"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"scale" " -type \"double3\" 1.0000000311560442 0.9999999579790575 0.99999996124270607"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"type" " 5"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "scale" " -type \"double3\" 1.0000001545209678 1.0000002434724646 1.0000002663924477"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "type" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "scale" 
		" -type \"double3\" 1.0000000861290541 1.0000000361007579 1.0000000493028349"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "drawStyle" 
		" 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "side" 
		" 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "type" 
		" 3"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"scale" " -type \"double3\" 1.0000000232841146 1.0000000068251416 0.99999992612091693"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"type" " 4"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"scale" " -type \"double3\" 1.0000001823638052 1.000000067672735 1.0000001575946575"
		
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"drawStyle" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"type" " 5"
		2 "RIG:MODEL:LOD0" "visibility" " 1"
		2 "RIG:MODEL:JNTS" "displayType" " 2"
		2 "RIG:MODEL:JNTS" "visibility" " 1"
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT.translateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT.translateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT.translateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT.rotateX" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT.rotateY" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT.rotateZ" ""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateZ" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateX" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateY" 
		""
		3 "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateZ" 
		""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT.translateX" "RIGRN.placeHolderList[1]" "RIGRN.placeHolderList[2]" 
		"RIG:MODEL:Root_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT.translateY" "RIGRN.placeHolderList[3]" "RIGRN.placeHolderList[4]" 
		"RIG:MODEL:Root_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT.translateZ" "RIGRN.placeHolderList[5]" "RIGRN.placeHolderList[6]" 
		"RIG:MODEL:Root_JNT.tz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.parentMatrix" "RIGRN.placeHolderList[7]" 
		""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT.rotateX" "RIGRN.placeHolderList[8]" "RIGRN.placeHolderList[9]" 
		"RIG:MODEL:Root_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT.rotateY" "RIGRN.placeHolderList[10]" "RIGRN.placeHolderList[11]" 
		"RIG:MODEL:Root_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT.rotateZ" "RIGRN.placeHolderList[12]" "RIGRN.placeHolderList[13]" 
		"RIG:MODEL:Root_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateOrder" "RIGRN.placeHolderList[14]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.jointOrient" "RIGRN.placeHolderList[15]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.segmentScaleCompensate" "RIGRN.placeHolderList[16]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.inverseScale" "RIGRN.placeHolderList[17]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.Character" "RIGRN.placeHolderList[18]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateAxis" "RIGRN.placeHolderList[19]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.inverseScale" 
		"RIGRN.placeHolderList[20]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[21]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateX" "RIGRN.placeHolderList[22]" 
		"RIGRN.placeHolderList[23]" "RIG:MODEL:Spine0_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateY" "RIGRN.placeHolderList[24]" 
		"RIGRN.placeHolderList[25]" "RIG:MODEL:Spine0_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateZ" "RIGRN.placeHolderList[26]" 
		"RIGRN.placeHolderList[27]" "RIG:MODEL:Spine0_JNT.tz"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateX" "RIGRN.placeHolderList[28]" "RIGRN.placeHolderList[29]" 
		"RIG:MODEL:Spine0_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateY" "RIGRN.placeHolderList[30]" "RIGRN.placeHolderList[31]" 
		"RIG:MODEL:Spine0_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateZ" "RIGRN.placeHolderList[32]" "RIGRN.placeHolderList[33]" 
		"RIG:MODEL:Spine0_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateOrder" "RIGRN.placeHolderList[34]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.jointOrient" "RIGRN.placeHolderList[35]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[36]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.Character" "RIGRN.placeHolderList[37]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateAxis" "RIGRN.placeHolderList[38]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.inverseScale" 
		"RIGRN.placeHolderList[39]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[40]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateX" "RIGRN.placeHolderList[41]" 
		"RIGRN.placeHolderList[42]" "RIG:MODEL:Spine1_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateY" "RIGRN.placeHolderList[43]" 
		"RIGRN.placeHolderList[44]" "RIG:MODEL:Spine1_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateZ" "RIGRN.placeHolderList[45]" 
		"RIGRN.placeHolderList[46]" "RIG:MODEL:Spine1_JNT.tz"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateX" "RIGRN.placeHolderList[47]" 
		"RIGRN.placeHolderList[48]" "RIG:MODEL:Spine1_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateY" "RIGRN.placeHolderList[49]" 
		"RIGRN.placeHolderList[50]" "RIG:MODEL:Spine1_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateZ" "RIGRN.placeHolderList[51]" 
		"RIGRN.placeHolderList[52]" "RIG:MODEL:Spine1_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[53]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.jointOrient" 
		"RIGRN.placeHolderList[54]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[55]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.Character" 
		"RIGRN.placeHolderList[56]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[57]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.inverseScale" 
		"RIGRN.placeHolderList[58]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[59]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateX" 
		"RIGRN.placeHolderList[60]" "RIGRN.placeHolderList[61]" "RIG:MODEL:Spine2_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateY" 
		"RIGRN.placeHolderList[62]" "RIGRN.placeHolderList[63]" "RIG:MODEL:Spine2_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateZ" 
		"RIGRN.placeHolderList[64]" "RIGRN.placeHolderList[65]" "RIG:MODEL:Spine2_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateX" 
		"RIGRN.placeHolderList[66]" "RIGRN.placeHolderList[67]" "RIG:MODEL:Spine2_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateY" 
		"RIGRN.placeHolderList[68]" "RIGRN.placeHolderList[69]" "RIG:MODEL:Spine2_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateZ" 
		"RIGRN.placeHolderList[70]" "RIGRN.placeHolderList[71]" "RIG:MODEL:Spine2_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[72]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.jointOrient" 
		"RIGRN.placeHolderList[73]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[74]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.Character" 
		"RIGRN.placeHolderList[75]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[76]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.inverseScale" 
		"RIGRN.placeHolderList[77]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[78]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateX" 
		"RIGRN.placeHolderList[79]" "RIGRN.placeHolderList[80]" "RIG:MODEL:Spine3_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateY" 
		"RIGRN.placeHolderList[81]" "RIGRN.placeHolderList[82]" "RIG:MODEL:Spine3_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateZ" 
		"RIGRN.placeHolderList[83]" "RIGRN.placeHolderList[84]" "RIG:MODEL:Spine3_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateX" 
		"RIGRN.placeHolderList[85]" "RIGRN.placeHolderList[86]" "RIG:MODEL:Spine3_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateY" 
		"RIGRN.placeHolderList[87]" "RIGRN.placeHolderList[88]" "RIG:MODEL:Spine3_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateZ" 
		"RIGRN.placeHolderList[89]" "RIGRN.placeHolderList[90]" "RIG:MODEL:Spine3_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[91]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.jointOrient" 
		"RIGRN.placeHolderList[92]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[93]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.Character" 
		"RIGRN.placeHolderList[94]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[95]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.inverseScale" 
		"RIGRN.placeHolderList[96]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[97]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateX" 
		"RIGRN.placeHolderList[98]" "RIGRN.placeHolderList[99]" "RIG:MODEL:Neck0_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateY" 
		"RIGRN.placeHolderList[100]" "RIGRN.placeHolderList[101]" "RIG:MODEL:Neck0_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateZ" 
		"RIGRN.placeHolderList[102]" "RIGRN.placeHolderList[103]" "RIG:MODEL:Neck0_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateX" 
		"RIGRN.placeHolderList[104]" "RIGRN.placeHolderList[105]" "RIG:MODEL:Neck0_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateY" 
		"RIGRN.placeHolderList[106]" "RIGRN.placeHolderList[107]" "RIG:MODEL:Neck0_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateZ" 
		"RIGRN.placeHolderList[108]" "RIGRN.placeHolderList[109]" "RIG:MODEL:Neck0_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[110]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.jointOrient" 
		"RIGRN.placeHolderList[111]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[112]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.Character" 
		"RIGRN.placeHolderList[113]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[114]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.inverseScale" 
		"RIGRN.placeHolderList[115]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[116]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateX" 
		"RIGRN.placeHolderList[117]" "RIGRN.placeHolderList[118]" "RIG:MODEL:Head0_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateY" 
		"RIGRN.placeHolderList[119]" "RIGRN.placeHolderList[120]" "RIG:MODEL:Head0_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateZ" 
		"RIGRN.placeHolderList[121]" "RIGRN.placeHolderList[122]" "RIG:MODEL:Head0_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateX" 
		"RIGRN.placeHolderList[123]" "RIGRN.placeHolderList[124]" "RIG:MODEL:Head0_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateY" 
		"RIGRN.placeHolderList[125]" "RIGRN.placeHolderList[126]" "RIG:MODEL:Head0_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateZ" 
		"RIGRN.placeHolderList[127]" "RIGRN.placeHolderList[128]" "RIG:MODEL:Head0_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[129]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.jointOrient" 
		"RIGRN.placeHolderList[130]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[131]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.Character" 
		"RIGRN.placeHolderList[132]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[133]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[134]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[135]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateX" 
		"RIGRN.placeHolderList[136]" "RIGRN.placeHolderList[137]" "RIG:MODEL:LfArm0_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateY" 
		"RIGRN.placeHolderList[138]" "RIGRN.placeHolderList[139]" "RIG:MODEL:LfArm0_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[140]" "RIGRN.placeHolderList[141]" "RIG:MODEL:LfArm0_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[142]" "RIGRN.placeHolderList[143]" "RIG:MODEL:LfArm0_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[144]" "RIGRN.placeHolderList[145]" "RIG:MODEL:LfArm0_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[146]" "RIGRN.placeHolderList[147]" "RIG:MODEL:LfArm0_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[148]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[149]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[150]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.Character" 
		"RIGRN.placeHolderList[151]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[152]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[153]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateX" 
		"RIGRN.placeHolderList[154]" "RIGRN.placeHolderList[155]" "RIG:MODEL:LfArm1_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateY" 
		"RIGRN.placeHolderList[156]" "RIGRN.placeHolderList[157]" "RIG:MODEL:LfArm1_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[158]" "RIGRN.placeHolderList[159]" "RIG:MODEL:LfArm1_JNT.tz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[160]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[161]" "RIGRN.placeHolderList[162]" "RIG:MODEL:LfArm1_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[163]" "RIGRN.placeHolderList[164]" "RIG:MODEL:LfArm1_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[165]" "RIGRN.placeHolderList[166]" "RIG:MODEL:LfArm1_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[167]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[168]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[169]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.Character" 
		"RIGRN.placeHolderList[170]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[171]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[172]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateX" 
		"RIGRN.placeHolderList[173]" "RIGRN.placeHolderList[174]" "RIG:MODEL:LfArm2_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateY" 
		"RIGRN.placeHolderList[175]" "RIGRN.placeHolderList[176]" "RIG:MODEL:LfArm2_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[177]" "RIGRN.placeHolderList[178]" "RIG:MODEL:LfArm2_JNT.tz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[179]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[180]" "RIGRN.placeHolderList[181]" "RIG:MODEL:LfArm2_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[182]" "RIGRN.placeHolderList[183]" "RIG:MODEL:LfArm2_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[184]" "RIGRN.placeHolderList[185]" "RIG:MODEL:LfArm2_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[186]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[187]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[188]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.Character" 
		"RIGRN.placeHolderList[189]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[190]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[191]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[192]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateX" 
		"RIGRN.placeHolderList[193]" "RIGRN.placeHolderList[194]" "RIG:MODEL:LfArm3_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateY" 
		"RIGRN.placeHolderList[195]" "RIGRN.placeHolderList[196]" "RIG:MODEL:LfArm3_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[197]" "RIGRN.placeHolderList[198]" "RIG:MODEL:LfArm3_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[199]" "RIGRN.placeHolderList[200]" "RIG:MODEL:LfArm3_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[201]" "RIGRN.placeHolderList[202]" "RIG:MODEL:LfArm3_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[203]" "RIGRN.placeHolderList[204]" "RIG:MODEL:LfArm3_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[205]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[206]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[207]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.Character" 
		"RIGRN.placeHolderList[208]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[209]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[210]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[211]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateX" 
		"RIGRN.placeHolderList[212]" "RIGRN.placeHolderList[213]" "RIG:MODEL:RtArm0_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateY" 
		"RIGRN.placeHolderList[214]" "RIGRN.placeHolderList[215]" "RIG:MODEL:RtArm0_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[216]" "RIGRN.placeHolderList[217]" "RIG:MODEL:RtArm0_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[218]" "RIGRN.placeHolderList[219]" "RIG:MODEL:RtArm0_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[220]" "RIGRN.placeHolderList[221]" "RIG:MODEL:RtArm0_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[222]" "RIGRN.placeHolderList[223]" "RIG:MODEL:RtArm0_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[224]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[225]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[226]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.Character" 
		"RIGRN.placeHolderList[227]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[228]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[229]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateX" 
		"RIGRN.placeHolderList[230]" "RIGRN.placeHolderList[231]" "RIG:MODEL:RtArm1_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateY" 
		"RIGRN.placeHolderList[232]" "RIGRN.placeHolderList[233]" "RIG:MODEL:RtArm1_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[234]" "RIGRN.placeHolderList[235]" "RIG:MODEL:RtArm1_JNT.tz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[236]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[237]" "RIGRN.placeHolderList[238]" "RIG:MODEL:RtArm1_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[239]" "RIGRN.placeHolderList[240]" "RIG:MODEL:RtArm1_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[241]" "RIGRN.placeHolderList[242]" "RIG:MODEL:RtArm1_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[243]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[244]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[245]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.Character" 
		"RIGRN.placeHolderList[246]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[247]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[248]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateX" 
		"RIGRN.placeHolderList[249]" "RIGRN.placeHolderList[250]" "RIG:MODEL:RtArm2_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateY" 
		"RIGRN.placeHolderList[251]" "RIGRN.placeHolderList[252]" "RIG:MODEL:RtArm2_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[253]" "RIGRN.placeHolderList[254]" "RIG:MODEL:RtArm2_JNT.tz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[255]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[256]" "RIGRN.placeHolderList[257]" "RIG:MODEL:RtArm2_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[258]" "RIGRN.placeHolderList[259]" "RIG:MODEL:RtArm2_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[260]" "RIGRN.placeHolderList[261]" "RIG:MODEL:RtArm2_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[262]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[263]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[264]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.Character" 
		"RIGRN.placeHolderList[265]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[266]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[267]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[268]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateX" 
		"RIGRN.placeHolderList[269]" "RIGRN.placeHolderList[270]" "RIG:MODEL:RtArm3_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateY" 
		"RIGRN.placeHolderList[271]" "RIGRN.placeHolderList[272]" "RIG:MODEL:RtArm3_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[273]" "RIGRN.placeHolderList[274]" "RIG:MODEL:RtArm3_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[275]" "RIGRN.placeHolderList[276]" "RIG:MODEL:RtArm3_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[277]" "RIGRN.placeHolderList[278]" "RIG:MODEL:RtArm3_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[279]" "RIGRN.placeHolderList[280]" "RIG:MODEL:RtArm3_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[281]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[282]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[283]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.Character" 
		"RIGRN.placeHolderList[284]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[285]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[286]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateX" "RIGRN.placeHolderList[287]" 
		"RIGRN.placeHolderList[288]" "RIG:MODEL:LfLeg0_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateY" "RIGRN.placeHolderList[289]" 
		"RIGRN.placeHolderList[290]" "RIG:MODEL:LfLeg0_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateZ" "RIGRN.placeHolderList[291]" 
		"RIGRN.placeHolderList[292]" "RIG:MODEL:LfLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[293]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateX" "RIGRN.placeHolderList[294]" "RIGRN.placeHolderList[295]" 
		"RIG:MODEL:LfLeg0_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateY" "RIGRN.placeHolderList[296]" "RIGRN.placeHolderList[297]" 
		"RIG:MODEL:LfLeg0_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateZ" "RIGRN.placeHolderList[298]" "RIGRN.placeHolderList[299]" 
		"RIG:MODEL:LfLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[300]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.jointOrient" "RIGRN.placeHolderList[301]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[302]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.Character" "RIGRN.placeHolderList[303]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[304]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[305]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateX" "RIGRN.placeHolderList[306]" 
		"RIGRN.placeHolderList[307]" "RIG:MODEL:LfLeg1_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateY" "RIGRN.placeHolderList[308]" 
		"RIGRN.placeHolderList[309]" "RIG:MODEL:LfLeg1_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateZ" "RIGRN.placeHolderList[310]" 
		"RIGRN.placeHolderList[311]" "RIG:MODEL:LfLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[312]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateX" "RIGRN.placeHolderList[313]" 
		"RIGRN.placeHolderList[314]" "RIG:MODEL:LfLeg1_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateY" "RIGRN.placeHolderList[315]" 
		"RIGRN.placeHolderList[316]" "RIG:MODEL:LfLeg1_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateZ" "RIGRN.placeHolderList[317]" 
		"RIGRN.placeHolderList[318]" "RIG:MODEL:LfLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[319]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[320]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[321]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.Character" 
		"RIGRN.placeHolderList[322]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[323]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[324]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[325]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[326]" "RIGRN.placeHolderList[327]" "RIG:MODEL:LfLeg2_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[328]" "RIGRN.placeHolderList[329]" "RIG:MODEL:LfLeg2_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[330]" "RIGRN.placeHolderList[331]" "RIG:MODEL:LfLeg2_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[332]" "RIGRN.placeHolderList[333]" "RIG:MODEL:LfLeg2_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[334]" "RIGRN.placeHolderList[335]" "RIG:MODEL:LfLeg2_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[336]" "RIGRN.placeHolderList[337]" "RIG:MODEL:LfLeg2_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[338]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[339]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[340]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.Character" 
		"RIGRN.placeHolderList[341]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[342]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[343]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[344]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[345]" "RIGRN.placeHolderList[346]" "RIG:MODEL:LfLeg3_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[347]" "RIGRN.placeHolderList[348]" "RIG:MODEL:LfLeg3_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[349]" "RIGRN.placeHolderList[350]" "RIG:MODEL:LfLeg3_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[351]" "RIGRN.placeHolderList[352]" "RIG:MODEL:LfLeg3_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[353]" "RIGRN.placeHolderList[354]" "RIG:MODEL:LfLeg3_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[355]" "RIGRN.placeHolderList[356]" "RIG:MODEL:LfLeg3_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[357]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[358]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[359]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.Character" 
		"RIGRN.placeHolderList[360]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[361]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[362]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateX" "RIGRN.placeHolderList[363]" 
		"RIGRN.placeHolderList[364]" "RIG:MODEL:RtLeg0_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateY" "RIGRN.placeHolderList[365]" 
		"RIGRN.placeHolderList[366]" "RIG:MODEL:RtLeg0_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateZ" "RIGRN.placeHolderList[367]" 
		"RIGRN.placeHolderList[368]" "RIG:MODEL:RtLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[369]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateX" "RIGRN.placeHolderList[370]" "RIGRN.placeHolderList[371]" 
		"RIG:MODEL:RtLeg0_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateY" "RIGRN.placeHolderList[372]" "RIGRN.placeHolderList[373]" 
		"RIG:MODEL:RtLeg0_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateZ" "RIGRN.placeHolderList[374]" "RIGRN.placeHolderList[375]" 
		"RIG:MODEL:RtLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[376]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.jointOrient" "RIGRN.placeHolderList[377]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[378]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.Character" "RIGRN.placeHolderList[379]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[380]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[381]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateX" "RIGRN.placeHolderList[382]" 
		"RIGRN.placeHolderList[383]" "RIG:MODEL:RtLeg1_JNT.tx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateY" "RIGRN.placeHolderList[384]" 
		"RIGRN.placeHolderList[385]" "RIG:MODEL:RtLeg1_JNT.ty"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateZ" "RIGRN.placeHolderList[386]" 
		"RIGRN.placeHolderList[387]" "RIG:MODEL:RtLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[388]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateX" "RIGRN.placeHolderList[389]" 
		"RIGRN.placeHolderList[390]" "RIG:MODEL:RtLeg1_JNT.rx"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateY" "RIGRN.placeHolderList[391]" 
		"RIGRN.placeHolderList[392]" "RIG:MODEL:RtLeg1_JNT.ry"
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateZ" "RIGRN.placeHolderList[393]" 
		"RIGRN.placeHolderList[394]" "RIG:MODEL:RtLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[395]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[396]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[397]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.Character" 
		"RIGRN.placeHolderList[398]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[399]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[400]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[401]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[402]" "RIGRN.placeHolderList[403]" "RIG:MODEL:RtLeg2_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[404]" "RIGRN.placeHolderList[405]" "RIG:MODEL:RtLeg2_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[406]" "RIGRN.placeHolderList[407]" "RIG:MODEL:RtLeg2_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[408]" "RIGRN.placeHolderList[409]" "RIG:MODEL:RtLeg2_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[410]" "RIGRN.placeHolderList[411]" "RIG:MODEL:RtLeg2_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[412]" "RIGRN.placeHolderList[413]" "RIG:MODEL:RtLeg2_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[414]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[415]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[416]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.Character" 
		"RIGRN.placeHolderList[417]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[418]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[419]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[420]" ""
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[421]" "RIGRN.placeHolderList[422]" "RIG:MODEL:RtLeg3_JNT.tx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[423]" "RIGRN.placeHolderList[424]" "RIG:MODEL:RtLeg3_JNT.ty"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[425]" "RIGRN.placeHolderList[426]" "RIG:MODEL:RtLeg3_JNT.tz"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[427]" "RIGRN.placeHolderList[428]" "RIG:MODEL:RtLeg3_JNT.rx"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[429]" "RIGRN.placeHolderList[430]" "RIG:MODEL:RtLeg3_JNT.ry"
		
		5 0 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[431]" "RIGRN.placeHolderList[432]" "RIG:MODEL:RtLeg3_JNT.rz"
		
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[433]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[434]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[435]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.Character" 
		"RIGRN.placeHolderList[436]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[437]" "";
	setAttr ".ptag" -type "string" "";
lockNode -l 1 ;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "9EBDBA84-41C8-A8D5-3AB9-2AAE4428660D";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 120 -ast 1 -aet 200 ";
	setAttr ".st" 6;
createNode HIKCharacterNode -n "Character1";
	rename -uid "A9420323-49EB-BC2D-75EB-7CABDF8447F6";
	setAttr ".OutputCharacterDefinition" -type "HIKCharacter" ;
	setAttr ".InputCharacterizationLock" yes;
	setAttr ".HipsTy" 55.191199440879132;
	setAttr ".HipsTz" -2.2396820794169496;
	setAttr ".HipsMinRLimitx" -360;
	setAttr ".HipsMinRLimity" -360;
	setAttr ".HipsMinRLimitz" -360;
	setAttr ".HipsMaxRLimitx" 360;
	setAttr ".HipsMaxRLimity" 360;
	setAttr ".HipsMaxRLimitz" 360;
	setAttr ".LeftUpLegTx" 24.896348910428696;
	setAttr ".LeftUpLegTy" 47.46058026766169;
	setAttr ".LeftUpLegTz" 0.95734403338759666;
	setAttr ".LeftUpLegRx" -102.26478604801068;
	setAttr ".LeftUpLegRy" -17.781583053252529;
	setAttr ".LeftUpLegRz" -94.720557086805783;
	setAttr ".LeftUpLegSx" 0.99999999999999978;
	setAttr ".LeftUpLegSz" 0.99999999999999978;
	setAttr ".LeftUpLegJointOrientx" -102.26478635579774;
	setAttr ".LeftUpLegJointOrienty" -17.781587467886478;
	setAttr ".LeftUpLegJointOrientz" -94.720556078954246;
	setAttr ".LeftUpLegMinRLimitx" -360;
	setAttr ".LeftUpLegMinRLimity" -360;
	setAttr ".LeftUpLegMinRLimitz" -360;
	setAttr ".LeftUpLegMaxRLimitx" 360;
	setAttr ".LeftUpLegMaxRLimity" 360;
	setAttr ".LeftUpLegMaxRLimitz" 360;
	setAttr ".LeftLegTx" 23.232967428592616;
	setAttr ".LeftLegTy" 27.316983511963681;
	setAttr ".LeftLegTz" 7.4395921002553838;
	setAttr ".LeftLegRx" -107.00091567701803;
	setAttr ".LeftLegRy" 46.224996299049131;
	setAttr ".LeftLegRz" -110.96824181081286;
	setAttr ".LeftLegSx" 0.99999999999999989;
	setAttr ".LeftLegSy" 0.99999999999999978;
	setAttr ".LeftLegSz" 0.99999999999999978;
	setAttr ".LeftLegJointOrientz" 65.67217566039028;
	setAttr ".LeftLegMinRLimitx" -360;
	setAttr ".LeftLegMinRLimity" -360;
	setAttr ".LeftLegMinRLimitz" -360;
	setAttr ".LeftLegMaxRLimitx" 360;
	setAttr ".LeftLegMaxRLimity" 360;
	setAttr ".LeftLegMaxRLimitz" 360;
	setAttr ".LeftFootTx" 19.28642749105838;
	setAttr ".LeftFootTy" 17.018837839851194;
	setAttr ".LeftFootTz" -4.0708299658502387;
	setAttr ".LeftFootRx" 93.371430498796386;
	setAttr ".LeftFootRy" 11.312835124006012;
	setAttr ".LeftFootRz" -94.801311348588584;
	setAttr ".LeftFootSx" 0.99999999999999978;
	setAttr ".LeftFootSy" 0.99999999999999989;
	setAttr ".LeftFootSz" 0.99999999999999989;
	setAttr ".LeftFootJointOrientx" -171.61346534149902;
	setAttr ".LeftFootJointOrienty" -5.8510961805819512;
	setAttr ".LeftFootJointOrientz" -37.121519227117467;
	setAttr ".LeftFootMinRLimitx" -360;
	setAttr ".LeftFootMinRLimity" -360;
	setAttr ".LeftFootMinRLimitz" -360;
	setAttr ".LeftFootMaxRLimitx" 360;
	setAttr ".LeftFootMaxRLimity" 360;
	setAttr ".LeftFootMaxRLimitz" 360;
	setAttr ".RightUpLegTx" -24.8963;
	setAttr ".RightUpLegTy" 47.4606;
	setAttr ".RightUpLegTz" 0.95734400000000308;
	setAttr ".RightUpLegRx" 77.735213774266057;
	setAttr ".RightUpLegRy" 17.781585602363176;
	setAttr ".RightUpLegRz" 94.720556504849256;
	setAttr ".RightUpLegSx" 0.99999999999999989;
	setAttr ".RightUpLegSy" 0.99999999999999989;
	setAttr ".RightUpLegSz" 0.99999999999999989;
	setAttr ".RightUpLegJointOrientx" 77.735213644202275;
	setAttr ".RightUpLegJointOrienty" 17.781587467886464;
	setAttr ".RightUpLegJointOrientz" 94.72055607895426;
	setAttr ".RightUpLegMinRLimitx" -360;
	setAttr ".RightUpLegMinRLimity" -360;
	setAttr ".RightUpLegMinRLimitz" -360;
	setAttr ".RightUpLegMaxRLimitx" 360;
	setAttr ".RightUpLegMaxRLimity" 360;
	setAttr ".RightUpLegMaxRLimitz" 360;
	setAttr ".RightLegTx" -23.232999848846962;
	setAttr ".RightLegTy" 27.316999820917051;
	setAttr ".RightLegTz" 7.439589404714269;
	setAttr ".RightLegRx" 72.999081790850084;
	setAttr ".RightLegRy" -46.225004234033975;
	setAttr ".RightLegRz" 110.96824531761882;
	setAttr ".RightLegSx" 0.99999999999999989;
	setAttr ".RightLegSy" 0.99999999999999989;
	setAttr ".RightLegSz" 0.99999999999999989;
	setAttr ".RightLegJointOrientx" 3.0788460863072449e-015;
	setAttr ".RightLegJointOrienty" 4.7708320221952728e-015;
	setAttr ".RightLegJointOrientz" 65.672175660390252;
	setAttr ".RightLegMinRLimitx" -360;
	setAttr ".RightLegMinRLimity" -360;
	setAttr ".RightLegMinRLimitz" -360;
	setAttr ".RightLegMaxRLimitx" 360;
	setAttr ".RightLegMaxRLimity" 360;
	setAttr ".RightLegMaxRLimitz" 360;
	setAttr ".RightFootTx" -19.286399847029703;
	setAttr ".RightFootTy" 17.018799873420594;
	setAttr ".RightFootTz" -4.0708306416367765;
	setAttr ".RightFootRx" -86.6299508290018;
	setAttr ".RightFootRy" -11.312854570401214;
	setAttr ".RightFootRz" 94.801313402914218;
	setAttr ".RightFootSx" 0.99999999999999978;
	setAttr ".RightFootSy" 0.99999999999999967;
	setAttr ".RightFootSz" 0.99999999999999967;
	setAttr ".RightFootJointOrientx" -171.61346534149922;
	setAttr ".RightFootJointOrienty" -5.8510961805819548;
	setAttr ".RightFootJointOrientz" -37.121519227117439;
	setAttr ".RightFootMinRLimitx" -360;
	setAttr ".RightFootMinRLimity" -360;
	setAttr ".RightFootMinRLimitz" -360;
	setAttr ".RightFootMaxRLimitx" 360;
	setAttr ".RightFootMaxRLimity" 360;
	setAttr ".RightFootMaxRLimitz" 360;
	setAttr ".SpineTx" 8.0118685686509011e-032;
	setAttr ".SpineTy" 58.573733546136459;
	setAttr ".SpineTz" -6.0232296347597458;
	setAttr ".SpineRx" 90;
	setAttr ".SpineRy" -10.518727472690843;
	setAttr ".SpineRz" 90;
	setAttr ".SpineSx" 0.99999999999999989;
	setAttr ".SpineSy" 0.99999999999999989;
	setAttr ".SpineJointOrientx" 89.999999999999972;
	setAttr ".SpineJointOrienty" -10.518727472690843;
	setAttr ".SpineJointOrientz" 89.999999999999972;
	setAttr ".SpineMinRLimitx" -360;
	setAttr ".SpineMinRLimity" -360;
	setAttr ".SpineMinRLimitz" -360;
	setAttr ".SpineMaxRLimitx" 360;
	setAttr ".SpineMaxRLimity" 360;
	setAttr ".SpineMaxRLimitz" 360;
	setAttr ".LeftArmTx" 23.309993628952476;
	setAttr ".LeftArmTy" 102.28634153983243;
	setAttr ".LeftArmTz" -3.940863159667638;
	setAttr ".LeftArmRx" 84.651154409916131;
	setAttr ".LeftArmRy" -0.74460443259397047;
	setAttr ".LeftArmRz" 1.5706547882074837;
	setAttr ".LeftArmSy" 0.99999999999999989;
	setAttr ".LeftArmSz" 0.99999999999999978;
	setAttr ".LeftArmJointOrientx" -5.4729899936903816;
	setAttr ".LeftArmJointOrienty" -69.56202227876075;
	setAttr ".LeftArmJointOrientz" 17.310288583888219;
	setAttr ".LeftArmMinRLimitx" -360;
	setAttr ".LeftArmMinRLimity" -360;
	setAttr ".LeftArmMinRLimitz" -360;
	setAttr ".LeftArmMaxRLimitx" 360;
	setAttr ".LeftArmMaxRLimity" 360;
	setAttr ".LeftArmMaxRLimitz" 360;
	setAttr ".LeftForeArmTx" 46.948709025447201;
	setAttr ".LeftForeArmTy" 102.28634153983235;
	setAttr ".LeftForeArmTz" -3.9408631596676402;
	setAttr ".LeftForeArmRx" 85.42405637130959;
	setAttr ".LeftForeArmRy" -0.70732896780781707;
	setAttr ".LeftForeArmRz" 2.2090125653840365;
	setAttr ".LeftForeArmSy" 0.99999999999999989;
	setAttr ".LeftForeArmSz" 0.99999999999999978;
	setAttr ".LeftForeArmJointOrientx" -1.1131941385122312e-014;
	setAttr ".LeftForeArmJointOrienty" 1.192708005548819e-014;
	setAttr ".LeftForeArmJointOrientz" 23.928552342924124;
	setAttr ".LeftForeArmMinRLimitx" -360;
	setAttr ".LeftForeArmMinRLimity" -360;
	setAttr ".LeftForeArmMinRLimitz" -360;
	setAttr ".LeftForeArmMaxRLimitx" 360;
	setAttr ".LeftForeArmMaxRLimity" 360;
	setAttr ".LeftForeArmMaxRLimitz" 360;
	setAttr ".LeftHandTx" 69.296476353955441;
	setAttr ".LeftHandTy" 102.28634158822945;
	setAttr ".LeftHandTz" -3.9408623517545984;
	setAttr ".LeftHandRx" 85.42405637130959;
	setAttr ".LeftHandRy" -0.70732896780781707;
	setAttr ".LeftHandRz" 2.2090125653840365;
	setAttr ".LeftHandSy" 0.99999999999999989;
	setAttr ".LeftHandSz" 0.99999999999999978;
	setAttr ".LeftHandMinRLimitx" -360;
	setAttr ".LeftHandMinRLimity" -360;
	setAttr ".LeftHandMinRLimitz" -360;
	setAttr ".LeftHandMaxRLimitx" 360;
	setAttr ".LeftHandMaxRLimity" 360;
	setAttr ".LeftHandMaxRLimitz" 360;
	setAttr ".RightArmTx" -23.309835259920057;
	setAttr ".RightArmTy" 102.28639146900886;
	setAttr ".RightArmTz" -3.9408299664687338;
	setAttr ".RightArmRx" -96.318513419099133;
	setAttr ".RightArmRy" 1.5332265183633453;
	setAttr ".RightArmRz" -0.37579364889634681;
	setAttr ".RightArmSx" 0.99999999999999978;
	setAttr ".RightArmSy" 0.99999999999999978;
	setAttr ".RightArmSz" 0.99999999999999978;
	setAttr ".RightArmJointOrientx" -5.4729899936903115;
	setAttr ".RightArmJointOrienty" -69.562022278760779;
	setAttr ".RightArmJointOrientz" 17.310288583888298;
	setAttr ".RightArmMinRLimitx" -360;
	setAttr ".RightArmMinRLimity" -360;
	setAttr ".RightArmMinRLimitz" -360;
	setAttr ".RightArmMaxRLimitx" 360;
	setAttr ".RightArmMaxRLimity" 360;
	setAttr ".RightArmMaxRLimitz" 360;
	setAttr ".RightForeArmTx" -46.940971507100116;
	setAttr ".RightForeArmTy" 101.78839442662002;
	setAttr ".RightForeArmTz" -3.6045913265366183;
	setAttr ".RightForeArmRx" -95.667852665921956;
	setAttr ".RightForeArmRy" 0.97874662640114896;
	setAttr ".RightForeArmRz" -2.8984993227163023;
	setAttr ".RightForeArmSx" 0.99999999999999978;
	setAttr ".RightForeArmSy" 0.99999999999999989;
	setAttr ".RightForeArmSz" 0.99999999999999978;
	setAttr ".RightForeArmJointOrientx" 8.5377366318522488e-007;
	setAttr ".RightForeArmJointOrienty" 7.9911436276982939e-014;
	setAttr ".RightForeArmJointOrientz" 23.92855234292411;
	setAttr ".RightForeArmMinRLimitx" -360;
	setAttr ".RightForeArmMinRLimity" -360;
	setAttr ".RightForeArmMinRLimitz" -360;
	setAttr ".RightForeArmMaxRLimitx" 360;
	setAttr ".RightForeArmMaxRLimity" 360;
	setAttr ".RightForeArmMaxRLimitz" 360;
	setAttr ".RightHandTx" -69.286839821518328;
	setAttr ".RightHandTy" 102.05216745908292;
	setAttr ".RightHandTz" -3.4823463088321849;
	setAttr ".RightHandRx" -95.472367134499763;
	setAttr ".RightHandRy" -2.8802337813790078;
	setAttr ".RightHandRz" -2.9017448269842694;
	setAttr ".RightHandSx" 0.99999999999999967;
	setAttr ".RightHandSy" 0.99999999999999989;
	setAttr ".RightHandSz" 0.99999999999999967;
	setAttr ".RightHandMinRLimitx" -360;
	setAttr ".RightHandMinRLimity" -360;
	setAttr ".RightHandMinRLimitz" -360;
	setAttr ".RightHandMaxRLimitx" 360;
	setAttr ".RightHandMaxRLimity" 360;
	setAttr ".RightHandMaxRLimitz" 360;
	setAttr ".HeadTx" 1.6958253703523554e-014;
	setAttr ".HeadTy" 117.86204373953683;
	setAttr ".HeadTz" 1.2434297448776448;
	setAttr ".HeadRx" 90;
	setAttr ".HeadRy" -13.363043218381343;
	setAttr ".HeadRz" 90;
	setAttr ".HeadSx" 0.99999999999999989;
	setAttr ".HeadSy" 0.99999999999999989;
	setAttr ".HeadJointOrientz" -17.835073123637716;
	setAttr ".HeadMinRLimitx" -360;
	setAttr ".HeadMinRLimity" -360;
	setAttr ".HeadMinRLimitz" -360;
	setAttr ".HeadMaxRLimitx" 360;
	setAttr ".HeadMaxRLimity" 360;
	setAttr ".HeadMaxRLimitz" 360;
	setAttr ".LeftToeBaseTx" 18.722105017686147;
	setAttr ".LeftToeBaseTy" 10.300346529578899;
	setAttr ".LeftToeBaseTz" -5.4196151741237344;
	setAttr ".LeftToeBaseRx" 85.058095787340008;
	setAttr ".LeftToeBaseRy" -48.53599441230687;
	setAttr ".LeftToeBaseRz" -83.327358776987907;
	setAttr ".LeftToeBaseSx" 0.99999999999999978;
	setAttr ".LeftToeBaseSy" 0.99999999999999978;
	setAttr ".LeftToeBaseSz" 0.99999999999999978;
	setAttr ".LeftToeBaseJointOrientz" 58.104520182110107;
	setAttr ".LeftToeBaseMinRLimitx" -360;
	setAttr ".LeftToeBaseMinRLimity" -360;
	setAttr ".LeftToeBaseMinRLimitz" -360;
	setAttr ".LeftToeBaseMaxRLimitx" 360;
	setAttr ".LeftToeBaseMaxRLimity" 360;
	setAttr ".LeftToeBaseMaxRLimitz" 360;
	setAttr ".RightToeBaseTx" -18.722099846692462;
	setAttr ".RightToeBaseTy" 10.300299873554344;
	setAttr ".RightToeBaseTz" -5.4196206421619415;
	setAttr ".RightToeBaseRx" -94.94298218941573;
	setAttr ".RightToeBaseRy" 48.534946918642213;
	setAttr ".RightToeBaseRz" 83.326979254682499;
	setAttr ".RightToeBaseSx" 0.99999999999999956;
	setAttr ".RightToeBaseSy" 0.99999999999999978;
	setAttr ".RightToeBaseSz" 0.99999999999999967;
	setAttr ".RightToeBaseJointOrientx" -6.5592618854326601e-014;
	setAttr ".RightToeBaseJointOrienty" -1.1807809254933292e-013;
	setAttr ".RightToeBaseJointOrientz" 58.104520182110136;
	setAttr ".RightToeBaseMinRLimitx" -360;
	setAttr ".RightToeBaseMinRLimity" -360;
	setAttr ".RightToeBaseMinRLimitz" -360;
	setAttr ".RightToeBaseMaxRLimitx" 360;
	setAttr ".RightToeBaseMaxRLimity" 360;
	setAttr ".RightToeBaseMaxRLimitz" 360;
	setAttr ".LeftShoulderTx" 13.982759325287196;
	setAttr ".LeftShoulderTy" 102.17234688323842;
	setAttr ".LeftShoulderTz" -0.31925955853253463;
	setAttr ".LeftShoulderRx" 90;
	setAttr ".LeftShoulderRy" 18.136862871113241;
	setAttr ".LeftShoulderRz" 44.17784732128932;
	setAttr ".LeftShoulderSy" 0.99999999999999989;
	setAttr ".LeftShoulderSz" 0.99999999999999989;
	setAttr ".LeftShoulderJointOrientx" 33.902095970534589;
	setAttr ".LeftShoulderJointOrienty" -59.575726745641283;
	setAttr ".LeftShoulderJointOrientz" -56.112285862172307;
	setAttr ".LeftShoulderMinRLimitx" -360;
	setAttr ".LeftShoulderMinRLimity" -360;
	setAttr ".LeftShoulderMinRLimitz" -360;
	setAttr ".LeftShoulderMaxRLimitx" 360;
	setAttr ".LeftShoulderMaxRLimity" 360;
	setAttr ".LeftShoulderMaxRLimitz" 360;
	setAttr ".RightShoulderTx" -13.982799999999989;
	setAttr ".RightShoulderTy" 102.17200000000003;
	setAttr ".RightShoulderTz" -0.31926000000000165;
	setAttr ".RightShoulderRx" -90.000283716468601;
	setAttr ".RightShoulderRy" -18.136864289644787;
	setAttr ".RightShoulderRz" -44.178255740275098;
	setAttr ".RightShoulderSx" 0.99999999999999978;
	setAttr ".RightShoulderSy" 0.99999999999999989;
	setAttr ".RightShoulderSz" 0.99999999999999989;
	setAttr ".RightShoulderJointOrientx" 33.902095970534603;
	setAttr ".RightShoulderJointOrienty" -59.575726745641369;
	setAttr ".RightShoulderJointOrientz" 123.8877141378277;
	setAttr ".RightShoulderMinRLimitx" -360;
	setAttr ".RightShoulderMinRLimity" -360;
	setAttr ".RightShoulderMinRLimitz" -360;
	setAttr ".RightShoulderMaxRLimitx" 360;
	setAttr ".RightShoulderMaxRLimity" 360;
	setAttr ".RightShoulderMaxRLimitz" 360;
	setAttr ".NeckTx" 1.6921086821162234e-014;
	setAttr ".NeckTy" 111.01050197738971;
	setAttr ".NeckTz" -2.9057035768035941;
	setAttr ".NeckRx" 90;
	setAttr ".NeckRy" -31.198116342019059;
	setAttr ".NeckRz" 90;
	setAttr ".NeckSx" 0.99999999999999989;
	setAttr ".NeckSy" 0.99999999999999989;
	setAttr ".NeckJointOrientz" 13.016581883919525;
	setAttr ".NeckMinRLimitx" -360;
	setAttr ".NeckMinRLimity" -360;
	setAttr ".NeckMinRLimitz" -360;
	setAttr ".NeckMaxRLimitx" 360;
	setAttr ".NeckMaxRLimity" 360;
	setAttr ".NeckMaxRLimitz" 360;
	setAttr ".Spine1Tx" 1.1426213413646285e-016;
	setAttr ".Spine1Ty" 65.644633894807797;
	setAttr ".Spine1Tz" -4.7103250159259193;
	setAttr ".Spine1Rx" 90;
	setAttr ".Spine1Ry" 5.5508242783198556;
	setAttr ".Spine1Rz" 90;
	setAttr ".Spine1Sx" 0.99999999999999989;
	setAttr ".Spine1Sy" 0.99999999999999989;
	setAttr ".Spine1JointOrientz" -16.0695517510107;
	setAttr ".Spine1MinRLimitx" -360;
	setAttr ".Spine1MinRLimity" -360;
	setAttr ".Spine1MinRLimitz" -360;
	setAttr ".Spine1MaxRLimitx" 360;
	setAttr ".Spine1MaxRLimity" 360;
	setAttr ".Spine1MaxRLimitz" 360;
	setAttr ".Spine2Tx" 6.5475053540765372e-015;
	setAttr ".Spine2Ty" 81.052304993805052;
	setAttr ".Spine2Tz" -6.20771029122354;
	setAttr ".Spine2Rx" 90;
	setAttr ".Spine2Ry" 10.145164264702329;
	setAttr ".Spine2Rz" 90;
	setAttr ".Spine2Sx" 0.99999999999999978;
	setAttr ".Spine2Sy" 0.99999999999999978;
	setAttr ".Spine2JointOrientx" 1.6970933548659575e-015;
	setAttr ".Spine2JointOrienty" -5.669513484603462e-015;
	setAttr ".Spine2JointOrientz" -4.5943399863824705;
	setAttr ".Spine2MinRLimitx" -360;
	setAttr ".Spine2MinRLimity" -360;
	setAttr ".Spine2MinRLimitz" -360;
	setAttr ".Spine2MaxRLimitx" 360;
	setAttr ".Spine2MaxRLimity" 360;
	setAttr ".Spine2MaxRLimitz" 360;
	setAttr ".Spine3Tx" 1.3228802577837378e-014;
	setAttr ".Spine3Ty" 93.936575033730833;
	setAttr ".Spine3Tz" -8.5132282816703011;
	setAttr ".Spine3Rx" 90;
	setAttr ".Spine3Ry" -18.181534458099527;
	setAttr ".Spine3Rz" 90;
	setAttr ".Spine3Sx" 0.99999999999999989;
	setAttr ".Spine3Sy" 0.99999999999999989;
	setAttr ".Spine3JointOrientx" 3.1088097218172411e-015;
	setAttr ".Spine3JointOrienty" 2.8456265568421573e-015;
	setAttr ".Spine3JointOrientz" 28.326698722801861;
	setAttr ".Spine3MinRLimitx" -360;
	setAttr ".Spine3MinRLimity" -360;
	setAttr ".Spine3MinRLimitz" -360;
	setAttr ".Spine3MaxRLimitx" 360;
	setAttr ".Spine3MaxRLimity" 360;
	setAttr ".Spine3MaxRLimitz" 360;
createNode HIKProperty2State -n "HIKproperties1";
	rename -uid "BD837A20-4783-7641-983B-A7BF5AC2EF42";
	setAttr ".lkr" 0.60000002384185791;
	setAttr ".rkr" 0.60000002384185791;
	setAttr ".FootBottomToAnkle" 17.018837839851194;
	setAttr ".FootBackToAnkle" 0.67439260413674784;
	setAttr ".FootMiddleToAnkle" 1.3487852082734957;
	setAttr ".FootFrontToMiddle" 0.67439260413674784;
	setAttr ".FootInToAnkle" 0.67439260413674784;
	setAttr ".FootOutToAnkle" 0.67439260413674784;
	setAttr ".HandBottomToWrist" 1.2544024452395037;
	setAttr ".HandBackToWrist" 0.01;
	setAttr ".HandMiddleToWrist" 0.89019823746050719;
	setAttr ".HandFrontToMiddle" 0.89019823746050719;
	setAttr ".HandInToWrist" 0.89019823746050719;
	setAttr ".HandOutToWrist" 0.89019823746050719;
	setAttr ".CtrlPullLeftFoot" 0;
	setAttr ".CtrlPullRightFoot" 0;
	setAttr ".CtrlChestPullLeftHand" 0;
	setAttr ".CtrlChestPullRightHand" 0;
	setAttr ".LeftHandThumbTip" 0.39200076413734491;
	setAttr ".LeftHandIndexTip" 0.39200076413734491;
	setAttr ".LeftHandMiddleTip" 0.39200076413734491;
	setAttr ".LeftHandRingTip" 0.39200076413734491;
	setAttr ".LeftHandPinkyTip" 0.39200076413734491;
	setAttr ".LeftHandExtraFingerTip" 0.39200076413734491;
	setAttr ".RightHandThumbTip" 0.39200076413734491;
	setAttr ".RightHandIndexTip" 0.39200076413734491;
	setAttr ".RightHandMiddleTip" 0.39200076413734491;
	setAttr ".RightHandRingTip" 0.39200076413734491;
	setAttr ".RightHandPinkyTip" 0.39200076413734491;
	setAttr ".RightHandExtraFingerTip" 0.39200076413734491;
	setAttr ".LeftFootThumbTip" 0.39200076413734491;
	setAttr ".LeftFootIndexTip" 0.39200076413734491;
	setAttr ".LeftFootMiddleTip" 0.39200076413734491;
	setAttr ".LeftFootRingTip" 0.39200076413734491;
	setAttr ".LeftFootPinkyTip" 0.39200076413734491;
	setAttr ".LeftFootExtraFingerTip" 0.39200076413734491;
	setAttr ".RightFootThumbTip" 0.39200076413734491;
	setAttr ".RightFootIndexTip" 0.39200076413734491;
	setAttr ".RightFootMiddleTip" 0.39200076413734491;
	setAttr ".RightFootRingTip" 0.39200076413734491;
	setAttr ".RightFootPinkyTip" 0.39200076413734491;
	setAttr ".RightFootExtraFingerTip" 0.39200076413734491;
	setAttr ".LeftUpLegRollEx" 1;
	setAttr ".LeftLegRollEx" 1;
	setAttr ".RightUpLegRollEx" 1;
	setAttr ".RightLegRollEx" 1;
	setAttr ".LeftArmRollEx" 1;
	setAttr ".LeftForeArmRollEx" 1;
	setAttr ".RightArmRollEx" 1;
	setAttr ".RightForeArmRollEx" 1;
createNode HIKSolverNode -n "HIKSolverNode1";
	rename -uid "053CC870-4D06-1FF8-E521-448B746B1EB7";
	setAttr ".ihi" 0;
	setAttr ".InputStance" yes;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKState2SK -n "HIKState2SK1";
	rename -uid "3DE1F1EC-46B5-96C9-29BB-80B0CF921EA1";
	setAttr ".ihi" 0;
	setAttr ".HipsTy" 55.191200256347656;
	setAttr ".HipsTz" -2.2396821975708008;
	setAttr ".LeftUpLegTx" 24.89634895324707;
	setAttr ".LeftUpLegTy" -7.7306205224221003;
	setAttr ".LeftUpLegTz" 3.1970261345927309;
	setAttr ".LeftUpLegSx" 1.0000001556886875;
	setAttr ".LeftUpLegSy" 1.0000001266787417;
	setAttr ".LeftUpLegSz" 1.0000001819939961;
	setAttr ".LeftLegTx" 21.22617955541045;
	setAttr ".LeftLegTy" 1.7005286672144848e-006;
	setAttr ".LeftLegTz" -1.0305497966101029e-007;
	setAttr ".LeftLegSx" 0.99999996808156077;
	setAttr ".LeftLegSy" 1.0000000376460778;
	setAttr ".LeftLegSz" 0.99999998856014694;
	setAttr ".LeftFootTx" 15.9410440619697;
	setAttr ".LeftFootTy" -2.1863848065351021e-006;
	setAttr ".LeftFootTz" -8.1134231066926077e-007;
	setAttr ".LeftFootRx" 5.7550227166229853;
	setAttr ".LeftFootSx" 1.0000000181715567;
	setAttr ".LeftFootSy" 1.0000000288884754;
	setAttr ".LeftFootSz" 1.0000000606598662;
	setAttr ".RightUpLegTx" -24.896299362182617;
	setAttr ".RightUpLegTy" -7.7305976342385065;
	setAttr ".RightUpLegTz" 3.1970260749880861;
	setAttr ".RightUpLegSx" 1.0000001545209678;
	setAttr ".RightUpLegSy" 1.0000002434724646;
	setAttr ".RightUpLegSz" 1.0000002663924477;
	setAttr ".RightLegTx" -21.226176733864314;
	setAttr ".RightLegTy" 1.4076748620084345e-005;
	setAttr ".RightLegTz" -7.9796577917790046e-005;
	setAttr ".RightLegSx" 1.0000000861290539;
	setAttr ".RightLegSy" 1.0000000361007577;
	setAttr ".RightLegSz" 1.0000000493028349;
	setAttr ".RightFootTx" -15.941088687655146;
	setAttr ".RightFootTy" 4.1556847103052519e-005;
	setAttr ".RightFootTz" 5.0802489916179638e-005;
	setAttr ".RightFootRx" 5.7536382343736889;
	setAttr ".RightFootSx" 1.0000000232841144;
	setAttr ".RightFootSy" 1.0000000068251416;
	setAttr ".RightFootSz" 0.99999992612091693;
	setAttr ".SpineTx" 8.0118685686509011e-032;
	setAttr ".SpineTy" 3.3825348425681341;
	setAttr ".SpineTz" -3.7835475195820738;
	setAttr ".SpineSx" 0.99999995555128274;
	setAttr ".SpineSy" 0.99999995555128274;
	setAttr ".LeftArmTx" 7.5598069854409573;
	setAttr ".LeftArmTy" -1.33463754595887;
	setAttr ".LeftArmTz" 6.4182836921534658;
	setAttr ".LeftArmRx" 2.022709359968943;
	setAttr ".LeftArmRy" 26.659357261830845;
	setAttr ".LeftArmRz" 4.2807929960557525;
	setAttr ".LeftArmSx" 1.0000000397084914;
	setAttr ".LeftArmSy" 1.0000000287096633;
	setAttr ".LeftArmSz" 1.0000000502620734;
	setAttr ".LeftForeArmTx" 15.752491418686034;
	setAttr ".LeftForeArmTy" -6.1561672644272143;
	setAttr ".LeftForeArmTz" -16.51512539165968;
	setAttr ".LeftForeArmRx" -18.408051499579884;
	setAttr ".LeftForeArmRy" 46.632840880528867;
	setAttr ".LeftForeArmRz" -45.053160951947532;
	setAttr ".LeftForeArmSx" 1.0000000726511713;
	setAttr ".LeftForeArmSy" 1.0000000247824055;
	setAttr ".LeftForeArmSz" 1.0000000674058824;
	setAttr ".LeftHandTx" 6.9137479729129545;
	setAttr ".LeftHandTy" -12.050653437398664;
	setAttr ".LeftHandTz" -32.520608035408046;
	setAttr ".LeftHandRx" -19.121454797457105;
	setAttr ".LeftHandRy" 45.753117108327153;
	setAttr ".LeftHandRz" -21.665499212179554;
	setAttr ".LeftHandSx" 1.0000000726511715;
	setAttr ".LeftHandSy" 1.0000000247824055;
	setAttr ".LeftHandSz" 1.0000000674058815;
	setAttr ".RightArmTx" -7.5598835796518813;
	setAttr ".RightArmTy" 1.3346091909340494;
	setAttr ".RightArmTz" -6.4178998427043723;
	setAttr ".RightArmRx" 1.334727776797624;
	setAttr ".RightArmRy" 25.3713858008133;
	setAttr ".RightArmRz" 4.9766800633011368;
	setAttr ".RightArmSx" 1.0000000816343075;
	setAttr ".RightArmSy" 1.0000000107310849;
	setAttr ".RightArmSz" 1.0000000404285561;
	setAttr ".RightForeArmTx" -16.171539662951446;
	setAttr ".RightForeArmTy" 5.8403421151793573;
	setAttr ".RightForeArmTz" 16.222308683212631;
	setAttr ".RightForeArmRx" -19.383636228216808;
	setAttr ".RightForeArmRy" 47.366963318814157;
	setAttr ".RightForeArmRz" -44.907560134615522;
	setAttr ".RightForeArmSx" 0.99999994371336831;
	setAttr ".RightForeArmSy" 0.99999995887371673;
	setAttr ".RightForeArmSz" 0.99999992601907217;
	setAttr ".RightHandTx" -7.1649022841379342;
	setAttr ".RightHandTy" 11.609682448285366;
	setAttr ".RightHandTz" 32.433842160601202;
	setAttr ".RightHandRx" -23.74452093042806;
	setAttr ".RightHandRy" 45.403588893411438;
	setAttr ".RightHandRz" -26.86291182869704;
	setAttr ".RightHandSx" 0.99999994616776844;
	setAttr ".RightHandSy" 0.99999997836460075;
	setAttr ".RightHandSz" 0.99999998738255302;
	setAttr ".HeadTx" 8.0099276912654318;
	setAttr ".HeadTy" -7.7209824667079374e-007;
	setAttr ".HeadTz" -1.7205795772753479e-015;
	setAttr ".HeadSx" 1.0000000883206766;
	setAttr ".HeadSy" 1.0000000745448281;
	setAttr ".HeadSz" 1.0000000000000018;
	setAttr ".LeftToeBaseTx" 6.8757426140225988;
	setAttr ".LeftToeBaseTy" 2.3689079320377004e-007;
	setAttr ".LeftToeBaseTz" 1.5454715907026184e-007;
	setAttr ".LeftToeBaseRx" 4.8886074028971596;
	setAttr ".LeftToeBaseRy" 5.4943574149710859;
	setAttr ".LeftToeBaseRz" 2.4519288111030884;
	setAttr ".LeftToeBaseSx" 1.000000031156044;
	setAttr ".LeftToeBaseSy" 0.99999995797905727;
	setAttr ".LeftToeBaseSz" 0.99999996124270618;
	setAttr ".RightToeBaseTx" -6.8757483953751191;
	setAttr ".RightToeBaseTy" 3.0563412796169587e-006;
	setAttr ".RightToeBaseTz" 2.2562286115856978e-005;
	setAttr ".RightToeBaseRx" 4.8877192205963169;
	setAttr ".RightToeBaseRy" 5.4947935683630602;
	setAttr ".RightToeBaseRz" 2.4509325120821854;
	setAttr ".RightToeBaseSx" 1.0000001823638052;
	setAttr ".RightToeBaseSy" 1.0000000676727347;
	setAttr ".RightToeBaseSz" 1.0000001575946575;
	setAttr ".LeftShoulderTx" 10.381336895390731;
	setAttr ".LeftShoulderTy" 5.2150679999327636;
	setAttr ".LeftShoulderTz" 13.982759475707994;
	setAttr ".LeftShoulderRx" -6.2295750983193123;
	setAttr ".LeftShoulderRy" 18.328613020910471;
	setAttr ".LeftShoulderRz" -1.0059517851518278;
	setAttr ".LeftShoulderSx" 1.0000000254376944;
	setAttr ".LeftShoulderSy" 1.00000005734347;
	setAttr ".LeftShoulderSz" 1.0000000097582107;
	setAttr ".RightShoulderTx" 10.381003325848752;
	setAttr ".RightShoulderTy" 5.215177082378176;
	setAttr ".RightShoulderTz" -13.982799530029311;
	setAttr ".RightShoulderRx" -6.2300003938151525;
	setAttr ".RightShoulderRy" 18.3290039679503;
	setAttr ".RightShoulderRz" -1.0059994001328054;
	setAttr ".RightShoulderSx" 0.99999989173486037;
	setAttr ".RightShoulderSy" 0.99999995476172643;
	setAttr ".RightShoulderSz" 0.99999996951204073;
	setAttr ".NeckTx" 17.971184284665043;
	setAttr ".NeckTy" -1.1235769648010319e-006;
	setAttr ".NeckTz" -2.8870257879123599e-015;
	setAttr ".NeckSx" 1.000000091426368;
	setAttr ".NeckSy" 1.0000000296760871;
	setAttr ".NeckSz" 1.0000001192092967;
	setAttr ".Spine1Tx" 7.1917525900957671;
	setAttr ".Spine1Ty" 4.1075679035884605e-007;
	setAttr ".Spine1Tz" -3.0795172178862311e-015;
	setAttr ".Spine1Sx" 0.99999999389055194;
	setAttr ".Spine1Sy" 0.99999999677329032;
	setAttr ".Spine1Sz" 1.0000000000000004;
	setAttr ".Spine2Tx" 15.48026356378827;
	setAttr ".Spine2Ty" 2.3151803518750569e-007;
	setAttr ".Spine2Tz" -2.5514109680176138e-015;
	setAttr ".Spine2Sx" 0.99999998528040357;
	setAttr ".Spine2Sy" 0.9999999852804039;
	setAttr ".Spine3Tx" 13.088922032006096;
	setAttr ".Spine3Ty" 1.860703342515535e-007;
	setAttr ".Spine3Tz" -1.3214022387466208e-015;
	setAttr ".Spine3Sx" 0.9999999638805831;
	setAttr ".Spine3Sy" 0.99999996388058321;
select -ne :time1;
	setAttr ".o" 1;
	setAttr ".unw" 1;
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :renderPartition;
	setAttr -s 13 ".st";
select -ne :renderGlobalsList1;
select -ne :defaultShaderList1;
	setAttr -s 15 ".s";
select -ne :postProcessList1;
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -s 29 ".u";
select -ne :defaultRenderingList1;
	setAttr -s 4 ".r";
select -ne :defaultTextureList1;
	setAttr -s 13 ".tx";
select -ne :initialShadingGroup;
	setAttr ".ro" yes;
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultRenderGlobals;
	setAttr ".fs" 1;
	setAttr ".ef" 10;
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :hardwareRenderGlobals;
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
select -ne :ikSystem;
	setAttr -s 2 ".sol";
connectAttr "RIGRN.phl[1]" "RIGRN.phl[2]";
connectAttr "RIGRN.phl[3]" "RIGRN.phl[4]";
connectAttr "RIGRN.phl[5]" "RIGRN.phl[6]";
connectAttr "RIGRN.phl[7]" "HIKState2SK1.HipsPGX";
connectAttr "RIGRN.phl[8]" "RIGRN.phl[9]";
connectAttr "RIGRN.phl[10]" "RIGRN.phl[11]";
connectAttr "RIGRN.phl[12]" "RIGRN.phl[13]";
connectAttr "RIGRN.phl[14]" "HIKState2SK1.HipsROrder";
connectAttr "RIGRN.phl[15]" "HIKState2SK1.HipsPreR";
connectAttr "RIGRN.phl[16]" "HIKState2SK1.HipsSC";
connectAttr "RIGRN.phl[17]" "HIKState2SK1.HipsIS";
connectAttr "RIGRN.phl[18]" "Character1.Hips";
connectAttr "RIGRN.phl[19]" "HIKState2SK1.HipsPostR";
connectAttr "RIGRN.phl[20]" "HIKState2SK1.SpineIS";
connectAttr "RIGRN.phl[21]" "HIKState2SK1.SpinePGX";
connectAttr "RIGRN.phl[22]" "RIGRN.phl[23]";
connectAttr "RIGRN.phl[24]" "RIGRN.phl[25]";
connectAttr "RIGRN.phl[26]" "RIGRN.phl[27]";
connectAttr "RIGRN.phl[28]" "RIGRN.phl[29]";
connectAttr "RIGRN.phl[30]" "RIGRN.phl[31]";
connectAttr "RIGRN.phl[32]" "RIGRN.phl[33]";
connectAttr "RIGRN.phl[34]" "HIKState2SK1.SpineROrder";
connectAttr "RIGRN.phl[35]" "HIKState2SK1.SpinePreR";
connectAttr "RIGRN.phl[36]" "HIKState2SK1.SpineSC";
connectAttr "RIGRN.phl[37]" "Character1.Spine";
connectAttr "RIGRN.phl[38]" "HIKState2SK1.SpinePostR";
connectAttr "RIGRN.phl[39]" "HIKState2SK1.Spine1IS";
connectAttr "RIGRN.phl[40]" "HIKState2SK1.Spine1PGX";
connectAttr "RIGRN.phl[41]" "RIGRN.phl[42]";
connectAttr "RIGRN.phl[43]" "RIGRN.phl[44]";
connectAttr "RIGRN.phl[45]" "RIGRN.phl[46]";
connectAttr "RIGRN.phl[47]" "RIGRN.phl[48]";
connectAttr "RIGRN.phl[49]" "RIGRN.phl[50]";
connectAttr "RIGRN.phl[51]" "RIGRN.phl[52]";
connectAttr "RIGRN.phl[53]" "HIKState2SK1.Spine1ROrder";
connectAttr "RIGRN.phl[54]" "HIKState2SK1.Spine1PreR";
connectAttr "RIGRN.phl[55]" "HIKState2SK1.Spine1SC";
connectAttr "RIGRN.phl[56]" "Character1.Spine1";
connectAttr "RIGRN.phl[57]" "HIKState2SK1.Spine1PostR";
connectAttr "RIGRN.phl[58]" "HIKState2SK1.Spine2IS";
connectAttr "RIGRN.phl[59]" "HIKState2SK1.Spine2PGX";
connectAttr "RIGRN.phl[60]" "RIGRN.phl[61]";
connectAttr "RIGRN.phl[62]" "RIGRN.phl[63]";
connectAttr "RIGRN.phl[64]" "RIGRN.phl[65]";
connectAttr "RIGRN.phl[66]" "RIGRN.phl[67]";
connectAttr "RIGRN.phl[68]" "RIGRN.phl[69]";
connectAttr "RIGRN.phl[70]" "RIGRN.phl[71]";
connectAttr "RIGRN.phl[72]" "HIKState2SK1.Spine2ROrder";
connectAttr "RIGRN.phl[73]" "HIKState2SK1.Spine2PreR";
connectAttr "RIGRN.phl[74]" "HIKState2SK1.Spine2SC";
connectAttr "RIGRN.phl[75]" "Character1.Spine2";
connectAttr "RIGRN.phl[76]" "HIKState2SK1.Spine2PostR";
connectAttr "RIGRN.phl[77]" "HIKState2SK1.Spine3IS";
connectAttr "RIGRN.phl[78]" "HIKState2SK1.Spine3PGX";
connectAttr "RIGRN.phl[79]" "RIGRN.phl[80]";
connectAttr "RIGRN.phl[81]" "RIGRN.phl[82]";
connectAttr "RIGRN.phl[83]" "RIGRN.phl[84]";
connectAttr "RIGRN.phl[85]" "RIGRN.phl[86]";
connectAttr "RIGRN.phl[87]" "RIGRN.phl[88]";
connectAttr "RIGRN.phl[89]" "RIGRN.phl[90]";
connectAttr "RIGRN.phl[91]" "HIKState2SK1.Spine3ROrder";
connectAttr "RIGRN.phl[92]" "HIKState2SK1.Spine3PreR";
connectAttr "RIGRN.phl[93]" "HIKState2SK1.Spine3SC";
connectAttr "RIGRN.phl[94]" "Character1.Spine3";
connectAttr "RIGRN.phl[95]" "HIKState2SK1.Spine3PostR";
connectAttr "RIGRN.phl[96]" "HIKState2SK1.NeckIS";
connectAttr "RIGRN.phl[97]" "HIKState2SK1.NeckPGX";
connectAttr "RIGRN.phl[98]" "RIGRN.phl[99]";
connectAttr "RIGRN.phl[100]" "RIGRN.phl[101]";
connectAttr "RIGRN.phl[102]" "RIGRN.phl[103]";
connectAttr "RIGRN.phl[104]" "RIGRN.phl[105]";
connectAttr "RIGRN.phl[106]" "RIGRN.phl[107]";
connectAttr "RIGRN.phl[108]" "RIGRN.phl[109]";
connectAttr "RIGRN.phl[110]" "HIKState2SK1.NeckROrder";
connectAttr "RIGRN.phl[111]" "HIKState2SK1.NeckPreR";
connectAttr "RIGRN.phl[112]" "HIKState2SK1.NeckSC";
connectAttr "RIGRN.phl[113]" "Character1.Neck";
connectAttr "RIGRN.phl[114]" "HIKState2SK1.NeckPostR";
connectAttr "RIGRN.phl[115]" "HIKState2SK1.HeadIS";
connectAttr "RIGRN.phl[116]" "HIKState2SK1.HeadPGX";
connectAttr "RIGRN.phl[117]" "RIGRN.phl[118]";
connectAttr "RIGRN.phl[119]" "RIGRN.phl[120]";
connectAttr "RIGRN.phl[121]" "RIGRN.phl[122]";
connectAttr "RIGRN.phl[123]" "RIGRN.phl[124]";
connectAttr "RIGRN.phl[125]" "RIGRN.phl[126]";
connectAttr "RIGRN.phl[127]" "RIGRN.phl[128]";
connectAttr "RIGRN.phl[129]" "HIKState2SK1.HeadROrder";
connectAttr "RIGRN.phl[130]" "HIKState2SK1.HeadPreR";
connectAttr "RIGRN.phl[131]" "HIKState2SK1.HeadSC";
connectAttr "RIGRN.phl[132]" "Character1.Head";
connectAttr "RIGRN.phl[133]" "HIKState2SK1.HeadPostR";
connectAttr "RIGRN.phl[134]" "HIKState2SK1.LeftShoulderIS";
connectAttr "RIGRN.phl[135]" "HIKState2SK1.LeftShoulderPGX";
connectAttr "RIGRN.phl[136]" "RIGRN.phl[137]";
connectAttr "RIGRN.phl[138]" "RIGRN.phl[139]";
connectAttr "RIGRN.phl[140]" "RIGRN.phl[141]";
connectAttr "RIGRN.phl[142]" "RIGRN.phl[143]";
connectAttr "RIGRN.phl[144]" "RIGRN.phl[145]";
connectAttr "RIGRN.phl[146]" "RIGRN.phl[147]";
connectAttr "RIGRN.phl[148]" "HIKState2SK1.LeftShoulderROrder";
connectAttr "RIGRN.phl[149]" "HIKState2SK1.LeftShoulderPreR";
connectAttr "RIGRN.phl[150]" "HIKState2SK1.LeftShoulderSC";
connectAttr "RIGRN.phl[151]" "Character1.LeftShoulder";
connectAttr "RIGRN.phl[152]" "HIKState2SK1.LeftShoulderPostR";
connectAttr "RIGRN.phl[153]" "HIKState2SK1.LeftArmIS";
connectAttr "RIGRN.phl[154]" "RIGRN.phl[155]";
connectAttr "RIGRN.phl[156]" "RIGRN.phl[157]";
connectAttr "RIGRN.phl[158]" "RIGRN.phl[159]";
connectAttr "RIGRN.phl[160]" "HIKState2SK1.LeftArmPGX";
connectAttr "RIGRN.phl[161]" "RIGRN.phl[162]";
connectAttr "RIGRN.phl[163]" "RIGRN.phl[164]";
connectAttr "RIGRN.phl[165]" "RIGRN.phl[166]";
connectAttr "RIGRN.phl[167]" "HIKState2SK1.LeftArmROrder";
connectAttr "RIGRN.phl[168]" "HIKState2SK1.LeftArmPreR";
connectAttr "RIGRN.phl[169]" "HIKState2SK1.LeftArmSC";
connectAttr "RIGRN.phl[170]" "Character1.LeftArm";
connectAttr "RIGRN.phl[171]" "HIKState2SK1.LeftArmPostR";
connectAttr "RIGRN.phl[172]" "HIKState2SK1.LeftForeArmIS";
connectAttr "RIGRN.phl[173]" "RIGRN.phl[174]";
connectAttr "RIGRN.phl[175]" "RIGRN.phl[176]";
connectAttr "RIGRN.phl[177]" "RIGRN.phl[178]";
connectAttr "RIGRN.phl[179]" "HIKState2SK1.LeftForeArmPGX";
connectAttr "RIGRN.phl[180]" "RIGRN.phl[181]";
connectAttr "RIGRN.phl[182]" "RIGRN.phl[183]";
connectAttr "RIGRN.phl[184]" "RIGRN.phl[185]";
connectAttr "RIGRN.phl[186]" "HIKState2SK1.LeftForeArmROrder";
connectAttr "RIGRN.phl[187]" "HIKState2SK1.LeftForeArmPreR";
connectAttr "RIGRN.phl[188]" "HIKState2SK1.LeftForeArmSC";
connectAttr "RIGRN.phl[189]" "Character1.LeftForeArm";
connectAttr "RIGRN.phl[190]" "HIKState2SK1.LeftForeArmPostR";
connectAttr "RIGRN.phl[191]" "HIKState2SK1.LeftHandIS";
connectAttr "RIGRN.phl[192]" "HIKState2SK1.LeftHandPGX";
connectAttr "RIGRN.phl[193]" "RIGRN.phl[194]";
connectAttr "RIGRN.phl[195]" "RIGRN.phl[196]";
connectAttr "RIGRN.phl[197]" "RIGRN.phl[198]";
connectAttr "RIGRN.phl[199]" "RIGRN.phl[200]";
connectAttr "RIGRN.phl[201]" "RIGRN.phl[202]";
connectAttr "RIGRN.phl[203]" "RIGRN.phl[204]";
connectAttr "RIGRN.phl[205]" "HIKState2SK1.LeftHandROrder";
connectAttr "RIGRN.phl[206]" "HIKState2SK1.LeftHandPreR";
connectAttr "RIGRN.phl[207]" "HIKState2SK1.LeftHandSC";
connectAttr "RIGRN.phl[208]" "Character1.LeftHand";
connectAttr "RIGRN.phl[209]" "HIKState2SK1.LeftHandPostR";
connectAttr "RIGRN.phl[210]" "HIKState2SK1.RightShoulderIS";
connectAttr "RIGRN.phl[211]" "HIKState2SK1.RightShoulderPGX";
connectAttr "RIGRN.phl[212]" "RIGRN.phl[213]";
connectAttr "RIGRN.phl[214]" "RIGRN.phl[215]";
connectAttr "RIGRN.phl[216]" "RIGRN.phl[217]";
connectAttr "RIGRN.phl[218]" "RIGRN.phl[219]";
connectAttr "RIGRN.phl[220]" "RIGRN.phl[221]";
connectAttr "RIGRN.phl[222]" "RIGRN.phl[223]";
connectAttr "RIGRN.phl[224]" "HIKState2SK1.RightShoulderROrder";
connectAttr "RIGRN.phl[225]" "HIKState2SK1.RightShoulderPreR";
connectAttr "RIGRN.phl[226]" "HIKState2SK1.RightShoulderSC";
connectAttr "RIGRN.phl[227]" "Character1.RightShoulder";
connectAttr "RIGRN.phl[228]" "HIKState2SK1.RightShoulderPostR";
connectAttr "RIGRN.phl[229]" "HIKState2SK1.RightArmIS";
connectAttr "RIGRN.phl[230]" "RIGRN.phl[231]";
connectAttr "RIGRN.phl[232]" "RIGRN.phl[233]";
connectAttr "RIGRN.phl[234]" "RIGRN.phl[235]";
connectAttr "RIGRN.phl[236]" "HIKState2SK1.RightArmPGX";
connectAttr "RIGRN.phl[237]" "RIGRN.phl[238]";
connectAttr "RIGRN.phl[239]" "RIGRN.phl[240]";
connectAttr "RIGRN.phl[241]" "RIGRN.phl[242]";
connectAttr "RIGRN.phl[243]" "HIKState2SK1.RightArmROrder";
connectAttr "RIGRN.phl[244]" "HIKState2SK1.RightArmPreR";
connectAttr "RIGRN.phl[245]" "HIKState2SK1.RightArmSC";
connectAttr "RIGRN.phl[246]" "Character1.RightArm";
connectAttr "RIGRN.phl[247]" "HIKState2SK1.RightArmPostR";
connectAttr "RIGRN.phl[248]" "HIKState2SK1.RightForeArmIS";
connectAttr "RIGRN.phl[249]" "RIGRN.phl[250]";
connectAttr "RIGRN.phl[251]" "RIGRN.phl[252]";
connectAttr "RIGRN.phl[253]" "RIGRN.phl[254]";
connectAttr "RIGRN.phl[255]" "HIKState2SK1.RightForeArmPGX";
connectAttr "RIGRN.phl[256]" "RIGRN.phl[257]";
connectAttr "RIGRN.phl[258]" "RIGRN.phl[259]";
connectAttr "RIGRN.phl[260]" "RIGRN.phl[261]";
connectAttr "RIGRN.phl[262]" "HIKState2SK1.RightForeArmROrder";
connectAttr "RIGRN.phl[263]" "HIKState2SK1.RightForeArmPreR";
connectAttr "RIGRN.phl[264]" "HIKState2SK1.RightForeArmSC";
connectAttr "RIGRN.phl[265]" "Character1.RightForeArm";
connectAttr "RIGRN.phl[266]" "HIKState2SK1.RightForeArmPostR";
connectAttr "RIGRN.phl[267]" "HIKState2SK1.RightHandIS";
connectAttr "RIGRN.phl[268]" "HIKState2SK1.RightHandPGX";
connectAttr "RIGRN.phl[269]" "RIGRN.phl[270]";
connectAttr "RIGRN.phl[271]" "RIGRN.phl[272]";
connectAttr "RIGRN.phl[273]" "RIGRN.phl[274]";
connectAttr "RIGRN.phl[275]" "RIGRN.phl[276]";
connectAttr "RIGRN.phl[277]" "RIGRN.phl[278]";
connectAttr "RIGRN.phl[279]" "RIGRN.phl[280]";
connectAttr "RIGRN.phl[281]" "HIKState2SK1.RightHandROrder";
connectAttr "RIGRN.phl[282]" "HIKState2SK1.RightHandPreR";
connectAttr "RIGRN.phl[283]" "HIKState2SK1.RightHandSC";
connectAttr "RIGRN.phl[284]" "Character1.RightHand";
connectAttr "RIGRN.phl[285]" "HIKState2SK1.RightHandPostR";
connectAttr "RIGRN.phl[286]" "HIKState2SK1.LeftUpLegIS";
connectAttr "RIGRN.phl[287]" "RIGRN.phl[288]";
connectAttr "RIGRN.phl[289]" "RIGRN.phl[290]";
connectAttr "RIGRN.phl[291]" "RIGRN.phl[292]";
connectAttr "RIGRN.phl[293]" "HIKState2SK1.LeftUpLegPGX";
connectAttr "RIGRN.phl[294]" "RIGRN.phl[295]";
connectAttr "RIGRN.phl[296]" "RIGRN.phl[297]";
connectAttr "RIGRN.phl[298]" "RIGRN.phl[299]";
connectAttr "RIGRN.phl[300]" "HIKState2SK1.LeftUpLegROrder";
connectAttr "RIGRN.phl[301]" "HIKState2SK1.LeftUpLegPreR";
connectAttr "RIGRN.phl[302]" "HIKState2SK1.LeftUpLegSC";
connectAttr "RIGRN.phl[303]" "Character1.LeftUpLeg";
connectAttr "RIGRN.phl[304]" "HIKState2SK1.LeftUpLegPostR";
connectAttr "RIGRN.phl[305]" "HIKState2SK1.LeftLegIS";
connectAttr "RIGRN.phl[306]" "RIGRN.phl[307]";
connectAttr "RIGRN.phl[308]" "RIGRN.phl[309]";
connectAttr "RIGRN.phl[310]" "RIGRN.phl[311]";
connectAttr "RIGRN.phl[312]" "HIKState2SK1.LeftLegPGX";
connectAttr "RIGRN.phl[313]" "RIGRN.phl[314]";
connectAttr "RIGRN.phl[315]" "RIGRN.phl[316]";
connectAttr "RIGRN.phl[317]" "RIGRN.phl[318]";
connectAttr "RIGRN.phl[319]" "HIKState2SK1.LeftLegROrder";
connectAttr "RIGRN.phl[320]" "HIKState2SK1.LeftLegPreR";
connectAttr "RIGRN.phl[321]" "HIKState2SK1.LeftLegSC";
connectAttr "RIGRN.phl[322]" "Character1.LeftLeg";
connectAttr "RIGRN.phl[323]" "HIKState2SK1.LeftLegPostR";
connectAttr "RIGRN.phl[324]" "HIKState2SK1.LeftFootIS";
connectAttr "RIGRN.phl[325]" "HIKState2SK1.LeftFootPGX";
connectAttr "RIGRN.phl[326]" "RIGRN.phl[327]";
connectAttr "RIGRN.phl[328]" "RIGRN.phl[329]";
connectAttr "RIGRN.phl[330]" "RIGRN.phl[331]";
connectAttr "RIGRN.phl[332]" "RIGRN.phl[333]";
connectAttr "RIGRN.phl[334]" "RIGRN.phl[335]";
connectAttr "RIGRN.phl[336]" "RIGRN.phl[337]";
connectAttr "RIGRN.phl[338]" "HIKState2SK1.LeftFootROrder";
connectAttr "RIGRN.phl[339]" "HIKState2SK1.LeftFootPreR";
connectAttr "RIGRN.phl[340]" "HIKState2SK1.LeftFootSC";
connectAttr "RIGRN.phl[341]" "Character1.LeftFoot";
connectAttr "RIGRN.phl[342]" "HIKState2SK1.LeftFootPostR";
connectAttr "RIGRN.phl[343]" "HIKState2SK1.LeftToeBaseIS";
connectAttr "RIGRN.phl[344]" "HIKState2SK1.LeftToeBasePGX";
connectAttr "RIGRN.phl[345]" "RIGRN.phl[346]";
connectAttr "RIGRN.phl[347]" "RIGRN.phl[348]";
connectAttr "RIGRN.phl[349]" "RIGRN.phl[350]";
connectAttr "RIGRN.phl[351]" "RIGRN.phl[352]";
connectAttr "RIGRN.phl[353]" "RIGRN.phl[354]";
connectAttr "RIGRN.phl[355]" "RIGRN.phl[356]";
connectAttr "RIGRN.phl[357]" "HIKState2SK1.LeftToeBaseROrder";
connectAttr "RIGRN.phl[358]" "HIKState2SK1.LeftToeBasePreR";
connectAttr "RIGRN.phl[359]" "HIKState2SK1.LeftToeBaseSC";
connectAttr "RIGRN.phl[360]" "Character1.LeftToeBase";
connectAttr "RIGRN.phl[361]" "HIKState2SK1.LeftToeBasePostR";
connectAttr "RIGRN.phl[362]" "HIKState2SK1.RightUpLegIS";
connectAttr "RIGRN.phl[363]" "RIGRN.phl[364]";
connectAttr "RIGRN.phl[365]" "RIGRN.phl[366]";
connectAttr "RIGRN.phl[367]" "RIGRN.phl[368]";
connectAttr "RIGRN.phl[369]" "HIKState2SK1.RightUpLegPGX";
connectAttr "RIGRN.phl[370]" "RIGRN.phl[371]";
connectAttr "RIGRN.phl[372]" "RIGRN.phl[373]";
connectAttr "RIGRN.phl[374]" "RIGRN.phl[375]";
connectAttr "RIGRN.phl[376]" "HIKState2SK1.RightUpLegROrder";
connectAttr "RIGRN.phl[377]" "HIKState2SK1.RightUpLegPreR";
connectAttr "RIGRN.phl[378]" "HIKState2SK1.RightUpLegSC";
connectAttr "RIGRN.phl[379]" "Character1.RightUpLeg";
connectAttr "RIGRN.phl[380]" "HIKState2SK1.RightUpLegPostR";
connectAttr "RIGRN.phl[381]" "HIKState2SK1.RightLegIS";
connectAttr "RIGRN.phl[382]" "RIGRN.phl[383]";
connectAttr "RIGRN.phl[384]" "RIGRN.phl[385]";
connectAttr "RIGRN.phl[386]" "RIGRN.phl[387]";
connectAttr "RIGRN.phl[388]" "HIKState2SK1.RightLegPGX";
connectAttr "RIGRN.phl[389]" "RIGRN.phl[390]";
connectAttr "RIGRN.phl[391]" "RIGRN.phl[392]";
connectAttr "RIGRN.phl[393]" "RIGRN.phl[394]";
connectAttr "RIGRN.phl[395]" "HIKState2SK1.RightLegROrder";
connectAttr "RIGRN.phl[396]" "HIKState2SK1.RightLegPreR";
connectAttr "RIGRN.phl[397]" "HIKState2SK1.RightLegSC";
connectAttr "RIGRN.phl[398]" "Character1.RightLeg";
connectAttr "RIGRN.phl[399]" "HIKState2SK1.RightLegPostR";
connectAttr "RIGRN.phl[400]" "HIKState2SK1.RightFootIS";
connectAttr "RIGRN.phl[401]" "HIKState2SK1.RightFootPGX";
connectAttr "RIGRN.phl[402]" "RIGRN.phl[403]";
connectAttr "RIGRN.phl[404]" "RIGRN.phl[405]";
connectAttr "RIGRN.phl[406]" "RIGRN.phl[407]";
connectAttr "RIGRN.phl[408]" "RIGRN.phl[409]";
connectAttr "RIGRN.phl[410]" "RIGRN.phl[411]";
connectAttr "RIGRN.phl[412]" "RIGRN.phl[413]";
connectAttr "RIGRN.phl[414]" "HIKState2SK1.RightFootROrder";
connectAttr "RIGRN.phl[415]" "HIKState2SK1.RightFootPreR";
connectAttr "RIGRN.phl[416]" "HIKState2SK1.RightFootSC";
connectAttr "RIGRN.phl[417]" "Character1.RightFoot";
connectAttr "RIGRN.phl[418]" "HIKState2SK1.RightFootPostR";
connectAttr "RIGRN.phl[419]" "HIKState2SK1.RightToeBaseIS";
connectAttr "RIGRN.phl[420]" "HIKState2SK1.RightToeBasePGX";
connectAttr "RIGRN.phl[421]" "RIGRN.phl[422]";
connectAttr "RIGRN.phl[423]" "RIGRN.phl[424]";
connectAttr "RIGRN.phl[425]" "RIGRN.phl[426]";
connectAttr "RIGRN.phl[427]" "RIGRN.phl[428]";
connectAttr "RIGRN.phl[429]" "RIGRN.phl[430]";
connectAttr "RIGRN.phl[431]" "RIGRN.phl[432]";
connectAttr "RIGRN.phl[433]" "HIKState2SK1.RightToeBaseROrder";
connectAttr "RIGRN.phl[434]" "HIKState2SK1.RightToeBasePreR";
connectAttr "RIGRN.phl[435]" "HIKState2SK1.RightToeBaseSC";
connectAttr "RIGRN.phl[436]" "Character1.RightToeBase";
connectAttr "RIGRN.phl[437]" "HIKState2SK1.RightToeBasePostR";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "HIKproperties1.msg" "Character1.propertyState";
connectAttr "HIKproperties1.OutputPropertySetState" "HIKSolverNode1.InputPropertySetState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKSolverNode1.InputCharacterDefinition"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKState2SK1.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKState2SK1.InputCharacterState"
		;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
// End of kobold_overboss_anim.ma
