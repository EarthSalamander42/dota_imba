//Maya ASCII 2016 scene
//Name: overboss_stun.ma
//Last modified: Wed, May 27, 2015 09:57:06 AM
//Codeset: 1252
file -rdi 1 -ns "RIG" -rfn "RIGRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_rig.ma";
file -rdi 2 -ns "MODEL" -rfn "RIG:MODELRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_model.ma";
file -r -ns "RIG" -dr 1 -rfn "RIGRN" -op "v=0;" -typ "mayaAscii" "D:/dev/source2/main/content/dota/models/props_structures/midas_throne/maya/kobold_overboss_rig.ma";
requires maya "2016";
requires -nodeType "HIKSolverNode" -nodeType "HIKRetargeterNode" -nodeType "HIKCharacterNode"
		 -nodeType "HIKControlSetNode" -nodeType "HIKEffectorFromCharacter" -nodeType "HIKSK2State"
		 -nodeType "HIKFK2State" -nodeType "HIKState2FK" -nodeType "HIKState2SK" -nodeType "HIKEffector2State"
		 -nodeType "HIKState2Effector" -nodeType "HIKProperty2State" -nodeType "HIKPinning2State"
		 -dataType "HIKCharacter" -dataType "HIKCharacterState" -dataType "HIKEffectorState"
		 -dataType "HIKPropertySetState" "mayaHIK" "1.0_HIK_2014.2";
requires -nodeType "vstExportNode" "PVstExportNode.py" "2.1.0";
requires "stereoCamera" "10.0";
requires "vstUtils" "1.0";
requires "vsMaster" "1.0";
requires "Mayatomr" "2012.0m - 3.9.1.48 ";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2016";
fileInfo "version" "2016";
fileInfo "cutIdentifier" "201502261600-953408";
fileInfo "osv" "Microsoft Windows 7 Business Edition, 64-bit Windows 7 Service Pack 1 (Build 7601)\n";
createNode transform -s -n "persp";
	rename -uid "B42D4178-4779-39F1-0BBF-148F1BDFD926";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 582.45351131918414 122.85946275047266 114.24149898565841 ;
	setAttr ".r" -type "double3" -3.9383527296235319 74.600000000000108 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 652.80010704645349;
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
createNode transform -n "Character1_Ctrl_Reference";
	rename -uid "AD161D3A-4700-4B35-6C50-4A8D35D11A58";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "50FDFADE-4B5E-5A0D-0112-B58A87B1A97B";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "464C5ADB-4399-F16D-B5C2-E6B0D9670E30";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr ".rt" 1;
	setAttr ".rr" 1;
	setAttr ".radi" 14.462502530459469;
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".lk" 2;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftAnkleEffector" -p "Character1_Ctrl_Reference";
	rename -uid "74B8132E-48F6-88EE-5397-74AAAD2E9C4D";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648357550790408 265.29219349260308 2.5444437451708134e-014 ;
	setAttr -l on ".ra";
	setAttr ".pin" 3;
	setAttr ".ei" 1;
	setAttr ".rt" 1;
	setAttr ".rr" 1;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" -90.943977535049385 11.312837968166692 -94.801304967472689 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightAnkleEffector" -p "Character1_Ctrl_Reference";
	rename -uid "EE9B1484-4E7C-940E-8980-5F8FA187D3BA";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648339634731641 -85.292375348586049 3.8753633107810623e-014 ;
	setAttr -l on ".ra";
	setAttr ".pin" 3;
	setAttr ".ei" 2;
	setAttr ".rt" 1;
	setAttr ".rr" 1;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" -89.056057311567685 11.312858817339892 -85.198880166696796 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftWristEffector" -p "Character1_Ctrl_Reference";
	rename -uid "DF1D8314-445E-D20F-1347-DFACC7A8C0BA";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 0 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 3;
	setAttr ".radi" 4.8208341768198233;
	setAttr -l on ".jo" -type "double3" 89.999999999999986 0 0 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 0 0 90 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightWristEffector" -p "Character1_Ctrl_Reference";
	rename -uid "0CD5C3D1-4C5C-8AD4-F0C2-3CA56854D604";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 90.000000000000014 0 180 ;
	setAttr -l on ".ra";
	setAttr ".ei" 4;
	setAttr ".radi" 4.8208341768198233;
	setAttr -l on ".jo" -type "double3" 90.000000000000014 0 180 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 0 0 90 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftKneeEffector" -p "Character1_Ctrl_Reference";
	rename -uid "7C03E9F4-48E7-9B02-300A-86ADDECAFF31";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 41.818369526459719 255.66617319479917 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 5;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" -105.46754193653341 46.22499098271755 -110.96824330919321 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightKneeEffector" -p "Character1_Ctrl_Reference";
	rename -uid "9CD0A879-4F32-EED6-3A31-A7A8033411E3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 41.818515442763932 -75.665996898119403 1.2846882449534567e-014 ;
	setAttr -l on ".ra";
	setAttr ".ei" 6;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" -74.53235620310916 46.224807712094773 -69.031565591661774 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftElbowEffector" -p "Character1_Ctrl_Reference";
	rename -uid "A4A7C1BB-44AD-EA5B-809C-8F968D4D1B7A";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90 0 -1.833790743017201e-006 ;
	setAttr -l on ".ra";
	setAttr ".ei" 7;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" 90 -1.8337907430172008e-006 0 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 -9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightElbowEffector" -p "Character1_Ctrl_Reference";
	rename -uid "228FCB5E-4B6E-67AB-34B1-CD852A200D0C";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 90.003699867130067 -0.6762883084853506 -0.3134603635436598 ;
	setAttr -l on ".ra";
	setAttr ".ei" 8;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" -90.003699664748936 0.31341669267919825 -0.6763085475273839 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 -9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_ChestOriginEffector" -p "Character1_Ctrl_Reference";
	rename -uid "D86F04DE-4E5B-2CE1-CCC6-A796C06A0623";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -100.51873153737549 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 9;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" 89.999999999999986 -10.518731537375487 90.000000000000028 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_ChestEndEffector" -p "Character1_Ctrl_Reference";
	rename -uid "B324C01E-4B70-F1DB-2A36-0D979AAE2956";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -108.18153308427868 -89.999999999999972 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 10;
	setAttr ".radi" 14.462502530459469;
	setAttr -l on ".jo" -type "double3" 90.000000000000014 -18.181533084278694 89.999999999999986 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftFootEffector" -p "Character1_Ctrl_Reference";
	rename -uid "26C6A3FB-4F16-8F66-85BC-1A928121D46E";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 11;
	setAttr ".radi" 5.7850010121837876;
	setAttr -l on ".jo" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 90 0 0 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightFootEffector" -p "Character1_Ctrl_Reference";
	rename -uid "798718D7-40F1-8549-D728-0197CE290D74";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 12;
	setAttr ".radi" 5.7850010121837876;
	setAttr -l on ".jo" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 90 0 0 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftShoulderEffector" -p "Character1_Ctrl_Reference";
	rename -uid "35B703EF-418F-977C-1911-64A75D1C0E1C";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 89.999999999999986 0 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 13;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" -89.999999999999986 0 0 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 0 0 90 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightShoulderEffector" -p "Character1_Ctrl_Reference";
	rename -uid "8D9D9053-46DC-F4DA-FD39-B78BEA24F18E";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90.017176845349368 -1.2070246691672979 0.81536621021078848 ;
	setAttr -l on ".ra";
	setAttr ".ei" 14;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" 90.01717477146434 0.81500434340307615 1.2072690178559695 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 0 0 90 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_HeadEffector" -p "Character1_Ctrl_Reference";
	rename -uid "22EB7F81-476A-6369-1AC0-09BC83BB4AEA";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr ".ei" 15;
	setAttr ".radi" 9.6416683536396466;
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftHipEffector" -p "Character1_Ctrl_Reference";
	rename -uid "164D8512-45FD-E7E4-4D53-059931DEEB0F";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -72.1617240701962 -85.505429986291404 179.99999999999991 ;
	setAttr -l on ".ra";
	setAttr ".ei" 16;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" -88.555427765641255 -17.781584091030204 -94.720557824158519 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightHipEffector" -p "Character1_Ctrl_Reference";
	rename -uid "FF0C0CB0-4F9D-6871-271A-70A1B86AA659";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 107.83826361025581 -85.505652076667786 -4.0588618618416478e-014 ;
	setAttr -l on ".ra";
	setAttr ".ei" 17;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" -91.444499965635828 -17.78157741199843 -85.279675659309802 ;
	setAttr -l on ".jo";
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness";
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Hips" -p "Character1_Ctrl_Reference";
	rename -uid "EC574A0A-449B-A91C-A636-B0A74E731CF3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftUpLeg" -p "Character1_Ctrl_Hips";
	rename -uid "D41651DD-45F1-D678-818E-8296F4278753";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 24.89634895324707 -7.730621337890625 3.197026252746582 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -72.1617240701962 -85.505429986291404 179.99999999999991 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -88.555427765641255 -17.781584091030204 -94.720557824158519 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftLeg" -p "Character1_Ctrl_LeftUpLeg";
	rename -uid "AAAEDF11-40A2-BE34-1839-809635D5B0AE";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -1.6633815765380895 -20.143594741821289 6.4822478294372559 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 41.818369526459719 255.66617319479917 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -105.46754193653341 46.22499098271755 -110.96824330919321 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftFoot" -p "Character1_Ctrl_LeftLeg";
	rename -uid "A770450E-4677-F13A-D177-8596481E80EF";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -3.9465408325195313 -10.298147201538086 -11.510421752929687 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648357550790408 265.29219349260308 2.5444437451708134e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -90.943977535049385 11.312837968166692 -94.801304967472689 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftToeBase" -p "Character1_Ctrl_LeftFoot";
	rename -uid "1CE98979-4A16-A797-6310-729C6B402DD6";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr -l on ".t" -type "double3" -0.56432151794433594 -6.7184906005859375 -1.348785400390625 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 0;
	setAttr ".lk" 0;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightUpLeg" -p "Character1_Ctrl_Hips";
	rename -uid "753475E5-4295-1337-C4E4-2F8B4AB78A75";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -24.896299362182617 -7.7305984497070313 3.1970261931419373 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 107.83826361025581 -85.505652076667786 -4.0588618618416478e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -91.444499965635828 -17.78157741199843 -85.279675659309802 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightLeg" -p "Character1_Ctrl_RightUpLeg";
	rename -uid "92EA6971-4442-035C-0722-F0B7693BD59B";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 1.6632995605468786 -20.143602371215827 6.4822455048561096 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 41.818515442763932 -75.665996898119403 1.2846882449534567e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -74.53235620310916 46.224807712094773 -69.031565591661774 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightFoot" -p "Character1_Ctrl_RightLeg";
	rename -uid "9AABF90B-44D8-FF24-0A6D-DC908D005C64";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 3.946599960327152 -10.298198699951175 -11.510420322418213 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648339634731641 -85.292375348586049 3.8753633107810623e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -89.056057311567685 11.312858817339892 -85.198880166696796 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightToeBase" -p "Character1_Ctrl_RightFoot";
	rename -uid "0CE16668-4A44-42E6-3166-78BC9885D4ED";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr -l on ".t" -type "double3" 0.564300537109375 -6.718501091003418 -1.3487896919250488 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -180 -89.999999999999986 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 0;
	setAttr ".lk" 0;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Spine" -p "Character1_Ctrl_Hips";
	rename -uid "964D4438-476E-8AF7-714D-0C85CDB4E103";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 8.0118685686509011e-032 3.3825340270996094 -3.7835474014282227 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -100.51873153737549 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 89.999999999999986 -10.518731537375487 90.000000000000028 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Spine1" -p "Character1_Ctrl_Spine";
	rename -uid "013A12E8-4BB3-2164-2D95-55B9CC5F0B2F";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 1.1426213731131427e-016 7.0708961486816406 1.3129043579101563 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -84.449178647732239 -89.999999999999972 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.000000000000014 5.5508213522677758 89.999999999999986 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Spine2" -p "Character1_Ctrl_Spine1";
	rename -uid "9F84F1BD-47CC-6FED-7081-EDBC1D1A7997";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 6.4332432526581195e-015 15.407676696777344 -1.4973850250244141 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -79.854834795333602 -89.999999999999957 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 10.145165204666403 89.999999999999957 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Spine3" -p "Character1_Ctrl_Spine2";
	rename -uid "42C96684-4BE8-B67F-D0B3-58901E3D4CCD";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 6.6812967850870931e-015 12.884269714355469 -2.3055181503295898 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -108.18153308427868 -89.999999999999972 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.000000000000014 -18.181533084278694 89.999999999999986 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftShoulder" -p "Character1_Ctrl_Spine3";
	rename -uid "E670C45B-4002-9715-8A2A-DAA5157932E4";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 13.982759475707995 8.2357711791992187 8.1939688622951508 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 0.27184377507479274 -21.217224574734775 -0.75110972960021016 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -2.6655183531044226e-017 21.218885655887302 
		0.70019316385605757 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftArm" -p "Character1_Ctrl_LeftShoulder";
	rename -uid "D3F81C7E-4FE4-253A-C588-B484DA68DAED";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 9.3272342681884766 0.11399078369140625 -3.6216035783290863 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 89.999999999999986 0 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -89.999999999999986 0 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftForeArm" -p "Character1_Ctrl_LeftArm";
	rename -uid "E63C8D38-476F-A518-EF48-8298F22614A6";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 23.638713836669918 0 4.4408920985006262e-016 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90 0 -1.833790743017201e-006 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 -1.8337907430172008e-006 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftHand" -p "Character1_Ctrl_LeftForeArm";
	rename -uid "473DA8F8-4BA2-C703-EAEA-0AB1E926EDA3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 22.347770690917969 0 7.152557373046875e-007 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 0 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 89.999999999999986 0 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightShoulder" -p "Character1_Ctrl_Spine3";
	rename -uid "B8999334-442C-6C2A-0346-FEA2AF1FEEE3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -13.982799530029309 8.2354202270507812 8.1939684152603149 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 0.27281685064397865 21.21743420579018 0.75379098431415203 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 2.6655223544057194e-017 -21.219107181425706 
		-0.70269164344685653 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightArm" -p "Character1_Ctrl_RightShoulder";
	rename -uid "FB661392-49FC-F4A6-FF9A-05806D7E01E2";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -9.3270359039306623 0.1143951416015625 -3.6215699911117554 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90.017176845349368 -1.2070246691672979 0.81536621021078848 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.01717477146434 0.81500434340307615 1.2072690178559695 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightForeArm" -p "Character1_Ctrl_RightArm";
	rename -uid "1786B0CC-4011-EDB7-EBA5-5CBCAC8D0997";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -23.631135940551751 -0.49800109863284092 0.33623862266540705 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 90.003699867130067 -0.6762883084853506 -0.3134603635436598 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -90.003699664748936 0.31341669267919825 -0.6763085475273839 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightHand" -p "Character1_Ctrl_RightForeArm";
	rename -uid "109142A1-41BD-1E2E-AE42-BB87F92E8498";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" -22.345870971679688 0.26377868652342329 0.12224507331848189 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 90.000000000000014 0 180 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.000000000000014 0 180 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Neck" -p "Character1_Ctrl_Spine3";
	rename -uid "FE7951FF-457A-FB9D-00C0-6C8A60069D0D";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 3.6922852267502244e-015 17.073928833007813 5.6075248718261719 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -121.19812432763258 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 -31.198124327632581 90.000000000000014 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Head" -p "Character1_Ctrl_Neck";
	rename -uid "A6F6764D-4CF6-B2A9-636A-B892CDB07B02";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -l on ".t" -type "double3" 3.716611165962419e-017 6.8515396118164205 4.1491333246231079 ;
	setAttr -l on ".t";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -l on ".s";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -89.999999999999986 -89.999999999999986 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "D86A74AF-4B9C-3A29-C654-40B055E29457";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "AE38BB7C-4CFC-0D14-71C0-F08FC6D90809";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "047C9194-427C-7C09-8CF0-639D3DA6BFF7";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "2176905E-4B8D-64F1-3697-C9A6C6860B23";
	setAttr ".g" yes;
createNode reference -n "RIGRN";
	rename -uid "AC5E3B45-47E8-0DD5-42BA-5B9B451E7F50";
	setAttr -s 507 ".phl";
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
	setAttr ".phl[438]" 0;
	setAttr ".phl[439]" 0;
	setAttr ".phl[440]" 0;
	setAttr ".phl[441]" 0;
	setAttr ".phl[442]" 0;
	setAttr ".phl[443]" 0;
	setAttr ".phl[444]" 0;
	setAttr ".phl[445]" 0;
	setAttr ".phl[446]" 0;
	setAttr ".phl[447]" 0;
	setAttr ".phl[448]" 0;
	setAttr ".phl[449]" 0;
	setAttr ".phl[450]" 0;
	setAttr ".phl[451]" 0;
	setAttr ".phl[452]" 0;
	setAttr ".phl[453]" 0;
	setAttr ".phl[454]" 0;
	setAttr ".phl[455]" 0;
	setAttr ".phl[456]" 0;
	setAttr ".phl[457]" 0;
	setAttr ".phl[458]" 0;
	setAttr ".phl[459]" 0;
	setAttr ".phl[460]" 0;
	setAttr ".phl[461]" 0;
	setAttr ".phl[462]" 0;
	setAttr ".phl[463]" 0;
	setAttr ".phl[464]" 0;
	setAttr ".phl[465]" 0;
	setAttr ".phl[466]" 0;
	setAttr ".phl[467]" 0;
	setAttr ".phl[468]" 0;
	setAttr ".phl[469]" 0;
	setAttr ".phl[470]" 0;
	setAttr ".phl[471]" 0;
	setAttr ".phl[472]" 0;
	setAttr ".phl[473]" 0;
	setAttr ".phl[474]" 0;
	setAttr ".phl[475]" 0;
	setAttr ".phl[476]" 0;
	setAttr ".phl[477]" 0;
	setAttr ".phl[478]" 0;
	setAttr ".phl[479]" 0;
	setAttr ".phl[480]" 0;
	setAttr ".phl[481]" 0;
	setAttr ".phl[482]" 0;
	setAttr ".phl[483]" 0;
	setAttr ".phl[484]" 0;
	setAttr ".phl[485]" 0;
	setAttr ".phl[486]" 0;
	setAttr ".phl[487]" 0;
	setAttr ".phl[488]" 0;
	setAttr ".phl[489]" 0;
	setAttr ".phl[490]" 0;
	setAttr ".phl[491]" 0;
	setAttr ".phl[492]" 0;
	setAttr ".phl[493]" 0;
	setAttr ".phl[494]" 0;
	setAttr ".phl[495]" 0;
	setAttr ".phl[496]" 0;
	setAttr ".phl[497]" 0;
	setAttr ".phl[498]" 0;
	setAttr ".phl[499]" 0;
	setAttr ".phl[500]" 0;
	setAttr ".phl[501]" 0;
	setAttr ".phl[502]" 0;
	setAttr ".phl[503]" 0;
	setAttr ".phl[504]" 0;
	setAttr ".phl[505]" 0;
	setAttr ".phl[506]" 0;
	setAttr ".phl[507]" 0;
	setAttr ".ed" -type "dataReferenceEdits" 
		"RIGRN"
		"RIGRN" 0
		"RIG:MODELRN" 0
		"RIGRN" 169
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
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[370]" "RIG:MODEL:Head0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[371]" "RIG:MODEL:Head0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[372]" "RIG:MODEL:Head0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[373]" "RIG:MODEL:Head0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[374]" "RIG:MODEL:Head0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[375]" "RIG:MODEL:Head0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[376]" "RIG:MODEL:LfArm0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[377]" "RIG:MODEL:LfArm0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[378]" "RIG:MODEL:LfArm0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[379]" "RIG:MODEL:LfArm0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[380]" "RIG:MODEL:LfArm0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[381]" "RIG:MODEL:LfArm0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[382]" "RIG:MODEL:LfArm1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[383]" "RIG:MODEL:LfArm1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[384]" "RIG:MODEL:LfArm1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[385]" "RIG:MODEL:LfArm1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[386]" "RIG:MODEL:LfArm1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[387]" "RIG:MODEL:LfArm1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[388]" "RIG:MODEL:LfArm2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[389]" "RIG:MODEL:LfArm2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[390]" "RIG:MODEL:LfArm2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[391]" "RIG:MODEL:LfArm2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[392]" "RIG:MODEL:LfArm2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[393]" "RIG:MODEL:LfArm2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[394]" "RIG:MODEL:LfArm3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[395]" "RIG:MODEL:LfArm3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[396]" "RIG:MODEL:LfArm3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[397]" "RIG:MODEL:LfArm3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[398]" "RIG:MODEL:LfArm3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[399]" "RIG:MODEL:LfArm3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[400]" "RIG:MODEL:LfLeg0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[401]" "RIG:MODEL:LfLeg0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[402]" "RIG:MODEL:LfLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[403]" "RIG:MODEL:LfLeg0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[404]" "RIG:MODEL:LfLeg0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[405]" "RIG:MODEL:LfLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[406]" "RIG:MODEL:LfLeg1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[407]" "RIG:MODEL:LfLeg1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[408]" "RIG:MODEL:LfLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[409]" "RIG:MODEL:LfLeg1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[410]" "RIG:MODEL:LfLeg1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[411]" "RIG:MODEL:LfLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[412]" "RIG:MODEL:LfLeg2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[413]" "RIG:MODEL:LfLeg2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[414]" "RIG:MODEL:LfLeg2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[415]" "RIG:MODEL:LfLeg2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[416]" "RIG:MODEL:LfLeg2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[417]" "RIG:MODEL:LfLeg2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[418]" "RIG:MODEL:LfLeg3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[419]" "RIG:MODEL:LfLeg3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[420]" "RIG:MODEL:LfLeg3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[421]" "RIG:MODEL:LfLeg3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[422]" "RIG:MODEL:LfLeg3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[423]" "RIG:MODEL:LfLeg3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[424]" "RIG:MODEL:Neck0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[425]" "RIG:MODEL:Neck0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[426]" "RIG:MODEL:Neck0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[427]" "RIG:MODEL:Neck0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[428]" "RIG:MODEL:Neck0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[429]" "RIG:MODEL:Neck0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[430]" "RIG:MODEL:Root_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[431]" "RIG:MODEL:Root_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[432]" "RIG:MODEL:Root_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[433]" "RIG:MODEL:Root_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[434]" "RIG:MODEL:Root_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[435]" "RIG:MODEL:Root_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[436]" "RIG:MODEL:RtArm0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[437]" "RIG:MODEL:RtArm0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[438]" "RIG:MODEL:RtArm0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[439]" "RIG:MODEL:RtArm0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[440]" "RIG:MODEL:RtArm0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[441]" "RIG:MODEL:RtArm0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[442]" "RIG:MODEL:RtArm1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[443]" "RIG:MODEL:RtArm1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[444]" "RIG:MODEL:RtArm1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[445]" "RIG:MODEL:RtArm1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[446]" "RIG:MODEL:RtArm1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[447]" "RIG:MODEL:RtArm1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[448]" "RIG:MODEL:RtArm2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[449]" "RIG:MODEL:RtArm2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[450]" "RIG:MODEL:RtArm2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[451]" "RIG:MODEL:RtArm2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[452]" "RIG:MODEL:RtArm2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[453]" "RIG:MODEL:RtArm2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[454]" "RIG:MODEL:RtArm3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[455]" "RIG:MODEL:RtArm3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[456]" "RIG:MODEL:RtArm3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[457]" "RIG:MODEL:RtArm3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[458]" "RIG:MODEL:RtArm3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[459]" "RIG:MODEL:RtArm3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[460]" "RIG:MODEL:RtLeg0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[461]" "RIG:MODEL:RtLeg0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[462]" "RIG:MODEL:RtLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[463]" "RIG:MODEL:RtLeg0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[464]" "RIG:MODEL:RtLeg0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[465]" "RIG:MODEL:RtLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[466]" "RIG:MODEL:RtLeg1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[467]" "RIG:MODEL:RtLeg1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[468]" "RIG:MODEL:RtLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[469]" "RIG:MODEL:RtLeg1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[470]" "RIG:MODEL:RtLeg1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[471]" "RIG:MODEL:RtLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[472]" "RIG:MODEL:RtLeg2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[473]" "RIG:MODEL:RtLeg2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[474]" "RIG:MODEL:RtLeg2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[475]" "RIG:MODEL:RtLeg2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[476]" "RIG:MODEL:RtLeg2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[477]" "RIG:MODEL:RtLeg2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[478]" "RIG:MODEL:RtLeg3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[479]" "RIG:MODEL:RtLeg3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[480]" "RIG:MODEL:RtLeg3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[481]" "RIG:MODEL:RtLeg3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[482]" "RIG:MODEL:RtLeg3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[483]" "RIG:MODEL:RtLeg3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[484]" "RIG:MODEL:Spine0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[485]" "RIG:MODEL:Spine0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[486]" "RIG:MODEL:Spine0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[487]" "RIG:MODEL:Spine0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[488]" "RIG:MODEL:Spine0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[489]" "RIG:MODEL:Spine0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[490]" "RIG:MODEL:Spine1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[491]" "RIG:MODEL:Spine1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[492]" "RIG:MODEL:Spine1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[493]" "RIG:MODEL:Spine1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[494]" "RIG:MODEL:Spine1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[495]" "RIG:MODEL:Spine1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[496]" "RIG:MODEL:Spine2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[497]" "RIG:MODEL:Spine2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[498]" "RIG:MODEL:Spine2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[499]" "RIG:MODEL:Spine2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[500]" "RIG:MODEL:Spine2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[501]" "RIG:MODEL:Spine2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[502]" "RIG:MODEL:Spine3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[503]" "RIG:MODEL:Spine3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[504]" "RIG:MODEL:Spine3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[505]" "RIG:MODEL:Spine3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[506]" "RIG:MODEL:Spine3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[507]" "RIG:MODEL:Spine3_JNT.rz"
		"RIG:MODELRN" 601
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
		2 "|RIG:MODEL:Root_JNT" "side" " 0"
		2 "|RIG:MODEL:Root_JNT" "type" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT" "type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "drawStyle" 
		" 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "side" 
		" 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT" "type" 
		" 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT" 
		"type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT" 
		"type" " 6"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT" 
		"type" " 7"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"side" " 0"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT" 
		"type" " 8"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT" 
		"type" " 9"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT" 
		"type" " 10"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT" 
		"type" " 11"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT" 
		"type" " 12"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT" 
		"type" " 9"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT" 
		"type" " 10"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT" 
		"type" " 11"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT" 
		"type" " 12"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT" "type" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "drawStyle" 
		" 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "side" 
		" 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT" "type" 
		" 3"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT" 
		"type" " 4"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"side" " 1"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT" 
		"type" " 5"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT" "type" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "drawStyle" 
		" 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "side" 
		" 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT" "type" 
		" 3"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT" 
		"type" " 4"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"drawStyle" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"side" " 2"
		2 "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT" 
		"type" " 5"
		2 "RIG:MODEL:LOD0" "visibility" " 1"
		2 "RIG:MODEL:JNTS" "displayType" " 2"
		2 "RIG:MODEL:JNTS" "visibility" " 1"
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
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleX" "RIGRN.placeHolderList[1]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleY" "RIGRN.placeHolderList[2]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleZ" "RIGRN.placeHolderList[3]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.message" "RIGRN.placeHolderList[4]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateX" "RIGRN.placeHolderList[5]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateY" "RIGRN.placeHolderList[6]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateZ" "RIGRN.placeHolderList[7]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.parentMatrix" "RIGRN.placeHolderList[8]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateX" "RIGRN.placeHolderList[9]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateY" "RIGRN.placeHolderList[10]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateZ" "RIGRN.placeHolderList[11]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateOrder" "RIGRN.placeHolderList[12]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.jointOrient" "RIGRN.placeHolderList[13]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.segmentScaleCompensate" "RIGRN.placeHolderList[14]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.inverseScale" "RIGRN.placeHolderList[15]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.Character" "RIGRN.placeHolderList[16]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateAxis" "RIGRN.placeHolderList[17]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.inverseScale" 
		"RIGRN.placeHolderList[18]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleX" "RIGRN.placeHolderList[19]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleY" "RIGRN.placeHolderList[20]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleZ" "RIGRN.placeHolderList[21]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[22]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateX" "RIGRN.placeHolderList[23]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateY" "RIGRN.placeHolderList[24]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateZ" "RIGRN.placeHolderList[25]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateX" "RIGRN.placeHolderList[26]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateY" "RIGRN.placeHolderList[27]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateZ" "RIGRN.placeHolderList[28]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateOrder" "RIGRN.placeHolderList[29]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.jointOrient" "RIGRN.placeHolderList[30]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[31]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.Character" "RIGRN.placeHolderList[32]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateAxis" "RIGRN.placeHolderList[33]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.inverseScale" 
		"RIGRN.placeHolderList[34]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleX" 
		"RIGRN.placeHolderList[35]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleY" 
		"RIGRN.placeHolderList[36]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleZ" 
		"RIGRN.placeHolderList[37]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[38]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateX" 
		"RIGRN.placeHolderList[39]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateY" 
		"RIGRN.placeHolderList[40]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateZ" 
		"RIGRN.placeHolderList[41]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateX" 
		"RIGRN.placeHolderList[42]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateY" 
		"RIGRN.placeHolderList[43]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateZ" 
		"RIGRN.placeHolderList[44]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[45]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.jointOrient" 
		"RIGRN.placeHolderList[46]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[47]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.Character" 
		"RIGRN.placeHolderList[48]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[49]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.inverseScale" 
		"RIGRN.placeHolderList[50]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleX" 
		"RIGRN.placeHolderList[51]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleY" 
		"RIGRN.placeHolderList[52]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleZ" 
		"RIGRN.placeHolderList[53]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[54]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateX" 
		"RIGRN.placeHolderList[55]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateY" 
		"RIGRN.placeHolderList[56]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateZ" 
		"RIGRN.placeHolderList[57]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateX" 
		"RIGRN.placeHolderList[58]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateY" 
		"RIGRN.placeHolderList[59]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateZ" 
		"RIGRN.placeHolderList[60]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[61]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.jointOrient" 
		"RIGRN.placeHolderList[62]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[63]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.Character" 
		"RIGRN.placeHolderList[64]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[65]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.inverseScale" 
		"RIGRN.placeHolderList[66]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleX" 
		"RIGRN.placeHolderList[67]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleY" 
		"RIGRN.placeHolderList[68]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleZ" 
		"RIGRN.placeHolderList[69]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[70]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateX" 
		"RIGRN.placeHolderList[71]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateY" 
		"RIGRN.placeHolderList[72]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateZ" 
		"RIGRN.placeHolderList[73]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateX" 
		"RIGRN.placeHolderList[74]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateY" 
		"RIGRN.placeHolderList[75]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateZ" 
		"RIGRN.placeHolderList[76]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[77]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.jointOrient" 
		"RIGRN.placeHolderList[78]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[79]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.Character" 
		"RIGRN.placeHolderList[80]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[81]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.inverseScale" 
		"RIGRN.placeHolderList[82]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleX" 
		"RIGRN.placeHolderList[83]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleY" 
		"RIGRN.placeHolderList[84]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleZ" 
		"RIGRN.placeHolderList[85]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[86]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateX" 
		"RIGRN.placeHolderList[87]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateY" 
		"RIGRN.placeHolderList[88]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateZ" 
		"RIGRN.placeHolderList[89]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateX" 
		"RIGRN.placeHolderList[90]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateY" 
		"RIGRN.placeHolderList[91]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateZ" 
		"RIGRN.placeHolderList[92]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[93]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.jointOrient" 
		"RIGRN.placeHolderList[94]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[95]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.Character" 
		"RIGRN.placeHolderList[96]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[97]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.inverseScale" 
		"RIGRN.placeHolderList[98]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleX" 
		"RIGRN.placeHolderList[99]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleY" 
		"RIGRN.placeHolderList[100]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleZ" 
		"RIGRN.placeHolderList[101]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[102]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateX" 
		"RIGRN.placeHolderList[103]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateY" 
		"RIGRN.placeHolderList[104]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateZ" 
		"RIGRN.placeHolderList[105]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateX" 
		"RIGRN.placeHolderList[106]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateY" 
		"RIGRN.placeHolderList[107]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateZ" 
		"RIGRN.placeHolderList[108]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[109]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.jointOrient" 
		"RIGRN.placeHolderList[110]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[111]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.Character" 
		"RIGRN.placeHolderList[112]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[113]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[114]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleX" 
		"RIGRN.placeHolderList[115]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleY" 
		"RIGRN.placeHolderList[116]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleZ" 
		"RIGRN.placeHolderList[117]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[118]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateX" 
		"RIGRN.placeHolderList[119]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateY" 
		"RIGRN.placeHolderList[120]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[121]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[122]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[123]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[124]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[125]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[126]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[127]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.Character" 
		"RIGRN.placeHolderList[128]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[129]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[130]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleX" 
		"RIGRN.placeHolderList[131]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleY" 
		"RIGRN.placeHolderList[132]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleZ" 
		"RIGRN.placeHolderList[133]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateX" 
		"RIGRN.placeHolderList[134]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateY" 
		"RIGRN.placeHolderList[135]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[136]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[137]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[138]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[139]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[140]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[141]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[142]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[143]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.Character" 
		"RIGRN.placeHolderList[144]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[145]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[146]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleX" 
		"RIGRN.placeHolderList[147]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleY" 
		"RIGRN.placeHolderList[148]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleZ" 
		"RIGRN.placeHolderList[149]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateX" 
		"RIGRN.placeHolderList[150]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateY" 
		"RIGRN.placeHolderList[151]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[152]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[153]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[154]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[155]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[156]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[157]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[158]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[159]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.Character" 
		"RIGRN.placeHolderList[160]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[161]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[162]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleX" 
		"RIGRN.placeHolderList[163]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleY" 
		"RIGRN.placeHolderList[164]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleZ" 
		"RIGRN.placeHolderList[165]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[166]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateX" 
		"RIGRN.placeHolderList[167]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateY" 
		"RIGRN.placeHolderList[168]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[169]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[170]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[171]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[172]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[173]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[174]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[175]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.Character" 
		"RIGRN.placeHolderList[176]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[177]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[178]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleX" 
		"RIGRN.placeHolderList[179]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleY" 
		"RIGRN.placeHolderList[180]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleZ" 
		"RIGRN.placeHolderList[181]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[182]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateX" 
		"RIGRN.placeHolderList[183]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateY" 
		"RIGRN.placeHolderList[184]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[185]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[186]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[187]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[188]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[189]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[190]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[191]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.Character" 
		"RIGRN.placeHolderList[192]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[193]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[194]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleX" 
		"RIGRN.placeHolderList[195]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleY" 
		"RIGRN.placeHolderList[196]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleZ" 
		"RIGRN.placeHolderList[197]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateX" 
		"RIGRN.placeHolderList[198]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateY" 
		"RIGRN.placeHolderList[199]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[200]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[201]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[202]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[203]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[204]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[205]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[206]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[207]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.Character" 
		"RIGRN.placeHolderList[208]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[209]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[210]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleX" 
		"RIGRN.placeHolderList[211]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleY" 
		"RIGRN.placeHolderList[212]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleZ" 
		"RIGRN.placeHolderList[213]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateX" 
		"RIGRN.placeHolderList[214]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateY" 
		"RIGRN.placeHolderList[215]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[216]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[217]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[218]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[219]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[220]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[221]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[222]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[223]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.Character" 
		"RIGRN.placeHolderList[224]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[225]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[226]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleX" 
		"RIGRN.placeHolderList[227]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleY" 
		"RIGRN.placeHolderList[228]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleZ" 
		"RIGRN.placeHolderList[229]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[230]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateX" 
		"RIGRN.placeHolderList[231]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateY" 
		"RIGRN.placeHolderList[232]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[233]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[234]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[235]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[236]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[237]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[238]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[239]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.Character" 
		"RIGRN.placeHolderList[240]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[241]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[242]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleX" "RIGRN.placeHolderList[243]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleY" "RIGRN.placeHolderList[244]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleZ" "RIGRN.placeHolderList[245]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateX" "RIGRN.placeHolderList[246]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateY" "RIGRN.placeHolderList[247]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateZ" "RIGRN.placeHolderList[248]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[249]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateX" "RIGRN.placeHolderList[250]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateY" "RIGRN.placeHolderList[251]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateZ" "RIGRN.placeHolderList[252]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[253]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.jointOrient" "RIGRN.placeHolderList[254]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[255]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.Character" "RIGRN.placeHolderList[256]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[257]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[258]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleX" 
		"RIGRN.placeHolderList[259]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleY" 
		"RIGRN.placeHolderList[260]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleZ" 
		"RIGRN.placeHolderList[261]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateX" 
		"RIGRN.placeHolderList[262]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateY" 
		"RIGRN.placeHolderList[263]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateZ" 
		"RIGRN.placeHolderList[264]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[265]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateX" 
		"RIGRN.placeHolderList[266]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateY" 
		"RIGRN.placeHolderList[267]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateZ" 
		"RIGRN.placeHolderList[268]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[269]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[270]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[271]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.Character" 
		"RIGRN.placeHolderList[272]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[273]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[274]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleX" 
		"RIGRN.placeHolderList[275]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleY" 
		"RIGRN.placeHolderList[276]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleZ" 
		"RIGRN.placeHolderList[277]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[278]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[279]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[280]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[281]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[282]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[283]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[284]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[285]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[286]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[287]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.Character" 
		"RIGRN.placeHolderList[288]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[289]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[290]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleX" 
		"RIGRN.placeHolderList[291]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleY" 
		"RIGRN.placeHolderList[292]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleZ" 
		"RIGRN.placeHolderList[293]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[294]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[295]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[296]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[297]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[298]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[299]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[300]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[301]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[302]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[303]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.Character" 
		"RIGRN.placeHolderList[304]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[305]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[306]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleX" "RIGRN.placeHolderList[307]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleY" "RIGRN.placeHolderList[308]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleZ" "RIGRN.placeHolderList[309]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateX" "RIGRN.placeHolderList[310]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateY" "RIGRN.placeHolderList[311]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateZ" "RIGRN.placeHolderList[312]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[313]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateX" "RIGRN.placeHolderList[314]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateY" "RIGRN.placeHolderList[315]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateZ" "RIGRN.placeHolderList[316]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[317]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.jointOrient" "RIGRN.placeHolderList[318]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[319]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.Character" "RIGRN.placeHolderList[320]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[321]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[322]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleX" 
		"RIGRN.placeHolderList[323]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleY" 
		"RIGRN.placeHolderList[324]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleZ" 
		"RIGRN.placeHolderList[325]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateX" 
		"RIGRN.placeHolderList[326]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateY" 
		"RIGRN.placeHolderList[327]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateZ" 
		"RIGRN.placeHolderList[328]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[329]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateX" 
		"RIGRN.placeHolderList[330]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateY" 
		"RIGRN.placeHolderList[331]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateZ" 
		"RIGRN.placeHolderList[332]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[333]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[334]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[335]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.Character" 
		"RIGRN.placeHolderList[336]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[337]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[338]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleX" 
		"RIGRN.placeHolderList[339]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleY" 
		"RIGRN.placeHolderList[340]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleZ" 
		"RIGRN.placeHolderList[341]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[342]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[343]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[344]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[345]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[346]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[347]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[348]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[349]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[350]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[351]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.Character" 
		"RIGRN.placeHolderList[352]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[353]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[354]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleX" 
		"RIGRN.placeHolderList[355]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleY" 
		"RIGRN.placeHolderList[356]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleZ" 
		"RIGRN.placeHolderList[357]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[358]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[359]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[360]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[361]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[362]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[363]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[364]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[365]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[366]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[367]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.Character" 
		"RIGRN.placeHolderList[368]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[369]" "";
	setAttr ".ptag" -type "string" "";
lockNode -l 1 ;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "9EBDBA84-41C8-A8D5-3AB9-2AAE4428660D";
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 32 -ast 0 -aet 200 ";
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
	setAttr ".OutputPropertySetState" -type "HIKPropertySetState" ;
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
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
	setAttr ".decs" -type "HIKCharacterState" ;
createNode HIKState2SK -n "HIKState2SK1";
	rename -uid "3DE1F1EC-46B5-96C9-29BB-80B0CF921EA1";
	setAttr ".ihi" 0;
	setAttr ".HipsTx" 3.6088106632232666;
	setAttr ".HipsTy" 51.636955261230469;
	setAttr ".HipsTz" -21.375129699707031;
	setAttr ".HipsRx" 14.628315624682237;
	setAttr ".HipsRy" -2.0927941321514703;
	setAttr ".HipsRz" 7.9646301268025566;
	setAttr ".HipsSx" 0.99999988101891835;
	setAttr ".HipsSy" 0.99999988362995218;
	setAttr ".HipsSz" 0.99999993698778789;
	setAttr ".LeftUpLegTx" 24.896384011694494;
	setAttr ".LeftUpLegTy" -7.7306335292689496;
	setAttr ".LeftUpLegTz" 3.1970303795745423;
	setAttr ".LeftUpLegRx" -7.5922423470835314;
	setAttr ".LeftUpLegRy" 9.3962883203257963;
	setAttr ".LeftUpLegRz" -23.808659347862985;
	setAttr ".LeftUpLegSx" 0.99999999192494016;
	setAttr ".LeftUpLegSy" 0.99999994426160033;
	setAttr ".LeftUpLegSz" 1.0000000527061637;
	setAttr ".LeftLegTx" 21.2261967228226;
	setAttr ".LeftLegTy" 6.663130669437578e-008;
	setAttr ".LeftLegTz" -1.0092199076439101e-006;
	setAttr ".LeftLegRx" 1.1225251309207365;
	setAttr ".LeftLegRy" 0.11588820936014392;
	setAttr ".LeftLegRz" 2.8065249117096651;
	setAttr ".LeftLegSx" 1.0000000788509495;
	setAttr ".LeftLegSy" 1.0000001429613397;
	setAttr ".LeftLegSz" 1.000000082939672;
	setAttr ".LeftFootTx" 15.941059774691393;
	setAttr ".LeftFootTy" 7.1704893898072442e-006;
	setAttr ".LeftFootTz" -3.2332713288951709e-006;
	setAttr ".LeftFootRx" -19.74718841706045;
	setAttr ".LeftFootRy" -9.9893470723944375;
	setAttr ".LeftFootRz" 6.1772704789075767;
	setAttr ".LeftFootSx" 1.0000001047112159;
	setAttr ".LeftFootSy" 1.0000001011186803;
	setAttr ".LeftFootSz" 1.0000001721128764;
	setAttr ".RightUpLegTx" -24.896330314062887;
	setAttr ".RightUpLegTy" -7.7306025271792151;
	setAttr ".RightUpLegTz" 3.1970289223972017;
	setAttr ".RightUpLegRx" 11.561842475364566;
	setAttr ".RightUpLegRy" -16.623856591071544;
	setAttr ".RightUpLegRz" -20.960316697386734;
	setAttr ".RightUpLegSx" 0.99999993118396624;
	setAttr ".RightUpLegSy" 1.0000000106950073;
	setAttr ".RightUpLegSz" 0.99999989357044272;
	setAttr ".RightLegTx" -21.22617887876779;
	setAttr ".RightLegTy" 1.8357940455793198e-005;
	setAttr ".RightLegTz" -8.012693025349904e-005;
	setAttr ".RightLegRx" 1.7747847359091757;
	setAttr ".RightLegRy" -0.70953807351788412;
	setAttr ".RightLegRz" 30.275415261007346;
	setAttr ".RightLegSx" 0.99999997431943011;
	setAttr ".RightLegSy" 1.0000000097059638;
	setAttr ".RightLegSz" 1.0000000279352936;
	setAttr ".RightFootTx" -15.941104314358121;
	setAttr ".RightFootTy" 4.2444359355187089e-005;
	setAttr ".RightFootTz" 4.8836194583401493e-005;
	setAttr ".RightFootRx" -28.011020041745958;
	setAttr ".RightFootRy" -5.3310782730557742;
	setAttr ".RightFootRz" 27.57680927166205;
	setAttr ".RightFootSx" 0.99999996825438597;
	setAttr ".RightFootSy" 0.99999992908531199;
	setAttr ".RightFootSz" 1.0000000199274852;
	setAttr ".SpineTx" -3.9397108064775921e-006;
	setAttr ".SpineTy" 3.382540505774557;
	setAttr ".SpineTz" -3.783547221968746;
	setAttr ".SpineRx" -0.84224797743399338;
	setAttr ".SpineRy" -2.3598684236839325;
	setAttr ".SpineRz" -10.704080201601561;
	setAttr ".SpineSx" 0.99999999209737211;
	setAttr ".SpineSy" 0.99999997107391492;
	setAttr ".SpineSz" 0.99999996188984452;
	setAttr ".LeftArmTx" 7.559808685251852;
	setAttr ".LeftArmTy" -1.3346354358059642;
	setAttr ".LeftArmTz" 6.4182886382952447;
	setAttr ".LeftArmRx" -1.5889826765710364;
	setAttr ".LeftArmRy" 21.996241809141072;
	setAttr ".LeftArmRz" -45.795593021180544;
	setAttr ".LeftArmSx" 1.0000001285887088;
	setAttr ".LeftArmSy" 1.0000001812125556;
	setAttr ".LeftArmSz" 1.0000001204442637;
	setAttr ".LeftForeArmTx" 23.627830964341104;
	setAttr ".LeftForeArmTy" -0.36614230435245787;
	setAttr ".LeftForeArmTz" 0.61648251299324386;
	setAttr ".LeftForeArmRx" -17.326153270550698;
	setAttr ".LeftForeArmRy" -10.689862445981982;
	setAttr ".LeftForeArmRz" 78.258838811790639;
	setAttr ".LeftForeArmSx" 0.99999998882170038;
	setAttr ".LeftForeArmSy" 1.0000000599672132;
	setAttr ".LeftForeArmSz" 0.99999997858549983;
	setAttr ".LeftHandTx" 22.329481161795972;
	setAttr ".LeftHandTy" -0.3435191644416733;
	setAttr ".LeftHandTz" 0.83664468097994416;
	setAttr ".LeftHandRx" -10.378267807301057;
	setAttr ".LeftHandRy" -1.4961599900213705;
	setAttr ".LeftHandRz" -18.473721251506234;
	setAttr ".LeftHandSx" 0.99999996298542293;
	setAttr ".LeftHandSy" 1.0000000085258898;
	setAttr ".LeftHandSz" 1.0000000059617986;
	setAttr ".RightArmTx" -7.5598872416181031;
	setAttr ".RightArmTy" 1.3346071756461555;
	setAttr ".RightArmTz" -6.4178981997192253;
	setAttr ".RightArmRx" 24.406800411832361;
	setAttr ".RightArmRy" 18.362156180787313;
	setAttr ".RightArmRz" -57.17840071609389;
	setAttr ".RightArmSx" 1.0000001187127625;
	setAttr ".RightArmSy" 1.0000001184594407;
	setAttr ".RightArmSz" 1.0000000512072178;
	setAttr ".RightForeArmTx" -23.627900861832689;
	setAttr ".RightForeArmTy" 0.3661371195845895;
	setAttr ".RightForeArmTz" -0.61643987575540393;
	setAttr ".RightForeArmRx" -4.3303171862286653;
	setAttr ".RightForeArmRy" -8.0330750331841507;
	setAttr ".RightForeArmRz" 22.451791150351681;
	setAttr ".RightForeArmSx" 1.0000000434158312;
	setAttr ".RightForeArmSy" 0.99999995449722956;
	setAttr ".RightForeArmSz" 0.99999997791972461;
	setAttr ".RightHandTx" -22.329465654181632;
	setAttr ".RightHandTy" 0.34352449211890335;
	setAttr ".RightHandTz" -0.83669001193933923;
	setAttr ".RightHandRx" -69.952314204433193;
	setAttr ".RightHandRy" -52.690632190436851;
	setAttr ".RightHandRz" -67.315912105992737;
	setAttr ".RightHandSx" 1.0000000940273099;
	setAttr ".RightHandSy" 1.0000003092994605;
	setAttr ".RightHandSz" 1.0000000284227359;
	setAttr ".HeadTx" 8.0099353442316215;
	setAttr ".HeadTy" -2.4835623422703179e-005;
	setAttr ".HeadTz" 1.8320638041302573e-005;
	setAttr ".HeadRx" 16.69556797509161;
	setAttr ".HeadRy" 7.4151006209172365;
	setAttr ".HeadRz" -29.237791548400278;
	setAttr ".HeadSx" 1.0000000542865666;
	setAttr ".HeadSy" 1.0000000721974878;
	setAttr ".HeadSz" 1.0000000655555612;
	setAttr ".LeftToeBaseTx" 6.8757388527960579;
	setAttr ".LeftToeBaseTy" -9.2084339620157607e-007;
	setAttr ".LeftToeBaseTz" 1.6708240337948155e-006;
	setAttr ".LeftToeBaseRx" 8.2071665340848803;
	setAttr ".LeftToeBaseRy" 17.627930683133247;
	setAttr ".LeftToeBaseRz" -4.3501156244948671;
	setAttr ".LeftToeBaseSx" 0.99999979737423916;
	setAttr ".LeftToeBaseSy" 0.9999997765341937;
	setAttr ".LeftToeBaseSz" 0.99999977594599909;
	setAttr ".RightToeBaseTx" -6.8757567242339457;
	setAttr ".RightToeBaseTy" 2.5513952799371964e-006;
	setAttr ".RightToeBaseTz" 2.3155280828746072e-005;
	setAttr ".RightToeBaseRx" -6.4643472068108938;
	setAttr ".RightToeBaseRy" 3.780299871787439;
	setAttr ".RightToeBaseRz" 2.1193700190113711;
	setAttr ".RightToeBaseSx" 1.0000001460697945;
	setAttr ".RightToeBaseSy" 1.0000000096447028;
	setAttr ".RightToeBaseSz" 1.0000000471947093;
	setAttr ".LeftShoulderTx" 10.38134134138663;
	setAttr ".LeftShoulderTy" 5.2150702754729465;
	setAttr ".LeftShoulderTz" 13.982771126595125;
	setAttr ".LeftShoulderRx" -3.6824881147459512;
	setAttr ".LeftShoulderRy" 3.6169378346416456;
	setAttr ".LeftShoulderRz" 5.5567687269982384;
	setAttr ".LeftShoulderSx" 1.0000000993390483;
	setAttr ".LeftShoulderSy" 1.0000000779323992;
	setAttr ".LeftShoulderSz" 1.000000074854994;
	setAttr ".RightShoulderTx" 10.381004860200051;
	setAttr ".RightShoulderTy" 5.2151776851105893;
	setAttr ".RightShoulderTz" -13.982811302262038;
	setAttr ".RightShoulderRx" 1.5191930503939715;
	setAttr ".RightShoulderRy" 3.5054133418593536;
	setAttr ".RightShoulderRz" -5.386176732362232;
	setAttr ".RightShoulderSx" 1.0000001901849971;
	setAttr ".RightShoulderSy" 1.0000000160223255;
	setAttr ".RightShoulderSz" 1.0000000757109364;
	setAttr ".NeckTx" 17.971303602163189;
	setAttr ".NeckTy" 4.2177542738386364e-006;
	setAttr ".NeckTz" 1.5057248864636108e-005;
	setAttr ".NeckRx" 0.058243861175478827;
	setAttr ".NeckRy" -17.901906758396532;
	setAttr ".NeckRz" 4.7514241052427479;
	setAttr ".NeckSx" 0.99999998534786916;
	setAttr ".NeckSy" 0.99999990331425115;
	setAttr ".NeckSz" 0.99999999915214588;
	setAttr ".Spine1Tx" 7.1917500042784681;
	setAttr ".Spine1Ty" 4.9265586454794175e-007;
	setAttr ".Spine1Tz" 2.4466804582345958e-008;
	setAttr ".Spine1Rx" 0.15748151264480112;
	setAttr ".Spine1Ry" -4.9867703178938276;
	setAttr ".Spine1Rz" -21.460042563126475;
	setAttr ".Spine1Sx" 1.0000001005220782;
	setAttr ".Spine1Sy" 1.0000001836601231;
	setAttr ".Spine1Sz" 1.0000001494468027;
	setAttr ".Spine2Tx" 15.480262649462759;
	setAttr ".Spine2Ty" 2.1285042532959153e-006;
	setAttr ".Spine2Tz" -1.9798640207291385e-006;
	setAttr ".Spine2Rx" 0.55742383800271444;
	setAttr ".Spine2Ry" -4.9580690497166557;
	setAttr ".Spine2Rz" -21.47731022799346;
	setAttr ".Spine2Sx" 1.0000000308015178;
	setAttr ".Spine2Sy" 1.0000001178170628;
	setAttr ".Spine2Sz" 1.0000000173221304;
	setAttr ".Spine3Tx" 13.088922400000342;
	setAttr ".Spine3Ty" 6.3619205548093305e-007;
	setAttr ".Spine3Tz" -4.2498682972791357e-007;
	setAttr ".Spine3Rx" -1.8672358756220067;
	setAttr ".Spine3Ry" -4.6274699897727034;
	setAttr ".Spine3Rz" -21.377739282648427;
	setAttr ".Spine3Sx" 0.99999989863239058;
	setAttr ".Spine3Sy" 0.99999995642313222;
	setAttr ".Spine3Sz" 0.99999989324874006;
createNode vstExportNode -n "kobold_overboss_anim_exportNode";
	rename -uid "D8090369-4943-2EAF-6884-29B202AD28AD";
	setAttr ".ei[0].exportFile" -type "string" "overboss_stun";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 32;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "8607C2B2-4105-B719-5AA8-D2A0571AB727";
	setAttr ".ihi" 0;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "4C20D771-422B-035D-8E43-AD880526855D";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "9B074D52-42E4-40B2-23C7-729C664F4E69";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "62464BA1-4120-E23D-77A4-39A4EA8E7644";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "2C5C5F2A-4687-BAE6-8921-EC8E6A15251E";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "58AD3629-4BAD-0AD2-FC21-B49CC868A73D";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "25C26EF8-4920-5132-0961-DD81298A95D0";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "C9E15B10-4D72-4169-9C56-10BD4B9B30CB";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "FFDEB5E8-4E21-F98B-FAE1-7BAB22A987A7";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "63D54797-4E58-6F3B-D587-3183BF1CAC9A";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "AB5C78B8-4C05-F553-A62C-3CA86A080589";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "B32034C6-441B-A438-58CB-8FAB5986B40E";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "A9C5E888-4F62-1739-CE98-678F3096ED72";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "7A3A58EB-481A-79A1-74BA-9497C803ABCD";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "11881B35-4E5F-22D4-4EAA-E9A3103AC6F8";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "0426757A-4AA9-44D6-C1AF-738605264674";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "D932D64A-4458-E7DA-9FDD-08B2B5A97F00";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.98969310522079468 0.13846932351589203 0.036518022418022156 0
		 -0.14320378005504608 0.95697295665740967 0.25237908959388733 0 0 -0.25500741600990295 0.96693903207778931 0
		 3.6088106632232666 51.636955261230469 -21.375129699707031 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99770009517669678 0.020408777520060539 -0.064637862145900726 0
		 -0.031375013291835785 0.9843364953994751 -0.17348575592041016 0 0.060084782540798187 0.17511476576328278 0.98271298408508301 0
		 29.355646133422852 46.871067047119141 -19.325679779052734 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99906879663467407 -0.0021993506234139204 -0.043092574924230576 0
		 -0.0035511942114681005 0.99112099409103394 -0.13291639089584351 0 0.043002281337976456 0.13294562697410583 0.99019014835357666 0
		 28.717580795288086 28.144168853759766 -9.3533391952514648 1;
	setAttr ".LeftFootGX" -type "matrix" 0.86759412288665771 -0.16824030876159668 -0.46794906258583069 0
		 0.084987729787826538 0.97735053300857544 -0.19381354749202728 0 0.48995736241340637 0.12838152050971985 0.86224168539047241 0
		 24.316305160522461 16.415872573852539 -19.212003707885742 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.96416068077087402 -0.26487413048744202 -0.015353008173406124 0
		 0.26488268375396729 0.9642794132232666 -0.0015140498289838433 0 0.015205622650682926 -0.0026069583836942911 0.99988090991973877 0
		 -19.923864364624023 39.976333618164063 -21.144004821777344 1;
	setAttr ".RightLegGX" -type "matrix" 0.98964041471481323 -0.11898772418498993 -0.080340608954429626 0
		 0.14312757551670074 0.86160796880722046 0.48697733879089355 0 0.011277768760919571 -0.4934312105178833 0.86971217393875122 0
		 -23.557300567626953 20.094812393188477 -14.657567977905273 1;
	setAttr ".RightFootGX" -type "matrix" 0.83866745233535767 -0.18729102611541748 0.5114288330078125 0
		 0.15527567267417908 0.98226600885391235 0.10508781671524048 0 -0.52204108238220215 -0.0087212547659873962 0.85287606716156006 0
		 -21.255355834960937 16.431804656982422 -30.000391006469727 1;
	setAttr ".SpineGX" -type "matrix" 0.99463605880737305 0.095200315117835999 0.040446605533361435 0
		 -0.097856521606445313 0.99275308847427368 0.069751575589179993 0 -0.033513125032186508 -0.073335394263267517 0.99674403667449951 0
		 3.1244142055511475 55.838787078857422 -24.179906845092773 1;
	setAttr ".LeftArmGX" -type "matrix" 0.69234621524810791 -0.72156554460525513 0.00027950105140917003 0
		 0.62194252014160156 0.59656089544296265 -0.50725042819976807 0 0.36584761738777161 0.35136663913726807 0.86179882287979126 0
		 28.278650283813477 91.344993591308594 -35.473526000976563 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.12007302045822144 0.40805813670158386 0.90502560138702393 0
		 0.76710200309753418 0.54054439067840576 -0.34549480676651001 0 -0.63018816709518433 0.73573136329650879 -0.24811734259128571 0
		 44.644821166992188 74.288116455078125 -35.4669189453125 1;
	setAttr ".LeftHandGX" -type "matrix" 0.26508313417434692 0.13297706842422485 0.95501226186752319 0
		 0.87455278635025024 0.38394880294799805 -0.29621133208274841 0 -0.40606492757797241 0.91372907161712646 -0.014517068862915039 0
		 47.328193664550781 83.407318115234375 -15.241603851318359 1;
	setAttr ".RightArmGX" -type "matrix" 0.42446506023406982 0.81001543998718262 0.40460464358329773 0
		 -0.71893036365509033 0.57315552234649658 -0.39323318004608154 0 -0.550426185131073 -0.12396883964538574 0.82562899589538574 0
		 -16.450037002563477 93.601974487304688 -45.668132781982422 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.61181420087814331 0.69628441333770752 -0.37532839179039001 0
		 -0.7851414680480957 0.47691282629966736 -0.39510393142700195 0 -0.096105754375457764 0.53641605377197266 0.83846378326416016 0
		 -26.307666778564453 74.133270263671875 -54.755958557128906 1;
	setAttr ".RightHandGX" -type "matrix" -0.46741598844528198 0.88171684741973877 -0.064012318849563599 0
		 0.39311274886131287 0.1424483060836792 -0.90838915109634399 0 -0.7918236255645752 -0.44975966215133667 -0.41319677233695984 0
		 -40.198043823242187 58.765548706054688 -46.370632171630859 1;
	setAttr ".HeadGX" -type "matrix" 0.81877774000167847 -0.56840193271636963 0.080763965845108032 0
		 0.18471121788024902 0.12761250138282776 -0.9744727611541748 0 0.54358565807342529 0.81279432773590088 0.20947645604610443 0
		 11.638580322265625 105.6041259765625 -52.076473236083984 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324440479278564 -4.5016292915533995e-008 -0.48728227615356445 0
		 -4.5016292915533995e-008 0.99999988079071045 -1.7305477229001553e-007 0 0.48728227615356445 1.7305477229001553e-007 0.87324440479278564 0
		 22.594865798950195 9.7713375091552734 -18.808773040771484 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841275215148926 -2.2288647016921459e-007 0.52933573722839355 0
		 3.7877725844737142e-007 1.0000002384185791 -1.8603104479097965e-007 0 -0.52933573722839355 3.5833136280416511e-007 0.84841275215148926 0
		 -21.121191024780273 9.7385187149047852 -31.56817626953125 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.87630033493041992 -0.12145610153675079 0.46620485186576843 0
		 0.46282428503036499 0.48091572523117065 -0.74465721845626831 0 -0.13376191258430481 0.86831396818161011 0.47763925790786743 0
		 19.568000793457031 95.567710876464844 -38.007228851318359 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.98961555957794189 0.14356833696365356 0.007032737135887146 0
		 -0.061976898461580276 0.47032871842384338 -0.88031244277954102 0 -0.1296926736831665 0.87073493003845215 0.4743424654006958 0
		 -7.6824560165405273 98.040664672851563 -43.783969879150391 1;
	setAttr ".NeckGX" -type "matrix" 0.8768007755279541 -0.36327430605888367 0.31504428386688232 0
		 0.46897381544113159 0.50129598379135132 -0.72716319561004639 0 0.10622929036617279 0.78532451391220093 0.60990273952484131 0
		 7.9846038818359375 98.91107177734375 -49.624832153320312 1;
	setAttr ".Spine1GX" -type "matrix" 0.99732697010040283 0.014002544805407524 0.071713000535964966 0
		 0.0077785514295101166 0.95554113388061523 -0.29475504159927368 0 -0.072652041912078857 0.29452496767044067 0.95287805795669556 0
		 2.3884813785552979 62.762157440185547 -22.378070831298828 1;
	setAttr ".Spine2GX" -type "matrix" 0.99024611711502075 -0.050337716937065125 0.1299201101064682 0
		 0.12021857500076294 0.78003901243209839 -0.61407417058944702 0 -0.070431634783744812 0.62370312213897705 0.77848190069198608 0
		 2.6171185970306396 77.043807983398438 -28.346384048461914 1;
	setAttr ".Spine3GX" -type "matrix" 0.97442585229873657 -0.088434800505638123 0.20657671988010406 0
		 0.22306084632873535 0.49184861779212952 -0.84162294864654541 0 -0.02717568539083004 0.86617809534072876 0.49899622797966003 0
		 4.3284292221069336 85.656082153320312 -38.053085327148437 1;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "830EFA95-481F-5E68-7857-28B6BDDAE3A7";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.98969310522079468 0.13846932351589203 0.036518022418022156 0
		 -0.14320378005504608 0.95697295665740967 0.25237908959388733 0 0 -0.25500741600990295 0.96693903207778931 0
		 3.6088106632232666 51.636955261230469 -21.375129699707031 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99770009517669678 0.020408777520060539 -0.064637862145900726 0
		 -0.031375013291835785 0.9843364953994751 -0.17348575592041016 0 0.060084782540798187 0.17511476576328278 0.98271298408508301 0
		 29.355646133422852 46.871067047119141 -19.325679779052734 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99906879663467407 -0.0021993506234139204 -0.043092574924230576 0
		 -0.0035511942114681005 0.99112099409103394 -0.13291639089584351 0 0.043002281337976456 0.13294562697410583 0.99019014835357666 0
		 28.717580795288086 28.144168853759766 -9.3533391952514648 1;
	setAttr ".LeftFootGX" -type "matrix" 0.86759412288665771 -0.16824030876159668 -0.46794906258583069 0
		 0.084987729787826538 0.97735053300857544 -0.19381354749202728 0 0.48995736241340637 0.12838152050971985 0.86224168539047241 0
		 24.316305160522461 16.415872573852539 -19.212003707885742 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.96416068077087402 -0.26487413048744202 -0.015353008173406124 0
		 0.26488268375396729 0.9642794132232666 -0.0015140498289838433 0 0.015205622650682926 -0.0026069583836942911 0.99988090991973877 0
		 -19.923864364624023 39.976333618164063 -21.144004821777344 1;
	setAttr ".RightLegGX" -type "matrix" 0.98964041471481323 -0.11898772418498993 -0.080340608954429626 0
		 0.14312757551670074 0.86160796880722046 0.48697733879089355 0 0.011277768760919571 -0.4934312105178833 0.86971217393875122 0
		 -23.557300567626953 20.094812393188477 -14.657567977905273 1;
	setAttr ".RightFootGX" -type "matrix" 0.83866745233535767 -0.18729102611541748 0.5114288330078125 0
		 0.15527567267417908 0.98226600885391235 0.10508781671524048 0 -0.52204108238220215 -0.0087212547659873962 0.85287606716156006 0
		 -21.255355834960937 16.431804656982422 -30.000391006469727 1;
	setAttr ".SpineGX" -type "matrix" 0.99463605880737305 0.095200315117835999 0.040446605533361435 0
		 -0.097856521606445313 0.99275308847427368 0.069751575589179993 0 -0.033513125032186508 -0.073335394263267517 0.99674403667449951 0
		 3.1244142055511475 55.838787078857422 -24.179906845092773 1;
	setAttr ".LeftArmGX" -type "matrix" 0.69234621524810791 -0.72156554460525513 0.00027950105140917003 0
		 0.62194252014160156 0.59656089544296265 -0.50725042819976807 0 0.36584761738777161 0.35136663913726807 0.86179882287979126 0
		 28.278650283813477 91.344993591308594 -35.473526000976563 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.12007302045822144 0.40805813670158386 0.90502560138702393 0
		 0.76710200309753418 0.54054439067840576 -0.34549480676651001 0 -0.63018816709518433 0.73573136329650879 -0.24811734259128571 0
		 44.644821166992188 74.288116455078125 -35.4669189453125 1;
	setAttr ".LeftHandGX" -type "matrix" 0.26508313417434692 0.13297706842422485 0.95501226186752319 0
		 0.87455278635025024 0.38394880294799805 -0.29621133208274841 0 -0.40606492757797241 0.91372907161712646 -0.014517068862915039 0
		 47.328193664550781 83.407318115234375 -15.241603851318359 1;
	setAttr ".RightArmGX" -type "matrix" 0.42446506023406982 0.81001543998718262 0.40460464358329773 0
		 -0.71893036365509033 0.57315552234649658 -0.39323318004608154 0 -0.550426185131073 -0.12396883964538574 0.82562899589538574 0
		 -16.450037002563477 93.601974487304688 -45.668132781982422 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.61181420087814331 0.69628441333770752 -0.37532839179039001 0
		 -0.7851414680480957 0.47691282629966736 -0.39510393142700195 0 -0.096105754375457764 0.53641605377197266 0.83846378326416016 0
		 -26.307666778564453 74.133270263671875 -54.755958557128906 1;
	setAttr ".RightHandGX" -type "matrix" -0.46741598844528198 0.88171684741973877 -0.064012318849563599 0
		 0.39311274886131287 0.1424483060836792 -0.90838915109634399 0 -0.7918236255645752 -0.44975966215133667 -0.41319677233695984 0
		 -40.198043823242187 58.765548706054688 -46.370632171630859 1;
	setAttr ".HeadGX" -type "matrix" 0.81877774000167847 -0.56840193271636963 0.080763965845108032 0
		 0.18471121788024902 0.12761250138282776 -0.9744727611541748 0 0.54358565807342529 0.81279432773590088 0.20947645604610443 0
		 11.638580322265625 105.6041259765625 -52.076473236083984 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324440479278564 -4.5016292915533995e-008 -0.48728227615356445 0
		 -4.5016292915533995e-008 0.99999988079071045 -1.7305477229001553e-007 0 0.48728227615356445 1.7305477229001553e-007 0.87324440479278564 0
		 22.594865798950195 9.7713375091552734 -18.808773040771484 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841275215148926 -2.2288647016921459e-007 0.52933573722839355 0
		 3.7877725844737142e-007 1.0000002384185791 -1.8603104479097965e-007 0 -0.52933573722839355 3.5833136280416511e-007 0.84841275215148926 0
		 -21.121191024780273 9.7385187149047852 -31.56817626953125 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.87630033493041992 -0.12145610153675079 0.46620485186576843 0
		 0.46282428503036499 0.48091572523117065 -0.74465721845626831 0 -0.13376191258430481 0.86831396818161011 0.47763925790786743 0
		 19.568000793457031 95.567710876464844 -38.007228851318359 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.98961555957794189 0.14356833696365356 0.007032737135887146 0
		 -0.061976898461580276 0.47032871842384338 -0.88031244277954102 0 -0.1296926736831665 0.87073493003845215 0.4743424654006958 0
		 -7.6824560165405273 98.040664672851563 -43.783969879150391 1;
	setAttr ".NeckGX" -type "matrix" 0.8768007755279541 -0.36327430605888367 0.31504428386688232 0
		 0.46897381544113159 0.50129598379135132 -0.72716319561004639 0 0.10622929036617279 0.78532451391220093 0.60990273952484131 0
		 7.9846038818359375 98.91107177734375 -49.624832153320312 1;
	setAttr ".Spine1GX" -type "matrix" 0.99732697010040283 0.014002544805407524 0.071713000535964966 0
		 0.0077785514295101166 0.95554113388061523 -0.29475504159927368 0 -0.072652041912078857 0.29452496767044067 0.95287805795669556 0
		 2.3884813785552979 62.762157440185547 -22.378070831298828 1;
	setAttr ".Spine2GX" -type "matrix" 0.99024611711502075 -0.050337716937065125 0.1299201101064682 0
		 0.12021857500076294 0.78003901243209839 -0.61407417058944702 0 -0.070431634783744812 0.62370312213897705 0.77848190069198608 0
		 2.6171185970306396 77.043807983398438 -28.346384048461914 1;
	setAttr ".Spine3GX" -type "matrix" 0.97442585229873657 -0.088434800505638123 0.20657671988010406 0
		 0.22306084632873535 0.49184861779212952 -0.84162294864654541 0 -0.02717568539083004 0.86617809534072876 0.49899622797966003 0
		 4.3284292221069336 85.656082153320312 -38.053085327148437 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "9D934CD8-4181-BFFD-2072-FE8968C7E7F2";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "361D0FC0-4A6A-4724-6B75-638855EBFCC7";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "07FBD386-4A15-D434-C0CD-FCA055B57CFB";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.98969310522079468 0.13846932351589203 0.036518022418022156 0
		 -0.14320378005504608 0.95697295665740967 0.25237908959388733 0 0 -0.25500741600990295 0.96693903207778931 0
		 4.7158908843994141 43.423698425292969 -20.234842300415039 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.86759412288665771 -0.16824030876159668 -0.46794906258583069 0
		 0.084987737238407135 0.97735059261322021 -0.19381356239318848 0 0.48995736241340637 0.12838152050971985 0.86224168539047241 0
		 24.316305160522461 16.415872573852539 -19.212003707885742 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.83866745233535767 -0.18729102611541748 0.5114288330078125 0
		 0.15527567267417908 0.98226600885391235 0.10508781671524048 0 -0.52204108238220215 -0.0087212547659873962 0.85287606716156006 0
		 -21.255355834960937 16.431804656982422 -30.000391006469727 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.26508313417434692 0.13297706842422485 0.95501226186752319 0
		 0.87455278635025024 0.38394880294799805 -0.29621133208274841 0 -0.40606492757797241 0.91372907161712646 -0.014517068862915039 0
		 47.328193664550781 83.407318115234375 -15.241603851318359 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.46741598844528198 0.88171684741973877 -0.064012318849563599 0
		 0.39311274886131287 0.1424483060836792 -0.90838915109634399 0 -0.7918236255645752 -0.44975966215133667 -0.41319677233695984 0
		 -40.198043823242187 58.765548706054688 -46.370632171630859 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99906879663467407 -0.0021993506234139204 -0.043092574924230576 0
		 -0.0035511942114681005 0.99112099409103394 -0.13291639089584351 0 0.043002281337976456 0.13294562697410583 0.99019014835357666 0
		 28.717580795288086 28.144168853759766 -9.3533391952514648 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98964041471481323 -0.11898772418498993 -0.080340608954429626 0
		 0.14312757551670074 0.86160796880722046 0.48697733879089355 0 0.011277768760919571 -0.4934312105178833 0.86971217393875122 0
		 -23.557300567626953 20.094812393188477 -14.657567977905273 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" 0.12007302045822144 0.40805813670158386 0.90502560138702393 0
		 0.76710200309753418 0.54054439067840576 -0.34549480676651001 0 -0.6301882266998291 0.73573142290115356 -0.2481173574924469 0
		 44.644821166992188 74.288116455078125 -35.4669189453125 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.61181420087814331 0.69628441333770752 -0.37532839179039001 0
		 -0.7851414680480957 0.47691282629966736 -0.39510393142700195 0 -0.096105754375457764 0.53641605377197266 0.83846378326416016 0
		 -26.307666778564453 74.133270263671875 -54.755958557128906 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.99463605880737305 0.095200315117835999 0.040446605533361435 0
		 -0.097856521606445313 0.99275308847427368 0.069751575589179993 0 -0.033513125032186508 -0.073335394263267517 0.99674403667449951 0
		 3.1244142055511475 55.838787078857422 -24.179906845092773 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.97442591190338135 -0.088434807956218719 0.20657673478126526 0
		 0.22306084632873535 0.49184861779212952 -0.84162294864654541 0 -0.027175687253475189 0.86617815494537354 0.49899625778198242 0
		 5.942772388458252 96.804183959960938 -40.895599365234375 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324440479278564 -4.5016292915533995e-008 -0.48728227615356445 0
		 -4.5016292915533995e-008 0.99999988079071045 -1.7305477229001553e-007 0 0.48728227615356445 1.7305477229001553e-007 0.87324440479278564 0
		 22.594865798950195 9.7713375091552734 -18.808773040771484 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841275215148926 -2.2288647016921459e-007 0.52933573722839355 0
		 3.7877725844737142e-007 1.0000002384185791 -1.8603104479097965e-007 0 -0.52933573722839355 3.5833136280416511e-007 0.84841275215148926 0
		 -21.121191024780273 9.7385187149047852 -31.56817626953125 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.69234627485275269 -0.7215656042098999 0.00027950108051300049 0
		 0.62194252014160156 0.59656089544296265 -0.50725042819976807 0 0.36584764719009399 0.35136666893959045 0.86179888248443604 0
		 28.278650283813477 91.344993591308594 -35.473526000976563 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.42446506023406982 0.81001543998718262 0.40460464358329773 0
		 -0.71893036365509033 0.57315552234649658 -0.39323318004608154 0 -0.550426185131073 -0.12396883964538574 0.82562899589538574 0
		 -16.450037002563477 93.601974487304688 -45.668132781982422 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.81877774000167847 -0.56840193271636963 0.080763965845108032 0
		 0.18471121788024902 0.12761250138282776 -0.9744727611541748 0 0.54358565807342529 0.81279432773590088 0.20947645604610443 0
		 11.638580322265625 105.6041259765625 -52.076473236083984 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99770015478134155 0.020408779382705688 -0.064637869596481323 0
		 -0.031375017017126083 0.98433655500411987 -0.17348577082157135 0 0.060084782540798187 0.17511476576328278 0.98271298408508301 0
		 29.355646133422852 46.871067047119141 -19.325679779052734 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.9641607403755188 -0.2648741602897644 -0.015353009104728699 0
		 0.26488268375396729 0.9642794132232666 -0.0015140498289838433 0 0.015205623582005501 -0.0026069586165249348 0.99988096952438354 0
		 -19.923864364624023 39.976333618164063 -21.144004821777344 1;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "AC82B6AA-406E-AD36-FBC1-9B870D78ED72";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.98969310522079468 0.13846932351589203 0.036518022418022156 0
		 -0.14320378005504608 0.95697295665740967 0.25237908959388733 0 0 -0.25500741600990295 0.96693903207778931 0
		 4.7158908843994141 43.423698425292969 -20.234842300415039 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.86759412288665771 -0.16824030876159668 -0.46794906258583069 0
		 0.084987737238407135 0.97735059261322021 -0.19381356239318848 0 0.48995736241340637 0.12838152050971985 0.86224168539047241 0
		 24.316305160522461 16.415872573852539 -19.212003707885742 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.83866745233535767 -0.18729102611541748 0.5114288330078125 0
		 0.15527567267417908 0.98226600885391235 0.10508781671524048 0 -0.52204108238220215 -0.0087212547659873962 0.85287606716156006 0
		 -21.255355834960937 16.431804656982422 -30.000391006469727 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.26508313417434692 0.13297706842422485 0.95501226186752319 0
		 0.87455278635025024 0.38394880294799805 -0.29621133208274841 0 -0.40606492757797241 0.91372907161712646 -0.014517068862915039 0
		 47.328193664550781 83.407318115234375 -15.241603851318359 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.46741598844528198 0.88171684741973877 -0.064012318849563599 0
		 0.39311274886131287 0.1424483060836792 -0.90838915109634399 0 -0.7918236255645752 -0.44975966215133667 -0.41319677233695984 0
		 -40.198043823242187 58.765548706054688 -46.370632171630859 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99906879663467407 -0.0021993506234139204 -0.043092574924230576 0
		 -0.0035511942114681005 0.99112099409103394 -0.13291639089584351 0 0.043002281337976456 0.13294562697410583 0.99019014835357666 0
		 28.717580795288086 28.144168853759766 -9.3533391952514648 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98964041471481323 -0.11898772418498993 -0.080340608954429626 0
		 0.14312757551670074 0.86160796880722046 0.48697733879089355 0 0.011277768760919571 -0.4934312105178833 0.86971217393875122 0
		 -23.557300567626953 20.094812393188477 -14.657567977905273 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" 0.12007302045822144 0.40805813670158386 0.90502560138702393 0
		 0.76710200309753418 0.54054439067840576 -0.34549480676651001 0 -0.6301882266998291 0.73573142290115356 -0.2481173574924469 0
		 44.644821166992188 74.288116455078125 -35.4669189453125 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.61181420087814331 0.69628441333770752 -0.37532839179039001 0
		 -0.7851414680480957 0.47691282629966736 -0.39510393142700195 0 -0.096105754375457764 0.53641605377197266 0.83846378326416016 0
		 -26.307666778564453 74.133270263671875 -54.755958557128906 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.99463605880737305 0.095200315117835999 0.040446605533361435 0
		 -0.097856521606445313 0.99275308847427368 0.069751575589179993 0 -0.033513125032186508 -0.073335394263267517 0.99674403667449951 0
		 3.1244142055511475 55.838787078857422 -24.179906845092773 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.97442591190338135 -0.088434807956218719 0.20657673478126526 0
		 0.22306084632873535 0.49184861779212952 -0.84162294864654541 0 -0.027175687253475189 0.86617815494537354 0.49899625778198242 0
		 5.942772388458252 96.804183959960938 -40.895599365234375 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324440479278564 -4.5016292915533995e-008 -0.48728227615356445 0
		 -4.5016292915533995e-008 0.99999988079071045 -1.7305477229001553e-007 0 0.48728227615356445 1.7305477229001553e-007 0.87324440479278564 0
		 22.594865798950195 9.7713375091552734 -18.808773040771484 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841275215148926 -2.2288647016921459e-007 0.52933573722839355 0
		 3.7877725844737142e-007 1.0000002384185791 -1.8603104479097965e-007 0 -0.52933573722839355 3.5833136280416511e-007 0.84841275215148926 0
		 -21.121191024780273 9.7385187149047852 -31.56817626953125 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.69234627485275269 -0.7215656042098999 0.00027950108051300049 0
		 0.62194252014160156 0.59656089544296265 -0.50725042819976807 0 0.36584764719009399 0.35136666893959045 0.86179888248443604 0
		 28.278650283813477 91.344993591308594 -35.473526000976563 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.42446506023406982 0.81001543998718262 0.40460464358329773 0
		 -0.71893036365509033 0.57315552234649658 -0.39323318004608154 0 -0.550426185131073 -0.12396883964538574 0.82562899589538574 0
		 -16.450037002563477 93.601974487304688 -45.668132781982422 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.81877774000167847 -0.56840193271636963 0.080763965845108032 0
		 0.18471121788024902 0.12761250138282776 -0.9744727611541748 0 0.54358565807342529 0.81279432773590088 0.20947645604610443 0
		 11.638580322265625 105.6041259765625 -52.076473236083984 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99770015478134155 0.020408779382705688 -0.064637869596481323 0
		 -0.031375017017126083 0.98433655500411987 -0.17348577082157135 0 0.060084782540798187 0.17511476576328278 0.98271298408508301 0
		 29.355646133422852 46.871067047119141 -19.325679779052734 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.9641607403755188 -0.2648741602897644 -0.015353009104728699 0
		 0.26488268375396729 0.9642794132232666 -0.0015140498289838433 0 0.015205623582005501 -0.0026069586165249348 0.99988096952438354 0
		 -19.923864364624023 39.976333618164063 -21.144004821777344 1;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "213EBB31-4DFC-BC0D-31AC-E3AFE69C4708";
	setAttr ".ihi" 0;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "6A2A71A7-450C-318F-5A36-37A6510EC9B8";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 3.3306690738754696e-016 -0.2550075714631152 0.96693905624733367 0
		 0.98969323511599439 0.13846925279768463 0.036518028359811328 0 -0.1432037023461234 0.95697304273743011 0.25237926838040359 0
		 3.5347108218415824 56.084833144491164 -19.022941972794783 1;
	setAttr ".LeftUpLegGX" -type "matrix" -0.10523715038232326 -0.81597036170361914 0.56843451850056048 0
		 0.98856288845568752 -0.14793032207507351 -0.029331816617535589 0 0.10802258838990116 0.55884644153899021 0.82220573734908653 0
		 25.05309393390927 47.395599873939332 -17.222949409035515 1;
	setAttr ".LeftLegGX" -type "matrix" -0.08898053388107921 -0.41509653366255539 -0.90541578174818982 0
		 0.98856286734281673 -0.14793031891570568 -0.029331815991092029 0 -0.12176289392983591 -0.89767025377862664 0.42351184008346032 0
		 22.46301287173053 27.313058932174442 -3.2327237510031654 1;
	setAttr ".LeftFootGX" -type "matrix" 0.19385179983007023 -0.90389762342899216 0.38130153993122967 0
		 0.87973969940763452 -0.01183403890523832 -0.47530858819170296 0 0.43414254242072275 0.4275855029261717 0.79290045969214273 0
		 20.992110439159109 20.451260444569655 -18.199798679163479 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.0099920335631869112 0.9552560431719247 -0.29561180976253076 0
		 0.99992513855334453 -0.0074507518486251201 0.0097219046080550264 0 0.0070843759280342505 -0.29568673954693431 -0.95525871494379511 0
		 -17.983672290226142 47.395599873939332 -17.222949409035515 1;
	setAttr ".RightLegGX" -type "matrix" -0.0082215984214977431 0.18007155479315973 0.98361913596466188 0
		 0.99992511719780897 -0.0074507516894984117 0.0097219044004230037 0 0.0090793411734438542 0.98362546477718471 -0.17999685260599435 0
		 -18.229594731214327 23.884980497010741 -9.9473956008917455 1;
	setAttr ".RightFootGX" -type "matrix" 0.35760789974878371 0.92971853212454836 -0.087979053999411541 0
		 0.83174072735405291 -0.27424402407454246 0.48269843742695384 0 0.42464597760961309 -0.24579248374502916 -0.8713563823357493 0
		 -18.093686669622457 20.908287036712554 -26.207223072240179 1;
	setAttr ".SpineGX" -type "matrix" -0.11866400440033839 0.98295029623446639 -0.14045488078817242 0
		 0.98808623416773123 0.13085872650004993 0.081003626752241528 0 0.098002285742838618 -0.1291693195070916 -0.98676787707759428 0
		 3.5347108218415819 69.826448955871058 -17.632107668600906 1;
	setAttr ".LeftArmGX" -type "matrix" 0.75596555108580321 -0.65372394147880641 0.034083494594462499 0
		 -0.64676634932902188 -0.73785529443781206 0.1930367629512808 0 -0.10104416882841144 -0.16797305339828439 -0.98059942104994247 0
		 22.685514262330187 109.41323165053896 -17.509121246921158 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.039300605359475924 0.22052214483525906 0.9745900457280009 0
		 -0.64676633220543744 -0.73785527490258507 0.19303675784049959 0 0.76167530519874882 -0.63791842112769648 0.11362824344122241 0
		 49.403869664754879 86.308437028099618 -16.304501051840582 1;
	setAttr ".LeftHandGX" -type "matrix" 0.30467934266192898 0.29050573256650541 0.90707078930746743 0
		 -0.83100114616398413 -0.38428100192480552 0.40220084715846638 0 0.46541178071035438 -0.87631897386723345 0.12432818526365037 0
		 50.448795750897766 92.171708441177358 9.6080167918153414 1;
	setAttr ".RightArmGX" -type "matrix" 0.32345730049766624 0.82312604821982593 0.46673265508865297 0
		 -0.83814688338706322 0.47816408012642925 -0.26243003594967068 0 -0.43918767500895428 -0.30630563948169864 0.84456582924461721 0
		 -22.069924254531863 106.31332711498118 -30.613368397741677 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.54306654810967037 0.68667213222027035 -0.48328139610587839 0
		 -0.83814696006698786 0.47816412387244367 -0.26243005995872659 0 0.050884518644861321 0.54757756176685302 0.83520661321301792 0
		 -33.501986476567893 77.221294244921907 -47.10926899785018 1;
	setAttr ".RightHandGX" -type "matrix" -0.30505289523425932 0.94691392172564592 -0.10147713267226255 0
		 0.39771869583785563 0.029853389993404145 -0.91702195476060344 0 -0.86531126812121373 -0.32009947186855181 -0.38571206110463307 0
		 -47.941102024700314 58.963978963324656 -34.259724878203784 1;
	setAttr ".HeadGX" -type "matrix" 0.49859360742351283 0.85132108591928557 0.16327037884624773 0
		 0.8364692841027358 -0.52193287269505684 0.16704981560235571 0 0.22742911417795031 0.053280792800941834 -0.97233602078891623 0
		 7.3180883347259744 130.73381178228615 -34.517480989127364 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.48728228791782857 3.3663182796850322e-009 0.87324463770581429 0
		 0.87324462668389091 -5.3317800261659665e-010 -0.48728232069383459 0 1.1747530725969568e-009 1.0000001602149959 3.1994304428017983e-009 0
		 24.423219533113684 4.4526006776580882 -11.450896642796367 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.52933574239081216 7.0454611589276794e-009 -0.84841252130292266 0
		 0.84841259162613547 -3.6683103697005004e-008 0.52933565359865375 0 -5.4183085518300089e-009 -1.0000001393909761 4.3999975524178225e-008 0
		 -24.423219533113645 4.4526006776580829 -24.650025271457093 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.84821506056894702 -0.00011340673791823686 0.5296523903441559 0
		 0.47625574720477337 -0.43740430570312949 -0.76279618110793335 0 0.23175873192547886 0.89926512374534218 -0.3709588725461927 0
		 4.2745592280968641 109.41569330653414 -29.005505649646139 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.99240882933379837 0.12204105588568796 0.015203785406989911 0
		 -0.073773988873540974 0.49183334183636457 0.86755831866373734 0 0.098400012737250589 -0.8620941059743632 0.49710315689622142 0
		 -0.52916746034498874 108.96229262483048 -30.283362141970162 1;
	setAttr ".NeckGX" -type "matrix" 0.34233924729455345 0.89539268877046618 -0.28473880979422445 0
		 0.89903057039358325 -0.22409755598628417 0.37619780722601048 0 0.27303538936608523 -0.38477600771016512 -0.88170245256566704 0
		 1.5682843473247281 115.69512512061451 -29.73511269121051 1;
	setAttr ".Spine1GX" -type "matrix" 0.07871897322600982 0.90365827054489534 -0.42095778666519873 0
		 0.95965903717591139 0.045643563048251387 0.27743769490908171 0 0.26992277569464618 -0.42581538988119771 -0.86361047700100191 0
		 0.071558291119653283 98.513385851189241 -21.731216562758732 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "7B874CBC-41C4-07DA-0996-2BA9ECCF6589";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotateX";
	rename -uid "CD3C9AD3-4BD0-1638-8DB0-E29F25AD02F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.6027367541153055e-008 1 5.6027367541153055e-008
		 2 5.6027367541153055e-008 3 5.6027367541153055e-008 4 5.6027367541153055e-008 5 5.6027367541153055e-008
		 6 5.6027367541153055e-008 7 5.6027367541153055e-008 8 5.6027367541153055e-008 9 5.6027367541153055e-008
		 10 5.6027367541153055e-008 11 5.6027367541153055e-008 12 5.6027367541153055e-008
		 13 5.6027367541153055e-008 14 5.6027367541153055e-008 15 5.6027367541153055e-008
		 16 5.6027367541153055e-008 17 5.6027367541153055e-008 18 5.6027367541153055e-008
		 19 5.6027367541153055e-008 20 5.6027367541153055e-008 21 5.6027367541153055e-008
		 22 5.6027367541153055e-008 23 5.6027367541153055e-008 24 5.6027367541153055e-008
		 25 5.6027367541153055e-008 26 5.6027367541153055e-008 27 5.6027367541153055e-008
		 28 5.6027367541153055e-008 29 5.6027367541153055e-008 30 5.6027367541153055e-008
		 31 5.6027367541153055e-008 32 5.6027367541153055e-008;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotateY";
	rename -uid "158E558D-4460-4C94-BE65-3796E94B80D2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 8.2332764381707122 1 8.2332764381707122
		 2 8.2332764381707122 3 8.2332764381707122 4 8.2332764381707122 5 8.2332764381707122
		 6 8.2332764381707122 7 8.2332764381707122 8 8.2332764381707122 9 8.2332764381707122
		 10 8.2332764381707122 11 8.2332764381707122 12 8.2332764381707122 13 8.2332764381707122
		 14 8.2332764381707122 15 8.2332764381707122 16 8.2332764381707122 17 8.2332764381707122
		 18 8.2332764381707122 19 8.2332764381707122 20 8.2332764381707122 21 8.2332764381707122
		 22 8.2332764381707122 23 8.2332764381707122 24 8.2332764381707122 25 8.2332764381707122
		 26 8.2332764381707122 27 8.2332764381707122 28 8.2332764381707122 29 8.2332764381707122
		 30 8.2332764381707122 31 8.2332764381707122 32 8.2332764381707122;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotateZ";
	rename -uid "84540F91-465B-C949-F9CD-82A87B4B8B87";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 14.774023390282307 1 14.774023390282307
		 2 14.774023390282307 3 14.774023390282307 4 14.774023390282307 5 14.774023390282307
		 6 14.774023390282307 7 14.774023390282307 8 14.774023390282307 9 14.774023390282307
		 10 14.774023390282307 11 14.774023390282307 12 14.774023390282307 13 14.774023390282307
		 14 14.774023390282307 15 14.774023390282307 16 14.774023390282307 17 14.774023390282307
		 18 14.774023390282307 19 14.774023390282307 20 14.774023390282307 21 14.774023390282307
		 22 14.774023390282307 23 14.774023390282307 24 14.774023390282307 25 14.774023390282307
		 26 14.774023390282307 27 14.774023390282307 28 14.774023390282307 29 14.774023390282307
		 30 14.774023390282307 31 14.774023390282307 32 14.774023390282307;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX";
	rename -uid "E89A7ED7-4053-67B2-0ED4-B8B69065173B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 4.9391822814941406 1 4.8954272270202637
		 2 4.7722034454345703 3 4.581489086151123 4 4.3352947235107422 5 4.0456118583679199
		 6 3.7244372367858887 7 3.3837473392486572 8 3.0354819297790527 9 2.6915552616119385
		 10 2.3638327121734619 11 2.0641500949859619 12 1.8043234348297119 13 1.5961458683013916
		 14 1.4514029026031494 15 1.3818838596343994 16 1.3993829488754272 17 1.4961569309234619
		 18 1.6506723165512085 19 1.8541109561920166 20 2.0976462364196777 21 2.3724749088287354
		 22 2.6697885990142822 23 2.9808065891265869 24 3.2967474460601807 25 3.6088087558746338
		 26 3.9081594944000244 27 4.185941219329834 28 4.4332618713378906 29 4.6411972045898437
		 30 4.8007979393005371 31 4.9031124114990234 32 4.9391822814941406;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY";
	rename -uid "D1D62F2D-4F32-CDB5-1039-F282255381AA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 51.725685119628906 1 51.729164123535156
		 2 51.730155944824219 3 51.728797912597656 4 51.725257873535156 5 51.719673156738281
		 6 51.712150573730469 7 51.702560424804688 8 51.691169738769531 9 51.678642272949219
		 10 51.665580749511719 11 51.652488708496094 12 51.639801025390625 13 51.627906799316406
		 14 51.61712646484375 15 51.607795715332031 16 51.600265502929688 17 51.594711303710938
		 18 51.5911865234375 19 51.589927673339844 20 51.591148376464844 21 51.595100402832031
		 22 51.601974487304688 23 51.611549377441406 24 51.623382568359375 25 51.636962890625
		 26 51.6517333984375 27 51.66705322265625 28 51.682212829589844 29 51.696464538574219
		 30 51.709007263183594 31 51.719009399414062 32 51.725685119628906;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ";
	rename -uid "A04D0205-4AC6-93A8-3F24-32AB537CD39B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -20.283411026000977 1 -20.186851501464844
		 2 -20.092958450317383 3 -20.008548736572266 4 -19.940404891967773 5 -19.895317077636719
		 6 -19.88006591796875 7 -19.905332565307617 8 -19.972829818725586 9 -20.075912475585938
		 10 -20.207984924316406 11 -20.362497329711914 12 -20.532938003540039 13 -20.712833404541016
		 14 -20.895742416381836 15 -21.075223922729492 16 -21.244836807250977 17 -21.398096084594727
		 18 -21.528514862060547 19 -21.629583358764648 20 -21.694786071777344 21 -21.71759033203125
		 22 -21.691741943359375 23 -21.620685577392578 24 -21.512462615966797 25 -21.375131607055664
		 26 -21.216785430908203 27 -21.045557022094727 28 -20.869613647460937 29 -20.697172164916992
		 30 -20.536481857299805 31 -20.395801544189453 32 -20.283411026000977;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotateX";
	rename -uid "9D702701-41EC-C2D5-C1DA-21B9510080A4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -7.2580264662468199 1 -7.1992950161692537
		 2 -7.0785832209013044 3 -6.9072573948474458 4 -6.6964669193218915 5 -6.4571100191366266
		 6 -6.1997882448469914 7 -5.935701389000128 8 -5.6737792282744852 9 -5.4211829138419327
		 10 -5.1854545462369188 11 -4.9743940965531355 12 -4.7962091412382986 13 -4.6594924442463279
		 14 -4.5730550024225511 15 -4.5460958809591352 16 -4.5882607876073935 17 -4.6927996953737523
		 18 -4.8420044495428352 19 -5.0276053598121404 20 -5.241229259383732 21 -5.4740876738821544
		 22 -5.7168721278260071 23 -5.9619621536895453 24 -6.2025153448738299 25 -6.432003455028914
		 26 -6.6441795417099927 27 -6.8332429989991246 28 -6.9937829495242543 29 -7.1209582295897045
		 30 -7.2101978634352299 31 -7.2572786368485103 32 -7.2580264662468199;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotateY";
	rename -uid "BE70B4E3-4169-9543-1D01-52A394B8B22D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.2921325533576509 1 5.2594294199424416
		 2 5.1383081160037758 3 4.9412422572856771 4 4.6809486332316244 5 4.3699620842204832
		 6 4.0213137192308581 7 3.6469474643344806 8 3.2604795843175687 9 2.8762537587433612
		 10 2.5083002834642159 11 2.1701605277377327 12 1.8748139172273277 13 1.6348733972634037
		 14 1.4627124443368595 15 1.3704241924899478 16 1.3701116415984063 17 1.454029390120432
		 18 1.6002326763549861 19 1.800569693822053 20 2.0468866035612527 21 2.3312831592695118
		 22 2.6460857309811403 23 2.9825386356446493 24 3.3311563835175879 25 3.6822097047730695
		 26 4.0253339924329392 27 4.3499367285965693 28 4.6448940858298968 29 4.8984580443195913
		 30 5.0989030822035222 31 5.2341352889617019 32 5.2921325533576509;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotateZ";
	rename -uid "FEC62B7A-4B1F-94AF-008F-709D133B2CA3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -23.942307524977601 1 -23.839251567500295
		 2 -23.747412710447968 3 -23.67149859666744 4 -23.61667649058402 5 -23.588047294442106
		 6 -23.591078857220765 7 -23.636359888131953 8 -23.724695123619806 9 -23.847700046172207
		 10 -23.997683507765462 11 -24.167524735809732 12 -24.351079344224818 13 -24.542680414266272
		 14 -24.736872191176928 15 -24.928672405383924 16 -25.112398513966991 17 -25.280899750414189
		 18 -25.425710635410169 19 -25.538656120747646 20 -25.612190009949948 21 -25.638540821792656
		 22 -25.610137892020614 23 -25.529886305808191 24 -25.4055202993822 25 -25.245276978101067
		 26 -25.057954204543655 27 -24.853177645598521 28 -24.64100416657546 29 -24.432517198197747
		 30 -24.238831448173652 31 -24.071610411007349 32 -23.942307524977601;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotateX";
	rename -uid "0257B286-4726-7BAC-7FD3-E7AFAF5BECA2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.1431729681148846 1 1.1238667648381275
		 2 1.0934555765311575 3 1.0551560601243102 4 1.0123733496011977 5 0.96861469322743943
		 6 0.92688436652409978 7 0.89070011812846517 8 0.8620171680529285 9 0.84168403971848671
		 10 0.8299393872580213 11 0.82671154348663634 12 0.83158849299969828 13 0.84368573042660966
		 14 0.86196684302091453 15 0.88530209229725998 16 0.91300315017275924 17 0.94322051563662113
		 18 0.97422514203938038 19 1.0046009434154854 20 1.0331750911317954 21 1.0587846866312578
		 22 1.0800736033974427 23 1.0974515264218812 24 1.1120010456988791 25 1.1243600498409938
		 26 1.1351168480378395 27 1.1441984932119862 28 1.1511973674719524 29 1.1556171524004677
		 30 1.1564086226161976 31 1.1526044863577991 32 1.1431729681148846;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotateY";
	rename -uid "1245469D-4C04-225B-C60D-DFB2A058FD23";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 0.1967371477525019 1 0.19954305422403748
		 2 0.20377536541925459 3 0.20901024833672169 4 0.21445538145936241 5 0.21993997632494955
		 6 0.22462853500796218 7 0.22825950859278107 8 0.23036674156099957 9 0.23101114199787678
		 10 0.23006449446606866 11 0.22782016499004684 12 0.22444054101291441 13 0.22029328092399125
		 14 0.21568607433680836 15 0.21098491188970125 16 0.20648631238203335 17 0.20235026887970523
		 18 0.19863637250952865 19 0.19553887749665061 20 0.19308513133957397 21 0.19136210124191744
		 22 0.19053470011879778 23 0.19034296522756464 24 0.19056480358498273 25 0.19092229690206414
		 26 0.1914857836113307 27 0.19190706543008443 28 0.19236654307445941 29 0.1929885162312891
		 30 0.19378753760455125 31 0.19501559421208395 32 0.1967371477525019;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotateZ";
	rename -uid "F27B60CA-4F67-C909-DF2D-D4A34EE47B7B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 2.8949257719525727 1 2.958882963642838
		 2 3.0568331111797495 3 3.1752971022090626 4 3.3018967654518856 5 3.4236545004416308
		 6 3.528945609406164 7 3.6062053109440892 8 3.6491888346695678 9 3.6569966398174265
		 10 3.6302815796695169 11 3.5725720589072298 12 3.4901859810670057 13 3.39072443251399
		 14 3.2825865972673007 15 3.175317081658819 16 3.0764898629208552 17 2.9900087930603019
		 18 2.9163660888959497 19 2.8563994034761708 20 2.8119080609834115 21 2.7843774000841393
		 22 2.7749422519354248 23 2.7792076240921282 24 2.7901799451560332 25 2.8024381581347644
		 26 2.8126828218850051 27 2.8197336805357853 28 2.8243071321647792 29 2.8296926119412849
		 30 2.8398941632076511 31 2.8601058516373254 32 2.8949257719525727;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotateX";
	rename -uid "89DF2765-4273-C9D3-C9F3-79AA66BAE037";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -25.426150430147548 1 -25.457574052104743
		 2 -25.505005478541069 3 -25.564344797505779 4 -25.632440339990445 5 -25.705973088774204
		 6 -25.782290401248428 7 -25.857684739501444 8 -25.930518219974783 9 -26.0002133224502
		 10 -26.06540545247768 11 -26.123819546379245 12 -26.172714458299446 13 -26.208346750653831
		 14 -26.226659793410764 15 -26.223329523535174 16 -26.193926402105252 17 -26.141051493018846
		 18 -26.072167842442461 19 -25.991493927370662 20 -25.903641017698437 21 -25.813674299280581
		 22 -25.726728339438196 23 -25.646435513002253 24 -25.575325234029478 25 -25.515196953533131
		 26 -25.467134102956763 27 -25.431909412253635 28 -25.409222425033782 29 -25.398396220765417
		 30 -25.398438886581904 31 -25.408062102005786 32 -25.426150430147548;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotateY";
	rename -uid "459244F8-4DE3-1AEF-F7B0-5399D3591722";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 10.00947428342171 1 10.003420197949877
		 2 9.9864272341996774 3 9.9603661769479626 4 9.9268424283321703 5 9.8874082092713689
		 6 9.8438137022486512 7 9.797532486384215 8 9.7502294175250022 9 9.7034205910511222
		 10 9.6589563535883354 11 9.6183731198352742 12 9.5832908579484428 13 9.5553093680713932
		 14 9.5361220654713552 15 9.5272563263738892 16 9.5301387198167475 17 9.5438898850347105
		 18 9.5654335927394154 19 9.593627882806862 20 9.6271656170696236 21 9.6646881787669923
		 22 9.7050381968534705 23 9.7470147474897999 24 9.7894518207833237 25 9.8313235452303918
		 26 9.8713588084766482 27 9.9085738069482794 28 9.9417557577553684 29 9.9696138512937971
		 30 9.9910568940660731 31 10.004746358591866 32 10.00947428342171;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotateZ";
	rename -uid "63251C2F-431E-BD90-9FD1-27836F9630E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -6.3140844892364738 1 -6.3454449158111537
		 2 -6.4011334515081186 3 -6.473019678432208 4 -6.5537330212142146 5 -6.6354308383698033
		 6 -6.7114621525248559 7 -6.7753326711476287 8 -6.8231167690601842 9 -6.8532155700504651
		 10 -6.8647501686206631 11 -6.8587853492738482 12 -6.8380051727523057 13 -6.8057572549861467
		 14 -6.7658992718934234 15 -6.7229918436986678 16 -6.680345104196828 17 -6.6399215497302482
		 18 -6.6020152442120725 19 -6.56697954097557 20 -6.5355255095330138 21 -6.5083818490878276
		 22 -6.4861640381801484 23 -6.4670485617205866 24 -6.4480891140281287 25 -6.4272623738569328
		 26 -6.4037816207726292 27 -6.3782054415789808 28 -6.352202748695337 29 -6.3288449956804049
		 30 -6.3118997787423856 31 -6.305648243724197 32 -6.3140844892364738;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotateX";
	rename -uid "13FA742B-4010-8A0F-FCC7-FC9AECD9D139";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -11.847496082142545 1 -11.761313231365445
		 2 -11.626920545322909 3 -11.456336523603191 4 -11.260329087660073 5 -11.049362406049029
		 6 -10.833149163528862 7 -10.62306133974282 8 -10.425563962900668 9 -10.242919715180667
		 10 -10.078500511345268 11 -9.9373608908493463 12 -9.8252442324557023 13 -9.7493164081826293
		 14 -9.7176794995330518 15 -9.7389106735005129 16 -9.8223080541117547 17 -9.9609406788115589
		 18 -10.136481050127932 19 -10.339222169632448 20 -10.558882288806805 21 -10.783992987782927
		 22 -11.002974621549674 23 -11.207576727884158 24 -11.392678547922406 25 -11.553433865344131
		 26 -11.686432150493124 27 -11.78920939469994 28 -11.860637236181322 29 -11.90097098329098
		 30 -11.911173887625766 31 -11.892704857356987 32 -11.847496082142545;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotateY";
	rename -uid "9C73B017-4726-7EEC-A186-2EA2DAACC8BB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 23.164182499076453 1 23.12301946516757
		 2 22.968152615573675 3 22.714503479862003 4 22.377371466361556 5 21.972192235746537
		 6 21.514728278405492 7 21.020440965023223 8 20.506630925747928 9 19.992196728754312
		 10 19.496206731662117 11 19.03697929164391 12 18.633207213776739 13 18.302977934887394
		 14 18.064192883936308 15 17.934528015863691 16 17.931234465978637 17 18.043690172437984
		 18 18.241643371915618 19 18.513461436041133 20 18.847538402851217 21 19.232970437369428
		 22 19.658673841086859 23 20.112366588725362 24 20.580444467264925 25 21.049357340780567
		 26 21.505219213656648 27 21.933880256146999 28 22.32116506890263 29 22.652375652956795
		 30 22.913082647371983 31 23.088602062318181 32 23.164182499076453;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotateZ";
	rename -uid "318C24FC-4A5C-4779-36B6-4381090C7EE3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -14.428889544789026 1 -14.232858237784079
		 2 -14.038836911642667 3 -13.860621320847711 4 -13.711807525068323 5 -13.605764237549003
		 6 -13.555776876176781 7 -13.582906356960029 8 -13.690435846895214 9 -13.865416867668346
		 10 -14.095445432328246 11 -14.368713966225739 12 -14.674206649856171 13 -15.00121318359151
		 14 -15.339470517702397 15 -15.678926691654157 16 -16.009539045855323 17 -16.318311667481225
		 18 -16.590253087804321 19 -16.811634368813195 20 -16.968309241782475 21 -17.046041905071892
		 22 -17.030672700998931 23 -16.9268716228583 24 -16.748307257586887 25 -16.508943711577526
		 26 -16.223355277043368 27 -15.906601447249574 28 -15.574416709783868 29 -15.243419212514118
		 30 -14.930528013744215 31 -14.653195223762475 32 -14.428889544789026;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotateX";
	rename -uid "F3B444FB-4593-6916-0CD0-789ED08D2FCB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -2.5474125161147203 1 -2.5561585561680888
		 2 -2.5431341303502948 3 -2.5105048626187174 4 -2.460783155767253 5 -2.3962716069427978
		 6 -2.3192273547324653 7 -2.2307814253473532 8 -2.1338294005259337 9 -2.0327329388636803
		 10 -1.9318639510013325 11 -1.8347051623282196 12 -1.744928229293736 13 -1.6656516024006929
		 14 -1.5998964609475104 15 -1.550823436223242 16 -1.521392774382565 17 -1.5115079711014852
		 18 -1.5182206710471349 19 -1.5413765308668104 20 -1.5805074147233005 21 -1.6355988960688685
		 22 -1.70591778993692 23 -1.7894851809163668 24 -1.8832182741262311 25 -1.9838452966533433
		 26 -2.0878721680443766 27 -2.1914066378647612 28 -2.2904443358341631 29 -2.3802360623407544
		 30 -2.4562422167201472 31 -2.5136246542113039 32 -2.5474125161147203;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotateY";
	rename -uid "F27E920A-4D44-DC97-77CF-92B56838ED75";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -0.016237210919348308 1 -0.015451678151991567
		 2 -0.015945352652382165 3 -0.017727250424194377 4 -0.020628184008362062 5 -0.024699003629111226
		 6 -0.029897191094515815 7 -0.036370517385067636 8 -0.04408659364454709 9 -0.05269562846129773
		 10 -0.061906633517703376 11 -0.071380805385527477 12 -0.080665749046376328 13 -0.089357205407981047
		 14 -0.097029792760155734 15 -0.10319662129162345 16 -0.10753688000425218 17 -0.1097829806979783
		 18 -0.11011780301095041 19 -0.10851388348193201 20 -0.10493855421268034 21 -0.099429094865813888
		 22 -0.092132105162350708 23 -0.083390444761409388 24 -0.073753770269308211 25 -0.063691517903769285
		 26 -0.053738843296778131 27 -0.044308003533238084 28 -0.035839374153266892 29 -0.028592118677487514
		 30 -0.022837233336555907 31 -0.018668180173402157 32 -0.016237210919348308;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotateZ";
	rename -uid "8A3E519A-404D-2320-12E8-C1A57AE14452";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 27.73555938445616 1 27.674388210519147
		 2 27.703378323710211 3 27.81381293343118 4 27.996099320322951 5 28.240890590421444
		 6 28.540219074519321 7 28.891523764299276 8 29.283312026025889 9 29.695980061876863
		 10 30.111493215196962 11 30.514711781877352 12 30.891949939024116 13 31.231504449764302
		 14 31.522681442780794 15 31.754895123681976 16 31.91634889848288 17 32.005999110499758
		 18 32.029955637843884 19 31.985774540215846 20 31.87099209428991 21 31.683504010345526
		 22 31.421042405277596 23 31.091432097154172 24 30.707400976299638 25 30.282858514122566
		 26 29.833989897825045 27 29.378022569448234 28 28.935263583209714 29 28.526513320027192
		 30 28.174789630628677 31 27.90349704227301 32 27.73555938445616;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotateX";
	rename -uid "91158AC7-48D6-5396-226D-A88B9517158A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 33.847548300219863 1 33.828015111375741
		 2 33.790489906450247 3 33.739407188998818 4 33.67887671092064 5 33.612694532231821
		 6 33.544169737407927 7 33.475998556436316 8 33.409974106399687 9 33.346960854809602
		 10 33.287783104058938 11 33.233793882277062 12 33.186271424390249 13 33.147108483261633
		 14 33.118665003135263 15 33.103693444948838 16 33.105748571821259 17 33.124383588051522
		 18 33.156397259371737 19 33.200591297369435 20 33.255574360290353 21 33.319192592694485
		 22 33.389056244374665 23 33.461909634507208 24 33.535015010427152 25 33.605375487042359
		 26 33.670485745605717 27 33.727954006113286 28 33.775993244887708 29 33.813044326676582
		 30 33.837928782209822 31 33.849620566292913 32 33.847548300219863;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotateY";
	rename -uid "AEF0E32F-4ECC-A96E-7976-689CE6A28FB7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -4.886858920058196 1 -4.884255209841502
		 2 -4.8701373695044374 3 -4.8460626022660316 4 -4.8134884755881959 5 -4.773930087139294
		 6 -4.7287293814093294 7 -4.6792912210666868 8 -4.6273615434310926 9 -4.5750040401102643
		 10 -4.5242008250927057 11 -4.4769964873819399 12 -4.4353129072849695 13 -4.4009590387263469
		 14 -4.3757510213281412 15 -4.361270908870436 16 -4.3594131642033807 17 -4.3689121142034493
		 18 -4.3871233253369279 19 -4.4128376498037376 20 -4.4450694703546487 21 -4.4824298853005127
		 22 -4.5242808546536519 23 -4.5692254426815522 24 -4.616003230434031 25 -4.6633757711664678
		 26 -4.7098777525219351 27 -4.7541843669669754 28 -4.7945825508809436 29 -4.8298197723754503
		 30 -4.8580609995272814 31 -4.8775737625282085 32 -4.886858920058196;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotateZ";
	rename -uid "2563A0F1-4367-7FAA-24A3-318B64B33325";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -25.911767733829308 1 -25.880102192897802
		 2 -25.916455984821177 3 -26.013594056320578 4 -26.163385794943519 5 -26.358013869601272
		 6 -26.59071894732687 7 -26.858016839639479 8 -27.150878285620198 9 -27.455238317851236
		 10 -27.757919169857388 11 -28.048129331244713 12 -28.315641265431925 13 -28.55207561585755
		 14 -28.749702262943458 15 -28.900894588430116 16 -28.99722256953174 17 -29.039230120437558
		 18 -29.033180889210158 19 -28.978604545161307 20 -28.875069384406402 21 -28.722476107711746
		 22 -28.520506939795808 23 -28.274847759177604 24 -27.994257530461596 25 -27.688222183961052
		 26 -27.367939307151943 27 -27.04520653487435 28 -26.734311960821316 29 -26.449379654146263
		 30 -26.206568414079804 31 -26.022077676876311 32 -25.911767733829308;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotateX";
	rename -uid "39386E24-4D2C-B686-7404-2C98DC6C889B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.7393879449482161 1 2.0476041754075909
		 2 2.2869425810526165 3 2.4345543454090546 4 2.4797933158075911 5 2.4294626365067371
		 6 2.2863062216331014 7 2.0578045347695952 8 1.7594318225458863 9 1.4059030197349514
		 10 1.0122360028950725 11 0.59375105048111254 12 0.16603642813883035 13 -0.25517564082207606
		 14 -0.65409663021991626 15 -1.0149882357278874 16 -1.3222561785048443 17 -1.5615740528222339
		 18 -1.7229510227458584 19 -1.8053265182506684 20 -1.8139108959014767 21 -1.7491331012129583
		 22 -1.6114480306124874 23 -1.4067894029915458 24 -1.1471837192460439 25 -0.8422512686059026
		 26 -0.50172356950695352 27 -0.13540681768856092 28 0.24681257696348485 29 0.63508146905770979
		 30 1.0196472193759842 31 1.3908727104985015 32 1.7393879449482161;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotateY";
	rename -uid "8FD23A32-46C9-11C5-0342-1D9532C2C3D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -4.3701490176836506 1 -4.5493678973529006
		 2 -4.6669915515052942 3 -4.7190228258884597 4 -4.7031618655445762 5 -4.6204573090575805
		 6 -4.4708734102190055 7 -4.2597842775050685 8 -4.0002034476664896 9 -3.704380923546577
		 10 -3.3845248869872373 11 -3.052646002702724 12 -2.7210000607381697 13 -2.4016305219268532
		 14 -2.1066809736555618 15 -1.8480834025074035 16 -1.6380090032872161 17 -1.4864655118235679
		 18 -1.39636836724279 19 -1.3673252084189385 20 -1.3981876892189264 21 -1.4885918110836591
		 22 -1.6380787686452198 23 -1.8407304828985582 24 -2.0844634445137213 25 -2.359874733961131
		 26 -2.6573550152059546 27 -2.9673582311295319 28 -3.2804248691718665 29 -3.5868311696328101
		 30 -3.8769555785334946 31 -4.1412582598886658 32 -4.3701490176836506;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotateZ";
	rename -uid "69B3290A-4663-6302-EF95-15A2B9911D0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -10.521574925170528 1 -10.470585168616354
		 2 -10.427884846336513 3 -10.40237349914338 4 -10.398093189120575 5 -10.412689769611308
		 6 -10.443043914695924 7 -10.484272460541765 8 -10.530278215494732 9 -10.575561372740333
		 10 -10.615525359913654 11 -10.646613744433996 12 -10.667088530025271 13 -10.676581701415749
		 14 -10.676292955559386 15 -10.66894795599946 16 -10.657958303666721 17 -10.647223145125071
		 18 -10.63965144558945 19 -10.63711571485103 20 -10.640789092868262 21 -10.650230179438083
		 22 -10.664307196266639 23 -10.680236142665885 24 -10.694513084541603 25 -10.70409624332183
		 26 -10.706494504368022 27 -10.699695024329722 28 -10.682551088353398 29 -10.654885889046783
		 30 -10.61753701543271 31 -10.572174460256887 32 -10.521574925170528;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotateX";
	rename -uid "503DE65E-43CC-60F8-7BAC-F08CE2910165";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.4676437326075629 1 5.2358274644638207
		 2 5.2431582184603291 3 5.4469747497323668 4 5.8219882600600856 5 6.3660390903621265
		 6 7.077691484370078 7 7.9561017138013446 8 8.997522908644239 9 10.204162920795564
		 10 11.607594879990247 11 13.228845241444949 12 15.043501333552209 13 17.004243799881188
		 14 19.039566948128499 15 21.052780759239724 16 22.922544616561883 17 24.509071959770921
		 18 25.67201672091106 19 26.261758007969203 20 26.155802615624587 21 25.3864939019223
		 22 24.039123148590946 23 22.218535393262666 24 20.051413636745629 25 17.67111255358375
		 26 15.216936489306278 27 12.826039205209796 28 10.62371849543241 29 8.7154822297469448
		 30 7.1830130351261596 31 6.0857982890389115 32 5.4676437326075629;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotateY";
	rename -uid "9FD58FD2-40A7-E2B7-51A0-0F887280F9D2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -1.0360381849673319 1 -1.1858371505876499
		 2 -1.2919405092113365 3 -1.3081435329971034 4 -1.210427742107596 5 -0.99818174352713018
		 6 -0.67619389645161698 7 -0.25576257815932196 8 0.24634294746815935 9 0.80274955685045957
		 10 1.3075609498752945 11 1.6679448632047074 12 1.8900237690780948 13 1.9986880787644439
		 14 2.0301753488542538 15 2.0255761268891868 16 2.0237005705942246 17 2.0519986959086736
		 18 2.1138416798167543 19 2.2004656373995166 20 2.2372461216547799 21 2.1831027868926034
		 22 2.0745855310037564 23 1.9323748814388966 24 1.7560693935978016 25 1.5348842300274517
		 26 1.2531792214089004 27 0.90033228178087266 28 0.48203339796714934 29 0.025758198728750452
		 30 -0.42065964028697067 31 -0.79601943304803535 32 -1.0360381849673319;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotateZ";
	rename -uid "0792B743-43A5-1389-871F-17B68979AD1C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 37.768878339188177 1 37.463558097132434
		 2 37.45098498323199 3 37.587721129451111 4 37.754212058241706 5 37.868291282159056
		 6 37.89585114329369 7 37.851849746216047 8 37.79541898988623 9 37.813157407511561
		 10 38.236840506731063 11 39.232868024701546 12 40.612793243663162 13 42.181923956994353
		 14 43.770557105516374 15 45.247859537009326 16 46.523035088207372 17 47.537787905816401
		 18 48.248884635185128 19 48.620191496582116 20 48.711521545153921 21 48.60872074591169
		 22 48.301852581554691 23 47.771606238568722 24 47.001270204967064 25 45.995024338489642
		 26 44.783394698393529 27 43.42795712831451 28 42.015369711228303 29 40.646823130334802
		 30 39.424943811506651 31 38.441462417046594 32 37.768878339188177;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotateX";
	rename -uid "02421C3E-4718-C8C1-9F6D-8981875D52B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -9.527955287222893 1 -9.1788015787145252
		 2 -8.7445686276860819 3 -8.2417240828079574 4 -7.689899343543761 5 -7.1143095725454302
		 6 -6.5475716833721433 7 -6.0291546736097077 8 -5.6045279044665754 9 -5.3220209188538616
		 10 -5.2608063703861569 11 -5.4315859112067777 12 -5.776380922096032 13 -6.236701185984094
		 14 -6.757537780722334 15 -7.2897508922551957 16 -7.7915352029839875 17 -8.2281481602363584
		 18 -8.570414013870737 19 -8.7918236776013199 20 -8.9700292818312715 21 -9.1886965219410026
		 22 -9.4272164389188777 23 -9.6640506338731615 24 -9.8785867041039808 25 -10.053546586747098
		 26 -10.1748689239841 27 -10.233486897432002 28 -10.224673814719733 29 -10.147559135005713
		 30 -10.004026063715292 31 -9.7968643865106646 32 -9.527955287222893;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotateY";
	rename -uid "A2A1C86A-4338-C292-C9D6-969AA61F7D08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -8.1997107956386763 1 -8.2444888345290792
		 2 -8.2794565839489778 3 -8.2915919625135039 4 -8.2700278701319032 5 -8.2082879732698721
		 6 -8.1074775140220421 7 -7.9791450811984816 8 -7.8471075766737099 9 -7.745132685808465
		 10 -7.7215201944636336 11 -7.7861004644719074 12 -7.9035319892523157 13 -8.0347491692761537
		 14 -8.1495191528340207 15 -8.2314198914385415 16 -8.276737983060066 17 -8.2914960781443465
		 18 -8.287079478595242 19 -8.2767540507812249 20 -8.2641610185905137 21 -8.2434222047126546
		 22 -8.214180644627195 23 -8.1781677337411267 24 -8.1395231488530282 25 -8.103673134870288
		 26 -8.0765277025432383 27 -8.0627194336243946 28 -8.0648414630965526 29 -8.0828051562314034
		 30 -8.1142172364626663 31 -8.1549294792738465 32 -8.1997107956386763;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotateZ";
	rename -uid "83142450-4C9D-E2DE-11AE-4DBEBF9C2DF6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 98.603800225431627 1 96.162631398757853
		 2 93.141499792899594 3 89.653278539230627 4 85.823001974011305 5 81.808206108369973
		 6 77.815589848322062 7 74.112048078611011 8 71.028395295703476 9 68.945743102868988
		 10 68.491247683305218 11 69.757046167953206 12 72.282531777602443 13 75.601846297665503
		 14 79.300489750559876 15 83.03517338998121 16 86.529387301777888 17 89.559020986251014
		 18 91.93265015889574 19 93.469481606806198 20 94.708465687580386 21 96.23160131233638
		 22 97.898175282740951 23 99.558974553073853 24 101.07078961089186 25 102.30903765410778
		 26 103.17102641340736 27 103.58865602127224 28 103.5259551270143 29 102.9770385416905
		 30 101.95818679843588 31 100.49406267853463 32 98.603800225431627;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotateX";
	rename -uid "583352BF-4F09-ED58-968E-D28396FD7A03";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -4.1595866590551038 1 -4.5671373135071311
		 2 -5.2339578306571051 3 -6.0197745766324742 4 -6.8168396658688462 5 -7.525401946043444
		 6 -8.0140949188132051 7 -8.4208369121711097 8 -9.0071283437159693 9 -9.7788725042431377
		 10 -10.711622098581321 11 -11.76499674377563 12 -12.872754273167738 13 -13.925031766421018
		 14 -14.767317149859508 15 -15.21031108642252 16 -16.269032422768227 17 -18.401438613795005
		 18 -20.628817433424064 19 -22.03820600187062 20 -21.793233151855198 21 -20.126604433135238
		 22 -17.979875346724434 23 -15.58207113171391 24 -13.13929908449337 25 -10.819447435994281
		 26 -8.7546923217191353 27 -7.0385804272098706 28 -5.7223403036396991 29 -4.8138622501077393
		 30 -4.2830884305711319 31 -4.0791638977866294 32 -4.1595866590551038;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotateY";
	rename -uid "FD932670-48FC-859E-AED9-4D9071B8A2D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -25.696094179346318 1 -25.889149738755343
		 2 -25.287462497024158 3 -23.969989098079662 4 -21.999306795675743 5 -19.420921456563878
		 6 -16.284719061609898 7 -12.696067619162216 8 -8.7903670791720572 9 -4.6554673757211944
		 10 -0.3504856297016109 11 4.0028319694257348 12 8.2285134774714344 13 12.149796752227097
		 14 15.585736329996767 15 18.340867081964507 16 20.104984142577546 17 20.758991146892544
		 18 20.363987919424297 19 18.970784048221418 20 16.743251688239795 21 13.827628664127559
		 22 10.220938074773738 23 6.0713283440092551 24 1.5555028245666291 25 -3.1371196114801485
		 26 -7.8089563242251971 27 -12.263876765481157 28 -16.318433541825897 29 -19.811459437031342
		 30 -22.608536988662113 31 -24.600941427139613 32 -25.696094179346318;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotateZ";
	rename -uid "B5AE4F74-49BF-36DB-CDC3-53A26D4D5464";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -11.848290460364417 1 -10.054084076901988
		 2 -8.1115125932050169 3 -6.1367198379287364 4 -4.2140067359515871 5 -2.4222372064544784
		 6 -0.8681522658858879 7 0.27894060753789612 8 0.79852385850490593 9 0.45816258228635565
		 10 -0.95863153253578126 11 -3.295702240217913 12 -6.2068369563437189 13 -9.3311990654907682
		 14 -12.313746601271463 15 -14.813308469593599 16 -16.686293230691994 17 -17.905614778783974
		 18 -18.359997598850757 19 -17.989552958034519 20 -17.358862398449332 21 -17.055789701732071
		 22 -17.053193169956252 23 -17.266633551426491 24 -17.579588548274327 25 -17.856357765561562
		 26 -17.957520476757903 27 -17.766588666703136 28 -17.209046418796902 29 -16.26934926288801
		 30 -14.995385092083289 31 -13.483350546218254 32 -11.848290460364417;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotateX";
	rename -uid "31BD412B-44CA-4CFA-02AA-A39AAC01AF6E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 42.843538816080809 1 41.897756136960162
		 2 40.772027320354098 3 39.493502863404153 4 38.069148116505559 5 36.856407687354647
		 6 36.199116388082864 7 36.097069677255497 8 36.621383096355558 9 37.70310446896864
		 10 39.169224661785734 11 40.929151851090232 12 42.88191475491216 13 44.914504224530418
		 14 46.832287070034255 15 48.472331044205824 16 49.768180286621586 17 50.669733443560901
		 18 51.098651112628012 19 51.076428793748974 20 50.792172891789662 21 50.395626777839041
		 22 49.911458603432472 23 49.284602181293266 24 48.505164367152481 25 47.660106164456785
		 26 46.841645162640596 27 46.060450202821016 28 45.322214885128311 29 44.629426246241081
		 30 43.983022220541081 31 43.385362459545519 32 42.843538816080809;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotateY";
	rename -uid "17A1F7DB-4485-435A-F16C-1492D8810A1C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.0433289330825266 1 5.4324957942419978
		 2 5.2860865774734158 3 4.6648938321423836 4 3.7365305737476548 5 2.8497643776792412
		 6 2.1388825586734881 7 1.5185558003428399 8 0.9162686560409784 9 0.29228759222074113
		 10 -0.33342869297941613 11 -0.94880133652546039 12 -1.5288476922112522 13 -2.0369887050911144
		 14 -2.390851690554884 15 -2.5295077269147086 16 -2.4438225922605299 17 -2.1495086925321667
		 18 -1.7201665258013554 19 -1.2556424754112137 20 -0.83445370898949878 21 -0.51772430208420761
		 22 -0.26641105312534491 23 0.012284030700834451 24 0.33098145753240193 25 0.69264910408831248
		 26 1.100574183840783 27 1.5739234253659884 28 2.1271526062788149 29 2.7667110339785279
		 30 3.4880933849853335 31 4.2636482853746331 32 5.0433289330825266;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotateZ";
	rename -uid "D9BFF55F-42EC-F25A-B7DF-979A02B3EA0E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 58.126933734291804 1 59.643542769617547
		 2 61.557139385581429 3 63.717903355705602 4 65.93974242267204 5 68.173191740818567
		 6 70.355371533580296 7 72.349164222524024 8 74.100077138292392 9 75.584841605147048
		 10 76.758955826513741 11 77.56801808421784 12 77.97099072692788 13 77.940285755217062
		 14 77.370865772947013 15 76.23610172272646 16 74.628166663331811 17 72.651638980910107
		 18 70.42066399383323 19 68.095652549072923 20 65.885254957455587 21 63.95769674550619
		 22 62.315656792534995 23 60.861954798498338 24 59.604396705636539 25 58.53665794237434
		 26 57.655095294508939 27 56.983488310255964 28 56.550375847296777 29 56.391690547466055
		 30 56.553540384355962 31 57.102550401321288 32 58.126933734291804;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotateX";
	rename -uid "4FDFEEE1-4918-28FD-58AB-38B834B8F134";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -1.0933663683052683 1 -1.0228363532428737
		 2 -1.1005797699642887 3 -1.3220223000496492 4 -1.6688710712532242 5 -2.0671352288783273
		 6 -2.4698122198055357 7 -2.8742352882464428 8 -3.2740845068744129 9 -3.6657120464886117
		 10 -4.0370837226626115 11 -4.3774263394637591 12 -4.6773064321876019 13 -4.9277675407884098
		 14 -5.1031376410361986 15 -5.1876318045012413 16 -5.1841047775488356 17 -5.1011731965109224
		 18 -4.9688550909632827 19 -4.8042447387581708 20 -4.6118372454436969 21 -4.4105278090470161
		 22 -4.1819344443230042 23 -3.8994272496738134 24 -3.5785823633155229 25 -3.2309577149614084
		 26 -2.8684276507110114 27 -2.5032556269094224 28 -2.1483374834975404 29 -1.8167331670764941
		 30 -1.521224104189514 31 -1.2756529503852836 32 -1.0933663683052683;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotateY";
	rename -uid "425CE6EF-4E7D-99E0-8A21-8CB992438214";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -3.4685467057558377 1 -3.3443690200008152
		 2 -3.4809551148374944 3 -3.8403228975782362 4 -4.3324795109185823 5 -4.8169211214096803
		 6 -5.239621270483541 7 -5.6098734592938531 8 -5.9313947375257188 9 -6.2093296479039592
		 10 -6.4431070031886826 11 -6.6343099606892961 12 -6.7859560613134109 13 -6.9012059681977345
		 14 -6.9760450038874877 15 -7.0104269684052971 16 -7.0090212771440674 17 -6.9752087240057694
		 18 -6.9191843813314957 19 -6.8456370935462374 20 -6.7541450545307145 21 -6.6518454698081522
		 22 -6.5270855400273922 23 -6.3596734526034018 24 -6.1504536795311573 25 -5.8986256101382528
		 26 -5.6049008996712377 27 -5.2721771082740219 28 -4.9071006015190504 29 -4.5211466589503599
		 30 -4.1321367640624196 31 -3.7683991228420002 32 -3.4685467057558377;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotateZ";
	rename -uid "76E302A3-4859-6D16-A766-6486A173417B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 25.099506798099103 1 24.120135752014182
		 2 25.198108814701218 3 28.09649873157348 4 32.234135400639914 5 36.548719473624054
		 6 40.568203970451414 7 44.346233740940569 8 47.883515707383538 9 51.195769368525724
		 10 54.223756408205908 11 56.918035961053171 12 59.237711902726161 13 61.141576539170579
		 14 62.457722761290832 15 63.087509892265793 16 63.06127682460987 17 62.443206427029494
		 18 61.451203314560843 19 60.206082313910912 20 58.735459438494807 21 57.176333760651104
		 22 55.379042036788938 23 53.112822208304046 24 50.470220571161718 25 47.509933369196936
		 26 44.293244319191892 27 40.889650413503119 28 37.383731366724483 29 33.882809460498088
		 30 30.523965623752975 31 27.508747172449173 32 25.099506798099103;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotateX";
	rename -uid "A77F4B04-4406-6368-E8B3-4E9197963635";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 67.558617225675249 1 67.004864825037913
		 2 66.554376552340699 3 66.140910876044799 4 65.752524671154148 5 65.810234392836193
		 6 66.585619399450167 7 67.993645295956696 8 70.080955431379479 9 72.713790890095211
		 10 75.604307027413597 11 78.588967613133832 12 81.496170772320099 13 84.144508496916629
		 14 86.341613047227014 15 87.999936985372642 16 89.081706255844068 17 89.554211770332756
		 18 89.348070058979744 19 88.515040134359054 20 87.30431507128165 21 85.925980707304234
		 22 84.397317777016042 23 82.598086167901528 24 80.511935916513124 25 78.294284209472835
		 26 76.124854941154027 27 74.062070574580432 28 72.167852554081435 29 70.50650723156599
		 30 69.142535808448443 31 68.140286240163874 32 67.558617225675249;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotateY";
	rename -uid "459EC0D7-4E9E-3344-A3E4-B2913D238F2B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 56.55007323568767 1 56.125981064716811
		 2 55.354330927982701 3 54.274985144308893 4 52.980340712699729 5 51.727182836208087
		 6 50.664420123508336 7 49.791931308626644 8 49.120031902245756 9 48.579281327572907
		 10 48.092175972978588 11 47.642469685070211 12 47.231570000458525 13 46.879654717652649
		 14 46.720970522335399 15 46.873155029228123 16 47.333310392307439 17 48.054742470807511
		 18 48.923797203170516 19 49.843446303877926 20 50.738843899457741 21 51.531192301486726
		 22 52.269644775332736 23 53.01813703701103 24 53.720441321280425 25 54.368567112071688
		 26 54.970940951690835 27 55.508294397026475 28 55.963103992490659 29 56.317895499778963
		 30 56.552753474879921 31 56.641692754842495 32 56.55007323568767;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotateZ";
	rename -uid "B7BB85DD-47DC-8993-BDB4-A48B486612A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -46.038689172291321 1 -45.430418663672015
		 2 -46.016333407363597 3 -47.725686510737098 4 -50.221501430708493 5 -52.486990414213849
		 6 -54.024924117168496 7 -54.970243044220283 8 -55.285905285971545 9 -55.080476010369992
		 10 -54.559770853241474 11 -53.832834734670897 12 -53.015647791900719 13 -52.224566877998825
		 14 -51.571603479056876 15 -51.100239679914651 16 -50.807041966550571 17 -50.701325880347987
		 18 -50.9156916017809 19 -51.42351174509897 20 -51.976704658645495 21 -52.440361642984854
		 22 -52.725819335795869 23 -52.852380275374671 24 -52.913427275309104 25 -52.829754580114631
		 26 -52.498416393183405 27 -51.921618114287512 28 -51.104503670789001 29 -50.061042136186877
		 30 -48.819997963532444 31 -47.445216743975543 32 -46.038689172291321;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotateX";
	rename -uid "2A5466BB-4670-2190-EB5C-8E80C2D9E1D6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 33.355683238759774 1 36.938423248896051
		 2 40.967570843131682 3 45.160105437453282 4 49.229977001320961 5 52.889255933926499
		 6 55.851409748292447 7 57.833873933507164 8 58.557012908877326 9 57.882152662338065
		 10 56.004837459322516 11 53.144993402222966 12 49.524052261170887 13 45.364772794675368
		 14 40.888994026439271 15 36.315308968667388 16 31.960477289246164 17 28.014154289253877
		 18 24.502610789735566 19 21.452742546684227 20 18.892332416377126 21 16.849973063300606
		 22 15.354903402165858 23 14.43672654938878 24 14.124378195663169 25 14.596030153976699
		 26 15.912937678926124 27 17.927015076061945 28 20.490523067783467 29 23.457658206656433
		 30 26.684967955052588 31 30.030975463674757 32 33.355683238759774;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotateY";
	rename -uid "78B2E04F-4608-53C4-6A9F-E7BB4C28AF59";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 7.4207326341411441 1 7.2830022792316003
		 2 7.3303393535519135 3 7.4415472158404086 4 7.5285090989674552 5 7.5488146938826919
		 6 7.5082677709058592 7 7.4485591355171845 8 7.4207455776732978 9 7.4126743034386244
		 10 7.3889607680836527 11 7.3341894383097097 12 7.2445159256586695 13 7.1572077495135025
		 14 7.1648260457694404 15 7.4129978700686028 16 7.8690179306767076 17 8.3745599156394732
		 18 8.9119457339905335 19 9.4561776973672771 20 9.9776770509139148 21 10.444195921112728
		 22 10.821742282447762 23 11.075150601509852 24 11.167946093867972 25 11.034816228713586
		 26 10.678650318558898 27 10.163347819177959 28 9.5527876285644453 29 8.9112608148955808
		 30 8.3025970848918096 31 7.7873443303306509 32 7.4207326341411441;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotateZ";
	rename -uid "E402960A-428E-4B74-E504-9D8208AAFAF9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -46.336677946875483 1 -47.467025557458051
		 2 -48.053287679818894 3 -48.172964896546304 4 -47.934255198670577 5 -47.4739340451682
		 6 -46.94701506229913 7 -46.514928311582359 8 -46.336644664922744 9 -46.470063073054952
		 10 -46.772120988457928 11 -47.090439692312771 12 -47.274695530650952 13 -47.190035396463756
		 14 -46.732758766300314 15 -45.844482142390262 16 -44.346431173299187 17 -42.232408766239558
		 18 -39.732245827279499 19 -37.064497962897796 20 -34.437858570879008 21 -32.053286733988685
		 22 -30.106864438651449 23 -28.793422955661296 24 -28.310551628469245 25 -28.909819812023237
		 26 -30.527421063950175 27 -32.899617621942831 28 -35.761808812479309 29 -38.838492851792239
		 30 -41.837400570949576 31 -44.446859715356361 32 -46.336677946875483;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotateX";
	rename -uid "ADA4161F-4FDD-5DB1-844D-8FABDE1FF4FB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 10.649759067254434 1 10.526649654171976
		 2 10.303186729098295 3 9.9993388442184745 4 9.634939745252975 5 9.2300723417933739
		 6 8.8047736256080142 7 8.3819415626387705 8 7.978279095974834 9 7.6046537325517019
		 10 7.2719119048323959 11 6.9909562781370829 12 6.7726364864055215 13 6.6276805936774901
		 14 6.5668194863466836 15 6.6007624180445532 16 6.7401853159800478 17 6.9705705745077005
		 18 7.2596518706534212 19 7.591684956914631 20 7.9509484892399964 21 8.3217522000784676
		 22 8.6885462167832834 23 9.0422888560165422 24 9.3769738998967345 25 9.6864944489077445
		 26 9.9648102152637019 27 10.205887942999402 28 10.40378761698433 29 10.552719807232062
		 30 10.647075967780639 31 10.681282143474576 32 10.649759067254434;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotateY";
	rename -uid "19BB8A34-40DF-904E-9C9F-2FBA297C21D7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -0.45199939185461474 1 -0.42967227992935147
		 2 -0.41456543087701614 3 -0.4070247638368612 4 -0.40690045956591903 5 -0.41369082852817413
		 6 -0.42680585797703469 7 -0.44674316763255989 8 -0.47215644261497774 9 -0.50051114362888638
		 10 -0.53024458267340424 11 -0.56056472433516447 12 -0.59136126115544563 13 -0.62312402252219157
		 14 -0.65663008205133677 15 -0.69264448946878443 16 -0.73164717561137094 17 -0.77228340485830771
		 18 -0.81148153210519214 19 -0.84631154273198506 20 -0.87355074858792503 21 -0.88961119401171418
		 22 -0.89100408931477826 23 -0.87727524298500581 24 -0.84950448811473722 25 -0.80956640793162082
		 26 -0.75990323906580182 27 -0.70350594718584714 28 -0.6438756291865555 29 -0.58491506546593641
		 30 -0.53061448248486709 31 -0.48503150409634438 32 -0.45199939185461474;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotateZ";
	rename -uid "ED64ADCF-443D-C6E5-12B6-B08C3EA56CD2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.0154460260236462 1 4.9241996210165953
		 2 4.8923801543674408 3 4.9203371694025497 4 5.0084132706058586 5 5.1569979848426977
		 6 5.3664922980255847 7 5.6421794526692022 8 5.9778406370385309 9 6.3565357947168684
		 10 6.7612166007932224 11 7.1747944898051284 12 7.5801711611108376 13 7.9603511522571955
		 14 8.298296365290037 15 8.5770797972625648 16 8.7798482469588723 17 8.9039798003419488
		 18 8.9569942068699788 19 8.9370983923624774 20 8.8426411108165812 21 8.6719140263599819
		 22 8.4236338341286032 23 8.1086239775270048 24 7.743586784891356 25 7.3451485981617974
		 26 6.929943081393974 27 6.5145722024111601 28 6.1156456443658724 29 5.749724675889107
		 30 5.4333567634422275 31 5.1830620655140454 32 5.0154460260236462;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotateX";
	rename -uid "21C299E0-41D2-3D56-7AAD-76BF7C00665D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 13.122725759078593 1 13.13747916021258
		 2 13.057538352640611 3 12.891834717290822 4 12.649301326291255 5 12.338835244145823
		 6 11.969528028677333 7 11.547871493181002 8 11.086513329885506 9 10.603883389529415
		 10 10.118592443558811 11 9.6494637963287939 12 9.2155150881826735 13 8.8359692819563964
		 14 8.530207552855579 15 8.3176780245636444 16 8.2178640374203251 17 8.2262382715897182
		 18 8.3211536234522061 19 8.4964710266880878 20 8.7459139567481774 21 9.0632050774124799
		 22 9.4416931713679073 23 9.8677713366049531 24 10.324561979730781 25 10.795267524486787
		 26 11.263423437867036 27 11.712685957873541 28 12.12704270651086 29 12.490729534606189
		 30 12.788208976405357 31 13.003999525600255 32 13.122725759078593;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotateY";
	rename -uid "184672AE-48E3-9A3F-3307-87B2518CF8C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 0.77002702251809629 1 0.80636887164292437
		 2 0.85024034853057318 3 0.89699166245012718 4 0.94183423799890564 5 0.9802185721983544
		 6 1.0079815164737262 7 1.0205303799258227 8 1.0169267274502451 9 0.99932273553145146
		 10 0.97036197250965639 11 0.93286306498869576 12 0.88973088259114796 13 0.84382815255335974
		 14 0.7975232088283879 15 0.75301387572117284 16 0.71145973280903829 17 0.67362295560519536
		 18 0.63988421457714773 19 0.61073199620673924 20 0.58677305796013934 21 0.56922065745601858
		 22 0.55965606853673933 23 0.55797054386665812 24 0.56326636673641128 25 0.57490982576838234
		 26 0.59230621001293315 27 0.61482418871790123 28 0.64170242170618075 29 0.67201350763897871
		 30 0.70454011706320518 31 0.73783808982156363 32 0.77002702251809629;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotateZ";
	rename -uid "D8A2BFF0-4B83-CEEE-74CE-258A939E7565";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -0.68614410807784054 1 -0.83735736434194452
		 2 -1.0476873374134754 3 -1.2996323260024818 4 -1.5757196080656348 5 -1.8584544936089136
		 6 -2.1302376524518154 7 -2.3686620735869601 8 -2.5621312890800465 9 -2.7089700761150475
		 10 -2.8076092974481961 11 -2.856407692145241 12 -2.8538346451326029 13 -2.7983895096318929
		 14 -2.688667433535231 15 -2.5232784447585086 16 -2.3009570308066429 17 -2.0358670896457891
		 18 -1.7531742965597166 19 -1.4679754987456028 20 -1.1954363664733085 21 -0.95062539182718153
		 22 -0.74827337192520227 23 -0.59101101369031084 24 -0.47564584772437735 25 -0.39910148147362107
		 26 -0.35810817902504899 27 -0.34958335803285046 28 -0.37037655543522846 29 -0.41741440803828772
		 30 -0.48768447912773022 31 -0.57821506679284662 32 -0.68614410807784054;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotateX";
	rename -uid "C52B5768-4335-19C6-C52E-6099F2888100";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 6.9922743911811818 1 6.9922765476752815
		 2 6.992294716677141 3 6.9922880684037576 4 6.992255249135308 5 6.9922687573210434
		 6 6.9922913728908354 7 6.9923092585948243 8 6.9923010332772462 9 6.9923269866588296
		 10 6.9923061386381899 11 6.9922798141657028 12 6.9922967428933056 13 6.9923084383890615
		 14 6.9922839238851529 15 6.992297114486008 16 6.9922996418409271 17 6.9922916496760621
		 18 6.9922917482326792 19 6.9922742719278403 20 6.9922966453134654 21 6.992301755478727
		 22 6.9922977635736236 23 6.992295465037226 24 6.9922742424413151 25 6.9922957342412646
		 26 6.9922970393612349 27 6.992291285205944 28 6.9922673850797077 29 6.9922999422824086
		 30 6.9923229108537752 31 6.9922940884305103 32 6.9922743911811818;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotateY";
	rename -uid "ABE76754-495B-F4D7-309D-24A13C65D69F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -5.3593915297137178 1 -5.359376629402826
		 2 -5.3593692963969328 3 -5.3593644667582394 4 -5.3593884084160326 5 -5.3593832515621482
		 6 -5.3594017293551381 7 -5.3593864571637599 8 -5.3593880066490467 9 -5.3593981175589116
		 10 -5.3593836597962259 11 -5.3593973166117816 12 -5.3593780516194771 13 -5.3593851994526798
		 14 -5.3593792336704267 15 -5.3593804726361016 16 -5.3593750126002906 17 -5.3593862436649955
		 18 -5.3593860586557138 19 -5.3593826354817455 20 -5.3593842861486172 21 -5.3593955200230798
		 22 -5.3593827000306824 23 -5.3593782561413805 24 -5.3593915734028661 25 -5.3593921428057101
		 26 -5.3593809462285646 27 -5.3593733822250123 28 -5.3593835481614853 29 -5.3593912847603953
		 30 -5.3593762628135933 31 -5.3593934013320652 32 -5.3593915297137178;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotateZ";
	rename -uid "E5B68227-44C8-B5E8-5C68-F2A0BFCF2D9E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -13.826399902865854 1 -13.826405930898821
		 2 -13.826389821087105 3 -13.826408192539978 4 -13.82641516503363 5 -13.826424470867588
		 6 -13.826388520239172 7 -13.826394615604261 8 -13.826419036128215 9 -13.826373710276867
		 10 -13.826381230379654 11 -13.826417940387863 12 -13.826396130783543 13 -13.826402120815496
		 14 -13.82639844594841 15 -13.826413613411383 16 -13.826420013377444 17 -13.826402314350663
		 18 -13.826403190951535 19 -13.826417325298486 20 -13.826393871011472 21 -13.826417507512442
		 22 -13.826403741972163 23 -13.826396276831533 24 -13.82639687933294 25 -13.826423508315608
		 26 -13.826407012446893 27 -13.826411378710448 28 -13.826413358546603 29 -13.82640096302921
		 30 -13.826409741241275 31 -13.826413579952437 32 -13.826399902865854;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotateX";
	rename -uid "4FB5B7A9-4677-61E5-7656-DB9145C0A1C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.4008995326002771 1 1.1312739217142251
		 2 0.9300410275176193 3 0.8260739335180558 4 0.84403204555720235 5 1.0396624798542411
		 6 1.4186731070672856 7 1.9192655382912889 8 2.4774288251366241 9 3.0366895987306033
		 10 3.5529413865784276 11 3.9967963103189721 12 4.3529769003899608 13 4.618347277416194
		 14 4.7997218208474504 15 4.911102522664379 16 4.970432241849851 17 4.9962075190066306
		 18 5.0029209376343511 19 5.0027837013350327 20 4.9966042928718375 21 4.9713786024273316
		 22 4.9108889165208831 23 4.7992319140454374 24 4.6232232538341647 25 4.3743189696222764
		 26 4.0501712722510943 27 3.6559252589897335 28 3.2050482588923188 29 2.7198211391722547
		 30 2.2312081893717894 31 1.7772617926332144 32 1.4008995326002771;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotateY";
	rename -uid "8D3944F5-4F4B-99DA-E107-4B8DE85A89E4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -21.514788184262592 1 -22.566986389047806
		 2 -23.381074167632494 3 -23.906699039848714 4 -24.092500663522948 5 -23.684704732268148
		 6 -22.543106713153055 7 -20.784768590742143 8 -18.526969056097162 9 -15.88907176710177
		 10 -12.993049052485249 11 -9.9635246593206208 12 -6.9270151521137882 13 -4.0108823055212408
		 14 -1.3425806394262827 15 0.95101656152913949 16 2.7439766987346172 17 3.9111587002622508
		 18 4.327923078892721 19 4.0254662514949064 20 3.170159745277302 21 1.8401552192929369
		 22 0.11382548805005099 23 -1.9299732087568644 24 -4.2117202155136857 25 -6.651425905601136
		 26 -9.1689037818806529 27 -11.684273628439961 28 -14.11846952334902 29 -16.393791698663588
		 30 -18.434234487593333 31 -20.1655304733451 32 -21.514788184262592;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotateZ";
	rename -uid "0B5F3F85-4D46-8D53-87D9-1F99375F1335";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 16.055218974694835 1 15.966941805473319
		 2 15.812765110073974 3 15.658042254570457 4 15.570215470644619 5 15.489897265321357
		 6 15.331102091360258 7 15.129993851328669 8 14.923758686341332 9 14.742878816501618
		 10 14.607540153238871 11 14.526675120429719 12 14.499382542353821 13 14.517164968618621
		 14 14.566596353963028 15 14.631524256365326 16 14.695341927573702 17 14.74264587747445
		 18 14.760587482021318 19 14.78307311766665 20 14.844400589634523 21 14.936603346152859
		 22 15.053594416497178 23 15.190689325539003 24 15.344059763259672 25 15.509773338192064
		 26 15.682691293526528 27 15.854646124311451 28 16.013265231171697 29 16.140261045448515
		 30 16.211019283409442 31 16.194640312057818 32 16.055218974694835;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotateX";
	rename -uid "DC502572-42D7-98FC-250A-7F83058D3E9A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 0.10701874391026024 1 0.11536535372103071
		 2 0.12295220728277979 3 0.12734641277303954 4 0.12770851665970817 5 0.12356495593998879
		 6 0.1167741307651519 7 0.11190293799233703 8 0.10822305082273301 9 0.10653162880192256
		 10 0.10610998354638203 11 0.10567489180394872 12 0.1058885812939723 13 0.10597428585737849
		 14 0.10606672228500542 15 0.10527847398483592 16 0.10397289886865181 17 0.10134244494237492
		 18 0.097191851320026973 19 0.091594642193025572 20 0.084417914430297475 21 0.07428580849660385
		 22 0.064999407241230669 23 0.059402807658973274 24 0.057518448976894558 25 0.058317709188240995
		 26 0.061735939593708496 27 0.067160185954034182 28 0.073704797532198912 29 0.081988322416517781
		 30 0.09024816882507733 31 0.098847851798626915 32 0.10701874391026024;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotateY";
	rename -uid "3B56BEB0-46AE-5BC8-C3F9-CEB6B8645740";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -23.521490513128327 1 -24.431439292188266
		 2 -25.222576094473453 3 -25.866780246171036 4 -26.338047353724956 5 -26.608197379874763
		 6 -26.638906945703138 7 -26.431420565246487 8 -26.018561255683153 9 -25.43157844322047
		 10 -24.704132630014179 11 -23.869681768178499 12 -22.959030726668267 13 -22.006467903320353
		 14 -21.04355750798554 15 -20.103084971154605 16 -19.217704017639864 17 -18.420429181886345
		 18 -17.743852887548062 19 -17.220106174650571 20 -16.881684687944848 21 -16.761662984372002
		 22 -16.839526948049329 23 -17.064309824419659 24 -17.422770831184462 25 -17.901880566428229
		 26 -18.487703582591607 27 -19.168065234545281 28 -19.929923938131012 29 -20.758646143434795
		 30 -21.642444698773218 31 -22.568316492054166 32 -23.521490513128327;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotateZ";
	rename -uid "65F0709B-4F93-848B-1D4A-259DEB2112BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 4.7389919063422363 1 4.73456288756263
		 2 4.7296965832208269 3 4.7277614203226479 4 4.7286485828957527 5 4.7313007698964853
		 6 4.7362618114523212 7 4.7389295033151742 8 4.7407297423405108 9 4.7398044970931412
		 10 4.7374217315389489 11 4.7364009856652798 12 4.7350167198070734 13 4.7347041190326893
		 14 4.7347898855182668 15 4.736788403281297 16 4.7387315550018716 17 4.7419516257572045
		 18 4.7458638044293346 19 4.7486087189542214 20 4.7488070844296857 21 4.7496984019509769
		 22 4.7496560904797791 23 4.7508006290563189 24 4.750585858137943 25 4.7511177693775997
		 26 4.7507063975395569 27 4.7499259064623756 28 4.7498269451355117 29 4.7470170196353534
		 30 4.7454408945382207 31 4.7425772425975001 32 4.7389919063422363;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotateX";
	rename -uid "09575ED9-4256-9E8E-4CAB-A4A29B0B9D78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 6.4158753012466665 1 7.116972699471602
		 2 7.6453602504114899 3 7.955949437421646 4 8.0278528561489608 5 7.8740319131994427
		 6 7.4995948948022084 7 6.9220884379743755 8 6.1796972108872934 9 5.3084482769627694
		 10 4.3449692388647323 11 3.3265170466009688 12 2.2909007327967954 13 1.2761715557990279
		 14 0.32051693827498073 15 -0.53807765971207067 16 -1.2618747757094293 17 -1.8166985211029201
		 18 -2.1820956369614715 19 -2.3562422300901016 20 -2.3496062357267551 21 -2.1633197083607181
		 22 -1.798444640305974 23 -1.2703164058651861 24 -0.61006562696042577 25 0.15748555026200253
		 26 1.0073074333289371 27 1.9140691974848263 28 2.852341606235913 29 3.7967367649685686
		 30 4.7219878109387476 31 5.6032037173580758 32 6.4158753012466665;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotateY";
	rename -uid "02D171ED-43CE-1303-21E3-6F8416F7F588";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -6.838742137254628 1 -6.9498560220112244
		 2 -6.9970689286379981 3 -6.9882901118630363 4 -6.9266767897824186 5 -6.8089103999799718
		 6 -6.6337332756264322 7 -6.4058998571964612 8 -6.1391687790243425 9 -5.8458528067551372
		 10 -5.5378289997702757 11 -5.2264579398364042 12 -4.9227272934728612 13 -4.6373058471650301
		 14 -4.3807687817996124 15 -4.1638840675052782 16 -3.9975577952957537 17 -3.8903020378781594
		 18 -3.8401577575739632 19 -3.846061814133118 20 -3.9096263905809199 21 -4.0304282678972232
		 22 -4.2078430487925615 23 -4.4349965751241962 24 -4.6981995959544305 25 -4.9867619216975783
		 26 -5.2900940363916975 27 -5.5978301599736771 28 -5.8996139809046975 29 -6.1851207968613329
		 30 -6.4439186128060744 31 -6.6654441706075218 32 -6.838742137254628;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotateZ";
	rename -uid "7FCA0274-44A7-439E-436D-56BBFBB3F351";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -21.329365172499646 1 -21.250436324829153
		 2 -21.179918415908119 3 -21.134745754996249 4 -21.123347184034827 5 -21.141224682006996
		 6 -21.182543995620428 7 -21.238692267895189 8 -21.299764770583735 9 -21.356577072714774
		 10 -21.401452617854023 11 -21.429039767286934 12 -21.436743771472404 13 -21.424944030836397
		 14 -21.396880792321049 15 -21.358285576056698 16 -21.316837783517109 17 -21.280817310877161
		 18 -21.256039964417457 19 -21.246543166855865 20 -21.254123649265843 21 -21.278399272779964
		 22 -21.317161404632095 23 -21.365129686279431 24 -21.414895697771765 25 -21.46003901304109
		 26 -21.494709913837418 27 -21.514304315652637 28 -21.515460889992596 29 -21.496592364863023
		 30 -21.457768322139113 31 -21.400853665930637 32 -21.329365172499646;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotateX";
	rename -uid "63C7A4FD-469D-1C4A-8358-D6AB23A6087A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 6.9418254219018083 1 7.6488461205233564
		 2 8.1786436656269803 3 8.4871364217559844 4 8.5537696655572706 5 8.391200011554977
		 6 8.0043719946600458 7 7.4110641099825036 8 6.6503462414349181 9 5.7590136192068648
		 10 4.7744916872047867 11 3.7347792752458693 12 2.6783986099957162 13 1.6441845319771358
		 14 0.6710413905424697 15 -0.20223554806675015 16 -0.93713184145176809 17 -1.4988728855404618
		 18 -1.8671933808496564 19 -2.0403377477870004 20 -2.0285953499049412 21 -1.8331785302599835
		 22 -1.455120746046201 23 -0.91032765515589542 24 -0.23093972815591138 25 0.55742224037881694
		 26 1.4288950968243546 27 2.3573655400766382 28 3.3166410569042752 29 4.2805567395144708
		 30 5.2231175738943287 31 6.1186098448425899 32 6.9418254219018083;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotateY";
	rename -uid "18C0EFC5-4245-AB3F-6F18-6AB909A27927";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -6.3041399219573524 1 -6.3591846519150801
		 2 -6.3643140000927252 3 -6.3309474499577929 4 -6.2638112934372092 5 -6.1586220662123674
		 6 -6.0137006069262382 7 -5.8324172377655525 8 -5.6255541019630151 9 -5.4025810493531532
		 10 -5.1723898420795109 11 -4.9433893549823757 12 -4.7234580499153322 13 -4.5201341558025732
		 14 -4.3409894335005808 15 -4.1936062751643171 16 -4.0857483055143433 17 -4.0232699897736808
		 18 -4.0025668866755346 19 -4.0223843067128104 20 -4.0852330538576869 21 -4.1906989124339189
		 22 -4.338330750526354 23 -4.5224677853080228 24 -4.7319510097055071 25 -4.9580733768228731
		 26 -5.1924088669473303 27 -5.4265267468811222 28 -5.6522507231952313 29 -5.8613751558534091
		 30 -6.0454911992673885 31 -6.196044145471161 32 -6.3041399219573524;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotateZ";
	rename -uid "BF9AE061-47EC-471F-CB13-C1B4EEC330E1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -21.328343331468826 1 -21.243249733512535
		 2 -21.167289080142307 3 -21.118388340765687 4 -21.105606757431286 5 -21.124310713682327
		 6 -21.168419228519436 7 -21.228930563765353 8 -21.29521003377787 9 -21.357292917890167
		 10 -21.406991490957076 11 -21.438442341354257 12 -21.448753291271654 13 -21.438162460738511
		 14 -21.410044665577537 15 -21.37043878529758 16 -21.32745579528838 17 -21.289828772278877
		 18 -21.263954695944662 19 -21.25403661384652 20 -21.261984279079368 21 -21.2874623233553
		 22 -21.328089209257531 23 -21.378358126829227 24 -21.430389119229847 25 -21.477305726800395
		 26 -21.512983653140225 27 -21.532431710471919 28 -21.53220123693184 29 -21.510639868444407
		 30 -21.46779980521687 31 -21.405779271017636 32 -21.328343331468826;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotateX";
	rename -uid "91702556-4D0A-980A-B26D-01BEF1A9F139";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.112000753874236 1 3.7109633005757501
		 2 4.1777035554954969 3 4.4672098348839127 4 4.5586718609199064 5 4.465291207709428
		 6 4.1923993472787933 7 3.7544129294967528 8 3.1810955030535606 9 2.5007961356139292
		 10 1.7424467932729648 11 0.93566547087143259 12 0.1105845241788634 13 -0.70240576995558068
		 14 -1.4728442372580339 15 -2.1703980144053294 16 -2.765059860471093 17 -3.2291085618894919
		 18 -3.5429759096404094 19 -3.7045699958729679 20 -3.7241026603283744 21 -3.6024937555457002
		 22 -3.3404973671806655 23 -2.9494188059866167 24 -2.4522233061199001 25 -1.8672362689088662
		 26 -1.2130765755717821 27 -0.50852217915882236 28 0.22751698398749456 29 0.97616004320430594
		 30 1.7186685564926865 31 2.436611463918982 32 3.112000753874236;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotateY";
	rename -uid "D0AA2DE2-445D-18E6-AF87-CC861FD60994";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -8.8390138974847918 1 -9.2223132832448176
		 2 -9.4776507650932142 3 -9.5942478048554332 4 -9.5667356880396479 5 -9.3972994538696231
		 6 -9.0868035961847688 7 -8.6465441973757784 8 -8.104301070366466 9 -7.4858164197137089
		 10 -6.816591171409506 11 -6.1219955727556572 12 -5.4273718690928954 13 -4.7578534371486647
		 14 -4.1386329028117474 15 -3.5947674867978447 16 -3.1515330195004982 17 -2.8303799101879865
		 18 -2.6376899395823981 19 -2.5731324967179812 20 -2.6340000983449601 21 -2.8193827706568233
		 22 -3.1283513544867336 23 -3.5484806607751622 24 -4.054779561691352 25 -4.6274749645491218
		 26 -5.2468457696320376 27 -5.8932194164202816 28 -6.5468347851323596 29 -7.1879562321385109
		 30 -7.7969038960575476 31 -8.3538583718248134 32 -8.8390138974847918;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotateZ";
	rename -uid "07CF8525-49BF-1AFE-2837-FB8F40BB929F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -21.186185728206578 1 -21.117135744137599
		 2 -21.058293184265828 3 -21.023247458927774 4 -21.018361012079946 5 -21.039236993956973
		 6 -21.080564645121648 7 -21.134805662784277 8 -21.193474106245958 9 -21.249005189700028
		 10 -21.295002938254466 11 -21.327186041002825 12 -21.343518852748598 13 -21.34411487147775
		 14 -21.331402541572526 15 -21.309737451385232 16 -21.284798390652529 17 -21.262735376445747
		 18 -21.247638611462147 19 -21.242441472471072 20 -21.248692261447427 21 -21.265859586554416
		 22 -21.292010598641436 23 -21.322942562667606 24 -21.353091985143063 25 -21.377734661443512
		 26 -21.39260860323585 27 -21.394546317226414 28 -21.38147033407007 29 -21.352673439364171
		 30 -21.308940388799211 31 -21.252262815741759 32 -21.186185728206578;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX";
	rename -uid "5A6860ED-4DE8-E61B-9C94-8A9FB41F92D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 6.0462617874145508 1 6.0025100708007813
		 2 5.8792829513549805 3 5.6885719299316406 4 5.4423742294311523 5 5.1526947021484375
		 6 4.8315200805664062 7 4.4908266067504883 8 4.1425647735595703 9 3.7986345291137695
		 10 3.470911979675293 11 3.171229362487793 12 2.911402702331543 13 2.7032251358032227
		 14 2.5584821701049805 15 2.4889631271362305 16 2.5064659118652344 17 2.603236198425293
		 18 2.7577552795410156 19 2.9611902236938477 20 3.2047290802001953 21 3.4795541763305664
		 22 3.7768678665161133 23 4.087885856628418 24 4.4038267135620117 25 4.7158880233764648
		 26 5.0152387619018555 27 5.2930240631103516 28 5.5403413772583008 29 5.7482767105102539
		 30 5.9078807830810547 31 6.0101919174194336 32 6.0462617874145508;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY";
	rename -uid "9E09B5BB-4319-E37F-C29B-D79DB1C55808";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 43.512428283691406 1 43.515907287597656
		 2 43.516899108886719 3 43.515541076660156 4 43.512001037597656 5 43.506416320800781
		 6 43.498893737792969 7 43.489303588867188 8 43.477912902832031 9 43.465385437011719
		 10 43.452323913574219 11 43.439231872558594 12 43.426544189453125 13 43.414649963378906
		 14 43.40386962890625 15 43.394538879394531 16 43.387008666992188 17 43.381454467773437
		 18 43.3779296875 19 43.376670837402344 20 43.377891540527344 21 43.381843566894531
		 22 43.388717651367188 23 43.398292541503906 24 43.410125732421875 25 43.4237060546875
		 26 43.4384765625 27 43.45379638671875 28 43.468955993652344 29 43.483207702636719
		 30 43.495750427246094 31 43.505752563476563 32 43.512428283691406;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ";
	rename -uid "5F50F5B9-4F6D-979C-ED11-29AFFB3BF682";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -19.143121719360352 1 -19.046562194824219
		 2 -18.952669143676758 3 -18.868259429931641 4 -18.800115585327148 5 -18.755027770996094
		 6 -18.739776611328125 7 -18.765043258666992 8 -18.832540512084961 9 -18.935625076293945
		 10 -19.067697525024414 11 -19.222208023071289 12 -19.392648696899414 13 -19.572546005249023
		 14 -19.755453109741211 15 -19.934934616088867 16 -20.104547500610352 17 -20.257806777954102
		 18 -20.388225555419922 19 -20.489294052124023 20 -20.554496765136719 21 -20.577302932739258
		 22 -20.551454544067383 23 -20.480398178100586 24 -20.372175216674805 25 -20.234842300415039
		 26 -20.076498031616211 27 -19.905267715454102 28 -19.729326248168945 29 -19.556882858276367
		 30 -19.39619255065918 31 -19.255514144897461 32 -19.143121719360352;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotateX";
	rename -uid "7BEEBB57-4CAD-ECAC-898B-92AC340F6EA4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 2.3715192066179008e-008 1 2.3715192066179008e-008
		 2 2.3715192066179008e-008 3 2.3715192066179008e-008 4 2.3715192066179008e-008 5 2.3715192066179008e-008
		 6 2.3715192066179008e-008 7 2.3715192066179008e-008 8 2.3715192066179008e-008 9 2.3715192066179008e-008
		 10 2.3715192066179008e-008 11 2.3715192066179008e-008 12 2.3715192066179008e-008
		 13 2.3715192066179008e-008 14 2.3715192066179008e-008 15 2.3715192066179008e-008
		 16 2.3715192066179008e-008 17 2.3715192066179008e-008 18 2.3715192066179008e-008
		 19 2.3715192066179008e-008 20 2.3715192066179008e-008 21 2.3715192066179008e-008
		 22 2.3715192066179008e-008 23 2.3715192066179008e-008 24 2.3715192066179008e-008
		 25 2.3715192066179008e-008 26 2.3715192066179008e-008 27 2.3715192066179008e-008
		 28 2.3715192066179008e-008 29 2.3715192066179008e-008 30 2.3715192066179008e-008
		 31 2.3715192066179008e-008 32 2.3715192066179008e-008;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotateY";
	rename -uid "E654F776-4E7B-61EB-006A-55A3F7AB3E33";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 8.2332768042557873 1 8.2332768042557873
		 2 8.2332768042557873 3 8.2332768042557873 4 8.2332768042557873 5 8.2332768042557873
		 6 8.2332768042557873 7 8.2332768042557873 8 8.2332768042557873 9 8.2332768042557873
		 10 8.2332768042557873 11 8.2332768042557873 12 8.2332768042557873 13 8.2332768042557873
		 14 8.2332768042557873 15 8.2332768042557873 16 8.2332768042557873 17 8.2332768042557873
		 18 8.2332768042557873 19 8.2332768042557873 20 8.2332768042557873 21 8.2332768042557873
		 22 8.2332768042557873 23 8.2332768042557873 24 8.2332768042557873 25 8.2332768042557873
		 26 8.2332768042557873 27 8.2332768042557873 28 8.2332768042557873 29 8.2332768042557873
		 30 8.2332768042557873 31 8.2332768042557873 32 8.2332768042557873;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotateZ";
	rename -uid "D1F4EA44-4E0A-C2BE-3A2D-3B8D41ED2450";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 14.774024056590276 1 14.774024056590276
		 2 14.774024056590276 3 14.774024056590276 4 14.774024056590276 5 14.774024056590276
		 6 14.774024056590276 7 14.774024056590276 8 14.774024056590276 9 14.774024056590276
		 10 14.774024056590276 11 14.774024056590276 12 14.774024056590276 13 14.774024056590276
		 14 14.774024056590276 15 14.774024056590276 16 14.774024056590276 17 14.774024056590276
		 18 14.774024056590276 19 14.774024056590276 20 14.774024056590276 21 14.774024056590276
		 22 14.774024056590276 23 14.774024056590276 24 14.774024056590276 25 14.774024056590276
		 26 14.774024056590276 27 14.774024056590276 28 14.774024056590276 29 14.774024056590276
		 30 14.774024056590276 31 14.774024056590276 32 14.774024056590276;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX";
	rename -uid "B2FF28AD-484D-3DC4-6FC0-ACB9B142B6BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 24.715864181518555 1 24.702678680419922
		 2 24.665523529052734 3 24.60791015625 4 24.533416748046875 5 24.44563102722168 6 24.348148345947266
		 7 24.244667053222656 8 24.138875961303711 9 24.034482955932617 10 23.935178756713867
		 11 23.844581604003906 12 23.766342163085938 13 23.703994750976563 14 23.661079406738281
		 15 23.64106559753418 16 23.647407531738281 17 23.67765998840332 18 23.725214004516602
		 19 23.787330627441406 20 23.861293792724609 21 23.944427490234375 22 24.034076690673828
		 23 24.127655029296875 24 24.222600936889648 25 24.316308975219727 26 24.40618896484375
		 27 24.489585876464844 28 24.563854217529297 29 24.626312255859375 30 24.674274444580078
		 31 24.705013275146484 32 24.715864181518555;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY";
	rename -uid "4E073672-42EA-04A6-2542-71A9852CE8E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 16.697120666503906 1 16.707784652709961
		 2 16.711442947387695 3 16.707826614379883 4 16.696718215942383 5 16.677940368652344
		 6 16.65123176574707 7 16.616006851196289 8 16.572931289672852 9 16.524105072021484
		 10 16.471611022949219 11 16.417755126953125 12 16.36492919921875 13 16.315582275390625
		 14 16.272161483764648 15 16.237194061279297 16 16.213069915771484 17 16.199926376342773
		 18 16.196353912353516 19 16.202249526977539 20 16.21754264831543 21 16.242237091064453
		 22 16.276248931884766 23 16.318008422851563 24 16.365274429321289 25 16.41588020324707
		 26 16.467700958251953 27 16.518697738647461 28 16.566993713378906 29 16.610727310180664
		 30 16.648157119750977 31 16.677530288696289 32 16.697120666503906;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ";
	rename -uid "FF32592D-4C9A-7D4F-AF3C-D096AA9913AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -18.894672393798828 1 -18.865741729736328
		 2 -18.837337493896484 3 -18.811540603637695 4 -18.790407180786133 5 -18.775955200195313
		 6 -18.770265579223633 7 -18.776494979858398 8 -18.795129776000977 9 -18.824188232421875
		 10 -18.861654281616211 11 -18.905643463134766 12 -18.954261779785156 13 -19.005685806274414
		 14 -19.058164596557617 15 -19.109977722167969 16 -19.159439086914062 17 -19.204692840576172
		 18 -19.243692398071289 19 -19.274562835693359 20 -19.295303344726563 21 -19.303951263427734
		 22 -19.298557281494141 23 -19.279958724975586 24 -19.250370025634766 25 -19.211996078491211
		 26 -19.167083740234375 27 -19.117984771728516 28 -19.06707763671875 29 -19.016775131225586
		 30 -18.969614028930664 31 -18.928077697753906 32 -18.894672393798828;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotateX";
	rename -uid "8C273F4B-42E1-5733-F244-D0A3D1FF3D73";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -27.547062487968663 1 -27.562225264763502
		 2 -27.578237582128235 3 -27.594487707915857 4 -27.610348811797234 5 -27.625155948371258
		 6 -27.637942777095436 7 -27.646772289247359 8 -27.65070554347615 9 -27.649896107567447
		 10 -27.644323910614791 11 -27.633820677590681 12 -27.618313886743962 13 -27.59775289618289
		 14 -27.572241281844526 15 -27.542198651464567 16 -27.508302740507418 17 -27.472769843718101
		 18 -27.438706466872208 19 -27.408495893163177 20 -27.384277990790753 21 -27.368123745509333
		 22 -27.361712668121431 23 -27.364520020812414 24 -27.375075045152556 25 -27.39173615466099
		 26 -27.412789404019232 27 -27.436687591555113 28 -27.461821829696088 29 -27.48668064383147
		 30 -27.509938046717103 31 -27.53039980399728 32 -27.547062487968663;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotateY";
	rename -uid "90F9A3DF-4DEE-40F0-68DE-1C82549E0F8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 11.880890817468002 1 11.815772615254703
		 2 11.634360378724558 3 11.354021807549934 4 10.992108100775797 5 10.566125676314618
		 6 10.093633866451874 7 9.5923541603108156 8 9.0800301015227323 9 8.5742722754875658
		 10 8.0926818522881447 11 7.652831222827321 12 7.2722403419625659 13 6.9682809422170395
		 14 6.7582585146465179 15 6.6593910798012486 16 6.6888031174034186 17 6.8348017629633633
		 18 7.0653594540263658 19 7.3672476776291633 20 7.7273152442708497 21 8.1324253466045118
		 22 8.569547000804107 23 9.025884790655871 24 9.4886481684617667 25 9.9450675734945033
		 26 10.38230444150884 27 10.787471349775302 28 11.1476547756358 29 11.449974858226891
		 30 11.681542152631875 31 11.829504048363264 32 11.880890817468002;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotateZ";
	rename -uid "D1E623BB-4C73-1AB1-9DF8-70842146E01E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -12.963038391359419 1 -12.825813997716722
		 2 -12.694452572240735 3 -12.578517492218994 4 -12.487462884625039 5 -12.43093764749576
		 6 -12.418509360058016 7 -12.465343864253841 8 -12.573684523991995 9 -12.733610286379339
		 10 -12.935219184188878 11 -13.168544122283466 12 -13.423606270005173 13 -13.690450370538802
		 14 -13.959097523015382 15 -14.21965745232535 16 -14.462256687902467 17 -14.677901294934125
		 18 -14.858269964139474 19 -14.994560403400731 20 -15.077969744779759 21 -15.099731757745388
		 22 -15.051427130870326 23 -14.938406243080841 24 -14.772524690307245 25 -14.565596594195988
		 26 -14.329401677068965 27 -14.075812700874369 28 -13.816652122603072 29 -13.563835021212419
		 30 -13.329296486228166 31 -13.125027751738081 32 -12.963038391359419;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX";
	rename -uid "A966C09E-449A-F6D6-DE02-C2AB9F1F3924";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -20.892040252685547 1 -20.905948638916016
		 2 -20.942232131958008 3 -20.997528076171875 4 -21.068527221679687 5 -21.151882171630859
		 6 -21.244207382202148 7 -21.342033386230469 8 -21.441967010498047 9 -21.540691375732422
		 10 -21.634845733642578 11 -21.720947265625 12 -21.795501708984375 13 -21.854944229125977
		 14 -21.895698547363281 15 -21.914199829101563 16 -21.906888961791992 17 -21.876144409179688
		 18 -21.828533172607422 19 -21.766822814941406 20 -21.693807601928711 21 -21.612295150756836
		 22 -21.525075912475586 23 -21.434791564941406 24 -21.344051361083984 25 -21.255350112915039
		 26 -21.17119026184082 27 -21.093940734863281 28 -21.025970458984375 29 -20.969549179077148
		 30 -20.926944732666016 31 -20.900350570678711 32 -20.892040252685547;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY";
	rename -uid "D91B25F9-4ECD-69D9-8B0C-5C807FB7B4E9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 16.27276611328125 1 16.285903930664062
		 2 16.312419891357422 3 16.349754333496094 4 16.395221710205078 5 16.446281433105469
		 6 16.50042724609375 7 16.554924011230469 8 16.607688903808594 9 16.657146453857422
		 10 16.701784133911133 11 16.740150451660156 12 16.770858764648438 13 16.792642593383789
		 14 16.804206848144531 15 16.804317474365234 16 16.791574478149414 17 16.767585754394531
		 18 16.735866546630859 19 16.698070526123047 20 16.6558837890625 21 16.611032485961914
		 22 16.565170288085938 23 16.519433975219727 24 16.474685668945313 25 16.431798934936523
		 26 16.39179801940918 27 16.355617523193359 28 16.324501037597656 29 16.299430847167969
		 30 16.281669616699219 31 16.272397994995117 32 16.27276611328125;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ";
	rename -uid "73D4C24A-4BC1-1F79-4253-08A91E0E5947";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -29.705596923828125 1 -29.677021026611328
		 2 -29.647638320922852 3 -29.619623184204102 4 -29.595157623291016 5 -29.576419830322266
		 6 -29.565738677978516 7 -29.56651496887207 8 -29.579675674438477 9 -29.603584289550781
		 10 -29.636655807495117 11 -29.677244186401367 12 -29.723596572875977 13 -29.773908615112305
		 14 -29.826410293579102 15 -29.879135131835938 16 -29.930234909057617 17 -29.977546691894531
		 18 -30.018699645996094 19 -30.05164909362793 20 -30.074302673339844 21 -30.084663391113281
		 22 -30.080867767333984 23 -30.063955307006836 24 -30.036334991455078 25 -30.000385284423828
		 26 -29.958461761474609 27 -29.912830352783203 28 -29.865772247314453 29 -29.819381713867188
		 30 -29.775836944580078 31 -29.737220764160156 32 -29.705596923828125;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotateX";
	rename -uid "51204747-4FF9-7EAD-6CB8-51A6A0CC7AE1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 33.436239226325384 1 33.429451367129694
		 2 33.39972390077893 3 33.350212299945468 4 33.284403463057181 5 33.205844757081529
		 6 33.118206937844413 7 33.024903287350213 8 32.929563176641572 9 32.835895488912541
		 10 32.747230155744326 11 32.66645822679223 12 32.596314530751052 13 32.539237280895058
		 14 32.497573734719104 15 32.473612196843945 16 32.469921971828782 17 32.484704147567356
		 18 32.513548899544745 19 32.555220475242685 20 32.608560250305622 21 32.672605879234311
		 22 32.746288434403105 23 32.827795236363308 24 32.914649249794785 25 33.004188039829828
		 26 33.093447200514426 27 33.17916035290903 28 33.258128408372414 29 33.326740870194932
		 30 33.381584308759457 31 33.419182957565731 32 33.436239226325384;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotateY";
	rename -uid "7048D34D-4F55-0C98-07A3-698177013B9E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.3673872270574847 1 5.3011704363914163
		 2 5.1262815071878656 3 4.85927276191613 4 4.5165243565776425 5 4.1144252726945849
		 6 3.6693185299528004 7 3.1978101578928499 8 2.7160592444757952 9 2.2399511869281357
		 10 1.7856869074023076 11 1.3697329884797498 12 1.0088067495218671 13 0.71993075990315714
		 14 0.52022283831553928 15 0.42690249497093469 16 0.45715612422903101 17 0.600065079512762
		 18 0.82467000968332016 19 1.1180146815636609 20 1.4669560543406994 21 1.8583449118724416
		 22 2.2788380675666029 23 2.7155285927860628 24 3.1557942240004584 25 3.5871575353009351
		 26 3.9974825363315678 27 4.3748224450047939 28 4.7075697393607259 29 4.9843100550757748
		 30 5.1939404746670537 31 5.3253361932079972 32 5.3673872270574847;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotateZ";
	rename -uid "7DA46889-4BB6-94C2-A5F6-A7A48584FF63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.3509464089364664 1 3.4918586677521937
		 2 3.6326915218874061 3 3.7629614736775134 4 3.8722602308575875 5 3.9501795666651782
		 6 3.9863480462911918 7 3.964870436597522 8 3.8827110640320499 9 3.7487166356299806
		 10 3.5717836923146797 11 3.3608250715642938 12 3.1247822311673743 13 2.8725921845709856
		 14 2.6132604433459976 15 2.3558146991203333 16 2.1093160531925959 17 1.883455604428703
		 18 1.6884516710641315 19 1.5340428475983354 20 1.4301869371767162 21 1.3865635353642749
		 22 1.4126544234937639 23 1.5036836988091258 24 1.6481149466407132 25 1.8344556297604451
		 26 2.0511932218074751 27 2.286864451519 28 2.5300300838183127 29 2.7693374060003091
		 30 2.9934453532179779 31 3.1910511829098955 32 3.3509464089364664;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX";
	rename -uid "28535CF2-400A-817E-3F42-59B87ED37287";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 55.219429016113281 1 55.719440460205078
		 2 56.103755950927734 3 56.415195465087891 4 56.705722808837891 5 57.001609802246094
		 6 57.309436798095703 7 57.593425750732422 8 57.765876770019531 9 57.708782196044922
		 10 57.227748870849609 11 56.238231658935547 12 54.797763824462891 13 53.007080078125
		 14 51.006687164306641 15 48.966651916503906 16 47.073837280273438 17 45.496322631835937
		 18 44.369049072265625 19 43.807720184326172 20 43.71026611328125 21 43.913093566894531
		 22 44.410667419433594 23 45.177783966064453 24 46.166862487792969 25 47.32818603515625
		 26 48.605430603027344 27 49.936283111572266 28 51.256206512451172 29 52.501094818115234
		 30 53.61053466796875 31 54.531341552734375 32 55.219429016113281;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY";
	rename -uid "96D93E75-432B-6FB7-7F21-9AA5BE52F109";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 73.838279724121094 1 71.751502990722656
		 2 69.7266845703125 3 67.933441162109375 4 66.508544921875 5 65.541618347167969 6 65.136131286621094
		 7 65.356719970703125 8 66.199478149414063 9 67.651100158691406 10 69.624549865722656
		 11 71.914619445800781 12 74.320022583007813 13 76.661064147949219 14 78.79150390625
		 15 80.605400085449219 16 82.035537719726563 17 83.055763244628906 18 83.69573974609375
		 19 84.007522583007813 20 84.171524047851562 21 84.292884826660156 22 84.307861328125
		 23 84.175407409667969 24 83.884536743164062 25 83.407318115234375 26 82.718208312988281
		 27 81.799087524414063 28 80.641494750976563 29 79.248420715332031 30 77.633712768554688
		 31 75.820404052734375 32 73.838279724121094;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ";
	rename -uid "2CD2E1CB-4DF4-757E-C12C-4A804E5221F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -25.365570068359375 1 -26.70201301574707
		 2 -27.858505249023437 3 -28.690765380859375 4 -29.102643966674805 5 -29.086599349975586
		 6 -28.615047454833984 7 -27.688146591186523 8 -26.338817596435547 9 -24.601537704467773
		 10 -22.611831665039063 11 -20.55109977722168 12 -18.533596038818359 13 -16.661571502685547
		 14 -15.017057418823242 15 -13.656965255737305 16 -12.612428665161133 17 -11.889484405517578
		 18 -11.468303680419922 19 -11.287742614746094 20 -11.341508865356445 21 -11.669795989990234
		 22 -12.253047943115234 23 -13.066629409790039 24 -14.0723876953125 25 -15.241619110107422
		 26 -16.544097900390625 27 -17.948886871337891 28 -19.423978805541992 29 -20.936660766601563
		 30 -22.453933715820312 31 -23.941822052001953 32 -25.365570068359375;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotateX";
	rename -uid "4A49909D-47CF-6CC3-B360-AF8FAF90D643";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -68.573174686259634 1 -70.546440012389155
		 2 -72.697772491493382 3 -74.723528310634563 4 -76.377273478554713 5 -77.463994889865788
		 6 -77.788990908880947 7 -77.507845848434229 8 -76.978897080413589 9 -76.29235303537034
		 10 -75.505435859490333 11 -74.64076741878381 12 -73.69114224982799 13 -72.626230204274378
		 14 -71.40279463066328 15 -69.976197409308156 16 -69.471335244758507 17 -70.441662520305613
		 18 -71.989145472140251 19 -73.217573979159539 20 -73.225431416401037 21 -72.158547739469796
		 22 -70.895771632651886 23 -69.589282343471638 24 -68.328787281053039 25 -67.207893398645041
		 26 -66.305515343412637 27 -65.687996668521109 28 -65.411042111968996 29 -65.52183841504646
		 30 -66.061347945921341 31 -67.066589035102467 32 -68.573174686259634;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotateY";
	rename -uid "5B15B29F-4A96-86B8-83C8-B991D627FDAD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.5996289902213658 1 2.5245142174036053
		 2 1.3159042853407639 3 0.1377950567182088 4 -0.85785506620515584 5 -1.5735499905799148
		 6 -1.9007628603596634 7 -1.8027851053389126 8 -1.3216293716750931 9 -0.49032119410767322
		 10 0.63878457911808983 11 2.0005493650901474 12 3.5230070196884409 13 5.1307393449470986
		 14 6.7446512763198179 15 8.2798518872510254 16 9.4601661977160116 17 10.105826835127907
		 18 10.321625149639821 19 10.251119694229342 20 10.057728141642048 21 9.7694255697823742
		 22 9.3270100582457189 23 8.7854040700349731 24 8.2093925522184428 25 7.6416623492886639
		 26 7.1076330508161947 27 6.6128881246150408 28 6.1422266523359434 29 5.6608790858105795
		 30 5.1175835637137839 31 4.4512323089904324 32 3.5996289902213658;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotateZ";
	rename -uid "12C0E621-4A70-50C5-AB53-4BBF39F7813E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 74.728123050028046 1 72.648104978411567
		 2 70.068791402181219 3 67.227047288800719 4 64.277453385575427 5 61.274304240568128
		 6 58.300248947253841 7 55.47109673989808 8 52.902334541631575 9 50.684335383596547
		 10 48.903674109648634 11 47.639677317835599 12 46.963433584620638 13 46.939264257012105
		 14 47.626876036236695 15 49.083791478750875 16 51.333874163791691 17 54.158350787640771
		 18 57.268595129575253 19 60.423159750776513 20 63.416046717644228 21 66.156022843812266
		 22 68.657748999225859 23 70.885262362031128 24 72.835518221685064 25 74.486906305832193
		 26 75.811224045834678 27 76.773400964981406 28 77.333053654512554 29 77.447957346802795
		 30 77.076472658395417 31 76.181021567668836 32 74.728123050028046;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX";
	rename -uid "9EB7F492-47AD-C27D-70EA-4E9BCAE8591C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -38.0328369140625 1 -37.490253448486328
		 2 -36.976024627685547 3 -36.520652770996094 4 -36.151020050048828 5 -35.888576507568359
		 6 -35.745872497558594 7 -35.722240447998047 8 -35.772380828857422 9 -35.853324890136719
		 10 -35.95404052734375 11 -36.066448211669922 12 -36.189102172851563 13 -36.328533172607422
		 14 -36.563613891601563 15 -36.939132690429688 16 -37.418190002441406 17 -37.965877532958984
		 18 -38.539787292480469 19 -39.084072113037109 20 -39.531757354736328 21 -39.814048767089844
		 22 -39.976100921630859 23 -40.102153778076172 24 -40.181438446044922 25 -40.198047637939453
		 26 -40.137969970703125 27 -39.993564605712891 28 -39.760879516601562 29 -39.440521240234375
		 30 -39.038230895996094 31 -38.563991546630859 32 -38.0328369140625;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY";
	rename -uid "CE345B9D-4FCE-593D-18CC-E5B4A30E5CC0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 61.505538940429688 1 61.693878173828125
		 2 61.830352783203125 3 61.912811279296875 4 61.942771911621094 5 61.88836669921875
		 6 61.723358154296875 7 61.459846496582031 8 61.109260559082031 9 60.687297821044922
		 10 60.214103698730469 11 59.709651947021484 12 59.19586181640625 13 58.695236206054687
		 14 58.231689453125 15 57.826686859130859 16 57.498626708984375 17 57.264987945556641
		 18 57.145278930664063 19 57.138774871826172 20 57.224750518798828 21 57.395729064941406
		 22 57.645286560058594 23 57.96490478515625 24 58.343406677246094 25 58.765567779541016
		 26 59.214065551757813 27 59.672279357910156 28 60.122833251953125 29 60.547996520996094
		 30 60.930000305175781 31 61.253772735595703 32 61.505538940429688;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ";
	rename -uid "7FCF4815-46C3-823E-FF51-A5952C6B7281";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -45.163265228271484 1 -44.939739227294922
		 2 -44.675704956054688 3 -44.416996002197266 4 -44.212791442871094 5 -44.109298706054687
		 6 -44.113418579101563 7 -44.205394744873047 8 -44.363399505615234 9 -44.566928863525391
		 10 -44.801433563232422 11 -45.052387237548828 12 -45.307167053222656 13 -45.555259704589844
		 14 -45.793586730957031 15 -46.018104553222656 16 -46.220970153808594 17 -46.393341064453125
		 18 -46.520088195800781 19 -46.601409912109375 20 -46.647121429443359 21 -46.651653289794922
		 22 -46.6197509765625 23 -46.561920166015625 24 -46.478633880615234 25 -46.370658874511719
		 26 -46.239723205566406 27 -46.089160919189453 28 -45.922721862792969 29 -45.744354248046875
		 30 -45.557731628417969 31 -45.3642578125 32 -45.163265228271484;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotateX";
	rename -uid "7BAF0A3A-4F4E-5F1B-F2D0-32A8CB0A6F63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -72.202941469649659 1 -72.216790482283741
		 2 -72.254038482658544 3 -72.30846051224448 4 -72.372753944844987 5 -72.440175165517502
		 6 -72.504923897333427 7 -72.562707393287127 8 -72.61011022312951 9 -72.64648234352984
		 10 -72.67209401759979 11 -72.687997259806835 12 -72.696484023863363 13 -72.699122192630171
		 14 -72.697827731658663 15 -72.694092283396088 16 -72.687262656625691 17 -72.677030927331472
		 18 -72.662634370638926 19 -72.643292862753 20 -72.618815303922048 21 -72.588900877687266
		 22 -72.554161627253436 23 -72.514809983822062 24 -72.471493588110974 25 -72.425931543104198
		 26 -72.379820271222897 27 -72.334659740906389 28 -72.29279100877956 29 -72.256580408083394
		 30 -72.228048959365552 31 -72.209511513742171 32 -72.202941469649659;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotateY";
	rename -uid "18458F6A-4217-3C40-2603-399B9E2948D2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 62.223203636979527 1 62.203738449058314
		 2 62.14883280556144 3 62.063546299014945 4 61.95256481304051 5 61.82112138773627
		 6 61.674563436935657 7 61.519678300543994 8 61.363830675664587 9 61.21547192291397
		 10 61.083373215981986 11 60.977190294924419 12 60.906613536233117 13 60.881075654467068
		 14 60.893245160948531 15 60.927820985651209 16 60.981981530570685 17 61.052472201978361
		 18 61.136418749420002 19 61.230455751333309 20 61.331706684259231 21 61.437245494742193
		 22 61.544461489167929 23 61.650503180146359 24 61.753108283778246 25 61.85017213240392
		 26 61.939635067388828 27 62.019673106888696 28 62.088702844474611 29 62.14510414080209
		 30 62.187365398858844 31 62.21395997834184 32 62.223203636979527;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotateZ";
	rename -uid "0CA76AE9-4DD3-2D7C-4745-9694791743B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 174.63157829474684 1 174.49667525859971
		 2 174.1225810756886 3 173.55474932495326 4 172.83989642198958 5 172.02388466636185
		 6 171.15184871065671 7 170.2673821404301 8 169.41296722201852 9 168.6284973477712
		 10 167.95290482258707 11 167.42423240883113 12 167.07933634512887 13 166.95586442438284
		 14 167.01469827509186 15 167.18267488417584 16 167.44786973788828 17 167.79807210225326
		 18 168.22155603845979 19 168.70650492841358 20 169.24051419355416 21 169.81144781814916
		 22 170.40612265767035 23 171.01176826787272 24 171.61505119665316 25 172.2018867253301
		 26 172.7579550585435 27 173.26906700541321 28 173.72045424247898 29 174.09708750785461
		 30 174.38431971280488 31 174.56735805994396 32 174.63157829474684;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX";
	rename -uid "EBDAB4DA-45E5-6F7F-AEC9-FA927C672539";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 29.484222412109375 1 29.454963684082031
		 2 29.378608703613281 3 29.26243782043457 4 29.113651275634766 5 28.93951416015625
		 6 28.747079849243164 7 28.543666839599609 8 28.336166381835938 9 28.131372451782227
		 10 27.936138153076172 11 27.757453918457031 12 27.602472305297852 13 27.47845458984375
		 14 27.392742156982422 15 27.35276985168457 16 27.366001129150391 17 27.427726745605469
		 18 27.524728775024414 19 27.651397705078125 20 27.802112579345703 21 27.971168518066406
		 22 28.152790069580078 23 28.341361999511719 24 28.531429290771484 25 28.717582702636719
		 26 28.894618988037109 27 29.057357788085938 28 29.200773239135742 29 29.320009231567383
		 30 29.410181045532227 31 29.466516494750977 32 29.484222412109375;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY";
	rename -uid "A4C5B217-4831-7EB7-C6CB-948F9A451DC1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 28.016546249389648 1 28.002660751342773
		 2 27.987524032592773 3 27.972345352172852 4 27.958356857299805 5 27.946907043457031
		 6 27.939216613769531 7 27.937198638916016 8 27.941350936889648 9 27.951017379760742
		 10 27.965482711791992 11 27.983894348144531 12 28.00535774230957 13 28.028938293457031
		 14 28.053695678710938 15 28.078670501708984 16 28.102951049804688 17 28.125511169433594
		 18 28.145303726196289 19 28.161340713500977 20 28.172676086425781 21 28.178428649902344
		 22 28.177690505981445 23 28.170963287353516 24 28.159416198730469 25 28.144186019897461
		 26 28.126304626464844 27 28.10682487487793 28 28.086688995361328 29 28.066793441772461
		 30 28.047971725463867 31 28.030950546264648 32 28.016546249389648;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ";
	rename -uid "3CDEC650-4845-F0E1-FE7C-1A842446BC46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -8.7334280014038086 1 -8.6697444915771484
		 2 -8.6023960113525391 3 -8.5371456146240234 4 -8.4795122146606445 5 -8.4351186752319336
		 6 -8.4093723297119141 7 -8.4098978042602539 8 -8.4385366439819336 9 -8.4918079376220703
		 10 -8.5659942626953125 11 -8.6571664810180664 12 -8.7610378265380859 13 -8.8731603622436523
		 14 -8.9890375137329102 15 -9.1039896011352539 16 -9.2136001586914062 17 -9.3135499954223633
		 18 -9.3997211456298828 19 -9.4681491851806641 20 -9.5146560668945313 21 -9.5351266860961914
		 22 -9.5256767272949219 23 -9.4886751174926758 24 -9.4294967651367187 25 -9.3533344268798828
		 26 -9.2651700973510742 27 -9.1697006225585938 28 -9.0714635848999023 29 -8.9746313095092773
		 30 -8.8833551406860352 31 -8.8016080856323242 32 -8.7334280014038086;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotateX";
	rename -uid "AF4ADE0D-49A4-532B-1FC4-E690102E7218";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 0.87354158516072045 1 0.81741186598783822
		 2 0.69929144527968123 3 0.52962173951493785 4 0.31965708620401151 5 0.080920029236570767
		 6 -0.17448279817261683 7 -0.43309267870273049 8 -0.68335449890785172 9 -0.91622595694509346
		 10 -1.1234862044599028 11 -1.2976987266673847 12 -1.432356035418501 13 -1.5220492798716367
		 14 -1.5620589254113157 15 -1.5482634709236007 16 -1.4765871323633772 17 -1.3560482813228683
		 18 -1.2042119249631797 19 -1.0293163006575947 20 -0.83896817126591283 21 -0.64030795940702412
		 22 -0.44010160672508092 23 -0.24164414160681025 24 -0.047130263102162367 25 0.14048299474261455
		 26 0.31761184550809962 27 0.47988334300249441 28 0.62214537125668912 29 0.73883251944229789
		 30 0.82381852426940094 31 0.87085060013671256 32 0.87354158516072045;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotateY";
	rename -uid "9ABB3FF0-4E43-0BA8-AB30-51971A629419";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.1522122967478934 1 3.0876614876311392
		 2 2.9362826587635977 3 2.7127731495978065 4 2.4312772914709662 5 2.1061162317742603
		 6 1.7506914199478174 7 1.3790552029211753 8 1.0034074675341851 9 0.63509466610162835
		 10 0.28564675887071111 11 -0.03269664960643999 12 -0.30737145061669241 13 -0.52515499677646826
		 14 -0.67259826598760064 15 -0.73580460864674246 16 -0.70064674941469574 17 -0.57593808344771147
		 18 -0.38633008198445995 19 -0.14263295563220935 20 0.1440590861503358 21 0.46236497831816598
		 22 0.80058826710249964 23 1.1480079648686341 24 1.4946041454262811 25 1.8306835676482764
		 26 2.1470782725002362 27 2.4346307479608877 28 2.6849147266152298 29 2.8897606216342053
		 30 3.0410863399399441 31 3.1311931341212063 32 3.1522122967478934;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotateZ";
	rename -uid "956DE787-417A-97AC-D99B-AB8392005999";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -5.9889230526873432 1 -5.8385025291579229
		 2 -5.6930602829798458 3 -5.5657251376082195 4 -5.4687611046501425 5 -5.4151371038642075
		 6 -5.4168858270572606 7 -5.4915755912800801 8 -5.642065530349762 9 -5.8573148543371953
		 10 -6.125849013412223 11 -6.4343410060489177 12 -6.7680161355819433 13 -7.1115327954827743
		 14 -7.4490172603310354 15 -7.7638217328385153 16 -8.040245490517604 17 -8.2690500331056214
		 18 -8.4463331249759594 19 -8.5646876694957221 20 -8.6164100808871353 21 -8.5939855815921042
		 22 -8.4905965910190631 23 -8.3155510360107669 24 -8.0858211023236706 25 -7.817600105444229
		 26 -7.5259193944982465 27 -7.2247330756750943 28 -6.9268377907863368 29 -6.6437217563024626
		 30 -6.3861943047194885 31 -6.1644557602153833 32 -5.9889230526873432;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX";
	rename -uid "88E71987-41F2-9B88-C877-ED8289F9D0C2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -22.921699523925781 1 -22.944221496582031
		 2 -23.005252838134766 3 -23.098552703857422 4 -23.217994689941406 5 -23.357458114624023
		 6 -23.511020660400391 7 -23.672943115234375 8 -23.837656021118164 9 -23.999782562255859
		 10 -24.154062271118164 11 -24.295080184936523 12 -24.417566299438477 13 -24.516086578369141
		 14 -24.585124969482422 15 -24.619060516357422 16 -24.612056732177734 17 -24.567489624023438
		 18 -24.495195388793945 19 -24.399162292480469 20 -24.283355712890625 21 -24.152019500732422
		 22 -24.009323120117188 23 -23.859729766845703 24 -23.707584381103516 25 -23.55729866027832
		 26 -23.413251876831055 27 -23.279754638671875 28 -23.161199569702148 29 -23.061803817749023
		 30 -22.985923767089844 31 -22.937824249267578 32 -22.921699523925781;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY";
	rename -uid "C467D9B2-4D1A-7F69-1F23-89964FBE7AD7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 20.079841613769531 1 20.061372756958008
		 2 20.03380012512207 3 19.999755859375 4 19.961940765380859 5 19.92315673828125 6 19.886028289794922
		 7 19.853641510009766 8 19.827861785888672 9 19.809276580810547 10 19.79835319519043
		 11 19.795070648193359 12 19.799339294433594 13 19.81072998046875 14 19.828615188598633
		 15 19.852382659912109 16 19.881425857543945 17 19.91401481628418 18 19.947563171386719
		 19 19.980474472045898 20 20.011079788208008 21 20.037748336791992 22 20.058954238891602
		 23 20.074907302856445 24 20.086568832397461 25 20.094814300537109 26 20.100265502929688
		 27 20.103343963623047 28 20.104152679443359 29 20.10260009765625 30 20.098344802856445
		 31 20.090909957885742 32 20.079841613769531;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ";
	rename -uid "BFDB5025-42AA-9685-91BA-3BA2A7330E0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -14.359419822692871 1 -14.324174880981445
		 2 -14.284889221191406 3 -14.244911193847656 4 -14.207585334777832 5 -14.176239013671875
		 6 -14.154106140136719 7 -14.145617485046387 8 -14.152097702026367 9 -14.171937942504883
		 10 -14.203455924987793 11 -14.244811058044434 12 -14.294011116027832 13 -14.348998069763184
		 14 -14.407619476318359 15 -14.467723846435547 16 -14.527187347412109 17 -14.583530426025391
		 18 -14.633893966674805 19 -14.675841331481934 20 -14.70695972442627 21 -14.724782943725586
		 22 -14.727022171020508 23 -14.714778900146484 24 -14.690752029418945 25 -14.657567024230957
		 26 -14.617690086364746 27 -14.573478698730469 28 -14.527135848999023 29 -14.480636596679688
		 30 -14.435956001281738 31 -14.394922256469727 32 -14.359419822692871;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotateX";
	rename -uid "1691D3EF-48BB-78C0-0E87-DE88EFEE61C6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 14.171160470648916 1 14.135025774951297
		 2 14.011298435328131 3 13.81069580604901 4 13.543583170887803 5 13.22061071405181
		 6 12.852895359501638 7 12.451974566982384 8 12.030978372503281 9 11.604767345205627
		 10 11.188877612300002 11 10.799615083297677 12 10.453786545027082 13 10.168593621743995
		 14 9.9613758989324488 15 9.8491767739248246 16 9.8487694986933487 17 9.9508693738926883
		 18 10.1282946516334 19 10.369788854059017 20 10.664173317785377 21 11.000224363994768
		 22 11.367147858002902 23 11.752795136895628 24 12.144558498604891 25 12.530450806967108
		 26 12.898955498590627 27 13.23914026179529 28 13.540747682488416 29 13.794048858255847
		 30 13.989723571816025 31 14.118530381629947 32 14.171160470648916;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotateY";
	rename -uid "07235668-4836-9539-1A28-6399DD10683C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.3757090243135455 1 5.3311935490944471
		 2 5.2190084862620001 3 5.0515776419768397 4 4.8412125588630266 5 4.6000695758322854
		 6 4.339470962779405 7 4.0701338566969962 8 3.8017497557516728 9 3.5427586194892702
		 10 3.3010102919531401 11 3.0842214946638844 12 2.8994663139763013 13 2.7539473162707275
		 14 2.6550379699113735 15 2.6103850555160144 16 2.6285709493320408 17 2.7043639031711866
		 18 2.8230894683593344 19 2.9787975818400558 20 3.1656522034886736 21 3.3769845814426072
		 22 3.6063885153519104 23 3.8469363891640107 24 4.0924335870538142 25 4.3360676071139777
		 26 4.5709285764050804 27 4.7898904593574727 28 4.9852129848988174 29 5.1495259039329699
		 30 5.2746926586357059 31 5.3526141427561695 32 5.3757090243135455;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotateZ";
	rename -uid "6F1A46AB-450F-730F-4533-249014CD514C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 27.772025691839641 1 27.884115605336504
		 2 28.070339391515805 3 28.312768860546672 4 28.592739236909857 5 28.891818064992272
		 6 29.192471203416282 7 29.474582263447889 8 29.725075079002135 9 29.937370898248705
		 10 30.105485321469903 11 30.225588939695427 12 30.294145374532967 13 30.309302255172096
		 14 30.269856418564231 15 30.174794608155704 16 30.022531782558531 17 29.824533702432927
		 18 29.600882245424028 19 29.362654320017281 20 29.121234561542892 21 28.888005463188112
		 22 28.673795931767287 23 28.481013774289334 24 28.308227637270729 25 28.154460094582078
		 26 28.020214573759713 27 27.906395477769067 28 27.816213992737524 29 27.752696786545563
		 30 27.72079889261359 31 27.725587027099333 32 27.772025691839641;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX";
	rename -uid "73D43BCD-4014-7FC3-2F50-D4A8A848EF01";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 43.834789276123047 1 43.058738708496094
		 2 42.267532348632812 3 41.606391906738281 4 41.177825927734375 5 41.008255004882813
		 6 41.098960876464844 7 41.400978088378906 8 41.817539215087891 9 42.251941680908203
		 10 42.570903778076172 11 42.718475341796875 12 42.733711242675781 13 42.661476135253906
		 14 42.546615600585937 15 42.432540893554688 16 42.36187744140625 17 42.357101440429688
		 18 42.424758911132813 19 42.58135986328125 20 42.831996917724609 21 43.157615661621094
		 22 43.530921936035156 23 43.921211242675781 24 44.301239013671875 25 44.644821166992188
		 26 44.9267578125 27 45.12066650390625 28 45.198074340820312 29 45.129722595214844
		 30 44.889522552490234 31 44.459701538085938 32 43.834789276123047;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY";
	rename -uid "2D4EDEDB-4ABB-8F48-D650-429841B46403";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 64.382980346679688 1 63.412185668945313
		 2 62.734432220458984 3 62.380256652832031 4 62.364112854003906 5 62.687290191650391
		 6 63.365028381347656 7 64.391853332519531 8 65.717010498046875 9 67.282768249511719
		 10 68.978958129882813 11 70.704544067382813 12 72.410751342773438 13 74.050872802734375
		 14 75.572486877441406 15 76.915130615234375 16 78.010772705078125 17 78.797706604003906
		 18 79.257781982421875 19 79.4012451171875 20 79.243339538574219 21 78.776130676269531
		 22 77.996856689453125 23 76.941230773925781 24 75.685348510742187 25 74.288108825683594
		 26 72.804580688476562 27 71.28302001953125 28 69.764419555664063 29 68.283836364746094
		 30 66.87286376953125 31 65.562088012695312 32 64.382980346679688;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ";
	rename -uid "07F72042-4C2C-B6B8-AF46-669756BA076C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -42.11102294921875 1 -43.12109375 2 -43.954814910888672
		 3 -44.479526519775391 4 -44.631050109863281 5 -44.432247161865234 6 -43.895999908447266
		 7 -43.060127258300781 8 -41.986244201660156 9 -40.737651824951172 10 -39.469573974609375
		 11 -38.304271697998047 12 -37.248195648193359 13 -36.2977294921875 14 -35.449592590332031
		 15 -34.707149505615234 16 -34.0838623046875 17 -33.602100372314453 18 -33.284523010253906
		 19 -33.121238708496094 20 -33.121425628662109 21 -33.312744140625 22 -33.673141479492188
		 23 -34.173759460449219 24 -34.777843475341797 25 -35.466926574707031 26 -36.231925964355469
		 27 -37.070732116699219 28 -37.982292175292969 29 -38.960674285888672 30 -39.991641998291016
		 31 -41.051826477050781 32 -42.11102294921875;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotateX";
	rename -uid "097D0C34-4142-B9F2-49E2-44B0383AF5E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -66.508852947433368 1 -68.06136893918665
		 2 -69.241163590797811 3 -70.025332561221191 4 -70.416619639382986 5 -70.411421647532535
		 6 -69.999178458080195 7 -69.188454409659414 8 -68.026895818535351 9 -66.549755375518899
		 10 -64.789056923672433 11 -62.76506578008923 12 -60.511926349691791 13 -58.111531991911114
		 14 -55.701348694970761 15 -53.459374626075281 16 -51.574111178133734 17 -50.195419117625498
		 18 -49.364733042181975 19 -49.057922125296969 20 -49.137008024136378 21 -49.50501317627343
		 22 -50.178581253962982 23 -51.1363005280135 24 -52.315514622833618 25 -53.695170448699265
		 26 -55.262789334680313 27 -57.001128482163715 28 -58.877033718927528 29 -60.835997452589616
		 30 -62.807617755748282 31 -64.719168308124551 32 -66.508852947433368;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotateY";
	rename -uid "791DA870-4803-E2DA-60A4-9FA6CC0CDF1A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 25.030340499170933 1 21.910686856380554
		 2 18.233070270799708 3 14.388133888077038 4 10.687451387260307 5 7.3380381575616695
		 6 4.5455460938912688 7 2.4745246768763578 8 1.2370574397539269 9 0.9443664796488852
		 10 1.6553926760743343 11 3.1039558335290796 12 4.9010081621149375 13 6.7073916709651336
		 14 8.2817813430323177 15 9.5047309589082012 16 10.375374348525112 17 10.984013100508422
		 18 11.454287325596757 19 11.894920293766397 20 12.739689727791632 21 14.291721460601952
		 22 16.403480086828974 23 18.887384528863013 24 21.523973095915657 25 24.082913302914928
		 26 26.334229968790797 27 28.070919466830979 28 29.125131130180812 29 29.382202585286237
		 30 28.784550665546504 31 27.324556738062544 32 25.030340499170933;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotateZ";
	rename -uid "F9508818-4177-E2D0-A612-968FF7C48D3A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 55.789603606037545 1 52.36430517971371
		 2 49.318005061502404 3 46.834413569261976 4 45.000932685735791 5 43.816009582127428
		 6 43.30929966992489 7 43.511048768422512 8 44.454362723897333 9 46.231710147315347
		 10 48.994886019245392 11 52.709287906130037 12 57.192804283139502 13 62.216811969234989
		 14 67.508034663717751 15 72.755328557739574 16 77.622497925470384 17 81.773145622810532
		 18 84.907171771315149 19 86.785119415755602 20 87.690814481101853 21 88.000795936442543
		 22 87.648126314170341 23 86.593017328922386 24 84.851391997818936 25 82.44250457485721
		 26 79.416323561189571 27 75.864666275975551 28 71.921371636096197 29 67.756673724903521
		 30 63.560120929638977 31 59.517233674206288 32 55.789603606037545;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX";
	rename -uid "42F8ECE7-40CC-B7AE-377D-D69EFCFEADE8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -23.554662704467773 1 -23.145301818847656
		 2 -22.709087371826172 3 -22.255168914794922 4 -21.81634521484375 5 -21.49705696105957
		 6 -21.36815071105957 7 -21.426986694335938 8 -21.648479461669922 9 -21.992050170898438
		 10 -22.424518585205078 11 -22.921875 12 -23.460168838500977 13 -24.016714096069336
		 14 -24.605419158935547 15 -25.216367721557617 16 -25.798164367675781 17 -26.314081192016602
		 18 -26.728187561035156 19 -27.015068054199219 20 -27.16712760925293 21 -27.163145065307617
		 22 -27.04090690612793 23 -26.855947494506836 24 -26.607500076293945 25 -26.307662963867188
		 26 -25.969245910644531 27 -25.597253799438477 28 -25.199077606201172 29 -24.784467697143555
		 30 -24.365131378173828 31 -23.95195198059082 32 -23.554662704467773;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY";
	rename -uid "68C5911E-4195-022C-A7C2-2A8F5288443C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 78.33056640625 1 78.68798828125 2 78.882972717285156
		 3 78.901321411132813 4 78.744956970214844 5 78.473716735839844 6 78.127349853515625
		 7 77.710899353027344 8 77.246574401855469 9 76.746109008789063 10 76.214683532714844
		 11 75.663848876953125 12 75.10638427734375 13 74.556968688964844 14 74.028518676757812
		 15 73.539207458496094 16 73.11602783203125 17 72.782752990722656 18 72.543617248535156
		 19 72.406814575195313 20 72.390388488769531 21 72.503189086914062 22 72.751472473144531
		 23 73.123947143554687 24 73.590057373046875 25 74.133277893066406 26 74.736869812011719
		 27 75.377182006835937 28 76.030616760253906 29 76.674018859863281 30 77.285125732421875
		 31 77.843513488769531 32 78.33056640625;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ";
	rename -uid "1C71069A-41BA-A5CD-3497-AD87902FA816";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -47.756309509277344 1 -47.141159057617188
		 2 -46.931041717529297 3 -47.120597839355469 4 -47.622489929199219 5 -48.260570526123047
		 6 -48.972705841064453 7 -49.770679473876953 8 -50.650318145751953 9 -51.595664978027344
		 10 -52.570415496826172 11 -53.543994903564453 12 -54.486083984375 13 -55.365852355957031
		 14 -56.132125854492188 15 -56.747356414794922 16 -57.197994232177734 17 -57.477466583251953
		 18 -57.601631164550781 19 -57.585418701171875 20 -57.442592620849609 21 -57.194034576416016
		 22 -56.813217163085938 23 -56.265766143798828 24 -55.573169708251953 25 -54.7559814453125
		 26 -53.836570739746094 27 -52.836380004882813 28 -51.780994415283203 29 -50.701629638671875
		 30 -49.636127471923828 31 -48.634132385253906 32 -47.756309509277344;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotateX";
	rename -uid "15606A61-4284-5B13-42F4-E99E2B8FEB1F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -33.326013951059011 1 -32.82677884325291
		 2 -34.042723876263892 3 -36.802141968314075 4 -40.546194190637095 5 -44.220636572979458
		 6 -47.422702037448367 7 -50.254991177869734 8 -52.735994425808641 9 -54.961453598750424
		 10 -56.995041294380393 11 -58.82493709121907 12 -60.418033094897275 13 -61.718326569256263
		 14 -62.538901819307348 15 -62.746742059038368 16 -62.358860361424426 17 -61.456624673196551
		 18 -60.246126573805768 19 -58.87130153815108 20 -57.401593153737892 21 -55.944761011927859
		 22 -54.386783583428368 23 -52.587353439935711 24 -50.639849311713988 25 -48.560865599454594
		 26 -46.347071306967003 27 -44.037020824327158 28 -41.675308349784657 29 -39.319578958795105
		 30 -37.048777421033499 31 -34.989533857916243 32 -33.326013951059011;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotateY";
	rename -uid "B1E7B596-4BB1-2A3E-4827-BB9F2A52C31A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -49.506042491719754 1 -50.171721599385812
		 2 -50.402831345869856 3 -50.145765986875489 4 -49.409528294395464 5 -48.565191381469788
		 6 -47.866982034187281 7 -47.28223169124837 8 -46.846761733614784 9 -46.541891820843247
		 10 -46.310922940186593 11 -46.122417790647383 12 -45.943225672628451 13 -45.745670021580914
		 14 -45.492589824526497 15 -45.17509879679077 16 -44.825926217277825 17 -44.468250526919974
		 18 -44.047510161635458 19 -43.595354352319852 20 -43.24617563543125 21 -43.053564305430086
		 22 -43.060755737815455 23 -43.259309410434312 24 -43.582049892327923 25 -44.025199971541802
		 26 -44.592434948959614 27 -45.261318706519887 28 -46.012136782762077 29 -46.827632612070964
		 30 -47.693613893083558 31 -48.592083186856627 32 -49.506042491719754;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotateZ";
	rename -uid "EF5F6119-4442-2AEE-A27B-5984B63AF584";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 9.9752713684344698 1 8.5292986425563981
		 2 8.7922632854721421 3 10.563790497973033 4 13.244080623024773 5 15.984165140148363
		 6 18.594730108090285 7 21.218673731052665 8 23.969937422335274 9 26.892770126669411
		 10 29.899541834418656 11 32.926248926684607 12 35.885981741634808 13 38.663579878779039
		 14 40.97700102100476 15 42.607516304794757 16 43.513658147358377 17 43.709248781747306
		 18 43.303029018130346 19 42.420734889168131 20 41.224307439049852 21 39.891936379000654
		 22 38.312662504822242 23 36.283492585258074 24 33.862129125889965 25 31.138041205554345
		 26 28.195630160065818 27 25.082681731522992 28 21.85824235194697 29 18.600219847375424
		 30 15.413904693496594 31 12.462929090914056 32 9.9752713684344698;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX";
	rename -uid "9BF75EDA-47A5-84BB-E661-F0BC2E20B15B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 4.4547886848449707 1 4.4110312461853027
		 2 4.2878098487854004 3 4.0970931053161621 4 3.8508999347686768 5 3.5612170696258545
		 6 3.2400424480438232 7 2.8993523120880127 8 2.5510871410369873 9 2.2071602344512939
		 10 1.8794374465942383 11 1.5797548294067383 12 1.3199281692504883 13 1.111750602722168
		 14 0.96700716018676758 15 0.89748811721801758 16 0.91498720645904541 17 1.0117616653442383
		 18 1.1662768125534058 19 1.369715690612793 20 1.6132509708404541 21 1.8880796432495117
		 22 2.1853935718536377 23 2.4964115619659424 24 2.8123524188995361 25 3.1244137287139893
		 26 3.4237644672393799 27 3.7015464305877686 28 3.9488670825958252 29 4.1568036079406738
		 30 4.316401481628418 31 4.4187188148498535 32 4.4547886848449707;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY";
	rename -uid "E0108E29-40C0-7A06-9B19-98B1D252FA00";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 55.927516937255859 1 55.930995941162109
		 2 55.931987762451172 3 55.930629730224609 4 55.927089691162109 5 55.921504974365234
		 6 55.913982391357422 7 55.904392242431641 8 55.893001556396484 9 55.880474090576172
		 10 55.867412567138672 11 55.854320526123047 12 55.841632843017578 13 55.829738616943359
		 14 55.818958282470703 15 55.809627532958984 16 55.802097320556641 17 55.796543121337891
		 18 55.793018341064453 19 55.791759490966797 20 55.792980194091797 21 55.796932220458984
		 22 55.803806304931641 23 55.813381195068359 24 55.825214385986328 25 55.838794708251953
		 26 55.853565216064453 27 55.868885040283203 28 55.884044647216797 29 55.898296356201172
		 30 55.910839080810547 31 55.920841217041016 32 55.927516937255859;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ";
	rename -uid "54719FDC-4C7E-8E94-6CD6-F384108B4B87";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -23.088190078735352 1 -22.991628646850586
		 2 -22.897737503051758 3 -22.813325881958008 4 -22.745183944702148 5 -22.700096130371094
		 6 -22.684844970703125 7 -22.710111618041992 8 -22.777608871459961 9 -22.880691528320313
		 10 -23.012763977050781 11 -23.167276382446289 12 -23.337717056274414 13 -23.517612457275391
		 14 -23.700521469116211 15 -23.880002975463867 16 -24.049615859985352 17 -24.202875137329102
		 18 -24.333293914794922 19 -24.434362411499023 20 -24.499565124511719 21 -24.522369384765625
		 22 -24.49652099609375 23 -24.425464630126953 24 -24.317241668701172 25 -24.179910659790039
		 26 -24.021564483642578 27 -23.850336074829102 28 -23.674392700195313 29 -23.501951217651367
		 30 -23.34126091003418 31 -23.200580596923828 32 -23.088190078735352;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotateX";
	rename -uid "877E2B54-49F1-0E0D-CE0C-69AB340E4C23";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.73897985613616 1 2.054513303708315 2 2.2999774861757309
		 3 2.4512488083082813 4 2.4971019526316334 5 2.4446783559453422 6 2.2971683404060501
		 7 2.0627510956202633 8 1.7577738767763096 9 1.3977394434537931 10 0.99832497134589226
		 11 0.57536279472763674 12 0.14469254719527891 13 -0.27789785566305869 14 -0.67678952981110274
		 15 -1.0366339598369212 16 -1.3423266670841569 17 -1.5801027898917468 18 -1.7403911953157409
		 19 -1.8224019863894847 20 -1.8315150962188849 21 -1.7680952420974838 22 -1.632433765643811
		 23 -1.4300619988426286 24 -1.1725018132395677 25 -0.86893616334174351 26 -0.52873967055855853
		 27 -0.16143118773604373 28 0.22326518217077826 29 0.61551949848276422 30 1.0054569929972119
		 31 1.3832000112383567 32 1.73897985613616;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotateY";
	rename -uid "E3FFB914-40E9-61B2-71CF-1FBCFA494CD4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.8631274271089984 1 3.6839058272776075
		 2 3.5662747231771266 3 3.5142369778549538 4 3.5300963698139602 5 3.6128049779498213
		 6 3.762395806530233 7 3.9734906740822908 8 4.2330730139015582 9 4.5288918694954869
		 10 4.8487395840718817 11 5.180609874705703 12 5.5122490635867196 13 5.8316144755193999
		 14 6.1265642255001831 15 6.385164549840761 16 6.5952428011323496 17 6.7467902890404412
		 18 6.8368899009895774 19 6.8659337299149552 20 6.8350703799424872 21 6.7446625000423133
		 22 6.5951708619053777 23 6.3925127808151405 24 6.1487739757095445 25 5.8733587548785682
		 26 5.5758775363701902 27 5.2658772347326712 28 4.9528182163882875 29 4.6464223729864322
		 30 4.3563088220688782 31 4.0920147642648024 32 3.8631274271089984;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotateZ";
	rename -uid "23FD9D7F-4D70-6CB6-BA5C-748F39F4398D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 4.2524502324462174 1 4.3033860224251876
		 2 4.3460130906522751 3 4.3714741522081759 4 4.3757523948975257 5 4.3611993979197647
		 6 4.3309121454119373 7 4.2897384636838467 8 4.2437419412418835 9 4.1984033420304501
		 10 4.1583196046734514 11 4.1270674474962377 12 4.1064139049093757 13 4.0967597574606005
		 14 4.0969324809256751 15 4.1042163920882393 16 4.1151947718350055 17 4.1259479390135532
		 18 4.1335423157513 19 4.136086678647783 20 4.1323974780501516 21 4.1229215513165363
		 22 4.1088062915793868 23 4.0928604940134781 24 4.0786101222048998 25 4.0691073404317688
		 26 4.0668393939339618 27 4.0738050306557376 28 4.0911280601930224 29 4.1189566061435681
		 30 4.156426856566557 31 4.2018523579282707 32 4.2524502324462174;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX";
	rename -uid "3837F638-4061-0816-9C45-A78F33A86810";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 10.454872131347656 1 10.599505424499512
		 2 10.560226440429687 3 10.362335205078125 4 10.023296356201172 5 9.550501823425293
		 6 8.9527244567871094 7 8.2472400665283203 8 7.4650402069091797 9 6.635523796081543
		 10 5.7882938385009766 11 4.9533705711364746 12 4.1616230010986328 13 3.444493293762207
		 14 2.8343210220336914 15 2.3640761375427246 16 2.0673928260803223 17 1.9541230201721191
		 18 2.0023980140686035 19 2.2025313377380371 20 2.5480117797851562 21 3.0290894508361816
		 22 3.6353836059570312 23 4.345008373260498 24 5.1237955093383789 25 5.9427781105041504
		 26 6.7731485366821289 27 7.5865859985351562 28 8.3554477691650391 29 9.052647590637207
		 30 9.6518764495849609 31 10.127651214599609 32 10.454872131347656;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY";
	rename -uid "D7147519-4919-53BD-04AA-A094CCB6871D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 96.02032470703125 1 95.948524475097656
		 2 95.907302856445313 3 95.89349365234375 4 95.90582275390625 5 95.94610595703125
		 6 96.015045166015625 7 96.108848571777344 8 96.218841552734375 9 96.337631225585937
		 10 96.458564758300781 11 96.575927734375 12 96.684967041015625 13 96.782241821289063
		 14 96.865409851074219 15 96.933235168457031 16 96.985328674316406 17 97.021797180175781
		 18 97.043983459472656 19 97.05303955078125 20 97.04931640625 21 97.0322265625 22 96.999969482421875
		 23 96.951141357421875 24 96.8858642578125 25 96.80419921875 26 96.707199096679688
		 27 96.597190856933594 28 96.477836608886719 29 96.35406494140625 30 96.231903076171875
		 31 96.118209838867188 32 96.02032470703125;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ";
	rename -uid "35ED4E51-4B94-881B-CC2A-38AA863FB67D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -40.053054809570313 1 -39.952621459960937
		 2 -39.850570678710937 3 -39.762882232666016 4 -39.700241088867188 5 -39.665473937988281
		 6 -39.660560607910156 7 -39.691490173339844 8 -39.756999969482422 9 -39.847877502441406
		 10 -39.955795288085938 11 -40.073532104492188 12 -40.195556640625 13 -40.317642211914063
		 14 -40.43701171875 15 -40.552131652832031 16 -40.662136077880859 17 -40.766288757324219
		 18 -40.862190246582031 19 -40.945522308349609 20 -41.010398864746094 21 -41.04986572265625
		 22 -41.056663513183594 23 -41.030975341796875 24 -40.975936889648438 25 -40.895614624023438
		 26 -40.794296264648438 27 -40.676704406738281 28 -40.548057556152344 29 -40.414314270019531
		 30 -40.28216552734375 31 -40.158981323242188 32 -40.053054809570313;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotateX";
	rename -uid "1F3C9894-4607-33B5-AE4D-A99C9FF8A776";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 15.716828856794089 1 18.116997460061473
		 2 19.915911960344346 3 20.960260775325334 4 21.178544880886118 5 20.614617713065954
		 6 19.289259586841474 7 17.270029409485307 8 14.696986332723412 9 11.700738994807548
		 10 8.4108826196340161 11 4.9556844219673337 12 1.4623247328003826 13 -1.9437689043568349
		 14 -5.1384606797313808 15 -7.9990771944477856 16 -10.403806158392849 17 -12.242784986898432
		 18 -13.450984095091753 19 -14.023856871643844 20 -13.996007766085405 21 -13.370742609045495
		 22 -12.15021886328342 23 -10.383306237213347 24 -8.1710171092109931 25 -5.5928332231845443
		 26 -2.7294599168241991 27 0.33700071190966002 28 3.5227298100835998 29 6.7418532551535391
		 30 9.906744950288644 31 12.928372036485978 32 15.716828856794089;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotateY";
	rename -uid "F7ED9226-453A-168E-D1AC-72A943867A53";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -16.529707457917262 1 -16.708731066872591
		 2 -16.722758241893168 3 -16.612766574346033 4 -16.396398298066593 5 -16.060639160834906
		 6 -15.597851047873029 7 -15.013626014507601 8 -14.335444817339733 9 -13.587807886072147
		 10 -12.795401194641078 11 -11.983756183366772 12 -11.18015224422439 13 -10.41360695486536
		 14 -9.715746398264324 15 -9.1204451347030933 16 -8.6638950255981531 17 -8.3753469003362824
		 18 -8.2504893081820985 19 -8.2886883015316233 20 -8.4983247371631734 21 -8.877775365774033
		 22 -9.4235233126254379 23 -10.111233007284458 24 -10.89509070254663 25 -11.738458194434751
		 26 -12.605613881237103 27 -13.462349023705306 28 -14.27639588359701 29 -15.01745995363696
		 30 -15.657351493430427 31 -16.169793707096026 32 -16.529707457917262;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotateZ";
	rename -uid "71CB8033-4BD0-EF31-9076-968CCE5019FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -62.173589847002837 1 -62.409893013288553
		 2 -62.548620310936471 3 -62.604141270678639 4 -62.583682689151019 5 -62.480633121816034
		 6 -62.289122830210516 7 -62.013595974673528 8 -61.674273069346661 9 -61.288973184866883
		 10 -60.874420266583812 11 -60.446323853553906 12 -60.020013257572295 13 -59.609669025524695
		 14 -59.22900955470211 15 -58.891336968560914 16 -58.609222429135421 17 -58.394019965961498
		 18 -58.251347972472871 19 -58.182796685555857 20 -58.18743654737176 21 -58.266680189568355
		 22 -58.423354661508171 23 -58.654697961973355 24 -58.950608934118961 25 -59.302866963940083
		 26 -59.701046548623182 27 -60.132393235977609 28 -60.581417455682299 29 -61.030422214346963
		 30 -61.459621469378916 31 -61.847770217252823 32 -62.173589847002837;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX";
	rename -uid "D82DE813-46E7-4DF0-EC3E-E9A3818CAA2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 22.766918182373047 1 22.760932922363281
		 2 22.744384765625 3 22.718843460083008 4 22.685955047607422 5 22.647333145141602
		 6 22.60460090637207 7 22.55946159362793 8 22.51356315612793 9 22.468538284301758
		 10 22.425989151000977 11 22.387439727783203 12 22.35443115234375 13 22.328407287597656
		 14 22.310817718505859 15 22.303058624267578 16 22.306528091430664 17 22.320135116577148
		 18 22.341030120849609 19 22.36802864074707 20 22.399965286254883 21 22.435699462890625
		 22 22.474102020263672 23 22.514123916625977 24 22.554740905761719 25 22.594869613647461
		 26 22.633441925048828 27 22.669315338134766 28 22.701343536376953 29 22.72833251953125
		 30 22.749078750610352 31 22.762332916259766 32 22.766918182373047;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY";
	rename -uid "634FF8D9-4C5E-3A60-0AE1-64AA9F8733D8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 10.106935501098633 1 10.114956855773926
		 2 10.112122535705566 3 10.098873138427734 4 10.075737953186035 5 10.043272972106934
		 6 10.001910209655762 7 9.9517669677734375 8 9.8941249847412109 9 9.8316125869750977
		 10 9.7667741775512695 11 9.7023067474365234 12 9.6409330368041992 13 9.5853662490844727
		 14 9.5382900238037109 15 9.5024547576904297 16 9.4805002212524414 17 9.4722356796264648
		 18 9.4754638671875 19 9.4897689819335937 20 9.5147991180419922 21 9.5501985549926758
		 22 9.5955972671508789 23 9.6492099761962891 24 9.7085895538330078 25 9.7713356018066406
		 26 9.835052490234375 27 9.8973188400268555 28 9.9558610916137695 29 10.008345603942871
		 30 10.052525520324707 31 10.086140632629395 32 10.106935501098633;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ";
	rename -uid "D312F920-4AE8-24E3-30D8-9CB113065801";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -18.678243637084961 1 -18.665500640869141
		 2 -18.65275764465332 3 -18.640966415405273 4 -18.631057739257812 5 -18.623886108398437
		 6 -18.620368957519531 7 -18.621818542480469 8 -18.628398895263672 9 -18.639251708984375
		 10 -18.653491973876953 11 -18.670387268066406 12 -18.689207077026367 13 -18.709291458129883
		 14 -18.730068206787109 15 -18.75098991394043 16 -18.77154541015625 17 -18.790983200073242
		 18 -18.808296203613281 19 -18.822677612304687 20 -18.833198547363281 21 -18.838926315307617
		 22 -18.838916778564453 23 -18.833356857299805 24 -18.823040008544922 25 -18.808767318725586
		 26 -18.791378021240234 27 -18.771829605102539 28 -18.751110076904297 29 -18.730249404907227
		 30 -18.710409164428711 31 -18.692695617675781 32 -18.678243637084961;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotateX";
	rename -uid "989AF9EA-4929-30B7-6063-C69F9B987085";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.8540955838101003e-006 1 -4.638255284496674e-006
		 2 -6.7393336260683528e-006 3 1.0315537846001447e-005 4 2.1120011727871383e-006 5 1.2585244124756249e-005
		 6 2.9688174314416481e-006 7 4.4082678799867077e-006 8 7.4385686558819677e-006 9 1.3947059613287592e-005
		 10 -1.2306796598911483e-006 11 0 12 1.4042389695694193e-005 13 3.4055402456409105e-014
		 14 -8.6309074300121523e-006 15 -4.4849306525984142e-006 16 2.4421940202617044e-006
		 17 5.5078070832788852e-006 18 -4.4304493321439869e-006 19 1.1600695243058005e-005
		 20 -2.5026539269743036e-006 21 6.9462947760592851e-006 22 2.3080371139254335e-006
		 23 -9.2159960037091118e-006 24 8.9064510066882224e-006 25 5.5333046747583459e-006
		 26 5.1466771511903148e-006 27 1.4324255225556855e-005 28 1.9132073376127869e-005
		 29 -2.9688183259529228e-006 30 5.3544814954563217e-006 31 5.6772776993545311e-006
		 32 1.8540955838101005e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotateY";
	rename -uid "054046B1-4FC3-D3D4-AC98-6F8C8659FA68";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -29.162092739391419 1 -29.162111065484179
		 2 -29.162120829208135 3 -29.162133315847505 4 -29.162126061565797 5 -29.162132007758785
		 6 -29.162113681663804 7 -29.162134927489447 8 -29.162140159844622 9 -29.162099886932289
		 10 -29.162099886933103 11 -29.162092739391365 12 -29.162089422210908 13 -29.162097270753403
		 14 -29.162092739390054 15 -29.162092739391309 16 -29.162097270753172 17 -29.16212344538684
		 18 -29.162111065484172 19 -29.162108449304689 20 -29.162123445387184 21 -29.162142776022723
		 22 -29.162097971750306 23 -29.162097270753002 24 -29.162092739390751 25 -29.162113681663168
		 26 -29.162094654573519 27 -29.162108449303894 28 -29.162111065483504 29 -29.162118213029345
		 30 -29.162097971750569 31 -29.162073712298525 32 -29.162092739391419;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotateZ";
	rename -uid "077F14DC-4694-B6B9-2EB5-51A0ECF0626B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 3.0464449935309692e-006 1 1.4439339569808448e-005
		 2 3.2839590313102012e-006 3 -1.5916155168036905e-005 4 -4.3342434955222211e-006 5 -7.6847031442059407e-006
		 6 -1.4466522990552728e-006 7 6.7929680330100699e-006 8 -1.163903266112412e-005 9 -2.7458251669641184e-006
		 10 4.7310662120756953e-006 11 0 12 -6.8426033328541304e-006 13 6.1312216198261532e-006
		 14 1.2831370942314332e-005 15 -1.1168634166553187e-014 16 -7.692773944166723e-006
		 17 -7.6080387868742546e-006 18 1.7031841372123025e-005 19 -3.8998456104507769e-006
		 20 5.1359405174360997e-006 21 -9.7466032349962544e-006 22 4.6927353323857827e-006
		 23 1.5151456781062296e-006 24 -4.3399534857202835e-006 25 -1.1355438622548693e-005
		 26 3.9543277116028518e-006 27 -6.9799553540421667e-006 28 -2.3302169691277565e-006
		 29 1.4466529543121315e-006 30 6.5468301518526288e-006 31 -1.4768137507764659e-006
		 32 3.0464449935309692e-006;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX";
	rename -uid "DE4C3947-4147-5D8D-CF66-D0B660DFFC2F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -20.972171783447266 1 -20.978216171264648
		 2 -20.993600845336914 3 -21.016937255859375 4 -21.046878814697266 5 -21.082035064697266
		 6 -21.120975494384766 7 -21.16221809387207 8 -21.204313278198242 9 -21.245859146118164
		 10 -21.285449981689453 11 -21.321582794189453 12 -21.352773666381836 13 -21.377498626708984
		 14 -21.394224166870117 15 -21.401447296142578 16 -21.397663116455078 17 -21.383945465087891
		 18 -21.363162994384766 19 -21.336536407470703 20 -21.305295944213867 21 -21.270675659179688
		 22 -21.233869552612305 23 -21.195972442626953 24 -21.158079147338867 25 -21.121185302734375
		 26 -21.086332321166992 27 -21.054450988769531 28 -21.026512145996094 29 -21.003410339355469
		 30 -20.986072540283203 31 -20.975347518920898 32 -20.972171783447266;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY";
	rename -uid "2D62B289-4F97-006A-A734-2ABE7D9ABD69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 9.6221599578857422 1 9.6395111083984375
		 2 9.6702051162719727 3 9.7114601135253906 4 9.7604131698608398 5 9.8143081665039062
		 6 9.8703994750976562 7 9.9255046844482422 8 9.9774541854858398 9 10.024928092956543
		 10 10.066618919372559 11 10.101201057434082 12 10.127400398254395 13 10.143973350524902
		 14 10.14964485168457 15 10.143185615539551 16 10.123232841491699 17 10.091760635375977
		 18 10.052884101867676 19 10.008686065673828 20 9.9612751007080078 21 9.9128122329711914
		 22 9.8653526306152344 23 9.8200445175170898 24 9.7775545120239258 25 9.7385149002075195
		 26 9.7036857604980469 27 9.6736640930175781 28 9.6493206024169922 29 9.6312217712402344
		 30 9.6201820373535156 31 9.6169233322143555 32 9.6221599578857422;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ";
	rename -uid "7E6966BD-4D4A-8510-051D-F89698E382A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -31.448875427246094 1 -31.436643600463867
		 2 -31.423675537109375 3 -31.410909652709961 4 -31.399272918701172 5 -31.389707565307617
		 6 -31.383298873901367 7 -31.381574630737305 8 -31.385089874267578 9 -31.393213272094727
		 10 -31.405401229858398 11 -31.421070098876953 12 -31.439540863037109 13 -31.460105895996094
		 14 -31.482099533081055 15 -31.504669189453125 16 -31.527067184448242 17 -31.548248291015625
		 18 -31.566970825195313 19 -31.582298278808594 20 -31.593273162841797 21 -31.598987579345703
		 22 -31.598659515380859 23 -31.592727661132813 24 -31.58222770690918 25 -31.568168640136719
		 26 -31.551548004150391 27 -31.533302307128906 28 -31.514392852783203 29 -31.495626449584961
		 30 -31.4779052734375 31 -31.462055206298828 32 -31.448875427246094;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotateX";
	rename -uid "4F3D40E3-4EC2-1649-49D2-8081967E8084";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -4.0083898854991532e-006 1 2.0666917799493299e-006
		 2 -8.8520971856420931e-006 3 -2.6545120653455411e-005 4 6.7720181717592427e-006 5 -9.6720806796426168e-006
		 6 -1.3517504142002021e-005 7 8.6559627241791128e-015 8 -9.6720807799804558e-006 9 1.1811185556055826e-005
		 10 -1.2867046429490417e-005 11 -1.3271450985627461e-005 12 -1.8310494152502346e-014
		 13 -1.1745466449382205e-005 14 -9.4039546011035456e-006 15 1.0654713801949147e-014
		 16 -6.9083107284134846e-006 17 9.2654338562671307e-006 18 6.9216886256285805e-006
		 19 -2.3660493838279408e-006 20 2.9201309426679931e-006 21 -4.4193562415642522e-006
		 22 -9.6720807344780763e-006 23 -2.9029633292764447e-005 24 -1.0918787697766468e-005
		 25 -2.820517594539018e-005 26 -8.2957738329843694e-006 27 9.9491245855916829e-006
		 28 -1.3414443600621574e-005 29 7.9793626796794331e-006 30 -8.57281970351177e-006
		 31 -3.4012017567281552e-005 32 -4.0083898854991498e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotateY";
	rename -uid "8D14C4AF-4D46-7BB5-0938-A8846104E266";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 31.960586712642492 1 31.9606014569469
		 2 31.960586712641561 3 31.960559594121904 4 31.960571863587141 5 31.960586712642638
		 6 31.960585485978331 7 31.96057806145507 8 31.960578061454779 9 31.960571863584654
		 10 31.960603931786796 11 31.96058671264111 12 31.960581762958896 13 31.960613831150962
		 14 31.960564543814211 15 31.960580536296888 16 31.96058176295865 17 31.960584237799694
		 18 31.960557119284807 19 31.960595280598046 20 31.960552169598202 21 31.960574338430707
		 22 31.960581762958533 23 31.960605179954776 24 31.960575586612084 25 31.960570636918963
		 26 31.960595280597314 27 31.960558367471933 28 31.960601456944115 29 31.960596507262462
		 30 31.960579288115362 31 31.960594032407929 32 31.960586712642492;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotateZ";
	rename -uid "63CAFCB3-4F7C-94BA-9648-7690EFC105E1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -7.5724899171209145e-006 1 -8.2890810236921583e-006
		 2 -1.2304021522272435e-005 3 -2.1367234210011842e-005 4 1.9393235404683923e-006 5 5.995282946286877e-014
		 6 -7.155298372732755e-006 7 7.8757398227215328e-006 8 -1.063025851962407e-014 9 2.2313229648120952e-005
		 10 -6.8109912539638117e-006 11 -9.1291422401747813e-006 12 9.0498417096352753e-006
		 13 9.5683319041658007e-014 14 -1.1129916536553373e-005 15 -1.0778034325796582e-005
		 16 1.3977542870401674e-014 17 1.0646203472170735e-005 18 1.7967846560935193e-005
		 19 -2.3767979547827276e-005 20 2.5702835444964791e-005 21 3.1748780489555543e-006
		 22 1.9569465356905533e-014 23 -1.7638284169678341e-005 24 -4.0149387611524826e-006
		 25 -2.406286582096351e-005 26 -7.2601964914890205e-006 27 -3.1996137256465247e-014
		 28 -1.5830789745100072e-005 29 4.2237631977246286e-006 30 -8.2276276169927963e-006
		 31 -2.8834129790601056e-005 32 -7.572489917120917e-006;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX";
	rename -uid "36BB22A8-469F-5AC9-8A4F-0FB26FA91107";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 30.707778930664063 1 30.482284545898438
		 2 30.160917282104492 3 29.808406829833984 4 29.466053009033203 5 29.139270782470703
		 6 28.826568603515625 7 28.515480041503906 8 28.187519073486328 9 27.825218200683594
		 10 27.416292190551758 11 26.957330703735352 12 26.456766128540039 13 25.93614387512207
		 14 25.430425643920898 15 24.986461639404297 16 24.660356521606445 17 24.489376068115234
		 18 24.479404449462891 19 24.63768196105957 20 24.961933135986328 21 25.441263198852539
		 22 26.056276321411133 23 26.768686294555664 24 27.525136947631836 25 28.278648376464844
		 26 28.985803604125977 27 29.609096527099609 28 30.118520736694336 29 30.492351531982422
		 30 30.717422485351562 31 30.788715362548828 32 30.707778930664063;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY";
	rename -uid "56C22A16-465A-B114-C5B5-338D52D21F76";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 83.870162963867188 1 83.19085693359375
		 2 82.733871459960938 3 82.511611938476563 4 82.528121948242187 5 82.77813720703125
		 6 83.264923095703125 7 83.977310180664063 8 84.877235412597656 9 85.927680969238281
		 10 87.087593078613281 11 88.311737060546875 12 89.551193237304688 13 90.75567626953125
		 14 91.874954223632813 15 92.860977172851563 16 93.668693542480469 17 94.261573791503906
		 18 94.627738952636719 19 94.769943237304688 20 94.696517944335938 21 94.408363342285156
		 22 93.904350280761719 23 93.201248168945313 24 92.337562561035156 25 91.345001220703125
		 26 90.257827758789063 27 89.112823486328125 28 87.948539733886719 29 86.8043212890625
		 30 85.718994140625 31 84.729522705078125 32 83.870162963867188;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ";
	rename -uid "F023D8A7-4CC5-4C40-C916-85ACB012F9F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -39.518600463867188 1 -40.050849914550781
		 2 -40.456039428710938 3 -40.694721221923828 4 -40.753456115722656 5 -40.65411376953125
		 6 -40.407066345214844 7 -40.033077239990234 8 -39.557811737060547 9 -38.997936248779297
		 10 -38.372352600097656 11 -37.702548980712891 12 -37.012996673583984 13 -36.330280303955078
		 14 -35.682621002197266 15 -35.098987579345703 16 -34.608146667480469 17 -34.236667633056641
		 18 -34.003726959228516 19 -33.906742095947266 20 -33.927116394042969 21 -34.056831359863281
		 22 -34.2880859375 23 -34.611534118652344 24 -35.010581970214844 25 -35.473537445068359
		 26 -35.988422393798828 27 -36.543113708496094 28 -37.125675201416016 29 -37.724582672119141
		 30 -38.329170227050781 31 -38.929851531982422 32 -39.518600463867188;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotateX";
	rename -uid "9114D590-4D42-BEEB-F376-AEAC9668F078";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -40.821972570353402 1 -39.759671197641516
		 2 -38.396003754303692 3 -37.226912178219877 4 -36.611072350918931 5 -36.625714955500854
		 6 -37.199781859013207 7 -38.08457167406597 8 -38.937270981267353 9 -39.453402668107607
		 10 -39.155917722564951 11 -37.879585411681589 12 -35.871789168287584 13 -33.382063890099502
		 14 -30.651611278964211 15 -27.911525371415124 16 -25.382781337222589 17 -23.273456575172936
		 18 -21.762500220142378 19 -21.025924552518653 20 -21.116575846764075 21 -21.927580567000987
		 22 -23.389643959323028 23 -25.401616191048809 24 -27.825081904671492 25 -30.497556371751276
		 26 -33.230053740519985 27 -35.816794451513232 28 -38.057006700268502 29 -39.778362481770998
		 30 -40.854117628204285 31 -41.210048019617467 32 -40.821972570353402;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotateY";
	rename -uid "33E79A56-4339-64B0-2AE1-45B5D4A2F627";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 55.525189818450471 1 56.793927487487771
		 2 57.784153646627722 3 58.389053263018759 4 58.540349323253132 5 58.202151136768876
		 6 57.334285516223225 7 55.948297705899336 8 54.149108733012582 9 52.068285303480508
		 10 50.001239303707088 11 48.14581540498736 12 46.477209557989084 13 44.96476493083906
		 14 43.602484215032923 15 42.420338504492989 16 41.481956293875989 17 40.857113378147361
		 18 40.556904550456956 19 40.55283242857579 20 40.822908131433664 21 41.398868674892476
		 22 42.294542334071743 23 43.460562816966778 24 44.784902816067984 25 46.183899506971912
		 26 47.589623750803781 27 48.960975876444778 28 50.286723594481956 29 51.580389391194942
		 30 52.868954858534373 31 54.178979429300625 32 55.525189818450471;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotateZ";
	rename -uid "443756BA-49D6-5D6F-075D-79B313EEEB78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 11.171486706604401 1 13.719063350437123
		 2 16.119147153478785 3 17.78630013567026 4 18.318941238265072 5 17.657315011375793
		 6 15.869997198846981 7 13.220185925309595 8 10.102275336065489 9 6.8760964263831363
		 10 4.1411030504793933 11 2.1863530727082559 12 0.82784518054819944 13 -0.1115106315440247
		 14 -0.77998080956892457 15 -1.2866372983483965 16 -1.696490663797692 17 -2.0340013300046769
		 18 -2.2950457735466383 19 -2.5065792564998972 20 -2.5814876896133465 21 -2.4050095846976824
		 22 -2.0154497812614731 23 -1.4620027511392306 24 -0.79482338826701715 25 -0.023143570792402493
		 26 0.8751434801942668 27 1.9481478327773027 28 3.2512880187324855 29 4.8270389929789275
		 30 6.6905636800571653 31 8.822892381016965 32 11.171486706604401;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX";
	rename -uid "327DDBD5-4419-7CF5-6E18-A58AA755E0AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -11.652608871459961 1 -11.405168533325195
		 2 -11.354218482971191 3 -11.494967460632324 4 -11.824012756347656 5 -12.351144790649414
		 6 -13.071987152099609 7 -13.948294639587402 8 -14.922568321228027 9 -15.93975830078125
		 10 -16.947677612304687 11 -17.899038314819336 12 -18.752439498901367 13 -19.473609924316406
		 14 -20.034967422485352 15 -20.415084838867188 16 -20.597105026245117 17 -20.589372634887695
		 18 -20.425962448120117 19 -20.129011154174805 20 -19.718221664428711 21 -19.209140777587891
		 22 -18.613489151000977 23 -17.944217681884766 24 -17.21818733215332 25 -16.450029373168945
		 26 -15.655941009521484 27 -14.854721069335937 28 -14.068435668945313 29 -13.323192596435547
		 30 -12.649050712585449 31 -12.079771041870117 32 -11.652608871459961;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY";
	rename -uid "6EB7C078-40E5-1188-9559-54BBC3251483";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 97.652305603027344 1 98.111717224121094
		 2 98.435432434082031 3 98.597335815429688 4 98.587165832519531 5 98.4547119140625
		 6 98.228034973144531 7 97.899497985839844 8 97.481498718261719 9 96.986351013183594
		 10 96.429573059082031 11 95.830223083496094 12 95.210426330566406 13 94.5946044921875
		 14 94.008224487304688 15 93.4765625 16 93.024063110351563 17 92.66839599609375 18 92.405914306640625
		 19 92.237930297851563 20 92.178169250488281 21 92.236236572265625 22 92.421394348144531
		 23 92.726295471191406 24 93.125808715820313 25 93.60198974609375 26 94.136825561523438
		 27 94.712554931640625 28 95.31207275390625 29 95.919303894042969 30 96.519760131835938
		 31 97.1009521484375 32 97.652305603027344;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ";
	rename -uid "160B4175-4447-BFF3-9122-429DF1D0494D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -41.137847900390625 1 -40.532081604003906
		 2 -40.034664154052734 3 -39.699188232421875 4 -39.545875549316406 5 -39.548271179199219
		 6 -39.702945709228516 7 -40.009471893310547 8 -40.447284698486328 9 -40.989330291748047
		 10 -41.608909606933594 11 -42.279869079589844 12 -42.977088928222656 13 -43.676284790039062
		 14 -44.35443115234375 15 -44.989730834960937 16 -45.561386108398438 17 -46.050281524658203
		 18 -46.440849304199219 19 -46.717983245849609 20 -46.871425628662109 21 -46.891960144042969
		 22 -46.770072937011719 23 -46.512763977050781 24 -46.139892578125 25 -45.668148040771484
		 26 -45.114776611328125 27 -44.497753143310547 28 -43.835784912109375 29 -43.148471832275391
		 30 -42.456012725830078 31 -41.778888702392578 32 -41.137847900390625;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotateX";
	rename -uid "5C291833-4C1C-11BC-59B7-B79CB3A7BAC8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -2.8991694758536322 1 -3.1548588161587867
		 2 -2.4951449368536434 3 -1.0064071692324859 4 1.103838169489894 5 3.6871959256577944
		 6 6.7083931257502885 7 10.086014646516805 8 13.798495501344954 9 17.708136506448025
		 10 21.520657527575157 11 25.037854826576382 12 28.087098737773882 13 30.519373575664215
		 14 31.977303048839318 15 32.270137065745196 16 31.502215472012232 17 29.83997495846846
		 18 27.546144400637623 19 24.893338639344933 20 22.199743675042367 21 19.766586056759493
		 22 17.482767043178903 23 15.066013005176114 24 12.542154162125415 25 10.000563685926254
		 26 7.543769803838642 27 5.2095139057775386 28 3.0356795564314401 29 1.0657299109672609
		 30 -0.64557534583694365 31 -2.0097096452817182 32 -2.8991694758536322;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotateY";
	rename -uid "052626C0-4DE3-8FEF-C805-429D712A010B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 53.771911763662622 1 54.206368925323382
		 2 54.777700889308754 3 55.439559330221179 4 56.140271673197908 5 56.828447028165556
		 6 57.443618454466808 7 57.920911792447143 8 58.206394411842034 9 58.296776022637914
		 10 58.236301825814813 11 58.057891007815456 12 57.804020783235572 13 57.519104490960345
		 14 57.256237434778676 15 57.04523907471809 16 56.87739036776874 17 56.729171683559521
		 18 56.572241281089703 19 56.381054388372142 20 56.13983180878062 21 55.85620301989411
		 22 55.541543314218139 23 55.209461655354673 24 54.884842101088374 25 54.561630962545806
		 26 54.235022938978531 27 53.930463094920029 28 53.675128418001812 29 53.498555703780298
		 30 53.432905736744971 31 53.511957014898705 32 53.771911763662622;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotateZ";
	rename -uid "62C21D79-4AEA-CE1B-614C-DF866807B4FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 29.065959324826132 1 29.344949119592947
		 2 31.173555812354536 3 34.388128844840594 4 38.60599716933875 5 43.125122317524038
		 6 47.554390247012087 7 51.805446720948694 8 55.774933262166442 9 59.38802062795807
		 10 62.504719856620433 11 64.997918699641403 12 66.778811875646326 13 67.795056974868913
		 14 67.841796425889115 15 66.863812441372758 16 65.027840388478722 17 62.543758655345037
		 18 59.752022147576902 19 56.901840587883186 20 54.153458923891257 21 51.713592505318744
		 22 49.444489815340269 23 47.090234026388522 24 44.708721534935968 25 42.314560764197061
		 26 39.929175341925919 27 37.593704052976541 28 35.356041436503723 29 33.277802336718793
		 30 31.44115933323501 31 29.976462556279653 32 29.065959324826132;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX";
	rename -uid "791154CE-4D7B-82FD-B04D-E7B1DB31511E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 16.781784057617187 1 16.903362274169922
		 2 16.822685241699219 3 16.587369918823242 4 16.225557327270508 5 15.738243103027344
		 6 15.127246856689453 7 14.403270721435547 8 13.592301368713379 9 12.71806812286377
		 10 11.806125640869141 11 10.88469409942627 12 9.9851846694946289 13 9.1436252593994141
		 14 8.3995180130004883 15 7.7959837913513184 16 7.3787202835083008 17 7.1687917709350586
		 18 7.1485805511474609 19 7.3145084381103516 20 7.6686363220214844 21 8.2049503326416016
		 22 8.9084596633911133 23 9.7445392608642578 24 10.667642593383789 25 11.63858699798584
		 26 12.618991851806641 27 13.572040557861328 28 14.462937355041504 29 15.258411407470703
		 30 15.928342819213867 31 16.444923400878906 32 16.781784057617187;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY";
	rename -uid "DA0FB602-4EFF-F240-2BF0-19B927BA6183";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 103.02368927001953 1 102.7655029296875
		 2 102.58971405029297 3 102.49211883544922 4 102.47282409667969 5 102.53972625732422
		 6 102.70130920410156 7 102.95297241210937 8 103.27528381347656 9 103.64939117431641
		 10 104.05641174316406 11 104.47789764404297 12 104.89485168457031 13 105.29100799560547
		 14 105.65080261230469 15 105.96198272705078 16 106.21385192871094 17 106.39915466308594
		 18 106.51753234863281 19 106.57131195068359 20 106.56208801269531 21 106.48993682861328
		 22 106.35330200195312 23 106.15538787841797 24 105.90374755859375 25 105.60420989990234
		 26 105.26386260986328 27 104.89253234863281 28 104.50144195556641 29 104.10372924804687
		 30 103.71438598632812 31 103.34912872314453 32 103.02368927001953;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ";
	rename -uid "CF9BD420-4329-45C1-57A5-65AD0357B8E0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -51.999141693115234 1 -51.994224548339844
		 2 -51.967460632324219 3 -51.927078247070313 4 -51.87969970703125 5 -51.829780578613281
		 6 -51.779651641845703 7 -51.737480163574219 8 -51.706790924072266 9 -51.683292388916016
		 10 -51.663948059082031 11 -51.647247314453125 12 -51.633331298828125 13 -51.624259948730469
		 14 -51.622570037841797 15 -51.632007598876953 16 -51.656593322753906 17 -51.699058532714844
		 18 -51.759330749511719 19 -51.831062316894531 20 -51.903564453125 21 -51.967292785644531
		 22 -52.015804290771484 23 -52.049770355224609 24 -52.069503784179688 25 -52.076568603515625
		 26 -52.073261260986328 27 -52.061763763427734 28 -52.045097351074219 29 -52.026348114013672
		 30 -52.009269714355469 31 -51.99853515625 32 -51.999141693115234;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotateX";
	rename -uid "4BDAEAF0-4CB3-572C-9467-13A438E6F468";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 78.724101566856362 1 84.730401882181468
		 2 90.582001270436052 3 95.926321419530481 4 100.41004869355068 5 103.71958706020293
		 6 105.54221685984525 7 105.66129668847734 8 103.95949348533857 9 100.44530842246519
		 10 95.447840319328151 11 89.307276235318412 12 82.343742672492283 13 74.857648791758635
		 14 67.124857550056632 15 59.411188140905836 16 52.060962103821701 17 45.350231870097105
		 18 39.450504988373979 19 34.54212377790094 20 30.79783030400084 21 28.391853929517413
		 22 27.440264005236063 23 27.968986540798298 24 29.964706083313633 25 33.580219947666123
		 26 38.691950588658962 27 44.869015047980916 28 51.68662294880513 29 58.757787232234918
		 30 65.765138392452684 31 72.474689754654705 32 78.724101566856362;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotateY";
	rename -uid "CCED29FC-4A04-5654-00C4-52AF740A9B1F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 5.7611725769079678 1 8.0318096589067451
		 2 9.7158787879127058 3 10.612404141485481 4 10.677227146217707 5 10.039245068437879
		 6 8.8527157727779571 7 7.312730525515879 8 5.6353770279247373 9 3.9032748759608835
		 10 2.0375055250652681 11 -0.012524367612777089 12 -2.2529325204330357 13 -4.6148192405347279
		 14 -6.9303797166995063 15 -8.9417017426575196 16 -10.59041767971372 17 -11.89169285987308
		 18 -12.727306368103408 19 -13.109835933602087 20 -13.145759013560612 21 -12.94298322508404
		 22 -12.576888075651471 23 -12.083953216996251 24 -11.467653419843156 25 -10.644205400943292
		 26 -9.4714647647171599 27 -7.8218116419630599 28 -5.6420567562950188 29 -2.9810788991761799
		 30 -0.0049271930872573757 31 3.0229158569180856 32 5.7611725769079678;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotateZ";
	rename -uid "147D9B47-46A8-4E2E-15FB-EFB608ECA5B2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -98.007219351000529 1 -98.308321158441629
		 2 -98.16880416496727 3 -97.862416950294815 4 -97.597747548900827 5 -97.472078529193098
		 6 -97.526606489114926 7 -97.761040028621835 8 -98.171992166908282 9 -98.769205225840068
		 10 -99.446251866736304 11 -100.06713695047804 12 -100.48683018837592 13 -100.54784112717142
		 14 -100.10786468459266 15 -99.070774557265949 16 -97.333266578478273 17 -94.987580702435594
		 18 -92.293992706578791 19 -89.508090378053609 20 -86.863594084513807 21 -84.565752376413002
		 22 -82.809374726849896 23 -81.767867628712239 24 -81.605646550393786 25 -82.539550807887494
		 26 -84.452148401383795 27 -86.999231324624049 28 -89.833856633358366 29 -92.626973471129986
		 30 -95.078563880086875 31 -96.940190852044324 32 -98.007219351000529;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX";
	rename -uid "0ECFFE38-4419-0650-6B0E-2598B19BDBEB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 30.686017990112305 1 30.642263412475586
		 2 30.519039154052734 3 30.328325271606445 4 30.082130432128906 5 29.792448043823242
		 6 29.471273422241211 7 29.130582809448242 8 28.782318115234375 9 28.438390731811523
		 10 28.110668182373047 11 27.810985565185547 12 27.551158905029297 13 27.342981338500977
		 14 27.198238372802734 15 27.128719329833984 16 27.146219253540039 17 27.242992401123047
		 18 27.39750862121582 19 27.600946426391602 20 27.844482421875 21 28.11931037902832
		 22 28.416624069213867 23 28.727642059326172 24 29.043582916259766 25 29.355644226074219
		 26 29.654994964599609 27 29.932777404785156 28 30.180097579956055 29 30.388032913208008
		 30 30.547634124755859 31 30.649948120117188 32 30.686017990112305;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY";
	rename -uid "8EF2B125-4129-6EC6-97DF-4FA14DCD739E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 46.959793090820312 1 46.963272094726563
		 2 46.964263916015625 3 46.962905883789063 4 46.959365844726563 5 46.953781127929687
		 6 46.946258544921875 7 46.936668395996094 8 46.925277709960938 9 46.912750244140625
		 10 46.899688720703125 11 46.8865966796875 12 46.873908996582031 13 46.862014770507813
		 14 46.851234436035156 15 46.841903686523438 16 46.834373474121094 17 46.828819274902344
		 18 46.825294494628906 19 46.82403564453125 20 46.82525634765625 21 46.829208374023438
		 22 46.836082458496094 23 46.845657348632813 24 46.857490539550781 25 46.871070861816406
		 26 46.885841369628906 27 46.901161193847656 28 46.91632080078125 29 46.930572509765625
		 30 46.943115234375 31 46.953117370605469 32 46.959793090820312;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ";
	rename -uid "A9974742-4822-CA84-DA52-FBA124B1E2EC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -18.233959197998047 1 -18.137401580810547
		 2 -18.043506622314453 3 -17.959098815917969 4 -17.890953063964844 5 -17.845867156982422
		 6 -17.830615997314453 7 -17.855880737304688 8 -17.923377990722656 9 -18.026462554931641
		 10 -18.158535003662109 11 -18.313045501708984 12 -18.483486175537109 13 -18.663383483886719
		 14 -18.846290588378906 15 -19.025772094726563 16 -19.195384979248047 17 -19.348644256591797
		 18 -19.47906494140625 19 -19.580131530761719 20 -19.645336151123047 21 -19.668140411376953
		 22 -19.642292022705078 23 -19.571235656738281 24 -19.4630126953125 25 -19.325679779052734
		 26 -19.167335510253906 27 -18.996105194091797 28 -18.820163726806641 29 -18.647720336914062
		 30 -18.487030029296875 31 -18.346351623535156 32 -18.233959197998047;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotateX";
	rename -uid "B641B6FD-47B6-8C0D-0F17-10A9EA03E0C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -2.9091163371435718 1 -2.8619807070744727
		 2 -2.751452984892226 3 -2.5883451033257296 4 -2.383186664593441 5 -2.1462648832627678
		 6 -1.8875392168220013 7 -1.6170039717995563 8 -1.3435246777723733 9 -1.0752739297842813
		 10 -0.82075366725635801 11 -0.58868117618342986 12 -0.38808658788277595 13 -0.22834088770796052
		 14 -0.11901012428988726 15 -0.069984658265663954 16 -0.091658324297983346 17 -0.17802067159886245
		 18 -0.31212066615068423 19 -0.48649118635780353 20 -0.69348467696151339 21 -0.92506778828523428
		 22 -1.1726787458796384 23 -1.4283007234418548 24 -1.6841810913855741 25 -1.9328466123464638
		 26 -2.1670592808832798 27 -2.3799477875001034 28 -2.5649893703634392 29 -2.7161151918724267
		 30 -2.8275217109637962 31 -2.8936791358132972 32 -2.9091163371435718;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotateY";
	rename -uid "2FE7428F-4161-A8FF-037F-758A16241E4C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -1.1960880213368894 1 -1.2364684894583298
		 2 -1.3641525579505185 3 -1.5663581349224802 4 -1.8300247611353624 5 -2.1422769900892376
		 6 -2.489711335183499 7 -2.8596167199244951 8 -3.2383353863571589 9 -3.6121696222931385
		 10 -3.9676833468667674 11 -4.2918918125426213 12 -4.5723055334950198 13 -4.7967746643789226
		 14 -4.9533818139768169 15 -5.0304627582892341 16 -5.0164065885684064 17 -4.9195149138398948
		 18 -4.7623530818001383 19 -4.5537159294214717 20 -4.302350472808393 21 -4.0167617897561314
		 22 -3.7051990402723605 23 -3.376144418081497 24 -3.0384127845399718 25 -2.7010191605916805
		 26 -2.3735721992074277 27 -2.0658546521361085 28 -1.7881618955321912 29 -1.5513509605018569
		 30 -1.3662769656662546 31 -1.2441374705896664 32 -1.1960880213368894;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotateZ";
	rename -uid "23192136-4EAE-0A94-A16D-7A9E200AE04C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -8.7843760560603474 1 -8.684505286636897
		 2 -8.6024333838315776 3 -8.5418636081909334 4 -8.5069633973873007 5 -8.5018839539813609
		 6 -8.5311336465583807 7 -8.6044359366121075 8 -8.7216665917679634 9 -8.8734783189880755
		 10 -9.0511952263614752 11 -9.2467035952545817 12 -9.4528632478622878 13 -9.6629970604626578
		 14 -9.8706213417540134 15 -10.069720935454678 16 -10.253561312653828 17 -10.415506792122738
		 18 -10.548763575999315 19 -10.645784092114221 20 -10.699690262974887 21 -10.703396570255261
		 22 -10.65003414796128 23 -10.543300538893014 24 -10.391763560211492 25 -10.204484329240776
		 26 -9.9910978501565602 27 -9.7620442387036057 28 -9.5281887380500674 29 -9.3014165619522711
		 30 -9.0936112188382445 31 -8.9171965947035012 32 -8.7843760560603474;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX";
	rename -uid "746F755A-4DF7-5C04-0763-42A20C3AC5DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -18.593494415283203 1 -18.637243270874023
		 2 -18.760473251342773 3 -18.951181411743164 4 -19.197381973266602 5 -19.487058639526367
		 6 -19.808233261108398 7 -20.148929595947266 8 -20.497188568115234 9 -20.841121673583984
		 10 -21.168844223022461 11 -21.468526840209961 12 -21.728353500366211 13 -21.936531066894531
		 14 -22.081274032592773 15 -22.150793075561523 16 -22.13328742980957 17 -22.036520004272461
		 18 -21.881998062133789 19 -21.678565979003906 20 -21.435024261474609 21 -21.160202026367188
		 22 -20.862888336181641 23 -20.551870346069336 24 -20.235929489135742 25 -19.923868179321289
		 26 -19.624517440795898 27 -19.346729278564453 28 -19.099414825439453 29 -18.8914794921875
		 30 -18.73187255859375 31 -18.62956428527832 32 -18.593494415283203;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY";
	rename -uid "7B1E907D-4434-F5EE-BE18-DBA2A93481B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 40.0650634765625 1 40.06854248046875 2 40.069534301757812
		 3 40.06817626953125 4 40.06463623046875 5 40.059051513671875 6 40.051528930664063
		 7 40.041938781738281 8 40.030548095703125 9 40.018020629882813 10 40.004959106445313
		 11 39.991867065429687 12 39.979179382324219 13 39.96728515625 14 39.956504821777344
		 15 39.947174072265625 16 39.939643859863281 17 39.934089660644531 18 39.930564880371094
		 19 39.929306030273437 20 39.930526733398438 21 39.934478759765625 22 39.941352844238281
		 23 39.950927734375 24 39.962760925292969 25 39.976341247558594 26 39.991111755371094
		 27 40.006431579589844 28 40.021591186523438 29 40.035842895507813 30 40.048385620117188
		 31 40.058387756347656 32 40.0650634765625;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ";
	rename -uid "3662EDE4-4900-3EDF-88FF-5AAEFEB94A2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -20.052284240722656 1 -19.955724716186523
		 2 -19.861831665039063 3 -19.777421951293945 4 -19.709278106689453 5 -19.664190292358398
		 6 -19.64893913269043 7 -19.674205780029297 8 -19.741703033447266 9 -19.84478759765625
		 10 -19.976860046386719 11 -20.131370544433594 12 -20.301811218261719 13 -20.481708526611328
		 14 -20.664615631103516 15 -20.844097137451172 16 -21.013710021972656 17 -21.166969299316406
		 18 -21.297388076782227 19 -21.398456573486328 20 -21.463659286499023 21 -21.486465454101563
		 22 -21.460617065429688 23 -21.389560699462891 24 -21.281337738037109 25 -21.144004821777344
		 26 -20.985660552978516 27 -20.814430236816406 28 -20.63848876953125 29 -20.466045379638672
		 30 -20.305355072021484 31 -20.164676666259766 32 -20.052284240722656;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotateX";
	rename -uid "77515EBD-4076-7D04-5BEB-8B9D6276D669";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 -6.0811102127286443 1 -6.0209760091231441
		 2 -5.9156823653376458 3 -5.7749161177314106 4 -5.6071095260391273 5 -5.4204344675042364
		 6 -5.2223681995838671 7 -5.0211495837654736 8 -4.8224190335105996 9 -4.6297067439746904
		 10 -4.4476321306882021 11 -4.2824773076230338 12 -4.1411202551032504 13 -4.0318331346020857
		 14 -3.9637452965312545 15 -3.9463881855019869 16 -3.9899396623744767 17 -4.0891613594297089
		 18 -4.2279915689087222 19 -4.3984404311821379 20 -4.5919960897271226 21 -4.7989935084163333
		 22 -5.0097176694325043 23 -5.2156445041051089 24 -5.4104058525977683 25 -5.587920577338779
		 26 -5.7435028171075375 27 -5.8733695435038378 28 -5.9749736858979228 29 -6.0470280931753075
		 30 -6.0888596346017945 31 -6.1001781082851076 32 -6.0811102127286443;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotateY";
	rename -uid "C039CA65-495E-516D-D046-E69D29BE6A56";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 16.257346349072115 1 16.198320064382163
		 2 16.026413795023782 3 15.757714472807328 4 15.408658626815162 5 14.995788446702523
		 6 14.535977700474891 7 14.04652335339704 8 13.544983267529506 9 13.049055847625821
		 10 12.576660255368765 11 12.145023317789429 12 11.771790024038415 13 11.474004705156464
		 14 11.268532536165868 15 11.172000873647548 16 11.200579653185059 17 11.342392757619731
		 18 11.56581965058796 19 11.857872321151303 20 12.20554183602092 21 12.596529155901733
		 22 13.018397070854613 23 13.459420260973467 24 13.907482100300976 25 14.350563865571218
		 26 14.776359375658979 27 15.17232914744546 28 15.525925366906591 29 15.824123439695891
		 30 16.054134566547543 31 16.202921463860342 32 16.257346349072115;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotateZ";
	rename -uid "E4A8F7D3-47E4-5C12-FECF-2C858495D12A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 33 ".ktv[0:32]"  0 1.9767864701361908 1 2.1592780950663308
		 2 2.328105428984184 3 2.4718527872789884 4 2.5792775686425746 5 2.6392740060533826
		 6 2.6407317528399163 7 2.5649366650095731 8 2.4102473534237272 9 2.1907084756820243
		 10 1.9199116896115263 11 1.6108797312107728 12 1.2760040929787375 13 0.92742180791578555
		 14 0.57692108590199676 15 0.23615908230412208 16 -0.083174583498669866 17 -0.36937937149710387
		 18 -0.61093314513983554 19 -0.79569121260939846 20 -0.91119625411768812 21 -0.94493642766326758
		 22 -0.8846043446983366 23 -0.73621696434996586 24 -0.51459412463225451 25 -0.23480192219436366
		 26 0.087528536832041065 27 0.43634754230867512 28 0.79504508564242338 29 1.1462045749313581
		 30 1.4722412032182479 31 1.7551088672624908 32 1.9767864701361908;
	setAttr ".roti" 5;
createNode pairBlend -n "pairBlend1";
	rename -uid "78BE1A62-4133-AA21-3461-3BBF6C8E99F2";
createNode pairBlend -n "pairBlend2";
	rename -uid "E4451AF5-4507-5E4C-88DA-62BE3668F622";
createNode pairBlend -n "pairBlend3";
	rename -uid "A935C3B0-40A8-9811-0627-54A31305585E";
createNode pairBlend -n "pairBlend4";
	rename -uid "0B3E109F-4882-4225-FE96-848AE1EC4216";
createNode pairBlend -n "pairBlend5";
	rename -uid "6AC95362-4854-4766-C0AD-77BAF412FBE0";
createNode pairBlend -n "pairBlend6";
	rename -uid "AE5986D3-42F2-18AF-6F1E-F8BEF40F93F0";
createNode pairBlend -n "pairBlend7";
	rename -uid "261A42AD-4635-61A5-DAF2-6E8DC58D481C";
createNode pairBlend -n "pairBlend8";
	rename -uid "7EC1F214-46B1-C69B-A6EA-D3AFED0ECAA7";
createNode pairBlend -n "pairBlend9";
	rename -uid "4325EBB0-4641-F1F9-0C92-8EB187A98801";
createNode pairBlend -n "pairBlend10";
	rename -uid "3BF014CC-4186-17BC-1919-DF8A746C80A9";
createNode pairBlend -n "pairBlend11";
	rename -uid "76AB8910-42B2-7FD7-E707-FA80DDBAB555";
createNode pairBlend -n "pairBlend12";
	rename -uid "BFF3378F-4CB5-DB46-A4E5-C1880BB986A5";
createNode pairBlend -n "pairBlend13";
	rename -uid "E91F2EA3-4377-8477-F48D-58BEC6AF7845";
createNode pairBlend -n "pairBlend14";
	rename -uid "33A8ABD6-4877-EBBC-FB05-A9BABFA67928";
createNode pairBlend -n "pairBlend15";
	rename -uid "17365780-409F-51D9-D820-4CA574595F40";
createNode pairBlend -n "pairBlend16";
	rename -uid "C5276941-459C-ECE3-EEC8-A28AD5728AD5";
createNode pairBlend -n "pairBlend17";
	rename -uid "C88869DF-4C89-B3B1-F961-F78AE61D7717";
createNode pairBlend -n "pairBlend18";
	rename -uid "D416A5C3-4F45-B9D5-B6CE-78939A0B3A49";
createNode pairBlend -n "pairBlend19";
	rename -uid "5B9B5842-47F8-EC70-759B-14A11DB3F03D";
createNode pairBlend -n "pairBlend20";
	rename -uid "00EEBCB1-49CA-DFE6-1078-208ED9A1853B";
createNode pairBlend -n "pairBlend21";
	rename -uid "806B76B6-4E39-1E3F-055B-04AFC8F75CB3";
createNode pairBlend -n "pairBlend22";
	rename -uid "A505932B-4615-A7E3-05B9-48A502C6BF04";
createNode pairBlend -n "pairBlend23";
	rename -uid "30B4D1A6-46B0-2B47-2229-549DC21CA6AC";
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 25;
	setAttr ".unw" 25;
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :renderPartition;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 13 ".st";
	setAttr -cb on ".an";
	setAttr -cb on ".pt";
select -ne :renderGlobalsList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
select -ne :defaultShaderList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 15 ".s";
select -ne :postProcessList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -k on ".cch";
	setAttr -k on ".nds";
	setAttr -s 29 ".u";
select -ne :defaultRenderingList1;
	setAttr -s 4 ".r";
select -ne :defaultTextureList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 13 ".tx";
select -ne :initialShadingGroup;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro" yes;
select -ne :initialParticleSE;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro" yes;
select -ne :defaultRenderGlobals;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".macc";
	setAttr -k on ".macd";
	setAttr -k on ".macq";
	setAttr -k on ".mcfr";
	setAttr -cb on ".ifg";
	setAttr -k on ".clip";
	setAttr -k on ".edm";
	setAttr -k on ".edl";
	setAttr -cb on ".ren";
	setAttr -av -k on ".esr";
	setAttr -k on ".ors";
	setAttr -cb on ".sdf";
	setAttr -k on ".outf";
	setAttr -cb on ".imfkey";
	setAttr -k on ".gama";
	setAttr -k on ".an";
	setAttr -cb on ".ar";
	setAttr ".fs" 1;
	setAttr ".ef" 10;
	setAttr -av -k on ".bfs";
	setAttr -cb on ".me";
	setAttr -cb on ".se";
	setAttr -k on ".be";
	setAttr -cb on ".ep";
	setAttr -k on ".fec";
	setAttr -k on ".ofc";
	setAttr -cb on ".ofe";
	setAttr -cb on ".efe";
	setAttr -cb on ".oft";
	setAttr -cb on ".umfn";
	setAttr -cb on ".ufe";
	setAttr -cb on ".pff";
	setAttr -cb on ".peie";
	setAttr -cb on ".ifp";
	setAttr -k on ".comp";
	setAttr -k on ".cth";
	setAttr -k on ".soll";
	setAttr -k on ".rd";
	setAttr -k on ".lp";
	setAttr -k on ".sp";
	setAttr -k on ".shs";
	setAttr -k on ".lpr";
	setAttr -cb on ".gv";
	setAttr -cb on ".sv";
	setAttr -k on ".mm";
	setAttr -k on ".npu";
	setAttr -k on ".itf";
	setAttr -k on ".shp";
	setAttr -cb on ".isp";
	setAttr -k on ".uf";
	setAttr -k on ".oi";
	setAttr -k on ".rut";
	setAttr -av -k on ".mbf";
	setAttr -k on ".afp";
	setAttr -k on ".pfb";
	setAttr -cb on ".prm";
	setAttr -cb on ".pom";
	setAttr -cb on ".pfrm";
	setAttr -cb on ".pfom";
	setAttr -av -k on ".bll";
	setAttr -k on ".bls";
	setAttr -av -k on ".smv";
	setAttr -k on ".ubc";
	setAttr -k on ".mbc";
	setAttr -cb on ".mbt";
	setAttr -k on ".udbx";
	setAttr -k on ".smc";
	setAttr -k on ".kmv";
	setAttr -cb on ".isl";
	setAttr -cb on ".ism";
	setAttr -cb on ".imb";
	setAttr -k on ".rlen";
	setAttr -av -k on ".frts";
	setAttr -k on ".tlwd";
	setAttr -k on ".tlht";
	setAttr -k on ".jfc";
	setAttr -cb on ".rsb";
	setAttr -k on ".ope";
	setAttr -k on ".oppf";
	setAttr -cb on ".hbl";
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :hardwareRenderGlobals;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
	setAttr -k off ".fbfm";
	setAttr -k off -cb on ".ehql";
	setAttr -k off -cb on ".eams";
	setAttr -k off -cb on ".eeaa";
	setAttr -k off -cb on ".engm";
	setAttr -k off -cb on ".mes";
	setAttr -k off -cb on ".emb";
	setAttr -av -k off -cb on ".mbbf";
	setAttr -k off -cb on ".mbs";
	setAttr -k off -cb on ".trm";
	setAttr -k off -cb on ".tshc";
	setAttr -k off ".enpt";
	setAttr -k off -cb on ".clmt";
	setAttr -k off -cb on ".tcov";
	setAttr -k off -cb on ".lith";
	setAttr -k off -cb on ".sobc";
	setAttr -k off -cb on ".cuth";
	setAttr -k off -cb on ".hgcd";
	setAttr -k off -cb on ".hgci";
	setAttr -k off -cb on ".mgcs";
	setAttr -k off -cb on ".twa";
	setAttr -k off -cb on ".twz";
	setAttr -k on ".hwcc";
	setAttr -k on ".hwdp";
	setAttr -k on ".hwql";
select -ne :ikSystem;
	setAttr -s 2 ".sol";
connectAttr "RIGRN.phl[370]" "pairBlend15.itx1";
connectAttr "RIGRN.phl[371]" "pairBlend15.ity1";
connectAttr "RIGRN.phl[372]" "pairBlend15.itz1";
connectAttr "RIGRN.phl[373]" "pairBlend15.irx1";
connectAttr "RIGRN.phl[374]" "pairBlend15.iry1";
connectAttr "RIGRN.phl[375]" "pairBlend15.irz1";
connectAttr "RIGRN.phl[376]" "pairBlend18.itx1";
connectAttr "RIGRN.phl[377]" "pairBlend18.ity1";
connectAttr "RIGRN.phl[378]" "pairBlend18.itz1";
connectAttr "RIGRN.phl[379]" "pairBlend18.irx1";
connectAttr "RIGRN.phl[380]" "pairBlend18.iry1";
connectAttr "RIGRN.phl[381]" "pairBlend18.irz1";
connectAttr "RIGRN.phl[382]" "pairBlend9.itx1";
connectAttr "RIGRN.phl[383]" "pairBlend9.ity1";
connectAttr "RIGRN.phl[384]" "pairBlend9.itz1";
connectAttr "RIGRN.phl[385]" "pairBlend9.irx1";
connectAttr "RIGRN.phl[386]" "pairBlend9.iry1";
connectAttr "RIGRN.phl[387]" "pairBlend9.irz1";
connectAttr "RIGRN.phl[388]" "pairBlend10.itx1";
connectAttr "RIGRN.phl[389]" "pairBlend10.ity1";
connectAttr "RIGRN.phl[390]" "pairBlend10.itz1";
connectAttr "RIGRN.phl[391]" "pairBlend10.irx1";
connectAttr "RIGRN.phl[392]" "pairBlend10.iry1";
connectAttr "RIGRN.phl[393]" "pairBlend10.irz1";
connectAttr "RIGRN.phl[394]" "pairBlend11.itx1";
connectAttr "RIGRN.phl[395]" "pairBlend11.ity1";
connectAttr "RIGRN.phl[396]" "pairBlend11.itz1";
connectAttr "RIGRN.phl[397]" "pairBlend11.irx1";
connectAttr "RIGRN.phl[398]" "pairBlend11.iry1";
connectAttr "RIGRN.phl[399]" "pairBlend11.irz1";
connectAttr "RIGRN.phl[400]" "pairBlend2.itx1";
connectAttr "RIGRN.phl[401]" "pairBlend2.ity1";
connectAttr "RIGRN.phl[402]" "pairBlend2.itz1";
connectAttr "RIGRN.phl[403]" "pairBlend2.irx1";
connectAttr "RIGRN.phl[404]" "pairBlend2.iry1";
connectAttr "RIGRN.phl[405]" "pairBlend2.irz1";
connectAttr "RIGRN.phl[406]" "pairBlend3.itx1";
connectAttr "RIGRN.phl[407]" "pairBlend3.ity1";
connectAttr "RIGRN.phl[408]" "pairBlend3.itz1";
connectAttr "RIGRN.phl[409]" "pairBlend3.irx1";
connectAttr "RIGRN.phl[410]" "pairBlend3.iry1";
connectAttr "RIGRN.phl[411]" "pairBlend3.irz1";
connectAttr "RIGRN.phl[412]" "pairBlend4.itx1";
connectAttr "RIGRN.phl[413]" "pairBlend4.ity1";
connectAttr "RIGRN.phl[414]" "pairBlend4.itz1";
connectAttr "RIGRN.phl[415]" "pairBlend4.irx1";
connectAttr "RIGRN.phl[416]" "pairBlend4.iry1";
connectAttr "RIGRN.phl[417]" "pairBlend4.irz1";
connectAttr "RIGRN.phl[418]" "pairBlend16.itx1";
connectAttr "RIGRN.phl[419]" "pairBlend16.ity1";
connectAttr "RIGRN.phl[420]" "pairBlend16.itz1";
connectAttr "RIGRN.phl[421]" "pairBlend16.irx1";
connectAttr "RIGRN.phl[422]" "pairBlend16.iry1";
connectAttr "RIGRN.phl[423]" "pairBlend16.irz1";
connectAttr "RIGRN.phl[424]" "pairBlend20.itx1";
connectAttr "RIGRN.phl[425]" "pairBlend20.ity1";
connectAttr "RIGRN.phl[426]" "pairBlend20.itz1";
connectAttr "RIGRN.phl[427]" "pairBlend20.irx1";
connectAttr "RIGRN.phl[428]" "pairBlend20.iry1";
connectAttr "RIGRN.phl[429]" "pairBlend20.irz1";
connectAttr "RIGRN.phl[430]" "pairBlend1.itx1";
connectAttr "RIGRN.phl[431]" "pairBlend1.ity1";
connectAttr "RIGRN.phl[432]" "pairBlend1.itz1";
connectAttr "RIGRN.phl[433]" "pairBlend1.irx1";
connectAttr "RIGRN.phl[434]" "pairBlend1.iry1";
connectAttr "RIGRN.phl[435]" "pairBlend1.irz1";
connectAttr "RIGRN.phl[436]" "pairBlend19.itx1";
connectAttr "RIGRN.phl[437]" "pairBlend19.ity1";
connectAttr "RIGRN.phl[438]" "pairBlend19.itz1";
connectAttr "RIGRN.phl[439]" "pairBlend19.irx1";
connectAttr "RIGRN.phl[440]" "pairBlend19.iry1";
connectAttr "RIGRN.phl[441]" "pairBlend19.irz1";
connectAttr "RIGRN.phl[442]" "pairBlend12.itx1";
connectAttr "RIGRN.phl[443]" "pairBlend12.ity1";
connectAttr "RIGRN.phl[444]" "pairBlend12.itz1";
connectAttr "RIGRN.phl[445]" "pairBlend12.irx1";
connectAttr "RIGRN.phl[446]" "pairBlend12.iry1";
connectAttr "RIGRN.phl[447]" "pairBlend12.irz1";
connectAttr "RIGRN.phl[448]" "pairBlend13.itx1";
connectAttr "RIGRN.phl[449]" "pairBlend13.ity1";
connectAttr "RIGRN.phl[450]" "pairBlend13.itz1";
connectAttr "RIGRN.phl[451]" "pairBlend13.irx1";
connectAttr "RIGRN.phl[452]" "pairBlend13.iry1";
connectAttr "RIGRN.phl[453]" "pairBlend13.irz1";
connectAttr "RIGRN.phl[454]" "pairBlend14.itx1";
connectAttr "RIGRN.phl[455]" "pairBlend14.ity1";
connectAttr "RIGRN.phl[456]" "pairBlend14.itz1";
connectAttr "RIGRN.phl[457]" "pairBlend14.irx1";
connectAttr "RIGRN.phl[458]" "pairBlend14.iry1";
connectAttr "RIGRN.phl[459]" "pairBlend14.irz1";
connectAttr "RIGRN.phl[460]" "pairBlend5.itx1";
connectAttr "RIGRN.phl[461]" "pairBlend5.ity1";
connectAttr "RIGRN.phl[462]" "pairBlend5.itz1";
connectAttr "RIGRN.phl[463]" "pairBlend5.irx1";
connectAttr "RIGRN.phl[464]" "pairBlend5.iry1";
connectAttr "RIGRN.phl[465]" "pairBlend5.irz1";
connectAttr "RIGRN.phl[466]" "pairBlend6.itx1";
connectAttr "RIGRN.phl[467]" "pairBlend6.ity1";
connectAttr "RIGRN.phl[468]" "pairBlend6.itz1";
connectAttr "RIGRN.phl[469]" "pairBlend6.irx1";
connectAttr "RIGRN.phl[470]" "pairBlend6.iry1";
connectAttr "RIGRN.phl[471]" "pairBlend6.irz1";
connectAttr "RIGRN.phl[472]" "pairBlend7.itx1";
connectAttr "RIGRN.phl[473]" "pairBlend7.ity1";
connectAttr "RIGRN.phl[474]" "pairBlend7.itz1";
connectAttr "RIGRN.phl[475]" "pairBlend7.irx1";
connectAttr "RIGRN.phl[476]" "pairBlend7.iry1";
connectAttr "RIGRN.phl[477]" "pairBlend7.irz1";
connectAttr "RIGRN.phl[478]" "pairBlend17.itx1";
connectAttr "RIGRN.phl[479]" "pairBlend17.ity1";
connectAttr "RIGRN.phl[480]" "pairBlend17.itz1";
connectAttr "RIGRN.phl[481]" "pairBlend17.irx1";
connectAttr "RIGRN.phl[482]" "pairBlend17.iry1";
connectAttr "RIGRN.phl[483]" "pairBlend17.irz1";
connectAttr "RIGRN.phl[484]" "pairBlend8.itx1";
connectAttr "RIGRN.phl[485]" "pairBlend8.ity1";
connectAttr "RIGRN.phl[486]" "pairBlend8.itz1";
connectAttr "RIGRN.phl[487]" "pairBlend8.irx1";
connectAttr "RIGRN.phl[488]" "pairBlend8.iry1";
connectAttr "RIGRN.phl[489]" "pairBlend8.irz1";
connectAttr "RIGRN.phl[490]" "pairBlend21.itx1";
connectAttr "RIGRN.phl[491]" "pairBlend21.ity1";
connectAttr "RIGRN.phl[492]" "pairBlend21.itz1";
connectAttr "RIGRN.phl[493]" "pairBlend21.irx1";
connectAttr "RIGRN.phl[494]" "pairBlend21.iry1";
connectAttr "RIGRN.phl[495]" "pairBlend21.irz1";
connectAttr "RIGRN.phl[496]" "pairBlend22.itx1";
connectAttr "RIGRN.phl[497]" "pairBlend22.ity1";
connectAttr "RIGRN.phl[498]" "pairBlend22.itz1";
connectAttr "RIGRN.phl[499]" "pairBlend22.irx1";
connectAttr "RIGRN.phl[500]" "pairBlend22.iry1";
connectAttr "RIGRN.phl[501]" "pairBlend22.irz1";
connectAttr "RIGRN.phl[502]" "pairBlend23.itx1";
connectAttr "RIGRN.phl[503]" "pairBlend23.ity1";
connectAttr "RIGRN.phl[504]" "pairBlend23.itz1";
connectAttr "RIGRN.phl[505]" "pairBlend23.irx1";
connectAttr "RIGRN.phl[506]" "pairBlend23.iry1";
connectAttr "RIGRN.phl[507]" "pairBlend23.irz1";
connectAttr "HIKState2SK1.HipsSx" "RIGRN.phl[1]";
connectAttr "HIKState2SK1.HipsSy" "RIGRN.phl[2]";
connectAttr "HIKState2SK1.HipsSz" "RIGRN.phl[3]";
connectAttr "RIGRN.phl[4]" "kobold_overboss_anim_exportNode.ei[0].objects[0]";
connectAttr "pairBlend1.otx" "RIGRN.phl[5]";
connectAttr "pairBlend1.oty" "RIGRN.phl[6]";
connectAttr "pairBlend1.otz" "RIGRN.phl[7]";
connectAttr "RIGRN.phl[8]" "HIKState2SK1.HipsPGX";
connectAttr "pairBlend1.orx" "RIGRN.phl[9]";
connectAttr "pairBlend1.ory" "RIGRN.phl[10]";
connectAttr "pairBlend1.orz" "RIGRN.phl[11]";
connectAttr "RIGRN.phl[12]" "HIKState2SK1.HipsROrder";
connectAttr "RIGRN.phl[13]" "HIKState2SK1.HipsPreR";
connectAttr "RIGRN.phl[14]" "HIKState2SK1.HipsSC";
connectAttr "RIGRN.phl[15]" "HIKState2SK1.HipsIS";
connectAttr "RIGRN.phl[16]" "Character1.Hips";
connectAttr "RIGRN.phl[17]" "HIKState2SK1.HipsPostR";
connectAttr "RIGRN.phl[18]" "HIKState2SK1.SpineIS";
connectAttr "HIKState2SK1.SpineSx" "RIGRN.phl[19]";
connectAttr "HIKState2SK1.SpineSy" "RIGRN.phl[20]";
connectAttr "HIKState2SK1.SpineSz" "RIGRN.phl[21]";
connectAttr "RIGRN.phl[22]" "HIKState2SK1.SpinePGX";
connectAttr "pairBlend8.otx" "RIGRN.phl[23]";
connectAttr "pairBlend8.oty" "RIGRN.phl[24]";
connectAttr "pairBlend8.otz" "RIGRN.phl[25]";
connectAttr "pairBlend8.orx" "RIGRN.phl[26]";
connectAttr "pairBlend8.ory" "RIGRN.phl[27]";
connectAttr "pairBlend8.orz" "RIGRN.phl[28]";
connectAttr "RIGRN.phl[29]" "HIKState2SK1.SpineROrder";
connectAttr "RIGRN.phl[30]" "HIKState2SK1.SpinePreR";
connectAttr "RIGRN.phl[31]" "HIKState2SK1.SpineSC";
connectAttr "RIGRN.phl[32]" "Character1.Spine";
connectAttr "RIGRN.phl[33]" "HIKState2SK1.SpinePostR";
connectAttr "RIGRN.phl[34]" "HIKState2SK1.Spine1IS";
connectAttr "HIKState2SK1.Spine1Sx" "RIGRN.phl[35]";
connectAttr "HIKState2SK1.Spine1Sy" "RIGRN.phl[36]";
connectAttr "HIKState2SK1.Spine1Sz" "RIGRN.phl[37]";
connectAttr "RIGRN.phl[38]" "HIKState2SK1.Spine1PGX";
connectAttr "pairBlend21.otx" "RIGRN.phl[39]";
connectAttr "pairBlend21.oty" "RIGRN.phl[40]";
connectAttr "pairBlend21.otz" "RIGRN.phl[41]";
connectAttr "pairBlend21.orx" "RIGRN.phl[42]";
connectAttr "pairBlend21.ory" "RIGRN.phl[43]";
connectAttr "pairBlend21.orz" "RIGRN.phl[44]";
connectAttr "RIGRN.phl[45]" "HIKState2SK1.Spine1ROrder";
connectAttr "RIGRN.phl[46]" "HIKState2SK1.Spine1PreR";
connectAttr "RIGRN.phl[47]" "HIKState2SK1.Spine1SC";
connectAttr "RIGRN.phl[48]" "Character1.Spine1";
connectAttr "RIGRN.phl[49]" "HIKState2SK1.Spine1PostR";
connectAttr "RIGRN.phl[50]" "HIKState2SK1.Spine2IS";
connectAttr "HIKState2SK1.Spine2Sx" "RIGRN.phl[51]";
connectAttr "HIKState2SK1.Spine2Sy" "RIGRN.phl[52]";
connectAttr "HIKState2SK1.Spine2Sz" "RIGRN.phl[53]";
connectAttr "RIGRN.phl[54]" "HIKState2SK1.Spine2PGX";
connectAttr "pairBlend22.otx" "RIGRN.phl[55]";
connectAttr "pairBlend22.oty" "RIGRN.phl[56]";
connectAttr "pairBlend22.otz" "RIGRN.phl[57]";
connectAttr "pairBlend22.orx" "RIGRN.phl[58]";
connectAttr "pairBlend22.ory" "RIGRN.phl[59]";
connectAttr "pairBlend22.orz" "RIGRN.phl[60]";
connectAttr "RIGRN.phl[61]" "HIKState2SK1.Spine2ROrder";
connectAttr "RIGRN.phl[62]" "HIKState2SK1.Spine2PreR";
connectAttr "RIGRN.phl[63]" "HIKState2SK1.Spine2SC";
connectAttr "RIGRN.phl[64]" "Character1.Spine2";
connectAttr "RIGRN.phl[65]" "HIKState2SK1.Spine2PostR";
connectAttr "RIGRN.phl[66]" "HIKState2SK1.Spine3IS";
connectAttr "HIKState2SK1.Spine3Sx" "RIGRN.phl[67]";
connectAttr "HIKState2SK1.Spine3Sy" "RIGRN.phl[68]";
connectAttr "HIKState2SK1.Spine3Sz" "RIGRN.phl[69]";
connectAttr "RIGRN.phl[70]" "HIKState2SK1.Spine3PGX";
connectAttr "pairBlend23.otx" "RIGRN.phl[71]";
connectAttr "pairBlend23.oty" "RIGRN.phl[72]";
connectAttr "pairBlend23.otz" "RIGRN.phl[73]";
connectAttr "pairBlend23.orx" "RIGRN.phl[74]";
connectAttr "pairBlend23.ory" "RIGRN.phl[75]";
connectAttr "pairBlend23.orz" "RIGRN.phl[76]";
connectAttr "RIGRN.phl[77]" "HIKState2SK1.Spine3ROrder";
connectAttr "RIGRN.phl[78]" "HIKState2SK1.Spine3PreR";
connectAttr "RIGRN.phl[79]" "HIKState2SK1.Spine3SC";
connectAttr "RIGRN.phl[80]" "Character1.Spine3";
connectAttr "RIGRN.phl[81]" "HIKState2SK1.Spine3PostR";
connectAttr "RIGRN.phl[82]" "HIKState2SK1.NeckIS";
connectAttr "HIKState2SK1.NeckSx" "RIGRN.phl[83]";
connectAttr "HIKState2SK1.NeckSy" "RIGRN.phl[84]";
connectAttr "HIKState2SK1.NeckSz" "RIGRN.phl[85]";
connectAttr "RIGRN.phl[86]" "HIKState2SK1.NeckPGX";
connectAttr "pairBlend20.otx" "RIGRN.phl[87]";
connectAttr "pairBlend20.oty" "RIGRN.phl[88]";
connectAttr "pairBlend20.otz" "RIGRN.phl[89]";
connectAttr "pairBlend20.orx" "RIGRN.phl[90]";
connectAttr "pairBlend20.ory" "RIGRN.phl[91]";
connectAttr "pairBlend20.orz" "RIGRN.phl[92]";
connectAttr "RIGRN.phl[93]" "HIKState2SK1.NeckROrder";
connectAttr "RIGRN.phl[94]" "HIKState2SK1.NeckPreR";
connectAttr "RIGRN.phl[95]" "HIKState2SK1.NeckSC";
connectAttr "RIGRN.phl[96]" "Character1.Neck";
connectAttr "RIGRN.phl[97]" "HIKState2SK1.NeckPostR";
connectAttr "RIGRN.phl[98]" "HIKState2SK1.HeadIS";
connectAttr "HIKState2SK1.HeadSx" "RIGRN.phl[99]";
connectAttr "HIKState2SK1.HeadSy" "RIGRN.phl[100]";
connectAttr "HIKState2SK1.HeadSz" "RIGRN.phl[101]";
connectAttr "RIGRN.phl[102]" "HIKState2SK1.HeadPGX";
connectAttr "pairBlend15.otx" "RIGRN.phl[103]";
connectAttr "pairBlend15.oty" "RIGRN.phl[104]";
connectAttr "pairBlend15.otz" "RIGRN.phl[105]";
connectAttr "pairBlend15.orx" "RIGRN.phl[106]";
connectAttr "pairBlend15.ory" "RIGRN.phl[107]";
connectAttr "pairBlend15.orz" "RIGRN.phl[108]";
connectAttr "RIGRN.phl[109]" "HIKState2SK1.HeadROrder";
connectAttr "RIGRN.phl[110]" "HIKState2SK1.HeadPreR";
connectAttr "RIGRN.phl[111]" "HIKState2SK1.HeadSC";
connectAttr "RIGRN.phl[112]" "Character1.Head";
connectAttr "RIGRN.phl[113]" "HIKState2SK1.HeadPostR";
connectAttr "RIGRN.phl[114]" "HIKState2SK1.LeftShoulderIS";
connectAttr "HIKState2SK1.LeftShoulderSx" "RIGRN.phl[115]";
connectAttr "HIKState2SK1.LeftShoulderSy" "RIGRN.phl[116]";
connectAttr "HIKState2SK1.LeftShoulderSz" "RIGRN.phl[117]";
connectAttr "RIGRN.phl[118]" "HIKState2SK1.LeftShoulderPGX";
connectAttr "pairBlend18.otx" "RIGRN.phl[119]";
connectAttr "pairBlend18.oty" "RIGRN.phl[120]";
connectAttr "pairBlend18.otz" "RIGRN.phl[121]";
connectAttr "pairBlend18.orx" "RIGRN.phl[122]";
connectAttr "pairBlend18.ory" "RIGRN.phl[123]";
connectAttr "pairBlend18.orz" "RIGRN.phl[124]";
connectAttr "RIGRN.phl[125]" "HIKState2SK1.LeftShoulderROrder";
connectAttr "RIGRN.phl[126]" "HIKState2SK1.LeftShoulderPreR";
connectAttr "RIGRN.phl[127]" "HIKState2SK1.LeftShoulderSC";
connectAttr "RIGRN.phl[128]" "Character1.LeftShoulder";
connectAttr "RIGRN.phl[129]" "HIKState2SK1.LeftShoulderPostR";
connectAttr "RIGRN.phl[130]" "HIKState2SK1.LeftArmIS";
connectAttr "HIKState2SK1.LeftArmSx" "RIGRN.phl[131]";
connectAttr "HIKState2SK1.LeftArmSy" "RIGRN.phl[132]";
connectAttr "HIKState2SK1.LeftArmSz" "RIGRN.phl[133]";
connectAttr "pairBlend9.otx" "RIGRN.phl[134]";
connectAttr "pairBlend9.oty" "RIGRN.phl[135]";
connectAttr "pairBlend9.otz" "RIGRN.phl[136]";
connectAttr "RIGRN.phl[137]" "HIKState2SK1.LeftArmPGX";
connectAttr "pairBlend9.orx" "RIGRN.phl[138]";
connectAttr "pairBlend9.ory" "RIGRN.phl[139]";
connectAttr "pairBlend9.orz" "RIGRN.phl[140]";
connectAttr "RIGRN.phl[141]" "HIKState2SK1.LeftArmROrder";
connectAttr "RIGRN.phl[142]" "HIKState2SK1.LeftArmPreR";
connectAttr "RIGRN.phl[143]" "HIKState2SK1.LeftArmSC";
connectAttr "RIGRN.phl[144]" "Character1.LeftArm";
connectAttr "RIGRN.phl[145]" "HIKState2SK1.LeftArmPostR";
connectAttr "RIGRN.phl[146]" "HIKState2SK1.LeftForeArmIS";
connectAttr "HIKState2SK1.LeftForeArmSx" "RIGRN.phl[147]";
connectAttr "HIKState2SK1.LeftForeArmSy" "RIGRN.phl[148]";
connectAttr "HIKState2SK1.LeftForeArmSz" "RIGRN.phl[149]";
connectAttr "pairBlend10.otx" "RIGRN.phl[150]";
connectAttr "pairBlend10.oty" "RIGRN.phl[151]";
connectAttr "pairBlend10.otz" "RIGRN.phl[152]";
connectAttr "RIGRN.phl[153]" "HIKState2SK1.LeftForeArmPGX";
connectAttr "pairBlend10.orx" "RIGRN.phl[154]";
connectAttr "pairBlend10.ory" "RIGRN.phl[155]";
connectAttr "pairBlend10.orz" "RIGRN.phl[156]";
connectAttr "RIGRN.phl[157]" "HIKState2SK1.LeftForeArmROrder";
connectAttr "RIGRN.phl[158]" "HIKState2SK1.LeftForeArmPreR";
connectAttr "RIGRN.phl[159]" "HIKState2SK1.LeftForeArmSC";
connectAttr "RIGRN.phl[160]" "Character1.LeftForeArm";
connectAttr "RIGRN.phl[161]" "HIKState2SK1.LeftForeArmPostR";
connectAttr "RIGRN.phl[162]" "HIKState2SK1.LeftHandIS";
connectAttr "HIKState2SK1.LeftHandSx" "RIGRN.phl[163]";
connectAttr "HIKState2SK1.LeftHandSy" "RIGRN.phl[164]";
connectAttr "HIKState2SK1.LeftHandSz" "RIGRN.phl[165]";
connectAttr "RIGRN.phl[166]" "HIKState2SK1.LeftHandPGX";
connectAttr "pairBlend11.otx" "RIGRN.phl[167]";
connectAttr "pairBlend11.oty" "RIGRN.phl[168]";
connectAttr "pairBlend11.otz" "RIGRN.phl[169]";
connectAttr "pairBlend11.orx" "RIGRN.phl[170]";
connectAttr "pairBlend11.ory" "RIGRN.phl[171]";
connectAttr "pairBlend11.orz" "RIGRN.phl[172]";
connectAttr "RIGRN.phl[173]" "HIKState2SK1.LeftHandROrder";
connectAttr "RIGRN.phl[174]" "HIKState2SK1.LeftHandPreR";
connectAttr "RIGRN.phl[175]" "HIKState2SK1.LeftHandSC";
connectAttr "RIGRN.phl[176]" "Character1.LeftHand";
connectAttr "RIGRN.phl[177]" "HIKState2SK1.LeftHandPostR";
connectAttr "RIGRN.phl[178]" "HIKState2SK1.RightShoulderIS";
connectAttr "HIKState2SK1.RightShoulderSx" "RIGRN.phl[179]";
connectAttr "HIKState2SK1.RightShoulderSy" "RIGRN.phl[180]";
connectAttr "HIKState2SK1.RightShoulderSz" "RIGRN.phl[181]";
connectAttr "RIGRN.phl[182]" "HIKState2SK1.RightShoulderPGX";
connectAttr "pairBlend19.otx" "RIGRN.phl[183]";
connectAttr "pairBlend19.oty" "RIGRN.phl[184]";
connectAttr "pairBlend19.otz" "RIGRN.phl[185]";
connectAttr "pairBlend19.orx" "RIGRN.phl[186]";
connectAttr "pairBlend19.ory" "RIGRN.phl[187]";
connectAttr "pairBlend19.orz" "RIGRN.phl[188]";
connectAttr "RIGRN.phl[189]" "HIKState2SK1.RightShoulderROrder";
connectAttr "RIGRN.phl[190]" "HIKState2SK1.RightShoulderPreR";
connectAttr "RIGRN.phl[191]" "HIKState2SK1.RightShoulderSC";
connectAttr "RIGRN.phl[192]" "Character1.RightShoulder";
connectAttr "RIGRN.phl[193]" "HIKState2SK1.RightShoulderPostR";
connectAttr "RIGRN.phl[194]" "HIKState2SK1.RightArmIS";
connectAttr "HIKState2SK1.RightArmSx" "RIGRN.phl[195]";
connectAttr "HIKState2SK1.RightArmSy" "RIGRN.phl[196]";
connectAttr "HIKState2SK1.RightArmSz" "RIGRN.phl[197]";
connectAttr "pairBlend12.otx" "RIGRN.phl[198]";
connectAttr "pairBlend12.oty" "RIGRN.phl[199]";
connectAttr "pairBlend12.otz" "RIGRN.phl[200]";
connectAttr "RIGRN.phl[201]" "HIKState2SK1.RightArmPGX";
connectAttr "pairBlend12.orx" "RIGRN.phl[202]";
connectAttr "pairBlend12.ory" "RIGRN.phl[203]";
connectAttr "pairBlend12.orz" "RIGRN.phl[204]";
connectAttr "RIGRN.phl[205]" "HIKState2SK1.RightArmROrder";
connectAttr "RIGRN.phl[206]" "HIKState2SK1.RightArmPreR";
connectAttr "RIGRN.phl[207]" "HIKState2SK1.RightArmSC";
connectAttr "RIGRN.phl[208]" "Character1.RightArm";
connectAttr "RIGRN.phl[209]" "HIKState2SK1.RightArmPostR";
connectAttr "RIGRN.phl[210]" "HIKState2SK1.RightForeArmIS";
connectAttr "HIKState2SK1.RightForeArmSx" "RIGRN.phl[211]";
connectAttr "HIKState2SK1.RightForeArmSy" "RIGRN.phl[212]";
connectAttr "HIKState2SK1.RightForeArmSz" "RIGRN.phl[213]";
connectAttr "pairBlend13.otx" "RIGRN.phl[214]";
connectAttr "pairBlend13.oty" "RIGRN.phl[215]";
connectAttr "pairBlend13.otz" "RIGRN.phl[216]";
connectAttr "RIGRN.phl[217]" "HIKState2SK1.RightForeArmPGX";
connectAttr "pairBlend13.orx" "RIGRN.phl[218]";
connectAttr "pairBlend13.ory" "RIGRN.phl[219]";
connectAttr "pairBlend13.orz" "RIGRN.phl[220]";
connectAttr "RIGRN.phl[221]" "HIKState2SK1.RightForeArmROrder";
connectAttr "RIGRN.phl[222]" "HIKState2SK1.RightForeArmPreR";
connectAttr "RIGRN.phl[223]" "HIKState2SK1.RightForeArmSC";
connectAttr "RIGRN.phl[224]" "Character1.RightForeArm";
connectAttr "RIGRN.phl[225]" "HIKState2SK1.RightForeArmPostR";
connectAttr "RIGRN.phl[226]" "HIKState2SK1.RightHandIS";
connectAttr "HIKState2SK1.RightHandSx" "RIGRN.phl[227]";
connectAttr "HIKState2SK1.RightHandSy" "RIGRN.phl[228]";
connectAttr "HIKState2SK1.RightHandSz" "RIGRN.phl[229]";
connectAttr "RIGRN.phl[230]" "HIKState2SK1.RightHandPGX";
connectAttr "pairBlend14.otx" "RIGRN.phl[231]";
connectAttr "pairBlend14.oty" "RIGRN.phl[232]";
connectAttr "pairBlend14.otz" "RIGRN.phl[233]";
connectAttr "pairBlend14.orx" "RIGRN.phl[234]";
connectAttr "pairBlend14.ory" "RIGRN.phl[235]";
connectAttr "pairBlend14.orz" "RIGRN.phl[236]";
connectAttr "RIGRN.phl[237]" "HIKState2SK1.RightHandROrder";
connectAttr "RIGRN.phl[238]" "HIKState2SK1.RightHandPreR";
connectAttr "RIGRN.phl[239]" "HIKState2SK1.RightHandSC";
connectAttr "RIGRN.phl[240]" "Character1.RightHand";
connectAttr "RIGRN.phl[241]" "HIKState2SK1.RightHandPostR";
connectAttr "RIGRN.phl[242]" "HIKState2SK1.LeftUpLegIS";
connectAttr "HIKState2SK1.LeftUpLegSx" "RIGRN.phl[243]";
connectAttr "HIKState2SK1.LeftUpLegSy" "RIGRN.phl[244]";
connectAttr "HIKState2SK1.LeftUpLegSz" "RIGRN.phl[245]";
connectAttr "pairBlend2.otx" "RIGRN.phl[246]";
connectAttr "pairBlend2.oty" "RIGRN.phl[247]";
connectAttr "pairBlend2.otz" "RIGRN.phl[248]";
connectAttr "RIGRN.phl[249]" "HIKState2SK1.LeftUpLegPGX";
connectAttr "pairBlend2.orx" "RIGRN.phl[250]";
connectAttr "pairBlend2.ory" "RIGRN.phl[251]";
connectAttr "pairBlend2.orz" "RIGRN.phl[252]";
connectAttr "RIGRN.phl[253]" "HIKState2SK1.LeftUpLegROrder";
connectAttr "RIGRN.phl[254]" "HIKState2SK1.LeftUpLegPreR";
connectAttr "RIGRN.phl[255]" "HIKState2SK1.LeftUpLegSC";
connectAttr "RIGRN.phl[256]" "Character1.LeftUpLeg";
connectAttr "RIGRN.phl[257]" "HIKState2SK1.LeftUpLegPostR";
connectAttr "RIGRN.phl[258]" "HIKState2SK1.LeftLegIS";
connectAttr "HIKState2SK1.LeftLegSx" "RIGRN.phl[259]";
connectAttr "HIKState2SK1.LeftLegSy" "RIGRN.phl[260]";
connectAttr "HIKState2SK1.LeftLegSz" "RIGRN.phl[261]";
connectAttr "pairBlend3.otx" "RIGRN.phl[262]";
connectAttr "pairBlend3.oty" "RIGRN.phl[263]";
connectAttr "pairBlend3.otz" "RIGRN.phl[264]";
connectAttr "RIGRN.phl[265]" "HIKState2SK1.LeftLegPGX";
connectAttr "pairBlend3.orx" "RIGRN.phl[266]";
connectAttr "pairBlend3.ory" "RIGRN.phl[267]";
connectAttr "pairBlend3.orz" "RIGRN.phl[268]";
connectAttr "RIGRN.phl[269]" "HIKState2SK1.LeftLegROrder";
connectAttr "RIGRN.phl[270]" "HIKState2SK1.LeftLegPreR";
connectAttr "RIGRN.phl[271]" "HIKState2SK1.LeftLegSC";
connectAttr "RIGRN.phl[272]" "Character1.LeftLeg";
connectAttr "RIGRN.phl[273]" "HIKState2SK1.LeftLegPostR";
connectAttr "RIGRN.phl[274]" "HIKState2SK1.LeftFootIS";
connectAttr "HIKState2SK1.LeftFootSx" "RIGRN.phl[275]";
connectAttr "HIKState2SK1.LeftFootSy" "RIGRN.phl[276]";
connectAttr "HIKState2SK1.LeftFootSz" "RIGRN.phl[277]";
connectAttr "RIGRN.phl[278]" "HIKState2SK1.LeftFootPGX";
connectAttr "pairBlend4.otx" "RIGRN.phl[279]";
connectAttr "pairBlend4.oty" "RIGRN.phl[280]";
connectAttr "pairBlend4.otz" "RIGRN.phl[281]";
connectAttr "pairBlend4.orx" "RIGRN.phl[282]";
connectAttr "pairBlend4.ory" "RIGRN.phl[283]";
connectAttr "pairBlend4.orz" "RIGRN.phl[284]";
connectAttr "RIGRN.phl[285]" "HIKState2SK1.LeftFootROrder";
connectAttr "RIGRN.phl[286]" "HIKState2SK1.LeftFootPreR";
connectAttr "RIGRN.phl[287]" "HIKState2SK1.LeftFootSC";
connectAttr "RIGRN.phl[288]" "Character1.LeftFoot";
connectAttr "RIGRN.phl[289]" "HIKState2SK1.LeftFootPostR";
connectAttr "RIGRN.phl[290]" "HIKState2SK1.LeftToeBaseIS";
connectAttr "HIKState2SK1.LeftToeBaseSx" "RIGRN.phl[291]";
connectAttr "HIKState2SK1.LeftToeBaseSy" "RIGRN.phl[292]";
connectAttr "HIKState2SK1.LeftToeBaseSz" "RIGRN.phl[293]";
connectAttr "RIGRN.phl[294]" "HIKState2SK1.LeftToeBasePGX";
connectAttr "pairBlend16.otx" "RIGRN.phl[295]";
connectAttr "pairBlend16.oty" "RIGRN.phl[296]";
connectAttr "pairBlend16.otz" "RIGRN.phl[297]";
connectAttr "pairBlend16.orx" "RIGRN.phl[298]";
connectAttr "pairBlend16.ory" "RIGRN.phl[299]";
connectAttr "pairBlend16.orz" "RIGRN.phl[300]";
connectAttr "RIGRN.phl[301]" "HIKState2SK1.LeftToeBaseROrder";
connectAttr "RIGRN.phl[302]" "HIKState2SK1.LeftToeBasePreR";
connectAttr "RIGRN.phl[303]" "HIKState2SK1.LeftToeBaseSC";
connectAttr "RIGRN.phl[304]" "Character1.LeftToeBase";
connectAttr "RIGRN.phl[305]" "HIKState2SK1.LeftToeBasePostR";
connectAttr "RIGRN.phl[306]" "HIKState2SK1.RightUpLegIS";
connectAttr "HIKState2SK1.RightUpLegSx" "RIGRN.phl[307]";
connectAttr "HIKState2SK1.RightUpLegSy" "RIGRN.phl[308]";
connectAttr "HIKState2SK1.RightUpLegSz" "RIGRN.phl[309]";
connectAttr "pairBlend5.otx" "RIGRN.phl[310]";
connectAttr "pairBlend5.oty" "RIGRN.phl[311]";
connectAttr "pairBlend5.otz" "RIGRN.phl[312]";
connectAttr "RIGRN.phl[313]" "HIKState2SK1.RightUpLegPGX";
connectAttr "pairBlend5.orx" "RIGRN.phl[314]";
connectAttr "pairBlend5.ory" "RIGRN.phl[315]";
connectAttr "pairBlend5.orz" "RIGRN.phl[316]";
connectAttr "RIGRN.phl[317]" "HIKState2SK1.RightUpLegROrder";
connectAttr "RIGRN.phl[318]" "HIKState2SK1.RightUpLegPreR";
connectAttr "RIGRN.phl[319]" "HIKState2SK1.RightUpLegSC";
connectAttr "RIGRN.phl[320]" "Character1.RightUpLeg";
connectAttr "RIGRN.phl[321]" "HIKState2SK1.RightUpLegPostR";
connectAttr "RIGRN.phl[322]" "HIKState2SK1.RightLegIS";
connectAttr "HIKState2SK1.RightLegSx" "RIGRN.phl[323]";
connectAttr "HIKState2SK1.RightLegSy" "RIGRN.phl[324]";
connectAttr "HIKState2SK1.RightLegSz" "RIGRN.phl[325]";
connectAttr "pairBlend6.otx" "RIGRN.phl[326]";
connectAttr "pairBlend6.oty" "RIGRN.phl[327]";
connectAttr "pairBlend6.otz" "RIGRN.phl[328]";
connectAttr "RIGRN.phl[329]" "HIKState2SK1.RightLegPGX";
connectAttr "pairBlend6.orx" "RIGRN.phl[330]";
connectAttr "pairBlend6.ory" "RIGRN.phl[331]";
connectAttr "pairBlend6.orz" "RIGRN.phl[332]";
connectAttr "RIGRN.phl[333]" "HIKState2SK1.RightLegROrder";
connectAttr "RIGRN.phl[334]" "HIKState2SK1.RightLegPreR";
connectAttr "RIGRN.phl[335]" "HIKState2SK1.RightLegSC";
connectAttr "RIGRN.phl[336]" "Character1.RightLeg";
connectAttr "RIGRN.phl[337]" "HIKState2SK1.RightLegPostR";
connectAttr "RIGRN.phl[338]" "HIKState2SK1.RightFootIS";
connectAttr "HIKState2SK1.RightFootSx" "RIGRN.phl[339]";
connectAttr "HIKState2SK1.RightFootSy" "RIGRN.phl[340]";
connectAttr "HIKState2SK1.RightFootSz" "RIGRN.phl[341]";
connectAttr "RIGRN.phl[342]" "HIKState2SK1.RightFootPGX";
connectAttr "pairBlend7.otx" "RIGRN.phl[343]";
connectAttr "pairBlend7.oty" "RIGRN.phl[344]";
connectAttr "pairBlend7.otz" "RIGRN.phl[345]";
connectAttr "pairBlend7.orx" "RIGRN.phl[346]";
connectAttr "pairBlend7.ory" "RIGRN.phl[347]";
connectAttr "pairBlend7.orz" "RIGRN.phl[348]";
connectAttr "RIGRN.phl[349]" "HIKState2SK1.RightFootROrder";
connectAttr "RIGRN.phl[350]" "HIKState2SK1.RightFootPreR";
connectAttr "RIGRN.phl[351]" "HIKState2SK1.RightFootSC";
connectAttr "RIGRN.phl[352]" "Character1.RightFoot";
connectAttr "RIGRN.phl[353]" "HIKState2SK1.RightFootPostR";
connectAttr "RIGRN.phl[354]" "HIKState2SK1.RightToeBaseIS";
connectAttr "HIKState2SK1.RightToeBaseSx" "RIGRN.phl[355]";
connectAttr "HIKState2SK1.RightToeBaseSy" "RIGRN.phl[356]";
connectAttr "HIKState2SK1.RightToeBaseSz" "RIGRN.phl[357]";
connectAttr "RIGRN.phl[358]" "HIKState2SK1.RightToeBasePGX";
connectAttr "pairBlend17.otx" "RIGRN.phl[359]";
connectAttr "pairBlend17.oty" "RIGRN.phl[360]";
connectAttr "pairBlend17.otz" "RIGRN.phl[361]";
connectAttr "pairBlend17.orx" "RIGRN.phl[362]";
connectAttr "pairBlend17.ory" "RIGRN.phl[363]";
connectAttr "pairBlend17.orz" "RIGRN.phl[364]";
connectAttr "RIGRN.phl[365]" "HIKState2SK1.RightToeBaseROrder";
connectAttr "RIGRN.phl[366]" "HIKState2SK1.RightToeBasePreR";
connectAttr "RIGRN.phl[367]" "HIKState2SK1.RightToeBaseSC";
connectAttr "RIGRN.phl[368]" "Character1.RightToeBase";
connectAttr "RIGRN.phl[369]" "HIKState2SK1.RightToeBasePostR";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_HipsEffector.uagx";
connectAttr "Character1_Ctrl_HipsEffector_rotateZ.o" "Character1_Ctrl_HipsEffector.rz"
		;
connectAttr "Character1_Ctrl_HipsEffector_rotateY.o" "Character1_Ctrl_HipsEffector.ry"
		;
connectAttr "Character1_Ctrl_HipsEffector_rotateX.o" "Character1_Ctrl_HipsEffector.rx"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateZ.o" "Character1_Ctrl_HipsEffector.tz"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateY.o" "Character1_Ctrl_HipsEffector.ty"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateX.o" "Character1_Ctrl_HipsEffector.tx"
		;
connectAttr "HIKState2Effector1.HipsEffectorGXM[0]" "Character1_Ctrl_HipsEffector.agx"
		;
connectAttr "HIKState2Effector2.HipsEffectorGXM[0]" "Character1_Ctrl_HipsEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftAnkleEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotateZ.o" "Character1_Ctrl_LeftAnkleEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotateY.o" "Character1_Ctrl_LeftAnkleEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotateX.o" "Character1_Ctrl_LeftAnkleEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateZ.o" "Character1_Ctrl_LeftAnkleEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateY.o" "Character1_Ctrl_LeftAnkleEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateX.o" "Character1_Ctrl_LeftAnkleEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftAnkleEffectorGXM[0]" "Character1_Ctrl_LeftAnkleEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftAnkleEffectorGXM[0]" "Character1_Ctrl_LeftAnkleEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightAnkleEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotateZ.o" "Character1_Ctrl_RightAnkleEffector.rz"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotateY.o" "Character1_Ctrl_RightAnkleEffector.ry"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotateX.o" "Character1_Ctrl_RightAnkleEffector.rx"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateZ.o" "Character1_Ctrl_RightAnkleEffector.tz"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateY.o" "Character1_Ctrl_RightAnkleEffector.ty"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateX.o" "Character1_Ctrl_RightAnkleEffector.tx"
		;
connectAttr "HIKState2Effector1.RightAnkleEffectorGXM[0]" "Character1_Ctrl_RightAnkleEffector.agx"
		;
connectAttr "HIKState2Effector2.RightAnkleEffectorGXM[0]" "Character1_Ctrl_RightAnkleEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftWristEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotateZ.o" "Character1_Ctrl_LeftWristEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotateY.o" "Character1_Ctrl_LeftWristEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotateX.o" "Character1_Ctrl_LeftWristEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateZ.o" "Character1_Ctrl_LeftWristEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateY.o" "Character1_Ctrl_LeftWristEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateX.o" "Character1_Ctrl_LeftWristEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftWristEffectorGXM[0]" "Character1_Ctrl_LeftWristEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftWristEffectorGXM[0]" "Character1_Ctrl_LeftWristEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightWristEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotateZ.o" "Character1_Ctrl_RightWristEffector.rz"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotateY.o" "Character1_Ctrl_RightWristEffector.ry"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotateX.o" "Character1_Ctrl_RightWristEffector.rx"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateZ.o" "Character1_Ctrl_RightWristEffector.tz"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateY.o" "Character1_Ctrl_RightWristEffector.ty"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateX.o" "Character1_Ctrl_RightWristEffector.tx"
		;
connectAttr "HIKState2Effector1.RightWristEffectorGXM[0]" "Character1_Ctrl_RightWristEffector.agx"
		;
connectAttr "HIKState2Effector2.RightWristEffectorGXM[0]" "Character1_Ctrl_RightWristEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftKneeEffector.uagx";
connectAttr "Character1_Ctrl_LeftKneeEffector_rotateZ.o" "Character1_Ctrl_LeftKneeEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_rotateY.o" "Character1_Ctrl_LeftKneeEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_rotateX.o" "Character1_Ctrl_LeftKneeEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateZ.o" "Character1_Ctrl_LeftKneeEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateY.o" "Character1_Ctrl_LeftKneeEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateX.o" "Character1_Ctrl_LeftKneeEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftKneeEffectorGXM[0]" "Character1_Ctrl_LeftKneeEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftKneeEffectorGXM[0]" "Character1_Ctrl_LeftKneeEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightKneeEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotateZ.o" "Character1_Ctrl_RightKneeEffector.rz"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotateY.o" "Character1_Ctrl_RightKneeEffector.ry"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotateX.o" "Character1_Ctrl_RightKneeEffector.rx"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateZ.o" "Character1_Ctrl_RightKneeEffector.tz"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateY.o" "Character1_Ctrl_RightKneeEffector.ty"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateX.o" "Character1_Ctrl_RightKneeEffector.tx"
		;
connectAttr "HIKState2Effector1.RightKneeEffectorGXM[0]" "Character1_Ctrl_RightKneeEffector.agx"
		;
connectAttr "HIKState2Effector2.RightKneeEffectorGXM[0]" "Character1_Ctrl_RightKneeEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftElbowEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotateZ.o" "Character1_Ctrl_LeftElbowEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotateY.o" "Character1_Ctrl_LeftElbowEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotateX.o" "Character1_Ctrl_LeftElbowEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateZ.o" "Character1_Ctrl_LeftElbowEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateY.o" "Character1_Ctrl_LeftElbowEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateX.o" "Character1_Ctrl_LeftElbowEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftElbowEffectorGXM[0]" "Character1_Ctrl_LeftElbowEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftElbowEffectorGXM[0]" "Character1_Ctrl_LeftElbowEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightElbowEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotateZ.o" "Character1_Ctrl_RightElbowEffector.rz"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotateY.o" "Character1_Ctrl_RightElbowEffector.ry"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotateX.o" "Character1_Ctrl_RightElbowEffector.rx"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateZ.o" "Character1_Ctrl_RightElbowEffector.tz"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateY.o" "Character1_Ctrl_RightElbowEffector.ty"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateX.o" "Character1_Ctrl_RightElbowEffector.tx"
		;
connectAttr "HIKState2Effector1.RightElbowEffectorGXM[0]" "Character1_Ctrl_RightElbowEffector.agx"
		;
connectAttr "HIKState2Effector2.RightElbowEffectorGXM[0]" "Character1_Ctrl_RightElbowEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_ChestOriginEffector.uagx"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotateZ.o" "Character1_Ctrl_ChestOriginEffector.rz"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotateY.o" "Character1_Ctrl_ChestOriginEffector.ry"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotateX.o" "Character1_Ctrl_ChestOriginEffector.rx"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateZ.o" "Character1_Ctrl_ChestOriginEffector.tz"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateY.o" "Character1_Ctrl_ChestOriginEffector.ty"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateX.o" "Character1_Ctrl_ChestOriginEffector.tx"
		;
connectAttr "HIKState2Effector1.ChestOriginEffectorGXM[0]" "Character1_Ctrl_ChestOriginEffector.agx"
		;
connectAttr "HIKState2Effector2.ChestOriginEffectorGXM[0]" "Character1_Ctrl_ChestOriginEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_ChestEndEffector.uagx";
connectAttr "Character1_Ctrl_ChestEndEffector_rotateZ.o" "Character1_Ctrl_ChestEndEffector.rz"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_rotateY.o" "Character1_Ctrl_ChestEndEffector.ry"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_rotateX.o" "Character1_Ctrl_ChestEndEffector.rx"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateZ.o" "Character1_Ctrl_ChestEndEffector.tz"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateY.o" "Character1_Ctrl_ChestEndEffector.ty"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateX.o" "Character1_Ctrl_ChestEndEffector.tx"
		;
connectAttr "HIKState2Effector1.ChestEndEffectorGXM[0]" "Character1_Ctrl_ChestEndEffector.agx"
		;
connectAttr "HIKState2Effector2.ChestEndEffectorGXM[0]" "Character1_Ctrl_ChestEndEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftFootEffector.uagx";
connectAttr "Character1_Ctrl_LeftFootEffector_rotateZ.o" "Character1_Ctrl_LeftFootEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_rotateY.o" "Character1_Ctrl_LeftFootEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_rotateX.o" "Character1_Ctrl_LeftFootEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateZ.o" "Character1_Ctrl_LeftFootEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateY.o" "Character1_Ctrl_LeftFootEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateX.o" "Character1_Ctrl_LeftFootEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftFootEffectorGXM[0]" "Character1_Ctrl_LeftFootEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftFootEffectorGXM[0]" "Character1_Ctrl_LeftFootEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightFootEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotateZ.o" "Character1_Ctrl_RightFootEffector.rz"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotateY.o" "Character1_Ctrl_RightFootEffector.ry"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotateX.o" "Character1_Ctrl_RightFootEffector.rx"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateZ.o" "Character1_Ctrl_RightFootEffector.tz"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateY.o" "Character1_Ctrl_RightFootEffector.ty"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateX.o" "Character1_Ctrl_RightFootEffector.tx"
		;
connectAttr "HIKState2Effector1.RightFootEffectorGXM[0]" "Character1_Ctrl_RightFootEffector.agx"
		;
connectAttr "HIKState2Effector2.RightFootEffectorGXM[0]" "Character1_Ctrl_RightFootEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftShoulderEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotateZ.o" "Character1_Ctrl_LeftShoulderEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotateY.o" "Character1_Ctrl_LeftShoulderEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotateX.o" "Character1_Ctrl_LeftShoulderEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateZ.o" "Character1_Ctrl_LeftShoulderEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateY.o" "Character1_Ctrl_LeftShoulderEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateX.o" "Character1_Ctrl_LeftShoulderEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftShoulderEffectorGXM[0]" "Character1_Ctrl_LeftShoulderEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftShoulderEffectorGXM[0]" "Character1_Ctrl_LeftShoulderEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightShoulderEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotateZ.o" "Character1_Ctrl_RightShoulderEffector.rz"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotateY.o" "Character1_Ctrl_RightShoulderEffector.ry"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotateX.o" "Character1_Ctrl_RightShoulderEffector.rx"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateZ.o" "Character1_Ctrl_RightShoulderEffector.tz"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateY.o" "Character1_Ctrl_RightShoulderEffector.ty"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateX.o" "Character1_Ctrl_RightShoulderEffector.tx"
		;
connectAttr "HIKState2Effector1.RightShoulderEffectorGXM[0]" "Character1_Ctrl_RightShoulderEffector.agx"
		;
connectAttr "HIKState2Effector2.RightShoulderEffectorGXM[0]" "Character1_Ctrl_RightShoulderEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_HeadEffector.uagx";
connectAttr "Character1_Ctrl_HeadEffector_rotateZ.o" "Character1_Ctrl_HeadEffector.rz"
		;
connectAttr "Character1_Ctrl_HeadEffector_rotateY.o" "Character1_Ctrl_HeadEffector.ry"
		;
connectAttr "Character1_Ctrl_HeadEffector_rotateX.o" "Character1_Ctrl_HeadEffector.rx"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateZ.o" "Character1_Ctrl_HeadEffector.tz"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateY.o" "Character1_Ctrl_HeadEffector.ty"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateX.o" "Character1_Ctrl_HeadEffector.tx"
		;
connectAttr "HIKState2Effector1.HeadEffectorGXM[0]" "Character1_Ctrl_HeadEffector.agx"
		;
connectAttr "HIKState2Effector2.HeadEffectorGXM[0]" "Character1_Ctrl_HeadEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftHipEffector.uagx";
connectAttr "Character1_Ctrl_LeftHipEffector_rotateZ.o" "Character1_Ctrl_LeftHipEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_rotateY.o" "Character1_Ctrl_LeftHipEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_rotateX.o" "Character1_Ctrl_LeftHipEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateZ.o" "Character1_Ctrl_LeftHipEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateY.o" "Character1_Ctrl_LeftHipEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateX.o" "Character1_Ctrl_LeftHipEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftHipEffectorGXM[0]" "Character1_Ctrl_LeftHipEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftHipEffectorGXM[0]" "Character1_Ctrl_LeftHipEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightHipEffector.uagx";
connectAttr "Character1_Ctrl_RightHipEffector_rotateZ.o" "Character1_Ctrl_RightHipEffector.rz"
		;
connectAttr "Character1_Ctrl_RightHipEffector_rotateY.o" "Character1_Ctrl_RightHipEffector.ry"
		;
connectAttr "Character1_Ctrl_RightHipEffector_rotateX.o" "Character1_Ctrl_RightHipEffector.rx"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateZ.o" "Character1_Ctrl_RightHipEffector.tz"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateY.o" "Character1_Ctrl_RightHipEffector.ty"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateX.o" "Character1_Ctrl_RightHipEffector.tx"
		;
connectAttr "HIKState2Effector1.RightHipEffectorGXM[0]" "Character1_Ctrl_RightHipEffector.agx"
		;
connectAttr "HIKState2Effector2.RightHipEffectorGXM[0]" "Character1_Ctrl_RightHipEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Hips.uagx";
connectAttr "Character1_Ctrl_Hips_rotateZ.o" "Character1_Ctrl_Hips.rz";
connectAttr "Character1_Ctrl_Hips_rotateY.o" "Character1_Ctrl_Hips.ry";
connectAttr "Character1_Ctrl_Hips_rotateX.o" "Character1_Ctrl_Hips.rx";
connectAttr "Character1_Ctrl_Hips_translateZ.o" "Character1_Ctrl_Hips.tz";
connectAttr "Character1_Ctrl_Hips_translateY.o" "Character1_Ctrl_Hips.ty";
connectAttr "Character1_Ctrl_Hips_translateX.o" "Character1_Ctrl_Hips.tx";
connectAttr "HIKState2FK1.HipsGX" "Character1_Ctrl_Hips.agx";
connectAttr "HIKState2FK2.HipsGX" "Character1_Ctrl_Hips.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftUpLeg.uagx";
connectAttr "Character1_Ctrl_LeftUpLeg_rotateZ.o" "Character1_Ctrl_LeftUpLeg.rz"
		;
connectAttr "Character1_Ctrl_LeftUpLeg_rotateY.o" "Character1_Ctrl_LeftUpLeg.ry"
		;
connectAttr "Character1_Ctrl_LeftUpLeg_rotateX.o" "Character1_Ctrl_LeftUpLeg.rx"
		;
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_LeftUpLeg.is";
connectAttr "HIKState2FK1.LeftUpLegGX" "Character1_Ctrl_LeftUpLeg.agx";
connectAttr "HIKState2FK2.LeftUpLegGX" "Character1_Ctrl_LeftUpLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftLeg.uagx";
connectAttr "Character1_Ctrl_LeftLeg_rotateZ.o" "Character1_Ctrl_LeftLeg.rz";
connectAttr "Character1_Ctrl_LeftLeg_rotateY.o" "Character1_Ctrl_LeftLeg.ry";
connectAttr "Character1_Ctrl_LeftLeg_rotateX.o" "Character1_Ctrl_LeftLeg.rx";
connectAttr "Character1_Ctrl_LeftUpLeg.s" "Character1_Ctrl_LeftLeg.is";
connectAttr "HIKState2FK1.LeftLegGX" "Character1_Ctrl_LeftLeg.agx";
connectAttr "HIKState2FK2.LeftLegGX" "Character1_Ctrl_LeftLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftFoot.uagx";
connectAttr "Character1_Ctrl_LeftFoot_rotateZ.o" "Character1_Ctrl_LeftFoot.rz";
connectAttr "Character1_Ctrl_LeftFoot_rotateY.o" "Character1_Ctrl_LeftFoot.ry";
connectAttr "Character1_Ctrl_LeftFoot_rotateX.o" "Character1_Ctrl_LeftFoot.rx";
connectAttr "Character1_Ctrl_LeftLeg.s" "Character1_Ctrl_LeftFoot.is";
connectAttr "HIKState2FK1.LeftFootGX" "Character1_Ctrl_LeftFoot.agx";
connectAttr "HIKState2FK2.LeftFootGX" "Character1_Ctrl_LeftFoot.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftToeBase.uagx";
connectAttr "Character1_Ctrl_LeftToeBase_rotateZ.o" "Character1_Ctrl_LeftToeBase.rz"
		;
connectAttr "Character1_Ctrl_LeftToeBase_rotateY.o" "Character1_Ctrl_LeftToeBase.ry"
		;
connectAttr "Character1_Ctrl_LeftToeBase_rotateX.o" "Character1_Ctrl_LeftToeBase.rx"
		;
connectAttr "Character1_Ctrl_LeftFoot.s" "Character1_Ctrl_LeftToeBase.is";
connectAttr "HIKState2FK1.LeftToeBaseGX" "Character1_Ctrl_LeftToeBase.agx";
connectAttr "HIKState2FK2.LeftToeBaseGX" "Character1_Ctrl_LeftToeBase.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightUpLeg.uagx";
connectAttr "Character1_Ctrl_RightUpLeg_rotateZ.o" "Character1_Ctrl_RightUpLeg.rz"
		;
connectAttr "Character1_Ctrl_RightUpLeg_rotateY.o" "Character1_Ctrl_RightUpLeg.ry"
		;
connectAttr "Character1_Ctrl_RightUpLeg_rotateX.o" "Character1_Ctrl_RightUpLeg.rx"
		;
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_RightUpLeg.is";
connectAttr "HIKState2FK1.RightUpLegGX" "Character1_Ctrl_RightUpLeg.agx";
connectAttr "HIKState2FK2.RightUpLegGX" "Character1_Ctrl_RightUpLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightLeg.uagx";
connectAttr "Character1_Ctrl_RightLeg_rotateZ.o" "Character1_Ctrl_RightLeg.rz";
connectAttr "Character1_Ctrl_RightLeg_rotateY.o" "Character1_Ctrl_RightLeg.ry";
connectAttr "Character1_Ctrl_RightLeg_rotateX.o" "Character1_Ctrl_RightLeg.rx";
connectAttr "Character1_Ctrl_RightUpLeg.s" "Character1_Ctrl_RightLeg.is";
connectAttr "HIKState2FK1.RightLegGX" "Character1_Ctrl_RightLeg.agx";
connectAttr "HIKState2FK2.RightLegGX" "Character1_Ctrl_RightLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightFoot.uagx";
connectAttr "Character1_Ctrl_RightFoot_rotateZ.o" "Character1_Ctrl_RightFoot.rz"
		;
connectAttr "Character1_Ctrl_RightFoot_rotateY.o" "Character1_Ctrl_RightFoot.ry"
		;
connectAttr "Character1_Ctrl_RightFoot_rotateX.o" "Character1_Ctrl_RightFoot.rx"
		;
connectAttr "Character1_Ctrl_RightLeg.s" "Character1_Ctrl_RightFoot.is";
connectAttr "HIKState2FK1.RightFootGX" "Character1_Ctrl_RightFoot.agx";
connectAttr "HIKState2FK2.RightFootGX" "Character1_Ctrl_RightFoot.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightToeBase.uagx";
connectAttr "Character1_Ctrl_RightToeBase_rotateZ.o" "Character1_Ctrl_RightToeBase.rz"
		;
connectAttr "Character1_Ctrl_RightToeBase_rotateY.o" "Character1_Ctrl_RightToeBase.ry"
		;
connectAttr "Character1_Ctrl_RightToeBase_rotateX.o" "Character1_Ctrl_RightToeBase.rx"
		;
connectAttr "Character1_Ctrl_RightFoot.s" "Character1_Ctrl_RightToeBase.is";
connectAttr "HIKState2FK1.RightToeBaseGX" "Character1_Ctrl_RightToeBase.agx";
connectAttr "HIKState2FK2.RightToeBaseGX" "Character1_Ctrl_RightToeBase.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine.uagx";
connectAttr "Character1_Ctrl_Spine_rotateZ.o" "Character1_Ctrl_Spine.rz";
connectAttr "Character1_Ctrl_Spine_rotateY.o" "Character1_Ctrl_Spine.ry";
connectAttr "Character1_Ctrl_Spine_rotateX.o" "Character1_Ctrl_Spine.rx";
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_Spine.is";
connectAttr "HIKState2FK1.SpineGX" "Character1_Ctrl_Spine.agx";
connectAttr "HIKState2FK2.SpineGX" "Character1_Ctrl_Spine.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine1.uagx";
connectAttr "Character1_Ctrl_Spine1_rotateZ.o" "Character1_Ctrl_Spine1.rz";
connectAttr "Character1_Ctrl_Spine1_rotateY.o" "Character1_Ctrl_Spine1.ry";
connectAttr "Character1_Ctrl_Spine1_rotateX.o" "Character1_Ctrl_Spine1.rx";
connectAttr "Character1_Ctrl_Spine.s" "Character1_Ctrl_Spine1.is";
connectAttr "HIKState2FK1.Spine1GX" "Character1_Ctrl_Spine1.agx";
connectAttr "HIKState2FK2.Spine1GX" "Character1_Ctrl_Spine1.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine2.uagx";
connectAttr "Character1_Ctrl_Spine2_rotateZ.o" "Character1_Ctrl_Spine2.rz";
connectAttr "Character1_Ctrl_Spine2_rotateY.o" "Character1_Ctrl_Spine2.ry";
connectAttr "Character1_Ctrl_Spine2_rotateX.o" "Character1_Ctrl_Spine2.rx";
connectAttr "Character1_Ctrl_Spine1.s" "Character1_Ctrl_Spine2.is";
connectAttr "HIKState2FK1.Spine2GX" "Character1_Ctrl_Spine2.agx";
connectAttr "HIKState2FK2.Spine2GX" "Character1_Ctrl_Spine2.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine3.uagx";
connectAttr "Character1_Ctrl_Spine3_rotateZ.o" "Character1_Ctrl_Spine3.rz";
connectAttr "Character1_Ctrl_Spine3_rotateY.o" "Character1_Ctrl_Spine3.ry";
connectAttr "Character1_Ctrl_Spine3_rotateX.o" "Character1_Ctrl_Spine3.rx";
connectAttr "Character1_Ctrl_Spine2.s" "Character1_Ctrl_Spine3.is";
connectAttr "HIKState2FK1.Spine3GX" "Character1_Ctrl_Spine3.agx";
connectAttr "HIKState2FK2.Spine3GX" "Character1_Ctrl_Spine3.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftShoulder.uagx";
connectAttr "Character1_Ctrl_LeftShoulder_rotateZ.o" "Character1_Ctrl_LeftShoulder.rz"
		;
connectAttr "Character1_Ctrl_LeftShoulder_rotateY.o" "Character1_Ctrl_LeftShoulder.ry"
		;
connectAttr "Character1_Ctrl_LeftShoulder_rotateX.o" "Character1_Ctrl_LeftShoulder.rx"
		;
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_LeftShoulder.is";
connectAttr "HIKState2FK1.LeftShoulderGX" "Character1_Ctrl_LeftShoulder.agx";
connectAttr "HIKState2FK2.LeftShoulderGX" "Character1_Ctrl_LeftShoulder.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftArm.uagx";
connectAttr "Character1_Ctrl_LeftArm_rotateZ.o" "Character1_Ctrl_LeftArm.rz";
connectAttr "Character1_Ctrl_LeftArm_rotateY.o" "Character1_Ctrl_LeftArm.ry";
connectAttr "Character1_Ctrl_LeftArm_rotateX.o" "Character1_Ctrl_LeftArm.rx";
connectAttr "Character1_Ctrl_LeftShoulder.s" "Character1_Ctrl_LeftArm.is";
connectAttr "HIKState2FK1.LeftArmGX" "Character1_Ctrl_LeftArm.agx";
connectAttr "HIKState2FK2.LeftArmGX" "Character1_Ctrl_LeftArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftForeArm.uagx";
connectAttr "Character1_Ctrl_LeftForeArm_rotateZ.o" "Character1_Ctrl_LeftForeArm.rz"
		;
connectAttr "Character1_Ctrl_LeftForeArm_rotateY.o" "Character1_Ctrl_LeftForeArm.ry"
		;
connectAttr "Character1_Ctrl_LeftForeArm_rotateX.o" "Character1_Ctrl_LeftForeArm.rx"
		;
connectAttr "Character1_Ctrl_LeftArm.s" "Character1_Ctrl_LeftForeArm.is";
connectAttr "HIKState2FK1.LeftForeArmGX" "Character1_Ctrl_LeftForeArm.agx";
connectAttr "HIKState2FK2.LeftForeArmGX" "Character1_Ctrl_LeftForeArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftHand.uagx";
connectAttr "Character1_Ctrl_LeftHand_rotateZ.o" "Character1_Ctrl_LeftHand.rz";
connectAttr "Character1_Ctrl_LeftHand_rotateY.o" "Character1_Ctrl_LeftHand.ry";
connectAttr "Character1_Ctrl_LeftHand_rotateX.o" "Character1_Ctrl_LeftHand.rx";
connectAttr "Character1_Ctrl_LeftForeArm.s" "Character1_Ctrl_LeftHand.is";
connectAttr "HIKState2FK1.LeftHandGX" "Character1_Ctrl_LeftHand.agx";
connectAttr "HIKState2FK2.LeftHandGX" "Character1_Ctrl_LeftHand.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightShoulder.uagx";
connectAttr "Character1_Ctrl_RightShoulder_rotateZ.o" "Character1_Ctrl_RightShoulder.rz"
		;
connectAttr "Character1_Ctrl_RightShoulder_rotateY.o" "Character1_Ctrl_RightShoulder.ry"
		;
connectAttr "Character1_Ctrl_RightShoulder_rotateX.o" "Character1_Ctrl_RightShoulder.rx"
		;
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_RightShoulder.is";
connectAttr "HIKState2FK1.RightShoulderGX" "Character1_Ctrl_RightShoulder.agx";
connectAttr "HIKState2FK2.RightShoulderGX" "Character1_Ctrl_RightShoulder.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightArm.uagx";
connectAttr "Character1_Ctrl_RightArm_rotateZ.o" "Character1_Ctrl_RightArm.rz";
connectAttr "Character1_Ctrl_RightArm_rotateY.o" "Character1_Ctrl_RightArm.ry";
connectAttr "Character1_Ctrl_RightArm_rotateX.o" "Character1_Ctrl_RightArm.rx";
connectAttr "Character1_Ctrl_RightShoulder.s" "Character1_Ctrl_RightArm.is";
connectAttr "HIKState2FK1.RightArmGX" "Character1_Ctrl_RightArm.agx";
connectAttr "HIKState2FK2.RightArmGX" "Character1_Ctrl_RightArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightForeArm.uagx";
connectAttr "Character1_Ctrl_RightForeArm_rotateZ.o" "Character1_Ctrl_RightForeArm.rz"
		;
connectAttr "Character1_Ctrl_RightForeArm_rotateY.o" "Character1_Ctrl_RightForeArm.ry"
		;
connectAttr "Character1_Ctrl_RightForeArm_rotateX.o" "Character1_Ctrl_RightForeArm.rx"
		;
connectAttr "Character1_Ctrl_RightArm.s" "Character1_Ctrl_RightForeArm.is";
connectAttr "HIKState2FK1.RightForeArmGX" "Character1_Ctrl_RightForeArm.agx";
connectAttr "HIKState2FK2.RightForeArmGX" "Character1_Ctrl_RightForeArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightHand.uagx";
connectAttr "Character1_Ctrl_RightHand_rotateZ.o" "Character1_Ctrl_RightHand.rz"
		;
connectAttr "Character1_Ctrl_RightHand_rotateY.o" "Character1_Ctrl_RightHand.ry"
		;
connectAttr "Character1_Ctrl_RightHand_rotateX.o" "Character1_Ctrl_RightHand.rx"
		;
connectAttr "Character1_Ctrl_RightForeArm.s" "Character1_Ctrl_RightHand.is";
connectAttr "HIKState2FK1.RightHandGX" "Character1_Ctrl_RightHand.agx";
connectAttr "HIKState2FK2.RightHandGX" "Character1_Ctrl_RightHand.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Neck.uagx";
connectAttr "Character1_Ctrl_Neck_rotateZ.o" "Character1_Ctrl_Neck.rz";
connectAttr "Character1_Ctrl_Neck_rotateY.o" "Character1_Ctrl_Neck.ry";
connectAttr "Character1_Ctrl_Neck_rotateX.o" "Character1_Ctrl_Neck.rx";
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_Neck.is";
connectAttr "HIKState2FK1.NeckGX" "Character1_Ctrl_Neck.agx";
connectAttr "HIKState2FK2.NeckGX" "Character1_Ctrl_Neck.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Head.uagx";
connectAttr "Character1_Ctrl_Head_rotateZ.o" "Character1_Ctrl_Head.rz";
connectAttr "Character1_Ctrl_Head_rotateY.o" "Character1_Ctrl_Head.ry";
connectAttr "Character1_Ctrl_Head_rotateX.o" "Character1_Ctrl_Head.rx";
connectAttr "Character1_Ctrl_Neck.s" "Character1_Ctrl_Head.is";
connectAttr "HIKState2FK1.HeadGX" "Character1_Ctrl_Head.agx";
connectAttr "HIKState2FK2.HeadGX" "Character1_Ctrl_Head.atx";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "HIKproperties1.msg" "Character1.propertyState";
connectAttr "Character1_Ctrl_HipsEffector.pull" "HIKproperties1.CtrlResistHipsPosition"
		;
connectAttr "Character1_Ctrl_HipsEffector.stiffness" "HIKproperties1.CtrlResistHipsOrientation"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.pull" "HIKproperties1.CtrlPullLeftFoot"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.pull" "HIKproperties1.CtrlPullRightFoot"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.pull" "HIKproperties1.CtrlChestPullLeftHand"
		;
connectAttr "Character1_Ctrl_RightWristEffector.pull" "HIKproperties1.CtrlChestPullRightHand"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.pull" "HIKproperties1.CtrlPullLeftKnee"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.stiffness" "HIKproperties1.CtrlResistLeftKnee"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.pull" "HIKproperties1.CtrlPullRightKnee"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.stiffness" "HIKproperties1.CtrlResistRightKnee"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.pull" "HIKproperties1.CtrlPullLeftElbow"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.stiffness" "HIKproperties1.CtrlResistLeftElbow"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.pull" "HIKproperties1.CtrlPullRightElbow"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.stiffness" "HIKproperties1.CtrlResistRightElbow"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.stiffness" "HIKproperties1.ParamCtrlSpineStiffness"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.pull" "HIKproperties1.CtrlResistChestPosition"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.stiffness" "HIKproperties1.CtrlResistChestOrientation"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.pull" "HIKproperties1.CtrlPullLeftToeBase"
		;
connectAttr "Character1_Ctrl_RightFootEffector.pull" "HIKproperties1.CtrlPullRightToeBase"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.stiffness" "HIKproperties1.CtrlResistLeftCollar"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.stiffness" "HIKproperties1.CtrlResistRightCollar"
		;
connectAttr "Character1_Ctrl_HeadEffector.pull" "HIKproperties1.CtrlPullHead";
connectAttr "Character1_Ctrl_HeadEffector.stiffness" "HIKproperties1.ParamCtrlNeckStiffness"
		;
connectAttr "HIKproperties1.OutputPropertySetState" "HIKSolverNode1.InputPropertySetState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKSolverNode1.InputCharacterDefinition"
		;
connectAttr "HIKFK2State1.OutputCharacterState" "HIKSolverNode1.InputCharacterState"
		;
connectAttr "HIKPinning2State1.OutputEffectorState" "HIKSolverNode1.InputEffectorState"
		;
connectAttr "HIKPinning2State1.OutputEffectorStateNoAux" "HIKSolverNode1.InputEffectorStateNoAux"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKState2SK1.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKState2SK1.InputCharacterState"
		;
connectAttr "Character1.OutputCharacterDefinition" "Character1_ControlRig.HIC";
connectAttr "Character1_Ctrl_Reference.ch" "Character1_ControlRig.Reference";
connectAttr "Character1_Ctrl_Hips.ch" "Character1_ControlRig.Hips";
connectAttr "Character1_Ctrl_LeftUpLeg.ch" "Character1_ControlRig.LeftUpLeg";
connectAttr "Character1_Ctrl_LeftLeg.ch" "Character1_ControlRig.LeftLeg";
connectAttr "Character1_Ctrl_LeftFoot.ch" "Character1_ControlRig.LeftFoot";
connectAttr "Character1_Ctrl_RightUpLeg.ch" "Character1_ControlRig.RightUpLeg";
connectAttr "Character1_Ctrl_RightLeg.ch" "Character1_ControlRig.RightLeg";
connectAttr "Character1_Ctrl_RightFoot.ch" "Character1_ControlRig.RightFoot";
connectAttr "Character1_Ctrl_Spine.ch" "Character1_ControlRig.Spine";
connectAttr "Character1_Ctrl_LeftArm.ch" "Character1_ControlRig.LeftArm";
connectAttr "Character1_Ctrl_LeftForeArm.ch" "Character1_ControlRig.LeftForeArm"
		;
connectAttr "Character1_Ctrl_LeftHand.ch" "Character1_ControlRig.LeftHand";
connectAttr "Character1_Ctrl_RightArm.ch" "Character1_ControlRig.RightArm";
connectAttr "Character1_Ctrl_RightForeArm.ch" "Character1_ControlRig.RightForeArm"
		;
connectAttr "Character1_Ctrl_RightHand.ch" "Character1_ControlRig.RightHand";
connectAttr "Character1_Ctrl_Head.ch" "Character1_ControlRig.Head";
connectAttr "Character1_Ctrl_LeftToeBase.ch" "Character1_ControlRig.LeftToeBase"
		;
connectAttr "Character1_Ctrl_RightToeBase.ch" "Character1_ControlRig.RightToeBase"
		;
connectAttr "Character1_Ctrl_LeftShoulder.ch" "Character1_ControlRig.LeftShoulder"
		;
connectAttr "Character1_Ctrl_RightShoulder.ch" "Character1_ControlRig.RightShoulder"
		;
connectAttr "Character1_Ctrl_Neck.ch" "Character1_ControlRig.Neck";
connectAttr "Character1_Ctrl_Spine1.ch" "Character1_ControlRig.Spine1";
connectAttr "Character1_Ctrl_Spine2.ch" "Character1_ControlRig.Spine2";
connectAttr "Character1_Ctrl_Spine3.ch" "Character1_ControlRig.Spine3";
connectAttr "Character1_Ctrl_HipsEffector.ch" "Character1_ControlRig.HipsEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.ch" "Character1_ControlRig.LeftAnkleEffector[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.ch" "Character1_ControlRig.RightAnkleEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.ch" "Character1_ControlRig.LeftWristEffector[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.ch" "Character1_ControlRig.RightWristEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.ch" "Character1_ControlRig.LeftKneeEffector[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.ch" "Character1_ControlRig.RightKneeEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.ch" "Character1_ControlRig.LeftElbowEffector[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.ch" "Character1_ControlRig.RightElbowEffector[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.ch" "Character1_ControlRig.ChestOriginEffector[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.ch" "Character1_ControlRig.ChestEndEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.ch" "Character1_ControlRig.LeftFootEffector[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.ch" "Character1_ControlRig.RightFootEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.ch" "Character1_ControlRig.LeftShoulderEffector[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.ch" "Character1_ControlRig.RightShoulderEffector[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.ch" "Character1_ControlRig.HeadEffector[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.ch" "Character1_ControlRig.LeftHipEffector[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.ch" "Character1_ControlRig.RightHipEffector[0]"
		;
connectAttr "HIKproperties1.ra" "Character1_ControlRig.ra";
connectAttr "Character1_HipsBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_ChestBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_LeftArmBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_RightArmBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_LeftLegBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_RightLegBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_HeadBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_LeftHandBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_RightHandBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_LeftFootBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_RightFootBPKG.msg" "Character1_FullBodyKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.msg" "Character1_FullBodyKG.act[0]";
connectAttr "Character1_Ctrl_LeftUpLeg.msg" "Character1_FullBodyKG.act[1]";
connectAttr "Character1_Ctrl_LeftLeg.msg" "Character1_FullBodyKG.act[2]";
connectAttr "Character1_Ctrl_LeftFoot.msg" "Character1_FullBodyKG.act[3]";
connectAttr "Character1_Ctrl_RightUpLeg.msg" "Character1_FullBodyKG.act[4]";
connectAttr "Character1_Ctrl_RightLeg.msg" "Character1_FullBodyKG.act[5]";
connectAttr "Character1_Ctrl_RightFoot.msg" "Character1_FullBodyKG.act[6]";
connectAttr "Character1_Ctrl_Spine.msg" "Character1_FullBodyKG.act[7]";
connectAttr "Character1_Ctrl_LeftArm.msg" "Character1_FullBodyKG.act[8]";
connectAttr "Character1_Ctrl_LeftForeArm.msg" "Character1_FullBodyKG.act[9]";
connectAttr "Character1_Ctrl_LeftHand.msg" "Character1_FullBodyKG.act[10]";
connectAttr "Character1_Ctrl_RightArm.msg" "Character1_FullBodyKG.act[11]";
connectAttr "Character1_Ctrl_RightForeArm.msg" "Character1_FullBodyKG.act[12]";
connectAttr "Character1_Ctrl_RightHand.msg" "Character1_FullBodyKG.act[13]";
connectAttr "Character1_Ctrl_Head.msg" "Character1_FullBodyKG.act[14]";
connectAttr "Character1_Ctrl_LeftToeBase.msg" "Character1_FullBodyKG.act[15]";
connectAttr "Character1_Ctrl_RightToeBase.msg" "Character1_FullBodyKG.act[16]";
connectAttr "Character1_Ctrl_LeftShoulder.msg" "Character1_FullBodyKG.act[17]";
connectAttr "Character1_Ctrl_RightShoulder.msg" "Character1_FullBodyKG.act[18]";
connectAttr "Character1_Ctrl_Neck.msg" "Character1_FullBodyKG.act[19]";
connectAttr "Character1_Ctrl_Spine1.msg" "Character1_FullBodyKG.act[20]";
connectAttr "Character1_Ctrl_Spine2.msg" "Character1_FullBodyKG.act[21]";
connectAttr "Character1_Ctrl_Spine3.msg" "Character1_FullBodyKG.act[22]";
connectAttr "Character1_Ctrl_HipsEffector.msg" "Character1_FullBodyKG.act[23]";
connectAttr "Character1_Ctrl_LeftAnkleEffector.msg" "Character1_FullBodyKG.act[24]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.msg" "Character1_FullBodyKG.act[25]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.msg" "Character1_FullBodyKG.act[26]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.msg" "Character1_FullBodyKG.act[27]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.msg" "Character1_FullBodyKG.act[28]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.msg" "Character1_FullBodyKG.act[29]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.msg" "Character1_FullBodyKG.act[30]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.msg" "Character1_FullBodyKG.act[31]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.msg" "Character1_FullBodyKG.act[32]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.msg" "Character1_FullBodyKG.act[33]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.msg" "Character1_FullBodyKG.act[34]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.msg" "Character1_FullBodyKG.act[35]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.msg" "Character1_FullBodyKG.act[36]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.msg" "Character1_FullBodyKG.act[37]"
		;
connectAttr "Character1_Ctrl_HeadEffector.msg" "Character1_FullBodyKG.act[38]";
connectAttr "Character1_Ctrl_LeftHipEffector.msg" "Character1_FullBodyKG.act[39]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.msg" "Character1_FullBodyKG.act[40]"
		;
connectAttr "Character1_Ctrl_Hips.rz" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.ry" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.rx" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.tz" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.ty" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.tx" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.rz" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.ry" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.rx" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.tz" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.ty" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HipsEffector.tx" "Character1_HipsBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Hips.msg" "Character1_HipsBPKG.act[0]";
connectAttr "Character1_Ctrl_HipsEffector.msg" "Character1_HipsBPKG.act[1]";
connectAttr "Character1_Ctrl_Spine.rz" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine.ry" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine.rx" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine1.rz" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine1.ry" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine1.rx" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine2.rz" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine2.ry" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine2.rx" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine3.rz" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine3.ry" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Spine3.rx" "Character1_ChestBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.rz" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.ry" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.rx" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.tz" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.ty" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestOriginEffector.tx" "Character1_ChestBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_ChestEndEffector.rz" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_ChestEndEffector.ry" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_ChestEndEffector.rx" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_ChestEndEffector.tz" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_ChestEndEffector.ty" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_ChestEndEffector.tx" "Character1_ChestBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_Spine.msg" "Character1_ChestBPKG.act[0]";
connectAttr "Character1_Ctrl_Spine1.msg" "Character1_ChestBPKG.act[1]";
connectAttr "Character1_Ctrl_Spine2.msg" "Character1_ChestBPKG.act[2]";
connectAttr "Character1_Ctrl_Spine3.msg" "Character1_ChestBPKG.act[3]";
connectAttr "Character1_Ctrl_ChestOriginEffector.msg" "Character1_ChestBPKG.act[4]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.msg" "Character1_ChestBPKG.act[5]"
		;
connectAttr "Character1_Ctrl_LeftArm.rz" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftArm.ry" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftArm.rx" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftForeArm.rz" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftForeArm.ry" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftForeArm.rx" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftHand.rz" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftHand.ry" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftHand.rx" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftShoulder.rz" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftShoulder.ry" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftShoulder.rx" "Character1_LeftArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftWristEffector.rz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftWristEffector.ry" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftWristEffector.rx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftWristEffector.tz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftWristEffector.ty" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftWristEffector.tx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.rz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.ry" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.rx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.tz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.ty" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftElbowEffector.tx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.rz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.ry" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.rx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.tz" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.ty" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftShoulderEffector.tx" "Character1_LeftArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftArm.msg" "Character1_LeftArmBPKG.act[0]";
connectAttr "Character1_Ctrl_LeftForeArm.msg" "Character1_LeftArmBPKG.act[1]";
connectAttr "Character1_Ctrl_LeftHand.msg" "Character1_LeftArmBPKG.act[2]";
connectAttr "Character1_Ctrl_LeftShoulder.msg" "Character1_LeftArmBPKG.act[3]";
connectAttr "Character1_Ctrl_LeftWristEffector.msg" "Character1_LeftArmBPKG.act[4]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.msg" "Character1_LeftArmBPKG.act[5]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.msg" "Character1_LeftArmBPKG.act[6]"
		;
connectAttr "Character1_Ctrl_RightArm.rz" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightArm.ry" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightArm.rx" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightForeArm.rz" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightForeArm.ry" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightForeArm.rx" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightHand.rz" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightHand.ry" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightHand.rx" "Character1_RightArmBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightShoulder.rz" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightShoulder.ry" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightShoulder.rx" "Character1_RightArmBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightWristEffector.rz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightWristEffector.ry" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightWristEffector.rx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightWristEffector.tz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightWristEffector.ty" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightWristEffector.tx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.rz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.ry" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.rx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.tz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.ty" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightElbowEffector.tx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.rz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.ry" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.rx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.tz" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.ty" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightShoulderEffector.tx" "Character1_RightArmBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightArm.msg" "Character1_RightArmBPKG.act[0]";
connectAttr "Character1_Ctrl_RightForeArm.msg" "Character1_RightArmBPKG.act[1]";
connectAttr "Character1_Ctrl_RightHand.msg" "Character1_RightArmBPKG.act[2]";
connectAttr "Character1_Ctrl_RightShoulder.msg" "Character1_RightArmBPKG.act[3]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.msg" "Character1_RightArmBPKG.act[4]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.msg" "Character1_RightArmBPKG.act[5]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.msg" "Character1_RightArmBPKG.act[6]"
		;
connectAttr "Character1_Ctrl_LeftUpLeg.rz" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftUpLeg.ry" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftUpLeg.rx" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftLeg.rz" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftLeg.ry" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftLeg.rx" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftFoot.rz" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftFoot.ry" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftFoot.rx" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftToeBase.rz" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftToeBase.ry" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftToeBase.rx" "Character1_LeftLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.rz" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.ry" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.rx" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.tz" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.ty" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftAnkleEffector.tx" "Character1_LeftLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_LeftKneeEffector.rz" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftKneeEffector.ry" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftKneeEffector.rx" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftKneeEffector.tz" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftKneeEffector.ty" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftKneeEffector.tx" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.rz" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.ry" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.rx" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.tz" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.ty" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftFootEffector.tx" "Character1_LeftLegBPKG.dnsm" 
		-na;
connectAttr "Character1_Ctrl_LeftHipEffector.rz" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftHipEffector.ry" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftHipEffector.rx" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftHipEffector.tz" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftHipEffector.ty" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftHipEffector.tx" "Character1_LeftLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_LeftUpLeg.msg" "Character1_LeftLegBPKG.act[0]";
connectAttr "Character1_Ctrl_LeftLeg.msg" "Character1_LeftLegBPKG.act[1]";
connectAttr "Character1_Ctrl_LeftFoot.msg" "Character1_LeftLegBPKG.act[2]";
connectAttr "Character1_Ctrl_LeftToeBase.msg" "Character1_LeftLegBPKG.act[3]";
connectAttr "Character1_Ctrl_LeftAnkleEffector.msg" "Character1_LeftLegBPKG.act[4]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.msg" "Character1_LeftLegBPKG.act[5]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.msg" "Character1_LeftLegBPKG.act[6]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.msg" "Character1_LeftLegBPKG.act[7]"
		;
connectAttr "Character1_Ctrl_RightUpLeg.rz" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightUpLeg.ry" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightUpLeg.rx" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightLeg.rz" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightLeg.ry" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightLeg.rx" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightFoot.rz" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightFoot.ry" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightFoot.rx" "Character1_RightLegBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_RightToeBase.rz" "Character1_RightLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightToeBase.ry" "Character1_RightLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightToeBase.rx" "Character1_RightLegBPKG.dnsm" -na
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.rz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightAnkleEffector.ry" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightAnkleEffector.rx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightAnkleEffector.tz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightAnkleEffector.ty" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightAnkleEffector.tx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.rz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.ry" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.rx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.tz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.ty" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightKneeEffector.tx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.rz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.ry" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.rx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.tz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.ty" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightFootEffector.tx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.rz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.ry" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.rx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.tz" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.ty" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightHipEffector.tx" "Character1_RightLegBPKG.dnsm"
		 -na;
connectAttr "Character1_Ctrl_RightUpLeg.msg" "Character1_RightLegBPKG.act[0]";
connectAttr "Character1_Ctrl_RightLeg.msg" "Character1_RightLegBPKG.act[1]";
connectAttr "Character1_Ctrl_RightFoot.msg" "Character1_RightLegBPKG.act[2]";
connectAttr "Character1_Ctrl_RightToeBase.msg" "Character1_RightLegBPKG.act[3]";
connectAttr "Character1_Ctrl_RightAnkleEffector.msg" "Character1_RightLegBPKG.act[4]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.msg" "Character1_RightLegBPKG.act[5]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.msg" "Character1_RightLegBPKG.act[6]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.msg" "Character1_RightLegBPKG.act[7]"
		;
connectAttr "Character1_Ctrl_Head.rz" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Head.ry" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Head.rx" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Neck.rz" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Neck.ry" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Neck.rx" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.rz" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.ry" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.rx" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.tz" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.ty" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_HeadEffector.tx" "Character1_HeadBPKG.dnsm" -na;
connectAttr "Character1_Ctrl_Head.msg" "Character1_HeadBPKG.act[0]";
connectAttr "Character1_Ctrl_Neck.msg" "Character1_HeadBPKG.act[1]";
connectAttr "Character1_Ctrl_HeadEffector.msg" "Character1_HeadBPKG.act[2]";
connectAttr "Character1.OutputCharacterDefinition" "HIKFK2State1.InputCharacterDefinition"
		;
connectAttr "Character1_Ctrl_Reference.wm" "HIKFK2State1.ReferenceGX";
connectAttr "Character1_Ctrl_Hips.wm" "HIKFK2State1.HipsGX";
connectAttr "Character1_Ctrl_LeftUpLeg.wm" "HIKFK2State1.LeftUpLegGX";
connectAttr "Character1_Ctrl_LeftLeg.wm" "HIKFK2State1.LeftLegGX";
connectAttr "Character1_Ctrl_LeftFoot.wm" "HIKFK2State1.LeftFootGX";
connectAttr "Character1_Ctrl_RightUpLeg.wm" "HIKFK2State1.RightUpLegGX";
connectAttr "Character1_Ctrl_RightLeg.wm" "HIKFK2State1.RightLegGX";
connectAttr "Character1_Ctrl_RightFoot.wm" "HIKFK2State1.RightFootGX";
connectAttr "Character1_Ctrl_Spine.wm" "HIKFK2State1.SpineGX";
connectAttr "Character1_Ctrl_LeftArm.wm" "HIKFK2State1.LeftArmGX";
connectAttr "Character1_Ctrl_LeftForeArm.wm" "HIKFK2State1.LeftForeArmGX";
connectAttr "Character1_Ctrl_LeftHand.wm" "HIKFK2State1.LeftHandGX";
connectAttr "Character1_Ctrl_RightArm.wm" "HIKFK2State1.RightArmGX";
connectAttr "Character1_Ctrl_RightForeArm.wm" "HIKFK2State1.RightForeArmGX";
connectAttr "Character1_Ctrl_RightHand.wm" "HIKFK2State1.RightHandGX";
connectAttr "Character1_Ctrl_Head.wm" "HIKFK2State1.HeadGX";
connectAttr "Character1_Ctrl_LeftToeBase.wm" "HIKFK2State1.LeftToeBaseGX";
connectAttr "Character1_Ctrl_RightToeBase.wm" "HIKFK2State1.RightToeBaseGX";
connectAttr "Character1_Ctrl_LeftShoulder.wm" "HIKFK2State1.LeftShoulderGX";
connectAttr "Character1_Ctrl_RightShoulder.wm" "HIKFK2State1.RightShoulderGX";
connectAttr "Character1_Ctrl_Neck.wm" "HIKFK2State1.NeckGX";
connectAttr "Character1_Ctrl_Spine1.wm" "HIKFK2State1.Spine1GX";
connectAttr "Character1_Ctrl_Spine2.wm" "HIKFK2State1.Spine2GX";
connectAttr "Character1_Ctrl_Spine3.wm" "HIKFK2State1.Spine3GX";
connectAttr "Character1_Ctrl_HipsEffector.wm" "HIKEffector2State1.HipsEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_HipsEffector.rt" "HIKEffector2State1.HipsEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_HipsEffector.rr" "HIKEffector2State1.HipsEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_HipsEffector.po" "HIKEffector2State1.HipsEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_HipsEffector.pull" "HIKEffector2State1.HipsEffectorPull"
		;
connectAttr "Character1_Ctrl_HipsEffector.stiffness" "HIKEffector2State1.HipsEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.wm" "HIKEffector2State1.LeftAnkleEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.rt" "HIKEffector2State1.LeftAnkleEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.rr" "HIKEffector2State1.LeftAnkleEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.po" "HIKEffector2State1.LeftAnkleEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.pull" "HIKEffector2State1.LeftAnkleEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.stiffness" "HIKEffector2State1.LeftAnkleEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.wm" "HIKEffector2State1.RightAnkleEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.rt" "HIKEffector2State1.RightAnkleEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.rr" "HIKEffector2State1.RightAnkleEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.po" "HIKEffector2State1.RightAnkleEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.pull" "HIKEffector2State1.RightAnkleEffectorPull"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.stiffness" "HIKEffector2State1.RightAnkleEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.wm" "HIKEffector2State1.LeftWristEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.rt" "HIKEffector2State1.LeftWristEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.rr" "HIKEffector2State1.LeftWristEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.po" "HIKEffector2State1.LeftWristEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.pull" "HIKEffector2State1.LeftWristEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.stiffness" "HIKEffector2State1.LeftWristEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightWristEffector.wm" "HIKEffector2State1.RightWristEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.rt" "HIKEffector2State1.RightWristEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.rr" "HIKEffector2State1.RightWristEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.po" "HIKEffector2State1.RightWristEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.pull" "HIKEffector2State1.RightWristEffectorPull"
		;
connectAttr "Character1_Ctrl_RightWristEffector.stiffness" "HIKEffector2State1.RightWristEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.wm" "HIKEffector2State1.LeftKneeEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.rt" "HIKEffector2State1.LeftKneeEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.rr" "HIKEffector2State1.LeftKneeEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.po" "HIKEffector2State1.LeftKneeEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.pull" "HIKEffector2State1.LeftKneeEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.stiffness" "HIKEffector2State1.LeftKneeEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.wm" "HIKEffector2State1.RightKneeEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.rt" "HIKEffector2State1.RightKneeEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.rr" "HIKEffector2State1.RightKneeEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.po" "HIKEffector2State1.RightKneeEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.pull" "HIKEffector2State1.RightKneeEffectorPull"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.stiffness" "HIKEffector2State1.RightKneeEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.wm" "HIKEffector2State1.LeftElbowEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.rt" "HIKEffector2State1.LeftElbowEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.rr" "HIKEffector2State1.LeftElbowEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.po" "HIKEffector2State1.LeftElbowEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.pull" "HIKEffector2State1.LeftElbowEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.stiffness" "HIKEffector2State1.LeftElbowEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.wm" "HIKEffector2State1.RightElbowEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.rt" "HIKEffector2State1.RightElbowEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.rr" "HIKEffector2State1.RightElbowEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.po" "HIKEffector2State1.RightElbowEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.pull" "HIKEffector2State1.RightElbowEffectorPull"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.stiffness" "HIKEffector2State1.RightElbowEffectorStiffness"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.wm" "HIKEffector2State1.ChestOriginEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.rt" "HIKEffector2State1.ChestOriginEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.rr" "HIKEffector2State1.ChestOriginEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.po" "HIKEffector2State1.ChestOriginEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.pull" "HIKEffector2State1.ChestOriginEffectorPull"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.stiffness" "HIKEffector2State1.ChestOriginEffectorStiffness"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.wm" "HIKEffector2State1.ChestEndEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.rt" "HIKEffector2State1.ChestEndEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.rr" "HIKEffector2State1.ChestEndEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.po" "HIKEffector2State1.ChestEndEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.pull" "HIKEffector2State1.ChestEndEffectorPull"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.stiffness" "HIKEffector2State1.ChestEndEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.wm" "HIKEffector2State1.LeftFootEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.rt" "HIKEffector2State1.LeftFootEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.rr" "HIKEffector2State1.LeftFootEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.po" "HIKEffector2State1.LeftFootEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.pull" "HIKEffector2State1.LeftFootEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.stiffness" "HIKEffector2State1.LeftFootEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightFootEffector.wm" "HIKEffector2State1.RightFootEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.rt" "HIKEffector2State1.RightFootEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.rr" "HIKEffector2State1.RightFootEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.po" "HIKEffector2State1.RightFootEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.pull" "HIKEffector2State1.RightFootEffectorPull"
		;
connectAttr "Character1_Ctrl_RightFootEffector.stiffness" "HIKEffector2State1.RightFootEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.wm" "HIKEffector2State1.LeftShoulderEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.rt" "HIKEffector2State1.LeftShoulderEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.rr" "HIKEffector2State1.LeftShoulderEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.po" "HIKEffector2State1.LeftShoulderEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.pull" "HIKEffector2State1.LeftShoulderEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.stiffness" "HIKEffector2State1.LeftShoulderEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.wm" "HIKEffector2State1.RightShoulderEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.rt" "HIKEffector2State1.RightShoulderEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.rr" "HIKEffector2State1.RightShoulderEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.po" "HIKEffector2State1.RightShoulderEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.pull" "HIKEffector2State1.RightShoulderEffectorPull"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.stiffness" "HIKEffector2State1.RightShoulderEffectorStiffness"
		;
connectAttr "Character1_Ctrl_HeadEffector.wm" "HIKEffector2State1.HeadEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.rt" "HIKEffector2State1.HeadEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.rr" "HIKEffector2State1.HeadEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.po" "HIKEffector2State1.HeadEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.pull" "HIKEffector2State1.HeadEffectorPull"
		;
connectAttr "Character1_Ctrl_HeadEffector.stiffness" "HIKEffector2State1.HeadEffectorStiffness"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.wm" "HIKEffector2State1.LeftHipEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.rt" "HIKEffector2State1.LeftHipEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.rr" "HIKEffector2State1.LeftHipEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.po" "HIKEffector2State1.LeftHipEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.pull" "HIKEffector2State1.LeftHipEffectorPull"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.stiffness" "HIKEffector2State1.LeftHipEffectorStiffness"
		;
connectAttr "Character1_Ctrl_RightHipEffector.wm" "HIKEffector2State1.RightHipEffectorGX[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.rt" "HIKEffector2State1.RightHipEffectorReachT[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.rr" "HIKEffector2State1.RightHipEffectorReachR[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.po" "HIKEffector2State1.RightHipEffectorPivot[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.pull" "HIKEffector2State1.RightHipEffectorPull"
		;
connectAttr "Character1_Ctrl_RightHipEffector.stiffness" "HIKEffector2State1.RightHipEffectorStiffness"
		;
connectAttr "HIKEffector2State1.EFF" "HIKPinning2State1.InputEffectorState";
connectAttr "HIKEffector2State1.EFFNA" "HIKPinning2State1.InputEffectorStateNoAux"
		;
connectAttr "Character1_Ctrl_HipsEffector.pint" "HIKPinning2State1.HipsEffectorPinT"
		;
connectAttr "Character1_Ctrl_HipsEffector.pinr" "HIKPinning2State1.HipsEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.pint" "HIKPinning2State1.LeftAnkleEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.pinr" "HIKPinning2State1.LeftAnkleEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.pint" "HIKPinning2State1.RightAnkleEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.pinr" "HIKPinning2State1.RightAnkleEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.pint" "HIKPinning2State1.LeftWristEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.pinr" "HIKPinning2State1.LeftWristEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightWristEffector.pint" "HIKPinning2State1.RightWristEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightWristEffector.pinr" "HIKPinning2State1.RightWristEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.pint" "HIKPinning2State1.LeftKneeEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.pinr" "HIKPinning2State1.LeftKneeEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.pint" "HIKPinning2State1.RightKneeEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.pinr" "HIKPinning2State1.RightKneeEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.pint" "HIKPinning2State1.LeftElbowEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.pinr" "HIKPinning2State1.LeftElbowEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.pint" "HIKPinning2State1.RightElbowEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.pinr" "HIKPinning2State1.RightElbowEffectorPinR"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.pint" "HIKPinning2State1.ChestOriginEffectorPinT"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.pinr" "HIKPinning2State1.ChestOriginEffectorPinR"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.pint" "HIKPinning2State1.ChestEndEffectorPinT"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.pinr" "HIKPinning2State1.ChestEndEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.pint" "HIKPinning2State1.LeftFootEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.pinr" "HIKPinning2State1.LeftFootEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightFootEffector.pint" "HIKPinning2State1.RightFootEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightFootEffector.pinr" "HIKPinning2State1.RightFootEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.pint" "HIKPinning2State1.LeftShoulderEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.pinr" "HIKPinning2State1.LeftShoulderEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.pint" "HIKPinning2State1.RightShoulderEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.pinr" "HIKPinning2State1.RightShoulderEffectorPinR"
		;
connectAttr "Character1_Ctrl_HeadEffector.pint" "HIKPinning2State1.HeadEffectorPinT"
		;
connectAttr "Character1_Ctrl_HeadEffector.pinr" "HIKPinning2State1.HeadEffectorPinR"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.pint" "HIKPinning2State1.LeftHipEffectorPinT"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.pinr" "HIKPinning2State1.LeftHipEffectorPinR"
		;
connectAttr "Character1_Ctrl_RightHipEffector.pint" "HIKPinning2State1.RightHipEffectorPinT"
		;
connectAttr "Character1_Ctrl_RightHipEffector.pinr" "HIKPinning2State1.RightHipEffectorPinR"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKState2FK1.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKState2FK1.InputCharacterState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKState2FK2.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.decs" "HIKState2FK2.InputCharacterState";
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKEffectorFromCharacter1.InputCharacterState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKEffectorFromCharacter1.InputCharacterDefinition"
		;
connectAttr "HIKproperties1.OutputPropertySetState" "HIKEffectorFromCharacter1.InputPropertySetState"
		;
connectAttr "HIKSolverNode1.decs" "HIKEffectorFromCharacter2.InputCharacterState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKEffectorFromCharacter2.InputCharacterDefinition"
		;
connectAttr "HIKproperties1.OutputPropertySetState" "HIKEffectorFromCharacter2.InputPropertySetState"
		;
connectAttr "Character1_Ctrl_HipsEffector.po" "HIKState2Effector1.HipsEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.po" "HIKState2Effector1.LeftAnkleEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.po" "HIKState2Effector1.RightAnkleEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.po" "HIKState2Effector1.LeftWristEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.po" "HIKState2Effector1.RightWristEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.po" "HIKState2Effector1.LeftKneeEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.po" "HIKState2Effector1.RightKneeEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.po" "HIKState2Effector1.LeftElbowEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.po" "HIKState2Effector1.RightElbowEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.po" "HIKState2Effector1.ChestOriginEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.po" "HIKState2Effector1.ChestEndEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.po" "HIKState2Effector1.LeftFootEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.po" "HIKState2Effector1.RightFootEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.po" "HIKState2Effector1.LeftShoulderEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.po" "HIKState2Effector1.RightShoulderEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.po" "HIKState2Effector1.HeadEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.po" "HIKState2Effector1.LeftHipEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.po" "HIKState2Effector1.RightHipEffectorpivotOffset[0]"
		;
connectAttr "HIKEffectorFromCharacter1.OutputEffectorState" "HIKState2Effector1.InputEffectorState"
		;
connectAttr "Character1_Ctrl_HipsEffector.po" "HIKState2Effector2.HipsEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector.po" "HIKState2Effector2.LeftAnkleEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector.po" "HIKState2Effector2.RightAnkleEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftWristEffector.po" "HIKState2Effector2.LeftWristEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightWristEffector.po" "HIKState2Effector2.RightWristEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector.po" "HIKState2Effector2.LeftKneeEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightKneeEffector.po" "HIKState2Effector2.RightKneeEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector.po" "HIKState2Effector2.LeftElbowEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightElbowEffector.po" "HIKState2Effector2.RightElbowEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector.po" "HIKState2Effector2.ChestOriginEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_ChestEndEffector.po" "HIKState2Effector2.ChestEndEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftFootEffector.po" "HIKState2Effector2.LeftFootEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightFootEffector.po" "HIKState2Effector2.RightFootEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector.po" "HIKState2Effector2.LeftShoulderEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector.po" "HIKState2Effector2.RightShoulderEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_HeadEffector.po" "HIKState2Effector2.HeadEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_LeftHipEffector.po" "HIKState2Effector2.LeftHipEffectorpivotOffset[0]"
		;
connectAttr "Character1_Ctrl_RightHipEffector.po" "HIKState2Effector2.RightHipEffectorpivotOffset[0]"
		;
connectAttr "HIKEffectorFromCharacter2.OutputEffectorState" "HIKState2Effector2.InputEffectorState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKRetargeterNode1.InputCharacterDefinitionDst"
		;
connectAttr "HIKproperties1.OutputPropertySetState" "HIKRetargeterNode1.InputDstPropertySetState"
		;
connectAttr "HIKSK2State1.OutputCharacterState" "HIKRetargeterNode1.InputCharacterState"
		;
connectAttr "HIKState2SK1.HipsT" "pairBlend1.it2";
connectAttr "HIKState2SK1.HipsR" "pairBlend1.ir2";
connectAttr "HIKState2SK1.LeftUpLegT" "pairBlend2.it2";
connectAttr "HIKState2SK1.LeftUpLegR" "pairBlend2.ir2";
connectAttr "HIKState2SK1.LeftLegT" "pairBlend3.it2";
connectAttr "HIKState2SK1.LeftLegR" "pairBlend3.ir2";
connectAttr "HIKState2SK1.LeftFootT" "pairBlend4.it2";
connectAttr "HIKState2SK1.LeftFootR" "pairBlend4.ir2";
connectAttr "HIKState2SK1.RightUpLegT" "pairBlend5.it2";
connectAttr "HIKState2SK1.RightUpLegR" "pairBlend5.ir2";
connectAttr "HIKState2SK1.RightLegT" "pairBlend6.it2";
connectAttr "HIKState2SK1.RightLegR" "pairBlend6.ir2";
connectAttr "HIKState2SK1.RightFootT" "pairBlend7.it2";
connectAttr "HIKState2SK1.RightFootR" "pairBlend7.ir2";
connectAttr "HIKState2SK1.SpineT" "pairBlend8.it2";
connectAttr "HIKState2SK1.SpineR" "pairBlend8.ir2";
connectAttr "HIKState2SK1.LeftArmT" "pairBlend9.it2";
connectAttr "HIKState2SK1.LeftArmR" "pairBlend9.ir2";
connectAttr "HIKState2SK1.LeftForeArmT" "pairBlend10.it2";
connectAttr "HIKState2SK1.LeftForeArmR" "pairBlend10.ir2";
connectAttr "HIKState2SK1.LeftHandT" "pairBlend11.it2";
connectAttr "HIKState2SK1.LeftHandR" "pairBlend11.ir2";
connectAttr "HIKState2SK1.RightArmT" "pairBlend12.it2";
connectAttr "HIKState2SK1.RightArmR" "pairBlend12.ir2";
connectAttr "HIKState2SK1.RightForeArmT" "pairBlend13.it2";
connectAttr "HIKState2SK1.RightForeArmR" "pairBlend13.ir2";
connectAttr "HIKState2SK1.RightHandT" "pairBlend14.it2";
connectAttr "HIKState2SK1.RightHandR" "pairBlend14.ir2";
connectAttr "HIKState2SK1.HeadT" "pairBlend15.it2";
connectAttr "HIKState2SK1.HeadR" "pairBlend15.ir2";
connectAttr "HIKState2SK1.LeftToeBaseT" "pairBlend16.it2";
connectAttr "HIKState2SK1.LeftToeBaseR" "pairBlend16.ir2";
connectAttr "HIKState2SK1.RightToeBaseT" "pairBlend17.it2";
connectAttr "HIKState2SK1.RightToeBaseR" "pairBlend17.ir2";
connectAttr "HIKState2SK1.LeftShoulderT" "pairBlend18.it2";
connectAttr "HIKState2SK1.LeftShoulderR" "pairBlend18.ir2";
connectAttr "HIKState2SK1.RightShoulderT" "pairBlend19.it2";
connectAttr "HIKState2SK1.RightShoulderR" "pairBlend19.ir2";
connectAttr "HIKState2SK1.NeckT" "pairBlend20.it2";
connectAttr "HIKState2SK1.NeckR" "pairBlend20.ir2";
connectAttr "HIKState2SK1.Spine1T" "pairBlend21.it2";
connectAttr "HIKState2SK1.Spine1R" "pairBlend21.ir2";
connectAttr "HIKState2SK1.Spine2T" "pairBlend22.it2";
connectAttr "HIKState2SK1.Spine2R" "pairBlend22.ir2";
connectAttr "HIKState2SK1.Spine3T" "pairBlend23.it2";
connectAttr "HIKState2SK1.Spine3R" "pairBlend23.ir2";
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
// End of overboss_stun.ma
