//Maya ASCII 2016 scene
//Name: overboss_death.ma
//Last modified: Wed, May 27, 2015 11:53:12 AM
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
	setAttr ".t" -type "double3" -415.93267420131087 319.25661142029242 400.32191664831794 ;
	setAttr ".r" -type "double3" -23.138352729626305 -46.199999999999839 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 624.49945544082186;
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
	rename -uid "6383DDAD-4FA9-531C-9694-3E8016E313D3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "84EAF5A7-46C1-AB3A-86F9-D1AB79056C5A";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "47C026A4-4FDE-9836-E778-47A4D6FAD76D";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90 -90 0 ;
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
	rename -uid "3D5A6BF3-482B-87EB-C8CE-AFB1D86ACE0C";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648357550790436 265.29219349260308 -7.6333312355124402e-014 ;
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
	rename -uid "815FB876-4FA5-E04B-D3EF-9C8605A37780";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 78.648339634731641 -85.292375348586049 0 ;
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
	rename -uid "4C0D6AE8-4B7E-342D-AB5C-E89AECB1F3AF";
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
	rename -uid "B3761A1F-449C-F8E6-CFBE-82954C546346";
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
	rename -uid "062FA630-45D6-33D2-4BEA-F48C8A73CCCF";
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
	rename -uid "CD9232DA-4872-D877-E2BB-5FA9C92CB391";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 41.818515442763903 -75.665996898119388 1.2846882449534545e-014 ;
	setAttr -l on ".ra";
	setAttr ".ei" 6;
	setAttr ".radi" 1.9283336707279293;
	setAttr -l on ".jo" -type "double3" -74.53235620310916 46.224807712094766 -69.031565591661774 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_LeftElbowEffector" -p "Character1_Ctrl_Reference";
	rename -uid "28294580-427A-1414-9346-2EB8C5708E8E";
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
	setAttr -l on ".jo" -type "double3" 90 -1.833790743017201e-006 0 ;
	setAttr -l on ".jo";
	setAttr ".tof" -type "double3" 0 0 -9.6416683536396466 ;
	setAttr ".lk" 6;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_RightElbowEffector" -p "Character1_Ctrl_Reference";
	rename -uid "397612D7-42ED-2967-ABF7-BB80CA95A4E9";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 90.003699867130067 -0.67628830848535038 -0.31346036354365969 ;
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
	rename -uid "C1984436-4DFC-CBBB-E59A-06868ED2CE2F";
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
	rename -uid "F2571351-4E32-2ECC-A792-3883D97E2186";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -108.18153308427867 -89.999999999999972 0 ;
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
	rename -uid "A8ACE839-4C2A-2352-DBFF-4494D0FF781A";
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
	rename -uid "6A8D1AFA-49E0-733B-C85F-85B96135E5EA";
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
	rename -uid "D3EF322D-4118-F73A-2084-B89D684D6B80";
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
	rename -uid "E9D05957-442A-E172-6DC6-75B346379345";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90.017176845349368 -1.2070246691672977 0.81536621021078848 ;
	setAttr -l on ".ra";
	setAttr ".ei" 14;
	setAttr ".radi" 7.7133346829117171;
	setAttr -l on ".jo" -type "double3" 90.017174771464326 0.81500434340307615 1.2072690178559695 ;
	setAttr -l on ".jo";
	setAttr ".rof" -type "double3" 0 0 90 ;
	setAttr ".lk" 1;
	setAttr -cb on ".pull";
	setAttr -cb on ".stiffness" 0.5;
instanceable -a 0;
createNode hikIKEffector -n "Character1_Ctrl_HeadEffector" -p "Character1_Ctrl_Reference";
	rename -uid "17E40D1F-468C-D653-0201-B4B54E51EC7D";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 4;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90 -90 0 ;
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
	rename -uid "5B2CBC55-4489-6A3F-CFD8-FA96407312F8";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -72.161724070196215 -85.505429986291404 180 ;
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
	rename -uid "E11B0BEF-4ECB-33B1-CAAE-9B940A24D044";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	addAttr -ci true -sn "pull" -ln "pull" -min 0 -max 1 -at "double";
	addAttr -ci true -sn "stiffness" -ln "stiffness" -min 0 -max 1 -at "double";
	setAttr -k off -cb on ".v";
	setAttr ".ove" yes;
	setAttr ".ovc" 6;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" 107.83826361025565 -85.505652076667786 -4.0588618618416409e-014 ;
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
	rename -uid "A0D2E699-4B26-C7AB-DF22-9FAF13307B2A";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".ovc" 25;
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr -l on ".ra" -type "double3" -90 -90 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftUpLeg" -p "Character1_Ctrl_Hips";
	rename -uid "9CE3B0AF-4B87-9350-F904-DB9C64704888";
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
	setAttr -l on ".ra" -type "double3" -72.161724070196215 -85.505429986291404 180 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -88.555427765641255 -17.781584091030204 -94.720557824158519 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftLeg" -p "Character1_Ctrl_LeftUpLeg";
	rename -uid "4840E95B-4A7E-8350-2CA6-CF9BEF431448";
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
	rename -uid "7FE5CAD1-422B-2466-B0D0-E4977E9B688F";
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
	setAttr -l on ".ra" -type "double3" 78.648357550790436 265.29219349260308 -7.6333312355124402e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -90.943977535049385 11.312837968166692 -94.801304967472689 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftToeBase" -p "Character1_Ctrl_LeftFoot";
	rename -uid "318BD820-42FB-928F-BC55-C2B0F72CCE19";
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
	rename -uid "61AC08F5-4706-75FA-5FAF-29812EA049F5";
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
	setAttr -l on ".ra" -type "double3" 107.83826361025565 -85.505652076667786 -4.0588618618416409e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -91.444499965635828 -17.78157741199843 -85.279675659309802 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightLeg" -p "Character1_Ctrl_RightUpLeg";
	rename -uid "D8A57F66-4D1B-78CB-2FA6-1DACF2B92F31";
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
	setAttr -l on ".ra" -type "double3" 41.818515442763903 -75.665996898119388 1.2846882449534545e-014 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -74.53235620310916 46.224807712094766 -69.031565591661774 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightFoot" -p "Character1_Ctrl_RightLeg";
	rename -uid "7A4DA8B7-4E2E-08D2-3144-11A47791C0E0";
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
	setAttr -l on ".ra" -type "double3" 78.648339634731641 -85.292375348586049 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -89.056057311567685 11.312858817339892 -85.198880166696796 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightToeBase" -p "Character1_Ctrl_RightFoot";
	rename -uid "0FE63895-4EF0-83E9-5998-5C91BD4577AC";
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
	rename -uid "746F888C-45E9-DA76-43A8-BDBB208A5BD1";
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
	rename -uid "8C432A06-45BF-392B-221B-3DAE1DD5D4C0";
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
	rename -uid "480655B9-43C8-D65E-AA83-9EB4F261433D";
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
	setAttr -l on ".ra" -type "double3" -79.854834795333602 -89.999999999999943 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 10.145165204666403 89.999999999999957 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_Spine3" -p "Character1_Ctrl_Spine2";
	rename -uid "6A9EA800-48AA-857F-9E1E-7581699CFBB3";
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
	setAttr -l on ".ra" -type "double3" -108.18153308427867 -89.999999999999972 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.000000000000014 -18.181533084278694 89.999999999999986 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftShoulder" -p "Character1_Ctrl_Spine3";
	rename -uid "EBAFEED8-41D1-9B1C-23BE-B59A6A41052D";
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
	setAttr -l on ".ra" -type "double3" 0.27184377507479268 -21.217224574734775 -0.75110972960021005 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -2.665518353104422e-017 21.218885655887302 0.70019316385605757 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftArm" -p "Character1_Ctrl_LeftShoulder";
	rename -uid "012A6423-4B5B-926E-9D9C-5FB7A2696068";
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
	rename -uid "EE6355AE-4401-EDA6-38E9-16BBF63B2EDC";
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
	setAttr -l on ".jo" -type "double3" 90 -1.833790743017201e-006 0 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_LeftHand" -p "Character1_Ctrl_LeftForeArm";
	rename -uid "9693104B-41BF-21A5-44E1-36ACCB202973";
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
	rename -uid "3199992D-4BB3-EDA4-4534-74B9536758F4";
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
	setAttr -l on ".ra" -type "double3" 0.27281685064397865 21.217434205790177 0.75379098431415203 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 2.6655223544057194e-017 -21.219107181425706 
		-0.70269164344685653 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightArm" -p "Character1_Ctrl_RightShoulder";
	rename -uid "FC1B3934-4F71-FE50-D397-8E8439504644";
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
	setAttr -l on ".ra" -type "double3" -90.017176845349368 -1.2070246691672977 0.81536621021078848 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90.017174771464326 0.81500434340307615 1.2072690178559695 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightForeArm" -p "Character1_Ctrl_RightArm";
	rename -uid "E8097887-4625-893A-DB97-00BE633067B1";
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
	setAttr -l on ".ra" -type "double3" 90.003699867130067 -0.67628830848535038 -0.31346036354365969 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" -90.003699664748936 0.31341669267919825 -0.6763085475273839 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode hikFKJoint -n "Character1_Ctrl_RightHand" -p "Character1_Ctrl_RightForeArm";
	rename -uid "A8F0F96F-4BBD-7E1E-AE05-9093C09E63BB";
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
	rename -uid "A07B35B0-4F10-6002-465C-248F483883C8";
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
	rename -uid "5AEBB77F-43B8-7F2A-26ED-46B2E178BF55";
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
	setAttr -l on ".ra" -type "double3" -90 -90 0 ;
	setAttr -l on ".ra";
	setAttr -l on ".jo" -type "double3" 90 0 90 ;
	setAttr -l on ".jo";
	setAttr ".radi" 3.8566673414558585;
instanceable -a 0;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "42949D8A-43DF-079D-69C8-89B3FD7533C0";
	setAttr -s 23 ".lnk";
	setAttr -s 23 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "D5BF0D86-48C7-CEC0-EBD3-1CB52F81300E";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "EC87F5E6-4EA7-35F0-B105-30960D685686";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "2176905E-4B8D-64F1-3697-C9A6C6860B23";
	setAttr ".g" yes;
createNode reference -n "RIGRN";
	rename -uid "AC5E3B45-47E8-0DD5-42BA-5B9B451E7F50";
	setAttr -s 506 ".phl";
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
		"RIGRN.placeHolderList[369]" "RIG:MODEL:Head0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[370]" "RIG:MODEL:Head0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[371]" "RIG:MODEL:Head0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[372]" "RIG:MODEL:Head0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[373]" "RIG:MODEL:Head0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Head0_JNT_SURROGATE|RIG:__NeckHeadConstraint|RIG:NeckHead_headSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[374]" "RIG:MODEL:Head0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[375]" "RIG:MODEL:LfArm0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[376]" "RIG:MODEL:LfArm0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[377]" "RIG:MODEL:LfArm0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[378]" "RIG:MODEL:LfArm0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[379]" "RIG:MODEL:LfArm0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm0_JNT_SURROGATE|RIG:__LfShoulderConstraint|RIG:LfShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[380]" "RIG:MODEL:LfArm0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[381]" "RIG:MODEL:LfArm1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[382]" "RIG:MODEL:LfArm1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[383]" "RIG:MODEL:LfArm1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[384]" "RIG:MODEL:LfArm1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[385]" "RIG:MODEL:LfArm1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm1_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[386]" "RIG:MODEL:LfArm1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[387]" "RIG:MODEL:LfArm2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[388]" "RIG:MODEL:LfArm2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[389]" "RIG:MODEL:LfArm2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[390]" "RIG:MODEL:LfArm2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[391]" "RIG:MODEL:LfArm2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm2_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[392]" "RIG:MODEL:LfArm2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[393]" "RIG:MODEL:LfArm3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[394]" "RIG:MODEL:LfArm3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[395]" "RIG:MODEL:LfArm3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[396]" "RIG:MODEL:LfArm3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[397]" "RIG:MODEL:LfArm3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfArm3_JNT_SURROGATE|RIG:__LfArmConstraint|RIG:LfArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[398]" "RIG:MODEL:LfArm3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[399]" "RIG:MODEL:LfLeg0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[400]" "RIG:MODEL:LfLeg0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[401]" "RIG:MODEL:LfLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[402]" "RIG:MODEL:LfLeg0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[403]" "RIG:MODEL:LfLeg0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg0_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[404]" "RIG:MODEL:LfLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[405]" "RIG:MODEL:LfLeg1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[406]" "RIG:MODEL:LfLeg1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[407]" "RIG:MODEL:LfLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[408]" "RIG:MODEL:LfLeg1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[409]" "RIG:MODEL:LfLeg1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg1_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[410]" "RIG:MODEL:LfLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[411]" "RIG:MODEL:LfLeg2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[412]" "RIG:MODEL:LfLeg2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[413]" "RIG:MODEL:LfLeg2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[414]" "RIG:MODEL:LfLeg2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[415]" "RIG:MODEL:LfLeg2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg2_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[416]" "RIG:MODEL:LfLeg2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[417]" "RIG:MODEL:LfLeg3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[418]" "RIG:MODEL:LfLeg3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[419]" "RIG:MODEL:LfLeg3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[420]" "RIG:MODEL:LfLeg3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[421]" "RIG:MODEL:LfLeg3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:LfLeg3_JNT_SURROGATE|RIG:__LfLegConstraint|RIG:LfLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[422]" "RIG:MODEL:LfLeg3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[423]" "RIG:MODEL:Neck0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[424]" "RIG:MODEL:Neck0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[425]" "RIG:MODEL:Neck0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[426]" "RIG:MODEL:Neck0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[427]" "RIG:MODEL:Neck0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Neck0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:NeckHead_neckSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[428]" "RIG:MODEL:Neck0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[429]" "RIG:MODEL:Root_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[430]" "RIG:MODEL:Root_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[431]" "RIG:MODEL:Root_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[432]" "RIG:MODEL:Root_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[433]" "RIG:MODEL:Root_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Root_JNT_SURROGATE|RIG:__KOBOLD_OVERBOSSConstraint|RIG:FkRoot0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[434]" "RIG:MODEL:Root_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[435]" "RIG:MODEL:RtArm0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[436]" "RIG:MODEL:RtArm0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[437]" "RIG:MODEL:RtArm0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[438]" "RIG:MODEL:RtArm0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[439]" "RIG:MODEL:RtArm0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm0_JNT_SURROGATE|RIG:__RtShoulderConstraint|RIG:RtShoulderDriver0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[440]" "RIG:MODEL:RtArm0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[441]" "RIG:MODEL:RtArm1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[442]" "RIG:MODEL:RtArm1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[443]" "RIG:MODEL:RtArm1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[444]" "RIG:MODEL:RtArm1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[445]" "RIG:MODEL:RtArm1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm1_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[446]" "RIG:MODEL:RtArm1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[447]" "RIG:MODEL:RtArm2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[448]" "RIG:MODEL:RtArm2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[449]" "RIG:MODEL:RtArm2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[450]" "RIG:MODEL:RtArm2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[451]" "RIG:MODEL:RtArm2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm2_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[452]" "RIG:MODEL:RtArm2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[453]" "RIG:MODEL:RtArm3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[454]" "RIG:MODEL:RtArm3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[455]" "RIG:MODEL:RtArm3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[456]" "RIG:MODEL:RtArm3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[457]" "RIG:MODEL:RtArm3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtArm3_JNT_SURROGATE|RIG:__RtArmConstraint|RIG:RtArmRig2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[458]" "RIG:MODEL:RtArm3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[459]" "RIG:MODEL:RtLeg0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[460]" "RIG:MODEL:RtLeg0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[461]" "RIG:MODEL:RtLeg0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[462]" "RIG:MODEL:RtLeg0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[463]" "RIG:MODEL:RtLeg0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg0_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[464]" "RIG:MODEL:RtLeg0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[465]" "RIG:MODEL:RtLeg1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[466]" "RIG:MODEL:RtLeg1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[467]" "RIG:MODEL:RtLeg1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[468]" "RIG:MODEL:RtLeg1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[469]" "RIG:MODEL:RtLeg1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg1_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[470]" "RIG:MODEL:RtLeg1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[471]" "RIG:MODEL:RtLeg2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[472]" "RIG:MODEL:RtLeg2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[473]" "RIG:MODEL:RtLeg2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[474]" "RIG:MODEL:RtLeg2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[475]" "RIG:MODEL:RtLeg2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg2_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg0_JNT1_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[476]" "RIG:MODEL:RtLeg2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[477]" "RIG:MODEL:RtLeg3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[478]" "RIG:MODEL:RtLeg3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[479]" "RIG:MODEL:RtLeg3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[480]" "RIG:MODEL:RtLeg3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[481]" "RIG:MODEL:RtLeg3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:RtLeg3_JNT_SURROGATE|RIG:__RtLegConstraint|RIG:RtLeg1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[482]" "RIG:MODEL:RtLeg3_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[483]" "RIG:MODEL:Spine0_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[484]" "RIG:MODEL:Spine0_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[485]" "RIG:MODEL:Spine0_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[486]" "RIG:MODEL:Spine0_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[487]" "RIG:MODEL:Spine0_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine0_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline0_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[488]" "RIG:MODEL:Spine0_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[489]" "RIG:MODEL:Spine1_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[490]" "RIG:MODEL:Spine1_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[491]" "RIG:MODEL:Spine1_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[492]" "RIG:MODEL:Spine1_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[493]" "RIG:MODEL:Spine1_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine1_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline1_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[494]" "RIG:MODEL:Spine1_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[495]" "RIG:MODEL:Spine2_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[496]" "RIG:MODEL:Spine2_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[497]" "RIG:MODEL:Spine2_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[498]" "RIG:MODEL:Spine2_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[499]" "RIG:MODEL:Spine2_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine2_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline2_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[500]" "RIG:MODEL:Spine2_JNT.rz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateX" 
		"RIGRN.placeHolderList[501]" "RIG:MODEL:Spine3_JNT.tx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateY" 
		"RIGRN.placeHolderList[502]" "RIG:MODEL:Spine3_JNT.ty"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_pointConstraint.constraintTranslateZ" 
		"RIGRN.placeHolderList[503]" "RIG:MODEL:Spine3_JNT.tz"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateX" 
		"RIGRN.placeHolderList[504]" "RIG:MODEL:Spine3_JNT.rx"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateY" 
		"RIGRN.placeHolderList[505]" "RIG:MODEL:Spine3_JNT.ry"
		5 3 "RIGRN" "|RIG:KOBOLD_OVERBOSS|RIG:NoTouch_NUL|RIG:WeldedStagingNodes_GRP|RIG:UNSORTED|RIG:unsorted_NUL|RIG:Spine3_JNT_SURROGATE|RIG:__SpineConstraint|RIG:SpinespineSpline3_JNT_orientConstraint.constraintRotateZ" 
		"RIGRN.placeHolderList[506]" "RIG:MODEL:Spine3_JNT.rz"
		"RIG:MODELRN" 600
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
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleX" "RIGRN.placeHolderList[1]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleY" "RIGRN.placeHolderList[2]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.scaleZ" "RIGRN.placeHolderList[3]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateX" "RIGRN.placeHolderList[4]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateY" "RIGRN.placeHolderList[5]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.translateZ" "RIGRN.placeHolderList[6]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.parentMatrix" "RIGRN.placeHolderList[7]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateX" "RIGRN.placeHolderList[8]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateY" "RIGRN.placeHolderList[9]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT.rotateZ" "RIGRN.placeHolderList[10]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateOrder" "RIGRN.placeHolderList[11]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.jointOrient" "RIGRN.placeHolderList[12]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.segmentScaleCompensate" "RIGRN.placeHolderList[13]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.inverseScale" "RIGRN.placeHolderList[14]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.Character" "RIGRN.placeHolderList[15]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT.rotateAxis" "RIGRN.placeHolderList[16]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.inverseScale" 
		"RIGRN.placeHolderList[17]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleX" "RIGRN.placeHolderList[18]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleY" "RIGRN.placeHolderList[19]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.scaleZ" "RIGRN.placeHolderList[20]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[21]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateX" "RIGRN.placeHolderList[22]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateY" "RIGRN.placeHolderList[23]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.translateZ" "RIGRN.placeHolderList[24]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateX" "RIGRN.placeHolderList[25]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateY" "RIGRN.placeHolderList[26]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateZ" "RIGRN.placeHolderList[27]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateOrder" "RIGRN.placeHolderList[28]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.jointOrient" "RIGRN.placeHolderList[29]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[30]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.Character" "RIGRN.placeHolderList[31]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT.rotateAxis" "RIGRN.placeHolderList[32]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.inverseScale" 
		"RIGRN.placeHolderList[33]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleX" 
		"RIGRN.placeHolderList[34]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleY" 
		"RIGRN.placeHolderList[35]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.scaleZ" 
		"RIGRN.placeHolderList[36]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[37]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateX" 
		"RIGRN.placeHolderList[38]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateY" 
		"RIGRN.placeHolderList[39]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.translateZ" 
		"RIGRN.placeHolderList[40]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateX" 
		"RIGRN.placeHolderList[41]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateY" 
		"RIGRN.placeHolderList[42]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateZ" 
		"RIGRN.placeHolderList[43]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[44]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.jointOrient" 
		"RIGRN.placeHolderList[45]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[46]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.Character" 
		"RIGRN.placeHolderList[47]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[48]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.inverseScale" 
		"RIGRN.placeHolderList[49]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleX" 
		"RIGRN.placeHolderList[50]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleY" 
		"RIGRN.placeHolderList[51]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.scaleZ" 
		"RIGRN.placeHolderList[52]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[53]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateX" 
		"RIGRN.placeHolderList[54]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateY" 
		"RIGRN.placeHolderList[55]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.translateZ" 
		"RIGRN.placeHolderList[56]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateX" 
		"RIGRN.placeHolderList[57]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateY" 
		"RIGRN.placeHolderList[58]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateZ" 
		"RIGRN.placeHolderList[59]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[60]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.jointOrient" 
		"RIGRN.placeHolderList[61]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[62]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.Character" 
		"RIGRN.placeHolderList[63]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[64]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.inverseScale" 
		"RIGRN.placeHolderList[65]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleX" 
		"RIGRN.placeHolderList[66]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleY" 
		"RIGRN.placeHolderList[67]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.scaleZ" 
		"RIGRN.placeHolderList[68]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[69]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateX" 
		"RIGRN.placeHolderList[70]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateY" 
		"RIGRN.placeHolderList[71]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.translateZ" 
		"RIGRN.placeHolderList[72]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateX" 
		"RIGRN.placeHolderList[73]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateY" 
		"RIGRN.placeHolderList[74]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateZ" 
		"RIGRN.placeHolderList[75]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[76]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.jointOrient" 
		"RIGRN.placeHolderList[77]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[78]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.Character" 
		"RIGRN.placeHolderList[79]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[80]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.inverseScale" 
		"RIGRN.placeHolderList[81]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleX" 
		"RIGRN.placeHolderList[82]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleY" 
		"RIGRN.placeHolderList[83]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.scaleZ" 
		"RIGRN.placeHolderList[84]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[85]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateX" 
		"RIGRN.placeHolderList[86]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateY" 
		"RIGRN.placeHolderList[87]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.translateZ" 
		"RIGRN.placeHolderList[88]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateX" 
		"RIGRN.placeHolderList[89]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateY" 
		"RIGRN.placeHolderList[90]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateZ" 
		"RIGRN.placeHolderList[91]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[92]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.jointOrient" 
		"RIGRN.placeHolderList[93]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[94]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.Character" 
		"RIGRN.placeHolderList[95]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[96]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.inverseScale" 
		"RIGRN.placeHolderList[97]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleX" 
		"RIGRN.placeHolderList[98]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleY" 
		"RIGRN.placeHolderList[99]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.scaleZ" 
		"RIGRN.placeHolderList[100]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[101]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateX" 
		"RIGRN.placeHolderList[102]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateY" 
		"RIGRN.placeHolderList[103]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.translateZ" 
		"RIGRN.placeHolderList[104]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateX" 
		"RIGRN.placeHolderList[105]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateY" 
		"RIGRN.placeHolderList[106]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateZ" 
		"RIGRN.placeHolderList[107]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[108]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.jointOrient" 
		"RIGRN.placeHolderList[109]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[110]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.Character" 
		"RIGRN.placeHolderList[111]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:Neck0_JNT|RIG:MODEL:Head0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[112]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[113]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleX" 
		"RIGRN.placeHolderList[114]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleY" 
		"RIGRN.placeHolderList[115]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.scaleZ" 
		"RIGRN.placeHolderList[116]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[117]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateX" 
		"RIGRN.placeHolderList[118]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateY" 
		"RIGRN.placeHolderList[119]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[120]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[121]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[122]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[123]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[124]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[125]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[126]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.Character" 
		"RIGRN.placeHolderList[127]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[128]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[129]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleX" 
		"RIGRN.placeHolderList[130]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleY" 
		"RIGRN.placeHolderList[131]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.scaleZ" 
		"RIGRN.placeHolderList[132]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateX" 
		"RIGRN.placeHolderList[133]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateY" 
		"RIGRN.placeHolderList[134]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[135]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[136]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[137]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[138]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[139]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[140]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[141]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[142]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.Character" 
		"RIGRN.placeHolderList[143]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[144]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[145]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleX" 
		"RIGRN.placeHolderList[146]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleY" 
		"RIGRN.placeHolderList[147]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.scaleZ" 
		"RIGRN.placeHolderList[148]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateX" 
		"RIGRN.placeHolderList[149]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateY" 
		"RIGRN.placeHolderList[150]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[151]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[152]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[153]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[154]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[155]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[156]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[157]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[158]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.Character" 
		"RIGRN.placeHolderList[159]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[160]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[161]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleX" 
		"RIGRN.placeHolderList[162]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleY" 
		"RIGRN.placeHolderList[163]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.scaleZ" 
		"RIGRN.placeHolderList[164]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[165]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateX" 
		"RIGRN.placeHolderList[166]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateY" 
		"RIGRN.placeHolderList[167]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[168]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[169]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[170]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[171]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[172]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[173]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[174]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.Character" 
		"RIGRN.placeHolderList[175]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:LfArm0_JNT|RIG:MODEL:LfArm1_JNT|RIG:MODEL:LfArm2_JNT|RIG:MODEL:LfArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[176]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.inverseScale" 
		"RIGRN.placeHolderList[177]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleX" 
		"RIGRN.placeHolderList[178]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleY" 
		"RIGRN.placeHolderList[179]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.scaleZ" 
		"RIGRN.placeHolderList[180]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[181]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateX" 
		"RIGRN.placeHolderList[182]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateY" 
		"RIGRN.placeHolderList[183]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.translateZ" 
		"RIGRN.placeHolderList[184]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateX" 
		"RIGRN.placeHolderList[185]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateY" 
		"RIGRN.placeHolderList[186]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateZ" 
		"RIGRN.placeHolderList[187]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateOrder" 
		"RIGRN.placeHolderList[188]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.jointOrient" 
		"RIGRN.placeHolderList[189]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[190]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.Character" 
		"RIGRN.placeHolderList[191]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT.rotateAxis" 
		"RIGRN.placeHolderList[192]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.inverseScale" 
		"RIGRN.placeHolderList[193]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleX" 
		"RIGRN.placeHolderList[194]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleY" 
		"RIGRN.placeHolderList[195]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.scaleZ" 
		"RIGRN.placeHolderList[196]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateX" 
		"RIGRN.placeHolderList[197]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateY" 
		"RIGRN.placeHolderList[198]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.translateZ" 
		"RIGRN.placeHolderList[199]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[200]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateX" 
		"RIGRN.placeHolderList[201]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateY" 
		"RIGRN.placeHolderList[202]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateZ" 
		"RIGRN.placeHolderList[203]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[204]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.jointOrient" 
		"RIGRN.placeHolderList[205]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[206]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.Character" 
		"RIGRN.placeHolderList[207]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[208]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.inverseScale" 
		"RIGRN.placeHolderList[209]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleX" 
		"RIGRN.placeHolderList[210]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleY" 
		"RIGRN.placeHolderList[211]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.scaleZ" 
		"RIGRN.placeHolderList[212]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateX" 
		"RIGRN.placeHolderList[213]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateY" 
		"RIGRN.placeHolderList[214]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.translateZ" 
		"RIGRN.placeHolderList[215]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[216]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateX" 
		"RIGRN.placeHolderList[217]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateY" 
		"RIGRN.placeHolderList[218]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateZ" 
		"RIGRN.placeHolderList[219]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[220]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.jointOrient" 
		"RIGRN.placeHolderList[221]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[222]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.Character" 
		"RIGRN.placeHolderList[223]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[224]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.inverseScale" 
		"RIGRN.placeHolderList[225]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleX" 
		"RIGRN.placeHolderList[226]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleY" 
		"RIGRN.placeHolderList[227]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.scaleZ" 
		"RIGRN.placeHolderList[228]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[229]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateX" 
		"RIGRN.placeHolderList[230]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateY" 
		"RIGRN.placeHolderList[231]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.translateZ" 
		"RIGRN.placeHolderList[232]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateX" 
		"RIGRN.placeHolderList[233]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateY" 
		"RIGRN.placeHolderList[234]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateZ" 
		"RIGRN.placeHolderList[235]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[236]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.jointOrient" 
		"RIGRN.placeHolderList[237]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[238]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.Character" 
		"RIGRN.placeHolderList[239]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:Spine0_JNT|RIG:MODEL:Spine1_JNT|RIG:MODEL:Spine2_JNT|RIG:MODEL:Spine3_JNT|RIG:MODEL:RtArm0_JNT|RIG:MODEL:RtArm1_JNT|RIG:MODEL:RtArm2_JNT|RIG:MODEL:RtArm3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[240]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[241]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleX" "RIGRN.placeHolderList[242]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleY" "RIGRN.placeHolderList[243]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.scaleZ" "RIGRN.placeHolderList[244]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateX" "RIGRN.placeHolderList[245]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateY" "RIGRN.placeHolderList[246]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.translateZ" "RIGRN.placeHolderList[247]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[248]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateX" "RIGRN.placeHolderList[249]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateY" "RIGRN.placeHolderList[250]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateZ" "RIGRN.placeHolderList[251]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[252]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.jointOrient" "RIGRN.placeHolderList[253]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[254]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.Character" "RIGRN.placeHolderList[255]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[256]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[257]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleX" 
		"RIGRN.placeHolderList[258]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleY" 
		"RIGRN.placeHolderList[259]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.scaleZ" 
		"RIGRN.placeHolderList[260]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateX" 
		"RIGRN.placeHolderList[261]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateY" 
		"RIGRN.placeHolderList[262]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.translateZ" 
		"RIGRN.placeHolderList[263]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[264]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateX" 
		"RIGRN.placeHolderList[265]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateY" 
		"RIGRN.placeHolderList[266]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateZ" 
		"RIGRN.placeHolderList[267]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[268]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[269]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[270]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.Character" 
		"RIGRN.placeHolderList[271]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[272]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[273]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleX" 
		"RIGRN.placeHolderList[274]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleY" 
		"RIGRN.placeHolderList[275]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.scaleZ" 
		"RIGRN.placeHolderList[276]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[277]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[278]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[279]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[280]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[281]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[282]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[283]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[284]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[285]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[286]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.Character" 
		"RIGRN.placeHolderList[287]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[288]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[289]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleX" 
		"RIGRN.placeHolderList[290]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleY" 
		"RIGRN.placeHolderList[291]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.scaleZ" 
		"RIGRN.placeHolderList[292]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[293]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[294]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[295]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[296]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[297]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[298]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[299]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[300]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[301]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[302]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.Character" 
		"RIGRN.placeHolderList[303]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:LfLeg0_JNT|RIG:MODEL:LfLeg1_JNT|RIG:MODEL:LfLeg2_JNT|RIG:MODEL:LfLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[304]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.inverseScale" 
		"RIGRN.placeHolderList[305]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleX" "RIGRN.placeHolderList[306]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleY" "RIGRN.placeHolderList[307]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.scaleZ" "RIGRN.placeHolderList[308]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateX" "RIGRN.placeHolderList[309]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateY" "RIGRN.placeHolderList[310]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.translateZ" "RIGRN.placeHolderList[311]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.parentMatrix" 
		"RIGRN.placeHolderList[312]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateX" "RIGRN.placeHolderList[313]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateY" "RIGRN.placeHolderList[314]" 
		""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateZ" "RIGRN.placeHolderList[315]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateOrder" "RIGRN.placeHolderList[316]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.jointOrient" "RIGRN.placeHolderList[317]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[318]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.Character" "RIGRN.placeHolderList[319]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT.rotateAxis" "RIGRN.placeHolderList[320]" 
		""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.inverseScale" 
		"RIGRN.placeHolderList[321]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleX" 
		"RIGRN.placeHolderList[322]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleY" 
		"RIGRN.placeHolderList[323]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.scaleZ" 
		"RIGRN.placeHolderList[324]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateX" 
		"RIGRN.placeHolderList[325]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateY" 
		"RIGRN.placeHolderList[326]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.translateZ" 
		"RIGRN.placeHolderList[327]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.parentMatrix" 
		"RIGRN.placeHolderList[328]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateX" 
		"RIGRN.placeHolderList[329]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateY" 
		"RIGRN.placeHolderList[330]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateZ" 
		"RIGRN.placeHolderList[331]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateOrder" 
		"RIGRN.placeHolderList[332]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.jointOrient" 
		"RIGRN.placeHolderList[333]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[334]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.Character" 
		"RIGRN.placeHolderList[335]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT.rotateAxis" 
		"RIGRN.placeHolderList[336]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.inverseScale" 
		"RIGRN.placeHolderList[337]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleX" 
		"RIGRN.placeHolderList[338]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleY" 
		"RIGRN.placeHolderList[339]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.scaleZ" 
		"RIGRN.placeHolderList[340]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.parentMatrix" 
		"RIGRN.placeHolderList[341]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateX" 
		"RIGRN.placeHolderList[342]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateY" 
		"RIGRN.placeHolderList[343]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.translateZ" 
		"RIGRN.placeHolderList[344]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateX" 
		"RIGRN.placeHolderList[345]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateY" 
		"RIGRN.placeHolderList[346]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateZ" 
		"RIGRN.placeHolderList[347]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateOrder" 
		"RIGRN.placeHolderList[348]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.jointOrient" 
		"RIGRN.placeHolderList[349]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[350]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.Character" 
		"RIGRN.placeHolderList[351]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT.rotateAxis" 
		"RIGRN.placeHolderList[352]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.inverseScale" 
		"RIGRN.placeHolderList[353]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleX" 
		"RIGRN.placeHolderList[354]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleY" 
		"RIGRN.placeHolderList[355]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.scaleZ" 
		"RIGRN.placeHolderList[356]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.parentMatrix" 
		"RIGRN.placeHolderList[357]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateX" 
		"RIGRN.placeHolderList[358]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateY" 
		"RIGRN.placeHolderList[359]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.translateZ" 
		"RIGRN.placeHolderList[360]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateX" 
		"RIGRN.placeHolderList[361]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateY" 
		"RIGRN.placeHolderList[362]" ""
		5 4 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateZ" 
		"RIGRN.placeHolderList[363]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateOrder" 
		"RIGRN.placeHolderList[364]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.jointOrient" 
		"RIGRN.placeHolderList[365]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.segmentScaleCompensate" 
		"RIGRN.placeHolderList[366]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.Character" 
		"RIGRN.placeHolderList[367]" ""
		5 3 "RIGRN" "|RIG:MODEL:Root_JNT|RIG:MODEL:RtLeg0_JNT|RIG:MODEL:RtLeg1_JNT|RIG:MODEL:RtLeg2_JNT|RIG:MODEL:RtLeg3_JNT.rotateAxis" 
		"RIGRN.placeHolderList[368]" "";
	setAttr ".ptag" -type "string" "";
lockNode -l 1 ;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "9EBDBA84-41C8-A8D5-3AB9-2AAE4428660D";
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 69 -ast 0 -aet 200 ";
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
	setAttr ".HipsTx" 3.0506439208984375;
	setAttr ".HipsTy" 27.379032135009766;
	setAttr ".HipsTz" 29.437789916992187;
	setAttr ".HipsRx" -4.3939760888657773;
	setAttr ".HipsRy" 1.4886555143071918;
	setAttr ".HipsRz" 18.679987036831491;
	setAttr ".HipsSx" 1.0000002466921138;
	setAttr ".HipsSy" 1.0000001662433087;
	setAttr ".HipsSz" 1.0000002540505057;
	setAttr ".LeftUpLegTx" 24.89635753765624;
	setAttr ".LeftUpLegTy" -7.7306237239001732;
	setAttr ".LeftUpLegTz" 3.197026394708125;
	setAttr ".LeftUpLegRx" 18.432190427931513;
	setAttr ".LeftUpLegRy" 9.916132945884117;
	setAttr ".LeftUpLegRz" 55.9015490387673;
	setAttr ".LeftUpLegSx" 0.99999999079672919;
	setAttr ".LeftUpLegSy" 0.99999988663994721;
	setAttr ".LeftUpLegSz" 0.99999994337033971;
	setAttr ".LeftLegTx" 21.226182421160235;
	setAttr ".LeftLegTy" 3.7690262182366041e-006;
	setAttr ".LeftLegTz" 2.1274791350833766e-007;
	setAttr ".LeftLegRx" 0.80016145260996552;
	setAttr ".LeftLegRy" -1.2449895225289542;
	setAttr ".LeftLegRz" 18.91492628297113;
	setAttr ".LeftLegSx" 1.0000001455731875;
	setAttr ".LeftLegSy" 1.0000001749321052;
	setAttr ".LeftLegSz" 1.0000001235440035;
	setAttr ".LeftFootTx" 15.941046877297079;
	setAttr ".LeftFootTy" -3.2936748475265176e-006;
	setAttr ".LeftFootTz" -3.7889998871776243e-006;
	setAttr ".LeftFootRx" -30.706568588575291;
	setAttr ".LeftFootRy" -16.732992361166055;
	setAttr ".LeftFootRz" -10.245206774175308;
	setAttr ".LeftFootSx" 1.000000079591375;
	setAttr ".LeftFootSy" 1.0000000044252062;
	setAttr ".LeftFootSz" 1.0000000636012158;
	setAttr ".RightUpLegTx" -24.896308834811599;
	setAttr ".RightUpLegTy" -7.7306012755995539;
	setAttr ".RightUpLegTz" 3.197027112940674;
	setAttr ".RightUpLegRx" -64.700277928377389;
	setAttr ".RightUpLegRy" -16.745800677260743;
	setAttr ".RightUpLegRz" 129.4027415970678;
	setAttr ".RightUpLegSx" 1.0000001221294521;
	setAttr ".RightUpLegSy" 0.99999994504992729;
	setAttr ".RightUpLegSz" 1.0000000719273254;
	setAttr ".RightLegTx" -21.226180063766527;
	setAttr ".RightLegTy" 1.3205115806602663e-005;
	setAttr ".RightLegTz" -7.5658129311761968e-005;
	setAttr ".RightLegRx" 14.988057672342853;
	setAttr ".RightLegRy" 0.82172549644856074;
	setAttr ".RightLegRz" -58.961304555002812;
	setAttr ".RightLegSx" 1.0000000491176777;
	setAttr ".RightLegSy" 1.0000000345479982;
	setAttr ".RightLegSz" 1.0000000026831648;
	setAttr ".RightFootTx" -15.941100014591113;
	setAttr ".RightFootTy" 3.7596232663972273e-005;
	setAttr ".RightFootTz" 5.1892795660535285e-005;
	setAttr ".RightFootRx" 7.4095376653218965;
	setAttr ".RightFootRy" -18.877927137884598;
	setAttr ".RightFootRz" -22.735349338182036;
	setAttr ".RightFootSx" 0.99999997721277079;
	setAttr ".RightFootSy" 1.0000000546155214;
	setAttr ".RightFootSz" 1.000000031213407;
	setAttr ".SpineTx" -1.3006233245960175e-007;
	setAttr ".SpineTy" 3.3825346610792586;
	setAttr ".SpineTz" -3.7835481990276492;
	setAttr ".SpineRx" 1.3239637025007653;
	setAttr ".SpineRy" -1.940561814220213;
	setAttr ".SpineRz" -12.387964309303518;
	setAttr ".SpineSx" 0.99999991623114459;
	setAttr ".SpineSy" 0.99999983760247146;
	setAttr ".SpineSz" 0.99999993418219124;
	setAttr ".LeftArmTx" 7.5598066588850337;
	setAttr ".LeftArmTy" -1.3346375637942245;
	setAttr ".LeftArmTz" 6.4182833580605312;
	setAttr ".LeftArmRx" 7.931543375331688;
	setAttr ".LeftArmRy" 19.178806137025699;
	setAttr ".LeftArmRz" 43.323322164086974;
	setAttr ".LeftArmSx" 0.99999990189096166;
	setAttr ".LeftArmSy" 0.99999987718270811;
	setAttr ".LeftArmSz" 0.99999979782275628;
	setAttr ".LeftForeArmTx" 23.627851802199125;
	setAttr ".LeftForeArmTy" -0.36614829441675489;
	setAttr ".LeftForeArmTz" 0.61647987309846286;
	setAttr ".LeftForeArmRx" -4.8634864891143961;
	setAttr ".LeftForeArmRy" -8.8916866174942406;
	setAttr ".LeftForeArmRz" 23.247676307303809;
	setAttr ".LeftForeArmSx" 0.99999995340705483;
	setAttr ".LeftForeArmSy" 1.0000000073967039;
	setAttr ".LeftForeArmSz" 0.99999999776041737;
	setAttr ".LeftHandTx" 22.329475265766206;
	setAttr ".LeftHandTy" -0.34352212726601294;
	setAttr ".LeftHandTz" 0.83665012170610353;
	setAttr ".LeftHandRx" -38.290869393072491;
	setAttr ".LeftHandRy" -10.589561410477291;
	setAttr ".LeftHandRz" -4.2340168452307916;
	setAttr ".LeftHandSx" 1.0000000140177725;
	setAttr ".LeftHandSy" 1.0000001346190195;
	setAttr ".LeftHandSz" 1.0000002822558656;
	setAttr ".RightArmTx" -7.5598953309505141;
	setAttr ".RightArmTy" 1.3346109541254663;
	setAttr ".RightArmTz" -6.4179072891446936;
	setAttr ".RightArmRx" 45.357918314679551;
	setAttr ".RightArmRy" 55.560002649676676;
	setAttr ".RightArmRz" -79.288235163085275;
	setAttr ".RightArmSx" 1.0000002295430515;
	setAttr ".RightArmSy" 1.0000002197174731;
	setAttr ".RightArmSz" 1.0000000664930717;
	setAttr ".RightForeArmTx" -23.627895683283178;
	setAttr ".RightForeArmTy" 0.3661439128972741;
	setAttr ".RightForeArmTz" -0.61643921449987715;
	setAttr ".RightForeArmRx" -8.6042209096976698;
	setAttr ".RightForeArmRy" -10.608294092233086;
	setAttr ".RightForeArmRz" 42.200770852753976;
	setAttr ".RightForeArmSx" 0.99999998622982889;
	setAttr ".RightForeArmSy" 0.99999999426740693;
	setAttr ".RightForeArmSz" 0.99999996080998088;
	setAttr ".RightHandTx" -22.329457419792234;
	setAttr ".RightHandTy" 0.34352631341836926;
	setAttr ".RightHandTz" -0.83668490439529108;
	setAttr ".RightHandRx" -86.034934031108435;
	setAttr ".RightHandRy" -21.75453349242008;
	setAttr ".RightHandRz" -40.529760177136055;
	setAttr ".RightHandSx" 1.0000001469359585;
	setAttr ".RightHandSy" 1.0000001020755465;
	setAttr ".RightHandSz" 1.0000000195688552;
	setAttr ".HeadTx" 8.0099193823507306;
	setAttr ".HeadTy" -4.6296355762365238e-006;
	setAttr ".HeadTz" -2.9201760471941896e-006;
	setAttr ".HeadRx" 1.4060434026149928;
	setAttr ".HeadRy" -2.3409461379314527;
	setAttr ".HeadRz" -33.479306193471885;
	setAttr ".HeadSx" 1.0000000605109549;
	setAttr ".HeadSy" 1.0000001623287968;
	setAttr ".HeadSz" 1.0000000719581874;
	setAttr ".LeftToeBaseTx" 6.8757432778285512;
	setAttr ".LeftToeBaseTy" -7.5324191328718371e-008;
	setAttr ".LeftToeBaseTz" 1.1443314988923703e-006;
	setAttr ".LeftToeBaseRx" 10.582078062082056;
	setAttr ".LeftToeBaseRy" -4.196280195997951;
	setAttr ".LeftToeBaseRz" -115.04847482360253;
	setAttr ".LeftToeBaseSx" 1.0000000512577225;
	setAttr ".LeftToeBaseSy" 1.0000000311138917;
	setAttr ".LeftToeBaseSz" 1.0000001084758166;
	setAttr ".RightToeBaseTx" -6.8757528046918868;
	setAttr ".RightToeBaseTy" 3.9604046548902261e-006;
	setAttr ".RightToeBaseTz" 2.255318305799392e-005;
	setAttr ".RightToeBaseRx" -0.47927967070782335;
	setAttr ".RightToeBaseRy" -2.4942924089848422;
	setAttr ".RightToeBaseRz" -75.551009055047885;
	setAttr ".RightToeBaseSx" 1.0000000327940188;
	setAttr ".RightToeBaseSy" 1.0000001855643685;
	setAttr ".RightToeBaseSz" 1.0000001292851393;
	setAttr ".LeftShoulderTx" 10.381333790581555;
	setAttr ".LeftShoulderTy" 5.2150699296957299;
	setAttr ".LeftShoulderTz" 13.982757600984828;
	setAttr ".LeftShoulderRx" -11.559600299659236;
	setAttr ".LeftShoulderRy" 3.8927313073410947;
	setAttr ".LeftShoulderRz" 28.704576285214539;
	setAttr ".LeftShoulderSx" 1.0000000988752431;
	setAttr ".LeftShoulderSy" 1.0000001249696711;
	setAttr ".LeftShoulderSz" 1.0000000532292084;
	setAttr ".RightShoulderTx" 10.380997632199238;
	setAttr ".RightShoulderTy" 5.2151811888149311;
	setAttr ".RightShoulderTz" -13.982801255309356;
	setAttr ".RightShoulderRx" -21.177459033804205;
	setAttr ".RightShoulderRy" 27.940859145318008;
	setAttr ".RightShoulderRz" -3.6975567625876145;
	setAttr ".RightShoulderSx" 0.9999998090501836;
	setAttr ".RightShoulderSy" 0.99999995122103946;
	setAttr ".RightShoulderSz" 0.99999997976663013;
	setAttr ".NeckTx" 17.971213606155928;
	setAttr ".NeckTy" -7.8014339521814691e-007;
	setAttr ".NeckTz" -2.9559317219485237e-006;
	setAttr ".NeckRz" 30.935088706053499;
	setAttr ".NeckSx" 1.0000001459000354;
	setAttr ".NeckSy" 1.0000002174392286;
	setAttr ".NeckSz" 1.0000001804081686;
	setAttr ".Spine1Tx" 7.1917520047717431;
	setAttr ".Spine1Ty" 1.1607829542015224e-006;
	setAttr ".Spine1Tz" 8.7559075900855987e-007;
	setAttr ".Spine1Rx" 3.8996650413522662;
	setAttr ".Spine1Ry" -2.5726335522666886;
	setAttr ".Spine1Rz" -24.828958015921472;
	setAttr ".Spine1Sx" 1.0000000913925129;
	setAttr ".Spine1Sy" 1.0000001433615546;
	setAttr ".Spine1Sz" 1.0000000797900825;
	setAttr ".Spine2Tx" 15.480265391410057;
	setAttr ".Spine2Ty" 1.7904139966162802e-006;
	setAttr ".Spine2Tz" -1.1272457811628556e-006;
	setAttr ".Spine2Rx" 4.0928622970255839;
	setAttr ".Spine2Ry" -2.2522822428421048;
	setAttr ".Spine2Rz" -24.821837474357359;
	setAttr ".Spine2Sx" 0.99999992421976724;
	setAttr ".Spine2Sy" 0.99999982295445788;
	setAttr ".Spine2Sz" 0.99999998293241277;
	setAttr ".Spine3Tx" 13.088919473533622;
	setAttr ".Spine3Ty" -2.1314912714842649e-006;
	setAttr ".Spine3Tz" 1.4117034590199751e-006;
	setAttr ".Spine3Rx" 2.5352639818801266;
	setAttr ".Spine3Ry" -3.9240801309116624;
	setAttr ".Spine3Rz" -24.828202012972067;
	setAttr ".Spine3Sx" 1.0000001202908746;
	setAttr ".Spine3Sy" 1.0000001148650803;
	setAttr ".Spine3Sz" 1.0000001177353359;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "AF47E422-47E0-CFAF-3901-A0AD7DC024B1";
	setAttr ".ihi" 0;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "AA89DE2F-4F23-3589-E471-93AEF6AA8201";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "1AA648AE-47F1-8E13-A0D2-5EB8B5198159";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "4DAC9ACE-4815-6387-514E-64923EAF5A34";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "E3F2046C-493A-7B0A-98C6-26B3549D4119";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "D544FE4D-41F0-E224-DB42-3394C7CF147A";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "9594D540-42B4-0ECE-47EC-079B0DEAC677";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "614476DB-4AE1-E7E8-0467-7ABCBBECD1AE";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "E973B81B-4416-0C0F-EA4D-EFB93D0DD00D";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "1C1F2752-4641-31CD-0B0A-3F94FD3BE6A2";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "C6CCD311-4084-BE24-82C4-4589A0BD33C1";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "C9B4C25D-497B-1311-B4B7-7CB22DBF6C61";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "75B12762-473D-B9E8-6F4A-4C84737334E7";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "C2C8CA10-4C5B-138F-7F2D-E98B6BAC2B57";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "8EA5DA9C-40D0-5BCA-7732-C3BFBEB4E6F8";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "211CE9A6-4384-4304-707F-089A3AFB7BA6";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "3E8A468E-4F83-2452-3E2D-7CB69387B867";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700270891189575 0.32017409801483154 -0.025979023426771164 0
		 -0.3212263286113739 0.94390052556991577 -0.076588355004787445 0 -9.3132257461547852e-010 0.080874517560005188 0.99672454595565796 0
		 3.0506439208984375 27.379032135009766 29.437789916992187 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.95676517486572266 -0.19533255696296692 0.21551194787025452 0
		 -0.01673809252679348 0.70274090766906738 0.71124869585037231 0 -0.29037913680076599 -0.68410539627075195 0.66908866167068481 0
		 29.110841751098633 28.311819076538086 32.569637298583984 1;
	setAttr ".LeftLegGX" -type "matrix" 0.93543583154678345 -0.29074937105178833 0.20105919241905212 0
		 -0.055081356316804886 0.44193977117538452 0.8953520655632019 0 -0.34917911887168884 -0.84861898422241211 0.39739140868186951 0
		 25.974231719970703 10.04646110534668 22.221246719360352 1;
	setAttr ".LeftFootGX" -type "matrix" 0.94942224025726318 0.3024061918258667 -0.084547840058803558 0
		 0.040198728442192078 0.14998635649681091 0.98787063360214233 0 0.31141912937164307 -0.94130480289459229 0.13024400174617767 0
		 26.868930816650391 16.41071891784668 7.6331424713134766 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.88506168127059937 -0.28289619088172913 -0.36964300274848938 0
		 0.20044009387493134 -0.48509329557418823 0.85118049383163452 0 -0.42010709643363953 -0.82743829488754272 -0.37263363599777222 0
		 -18.04295539855957 12.369518280029297 33.863201141357422 1;
	setAttr ".RightLegGX" -type "matrix" 0.86085456609725952 -0.18742436170578003 -0.47307682037353516 0
		 0.50169664621353149 0.46797224879264832 0.7275317907333374 0 0.08502960205078125 -0.86364006996154785 0.49688619375228882 0
		 -23.331655502319336 16.306846618652344 13.687028884887695 1;
	setAttr ".RightFootGX" -type "matrix" 0.97611242532730103 -0.14790278673171997 -0.1591518223285675 0
		 0.18316452205181122 0.16620399057865143 0.96893090009689331 0 -0.1168559268116951 -0.97493642568588257 0.18932431936264038 0
		 -26.079505920410156 20.688753128051758 -1.3916616439819336 1;
	setAttr ".SpineGX" -type "matrix" 0.9573180079460144 0.28547763824462891 -0.045224927365779877 0
		 -0.28607550263404846 0.91349345445632935 -0.28929367661476135 0 -0.041274204850196838 0.28988373279571533 0.95617169141769409 0
		 1.9640846252441406 30.265815734863281 25.407571792602539 1;
	setAttr ".LeftArmGX" -type "matrix" 0.29938477277755737 0.93467694520950317 0.19169750809669495 0
		 0.32632771134376526 0.08849065750837326 -0.94110554456710815 0 -0.89659303426742554 0.34430879354476929 -0.27851814031600952 0
		 19.251871109008789 61.180515289306641 -5.4256696701049805 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.49347957968711853 0.86941361427307129 0.024453580379486084 0
		 0.31387567520141602 0.20423626899719238 -0.927237868309021 0 -0.81114739179611206 -0.4498976469039917 -0.37367391586303711 0
		 26.328947067260742 83.27508544921875 -0.89418554306030273 1;
	setAttr ".LeftHandGX" -type "matrix" -0.51839721202850342 0.82890415191650391 0.2101958692073822 0
		 0.68778783082962036 0.5502169132232666 -0.47350805997848511 0 -0.50814598798751831 -0.10089518129825592 -0.85534083843231201 0
		 15.300773620605469 102.70455169677734 -0.34770423173904419 1;
	setAttr ".RightArmGX" -type "matrix" 0.26036363840103149 0.71244603395462036 0.6516377329826355 0
		 -0.70249432325363159 0.60278642177581787 -0.3783525824546814 0 -0.66235405206680298 -0.35926252603530884 0.65743285417556763 0
		 -27.35679817199707 53.794403076171875 -10.248052597045898 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.6115918755531311 0.68163925409317017 -0.40165096521377563 0
		 -0.78647154569625854 0.46852320432662964 -0.40242850780487061 0 -0.086128279566764832 0.56200897693634033 0.82263481616973877 0
		 -33.382343292236328 36.537506103515625 -25.237518310546875 1;
	setAttr ".RightHandGX" -type "matrix" 0.16020685434341431 0.98673814535140991 -0.026104629039764404 0
		 0.38470619916915894 -0.086772382259368896 -0.91895133256912231 0 -0.90902954339981079 0.13717979192733765 -0.39350593090057373 0
		 -47.266880035400391 21.497968673706055 -16.267866134643555 1;
	setAttr ".HeadGX" -type "matrix" 0.997883141040802 0.037812996655702591 0.05290864035487175 0
		 0.055383000522851944 -0.067698992788791656 -0.99616736173629761 0 -0.034086216241121292 0.99698895215988159 -0.069649882614612579 0
		 -4.2701468467712402 62.2197265625 -20.641986846923828 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.88357639312744141 0.2531147301197052 -0.39398708939552307 0
		 0.1330338716506958 -0.94234716892242432 -0.30705669522285461 0 -0.44899317622184753 0.21889439225196838 -0.86630851030349731 0
		 25.643037796020508 16.50200080871582 0.86818075180053711 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.99201053380966187 -0.12131147831678391 0.034623067826032639 0
		 -0.12508906424045563 -0.9102434515953064 0.3947272002696991 0 -0.016369517892599106 -0.39590451121330261 -0.91814577579498291 0
		 -26.601661682128906 20.80363655090332 -8.2465963363647461 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.79361271858215332 0.54768061637878418 0.26499935984611511 0
		 0.20593787729740143 0.16803978383541107 -0.96402913331985474 0 -0.57251042127609253 0.81963920593261719 0.020570322871208191 0
		 9.752777099609375 59.02142333984375 -7.7129926681518555 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.9642874002456665 -0.031037718057632446 0.26303434371948242 0
		 0.255767822265625 -0.14884315431118011 -0.955211341381073 0 0.068798474967479706 0.98837369680404663 -0.13558907806873322 0
		 -18.142946243286133 57.101409912109375 -8.1764945983886719 1;
	setAttr ".NeckGX" -type "matrix" 0.99750238656997681 0.068656831979751587 0.016586298123002052 0
		 -0.019280167296528816 0.49058049917221069 -0.87118250131607056 0 -0.067949548363685608 0.86868685483932495 0.49067896604537964 0
		 -3.8561162948608398 55.254203796386719 -16.708934783935547 1;
	setAttr ".Spine1GX" -type "matrix" 0.9765167236328125 0.20737706124782562 -0.058393262326717377 0
		 -0.19290734827518463 0.72096705436706543 -0.66557735204696655 0 -0.095925860106945038 0.66121190786361694 0.74404096603393555 0
		 -0.1129148006439209 37.105621337890625 24.617368698120117 1;
	setAttr ".Spine2GX" -type "matrix" 0.99081695079803467 0.13021856546401978 -0.036396853625774384 0
		 -0.084558248519897461 0.38671949505805969 -0.91831237077713013 0 -0.10550596565008163 0.91295731067657471 0.39417934417724609 0
		 -2.9415311813354492 47.223960876464844 13.248252868652344 1;
	setAttr ".Spine3GX" -type "matrix" 0.99750256538391113 0.068656757473945618 0.016586441546678543 0
		 0.018393157050013542 -0.025767182931303978 -0.99949872493743896 0 -0.068194955587387085 0.99730759859085083 -0.026965644210577011 0
		 -3.7877564430236816 50.101718902587891 0.50767993927001953 1;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "3977D7B5-4A66-8475-9C7A-1EBAC04D32B6";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700270891189575 0.32017409801483154 -0.025979023426771164 0
		 -0.3212263286113739 0.94390052556991577 -0.076588355004787445 0 -9.3132257461547852e-010 0.080874517560005188 0.99672454595565796 0
		 3.0506439208984375 27.379032135009766 29.437789916992187 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.95676517486572266 -0.19533255696296692 0.21551194787025452 0
		 -0.01673809252679348 0.70274090766906738 0.71124869585037231 0 -0.29037913680076599 -0.68410539627075195 0.66908866167068481 0
		 29.110841751098633 28.311819076538086 32.569637298583984 1;
	setAttr ".LeftLegGX" -type "matrix" 0.93543583154678345 -0.29074937105178833 0.20105919241905212 0
		 -0.055081356316804886 0.44193977117538452 0.8953520655632019 0 -0.34917911887168884 -0.84861898422241211 0.39739140868186951 0
		 25.974231719970703 10.04646110534668 22.221246719360352 1;
	setAttr ".LeftFootGX" -type "matrix" 0.94942224025726318 0.3024061918258667 -0.084547840058803558 0
		 0.040198728442192078 0.14998635649681091 0.98787063360214233 0 0.31141912937164307 -0.94130480289459229 0.13024400174617767 0
		 26.868930816650391 16.41071891784668 7.6331424713134766 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.88506168127059937 -0.28289619088172913 -0.36964300274848938 0
		 0.20044009387493134 -0.48509329557418823 0.85118049383163452 0 -0.42010709643363953 -0.82743829488754272 -0.37263363599777222 0
		 -18.04295539855957 12.369518280029297 33.863201141357422 1;
	setAttr ".RightLegGX" -type "matrix" 0.86085456609725952 -0.18742436170578003 -0.47307682037353516 0
		 0.50169664621353149 0.46797224879264832 0.7275317907333374 0 0.08502960205078125 -0.86364006996154785 0.49688619375228882 0
		 -23.331655502319336 16.306846618652344 13.687028884887695 1;
	setAttr ".RightFootGX" -type "matrix" 0.97611242532730103 -0.14790278673171997 -0.1591518223285675 0
		 0.18316452205181122 0.16620399057865143 0.96893090009689331 0 -0.1168559268116951 -0.97493642568588257 0.18932431936264038 0
		 -26.079505920410156 20.688753128051758 -1.3916616439819336 1;
	setAttr ".SpineGX" -type "matrix" 0.9573180079460144 0.28547763824462891 -0.045224927365779877 0
		 -0.28607550263404846 0.91349345445632935 -0.28929367661476135 0 -0.041274204850196838 0.28988373279571533 0.95617169141769409 0
		 1.9640846252441406 30.265815734863281 25.407571792602539 1;
	setAttr ".LeftArmGX" -type "matrix" 0.29938477277755737 0.93467694520950317 0.19169750809669495 0
		 0.32632771134376526 0.08849065750837326 -0.94110554456710815 0 -0.89659303426742554 0.34430879354476929 -0.27851814031600952 0
		 19.251871109008789 61.180515289306641 -5.4256696701049805 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.49347957968711853 0.86941361427307129 0.024453580379486084 0
		 0.31387567520141602 0.20423626899719238 -0.927237868309021 0 -0.81114739179611206 -0.4498976469039917 -0.37367391586303711 0
		 26.328947067260742 83.27508544921875 -0.89418554306030273 1;
	setAttr ".LeftHandGX" -type "matrix" -0.51839721202850342 0.82890415191650391 0.2101958692073822 0
		 0.68778783082962036 0.5502169132232666 -0.47350805997848511 0 -0.50814598798751831 -0.10089518129825592 -0.85534083843231201 0
		 15.300773620605469 102.70455169677734 -0.34770423173904419 1;
	setAttr ".RightArmGX" -type "matrix" 0.26036363840103149 0.71244603395462036 0.6516377329826355 0
		 -0.70249432325363159 0.60278642177581787 -0.3783525824546814 0 -0.66235405206680298 -0.35926252603530884 0.65743285417556763 0
		 -27.35679817199707 53.794403076171875 -10.248052597045898 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.6115918755531311 0.68163925409317017 -0.40165096521377563 0
		 -0.78647154569625854 0.46852320432662964 -0.40242850780487061 0 -0.086128279566764832 0.56200897693634033 0.82263481616973877 0
		 -33.382343292236328 36.537506103515625 -25.237518310546875 1;
	setAttr ".RightHandGX" -type "matrix" 0.16020685434341431 0.98673814535140991 -0.026104629039764404 0
		 0.38470619916915894 -0.086772382259368896 -0.91895133256912231 0 -0.90902954339981079 0.13717979192733765 -0.39350593090057373 0
		 -47.266880035400391 21.497968673706055 -16.267866134643555 1;
	setAttr ".HeadGX" -type "matrix" 0.997883141040802 0.037812996655702591 0.05290864035487175 0
		 0.055383000522851944 -0.067698992788791656 -0.99616736173629761 0 -0.034086216241121292 0.99698895215988159 -0.069649882614612579 0
		 -4.2701468467712402 62.2197265625 -20.641986846923828 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.88357639312744141 0.2531147301197052 -0.39398708939552307 0
		 0.1330338716506958 -0.94234716892242432 -0.30705669522285461 0 -0.44899317622184753 0.21889439225196838 -0.86630851030349731 0
		 25.643037796020508 16.50200080871582 0.86818075180053711 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.99201053380966187 -0.12131147831678391 0.034623067826032639 0
		 -0.12508906424045563 -0.9102434515953064 0.3947272002696991 0 -0.016369517892599106 -0.39590451121330261 -0.91814577579498291 0
		 -26.601661682128906 20.80363655090332 -8.2465963363647461 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.79361271858215332 0.54768061637878418 0.26499935984611511 0
		 0.20593787729740143 0.16803978383541107 -0.96402913331985474 0 -0.57251042127609253 0.81963920593261719 0.020570322871208191 0
		 9.752777099609375 59.02142333984375 -7.7129926681518555 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.9642874002456665 -0.031037718057632446 0.26303434371948242 0
		 0.255767822265625 -0.14884315431118011 -0.955211341381073 0 0.068798474967479706 0.98837369680404663 -0.13558907806873322 0
		 -18.142946243286133 57.101409912109375 -8.1764945983886719 1;
	setAttr ".NeckGX" -type "matrix" 0.99750238656997681 0.068656831979751587 0.016586298123002052 0
		 -0.019280167296528816 0.49058049917221069 -0.87118250131607056 0 -0.067949548363685608 0.86868685483932495 0.49067896604537964 0
		 -3.8561162948608398 55.254203796386719 -16.708934783935547 1;
	setAttr ".Spine1GX" -type "matrix" 0.9765167236328125 0.20737706124782562 -0.058393262326717377 0
		 -0.19290734827518463 0.72096705436706543 -0.66557735204696655 0 -0.095925860106945038 0.66121190786361694 0.74404096603393555 0
		 -0.1129148006439209 37.105621337890625 24.617368698120117 1;
	setAttr ".Spine2GX" -type "matrix" 0.99081695079803467 0.13021856546401978 -0.036396853625774384 0
		 -0.084558248519897461 0.38671949505805969 -0.91831237077713013 0 -0.10550596565008163 0.91295731067657471 0.39417934417724609 0
		 -2.9415311813354492 47.223960876464844 13.248252868652344 1;
	setAttr ".Spine3GX" -type "matrix" 0.99750256538391113 0.068656757473945618 0.016586441546678543 0
		 0.018393157050013542 -0.025767182931303978 -0.99949872493743896 0 -0.068194955587387085 0.99730759859085083 -0.026965644210577011 0
		 -3.7877564430236816 50.101718902587891 0.50767993927001953 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "63DBC1CE-4827-0AFA-AB74-B0A5CAB4FD44";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "0C16AEFD-4C0A-1E43-3BF4-11BCE9B158EF";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "1EB8EB98-4E52-7058-BFCC-F196A858BF8F";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700270891189575 0.32017409801483154 -0.025979023426771164 0
		 -0.32122635841369629 0.94390058517456055 -0.076588362455368042 0 -9.3132257461547852e-010 0.080874517560005188 0.99672454595565796 0
		 5.5339431762695313 20.340667724609375 33.216419219970703 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.94942224025726318 0.3024061918258667 -0.084547840058803558 0
		 0.040198728442192078 0.14998635649681091 0.98787063360214233 0 0.31141915917396545 -0.94130486249923706 0.13024401664733887 0
		 26.868930816650391 16.41071891784668 7.6331424713134766 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.9761124849319458 -0.14790280163288116 -0.1591518372297287 0
		 0.18316452205181122 0.16620399057865143 0.96893090009689331 0 -0.1168559268116951 -0.97493642568588257 0.18932431936264038 0
		 -26.079505920410156 20.688753128051758 -1.3916616439819336 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" -0.51839727163314819 0.82890421152114868 0.2101958841085434 0
		 0.68778783082962036 0.5502169132232666 -0.47350805997848511 0 -0.50814598798751831 -0.10089518129825592 -0.85534083843231201 0
		 15.300773620605469 102.70455169677734 -0.34770423173904419 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.16020685434341431 0.98673814535140991 -0.026104629039764404 0
		 0.38470619916915894 -0.086772382259368896 -0.91895133256912231 0 -0.90902954339981079 0.13717979192733765 -0.39350593090057373 0
		 -47.266880035400391 21.497968673706055 -16.267866134643555 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.93543583154678345 -0.29074937105178833 0.20105919241905212 0
		 -0.055081360042095184 0.44193980097770691 0.89535212516784668 0 -0.34917911887168884 -0.84861898422241211 0.39739140868186951 0
		 25.974231719970703 10.04646110534668 22.221246719360352 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.86085456609725952 -0.18742436170578003 -0.47307682037353516 0
		 0.50169664621353149 0.46797224879264832 0.7275317907333374 0 0.08502960205078125 -0.86364006996154785 0.49688619375228882 0
		 -23.331655502319336 16.306846618652344 13.687028884887695 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.49347957968711853 0.86941361427307129 0.024453580379486084 0
		 0.31387567520141602 0.20423626899719238 -0.927237868309021 0 -0.81114739179611206 -0.4498976469039917 -0.37367391586303711 0
		 26.328947067260742 83.27508544921875 -0.89418554306030273 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.6115918755531311 0.68163925409317017 -0.40165096521377563 0
		 -0.78647154569625854 0.46852320432662964 -0.40242850780487061 0 -0.086128279566764832 0.56200897693634033 0.82263481616973877 0
		 -33.382343292236328 36.537506103515625 -25.237518310546875 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.9573180079460144 0.28547763824462891 -0.045224927365779877 0
		 -0.28607553243637085 0.91349351406097412 -0.28929370641708374 0 -0.041274204850196838 0.28988373279571533 0.95617169141769409 0
		 1.9640846252441406 30.265815734863281 25.407571792602539 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99750256538391113 0.068656757473945618 0.016586441546678543 0
		 0.018393158912658691 -0.025767184793949127 -0.99949878454208374 0 -0.068194955587387085 0.99730759859085083 -0.026965644210577011 0
		 -4.1950845718383789 58.061416625976562 -7.9447436332702637 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.88357639312744141 0.2531147301197052 -0.39398708939552307 0
		 0.1330338716506958 -0.94234716892242432 -0.30705669522285461 0 -0.44899317622184753 0.21889439225196838 -0.86630851030349731 0
		 25.643037796020508 16.50200080871582 0.86818075180053711 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.99201059341430664 -0.1213114857673645 0.034623071551322937 0
		 -0.12508906424045563 -0.9102434515953064 0.3947272002696991 0 -0.016369517892599106 -0.39590451121330261 -0.91814577579498291 0
		 -26.601661682128906 20.80363655090332 -8.2465963363647461 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.29938477277755737 0.93467694520950317 0.19169750809669495 0
		 0.32632774114608765 0.088490664958953857 -0.94110560417175293 0 -0.89659309387207031 0.34430882334709167 -0.27851817011833191 0
		 19.251871109008789 61.180515289306641 -5.4256696701049805 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.26036363840103149 0.71244603395462036 0.6516377329826355 0
		 -0.70249432325363159 0.60278642177581787 -0.3783525824546814 0 -0.66235405206680298 -0.35926252603530884 0.65743285417556763 0
		 -27.35679817199707 53.794403076171875 -10.248052597045898 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.997883141040802 0.037812996655702591 0.05290864035487175 0
		 0.055383000522851944 -0.067698992788791656 -0.99616736173629761 0 -0.034086216241121292 0.99698895215988159 -0.069649882614612579 0
		 -4.2701468467712402 62.2197265625 -20.641986846923828 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.95676517486572266 -0.19533255696296692 0.21551194787025452 0
		 -0.016738094389438629 0.70274096727371216 0.71124875545501709 0 -0.29037913680076599 -0.68410539627075195 0.66908866167068481 0
		 29.110841751098633 28.311819076538086 32.569637298583984 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.88506174087524414 -0.28289622068405151 -0.36964303255081177 0
		 0.20044010877609253 -0.48509332537651062 0.8511805534362793 0 -0.42010712623596191 -0.8274383544921875 -0.3726336658000946 0
		 -18.04295539855957 12.369518280029297 33.863201141357422 1;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "B6555147-4B61-EDB1-CCF0-969FE27FAFEF";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700270891189575 0.32017409801483154 -0.025979023426771164 0
		 -0.32122635841369629 0.94390058517456055 -0.076588362455368042 0 -9.3132257461547852e-010 0.080874517560005188 0.99672454595565796 0
		 5.5339431762695313 20.340667724609375 33.216419219970703 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.94942224025726318 0.3024061918258667 -0.084547840058803558 0
		 0.040198728442192078 0.14998635649681091 0.98787063360214233 0 0.31141915917396545 -0.94130486249923706 0.13024401664733887 0
		 26.868930816650391 16.41071891784668 7.6331424713134766 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.9761124849319458 -0.14790280163288116 -0.1591518372297287 0
		 0.18316452205181122 0.16620399057865143 0.96893090009689331 0 -0.1168559268116951 -0.97493642568588257 0.18932431936264038 0
		 -26.079505920410156 20.688753128051758 -1.3916616439819336 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" -0.51839727163314819 0.82890421152114868 0.2101958841085434 0
		 0.68778783082962036 0.5502169132232666 -0.47350805997848511 0 -0.50814598798751831 -0.10089518129825592 -0.85534083843231201 0
		 15.300773620605469 102.70455169677734 -0.34770423173904419 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.16020685434341431 0.98673814535140991 -0.026104629039764404 0
		 0.38470619916915894 -0.086772382259368896 -0.91895133256912231 0 -0.90902954339981079 0.13717979192733765 -0.39350593090057373 0
		 -47.266880035400391 21.497968673706055 -16.267866134643555 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.93543583154678345 -0.29074937105178833 0.20105919241905212 0
		 -0.055081360042095184 0.44193980097770691 0.89535212516784668 0 -0.34917911887168884 -0.84861898422241211 0.39739140868186951 0
		 25.974231719970703 10.04646110534668 22.221246719360352 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.86085456609725952 -0.18742436170578003 -0.47307682037353516 0
		 0.50169664621353149 0.46797224879264832 0.7275317907333374 0 0.08502960205078125 -0.86364006996154785 0.49688619375228882 0
		 -23.331655502319336 16.306846618652344 13.687028884887695 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.49347957968711853 0.86941361427307129 0.024453580379486084 0
		 0.31387567520141602 0.20423626899719238 -0.927237868309021 0 -0.81114739179611206 -0.4498976469039917 -0.37367391586303711 0
		 26.328947067260742 83.27508544921875 -0.89418554306030273 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.6115918755531311 0.68163925409317017 -0.40165096521377563 0
		 -0.78647154569625854 0.46852320432662964 -0.40242850780487061 0 -0.086128279566764832 0.56200897693634033 0.82263481616973877 0
		 -33.382343292236328 36.537506103515625 -25.237518310546875 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.9573180079460144 0.28547763824462891 -0.045224927365779877 0
		 -0.28607553243637085 0.91349351406097412 -0.28929370641708374 0 -0.041274204850196838 0.28988373279571533 0.95617169141769409 0
		 1.9640846252441406 30.265815734863281 25.407571792602539 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99750256538391113 0.068656757473945618 0.016586441546678543 0
		 0.018393158912658691 -0.025767184793949127 -0.99949878454208374 0 -0.068194955587387085 0.99730759859085083 -0.026965644210577011 0
		 -4.1950845718383789 58.061416625976562 -7.9447436332702637 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.88357639312744141 0.2531147301197052 -0.39398708939552307 0
		 0.1330338716506958 -0.94234716892242432 -0.30705669522285461 0 -0.44899317622184753 0.21889439225196838 -0.86630851030349731 0
		 25.643037796020508 16.50200080871582 0.86818075180053711 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.99201059341430664 -0.1213114857673645 0.034623071551322937 0
		 -0.12508906424045563 -0.9102434515953064 0.3947272002696991 0 -0.016369517892599106 -0.39590451121330261 -0.91814577579498291 0
		 -26.601661682128906 20.80363655090332 -8.2465963363647461 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.29938477277755737 0.93467694520950317 0.19169750809669495 0
		 0.32632774114608765 0.088490664958953857 -0.94110560417175293 0 -0.89659309387207031 0.34430882334709167 -0.27851817011833191 0
		 19.251871109008789 61.180515289306641 -5.4256696701049805 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.26036363840103149 0.71244603395462036 0.6516377329826355 0
		 -0.70249432325363159 0.60278642177581787 -0.3783525824546814 0 -0.66235405206680298 -0.35926252603530884 0.65743285417556763 0
		 -27.35679817199707 53.794403076171875 -10.248052597045898 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.997883141040802 0.037812996655702591 0.05290864035487175 0
		 0.055383000522851944 -0.067698992788791656 -0.99616736173629761 0 -0.034086216241121292 0.99698895215988159 -0.069649882614612579 0
		 -4.2701468467712402 62.2197265625 -20.641986846923828 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.95676517486572266 -0.19533255696296692 0.21551194787025452 0
		 -0.016738094389438629 0.70274096727371216 0.71124875545501709 0 -0.29037913680076599 -0.68410539627075195 0.66908866167068481 0
		 29.110841751098633 28.311819076538086 32.569637298583984 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.88506174087524414 -0.28289622068405151 -0.36964303255081177 0
		 0.20044010877609253 -0.48509332537651062 0.8511805534362793 0 -0.42010712623596191 -0.8274383544921875 -0.3726336658000946 0
		 -18.04295539855957 12.369518280029297 33.863201141357422 1;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "FE1D664A-4EBA-C319-24C9-B48725961440";
	setAttr ".ihi" 0;
	setAttr ".InputCharacterDefinitionSrc" -type "HIKCharacter" ;
	setAttr ".InputSrcPropertySetState" -type "HIKPropertySetState" ;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "C18ECAEE-4140-8515-0D13-728281A0E0CD";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
	setAttr ".InputCharacterDefinition" -type "HIKCharacter" ;
	setAttr ".HipsGX" -type "matrix" 1.1102230246251565e-016 -0.99952301610586292 -0.030882685677241867 0
		 0.94700241615378478 -0.0099203350837058224 0.32107321711834069 0 -0.32122643695513942 -0.029245977953666041 0.94655071125357015 0
		 6.6941943584216208 29.114772585314565 56.26522701017403 1;
	setAttr ".LeftUpLegGX" -type "matrix" -0.13708313774053318 0.59680342072116632 -0.79059103282608489 0
		 0.97047002818125361 0.24084238413968129 0.013534788175781021 0 0.19848542603616046 -0.76538946798270391 -0.61219522809753968 0
		 28.212577470489315 25.405655837634441 48.203887108412502 1;
	setAttr ".LeftLegGX" -type "matrix" -0.17443702608448139 0.72731724991087221 0.66376332546927763 0
		 0.97617678528477669 0.21607418344065521 0.019776464031095981 0 -0.12903833603485065 0.65140000045265878 -0.74768142142123817 0
		 24.838707713318129 40.094092689427242 28.74597842681144 1;
	setAttr ".LeftFootGX" -type "matrix" 0.082002658714842275 0.99611535124859196 0.032095215306956582 0
		 0.66016684716819329 -0.078415662037103429 0.74701471507291028 0 0.74662940902645303 -0.040069025398280028 -0.66403251738204538 0
		 21.955157403913098 52.11709000554275 39.718390992223576 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.29830422104653653 -0.89260112595410723 0.3380504584726492 0
		 0.93541399007620152 0.20297707808094129 -0.28948451562507943 0 0.18977765773308805 0.40257146966078972 0.89550025195013327 0
		 -14.824188753646096 25.40565583763447 48.203887108412516 1;
	setAttr ".RightLegGX" -type "matrix" -0.024273686041865111 -0.77998064271278622 -0.62533271232463472 0
		 0.93541397009843918 0.20297707374593255 -0.28948450944251974 0 0.35272051876745075 -0.5919718961393754 0.72467773139652281 0
		 -22.16600778707361 47.374221729185649 39.883839602660977 1;
	setAttr ".RightFootGX" -type "matrix" 0.30442966796451382 -0.87993106871908733 0.3647521801747447 0
		 0.95252748489633132 0.28273844319125996 -0.11291851542819831 0 -0.0037689861608796726 0.38181208246390275 0.92423233672187921 0
		 -21.764748645584348 60.267779340084005 50.220973034692435 1;
	setAttr ".SpineGX" -type "matrix" -0.064511395484888268 0.0029472051922565801 0.99791262051299623 0
		 0.997916970142531 0.00016655411333931381 0.064511184776583602 0 2.3921247032538187e-005 0.99999564528364349 -0.0029518107141203558 0
		 6.6941943584216235 30.851805742056488 69.967385270158758 1;
	setAttr ".LeftArmGX" -type "matrix" 0.64298052342884782 -0.071955311307257117 0.76249533386271096 0
		 0.18650529038737118 -0.95089623503680143 -0.24700639497638222 0 0.74282726646718045 0.30102961747084589 -0.59798759082301078 0
		 23.363614607104722 18.95564319793769 121.5277274412133 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.26425700206702052 -0.29070645618887281 0.91959699402408734 0
		 0.18650536101202642 -0.95089620137766806 -0.24700636404109474 0 0.9462475781877645 0.10623647883435716 0.30549937848230629 0
		 46.088698197594312 16.412503787805228 148.47686801221607 1;
	setAttr ".LeftHandGX" -type "matrix" 0.64654355313777057 0.51941500171051058 0.55873963597969922 0
		 -0.079124394852673474 -0.682803003228316 0.72630567046853578 0 0.75876304642688208 -0.51379781555403148 -0.40036333064452601 0
		 39.062601073994585 8.6831660133556845 172.92721974720985 1;
	setAttr ".RightArmGX" -type "matrix" 0.86023590521730042 0.37059127002820069 0.35022408815470263 0
		 0.38503486004397286 -0.92240444080701656 0.030307396921201907 0 0.33427988628621597 0.10877700187929173 -0.936175768313386 0
		 -29.891460071558434 25.951378829385085 119.01108378823693 1;
	setAttr ".RightForeArmGX" -type "matrix" -0.013459570103743768 0.027223301312634007 0.99953913620624169 0
		 0.38503495339459987 -0.92240450248270167 0.030307352519991677 0 0.92280431624032033 0.38526521600165997 0.0019332232106670233 0
		 -60.295078047730783 12.853440539057869 106.63299079005969 1;
	setAttr ".RightHandGX" -type "matrix" 0.051118189422263365 -0.0025432999594192617 0.99868981862882555 0
		 0.17501878481055541 -0.98449863401112614 -0.011465460958029739 0 0.98323773191113228 0.17537548333750336 -0.049880650871982388 0
		 -59.937213873038139 12.129623253623819 80.057129092713325 1;
	setAttr ".HeadGX" -type "matrix" 0.1113350817844643 -0.14984380781790518 0.98242136516873935 0
		 0.93511471048578476 0.35043130531643968 -0.05252442479187637 0 -0.33640073483363797 0.92452413530836552 0.17913634312910653 0
		 2.658647476167908 21.158366475476779 133.4391233963774 1;
	setAttr ".LeftToeBaseGX" -type "matrix" -0.7025142084632191 0.69331093470011451 0.16060514202841486 0
		 0.5151274231982268 0.33967236699917097 0.7869350069467409 0 0.49103737264686609 0.63556507673457374 -0.59576803767705 0
		 23.406575543110883 69.747976948351024 40.286464839394249 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.00081661635561477942 -0.94269721702825815 0.33364881944017599 0
		 0.99384072130166068 -0.036208593628803153 -0.10473681818235919 0 0.11081602454932719 0.33167917333675845 0.93686115327423769 0
		 -27.153045331341048 75.842247023889428 43.764990026746112 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.77555501601838273 -0.48126844073741648 0.40852848745089576 0
		 0.25894263661136563 0.8327216310489487 0.48941137269389356 0 -0.57572874274609709 -0.27377996968967933 0.77044228782439861 0
		 6.5297840941458443 29.401829100051536 112.66040112337751 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.97793197001292131 0.013425984909567396 -0.20849286804695707 0
		 -0.01844023635581183 -0.98849160247843704 -0.15014784763899283 0 -0.20810933221695635 0.15067907004238551 -0.96642986163326794 0
		 -8.6649313809040915 26.242796057552074 114.48563558817058 1;
	setAttr ".NeckGX" -type "matrix" -0.059857764627678021 -0.23039299460506862 0.97125512922778412 0
		 0.99817184312032126 -0.021999267640342667 0.056298140864013586 0 0.0083962024175399698 0.97284903428796787 0.23128851388119726 0
		 3.6639964960033282 25.027962448887529 117.1262790922937 1;
	setAttr ".Spine1GX" -type "matrix" -0.060349818857139914 -0.31082361549201831 0.94854993772300877 0
		 0.99817184312032126 -0.021999267640342667 0.056298140864013586 0 0.0033686108542804265 0.95021305421212721 0.31158291229469687 0
		 4.8114599634136539 30.937818523874377 99.090990483325527 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "7CC8C90E-48E1-CDE3-A18E-B6B46D16130B";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAX";
	rename -uid "5FC5C293-4CC1-CE68-7F57-0F91BF13726E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -4.1978587361131004e-006 1 -1.4931978422824571e-006
		 2 -1.8312810830573492e-006 3 4.2260314384696245e-006 4 -9.8466584180531029e-006 5 -3.3174363575168721e-006
		 6 -1.311940587615974e-017 7 -6.4799182000061219e-006 8 -3.2117849138494577e-006 9 -3.0990915215752262e-006
		 10 1.0495448870595001e-016 11 -1.3523304795610203e-006 12 -3.0427436257341707e-006
		 13 0 14 -3.155437454084769e-006 15 -2.4792728574521269e-006 16 -1.4650246213186472e-006
		 17 0 18 0 19 -2.8173554554666396e-006 20 -3.606214386164602e-006 21 1.0495448870595001e-016
		 22 -4.8458500429525736e-006 23 0 24 -1.0495467324929683e-016 25 -1.2396363045022037e-006
		 26 2.7046614969596928e-006 27 -4.1981871312712797e-016 28 4.1981870548820686e-016
		 29 -4.9585455614154566e-006 30 -1.3523306206904846e-006 31 -9.9170917596159494e-006
		 32 -5.8600988655458226e-006 33 -1.8031076371232408e-006 34 -5.4093201414577393e-006
		 35 -4.5077679807885688e-006 36 3.6062155652141891e-006 37 1.6792748525085119e-015
		 38 -3.6062143825442807e-006 39 0 40 -1.8031077536769665e-006 41 -1.8031073002148007e-006
		 42 -6.3108756444681765e-006 43 -1.803106968351035e-006 44 2.7046616559692455e-006
		 45 -7.2124292807124395e-006 46 -6.3108768321272877e-006 47 -9.9170889479746996e-006
		 48 -5.4093222650396418e-006 49 -5.4093222650396418e-006 50 -5.4093222650396418e-006
		 51 -5.4093222650396418e-006 52 -5.4093222650396418e-006 53 -5.4093222650396418e-006
		 54 -5.4093222650396418e-006 55 -5.4093222650396418e-006 56 -5.4093222650396418e-006
		 57 -5.4093222650396418e-006 58 -5.4093222650396418e-006 59 -5.4093222650396418e-006
		 60 -5.4093222650396418e-006 61 -5.4093222650396418e-006 62 -5.4093222650396418e-006
		 63 -5.4093222650396418e-006 64 -5.4093222650396418e-006 65 -5.4093222650396418e-006
		 66 -5.4093222650396418e-006 67 -5.4093222650396418e-006 68 -5.4093222650396418e-006
		 69 -5.4093222650396418e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAY";
	rename -uid "7C39D746-4191-B168-5FE5-5FA317480395";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 18.737108943637292 1 18.737108454960424
		 2 18.737112086126629 3 18.737109268975033 4 18.737113602226295 5 18.737110437269724
		 6 18.737107303750559 7 18.737109812409713 8 18.737107109529155 9 18.73710454076161
		 10 18.737109794208461 11 18.737108971503353 12 18.737106129175093 13 18.737114133670357
		 14 18.737108961829744 15 18.737107413690232 16 18.737105779679922 17 18.737106894426162
		 18 18.737109897830539 19 18.737111115422302 20 18.737110069612889 21 18.737103134617318
		 22 18.737101085685353 23 18.737109930436365 24 18.737102924272016 25 18.737105631838133
		 26 18.737109367899556 27 18.737114887242775 28 18.737107949996574 29 18.737113525882148
		 30 18.737105991360256 31 18.737106595629204 32 18.737101614517034 33 18.737111561990154
		 34 18.737104038835696 35 18.73710900080631 36 18.73710985278101 37 18.737110963227607
		 38 18.73711046046445 39 18.737110783691822 40 18.737110682170528 41 18.737110047492013
		 42 18.737109993899722 43 18.737110264070534 44 18.737112166947572 45 18.7371116030039
		 46 18.737110229653357 47 18.737108374153145 48 18.737111200884097 49 18.737111200884097
		 50 18.737111200884097 51 18.737111200884097 52 18.737111200884097 53 18.737111200884097
		 54 18.737111200884097 55 18.737111200884097 56 18.737111200884097 57 18.737111200884097
		 58 18.737111200884097 59 18.737111200884097 60 18.737111200884097 61 18.737111200884097
		 62 18.737111200884097 63 18.737111200884097 64 18.737111200884097 65 18.737111200884097
		 66 18.737111200884097 67 18.737111200884097 68 18.737111200884097 69 18.737111200884097;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ";
	rename -uid "97BD7683-41E7-9994-A6A7-47931D9D0299";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.7085208156093601 1 2.5897297695924077
		 2 2.2527371933439695 3 1.7266504011673429 4 1.0405461477515396 5 0.2235347961106926
		 6 -0.69530418404869976 7 -1.6868834095559002 8 -2.7220900238248982 9 -3.7718457906611054
		 10 -4.8070571391247778 11 -5.7986271347227536 12 -6.7174629040519633 13 -7.5344807261563522
		 14 -8.2205843910141869 15 -8.746673462698352 16 -9.0836575222551961 17 -9.2024506872008232
		 18 -8.9064528110155337 19 -8.0328197340632865 20 -6.6031002730994732 21 -4.6388342871336228
		 22 -2.1615859962896087 23 0.80711593756673916 24 4.2457171306585648 25 8.1326551370952807
		 26 12.446407091024676 27 17.165400982731857 28 22.268118150297916 29 27.732977789908627
		 30 33.538467482322993 31 39.663006766208518 32 46.085083086171537 33 52.783121735571619
		 34 59.735548795374406 35 66.920889820361126 36 74.317578383400871 37 81.90400081489264
		 38 89.658660369289493 39 90.366842939759309 40 90.988871345266162 41 91.483777569504539
		 42 91.810704820869134 43 91.928779024698585 44 91.769733764920389 45 91.363230452401069
		 46 90.815344468508059 47 90.232113084989464 48 89.719592008104314 49 89.719592008104314
		 50 89.719592008104314 51 89.719592008104314 52 89.719592008104314 53 89.719592008104314
		 54 89.719592008104314 55 89.719592008104314 56 89.719592008104314 57 89.719592008104314
		 58 89.719592008104314 59 89.719592008104314 60 89.719592008104314 61 89.719592008104314
		 62 89.719592008104314 63 89.719592008104314 64 89.719592008104314 65 89.719592008104314
		 66 89.719592008104314 67 89.719592008104314 68 89.719592008104314 69 89.719592008104314;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX_tempLayer_inputA";
	rename -uid "50B074BC-4012-D0E3-CAA1-15800DE07CB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.5792288780212402 1 3.5843284130096436
		 2 3.5935878753662109 3 3.6131985187530518 4 3.6410677433013916 5 3.6744122505187988
		 6 3.7101516723632812 7 3.7452294826507568 8 3.7769303321838379 9 3.8028538227081299
		 10 3.8099977970123291 11 3.7869923114776611 12 3.7379829883575439 13 3.6726951599121094
		 14 3.5986764430999756 15 3.5212762355804443 16 3.4522430896759033 17 3.4111020565032959
		 18 3.4270255565643311 19 3.3763279914855957 20 3.2399139404296875 21 3.0506479740142822
		 22 2.8521068096160889 23 2.6923258304595947 24 2.5971262454986572 25 2.5729122161865234
		 26 2.6159498691558838 27 2.6762626171112061 28 2.6745753288269043 29 2.5940098762512207
		 30 2.4975337982177734 31 2.3549408912658691 32 2.1810400485992432 33 2.016249418258667
		 34 1.8772621154785156 35 1.7934107780456543 36 1.7044565677642822 37 1.6085164546966553
		 38 1.5243661403656006 39 1.5501470565795898 40 1.8677561283111572 41 2.3773295879364014
		 42 2.814028263092041 43 2.9793164730072021 44 2.8165006637573242 45 2.4248447418212891
		 46 1.9125576019287109 47 1.3953170776367187 48 1.0138871669769287 49 0.91118311882019043
		 50 1.1575398445129395 51 1.8758409023284912 52 3.1344542503356934 53 4.0555534362792969
		 54 5.0676431655883789 55 4.4502935409545898 56 3.9112625122070312 57 3.6168537139892578
		 58 3.5064394474029541 59 3.6332569122314453 60 3.9224412441253662 61 4.2399253845214844
		 62 4.5820026397705078 63 4.7420353889465332 64 4.6847724914550781 65 4.6428532600402832
		 66 4.6876344680786133 67 4.7636833190917969 68 4.7636833190917969 69 4.7636833190917969;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY_tempLayer_inputA";
	rename -uid "BB554B41-4D8B-3BE1-9A44-5DBC2E5C41BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 51.674160003662109 1 51.774772644042969
		 2 51.795608520507812 3 51.766872406005859 4 51.657798767089844 5 51.438529968261719
		 6 51.080581665039063 7 50.557060241699219 8 49.842563629150391 9 48.912883758544922
		 10 47.798831939697266 11 46.433277130126953 12 44.692710876464844 13 42.507476806640625
		 14 39.756629943847656 15 36.278610229492188 16 32.108848571777344 17 27.428205490112305
		 18 27.415481567382812 19 27.471523284912109 20 27.465217590332031 21 27.3790283203125
		 22 27.200376510620117 23 26.940479278564453 24 26.614313125610352 25 26.259078979492188
		 26 25.981044769287109 27 25.785915374755859 28 25.666051864624023 29 25.578166961669922
		 30 25.480865478515625 31 25.57136344909668 32 26.005352020263672 33 26.810657501220703
		 34 28.049684524536133 35 29.686727523803711 36 31.778554916381836 37 34.003879547119141
		 38 35.894203186035156 39 37.156650543212891 40 38.449748992919922 41 39.544418334960938
		 42 40.513076782226563 43 40.84954833984375 44 40.447437286376953 45 39.471229553222656
		 46 38.121284484863281 47 36.58612060546875 48 35.032962799072266 49 33.776535034179688
		 50 32.255783081054688 51 30.441701889038086 52 28.301471710205078 53 26.955053329467773
		 54 25.633016586303711 55 25.916814804077148 56 26.027584075927734 57 25.843528747558594
		 58 26.24799919128418 59 26.118747711181641 60 25.547014236450195 61 24.895595550537109
		 62 24.107570648193359 63 23.692054748535156 64 23.718778610229492 65 23.719944000244141
		 66 23.660757064819336 67 23.56525993347168 68 23.56525993347168 69 23.56525993347168;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ_tempLayer_inputA";
	rename -uid "BBD51D6E-4A63-54CB-F30E-6D9C846211B8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -20.349437713623047 1 -18.030025482177734
		 2 -15.621157646179199 3 -13.11439037322998 4 -10.528463363647461 5 -7.883234977722168
		 6 -5.199488639831543 7 -2.4987225532531738 8 0.19732403755187988 9 2.8669462203979492
		 10 5.4453697204589844 11 7.8985214233398438 12 10.268477439880371 13 12.60832405090332
		 14 14.951624870300293 15 17.285505294799805 16 19.508974075317383 17 21.534212112426758
		 18 23.297603607177734 19 25.367050170898438 20 27.417877197265625 21 29.43779182434082
		 22 31.412269592285156 23 33.324539184570312 24 35.03125 25 36.452362060546875 26 37.74884033203125
		 27 38.982608795166016 28 40.187732696533203 29 41.325634002685547 30 42.330692291259766
		 31 43.148826599121094 32 43.825916290283203 33 44.490253448486328 34 45.261810302734375
		 35 46.32843017578125 36 48.136623382568359 37 50.797527313232422 38 53.735641479492187
		 39 55.714035034179688 40 57.418647766113281 41 58.657684326171875 42 59.3736572265625
		 43 59.662254333496094 44 59.554473876953125 45 59.109382629394531 46 58.370468139648438
		 47 57.367202758789063 48 56.173343658447266 49 54.922210693359375 50 53.624973297119141
		 51 52.255134582519531 52 51.037712097167969 53 50.563232421875 54 50.410442352294922
		 55 49.941730499267578 56 49.573932647705078 57 49.507476806640625 58 49.739250183105469
		 59 49.895683288574219 60 49.9521484375 61 49.914180755615234 62 49.879310607910156
		 63 50.031806945800781 64 49.979343414306641 65 49.946617126464844 66 49.971271514892578
		 67 50.017356872558594 68 50.017356872558594 69 50.017356872558594;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX";
	rename -uid "0C7E5D14-48A3-F9B5-EF3D-609992D49320";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -6.6249349688741992 1 -5.6089606010226349
		 2 -4.4482267675027067 3 -3.0694139249207053 4 -1.5039449182056093 5 0.2156602902378868
		 6 2.0502285599229659 7 3.9494316167293957 8 5.8482926255909957 9 7.6695599105451882
		 10 7.6496183335952495 11 7.3388010748376988 12 8.3249768885422721 13 10.905418489431797
		 14 14.739299691022785 15 17.962594364486204 16 20.229790188365882 17 23.910945028930445
		 18 23.164163448120899 19 23.419415786980942 20 23.844100569019432 21 23.952001091021149
		 22 23.488724692155007 23 22.497468965740044 24 21.171471280541997 25 20.769063810205793
		 26 15.864677410833593 27 10.629532758967535 28 5.7779075646814686 29 2.0553922109777698
		 30 -0.64501300922384563 31 -2.0013431072140748 32 -2.3037836132832319 33 -2.0646617759359498
		 34 -1.2433875258576521 35 0.15523525632990909 36 1.8922930058854066 37 3.6117466686696091
		 38 5.464770433118411 39 7.2580759850133223 40 6.399982519420778 41 5.9821916300211715
		 42 4.5288485556094935 43 1.4476439111418755 44 -2.7073231068594428 45 -7.2623520588960675
		 46 -11.667868240496491 47 -15.498391508155461 48 -18.431744148392845 49 -20.365514348366037
		 50 -20.90558991110483 51 -22.907133552245792 52 -23.695940401840989 53 -24.49200073175254
		 54 -25.148366607233431 55 -24.686747904728957 56 -23.866294239524009 57 -23.113561960637462
		 58 -23.110437542357225 59 -23.525766685758004 60 -23.971359262985846 61 -24.41840370754765
		 62 -24.852927577035359 63 -24.842481817351921 64 -24.873958416404587 65 -24.880389207732538
		 66 -24.87013088285314 67 -24.8526162411749 68 -24.8526162411749 69 -24.8526162411749;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY";
	rename -uid "4E42F9A7-469D-D08D-1A4B-2D87DE236291";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 17.65472299930223 1 17.891364475172111
		 2 18.182013361503618 3 18.556714311098265 4 18.951441750795031 5 19.308069131305682
		 6 19.57529989777484 7 19.711097643197892 8 19.686022967672315 9 19.488823262308486
		 10 18.881289925133327 11 18.55833613318325 12 18.993501982604574 13 20.374525977296319
		 14 22.576813495228741 15 24.129128760715084 16 24.696893611786088 17 26.036600889227959
		 18 23.246381488673492 19 22.988657312183758 20 22.263576736403188 21 21.138203852174495
		 22 19.694663689023447 23 18.008119617610159 24 16.207016511578956 25 14.217026684384754
		 26 14.826495736507733 27 15.192969022885768 28 15.343607684310259 29 14.373312105168296
		 30 13.134085812231261 31 12.458829693775698 32 12.140141498410685 33 12.088231690922216
		 34 12.138500012703942 35 12.231171690402 36 12.366420349161384 37 13.013121435940128
		 38 12.590800834554052 39 11.630755319546036 40 10.016000825456926 41 9.7491973491587807
		 42 10.415723158917439 43 11.575362398856447 44 12.702119192315537 45 13.502790734488388
		 46 13.554700449930635 47 12.744700460836015 48 11.212318714222981 49 9.205601630409701
		 50 10.546499934770738 51 5.0650302535260661 52 -0.603068144403761 53 -1.1493652789519768
		 54 -1.3520076789232662 55 0.13451026824511222 56 1.6074094976365974 57 2.5599706156572037
		 58 2.520485002470374 59 1.4827274453360459 60 -0.19751091999368153 61 -1.2630271649438445
		 62 -2.6159760408241639 63 -2.665581906453677 64 -2.9042986796445285 65 -2.9695933061591555
		 66 -2.9018382308789379 67 -2.7850776242090207 68 -2.7850776242090207 69 -2.7850776242090207;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "20BBBC34-4DA9-01DA-2FA4-229603B5E5FD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.1872635962108959 1 4.6473002103642722
		 2 7.6224653948739656 3 11.302003903986115 4 15.567342251773415 5 20.30272343657866
		 6 25.381261872478451 7 30.650528575387867 8 35.916045828414148 9 40.93618118702355
		 10 39.29349094480569 11 34.578694406569944 12 31.875742028224632 13 32.013691362896076
		 14 34.491074395365125 15 37.635881941441177 16 40.783914437341771 17 45.318611237893563
		 18 49.384624511101507 19 50.016673149460431 20 51.60513168334019 21 53.695248624111599
		 22 56.0513854490151 23 58.881480065362894 24 62.828390472391227 25 72.976528984420654
		 26 67.479815840946202 27 62.500487352427591 28 57.613524217347489 29 52.516174816608618
		 30 48.011347151181965 31 45.762571918998589 32 46.108791757050675 33 48.141478054790248
		 34 51.461404428305237 35 55.987363517920301 36 61.314970015163894 37 66.855327547701009
		 38 72.671986017515835 39 78.16203401917214 40 69.961490222776533 41 64.546296921753239
		 42 59.551237474435766 43 54.552659393970139 44 49.641441193292813 45 44.732334928217767
		 46 39.460067750684722 47 34.151747752819986 48 29.271957003780891 49 25.030902153530867
		 50 26.501727129446085 51 17.123312317401098 52 7.3078183437666331 53 3.8091248250205969
		 54 0.77866527840196265 55 3.5399245774903547 56 7.3352203832778198 57 10.080163515583809
		 58 8.7112649682583996 59 5.0374681383597446 60 0.62758511866927857 61 -1.5293859395868501
		 62 -3.8720267816094043 63 -3.5980153177975209 64 -3.7778361899974957 65 -3.7870115364101866
		 66 -3.7092730829267309 67 -3.5812218846342674 68 -3.5812218846342674 69 -3.5812218846342674;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX";
	rename -uid "128BC637-4D2B-FEB3-9FB5-3D96A49A1B42";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.9409862152602591 1 2.7131024061078493
		 2 2.5673852449637056 3 2.5150571517059284 4 2.5525402664017229 5 2.6722929699295115
		 6 2.8632597708866285 7 3.1120088099151353 8 3.4047256938196786 9 3.7294186027524647
		 10 3.0268654759439046 11 0.56751812789473755 12 -1.9667496817926444 13 -3.4594374515158681
		 14 -3.5964735192701753 15 -3.0495801184715066 16 -2.3965322055488292 17 -1.4406870156727543
		 18 -1.7491067467490626 19 -1.3983277320419065 20 -0.47092381190127974 21 0.88291470953757145
		 22 2.5416430754465731 23 4.3218254233473816 24 5.794584383147849 25 5.4703450869977681
		 26 7.4942911345132348 27 9.4203554624714538 28 11.166525821694764 29 12.722735408233369
		 30 14.079632731546319 31 16.234485338618526 32 17.527387746842628 33 18.084397780380343
		 34 18.050427209637164 35 17.224865434652209 36 15.157545457274448 37 12.180121715551138
		 38 10.504298441901614 39 7.8257797702851413 40 6.3635226116088912 41 4.678518481362361
		 42 2.5216653739037858 43 0.86822966525604994 44 0.071773129051413836 45 0.47159918698145425
		 46 -0.69296131424693574 47 0.14704743021547015 48 0.45595785977773073 49 0.79955382278869203
		 50 0.4121690780997207 51 3.3758187774653154 52 6.7749038195203504 53 9.8690999347177097
		 54 11.65217101307767 55 11.175533886763722 56 9.4817047822121339 57 8.1634062700165178
		 58 7.4092620429830598 59 7.8487763039395055 60 9.1261192264537723 61 10.760479010791215
		 62 11.5392371996259 63 11.545283260612383 64 11.414925441233555 65 11.418411557824548
		 66 11.449215875709006 67 11.498776880537825 68 11.498776880537825 69 11.498776880537825;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY";
	rename -uid "C8823CFB-4B9F-5A68-DE6C-6E88B896966A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -0.044644024984307404 1 -0.027096128971667546
		 2 -0.025440400784070526 3 -0.042585190597096707 4 -0.075172525790217687 5 -0.11868801692314963
		 6 -0.16793357724878763 7 -0.21780950319266459 8 -0.26360103425508702 9 -0.30016374589457245
		 10 -0.1731817066083286 11 0.19673637007873124 12 1.0248504742092259 13 2.0468625212678315
		 14 2.6973930339369412 15 2.6932759714038839 16 2.3276055400991158 17 1.911223550477986
		 18 0.33531722494865002 19 0.17531622740629466 20 -0.23536502317265842 21 -0.74756873470550744
		 22 -1.1662871842064655 23 -1.2963278284061552 24 -1.0587499682698325 25 -0.85340687300856177
		 26 -0.79071199476642484 27 -0.50613273826049388 28 0.10082065018487381 29 2.7760475460882819
		 30 5.6899935334652589 31 7.3923604985921827 32 8.6135271221976062 33 9.10186857478074
		 34 8.5754657676575334 35 7.1835357388685139 36 5.0430596723066961 37 1.203382431118365
		 38 -0.57523237015125361 39 -0.88536649708762272 40 -1.0440835265765773 41 -1.4167973082610743
		 42 -1.447358284799005 43 -1.2862476549913893 44 -1.1804080352476007 45 -1.1453426262632371
		 46 -1.0922635462888022 47 -1.0183944387617418 48 -0.91931023739735984 49 -0.80025517096704057
		 50 -0.50414676629875399 51 -0.6894684002066912 52 -0.87551521086048156 53 -0.86184309764730738
		 54 -0.41081382763158208 55 -0.69530008177188729 56 -0.85415943618709789 57 -0.85262528235964952
		 58 -0.82545491084113143 59 -0.83887609359198623 60 -0.85031135218836518 61 -0.7960982111773911
		 62 -0.61298248733845462 63 -0.61302740350169493 64 -0.61296689751660016 65 -0.61299351247340583
		 66 -0.61296976405513215 67 -0.61299454596340119 68 -0.61299454596340119 69 -0.61299454596340119;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ";
	rename -uid "238EE460-4C15-055C-0EDF-6CB901C334D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -32.21577675023385 1 -31.334138015476121
		 2 -30.929430580149646 3 -31.469440781761499 4 -32.773211661203398 5 -34.663202991079508
		 6 -36.936803876935457 7 -39.335504601490925 8 -41.50649442589107 9 -42.984318158057896
		 10 -28.88534865295367 11 -5.9217732370072014 12 14.943300197845375 13 31.094001127870179
		 14 41.114291313964458 15 43.488979588443833 16 41.482601676622906 17 39.761967928688939
		 18 34.537951032377705 19 32.643311179970965 20 27.308772829563271 21 18.940163639206602
		 22 7.6825499915538185 23 -6.9039245936486155 24 -25.950117714630277 25 -60.272190216581485
		 26 -59.052390420284638 27 -58.027999345896994 28 -57.434022781551867 29 -57.431232963587206
		 30 -57.627265458921769 31 -58.989319902480318 32 -60.898399185219482 33 -61.869212863391866
		 34 -60.899065257283127 35 -58.911992952429557 36 -57.522039266227736 37 -57.340131904850764
		 38 -57.908762276818166 39 -59.218502790075149 40 -31.082127093899707 41 -11.993241290772628
		 42 0.64817442513694468 43 6.0893192013698094 44 4.4898224464187164 45 -1.6561748116877433
		 46 -8.9833997027708801 47 -17.275182163613483 48 -26.644058039635105 49 -36.468498487440463
		 50 -62.889207028822824 51 -62.05317315897603 52 -60.668782918274694 53 -58.991944596055127
		 54 -57.658558424238542 55 -58.310642820365395 56 -59.380962999129125 57 -60.35687698381345
		 58 -60.765440273134075 59 -60.537391718836886 60 -59.93932157729612 61 -59.128721277394767
		 62 -58.315829571821958 63 -58.316298648145498 64 -58.31550577700191 65 -58.315818513937323
		 66 -58.315424377828414 67 -58.316106602941311 68 -58.316106602941311 69 -58.316106602941311;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX";
	rename -uid "7B6E6F24-461F-0F93-73A5-D597631EC7B3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -24.67231051408007 1 -24.998519737775155
		 2 -25.269315417139119 3 -25.446441551980357 4 -25.527049439115835 5 -25.510090644905119
		 6 -25.400491605572743 7 -25.213819497793629 8 -24.982986312631844 9 -24.762724744700858
		 10 -25.390601579717902 11 -25.388248000836828 12 -25.100711287163406 13 -25.436490872173074
		 14 -26.98225194888666 15 -28.482321194288282 16 -29.262978582912812 17 -31.139808552966958
		 18 -28.6652321668201 19 -29.785562018993414 20 -32.669893863087509 21 -36.503279164107639
		 22 -40.381077383556558 23 -43.354039312083167 24 -44.400797962767214 25 -40.286928709807718
		 26 -43.622105905781979 27 -46.765075387482803 28 -49.470606735533359 29 -51.954171448761031
		 30 -53.986438057193062 31 -56.4627048978532 32 -57.928421303098936 33 -58.604704081785627
		 34 -58.655750790778875 35 -57.876373431325376 36 -55.565814543015605 37 -51.709351462189503
		 38 -48.786966747878729 39 -44.669720340265727 40 -46.610157634614183 41 -47.193212155762012
		 42 -46.669261596337073 43 -45.914742165853106 44 -45.345653038992289 45 -45.557182889476074
		 46 -43.960527349146702 47 -43.967941548983447 48 -42.938108839127523 49 -41.740580384155599
		 50 -38.03227986219855 51 -40.893061530805156 52 -45.265122706707672 53 -49.514428094637609
		 54 -52.216106345812733 55 -51.292872441636071 56 -48.946521032600891 57 -47.399384026739952
		 58 -46.839285760280426 59 -47.797402070809547 60 -49.588399781016562 61 -51.828605795559831
		 62 -53.191210287622397 63 -53.270405056342675 64 -53.01651287885371 65 -52.993176504821932
		 66 -53.065511281073285 67 -53.18480621433617 68 -53.18480621433617 69 -53.18480621433617;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY";
	rename -uid "50BF4DEC-43EA-07B5-C604-A2AE2D0D3ED8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 15.805399055350481 1 15.72902840105564
		 2 15.677029973786087 3 15.69266984482225 4 15.760799380623254 5 15.871139014008593
		 6 16.013979123462732 7 16.176485378389742 8 16.339011984909305 9 16.47205255054228
		 10 15.432934311447003 11 14.311780847377618 12 14.122234018551707 13 14.684675022139125
		 14 15.577780399133671 15 16.385047285846298 16 17.021143786171969 17 17.747133713666326
		 18 16.683512151145333 19 16.565820909594159 20 16.495443044943869 21 16.983762457042697
		 22 18.350777148286252 23 20.515855266895468 24 22.962353333324611 25 24.691138489120757
		 26 25.964198589709191 27 26.671903266367522 28 27.165654217951879 29 26.710769341268136
		 30 26.056236512439288 31 26.310816377839583 32 26.478251768925087 33 26.340396558977428
		 34 25.923495069035269 35 25.434720700730708 36 25.314565293163312 37 26.12439644676774
		 38 25.887616720398405 39 24.296126643581303 40 20.749156442089003 41 18.127951509528803
		 42 16.135295513499369 43 14.883905989541532 44 14.546990106200465 45 14.999428988561844
		 46 15.601142032631525 47 16.698837891599752 48 17.591348333213769 49 18.385272974298903
		 50 18.194064490062349 51 21.151731290584575 52 23.043984859956208 53 23.177652017457497
		 54 21.954227484021636 55 22.732288348348693 56 23.542854260284209 57 24.690545082976453
		 58 25.840525030461567 59 27.465524434274236 60 28.761974719433198 61 28.894753947341385
		 62 28.01654170548467 63 27.139466985643345 64 26.785057375030394 65 26.838262568762822
		 66 26.815546578652889 67 26.773394733725738 68 26.773394733725738 69 26.773394733725738;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ";
	rename -uid "A9DC7C50-405A-2D8E-D342-0BABE59CABB9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 16.108106073018678 1 16.273736207785063
		 2 16.8206624578259 3 17.975546517036356 4 19.621459681977456 5 21.640681368929439
		 6 23.899763024648433 7 26.2328650819681 8 28.419770433890204 9 30.174478721149455
		 10 22.948382226086714 11 10.770102880412981 12 -0.24671143683021282 13 -8.8426730199304515
		 14 -14.311791560145572 15 -15.218759919283055 16 -13.30704998479362 17 -12.163347573123279
		 18 -7.3114027352941582 19 -5.0849599316382168 20 0.9251032257334254 21 9.8155325024562217
		 22 20.719937020379945 23 32.987326849455819 24 46.38142956473564 25 67.087317764162137
		 26 63.332888570977325 27 59.342771928978209 28 56.281738710190773 29 53.714330950044157
		 30 50.804588072000243 31 48.142893834290163 32 46.25992696941595 33 44.515868859015043
		 34 42.67244839933511 35 41.317163835657347 36 41.929645556826152 37 44.889231731644962
		 38 49.176073924840622 39 54.917388177589054 40 42.453415629808248 41 35.329804480844629
		 42 31.872432105956388 43 32.121525213631621 44 35.843399746439765 45 41.886160086728275
		 46 48.641200235333152 47 54.877016558472569 48 60.044455638713544 49 63.739374671772204
		 50 74.579079721777575 51 65.227052990252957 52 53.270822292067166 53 41.999690105987561
		 54 32.163063264009466 55 35.775145809912317 56 41.132492220479214 57 48.201533962854114
		 58 56.632766447858039 59 61.217376745851332 60 60.176070890111653 61 54.044023657343367
		 62 46.566580882188489 63 43.421074414171763 64 42.449973860925539 65 42.493507513690794
		 66 42.371443797540458 67 42.169498770240743 68 42.169498770240743 69 42.169498770240743;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX";
	rename -uid "6C65044D-479A-1642-5D5D-0F8984DA873C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -14.490871744825531 1 -11.585812206442538
		 2 -8.6267463628581709 3 -5.5668426465649441 4 -2.4378265939554655 5 0.71303857853075925
		 6 3.8347401731598816 7 6.8848150422297438 8 9.8374361835770152 9 12.684711367412046
		 10 15.386117786893763 11 17.95764700293368 12 20.491654056769338 13 23.129221301561795
		 14 26.083633051445624 15 29.636068445888991 16 34.145287129566682 17 40.417094159464767
		 18 40.808026648688063 19 41.000946179443517 20 41.53010562025613 21 42.29039797118385
		 22 43.10346376931038 23 43.428676863666894 24 42.799594506718641 25 41.357433885043328
		 26 39.448352629612295 27 36.916271984051392 28 34.324085687368985 29 32.009221180563287
		 30 28.270484057212357 31 22.777429914832574 32 15.718622859365549 33 5.3705875146868216
		 34 -4.5242647378533141 35 -12.981384601156403 36 -18.919542778175831 37 -18.348259061026297
		 38 0.72243520109562387 39 27.842399935230123 40 39.897009992179186 41 42.686731559052333
		 42 42.262956193646879 43 41.442461831053556 44 41.258692036230322 45 41.665103822958478
		 46 43.227121657962428 47 45.999217004704228 48 49.725195584410649 49 53.96222691344753
		 50 57.88006419889409 51 58.365114763766734 52 23.93075672751025 53 -59.077874667896566
		 54 -51.770697896727633 55 -49.169741159401632 56 -48.036998924261191 57 -44.305641229998237
		 58 -42.097400564082541 59 -41.785458604629547 60 -43.747851257960107 61 -46.928236256504469
		 62 -49.536619558290724 63 -50.567144518842298 64 -50.929840259852362 65 -51.099162540561096
		 66 -50.956373056570243 67 -50.686733420029988 68 -50.686733420029988 69 -50.686733420029988;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY";
	rename -uid "D1A7A366-43F5-3F50-D413-E6AAD6DFA958";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 37.439535470695255 1 37.848716122487801
		 2 38.002177857317442 3 37.868536995753288 4 37.432571220097365 5 36.69615480956827
		 6 35.677896713048604 7 34.409533985424609 8 32.929300571672393 9 31.273619528210123
		 10 29.512643251706066 11 27.721944525179495 12 25.886523891211922 13 23.943612249324669
		 14 21.723300741853382 15 18.839926393266619 16 14.756762187538474 17 7.8524752049312685
		 18 2.3831661704055414 19 2.8228299644596491 20 4.0667600930864447 21 6.0018115098566822
		 22 8.4524039915558369 23 13.552442581609144 24 20.162510883059717 25 25.69525080553667
		 26 29.614313886942377 27 33.113243768144294 28 36.798616650397456 29 41.170112143902145
		 30 46.661460534554102 31 52.625419371166693 32 57.971427896175655 33 59.939823859730659
		 34 60.062906436920144 35 59.813115860268489 36 60.817490733326899 37 64.63092292963843
		 38 67.241609947859146 39 60.257693805606991 40 45.875269763237505 41 29.721136112659945
		 42 16.271748506817662 43 9.5361753934280369 44 6.7508156185934087 45 10.677722736678502
		 46 16.453341953037331 47 24.276054269579337 48 33.975498798624976 49 45.203900914511962
		 50 57.675391476905737 51 70.833433783425477 52 82.625986507571923 53 70.372191182037781
		 54 45.107940886915117 55 43.413220623743932 56 44.737799363676849 57 43.12489492857307
		 58 47.800549777992742 59 50.163223055995005 60 49.778986386156966 61 46.903982235664436
		 62 42.966588904431781 63 38.877223861505826 64 39.884788661690209 65 40.414274642670151
		 66 39.459170388032703 67 37.922524601877413 68 37.922524601877413 69 37.922524601877413;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "27AE24F7-425F-D4D5-7E42-969060F3E5F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.38703984305204236 1 6.1312237039483461
		 2 12.04544394154334 3 18.198262840748342 4 24.551929543985594 5 31.050327065403494
		 6 37.630244944622284 7 44.235175143630521 8 50.826227320080577 9 57.387490199884674
		 10 63.747379761093804 11 70.218835757564847 12 77.220524723635208 13 84.816050006113613
		 14 93.144976361590537 15 102.43440087987965 16 112.67733824044998 17 124.18151110225431
		 18 127.45006931914094 19 127.54983221747226 20 127.71837372424902 21 127.67636425257916
		 22 127.10222910769355 23 124.35683248030978 24 119.73932139507339 25 114.58229867014008
		 26 109.3951817444115 27 103.25382186519769 28 97.24333715137648 29 92.1862466086327
		 30 84.517011256684953 31 74.050396639352869 32 61.720115752230306 33 44.753614385540885
		 34 28.905344295416114 35 15.596308402368185 36 8.8265185577556196 37 14.797978799142486
		 38 43.152443630463445 39 80.144865485325397 40 100.88318270622605 41 110.87425918081135
		 42 116.01331066250465 43 120.25534483680815 44 125.03775975185557 45 127.7549043063065
		 46 130.70170253288273 47 133.25458602683977 48 135.12217172204623 49 135.98266347466219
		 50 134.88929655577871 51 128.56659067636727 52 84.920156893805355 53 -13.920367268689583
		 54 -32.405298090592005 55 -34.902754366814492 56 -37.532632014924211 57 -37.533569934123904
		 58 -30.315954768568854 59 -27.311646904147441 60 -29.186954819676213 61 -34.935082398803523
		 62 -41.564257914897809 63 -46.921180000080142 64 -46.802794117440492 65 -46.897482973227419
		 66 -47.4421256832387 67 -48.294566562990745 68 -48.294566562990745 69 -48.294566562990745;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX";
	rename -uid "C9798F12-4E5B-2C31-B184-809C3051C06F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -6.2584152779594326 1 -6.6753956768644196
		 2 -7.0010899412758043 3 -7.2411592394188311 4 -7.4264486386358337 5 -7.586766558131643
		 6 -7.7481100313088707 7 -7.9346438433195798 8 -8.1738390566223433 9 -8.5007498033981008
		 10 -8.9264656111589247 11 -9.2652561262519377 12 -9.3842296930552997 13 -9.4101183294102437
		 14 -9.5144646551240459 15 -9.9128877216260651 16 -10.823319801192484 17 -12.616917207175812
		 18 -15.569521778724996 19 -15.587657031588199 20 -15.641077723094485 21 -15.73100184696562
		 22 -15.853739864440008 23 -14.716230333277807 24 -14.342148227414331 25 -14.018491454792821
		 26 -13.79943072843011 27 -13.594438110527143 28 -13.472393161403566 29 -13.499409986917943
		 30 -13.827165432410403 31 -15.137892485552753 32 -17.268870788211451 33 -18.387895141184202
		 34 -19.083101143291195 35 -18.883688231830288 36 -17.961316086238345 37 -17.077202430500137
		 38 -16.238430356481793 39 -15.337256433742054 40 -14.651631910073505 41 -13.99943008234588
		 42 -14.232493708828398 43 -14.816181799543765 44 -15.789094142525947 45 -14.991074549597769
		 46 -15.261504309401564 47 -15.71199250934335 48 -16.26427568146266 49 -16.86175826268698
		 50 -17.548154771888491 51 -18.325517706592006 52 -18.833397918653766 53 -17.614745074197401
		 54 -14.024150785930587 55 -14.804652468214895 56 -17.10711017217109 57 -17.984440592404031
		 58 -18.449720218157001 59 -18.884118309086123 60 -19.14737035292821 61 -19.256602977589115
		 62 -19.269886333704324 63 -19.010355508288249 64 -19.147702649251649 65 -19.262109218911476
		 66 -19.112916348605243 67 -18.906163515435299 68 -18.906163515435299 69 -18.906163515435299;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY";
	rename -uid "DCFBEF92-411B-9783-2D6D-FBB68A58199B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.029292217933199347 1 0.011361886461668965
		 2 -0.007672316063181462 3 -0.017845827806618718 4 -0.020107075932884758 5 -0.019522085925737183
		 6 -0.021112933166071598 7 -0.029415059754004269 8 -0.051008746521803525 9 -0.098493763281890842
		 10 -0.19566389682321264 11 -0.31717890390720865 12 -0.39808231437334729 13 -0.43423469496432771
		 14 -0.43946423077354591 15 -0.42831259871693844 16 -0.38514450628069075 17 -0.085194496118341276
		 18 0.46254494225350973 19 0.46686978425243969 20 0.47777354120484433 21 0.49206100118018808
		 22 0.50690580405902086 23 0.025679024061641128 24 -0.74275767606316323 25 -1.362294998420607
		 26 -1.8391319702692568 27 -2.3083740725729247 28 -2.7136704537182439 29 -2.9875669652610184
		 30 -3.8025086746572048 31 -6.0766243628202954 32 -9.8574146695452285 33 -9.0367372190358992
		 34 -8.549411766355357 35 -10.016911208589649 36 -10.605011971415854 37 -10.334708301253277
		 38 -9.5886942007781339 39 -8.4776724048830694 40 -7.7979147651334833 41 -5.34325615332091
		 42 -0.72672123643779085 43 0.24114911883306508 44 0.55160365803334332 45 0.16895090816597963
		 46 0.11212858542226593 47 0.12459037136089908 48 0.12781631994423365 49 0.072597968115334213
		 50 -0.063146780721306445 51 -0.22044380896537583 52 -0.29323459412478547 53 -0.067684072220979552
		 54 -0.1112855635748089 55 -2.1094949723828433 56 -8.8747404300998447 57 -8.239041158765783
		 58 -9.0393391055525427 59 -10.127224137912322 60 -10.403261496846268 61 -10.118976360583661
		 62 -10.000898605857971 63 -9.9440497214833687 64 -10.026474097117937 65 -10.223513355718014
		 66 -10.224333630987944 67 -10.226193763161515 68 -10.226193763161515 69 -10.226193763161515;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ";
	rename -uid "DDC53CB4-4630-FECE-7606-FBB6AEAB6136";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 38.783171643564124 1 35.925032997301258
		 2 33.936751442891349 3 32.310520041952593 4 30.805734698963619 5 29.192743886277526
		 6 27.262233163659218 7 24.828359049068244 8 21.727768727318939 9 17.815788828522361
		 10 13.04459690009103 11 8.0162495415972561 12 3.1750337842190333 13 -1.8401293159970979
		 14 -7.5736468271289743 15 -14.917122014160062 16 -25.288040228406928 17 -42.793180707775981
		 18 -58.852437415282502 19 -58.867938668654716 20 -58.908406443215 21 -58.963699913362589
		 22 -59.02508740788636 23 -52.661479893288558 24 -41.842826189976918 25 -32.348841697610681
		 26 -25.230751007508378 27 -18.904581941430845 28 -13.63574348703359 29 -9.328108403599801
		 30 -5.4145975913914981 31 -3.4764523771519111 32 -3.331657645232958 33 -3.5159727820174842
		 34 -4.5954966384160532 35 -5.7818556924694517 36 -5.2909908993077943 37 -4.2181735648052197
		 38 -8.1333264489190995 39 -18.386888027302238 40 -31.291259118322877 41 -45.321287824663038
		 42 -55.693648912050669 43 -58.264194974197963 44 -59.234654999527308 45 -48.553237859791537
		 46 -38.848308951684132 47 -29.233530292892087 48 -18.779718510367736 49 -7.2808264118539947
		 50 4.501179795218083 51 15.430273133327958 52 25.315812823783745 53 35.746999875102112
		 54 37.391076121663737 55 22.119456904013497 56 6.9584132513036465 57 -4.4788041310870499
		 58 -3.6002416419349199 59 -1.4435579811701313 60 1.8238676602984254 61 5.0772387133525037
		 62 7.120066428925516 63 7.3615431298649128 64 7.0443525931036213 65 6.4458138819049688
		 66 6.4757370551041307 67 6.5400025739978744 68 6.5400025739978744 69 6.5400025739978744;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX";
	rename -uid "917AF633-44A7-8D79-28BE-C2935873B8BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 35.288262024721782 1 35.359063552442215
		 2 36.023333110067661 3 37.269147643773458 4 39.010492572269264 5 41.101149293958244
		 6 43.341661751722015 7 45.489122415615114 8 47.26842853009704 9 48.382211112405251
		 10 48.481748884749152 11 46.318384098331919 12 41.28266694258167 13 34.02069236917805
		 14 25.302434544696236 15 15.987859197664431 16 6.6940506150782335 17 -2.7509328418477299
		 18 -1.9765724849544697 19 -1.9434002758227311 20 -1.8471195881570854 21 -1.6876818660264683
		 22 -1.4723178124560423 23 -2.2381411394357724 24 -2.3162270525523541 25 -2.634655772338502
		 26 -3.0224785822983549 27 -3.572987654074717 28 -4.1135748590130516 29 -4.4579255168214909
		 30 -5.1388758642502479 31 -6.6242140609487157 32 -8.6933230899516456 33 -8.2274656690134744
		 34 -7.9790661194910291 35 -9.3794271131241818 36 -10.423140659433702 37 -9.6625090174162516
		 38 -7.7581574722494411 39 -5.6459012352984272 40 -4.0387957557069987 41 -2.0193526100836285
		 42 -0.17381490195163077 43 -0.76650089630135609 44 -1.3957327095494412 45 -3.1581064832043837
		 46 -3.7536083614512856 47 -4.242898580913713 48 -4.7426832738777618 49 -5.3641867769619695
		 50 -6.1342286849612888 51 -7.0320504766875418 52 -7.9556641979520952 53 -8.7182469389685906
		 54 -8.5369283309049919 55 -8.4589048294135711 56 -10.329481370184249 57 -8.7723280806443782
		 58 -8.7565041557886882 59 -9.0151124326914509 60 -9.1801755291749245 61 -9.3449918352209504
		 62 -9.6323415218767661 63 -9.8815984999097246 64 -9.8914984150080247 65 -9.9245379642993701
		 66 -9.9927262424823606 67 -10.077867179909758 68 -10.077867179909758 69 -10.077867179909758;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY";
	rename -uid "6FC00F18-4C5B-B541-BD52-4384A044276A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -3.3392151620649058 1 -3.4012678775650507
		 2 -3.3111959829995903 3 -3.1471993871211956 4 -2.9375455071368579 5 -2.7215093390485858
		 6 -2.5500872220790662 7 -2.4819848896895831 8 -2.5760679465175165 9 -2.882431133599844
		 10 -3.4393066757042887 11 -4.3875965901865666 12 -5.7592176338707235 13 -7.4004752288977418
		 14 -9.1586051729162872 15 -10.978151597713055 16 -13.076172730988219 17 -16.463588517508416
		 18 -18.887313780939024 19 -18.955730974959632 20 -19.143675869504747 21 -19.429034343778618
		 22 -19.780910181090231 23 -18.949048182986974 24 -16.988635566130096 25 -15.409352756385918
		 26 -14.223197965052792 27 -13.081970548845216 28 -12.240014495086877 29 -11.899037121241946
		 30 -11.348655066471096 31 -10.314906408075423 32 -8.5604859743043846 33 -8.2727258769128369
		 34 -8.0915479555863978 35 -7.4097938798758634 36 -8.0801685158050898 37 -9.2874408116914502
		 38 -9.5299500611524834 39 -9.5548597681431691 40 -10.105527663162897 41 -12.272355972314028
		 42 -16.010313518339824 43 -17.866322235290113 44 -19.531864469985464 45 -19.23096502256028
		 46 -19.357225966300227 47 -19.725261316948977 48 -20.045258506381881 49 -20.108616383888037
		 50 -19.768997364403678 51 -19.080645181742508 52 -17.971156244242501 53 -15.669610860766298
		 54 -12.897762345306075 55 -12.096392543860524 56 -8.9374284896180338 57 -9.5618283053608337
		 58 -9.0373350790082068 59 -8.4227355036933211 60 -8.1425186909043816 61 -8.1165976525796228
		 62 -8.0907773146144848 63 -8.0822125620897083 64 -8.228502370347238 65 -8.2615988025685176
		 66 -8.1704318516804477 67 -8.0158242778166553 68 -8.0158242778166553 69 -8.0158242778166553;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ";
	rename -uid "F0570338-427D-5114-DAB2-36BDD5585944";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -38.176574379638986 1 -36.708858572443233
		 2 -36.063097041303692 3 -35.823709419892069 4 -35.758840202209051 5 -35.637501269449452
		 6 -35.24290612603459 7 -34.382982965863405 8 -32.897270010590582 9 -30.658092170444966
		 10 -27.48423576957936 11 -23.787152856056196 12 -19.981664679784878 13 -15.883629034975412
		 14 -11.280396704063651 15 -5.8418382656211314 16 1.3727903816522553 17 12.976670977738126
		 18 22.376245318853805 19 22.372853446719581 20 22.348512785012243 21 22.273522560132953
		 22 22.128780642608849 23 18.682034009607218 24 12.615476783203803 25 7.0322845849024365
		 26 2.5023026097701306 27 -1.5853615971624648 28 -5.0010626379662693 29 -7.811371703525813
		 30 -10.639642380425734 31 -8.8604312673442767 32 -1.2942939085093568 33 5.4306742143157436
		 34 8.7713718753801668 35 1.5506462633829619 36 -16.827083843220947 37 -37.121474034558183
		 38 -45.316816612342009 39 -39.28944512892113 40 -28.051763995038012 41 -13.725710430168389
		 42 -0.013081394655952004 43 11.441924977015361 44 22.381245840729711 45 26.973798567501753
		 46 31.11999032396395 47 34.154708099737789 48 35.54331223570675 49 35.009373270892439
		 50 32.361662008782368 51 27.629713622869932 52 21.299127621055877 53 15.204972636641363
		 54 15.357100058306687 55 17.120450939240989 56 17.155374441592606 57 12.226180876446158
		 58 17.596214225369305 59 22.596581603897807 60 26.290376176987408 61 28.901192433482063
		 62 30.298523281427897 63 31.923164444275525 64 31.536025159894688 65 31.257121782365573
		 66 31.120826163683063 67 31.192032036967767 68 31.192032036967767 69 31.192032036967767;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAX";
	rename -uid "BBBB49B8-454D-E3E3-9E60-19B1DB5CD5F2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.34814499249625003 1 0.34927071632126594
		 2 0.36919453589819462 3 0.40359428579426165 4 0.44810086887304346 5 0.49867522662076569
		 6 0.55185460423640365 7 0.60510408337473365 8 0.65652962715950869 9 0.70509662777678739
		 10 0.74990161010020628 11 0.78972778219820183 12 0.82524613122118895 13 0.85794545468064665
		 14 0.88682898104083185 15 0.91093513769936241 16 0.9293371089501048 17 0.94109249243732296
		 18 0.98495515953700796 19 1.0836172463540286 20 1.2090624878714527 21 1.3239584025331248
		 22 1.3855462718390137 23 1.4040786030710193 24 1.4194994160428054 25 1.4317775218740267
		 26 1.4410817169371437 27 1.447432625573944 28 1.4509418041857067 29 1.4516784553038775
		 30 1.4497163204590315 31 1.4451347342848468 32 1.4380087934486503 33 1.4284074358301377
		 34 1.3854343520941244 35 1.2892807970043472 36 1.1567105967646416 37 0.97390089319195883
		 38 0.73496442296524211 39 0.46579206084094821 40 0.19459999958457455 41 0.023259499938360122
		 42 -0.14593000063873787 43 -0.30977500626922799 44 -0.19013793021193146 45 -0.08703227841864522
		 46 -0.018548550490119581 47 0.0072496748905625128 48 -0.015059522375569553 49 -0.076982823375346635
		 50 -0.15531234220758172 51 -0.19932441696769107 52 -0.24586175842392685 53 -0.28645908227502925
		 54 -0.28646149303455659 55 -0.28647405461246545 56 -0.2864728961920211 57 -0.2864732941922768
		 58 -0.28647690427245259 59 -0.286474519745338 60 -0.28647289619202049 61 -0.28646994175778945
		 62 -0.28647451974534405 63 -0.28648175552345567 64 -0.28646480356603388 65 -0.28647339654020515
		 66 -0.28647405461246656 67 -0.28647690427244921 68 -0.28647690427244921 69 -0.28647690427244921;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAY";
	rename -uid "A624FEA3-49B3-E3F2-967A-63BCC7CCB0C2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -3.2935192271352811 1 -3.2684824347474741
		 2 -3.1937041044674994 3 -3.0812327840560156 4 -2.9428324367680712 5 -2.7899658970738317
		 6 -2.6335675648605794 7 -2.4832507005571647 8 -2.3482767711375776 9 -2.236899050882589
		 10 -2.1578322823673934 11 -2.1202012715977925 12 -2.1068164633981445 13 -2.0940008836879045
		 14 -2.0823433855716527 15 -2.0722649050347002 16 -2.0645311018760442 17 -2.0594693449089383
		 18 -2.051613926738292 19 -2.0299451069008563 20 -1.9896892108155664 21 -1.9405796497479331
		 22 -1.9079774583380393 23 -1.8949173798178067 24 -1.8839038676500648 25 -1.8751085300869006
		 26 -1.8684119935821222 27 -1.8638263550724998 28 -1.8612297986771424 29 -1.8607097535678689
		 30 -1.8621292598105086 31 -1.8654540212135065 32 -1.8705943968718066 33 -1.8775377260692596
		 34 -1.9053495586439395 35 -1.9634723163375989 36 -2.0363766006708284 37 -2.1280320349316333
		 38 -2.2343899300496983 39 -2.3188016648673413 40 -2.3530041185493573 41 -2.3293676316308707
		 42 -2.2748963114526521 43 -2.2034257478996646 44 -2.2165480563022348 45 -2.2265098536907915
		 46 -2.2340744791221199 47 -2.2403621509827127 48 -2.2451628841125841 49 -2.2472316389498825
		 50 -2.2457727154812339 51 -2.2404760468082947 52 -2.2339101275648416 53 -2.2272355397094339
		 54 -2.2272188246292117 55 -2.2272367700263573 56 -2.2272353211376035 57 -2.2272369194399908
		 58 -2.2272385895867499 59 -2.2272350253737843 60 -2.2272353211376221 61 -2.227237533144991
		 62 -2.2272350253737776 63 -2.2272396649064246 64 -2.2272378170481604 65 -2.2272362196940163
		 66 -2.2272367700263511 67 -2.2272385895867473 68 -2.2272385895867473 69 -2.2272385895867473;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ";
	rename -uid "8342B1AE-4101-97B6-51C0-0897DC2391BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -4.3876150830657261 1 -4.4321310434736008
		 2 -4.63995148408332 3 -4.9812097020946249 4 -5.4258407588042692 5 -5.9437822641062237
		 6 -6.5045195434092893 7 -7.077677276017357 8 -7.6324118355617667 9 -8.1378800348903155
		 10 -8.5633918025913935 11 -8.8783693984503671 12 -9.1203477719224395 13 -9.3431230425574743
		 14 -9.5399466127414101 15 -9.7043180407791727 16 -9.8298613003083251 17 -9.9099607446657227
		 18 -10.212854113292765 19 -10.874829673025932 20 -11.680693656038745 21 -12.387932309492095
		 22 -12.755563677470686 23 -12.863870415790233 24 -12.953787291972782 25 -13.025545142605772
		 26 -13.079824023198501 27 -13.117027105779437 28 -13.137498127038519 29 -13.141803174075383
		 30 -13.130357550498715 31 -13.103589572136997 32 -13.061913566729064 33 -13.005855836060178
		 34 -12.718200029106733 35 -12.060883360390303 36 -11.152488112920363 37 -9.9280754030954004
		 38 -8.3621660511947375 39 -6.633716969136624 40 -4.9226605858640937 41 -3.8984451227459265
		 42 -2.8149992937833397 43 -1.6773288030327955 44 -2.4732414909439191 45 -3.145138945448839
		 46 -3.5758607686564172 47 -3.7211146003494942 48 -3.5558743921225746 49 -3.1394286897993942
		 50 -2.6196129238083645 51 -2.3388982855014047 52 -2.0400346990922609 53 -1.7774527790232757
		 54 -1.7774432094499202 55 -1.7774334868893147 56 -1.7774335667178629 57 -1.7774334792747246
		 58 -1.7774266242308903 59 -1.7774339973895188 60 -1.7774335667178631 61 -1.7774326287783351
		 62 -1.7774339973894842 63 -1.7774344308859962 64 -1.7774327387051103 65 -1.7774406704467571
		 66 -1.7774334868893009 67 -1.7774266242308743 68 -1.7774266242308743 69 -1.7774266242308743;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX";
	rename -uid "6D1059D6-471F-A38E-B0BE-3D829BCC5A9C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.8146118857303151 1 9.1377158602276456
		 2 16.074633102914188 3 22.62484450129093 4 26.961752010117873 5 27.988569250816084
		 6 25.90123489060263 7 12.400036029347355 8 -8.0745275386312674 9 -31.557232711293288
		 10 -46.322326874593521 11 -48.555680315117037 12 -40.76927890980879 13 -31.69547783148688
		 14 -24.350639160382137 15 -19.201817248395525 16 -15.549715792021722 17 -12.30218229904475
		 18 -9.21964158897649 19 -5.3871127777773742 20 -5.3981249947036716 21 -8.1518219052464094
		 22 -12.475910534619066 23 -17.138424695372013 24 -20.303226565152386 25 -21.924529972407516
		 26 -22.208181455136103 27 -21.889731362872087 28 -21.814368641902369 29 -21.825904347167082
		 30 -21.801137967619759 31 -21.767490433451925 32 -21.833752553494893 33 -23.766689999360466
		 34 -30.627464943437321 35 -42.162584943476197 36 -54.798070977967541 37 -68.50823431867677
		 38 -83.94057455492657 39 -80.135953476799926 40 -72.77476111169436 41 -61.864720448355712
		 42 -66.177798593165363 43 -72.209774309341299 44 -65.481605645280695 45 -62.780360357253237
		 46 -63.858796797507772 47 -67.669799216419349 48 -73.168861552537194 49 -79.404691896720024
		 50 -78.394059119924165 51 -75.644225575285901 52 -75.455667159260514 53 -76.943116712765658
		 54 -78.180490392331407 55 -80.11425806120215 56 -81.951292099449603 57 -83.180565745582825
		 58 -82.175034708402407 59 -81.225450440046373 60 -81.225436799707538 61 -81.225444164247449
		 62 -81.225440367243849 63 -81.225413658321543 64 -81.225421211186173 65 -81.225422614645879
		 66 -81.225423554651229 67 -81.225397525900291 68 -81.225397525900291 69 -81.225397525900291;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY";
	rename -uid "AFA94B86-4871-7295-5FA5-D09DDF8DA08C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 40.357897416574289 1 40.471621391997857
		 2 42.535352004868997 3 46.683493098473505 4 52.284388575085892 5 57.319842037837084
		 6 59.302717077585086 7 59.91518078750768 8 60.283862876557457 9 56.667537742039102
		 10 49.572974377395873 11 40.69753370178104 12 32.563150277317462 13 25.91339062916871
		 14 20.16114535229956 15 14.772241052331051 16 8.509967320983467 17 1.5913307123272784
		 18 -1.1811081144509792 19 -2.9805792814150838 20 -3.192837008065843 21 -1.9435901918476786
		 22 -2.4304923436113484 23 -3.3706548926811175 24 -1.3918160160566933 25 0.23688316182134625
		 26 1.134126931844109 27 1.9329795682845838 28 0.92900955303028376 29 0.49444743790879125
		 30 3.8829091627323966 31 10.663549923352345 32 19.176787761790351 33 26.630573314974882
		 34 28.846631238247607 35 23.769061253068898 36 13.498731666540158 37 -1.5526327784979423
		 38 -22.803819046630561 39 -33.830270980196801 40 -40.60748655387156 41 -34.048332059425853
		 42 -29.866777780372331 43 -29.875818289047324 44 -26.910400677156112 45 -23.388899155435155
		 46 -20.227803778190452 47 -18.312485316540773 48 -18.465451084740476 49 -21.173979953608168
		 50 -26.086628836910172 51 -29.077013324342655 52 -31.634509322266126 53 -33.516910632313696
		 54 -33.740542009294614 55 -33.930665501693142 56 -34.2474020321567 57 -34.736949971288134
		 58 -35.570907691176899 59 -36.409255212726677 60 -36.409273164444407 61 -36.40925798008238
		 62 -36.409258987830299 63 -36.409283619185594 64 -36.40926342923715 65 -36.409267497532952
		 66 -36.409263428372377 67 -36.40929402147168 68 -36.40929402147168 69 -36.40929402147168;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ";
	rename -uid "3A952568-4088-1154-42EC-FF87E8F3F04F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.3818591472264554 1 -2.4356683634987233
		 2 3.0360250882371003 3 6.8970896474268732 4 9.08742565072329 5 10.064028740676516
		 6 10.812002688680147 7 3.915248433187215 8 -8.5361714855638571 9 -24.178718026858618
		 10 -32.165221696923034 11 -31.22123935230767 12 -24.881123152404651 13 -20.766727862593118
		 14 -19.07282627679507 15 -21.326417426602788 16 -27.489553762823206 17 -37.826151128877697
		 18 -43.735468907648269 19 -52.511206089327139 20 -48.706723012878115 21 -36.797231604828603
		 22 -22.820378146954532 23 -11.12432990784345 24 -3.6406276227691703 25 -2.1256163711208673
		 26 -5.0888966401363724 27 -8.9102232960417158 28 -11.895832852246189 29 -10.69139219942301
		 30 -5.6164396217134582 31 0.32458662594499765 32 5.4844315425310262 33 8.0889191487403078
		 34 6.6679334331145617 35 2.4746668722794345 36 0.11076856076992078 37 0.23087102968108339
		 38 2.2556264357185287 39 10.515536892223391 40 15.16734618030101 41 6.326910787047483
		 42 13.659617175026066 43 24.083667176130785 44 18.668849112407045 45 12.987181229161651
		 46 8.1945595027091471 47 4.4039902252095118 48 2.0826121134024618 49 2.0641391398236468
		 50 7.0682801806897313 51 9.1927115948398512 52 14.253315940961183 53 18.408858906912847
		 54 18.851025363118648 55 18.040348237926899 56 16.004198190473129 57 13.346160450421671
		 58 11.578565173258532 59 9.9063786393559834 60 9.9063652970972012 61 9.906367119617979
		 62 9.9063621627202068 63 9.9063711326554671 64 9.9063607283524888 65 9.9063655431027087
		 66 9.9063636328950455 67 9.906347543220944 68 9.906347543220944 69 9.906347543220944;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX";
	rename -uid "D4504E42-4AC1-5F16-7179-AB9D97DC5AAF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -4.528912286263389 1 -5.7507904405820396
		 2 -7.1081335086476578 3 -8.1146098814899617 4 -8.5626681038102266 5 -8.6358117321691097
		 6 -8.7567306010391714 7 -8.3520434616667067 8 -7.6798592969587078 9 -6.9704200196767943
		 10 -6.296226734362067 11 -5.9720504708981768 12 -6.1352233730159913 13 -6.1115245441022665
		 14 -6.0248124083289403 15 -5.6483485003967671 16 -4.8008559330280853 17 -3.2254145667016365
		 18 -3.226569394651686 19 -2.2241761650437435 20 -2.0552984779876846 21 -2.718434800523577
		 22 -3.8291308642689756 23 -4.8981820020473883 24 -5.4991708539085744 25 -5.5976835973847487
		 26 -5.2687667659915771 27 -4.7186110332002906 28 -4.1439221883034083 29 -4.4785918414202959
		 30 -5.8152668684378703 31 -7.1331960769427853 32 -7.6572211094005658 33 -7.0940133016276148
		 34 -6.1422924893280273 35 -5.6896070327247728 36 -6.1165374677114714 37 -6.6945194299520185
		 38 -6.0282048017394336 39 -4.7964955172872177 40 -3.5746997321687117 41 -2.8252837635809382
		 42 -3.3414958047732486 43 -3.2922181713730416 44 -3.6907760078007112 45 -3.9470540205701639
		 46 -4.063382730070936 47 -4.0562188396393095 48 -3.938249377241124 49 -3.6939467826670147
		 50 -3.3353675088215784 51 -2.9931108148338921 52 -2.9393115997614006 53 -2.8764165813761244
		 54 -2.9278222288424449 55 -2.9332269913741471 56 -2.8747878005278147 57 -2.7617074673843525
		 58 -2.6155464829117028 59 -2.4674999546884435 60 -2.4674959717105382 61 -2.4674957551255927
		 62 -2.4674982388903413 63 -2.4675040989014736 64 -2.4674994013646705 65 -2.4674979944523892
		 66 -2.46749014944184 67 -2.4674910601797158 68 -2.4674910601797158 69 -2.4674910601797158;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY";
	rename -uid "5DDA1C03-474A-D464-048B-37B18117146A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -7.3941147490330472 1 -7.8954186109044304
		 2 -8.2074340421503038 3 -8.289867624437985 4 -8.2873660371661053 5 -8.2846542311240992
		 6 -8.2787723363717305 7 -8.2915419042044523 8 -8.2692904371561582 9 -8.186513720688918
		 10 -8.0496533251327484 11 -7.9628149827629615 12 -8.0082888758360067 13 -8.0018959679756101
		 14 -7.9779290093517368 15 -7.8619011891678534 16 -7.5257484536993813 17 -6.572503797548376
		 18 -6.5733792237109556 19 -5.6619603209734182 20 -5.4752145206238376 21 -6.1490150738159715
		 22 -6.9954994687212553 23 -7.5699264551213652 24 -7.810439398818807 25 -7.8447715385686978
		 26 -7.724634037840441 27 -7.4872120142800336 28 -7.186024353939267 29 -7.3683773652536422
		 30 -7.915774092695119 31 -8.2109584733238794 32 -8.2675865497871968 33 -8.2053849723952261
		 34 -8.0101635675422607 35 -7.8755534085448282 36 -8.0032548079185322 37 -8.1375039944557788
		 38 -7.9788930353653162 39 -7.5237210358513051 40 -6.8270033186285728 41 -6.2441338732755378
		 42 -6.6602269231722513 43 -6.6234039455190716 44 -6.9055906062690458 45 -7.0691389764665145
		 46 -7.1390902810145542 47 -7.1348602982622458 48 -7.0637473451160773 49 -6.9076768143906584
		 50 -6.655691545625916 51 -6.3870236501195761 52 -6.3420535174717827 53 -6.2885097029944301
		 54 -6.3323756127240873 55 -6.336957640930188 56 -6.2870930058415979 57 -6.187998580818511
		 58 -6.0542674823421976 59 -5.9120239544550506 60 -5.9120169411449783 61 -5.9120213115064786
		 62 -5.9120204312400899 63 -5.912014566975702 64 -5.9120157928410935 65 -5.9120090225384381
		 66 -5.9120157314560835 67 -5.9120038442125642 68 -5.9120038442125642 69 -5.9120038442125642;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ";
	rename -uid "7F1732B1-4A8D-0C39-64DB-76BDEDD7FE6D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 62.930986281906137 1 72.096402634499128
		 2 81.765066255548618 3 88.771523307247207 4 91.87880064112899 5 92.386428658899391
		 6 93.226062770913998 7 90.418077812636014 8 85.753327477192471 9 80.799043992245018
		 10 76.0272889663852 11 73.700335982400759 12 74.874748769775451 13 74.70450405800112
		 14 74.080697241957139 15 71.349123250622739 16 65.025046428702765 17 52.240470810420938
		 18 52.250449920746718 19 42.865882133472837 20 41.125346128586571 21 47.666663612039144
		 22 57.348008700835386 23 65.765961406292519 24 70.254851952118727 25 70.978222038465105
		 26 68.550317868216112 27 64.395590395805542 28 59.897593484175431 29 62.539102830482037
		 30 72.565158655836356 31 81.94048019912708 32 85.595766591986958 33 81.66598349315548
		 34 74.925414065388395 35 71.650432078397685 36 74.740570436718329 37 78.855751107565766
		 38 74.10535135177318 39 64.991808150242719 40 55.233698832221009 41 48.656597662691986
		 42 53.247868712654792 43 52.822052396819352 44 56.204609199833712 45 58.310979187853562
		 46 59.251636085270412 47 59.193957715511623 48 58.239513337607974 49 56.230969351129481
		 50 53.195171538064329 51 50.182268131903299 52 49.696890590479114 53 49.125245707908768
		 54 49.59294126726747 55 49.641992023532318 56 49.110385676919506 57 48.069718305255684
		 58 46.698965311529484 59 45.278679820831698 60 45.278669498884447 61 45.278675750878676
		 62 45.278697151209016 63 45.278671159636559 64 45.278670115855846 65 45.278674233960615
		 66 45.278678836978941 67 45.278658779204079 68 45.278658779204079 69 45.278658779204079;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX";
	rename -uid "BF186436-4219-6768-CA59-8DAE4ECBBC5A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -9.7418129911441298 1 -9.7741594443129625
		 2 -8.7305512268085916 3 -6.6743113136893832 4 -4.1459128163065975 5 -1.8759710089887738
		 6 -0.3444150977951892 7 1.8866945799736619 8 6.5517919479345847 9 10.931770712782395
		 10 13.343496153901537 11 10.078681279901932 12 1.0211415622361275 13 -8.1564858445173929
		 14 -15.931664271132208 15 -22.228931263771457 16 -27.79316658738621 17 -32.833188626102341
		 18 -35.249760545172734 19 -38.200966963385483 20 -39.552525878416041 21 -38.621382822800868
		 22 -38.397699283067602 23 -38.58437272260938 24 -36.294639337168235 25 -32.556880848810891
		 26 -27.986285565909991 27 -23.280383693545257 28 -19.755117076728567 29 -16.504115226329198
		 30 -11.405294633700493 31 -3.9036715786461071 32 5.4178699227984062 33 14.566262001146317
		 34 20.102739333100299 35 21.093569527336097 36 18.908172466673165 37 14.938714161266931
		 38 12.382922166195137 39 -8.4914477471729004 40 -36.273641314315178 41 -60.199980026451662
		 42 -70.925551814052497 43 -71.066729682636847 44 -67.036623221845034 45 -59.761093374525714
		 46 -50.385175779359649 47 -39.789367766448898 48 -26.277406904989324 49 -7.9772102896949217
		 50 -2.0970056109061046 51 3.7624589960235979 52 7.9401853474506039 53 11.521267352901342
		 54 15.18662427377752 55 16.83391709269711 56 17.33731368717957 57 17.022941077628598
		 58 13.589058031928191 59 12.552125396089798 60 13.928976127218899 61 17.293023315100935
		 62 21.487307892302422 63 25.317147900498696 64 25.317154235152437 65 25.317135956665254
		 66 25.317151538046744 67 25.317126815249395 68 25.317126815249395 69 25.317126815249395;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY";
	rename -uid "60011294-42E1-5662-53B3-889AD57B45E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 18.577658783547861 1 18.487274942583181
		 2 17.016884684632931 3 14.447690889086221 4 10.963331683694468 5 7.4033400062456725
		 6 5.3638495530884747 7 2.1773940864750005 8 -1.2835632499606373 9 -4.5832671716099931
		 10 -7.2013025300915601 11 -7.7591681198443325 12 -6.2716059281458518 13 -4.1133423760600278
		 14 -2.5707432284314296 15 -2.0793427960643132 16 -2.9433922202961367 17 -5.3110940621758544
		 18 -6.2477497985490222 19 -9.2348063523142123 20 -11.146735349483253 21 -10.854845260845357
		 22 -10.695199219390883 23 -10.340910896338277 24 -8.2512155300280945 25 -5.1076472237169135
		 26 -1.5375262436182491 27 1.8437963075275992 28 4.5024508802111445 29 8.4084424993239555
		 30 14.866849137585175 31 22.627135830563578 32 30.303765637237248 33 36.208782936315068
		 34 39.827723248184427 35 41.675196940418765 36 41.866623534758546 37 39.969118410735554
		 38 36.810435321620638 39 41.045758336147294 40 44.706103296819684 41 51.368078510610125
		 42 43.409796951358345 43 33.817079280323718 44 33.19270396339418 45 35.539950129975438
		 46 39.772249476093442 47 45.015941423768211 48 50.808447252501338 49 54.846468072273922
		 50 52.365724205197331 51 51.805591259610225 52 49.243575742094656 53 47.116036818905258
		 54 46.227210755531829 55 45.672129680271141 56 45.365368683207947 57 45.367626883727553
		 58 45.903712218003079 59 46.598687378153599 60 46.757117053672083 61 47.126021167963103
		 62 47.548792358938854 63 47.897873148375581 64 47.897859637563784 65 47.897872725017081
		 66 47.897873878042027 67 47.897877518307233 68 47.897877518307233 69 47.897877518307233;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ";
	rename -uid "CA670522-46CA-7071-EEF3-038607D02BA0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -12.363667949500918 1 -15.475358818518929
		 2 -18.379085157915156 3 -20.728142542918807 4 -22.359635292652786 5 -23.336045250130507
		 6 -24.084180701552828 7 -22.377106689950669 8 -18.774973962242502 9 -16.446908500310141
		 10 -13.884680485201182 11 -12.577459865039639 12 -13.487857623653561 13 -14.545976228758793
		 14 -15.319448636936309 15 -15.292343219034864 16 -13.441015974822967 17 -7.6193546965300341
		 18 -9.010194913474896 19 -3.6937957824711107 20 -0.95348500986277807 21 -1.8070946901460032
		 22 -4.5903132530191471 23 -7.881697869096528 24 -9.3364519674796327 25 -9.3877067745238936
		 26 -7.9128553448909011 27 -4.8684611004923521 28 -1.1262825869180675 29 -1.9674108891101916
		 30 -7.4850426508062702 31 -11.286617517460972 32 -9.1109083956406511 33 -1.2722229536726393
		 34 4.4693534761031737 35 1.2141575705949528 36 -10.832519536073139 37 -25.673583274961352
		 38 -33.982102569840215 39 -39.039111575177088 40 -49.002563998748677 41 -60.245201890864038
		 42 -76.443961547065584 43 -81.54617345543555 44 -86.51268495033942 45 -88.865436534118004
		 46 -88.691355582762824 47 -85.933215323931321 48 -78.124294432993807 49 -63.103625742717824
		 50 -54.660354451705032 51 -44.461832125370393 52 -36.827315338356733 53 -30.469648082075469
		 54 -26.977665870080163 55 -25.472898417925091 56 -23.27120315757865 57 -20.897818632456389
		 58 -20.751854768136027 59 -20.182705282155528 60 -19.956700702434254 61 -19.382555799667191
		 62 -18.625243076997872 63 -17.896917419084073 64 -17.89691459090853 65 -17.896943193050749
		 66 -17.896917492769209 67 -17.896940837036432 68 -17.896940837036432 69 -17.896940837036432;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX";
	rename -uid "F4BFDC81-4819-BAF2-3F56-7690A858CB04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 19.074612844339356 1 18.672425522492439
		 2 17.915986562968637 3 16.986006310135352 4 16.084478620244475 5 15.448153478309759
		 6 15.340193115136707 7 93.815937193968622 8 94.769587839986031 9 93.482589305436321
		 10 90.25717788796284 11 85.805731694820949 12 81.099473894966891 13 76.928360606167317
		 14 73.619997011837341 15 71.202371789953204 16 69.524030501126404 17 68.338296046563201
		 18 69.61944026844148 19 72.637522338071378 20 76.720068821125324 21 80.625060099127495
		 22 82.746432047014835 23 83.669394734443088 24 85.073444239597308 25 87.275208592953561
		 26 90.775969072441654 27 96.522894182298856 28 106.5577746406601 29 123.86956498898031
		 30 146.77202200793189 31 165.01844622854401 32 173.38581580208387 33 174.36568592916012
		 34 169.32995929166384 35 159.34945318312944 36 146.94426084265362 37 133.64294818188006
		 38 120.77452398460517 39 111.63668167716111 40 103.41881118325526 41 98.393335880625301
		 42 94.150484234870831 43 91.798988547109744 44 102.20007749017009 45 110.46329248050766
		 46 123.33528532661228 47 130.94620807864189 48 133.79867633203904 49 131.0232526184997
		 50 123.5952943770365 51 113.54740603386959 52 102.82613878378234 53 94.040256598687961
		 54 90.389615704373739 55 95.602649429931191 56 103.4259428529413 57 112.51124694859436
		 58 120.93370868176369 59 126.41944403883178 60 128.75919625213879 61 129.22028418009216
		 62 130.08059119311474 63 130.08060736530999 64 130.08060000862545 65 130.08057207255166
		 66 130.08059299543436 67 130.08070262564246 68 130.08070262564246 69 130.08070262564246;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY";
	rename -uid "4975ED2F-4989-366F-3770-B28235725586";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 13.140739198945679 1 12.908332479633543
		 2 12.44920845964203 3 11.899834276944413 4 11.362644302538937 5 10.889662569154043
		 6 10.498810252548221 7 -6.2450899300272553 8 -14.096622726348851 9 -18.341498395753625
		 10 -19.894359262501879 11 -19.277337615758487 12 -17.911140393032817 13 -17.46564093544135
		 14 -18.606890611735878 15 -21.34611259489531 16 -25.299147808039972 17 -30.158147720064445
		 18 -30.685205251101735 19 -34.347827603707366 20 -38.363485116447244 21 -41.074666334327915
		 22 -40.694259271380751 23 -37.532668012977929 24 -33.264859637036643 25 -27.856634068991792
		 26 -21.256160580055887 27 -13.213734954653056 28 -4.532840605236478 29 -0.26916432296491166
		 30 1.4157025668318892 31 6.2047456365836773 32 11.365907620127352 33 15.149993860356005
		 34 16.56976478197193 35 15.416695045930851 36 12.892251114836105 37 11.158936984155662
		 38 11.969706504690352 39 14.499824519019867 40 18.004896533922967 41 23.009451571810875
		 42 28.128253661567726 43 30.812533620384119 44 37.730139238292551 45 45.949125110587012
		 46 51.550361956942211 47 54.992723735431596 48 56.110071062623994 49 54.735662175268097
		 50 51.996327958997632 51 50.662005561048268 52 50.992333303092195 53 53.053406108550952
		 54 56.538184573011542 55 57.694052100032941 56 59.382548718572131 57 62.104899664866345
		 58 65.724033688034709 59 69.481370914191885 60 72.626529181825816 61 74.997540425237332
		 62 76.91062359333867 63 76.910634587622582 64 76.910638452188195 65 76.910616226737673
		 66 76.910652857545074 67 76.910650728754902 68 76.910650728754902 69 76.910650728754902;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ";
	rename -uid "05C491C9-412A-1936-AF2C-86930D0B83BB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 54.153052505682062 1 54.238795069660632
		 2 54.511653358151918 3 54.884502998772497 4 55.275659097917845 5 55.601070520156313
		 6 55.766822515148846 7 46.941961122948825 8 47.496361371356947 9 49.475989015903565
		 10 52.535147292162904 11 56.142714712779018 12 59.57465704516661 13 62.430806010734692
		 14 64.799925733829014 15 66.716016900237804 16 67.985569963066879 17 68.253972595597659
		 18 67.691811200622666 19 65.398179579001962 20 62.729296475398861 21 60.881420126420025
		 22 61.593705743817523 23 64.140567289847425 24 66.605399380342035 25 68.780231418904364
		 26 70.593721510683238 27 72.258787288329373 28 74.336393741418817 29 74.801852734541669
		 30 69.953548952543088 31 64.320077290530818 32 59.443603321832583 33 55.033160554906416
		 34 51.988107572687973 35 50.986063532493183 36 51.820623598747275 37 54.659100569878937
		 38 58.707915124454992 39 58.104152012432806 40 55.727712119794759 41 48.012423355913214
		 42 34.898937822669211 43 14.59156915713603 44 -6.8747155920045282 45 -21.028267609281809
		 46 -25.019739521312857 47 -24.268657840167293 48 -21.40314057226642 49 -17.39685234208374
		 50 -11.866889212637984 51 -5.0826698352143218 52 0.96675590727986527 53 4.2141189196558271
		 54 5.0153572498224026 55 6.836566059290818 56 6.7933856754315727 57 4.8904569734003136
		 58 1.6520798848165741 59 -2.3989628827611313 60 -5.9056064354123778 61 -6.7883083400909907
		 62 -4.8956447630218047 63 -4.8956155371236916 64 -4.8956402609969603 65 -4.8956660858733194
		 66 -4.895650761667306 67 -4.8955465410828412 68 -4.8955465410828412 69 -4.8955465410828412;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX";
	rename -uid "C417ACC6-4D2A-F153-6D91-C195751368F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -3.878416617209449 1 -4.2065704430161786
		 2 -5.2226306491347101 3 -6.8800245818964436 4 -8.646254107475114 5 -9.4885789241913727
		 6 -9.4887850780962619 7 -1.1962191218258977 8 -1.8537385069970731 9 -2.072946034452833
		 10 -1.9710601484805568 11 -1.6719152139105566 12 -1.3898659274095895 13 -1.3262093422062753
		 14 -1.5832630542132649 15 -2.2322708655554 16 -3.3086653414694629 17 -4.8108730399538819
		 18 -4.7523605030802489 19 -5.156648892717465 20 -5.5718263340098417 21 -5.7583858297747259
		 22 -5.4577032747008962 23 -4.7365463620002419 24 -3.8727811429000951 25 -2.9067794492078298
		 26 -1.8963596889998944 27 -0.90633320408306162 28 -0.21481908946294362 29 -0.13602993169790994
		 30 -0.60087005628024681 31 -1.3139184782376867 32 -2.1414219495362161 33 -2.9709103817526028
		 34 -3.5228559525179746 35 -3.7355650361695329 36 -3.781845929272885 37 -3.6243269775102021
		 38 -3.2844524931807189 39 -3.9307151785675187 40 -4.7883688223013339 41 -5.8014113429615968
		 42 -6.5377964013151555 43 -7.017155844572704 44 -6.0557888137983227 45 -4.6618976019831724
		 46 -4.6205283310747731 47 -4.7557201810487966 48 -4.9197958783545159 49 -5.0288777262537039
		 50 -4.9847319066044289 51 -4.5373877544466295 52 -4.0350098027592018 53 -3.5138709977428886
		 54 -2.8734605965875297 55 -2.8235653522846316 56 -2.7572615932817728 57 -2.6125688698512981
		 58 -2.3626065460692334 59 -1.9886171855280068 60 -1.5196094052569691 61 -1.0150565039927451
		 62 -0.58085234880333492 63 -0.58085232988536162 64 -0.58085688777351974 65 -0.58087207875017799
		 66 -0.5808697397500483 67 -0.58087212969812763 68 -0.58087212969812763 69 -0.58087212969812763;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY";
	rename -uid "C297D7F9-4D8D-51D2-C9A4-3382B69B9689";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -6.3465996068456523 1 -5.7027841293558073
		 2 -4.0710819846655646 3 -2.0130345315391098 4 -0.26584278409737483 5 0.45765692996418933
		 6 0.45302388071000643 7 -3.6412310005107047 8 -4.5666734658169847 9 -4.8235092973881599
		 10 -4.7067478441041564 11 -4.3364868202080196 12 -3.9427826620459956 13 -3.84677822793171
		 14 -4.2178856071052477 15 -4.9975340412998959 16 -5.9573192233303915 17 -6.8486892853568078
		 18 -6.8215713212038134 19 -6.9979439022017074 20 -7.1534192104436007 21 -7.2151854872418681
		 22 -7.1131930078150489 23 -6.8141439995736217 24 -6.343099722190062 25 -5.6376352102191278
		 26 -4.6182794163259686 27 -3.1275857665131914 28 -1.293490902218924 29 -0.94358494853687691
		 30 -2.4699086110028015 31 -3.827917109555957 32 -4.8994984581125314 33 -5.6913984344231947
		 34 -6.111903771522754 35 -6.2554741382226577 36 -6.2854459247228691 37 -6.1815539436510116
		 38 -5.9392401199065414 39 -6.3789811857492174 40 -6.8383453884901364 41 -7.2287791453766941
		 42 -7.4222788630898817 43 -7.5106338790205553 44 -7.303800803650133 45 -6.7785567576669346
		 46 -6.7584141889152995 47 -6.8231293648295415 48 -6.8977428320735559 49 -6.9449754639058128
		 50 -6.9260770457773173 51 -6.7171565344483417 52 -6.44193142218296 53 -6.1056301300716056
		 54 -5.6092452353316595 55 -5.5661704142863355 56 -5.5078190825652227 57 -5.3760148331884237
		 58 -5.1328505122932668 59 -4.7271989284698401 60 -4.1299312416302483 61 -3.3303917021878822
		 62 -2.421004538051752 63 -2.4210047031831752 64 -2.4210076669470135 65 -2.4209978453372001
		 66 -2.4210264494964 67 -2.4210168205676696 68 -2.4210168205676696 69 -2.4210168205676696;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ";
	rename -uid "2406409C-41B6-88D3-581C-AE9DBC4730C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 52.942246201577518 1 49.84584936987428
		 2 42.493927078529772 3 33.760958820962486 4 26.458579870025396 5 23.395325868584536
		 6 23.437756697541602 7 26.47919786219331 8 34.286041646867275 9 36.608871473812407
		 10 35.542818583483687 11 32.268860943157748 12 28.940403685967119 13 28.149293278769203
		 14 31.251121931434955 15 38.233072357865076 16 48.181445493143826 17 60.256525576696681
		 18 59.811212753467387 19 62.856993887638097 20 65.918827504375813 21 67.276082010849308
		 22 65.083085109634411 23 59.690660825821624 24 52.896319036348224 25 44.640684814671111
		 26 34.746381068887757 27 22.431288280428127 28 8.9750444592872665 29 6.5215686779941082
		 30 17.458953826889463 31 27.994362845961742 32 37.312852621546291 33 45.217475895694349
		 34 50.002927794092379 35 51.773106317162707 36 52.153545111300645 37 50.851882234032104
		 38 47.972936188393334 39 53.366452349255432 40 60.0854247744821 41 67.587491042271637
		 42 72.848213067564586 43 76.2155381923981 44 69.419241736176986 45 59.119655938356843
		 46 58.802151000024438 47 59.836737170608707 48 61.081350553180897 49 61.902162968883296
		 50 61.570391016514691 51 58.161268069532355 52 54.207187093540391 53 49.927388868408059
		 54 44.339174871630128 55 43.88508199340113 56 43.27627480874559 57 41.928018895704255
		 58 39.526193500181321 59 35.728262194823706 60 30.504925289795565 61 24.009802741795475
		 62 17.096905976417531 63 17.096911589949595 64 17.096915046695532 65 17.09690498780348
		 66 17.096892053714633 67 17.096878900150589 68 17.096878900150589 69 17.096878900150589;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX";
	rename -uid "20FF88AE-4386-44F0-5EAF-18A067E7BDB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 75.362715831892743 1 75.36266934292469
		 2 75.362714875272189 3 75.362698770551361 4 75.362773063438283 5 75.362685838430423
		 6 75.36271351982586 7 174.37505356953537 8 170.38213382652816 9 162.66186335929643
		 10 151.88701714268458 11 139.014713298131 12 125.25127607382915 13 111.89838082183697
		 14 100.07125649541554 15 90.527061765409528 16 83.723369443555953 17 79.966402980760606
		 18 78.751267833270916 19 80.225807402653416 20 83.489355574330943 21 88.375055111568656
		 22 94.76652285938917 23 102.74602068236732 24 112.48721651616756 25 124.09161792334395
		 26 137.83615051321161 27 154.41267094011897 28 175.55596007878711 29 204.1796411362028
		 30 239.36427373389151 31 270.94937775408312 32 292.6816465872277 33 306.34371182405226
		 34 312.8913100495775 35 313.22642196532598 36 310.15145474410429 37 305.72521162501704
		 38 301.14973645556108 39 300.00256930960785 40 300.78891889520025 41 307.95808113185115
		 42 321.24409953988027 43 342.46068604561191 44 369.08488567017423 45 388.32892331321403
		 46 400.83926580299652 47 406.29841243932276 48 406.87578917958405 49 402.15452634087279
		 50 392.13392533171378 51 378.79154607593256 52 365.69963891790576 53 356.35558244483326
		 54 352.75836841937542 55 355.52159620647495 56 362.53749482869432 57 372.82329638577147
		 58 384.29041277540421 59 394.12681775093921 60 400.44743586233136 61 402.30800060729115
		 62 401.76681451032749 63 401.76682658491802 64 401.76681559427772 65 401.76681498599743
		 66 401.76681424719214 67 401.76681927058667 68 401.76681927058667 69 401.76681927058667;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY";
	rename -uid "01E6C508-4830-CAFA-04D9-63A8EBA4F7DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 55.849277204418435 1 55.849266604465186
		 2 55.849261123646144 3 55.849252138926708 4 55.849247019971578 5 55.84927530793815
		 6 55.84924927339889 7 20.650263141746549 8 19.587893689809526 9 20.074869602328565
		 10 21.359559422693092 11 22.755070572116129 12 23.751112864155335 13 24.073714566918252
		 14 23.798160120947799 15 23.285264347224032 16 23.025331781436972 17 23.542617230323259
		 18 23.064345497635379 19 22.684144892854103 20 21.744174765989179 21 20.292722607838527
		 22 18.296137888641962 23 16.008991392576668 24 13.782394444594781 25 11.85574560559156
		 26 10.543319023898727 27 10.377067470449289 28 11.977149807957225 29 15.131569392339978
		 30 18.76154341449714 31 21.288605264348199 32 22.778482035380055 33 24.063845990827257
		 34 24.136645060431107 35 21.661333373090578 36 16.887997934788885 37 10.867248528939344
		 38 5.0698434441725491 39 3.8949992744841091 40 2.9970555935196637 41 3.9733156940833716
		 42 3.764628757324715 43 0.22519205065631129 44 -1.3209598338604369 45 -2.9295776623597765
		 46 -10.490132548108514 47 -14.30338310816329 48 -15.594176478726791 49 -14.736179909570758
		 50 -11.604970756892248 51 -5.0221506897370709 52 1.3239419842988978 53 5.8273148956161052
		 54 8.7047980402764029 55 6.0460501315922244 56 2.3377985045181968 57 -1.3710959858907636
		 58 -3.8559010845690675 59 -4.3481201400476674 60 -3.3271840382015654 61 -1.3306561492038833
		 62 0.82253530180461221 63 0.82253239322267246 64 0.82255529071040656 65 0.82254302491420828
		 66 0.82256220936079949 67 0.82253105950093974 68 0.82253105950093974 69 0.82253105950093974;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ";
	rename -uid "9BBE9843-4EEB-DC96-7532-C8934C3AA020";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -49.658750134030655 1 -49.658743132521948
		 2 -49.658681750508009 3 -49.658709518800492 4 -49.658701120579956 5 -49.658756246579699
		 6 -49.65874389020972 7 22.87502055534204 8 16.933598853030322 9 12.847424303621898
		 10 9.6722436449065903 11 7.1821284932689533 12 4.7037772686499526 13 1.2489052085849355
		 14 -3.6353806947080773 15 -9.8752060484712132 16 -17.061495235385255 17 -24.864463490607424
		 18 -25.161816010479221 19 -27.816049374252835 20 -31.11317980454373 21 -33.617491828637171
		 22 -33.969655773496278 23 -32.52004955996145 24 -30.57057619165629 25 -28.03496566464262
		 26 -24.727267483356428 27 -20.008000991937134 28 -14.066472633907884 29 -12.351275983352155
		 30 -14.454890672659277 31 -14.665736080698233 32 -15.947170725077587 33 -18.612333039995534
		 34 -21.910864513384688 35 -25.055748157975586 36 -26.131031588835636 37 -22.695870012226109
		 38 -13.961850356576884 39 -13.12487303337031 40 -13.294848996591805 41 -17.976712753064515
		 42 -20.261537954866828 43 -19.351516902292278 44 -12.771136063375627 45 -3.1375736042669997
		 46 -3.8828415999844954 47 -7.0937015863981134 48 -10.754994827203786 49 -13.605258674167622
		 50 -14.583744316993737 51 -13.03363488292794 52 -12.664762245859396 53 -12.806123338935574
		 54 -11.608511887495684 55 -11.745805430784154 56 -11.65102677026873 57 -11.632509333809798
		 58 -11.433038322901693 59 -9.9165067295060538 60 -6.5527877322435151 61 -1.7663604224349267
		 62 3.3406013197228863 63 3.3406083854943684 64 3.3405818027999117 65 3.3405952544053577
		 66 3.3405773936584509 67 3.3405988558670026 68 3.3405988558670026 69 3.3405988558670026;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAX";
	rename -uid "C748E6EB-47F3-126D-9897-8883CD75EE6D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -2.8183932595702288 1 -2.5928910679389769
		 2 -2.1006340904997738 3 -1.6516987128329719 4 -1.4628779078027212 5 -1.5742442070993492
		 6 -1.7851685671190038 7 -1.7834848604091416 8 -1.4388828597379171 9 -0.80906354355913512
		 10 -0.10454868487478829 11 0.41769607777900625 12 0.68240785979588015 13 0.85669630889701298
		 14 1.0239328751986998 15 1.1812017213704322 16 1.3266844848217259 17 1.4597521999497995
		 18 1.568431903384425 19 1.6600266361765619 20 1.7690089310450834 21 1.9090548880156497
		 22 2.0707308685095938 23 2.244686568365664 24 2.4360911409622616 25 2.6478512238244698
		 26 2.8825746813583164 27 3.1424739989616337 28 3.4291652633038328 29 3.7385057179671732
		 30 4.0656025009660404 31 4.4118688495310687 32 4.780739546482236 33 5.1772379283406078
		 34 5.5725566507874715 35 5.9479333119879518 36 6.3254335393034475 37 6.6667708634583658
		 38 6.9261653849002638 39 7.2444898060693754 40 7.7996849825514349 41 8.8676426201430711
		 42 9.6001629857828501 43 10.216429862646999 44 10.422953497508537 45 10.612870932703823
		 46 10.81045702572802 47 11.051841269738393 48 11.369759144303424 49 11.766321136140467
		 50 12.239468783226014 51 12.852035493043422 52 13.592218379497234 53 14.495774150826621
		 54 15.541555088774521 55 16.799488516937178 56 18.188119926234819 57 18.007320952000192
		 58 17.792634930261297 59 17.663515304518391 60 17.680367740713905 61 17.872335244418352
		 62 18.278754327432555 63 18.899229583521336 64 19.734074555078159 65 20.764708989250742
		 66 21.928717807694646 67 23.086033461519023 68 23.137392372726154 69 23.153939539617262;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAY";
	rename -uid "17D6D42A-48C8-3244-9EBE-12AAE66D37A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 5.1105078605917598 1 5.0183820233037482
		 2 4.665849946335709 3 4.0433474477219393 4 3.20398084387132 5 2.2116914085951178
		 6 1.0380502112115744 7 -0.29126535474548271 8 -1.5986110582666659 9 -2.6546696172776634
		 10 -3.2913304135539279 11 -3.4797365823851134 12 -3.4318676002455106 13 -3.3428306213120274
		 14 -3.2209029435815384 15 -3.0724125614318112 16 -2.9040917260046402 17 -2.7228737280955615
		 18 -2.4967128163001573 19 -2.2521137056656393 20 -2.0662550167481881 21 -1.952671743865676
		 22 -1.8589920042117334 23 -1.756774935059531 24 -1.6675485942987693 25 -1.5940454332864655
		 26 -1.5388176011757781 27 -1.5044563909513886 28 -1.4937136839464196 29 -1.0996541332865948
		 30 0.023053548783102517 31 1.7789858755397912 32 4.0726269573861194 33 6.8083180502983733
		 34 9.8889244968664247 35 13.212594722537611 36 16.674366159212283 37 20.201871500779227
		 38 23.69009755979739 39 27.002612352472578 40 30.059382065945162 41 32.699976935523594
		 42 28.711014013066467 43 24.090718247394356 44 20.245240142034081 45 16.513315360991772
		 46 13.128771826019259 47 10.336605199650929 48 8.3939347243486662 49 7.6006082574735814
		 50 8.5858549401667794 51 11.426578570813346 52 15.572263651636987 53 20.502647819238842
		 54 26.150526026411406 55 31.582896920131748 56 36.273928782058235 57 33.78898714161128
		 58 30.909538645937669 59 28.124370840465645 60 25.963513367502742 61 24.990792598498995
		 62 25.680205772271808 63 27.832697083987586 64 30.899355696262063 65 34.410921260349518
		 66 37.90565390762162 67 40.934108193174495 68 40.862592028233308 69 40.836523571624163;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAZ";
	rename -uid "8E1FFB0E-4EEA-1131-D729-A2B8B3C2D58A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.38735492342387767 1 2.6566056764552846
		 2 8.7757166978529568 3 16.717764350248586 4 24.461281512017763 5 29.99428430284242
		 6 30.818373371389516 7 26.761424932511325 8 19.290572579303252 9 9.8675681524772312
		 10 -0.030978743093063487 11 -8.9118284414937481 12 -14.813877883693818 13 -18.519909477883079
		 14 -22.331082729890909 15 -26.256850996592764 16 -30.306774433880822 17 -34.490420636289613
		 18 -36.889075338326357 19 -36.507408982979975 20 -34.816372175296763 21 -33.483121147898935
		 22 -34.065773218228422 23 -35.868261854468201 24 -37.169567150407403 25 -37.941824976675839
		 26 -38.157101411366078 27 -37.787475683831829 28 -36.805083265694662 29 -35.447860152205187
		 30 -33.979523767201897 31 -32.411343848713841 32 -30.755307901587013 33 -29.024316759435685
		 34 -28.767873473367008 35 -30.985730270194313 36 -34.865658052613348 37 -40.909783175847409
		 38 -49.350329993803065 39 -58.91260196555227 40 -68.274753515375707 41 -68.372010294873192
		 42 -64.868118266673491 43 -61.999584935724208 44 -59.708269808174414 45 -58.698413549671805
		 46 -58.965966016917648 47 -59.990627606024539 48 -61.118923036227443 49 -61.936121878200673
		 50 -61.954800749543253 51 -58.883663807061772 52 -54.763712698989188 53 -49.452738145531697
		 54 -49.435744375266474 55 -49.330111679779506 56 -49.018623278167475 57 -51.004685826547373
		 58 -52.369271964863387 59 -52.246579187846429 60 -50.527296989301462 61 -47.85475923095958
		 62 -44.877446906013297 63 -42.303921550632815 64 -39.070145535489694 65 -35.475415639315997
		 66 -31.857219085154934 67 -28.623541756890493 68 -27.563241211498724 69 -27.171050679448047;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX";
	rename -uid "CA4D766D-48BA-104B-C7AF-EC9D21EA1A43";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 9.4478683800076251 1 7.806382195957057
		 2 6.0639378619544075 3 4.2585542285085545 4 2.4314690995170856 5 0.62442041287697347
		 6 -1.1232056859728561 7 -2.7762974778322005 8 -4.3047714059804418 9 -5.683642909775962
		 10 -7.4561876035577104 11 -10.004238909997589 12 -12.024948420310841 13 -11.561702003851448
		 14 -7.5996221932775194 15 -1.2000094219440891 16 4.1764572310603452 17 5.5547858089414497
		 18 7.9625909443085048 19 7.9625832851316298 20 7.962585164168253 21 7.9625944896838954
		 22 7.9625879661853514 23 7.9625912224662709 24 7.9625949683755266 25 7.9626004980366822
		 26 7.9625962540980622 27 7.9625672704109425 28 7.962593789930609 29 7.9625824837439012
		 30 7.9625535016699782 31 7.9625826328040423 32 7.9625811417769219 33 7.9625677641504327
		 34 7.9625469562242808 35 7.9625777810898137 36 7.9625990266313575 37 7.9625855730474875
		 38 7.9625855368645437 39 7.9625902401526352 40 7.962600829920043 41 7.9625955336420375
		 42 7.9626066924564629 43 7.9625885405672285 44 7.9626019648073187 45 7.9625938926284281
		 46 7.9625793342362332 47 7.9625915982362514 48 7.9625691329726527 49 7.9626008581523022
		 50 7.9625666101094126 51 7.9626059141606138 52 7.9625742646452542 53 7.962579178953324
		 54 7.9625725810538404 55 7.9625797305474757 56 7.9625684071990097 57 7.9625794833862509
		 58 7.9625997977160434 59 7.96259237677919 60 7.96258556962401 61 7.9626103751472419
		 62 7.9626010628937225 63 7.9626077679960163 64 7.9625700433583422 65 7.9625968302166346
		 66 7.962605393806645 67 7.9625817362625284 68 7.9625817362625284 69 7.9625817362625284;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY";
	rename -uid "6EC17E1E-4156-DE63-6F75-75813A30F3BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -0.06093584100964379 1 0.35018157018991491
		 2 0.59980760091321417 3 0.66252983233136997 4 0.52236396978390343 5 0.17282834620775636
		 6 -0.38387083527436655 7 -1.1388771577724954 8 -2.0786685783417989 9 -3.1874274291449085
		 10 -3.5890036083021393 11 -1.9205025803384064 12 2.3216679435664846 13 8.3753041306880966
		 14 13.969983486867894 15 16.804287608173524 16 17.017600262825354 17 17.493375005258869
		 18 16.669130951139287 19 16.669124754350367 20 16.66912710635162 21 16.669133322854687
		 22 16.669097232613954 23 16.669129682438754 24 16.669118055091953 25 16.66911022177008
		 26 16.669130924448364 27 16.669143379877983 28 16.669112436747081 29 16.669115906889967
		 30 16.669121872254976 31 16.66911441691008 32 16.669123192910217 33 16.669132962547522
		 34 16.669109220975731 35 16.669130526436923 36 16.669106323097459 37 16.669125845080153
		 38 16.669131245043133 39 16.669120515571468 40 16.669118163583214 41 16.669122364379788
		 42 16.669095524339607 43 16.669112951270261 44 16.669108517414923 45 16.6691287871502
		 46 16.669122604290095 47 16.669139090068334 48 16.669150808180557 49 16.669102907640109
		 50 16.669117018485895 51 16.669126761087558 52 16.669104619040606 53 16.669141804825014
		 54 16.669117823408101 55 16.669127390277456 56 16.669132617243378 57 16.669143133846291
		 58 16.669123249868463 59 16.669145965114293 60 16.669124048706209 61 16.669124954789659
		 62 16.669129967148578 63 16.669107247865419 64 16.669112800579423 65 16.669137215661564
		 66 16.669121080658464 67 16.669130440987971 68 16.669130440987971 69 16.669130440987971;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ";
	rename -uid "19CC0E5B-4DFD-3A8C-B7A3-2F89280BCC59";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.9792343137863564 1 0.06058667135955427
		 2 -3.0147405845242421 3 -6.2137577704442579 4 -9.5045457331360126 5 -12.858655662175897
		 6 -16.253402695418092 7 -19.673835627055116 8 -23.114052997234136 9 -26.577846697583993
		 10 -22.949187001622352 11 -8.1435915764041678 12 13.380934823561702 13 38.064034031558833
		 14 63.685086371144692 15 88.469010621155761 16 106.62281411247277 17 110.54159518177744
		 18 118.60862501393009 19 118.60863783244403 20 118.60857957718849 21 118.60863823756725
		 22 118.60862673206941 23 118.608627631084 24 118.60863316876659 25 118.60863528671545
		 26 118.60861522606639 27 118.60864797412006 28 118.60863916461417 29 118.60861472109413
		 30 118.60863081036959 31 118.60864069445627 32 118.60863863244725 33 118.60863898842283
		 34 118.60862440538521 35 118.60862086733165 36 118.60862601397871 37 118.60864087973933
		 38 118.60863467745521 39 118.60865268201638 40 118.60862200542124 41 118.6086306244152
		 42 118.6086149004709 43 118.60861206892349 44 118.60864697677965 45 118.60862753629006
		 46 118.60861084112211 47 118.6086385672759 48 118.60863865377763 49 118.60862214482439
		 50 118.60863716742033 51 118.60863923209672 52 118.60864647007806 53 118.60862729755823
		 54 118.60861010199075 55 118.60863253529909 56 118.60863121157503 57 118.60863232809668
		 58 118.60864082142589 59 118.60860619885719 60 118.60864051207398 61 118.60863000649813
		 62 118.60864490479888 63 118.60862462188979 64 118.60862863321695 65 118.60861531913609
		 66 118.60861760792723 67 118.60863569943974 68 118.60863569943974 69 118.60863569943974;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX";
	rename -uid "8BFEED3D-4B06-2093-05F4-BAB76FCA5006";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 13.968347227007813 1 14.954014015703811
		 2 15.286952438220844 3 15.283125288486081 4 15.195111647781584 5 15.214723063704383
		 6 15.460085176728905 7 15.956666141904302 8 16.633124159719891 9 17.349645550041153
		 10 17.959434723947652 11 17.504842122340964 12 15.191921917593188 13 11.611820910940313
		 14 7.8610571559689619 15 5.0575113621389489 16 3.7587010760228541 17 3.8031023901371377
		 18 2.9356895557652036 19 2.9357009356421155 20 2.935700114452469 21 2.9356913755879903
		 22 2.9357015557525625 23 2.9357080267733098 24 2.9356945537278212 25 2.9356924288788222
		 26 2.9357034141594975 27 2.9356967387499049 28 2.9356967834595444 29 2.9356979583070055
		 30 2.9356951935237614 31 2.9356905057654852 32 2.935701097935377 33 2.9356959816492734
		 34 2.9356861993941648 35 2.9356945270454218 36 2.9356962824446007 37 2.9356782478792516
		 38 2.9356927382907831 39 2.93569989074004 40 2.9357003394708303 41 2.9357121635437955
		 42 2.9357093260387703 43 2.9356831962213401 44 2.9357051686521576 45 2.9356988729505531
		 46 2.9357006789312199 47 2.9356999011218465 48 2.9356902940650778 49 2.9356852496530506
		 50 2.9356978195587353 51 2.9356934303821443 52 2.935707243877328 53 2.9357068084402447
		 54 2.9357076550439976 55 2.9356991444902176 56 2.9356938263059345 57 2.935706607132285
		 58 2.93569314132976 59 2.9356833689903823 60 2.9356966723293434 61 2.9356855290828214
		 62 2.9357038891639369 63 2.9357057859918427 64 2.9356992529577242 65 2.9356985992367832
		 66 2.935694385111014 67 2.9357000873668335 68 2.9357000873668335 69 2.9357000873668335;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY";
	rename -uid "19074A63-4A43-7996-6CDD-21973FA9716B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 1.2869253324469228 1 1.8195404992753073
		 2 1.7895304925113877 3 1.2694299778742977 4 0.37662010393541123 5 -0.81027119592676589
		 6 -2.2858926378741393 7 -4.1055042504772894 8 -6.3371268082388053 9 -9.0025331445462484
		 10 -12.034208077076617 11 -15.485533507010437 12 -18.770462773742857 13 -20.811098143358361
		 14 -20.946460927086722 15 -19.184264160761536 16 -16.076976593236328 17 -12.410980626964646
		 18 -10.877001134728122 19 -10.877007544955639 20 -10.87700089618038 21 -10.877012238883614
		 22 -10.877014067131197 23 -10.87701645733129 24 -10.877013547633752 25 -10.877006954473547
		 26 -10.877008136781551 27 -10.877027938721177 28 -10.877005959989772 29 -10.87702995123766
		 30 -10.87700969216173 31 -10.876980650870808 32 -10.877021431316312 33 -10.877040695039446
		 34 -10.876991791703183 35 -10.876996934957607 36 -10.877001407388116 37 -10.877031994313166
		 38 -10.877003898645114 39 -10.877013842981466 40 -10.877022457470387 41 -10.876997304090203
		 42 -10.877018560650987 43 -10.877001820975398 44 -10.877013424042735 45 -10.877013765933764
		 46 -10.877021840798896 47 -10.876998871247336 48 -10.877015367862233 49 -10.876992917573576
		 50 -10.876995382203667 51 -10.877006508998283 52 -10.877010748196367 53 -10.877015306945616
		 54 -10.877016130598472 55 -10.877016032601775 56 -10.876998160085154 57 -10.877008108847027
		 58 -10.87701977437581 59 -10.877015795809374 60 -10.877006659655711 61 -10.877011449341117
		 62 -10.877035649939494 63 -10.877016340842451 64 -10.877011636446118 65 -10.877016053591227
		 66 -10.877026139764883 67 -10.877029601424329 68 -10.877029601424329 69 -10.877029601424329;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ";
	rename -uid "69DCE178-447D-CDC5-D2D6-4C9D1211A12B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -2.54615141075312 1 -4.1663359924831465
		 2 -3.9047323261262772 3 -2.0217904698247291 4 1.2268208727482106 5 5.5896296205888198
		 6 10.819443382027206 7 16.670407016398084 8 22.891283179299801 9 29.217833977963927
		 10 35.363684427707732 11 42.862814929333034 12 52.452723782910326 13 62.569672027794567
		 14 71.496066644818981 15 77.539995488125882 16 79.267558854148632 17 75.426666892289049
		 18 77.409396722508731 19 77.409403847392042 20 77.409358683697164 21 77.409368560652879
		 22 77.40938399262312 23 77.409368941544713 24 77.409403308947333 25 77.40939716239869
		 26 77.409371216339665 27 77.409394699358842 28 77.409388026434641 29 77.409378292536474
		 30 77.409385136279425 31 77.409388717458526 32 77.409397708167944 33 77.409369581771514
		 34 77.409381759540651 35 77.409383922901554 36 77.409378777895029 37 77.409394118327839
		 38 77.409383322480551 39 77.409377597601676 40 77.409385578577229 41 77.409381398347918
		 42 77.409388080920863 43 77.409366001740835 44 77.409353500176252 45 77.409402517821121
		 46 77.409375385637716 47 77.409375077299543 48 77.409383667264137 49 77.409381496759465
		 50 77.409374504642685 51 77.40939045389635 52 77.409357989251134 53 77.409399906831979
		 54 77.409384315326164 55 77.409358164308657 56 77.409409640292907 57 77.409359058289439
		 58 77.409398733747906 59 77.409409142492422 60 77.409377141645251 61 77.409375062141478
		 62 77.409363922968367 63 77.409352025476437 64 77.40937240919547 65 77.409383448641222
		 66 77.40936281583754 67 77.409375976961925 68 77.409375976961925 69 77.409375976961925;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX";
	rename -uid "28E0E91D-4CEC-DE1D-4396-02B4016AB377";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 6.9922748597240156 1 7.2721505536933231
		 2 8.0743233231017122 3 9.3490162541623949 4 11.014561450434416 5 12.928065402895447
		 6 14.881513523811405 7 16.437560716922089 8 17.196325167536759 9 17.042207663399473
		 10 16.129952424760386 11 15.023874516334763 12 14.662328021523422 13 15.087406468314592
		 14 14.905824501668738 15 14.29493853420797 16 14.055033178118878 17 13.958375752924059
		 18 13.828158959807761 19 13.573623742207889 20 14.245035026248317 21 15.577573290240801
		 22 16.482316557913975 23 16.232143882122585 24 15.006101810696221 25 14.19559937431956
		 26 13.361299325401767 27 11.751955186379698 28 10.702987504504073 29 10.557839122025142
		 30 10.721407492920267 31 11.122441875751317 32 11.691829541331737 33 12.364249026600792
		 34 13.078328227220846 35 13.77700824248574 36 14.40714442579495 37 14.918461273681517
		 38 15.261996920175221 39 15.387963196888515 40 10.826965178232108 41 2.8860354832018031
		 42 -2.3987689336964544 43 -4.0307664412070947 44 -4.0307889792439786 45 -4.0308222033909384
		 46 -4.0307666064826941 47 -4.0308057483652124 48 -4.0307863655606502 49 -4.0307696233463144
		 50 -4.0307731961821736 51 -4.0307757928392407 52 -4.0307577641520629 53 -4.0307855327242494
		 54 -4.03078267607225 55 -4.0307757349144211 56 -4.0307653608618308 57 -4.0307545757178271
		 58 -4.030764766610357 59 -4.0307562534674224 60 -4.0307653608618113 61 -4.0307451777628502
		 62 -4.0307562534674215 63 -4.0307811348672882 64 -4.0307544570973146 65 -4.0307434031665901
		 66 -4.0307757349144131 67 -4.0307647666104245 68 -4.0307647666104245 69 -4.0307647666104245;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY";
	rename -uid "85E933A2-4496-FE5F-68CD-339CE165A17A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -5.3593867660052172 1 -5.9399488177103557
		 2 -7.4539395522279017 3 -9.5571141227711411 4 -11.914782567315191 5 -14.214762248962073
		 6 -16.172281254350263 7 -18.768786672852361 8 -22.660750250817621 9 -27.037957138068215
		 10 -31.142671968405836 11 -34.398328189865673 12 -36.418294792391954 13 -37.654270051799855
		 14 -38.176395223485365 15 -37.089648218393577 16 -34.364889189868173 17 -30.387843141622156
		 18 -25.557202591929318 19 -20.293935897180173 20 -22.755855532985962 21 -28.880544119835715
		 22 -36.733543891281997 23 -44.383675806917154 24 -50.059540677951446 25 -52.261655095955113
		 26 -51.805766473393383 27 -50.926208369767814 28 -50.324593460694452 29 -50.050637344850749
		 30 -49.719342601072199 31 -49.342854446452073 32 -48.93428760885535 33 -48.508758849156358
		 34 -48.084193749592501 35 -47.681331762417791 36 -47.323488198738318 37 -47.035798007841784
		 38 -46.844418683717741 39 -46.77516807621339 40 -44.936644791257372 41 -40.069019391645668
		 42 -34.556070600874037 43 -31.975626063683638 44 -31.975609352838738 45 -31.975598309364344
		 46 -31.975597715465582 47 -31.975589458672207 48 -31.975600971642383 49 -31.97562125643039
		 50 -31.975614848046021 51 -31.975613882060351 52 -31.975605604824413 53 -31.975603115079608
		 54 -31.975600292875463 55 -31.975597328033977 56 -31.975602451415117 57 -31.97560943092768
		 58 -31.975600570865382 59 -31.975601593463526 60 -31.97560245141506 61 -31.97561027521883
		 62 -31.975601593463516 63 -31.975604918240837 64 -31.975606891691047 65 -31.975606687171542
		 66 -31.97559732803397 67 -31.975600570865502 68 -31.975600570865502 69 -31.975600570865502;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ";
	rename -uid "5D6C0435-42BE-CD0D-4E42-2DA3C3CFB4EC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -13.826405290795437 1 -14.370063485370348
		 2 -15.773432067014644 3 -17.702011857052849 4 -19.816801077161287 5 -21.756599007880499
		 6 -23.125800258722872 7 -22.859237454220359 8 -20.685330333786464 9 -17.333232939774199
		 10 -13.657992374655631 11 -10.817700549352491 12 -10.279052453002262 13 -11.671886513398599
		 14 -12.795696853313327 15 -13.421997500927835 16 -14.093993869456623 17 -14.754365559865271
		 18 -15.391999913072226 19 -16.047666524652016 20 -15.802117494506742 21 -15.116975232881826
		 22 -13.939410446822611 23 -12.16458455248743 24 -10.118535694846207 25 -9.0622973982809736
		 26 -8.9687409940915312 27 -8.8177318808444074 28 -8.7909811056753302 29 -9.0457447756825058
		 30 -9.5766829909912801 31 -10.312249966002069 32 -11.182622785330798 33 -12.121272554685858
		 34 -13.065341509892241 35 -13.956176978192895 36 -14.738804094514336 37 -15.361053819776455
		 38 -15.772296624575738 39 -15.921190103023948 40 -9.4032867288117981 41 3.6193317168931434
		 42 15.115315388030515 43 19.965308908758516 44 19.965322149386541 45 19.965264215440893
		 46 19.965319345755248 47 19.965257142452 48 19.965297554905966 49 19.965328612882288
		 50 19.965315944175043 51 19.965287514645023 52 19.965355558866591 53 19.965323488176988
		 54 19.965328509668886 55 19.965311278034363 56 19.965298947225776 57 19.965289641115671
		 58 19.965283292780278 59 19.965308040129383 60 19.965298947225822 61 19.965313242623019
		 62 19.965308040129347 63 19.965292009762162 64 19.965310273247649 65 19.96531113273592
		 66 19.965311278034459 67 19.965283292780494 68 19.965283292780494 69 19.965283292780494;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX";
	rename -uid "4163BDE1-4AAA-9B75-45F9-069D7CFA1A72";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 5.5883408884352059 1 5.3501674825688479
		 2 4.6632889860633515 3 3.7285788189273363 4 2.7368404221475853 5 1.858919088577409
		 6 1.24804258038158 7 0.68896745860515629 8 -0.11020320394920834 9 -1.1300009730786884
		 10 -2.355925488714937 11 -3.7648461192954281 12 -5.3162132643666427 13 -6.946240802374442
		 14 -8.5659961484584297 15 -10.062976332627612 16 -11.305317204516822 17 -12.151164535664407
		 18 -12.461329844247615 19 -12.461340614896756 20 -12.461325516848909 21 -12.461315666448243
		 22 -12.461296661425209 23 -12.461294823309064 24 -12.461336158102606 25 -12.461307635009454
		 26 -12.46131429277653 27 -12.461316495272795 28 -12.4612957083637 29 -12.46127190358005
		 30 -12.46130861293733 31 -12.461283752404698 32 -12.461284312758648 33 -12.46127900743824
		 34 -12.461273175610048 35 -12.461302496288315 36 -12.461337582474282 37 -12.461312669518563
		 38 -12.461273725513044 39 -12.461318887268604 40 -12.461270113381092 41 -12.461317449032915
		 42 -12.46143497344338 43 -12.461297798883843 44 -12.461292275372946 45 -12.461344946217432
		 46 -12.461301700484157 47 -12.461334602474983 48 -12.461336661381452 49 -12.461257266227754
		 50 -12.461257527596112 51 -12.461317869002759 52 -12.46124033559928 53 -12.461297359925016
		 54 -12.461312721593899 55 -12.461298381389922 56 -12.4612994560758 57 -12.461290192597167
		 58 -12.461317367265712 59 -12.461291296727859 60 -12.461299456075812 61 -12.461277569111859
		 62 -12.461291296727859 63 -12.461316893748199 64 -12.46128630428684 65 -12.461280336781032
		 66 -12.461298381389915 67 -12.461317367265686 68 -12.461317367265686 69 -12.461317367265686;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY";
	rename -uid "A8370388-4818-81E0-3A21-93820AA7B5AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -16.687930164853078 1 -16.426255663974661
		 2 -15.768157770559126 3 -14.943367673161566 4 -14.156064915943233 5 -13.576536451332066
		 6 -13.355195578274962 7 -12.964796828787557 8 -11.872286736789722 9 -10.22493524172639
		 10 -8.1738386738519218 11 -5.8716047212030906 12 -3.4691192040766574 13 -1.1115305612174904
		 14 1.0658922133972704 15 2.9407441417676035 16 4.4036897701038011 17 5.3547970041582973
		 18 5.6951989405175825 19 5.6952167935451419 20 5.6952123196128976 21 5.6952174567157936
		 22 5.6952265037489997 23 5.6952103592151593 24 5.6952043890998238 25 5.6952173222105493
		 26 5.6952121312332507 27 5.6952179340736304 28 5.6952133848216535 29 5.6952135609301147
		 30 5.6952163131353633 31 5.6952078212021453 32 5.6952044403754636 33 5.6952069399765115
		 34 5.6952056136794065 35 5.6952044864202467 36 5.6952128098048593 37 5.6952027094002426
		 38 5.6952228119545785 39 5.695204616898307 40 5.695202603496158 41 5.6952138039387901
		 42 5.6951861963891632 43 5.6952092427113499 44 5.6952029854931867 45 5.6951928970307089
		 46 5.695203963164003 47 5.6952063005763947 48 5.695204551419641 49 5.695211869301489
		 50 5.6952126903547926 51 5.6952091465647054 52 5.6952237268503607 53 5.6952054356859607
		 54 5.6952130868321191 55 5.6952125273354577 56 5.6952117687463479 57 5.6952169169579783
		 58 5.6952216832706437 59 5.6952188767382843 60 5.6952117687464074 61 5.6952129048066205
		 62 5.6952188767382896 63 5.6952164677428874 64 5.695214891080405 65 5.6952181300616571
		 66 5.6952125273354506 67 5.695221683270514 68 5.695221683270514 69 5.695221683270514;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ";
	rename -uid "EE11C20E-4E77-FB7F-1833-B48BE5823539";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 23.093380408756239 1 22.429042247091122
		 2 20.525811938031861 3 17.978516568489777 4 15.401279773390021 5 13.434878136864542
		 6 12.737186793275223 7 12.418085646414127 8 11.258777292813965 9 9.4240212957496414
		 10 7.0750407081006692 11 4.3684708123554996 12 1.4587705789525074 13 -1.4973459688725579
		 14 -4.3354927716783758 15 -6.8795471038276679 16 -8.9411099389514384 17 -10.32285412988251
		 18 -10.826260346445373 19 -10.82626645780369 20 -10.826249712234182 21 -10.826255902190214
		 22 -10.826270493021914 23 -10.826261761819895 24 -10.826264850460683 25 -10.826277277119893
		 26 -10.826275640578576 27 -10.826240996138706 28 -10.826264440396054 29 -10.82626169391088
		 30 -10.826256109618777 31 -10.826275231458927 32 -10.826257427952216 33 -10.826255078637342
		 34 -10.826255453378009 35 -10.82625853184301 36 -10.826265237196058 37 -10.826257659050734
		 38 -10.826253357544337 39 -10.826251792924415 40 -10.826268180825755 41 -10.8262739897164
		 42 -10.826295971518707 43 -10.826247908633128 44 -10.826267088036316 45 -10.826286319091258
		 46 -10.826263538972601 47 -10.826279095535249 48 -10.826280064317693 49 -10.826249931286553
		 50 -10.8262584050415 51 -10.826275313739224 52 -10.826216444156294 53 -10.826257867546314
		 54 -10.826251624067206 55 -10.826259531297268 56 -10.826266106626701 57 -10.826271156664733
		 58 -10.826275153728441 59 -10.826271842294377 60 -10.826266106626671 61 -10.826274435822191
		 62 -10.826271842294407 63 -10.826268487627752 64 -10.826269168604211 65 -10.826275776980747
		 66 -10.826259531297197 67 -10.826275153728256 68 -10.826275153728256 69 -10.826275153728256;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAX";
	rename -uid "8B2FEEB9-41CF-A43A-5ED5-64A1E59147AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 8.686912762483329e-006 1 0 2 -1.3179642113505795e-006
		 3 -7.3962569733660354e-006 4 -1.0457744096028817e-005 5 3.0507508574968661e-006 6 2.6174111655968366e-006
		 7 1.3618602694849261e-005 8 0 9 2.4238938870528334e-006 10 1.5593647880739538e-006
		 11 -5.6238444179096362e-006 12 -5.4900394969640989e-006 13 7.1100006855770517e-006
		 14 0 15 1.8178067309748683e-006 16 5.3033643571106675e-006 17 0 18 4.6966051646834079e-006
		 19 0 20 -1.5454384435775527e-006 21 2.1502555797974933e-006 22 0 23 7.4438857664084251e-006
		 24 5.5095176143632883e-006 25 -4.6996751639270673e-006 26 -2.8956052603557901e-006
		 27 8.1382164670106921e-006 28 -2.3493057960795787e-006 29 -1.0521112943172087e-005
		 30 0 31 5.3967125970580381e-006 32 2.0725723699547157e-006 33 -5.2447406764763795e-006
		 34 2.0823314781400849e-006 35 2.2757645247885198e-006 36 -4.1898198118746048e-006
		 37 0 38 3.8041683918402894e-006 39 0 40 -1.6995406354851152e-006 41 2.3063100564429117e-006
		 42 -3.4239290050342138e-006 43 -2.0099824585351511e-006 44 0 45 0 46 1.9898813019648243e-006
		 47 0 48 4.2255263016527821e-006 49 0 50 9.4787915988669546e-023 51 2.4759338642573454e-006
		 52 -2.6539379130112709e-006 53 0 54 -1.5166066558193964e-021 55 1.5166066558199164e-021
		 56 -1.5166066558200767e-021 57 0 58 4.0260992773955916e-006 59 -1.411624241403296e-006
		 60 -1.4278250883374455e-006 61 -3.4491515616200602e-006 62 -1.4116242422534784e-006
		 63 0 64 -2.2527825482904574e-006 65 -1.8050331827935976e-006 66 -2.0294625307304393e-006
		 67 3.791516639546772e-022 68 1.8957583197733991e-022 69 1.8957583197733991e-022;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAY";
	rename -uid "3844927F-4E9F-8A68-4C0E-47AC3BA5C45C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -1.5689269706443222e-006 1 -2.968471692860166e-006
		 2 -5.0041101684918582e-006 3 1.2551698468995525e-006 4 2.4329219941923379e-006 5 5.2126583121725987e-006
		 6 7.4303396496278784e-006 7 6.2510941911691719e-006 8 0 9 -2.4663535977328333e-006
		 10 0 11 -5.7802245846168504e-006 12 -2.4169481190603493e-006 13 -3.0608115829941501e-006
		 14 4.0103379954628826e-006 15 -2.222540425170193e-006 16 -3.791516639546772e-022
		 17 -6.4312955494195689e-006 18 -3.5254087181873326e-006 19 -6.4451143144635231e-006
		 20 -1.1200972166462725e-005 21 1.971862736721155e-006 22 -8.9153459575907849e-006
		 23 0 24 8.2976027493041684e-006 25 -3.3906602037306952e-006 26 0 27 2.9542559147216951e-006
		 28 5.9597242461254489e-005 29 2.6572548682963909e-006 30 -5.0406857982796761e-006
		 31 -3.8074548811554489e-006 32 -3.700958045443722e-006 33 -7.8905871810570446e-006
		 34 1.2429910378315581e-006 35 2.4920323983868213e-006 36 -5.3576922477886409e-006
		 37 0 38 0 39 0 40 -7.2418480796231912e-006 41 0 42 -7.0240467943079513e-005 43 0
		 44 8.7788944801625814e-006 45 -5.9519740539604624e-005 46 0 47 -0.00010041680039745621
		 48 0 49 5.4392741224864761e-006 50 -4.2127790751929305e-006 51 0 52 5.5248887090339371e-006
		 53 -5.7406605615105827e-005 54 -5.4550677812807141e-005 55 -7.2311820459376361e-005
		 56 -7.694626157259608e-005 57 5.8229862918100993e-006 58 -4.8411944578633528e-006
		 59 5.9559900417339617e-006 60 -6.538427620162335e-005 61 7.7997273353144565e-006
		 62 5.9559900422488137e-006 63 3.1694198413214032e-006 64 7.6010319470891779e-006
		 65 6.1445949668221744e-006 66 -5.7747691483685538e-005 67 -6.6910741536963796e-006
		 68 -6.6910741536963804e-006 69 -6.6910741536963804e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ";
	rename -uid "94876E3B-46BA-DF9C-3D10-12AB90053E6D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 30.935405792836651 1 30.934658760478772
		 2 30.934584507710355 3 30.934776697859835 4 30.934718019136895 5 30.935588123360994
		 6 30.934869662854929 7 30.935214338287214 8 30.93465901716608 9 30.93550492296141
		 10 30.934670514956302 11 30.934723768194367 12 30.934710574378634 13 30.9354657385019
		 14 30.934812922836194 15 30.935672429932822 16 30.935213838487638 17 30.934715741948661
		 18 30.934744316951786 19 30.935340941552745 20 30.934731652351282 21 30.934852823572335
		 22 30.828580025883387 23 30.517686779686748 24 30.012958455578648 25 29.328190161226114
		 26 28.472488659117769 27 27.458454264626695 28 26.298423234105265 29 25.004497431769355
		 30 23.58772748463733 31 22.059875166189151 32 20.431041435235592 33 18.715722105821964
		 34 16.923968718436161 35 15.0672593122199 36 13.160116716966938 37 11.208869551932057
		 38 9.2299021652009046 39 7.2333151445586932 40 5.2309047562190436 41 3.2342920619206748
		 42 1.2551761739340537 43 -0.69439767147719167 44 -2.6032718451894787 45 -4.4600060482916035
		 46 -6.2511373820483973 47 -7.9668159766036855 48 -9.5946513900951196 49 -11.123720764673982
		 50 -12.54027235365176 51 -13.83406160235277 52 -14.994252107006101 53 -16.007723480777241
		 54 -16.863121375563523 55 -17.549486503747715 56 -18.053701360616415 57 -18.364181872625682
		 58 -18.470520592186073 59 -18.470477389235942 60 -18.471158532855419 61 -18.470469200972694
		 62 -18.470477389235942 63 -18.47059978617224 64 -18.470497889715073 65 -18.470468076091869
		 66 -18.471272446825601 67 -18.470596825394658 68 -18.470596825394658 69 -18.470596825394658;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX";
	rename -uid "B14EC80C-4DA3-E528-57AC-D6B084739798";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.7327635308685343 1 2.7212931027310652
		 2 2.7220675426451875 3 2.7318890757410856 4 2.747292060159956 5 2.7654705312992789
		 6 2.7848802809289461 7 2.8056332454368613 8 2.8296161537633586 9 2.8601774396903776
		 10 2.9017455578108513 11 2.9587313284484948 12 3.0222265118643965 13 3.0800856214492582
		 14 3.1307722546630097 15 3.1727738977417523 16 3.2046364143323616 17 3.2248534336122088
		 18 3.3082545634682323 19 3.4911042216904784 20 3.7108707785213637 21 3.8996578103949293
		 22 3.994733678628736 23 4.0207073848587669 24 4.0420702740458685 25 4.0590751895901223
		 26 4.0718460018314806 27 4.0805787469867196 28 4.0853776691798256 29 4.0863776022437559
		 30 4.0837103995945911 31 4.0774249122740169 32 4.0676288130020231 33 4.0544222563042904
		 34 3.9919172444650166 35 3.846856961052374 36 3.6374311323927468 37 3.3356107471821708
		 38 2.9211950858476432 39 2.417577059313015 40 1.8662907773817878 41 1.4874934407070279
		 42 1.0902236734531261 43 0.69074938221462545 44 0.95765547382115312 45 1.1857375344737928
		 46 1.3368012815156438 47 1.3951662848202147 48 1.3495213365725733 49 1.2172867172212527
		 50 1.0472587794667703 51 0.94930198016200595 52 0.84495343374692322 53 0.75321162493630822
		 54 0.75321399589059879 55 0.75321118958335231 56 0.75321057999400221 57 0.75321037892831111
		 58 0.75321039032787107 59 0.7532098731817759 60 0.75321057999400165 61 0.75320979523418707
		 62 0.75320987318176591 63 0.75320861890285273 64 0.75320902526991618 65 0.75320867464946717
		 66 0.75321118958334488 67 0.75321039032786063 68 0.75321039032786063 69 0.75321039032786063;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY";
	rename -uid "706F95CA-46F8-1FA3-D6CB-28B2E2E682B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -6.0306729983342713 1 -5.981487167158944
		 2 -5.8218592533983236 3 -5.5780116596427414 4 -5.2761585735025474 5 -4.9412655213689405
		 6 -4.5965669466735948 7 -4.2631414542784398 8 -3.9598973580097931 9 -3.7044132221355124
		 10 -3.5138916701757097 11 -3.4070858353515354 12 -3.3503410441217638 13 -3.2970486624512367
		 14 -3.2490766975506968 15 -3.2083803850195403 16 -3.1769360830216042 17 -3.1566973023018083
		 18 -3.1012656797335714 19 -2.9683525484178697 20 -2.774133190046332 21 -2.5726230132501691
		 22 -2.452688689891628 23 -2.4105025266741142 24 -2.3753350316834192 25 -2.3470735903756759
		 26 -2.3256297437483044 27 -2.3109040344766907 28 -2.3027656415815181 29 -2.3010601686652552
		 30 -2.3056118017432907 31 -2.3162247163368712 32 -2.3327174194971718 33 -2.35485101602921
		 34 -2.449368396466916 35 -2.6526732739240169 36 -2.9173586717549775 37 -3.2601306082095327
		 38 -3.6729086156179998 39 -4.0576896884238618 40 -4.3335888930075663 41 -4.4127930331971896
		 42 -4.4257589422382235 43 -4.3958245412048944 44 -4.3441616812862804 45 -4.2942551779874254
		 46 -4.2617621787743953 47 -4.2559846395162868 48 -4.2809885314928486 49 -4.3278373107209154
		 50 -4.3777782123615889 51 -4.396601536818876 52 -4.4140286256986192 53 -4.427048599987951
		 54 -4.4270607136853917 55 -4.4270586313392908 56 -4.4270604146008257 57 -4.4270593067168225
		 58 -4.4270675603888145 59 -4.427064118504755 60 -4.4270604146008115 61 -4.4270623872337795
		 62 -4.4270641185047372 63 -4.4270594721970582 64 -4.4270512713368317 65 -4.4270630482809379
		 66 -4.4270586313392943 67 -4.4270675603888243 68 -4.4270675603888243 69 -4.4270675603888243;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ";
	rename -uid "D978289A-438D-09C2-7241-C9BEEB52DDE7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.9064793045229784 1 -8.9937811581338298
		 2 -9.4050440763714835 3 -10.081108494965493 4 -10.962559448422319 5 -11.989757374279309
		 6 -13.102610876030973 7 -14.240519987132485 8 -15.342533974589777 9 -16.347500392427929
		 10 -17.194307221105827 11 -17.82232155274275 12 -18.305851362804329 13 -18.750645788099984
		 14 -19.143735182626237 15 -19.472083958245186 16 -19.722721803206728 17 -19.882648074247978
		 18 -20.488020999523076 19 -21.810479522854724 20 -23.418885688320703 21 -24.828959014017805
		 22 -25.561222874842557 23 -25.776754302258716 24 -25.955505447958497 25 -26.098405345953221
		 26 -26.20636791229267 27 -26.280290244085059 28 -26.321078574569317 29 -26.329619174223165
		 30 -26.306801957234576 31 -26.253530281882494 32 -26.170694649775957 33 -26.059162971413134
		 34 -25.486431243032335 35 -24.176681473071536 36 -22.365801647371871 37 -19.923126637978374
		 38 -16.796425978027528 39 -13.339928220144882 40 -9.9120859075633874 41 -7.8564983781121445
		 42 -5.6802135929862185 43 -3.3943449005070701 44 -4.9919545045196845 45 -6.340572843018494
		 46 -7.2049163691725626 47 -7.4966449588086155 48 -7.1654720877542708 49 -6.3302915502969794
		 50 -5.2873616397197027 51 -4.7238067872828058 52 -4.1238564927322878 53 -3.5965000828887743
		 54 -3.5965055439875018 55 -3.5965076282663366 56 -3.5965076534924179 57 -3.5965076397419478
		 58 -3.5965014420952448 59 -3.5965075661294961 60 -3.5965076534923828 61 -3.596507838563999
		 62 -3.5965075661294894 63 -3.5965086361243856 64 -3.5965093534607591 65 -3.5965008417980102
		 66 -3.5965076282663491 67 -3.596501442095255 68 -3.596501442095255 69 -3.596501442095255;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX";
	rename -uid "71EE2AA8-4B63-5F94-13E2-F1B005580633";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.2080860180274882 1 3.192691306581366
		 2 3.1805736367304047 3 3.1706614170980689 4 3.161644088380966 5 3.1527659297814736
		 6 3.144365380591049 7 3.1382530721505777 8 3.1377599898962454 9 3.1476974487208755
		 10 3.1738394337621352 11 3.2220324977919712 12 3.2807682065192814 13 3.3341524580190538
		 14 3.3808171862033349 15 3.4194078246427373 16 3.4486287688407442 17 3.4671656285447039
		 18 3.5458227799086406 19 3.7173948730598205 20 3.9208366422772714 21 4.092865772302698
		 22 4.1780085917454226 23 4.2005164877756744 24 4.2189930503913775 25 4.2336712144620607
		 26 4.2446994616317619 27 4.2522169197155542 28 4.2563445333358843 29 4.2572171473380047
		 30 4.2548917165709099 31 4.2495084909729472 32 4.2410663072893033 33 4.2296533082184364
		 34 4.1749206107174555 35 4.0466397985974725 36 3.8591255447506487 37 3.5858362020813712
		 38 3.2059886509894375 39 2.7350240036301576 40 2.2078452396541666 41 1.8367054098559585
		 42 1.4418275469075326 43 1.0412892091637365 44 1.3031292059032995 45 1.5264280465451876
		 46 1.6743586156818773 47 1.7320613309903112 48 1.6885850269638352 49 1.5605739363513591
		 50 1.3951373140469123 51 1.299027626236184 52 1.1964311979797833 53 1.1060424573739149
		 54 1.106043840062553 55 1.106042375498395 56 1.1060423754983952 57 1.1060432887846388
		 58 1.1060415355928646 59 1.1060425526264115 60 1.1060423754983926 61 1.1060419199942366
		 62 1.1060425526264182 63 1.1060423811583981 64 1.1060394153872455 65 1.1060425526264166
		 66 1.1060423754983806 67 1.1060415355928528 68 1.1060415355928528 69 1.1060415355928528;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY";
	rename -uid "556BAC2F-4AB3-1EFB-BCFB-56A4293F80A3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -5.7924688492688912 1 -5.7443368667034624
		 2 -5.5851752181807361 3 -5.341378127701387 4 -5.0392201377176198 5 -4.7039715948316783
		 6 -4.3588358226931083 7 -4.0247876217488328 8 -3.7206359376392082 9 -3.4635166916863183
		 10 -3.2702824689906769 11 -3.1592803167063863 12 -3.097615253070495 13 -3.0398755896677359
		 14 -2.9880251338266506 15 -2.9440880844641266 16 -2.9101852395583836 17 -2.8883883642955248
		 18 -2.8264850334586753 19 -2.6793250805097264 20 -2.4682095019585173 21 -2.2522913582874531
		 22 -2.1250855508818733 23 -2.0810275146357844 24 -2.044224510978192 25 -2.0146871459917803
		 26 -1.9922875444431818 27 -1.9769244175664513 28 -1.9684236260212253 29 -1.966655307717142
		 30 -1.9714196407006053 31 -1.9825036277800139 32 -1.999720190497257 33 -2.0228134002055009
		 34 -2.1220407892248976 35 -2.3362861080493782 36 -2.6168539844389715 37 -2.9826498145007068
		 38 -3.4272453670114533 39 -3.8510662140373149 40 -4.1702110797641128 41 -4.2794520575094142
		 42 -4.3242110936551033 43 -4.3263589003134335 44 -4.2534622429397135 45 -4.1854660138823689
		 46 -4.1409732517530351 47 -4.1305321250617881 48 -4.1591161546180961 49 -4.2163819111404637
		 50 -4.2798073771201537 51 -4.3064346001354634 52 -4.3321522580220622 53 -4.3524907154406023
		 54 -4.3524935077727829 55 -4.352472247369203 56 -4.3524722473692057 57 -4.3524808123694188
		 58 -4.3524698476129062 59 -4.3524738509962306 60 -4.3524722473692092 61 -4.3524708332858593
		 62 -4.3524738509962306 63 -4.3524802022647817 64 -4.3524784798064271 65 -4.3524738509962235
		 66 -4.3524722473692208 67 -4.3524698476129045 68 -4.3524698476129045 69 -4.3524698476129045;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ";
	rename -uid "E0C416F4-4C0F-27C7-C3BE-A2AC72B0C9A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.9248365960476441 1 -9.0117823199067075
		 2 -9.4217900635776779 3 -10.095920908758833 4 -10.975112992633825 5 -11.99994663059843
		 6 -13.110526622988763 7 -14.246379760004967 8 -15.346643115989888 9 -16.350183250560679
		 10 -17.195925932111596 11 -17.823193649730928 12 -18.306156697501045 13 -18.750457789126383
		 14 -19.143106317596089 15 -19.471089147680168 16 -19.721446106443629 17 -19.881197269547023
		 18 -20.485941122201535 19 -21.806987974448909 20 -23.413504444262639 21 -24.821845335999477
		 22 -25.553187824624139 23 -25.768449495494 24 -25.946956002463185 25 -26.089672427114813
		 26 -26.197525013568246 27 -26.271373186550903 28 -26.312090534526117 29 -26.320630843155094
		 30 -26.297826631111178 31 -26.244661773361099 32 -26.161905090651363 33 -26.050494417400863
		 34 -25.47839941634998 35 -24.170130258182056 36 -22.361303356831694 37 -19.921542050829856
		 38 -16.798673176993802 39 -13.346262534485103 40 -9.921883572722054 41 -7.867842895781016
		 42 -5.6925162007480914 43 -3.4071929770510536 44 -5.0039954817630079 45 -6.3518562399856551
		 46 -7.2157093937391243 47 -7.5072514345871086 48 -7.1763437660897544 49 -6.3417701463060725
		 50 -5.2994636601799572 51 -4.7362339686839379 52 -4.1365604525174939 53 -3.6094221060449589
		 54 -3.6094275422644047 55 -3.60941380809644 56 -3.6094138080964098 57 -3.6094350890250917
		 58 -3.6094336133939287 59 -3.6094330089744227 60 -3.6094138080964142 61 -3.609413055519616
		 62 -3.6094330089744489 63 -3.6094210875163903 64 -3.6094117686862068 65 -3.6094330089744529
		 66 -3.6094138080963929 67 -3.6094336133939118 68 -3.6094336133939118 69 -3.6094336133939118;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX";
	rename -uid "9C7683D7-475C-1BA9-A10C-D1BCE5979AA8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.064637370219332038 1 0.074201138301744629
		 2 0.13990443623868054 3 0.24812187699425683 4 0.38496565108626107 5 0.53760153371499431
		 6 0.69522554754364541 7 0.84938759538343844 8 0.99413458152973166 9 1.1255029327207788
		 10 1.2406392066638274 11 1.3360063639226247 12 1.4171254620120433 13 1.4916738340420499
		 14 1.5574979573567211 15 1.6124208548039165 16 1.6543110759580038 17 1.6810266394986564
		 18 1.7798311241409475 19 2.0010990026479987 20 2.280897846219792 21 2.5352660380207772
		 22 2.6707999701539622 23 2.7116035593577186 24 2.7453954370106204 25 2.7723717064475588
		 26 2.7927316273922131 27 2.8066610183525498 28 2.814355553670187 29 2.8159659883975312
		 30 2.8116638917240118 31 2.8016260924768637 32 2.7860063359703262 33 2.7649645655263662
		 34 2.6695516560307668 35 2.4545662517153626 36 2.1557664295402352 37 1.7407244170275662
		 38 1.1941412333586503 39 0.57716841830892018 40 -0.039290810411009916 41 -0.41808694181144584
		 42 -0.78688966938477722 43 -1.1402412187524753 44 -0.87515912144450292 45 -0.64624652569561758
		 46 -0.49486084380151396 47 -0.43910726213520923 48 -0.49100337613867479 49 -0.63097352155849018
		 50 -0.8067780269098429 51 -0.90402637330261681 52 -1.0065449026746451 53 -1.0957517325840351
		 54 -1.0957518111041404 55 -1.0957547594746135 56 -1.0957535364330881 57 -1.0957520319207159
		 58 -1.0957543652882518 59 -1.0957520391045714 60 -1.0957535364330842 61 -1.0957486258327931
		 62 -1.0957520391045759 63 -1.0957506727184625 64 -1.0957499138643951 65 -1.0957506420976992
		 66 -1.0957547594746069 67 -1.0957543652882542 68 -1.0957543652882542 69 -1.0957543652882542;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY";
	rename -uid "A871E98E-4842-7CA9-1DCD-CEB5EE4F03E4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -6.6185561659308041 1 -6.5689583842584565
		 2 -6.4232841757513182 3 -6.2042293501428265 4 -5.9343340178277657 5 -5.6353082386105147
		 6 -5.3278021788599252 7 -5.0310795473810161 8 -4.7632756249426071 9 -4.541785990988366
		 10 -4.3841495557457053 11 -4.3093271662638477 12 -4.28296022888793 13 -4.2574661935810614
		 14 -4.2339507272050252 15 -4.2136090057035371 16 -4.1976552734205779 17 -4.1872560915993153
		 18 -4.1700652212650375 19 -4.1219471492658375 20 -4.0325803089476961 21 -3.924059536892285
		 22 -3.8524378197249538 23 -3.8242935288668596 24 -3.8006892810691038 25 -3.7816242666493136
		 26 -3.7671428705103627 27 -3.7571844687188625 28 -3.7516652130374117 29 -3.7504835685592939
		 30 -3.7535812486861446 31 -3.7607797349104151 32 -3.7719394347240018 33 -3.7868871909229389
		 34 -3.8482821772205806 35 -3.9760856336856842 36 -4.1341399100859295 37 -4.3264707884749374
		 38 -4.5375228792566498 39 -4.6869486055843019 40 -4.7175092741966509 41 -4.6375007241378938
		 42 -4.4894820487262193 43 -4.3013664968020819 44 -4.361519485632086 45 -4.4076161505915339
		 46 -4.4386649762226158 47 -4.4568903942301317 48 -4.4614084501928062 49 -4.4510369251147441
		 50 -4.4283201713125111 51 -4.4061399507783889 52 -4.3800783682465454 53 -4.3550930681535949
		 54 -4.3550921888613683 55 -4.3551010633474343 56 -4.3550960256022169 57 -4.3550804278531983
		 58 -4.3550742683273089 59 -4.3550847057733417 60 -4.3550960256022178 61 -4.3550905066073708
		 62 -4.3550847057733408 63 -4.3550832934041788 64 -4.3550952388140844 65 -4.3550851224281386
		 66 -4.3551010633474352 67 -4.355074268327308 68 -4.355074268327308 69 -4.355074268327308;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ";
	rename -uid "EAA7005C-4350-79AA-6251-BDB5083C0E26";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.7662276798657999 1 -8.8558292317558713
		 2 -9.274471460712725 3 -9.9614347657102194 4 -10.855898382081184 5 -11.896876762057852
		 6 -13.023178901572516 7 -14.17338935973028 8 -15.286066316173372 9 -16.299609404256596
		 10 -17.152780834801291 11 -17.784606783757678 12 -18.270432349276771 13 -18.717403592468138
		 14 -19.112508507882453 15 -19.442548289291288 16 -19.694462574115281 17 -19.855195709953072
		 18 -20.463256834674006 19 -21.792036450769039 20 -23.409319371091538 21 -24.828202112139987
		 22 -25.565508731009913 23 -25.782644849245141 24 -25.962778128749367 25 -26.106815970959122
		 26 -26.215549567981792 27 -26.290021024606517 28 -26.33114006832421 29 -26.339750119184551
		 30 -26.316780842799911 31 -26.263080565279722 32 -26.179602933805445 33 -26.067218105760727
		 34 -25.490752622700061 35 -24.172812523952906 36 -22.350938135013365 37 -19.89390877233296
		 38 -16.750065999665882 39 -13.277890688425323 40 -9.839862392301006 41 -7.7822471117145895
		 42 -5.6071819803868275 43 -3.3250248555100148 44 -4.9222927857700656 45 -6.2712221680840115
		 46 -7.1359648397550677 47 -7.4276901126594481 48 -7.0959172717899985 49 -6.2597793978364464
		 50 -5.216149346345567 51 -4.6526317072968277 52 -4.0528197035326876 53 -3.5257345804835647
		 54 -3.5257318638016999 55 -3.5257498826555058 56 -3.5257485367787402 57 -3.5257348172914686
		 58 -3.525732540906076 59 -3.5257323738627568 60 -3.5257485367787598 61 -3.5257624409629491
		 62 -3.5257323738627662 63 -3.5257330396594768 64 -3.5257614115452642 65 -3.525743481318619
		 66 -3.5257498826554983 67 -3.5257325409060711 68 -3.5257325409060711 69 -3.5257325409060711;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA";
	rename -uid "C81E1EC6-41C3-F6A5-9BCD-2EB2B42CEE18";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 6.0625362396240234 1 6.0676326751708984
		 2 6.0768852233886719 3 6.0964984893798828 4 6.1243724822998047 5 6.1577167510986328
		 6 6.1934452056884766 7 6.2285308837890625 8 6.2602443695068359 9 6.2861537933349609
		 10 6.2932968139648438 11 6.2703018188476563 12 6.2212905883789062 13 6.1559963226318359
		 14 6.0819797515869141 15 6.0045661926269531 16 5.9355583190917969 17 5.8944072723388672
		 18 5.9103164672851562 19 5.8596210479736328 20 5.7232170104980469 21 5.5339431762695313
		 22 5.3354129791259766 23 5.1756191253662109 24 5.0804061889648437 25 5.0562038421630859
		 26 5.0992641448974609 27 5.1595687866210938 28 5.1578807830810547 29 5.0773162841796875
		 30 4.9808368682861328 31 4.8382492065429687 32 4.6643447875976563 33 4.4995498657226563
		 34 4.3605670928955078 35 4.2767124176025391 36 4.1877574920654297 37 4.0918045043945313
		 38 4.0076675415039062 39 4.0334491729736328 40 4.3510627746582031 41 4.8606357574462891
		 42 5.297332763671875 43 5.4626178741455078 44 5.2998008728027344 45 4.9081325531005859
		 46 4.3958587646484375 47 3.8786125183105469 48 3.4971866607666016 49 3.3944816589355469
		 50 3.640838623046875 51 4.3591423034667969 52 5.6177539825439453 53 6.5388545989990234
		 54 7.5509490966796875 55 6.93359375 56 6.394561767578125 57 6.1001529693603516 58 5.9897403717041016
		 59 6.1165561676025391 60 6.4057426452636719 61 6.7232246398925781 62 7.0653018951416016
		 63 7.2253341674804687 64 7.1680736541748047 65 7.1261520385742187 66 7.1709403991699219
		 67 7.2469844818115234 68 7.2469844818115234 69 7.2469844818115234;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA";
	rename -uid "88AFF16E-4E9F-CCA9-D084-E184928FAD67";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 44.210350036621094 1 44.31689453125 2 44.354698181152344
		 3 44.352958679199219 4 44.280033111572266 5 44.105205535888672 6 43.79901123046875
		 7 43.333431243896484 8 42.681755065917969 9 41.818141937255859 10 40.771598815917969
		 11 39.47283935546875 12 37.796028137207031 13 35.668972015380859 14 32.968070983886719
		 15 29.529006958007812 16 25.384489059448242 17 20.712810516357422 18 20.677820205688477
		 19 20.669197082519531 20 20.560512542724609 21 20.340669631958008 22 20.005256652832031
		 23 19.575275421142578 24 19.076799392700195 25 18.559528350830078 26 18.14314079284668
		 27 17.847560882568359 28 17.679649353027344 29 17.610504150390625 30 17.6124267578125
		 31 17.895076751708984 32 18.624601364135742 33 19.836774826049805 34 21.598705291748047
		 35 23.875766754150391 36 26.721652984619141 37 29.807699203491211 38 32.653621673583984
		 39 34.006561279296875 40 35.379547119140625 41 36.538032531738281 42 37.548965454101563
		 43 37.900733947753906 44 37.478023529052734 45 36.44927978515625 46 35.028759002685547
		 47 33.418777465820313 48 31.800146102905273 49 30.543720245361328 50 29.022966384887695
		 51 27.208887100219727 52 25.068655014038086 53 23.722238540649414 54 22.400199890136719
		 55 22.684000015258789 56 22.794767379760742 57 22.610712051391602 58 23.01518440246582
		 59 22.885931015014648 60 22.314199447631836 61 21.662778854370117 62 20.874753952026367
		 63 20.459239959716797 64 20.485963821411133 65 20.487127304077148 66 20.427940368652344
		 67 20.33244514465332 68 20.33244514465332 69 20.33244514465332;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA";
	rename -uid "B32CBBEE-4D45-604F-4F7F-D496ABB5CEE3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -17.501928329467773 1 -15.167047500610352
		 2 -12.71436882019043 3 -10.139400482177734 4 -7.4649066925048828 5 -4.7147884368896484
		 6 -1.9138579368591309 7 0.91243171691894531 8 3.7384271621704102 9 6.5386466979980469
		 10 9.2446479797363281 11 11.818838119506836 12 14.299909591674805 13 16.737691879272461
		 14 19.162586212158203 15 21.558612823486328 16 23.821708679199219 17 25.860877990722656
		 18 27.589519500732422 19 29.555740356445313 20 31.43553352355957 21 33.216419219970703
		 22 34.883155822753906 23 36.418121337890625 24 37.677509307861328 25 38.581581115722656
		 26 39.292892456054688 27 39.876602172851563 28 40.372138977050781 29 40.748603820800781
		 30 40.950687408447266 31 40.937210083007813 32 40.769569396972656 33 40.593910217285156
		 34 40.549957275390625 35 40.846698760986328 36 41.952423095703125 37 43.999832153320312
		 38 46.433917999267578 39 48.372810363769531 40 50.043663024902344 41 51.256454467773438
		 42 51.955390930175781 43 52.237899780273437 44 52.138332366943359 45 51.714496612548828
		 46 51.004806518554687 47 50.033409118652344 48 48.868179321289063 49 47.617042541503906
		 50 46.319808959960938 51 44.949970245361328 52 43.732547760009766 53 43.258068084716797
		 54 43.105278015136719 55 42.636566162109375 56 42.268768310546875 57 42.202312469482422
		 58 42.434085845947266 59 42.590518951416016 60 42.646984100341797 61 42.609016418457031
		 62 42.574146270751953 63 42.726638793945313 64 42.674179077148438 65 42.641452789306641
		 66 42.666107177734375 67 42.712192535400391 68 42.712192535400391 69 42.712192535400391;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX";
	rename -uid "198E5341-49B3-8358-4C92-58A85D30C015";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -4.2015858205086758e-006 1 -1.5057632946510999e-006
		 2 -1.8322097752969844e-006 3 4.2171888515933571e-006 4 -9.8460615078224799e-006 5 -3.3171708804320232e-006
		 6 3.2331048978575914e-010 7 -6.4811511042392144e-006 8 -3.2242231917068968e-006 9 -3.1090705804822951e-006
		 10 1.385284943289021e-008 11 -1.3302072120310354e-006 12 -3.0166187027696204e-006
		 13 1.3278485048134974e-008 14 -3.1496029668495061e-006 15 -2.4618734802278396e-006
		 16 -1.5037716135571865e-006 17 3.2300633669400892e-008 18 3.3462776746246728e-008
		 19 -2.8063579699869524e-006 20 -3.6186033387248235e-006 21 -7.7219722390433739e-009
		 22 -4.8422528200115558e-006 23 6.9756368550684426e-011 24 3.609412966121813e-009
		 25 -1.2753044506115048e-006 26 2.6587869135732686e-006 27 -7.2547726055308215e-008
		 28 -8.3436868125851803e-008 29 -5.011060065605059e-006 30 -1.512368158861132e-006
		 31 -9.9667626242287725e-006 32 -5.6966585770824409e-006 33 -1.8918736404143528e-006
		 34 -5.1944865652466859e-006 35 -4.8214439372117825e-006 36 3.5228400304835229e-006
		 37 3.0388604519833465e-008 38 -3.6616277339843356e-006 39 1.4850031595414084e-007
		 40 -1.8863502547679624e-006 41 -1.8866251803212035e-006 42 -6.3040441654504887e-006
		 43 -1.6929540538790896e-006 44 2.7258254756734759e-006 45 -7.0777436227473796e-006
		 46 -6.4285205724950256e-006 47 -9.8681691975224336e-006 48 -5.5093965176319316e-006
		 49 -5.5093965176319316e-006 50 -5.5093965176319316e-006 51 -5.5093965176319316e-006
		 52 -5.5093965176319316e-006 53 -5.5093965176319316e-006 54 -5.5093965176319316e-006
		 55 -5.5093965176319316e-006 56 -5.5093965176319316e-006 57 -5.5093965176319316e-006
		 58 -5.5093965176319316e-006 59 -5.5093965176319316e-006 60 -5.5093965176319316e-006
		 61 -5.5093965176319316e-006 62 -5.5093965176319316e-006 63 -5.5093965176319316e-006
		 64 -5.5093965176319316e-006 65 -5.5093965176319316e-006 66 -5.5093965176319316e-006
		 67 -5.5093965176319316e-006 68 -5.5093965176319316e-006 69 -5.5093965176319316e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY";
	rename -uid "73C6658F-470D-8872-66BE-D8B0793A5661";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 18.737108336081654 1 18.737108446568726
		 2 18.73711204139536 3 18.737109291298186 4 18.73711424176653 5 18.737110103103046
		 6 18.737107253291015 7 18.737109430776648 8 18.737108183061952 9 18.737105409021339
		 10 18.737109481666238 11 18.737108707327053 12 18.737106301624468 13 18.737113513654457
		 14 18.737109048859327 15 18.737107198238892 16 18.737106834371065 17 18.737106718973301
		 18 18.737110083924431 19 18.737110537610281 20 18.737110784534043 21 18.737103315162447
		 22 18.737100444088512 23 18.737109939815102 24 18.737102561665246 25 18.737105320799888
		 26 18.737108580620635 27 18.73711507317552 28 18.73710816972617 29 18.737112407266313
		 30 18.737106306216475 31 18.737106175765593 32 18.737101780665327 33 18.737111392586431
		 34 18.737103490237935 35 18.737109167737842 36 18.737109105027081 37 18.737110996389067
		 38 18.737110407674717 39 18.737110923424446 40 18.737110604688599 41 18.737109970422509
		 42 18.737110578224435 43 18.737110364931922 44 18.737112186380063 45 18.737112247080404
		 46 18.737110119819281 47 18.737108420294192 48 18.7371116256524 49 18.7371116256524
		 50 18.7371116256524 51 18.7371116256524 52 18.7371116256524 53 18.7371116256524 54 18.7371116256524
		 55 18.7371116256524 56 18.7371116256524 57 18.7371116256524 58 18.7371116256524 59 18.7371116256524
		 60 18.7371116256524 61 18.7371116256524 62 18.7371116256524 63 18.7371116256524 64 18.7371116256524
		 65 18.7371116256524 66 18.7371116256524 67 18.7371116256524 68 18.7371116256524 69 18.7371116256524;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ";
	rename -uid "15935FDC-464D-C222-F3FC-1AA4A4B45F2B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.7085207992567573 1 2.5897297556463839
		 2 2.2527371877149975 3 1.7266503396015012 4 1.0405461696738005 5 0.22353479765036952
		 6 -0.69530418208906541 7 -1.686883391078176 8 -2.7220902166102769 9 -3.7718458758060529
		 10 -4.8070570551605396 11 -5.7986269443470055 12 -6.7174626940035864 13 -7.5344807495621016
		 14 -8.2205847725776433 15 -8.7466733572382278 16 -9.0836580055319871 17 -9.2024503919299825
		 18 -8.9064528341496327 19 -8.0328198977243463 20 -6.6031003812953086 21 -4.6388343339376936
		 22 -2.1615860681054682 23 0.80711593798954306 24 4.2457173213853974 25 8.1326553043734133
		 26 12.446407280813835 27 17.165400948830445 28 22.268118709028549 29 27.732976122175437
		 30 33.538467491318933 31 39.66300456768802 32 46.085084366544351 33 52.783121197547267
		 34 59.735550874442517 35 66.920886750635773 36 74.31757809162076 37 81.904000999082612
		 38 89.658660033423416 39 90.36684383984236 40 90.988870840720622 41 91.483777063289864
		 42 91.810704864894205 43 91.928779692352933 44 91.769733893197497 45 91.363231295622342
		 46 90.815343755455558 47 90.232113381507276 48 89.719591391014546 49 89.719591391014546
		 50 89.719591391014546 51 89.719591391014546 52 89.719591391014546 53 89.719591391014546
		 54 89.719591391014546 55 89.719591391014546 56 89.719591391014546 57 89.719591391014546
		 58 89.719591391014546 59 89.719591391014546 60 89.719591391014546 61 89.719591391014546
		 62 89.719591391014546 63 89.719591391014546 64 89.719591391014546 65 89.719591391014546
		 66 89.719591391014546 67 89.719591391014546 68 89.719591391014546 69 89.719591391014546;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "4E5D2B38-4DFE-96EF-AB0B-5FAB8ECB3E7A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 24.705314636230469 1 24.710159301757813
		 2 24.721057891845703 3 24.738910675048828 4 24.76447868347168 5 24.798397064208984
		 6 24.841268539428711 7 24.893682479858398 8 24.95623779296875 9 25.029533386230469
		 10 25.146434783935547 11 25.347297668457031 12 25.633487701416016 13 25.977401733398438
		 14 26.306930541992187 15 26.500764846801758 16 26.600345611572266 17 26.757349014282227
		 18 27.206878662109375 19 27.194496154785156 20 27.103912353515625 21 26.868934631347656
		 22 26.480356216430664 23 26.012468338012695 24 25.600793838500977 25 25.387712478637695
		 26 25.518730163574219 27 25.602317810058594 28 25.624776840209961 29 25.786516189575195
		 30 26.015552520751953 31 26.121599197387695 32 26.000320434570312 33 25.708942413330078
		 34 25.340488433837891 35 24.999267578125 36 24.767671585083008 37 24.68834114074707
		 38 24.748895645141602 39 24.914300918579102 40 25.238533020019531 41 25.570953369140625
		 42 25.461399078369141 43 24.700300216674805 44 23.549703598022461 45 22.43658447265625
		 46 21.847423553466797 47 22.125143051147461 48 23.462949752807617 49 25.804834365844727
		 50 29.133907318115234 51 33.266609191894531 52 37.681682586669922 53 38.518817901611328
		 54 39.178691864013672 55 37.944671630859375 56 36.858112335205078 57 36.219329833984375
		 58 36.143192291259766 59 36.740089416503906 60 37.769638061523438 61 38.487247467041016
		 62 39.352146148681641 63 39.562042236328125 64 39.640796661376953 65 39.638889312744141
		 66 39.646854400634766 67 39.659164428710938 68 39.659164428710938 69 39.659164428710938;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "70972453-48D8-3368-C116-ACA1A3EF839B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 16.93992805480957 1 17.22552490234375
		 2 17.479482650756836 3 17.693962097167969 4 17.862846374511719 5 17.982261657714844
		 6 18.050146102905273 7 18.065866470336914 8 18.029455184936523 9 17.9407958984375
		 10 18.930999755859375 11 21.421197891235352 12 24.280635833740234 13 26.405517578125
		 14 26.828392028808594 15 24.656194686889648 16 20.776027679443359 17 16.91773796081543
		 18 17.117755889892578 19 17.220180511474609 20 16.995758056640625 21 16.410722732543945
		 22 15.411511421203613 23 13.978120803833008 24 12.168522834777832 25 10.246381759643555
		 26 9.4049062728881836 27 9.0981197357177734 28 8.9914150238037109 29 8.7574748992919922
		 30 8.9390535354614258 31 10.573528289794922 32 14.24091625213623 33 19.918876647949219
		 34 27.719841003417969 35 37.088550567626953 36 46.947547912597656 37 56.035449981689453
		 38 63.448947906494141 39 66.620872497558594 40 67.72943115234375 41 67.379074096679688
		 42 66.469375610351563 43 65.181060791015625 44 63.487159729003906 45 60.920318603515625
		 46 57.106239318847656 47 52.237785339355469 48 46.682777404785156 49 41.308765411376953
		 50 35.070663452148437 51 27.434091567993164 52 19.206928253173828 53 15.985140800476074
		 54 12.962186813354492 55 14.923117637634277 56 17.278861999511719 57 18.664031982421875
		 58 18.091716766357422 59 15.644628524780273 60 12.391337394714355 61 10.544539451599121
		 62 8.4385185241699219 63 8.1896562576293945 64 8.1031742095947266 65 8.0977582931518555
		 66 8.0871009826660156 67 8.0714168548583984 68 8.0714168548583984 69 8.0714168548583984;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "F8829213-4709-61A4-AD7A-88B38E0C9906";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -18.402778625488281 1 -17.698099136352539
		 2 -16.944698333740234 3 -16.151556015014648 4 -15.32811164855957 5 -14.483565330505371
		 6 -13.626184463500977 7 -12.762849807739258 8 -11.898781776428223 9 -11.03769588470459
		 10 -9.7462253570556641 11 -7.6663036346435547 12 -4.9924888610839844 13 -2.0549964904785156
		 14 0.69759654998779297 15 2.7521114349365234 16 4.1245136260986328 17 5.0819168090820313
		 18 5.1809139251708984 19 6.6986007690429687 20 7.4429130554199219 21 7.6331443786621094
		 22 7.4792194366455078 23 7.1451263427734375 24 6.7349185943603516 25 6.4799461364746094
		 26 7.9548797607421875 27 9.1181907653808594 28 10.151021957397461 29 11.144493103027344
		 30 11.785499572753906 31 11.661600112915039 32 10.961681365966797 33 10.351222991943359
		 34 10.609687805175781 35 12.715082168579102 36 17.479978561401367 37 24.813720703125
		 38 33.896171569824219 39 38.968994140625 40 43.926811218261719 41 47.695152282714844
		 42 49.268169403076172 43 48.440650939941406 44 45.405208587646484 45 40.824131011962891
		 46 35.622684478759766 47 30.275253295898437 48 25.288381576538086 49 21.277444839477539
		 50 17.700765609741211 51 16.18365478515625 52 16.065303802490234 53 15.960687637329102
		 54 16.172933578491211 55 15.141830444335938 56 14.224021911621094 57 13.870731353759766
		 58 14.22332763671875 59 14.866559982299805 60 15.742660522460937 61 16.175857543945313
		 62 16.744108200073242 63 16.84846305847168 64 16.872879028320313 65 16.853107452392578
		 66 16.850238800048828 67 16.850509643554688 68 16.850509643554688 69 16.850509643554688;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "D0095881-4C82-B638-A784-BE97294EEC0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -27.774002159068981 1 -28.020656868386016
		 2 -28.189532059930013 3 -28.267302120158366 4 -28.243926806374763 5 -28.112304844105463
		 6 -27.867888351983623 7 -27.507744554462761 8 -27.029604053787711 9 -26.430821003330919
		 10 -25.603168444095406 11 -24.335038964414615 12 -22.473631863754584 13 -20.039881318765858
		 14 -17.463559543966856 15 -15.710669098928824 16 -14.583490363206984 17 -12.890310488241262
		 18 -13.255211161449809 19 -14.429492186757114 20 -17.61398146037379 21 -22.28362895917801
		 22 -27.753007875248052 23 -33.291778363120052 24 -38.385502881107953 25 -42.962009901658519
		 26 -47.424145652552546 27 -52.157959771539169 28 -56.514671930045019 29 -59.80289225879563
		 30 -62.072161467526861 31 -63.285916891563687 32 -63.943843565173481 33 -64.394358768777437
		 34 -64.414990814130036 35 -63.795131381558484 36 -62.366069957397983 37 -60.116608197051761
		 38 -57.22565798609282 39 -54.637306168092486 40 -52.126126826497163 41 -49.878785247196099
		 42 -48.420951703516018 43 -48.168603350324211 44 -49.501883530238068 45 -52.395315538242762
		 46 -56.465955540325467 47 -61.76796186313036 48 -67.893747051041615 49 -73.567607779730494
		 50 -78.367584934920302 51 -80.742637533267768 52 -79.164497696365927 53 -76.63823012882402
		 54 -73.792239553280169 55 -74.957701927511991 56 -76.257748115424334 57 -78.172731189174272
		 58 -80.463370312858856 59 -82.081941789864686 60 -82.216120934353725 61 -81.075376809744455
		 62 -79.013937184898367 63 -77.915333145090401 64 -77.394699306638742 65 -77.394676705019165
		 66 -77.394710008852272 67 -77.394680858264195 68 -77.394680858264195 69 -77.394680858264195;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "B557C6EE-4121-F9BD-A874-178D1A42DAD7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 11.793275841190637 1 11.758399370756736
		 2 11.721118614863361 3 11.683785320273882 4 11.648613074374268 5 11.617957359769205
		 6 11.593916529682991 7 11.578353467608537 8 11.572995822372997 9 11.579151641644609
		 10 11.713410067294639 11 12.052554161713818 12 12.53088377488031 13 13.03119275642284
		 14 13.398476366391913 15 13.496932309800659 16 13.433925528098387 17 13.371614964534961
		 18 11.030089640831179 19 10.610181990867698 20 9.7748653062798745 21 9.3732041534965962
		 22 10.044382705975897 23 11.927143405984564 24 14.583748737084154 25 17.201343577075217
		 26 19.297458209677938 27 21.151944191082315 28 22.729769468991552 29 23.577789143587566
		 30 23.858918369278829 31 24.039422711066372 32 24.428907359431552 33 24.94440732579141
		 34 25.543906645210374 35 26.147394773969907 36 26.633525001145092 37 26.845733190799987
		 38 26.655790714241189 39 25.866582992556207 40 25.015075138205599 41 24.257538909130137
		 42 24.349968637953754 43 25.889163695225875 44 28.6770282608191 45 32.097203679014243
		 46 35.29033469976067 47 37.268079380888501 48 36.912830509918173 49 33.88189941490559
		 50 27.569885312505804 51 17.617551737268617 52 6.2535260471567584 53 1.4075011251705027
		 54 -2.315082859608748 55 0.45225603667698155 56 3.9010094514243367 57 8.443253003595343
		 58 13.198525496515362 59 15.714025351069708 60 14.630056233291487 61 11.25610768354127
		 62 6.7393579971610578 63 4.7022093799079254 64 3.7884819395347562 65 3.7884778459590298
		 66 3.7884935035046357 67 3.78846912794008 68 3.78846912794008 69 3.78846912794008;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "014F09D5-4742-7DFA-BE77-E291CD841FE8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -10.620369620049361 1 -7.3095080790234075
		 2 -3.8171607259278768 3 -0.17754429687026885 4 3.5768657476372434 5 7.4172734786148329
		 6 11.32020606568746 7 15.268953840602844 8 19.254547690496231 9 23.276275705402433
		 10 27.781426081661294 11 33.40798395088234 12 40.262841707216303 13 47.870079523883277
		 14 54.958952500251272 15 59.445869891150245 16 62.256815972540515 17 66.29417149123212
		 18 69.200207831387857 19 70.901915881405415 20 74.30782572279081 21 78.620871693896831
		 22 82.928721838886332 23 86.163389233371362 24 87.170299829163852 25 85.135249825282401
		 26 81.164546658179603 27 77.432781720196402 28 74.480438292135219 29 71.40381790854218
		 30 68.708465321927989 31 68.360562770425261 32 71.153924861140013 33 76.988770691775869
		 34 86.419565385732653 35 99.054350414992811 36 114.22649828399602 37 131.19378872189475
		 38 149.13539826781047 39 159.7479262234306 40 169.42290349830535 41 177.41494173112855
		 42 182.31257083091168 43 183.09720719102057 44 179.71225695186109 45 173.36380017001974
		 46 165.20456160723464 47 154.71102379758753 48 141.91822865259962 49 128.8862912462391
		 50 114.0836269974551 51 97.204830865390889 52 80.040933891538231 53 69.584704888529345
		 54 59.811202279919591 55 64.997190479493426 56 71.867142890610381 57 78.684845560678838
		 58 82.782718141546354 59 82.180224374184746 60 77.402673357491565 61 71.662061454611305
		 62 64.550271109081478 63 62.650957707803009 64 61.776484166980843 65 61.776467044644427
		 66 61.776475183901177 67 61.776469989249584 68 61.776469989249584 69 61.776469989249584;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "02C168D8-4F11-36A1-9E3F-EEAF95138F63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -20.951248168945312 1 -20.962615966796875
		 2 -20.908332824707031 3 -20.796741485595703 4 -20.641933441162109 5 -20.462715148925781
		 6 -20.280624389648437 7 -20.117654800415039 8 -19.994287490844727 9 -19.929069519042969
		 10 -19.940309524536133 11 -20.098501205444336 12 -20.45001220703125 13 -20.976705551147461
		 14 -21.632472991943359 15 -22.332368850708008 16 -22.973403930664063 17 -23.469722747802734
		 18 -23.519077301025391 19 -23.853246688842773 20 -24.76317024230957 21 -26.079502105712891
		 22 -27.57481575012207 23 -28.922307968139648 24 -29.810489654541016 25 -30.141025543212891
		 26 -29.986196517944336 27 -29.626005172729492 28 -29.686031341552734 29 -30.517910003662109
		 30 -31.560861587524414 31 -32.684112548828125 32 -33.587650299072266 33 -34.148513793945313
		 34 -34.402336120605469 35 -34.379631042480469 36 -35.215492248535156 37 -37.201877593994141
		 38 -39.033374786376953 39 -39.245800018310547 40 -36.873725891113281 41 -32.778335571289063
		 42 -28.729793548583984 43 -26.329124450683594 44 -26.219440460205078 45 -27.773527145385742
		 46 -30.463857650756836 47 -33.712917327880859 48 -36.810554504394531 49 -39.137924194335938
		 50 -40.446258544921875 51 -40.531520843505859 52 -39.002223968505859 53 -35.73675537109375
		 54 -28.911109924316406 55 -29.97503662109375 56 -30.605279922485352 57 -30.699943542480469
		 58 -31.624292373657227 59 -31.793508529663086 60 -31.377241134643555 61 -30.562366485595703
		 62 -29.515007019042969 63 -28.491682052612305 64 -28.963077545166016 65 -29.220987319946289
		 66 -28.861845016479492 67 -28.26385498046875 68 -28.26385498046875 69 -28.26385498046875;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "430FDBBD-49B8-5C82-DD80-55961B1ADE18";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 16.371231079101562 1 16.644107818603516
		 2 17.182292938232422 3 17.896358489990234 4 18.698726654052734 5 19.506175994873047
		 6 20.24273681640625 7 20.841508865356445 8 21.245635986328125 9 21.408073425292969
		 10 21.288925170898437 11 21.105129241943359 12 21.059879302978516 13 21.070747375488281
		 14 21.021160125732422 15 20.785594940185547 16 20.270627975463867 17 19.438119888305664
		 18 19.274202346801758 19 19.738901138305664 20 20.26551628112793 21 20.688758850097656
		 22 20.846366882324219 23 20.634012222290039 24 20.133918762207031 25 19.681934356689453
		 26 19.625869750976563 27 19.549144744873047 28 19.763740539550781 29 20.478458404541016
		 30 20.269401550292969 31 19.361223220825195 32 18.6724853515625 33 18.6099853515625
		 34 19.685564041137695 35 22.046577453613281 36 27.868535995483398 37 37.911468505859375
		 38 50.158256530761719 39 58.211055755615234 40 65.379501342773438 41 70.435256958007812
		 42 73.149391174316406 43 73.586814880371094 44 72.418258666992188 45 69.801544189453125
		 46 66.301460266113281 47 62.328231811523438 48 58.1024169921875 49 54.074813842773438
		 50 49.87554931640625 51 45.520484924316406 52 40.776199340820313 53 34.724353790283203
		 54 25.288318634033203 55 22.275156021118164 56 18.5810546875 57 14.901933670043945
		 58 19.408710479736328 59 21.464557647705078 60 20.9744873046875 61 18.442424774169922
		 62 14.813472747802734 63 11.391536712646484 64 11.743816375732422 65 11.748451232910156
		 66 11.181324005126953 67 10.282552719116211 68 10.282552719116211 69 10.282552719116211;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "83387610-49B3-A94C-2560-05ADDFEE732E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -29.282697677612305 1 -28.543394088745117
		 2 -27.598997116088867 3 -26.47157096862793 4 -25.188959121704102 5 -23.785446166992188
		 6 -22.30169677734375 7 -20.783445358276367 8 -19.278881072998047 9 -17.834930419921875
		 10 -16.494562149047852 11 -15.274553298950195 12 -14.122122764587402 13 -12.968225479125977
		 14 -11.768203735351563 15 -10.530605316162109 16 -9.3215236663818359 17 -8.2251033782958984
		 18 -7.2288684844970703 19 -5.2442970275878906 20 -3.2870903015136719 21 -1.3916568756103516
		 22 0.3759002685546875 23 2.0830268859863281 24 3.7131080627441406 25 5.0044574737548828
		 26 5.9459075927734375 27 6.6266117095947266 28 7.2956180572509766 29 8.1316890716552734
		 30 8.5402965545654297 31 8.188140869140625 32 7.3555183410644531 33 6.4035358428955078
		 34 5.5221004486083984 35 5.0817184448242188 36 6.5229721069335937 37 11.167219161987305
		 38 19.12080192565918 39 26.786975860595703 40 34.803081512451172 41 41.866600036621094
		 42 47.434074401855469 43 51.579414367675781 44 54.650726318359375 45 56.707462310791016
		 46 57.510078430175781 47 56.825729370117188 48 54.774383544921875 49 51.63995361328125
		 50 47.101325988769531 51 41.231201171875 52 34.238113403320312 53 25.298603057861328
		 54 15.68604850769043 55 11.137392044067383 56 7.7355232238769531 57 6.0743122100830078
		 58 6.0586700439453125 59 6.5921878814697266 60 7.2097358703613281 61 7.7158679962158203
		 62 8.2398548126220703 63 8.89501953125 64 8.8614215850830078 65 8.8089599609375 66 8.8622989654541016
		 67 8.9742355346679687 68 8.9742355346679687 69 8.9742355346679687;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "CD835B24-4156-10C4-38C9-8D84694CD0FD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 33.469594939315115 1 33.85196948382827
		 2 34.866609111871576 3 36.474916552513456 4 38.579243698338828 5 41.024086426215909
		 6 43.603046583007647 7 46.069699731382379 8 48.150243057075841 9 49.553341638782328
		 10 49.972992384127927 11 48.292194830912798 12 44.049175142311761 13 37.992040228297419
		 14 31.011654073432886 15 24.086964090293641 16 18.118623508745141 17 13.734402531818228
		 18 12.642699723204611 19 12.762053960214718 20 13.03895413331416 21 13.337615018701147
		 22 13.468134331967683 23 13.235687478476319 24 12.533311373687592 25 11.420152452693481
		 26 10.081785091196734 27 8.4608412972240821 28 6.9377286071257629 29 5.6893158941773008
		 30 3.5245885386620603 31 1.409870482410899 32 0.40071593947415823 33 -0.59678987113766724
		 34 -2.727409110483491 35 -8.488577281656676 36 -16.885285293631881 37 -24.362392834058411
		 38 -26.380571253149125 39 -21.658418808110053 40 -13.080864601465326 41 -4.0202425431664164
		 42 2.4768730084723409 43 6.0158494498597994 44 8.1105880936851147 45 10.459295975961656
		 46 14.136917211050411 47 19.188563866124369 48 24.883305300561698 49 29.99435948723708
		 50 33.102971690489298 51 32.685897693641465 52 27.438759146664346 53 16.017934156618185
		 54 0.29131959610071001 55 -4.6961500532042058 56 -10.746676132530711 57 -16.520975650309424
		 58 -11.954797222992582 59 -8.5276593372997755 60 -6.7566581929184153 61 -6.6540528576055564
		 62 -7.8326830444351714 63 -9.3292466783453776 64 -8.9184947678864415 65 -8.8999716231148316
		 66 -9.5156141264385852 67 -10.395029283244165 68 -10.395029283244165 69 -10.395029283244165;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "2EC6E182-4190-7ED2-4B5C-5EBE1EBF1EB5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 5.1072154100015403 1 4.9480380791381178
		 2 4.8032527846120816 3 4.6624242412948469 4 4.5214265011640622 5 4.3788843500491588
		 6 4.2317435091225644 7 4.0723576590264701 8 3.8874925351979557 9 3.6608948971131432
		 10 3.3789587032000274 11 3.0676932841497599 12 2.7920044409504761 13 2.623391345463165
		 14 2.6013251068682099 15 2.6785242457448115 16 2.719146214687961 17 2.5590693480931055
		 18 2.2897660629669394 19 2.6363897752591829 20 3.6668395576806461 21 5.1892711814454842
		 22 6.9317399613656701 23 8.5458857501176784 24 9.6820752109738297 25 10.122291449493467
		 26 9.9466194530669938 27 9.5497744627071022 28 9.6699653724265833 29 10.714184271804386
		 30 12.275608674967932 31 13.29338043064471 32 13.317873678429958 33 13.164733204001966
		 34 13.397468494150592 35 14.098829875341023 36 13.964219179101509 37 12.845206540070849
		 38 13.738349329268452 39 17.201532365970749 40 17.815239951719448 41 14.277326630716502
		 42 8.2228696951439595 43 2.639399577238148 44 -0.79480737822777592 45 -2.4016238612619376
		 46 -2.9673543909046658 47 -3.1813844908806224 48 -3.4828553247751808 49 -3.5791161448379292
		 50 -2.3050596788202129 51 1.1561483818548448 52 5.9135907307612969 53 10.658417556729406
		 54 9.0871221735573755 55 11.726973983130414 56 12.783769992293442 57 11.956291954053203
		 58 12.965552408133801 59 12.936012701276121 60 12.596898014287854 61 12.411712755354991
		 62 12.381568884622491 63 12.285972628714152 64 12.566114164454868 65 12.752421646052893
		 66 12.600418664334649 67 12.312313486134897 68 12.312313486134897 69 12.312313486134897;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "15EC632C-4AE9-5FAC-10C3-228917F045C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 5.4586230562368376 1 8.5570029108649734
		 2 11.582816700762725 3 14.566426345396263 4 17.534989313608683 5 20.512726193706296
		 6 23.519961621210502 7 26.570921763919841 8 29.671620388162633 9 32.820236986554029
		 10 36.010615330209525 11 39.733267088850269 12 44.417166470032996 13 49.937771643413072
		 14 56.118773378140695 15 62.748449222697914 16 69.628206582719599 17 76.608246010635483
		 18 77.129948417987791 19 77.908383241826186 20 78.951942537926641 21 79.99549877551155
		 22 80.769175049680115 23 81.124282375044402 24 81.124788220731276 25 81.061838829134629
		 26 81.258722226825554 27 81.215935133267863 28 81.508779731063882 29 82.58194272751291
		 30 81.347538958170247 31 80.926705948502999 32 84.107402349890833 33 87.630131552345148
		 34 88.173062232122504 35 78.748406033251342 36 64.831443888273796 37 58.5917935396118
		 38 68.649511286587256 39 85.205198256786119 40 104.9412293464694 41 124.70587163572613
		 42 142.56429420180049 43 158.59034818215636 44 173.38503319401335 45 186.81400187620628
		 46 197.83338536812303 47 205.29100496515488 48 208.96153950908212 49 209.04126848194005
		 50 204.54573964562937 51 195.44249605790702 52 181.83416769122675 53 160.48681886658662
		 54 130.18874310910522 55 112.99921249803928 56 94.120439577377567 57 76.184699755012161
		 58 89.662011377050945 59 99.878300347005222 60 105.64831018379316 61 106.5321328365237
		 62 103.34187417070754 63 98.891312932167509 64 98.995129821351398 65 98.368294509174845
		 66 97.195837228203843 67 95.625510504397226 68 95.625510504397226 69 95.625510504397226;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA";
	rename -uid "36ED5BEB-4EDC-1002-16F5-0F9FB1868F70";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 30.561656951904297 1 28.626190185546875
		 2 24.095958709716797 3 18.417915344238281 4 12.957779884338379 5 8.9141960144042969
		 6 7.3957901000976563 7 8.0760736465454102 8 9.1823043823242187 9 10.333942413330078
		 10 11.811191558837891 11 13.359357833862305 12 14.384952545166016 13 14.071226119995117
		 14 13.599530220031738 15 12.986265182495117 16 12.377162933349609 17 12.037528991699219
		 18 11.474672317504883 19 12.055351257324219 20 13.570159912109375 21 15.300786972045898
		 22 16.530067443847656 23 16.652175903320313 24 16.409324645996094 25 15.795055389404297
		 26 15.049285888671875 27 14.517449378967285 28 14.348358154296875 29 14.521509170532227
		 30 15.087015151977539 31 16.175027847290039 32 17.804290771484375 33 19.869501113891602
		 34 21.984308242797852 35 23.749124526977539 36 25.329875946044922 37 26.906463623046875
		 38 28.238218307495117 39 28.526071548461914 40 28.091726303100586 41 27.564817428588867
		 42 27.031665802001953 43 26.872095108032227 44 26.609991073608398 45 26.119056701660156
		 46 25.506311416625977 47 24.826335906982422 48 24.188709259033203 49 23.775215148925781
		 50 23.623668670654297 51 24.038263320922852 52 25.055517196655273 53 25.766313552856445
		 54 26.514007568359375 55 25.580337524414063 56 24.659530639648438 57 23.944606781005859
		 58 23.393571853637695 59 23.095832824707031 60 23.385013580322266 61 23.702495574951172
		 62 24.044576644897461 63 24.204643249511719 64 24.1473388671875 65 24.105415344238281
		 66 24.150215148925781 67 24.22625732421875 68 24.22625732421875 69 24.22625732421875;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA";
	rename -uid "1D3B18C0-4CA0-4541-475C-7F9EC5CBD5B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 78.763381958007813 1 79.225601196289063
		 2 80.163917541503906 3 81.493843078613281 4 83.073936462402344 5 84.812820434570313
		 6 86.717430114746094 7 90.329208374023438 8 95.516815185546875 9 102.43051147460937
		 10 108.67270660400391 11 112.91393280029297 12 113.73182678222656 13 112.43179321289062
		 14 110.35145568847656 15 107.76446533203125 16 105.12978363037109 17 103.04135131835937
		 18 102.33340454101562 19 102.79784393310547 20 103.01753234863281 21 102.70455932617187
		 22 102.90668487548828 23 103.74756622314453 24 104.94252777099609 25 106.37382507324219
		 26 107.98687744140625 27 109.64701843261719 28 111.24256134033203 29 110.8819580078125
		 30 107.39052581787109 31 101.94497680664062 32 95.509101867675781 33 88.66363525390625
		 34 82.490097045898437 35 78.252365112304688 36 75.5423583984375 37 72.386123657226563
		 38 67.238250732421875 39 58.77496337890625 40 48.754779815673828 41 37.443717956542969
		 42 35.319805145263672 43 33.323757171630859 44 35.008853912353516 45 36.391654968261719
		 46 37.164882659912109 47 37.005802154541016 48 35.822196960449219 49 33.814842224121094
		 50 30.776767730712891 51 27.220184326171875 52 24.977621078491211 53 23.738842010498047
		 54 22.979650497436523 55 23.577245712280273 56 23.556365966796875 57 22.862491607666016
		 58 22.499670028686523 59 21.675054550170898 60 21.103336334228516 61 20.451904296875
		 62 19.663871765136719 63 19.248371124267578 64 19.275089263916016 65 19.276247024536133
		 66 19.217075347900391 67 19.121547698974609 68 19.121547698974609 69 19.121547698974609;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA";
	rename -uid "6741D976-40C2-8FF8-E4B5-2197A3A4C082";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.41650390625 1 4.014251708984375 2 4.4448909759521484
		 3 4.7388124465942383 4 5.045863151550293 5 5.5518941879272461 6 6.3476724624633789
		 7 8.8688993453979492 8 10.979362487792969 9 11.253493309020996 10 9.7652530670166016
		 11 6.9598188400268555 12 4.5439071655273437 13 3.8986279964447021 14 3.526132345199585
		 15 3.3067367076873779 16 3.0310890674591064 17 2.6206181049346924 18 1.3543527126312256
		 19 -0.2281949520111084 20 -1.2664206027984619 21 -0.3476874828338623 22 0.82404065132141113
		 23 2.7487428188323975 24 7.0819301605224609 25 13.018537521362305 26 20.199575424194336
		 27 28.165977478027344 28 36.231464385986328 29 44.771232604980469 30 54.399620056152344
		 31 64.757293701171875 32 75.656211853027344 33 86.824462890625 34 97.5299072265625
		 35 107.41307830810547 36 116.07499694824219 37 124.25331115722656 38 132.89813232421875
		 39 139.59197998046875 40 145.41339111328125 41 148.57461547851562 42 149.75143432617187
		 43 150.64216613769531 44 150.0888671875 45 149.23933410644531 46 148.25808715820312
		 47 147.2569580078125 48 146.36863708496094 49 145.77133178710937 50 145.16773986816406
		 51 144.2259521484375 52 143.22372436523438 53 142.94122314453125 54 142.82318115234375
		 55 142.43345642089844 56 142.20155334472656 57 142.31159973144531 58 142.72660827636719
		 59 143.05917358398437 60 143.11566162109375 61 143.07769775390625 62 143.04281616210937
		 63 143.1953125 64 143.14285278320312 65 143.110107421875 66 143.13478088378906 67 143.18084716796875
		 68 143.18084716796875 69 143.18084716796875;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX";
	rename -uid "54D008C0-4738-FF1F-E73C-0BBBA9D221BB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -67.859963853017504 1 -68.36630367773644
		 2 -69.097795982852588 3 -69.473012685416506 4 -68.915318941817489 5 -67.110692386989101
		 6 -64.232516554580442 7 -58.806291866455112 8 -49.798652943338006 9 -38.38993955471976
		 10 -25.809732921156662 11 -14.464982977754392 12 -8.7786344413988147 13 -7.4865399759299267
		 14 -5.9422930761490154 15 -4.1633174212425894 16 -2.1647366998615585 17 0.037932225045168015
		 18 2.4247768696563199 19 4.9701148599000939 20 7.6398203327983198 21 10.391053903811233
		 22 13.172080767130391 23 15.924222283215231 24 18.583989964901729 25 21.084831035666884
		 26 23.360990850428507 27 25.347545230488141 28 26.982215368934654 29 26.282687790653505
		 30 20.636548480775364 31 7.1789744695923963 32 -16.748100994301144 33 -42.016070458055886
		 34 -56.860300092297742 35 -62.947649578684235 36 -64.465864686916717 37 -63.973411393125517
		 38 -63.007009766921428 39 -62.547590423515281 40 -62.547596815032023 41 -62.547593749809202
		 42 -58.233200270722989 43 -53.274901968447857 44 -47.831448454964558 45 -42.154692426250584
		 46 -36.565799335893388 47 -31.413756909334232 48 -25.757153211672314 49 -18.702394765359923
		 50 -10.683390791531657 51 -2.5023798649899014 52 4.6485530147305205 53 9.5857352299147713
		 54 11.407322319610106 55 9.7115573408789633 56 5.6907213570041906 57 0.93432224061496127
		 58 -3.0148849306142842 59 -4.6613063863317619 60 -3.3813208646532473 61 -0.25839031388819933
		 62 3.6276761997221674 63 7.1706024384208096 64 7.1706207041845236 65 7.1706013997064337
		 66 7.170615547247345 67 7.1706023409969388 68 7.1706023409969388 69 7.1706023409969388;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY";
	rename -uid "2F4A68CD-4C7A-F01B-4D16-6CB0BC4736E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.9865724402642545 1 1.1850647238068848
		 2 1.8488899080048156 3 2.8969227498680632 4 4.2451661124376541 5 6.0740829448970715
		 6 9.2373743009163505 7 15.502336632029362 8 24.453697170179094 9 34.237175574466285
		 10 42.932074414003644 11 48.900885490242423 12 51.163410333349077 13 51.421058436715541
		 14 51.816414406881101 15 52.321196970551327 16 52.905156841088221 17 53.537023422181583
		 18 54.186736703406595 19 54.826584826614109 20 55.432769816075272 21 55.986340690193508
		 22 56.474516705961122 23 56.890739850236173 24 57.234759381423729 25 57.511603893301341
		 26 57.729865529050613 27 57.899656478021264 28 58.029202970443166 29 59.621913863616676
		 30 63.512845140242113 31 68.056404849564672 32 70.262585491255578 33 67.262339475328503
		 34 60.140521325314445 35 51.684780806370668 36 43.734472198994432 37 37.349226043361597
		 38 33.177015106573165 39 31.684001082727416 40 31.683998375903354 41 31.683999102151407
		 42 31.009217279131072 43 29.969385281840658 44 28.815339448270468 45 27.787683721370811
		 46 27.099084565002887 47 26.923383210456244 48 28.133308460064111 49 30.682645032800686
		 50 33.343960577071662 51 35.207717728534334 52 35.985664436229847 53 36.018416361670852
		 54 35.918492142218064 55 35.705641850367748 56 35.176257598284707 57 34.507390205835463
		 58 33.919404726845599 59 33.666114357401845 60 33.863446209562746 61 34.332812003557045
		 62 34.891625198249479 63 35.375054133390201 64 35.37503948635301 65 35.375047520989447
		 66 35.37506390317477 67 35.375050021127748 68 35.375050021127748 69 35.375050021127748;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "81CAE27A-4FB9-EF7B-0C72-02AE86A38FF7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 74.756658632303044 1 78.509887912024411
		 2 87.853754055326846 3 100.00091410324261 4 112.17023375734429 5 121.60718786415288
		 6 125.65484122072421 7 126.33802172499743 8 127.97359832873346 9 131.33097273302818
		 10 136.58319500057078 11 142.38797988319692 12 145.30188223377866 13 145.6083136380156
		 14 146.26658131621755 15 147.24438956609725 16 148.51163164434166 17 150.03763815960974
		 18 151.78736320744602 19 153.71991638622694 20 155.78632613365409 21 157.92878211685016
		 22 160.08107464352562 23 162.17021843989343 24 164.11856089226382 25 165.84576636614207
		 26 167.27207499287641 27 168.31877484347862 28 168.90949900317452 29 167.06592753175713
		 30 160.02812870618101 31 144.58191107287746 32 117.73075792226442 33 88.399671037270835
		 34 68.350926368628436 35 56.16282295303418 36 48.184581594868639 37 42.703378962745909
		 38 39.271264800197997 39 38.044326838205095 40 38.044272015221182 41 38.044308664638649
		 42 35.033398543415473 43 31.965257567054593 44 29.203406336036974 45 27.053794362730869
		 46 25.788353805580812 47 25.673704051287338 48 28.508719551436563 49 35.243466291605998
		 50 44.802498360171839 51 55.686807410417643 52 65.925131658670722 53 73.435276345125629
		 54 76.330382636691454 55 76.096599240578854 56 75.573551985422156 57 75.014677705234163
		 58 74.602643361054049 59 74.445400859945423 60 74.566963787338636 61 74.885168047731284
		 62 75.322997712152485 63 75.760823142763385 64 75.760846413993093 65 75.760825220896479
		 66 75.760836315366731 67 75.760823137814853 68 75.760823137814853 69 75.760823137814853;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA";
	rename -uid "935F6EDC-45F3-7828-0E24-EAB864A49242";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -42.800098419189453 1 -43.316463470458984
		 2 -44.340599060058594 3 -45.087261199951172 4 -45.305091857910156 5 -45.453842163085937
		 6 -45.448440551757813 7 -43.881515502929687 8 -43.9212646484375 9 -44.169277191162109
		 10 -44.570632934570313 11 -45.070358276367188 12 -45.616836547851563 13 -46.194076538085938
		 14 -46.805149078369141 15 -47.440315246582031 16 -48.040920257568359 17 -48.515724182128906
		 18 -48.530788421630859 19 -48.322933197021484 20 -47.878322601318359 21 -47.266887664794922
		 22 -46.530055999755859 23 -45.686740875244141 24 -44.785995483398437 25 -43.908245086669922
		 26 -43.14825439453125 27 -42.661518096923828 28 -42.534805297851563 29 -42.582530975341797
		 30 -42.36895751953125 31 -42.282176971435547 32 -42.455612182617188 33 -42.777763366699219
		 34 -43.238639831542969 35 -43.815994262695313 36 -44.567451477050781 37 -45.511528015136719
		 38 -46.545536041259766 39 -47.093826293945313 40 -47.378898620605469 41 -47.329689025878906
		 42 -47.352699279785156 43 -47.764396667480469 44 -48.995822906494141 45 -50.506069183349609
		 46 -51.422454833984375 47 -51.819801330566406 48 -51.696731567382813 49 -50.957057952880859
		 50 -49.633388519287109 51 -47.844497680664063 52 -45.697685241699219 53 -44.142181396484375
		 54 -42.729629516601563 55 -42.828239440917969 56 -42.8436279296875 57 -42.707126617431641
		 58 -42.52215576171875 59 -42.200519561767578 60 -41.762603759765625 61 -41.337905883789063
		 62 -41.027969360351563 63 -40.867935180664063 64 -40.925186157226563 65 -40.967109680175781
		 66 -40.922336578369141 67 -40.846305847167969 68 -40.846305847167969 69 -40.846305847167969;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA";
	rename -uid "0781A05F-4523-2F3C-1191-6F85DD726D86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 59.371875762939453 1 59.348136901855469
		 2 58.980766296386719 3 58.333457946777344 4 57.100639343261719 5 55.013351440429688
		 6 52.003147125244141 7 49.875354766845703 8 48.3592529296875 9 46.21392822265625
		 10 43.684230804443359 11 41.0167236328125 12 38.270999908447266 13 35.436073303222656
		 14 32.565238952636719 15 29.688636779785156 16 27.022953033447266 17 24.906936645507813
		 18 24.198329925537109 19 23.505344390869141 20 22.495464324951172 21 21.498001098632813
		 22 20.849632263183594 23 20.547466278076172 24 20.413925170898437 25 20.562715530395508
		 26 21.177087783813477 27 22.354583740234375 28 24.364160537719727 29 26.996097564697266
		 30 29.861848831176758 31 33.301490783691406 32 37.167797088623047 33 41.143791198730469
		 34 45.385513305664062 35 49.988437652587891 36 54.800010681152344 37 59.090030670166016
		 38 61.724922180175781 39 60.827274322509766 40 58.060672760009766 41 52.921531677246094
		 42 47.45684814453125 43 41.967727661132812 44 39.317817687988281 45 35.913555145263672
		 46 37.282485961914063 47 38.247207641601562 48 38.52337646484375 49 37.861965179443359
		 50 35.73040771484375 51 31.821014404296875 52 27.150106430053711 53 23.435310363769531
		 54 20.598838806152344 55 22.362316131591797 56 24.262666702270508 57 25.673868179321289
		 58 26.912582397460938 59 26.374485015869141 60 24.383556365966797 61 21.832944869995117
		 62 19.255638122558594 63 18.840129852294922 64 18.866846084594727 65 18.868009567260742
		 66 18.808818817138672 67 18.713319778442383 68 18.713319778442383 69 18.713319778442383;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA";
	rename -uid "4B853641-45BE-131F-BE11-4F8BB56C773D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -42.463363647460938 1 -41.575412750244141
		 2 -42.52899169921875 3 -44.050514221191406 4 -44.777748107910156 5 -43.416999816894531
		 6 -40.091114044189453 7 -41.315269470214844 8 -40.424007415771484 9 -39.348072052001953
		 10 -38.097587585449219 11 -36.716041564941406 12 -35.190254211425781 13 -33.442340850830078
		 14 -31.386404037475586 15 -29.049079895019531 16 -26.585712432861328 17 -24.129829406738281
		 18 -22.495121002197266 19 -20.561874389648438 20 -18.500171661376953 21 -16.267854690551758
		 22 -13.825141906738281 23 -11.219846725463867 24 -8.6775531768798828 25 -6.2841339111328125
		 26 -3.8887529373168945 27 -1.4659417867660522 28 1.186772346496582 29 4.6067705154418945
		 30 8.5057563781738281 31 12.286464691162109 32 16.291168212890625 33 20.745307922363281
		 34 25.580493927001953 35 30.967426300048828 36 37.536209106445313 37 45.73779296875
		 38 55.053623199462891 39 61.741886138916016 40 67.642753601074219 41 71.627105712890625
		 42 74.377731323242187 43 76.000259399414063 44 75.658370971679688 45 74.865036010742188
		 46 73.659622192382812 47 72.021347045898438 48 70.148307800292969 49 68.295219421386719
		 50 66.293731689453125 51 63.904388427734375 52 61.843002319335938 53 60.67742919921875
		 54 59.819053649902344 55 58.608993530273438 56 57.47760009765625 57 56.705825805664063
		 58 56.329109191894531 59 55.966854095458984 60 55.608421325683594 61 55.314125061035156
		 62 55.247482299804688 63 55.399997711181641 64 55.347518920898438 65 55.314796447753906
		 66 55.339443206787109 67 55.385543823242188 68 55.385543823242188 69 55.385543823242188;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX";
	rename -uid "6BFBFB20-4EBB-AF3B-3A7F-5DB98B74FFA5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -70.275033464269882 1 -67.017024416278417
		 2 -61.037904041034423 3 -56.112307262713536 4 -55.207902392919102 5 -60.071310398820735
		 6 -67.104754700874878 7 -44.495498701875881 8 -48.209770292941286 9 -56.937200194510751
		 10 -74.52778707194787 11 -111.29448158201765 12 -161.2209859613441 13 -191.12130004860447
		 14 -206.94413663995334 15 -216.73925409181268 16 -223.15034435549444 17 -226.95943306446509
		 18 -228.26946399115417 19 -228.96090522148359 20 -231.55252090979965 21 -237.68489509835513
		 22 -249.33690693260868 23 -264.61648400190467 24 -275.82640444570023 25 -279.12775189673079
		 26 -276.27197634081011 27 -269.66992665783908 28 -260.97095167679259 29 -251.22700827137564
		 30 -241.13163960448875 31 -231.15957655392924 32 -221.64586889312571 33 -212.83690454891857
		 34 -204.92682939299732 35 -198.08337626674793 36 -192.46677444100482 37 -188.23999203311121
		 38 -185.57347838345834 39 -184.64445979508636 40 -184.64447690571643 41 -184.64446208724942
		 42 -184.64446621657453 43 -184.64447846780257 44 -184.64444424730058 45 -184.64444368550571
		 46 -184.64448332234616 47 -184.64447477280939 48 -184.64448103426969 49 -184.64449059961396
		 50 -184.64447305734785 51 -184.6444871714049 52 -184.64448546081098 53 -184.644471772206
		 54 -184.64446465284905 55 -184.64447833698884 56 -184.64445538938503 57 -184.64446122843464
		 58 -184.64447363837124 59 -184.64448075396527 60 -184.64443742563543 61 -184.64448304127959
		 62 -184.64446336392942 63 -184.64446608867735 64 -184.64447834462564 65 -184.6444578097163
		 66 -184.64446308726107 67 -184.64446352243974 68 -184.64446352243974 69 -184.64446352243974;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY";
	rename -uid "EBB2D248-4994-211B-5619-F29A24BFC690";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 58.549754523184433 1 58.947017250794353
		 2 59.760747402687826 3 60.576421694249419 4 60.770784261255528 5 59.648298714223785
		 6 56.669367892913186 7 78.775494444363432 8 81.057847774825831 9 83.33736524666206
		 10 85.450092544343775 11 86.875443161828485 12 86.568436547067265 13 84.909428575946592
		 14 82.939361429962361 15 81.086652885608075 16 79.568263051146076 17 78.551876588605026
		 18 78.184154571936162 19 78.537263339954293 20 79.471998029349351 21 80.658395774972647
		 22 81.488403352190119 23 81.120669270491106 24 79.107440254204647 25 75.727231959329941
		 26 71.398917817045586 27 66.376708047248869 28 60.798430654759457 29 54.763670539321687
		 30 48.379998396066021 31 41.785120527168068 32 35.152220481082068 33 28.684715602370293
		 34 22.605914775405868 35 17.147592423478635 36 12.539701058028429 37 9.0033122686994851
		 38 6.7447958002485437 39 5.9534400489104025 40 5.953430291736427 41 5.953429423421186
		 42 5.9534495331258546 43 5.9534702719728942 44 5.9535069833786691 45 5.9534440031435638
		 46 5.9534384833229916 47 5.9534234329702915 48 5.9534545478015009 49 5.9534421159182171
		 50 5.9534467106900655 51 5.9534312749988674 52 5.9534193156312263 53 5.9534303542105853
		 54 5.9534142864577397 55 5.9534120139494755 56 5.9534000603168469 57 5.9534170439222542
		 58 5.9534021876227525 59 5.9534183820581612 60 5.9534104093759419 61 5.953395695512226
		 62 5.9534022179062651 63 5.9533911719758343 64 5.953395062648311 65 5.9534062180889373
		 66 5.9533986031210562 67 5.9533926300294757 68 5.9533926300294757 69 5.9533926300294757;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "1C71A2BA-45A1-E0E5-6BBB-6794A1E80AD1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 170.3385082890936 1 170.17074719621019
		 2 167.95045473044581 3 162.77684735583065 4 154.86002216205469 5 145.89106676318198
		 6 138.94975341458905 7 171.68586746606448 8 169.05096872569018 9 163.02832487309763
		 10 149.35571917429641 11 117.3213586568998 12 72.560303544320121 13 47.897973294113037
		 14 37.04682461785319 15 31.639056507031697 16 28.72912221299655 17 27.240830523249112
		 18 26.773185511395745 19 25.126570244234234 20 19.781814069031164 21 9.2545876847640969
		 22 -8.2835860355803366 23 -30.783462364305649 24 -50.373308761179928 25 -63.016672815823604
		 26 -70.243493130429798 27 -74.225030359342952 28 -76.363738991319153 29 -77.469425381408641
		 30 -78.009831684185883 31 -78.25647038680232 32 -78.364435271491075 33 -78.418611939080989
		 34 -78.461727011383388 35 -78.510631747059008 36 -78.566656059893376 37 -78.621848306459881
		 38 -78.663518197879199 39 -78.679419257801342 40 -78.679399056925007 41 -78.679404442601012
		 42 -78.679440806769975 43 -78.679419931806763 44 -78.679362692841011 45 -78.679376159970218
		 46 -78.679446192256066 47 -78.679463029667446 48 -78.679460333520325 49 -78.679463029638981
		 50 -78.679427339458314 51 -78.679496023620757 52 -78.679440132637879 53 -78.679440132651976
		 54 -78.679425991463688 55 -78.679459659467469 56 -78.679418583797741 57 -78.679418583792526
		 58 -78.679398383009428 59 -78.679424643340553 60 -78.679399731034252 61 -78.679441480612908
		 62 -78.679442828656022 63 -78.679442828810707 64 -78.67942868755776 65 -78.679425991492678
		 66 -78.679400404936771 67 -78.679425991523814 68 -78.679425991523814 69 -78.679425991523814;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA";
	rename -uid "A845D276-45EA-6CF1-F871-1F894A619BAD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 28.145029067993164 1 28.136310577392578
		 2 28.115133285522461 3 28.073068618774414 4 28.01832389831543 5 27.957479476928711
		 6 27.896612167358398 7 27.842182159423828 8 27.801795959472656 9 27.784198760986328
		 10 28.057010650634766 11 28.252162933349609 12 28.084367752075195 13 27.508214950561523
		 14 26.587858200073242 15 25.883539199829102 16 25.534322738647461 17 24.879165649414063
		 18 25.762075424194336 19 25.780641555786133 20 25.843849182128906 21 25.974218368530273
		 22 26.19267463684082 23 26.506633758544922 24 26.853208541870117 25 26.911893844604492
		 26 27.095819473266602 27 27.320774078369141 28 27.527210235595703 29 28.044736862182617
		 30 28.589748382568359 31 28.778144836425781 32 28.709548950195313 33 28.488710403442383
		 34 28.195816040039062 35 27.868644714355469 36 27.449129104614258 37 26.787797927856445
		 38 26.474309921264648 39 26.453720092773438 40 27.938369750976562 41 28.890296936035156
		 42 29.370292663574219 43 29.364711761474609 44 29.003732681274414 45 28.498161315917969
		 46 28.121637344360352 47 28.017562866210938 48 28.269207000732422 49 28.935016632080078
		 50 28.680030822753906 51 31.394645690917969 52 34.531982421875 53 35.550273895263672
		 54 36.534652709960937 55 35.477279663085938 56 34.51507568359375 57 33.939521789550781
		 58 33.813304901123047 59 34.219978332519531 60 34.971443176269531 61 35.589790344238281
		 62 36.31829833984375 63 36.507392883300781 64 36.527156829833984 65 36.507957458496094
		 66 36.532032012939453 67 36.572074890136719 68 36.572074890136719 69 36.572074890136719;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA";
	rename -uid "D2ACDE90-45FC-333B-56A3-E9A7A532D4D6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 31.468204498291016 1 31.423797607421875
		 2 31.332664489746094 3 31.232307434082031 4 31.117931365966797 5 30.981037139892578
		 6 30.807817459106445 7 30.576051712036133 8 30.250024795532227 9 29.775320053100586
		 10 28.41539192199707 11 26.623933792114258 12 24.743463516235352 13 22.617586135864258
		 14 20.079133987426758 15 16.861608505249023 16 12.943326950073242 17 8.7527332305908203
		 18 9.0691089630126953 19 9.2684001922607422 20 9.5984115600585937 21 10.04644775390625
		 22 10.630399703979492 23 11.47297477722168 24 12.833908081054687 25 16.435819625854492
		 26 15.568681716918945 27 15.068296432495117 28 14.786346435546875 29 14.611818313598633
		 30 14.722320556640625 31 15.845876693725586 32 18.337949752807617 33 21.986501693725586
		 34 26.702259063720703 35 32.310642242431641 36 38.514129638671875 37 44.509231567382813
		 38 49.677608489990234 39 52.195018768310547 40 52.062015533447266 41 52.027534484863281
		 42 51.786590576171875 43 50.745750427246094 44 48.8228759765625 45 46.177177429199219
		 46 42.933406829833984 47 39.412761688232422 48 35.981224060058594 49 33.203037261962891
		 50 32.213798522949219 51 26.945674896240234 52 21.144744873046875 53 18.529409408569336
		 54 16.126323699951172 55 17.404514312744141 56 18.900522232055664 57 19.728887557983398
		 58 19.632375717163086 59 18.157938003540039 60 15.994939804077148 61 14.578725814819336
		 62 12.974542617797852 63 12.653053283691406 64 12.617578506469727 65 12.615495681762695
		 66 12.583103179931641 67 12.531801223754883 68 12.531801223754883 69 12.531801223754883;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "B4A8B8EC-4211-E3F2-AE21-9ABE15031C6E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -12.81578254699707 1 -11.311613082885742
		 2 -9.825221061706543 3 -8.4241094589233398 4 -7.0920634269714355 5 -5.8135623931884766
		 6 -4.5694684982299805 7 -3.333155632019043 8 -2.0662972927093506 9 -0.71911334991455078
		 10 2.7314352989196777 11 7.1191787719726563 12 10.752216339111328 13 13.353607177734375
		 14 15.13662052154541 15 16.643854141235352 16 17.967536926269531 17 18.643703460693359
		 18 18.864805221557617 19 20.442222595214844 20 21.507352828979492 21 22.221229553222656
		 22 22.683664321899414 23 22.880332946777344 24 22.612766265869141 25 21.091072082519531
		 26 22.571239471435547 27 23.798809051513672 28 24.879116058349609 29 25.798641204833984
		 30 26.415763854980469 31 26.469100952148437 32 26.127147674560547 33 25.911272048950195
		 34 26.259876251220703 35 27.650108337402344 36 30.739105224609375 37 35.623687744140625
		 38 41.737743377685547 39 45.5751953125 40 45.092937469482422 41 44.969558715820313
		 42 44.445995330810547 43 43.543502807617188 44 42.350856781005859 45 40.943103790283203
		 46 39.348533630371094 47 37.685726165771484 48 36.081615447998047 49 34.642181396484375
		 50 33.377155303955078 51 32.006877899169922 52 31.571466445922852 53 31.414857864379883
		 54 31.571449279785156 55 30.694053649902344 56 29.908329010009766 57 29.611934661865234
		 58 29.917751312255859 59 30.405193328857422 60 31.016868591308594 61 31.323369979858398
		 62 31.721996307373047 63 31.843929290771484 64 31.840921401977539 65 31.816545486450195
		 66 31.823579788208008 67 31.840232849121094 68 31.840232849121094 69 31.840232849121094;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "5625C7E9-421E-1E5D-DE52-96BD593211D2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.15234809184050646 1 -0.20831426541422418
		 2 -0.52767153611701934 3 -0.78241893082613634 4 -0.96531027802892977 5 -1.0746635168209351
		 6 -1.1139078890152809 7 -1.09119983007953 8 -1.0193043248261486 9 -0.91567866477276971
		 10 -1.9317121602764273 11 -4.2496795817692634 12 -6.2938233930959067 13 -7.349023411188722
		 14 -7.1508585297973006 15 -6.2975754267613864 16 -5.2324006141934989 17 -3.3128929796833813
		 18 -4.8565544544717056 19 -4.499172451383699 20 -3.483359234112728 21 -2.1005787711379518
		 22 -0.76761618246439967 23 0.03557906609643121 24 -0.18904288704731884 25 -1.9833994100518868
		 26 -3.810929939809883 27 -6.2600409915749715 28 -8.5194765166313786 29 -9.7997979093503513
		 30 -10.517038075213677 31 -9.884318864671144 32 -10.113156084793165 33 -11.442721263209215
		 34 -13.518334491877894 35 -15.90744119367562 36 -18.559593702590654 37 -21.093620294575263
		 38 -21.603850340657473 39 -23.165832864561025 40 -19.103342506751897 41 -14.778453115407325
		 42 -12.433060821190239 43 -12.877939390065373 44 -16.71872620062269 45 -22.711207585191463
		 46 -31.238116521294863 47 -37.312374697083037 48 -42.32043728526574 49 -45.057694076771689
		 50 -45.925203293081438 51 -41.669106897283179 52 -35.560887132897413 53 -32.135387515089398
		 54 -29.833641762635917 55 -30.882819843982425 56 -33.133779462373354 57 -34.627247670058928
		 58 -34.649960725629931 59 -33.074633923533312 60 -30.472538247717491 61 -28.570386100503463
		 62 -27.419755098030727 63 -27.541761414936623 64 -27.638813632403959 65 -27.643420988670048
		 66 -27.634055634911437 67 -27.618174902393697 68 -27.618174902393697 69 -27.618174902393697;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "C562AE07-4D18-6A92-3EAA-52A9FB8C17C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -0.34659434890483937 1 -0.72822357213543998
		 2 -1.1213026784535844 3 -1.5464709143799225 4 -1.9955737487764478 5 -2.4616382926148832
		 6 -2.9368136533516509 7 -3.4101226076462705 8 -3.8647924388803307 9 -4.2756532050253924
		 10 -3.7689131730767573 11 -2.7772710458366459 12 -2.1815274129070992 13 -2.6410006495284213
		 14 -4.5975337073867095 15 -6.7527792534502611 16 -8.2738132996626685 17 -10.752645601023866
		 18 -9.372213422446432 19 -9.361383239204784 20 -9.3676124265348548 21 -9.0514684669084549
		 22 -8.276764932442541 23 -7.2470125838346178 24 -6.5773457886496587 25 -8.080753080412677
		 26 -7.8828226293173147 27 -7.3133061779445603 28 -6.5948319327431379 29 -5.3352300213388109
		 30 -4.1728764679472432 31 -3.699384021370741 32 -3.0548717712569968 33 -1.8657058594424218
		 34 0.16847721061060542 35 2.9239673662702459 36 5.5572250794165985 37 6.9983510317352247
		 38 9.0161597988317634 39 9.5834881275365191 40 18.230127398797023 41 23.095174456332561
		 42 26.450996979624392 43 29.3180229445219 44 31.244456067230107 45 31.312381912519616
		 46 29.010859964457861 47 23.901567314070068 48 16.141455199490487 49 6.863082092806402
		 50 -10.337433928425888 51 -16.969250988195022 52 -23.014984959266016 53 -22.683458669433691
		 54 -21.819978840349012 55 -20.834176112831617 56 -19.921474133968854 57 -19.377006519125075
		 58 -19.828846166607633 59 -21.041366691179711 60 -22.592406854501625 61 -23.153653584913869
		 62 -23.87366963948077 63 -23.918506032927763 64 -24.156658661463197 65 -24.221492061314834
		 66 -24.153051774549503 67 -24.036023991001713 68 -24.036023991001713 69 -24.036023991001713;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "D29B81AA-4CC0-AED1-3573-C484D0206E6B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -26.457397819222685 1 -23.37134993940257
		 2 -20.483040318891668 3 -18.048880696905655 4 -15.983802696534056 5 -14.199034836103767
		 6 -12.585941978199825 7 -10.9985360686644 8 -9.2314597435909036 9 -7.008628245676273
		 10 4.5122234912754742 11 22.064139676860147 12 39.596928891285103 13 55.332239971361311
		 14 67.28692612150769 15 72.187915073331098 16 72.774366044594871 17 75.002455489445126
		 18 74.045121631253281 19 73.615650449844878 20 71.215709546825494 21 66.80418079993683
		 22 60.288279216588194 23 51.400239781935142 24 39.584393326869964 25 18.966045240021369
		 26 19.043380328519557 27 19.735919706946454 28 20.329330212606305 29 19.920907773662471
		 30 20.027922595475687 31 21.940797303471523 32 26.322282779847104 33 33.673863621992915
		 34 44.602328799106154 35 58.12159072798071 36 72.429498593770404 37 86.814857883378593
		 38 100.27096797122528 39 105.37707862851674 40 124.66108946608213 41 138.98187291520551
		 42 147.21987512064689 43 147.37891136088155 44 139.27368495224096 45 125.65004764991801
		 46 110.6319141361668 47 95.810829833567993 48 82.231157086463583 49 70.862179570048667
		 50 53.348916185213852 51 45.712379577971014 52 37.31826747099224 53 34.867391745983973
		 54 32.306018051122827 55 34.882412540929636 56 38.108159286024254 57 40.178754367780328
		 58 38.408384705320046 59 34.783581303070967 60 30.630877238917453 61 28.944270582737598
		 62 26.948925265582069 63 27.249881201299818 64 27.055341539751428 65 27.045629257549056
		 66 27.1308138824179 67 27.269794898887387 68 27.269794898887387 69 27.269794898887387;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA";
	rename -uid "68F1973F-49F7-F450-232E-0DB469FD9B99";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -22.988239288330078 1 -22.99992561340332
		 2 -22.981094360351563 3 -22.920633316040039 4 -22.823471069335938 5 -22.699563980102539
		 6 -22.562404632568359 7 -22.427242279052734 8 -22.308803558349609 9 -22.219720840454102
		 10 -22.17747688293457 11 -22.241752624511719 12 -22.44886589050293 13 -22.781705856323242
		 14 -23.196414947509766 15 -23.588521957397461 16 -23.752189636230469 17 -23.117031097412109
		 18 -21.710145950317383 19 -21.922760009765625 20 -22.500585556030273 21 -23.331626892089844
		 22 -24.265342712402344 23 -25.715930938720703 24 -27.272575378417969 25 -28.293458938598633
		 26 -28.739051818847656 27 -28.929103851318359 28 -29.271217346191406 29 -30.016571044921875
		 30 -30.846517562866211 31 -31.698345184326172 32 -32.473361968994141 33 -32.382625579833984
		 34 -32.122390747070313 35 -32.003425598144531 36 -32.408054351806641 37 -33.571029663085938
		 38 -34.756187438964844 39 -34.797306060791016 40 -32.875167846679688 41 -29.194101333618164
		 42 -25.337465286254883 43 -23.568580627441406 44 -23.46186637878418 45 -25.505722045898438
		 46 -28.226245880126953 47 -31.3671875 48 -34.500080108642578 49 -37.095932006835937
		 50 -38.68524169921875 51 -38.776588439941406 52 -36.969985961914063 53 -32.979537963867187
		 54 -25.857990264892578 55 -26.141010284423828 56 -27.301128387451172 57 -27.100028991699219
		 58 -28.098625183105469 59 -28.491840362548828 60 -28.205987930297852 61 -27.425884246826172
		 62 -26.432258605957031 63 -25.515480041503906 64 -25.873580932617188 65 -26.084316253662109
		 66 -25.802350997924805 67 -25.340826034545898 68 -25.340826034545898 69 -25.340826034545898;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA";
	rename -uid "BAC23A5C-4A7E-5EAB-EE02-91B4964229AA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 16.192705154418945 1 16.013673782348633
		 2 15.89134407043457 3 15.846452713012695 4 15.850793838500977 5 15.880666732788086
		 6 15.915037155151367 7 15.934003829956055 8 15.918527603149414 9 15.851045608520508
		 10 15.736848831176758 11 15.566972732543945 12 15.329311370849609 13 15.014064788818359
		 14 14.59565544128418 15 14.070653915405273 16 13.594076156616211 17 13.690784454345703
		 18 15.652053833007813 19 15.909677505493164 20 16.161216735839844 21 16.306888580322266
		 22 16.252117156982422 23 15.141757965087891 24 13.284402847290039 25 11.621824264526367
		 26 10.546781539916992 27 9.6282176971435547 28 9.0999069213867187 29 9.0723838806152344
		 30 8.5839366912841797 31 8.0940456390380859 32 8.2866344451904297 33 8.8410472869873047
		 34 10.495746612548828 35 13.302639007568359 36 18.082700729370117 37 25.523900985717773
		 38 35.566238403320312 39 43.016387939453125 40 49.949844360351562 41 54.975532531738281
		 42 57.804023742675781 43 58.419952392578125 44 57.6387939453125 45 56.023647308349609
		 46 53.673599243164063 47 50.689018249511719 48 47.12139892578125 49 43.322502136230469
		 50 38.642353057861328 51 33.174503326416016 52 26.988479614257813 53 19.391550064086914
		 54 10.423809051513672 55 9.9653472900390625 56 9.9351615905761719 57 9.4203758239746094
		 58 11.916545867919922 59 12.753011703491211 60 11.796289443969727 61 9.6468124389648437
		 62 7.0671634674072266 63 5.1053695678710938 64 5.3548259735107422 65 5.4539890289306641
		 66 5.1316452026367188 67 4.6236782073974609 68 4.6236782073974609 69 4.6236782073974609;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "039F0DEA-4ED4-8C93-22E0-2B8DDA3FF366";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -13.473273277282715 1 -12.74558162689209
		 2 -11.846042633056641 3 -10.80613899230957 4 -9.6567802429199219 5 -8.4241065979003906
		 6 -7.1298918724060059 7 -5.7934231758117676 8 -4.4335660934448242 9 -3.0704188346862793
		 10 -1.7199897766113281 11 -0.48085403442382813 12 0.61842536926269531 13 1.6665573120117187
		 14 2.7364711761474609 15 3.8725242614746094 16 5.1330833435058594 17 6.6396961212158203
		 18 8.1895103454589844 19 10.109167098999023 20 11.949512481689453 21 13.687030792236328
		 22 15.27752685546875 23 16.700576782226563 24 17.882148742675781 25 18.633085250854492
		 26 18.989419937133789 27 19.084859848022461 28 19.137454986572266 29 19.256826400756836
		 30 19.359642028808594 31 19.421909332275391 32 19.397563934326172 33 18.876228332519531
		 34 18.346597671508789 35 18.197189331054687 36 18.789766311645508 37 20.520486831665039
		 38 23.905899047851562 39 28.644725799560547 40 34.567123413085937 41 40.360485076904297
		 42 44.763870239257813 43 47.521808624267578 44 49.351516723632812 45 49.016887664794922
		 46 48.041786193847656 47 46.18878173828125 48 43.451953887939453 49 40.049598693847656
		 50 35.928482055664063 51 31.300678253173828 52 26.499431610107422 53 21.919082641601563
		 54 20.568992614746094 55 20.51222038269043 56 20.714344024658203 57 20.603996276855469
		 58 19.680545806884766 59 19.527654647827148 60 19.851818084716797 61 20.635547637939453
		 62 21.82696533203125 63 23.238845825195313 64 23.13566780090332 65 23.114889144897461
		 66 23.290027618408203 67 23.587638854980469 68 23.587638854980469 69 23.587638854980469;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "27DC37C4-4ED0-5685-636C-02B1D744E132";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 15.539335906257678 1 15.707070094752426
		 2 15.940576656515026 3 16.191706340186386 4 16.423297862912676 5 16.620889383938422
		 6 16.793055010983995 7 16.964200662323499 8 17.162167668525136 9 17.40534226750674
		 10 17.698549565734073 11 18.363135989912205 12 19.665378547440501 13 21.53507682678752
		 14 23.892022989549137 15 26.655603386446185 16 29.855639392481919 17 33.698614709023921
		 18 29.54949232601837 19 29.874782010035837 20 30.589731680620837 21 31.48647591422295
		 22 32.282981907910845 23 34.680033875134988 24 36.217698565484952 25 36.932660059474109
		 26 36.813533283884119 27 36.143943145168201 28 35.762506759062475 29 36.24129173112587
		 30 36.446296810398799 31 35.543036402736263 32 33.41264118248629 33 30.281026525109112
		 34 27.227772306865266 35 25.515610810567789 36 26.7443599747257 37 30.706044681782625
		 38 33.887524470540313 39 35.01039870917802 40 33.63879760553705 41 30.928617507793035
		 42 27.941388236085178 43 25.682154340952522 44 24.051262623096541 45 25.082894572259818
		 46 26.963559457275107 47 30.764063154297453 48 35.963436547751776 49 41.557770446216907
		 50 46.555765502402828 51 49.63507180022232 52 49.265940676934918 53 43.717124392079761
		 54 29.714434077319442 55 25.219681074276281 56 19.480099409904351 57 13.207409786796036
		 58 16.410653099833766 59 18.312780182922783 60 18.894621236747422 61 18.077744870909143
		 62 16.296403813449022 63 13.839486284986208 64 14.499684255436289 65 14.638746274327392
		 66 13.995630003215162 67 12.932818042305106 68 12.932818042305106 69 12.932818042305106;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "029D94E6-4E88-2A85-7B98-71AF8F59390A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.286584049668857 1 3.0092342188305601
		 2 2.4635111808803511 3 1.7766596841050388 4 1.0138121835162139 5 0.24654244910126807
		 6 -0.45227683211924985 7 -1.0137182522915023 8 -1.3758771217227028 9 -1.4828263651335329
		 10 -1.2869136481704582 11 -0.93884094932624851 12 -0.58536692068743756 13 -0.17394080894604622
		 14 0.3604074713836326 15 1.1932186075255435 16 2.913650898915725 17 7.6990566743122422
		 18 14.530288259998358 19 14.796345194516508 20 15.745639115216651 21 17.227130681339997
		 22 19.028868283327718 23 17.890056763258162 24 14.318804811174981 25 10.75257701775053
		 26 7.6286441140853247 27 4.8079968065824774 28 2.9718266243607498 29 2.356799846770171
		 30 2.7303680596076294 31 4.2012948775771362 32 5.7134567754842003 33 8.6576306370661644
		 34 11.060288412537949 35 11.869143269967541 36 12.197074459255925 37 11.575323525412312
		 38 9.4529754300830557 39 7.7312796011423606 40 4.6181035234463614 41 2.3107665618853366
		 42 0.93778099294198258 43 -2.076954167507798 44 -2.681352943815893 45 -5.3854585794903933
		 46 -5.9901239682145091 47 -5.8010467476256515 48 -5.9888906902560581 49 -6.9720851338451233
		 50 -7.967454142955865 51 -7.8236616173606439 52 -6.2479113483877127 53 -1.7371037063939827
		 54 5.0573357738527589 55 12.360358047327761 56 15.159678721504145 57 19.281107921837986
		 58 17.119362340114396 59 15.08060121620969 60 14.124059611886398 61 14.423328482437272
		 62 15.331866273353494 63 16.368381751075127 64 16.668129482824398 65 16.920293301894535
		 66 16.875599218369636 67 16.750031729997605 68 16.750031729997605 69 16.750031729997605;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "C7225D3F-43D6-4712-F68D-56811BEB3C8A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 42.122256667831387 1 43.72564349969074
		 2 46.048045700904112 3 48.715128276431528 4 51.530129604399349 5 54.294391554196864
		 6 56.818847394767779 7 58.932135765068438 8 60.48628116575204 9 61.360178600507808
		 10 61.37414209456896 11 61.379646924575091 12 62.191640763954723 13 63.546151573689087
		 14 65.108634191018041 15 66.430091668652665 16 66.623719691865077 17 63.967845887123666
		 18 57.261993773607628 19 58.144242469591525 20 59.486913676605027 21 61.021651918387796
		 22 62.439849100056968 23 65.824034216578511 24 70.414455245361438 25 74.533993337799728
		 26 78.1512170978624 27 81.259098786755345 28 84.380751844363246 29 88.055710260286375
		 30 89.689260239639751 31 87.87815088335978 32 83.811978915386462 33 81.762514068252528
		 34 79.843381804713417 35 78.03879092838288 36 83.21623659916925 37 97.905161140135988
		 38 116.55776900320728 39 127.31651747243656 40 134.45520368044131 41 138.67752244558807
		 42 142.71328599108435 43 147.33674355483359 44 151.97765340618707 45 161.10211518138917
		 46 168.73207353816449 47 174.27583372660629 48 177.70731873059958 49 178.9674769908838
		 50 176.652266951321 51 170.59924211987121 52 161.16661231855312 53 144.84916929401817
		 54 115.48683194623683 55 97.870735669008639 56 78.877715696705394 57 66.255130074360096
		 58 74.298593637663217 59 79.159110628973991 60 81.016467841913055 61 79.28590295502066
		 62 74.752032844511902 63 68.686410813383873 64 69.233498947767089 65 68.913953602209844
		 66 67.847772513969588 67 66.149342355440496 68 66.149342355440496 69 66.149342355440496;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA";
	rename -uid "780C64C1-41D1-61AA-69D5-289E66D8231F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 33.259979248046875 1 33.321632385253906
		 2 32.213123321533203 3 30.015861511230469 4 27.07417106628418 5 24.33747673034668
		 6 23.047908782958984 7 22.659084320068359 8 22.269176483154297 9 21.92231559753418
		 10 22.217336654663086 11 23.762819290161133 12 26.149707794189453 13 27.395654678344727
		 14 28.038515090942383 15 27.944568634033203 16 27.083835601806641 17 25.11273193359375
		 18 24.961610794067383 19 23.78294563293457 20 24.318220138549805 21 26.328952789306641
		 22 28.462549209594727 23 29.661708831787109 24 29.974302291870117 25 29.597030639648438
		 26 28.774057388305664 27 27.817728042602539 28 27.001382827758789 29 27.494277954101563
		 30 29.229568481445313 31 30.773885726928711 32 31.348382949829102 33 30.783487319946289
		 34 29.825077056884766 35 29.340330123901367 36 29.805332183837891 37 30.889228820800781
		 38 31.354331970214844 39 32.477912902832031 40 32.506004333496094 41 31.837621688842773
		 42 32.578742980957031 43 32.112751007080078 44 32.515533447265625 45 32.578575134277344
		 46 32.277484893798828 47 31.632261276245117 48 30.799823760986328 49 30.035537719726563
		 50 29.837905883789063 51 29.98277473449707 52 31.062921524047852 53 31.755647659301758
		 54 32.730751037597656 55 31.9832763671875 56 31.155454635620117 57 30.427825927734375
		 58 29.844350814819336 59 29.494487762451172 60 29.783664703369141 61 30.101146697998047
		 62 30.443229675292969 63 30.603282928466797 64 30.545988082885742 65 30.504074096679688
		 66 30.548862457275391 67 30.624912261962891 68 30.624912261962891 69 30.624912261962891;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA";
	rename -uid "610261D9-48E4-504C-D87B-8D986BF1CCE7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 78.017257690429687 1 77.273239135742188
		 2 76.455230712890625 3 75.825729370117187 4 75.573448181152344 5 75.767822265625
		 6 76.202537536621094 7 78.03125 8 81.070770263671875 9 85.520362854003906 10 89.989089965820313
		 11 93.538162231445313 12 94.882369995117188 13 94.638397216796875 14 93.471115112304688
		 15 91.377517700195313 16 88.563674926757813 17 85.235870361328125 18 84.6800537109375
		 19 83.868560791015625 20 83.4539794921875 21 83.275100708007813 22 84.013641357421875
		 23 85.609161376953125 24 87.210823059082031 25 88.801544189453125 26 90.362312316894531
		 27 91.801841735839844 28 93.152572631835938 29 93.296485900878906 30 91.060890197753906
		 31 86.588081359863281 32 80.608848571777344 33 74.686729431152344 34 70.098526000976563
		 35 66.4066162109375 36 62.449077606201172 37 57.446300506591797 38 51.346836090087891
		 39 47.895378112792969 40 44.798038482666016 41 40.497066497802734 42 40.460479736328125
		 43 39.319732666015625 44 41.505470275878906 45 42.419666290283203 46 42.019222259521484
		 47 40.382419586181641 48 37.770095825195312 49 34.639244079589844 50 32.620307922363281
		 51 30.319517135620117 52 28.439559936523438 53 27.130233764648437 54 25.977161407470703
		 55 26.010900497436523 56 25.485263824462891 57 24.496219635009766 58 24.442058563232422
		 59 23.902299880981445 60 23.33057975769043 61 22.67915153503418 62 21.891119003295898
		 63 21.475614547729492 64 21.502336502075195 65 21.503494262695313 66 21.444318771362305
		 67 21.348798751831055 68 21.348798751831055 69 21.348798751831055;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "D56DFC50-4C44-3CE3-9A73-0089B97C9793";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -18.755226135253906 1 -17.747278213500977
		 2 -16.043655395507813 3 -13.503537178039551 4 -10.571211814880371 5 -7.8545694351196289
		 6 -5.6469650268554687 7 -2.7723636627197266 8 0.04920196533203125 9 2.3552112579345703
		 10 3.2800655364990234 11 2.9886112213134766 12 2.1540412902832031 13 1.6013450622558594
		 14 1.078028678894043 15 0.63461875915527344 16 0.081381797790527344 17 -0.75979804992675781
		 18 -1.071502685546875 19 -2.1172971725463867 20 -2.347959041595459 21 -0.89417266845703125
		 22 1.1270599365234375 23 3.8319144248962402 24 8.0824337005615234 25 13.396794319152832
		 26 19.545061111450195 27 26.147237777709961 28 32.756397247314453 29 40.093429565429687
		 30 48.676517486572266 31 57.65362548828125 32 65.9627685546875 33 73.224678039550781
		 34 80.665908813476562 35 89.306732177734375 36 98.526229858398438 37 108.11754608154297
		 38 117.49760437011719 39 120.47547149658203 40 123.86620330810547 41 126.85267639160156
		 42 128.72225952148437 43 129.76139831542969 44 129.53791809082031 45 128.71226501464844
		 46 127.52142333984375 47 126.24028015136719 48 125.11018371582031 49 124.33417510986328
		 50 123.78065490722656 51 122.90740203857422 52 121.97874450683594 53 121.67977905273438
		 54 121.56782531738281 55 121.16134643554687 56 120.9058837890625 57 120.98739624023437
		 58 121.41845703125 59 121.76318359375 60 121.81965637207031 61 121.78169250488281
		 62 121.74681091308594 63 121.89930725097656 64 121.84685516357422 65 121.81411743164062
		 66 121.83877563476562 67 121.88485717773437 68 121.88485717773437 69 121.88485717773437;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "CB445A0F-4977-58D4-24FC-E39B3D3D2178";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -59.579557442263429 1 -59.827336734390137
		 2 -60.740570584462176 3 -61.960716697593142 4 -62.743313836003885 5 -62.183500503199589
		 6 -59.524653721026596 7 -54.783759220778059 8 -49.550404965785134 9 -41.164732241926473
		 10 -29.423115206315615 11 -9.9772442939795116 12 9.9200632407459182 13 20.726845827286272
		 14 29.039127332944918 15 35.72363715726754 16 41.573049336692506 17 45.633502150318648
		 18 52.635011948359654 19 57.767695161233398 20 63.04816283864379 21 65.583757850987851
		 22 70.006806444889449 23 73.93770336338622 24 72.062069632691049 25 66.933236673212761
		 26 59.649481158856581 27 51.064468953080748 28 43.151564888875008 29 36.927456696619011
		 30 29.353860414525226 31 16.834276369276786 32 -1.7005881898453361 33 -23.313269773800961
		 34 -39.546646575010257 35 -47.783827223888736 36 -49.763110283295859 37 -47.034219252928217
		 38 -45.02925099187587 39 -34.296855790772113 40 -22.113982820729756 41 -18.189859035909372
		 42 -8.90410601101234 43 -0.2767061631579944 44 -1.916958300452642 45 -6.2888955801862299
		 46 -11.702966728879824 47 -17.293347401973914 48 -22.148847327706033 49 -25.26488433412209
		 50 -19.457082572332581 51 -15.28249882921947 52 -10.147011366770267 53 -7.0303627881471105
		 54 -7.4316724686891025 55 -9.4612245342788306 56 -12.565442636643127 57 -15.848120592650067
		 58 -16.714208571126353 59 -17.490208204844627 60 -17.490203863601728 61 -17.490207695347177
		 62 -17.490217656431913 63 -17.490203806649781 64 -17.490196067364909 65 -17.490199709281956
		 66 -17.490191195490535 67 -17.49019447236088 68 -17.49019447236088 69 -17.49019447236088;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "2D09FD1D-4E7F-3C07-8EB0-E38535601D87";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 1.9133004235164928 1 5.0118783533060967
		 2 9.5525944981145123 3 14.692520207088204 4 19.610603076941018 5 23.874731825990729
		 6 28.067499415798277 7 33.387511481997727 8 40.272230166200877 9 49.172527790543761
		 10 56.72419848133832 11 60.113142190801341 12 57.50732493619752 13 52.769200494502698
		 14 49.055707134310659 15 47.161209827735156 16 47.841147776475459 17 52.820358888604552
		 18 52.17967109333371 19 57.890335849538651 20 61.093968851797079 21 60.390561405237385
		 22 57.715955350942039 23 54.256729034655933 24 52.5085208809734 25 51.842051027753421
		 26 52.059492601493169 27 52.989135323710883 28 54.044810309543507 29 51.896726124271574
		 30 46.945572129221787 31 43.407114633832322 32 41.816303482657823 33 38.713525794974075
		 34 33.675450622668464 35 32.009759569363865 36 35.865692335828243 37 41.952497530014369
		 38 45.324118364810765 39 29.132475484541182 40 10.198147401517907 41 -7.8528136034616756
		 42 -13.298882640669099 43 -15.563312081642145 44 -16.900198296304428 45 -15.648595559037659
		 46 -12.545690301588259 47 -8.6903368131821548 48 -5.0004199198263093 49 -2.1141084020124561
		 50 -4.7318861074677043 51 -7.9718393177849363 52 -8.9116890873286003 53 -8.7286560913642823
		 54 -7.7083289353565538 55 -6.2518667167316035 56 -4.9515165593089447 57 -4.1923302728174026
		 58 -4.9862435911875744 59 -5.7197714221003855 60 -5.7197553786163882 61 -5.7197727817393753
		 62 -5.7197692012380239 63 -5.7197647146257875 64 -5.719774878360238 65 -5.7197711276696399
		 66 -5.7197613078509093 67 -5.7197773974391755 68 -5.7197773974391755 69 -5.7197773974391755;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "F8CA778E-440C-8845-9C5B-A69C6DEDFA3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 96.938846686893143 1 102.17594537140444
		 2 111.61253235610481 3 122.44702095268606 4 132.11067116874386 5 139.00166364835047
		 6 142.53610281861191 7 141.40049967716212 8 140.13135785306392 9 142.48067772504061
		 10 148.06852051864485 11 159.10716294421448 12 168.51730774512228 13 170.21771437583061
		 14 170.37711635230698 15 169.87163426492663 16 168.65867983959342 17 165.50432977665429
		 18 169.80338975035426 19 170.84928979255002 20 174.2538548716513 21 177.16309328443228
		 22 181.45468528368357 23 184.75945484384573 24 184.21827322227051 25 181.56982672824216
		 26 177.26968145920219 27 171.3693923146308 28 164.64273305427119 29 160.17140702840868
		 30 157.96816539271344 31 154.05288734560412 32 144.40885167726742 33 128.74746889833676
		 34 114.93564254198124 35 107.1605959159798 36 104.3071217073045 37 103.86509277406404
		 38 101.43870621723028 39 101.67987873345562 40 101.57773501667997 41 101.12827153417112
		 42 104.77689539134991 43 104.08908083906114 44 106.0326056927468 45 107.46787355390612
		 46 108.08346205888381 47 107.94376380879383 48 107.27503236972596 49 106.27945819501655
		 50 106.20174243837124 51 105.58068705700889 52 105.78919665148848 53 105.73248186656627
		 54 106.30307956220629 55 106.75185178993115 56 106.96354712014789 57 106.91089644704783
		 58 106.84303257741901 59 106.72354126134876 60 106.72353893438475 61 106.72354894700348
		 62 106.72356705845355 63 106.72354022939686 64 106.72355053354831 65 106.72355872871817
		 66 106.72354912492817 67 106.72355078901452 68 106.72355078901452 69 106.72355078901452;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA";
	rename -uid "45F240EF-42C5-617C-E32A-B39CE4DF2DCB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -29.125669479370117 1 -29.379190444946289
		 2 -30.015735626220703 3 -30.785467147827148 4 -31.477611541748047 5 -31.931484222412109
		 6 -32.022491455078125 7 -36.957389831542969 8 -37.558418273925781 9 -37.485679626464844
		 10 -37.035797119140625 11 -36.48211669921875 12 -36.068328857421875 13 -35.819541931152344
		 14 -35.551040649414063 15 -35.116668701171875 16 -34.518733978271484 17 -33.854705810546875
		 18 -33.841262817382813 19 -33.671913146972656 20 -33.490943908691406 21 -33.382362365722656
		 22 -33.403465270996094 23 -33.542274475097656 24 -33.755409240722656 25 -34.06512451171875
		 26 -34.476829528808594 27 -34.964698791503906 28 -35.242729187011719 29 -35.592460632324219
		 30 -37.646701812744141 31 -40.192611694335937 32 -42.316303253173828 33 -43.995353698730469
		 34 -45.087699890136719 35 -45.538227081298828 36 -45.486709594726563 37 -44.893638610839844
		 38 -43.991127014160156 39 -44.462608337402344 40 -45.121894836425781 41 -46.733451843261719
		 42 -48.873039245605469 43 -50.809123992919922 44 -49.480369567871094 45 -46.762996673583984
		 46 -45.525157928466797 47 -45.308250427246094 48 -45.706169128417969 49 -46.542209625244141
		 50 -47.469589233398438 51 -47.540023803710938 52 -46.421520233154297 53 -44.984001159667969
		 54 -42.957870483398438 55 -43.227806091308594 56 -43.241073608398437 57 -42.655342102050781
		 58 -41.521331787109375 59 -40.014297485351563 60 -38.52008056640625 61 -37.32244873046875
		 62 -36.314994812011719 63 -36.154956817626953 64 -36.21221923828125 65 -36.254138946533203
		 66 -36.2093505859375 67 -36.133323669433594 68 -36.133323669433594 69 -36.133323669433594;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA";
	rename -uid "269D6202-46CB-7897-6BE3-709CC4713140";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 76.294174194335938 1 76.380996704101563
		 2 76.096923828125 3 75.386955261230469 4 74.122222900390625 5 72.18988037109375 6 69.536758422851563
		 7 70.912574768066406 8 69.722183227539062 9 67.524147033691406 10 64.719497680664062
		 11 61.642696380615234 12 58.463718414306641 13 55.223106384277344 14 51.867965698242187
		 15 48.218215942382813 16 44.325363159179688 17 40.474166870117188 18 39.689136505126953
		 19 38.617652893066406 20 37.363407135009766 21 36.537532806396484 22 36.734085083007813
		 23 37.715656280517578 24 38.867538452148438 25 40.182048797607422 26 41.698509216308594
		 27 43.286823272705078 28 44.893280029296875 29 47.267604827880859 30 50.780235290527344
		 31 54.041938781738281 32 57.013053894042969 33 59.881546020507813 34 62.983112335205078
		 35 66.3372802734375 36 69.541893005371094 37 71.289276123046875 38 69.934135437011719
		 39 68.307403564453125 40 65.376335144042969 41 61.416095733642578 42 55.348529815673828
		 43 46.155223846435547 44 40.151248931884766 45 36.76593017578125 46 35.752105712890625
		 47 34.985366821289063 48 33.890064239501953 49 32.564582824707031 50 31.25408935546875
		 51 30.532123565673828 52 29.261447906494141 53 28.048381805419922 54 26.591224670410156
		 55 27.150171279907227 56 27.091062545776367 57 26.31439208984375 58 25.937784194946289
		 59 25.090145111083984 60 24.081298828125 61 23.386676788330078 62 22.820201873779297
		 63 22.404689788818359 64 22.431407928466797 65 22.432573318481445 66 22.373386383056641
		 67 22.277877807617188 68 22.277877807617188 69 22.277877807617188;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "AC191D04-426E-9A85-9D7D-D881B84B6DE9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -47.56915283203125 1 -45.455734252929688
		 2 -43.650577545166016 3 -42.0357666015625 4 -40.477813720703125 5 -38.776329040527344
		 6 -36.664840698242187 7 -38.329483032226563 8 -38.823444366455078 9 -38.556507110595703
		 10 -37.689662933349609 11 -36.232067108154297 12 -34.481143951416016 13 -32.927280426025391
		 14 -31.801364898681641 15 -31.099922180175781 16 -30.73297119140625 17 -30.621299743652344
		 18 -29.103931427001953 19 -28.071128845214844 20 -26.948282241821289 21 -25.237506866455078
		 22 -22.473831176757813 23 -18.782119750976562 24 -14.77778434753418 25 -10.481466293334961
		 26 -5.6497001647949219 27 -0.043620109558105469 28 6.1671848297119141 29 10.901827812194824
		 30 14.794164657592773 31 20.341926574707031 32 26.565853118896484 33 32.862926483154297
		 34 39.230709075927734 35 46.105865478515625 36 54.306858062744141 37 64.451934814453125
		 38 75.681442260742187 39 82.635597229003906 40 88.638229370117187 41 92.288894653320312
		 42 95.230369567871094 43 97.740013122558594 44 97.985336303710938 45 96.880615234375
		 46 95.160858154296875 47 93.149131774902344 48 91.173736572265625 49 89.552444458007813
		 50 88.081413269042969 51 86.212875366210938 52 84.079032897949219 53 82.527679443359375
		 54 81.34722900390625 55 80.434219360351563 56 79.642105102539063 57 79.044357299804687
		 58 78.633171081542969 59 78.170326232910156 60 77.717643737792969 61 77.243217468261719
		 62 76.799858093261719 63 76.952377319335937 64 76.899894714355469 65 76.867172241210938
		 66 76.891830444335937 67 76.93792724609375 68 76.93792724609375 69 76.93792724609375;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "E9111D40-44B8-A978-CA7B-909211A33850";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -43.938724910213999 1 -41.271157046328256
		 2 -36.20872113073623 3 -31.99077869434889 4 -31.103418902164364 5 -35.094398964141817
		 6 -42.358183564772759 7 51.194874034336578 8 39.6413839001832 9 27.32951691495354
		 10 16.908959270051643 11 9.0825462985179151 12 1.758725985897954 13 -7.3179383905993349
		 14 -18.362125734476333 15 -29.700191416229831 16 -39.025853401495375 17 -45.184968325600956
		 18 -45.893345674443012 19 -47.481004213796858 20 -49.213137834542493 21 -50.389832061462592
		 22 -50.327319859487886 23 -48.516419427790609 24 -44.648859378387087 25 -36.973892348227409
		 26 -21.942651289531224 27 6.2663161473452975 28 40.880018574147265 29 67.06620547354072
		 30 102.65872229164944 31 144.27344961593101 32 167.43475106997352 33 176.5635629240688
		 34 175.70766121209786 35 167.01865114979316 36 154.1913610607148 37 140.34427877220597
		 38 129.05119544800314 39 126.66088320887798 40 127.55589296393286 41 136.25728086021064
		 42 150.78825983257755 43 170.54751782629518 44 195.06718084654582 45 213.65131448749673
		 46 225.65704390567211 47 230.74794582566827 48 230.84465427019467 49 225.61960825453855
		 50 215.57623431992278 51 203.69139853811407 52 192.4089970718436 53 184.39646838319882
		 54 181.18637706651162 55 183.40635615325249 56 189.46507696862585 57 198.67405441714544
		 58 209.40994638514721 59 219.12866631000793 60 225.65615142375728 61 227.66545939252427
		 62 226.94410767067615 63 226.94412215085171 64 226.94411376849106 65 226.94410940280429
		 66 226.94410794192035 67 226.94411816992684 68 226.94411816992684 69 226.94411816992684;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "0BE682F8-4673-10D0-9453-2495C93B3B7C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -49.854466703769347 1 -50.308269691543735
		 2 -50.661638664220909 3 -50.407006939976753 4 -50.255740680760667 5 -50.866376273373788
		 6 -52.335876629814535 7 -70.898279938662867 8 -73.581130082308263 9 -73.143481116844441
		 10 -70.940865712662159 11 -68.036805104543362 12 -65.305149633268783 13 -62.977785988541086
		 14 -60.415439525728324 15 -56.678682514551355 16 -51.382903980540611 17 -44.773293705178865
		 18 -44.499169622875364 19 -43.15275799231889 20 -42.289386891646359 21 -42.866254578934509
		 22 -45.864338799894092 23 -50.769776610011455 24 -56.256572200121859 25 -62.013685585840008
		 26 -67.338414442824202 27 -70.161792618618435 28 -67.278411969234881 29 -65.602738579027559
		 30 -69.792856854867068 31 -68.293798180710169 32 -62.623209091113978 33 -56.9007249752352
		 34 -51.847778391375101 35 -46.933395095303425 36 -41.229598519303408 37 -33.100988860686265
		 38 -21.629497391890336 39 -19.634623505256062 40 -19.175580483613778 41 -22.354548748161545
		 42 -20.624567897176192 43 -10.701647456021558 44 -2.1187431761835089 45 -2.295428590383493
		 46 3.7511260342407362 47 8.1965905195278701 48 11.783262795018523 49 13.577252181769127
		 50 11.49071892608247 51 3.3005812819005582 52 -5.3951156089198173 53 -11.882191335766525
		 54 -15.541784077082957 55 -12.354170343784698 56 -7.254662759251775 57 -1.640163681639341
		 58 2.4732172358548974 59 3.2318271593854755 60 0.68044967511407128 61 -4.1045918959892802
		 62 -9.3183495627728146 63 -9.3183418739646608 64 -9.3183432377930355 65 -9.3183544967457532
		 66 -9.3183472700535734 67 -9.3183365727905496 68 -9.3183365727905496 69 -9.3183365727905496;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "F9415C58-4D12-1B50-E941-65B083C9CD23";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 20.436356385184567 1 15.457682702855537
		 2 4.2231060420835167 3 -8.4500807208999564 4 -17.832190575355309 5 -19.527765287586035
		 6 -14.849938503007648 7 -24.421402196871139 8 -15.004203389432019 9 -7.3418411748410133
		 10 -3.5285728921399411 11 -3.6420613054515303 12 -4.6772810581763142 13 -3.2284404985878568
		 14 1.8354527870252468 15 9.2975421197868524 16 16.980076693569352 17 23.835767498335084
		 18 24.177393691889254 19 27.108066767768729 20 30.414392126369574 21 32.885648583107056
		 22 33.444641002099289 23 32.029002498728715 24 29.113774072975833 25 23.272433159402873
		 26 11.47867975451868 27 -11.133193129823134 28 -35.562400182955926 29 -43.32060506689109
		 30 -54.882382014605632 31 -77.417725960387486 32 -90.842800141240829 33 -97.083523289375819
		 34 -98.880880406500566 35 -97.522839797647009 36 -94.042772775211603 37 -88.863005810971615
		 38 -83.520128133966764 39 -83.374845678192059 40 -84.411319884574922 41 -88.938477247953728
		 42 -94.737520949153264 43 -98.413095036972408 44 -91.581827501413812 45 -80.6904242799786
		 46 -74.931907870586983 47 -73.089905416235766 48 -74.273208765636028 49 -78.419776962373248
		 50 -84.504549025502769 51 -89.492446046158776 52 -92.241883541605716 53 -92.662106384580781
		 54 -91.109046016478885 55 -91.510507567438651 56 -91.426904333009333 57 -90.200026924765211
		 58 -87.714851178701807 59 -84.651657883208543 60 -81.961474787710827 61 -79.984032068592313
		 62 -78.086188086606597 63 -78.086182014751273 64 -78.086203535701728 65 -78.08618234395999
		 66 -78.086182267073966 67 -78.086171411306225 68 -78.086171411306225 69 -78.086171411306225;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA";
	rename -uid "BB0C6CFD-4447-2A3E-8668-9DAF7B891B99";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.4926691055297852 1 2.4977626800537109
		 2 2.5070257186889648 3 2.5266382694244385 4 2.554509162902832 5 2.587852954864502
		 6 2.6235966682434082 7 2.6586704254150391 8 2.6903672218322754 9 2.7162966728210449
		 10 2.7234363555908203 11 2.7004404067993164 12 2.6514239311218262 13 2.5861353874206543
		 14 2.5121161937713623 15 2.434715747833252 16 2.3656821250915527 17 2.3245444297790527
		 18 2.3404664993286133 19 2.2897684574127197 20 2.1533551216125488 21 1.9640860557556152
		 22 1.7655496597290039 23 1.6057661771774292 24 1.5105693340301514 25 1.486357569694519
		 26 1.5293885469436646 27 1.5897009372711182 28 1.5880162715911865 29 1.5074559450149536
		 30 1.4109666347503662 31 1.268385648727417 32 1.0944774150848389 33 0.92968893051147461
		 34 0.79070174694061279 35 0.70684850215911865 36 0.61788308620452881 37 0.52195644378662109
		 38 0.43780648708343506 39 0.46358656883239746 40 0.78119838237762451 41 1.2907702922821045
		 42 1.7274612188339233 43 1.8927569389343262 44 1.7299411296844482 45 1.3382875919342041
		 46 0.8259894847869873 47 0.30875682830810547 48 -0.072671175003051758 49 -0.17537176609039307
		 50 0.070981502532958984 51 0.78928184509277344 52 2.0478968620300293 53 2.9689946174621582
		 54 3.9810843467712402 55 3.3637347221374512 56 2.8247036933898926 57 2.5302948951721191
		 58 2.4198808670043945 59 2.5466980934143066 60 2.8358826637268066 61 3.1533665657043457
		 62 3.4954438209533691 63 3.6554765701293945 64 3.5982136726379395 65 3.5562944412231445
		 66 3.6010756492614746 67 3.6771245002746582 68 3.6771245002746582 69 3.6771245002746582;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA";
	rename -uid "89FC3063-4CFA-D7A7-4136-9E99F4D1A215";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 55.052642822265625 1 55.145721435546875
		 2 55.145122528076172 3 55.082691192626953 4 54.929252624511719 5 54.656536102294922
		 6 54.237701416015625 7 53.647563934326172 8 52.862533569335938 9 51.860313415527344
		 10 50.673770904541016 11 49.237892150878906 12 47.431415557861328 13 45.186981201171875
		 14 42.385993957519531 15 38.869277954101563 16 34.674610137939453 17 29.98516845703125
		 18 29.994350433349609 19 30.114652633666992 20 30.212163925170898 21 30.265811920166016
		 22 30.258661270141602 23 30.196722030639648 24 30.088905334472656 25 29.96537971496582
		 26 29.924488067626953 27 29.963142395019531 28 30.064168930053711 29 30.174142837524414
		 30 30.241233825683594 31 30.452207565307617 32 30.952663421630859 33 31.761137008666992
		 34 32.931991577148438 35 34.423141479492188 36 36.287113189697266 37 38.200839996337891
		 38 39.696765899658203 39 40.919612884521484 40 42.177452087402344 41 43.243751525878906
		 42 44.193515777587891 43 44.523139953613281 44 44.130252838134766 45 43.177497863769531
		 46 41.858867645263672 47 40.356658935546875 48 38.832141876220703 49 37.575714111328125
		 50 36.054962158203125 51 34.240879058837891 52 32.100650787353516 53 30.754230499267578
		 54 29.432193756103516 55 29.715991973876953 56 29.826761245727539 57 29.642705917358398
		 58 30.047176361083984 59 29.917924880981445 60 29.34619140625 61 28.694772720336914
		 62 27.906747817993164 63 27.491231918334961 64 27.517955780029297 65 27.519121170043945
		 66 27.459934234619141 67 27.364437103271484 68 27.364437103271484 69 27.364437103271484;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA";
	rename -uid "BF8F79B2-40D4-8FA5-DFB2-17BD17BAB83D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -23.977390289306641 1 -21.66497802734375
		 2 -19.275867462158203 3 -16.799701690673828 4 -14.253216743469238 5 -11.65425968170166
		 6 -9.0216302871704102 7 -6.3749284744262695 8 -3.734081506729126 9 -1.1191360950469971
		 10 1.4066944122314453 11 3.8106951713562012 12 6.1362056732177734 13 8.4374179840087891
		 14 10.748930931091309 15 13.058852195739746 16 15.267153739929199 17 17.287082672119141
		 18 19.063741683959961 19 21.172998428344727 20 23.291080474853516 21 25.407577514648438
		 22 27.510589599609375 23 29.58648681640625 24 31.495233535766602 25 33.160018920898438
		 26 34.744598388671875 27 36.312976837158203 28 37.900211334228516 29 39.467365264892578
		 30 40.946842193603516 31 42.28076171875 32 43.509227752685547 33 44.752765655517578
		 34 46.121623992919922 35 47.792167663574219 36 50.19793701171875 37 53.436023712158203
		 38 56.916313171386719 39 58.941459655761719 40 60.686737060546875 41 61.957851409912109
		 42 62.694877624511719 43 62.991050720214844 44 62.873062133789063 45 62.401756286621094
		 46 61.627250671386719 47 60.585773468017578 48 59.358055114746094 49 58.106925964355469
		 50 56.809684753417969 51 55.439849853515625 52 54.222427368164062 53 53.747947692871094
		 54 53.595157623291016 55 53.126445770263672 56 52.758647918701172 57 52.692192077636719
		 58 52.923965454101563 59 53.080398559570313 60 53.136863708496094 61 53.098896026611328
		 62 53.06402587890625 63 53.216522216796875 64 53.164058685302734 65 53.131332397460938
		 66 53.155986785888672 67 53.202072143554687 68 53.202072143554687 69 53.202072143554687;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX";
	rename -uid "A03FC19C-49EB-7F64-9FE9-8C8D9D60D2DB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.38685748800602 1 2.3734924827847799
		 2 2.3252912308264948 3 2.2475758170021765 4 2.1456326213605159 5 2.0251810111890869
		 6 1.892696180197132 7 1.7556576521639202 8 1.6224719992757213 9 1.5024615788754152
		 10 1.4051021225765945 11 1.3395293387697558 12 1.2939948730304625 13 1.2520595749975287
		 14 1.2149852208403173 15 1.1840022595373749 16 1.1603234311598978 17 1.1452297539838883
		 18 1.0875302052823614 19 0.96418564214644098 20 0.81930505797163611 21 0.69689614981317305
		 22 0.63508929454836338 23 0.61726027621154689 24 0.60248513351405864 25 0.59066492961820838
		 26 0.5817450098466157 27 0.57559826200663522 28 0.57223225033480307 29 0.57151794257162336
		 30 0.57340283048400398 31 0.57780484257777953 32 0.58467801717895429 33 0.59390702176767385
		 34 0.64749515104947308 35 0.77195766216853956 36 0.94417466405462602 37 1.1718914160430298
		 38 1.4572666532890839 39 1.7656314550386953 40 2.0647704614038234 41 2.2343217980620445
		 42 2.4252986901656111 43 2.6389124734077898 44 2.4950977833037027 45 2.3753515236819247
		 46 2.3007680755944988 47 2.2782377058826966 48 2.3107635937737037 49 2.3870367902278029
		 50 2.4810398677808974 51 2.5300503786133159 52 2.582485089326862 53 2.6287865976905902
		 54 2.6287877688369954 55 2.628778182991482 56 2.628779378428852 57 2.6287790667453916
		 58 2.6287777359876325 59 2.6287776462819523 60 2.628779378428852 61 2.628782532285443
		 62 2.6287776462819523 63 2.6287702101550043 64 2.6287877842599814 65 2.6287762013424731
		 66 2.628778182991482 67 2.6287777359876325 68 2.6287777359876325 69 2.6287777359876325;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY";
	rename -uid "D3767818-4D55-1B34-67E9-108170AB8E77";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 15.334581556883355 1 15.361177107316012
		 2 15.443120277215895 3 15.56682367250658 4 15.718883851193723 5 15.886238919787475
		 6 16.056598122481912 7 16.219330811043992 8 16.364516267977766 9 16.483649608346166
		 10 16.568104672249703 11 16.609042429923157 12 16.624573023398039 13 16.639073038420875
		 14 16.65196448645974 15 16.662902811544512 16 16.671187198677721 17 16.67655494096844
		 18 16.685222759562983 19 16.706795073009353 20 16.743471443536627 21 16.786300090689483
		 22 16.814480317066288 23 16.826096386805901 24 16.835845100086019 25 16.843603721976695
		 26 16.849498143862622 27 16.85352723103064 28 16.85580358528674 29 16.856262947857381
		 30 16.855011723628579 31 16.852095032518942 32 16.847576344826319 33 16.841468045438432
		 34 16.817596312139678 35 16.766678540021065 36 16.699559364589597 37 16.608059510686051
		 38 16.489135496939507 39 16.374258151772104 40 16.29277712995972 41 16.279956870320138
		 42 16.289213137882015 43 16.305859498381768 44 16.331841802237143 45 16.352040449735821
		 46 16.362435481717757 47 16.361963997189765 48 16.350547885057868 49 16.331092705758227
		 50 16.309438408353486 51 16.301599536423236 52 16.293680175047641 53 16.287200686855005
		 54 16.287216602668718 55 16.287198428564587 56 16.287199877786072 57 16.287198286230769
		 58 16.287195715836948 59 16.287200205842392 60 16.287199877786072 61 16.287197609413681
		 62 16.287200205842392 63 16.287194887718815 64 16.287196648918862 65 16.287199176676289
		 66 16.287198428564587 67 16.287195715836948 68 16.287195715836948 69 16.287195715836948;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ";
	rename -uid "08782EA5-4270-0B93-1EC9-80B22206C5B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -1.4623857114996159 1 -1.6263113146484882
		 2 -2.1757019302718774 3 -3.0513407190484565 4 -4.1938758921775223 5 -5.5438192200334386
		 6 -7.0410055129849463 7 -8.6251153122387567 8 -10.235054719417731 9 -11.809511732870284
		 10 -13.28716156661827 11 -14.606728273183286 12 -15.77778183501438 13 -16.827039904468084
		 14 -17.718357106829128 15 -18.415847015109339 16 -18.883757728950663 17 -19.086090514062818
		 18 -19.106067444288609 19 -18.923110125034114 20 -18.334513963618303 21 -17.108872591990657
		 22 -15.015811044921787 23 -12.160367637283034 24 -8.815808606098452 25 -5.0039279309276523
		 26 -0.74695506078936624 27 3.9331182633931956 28 9.0144161986052165 29 14.474772349383507
		 30 20.2922365415888 31 26.444779829622664 32 32.910456324181311 33 39.667131068525102
		 34 46.920295576874608 35 54.792463337961351 36 63.137600590703698 37 72.00121669921154
		 38 81.387324129799211 39 83.894307969289599 40 86.296208673856725 41 87.857458872204347
		 42 89.313592319746476 43 90.618275104177599 44 89.630849175128404 45 88.524927254035788
		 46 87.528554741353787 47 86.793910749105464 48 86.453130734861745 49 86.88630546564913
		 50 87.427059822645546 51 87.719251088299231 52 88.030356440641512 53 88.303716321521463
		 54 88.303726449717217 55 88.303735901207446 56 88.30373587944959 57 88.303735962299896
		 58 88.303744895175086 59 88.303735537977175 60 88.30373587944959 61 88.303736640292371
		 62 88.303735537977175 63 88.303735454111788 64 88.303737325873612 65 88.303727062632433
		 66 88.303735901207446 67 88.303744895175086 68 88.303744895175086 69 88.303744895175086;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA";
	rename -uid "1EDD1BD7-4E3F-F3AA-CAD6-8D8D9854D820";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -1.555877685546875 1 -1.6256875991821289
		 2 -1.8370246887207031 3 -2.1426687240600586 4 -2.502354621887207 5 -2.8781490325927734
		 6 -3.2368917465209961 7 -3.5525498390197754 8 -3.806340217590332 9 -3.9869918823242187
		 10 -4.0984725952148437 11 -4.1437702178955078 12 -4.1634807586669922 13 -4.200922966003418
		 14 -4.249577522277832 15 -4.3053407669067383 16 -4.3574590682983398 17 -4.3877124786376953
		 18 -4.294097900390625 19 -4.1785821914672852 20 -4.1367959976196289 21 -4.1950864791870117
		 22 -4.3407778739929199 23 -4.4943108558654785 24 -4.5843048095703125 25 -4.6042704582214355
		 26 -4.5580253601074219 27 -4.4954729080200195 28 -4.4959526062011719 29 -4.5762505531311035
		 30 -4.6734209060668945 31 -4.817603588104248 32 -4.9940032958984375 33 -5.1621007919311523
		 34 -5.3452005386352539 35 -5.5354852676391602 36 -5.7639369964599609 37 -6.0078763961791992
		 38 -6.2146487236022949 39 -6.2968587875366211 40 -6.1113529205322266 41 -5.7584800720214844
		 42 -5.5368657112121582 43 -5.5887670516967773 44 -5.7225990295410156 45 -6.0720911026000977
		 46 -6.5437684059143066 47 -7.0344018936157227 48 -7.4099092483520508 49 -7.5224156379699707
		 50 -7.2902498245239258 51 -6.5886569023132324 52 -5.3472814559936523 53 -4.441002368927002
		 54 -3.4289140701293945 55 -4.0462527275085449 56 -4.5852847099304199 57 -4.8796982765197754
		 58 -4.9901061058044434 59 -4.8632936477661133 60 -4.5741057395935059 61 -4.2566242218017578
		 62 -3.9145479202270508 63 -3.7545089721679687 64 -3.8117809295654297 65 -3.8536953926086426
		 66 -3.8089118003845215 67 -3.7328629493713379 68 -3.7328629493713379 69 -3.7328629493713379;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA";
	rename -uid "7FC68C87-466A-AC09-50EC-41AF5820D5DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 99.050186157226563 1 99.111068725585938
		 2 98.972885131835938 3 98.63958740234375 4 98.04351806640625 5 97.124549865722656
		 6 95.844085693359375 7 94.193893432617188 8 92.199966430664063 9 89.920799255371094
		 10 87.495849609375 11 84.983642578125 12 82.23760986328125 13 79.104743957519531
		 14 75.508331298828125 15 71.332496643066406 16 66.658111572265625 17 61.709671020507813
		 18 61.130638122558594 19 60.045845031738281 20 58.813453674316406 21 58.061431884765625
		 22 58.464870452880859 23 59.775016784667969 24 61.275375366210938 25 62.933761596679688
		 26 64.77606201171875 27 66.717208862304688 28 68.648956298828125 29 70.419021606445313
		 30 71.871284484863281 31 73.085540771484375 32 74.101730346679688 33 74.838470458984375
		 34 75.17742919921875 35 74.533401489257813 36 72.47637939453125 37 68.135421752929688
		 38 60.654098510742187 39 56.160026550292969 40 51.501514434814453 41 48.857395172119141
		 42 46.027946472167969 43 42.604637145996094 44 44.890125274658203 45 46.429435729980469
		 46 46.933509826660156 47 46.350727081298828 48 44.680305480957031 49 42.07012939453125
		 50 38.862274169921875 51 36.139293670654297 52 33.034637451171875 53 30.843900680541992
		 54 29.521862030029297 55 29.805656433105469 56 29.916423797607422 57 29.732372283935547
		 58 30.136825561523437 59 30.007585525512695 60 29.435855865478516 61 28.784435272216797
		 62 27.996408462524414 63 27.580898284912109 64 27.60761833190918 65 27.608781814575195
		 66 27.549598693847656 67 27.454086303710938 68 27.454086303710938 69 27.454086303710938;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA";
	rename -uid "B9DB58B2-431A-6963-0489-A2B5689A1B08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -30.339809417724609 1 -28.260265350341797
		 2 -26.797428131103516 3 -25.818580627441406 4 -25.212970733642578 5 -24.865142822265625
		 6 -24.656438827514648 7 -24.470043182373047 8 -24.196807861328125 9 -23.741672515869141
		 10 -23.070854187011719 11 -22.138185501098633 12 -21.006984710693359 13 -19.756948471069336
		 14 -18.328689575195313 15 -16.712150573730469 16 -14.986706733703613 17 -13.217430114746094
		 18 -11.965030670166016 19 -10.83499813079834 20 -9.6469612121582031 21 -7.9447321891784668
		 22 -5.3379526138305664 23 -1.9808132648468018 24 1.5612561702728271 25 5.2401704788208008
		 26 9.2472038269042969 27 13.669445037841797 28 18.556905746459961 29 23.873661041259766
		 30 29.540130615234375 31 35.468238830566406 32 41.647701263427734 33 48.126724243164063
		 34 55.648952484130859 35 64.657073974609375 36 74.797317504882813 37 85.719062805175781
		 38 95.897506713867188 39 100.60350799560547 40 103.99641418457031 41 105.78020477294922
		 42 106.63887786865234 43 106.65376281738281 44 106.75684356689453 45 106.30406188964844
		 46 105.43037414550781 47 104.296875 48 103.06565093994141 49 101.90640258789062 50 100.65153503417969
		 51 99.270339965820313 52 98.015510559082031 53 97.486717224121094 54 97.333915710449219
		 55 96.865203857421875 56 96.497406005859375 57 96.430953979492188 58 96.662734985351563
		 59 96.819168090820313 60 96.875625610351563 61 96.837661743164063 62 96.80279541015625
		 63 96.955291748046875 64 96.902816772460938 65 96.870101928710938 66 96.894744873046875
		 67 96.940841674804688 68 96.940841674804688 69 96.940841674804688;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX";
	rename -uid "DD88C60A-4E39-844D-4B84-53890698237F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.47960888606056357 1 0.4223081042921496
		 2 0.2773439111931566 3 0.038270599081517261 4 -0.30225278511810733 5 -0.74178530520646646
		 6 -1.2619643867178676 7 -1.8276037441391522 8 -2.3889151276366047 9 -2.8871908252767025
		 10 -3.2608379408733636 11 -3.4524350209915302 12 -3.5326115917301166 13 -3.6044544565103234
		 14 -3.6662643239549872 15 -3.7167714242699574 16 -3.7544788969589611 17 -3.7782425853452501
		 18 -3.8382300234475548 19 -3.9359261235117584 20 -4.0102298699569596 21 -4.0444138764788544
		 22 -4.058673118381761 23 -4.0700360709440995 24 -4.0793665142948488 25 -4.0866207042249023
		 26 -4.0920558148457893 27 -4.0957269221654915 28 -4.0977841755804914 29 -4.0981963965262365
		 30 -4.0970750106519329 31 -4.0944246540820286 32 -4.0902988811057641 33 -4.0846287889064508
		 34 -4.0435522568442748 35 -3.9302810714740968 36 -3.7377438770279729 37 -3.4276625658062336
		 38 -2.9649283774318791 39 -2.4364774531824747 40 -1.9248897616469929 41 -1.6765843432960563
		 42 -1.3012862567673578 43 -0.76579695135988279 44 -1.1090678517961805 45 -1.3835415245050631
		 46 -1.5403379514552218 47 -1.5723355893974567 48 -1.4836004991256115 49 -1.3023948363953832
		 50 -1.0841053125617974 51 -0.97800370992674956 52 -0.86245860735408153 53 -0.75868889790675298
		 54 -0.75869228199137628 55 -0.75869946819480549 56 -0.75869855516840701 57 -0.75870088537056213
		 58 -0.75870167972872027 59 -0.75870186302954634 60 -0.75869855516840701 61 -0.75869284683435068
		 62 -0.75870186302954634 63 -0.75870771796819636 64 -0.75869180252391222 65 -0.75870198571870495
		 66 -0.75869946819480549 67 -0.75870167972872027 68 -0.75870167972872027 69 -0.75870167972872027;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY";
	rename -uid "84F90711-4983-F47D-AE63-53AC91E074AA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -4.164739284205921 1 -3.9984841205495374
		 2 -3.5053197945756485 3 -2.7803989759679526 4 -1.9227898694720036 5 -1.0272766554271937
		 6 -0.17684966123829957 7 0.5639026602395214 8 1.1509964656499305 9 1.5608202847388184
		 10 1.783033513329388 11 1.8098534338038768 12 1.7350863668878889 13 1.6642178444031235
		 14 1.5999276520304977 15 1.545152419272398 16 1.50255481085383 17 1.4751381993801351
		 18 1.2969010334929183 19 0.9184976008350032 20 0.51448391142627348 21 0.21795029182183187
		 22 0.096485057003764307 23 0.079083677186407755 24 0.064580617238597163 25 0.052896899053470482
		 26 0.04402617388438658 27 0.03787735507037604 28 0.034529588268453315 29 0.03381974211106157
		 30 0.035701029935793577 31 0.040104175430470831 32 0.046933607430438271 33 0.056091813475331452
		 34 0.16015942436331654 35 0.41189937261292536 36 0.74727330742679055 37 1.1171057472920536
		 38 1.4439178835311117 39 1.7287424341575313 40 2.045077689216765 41 2.3965357822544617
		 42 2.8707921944590238 43 3.3371388002009041 44 3.2831984037574324 45 3.1923701172343955
		 46 3.1013653811583688 47 3.041605028489569 48 3.028894315707733 49 3.0504890300135816
		 50 3.0790430671260607 51 3.1136138812012404 52 3.1483363889724822 53 3.1772149533244423
		 54 3.1772169742186773 55 3.1772122798996185 56 3.1772172847351006 57 3.1772238733157963
		 58 3.1772317361701261 59 3.1772232959758773 60 3.1772172847351006 61 3.1772206355458166
		 62 3.1772232959758773 63 3.1772191403621464 64 3.1772214152646878 65 3.177222947199327
		 66 3.1772122798996185 67 3.1772317361701261 68 3.1772317361701261 69 3.1772317361701261;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ";
	rename -uid "DB26DD48-483E-CC1C-3E70-258E9CAF580B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -28.286751832919659 1 -28.705905569555323
		 2 -30.469833199195843 3 -33.346587883318335 4 -37.104651922280212 5 -41.51142077758815
		 6 -46.330753160503441 7 -51.32220182147357 8 -56.240579135837059 9 -60.837179492974393
		 10 -64.862138958404728 11 -68.066182488960251 12 -70.683150841367279 13 -73.062764717249564
		 14 -75.130019569421165 15 -76.809898869027464 16 -78.027737574083034 17 -78.70861503137229
		 18 -80.531748567653338 19 -84.292387984619097 20 -88.514068961988471 21 -91.520434837260936
		 22 -91.632689008857724 23 -89.429482596933198 24 -86.626001573029555 25 -83.246795684019929
		 26 -79.316698898903581 27 -74.860463950263778 28 -69.902692728674353 29 -64.468218292114571
		 30 -58.581661150540903 31 -52.26781027055258 32 -45.551267076849527 33 -38.456889605462756
		 34 -29.482442010021565 35 -17.680738168416902 36 -3.9085003620508192 37 12.274768998276796
		 38 31.026250510856872 39 43.869388190353796 40 56.501801212678437 41 64.192861595734925
		 42 72.129090435961302 43 80.239030660024568 44 74.485617212840637 45 69.355330810394108
		 46 65.778690351527743 47 64.172209504589446 48 64.818625290123421 49 67.743275516454233
		 50 71.39516626405306 51 73.369037898325772 52 75.470302447961288 53 77.317020633849239
		 54 77.317020060915269 55 77.317019656077534 56 77.317020425270954 57 77.317020286247839
		 58 77.317032976139558 59 77.317020281808013 60 77.317020425270954 61 77.3170094188647
		 62 77.317020281808013 63 77.317032292435982 64 77.31700942097828 65 77.317009253052746
		 66 77.317019656077534 67 77.317032976139558 68 77.317032976139558 69 77.317032976139558;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA";
	rename -uid "E9984678-49BE-D7E0-AD54-56A191BBCAAB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 22.761833190917969 1 22.765720367431641
		 2 22.777647018432617 3 22.798574447631836 4 22.829263687133789 5 22.870262145996094
		 6 22.922033309936523 7 22.98499870300293 8 23.059581756591797 9 23.146236419677734
		 10 23.266376495361328 11 23.455730438232422 12 23.726348876953125 13 24.063470840454102
		 14 24.403846740722656 15 24.622474670410156 16 24.752826690673828 17 24.951858520507813
		 18 25.699127197265625 19 25.751283645629883 20 25.790088653564453 21 25.643041610717773
		 22 25.216793060302734 23 24.559324264526367 24 23.848392486572266 25 23.315488815307617
		 26 23.172342300415039 27 23.015111923217773 28 22.837783813476562 29 22.880603790283203
		 30 23.056388854980469 31 23.140054702758789 32 23.000381469726563 33 22.703758239746094
		 34 22.353853225708008 35 22.059196472167969 36 21.902793884277344 37 21.925411224365234
		 38 22.107561111450195 39 22.401082992553711 40 22.843585968017578 41 23.269634246826172
		 42 23.149738311767578 43 22.215208053588867 44 20.756454467773438 45 19.270296096801758
		 46 18.333917617797852 47 18.381669998168945 48 19.702472686767578 49 22.278768539428711
		 50 26.166477203369141 51 31.26005744934082 52 36.838230133056641 53 38.153709411621094
		 54 39.171962738037109 55 37.652069091796875 56 36.216690063476562 57 35.103645324707031
		 58 34.509552001953125 59 34.810264587402344 60 35.919754028320313 61 36.975532531738281
		 62 38.307155609130859 63 38.741909027099609 64 38.921733856201172 65 38.919826507568359
		 66 38.927791595458984 67 38.940101623535156 68 38.940101623535156 69 38.940101623535156;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA";
	rename -uid "4D210773-4617-08E2-D2B2-B7AD86525190";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 10.344830513000488 1 10.645644187927246
		 2 10.939857482910156 3 11.22264575958252 4 11.489948272705078 5 11.739033699035645
		 6 11.968201637268066 7 12.176620483398438 8 12.363934516906738 9 12.529690742492676
		 10 13.840699195861816 11 16.780677795410156 12 20.249834060668945 13 23.1173095703125
		 14 24.281967163085938 15 22.597543716430664 16 19.027626037597656 17 15.623374938964844
		 18 16.123699188232422 19 16.418434143066406 20 16.582923889160156 21 16.502008438110352
		 22 16.016088485717773 23 14.973793029785156 24 13.295000076293945 25 11.15389347076416
		 26 9.8759441375732422 27 9.1663455963134766 28 8.7498874664306641 29 8.1907539367675781
		 30 8.0849685668945313 31 9.6851234436035156 32 13.659906387329102 33 19.976306915283203
		 34 28.798547744750977 35 39.481189727783203 36 50.763153076171875 37 61.141895294189453
		 38 69.471755981445312 39 72.955436706542969 40 74.173332214355469 41 73.781105041503906
		 42 72.763603210449219 43 71.392257690429687 44 69.652946472167969 45 67.000213623046875
		 46 63.010017395019531 47 57.867153167724609 48 51.910770416259766 49 45.993263244628906
		 50 38.852275848388672 51 29.684333801269531 52 19.437210083007813 53 14.923843383789063
		 54 10.733038902282715 55 13.314403533935547 56 16.513570785522461 57 18.75401496887207
		 58 18.703439712524414 59 16.205196380615234 60 12.391254425048828 61 9.8393325805664062
		 62 6.8499155044555664 63 6.3568916320800781 64 6.1592597961425781 65 6.1538419723510742
		 66 6.1431856155395508 67 6.1275005340576172 68 6.1275005340576172 69 6.1275005340576172;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA";
	rename -uid "75E444CD-4193-0616-8AFB-80A1032A7F29";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -18.461584091186523 1 -18.145530700683594
		 2 -17.800441741943359 3 -17.429437637329102 4 -17.036026000976563 5 -16.623720169067383
		 6 -16.195674896240234 7 -15.754436492919922 8 -15.301784515380859 9 -14.838878631591797
		 10 -13.968798637390137 11 -12.374106407165527 12 -10.226161003112793 13 -7.782160758972168
		 14 -5.3991122245788574 15 -3.533571720123291 16 -2.2634096145629883 17 -1.425053596496582
		 18 -1.4534206390380859 19 0.024008750915527344 20 0.7064971923828125 21 0.86818504333496094
		 22 0.74767398834228516 23 0.49886417388916016 24 0.18236207962036133 25 -0.012987613677978516
		 26 1.5090737342834473 27 2.7481398582458496 28 3.870084285736084 29 4.9388236999511719
		 30 5.6381621360778809 31 5.5299601554870605 32 4.80224609375 33 4.1672611236572266
		 34 4.511143684387207 35 6.9786128997802734 36 12.529277801513672 37 21.130483627319336
		 38 31.889957427978516 39 38.056381225585937 40 44.053939819335937 41 48.692031860351563
		 42 50.789588928222656 43 50.028472900390625 44 46.612136840820312 45 41.358146667480469
		 46 35.34613037109375 47 29.021291732788086 48 22.879507064819336 49 17.686042785644531
		 50 12.784512519836426 51 10.004171371459961 52 9.2453765869140625 53 9.1771678924560547
		 54 9.6685724258422852 55 8.4633378982543945 56 7.4211750030517578 57 7.0867061614990234
		 58 7.5725493431091309 59 8.2910480499267578 60 9.1204433441162109 61 9.5055332183837891
		 62 10.136526107788086 63 10.272429466247559 64 10.316964149475098 65 10.29719352722168
		 66 10.29432487487793 67 10.294594764709473 68 10.294594764709473 69 10.294594764709473;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX";
	rename -uid "E4EF6E79-4C16-8FFE-A2E0-60A0381907B6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 2.0324427738149012e-005 1 -2.8294268752950578e-014
		 2 2.0477748340015901e-005 3 -1.2804840423249759e-014 4 8.477589779102426e-006 5 1.0205963541952294e-014
		 6 -3.4459029367740255e-006 7 -2.3846991351431682e-006 8 2.8769714237395635e-006 9 1.2415768034738359e-005
		 10 -4.2228662536222759 11 -14.518228082441603 12 -24.823662913547619 13 -29.153536249078797
		 14 -25.569603776672345 15 -15.897290055063028 16 -5.8844842277276239 17 -1.6950867161185568
		 18 1.5117515973077567 19 0.1495420408779071 20 -3.4641139725765706 21 -8.5623086756703835
		 22 -14.330924252255025 23 -20.047324152361483 24 -25.289937475180047 25 -30.140114258771195
		 26 -35.178579560712564 27 -40.845191360525128 28 -46.295548572611743 29 -50.588756210943721
		 30 -53.638893108403209 31 -55.236185737931869 32 -55.981315264411101 33 -56.378822718622047
		 34 -56.240287621001727 35 -55.499576029629765 36 -54.154027860259802 37 -52.321272679502322
		 38 -50.207483524233787 39 -48.027713411101942 40 -45.940756883313952 41 -44.045867229360127
		 42 -42.769534206240728 43 -42.462381827066736 44 -43.628437602888219 45 -46.517087459289208
		 46 -50.967616513831722 47 -57.11280805501837 48 -64.226183766663596 49 -70.375116194356508
		 50 -74.657261068390852 51 -75.46943484402577 52 -72.144133806759839 53 -69.097643476384562
		 54 -66.070665945476748 55 -67.376460578365737 56 -68.915082981868323 57 -71.403648859323141
		 58 -74.599545001013468 59 -76.909320149806717 60 -77.019677112930211 61 -75.354267123963737
		 62 -72.661191426544974 63 -71.250556488140845 64 -70.599071450237858 65 -70.599042727457359
		 66 -70.599081925885315 67 -70.599047536512373 68 -70.599047536512373 69 -70.599047536512373;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY";
	rename -uid "C1FBD833-4B06-B808-6589-B0BB3E138739";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -29.162118350078874 1 -29.16210513247378
		 2 -29.162107925678779 3 -29.162113512092759 4 -29.162113512092898 5 -29.162119098504558
		 6 -29.162098574994694 7 -29.162107925680424 8 -29.162116305298873 9 -29.162107925679514
		 10 -28.881358745075115 11 -25.571320010939207 12 -15.815869575081638 13 -0.74062492079781306
		 14 14.52135823815528 15 24.773608765138945 16 28.613474963266455 17 29.117124960735104
		 18 26.777340935144384 19 26.553603434544378 20 26.299385260873802 21 26.679092637013188
		 22 28.148802369437938 23 30.746388679515313 24 34.060724633442753 25 37.384652069485789
		 26 40.218544159790596 27 42.673990522909072 28 44.62008776305737 29 45.714448685576372
		 30 46.155975241046086 31 46.319665376220911 32 46.465844283111871 33 46.500514383787809
		 34 46.333472050021484 35 45.928096540656668 36 45.275443482047258 37 44.383669384016656
		 38 43.307645560493931 39 42.160319500774861 40 41.087313797098318 41 40.221797589047284
		 42 40.279477711493513 43 41.813546408355748 44 44.629060054639091 45 48.130182684742323
		 46 51.441008892198838 47 53.554912682196104 48 53.352936204652828 49 50.519707083562949
		 50 44.69023448264457 51 35.858930888042956 52 26.259976344040226 53 22.592677735961889
		 54 19.910044986462911 55 22.173212414345819 56 24.93994460897758 57 28.667748308621299
		 58 32.710940533899041 59 34.978875304337542 60 34.259208228097989 61 31.549342095743974
		 62 27.906531538719875 63 26.17496689928554 64 25.399304333315538 65 25.399296132468038
		 66 25.399308022625924 67 25.399309442163521 68 25.399309442163521 69 25.399309442163521;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "EE58DEEC-4889-176E-07B2-80A7AD68EA2F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -3.5225688024077342e-006 1 3.7848535124252587e-006
		 2 -1.7677437756355691e-005 3 7.077435430467653e-006 4 1.3234927500530637e-006 5 5.185008638120845e-006
		 6 1.3246985589883634e-005 7 2.3846991269035739e-006 8 -4.2771262391582369e-006 9 -1.3815923338927961e-005
		 10 8.6916457709478863 11 30.961452650357625 12 59.493178468353456 13 88.672577986007823
		 14 117.65677634098181 15 145.79707171317892 16 167.85428442154318 17 176.5197236942463
		 18 187.66293749253995 19 188.96717251348687 20 191.3261220731124 21 194.18039329781146
		 22 196.86095213878122 23 198.52088232793014 24 198.11880448358457 25 194.74503392397071
		 26 189.2340315819855 27 183.61073628219799 28 178.73377860844784 29 174.0502902299709
		 30 170.16176163794731 31 169.19955612213118 32 171.76011256364473 33 177.52442884978498
		 34 187.08141549512365 35 199.98991159794974 36 215.50751054082113 37 232.80438560150409
		 38 251.00470201393421 39 262.06281168954604 40 272.17674666515029 41 280.60185573437298
		 42 285.81866115978056 43 286.70836248795337 44 283.04251767386808 45 275.89517616143604
		 46 266.39060511100041 47 253.90977554619008 48 238.77125452693957 49 223.77366839867273
		 50 207.68698118808814 51 190.42235953413442 52 173.78398165903207 53 164.01878193185323
		 54 155.02351595740714 55 159.94956815740377 56 166.53243267608818 57 172.80931032440674
		 58 176.10473161379358 59 174.84182511407164 60 169.96711520928395 61 164.60519078536043
		 62 158.12644770899718 63 156.57617149995397 64 155.8634465787801 65 155.86340736855306
		 66 155.86342150683137 67 155.86342133297404 68 155.86342133297404 69 155.86342133297404;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA";
	rename -uid "AAD723DD-4975-F968-360F-E6A11713ABA8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -21.001749038696289 1 -20.997724533081055
		 2 -20.931259155273438 3 -20.809394836425781 4 -20.645729064941406 5 -20.458938598632812
		 6 -20.270269393920898 7 -20.100870132446289 8 -19.969694137573242 9 -19.89335823059082
		 10 -19.888521194458008 11 -20.031877517700195 12 -20.381221771240234 13 -20.92753791809082
		 14 -21.62922477722168 15 -22.394491195678711 16 -23.102273941040039 17 -23.645116806030273
		 18 -23.667266845703125 19 -24.050365447998047 20 -25.093505859375 21 -26.601657867431641
		 22 -28.311969757080078 23 -29.85450553894043 24 -30.87713623046875 25 -31.259050369262695
		 26 -31.08537483215332 27 -30.677892684936523 28 -30.754932403564453 29 -31.720279693603516
		 30 -32.934864044189453 31 -34.173168182373047 32 -35.109783172607422 33 -35.686470031738281
		 34 -35.972606658935547 35 -35.942092895507812 36 -36.63623046875 37 -38.438606262207031
		 38 -40.461208343505859 39 -41.227272033691406 40 -39.108768463134766 41 -34.779651641845703
		 42 -30.153341293334961 43 -27.169486999511719 44 -26.684873580932617 45 -28.046199798583984
		 46 -30.645586013793945 47 -33.842044830322266 48 -36.8870849609375 49 -39.202526092529297
		 50 -40.683536529541016 51 -41.213603973388672 52 -40.269241333007812 53 -37.526870727539063
		 54 -30.35295295715332 55 -31.583686828613281 56 -32.161102294921875 57 -31.987730026245117
		 58 -33.158523559570313 59 -33.421890258789063 60 -33.020263671875 61 -32.192043304443359
		 62 -31.111530303955078 63 -30.035066604614258 64 -30.540077209472656 65 -30.813713073730469
		 66 -30.425714492797852 67 -29.779138565063477 68 -29.779138565063477 69 -29.779138565063477;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA";
	rename -uid "01CF4729-4190-9107-540F-A0A1EABF7FC2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 9.788722038269043 1 10.17805004119873
		 2 10.84816837310791 3 11.709603309631348 4 12.675214767456055 5 13.662639617919922
		 6 14.596979141235352 7 15.412321090698242 8 16.052413940429687 9 16.470232009887695
		 10 16.625415802001953 11 16.780048370361328 12 17.185905456542969 13 17.760498046875
		 14 18.376914978027344 15 18.88853645324707 16 19.175510406494141 17 19.174152374267578
		 18 19.075111389160156 19 19.629512786865234 20 20.270839691162109 21 20.803640365600586
		 22 21.035812377929688 23 20.8489990234375 24 20.337194442749023 25 19.873218536376953
		 26 19.842151641845703 27 19.764530181884766 28 20.012367248535156 29 20.841945648193359
		 30 20.471504211425781 31 19.503520965576172 32 19.183841705322266 33 19.530126571655273
		 34 20.664865493774414 35 21.927753448486328 36 26.150875091552734 37 35.501014709472656
		 38 48.875236511230469 39 58.799270629882812 40 68.104286193847656 41 75.084144592285156
		 42 79.164352416992188 43 80.303085327148438 44 79.254951477050781 45 76.329483032226563
		 46 72.303298950195312 47 67.846817016601563 48 63.349372863769531 49 59.315990447998047
		 50 55.442451477050781 51 51.623668670654297 52 47.355434417724609 53 41.289646148681641
		 54 30.502908706665039 55 25.952733993530273 56 20.245809555053711 57 14.503481864929199
		 58 20.564785003662109 59 23.763504028320313 60 23.894222259521484 61 21.457685470581055
		 62 17.495349884033203 63 13.594913482666016 64 13.953415870666504 65 13.885907173156738
		 66 13.19228458404541 67 12.123874664306641 68 12.123874664306641 69 12.123874664306641;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA";
	rename -uid "2303924A-483A-5FDA-46C7-5194C70A97D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -31.268655776977539 1 -30.881093978881836
		 2 -30.273765563964844 3 -29.47154426574707 4 -28.50456428527832 5 -27.408849716186523
		 6 -26.226139068603516 7 -25.002401351928711 8 -23.785078048706055 9 -22.619533538818359
		 10 -21.546783447265625 11 -20.619199752807617 12 -19.802227020263672 13 -18.994483947753906
		 14 -18.115165710449219 15 -17.139183044433594 16 -16.108283996582031 17 -15.093544006347656
		 18 -14.100138664245605 19 -12.116347312927246 20 -10.154898643493652 21 -8.2465925216674805
		 22 -6.4575953483581543 23 -4.7258448600769043 24 -3.0763640403747559 25 -1.7770895957946777
		 26 -0.83797121047973633 27 -0.16478586196899414 28 0.5080113410949707 29 1.371650218963623
		 30 1.8062605857849121 31 1.4770731925964355 32 0.66989374160766602 33 -0.23453617095947266
		 34 -1.0999207496643066 35 -1.6130952835083008 36 0.018578529357910156 37 4.8477139472961426
		 38 12.518446922302246 39 20.229255676269531 40 28.899179458618164 41 37.212734222412109
		 42 44.422492980957031 43 50.370510101318359 44 55.2154541015625 45 58.849327087402344
		 46 60.859825134277344 47 60.925052642822266 48 59.217300415039063 49 56.089878082275391
		 50 51.129875183105469 51 44.323421478271484 52 35.782211303710937 53 24.314559936523438
		 54 11.44281005859375 55 5.5549530982971191 56 1.2483081817626953 57 -0.66800355911254883
		 58 -0.54326629638671875 59 0.32009410858154297 60 1.205439567565918 61 1.7553038597106934
		 62 2.1133055686950684 63 2.5673770904541016 64 2.5442452430725098 65 2.4709429740905762
		 66 2.4758844375610352 67 2.5252504348754883 68 2.5252504348754883 69 2.5252504348754883;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX";
	rename -uid "67FE5BF9-422D-9393-5775-8CB2E9FBB041";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.9883897138957971e-006 1 0.059764412003658431
		 2 0.37312574225285555 3 1.2244206026096931 4 2.9783583131347457 5 6.009962137211339
		 6 10.565239230049123 7 16.552256723436393 8 23.3732308987287 9 30.020075174672833
		 10 35.472774185610803 11 38.862028050608295 12 38.96740463280149 13 35.422423304355654
		 14 28.92473810706279 15 21.206422253071665 16 14.322554402846501 17 9.3475016401448059
		 18 7.8906800630137761 19 7.8184581662652439 20 7.5952578060315226 21 7.1868713470932901
		 22 6.5426825574743237 23 5.6373688609348465 24 4.5220602988859895 25 3.333464104991557
		 26 2.18998192116941 27 0.89285208819428996 28 -0.54816598741492217 29 -2.1560790911455294
		 30 -4.698606359206261 31 -7.0010401365690962 32 -8.0559800955001695 33 -9.0280488410929571
		 34 -11.059878508288749 35 -16.162578810077591 36 -23.080050113171126 37 -29.32567206813475
		 38 -32.084934871093928 39 -29.502366792828017 40 -22.420215427189468 41 -12.930187550990357
		 42 -4.1650803887516865 43 2.0987266858349773 44 6.362357368556169 45 10.164071685817131
		 46 14.626776073026635 47 19.926395650042124 48 25.556157499466753 49 30.302094082718355
		 50 32.296960384781826 51 29.74231335761824 52 21.763750509546188 53 7.8153478374862742
		 54 -6.8728063576210552 55 -12.619665733344029 56 -18.268480696554885 57 -22.64538497470291
		 58 -19.31419646851603 59 -16.431805686001706 60 -14.78014788960656 61 -14.62443556493422
		 62 -15.644579141286609 63 -16.896620381550562 64 -16.630517165634689 65 -16.671889945217345
		 66 -17.150240440118512 67 -17.809298913081651 68 -17.809298913081651 69 -17.809298913081651;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY";
	rename -uid "A7940BC6-4E38-15A0-C305-B9A37B467973";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 31.960581959664587 1 32.235704418085817
		 2 33.036135379716129 3 34.335954313331847 4 36.035154165754214 5 37.874258687524808
		 6 39.404030803534212 7 40.04067856688043 8 39.223695595463624 9 36.620916848992401
		 10 32.240485695862958 11 24.872616257666422 12 14.77797062593705 13 4.729707814691646
		 14 -2.66838600166012 15 -5.936258966443142 16 -5.4208421224414618 17 -2.8414572077732267
		 18 -2.167621594058867 19 -1.7528057602338618 20 -0.63478001070429246 21 0.93794320900878947
		 22 2.6213429756970581 23 4.0098155268924867 24 4.7498212894893621 25 4.6912088627723847
		 26 4.0049512493132777 27 2.9910546665105033 28 2.5115305551530649 29 3.0380091000642868
		 30 3.521670204993105 31 3.6021865105114883 32 3.4622459658060589 33 3.200565363048681
		 34 2.6572442276334454 35 0.54526751877383317 36 -3.2994483124425895 37 -7.0077550449421295
		 38 -6.1464128128548152 39 -0.36485341738040394 40 4.4199526068550075 41 5.9129581160651083
		 42 4.2120251875015171 43 1.5789413953403582 44 0.0468075484101012 45 -0.00088654440565267634
		 46 1.1960549460668268 47 3.1257050095463206 48 5.1785507730625522 49 7.1601760932232326
		 50 9.5896737662730125 51 12.548603658408929 52 14.445354600719599 53 13.035770353958474
		 54 3.2190059552636545 55 2.3760106244015793 56 -0.32178022156525765 57 -4.3448869569454471
		 58 -0.91080580672132327 59 1.0465839333777323 60 1.8285676117326004 61 1.7670495597090472
		 62 1.05998817955459 63 0.086872860934911436 64 0.49756129665273319 65 0.62593932719358203
		 66 0.1772429919200019 67 -0.51860134770147492 68 -0.51860134770147492 69 -0.51860134770147492;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "B2F3582D-4363-2C2F-7754-EEA43E5AB103";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -9.678774329235498e-006 1 1.1306502956278055
		 2 4.3572311103226262 3 9.4561888181272948 4 16.255147723802594 5 24.629804129249344
		 6 34.431388431252806 7 45.32495764546919 8 56.636494522771294 9 67.43382258554665
		 10 76.891082363775354 11 86.609316822569809 12 97.89050298231831 13 110.55796666784057
		 14 124.25570481981971 15 137.34950788407915 16 147.20259000380588 17 151.39536149493944
		 18 154.07800303555751 19 154.82551966329808 20 155.77668972205416 21 156.67428966352105
		 22 157.27240251214511 23 157.47132488276435 24 157.39665383394018 25 157.37724919329648
		 26 157.71679190366962 27 157.88078698437386 28 158.32862280106255 29 159.44166115873028
		 30 158.34472301521319 31 158.14007604320884 32 161.46405973339699 33 165.15291120368229
		 34 166.05272441370491 35 157.77347640145331 36 145.90441609020172 37 141.77540393425406
		 38 152.44123180022189 39 167.34754376775962 40 184.58431566781707 41 202.60092709882403
		 42 219.90680036655877 43 235.83520773728554 44 250.50959794227933 45 263.76887527262267
		 46 274.6663814433274 47 282.17817507893062 48 286.14782714708059 49 286.68137929146144
		 50 282.47047079568614 51 273.03187754593932 52 258.40800847833771 53 236.29858934753275
		 54 207.80404006202866 55 191.31596827353468 56 173.70905501272418 57 157.27345733092437
		 58 169.53348425810415 59 178.93286310359372 60 184.33060853341263 61 185.20651664930227
		 62 182.28076201118222 63 178.18208421103344 64 178.17100772786401 65 177.52650788554453
		 66 176.50831618705308 67 175.16567908269442 68 175.16567908269442 69 175.16567908269442;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "9A3496A4-4AE7-3876-F225-43A541180BCD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 21.518192291259766 1 21.468223571777344
		 2 21.305385589599609 3 21.051155090332031 4 20.725889205932617 5 20.362859725952148
		 6 20.009304046630859 7 19.768180847167969 8 19.636402130126953 9 19.526679992675781
		 10 19.396486282348633 11 19.26817512512207 12 19.147607803344727 13 19.002344131469727
		 14 18.889104843139648 15 18.875629425048828 16 18.944969177246094 17 19.063465118408203
		 18 19.273530960083008 19 19.427122116088867 20 19.435516357421875 21 19.251874923706055
		 22 18.803285598754883 23 18.197792053222656 24 17.674234390258789 25 17.463321685791016
		 26 17.555139541625977 27 17.70439338684082 28 17.760843276977539 29 17.701519012451172
		 30 17.625179290771484 31 17.500982284545898 32 17.34300422668457 33 17.191183090209961
		 34 17.025375366210938 35 16.857583999633789 36 16.657657623291016 37 16.451953887939453
		 38 16.296092987060547 39 16.267194747924805 40 16.779478073120117 41 17.492048263549805
		 42 17.672786712646484 43 17.453882217407227 44 17.316295623779297 45 16.96717643737793
		 46 16.498703002929688 47 16.012102127075195 48 15.640163421630859 49 15.530856132507324
		 50 15.766338348388672 51 16.467714309692383 52 17.708978652954102 53 18.615270614624023
		 54 19.627363204956055 55 19.010017395019531 56 18.470979690551758 57 18.176567077636719
		 58 18.066167831420898 59 18.192981719970703 60 18.482158660888672 61 18.799652099609375
		 62 19.141727447509766 63 19.301765441894531 64 19.24449348449707 65 19.20257568359375
		 66 19.247360229492188 67 19.323413848876953 68 19.323413848876953 69 19.323413848876953;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "C231A3E2-452D-C723-11D3-3F89E8489589";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 94.11212158203125 1 94.207023620605469
		 2 94.193565368652344 3 94.115203857421875 4 93.938735961914062 5 93.61090087890625
		 6 93.060150146484375 7 92.440040588378906 8 91.812973022460938 9 90.972122192382813
		 10 89.804290771484375 11 88.174270629882813 12 85.896675109863281 13 83.024795532226562
		 14 79.580230712890625 15 75.293304443359375 16 70.212593078613281 17 64.614700317382812
		 18 63.267063140869141 19 61.408153533935547 20 60.774589538574219 21 61.180530548095703
		 22 62.870391845703125 23 65.304443359375 24 67.567100524902344 25 69.434616088867188
		 26 71.052146911621094 27 72.652168273925781 28 74.216354370117188 29 75.581741333007813
		 30 76.522209167480469 31 77.112586975097656 32 77.394721984863281 33 77.296905517578125
		 34 76.585289001464844 35 74.611320495605469 36 71.087455749511719 37 65.221420288085937
		 38 56.356624603271484 39 51.292068481445313 40 47.009956359863281 41 45.653736114501953
		 42 43.889881134033203 43 40.587265014648438 44 43.206382751464844 45 45.064807891845703
		 46 45.807281494140625 47 45.346279144287109 48 43.655693054199219 49 40.871479034423828
		 50 37.446956634521484 51 34.603633880615234 52 31.372829437255859 53 29.073005676269531
		 54 27.750965118408203 55 28.034755706787109 56 28.145523071289063 57 27.961469650268555
		 58 28.365924835205078 59 28.23668098449707 60 27.664957046508789 61 27.013534545898438
		 62 26.225503921508789 63 25.809993743896484 64 25.836719512939453 65 25.837879180908203
		 66 25.778696060180664 67 25.683185577392578 68 25.683185577392578 69 25.683185577392578;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "6B8459F3-4DCC-7F50-98AE-C782F8F6CC87";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -31.47821044921875 1 -29.216047286987305
		 2 -27.231204986572266 3 -25.50013542175293 4 -24.032438278198242 5 -22.841753005981445
		 6 -21.937356948852539 7 -21.287731170654297 8 -20.842475891113281 9 -20.521158218383789
		 10 -20.189014434814453 11 -19.590490341186523 12 -18.558696746826172 13 -17.199356079101563
		 14 -15.718415260314941 15 -14.124847412109375 16 -12.40003776550293 17 -10.606779098510742
		 18 -9.3128013610839844 19 -8.0625133514404297 20 -6.8859467506408691 21 -5.4256620407104492
		 22 -3.1683692932128906 23 -0.052231311798095703 24 3.4325709342956543 25 7.3565645217895508
		 26 11.796350479125977 27 16.670963287353516 28 22.040935516357422 29 27.883640289306641
		 30 34.090415954589844 31 40.541248321533203 32 47.192901611328125 33 54.061538696289063
		 34 61.880825042724609 35 70.985893249511719 36 80.882354736328125 37 91.091049194335938
		 38 99.977874755859375 39 103.60939788818359 40 106.35697937011719 41 108.78605651855469
		 42 110.69892883300781 43 111.26004791259766 44 111.51352691650391 45 111.16014099121094
		 46 110.33219146728516 47 109.20619201660156 48 107.95399475097656 49 106.73981475830078
		 50 105.40991973876953 51 103.99237060546875 52 102.69514465332031 53 102.12611389160156
		 54 101.97331237792969 55 101.50460052490234 56 101.13680267333984 57 101.07035064697266
		 58 101.3021240234375 59 101.45855712890625 60 101.51502227783203 61 101.47705078125
		 62 101.44218444824219 63 101.59468078613281 64 101.54221343994141 65 101.50949096679687
		 66 101.53414154052734 67 101.58023071289062 68 101.58023071289062 69 101.58023071289062;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "A9463BB5-40E9-E692-4D47-04AE8246CF9E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -39.704553509983356 1 -35.657447095303866
		 2 -32.887311534351419 3 -33.527531970083729 4 -37.849451669324203 5 -43.049984910609375
		 6 -46.278478355273698 7 -51.813286702934704 8 -58.209335463123338 9 -63.93736707491162
		 10 -67.508532560859862 11 -67.533708589681297 12 -64.808313611316009 13 -60.887308994752047
		 14 -58.20090354838284 15 -56.436337682444801 16 -54.949165582598802 17 -51.583731846512336
		 18 -53.59210831911173 19 -54.51830750111165 20 -65.031080882695377 21 -75.5863565279179
		 22 -84.273554120117808 23 -89.418622354005919 24 -87.727520170006926 25 -82.342017681273234
		 26 -74.693004399009197 27 -66.73630989474232 28 -60.601239314755283 29 -57.259895737931913
		 30 -55.012568663464435 31 -52.406282490964735 32 -49.934665281799745 33 -48.981049428954904
		 34 -50.576181696022921 35 -54.044380907998857 36 -57.573966235459814 37 -60.395226297437013
		 38 -63.083781385305556 39 -45.797540008360215 40 -24.56993774803653 41 -8.8068156353034297
		 42 2.1204504232220511 43 8.9043271499206718 44 9.2746498576363994 45 6.1439538316869404
		 46 0.90304975299653423 47 -5.2702812786548705 48 -11.269247581621338 49 -16.049680479050309
		 50 -11.133641717654314 51 -6.5275672502646307 52 -2.6181717825700836 53 -0.83051494280529714
		 54 -1.8332233189150797 55 -4.2463001850358921 56 -7.2978667164789899 57 -10.173747089420194
		 58 -10.380979746346338 59 -10.632282244679091 60 -10.632291828710192 61 -10.632282745457914
		 62 -10.632286938851081 63 -10.632276837336461 64 -10.632267824058168 65 -10.632268053724758
		 66 -10.632278551162075 67 -10.632264840944831 68 -10.632264840944831 69 -10.632264840944831;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "D4BEC6AA-4FE3-35E7-6FC2-50AA355092DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 42.911583330059308 1 45.754602843495825
		 2 48.624490724053807 3 50.688085289642785 4 50.979024669357727 5 49.01002113113104
		 6 45.490609389739703 7 37.556384400623784 8 27.028447042635406 9 13.334059369346127
		 10 -0.44791891507246834 11 -13.115290892253707 12 -22.341459242606994 13 -29.42576184831443
		 14 -35.989203041851233 15 -42.87629534842435 16 -50.924366783165596 17 -60.732515267854275
		 18 -64.937146685945237 19 -71.833339829219469 20 -73.620963700784557 21 -69.175991323980753
		 22 -63.435689850159292 23 -59.1999712827567 24 -56.20139044911312 25 -55.013589407325675
		 26 -54.774380742237646 27 -54.105462996185295 28 -53.232204323937829 29 -48.538014227238243
		 30 -37.95456205913483 31 -23.631114926923249 32 -7.8146312162082401 33 6.3395126316325827
		 34 15.927021864493554 35 20.309286870557873 36 21.434263820462277 37 19.202907460060128
		 38 12.23555486429853 39 8.2615330617761362 40 5.3691302606650479 41 12.600104643437877
		 42 8.3416541642600031 43 3.0737415084313144 44 4.1262531157988676 45 6.4247785990823134
		 46 9.2213040077516464 47 12.121664928497262 48 14.417220358780003 49 15.286474125984368
		 50 11.781731267498319 51 10.441595181206976 52 7.1280602647196929 53 4.7142242529739162
		 54 4.3034122611401546 55 4.9114503147379818 56 6.4616618129410339 57 8.4294760663422625
		 58 9.5549325109196648 59 10.565496549742914 60 10.565490361570617 61 10.565502373929931
		 62 10.565507029208961 63 10.565492319216395 64 10.565495722748539 65 10.565501264042366
		 66 10.565488963696687 67 10.565508115118943 68 10.565508115118943 69 10.565508115118943;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "B3B4197C-4208-A900-29D3-50B3AE23406F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -47.296701976434889 1 -44.05514260310968
		 2 -45.725539376844161 3 -53.230389788385224 4 -64.751509698236802 5 -75.146973416287395
		 6 -79.434193469911506 7 -81.125781551439985 8 -82.817436637087894 9 -84.021713295698447
		 10 -83.146223368377349 11 -78.741777929191628 12 -71.321799533784514 13 -65.942299275949836
		 14 -61.42185855400713 15 -58.431382437309324 16 -56.892488886105212 17 -58.436491849631366
		 18 -55.386887251077873 19 -53.771291237625796 20 -42.904411775602263 21 -32.631683629313514
		 22 -23.974502682385516 23 -18.717150048078054 24 -20.70838169836653 25 -26.464395575257946
		 26 -34.63217339439727 27 -43.137390540217936 28 -49.226995374772955 29 -51.268948471669155
		 30 -51.49499907773766 31 -52.201702578401658 32 -53.271058825272526 33 -54.652140392509672
		 34 -55.730411318534777 35 -55.731782842910206 36 -53.307660321500265 37 -49.704376335600593
		 38 -49.320876206234743 39 -46.135038108708798 40 -48.070293163391909 41 -51.549092855153539
		 42 -50.408038075343846 43 -51.609748563301991 44 -49.860436432561002 45 -48.349136654537659
		 46 -47.449761021700368 47 -47.47936657848728 48 -48.535340581204686 49 -50.49801434708683
		 50 -52.54868967835101 51 -54.453641562477742 52 -55.297305655008721 53 -56.098248370611891
		 54 -56.228233435299032 55 -56.575569342081302 56 -57.314468018071317 57 -58.403758867545889
		 58 -59.650896351022091 59 -60.899791719894182 60 -60.899794165598266 61 -60.89979537350446
		 62 -60.899802034292314 63 -60.899795644572094 64 -60.899802936507172 65 -60.89980734315445
		 66 -60.899795671484412 67 -60.899818598552322 68 -60.899818598552322 69 -60.899818598552322;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "E0610541-4074-C76B-9364-308AA937FAE1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -23.129734039306641 1 -23.243185043334961
		 2 -23.566108703613281 3 -23.997348785400391 4 -24.451637268066406 5 -24.85943603515625
		 6 -25.164031982421875 7 -25.429275512695313 8 -25.737205505371094 9 -26.058286666870117
		 10 -26.371349334716797 11 -26.651573181152344 12 -26.8974609375 13 -27.118259429931641
		 14 -27.299402236938477 15 -27.43848991394043 16 -27.534326553344727 17 -27.582286834716797
		 18 -27.487146377563477 19 -27.359533309936523 20 -27.306121826171875 21 -27.356790542602539
		 22 -27.499162673950195 23 -27.651453018188477 24 -27.740400314331055 25 -27.759550094604492
		 26 -27.712675094604492 27 -27.64971923828125 28 -27.649971008300781 29 -27.730205535888672
		 30 -27.827508926391602 31 -27.971996307373047 32 -28.148857116699219 33 -28.317600250244141
		 34 -28.505975723266602 35 -28.709800720214844 36 -28.958829879760742 37 -29.231931686401367
		 38 -29.477397918701172 39 -29.600500106811523 40 -29.452304840087891 41 -29.117073059082031
		 42 -28.919706344604492 43 -29.00291633605957 44 -29.116168975830078 45 -29.448776245117188
		 46 -29.910686492919922 47 -30.399415969848633 48 -30.780721664428711 49 -30.904762268066406
		 50 -30.686166763305664 51 -29.990983963012695 52 -28.756475448608398 53 -27.856311798095703
		 54 -26.844223022460937 55 -27.461542129516602 56 -28.000576019287109 57 -28.294998168945312
		 58 -28.405410766601563 59 -28.278593063354492 60 -27.989397048950195 61 -27.671924591064453
		 62 -27.329843521118164 63 -27.169809341430664 64 -27.227077484130859 65 -27.268989562988281
		 66 -27.224201202392578 67 -27.148164749145508 68 -27.148164749145508 69 -27.148164749145508;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "6D0AC47A-4E46-FB03-BEA1-F0BD77313191";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 94.599678039550781 1 94.669830322265625
		 2 94.514427185058594 3 94.096443176269531 4 93.304054260253906 5 92.033760070800781
		 6 90.216629028320313 7 88.056816101074219 8 85.792449951171875 9 83.464859008789063
		 10 81.192901611328125 11 79.01727294921875 12 76.7056884765625 13 74.006294250488281
		 14 70.813812255859375 15 66.987876892089844 16 62.589210510253906 17 57.824623107910156
		 18 57.252101898193359 19 56.027873992919922 20 54.645774841308594 21 53.794422149658203
		 22 54.201816558837891 23 55.603126525878906 24 57.230083465576172 25 59.055274963378906
		 26 61.109447479248047 27 63.312313079833984 28 65.559646606445313 29 67.702133178710937
		 30 69.584907531738281 31 71.286933898925781 32 72.844825744628906 33 74.17108154296875
		 34 75.234077453613281 35 75.479202270507813 36 74.361595153808594 37 70.949020385742187
		 38 64.235023498535156 39 59.951484680175781 40 55.314929962158203 41 52.623897552490234
		 42 49.662952423095703 43 46.026638031005859 44 48.454914093017578 45 50.084175109863281
		 46 50.624412536621094 47 50.039958953857422 48 48.341518402099609 49 45.68359375
		 50 42.406753540039062 51 39.646083831787109 52 36.496799468994141 53 34.263076782226563
		 54 32.941043853759766 55 33.224838256835938 56 33.335605621337891 57 33.151554107666016
		 58 33.556007385253906 59 33.426769256591797 60 32.855037689208984 61 32.20361328125
		 62 31.415590286254883 63 31.000080108642578 64 31.02679443359375 65 31.027963638305664
		 66 30.968778610229492 67 30.873268127441406 68 30.873268127441406 69 30.873268127441406;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "81E9C179-4A95-23D2-DE76-AFB73D81AA0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -33.866989135742187 1 -31.793388366699219
		 2 -30.309291839599609 3 -29.281627655029297 4 -28.583072662353516 5 -28.052562713623047
		 6 -27.494409561157227 7 -26.841686248779297 8 -26.142862319946289 9 -25.361797332763672
		 10 -24.510562896728516 11 -23.572040557861328 12 -22.568216323852539 13 -21.51362419128418
		 14 -20.322811126708984 15 -18.953437805175781 16 -17.449836730957031 17 -15.842588424682617
		 18 -14.613946914672852 19 -13.379986763000488 20 -12.053321838378906 21 -10.248035430908203
		 22 -7.6816072463989258 23 -4.4947605133056641 24 -1.1605668067932129 25 2.2791104316711426
		 26 6.0230808258056641 27 10.16729736328125 28 14.772021293640137 29 19.812885284423828
		 30 25.222969055175781 31 30.927703857421875 32 36.930717468261719 33 43.294052124023438
		 34 50.795856475830078 35 59.963043212890625 36 70.505386352539063 37 82.154693603515625
		 38 93.448371887207031 39 99.008987426757813 40 103.19928741455078 41 105.37142944335937
		 42 106.55868530273437 43 106.86499786376953 44 106.65370941162109 45 105.91577911376953
		 46 104.84558868408203 47 103.63138580322266 48 102.45107269287109 49 101.47528076171875
		 50 100.43970489501953 51 99.165084838867188 52 98.0213623046875 53 97.587982177734375
		 54 97.4351806640625 55 96.966476440429687 56 96.598678588867188 57 96.5322265625
		 58 96.764015197753906 59 96.920433044433594 60 96.976898193359375 61 96.938926696777344
		 62 96.904060363769531 63 97.056571960449219 64 97.00408935546875 65 96.971366882324219
		 66 96.996017456054688 67 97.042121887207031 68 97.042121887207031 69 97.042121887207031;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "903A06E0-457E-7CE0-7F95-C68513D53F12";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 26.374977586754841 1 24.863328353485269
		 2 20.723588174409869 3 15.027718677933487 4 8.7375170455678397 5 2.6730452017349804
		 6 -2.5570840895170281 7 67.875056846984862 8 66.756319975906536 9 63.045728345531863
		 10 57.332193505560632 11 49.988029751627337 12 41.665439161605612 13 33.853430683793128
		 14 28.204187342786295 15 25.368385743035208 16 24.781621865885803 17 25.385912552440459
		 18 24.586647948095976 19 25.359661205169434 20 26.916755518964624 21 29.082355855968697
		 22 31.618099360984974 23 34.160635779715527 24 36.551628481761945 25 38.749590661033849
		 26 40.981304292485923 27 43.922444570201932 28 50.829064315728303 29 70.000327326936542
		 30 93.954270349787649 31 111.36699022493829 32 121.13514386279356 33 126.11189977364374
		 34 128.85780723140019 35 129.76347126817242 36 128.6322740697172 37 126.50929024524248
		 38 124.89104190911442 39 125.1799031633323 40 128.15875373771777 41 134.22616580645729
		 42 144.70002244727777 43 161.00344680142035 44 178.25117734369684 45 193.72980109086694
		 46 209.49822858028682 47 217.49867059100725 48 219.65425482993953 49 215.73714450416628
		 50 206.04560228361623 51 192.23255238936127 52 179.06640831713432 53 169.95326632961698
		 54 166.55404570052454 55 170.58831183572588 56 178.86298056587555 57 190.27406408853429
		 58 202.62281310753229 59 213.09360706736197 60 219.92638544908397 61 222.16271794721229
		 62 221.91723109320134 63 221.91723319595889 64 221.91724649310086 65 221.91724195104624
		 66 221.91724346568449 67 221.91726704704462 68 221.91726704704462 69 221.91726704704462;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "1500E2EF-48DB-2D81-0DCE-16B18F54B525";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 50.268059961447982 1 50.193698757892975
		 2 50.657591407363483 3 51.758760739692818 4 53.626265880326208 5 56.419567465547175
		 6 60.300764853204349 7 45.640796324411653 8 42.013241936562359 9 41.619461758010367
		 10 43.423831691314064 11 46.572137570855553 12 49.774077259971996 13 51.888081000621469
		 14 52.569164588539607 15 51.920498830861447 16 50.031297364890925 17 46.753913050740408
		 18 47.504372010676342 19 46.962645211873671 20 46.520222839124095 21 46.442495690574319
		 22 47.197970927310784 23 48.717357618853086 24 50.483175307538261 25 52.444843367036064
		 26 54.595876728328811 27 57.200188743295641 28 60.158566597787733 29 59.021909946374919
		 30 51.878765565453413 31 45.939324178942918 32 41.078720311163124 33 36.194144554529124
		 34 30.232645740698004 35 21.828389662298914 36 10.913180066619116 37 -1.6115224827050667
		 38 -14.69931609093898 39 -21.496320169156977 40 -26.060197553603047 41 -22.792163292683963
		 42 -14.957505922078292 43 -1.4184740671325851 44 19.460564731216984 45 33.227658261574696
		 46 37.967720525525309 47 38.577026560694776 48 36.730519298403742 49 32.756601507390101
		 50 27.186676058095415 51 21.715086796757738 52 16.884715074993647 53 14.345716504319725
		 54 14.738274360824422 55 14.068508198121741 56 14.521328972742189 57 16.057126638082075
		 58 18.104243544563431 59 20.021248664653466 60 21.21914652248639 61 21.38009834224215
		 62 20.841333517567747 63 20.841335959983279 64 20.841341841173911 65 20.841338835606958
		 66 20.841346617673096 67 20.841321649692272 68 20.841321649692272 69 20.841321649692272;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "C99E46C6-4F1E-A083-D49A-D6A0B80CDBCD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 65.837918086021347 1 65.294872922436895
		 2 63.674540903778691 3 61.424299521812451 4 58.817107523141097 5 55.873274121549954
		 6 52.30366267764915 7 44.824650609220996 8 47.011670395621778 9 49.093702730731984
		 10 50.931063233368157 11 51.961241602036438 12 52.075801381030757 13 52.251618338103718
		 14 53.804037090536568 15 57.197148529685748 16 61.78980978156001 17 66.624639566226804
		 18 65.91803284947207 19 66.363626628376295 20 67.078490176076244 21 67.726707490230652
		 22 67.83396861159089 23 67.125312342738539 24 65.63131510456553 25 63.096509560306032
		 26 59.236556113547152 27 53.653456766507759 28 47.786446534607954 29 47.859999773435213
		 30 46.39828262042213 31 40.878611520020861 32 36.364828337294782 33 33.947155933744121
		 34 35.292911015237436 35 39.965627149740435 36 45.066962061121693 37 49.335336800809444
		 38 51.811824211258063 39 48.935418251586626 40 44.116772101588701 41 37.716096631178495
		 42 30.558169755964165 43 23.529725268629843 44 23.695720032060972 45 27.99122725999262
		 46 32.110389837997182 47 35.354856081873677 48 37.329716004159657 49 37.653184324810738
		 50 36.800035648489285 51 36.947580218193544 52 38.860559083490699 53 41.926745727421505
		 54 45.535603664734097 55 46.945531113482652 56 48.624320130572968 57 51.145877073204439
		 58 54.604052860887769 59 58.390913339291679 60 61.726317153436888 61 64.278953354592019
		 62 66.307087827271062 63 66.307078501166117 64 66.307100831806295 65 66.307079611393974
		 66 66.307111086456544 67 66.307107171041764 68 66.307107171041764 69 66.307107171041764;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA";
	rename -uid "6B027BC5-4FD0-C067-3BF6-AD896C73E403";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -0.5829620361328125 1 -0.69177961349487305
		 2 -1.0186989307403564 3 -1.4945123195648193 4 -2.0559990406036377 5 -2.6431193351745605
		 6 -3.2032220363616943 7 -3.6949589252471924 8 -4.088961124420166 9 -4.3681068420410156
		 10 -4.533607006072998 11 -4.5862998962402344 12 -4.5890717506408691 13 -4.6104354858398437
		 14 -4.6444764137268066 15 -4.6877827644348145 16 -4.7302026748657227 17 -4.7542037963867187
		 18 -4.6194133758544922 19 -4.4162883758544922 20 -4.2807822227478027 21 -4.2701482772827148
		 22 -4.386866569519043 23 -4.5342178344726562 24 -4.6172733306884766 25 -4.6295642852783203
		 26 -4.5749526023864746 27 -4.5033779144287109 28 -4.494239330291748 29 -4.5643267631530762
		 30 -4.6507778167724609 31 -4.783780574798584 32 -4.9485969543457031 33 -5.1047916412353516
		 34 -5.2999634742736816 35 -5.5418410301208496 36 -5.8470392227172852 37 -6.1829643249511719
		 38 -6.4798436164855957 39 -6.6487202644348145 40 -6.5627884864807129 41 -6.3104696273803711
		 42 -6.2322626113891602 43 -6.4393234252929687 44 -6.5356531143188477 45 -6.8388514518737793
		 46 -7.2700777053833008 47 -7.7369041442871094 48 -8.1109552383422852 49 -8.2399749755859375
		 50 -8.0308828353881836 51 -7.3450860977172852 52 -6.1212372779846191 53 -5.2305235862731934
		 54 -4.216463565826416 55 -4.8321456909179687 56 -5.3699245452880859 57 -5.6635451316833496
		 58 -5.7736835479736328 59 -5.6468672752380371 60 -5.3576822280883789 61 -5.0402016639709473
		 62 -4.6981215476989746 63 -4.5380969047546387 64 -4.5953569412231445 65 -4.637270450592041
		 66 -4.5924878120422363 67 -4.5164370536804199 68 -4.5164370536804199 69 -4.5164370536804199;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA";
	rename -uid "C0DF7B97-4D0E-6579-1166-C48B63CE103E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 112.22518157958984 1 112.27369689941406
		 2 112.07221221923828 3 111.60594177246094 4 110.78284454345703 5 109.52374267578125
		 6 107.78319549560547 7 105.56522369384766 8 102.92624664306641 9 99.972671508789063
		 10 96.904464721679688 11 93.847663879394531 12 90.636688232421875 13 87.065826416015625
		 14 83.077621459960938 15 78.576156616210938 16 73.661788940429688 17 68.577774047851562
		 18 67.631332397460938 19 65.767936706542969 20 63.631851196289063 21 62.219734191894531
		 22 62.591011047363281 23 64.366996765136719 24 66.447746276855469 25 68.79248046875
		 26 71.416275024414063 27 74.220611572265625 28 77.080352783203125 29 79.821830749511719
		 30 82.264472961425781 31 84.458610534667969 32 86.410446166992188 33 88.00238037109375
		 34 89.188926696777344 35 89.202606201171875 36 87.212860107421875 37 81.950004577636719
		 38 72.105255126953125 39 65.39361572265625 40 58.123603820800781 41 53.82977294921875
		 42 49.184413909912109 43 43.81829833984375 44 47.933887481689453 45 51.113609313964844
		 46 52.813575744628906 47 52.888519287109375 48 51.277957916259766 49 48.113945007324219
		 50 44.124858856201172 51 41.044429779052734 52 37.522308349609375 53 34.958732604980469
		 54 33.756179809570313 55 34.135787963867188 56 34.317024230957031 57 34.176467895507813
		 58 34.595771789550781 59 34.466541290283203 60 33.894802093505859 61 33.243389129638672
		 62 32.455364227294922 63 32.039848327636719 64 32.066574096679688 65 32.067737579345703
		 66 32.008548736572266 67 31.913040161132813 68 31.913040161132813 69 31.913040161132813;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA";
	rename -uid "2B28B9FE-4C27-C3C0-73BB-9491C1901E96";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -32.338203430175781 1 -30.3555908203125
		 2 -29.298530578613281 3 -28.976390838623047 4 -29.216537475585937 5 -29.837818145751953
		 6 -30.654298782348633 7 -31.483631134033203 8 -32.158229827880859 9 -32.535533905029297
		 10 -32.547462463378906 11 -32.125694274902344 12 -31.389266967773438 13 -30.479455947875977
		 14 -29.331745147705078 15 -27.932704925537109 16 -26.358936309814453 17 -24.672233581542969
		 18 -23.63349723815918 19 -22.90641975402832 20 -22.108152389526367 21 -20.641992568969727
		 22 -18.05638313293457 23 -14.569767951965332 24 -10.851818084716797 25 -6.9350147247314453
		 26 -2.6105971336364746 27 2.2271718978881836 28 7.6473684310913086 29 13.632596969604492
		 30 20.119880676269531 31 27.034904479980469 32 34.376880645751953 33 42.197917938232422
		 34 51.610576629638672 35 63.344314575195312 36 76.814643859863281 37 91.609184265136719
		 38 105.83108520507812 39 112.79945373535156 40 117.93289184570312 41 120.52091217041016
		 42 121.99337768554687 43 122.39316558837891 44 122.3621826171875 45 121.60903167724609
		 46 120.42251586914062 47 119.11222839355469 48 117.94291687011719 49 117.09484100341797
		 50 116.19554138183594 51 114.98987579345703 52 113.9097900390625 53 113.52400207519531
		 54 113.37563323974609 55 112.90919494628906 56 112.54234313964844 57 112.47616577148437
		 58 112.70802307128906 59 112.86440277099609 60 112.92088317871094 61 112.88289642333984
		 62 112.84803009033203 63 113.00077819824219 64 112.94805908203125 65 112.91533660888672
		 66 112.94000244140625 67 112.986083984375 68 112.986083984375 69 112.986083984375;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX";
	rename -uid "8DA820E3-4FA9-12E5-C52A-49BF37732222";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -3.2986743066333757 1 -3.2484959314612798
		 2 -3.1289827435622657 3 -2.9864422515833882 4 -2.8670207000840939 5 -2.8169442791053974
		 6 -2.8218487274785948 7 -2.8346191542686077 8 -2.8524307692221234 9 -2.8721767939834928
		 10 -2.8908618025273887 11 -2.9048582560716638 12 -2.9106100400578971 13 -2.8978791113032041
		 14 -2.8594781333410699 15 -2.7964866453414601 16 -2.7097637321081005 17 -2.6004218922459432
		 18 -2.4694127304641937 19 -2.317735357950514 20 -2.1463449373071226 21 -1.9563627001110446
		 22 -1.7486504123146667 23 -1.524280196026415 24 -1.2843263167802799 25 -1.0296489165773617
		 26 -0.76137301234109045 27 -0.48044355690468127 28 -0.18802658040539269 29 0.12061249872919261
		 30 0.44912771777378246 31 0.79624511424692135 32 1.1620084395602572 33 1.5478851307068155
		 34 1.9569715828598033 35 2.3936701219747869 36 2.8632496972656329 37 3.3714015971712032
		 38 3.9231045775862872 39 4.5216478772844804 40 5.1669622867262017 41 5.8540169885220958
		 42 6.1780166388393516 43 6.4816122103001108 44 6.7896997446794165 45 7.1198702408154588
		 46 7.4805320991151518 47 7.8725503576855527 48 8.2901160623064332 49 8.7268248274500255
		 50 9.1893379596999534 51 9.7025133228047515 52 10.305752767414045 53 11.04439801709818
		 54 11.951817483718964 55 13.027962856197512 56 14.210053951582172 57 14.178152512652506
		 58 14.103094721548548 59 14.069171529627287 60 14.128122071714552 61 14.316616896713107
		 62 14.677147506329064 63 15.214306123654328 64 15.927272048195773 65 16.807327749146591
		 66 17.806854934595478 67 18.807946778718296 68 18.876660539682131 69 18.899977184299825;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY";
	rename -uid "905D86FE-423C-B8F4-9870-8DB4A2EF2B4A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 0.94580921225016767 1 1.0513304570462123
		 2 1.3028461516060057 3 1.6030281093874876 4 1.854616683143629 5 1.9602577363454374
		 6 1.7795286240027024 7 1.3066347622271095 8 0.64487241399269735 9 -0.10189084904345048
		 10 -0.83032885802397038 11 -1.4369432700518263 12 -1.8181093843452574 13 -2.0417155929413098
		 14 -2.2454116556255146 15 -2.4296576682374869 16 -2.5955757412680587 17 -2.7437560617370575
		 18 -2.8749853386420727 19 -2.9900245073422189 20 -3.089765959970991 21 -3.1748549929858858
		 22 -3.2460971452942329 23 -3.3043041178426624 24 -3.3502349192220371 25 -3.3845448114125425
		 26 -3.4081581198698951 27 -3.4218314571694242 28 -3.4262340814261925 29 -3.0298160713114228
		 30 -1.9038969003326702 31 -0.14377735029919722 32 2.1549772997725678 33 4.8969331396609217
		 34 7.9862050130675453 35 11.326950020156854 36 14.823383238755241 37 18.379120546530718
		 38 21.898371610403903 39 25.28513950027714 40 28.443647927539534 41 31.278469580902776
		 42 27.790884650509707 43 23.819380807742721 44 19.657709616555927 45 15.599056056897442
		 46 11.935851062667235 47 8.9591992390414639 48 6.9590895499290539 49 6.2236903153867562
		 50 7.3487286484402867 51 10.384426446759855 52 14.800355115438098 53 20.067275295373733
		 54 25.657308310908597 55 31.045897538129349 56 35.715437577404529 57 33.108295366373582
		 58 30.153614544465178 59 27.3808426492973 60 25.319570214601214 61 24.498350903976021
		 62 25.354408490461442 63 27.648541319393054 64 30.89272070056359 65 34.601013808765984
		 66 38.292658532681997 67 41.495907259165449 68 41.484255640905644 69 41.480281479353458;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ";
	rename -uid "41A9B002-4975-A587-AE1B-3B8CA26535B9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 3.0280593699951268 1 4.8653655029069256
		 2 9.1953922417205014 3 14.241121156819377 4 18.22430330096276 5 19.366566888255527
		 6 15.39505488147921 7 6.3741108976194978 8 -5.9795820586318884 9 -19.945129867676375
		 10 -33.807454431976815 11 -45.846164128961853 12 -54.344178113244489 13 -60.41840271019263
		 14 -66.289825071120561 15 -71.889948374843286 16 -77.156316523166794 17 -82.021959846819001
		 18 -86.253324548011477 19 -89.650908239241318 20 -92.20151264648824 21 -93.888027502364011
		 22 -94.696282277187947 23 -94.610770122351838 24 -93.617370388641206 25 -91.69874558756851
		 26 -88.842404115332386 27 -85.032367686350739 28 -80.252794592688417 29 -74.779965358466654
		 30 -68.912794792415468 31 -62.669463326257706 32 -56.070522513355549 33 -49.133747528485834
		 34 -41.882663251700606 35 -34.340745732030015 36 -26.52975948429712 37 -18.481775502907272
		 38 -10.220634497446289 39 -8.9732144046568045 40 -7.7944511774614167 41 -2.5066745713366552
		 42 6.928510117446061 43 16.050491856983609 44 10.965720518869711 45 5.2690636410329574
		 46 -0.11950840797810115 47 -4.2764823979141333 48 -6.2672424693440805 49 -5.6477891154622712
		 50 -3.4936662393820499 51 0.081875332029343745 52 4.874868580075737 53 10.680713599840605
		 54 9.4705346307204703 55 8.4977322968538349 56 7.927138318428633 57 5.8580131395524093
		 58 4.6234328064143915 59 4.9468122202397407 60 6.8019850198015526 61 9.5240857178131826
		 62 12.438197951640747 63 14.847865590151166 64 17.842155194057277 65 21.149737119201681
		 66 24.465590800717475 67 27.424389457081581 68 28.498456128916985 69 28.89594122896214;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA";
	rename -uid "AAD50E61-47FE-F98F-DC77-109CC7348732";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 29.639450073242188 1 29.644536972045898
		 2 29.653770446777344 3 29.673381805419922 4 29.701288223266602 5 29.734636306762695
		 6 29.770334243774414 7 29.805446624755859 8 29.837158203125 9 29.863059997558594
		 10 29.870189666748047 11 29.847198486328125 12 29.798192977905273 13 29.732919692993164
		 14 29.658912658691406 15 29.581466674804687 16 29.51246452331543 17 29.471307754516602
		 18 29.487218856811523 19 29.436555862426758 20 29.30009651184082 21 29.110811233520508
		 22 28.912330627441406 23 28.752508163452148 24 28.657323837280273 25 28.633087158203125
		 26 28.676200866699219 27 28.736471176147461 28 28.734785079956055 29 28.654209136962891
		 30 28.557746887207031 31 28.4151611328125 32 28.241275787353516 33 28.076435089111328
		 34 27.937505722045898 35 27.853616714477539 36 27.764673233032227 37 27.668676376342773
		 38 27.584568023681641 39 27.610359191894531 40 27.92796516418457 41 28.437526702880859
		 42 28.874248504638672 43 29.039499282836914 44 28.876705169677734 45 28.485004425048828
		 46 27.972785949707031 47 27.455526351928711 48 27.074069976806641 49 26.971366882324219
		 50 27.217721939086914 51 27.936027526855469 52 29.194637298583984 53 30.115739822387695
		 54 31.127834320068359 55 30.510478973388672 56 29.971445083618164 57 29.677036285400391
		 58 29.566625595092773 59 29.693439483642578 60 29.982627868652344 61 30.300107955932617
		 62 30.642185211181641 63 30.802219390869141 64 30.744958877563477 65 30.703035354614258
		 66 30.747825622558594 67 30.823869705200195 68 30.823869705200195 69 30.823869705200195;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA";
	rename -uid "28479142-45A1-5CA6-3A41-679CAC1081E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 52.198776245117188 1 52.306076049804688
		 2 52.345867156982422 3 52.346683502197266 4 52.276077270507813 5 52.102508544921875
		 6 51.7957763671875 7 51.327327728271484 8 50.670082092285156 9 49.798171997070313
		 10 48.740814208984375 11 47.429271697998047 12 45.738483428955078 13 43.5972900390625
		 14 40.883255004882813 15 37.433349609375 16 33.281547546386719 17 28.60723876953125
		 18 28.578742980957031 19 28.588092803955078 20 28.50480842590332 21 28.31181526184082
		 22 27.996921539306641 23 27.571826934814453 24 27.052209854125977 25 26.476455688476563
		 26 25.952548980712891 27 25.488693237304688 28 25.080564498901367 29 24.689170837402344
		 30 24.278343200683594 31 24.051536560058594 32 24.171478271484375 33 24.673839569091797
		 34 25.629301071166992 35 27.010738372802734 36 28.883382797241211 37 30.933982849121094
		 38 32.701263427734375 39 33.955352783203125 40 35.241523742675781 41 36.330947875976562
		 42 37.2962646484375 43 37.631565093994141 44 37.231044769287109 45 36.259017944335938
		 46 34.914955139160156 47 33.386375427246094 48 31.839282989501953 49 30.582855224609375
		 50 29.062103271484375 51 27.248023986816406 52 25.107791900634766 53 23.761375427246094
		 54 22.439338684082031 55 22.723136901855469 56 22.833904266357422 57 22.649848937988281
		 58 23.0543212890625 59 22.925067901611328 60 22.353336334228516 61 21.701915740966797
		 62 20.913890838623047 63 20.498376846313477 64 20.525100708007812 65 20.526264190673828
		 66 20.467079162597656 67 20.37158203125 68 20.37158203125 69 20.37158203125;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA";
	rename -uid "54A770F3-4E38-1DBC-A4DD-E096AA9308D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -17.124008178710938 1 -14.805696487426758
		 2 -12.400012969970703 3 -9.8984317779541016 4 -7.3196702003479004 5 -4.683586597442627
		 6 -2.0109052658081055 7 0.67701387405395508 8 3.3586218357086182 9 6.0125517845153809
		 10 8.5744647979736328 11 11.010845184326172 12 13.364433288574219 13 15.689053535461426
		 14 18.019086837768555 15 20.342487335205078 16 22.559116363525391 17 24.581911087036133
		 18 26.351352691650391 19 28.438188552856445 20 30.515911102294922 21 32.569637298583984
		 22 34.581512451171875 23 36.530776977539063 24 38.269584655761719 25 39.712932586669922
		 26 41.016532897949219 27 42.236869812011719 28 43.402664184570313 29 44.470191955566406
		 30 45.36920166015625 31 46.041702270507813 32 46.530635833740234 33 46.962615966796875
		 34 47.457347869873047 35 48.2039794921875 36 49.652065277099609 37 51.917472839355469
		 38 54.431121826171875 39 56.369998931884766 40 58.039821624755859 41 59.251121520996094
		 42 59.948749542236328 43 60.230716705322266 44 60.131866455078125 45 59.709579467773438
		 46 59.001354217529297 47 58.030693054199219 48 56.865428924560547 49 55.614295959472656
		 50 54.317058563232422 51 52.947219848632813 52 51.72979736328125 53 51.255317687988281
		 54 51.102527618408203 55 50.633815765380859 56 50.266017913818359 57 50.199562072753906
		 58 50.43133544921875 59 50.5877685546875 60 50.644233703613281 61 50.606266021728516
		 62 50.571395874023438 63 50.723892211914063 64 50.671428680419922 65 50.638702392578125
		 66 50.663356781005859 67 50.709442138671875 68 50.709442138671875 69 50.709442138671875;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX";
	rename -uid "1C3C47D8-46D6-1183-ABA1-48B3D1DC37EC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -1.9526710998863654 1 -1.6950181772069739
		 2 -1.4452443361874734 3 -1.1952088272142245 4 -0.94226800582172976 5 -0.68127004440694583
		 6 -0.40549140717831589 7 -0.10782867253376432 8 0.21798602711051976 9 0.57656212679165275
		 10 1.1224071289269928 11 2.3336206168070852 12 4.2338419131878871 13 6.8267820493372824
		 14 9.9171747075592975 15 12.177383151246831 16 13.483697465087634 17 15.765723550482104
		 18 13.854183922150854 19 13.878401431222347 20 13.780091006953191 21 13.218882891941506
		 22 12.021507333424985 23 10.19625832830126 24 7.8187362969154206 25 5.2499338060201239
		 26 1.325759015337086 27 -2.9556339136448311 28 -6.8142247134886391 29 -9.4397172855319678
		 30 -11.146953788285749 31 -12.024249734138426 32 -12.421306561842911 33 -12.575262482157543
		 34 -12.286812124832947 35 -11.470059252079702 36 -10.225078061405501 37 -8.800119928684234
		 38 -7.0230656934330939 39 -5.6227924651660972 40 -5.6631064643018165 41 -5.4343495310442345
		 42 -6.2260246915670558 43 -8.5845233900033708 44 -11.974008722775018 45 -15.707324933550252
		 46 -19.15969297657179 47 -21.963587656300316 48 -23.904040839902855 49 -24.931387283924714
		 50 -25.78601051983637 51 -25.729486563489473 52 -24.251850763239524 53 -24.211679854768093
		 54 -24.142459557992161 55 -24.343895830569203 56 -24.423801019806767 57 -24.315439899476615
		 58 -23.990433357262781 59 -23.539408112943018 60 -22.934630338858987 61 -22.862716472356368
		 62 -22.728161033918756 63 -22.782405783822632 64 -22.768559991152916 65 -22.772106736006481
		 66 -22.781096756585452 67 -22.795307948586956 68 -22.795307948586956 69 -22.795307948586956;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY";
	rename -uid "C17C411A-4A5E-6B4E-3895-8C99204C579F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -0.43206594992945507 1 -0.37264882066018173
		 2 -0.25762430232856076 3 -0.040701678805416024 4 0.2536600597006583 5 0.60249623816454501
		 6 0.98187840650055502 7 1.3645967852186431 8 1.7171179000672576 9 1.9989771700830585
		 10 1.1652282465604908 11 0.35499658359127262 12 0.55357750042946396 13 1.913834845212494
		 14 4.2657444969944747 15 6.0597488457843314 16 6.9242003137792176 17 8.7785992951308938
		 18 6.5955227848198472 19 6.4797076217651819 20 6.0889589575023866 21 5.441374877235214
		 22 4.5975012303527709 23 3.6890248321181049 24 3.007764150930738 25 3.8194394522583197
		 26 3.358985452607687 27 2.907345038726513 28 2.377672840473593 29 0.82081165955031454
		 30 -0.78220434481697443 31 -1.3610005203366804 32 -1.1127765149843041 33 -0.28647788125571633
		 34 0.89447318968997469 35 2.3592607195964237 36 4.0171760811050277 37 6.1716872439179982
		 38 7.2478709371166614 39 7.5061390021248915 40 4.201635680949229 41 2.8688711541377994
		 42 2.5883162778825102 43 2.8479769596938356 44 3.1460377908835833 45 3.1793922237681072
		 46 2.4882081789952042 47 1.0193921984933161 48 -1.0353739118964285 49 -3.399604385934754
		 50 -1.9439504865407589 51 -8.0374419353626116 52 -13.993279720261109 53 -14.548007884626356
		 54 -14.716626506488586 55 -13.262687026416083 56 -11.782639553489954 57 -10.788058129119149
		 58 -10.852381827606807 59 -11.918770811738899 60 -13.559620020107634 61 -14.576082123519758
		 62 -15.853163970425715 63 -15.912730384556047 64 -16.144762268458837 65 -16.209675494941781
		 66 -16.144809417718548 67 -16.032751529519022 68 -16.032751529519022 69 -16.032751529519022;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "19034B20-41BD-26E7-226B-579F7BAE5C08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 6.0830963629504797 1 8.3184122995996965
		 2 10.823666410507089 3 13.803868532235596 4 17.166242507459945 5 20.825008495869035
		 6 24.689292590275862 7 28.649915564226404 8 32.563137371122785 9 36.243468226674658
		 10 33.744247382127213 11 28.346018078662397 12 24.844901258370022 13 24.062842701021328
		 14 25.512121907447234 15 27.733404069006372 16 30.205497909934344 17 34.014122321471454
		 18 38.419764435926581 19 39.904321268477062 20 42.898106593095001 21 46.969258261175426
		 22 51.881923641910163 23 57.80772390859952 24 65.313105295876298 25 79.178083718612612
		 26 78.167104879819874 27 78.10611442085154 28 78.558539907956643 29 79.386638384143055
		 30 81.115449131476808 31 85.184350908005769 32 91.975866617593596 33 100.61741362735175
		 34 110.72869629515324 35 122.22032829856605 36 134.68837475571229 37 147.45738331022795
		 38 160.92110236550874 39 167.12698785353967 40 160.19701835020439 41 155.51393384556152
		 42 150.881117332835 43 145.95812585602846 44 140.87006738124282 45 135.60864606670674
		 46 129.97122292014413 47 124.35426868306858 48 119.25507722578379 49 115.26976695610905
		 50 116.60491823353259 51 107.66864114107524 52 97.850552196432005 53 94.242210782339328
		 54 91.108739499860761 55 93.972091564486249 56 97.856630948142424 57 100.63861091058423
		 58 99.247263670449186 59 95.51034906986294 60 90.974199491263718 61 88.726432048956866
		 62 86.256300150592324 63 86.538814121255768 64 86.343035201533368 65 86.330999851077195
		 66 86.414367283597073 67 86.551782100038437 68 86.551782100038437 69 86.551782100038437;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA";
	rename -uid "ECBA66DE-47C8-BA12-515F-F49CBF10D132";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -17.514377593994141 1 -17.509271621704102
		 2 -17.5 3 -17.480384826660156 4 -17.452543258666992 5 -17.41920280456543 6 -17.383443832397461
		 7 -17.348384857177734 8 -17.316669464111328 9 -17.290752410888672 10 -17.283596038818359
		 11 -17.306594848632812 12 -17.355611801147461 13 -17.420927047729492 14 -17.494953155517578
		 15 -17.572334289550781 16 -17.641347885131836 17 -17.682493209838867 18 -17.666585922241211
		 19 -17.717313766479492 20 -17.853662490844727 21 -18.042924880981445 22 -18.241504669189453
		 23 -18.401269912719727 24 -18.496511459350586 25 -18.520679473876953 26 -18.477672576904297
		 27 -18.417333602905273 28 -18.419023513793945 29 -18.499576568603516 30 -18.596073150634766
		 31 -18.738662719726563 32 -18.912586212158203 33 -19.077335357666016 34 -19.216371536254883
		 35 -19.300191879272461 36 -19.389158248901367 37 -19.485067367553711 38 -19.569232940673828
		 39 -19.543460845947266 40 -19.225839614868164 41 -18.716255187988281 42 -18.279582977294922
		 43 -18.114263534545898 44 -18.277103424072266 45 -18.668739318847656 46 -19.181068420410156
		 47 -19.698301315307617 48 -20.079696655273438 49 -20.182403564453125 50 -19.936044692993164
		 51 -19.217742919921875 52 -17.959129333496094 53 -17.038030624389648 54 -16.025936126708984
		 55 -16.643291473388672 56 -17.182321548461914 57 -17.476730346679687 58 -17.58714485168457
		 59 -17.4603271484375 60 -17.171142578125 61 -16.853658676147461 62 -16.511581420898438
		 63 -16.351551055908203 64 -16.408811569213867 65 -16.45073127746582 66 -16.40594482421875
		 67 -16.329900741577148 68 -16.329900741577148 69 -16.329900741577148;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA";
	rename -uid "EC9E8691-4041-44A8-6C06-22A236EC0CE0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 36.221920013427734 1 36.327713012695312
		 2 36.363525390625 3 36.359237670898437 4 36.283988952636719 5 36.107902526855469
		 6 35.802249908447266 7 35.339534759521484 8 34.693428039550781 9 33.838111877441406
		 10 32.802379608154297 11 31.51640510559082 12 29.85357666015625 13 27.740653991699219
		 14 25.052885055541992 15 21.624666213989258 16 17.487430572509766 17 12.818382263183594
		 18 12.776897430419922 19 12.750303268432617 20 12.616214752197266 21 12.369524002075195
		 22 12.013589859008789 23 11.578723907470703 24 11.101388931274414 25 10.642599105834961
		 26 10.333732604980469 27 10.206430435180664 28 10.278732299804687 29 10.531839370727539
		 30 10.946512222290039 31 11.738616943359375 32 13.077724456787109 33 14.999710083007813
		 34 17.568107604980469 35 20.740795135498047 36 24.559921264648438 37 28.681415557861328
		 38 32.605979919433594 39 34.057769775390625 40 35.517566680908203 41 36.7451171875
		 42 37.801670074462891 43 38.169906616210938 44 37.725002288818359 45 36.639545440673828
		 46 35.142562866210938 47 33.451179504394531 48 31.761009216308594 49 30.504583358764648
		 50 28.983829498291016 51 27.169750213623047 52 25.029518127441406 53 23.683101654052734
		 54 22.361063003540039 55 22.644863128662109 56 22.755630493164063 57 22.571575164794922
		 58 22.976047515869141 59 22.846794128417969 60 22.275062561035156 61 21.623641967773438
		 62 20.835617065429687 63 20.420103073120117 64 20.446826934814453 65 20.447990417480469
		 66 20.388803482055664 67 20.293308258056641 68 20.293308258056641 69 20.293308258056641;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA";
	rename -uid "D9184850-4496-19ED-1636-2497FB8E580D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -17.879848480224609 1 -15.528398513793945
		 2 -13.028724670410156 3 -10.380369186401367 4 -7.610142707824707 5 -4.7459907531738281
		 6 -1.8168106079101563 7 1.1478495597839355 8 4.1182327270507812 9 7.0647416114807129
		 10 9.9148321151733398 11 12.626832008361816 12 15.235386848449707 13 17.786331176757813
		 14 20.306085586547852 15 22.774736404418945 16 25.084299087524414 17 27.139842987060547
		 18 28.82768440246582 19 30.673294067382813 20 32.355155944824219 21 33.863201141357422
		 22 35.184795379638672 23 36.305469512939453 24 37.085433959960938 25 37.450233459472656
		 26 37.569248199462891 27 37.516334533691406 28 37.341609954833984 29 37.027019500732422
		 30 36.532173156738281 31 35.832721710205078 32 35.008506774902344 33 34.225208282470703
		 34 33.642562866210938 35 33.489418029785156 36 34.252777099609375 37 36.082195281982422
		 38 38.436714172363281 39 40.375617980957031 40 42.047508239746094 41 43.261791229248047
		 42 43.962028503417969 43 44.245086669921875 44 44.144798278808594 45 43.719413757324219
		 46 43.008262634277344 47 42.036128997802734 48 40.870933532714844 49 39.619792938232422
		 50 38.322563171386719 51 36.952720642089844 52 35.735298156738281 53 35.260818481445313
		 54 35.108028411865234 55 34.639312744140625 56 34.271522521972656 57 34.205062866210937
		 58 34.436836242675781 59 34.593269348144531 60 34.649734497070313 61 34.611770629882813
		 62 34.576896667480469 63 34.729389190673828 64 34.676929473876953 65 34.644203186035156
		 66 34.668857574462891 67 34.714942932128906 68 34.714942932128906 69 34.714942932128906;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX";
	rename -uid "B38799FB-4AF6-A8E5-761F-CD99104DE9F8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 -8.3475794899922739 1 -7.3521209549056303
		 2 -6.4168274889471899 3 -5.493841930738034 4 -4.5726060167029035 5 -3.6482250340032354
		 6 -2.7165566965282779 7 -1.7695374909908217 8 -0.79227083739927395 9 0.23710101105449333
		 10 1.3403701829693688 11 2.4657860416775246 12 3.6555128671293082 13 5.1200635751230106
		 14 7.1674067051860719 15 10.23373644330327 16 14.911624511026769 17 22.316372343825279
		 18 23.344470188202614 19 23.495490447148487 20 23.923550738444003 21 24.484600218928897
		 22 24.964160656576013 23 24.485099971048307 24 22.708262798135017 25 20.273558667888643
		 26 17.777331980259255 27 15.039478896690724 28 12.465439061878861 29 10.066623309966216
		 30 6.8567707008216789 31 3.1729160865036978 32 -0.37276613429838557 33 -3.5026622933946996
		 34 -5.8940615667204517 35 -7.8975384429751125 36 -10.391664106833051 37 -12.560606970104368
		 38 -9.4528175695878485 39 0.45019423851578416 40 10.129313845451623 41 15.340878996514464
		 42 16.647116276277391 43 16.403637661908274 44 16.577362172914931 45 16.777869081740025
		 46 17.730585272934906 47 19.031547791436708 48 19.720772786138834 49 18.091392364329376
		 50 11.17350988227388 51 -4.4214573219304647 52 -24.001462250646586 53 -35.863744764872507
		 54 -28.141657558926433 55 -25.070986733560435 56 -22.762526413535202 57 -19.419261325404335
		 58 -18.593573234431393 59 -18.850914133667036 60 -20.180256285950112 61 -21.984149778507007
		 62 -23.437119705431375 63 -23.981112961612897 64 -24.128106067737871 65 -24.138501030056631
		 66 -24.095039498910904 67 -23.984933299447484 68 -23.984933299447484 69 -23.984933299447484;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY";
	rename -uid "D148D220-4440-DCCE-0C8A-CBA1A404C91A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 19.418171797016864 1 19.415299236660417
		 2 19.311892052066035 3 19.093807991005843 4 18.768648101262958 5 18.356278167260879
		 6 17.885669518287173 7 17.390541591889107 8 16.904209998776938 9 16.454073752662367
		 10 16.061210755117227 11 15.843738473510422 12 15.886055411821051 13 16.157184084428177
		 14 16.538490574425598 15 16.722198710567955 16 16.14839543100075 17 13.237850528357512
		 18 9.0020729990769635 19 9.3903079508707439 20 10.528044935002873 21 12.224313434350771
		 22 14.212157294698844 23 17.990168568763984 24 22.50699910545239 25 25.739138954801078
		 26 27.398948397675451 27 28.352328108790839 28 29.554317231501397 29 31.732127067111612
		 30 34.349970152029606 31 37.079549891474777 32 39.500789347791795 33 38.990466310375474
		 34 37.858302665140911 35 37.263066920778385 36 38.077830777927737 37 40.924956511025542
		 38 43.349419925624836 39 42.196497274372931 40 35.583379356052134 41 25.135686912021018
		 42 15.19471466877274 43 10.877747802503135 44 10.335899500613966 45 15.009649719492469
		 46 21.431706516288163 47 29.483135132440353 48 38.771723788439203 49 48.574353988326038
		 50 57.558276022831137 51 63.014446743386934 52 61.109968978669222 53 48.479067234780345
		 54 29.162694058308265 55 28.336606879325704 56 30.329052173648638 57 28.86848140532009
		 58 31.055264796198848 59 32.448996819881643 60 32.572146139864515 61 31.52223203154831
		 62 29.993668914237592 63 28.126379540439213 64 28.985460015377889 65 29.490459494738442
		 66 28.827785916633559 67 27.755752137711017 68 27.755752137711017 69 27.755752137711017;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "290A4A20-4FD1-4E2B-7355-E699270634F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 70 ".ktv[0:69]"  0 5.5636399904493956 1 10.283455449381952
		 2 14.884010870484268 3 19.479897154684494 4 24.10357112343835 5 28.774160583104955
		 6 33.501347705138173 7 38.292356447985185 8 43.159355899111723 9 48.125358130199373
		 10 53.06014908382479 11 58.246266612958834 12 64.090628488971944 13 70.711365285430276
		 14 78.342499301819529 15 87.392665306335331 16 98.111733833394226 17 111.32597470694745
		 18 116.48049341217151 19 117.30890382014614 20 118.50691775862451 21 119.8091060501027
		 22 120.92247502004696 23 119.50113281615491 24 116.08978125615877 25 112.90499759819613
		 26 110.76198744079183 27 108.42402977609602 28 106.65167737706952 29 105.89483866136234
		 30 103.06719504020664 31 98.724068103474636 32 94.493892894106793 33 89.602262465725346
		 34 86.479444988705467 35 85.269097353721492 36 88.612948734277708 37 100.27130974171169
		 38 123.13395440510186 39 147.61477399505782 40 171.00256112443452 41 188.44694110592792
		 42 199.6570193681373 43 206.56608264293055 44 211.97083027306596 45 212.38422600658558
		 46 211.99242435106831 47 209.98149312900384 48 205.64498618404019 49 197.98164041321158
		 50 183.42264536661281 51 158.43113870196433 52 126.98387355063313 53 95.100387424648673
		 54 70.727537591718388 55 68.079953757684294 56 66.745334463495013 57 65.958346378208446
		 58 73.496999015958082 59 76.723114914779245 60 75.229162753580482 61 69.727543703708477
		 62 62.827561565168509 63 56.602978145247945 64 57.211359208202481 65 57.411733661775962
		 66 56.490290762287287 67 55.029411269156455 68 55.029411269156455 69 55.029411269156455;
	setAttr ".roti" 5;
createNode pairBlend -n "pairBlend1";
	rename -uid "8C583AA5-4B58-A691-831A-1D81F084242F";
createNode pairBlend -n "pairBlend2";
	rename -uid "4899FE6C-4200-B251-63A7-189ED8E0C512";
createNode pairBlend -n "pairBlend3";
	rename -uid "75723816-4A77-5580-F8A4-A5BA8005CD20";
createNode pairBlend -n "pairBlend4";
	rename -uid "74332A7A-4DBC-F75F-0DAE-E9A049CAAD08";
createNode pairBlend -n "pairBlend5";
	rename -uid "4D64098E-433C-82E8-BE0A-688E039D089A";
createNode pairBlend -n "pairBlend6";
	rename -uid "50402861-4886-0CD4-DE66-B1913FC29C33";
createNode pairBlend -n "pairBlend7";
	rename -uid "3B9EA1E8-4E11-8EC8-74E7-848C86DA90B5";
createNode pairBlend -n "pairBlend8";
	rename -uid "B4A2E3F4-4C8B-4B83-D96D-55A46DB1C4DA";
createNode pairBlend -n "pairBlend9";
	rename -uid "D373299C-4DF7-0DBD-1003-E9B07894ECEC";
createNode pairBlend -n "pairBlend10";
	rename -uid "929D5A50-4DBC-74DE-3189-37AAE0127C18";
createNode pairBlend -n "pairBlend11";
	rename -uid "53CB5C40-4A97-67B6-2AF1-D19305A59CDB";
createNode pairBlend -n "pairBlend12";
	rename -uid "91570127-49BD-0992-DA99-39B4F90F7C53";
createNode pairBlend -n "pairBlend13";
	rename -uid "69E8F845-4548-ABA7-8738-529702DBB0EB";
createNode pairBlend -n "pairBlend14";
	rename -uid "4AA4E08D-4CC8-0DF2-9498-6085AA7B5E69";
createNode pairBlend -n "pairBlend15";
	rename -uid "30B944D7-433A-0926-37F5-5FAC37E02E25";
createNode pairBlend -n "pairBlend16";
	rename -uid "9CBBBCE4-483C-2A61-DEC4-C385706DA8D8";
createNode pairBlend -n "pairBlend17";
	rename -uid "D3332111-4634-3CDF-62EF-C0AC2EABD851";
createNode pairBlend -n "pairBlend18";
	rename -uid "546E330D-4618-B5C7-4DC9-C7806BC92F8C";
createNode pairBlend -n "pairBlend19";
	rename -uid "1B615FD5-4899-2E83-296E-C3A7480B7CE2";
createNode pairBlend -n "pairBlend20";
	rename -uid "E5F5F17B-4C71-5449-2D07-C4B26E3D0752";
createNode pairBlend -n "pairBlend21";
	rename -uid "BCE2733D-4FED-C1E3-6264-5B945D0571EE";
createNode pairBlend -n "pairBlend22";
	rename -uid "ACDCD86F-4B8F-6413-9322-AFA94AB9F3E3";
createNode pairBlend -n "pairBlend23";
	rename -uid "55385C37-4626-7ECA-9BC4-F098DB1FD9FC";
createNode vstExportNode -n "overboss_death_exportNode";
	rename -uid "5748C2A9-4D58-B415-A018-799FD2A91820";
	setAttr ".ei[0].exportFile" -type "string" "overboss_death";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 69;
select -ne :time1;
	setAttr ".o" 21;
	setAttr ".unw" 21;
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
connectAttr "RIGRN.phl[369]" "pairBlend15.itx1";
connectAttr "RIGRN.phl[370]" "pairBlend15.ity1";
connectAttr "RIGRN.phl[371]" "pairBlend15.itz1";
connectAttr "RIGRN.phl[372]" "pairBlend15.irx1";
connectAttr "RIGRN.phl[373]" "pairBlend15.iry1";
connectAttr "RIGRN.phl[374]" "pairBlend15.irz1";
connectAttr "RIGRN.phl[375]" "pairBlend18.itx1";
connectAttr "RIGRN.phl[376]" "pairBlend18.ity1";
connectAttr "RIGRN.phl[377]" "pairBlend18.itz1";
connectAttr "RIGRN.phl[378]" "pairBlend18.irx1";
connectAttr "RIGRN.phl[379]" "pairBlend18.iry1";
connectAttr "RIGRN.phl[380]" "pairBlend18.irz1";
connectAttr "RIGRN.phl[381]" "pairBlend9.itx1";
connectAttr "RIGRN.phl[382]" "pairBlend9.ity1";
connectAttr "RIGRN.phl[383]" "pairBlend9.itz1";
connectAttr "RIGRN.phl[384]" "pairBlend9.irx1";
connectAttr "RIGRN.phl[385]" "pairBlend9.iry1";
connectAttr "RIGRN.phl[386]" "pairBlend9.irz1";
connectAttr "RIGRN.phl[387]" "pairBlend10.itx1";
connectAttr "RIGRN.phl[388]" "pairBlend10.ity1";
connectAttr "RIGRN.phl[389]" "pairBlend10.itz1";
connectAttr "RIGRN.phl[390]" "pairBlend10.irx1";
connectAttr "RIGRN.phl[391]" "pairBlend10.iry1";
connectAttr "RIGRN.phl[392]" "pairBlend10.irz1";
connectAttr "RIGRN.phl[393]" "pairBlend11.itx1";
connectAttr "RIGRN.phl[394]" "pairBlend11.ity1";
connectAttr "RIGRN.phl[395]" "pairBlend11.itz1";
connectAttr "RIGRN.phl[396]" "pairBlend11.irx1";
connectAttr "RIGRN.phl[397]" "pairBlend11.iry1";
connectAttr "RIGRN.phl[398]" "pairBlend11.irz1";
connectAttr "RIGRN.phl[399]" "pairBlend2.itx1";
connectAttr "RIGRN.phl[400]" "pairBlend2.ity1";
connectAttr "RIGRN.phl[401]" "pairBlend2.itz1";
connectAttr "RIGRN.phl[402]" "pairBlend2.irx1";
connectAttr "RIGRN.phl[403]" "pairBlend2.iry1";
connectAttr "RIGRN.phl[404]" "pairBlend2.irz1";
connectAttr "RIGRN.phl[405]" "pairBlend3.itx1";
connectAttr "RIGRN.phl[406]" "pairBlend3.ity1";
connectAttr "RIGRN.phl[407]" "pairBlend3.itz1";
connectAttr "RIGRN.phl[408]" "pairBlend3.irx1";
connectAttr "RIGRN.phl[409]" "pairBlend3.iry1";
connectAttr "RIGRN.phl[410]" "pairBlend3.irz1";
connectAttr "RIGRN.phl[411]" "pairBlend4.itx1";
connectAttr "RIGRN.phl[412]" "pairBlend4.ity1";
connectAttr "RIGRN.phl[413]" "pairBlend4.itz1";
connectAttr "RIGRN.phl[414]" "pairBlend4.irx1";
connectAttr "RIGRN.phl[415]" "pairBlend4.iry1";
connectAttr "RIGRN.phl[416]" "pairBlend4.irz1";
connectAttr "RIGRN.phl[417]" "pairBlend16.itx1";
connectAttr "RIGRN.phl[418]" "pairBlend16.ity1";
connectAttr "RIGRN.phl[419]" "pairBlend16.itz1";
connectAttr "RIGRN.phl[420]" "pairBlend16.irx1";
connectAttr "RIGRN.phl[421]" "pairBlend16.iry1";
connectAttr "RIGRN.phl[422]" "pairBlend16.irz1";
connectAttr "RIGRN.phl[423]" "pairBlend20.itx1";
connectAttr "RIGRN.phl[424]" "pairBlend20.ity1";
connectAttr "RIGRN.phl[425]" "pairBlend20.itz1";
connectAttr "RIGRN.phl[426]" "pairBlend20.irx1";
connectAttr "RIGRN.phl[427]" "pairBlend20.iry1";
connectAttr "RIGRN.phl[428]" "pairBlend20.irz1";
connectAttr "RIGRN.phl[429]" "pairBlend1.itx1";
connectAttr "RIGRN.phl[430]" "pairBlend1.ity1";
connectAttr "RIGRN.phl[431]" "pairBlend1.itz1";
connectAttr "RIGRN.phl[432]" "pairBlend1.irx1";
connectAttr "RIGRN.phl[433]" "pairBlend1.iry1";
connectAttr "RIGRN.phl[434]" "pairBlend1.irz1";
connectAttr "RIGRN.phl[435]" "pairBlend19.itx1";
connectAttr "RIGRN.phl[436]" "pairBlend19.ity1";
connectAttr "RIGRN.phl[437]" "pairBlend19.itz1";
connectAttr "RIGRN.phl[438]" "pairBlend19.irx1";
connectAttr "RIGRN.phl[439]" "pairBlend19.iry1";
connectAttr "RIGRN.phl[440]" "pairBlend19.irz1";
connectAttr "RIGRN.phl[441]" "pairBlend12.itx1";
connectAttr "RIGRN.phl[442]" "pairBlend12.ity1";
connectAttr "RIGRN.phl[443]" "pairBlend12.itz1";
connectAttr "RIGRN.phl[444]" "pairBlend12.irx1";
connectAttr "RIGRN.phl[445]" "pairBlend12.iry1";
connectAttr "RIGRN.phl[446]" "pairBlend12.irz1";
connectAttr "RIGRN.phl[447]" "pairBlend13.itx1";
connectAttr "RIGRN.phl[448]" "pairBlend13.ity1";
connectAttr "RIGRN.phl[449]" "pairBlend13.itz1";
connectAttr "RIGRN.phl[450]" "pairBlend13.irx1";
connectAttr "RIGRN.phl[451]" "pairBlend13.iry1";
connectAttr "RIGRN.phl[452]" "pairBlend13.irz1";
connectAttr "RIGRN.phl[453]" "pairBlend14.itx1";
connectAttr "RIGRN.phl[454]" "pairBlend14.ity1";
connectAttr "RIGRN.phl[455]" "pairBlend14.itz1";
connectAttr "RIGRN.phl[456]" "pairBlend14.irx1";
connectAttr "RIGRN.phl[457]" "pairBlend14.iry1";
connectAttr "RIGRN.phl[458]" "pairBlend14.irz1";
connectAttr "RIGRN.phl[459]" "pairBlend5.itx1";
connectAttr "RIGRN.phl[460]" "pairBlend5.ity1";
connectAttr "RIGRN.phl[461]" "pairBlend5.itz1";
connectAttr "RIGRN.phl[462]" "pairBlend5.irx1";
connectAttr "RIGRN.phl[463]" "pairBlend5.iry1";
connectAttr "RIGRN.phl[464]" "pairBlend5.irz1";
connectAttr "RIGRN.phl[465]" "pairBlend6.itx1";
connectAttr "RIGRN.phl[466]" "pairBlend6.ity1";
connectAttr "RIGRN.phl[467]" "pairBlend6.itz1";
connectAttr "RIGRN.phl[468]" "pairBlend6.irx1";
connectAttr "RIGRN.phl[469]" "pairBlend6.iry1";
connectAttr "RIGRN.phl[470]" "pairBlend6.irz1";
connectAttr "RIGRN.phl[471]" "pairBlend7.itx1";
connectAttr "RIGRN.phl[472]" "pairBlend7.ity1";
connectAttr "RIGRN.phl[473]" "pairBlend7.itz1";
connectAttr "RIGRN.phl[474]" "pairBlend7.irx1";
connectAttr "RIGRN.phl[475]" "pairBlend7.iry1";
connectAttr "RIGRN.phl[476]" "pairBlend7.irz1";
connectAttr "RIGRN.phl[477]" "pairBlend17.itx1";
connectAttr "RIGRN.phl[478]" "pairBlend17.ity1";
connectAttr "RIGRN.phl[479]" "pairBlend17.itz1";
connectAttr "RIGRN.phl[480]" "pairBlend17.irx1";
connectAttr "RIGRN.phl[481]" "pairBlend17.iry1";
connectAttr "RIGRN.phl[482]" "pairBlend17.irz1";
connectAttr "RIGRN.phl[483]" "pairBlend8.itx1";
connectAttr "RIGRN.phl[484]" "pairBlend8.ity1";
connectAttr "RIGRN.phl[485]" "pairBlend8.itz1";
connectAttr "RIGRN.phl[486]" "pairBlend8.irx1";
connectAttr "RIGRN.phl[487]" "pairBlend8.iry1";
connectAttr "RIGRN.phl[488]" "pairBlend8.irz1";
connectAttr "RIGRN.phl[489]" "pairBlend21.itx1";
connectAttr "RIGRN.phl[490]" "pairBlend21.ity1";
connectAttr "RIGRN.phl[491]" "pairBlend21.itz1";
connectAttr "RIGRN.phl[492]" "pairBlend21.irx1";
connectAttr "RIGRN.phl[493]" "pairBlend21.iry1";
connectAttr "RIGRN.phl[494]" "pairBlend21.irz1";
connectAttr "RIGRN.phl[495]" "pairBlend22.itx1";
connectAttr "RIGRN.phl[496]" "pairBlend22.ity1";
connectAttr "RIGRN.phl[497]" "pairBlend22.itz1";
connectAttr "RIGRN.phl[498]" "pairBlend22.irx1";
connectAttr "RIGRN.phl[499]" "pairBlend22.iry1";
connectAttr "RIGRN.phl[500]" "pairBlend22.irz1";
connectAttr "RIGRN.phl[501]" "pairBlend23.itx1";
connectAttr "RIGRN.phl[502]" "pairBlend23.ity1";
connectAttr "RIGRN.phl[503]" "pairBlend23.itz1";
connectAttr "RIGRN.phl[504]" "pairBlend23.irx1";
connectAttr "RIGRN.phl[505]" "pairBlend23.iry1";
connectAttr "RIGRN.phl[506]" "pairBlend23.irz1";
connectAttr "HIKState2SK1.HipsSx" "RIGRN.phl[1]";
connectAttr "HIKState2SK1.HipsSy" "RIGRN.phl[2]";
connectAttr "HIKState2SK1.HipsSz" "RIGRN.phl[3]";
connectAttr "pairBlend1.otx" "RIGRN.phl[4]";
connectAttr "pairBlend1.oty" "RIGRN.phl[5]";
connectAttr "pairBlend1.otz" "RIGRN.phl[6]";
connectAttr "RIGRN.phl[7]" "HIKState2SK1.HipsPGX";
connectAttr "pairBlend1.orx" "RIGRN.phl[8]";
connectAttr "pairBlend1.ory" "RIGRN.phl[9]";
connectAttr "pairBlend1.orz" "RIGRN.phl[10]";
connectAttr "RIGRN.phl[11]" "HIKState2SK1.HipsROrder";
connectAttr "RIGRN.phl[12]" "HIKState2SK1.HipsPreR";
connectAttr "RIGRN.phl[13]" "HIKState2SK1.HipsSC";
connectAttr "RIGRN.phl[14]" "HIKState2SK1.HipsIS";
connectAttr "RIGRN.phl[15]" "Character1.Hips";
connectAttr "RIGRN.phl[16]" "HIKState2SK1.HipsPostR";
connectAttr "RIGRN.phl[17]" "HIKState2SK1.SpineIS";
connectAttr "HIKState2SK1.SpineSx" "RIGRN.phl[18]";
connectAttr "HIKState2SK1.SpineSy" "RIGRN.phl[19]";
connectAttr "HIKState2SK1.SpineSz" "RIGRN.phl[20]";
connectAttr "RIGRN.phl[21]" "HIKState2SK1.SpinePGX";
connectAttr "pairBlend8.otx" "RIGRN.phl[22]";
connectAttr "pairBlend8.oty" "RIGRN.phl[23]";
connectAttr "pairBlend8.otz" "RIGRN.phl[24]";
connectAttr "pairBlend8.orx" "RIGRN.phl[25]";
connectAttr "pairBlend8.ory" "RIGRN.phl[26]";
connectAttr "pairBlend8.orz" "RIGRN.phl[27]";
connectAttr "RIGRN.phl[28]" "HIKState2SK1.SpineROrder";
connectAttr "RIGRN.phl[29]" "HIKState2SK1.SpinePreR";
connectAttr "RIGRN.phl[30]" "HIKState2SK1.SpineSC";
connectAttr "RIGRN.phl[31]" "Character1.Spine";
connectAttr "RIGRN.phl[32]" "HIKState2SK1.SpinePostR";
connectAttr "RIGRN.phl[33]" "HIKState2SK1.Spine1IS";
connectAttr "HIKState2SK1.Spine1Sx" "RIGRN.phl[34]";
connectAttr "HIKState2SK1.Spine1Sy" "RIGRN.phl[35]";
connectAttr "HIKState2SK1.Spine1Sz" "RIGRN.phl[36]";
connectAttr "RIGRN.phl[37]" "HIKState2SK1.Spine1PGX";
connectAttr "pairBlend21.otx" "RIGRN.phl[38]";
connectAttr "pairBlend21.oty" "RIGRN.phl[39]";
connectAttr "pairBlend21.otz" "RIGRN.phl[40]";
connectAttr "pairBlend21.orx" "RIGRN.phl[41]";
connectAttr "pairBlend21.ory" "RIGRN.phl[42]";
connectAttr "pairBlend21.orz" "RIGRN.phl[43]";
connectAttr "RIGRN.phl[44]" "HIKState2SK1.Spine1ROrder";
connectAttr "RIGRN.phl[45]" "HIKState2SK1.Spine1PreR";
connectAttr "RIGRN.phl[46]" "HIKState2SK1.Spine1SC";
connectAttr "RIGRN.phl[47]" "Character1.Spine1";
connectAttr "RIGRN.phl[48]" "HIKState2SK1.Spine1PostR";
connectAttr "RIGRN.phl[49]" "HIKState2SK1.Spine2IS";
connectAttr "HIKState2SK1.Spine2Sx" "RIGRN.phl[50]";
connectAttr "HIKState2SK1.Spine2Sy" "RIGRN.phl[51]";
connectAttr "HIKState2SK1.Spine2Sz" "RIGRN.phl[52]";
connectAttr "RIGRN.phl[53]" "HIKState2SK1.Spine2PGX";
connectAttr "pairBlend22.otx" "RIGRN.phl[54]";
connectAttr "pairBlend22.oty" "RIGRN.phl[55]";
connectAttr "pairBlend22.otz" "RIGRN.phl[56]";
connectAttr "pairBlend22.orx" "RIGRN.phl[57]";
connectAttr "pairBlend22.ory" "RIGRN.phl[58]";
connectAttr "pairBlend22.orz" "RIGRN.phl[59]";
connectAttr "RIGRN.phl[60]" "HIKState2SK1.Spine2ROrder";
connectAttr "RIGRN.phl[61]" "HIKState2SK1.Spine2PreR";
connectAttr "RIGRN.phl[62]" "HIKState2SK1.Spine2SC";
connectAttr "RIGRN.phl[63]" "Character1.Spine2";
connectAttr "RIGRN.phl[64]" "HIKState2SK1.Spine2PostR";
connectAttr "RIGRN.phl[65]" "HIKState2SK1.Spine3IS";
connectAttr "HIKState2SK1.Spine3Sx" "RIGRN.phl[66]";
connectAttr "HIKState2SK1.Spine3Sy" "RIGRN.phl[67]";
connectAttr "HIKState2SK1.Spine3Sz" "RIGRN.phl[68]";
connectAttr "RIGRN.phl[69]" "HIKState2SK1.Spine3PGX";
connectAttr "pairBlend23.otx" "RIGRN.phl[70]";
connectAttr "pairBlend23.oty" "RIGRN.phl[71]";
connectAttr "pairBlend23.otz" "RIGRN.phl[72]";
connectAttr "pairBlend23.orx" "RIGRN.phl[73]";
connectAttr "pairBlend23.ory" "RIGRN.phl[74]";
connectAttr "pairBlend23.orz" "RIGRN.phl[75]";
connectAttr "RIGRN.phl[76]" "HIKState2SK1.Spine3ROrder";
connectAttr "RIGRN.phl[77]" "HIKState2SK1.Spine3PreR";
connectAttr "RIGRN.phl[78]" "HIKState2SK1.Spine3SC";
connectAttr "RIGRN.phl[79]" "Character1.Spine3";
connectAttr "RIGRN.phl[80]" "HIKState2SK1.Spine3PostR";
connectAttr "RIGRN.phl[81]" "HIKState2SK1.NeckIS";
connectAttr "HIKState2SK1.NeckSx" "RIGRN.phl[82]";
connectAttr "HIKState2SK1.NeckSy" "RIGRN.phl[83]";
connectAttr "HIKState2SK1.NeckSz" "RIGRN.phl[84]";
connectAttr "RIGRN.phl[85]" "HIKState2SK1.NeckPGX";
connectAttr "pairBlend20.otx" "RIGRN.phl[86]";
connectAttr "pairBlend20.oty" "RIGRN.phl[87]";
connectAttr "pairBlend20.otz" "RIGRN.phl[88]";
connectAttr "pairBlend20.orx" "RIGRN.phl[89]";
connectAttr "pairBlend20.ory" "RIGRN.phl[90]";
connectAttr "pairBlend20.orz" "RIGRN.phl[91]";
connectAttr "RIGRN.phl[92]" "HIKState2SK1.NeckROrder";
connectAttr "RIGRN.phl[93]" "HIKState2SK1.NeckPreR";
connectAttr "RIGRN.phl[94]" "HIKState2SK1.NeckSC";
connectAttr "RIGRN.phl[95]" "Character1.Neck";
connectAttr "RIGRN.phl[96]" "HIKState2SK1.NeckPostR";
connectAttr "RIGRN.phl[97]" "HIKState2SK1.HeadIS";
connectAttr "HIKState2SK1.HeadSx" "RIGRN.phl[98]";
connectAttr "HIKState2SK1.HeadSy" "RIGRN.phl[99]";
connectAttr "HIKState2SK1.HeadSz" "RIGRN.phl[100]";
connectAttr "RIGRN.phl[101]" "HIKState2SK1.HeadPGX";
connectAttr "pairBlend15.otx" "RIGRN.phl[102]";
connectAttr "pairBlend15.oty" "RIGRN.phl[103]";
connectAttr "pairBlend15.otz" "RIGRN.phl[104]";
connectAttr "pairBlend15.orx" "RIGRN.phl[105]";
connectAttr "pairBlend15.ory" "RIGRN.phl[106]";
connectAttr "pairBlend15.orz" "RIGRN.phl[107]";
connectAttr "RIGRN.phl[108]" "HIKState2SK1.HeadROrder";
connectAttr "RIGRN.phl[109]" "HIKState2SK1.HeadPreR";
connectAttr "RIGRN.phl[110]" "HIKState2SK1.HeadSC";
connectAttr "RIGRN.phl[111]" "Character1.Head";
connectAttr "RIGRN.phl[112]" "HIKState2SK1.HeadPostR";
connectAttr "RIGRN.phl[113]" "HIKState2SK1.LeftShoulderIS";
connectAttr "HIKState2SK1.LeftShoulderSx" "RIGRN.phl[114]";
connectAttr "HIKState2SK1.LeftShoulderSy" "RIGRN.phl[115]";
connectAttr "HIKState2SK1.LeftShoulderSz" "RIGRN.phl[116]";
connectAttr "RIGRN.phl[117]" "HIKState2SK1.LeftShoulderPGX";
connectAttr "pairBlend18.otx" "RIGRN.phl[118]";
connectAttr "pairBlend18.oty" "RIGRN.phl[119]";
connectAttr "pairBlend18.otz" "RIGRN.phl[120]";
connectAttr "pairBlend18.orx" "RIGRN.phl[121]";
connectAttr "pairBlend18.ory" "RIGRN.phl[122]";
connectAttr "pairBlend18.orz" "RIGRN.phl[123]";
connectAttr "RIGRN.phl[124]" "HIKState2SK1.LeftShoulderROrder";
connectAttr "RIGRN.phl[125]" "HIKState2SK1.LeftShoulderPreR";
connectAttr "RIGRN.phl[126]" "HIKState2SK1.LeftShoulderSC";
connectAttr "RIGRN.phl[127]" "Character1.LeftShoulder";
connectAttr "RIGRN.phl[128]" "HIKState2SK1.LeftShoulderPostR";
connectAttr "RIGRN.phl[129]" "HIKState2SK1.LeftArmIS";
connectAttr "HIKState2SK1.LeftArmSx" "RIGRN.phl[130]";
connectAttr "HIKState2SK1.LeftArmSy" "RIGRN.phl[131]";
connectAttr "HIKState2SK1.LeftArmSz" "RIGRN.phl[132]";
connectAttr "pairBlend9.otx" "RIGRN.phl[133]";
connectAttr "pairBlend9.oty" "RIGRN.phl[134]";
connectAttr "pairBlend9.otz" "RIGRN.phl[135]";
connectAttr "RIGRN.phl[136]" "HIKState2SK1.LeftArmPGX";
connectAttr "pairBlend9.orx" "RIGRN.phl[137]";
connectAttr "pairBlend9.ory" "RIGRN.phl[138]";
connectAttr "pairBlend9.orz" "RIGRN.phl[139]";
connectAttr "RIGRN.phl[140]" "HIKState2SK1.LeftArmROrder";
connectAttr "RIGRN.phl[141]" "HIKState2SK1.LeftArmPreR";
connectAttr "RIGRN.phl[142]" "HIKState2SK1.LeftArmSC";
connectAttr "RIGRN.phl[143]" "Character1.LeftArm";
connectAttr "RIGRN.phl[144]" "HIKState2SK1.LeftArmPostR";
connectAttr "RIGRN.phl[145]" "HIKState2SK1.LeftForeArmIS";
connectAttr "HIKState2SK1.LeftForeArmSx" "RIGRN.phl[146]";
connectAttr "HIKState2SK1.LeftForeArmSy" "RIGRN.phl[147]";
connectAttr "HIKState2SK1.LeftForeArmSz" "RIGRN.phl[148]";
connectAttr "pairBlend10.otx" "RIGRN.phl[149]";
connectAttr "pairBlend10.oty" "RIGRN.phl[150]";
connectAttr "pairBlend10.otz" "RIGRN.phl[151]";
connectAttr "RIGRN.phl[152]" "HIKState2SK1.LeftForeArmPGX";
connectAttr "pairBlend10.orx" "RIGRN.phl[153]";
connectAttr "pairBlend10.ory" "RIGRN.phl[154]";
connectAttr "pairBlend10.orz" "RIGRN.phl[155]";
connectAttr "RIGRN.phl[156]" "HIKState2SK1.LeftForeArmROrder";
connectAttr "RIGRN.phl[157]" "HIKState2SK1.LeftForeArmPreR";
connectAttr "RIGRN.phl[158]" "HIKState2SK1.LeftForeArmSC";
connectAttr "RIGRN.phl[159]" "Character1.LeftForeArm";
connectAttr "RIGRN.phl[160]" "HIKState2SK1.LeftForeArmPostR";
connectAttr "RIGRN.phl[161]" "HIKState2SK1.LeftHandIS";
connectAttr "HIKState2SK1.LeftHandSx" "RIGRN.phl[162]";
connectAttr "HIKState2SK1.LeftHandSy" "RIGRN.phl[163]";
connectAttr "HIKState2SK1.LeftHandSz" "RIGRN.phl[164]";
connectAttr "RIGRN.phl[165]" "HIKState2SK1.LeftHandPGX";
connectAttr "pairBlend11.otx" "RIGRN.phl[166]";
connectAttr "pairBlend11.oty" "RIGRN.phl[167]";
connectAttr "pairBlend11.otz" "RIGRN.phl[168]";
connectAttr "pairBlend11.orx" "RIGRN.phl[169]";
connectAttr "pairBlend11.ory" "RIGRN.phl[170]";
connectAttr "pairBlend11.orz" "RIGRN.phl[171]";
connectAttr "RIGRN.phl[172]" "HIKState2SK1.LeftHandROrder";
connectAttr "RIGRN.phl[173]" "HIKState2SK1.LeftHandPreR";
connectAttr "RIGRN.phl[174]" "HIKState2SK1.LeftHandSC";
connectAttr "RIGRN.phl[175]" "Character1.LeftHand";
connectAttr "RIGRN.phl[176]" "HIKState2SK1.LeftHandPostR";
connectAttr "RIGRN.phl[177]" "HIKState2SK1.RightShoulderIS";
connectAttr "HIKState2SK1.RightShoulderSx" "RIGRN.phl[178]";
connectAttr "HIKState2SK1.RightShoulderSy" "RIGRN.phl[179]";
connectAttr "HIKState2SK1.RightShoulderSz" "RIGRN.phl[180]";
connectAttr "RIGRN.phl[181]" "HIKState2SK1.RightShoulderPGX";
connectAttr "pairBlend19.otx" "RIGRN.phl[182]";
connectAttr "pairBlend19.oty" "RIGRN.phl[183]";
connectAttr "pairBlend19.otz" "RIGRN.phl[184]";
connectAttr "pairBlend19.orx" "RIGRN.phl[185]";
connectAttr "pairBlend19.ory" "RIGRN.phl[186]";
connectAttr "pairBlend19.orz" "RIGRN.phl[187]";
connectAttr "RIGRN.phl[188]" "HIKState2SK1.RightShoulderROrder";
connectAttr "RIGRN.phl[189]" "HIKState2SK1.RightShoulderPreR";
connectAttr "RIGRN.phl[190]" "HIKState2SK1.RightShoulderSC";
connectAttr "RIGRN.phl[191]" "Character1.RightShoulder";
connectAttr "RIGRN.phl[192]" "HIKState2SK1.RightShoulderPostR";
connectAttr "RIGRN.phl[193]" "HIKState2SK1.RightArmIS";
connectAttr "HIKState2SK1.RightArmSx" "RIGRN.phl[194]";
connectAttr "HIKState2SK1.RightArmSy" "RIGRN.phl[195]";
connectAttr "HIKState2SK1.RightArmSz" "RIGRN.phl[196]";
connectAttr "pairBlend12.otx" "RIGRN.phl[197]";
connectAttr "pairBlend12.oty" "RIGRN.phl[198]";
connectAttr "pairBlend12.otz" "RIGRN.phl[199]";
connectAttr "RIGRN.phl[200]" "HIKState2SK1.RightArmPGX";
connectAttr "pairBlend12.orx" "RIGRN.phl[201]";
connectAttr "pairBlend12.ory" "RIGRN.phl[202]";
connectAttr "pairBlend12.orz" "RIGRN.phl[203]";
connectAttr "RIGRN.phl[204]" "HIKState2SK1.RightArmROrder";
connectAttr "RIGRN.phl[205]" "HIKState2SK1.RightArmPreR";
connectAttr "RIGRN.phl[206]" "HIKState2SK1.RightArmSC";
connectAttr "RIGRN.phl[207]" "Character1.RightArm";
connectAttr "RIGRN.phl[208]" "HIKState2SK1.RightArmPostR";
connectAttr "RIGRN.phl[209]" "HIKState2SK1.RightForeArmIS";
connectAttr "HIKState2SK1.RightForeArmSx" "RIGRN.phl[210]";
connectAttr "HIKState2SK1.RightForeArmSy" "RIGRN.phl[211]";
connectAttr "HIKState2SK1.RightForeArmSz" "RIGRN.phl[212]";
connectAttr "pairBlend13.otx" "RIGRN.phl[213]";
connectAttr "pairBlend13.oty" "RIGRN.phl[214]";
connectAttr "pairBlend13.otz" "RIGRN.phl[215]";
connectAttr "RIGRN.phl[216]" "HIKState2SK1.RightForeArmPGX";
connectAttr "pairBlend13.orx" "RIGRN.phl[217]";
connectAttr "pairBlend13.ory" "RIGRN.phl[218]";
connectAttr "pairBlend13.orz" "RIGRN.phl[219]";
connectAttr "RIGRN.phl[220]" "HIKState2SK1.RightForeArmROrder";
connectAttr "RIGRN.phl[221]" "HIKState2SK1.RightForeArmPreR";
connectAttr "RIGRN.phl[222]" "HIKState2SK1.RightForeArmSC";
connectAttr "RIGRN.phl[223]" "Character1.RightForeArm";
connectAttr "RIGRN.phl[224]" "HIKState2SK1.RightForeArmPostR";
connectAttr "RIGRN.phl[225]" "HIKState2SK1.RightHandIS";
connectAttr "HIKState2SK1.RightHandSx" "RIGRN.phl[226]";
connectAttr "HIKState2SK1.RightHandSy" "RIGRN.phl[227]";
connectAttr "HIKState2SK1.RightHandSz" "RIGRN.phl[228]";
connectAttr "RIGRN.phl[229]" "HIKState2SK1.RightHandPGX";
connectAttr "pairBlend14.otx" "RIGRN.phl[230]";
connectAttr "pairBlend14.oty" "RIGRN.phl[231]";
connectAttr "pairBlend14.otz" "RIGRN.phl[232]";
connectAttr "pairBlend14.orx" "RIGRN.phl[233]";
connectAttr "pairBlend14.ory" "RIGRN.phl[234]";
connectAttr "pairBlend14.orz" "RIGRN.phl[235]";
connectAttr "RIGRN.phl[236]" "HIKState2SK1.RightHandROrder";
connectAttr "RIGRN.phl[237]" "HIKState2SK1.RightHandPreR";
connectAttr "RIGRN.phl[238]" "HIKState2SK1.RightHandSC";
connectAttr "RIGRN.phl[239]" "Character1.RightHand";
connectAttr "RIGRN.phl[240]" "HIKState2SK1.RightHandPostR";
connectAttr "RIGRN.phl[241]" "HIKState2SK1.LeftUpLegIS";
connectAttr "HIKState2SK1.LeftUpLegSx" "RIGRN.phl[242]";
connectAttr "HIKState2SK1.LeftUpLegSy" "RIGRN.phl[243]";
connectAttr "HIKState2SK1.LeftUpLegSz" "RIGRN.phl[244]";
connectAttr "pairBlend2.otx" "RIGRN.phl[245]";
connectAttr "pairBlend2.oty" "RIGRN.phl[246]";
connectAttr "pairBlend2.otz" "RIGRN.phl[247]";
connectAttr "RIGRN.phl[248]" "HIKState2SK1.LeftUpLegPGX";
connectAttr "pairBlend2.orx" "RIGRN.phl[249]";
connectAttr "pairBlend2.ory" "RIGRN.phl[250]";
connectAttr "pairBlend2.orz" "RIGRN.phl[251]";
connectAttr "RIGRN.phl[252]" "HIKState2SK1.LeftUpLegROrder";
connectAttr "RIGRN.phl[253]" "HIKState2SK1.LeftUpLegPreR";
connectAttr "RIGRN.phl[254]" "HIKState2SK1.LeftUpLegSC";
connectAttr "RIGRN.phl[255]" "Character1.LeftUpLeg";
connectAttr "RIGRN.phl[256]" "HIKState2SK1.LeftUpLegPostR";
connectAttr "RIGRN.phl[257]" "HIKState2SK1.LeftLegIS";
connectAttr "HIKState2SK1.LeftLegSx" "RIGRN.phl[258]";
connectAttr "HIKState2SK1.LeftLegSy" "RIGRN.phl[259]";
connectAttr "HIKState2SK1.LeftLegSz" "RIGRN.phl[260]";
connectAttr "pairBlend3.otx" "RIGRN.phl[261]";
connectAttr "pairBlend3.oty" "RIGRN.phl[262]";
connectAttr "pairBlend3.otz" "RIGRN.phl[263]";
connectAttr "RIGRN.phl[264]" "HIKState2SK1.LeftLegPGX";
connectAttr "pairBlend3.orx" "RIGRN.phl[265]";
connectAttr "pairBlend3.ory" "RIGRN.phl[266]";
connectAttr "pairBlend3.orz" "RIGRN.phl[267]";
connectAttr "RIGRN.phl[268]" "HIKState2SK1.LeftLegROrder";
connectAttr "RIGRN.phl[269]" "HIKState2SK1.LeftLegPreR";
connectAttr "RIGRN.phl[270]" "HIKState2SK1.LeftLegSC";
connectAttr "RIGRN.phl[271]" "Character1.LeftLeg";
connectAttr "RIGRN.phl[272]" "HIKState2SK1.LeftLegPostR";
connectAttr "RIGRN.phl[273]" "HIKState2SK1.LeftFootIS";
connectAttr "HIKState2SK1.LeftFootSx" "RIGRN.phl[274]";
connectAttr "HIKState2SK1.LeftFootSy" "RIGRN.phl[275]";
connectAttr "HIKState2SK1.LeftFootSz" "RIGRN.phl[276]";
connectAttr "RIGRN.phl[277]" "HIKState2SK1.LeftFootPGX";
connectAttr "pairBlend4.otx" "RIGRN.phl[278]";
connectAttr "pairBlend4.oty" "RIGRN.phl[279]";
connectAttr "pairBlend4.otz" "RIGRN.phl[280]";
connectAttr "pairBlend4.orx" "RIGRN.phl[281]";
connectAttr "pairBlend4.ory" "RIGRN.phl[282]";
connectAttr "pairBlend4.orz" "RIGRN.phl[283]";
connectAttr "RIGRN.phl[284]" "HIKState2SK1.LeftFootROrder";
connectAttr "RIGRN.phl[285]" "HIKState2SK1.LeftFootPreR";
connectAttr "RIGRN.phl[286]" "HIKState2SK1.LeftFootSC";
connectAttr "RIGRN.phl[287]" "Character1.LeftFoot";
connectAttr "RIGRN.phl[288]" "HIKState2SK1.LeftFootPostR";
connectAttr "RIGRN.phl[289]" "HIKState2SK1.LeftToeBaseIS";
connectAttr "HIKState2SK1.LeftToeBaseSx" "RIGRN.phl[290]";
connectAttr "HIKState2SK1.LeftToeBaseSy" "RIGRN.phl[291]";
connectAttr "HIKState2SK1.LeftToeBaseSz" "RIGRN.phl[292]";
connectAttr "RIGRN.phl[293]" "HIKState2SK1.LeftToeBasePGX";
connectAttr "pairBlend16.otx" "RIGRN.phl[294]";
connectAttr "pairBlend16.oty" "RIGRN.phl[295]";
connectAttr "pairBlend16.otz" "RIGRN.phl[296]";
connectAttr "pairBlend16.orx" "RIGRN.phl[297]";
connectAttr "pairBlend16.ory" "RIGRN.phl[298]";
connectAttr "pairBlend16.orz" "RIGRN.phl[299]";
connectAttr "RIGRN.phl[300]" "HIKState2SK1.LeftToeBaseROrder";
connectAttr "RIGRN.phl[301]" "HIKState2SK1.LeftToeBasePreR";
connectAttr "RIGRN.phl[302]" "HIKState2SK1.LeftToeBaseSC";
connectAttr "RIGRN.phl[303]" "Character1.LeftToeBase";
connectAttr "RIGRN.phl[304]" "HIKState2SK1.LeftToeBasePostR";
connectAttr "RIGRN.phl[305]" "HIKState2SK1.RightUpLegIS";
connectAttr "HIKState2SK1.RightUpLegSx" "RIGRN.phl[306]";
connectAttr "HIKState2SK1.RightUpLegSy" "RIGRN.phl[307]";
connectAttr "HIKState2SK1.RightUpLegSz" "RIGRN.phl[308]";
connectAttr "pairBlend5.otx" "RIGRN.phl[309]";
connectAttr "pairBlend5.oty" "RIGRN.phl[310]";
connectAttr "pairBlend5.otz" "RIGRN.phl[311]";
connectAttr "RIGRN.phl[312]" "HIKState2SK1.RightUpLegPGX";
connectAttr "pairBlend5.orx" "RIGRN.phl[313]";
connectAttr "pairBlend5.ory" "RIGRN.phl[314]";
connectAttr "pairBlend5.orz" "RIGRN.phl[315]";
connectAttr "RIGRN.phl[316]" "HIKState2SK1.RightUpLegROrder";
connectAttr "RIGRN.phl[317]" "HIKState2SK1.RightUpLegPreR";
connectAttr "RIGRN.phl[318]" "HIKState2SK1.RightUpLegSC";
connectAttr "RIGRN.phl[319]" "Character1.RightUpLeg";
connectAttr "RIGRN.phl[320]" "HIKState2SK1.RightUpLegPostR";
connectAttr "RIGRN.phl[321]" "HIKState2SK1.RightLegIS";
connectAttr "HIKState2SK1.RightLegSx" "RIGRN.phl[322]";
connectAttr "HIKState2SK1.RightLegSy" "RIGRN.phl[323]";
connectAttr "HIKState2SK1.RightLegSz" "RIGRN.phl[324]";
connectAttr "pairBlend6.otx" "RIGRN.phl[325]";
connectAttr "pairBlend6.oty" "RIGRN.phl[326]";
connectAttr "pairBlend6.otz" "RIGRN.phl[327]";
connectAttr "RIGRN.phl[328]" "HIKState2SK1.RightLegPGX";
connectAttr "pairBlend6.orx" "RIGRN.phl[329]";
connectAttr "pairBlend6.ory" "RIGRN.phl[330]";
connectAttr "pairBlend6.orz" "RIGRN.phl[331]";
connectAttr "RIGRN.phl[332]" "HIKState2SK1.RightLegROrder";
connectAttr "RIGRN.phl[333]" "HIKState2SK1.RightLegPreR";
connectAttr "RIGRN.phl[334]" "HIKState2SK1.RightLegSC";
connectAttr "RIGRN.phl[335]" "Character1.RightLeg";
connectAttr "RIGRN.phl[336]" "HIKState2SK1.RightLegPostR";
connectAttr "RIGRN.phl[337]" "HIKState2SK1.RightFootIS";
connectAttr "HIKState2SK1.RightFootSx" "RIGRN.phl[338]";
connectAttr "HIKState2SK1.RightFootSy" "RIGRN.phl[339]";
connectAttr "HIKState2SK1.RightFootSz" "RIGRN.phl[340]";
connectAttr "RIGRN.phl[341]" "HIKState2SK1.RightFootPGX";
connectAttr "pairBlend7.otx" "RIGRN.phl[342]";
connectAttr "pairBlend7.oty" "RIGRN.phl[343]";
connectAttr "pairBlend7.otz" "RIGRN.phl[344]";
connectAttr "pairBlend7.orx" "RIGRN.phl[345]";
connectAttr "pairBlend7.ory" "RIGRN.phl[346]";
connectAttr "pairBlend7.orz" "RIGRN.phl[347]";
connectAttr "RIGRN.phl[348]" "HIKState2SK1.RightFootROrder";
connectAttr "RIGRN.phl[349]" "HIKState2SK1.RightFootPreR";
connectAttr "RIGRN.phl[350]" "HIKState2SK1.RightFootSC";
connectAttr "RIGRN.phl[351]" "Character1.RightFoot";
connectAttr "RIGRN.phl[352]" "HIKState2SK1.RightFootPostR";
connectAttr "RIGRN.phl[353]" "HIKState2SK1.RightToeBaseIS";
connectAttr "HIKState2SK1.RightToeBaseSx" "RIGRN.phl[354]";
connectAttr "HIKState2SK1.RightToeBaseSy" "RIGRN.phl[355]";
connectAttr "HIKState2SK1.RightToeBaseSz" "RIGRN.phl[356]";
connectAttr "RIGRN.phl[357]" "HIKState2SK1.RightToeBasePGX";
connectAttr "pairBlend17.otx" "RIGRN.phl[358]";
connectAttr "pairBlend17.oty" "RIGRN.phl[359]";
connectAttr "pairBlend17.otz" "RIGRN.phl[360]";
connectAttr "pairBlend17.orx" "RIGRN.phl[361]";
connectAttr "pairBlend17.ory" "RIGRN.phl[362]";
connectAttr "pairBlend17.orz" "RIGRN.phl[363]";
connectAttr "RIGRN.phl[364]" "HIKState2SK1.RightToeBaseROrder";
connectAttr "RIGRN.phl[365]" "HIKState2SK1.RightToeBasePreR";
connectAttr "RIGRN.phl[366]" "HIKState2SK1.RightToeBaseSC";
connectAttr "RIGRN.phl[367]" "Character1.RightToeBase";
connectAttr "RIGRN.phl[368]" "HIKState2SK1.RightToeBasePostR";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_HipsEffector.uagx";
connectAttr "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_HipsEffector.rz"
		;
connectAttr "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_HipsEffector.ry"
		;
connectAttr "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_HipsEffector.rx"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_HipsEffector.tz"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_HipsEffector.ty"
		;
connectAttr "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_HipsEffector.tx"
		;
connectAttr "HIKState2Effector1.HipsEffectorGXM[0]" "Character1_Ctrl_HipsEffector.agx"
		;
connectAttr "HIKState2Effector2.HipsEffectorGXM[0]" "Character1_Ctrl_HipsEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftAnkleEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftAnkleEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftAnkleEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftAnkleEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftAnkleEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftAnkleEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftAnkleEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftAnkleEffectorGXM[0]" "Character1_Ctrl_LeftAnkleEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftAnkleEffectorGXM[0]" "Character1_Ctrl_LeftAnkleEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightAnkleEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightAnkleEffector.rz"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightAnkleEffector.ry"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightAnkleEffector.rx"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightAnkleEffector.tz"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightAnkleEffector.ty"
		;
connectAttr "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightAnkleEffector.tx"
		;
connectAttr "HIKState2Effector1.RightAnkleEffectorGXM[0]" "Character1_Ctrl_RightAnkleEffector.agx"
		;
connectAttr "HIKState2Effector2.RightAnkleEffectorGXM[0]" "Character1_Ctrl_RightAnkleEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftWristEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftWristEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftWristEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftWristEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftWristEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftWristEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftWristEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftWristEffectorGXM[0]" "Character1_Ctrl_LeftWristEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftWristEffectorGXM[0]" "Character1_Ctrl_LeftWristEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightWristEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightWristEffector.rz"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightWristEffector.ry"
		;
connectAttr "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightWristEffector.rx"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightWristEffector.tz"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightWristEffector.ty"
		;
connectAttr "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightWristEffector.tx"
		;
connectAttr "HIKState2Effector1.RightWristEffectorGXM[0]" "Character1_Ctrl_RightWristEffector.agx"
		;
connectAttr "HIKState2Effector2.RightWristEffectorGXM[0]" "Character1_Ctrl_RightWristEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftKneeEffector.uagx";
connectAttr "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftKneeEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftKneeEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftKneeEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftKneeEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftKneeEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftKneeEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftKneeEffectorGXM[0]" "Character1_Ctrl_LeftKneeEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftKneeEffectorGXM[0]" "Character1_Ctrl_LeftKneeEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightKneeEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightKneeEffector.rz"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightKneeEffector.ry"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightKneeEffector.rx"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightKneeEffector.tz"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightKneeEffector.ty"
		;
connectAttr "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightKneeEffector.tx"
		;
connectAttr "HIKState2Effector1.RightKneeEffectorGXM[0]" "Character1_Ctrl_RightKneeEffector.agx"
		;
connectAttr "HIKState2Effector2.RightKneeEffectorGXM[0]" "Character1_Ctrl_RightKneeEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftElbowEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftElbowEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftElbowEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftElbowEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftElbowEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftElbowEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftElbowEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftElbowEffectorGXM[0]" "Character1_Ctrl_LeftElbowEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftElbowEffectorGXM[0]" "Character1_Ctrl_LeftElbowEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightElbowEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightElbowEffector.rz"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightElbowEffector.ry"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightElbowEffector.rx"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightElbowEffector.tz"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightElbowEffector.ty"
		;
connectAttr "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightElbowEffector.tx"
		;
connectAttr "HIKState2Effector1.RightElbowEffectorGXM[0]" "Character1_Ctrl_RightElbowEffector.agx"
		;
connectAttr "HIKState2Effector2.RightElbowEffectorGXM[0]" "Character1_Ctrl_RightElbowEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_ChestOriginEffector.uagx"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_ChestOriginEffector.rz"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_ChestOriginEffector.ry"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_ChestOriginEffector.rx"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_ChestOriginEffector.tz"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_ChestOriginEffector.ty"
		;
connectAttr "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_ChestOriginEffector.tx"
		;
connectAttr "HIKState2Effector1.ChestOriginEffectorGXM[0]" "Character1_Ctrl_ChestOriginEffector.agx"
		;
connectAttr "HIKState2Effector2.ChestOriginEffectorGXM[0]" "Character1_Ctrl_ChestOriginEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_ChestEndEffector.uagx";
connectAttr "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_ChestEndEffector.rz"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_ChestEndEffector.ry"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_ChestEndEffector.rx"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_ChestEndEffector.tz"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_ChestEndEffector.ty"
		;
connectAttr "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_ChestEndEffector.tx"
		;
connectAttr "HIKState2Effector1.ChestEndEffectorGXM[0]" "Character1_Ctrl_ChestEndEffector.agx"
		;
connectAttr "HIKState2Effector2.ChestEndEffectorGXM[0]" "Character1_Ctrl_ChestEndEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftFootEffector.uagx";
connectAttr "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftFootEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftFootEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftFootEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftFootEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftFootEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftFootEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftFootEffectorGXM[0]" "Character1_Ctrl_LeftFootEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftFootEffectorGXM[0]" "Character1_Ctrl_LeftFootEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightFootEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightFootEffector.rz"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightFootEffector.ry"
		;
connectAttr "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightFootEffector.rx"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightFootEffector.tz"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightFootEffector.ty"
		;
connectAttr "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightFootEffector.tx"
		;
connectAttr "HIKState2Effector1.RightFootEffectorGXM[0]" "Character1_Ctrl_RightFootEffector.agx"
		;
connectAttr "HIKState2Effector2.RightFootEffectorGXM[0]" "Character1_Ctrl_RightFootEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftShoulderEffector.uagx"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftShoulderEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftShoulderEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftShoulderEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftShoulderEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftShoulderEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftShoulderEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftShoulderEffectorGXM[0]" "Character1_Ctrl_LeftShoulderEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftShoulderEffectorGXM[0]" "Character1_Ctrl_LeftShoulderEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightShoulderEffector.uagx"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightShoulderEffector.rz"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightShoulderEffector.ry"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightShoulderEffector.rx"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightShoulderEffector.tz"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightShoulderEffector.ty"
		;
connectAttr "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightShoulderEffector.tx"
		;
connectAttr "HIKState2Effector1.RightShoulderEffectorGXM[0]" "Character1_Ctrl_RightShoulderEffector.agx"
		;
connectAttr "HIKState2Effector2.RightShoulderEffectorGXM[0]" "Character1_Ctrl_RightShoulderEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_HeadEffector.uagx";
connectAttr "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_HeadEffector.rz"
		;
connectAttr "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_HeadEffector.ry"
		;
connectAttr "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_HeadEffector.rx"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_HeadEffector.tz"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_HeadEffector.ty"
		;
connectAttr "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_HeadEffector.tx"
		;
connectAttr "HIKState2Effector1.HeadEffectorGXM[0]" "Character1_Ctrl_HeadEffector.agx"
		;
connectAttr "HIKState2Effector2.HeadEffectorGXM[0]" "Character1_Ctrl_HeadEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftHipEffector.uagx";
connectAttr "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftHipEffector.rz"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftHipEffector.ry"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftHipEffector.rx"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_LeftHipEffector.tz"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_LeftHipEffector.ty"
		;
connectAttr "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_LeftHipEffector.tx"
		;
connectAttr "HIKState2Effector1.LeftHipEffectorGXM[0]" "Character1_Ctrl_LeftHipEffector.agx"
		;
connectAttr "HIKState2Effector2.LeftHipEffectorGXM[0]" "Character1_Ctrl_LeftHipEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightHipEffector.uagx";
connectAttr "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightHipEffector.rz"
		;
connectAttr "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightHipEffector.ry"
		;
connectAttr "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightHipEffector.rx"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA.o" "Character1_Ctrl_RightHipEffector.tz"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA.o" "Character1_Ctrl_RightHipEffector.ty"
		;
connectAttr "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA.o" "Character1_Ctrl_RightHipEffector.tx"
		;
connectAttr "HIKState2Effector1.RightHipEffectorGXM[0]" "Character1_Ctrl_RightHipEffector.agx"
		;
connectAttr "HIKState2Effector2.RightHipEffectorGXM[0]" "Character1_Ctrl_RightHipEffector.atx"
		;
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Hips.uagx";
connectAttr "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Hips.rz"
		;
connectAttr "Character1_Ctrl_Hips_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Hips.ry"
		;
connectAttr "Character1_Ctrl_Hips_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Hips.rx"
		;
connectAttr "Character1_Ctrl_Hips_translateZ_tempLayer_inputA.o" "Character1_Ctrl_Hips.tz"
		;
connectAttr "Character1_Ctrl_Hips_translateY_tempLayer_inputA.o" "Character1_Ctrl_Hips.ty"
		;
connectAttr "Character1_Ctrl_Hips_translateX_tempLayer_inputA.o" "Character1_Ctrl_Hips.tx"
		;
connectAttr "HIKState2FK1.HipsGX" "Character1_Ctrl_Hips.agx";
connectAttr "HIKState2FK2.HipsGX" "Character1_Ctrl_Hips.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftUpLeg.uagx";
connectAttr "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftUpLeg.rz"
		;
connectAttr "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftUpLeg.ry"
		;
connectAttr "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftUpLeg.rx"
		;
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_LeftUpLeg.is";
connectAttr "HIKState2FK1.LeftUpLegGX" "Character1_Ctrl_LeftUpLeg.agx";
connectAttr "HIKState2FK2.LeftUpLegGX" "Character1_Ctrl_LeftUpLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftLeg.uagx";
connectAttr "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftLeg.rz"
		;
connectAttr "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftLeg.ry"
		;
connectAttr "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftLeg.rx"
		;
connectAttr "Character1_Ctrl_LeftUpLeg.s" "Character1_Ctrl_LeftLeg.is";
connectAttr "HIKState2FK1.LeftLegGX" "Character1_Ctrl_LeftLeg.agx";
connectAttr "HIKState2FK2.LeftLegGX" "Character1_Ctrl_LeftLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftFoot.uagx";
connectAttr "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftFoot.rz"
		;
connectAttr "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftFoot.ry"
		;
connectAttr "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftFoot.rx"
		;
connectAttr "Character1_Ctrl_LeftLeg.s" "Character1_Ctrl_LeftFoot.is";
connectAttr "HIKState2FK1.LeftFootGX" "Character1_Ctrl_LeftFoot.agx";
connectAttr "HIKState2FK2.LeftFootGX" "Character1_Ctrl_LeftFoot.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftToeBase.uagx";
connectAttr "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftToeBase.rz"
		;
connectAttr "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftToeBase.ry"
		;
connectAttr "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftToeBase.rx"
		;
connectAttr "Character1_Ctrl_LeftFoot.s" "Character1_Ctrl_LeftToeBase.is";
connectAttr "HIKState2FK1.LeftToeBaseGX" "Character1_Ctrl_LeftToeBase.agx";
connectAttr "HIKState2FK2.LeftToeBaseGX" "Character1_Ctrl_LeftToeBase.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightUpLeg.uagx";
connectAttr "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightUpLeg.rz"
		;
connectAttr "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightUpLeg.ry"
		;
connectAttr "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightUpLeg.rx"
		;
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_RightUpLeg.is";
connectAttr "HIKState2FK1.RightUpLegGX" "Character1_Ctrl_RightUpLeg.agx";
connectAttr "HIKState2FK2.RightUpLegGX" "Character1_Ctrl_RightUpLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightLeg.uagx";
connectAttr "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightLeg.rz"
		;
connectAttr "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightLeg.ry"
		;
connectAttr "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightLeg.rx"
		;
connectAttr "Character1_Ctrl_RightUpLeg.s" "Character1_Ctrl_RightLeg.is";
connectAttr "HIKState2FK1.RightLegGX" "Character1_Ctrl_RightLeg.agx";
connectAttr "HIKState2FK2.RightLegGX" "Character1_Ctrl_RightLeg.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightFoot.uagx";
connectAttr "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightFoot.rz"
		;
connectAttr "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightFoot.ry"
		;
connectAttr "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightFoot.rx"
		;
connectAttr "Character1_Ctrl_RightLeg.s" "Character1_Ctrl_RightFoot.is";
connectAttr "HIKState2FK1.RightFootGX" "Character1_Ctrl_RightFoot.agx";
connectAttr "HIKState2FK2.RightFootGX" "Character1_Ctrl_RightFoot.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightToeBase.uagx";
connectAttr "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightToeBase.rz"
		;
connectAttr "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightToeBase.ry"
		;
connectAttr "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightToeBase.rx"
		;
connectAttr "Character1_Ctrl_RightFoot.s" "Character1_Ctrl_RightToeBase.is";
connectAttr "HIKState2FK1.RightToeBaseGX" "Character1_Ctrl_RightToeBase.agx";
connectAttr "HIKState2FK2.RightToeBaseGX" "Character1_Ctrl_RightToeBase.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine.uagx";
connectAttr "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Spine.rz"
		;
connectAttr "Character1_Ctrl_Spine_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Spine.ry"
		;
connectAttr "Character1_Ctrl_Spine_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Spine.rx"
		;
connectAttr "Character1_Ctrl_Hips.s" "Character1_Ctrl_Spine.is";
connectAttr "HIKState2FK1.SpineGX" "Character1_Ctrl_Spine.agx";
connectAttr "HIKState2FK2.SpineGX" "Character1_Ctrl_Spine.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine1.uagx";
connectAttr "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Spine1.rz"
		;
connectAttr "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Spine1.ry"
		;
connectAttr "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Spine1.rx"
		;
connectAttr "Character1_Ctrl_Spine.s" "Character1_Ctrl_Spine1.is";
connectAttr "HIKState2FK1.Spine1GX" "Character1_Ctrl_Spine1.agx";
connectAttr "HIKState2FK2.Spine1GX" "Character1_Ctrl_Spine1.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine2.uagx";
connectAttr "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Spine2.rz"
		;
connectAttr "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Spine2.ry"
		;
connectAttr "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Spine2.rx"
		;
connectAttr "Character1_Ctrl_Spine1.s" "Character1_Ctrl_Spine2.is";
connectAttr "HIKState2FK1.Spine2GX" "Character1_Ctrl_Spine2.agx";
connectAttr "HIKState2FK2.Spine2GX" "Character1_Ctrl_Spine2.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Spine3.uagx";
connectAttr "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Spine3.rz"
		;
connectAttr "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Spine3.ry"
		;
connectAttr "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Spine3.rx"
		;
connectAttr "Character1_Ctrl_Spine2.s" "Character1_Ctrl_Spine3.is";
connectAttr "HIKState2FK1.Spine3GX" "Character1_Ctrl_Spine3.agx";
connectAttr "HIKState2FK2.Spine3GX" "Character1_Ctrl_Spine3.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftShoulder.uagx";
connectAttr "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftShoulder.rz"
		;
connectAttr "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftShoulder.ry"
		;
connectAttr "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftShoulder.rx"
		;
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_LeftShoulder.is";
connectAttr "HIKState2FK1.LeftShoulderGX" "Character1_Ctrl_LeftShoulder.agx";
connectAttr "HIKState2FK2.LeftShoulderGX" "Character1_Ctrl_LeftShoulder.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftArm.uagx";
connectAttr "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftArm.rz"
		;
connectAttr "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftArm.ry"
		;
connectAttr "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftArm.rx"
		;
connectAttr "Character1_Ctrl_LeftShoulder.s" "Character1_Ctrl_LeftArm.is";
connectAttr "HIKState2FK1.LeftArmGX" "Character1_Ctrl_LeftArm.agx";
connectAttr "HIKState2FK2.LeftArmGX" "Character1_Ctrl_LeftArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftForeArm.uagx";
connectAttr "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftForeArm.rz"
		;
connectAttr "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftForeArm.ry"
		;
connectAttr "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftForeArm.rx"
		;
connectAttr "Character1_Ctrl_LeftArm.s" "Character1_Ctrl_LeftForeArm.is";
connectAttr "HIKState2FK1.LeftForeArmGX" "Character1_Ctrl_LeftForeArm.agx";
connectAttr "HIKState2FK2.LeftForeArmGX" "Character1_Ctrl_LeftForeArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_LeftHand.uagx";
connectAttr "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_LeftHand.rz"
		;
connectAttr "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY.o" "Character1_Ctrl_LeftHand.ry"
		;
connectAttr "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX.o" "Character1_Ctrl_LeftHand.rx"
		;
connectAttr "Character1_Ctrl_LeftForeArm.s" "Character1_Ctrl_LeftHand.is";
connectAttr "HIKState2FK1.LeftHandGX" "Character1_Ctrl_LeftHand.agx";
connectAttr "HIKState2FK2.LeftHandGX" "Character1_Ctrl_LeftHand.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightShoulder.uagx";
connectAttr "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightShoulder.rz"
		;
connectAttr "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightShoulder.ry"
		;
connectAttr "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightShoulder.rx"
		;
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_RightShoulder.is";
connectAttr "HIKState2FK1.RightShoulderGX" "Character1_Ctrl_RightShoulder.agx";
connectAttr "HIKState2FK2.RightShoulderGX" "Character1_Ctrl_RightShoulder.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightArm.uagx";
connectAttr "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightArm.rz"
		;
connectAttr "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightArm.ry"
		;
connectAttr "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightArm.rx"
		;
connectAttr "Character1_Ctrl_RightShoulder.s" "Character1_Ctrl_RightArm.is";
connectAttr "HIKState2FK1.RightArmGX" "Character1_Ctrl_RightArm.agx";
connectAttr "HIKState2FK2.RightArmGX" "Character1_Ctrl_RightArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightForeArm.uagx";
connectAttr "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightForeArm.rz"
		;
connectAttr "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightForeArm.ry"
		;
connectAttr "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightForeArm.rx"
		;
connectAttr "Character1_Ctrl_RightArm.s" "Character1_Ctrl_RightForeArm.is";
connectAttr "HIKState2FK1.RightForeArmGX" "Character1_Ctrl_RightForeArm.agx";
connectAttr "HIKState2FK2.RightForeArmGX" "Character1_Ctrl_RightForeArm.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_RightHand.uagx";
connectAttr "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_RightHand.rz"
		;
connectAttr "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY.o" "Character1_Ctrl_RightHand.ry"
		;
connectAttr "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX.o" "Character1_Ctrl_RightHand.rx"
		;
connectAttr "Character1_Ctrl_RightForeArm.s" "Character1_Ctrl_RightHand.is";
connectAttr "HIKState2FK1.RightHandGX" "Character1_Ctrl_RightHand.agx";
connectAttr "HIKState2FK2.RightHandGX" "Character1_Ctrl_RightHand.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Neck.uagx";
connectAttr "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Neck.rz"
		;
connectAttr "Character1_Ctrl_Neck_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Neck.ry"
		;
connectAttr "Character1_Ctrl_Neck_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Neck.rx"
		;
connectAttr "Character1_Ctrl_Spine3.s" "Character1_Ctrl_Neck.is";
connectAttr "HIKState2FK1.NeckGX" "Character1_Ctrl_Neck.agx";
connectAttr "HIKState2FK2.NeckGX" "Character1_Ctrl_Neck.atx";
connectAttr "Character1_ControlRig.rao" "Character1_Ctrl_Head.uagx";
connectAttr "Character1_Ctrl_Head_rotate_tempLayer_inputAZ.o" "Character1_Ctrl_Head.rz"
		;
connectAttr "Character1_Ctrl_Head_rotate_tempLayer_inputAY.o" "Character1_Ctrl_Head.ry"
		;
connectAttr "Character1_Ctrl_Head_rotate_tempLayer_inputAX.o" "Character1_Ctrl_Head.rx"
		;
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
// End of overboss_death.ma
