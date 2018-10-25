//Maya ASCII 2016 scene
//Name: overboss_attack.ma
//Last modified: Wed, May 27, 2015 09:54:26 AM
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
	setAttr ".t" -type "double3" -96.371456403192383 162.95292850871769 490.02390260264633 ;
	setAttr ".r" -type "double3" -13.538352729623723 -7.799999999999871 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 514.76025291912583;
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
	rename -uid "8A970123-41F4-C2F3-F255-2692566BFACF";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v" no;
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "BA3CE7EB-465B-E4F3-3EA9-78BE8BD442A9";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "4A9BA794-400E-80B0-A25F-839051138B69";
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
	rename -uid "46676B3C-4EE6-DBCA-7929-619559143B21";
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
	rename -uid "A0783892-4B20-F2E5-3307-1EBDD84198FF";
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
	rename -uid "36195602-416F-405D-13DB-48AA867E3B50";
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
	rename -uid "58FC711A-4CA0-FF83-36A5-F0BDDE7CDC69";
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
	rename -uid "26C7164D-4C12-F747-0192-DDA95C5CAFEA";
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
	rename -uid "BFA58236-45C9-B827-3B6C-328BA8F34F59";
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
	rename -uid "2B80799A-46E1-5E4C-155A-6B9DF5ED39F4";
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
	rename -uid "247D23BD-4794-BE49-DB68-2B9E0A79A084";
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
	rename -uid "A9970793-46EF-E43B-AF27-3DB415A43A95";
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
	rename -uid "5135AB9E-448B-D7F2-4ECB-A3BCEBE79E13";
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
	rename -uid "288FDE7C-4CE2-EDB7-6EB3-ED820D91F9F3";
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
	rename -uid "04F282C1-47A2-6845-FC96-AA9A11FBBC13";
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
	rename -uid "A7F7BB5B-4447-6C93-261E-0A96018FDD85";
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
	rename -uid "0D6AD5BE-4FA6-2EDF-FA0E-80A28FA435EE";
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
	rename -uid "86E54AB6-4DC2-6ECA-9729-9DBE0BE03815";
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
	rename -uid "4AB61CCA-4583-CEB4-3D14-E8ACA6382C0D";
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
	rename -uid "A6AB7CB9-4675-1F35-E9D3-7EB3BE84162B";
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
	rename -uid "F9420EF5-4B7A-D4B2-21B6-63B10B750737";
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
	rename -uid "8D80A128-4EF7-A395-AD19-0CB7160E4DF7";
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
	rename -uid "FC823134-4D0E-FD95-5CD1-B88A06606E54";
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
	rename -uid "748A0844-4387-B631-BFFA-4687F2787FE9";
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
	rename -uid "53F597CC-4071-479E-9176-C196E833B503";
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
	rename -uid "D24E8FBD-44D5-F1A9-BA33-B5A0DBEF1D82";
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
	rename -uid "9F29665A-4363-7BD7-88FE-1D90B9F29DDF";
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
	rename -uid "0900D177-471F-C016-E80E-55B865044A58";
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
	rename -uid "E6DB6B84-4E02-F7B2-B6E6-CD8CED70FA4B";
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
	rename -uid "01F1280A-4B96-568D-BAD9-18BA9FCE231F";
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
	rename -uid "F2560349-4E1C-919E-4BB8-70A730F4C50C";
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
	rename -uid "2A0D9A6D-45BA-AAFF-A25E-4C833EE8B87E";
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
	rename -uid "DFD4AB12-466C-FC1E-C812-FA9525ACBED6";
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
	rename -uid "E4E111EE-44A9-210C-E1A1-968EB7741A4D";
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
	rename -uid "FD3425A3-4666-369E-6DC3-30BE25A55F83";
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
	rename -uid "B9D2A66F-4CE0-31A1-EA6A-B7841BC8FDD7";
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
	rename -uid "03A9EA09-4438-9F5E-DF53-A7A294C97134";
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
	rename -uid "7416AB4D-48D3-FE23-B6EA-A69D7F2286C6";
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
	rename -uid "74FF37D6-45B8-68D1-1D43-988142AB24C6";
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
	rename -uid "1CF0C60C-4CE0-B5BC-3877-3D80855ACC53";
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
	rename -uid "8DF1F6ED-417E-93F1-CDB5-5B810029F3C4";
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
	rename -uid "24DAA3E5-4CE9-0907-5137-38AEADE49412";
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
	rename -uid "380FE13D-4905-64FE-9571-23963024D01D";
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
	rename -uid "0D94B717-4D4A-1AA1-70E4-A7BAF018A241";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "7A733E2C-4953-44FF-A518-14BB82AD08BD";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "37099C76-43A0-C5AD-4574-DD9C7479DD9A";
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
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 30 -ast 0 -aet 200 ";
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
	setAttr ".HipsTx" -2.2736303806304932;
	setAttr ".HipsTy" 42.35760498046875;
	setAttr ".HipsTz" -2.1603424549102783;
	setAttr ".HipsRx" 8.2383805329159063;
	setAttr ".HipsRy" 22.900962544268967;
	setAttr ".HipsRz" 20.408574617727659;
	setAttr ".HipsSx" 1.0000001995162418;
	setAttr ".HipsSy" 1.0000001590382648;
	setAttr ".HipsSz" 1.0000002288248833;
	setAttr ".LeftUpLegTx" 24.896372204848255;
	setAttr ".LeftUpLegTy" -7.7306282407177065;
	setAttr ".LeftUpLegTz" 3.1970274025978092;
	setAttr ".LeftUpLegRx" 14.334097238623897;
	setAttr ".LeftUpLegRy" 22.830920164223649;
	setAttr ".LeftUpLegRz" -14.297715760032476;
	setAttr ".LeftUpLegSx" 1.0000000490843493;
	setAttr ".LeftUpLegSy" 1.0000000338987529;
	setAttr ".LeftUpLegSz" 1.0000000798768398;
	setAttr ".LeftLegTx" 21.226197418159675;
	setAttr ".LeftLegTy" 2.0884331988213489e-006;
	setAttr ".LeftLegTz" -6.7992640850889074e-007;
	setAttr ".LeftLegRx" 3.0444052782429116;
	setAttr ".LeftLegRy" 0.91228168773044072;
	setAttr ".LeftLegRz" -62.835690795900405;
	setAttr ".LeftLegSx" 1.0000000366007951;
	setAttr ".LeftLegSy" 1.0000000216088547;
	setAttr ".LeftLegSz" 1.0000000977824937;
	setAttr ".LeftFootTx" 15.941048607105488;
	setAttr ".LeftFootTy" 9.6852286191051462e-008;
	setAttr ".LeftFootTz" -4.228736351308271e-006;
	setAttr ".LeftFootRx" -15.459906131782153;
	setAttr ".LeftFootRy" -15.719534094349896;
	setAttr ".LeftFootRz" -38.09413312560114;
	setAttr ".LeftFootSx" 1.0000000378464107;
	setAttr ".LeftFootSy" 0.99999998255929545;
	setAttr ".LeftFootSz" 0.9999999906191962;
	setAttr ".RightUpLegTx" -24.896305996552563;
	setAttr ".RightUpLegTy" -7.7306076256656127;
	setAttr ".RightUpLegTz" 3.197033712279985;
	setAttr ".RightUpLegRx" -39.7891557125498;
	setAttr ".RightUpLegRy" -16.760571603535592;
	setAttr ".RightUpLegRz" 68.365806222877907;
	setAttr ".RightUpLegSx" 1.0000001009625752;
	setAttr ".RightUpLegSy" 1.0000000535072957;
	setAttr ".RightUpLegSz" 1.000000158729184;
	setAttr ".RightLegTx" -21.226182595153965;
	setAttr ".RightLegTy" 5.687010645516466e-006;
	setAttr ".RightLegTz" -8.0533918115577308e-005;
	setAttr ".RightLegRx" 14.256716361395476;
	setAttr ".RightLegRy" 2.6776602374924208;
	setAttr ".RightLegRz" -17.692101959564731;
	setAttr ".RightLegSx" 0.99999996723325724;
	setAttr ".RightLegSy" 0.99999999164114883;
	setAttr ".RightLegSz" 1.0000000653209695;
	setAttr ".RightFootTx" -15.94110354381962;
	setAttr ".RightFootTy" 4.048575848969449e-005;
	setAttr ".RightFootTz" 5.1242405316287432e-005;
	setAttr ".RightFootRx" -27.024779120031035;
	setAttr ".RightFootRy" -6.453164215772774;
	setAttr ".RightFootRz" 12.842595093055584;
	setAttr ".RightFootSx" 1.0000000633554458;
	setAttr ".RightFootSy" 1.0000001458519401;
	setAttr ".RightFootSz" 1.0000000741392372;
	setAttr ".SpineTx" -3.5602038828130844e-007;
	setAttr ".SpineTy" 3.3825354105569474;
	setAttr ".SpineTz" -3.7835472671381809;
	setAttr ".SpineRx" 6.2906051669293026;
	setAttr ".SpineRy" -3.2282851925702207;
	setAttr ".SpineRz" -1.4924103486507649;
	setAttr ".SpineSx" 1.000000009526772;
	setAttr ".SpineSy" 1.0000000436310956;
	setAttr ".SpineSz" 0.99999997169927246;
	setAttr ".LeftArmTx" 7.5598042444181743;
	setAttr ".LeftArmTy" -1.3346427550739151;
	setAttr ".LeftArmTz" 6.4182841537126905;
	setAttr ".LeftArmRx" 4.4458653527715066;
	setAttr ".LeftArmRy" -16.462830538874154;
	setAttr ".LeftArmRz" -13.726289398398238;
	setAttr ".LeftArmSx" 0.9999999218830018;
	setAttr ".LeftArmSy" 0.99999984102357209;
	setAttr ".LeftArmSz" 0.99999984430456768;
	setAttr ".LeftForeArmTx" 23.627842252379835;
	setAttr ".LeftForeArmTy" -0.36613975327347781;
	setAttr ".LeftForeArmTz" 0.61648630071324817;
	setAttr ".LeftForeArmRx" -6.382643826760793;
	setAttr ".LeftForeArmRy" -9.8304163276563354;
	setAttr ".LeftForeArmRz" 30.743285360415509;
	setAttr ".LeftForeArmSx" 0.99999992838373453;
	setAttr ".LeftForeArmSy" 0.99999999843860532;
	setAttr ".LeftForeArmSz" 1.0000000047522677;
	setAttr ".LeftHandTx" 22.329475333882826;
	setAttr ".LeftHandTy" -0.34351814013007953;
	setAttr ".LeftHandTz" 0.83665486454972893;
	setAttr ".LeftHandRx" -44.367824662213266;
	setAttr ".LeftHandRy" 23.68572188278505;
	setAttr ".LeftHandRz" -17.695587072291836;
	setAttr ".LeftHandSx" 1.0000002627935463;
	setAttr ".LeftHandSy" 1.0000003138311861;
	setAttr ".LeftHandSz" 1.0000002999476221;
	setAttr ".RightArmTx" -7.559890672444709;
	setAttr ".RightArmTy" 1.334614081533644;
	setAttr ".RightArmTz" -6.4179031945876943;
	setAttr ".RightArmRx" 3.7675923001559273;
	setAttr ".RightArmRy" 9.7607389374477656;
	setAttr ".RightArmRz" 10.317368847562157;
	setAttr ".RightArmSx" 0.99999996492500776;
	setAttr ".RightArmSy" 1.0000000181599051;
	setAttr ".RightArmSz" 1.0000000064744812;
	setAttr ".RightForeArmTx" -23.627904204743729;
	setAttr ".RightForeArmTy" 0.36613370786540145;
	setAttr ".RightForeArmTz" -0.61642445359701981;
	setAttr ".RightForeArmRx" -0.39036395843996702;
	setAttr ".RightForeArmRy" -2.5154806830901171;
	setAttr ".RightForeArmRz" -4.1398908096099607;
	setAttr ".RightForeArmSx" 1.0000000405293976;
	setAttr ".RightForeArmSy" 0.99999990517009862;
	setAttr ".RightForeArmSz" 1.0000000621251597;
	setAttr ".RightHandTx" -22.329453088007202;
	setAttr ".RightHandTy" 0.34352392960537514;
	setAttr ".RightHandTz" -0.83668687952838638;
	setAttr ".RightHandRx" -50.996943864795931;
	setAttr ".RightHandRy" -23.81401931265551;
	setAttr ".RightHandRz" -66.925756192715639;
	setAttr ".RightHandSx" 1.0000000349765685;
	setAttr ".RightHandSy" 0.99999993876749704;
	setAttr ".RightHandSz" 1.000000038491303;
	setAttr ".HeadTx" 8.0099448383503784;
	setAttr ".HeadTy" -5.0187861972972314e-006;
	setAttr ".HeadTz" -6.9398438640178028e-007;
	setAttr ".HeadRx" -50.209361409279246;
	setAttr ".HeadRy" 32.39277108766435;
	setAttr ".HeadRz" -11.477754250787434;
	setAttr ".HeadSx" 1.0000000812553436;
	setAttr ".HeadSy" 1.0000001287289784;
	setAttr ".HeadSz" 1.0000000825142148;
	setAttr ".LeftToeBaseTx" 6.8757461655578958;
	setAttr ".LeftToeBaseTy" 2.3217321327706486e-006;
	setAttr ".LeftToeBaseTz" -6.6582520830138492e-007;
	setAttr ".LeftToeBaseRx" 0.15438856631492004;
	setAttr ".LeftToeBaseRy" 21.372340810771334;
	setAttr ".LeftToeBaseRz" -37.343289095603232;
	setAttr ".LeftToeBaseSx" 1.0000000400524514;
	setAttr ".LeftToeBaseSy" 1.0000001303424695;
	setAttr ".LeftToeBaseSz" 1.0000000560311817;
	setAttr ".RightToeBaseTx" -6.8757539307799247;
	setAttr ".RightToeBaseTy" 3.2086464472058651e-006;
	setAttr ".RightToeBaseTz" 2.3770638467368599e-005;
	setAttr ".RightToeBaseRx" -19.118299181370414;
	setAttr ".RightToeBaseRy" 6.3834263668079485;
	setAttr ".RightToeBaseRz" 35.283466158760803;
	setAttr ".RightToeBaseSx" 0.99999986023057474;
	setAttr ".RightToeBaseSy" 1.0000000364723174;
	setAttr ".RightToeBaseSz" 0.99999993591283665;
	setAttr ".LeftShoulderTx" 10.381339504404707;
	setAttr ".LeftShoulderTy" 5.2150705719870931;
	setAttr ".LeftShoulderTz" 13.982765936485098;
	setAttr ".LeftShoulderRx" -10.471017859499996;
	setAttr ".LeftShoulderRy" 45.417232244869588;
	setAttr ".LeftShoulderRz" -8.5255946549762331;
	setAttr ".LeftShoulderSx" 1.0000000788217815;
	setAttr ".LeftShoulderSy" 1.0000003096354013;
	setAttr ".LeftShoulderSz" 1.00000006102745;
	setAttr ".RightShoulderTx" 10.381012408731365;
	setAttr ".RightShoulderTy" 5.2151808400652442;
	setAttr ".RightShoulderTz" -13.982802766697283;
	setAttr ".RightShoulderRx" -20.353352141400091;
	setAttr ".RightShoulderRy" -0.61659837281885033;
	setAttr ".RightShoulderRz" 1.9925706797847875;
	setAttr ".RightShoulderSx" 0.99999985468424268;
	setAttr ".RightShoulderSy" 0.99999995295504385;
	setAttr ".RightShoulderSz" 0.99999990444335363;
	setAttr ".NeckTx" 17.971188624942499;
	setAttr ".NeckTy" -3.4531853145836067e-006;
	setAttr ".NeckTz" 3.0314533070452399e-006;
	setAttr ".NeckRx" -3.8340836326722565;
	setAttr ".NeckRy" -15.674477610508353;
	setAttr ".NeckRz" 14.178072911002229;
	setAttr ".NeckSx" 1.0000003191013696;
	setAttr ".NeckSy" 1.0000001522642832;
	setAttr ".NeckSz" 0.99999994629559474;
	setAttr ".Spine1Tx" 7.1917508551920974;
	setAttr ".Spine1Ty" 5.4835317797596872e-007;
	setAttr ".Spine1Tz" -9.3644239029799792e-009;
	setAttr ".Spine1Rx" 13.906644730291992;
	setAttr ".Spine1Ry" -2.5521082143773226;
	setAttr ".Spine1Rz" -2.9512599184478447;
	setAttr ".Spine1Sx" 1.0000000678543195;
	setAttr ".Spine1Sy" 1.0000000605102015;
	setAttr ".Spine1Sz" 1.0000000194508583;
	setAttr ".Spine2Tx" 15.480260403557558;
	setAttr ".Spine2Ty" -3.1167701202150511e-006;
	setAttr ".Spine2Tz" -1.9534830801859471e-006;
	setAttr ".Spine2Rx" 14.062126095490214;
	setAttr ".Spine2Ry" -1.4412802855724094;
	setAttr ".Spine2Rz" -2.8177483269144017;
	setAttr ".Spine2Sx" 0.99999991030442714;
	setAttr ".Spine2Sy" 0.99999977279029373;
	setAttr ".Spine2Sz" 0.99999991513862863;
	setAttr ".Spine3Tx" 13.088917775817393;
	setAttr ".Spine3Ty" -2.3733784004775771e-007;
	setAttr ".Spine3Tz" -6.3653476845004775e-007;
	setAttr ".Spine3Rx" 11.759857102750271;
	setAttr ".Spine3Ry" -7.8971479078207398;
	setAttr ".Spine3Rz" -3.4545292032536508;
	setAttr ".Spine3Sx" 0.99999994116187629;
	setAttr ".Spine3Sy" 0.99999991043812497;
	setAttr ".Spine3Sz" 0.99999998203068485;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "BC9BB22B-4CB3-2CD5-1B07-F3A866D74663";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "870C8F12-48A5-FBA7-A179-CEB943BA4F8F";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "823D019B-46DE-9135-A760-FDACC4D85BB0";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "D9041F67-4DA0-140F-2736-F0977E9DE2B2";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "10060175-4083-78B9-25C9-0B8742DCEE98";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "1A1F571F-4A45-9F96-FCC2-59859BE137F0";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "2E6FE469-42D6-EAA4-2229-2C81C7E90BD0";
	setAttr ".ihi" 0;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "6DC1543D-466A-9D94-CF1D-F7860414C5FA";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" -0.38037632287492351 -5.5511151231257802e-017 0.92483179713726971 0
		 0.87581794642484301 0.32122643695513331 0.36021729681024534 0 -0.29708042297721782 0.94700241615378666 -0.12218693089920696 0
		 -0.53718496277415007 48.727735265313378 -1.9705018737214193 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.074378978457548289 -0.70363414869353103 0.70665907139032202 0
		 0.99400210176017922 0.10928209190335242 0.0041912018258796514 0 -0.080174249840791439 0.70210882571715827 0.70754207356562226 0
		 17.858815828463413 40.784787979508977 9.8734967382800587 1;
	setAttr ".LeftLegGX" -type "matrix" 0.042295642395766365 -0.34880355099359384 -0.93624117468201662 0
		 0.99400208053114236 0.10928208956940005 0.0041912017363675896 0 0.10085247618132778 -0.93080285248045314 0.35133349284707416 0
		 19.689420161887611 23.467049171375212 27.265684493036282 1;
	setAttr ".LeftFootGX" -type "matrix" 0.44716500869395648 -0.7485186903969574 0.48965653184084312 0
		 0.83732275446603766 0.1577985139575484 -0.52344098513983139 0 0.3145381896616159 0.64406501649426451 0.69731358840187763 0
		 20.388592858883676 17.701114362518044 11.789046690348338 1;
	setAttr ".RightUpLegGX" -type "matrix" -0.09081770080841689 0.99512020341386809 -0.038577413076864145 0
		 0.99531113055993226 0.091993732988491034 0.029886758231611563 0 0.033289787949806977 -0.035682272074849336 -0.99880859741999151 0
		 -21.942954021580292 40.784787979508977 -6.4966701464842673 1;
	setAttr ".RightLegGX" -type "matrix" -0.0013503466627028567 -0.29573612300988822 0.95526871055985652 0
		 0.99531110930293865 0.09199373102376851 0.029886757593316049 0 -0.096717330248833749 0.95082997636466604 0.29422516431573753 0
		 -19.707762303447179 16.293037831486664 -5.5472086048592093 1;
	setAttr ".RightFootGX" -type "matrix" 0.26767651533722536 0.94516792630668145 0.18710196042788485 0
		 0.86784456069651306 -0.32086847122344092 0.37932762397340897 0 0.41856344490839009 0.060838295025674644 -0.90614758426001152 0
		 -19.68544018484916 21.181736652002343 -21.338386202527953 1;
	setAttr ".SpineGX" -type "matrix" 0.01061082319028539 0.98104728146879128 -0.19347776693689273 0
		 0.94940993940877072 0.050847589807058002 0.30989561075085786 0 0.3138601245962328 -0.18697796251762264 -0.93087650527132948 0
		 0.28418600060666765 62.369713567502565 -3.9675504240583428 1;
	setAttr ".LeftArmGX" -type "matrix" 0.7292215764102673 -0.37782218041829441 0.57051463766982846 0
		 -0.44803186367868064 -0.89381033248201092 -0.019257916259892982 0 0.51720775997519686 -0.24156538991758253 -0.82106170987654092 0
		 23.901087575654106 109.52059386446786 -2.7255600756788283 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.17787637328850664 0.0680108537654808 0.98169996673600046 0
		 -0.44803183663034979 -0.89381031591066762 -0.019257939858237694 0 0.87614379573853718 -0.44325832131135823 0.18945892819945154 0
		 49.674220621104496 96.167092567290126 17.438337759252811 1;
	setAttr ".LeftHandGX" -type "matrix" -0.036300757495205796 0.41592096616098739 0.90867620940221383 0
		 -0.90048059445262529 -0.40793430653281776 0.15074697898530814 0 0.43337911549885155 -0.81277286405546256 0.38933712300291201 0
		 44.944821216998015 97.975373219496063 43.53989529028911 1;
	setAttr ".RightArmGX" -type "matrix" 0.9538341554876244 0.27251238924282273 0.12624615752830967 0
		 0.27685681563735653 -0.63488697989613141 -0.72129687352610217 0 -0.11641036232334553 0.72294955857698506 -0.68102350547832458 0
		 -20.936239046721859 101.92628895972278 -17.963609001050131 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.077671032744750748 -0.73339675888231326 0.67534960552636925 0
		 0.27685682828696451 -0.63488695923728256 -0.721297013692202 0 0.95776738073953238 0.24299897042378452 0.15373361271995659 0
		 -54.647943146747544 92.294785750974995 -22.425572843063055 1;
	setAttr ".RightHandGX" -type "matrix" 0.53134731955324377 -0.40008761604266646 0.74672673586543425 0
		 -0.58678643583840362 -0.8095797445587718 -0.016224809600424689 0 0.61102594811396482 -0.42954794156692522 -0.66493352763491587 0
		 -56.713065674734402 111.79441371643458 -40.381841185511348 1;
	setAttr ".HeadGX" -type "matrix" -0.16252566755516332 0.43586506132318925 0.88521592112244274 0
		 0.87962234331982836 -0.34246680880540586 0.3301234466075269 0 0.44704627971638583 0.83230916447413017 -0.32773684327793984 0
		 1.5589249562670566 126.33268637633222 -5.9679915816134992 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.48728228202539142 3.3387378362004227e-008 0.87324462609253672 0
		 0.87324463383784323 3.9443353444523765e-009 -0.48728230797861738 0 -5.5742315652196339e-008 1.000000173176256 -1.4974975759418641e-008 0
		 28.303254565324963 4.4526006776580758 20.455794118334978 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.52933573977475923 -2.4113976995754349e-008 -0.84841252088026775 0
		 0.848412594439928 -2.0833753396065635e-008 0.52933564850585368 0 -1.6260320846728238e-008 -1.0000001414428752 -1.3649804238291541e-008 0
		 -24.423219533113635 4.4526006776580793 -24.650025271457093 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.87915707069076432 0.25569379421441646 0.40212435288192067 0
		 0.44377961063568999 -0.13186236510489288 -0.88638143074702458 0 -0.17361718118332048 0.95772300781661768 -0.22939937384403153 0
		 4.8185198603979389 103.9706249841861 -11.453880675204061 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.97029119401879527 0.095129455848786029 0.22245416471287341 0
		 -0.23473050944104629 0.14734287864516668 0.96082866863416783 0 0.058626089119168244 -0.98450028919711052 0.16529524293568354 0
		 0.12444260727367695 103.99112395529525 -13.135123692214368 1;
	setAttr ".NeckGX" -type "matrix" -0.022075062478310911 0.97438157446350915 0.22381606932206996 0
		 0.9075639641527482 -0.074368596235885986 0.41327646601263929 0 0.41933373138576224 0.21225049192679818 -0.88267156134306224 0
		 1.9296898268451383 109.96733149270169 -9.7271247106702017 1;
	setAttr ".Spine1GX" -type "matrix" 0.07025689367765145 0.99751142443160201 -0.0059440641908819203 0
		 0.93890534178469187 -0.064114130346710069 0.33815176231458333 0 0.33692901699041461 -0.029338394675662405 -0.9410729000854885 0
		 0.59385782880916849 91.001111881976001 -9.6141070322897466 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "212AC8C0-495C-DB2E-CA7C-968FE1AA77F3";
	setAttr ".ovrd" yes;
createNode pairBlend -n "pairBlend1";
	rename -uid "ED5F4D8B-4FAD-95B4-0B8E-34AC3948FF0E";
createNode pairBlend -n "pairBlend2";
	rename -uid "A8C4BEA8-40EA-6DB3-4BD0-07A93401EBAF";
createNode pairBlend -n "pairBlend3";
	rename -uid "C25CE025-45CF-F4F8-C26A-DD9AC59041ED";
createNode pairBlend -n "pairBlend4";
	rename -uid "197FDCBE-4B8F-A390-9EFA-9CBDD405A9EB";
createNode pairBlend -n "pairBlend5";
	rename -uid "90B3E1B4-4A5F-6148-0014-9083CF3ADFC0";
createNode pairBlend -n "pairBlend6";
	rename -uid "03885728-4778-2443-C188-A7828DE57B6F";
createNode pairBlend -n "pairBlend7";
	rename -uid "75D83F40-4259-B41D-A477-44B306A1DC1C";
createNode pairBlend -n "pairBlend8";
	rename -uid "F4DA9660-40B8-BF2C-00E0-9E90000CC529";
createNode pairBlend -n "pairBlend9";
	rename -uid "CA7D25BF-4594-4F61-EF2D-61ABD474E107";
createNode pairBlend -n "pairBlend10";
	rename -uid "24A55476-4BC1-8648-B9BE-8C98658C13C4";
createNode pairBlend -n "pairBlend11";
	rename -uid "2E5E2CE8-4994-0047-E819-7697F9964E02";
createNode pairBlend -n "pairBlend12";
	rename -uid "50192994-485D-4A1D-64DE-7797BC773E5F";
createNode pairBlend -n "pairBlend13";
	rename -uid "3D39DB0D-4908-4E0A-0D36-82BB80845A79";
createNode pairBlend -n "pairBlend14";
	rename -uid "6AC7DFB4-47FA-C9B0-352E-BB9B10F0F339";
createNode pairBlend -n "pairBlend15";
	rename -uid "4D549E6D-41E5-4E5E-C3A7-2F8C28F4D8D9";
createNode pairBlend -n "pairBlend16";
	rename -uid "B77BD25A-4BDB-4971-0563-EF9670FD112D";
createNode pairBlend -n "pairBlend17";
	rename -uid "A9BDBE9B-40D5-981E-B468-7685452D974D";
createNode pairBlend -n "pairBlend18";
	rename -uid "61CF6DD1-4DF9-68FF-393B-399676C8B497";
createNode pairBlend -n "pairBlend19";
	rename -uid "EF78DAE9-40C5-855B-94B7-3B99113196BC";
createNode pairBlend -n "pairBlend20";
	rename -uid "C7050B05-4AF9-9B07-CEA3-9BA0A18F0BC1";
createNode pairBlend -n "pairBlend21";
	rename -uid "2D901102-4770-20B0-A898-10BABA98C1D1";
createNode pairBlend -n "pairBlend22";
	rename -uid "C024084E-4548-301A-F4A6-20920E3A04E6";
createNode pairBlend -n "pairBlend23";
	rename -uid "472DBD62-4398-7DB7-FFD8-BF9D3251D8A8";
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "E8F6DB84-46EF-8198-A2A5-7CA021448B3C";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "3F5B79A5-4F25-7C81-41E3-598C9739B3A6";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "6A73FEC5-4E36-C90A-E60F-479908CC904B";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA";
	rename -uid "F20E99D3-494B-9029-3E04-79B1E5F0111A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -17.145320892333984 1 -16.764070510864258
		 2 -15.762130737304688 3 -14.216391563415527 4 -12.17225456237793 5 -9.7431297302246094
		 6 -7.034271240234375 7 -4.3332672119140625 8 -2.0599880218505859 9 -0.70631790161132813
		 10 0.43276357650756836 11 1.0212256908416748 12 0.93491721153259277 13 0.49343442916870117
		 14 -0.26613235473632813 15 -1.2055549621582031 16 -2.5818743705749512 17 -4.5799503326416016
		 18 -6.9172849655151367 19 -9.2270622253417969 20 -11.175020217895508 21 -12.874918937683105
		 22 -14.19432258605957 23 -15.191093444824219 24 -15.938717842102051 25 -16.477287292480469
		 26 -16.828056335449219 27 -17.029685974121094 28 -17.122165679931641 29 -17.146650314331055
		 30 -17.145320892333984;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "BD97BE85-40D8-3877-5962-BCB6E3A7FD11";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.86335647106170654 0.32122647762298584 -0.38913950324058533 0
		 -0.29285335540771484 0.94700264930725098 0.13199752569198608 0 0.41091713309288025 -8.1956386566162109e-008 0.91167294979095459 0
		 1.3040504455566406 35.036701202392578 -0.26613140106201172 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.91267633438110352 -0.15795296430587769 -0.37692555785179138 0
		 -0.12908819317817688 0.76365697383880615 -0.63258540630340576 0 0.38776054978370667 0.62600231170654297 0.67658179998397827 0
		 26.35350227355957 12.309239387512207 10.633017539978027 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.90495264530181885 -0.32652020454406738 0.27284723520278931 0
		 0.07509748637676239 0.7537112832069397 0.65290123224258423 0 -0.41883343458175659 -0.5703544020652771 0.70659375190734863 0
		 -22.729848861694336 16.434684753417969 -22.800151824951172 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.58725690841674805 -0.040959030389785767 -0.80836397409439087 0
		 -0.74377095699310303 0.36664187908172607 -0.55890882015228271 0 0.31927222013473511 0.92946040630340576 0.18484881520271301 0
		 12.96912956237793 74.888107299804688 -58.638290405273437 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.1170513853430748 0.83641290664672852 -0.53545522689819336 0
		 -0.99312031269073486 0.10038623958826065 -0.060288414359092712 0 0.0033263266086578369 0.53882831335067749 0.84240901470184326 0
		 -3.5191450119018555 81.383651733398438 59.082534790039062 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.94098031520843506 0.2261301577091217 -0.25183629989624023 0
		 -0.28718331456184387 0.13967292010784149 -0.94763779640197754 0 -0.17911478877067566 0.96403157711029053 0.19637024402618408 0
		 25.047979354858398 25.736457824707031 2.1405229568481445 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98370987176895142 0.04224703460931778 -0.17472942173480988 0
		 0.10626567155122757 0.64731681346893311 0.75477731227874756 0 0.14499236643314362 -0.76104950904846191 0.63228243589401245 0
		 -23.84889030456543 14.17414665222168 -7.0598697662353516 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" 0.85759812593460083 -0.24214836955070496 -0.45375141501426697 0
		 -0.057378970086574554 0.83168137073516846 -0.55228108167648315 0 0.51111042499542236 0.49967080354690552 0.69935387372970581 0
		 -6.1962800025939941 80.299583435058594 -48.497955322265625 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" -0.48629602789878845 0.060052976012229919 -0.87172812223434448 0
		 -0.47454458475112915 0.81954175233840942 0.32118397951126099 0 0.73370546102523804 0.56986433267593384 -0.37004196643829346 0
		 -14.350374221801758 82.439750671386719 39.563526153564453 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.81987577676773071 0.28271263837814331 -0.49787291884422302 0
		 -0.27230203151702881 0.95748263597488403 0.095282614231109619 0 0.50364226102828979 0.057451903820037842 0.8619999885559082 0
		 -4.8189420700073242 45.560874938964844 -5.1632137298583984 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.35720831155776978 -0.063727200031280518 -0.93184816837310791 0
		 -0.23728683590888977 0.95874619483947754 -0.15652662515640259 0 0.90338099002838135 0.27702793478965759 0.32735049724578857 0
		 -10.227033615112305 89.247344970703125 -4.9851932525634766 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324488162994385 1.2979108987565269e-007 -0.48728203773498535 0
		 -1.2979108987565269e-007 1.0000002384185791 3.3762198370368424e-008 0 0.48728203773498535 3.3762198370368424e-008 0.87324488162994385 0
		 26.182731628417969 6.4234061241149902 14.183185577392578 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841251373291016 1.6409556380381218e-008 0.52933573722839355 0
		 1.6409556380381218e-008 1.0000001192092896 -5.730130325787286e-008 0 -0.52933573722839355 5.730130325787286e-008 0.84841251373291016 0
		 -22.158807754516602 11.955905914306641 -27.985752105712891 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.06338268518447876 -0.44577950239181519 -0.89289605617523193 0
		 -0.1271500438451767 0.8837968111038208 -0.45026242733001709 0 0.98985636234283447 0.14207057654857635 -0.00066346302628517151 0
		 -7.6945672035217285 90.837242126464844 -27.391040802001953 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" -0.17379623651504517 0.213847815990448 -0.96128249168395996 0
		 -0.49194544553756714 0.82676172256469727 0.27286410331726074 0 0.8531029224395752 0.5203213095664978 -0.038486599922180176 0
		 -18.989212036132812 87.729988098144531 16.996150970458984 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.91517788171768188 0.14235226809978485 -0.37707450985908508 0
		 -0.15105132758617401 0.98850405216217041 0.0065689049661159515 0 0.37367478013038635 0.050945889204740524 0.92615962028503418 0
		 -10.214632034301758 103.58108520507812 -8.2830486297607422 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.98064315319061279 0.18965749442577362 -0.048676371574401855 0
		 -0.19559116661548615 0.937225341796875 -0.28870946168899536 0 -0.0091351922601461411 0.29264158010482788 0.95617872476577759 0
		 22.798467636108398 43.034053802490234 -9.95428466796875 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.96745288372039795 -0.11683661490678787 -0.2244657576084137 0
		 0.2508949339389801 0.32728159427642822 0.91100990772247314 0 -0.032975830137729645 -0.9376760721206665 0.34594312310218811 0
		 -20.190366744995117 27.039346694946289 9.4220218658447266 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "73973568-45B3-76F4-6258-FEB8FCFED834";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "5378F297-4539-6EB6-2DE0-0A93776CCA9C";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.86335647106170654 0.32122647762298584 -0.38913950324058533 0
		 -0.29285335540771484 0.94700264930725098 0.13199752569198608 0 0.41091713309288025 -8.1956386566162109e-008 0.91167294979095459 0
		 1.3040504455566406 35.036701202392578 -0.26613140106201172 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.91267633438110352 -0.15795296430587769 -0.37692555785179138 0
		 -0.12908819317817688 0.76365697383880615 -0.63258540630340576 0 0.38776054978370667 0.62600231170654297 0.67658179998397827 0
		 26.35350227355957 12.309239387512207 10.633017539978027 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.90495264530181885 -0.32652020454406738 0.27284723520278931 0
		 0.07509748637676239 0.7537112832069397 0.65290123224258423 0 -0.41883343458175659 -0.5703544020652771 0.70659375190734863 0
		 -22.729848861694336 16.434684753417969 -22.800151824951172 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.58725690841674805 -0.040959030389785767 -0.80836397409439087 0
		 -0.74377095699310303 0.36664187908172607 -0.55890882015228271 0 0.31927222013473511 0.92946040630340576 0.18484881520271301 0
		 12.96912956237793 74.888107299804688 -58.638290405273437 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.1170513853430748 0.83641290664672852 -0.53545522689819336 0
		 -0.99312031269073486 0.10038623958826065 -0.060288414359092712 0 0.0033263266086578369 0.53882831335067749 0.84240901470184326 0
		 -3.5191450119018555 81.383651733398438 59.082534790039062 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.94098031520843506 0.2261301577091217 -0.25183629989624023 0
		 -0.28718331456184387 0.13967292010784149 -0.94763779640197754 0 -0.17911478877067566 0.96403157711029053 0.19637024402618408 0
		 25.047979354858398 25.736457824707031 2.1405229568481445 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98370987176895142 0.04224703460931778 -0.17472942173480988 0
		 0.10626567155122757 0.64731681346893311 0.75477731227874756 0 0.14499236643314362 -0.76104950904846191 0.63228243589401245 0
		 -23.84889030456543 14.17414665222168 -7.0598697662353516 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" 0.85759812593460083 -0.24214836955070496 -0.45375141501426697 0
		 -0.057378970086574554 0.83168137073516846 -0.55228108167648315 0 0.51111042499542236 0.49967080354690552 0.69935387372970581 0
		 -6.1962800025939941 80.299583435058594 -48.497955322265625 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" -0.48629602789878845 0.060052976012229919 -0.87172812223434448 0
		 -0.47454458475112915 0.81954175233840942 0.32118397951126099 0 0.73370546102523804 0.56986433267593384 -0.37004196643829346 0
		 -14.350374221801758 82.439750671386719 39.563526153564453 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.81987577676773071 0.28271263837814331 -0.49787291884422302 0
		 -0.27230203151702881 0.95748263597488403 0.095282614231109619 0 0.50364226102828979 0.057451903820037842 0.8619999885559082 0
		 -4.8189420700073242 45.560874938964844 -5.1632137298583984 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.35720831155776978 -0.063727200031280518 -0.93184816837310791 0
		 -0.23728683590888977 0.95874619483947754 -0.15652662515640259 0 0.90338099002838135 0.27702793478965759 0.32735049724578857 0
		 -10.227033615112305 89.247344970703125 -4.9851932525634766 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324488162994385 1.2979108987565269e-007 -0.48728203773498535 0
		 -1.2979108987565269e-007 1.0000002384185791 3.3762198370368424e-008 0 0.48728203773498535 3.3762198370368424e-008 0.87324488162994385 0
		 26.182731628417969 6.4234061241149902 14.183185577392578 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841251373291016 1.6409556380381218e-008 0.52933573722839355 0
		 1.6409556380381218e-008 1.0000001192092896 -5.730130325787286e-008 0 -0.52933573722839355 5.730130325787286e-008 0.84841251373291016 0
		 -22.158807754516602 11.955905914306641 -27.985752105712891 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.06338268518447876 -0.44577950239181519 -0.89289605617523193 0
		 -0.1271500438451767 0.8837968111038208 -0.45026242733001709 0 0.98985636234283447 0.14207057654857635 -0.00066346302628517151 0
		 -7.6945672035217285 90.837242126464844 -27.391040802001953 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" -0.17379623651504517 0.213847815990448 -0.96128249168395996 0
		 -0.49194544553756714 0.82676172256469727 0.27286410331726074 0 0.8531029224395752 0.5203213095664978 -0.038486599922180176 0
		 -18.989212036132812 87.729988098144531 16.996150970458984 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.91517788171768188 0.14235226809978485 -0.37707450985908508 0
		 -0.15105132758617401 0.98850405216217041 0.0065689049661159515 0 0.37367478013038635 0.050945889204740524 0.92615962028503418 0
		 -10.214632034301758 103.58108520507812 -8.2830486297607422 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.98064315319061279 0.18965749442577362 -0.048676371574401855 0
		 -0.19559116661548615 0.937225341796875 -0.28870946168899536 0 -0.0091351922601461411 0.29264158010482788 0.95617872476577759 0
		 22.798467636108398 43.034053802490234 -9.95428466796875 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.96745288372039795 -0.11683661490678787 -0.2244657576084137 0
		 0.2508949339389801 0.32728159427642822 0.91100990772247314 0 -0.032975830137729645 -0.9376760721206665 0.34594312310218811 0
		 -20.190366744995117 27.039346694946289 9.4220218658447266 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "96D15C1A-44FB-0D97-45F1-1AB68B13C84B";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "38769767-4532-0687-9FD3-7C98C59FEC74";
	setAttr ".ihi" 0;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA";
	rename -uid "DAA0C939-417D-0D22-0D68-F2B6F472B2ED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 44.421516418457031 1 44.196922302246094
		 2 43.603511810302734 3 42.717826843261719 4 41.604530334472656 5 40.362899780273438
		 6 39.08477783203125 7 37.888774871826172 8 36.895462036132813 9 36.36590576171875
		 10 36.225181579589844 11 36.174076080322266 12 35.867130279541016 13 35.389301300048828
		 14 35.036705017089844 15 34.872291564941406 16 35.175624847412109 17 36.001598358154297
		 18 37.109439849853516 19 38.405994415283203 20 39.473423004150391 21 40.543800354003906
		 22 41.500778198242187 23 42.369522094726563 24 43.111305236816406 25 43.646366119384766
		 26 44.010848999023438 27 44.23834228515625 28 44.361461639404297 29 44.411937713623047
		 30 44.421516418457031;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA";
	rename -uid "3B295F76-4D09-2E68-DCD0-018F65A3CFCA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 6.0677757263183594 1 5.4000587463378906
		 2 3.7422351837158203 3 1.6464023590087891 4 -0.34092140197753906 5 -1.7458457946777344
		 6 -2.16839599609375 7 -1.9358024597167969 8 -1.7246417999267578 9 -1.2955741882324219
		 10 -0.75000572204589844 11 -0.12652397155761719 12 0.50644302368164063 13 1.0687637329101563
		 14 1.3040428161621094 15 1.0961036682128906 16 0.48017120361328125 17 -0.42866325378417969
		 18 -1.3952541351318359 19 -2.2224578857421875 20 -2.6657791137695312 21 -2.6264133453369141
		 22 -2.0480613708496094 23 -1.0882205963134766 24 0.11548233032226563 25 1.4506168365478516
		 26 2.8025398254394531 27 4.0563259124755859 28 5.0961666107177734 29 5.8055152893066406
		 30 6.0677757263183594;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ";
	rename -uid "11346AA6-48B8-BF80-AAE6-568A1A5D0971";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0 1 -0.93338743698741644 2 -3.2495316490322503
		 3 -6.1694525616884786 4 -8.9105423938435084 5 -10.851935697026118 6 -11.580693225720649
		 7 -11.075591949579419 8 -9.6359985041969516 9 -7.3519683413273507 10 -4.3743275450870502
		 11 -0.9786041791703769 12 2.4545493399589708 13 5.5298846323465574 14 7.9350221233650373
		 15 9.4748793072278197 16 10.020189295313715 17 9.8913316110277059 18 9.5267430586862005
		 19 8.9562361758985798 20 8.2088208706244092 21 7.315903063795397 22 6.3135314473105284
		 23 5.2431858694757647 24 4.1513890414869294 25 3.0883229598514523 26 2.1059618026778821
		 27 1.2562465755102563 28 0.5897496715751851 29 0.15522678726189199 30 0;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY";
	rename -uid "D96DED52-456E-7EB4-F953-FE99D1BDC253";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 18.737105422408931 1 18.714681133996727
		 2 18.463157458073479 3 17.726824655920286 4 16.550092117023382 5 15.367455443472762
		 6 14.831849583607212 7 15.208960686352864 8 16.146286066616767 9 17.282328948285368
		 10 18.237196927074432 11 18.712453395079301 12 18.581365143903547 13 17.930565306643093
		 14 17.02885763467064 15 16.239679849060092 16 15.914639807386637 17 15.993756559050068
		 18 16.209855672671107 19 16.525897981419345 20 16.901583207171427 21 17.29723891928364
		 22 17.67745053367231 23 18.01389904997308 24 18.287555812691892 25 18.489857300818905
		 26 18.622594824780933 27 18.696460193853945 28 18.728158594517652 29 18.73648975550968
		 30 18.737105422408931;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX";
	rename -uid "47743A5A-47D4-F79E-AE98-C0A7386C2417";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0 1 -2.9068114872227939 2 -10.163797486028622
		 3 -19.545743268519299 4 -28.828528286731718 5 -35.880933942789156 6 -38.677924862986806
		 7 -36.729125192809398 8 -31.405452886661937 9 -23.47578212153093 10 -13.735543212334079
		 11 -3.04775728433416 12 7.661673026358006 13 17.457038667977422 14 25.452259675379949
		 15 30.827724219449291 16 32.796636694870244 17 32.327864310324685 18 31.01332832021485
		 19 28.989057912986766 20 26.390572120219367 21 23.354429586347365 22 20.019575034794965
		 23 16.527905987366768 24 13.024129309751787 25 9.6551323595799712 26 6.5689124026477135
		 27 3.9135077138334222 28 1.8362005339250185 29 0.48323252256377708 30 0;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "64C1873A-4CA7-3DF5-06B8-5D9BF0B84BE8";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "48540926-48CF-6128-0CF2-B4BD83941BF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -18.297317504882812 1 -17.896823883056641
		 2 -16.856231689453125 3 -13.547822952270508 4 -7.336662769317627 5 -0.087498664855957031
		 6 6.78253173828125 7 12.156194686889648 8 14.839733123779297 9 14.496994018554688
		 10 13.933719635009766 11 13.237998008728027 12 12.523193359375 13 11.896608352661133
		 14 10.633009910583496 15 9.1420021057128906 16 7.0759248733520508 17 3.6386947631835937
		 18 -1.5890464782714844 19 -8.043543815612793 20 -13.689275741577148 21 -17.680446624755859
		 22 -19.220054626464844 23 -19.219642639160156 24 -19.135358810424805 25 -18.993057250976563
		 26 -18.816818237304688 27 -18.63177490234375 28 -18.464794158935547 29 -18.343860626220703
		 30 -18.297317504882812;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "59C0B68C-42CD-BD75-7147-8488A6319DE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 16.987054824829102 1 17.09161376953125
		 2 17.269035339355469 3 18.978200912475586 4 21.992504119873047 5 23.488842010498047
		 6 22.188510894775391 7 18.778966903686523 8 13.526762008666992 9 13.620353698730469
		 10 13.52464485168457 11 13.164812088012695 12 12.556461334228516 13 11.829076766967773
		 14 12.309253692626953 15 13.219623565673828 16 13.600597381591797 17 13.323806762695313
		 18 13.498235702514648 19 14.980863571166992 20 15.851615905761719 21 15.966466903686523
		 22 15.37786865234375 23 15.606260299682617 24 15.879734039306641 25 16.161449432373047
		 26 16.425657272338867 27 16.653295516967773 28 16.830310821533203 29 16.945436477661133
		 30 16.987054824829102;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "D0DFEE88-4057-4009-C036-7B9BF321A4C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 24.701837539672852 1 24.503799438476563
		 2 23.938720703125 3 23.383306503295898 4 22.938434600830078 5 22.741842269897461
		 6 23.282482147216797 7 24.234720230102539 8 24.508613586425781 9 24.98045539855957
		 10 25.524379730224609 11 26.002964019775391 12 26.328388214111328 13 26.493673324584961
		 14 26.353504180908203 15 25.977991104125977 16 25.483139038085937 17 24.867156982421875
		 18 23.995883941650391 19 22.897356033325195 20 22.084194183349609 21 21.739757537841797
		 22 21.915138244628906 23 22.334625244140625 24 22.791984558105469 25 23.255638122558594
		 26 23.698127746582031 27 24.092205047607422 28 24.410179138183594 29 24.623502731323242
		 30 24.701837539672852;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "8271CD64-4BFF-DF0C-FE5A-E083F96AED7C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -10.121490879014077 1 -8.2535600003544811
		 2 -3.4223895095240371 3 0.52332592385824894 4 0.46531046480319027 5 -4.0963571637534795
		 6 -12.056181061855536 7 -19.253410323197468 8 -22.492814750173551 9 -23.9777948168188
		 10 -26.731948890194722 11 -30.466072308030622 12 -34.728156808473237 13 -38.90633787128769
		 14 -42.466242029190127 15 -45.14042806320748 16 -45.497934386825179 17 -42.94659752581979
		 18 -38.1346222952671 19 -31.329174539275147 20 -23.789078378926373 21 -17.814492156474749
		 22 -15.42302690289241 23 -15.221188251541722 24 -14.607176004206037 25 -13.744553132181061
		 26 -12.766065278410416 27 -11.793947035558958 28 -10.948102431511723 29 -10.349342992702939
		 30 -10.121490879014077;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "11FCB093-4D76-A070-0261-768D1E2C076B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 11.767878665944169 1 10.774694987595659
		 2 7.9666753333776414 3 3.0752377017537347 4 -4.2734624996776667 5 -12.309228546090564
		 6 -16.480695752434748 7 -15.249897621616318 8 -10.704339421084292 9 -8.3217883324731332
		 10 -5.6752084122517328 11 -3.4684381310207346 12 -2.1344363653394951 13 -1.6689124864079259
		 14 -2.0510179059966789 15 -2.9604005456300908 16 -3.941808830875019 17 -4.9378343030189313
		 18 -5.8457926158472775 19 -6.2217074819588589 20 -5.5997227687195599 21 -3.9748068078898648
		 22 -1.8383812824868717 23 0.24577969423949997 24 2.5067552465202301 25 4.7819049241196536
		 26 6.9366675772333704 27 8.8425199410331867 28 10.371708265955345 29 11.393499053444215
		 30 11.767878665944169;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "B59D9191-4A7A-E6AC-488A-A380145BC140";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -27.817066159610302 1 -27.991381553422102
		 2 -28.433567063933694 3 -27.723374519801247 4 -26.015625146288443 5 -23.515223145844818
		 6 -20.695685990294777 7 -20.263258930495233 8 -27.548507637626056 9 -26.871366939515084
		 10 -25.887757492753924 11 -24.695704224659917 12 -23.356537521406885 13 -21.984764641650848
		 14 -20.758009383247998 15 -19.809405991278204 16 -19.723707517027009 17 -20.734671172100335
		 18 -22.485215718787789 19 -24.659402103858927 20 -26.621334774756932 21 -27.760186315160869
		 22 -27.976723289175407 23 -27.815393354292045 24 -27.731303542753889 25 -27.704255217600004
		 26 -27.71459591539432 27 -27.744576543400747 28 -27.779099882466042 29 -27.806293947425853
		 30 -27.817066159610302;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "303B4211-4A9C-FDC4-48BE-C5916DFED6E0";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "CF98EA1A-4FCD-33B5-DA82-BA95B7FB7206";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -29.197517395019531 1 -29.321805953979492
		 2 -29.630527496337891 3 -30.006139755249023 4 -30.27851676940918 5 -30.261478424072266
		 6 -29.796087265014648 7 -28.885784149169922 8 -27.732545852661133 9 -26.45832633972168
		 10 -25.2218017578125 11 -24.192144393920898 12 -23.444919586181641 13 -22.999198913574219
		 14 -22.800148010253906 15 -22.786905288696289 16 -22.955612182617188 17 -23.256645202636719
		 18 -23.639383316040039 19 -24.129718780517578 20 -24.732200622558594 21 -25.41552734375
		 22 -26.135074615478516 23 -26.826332092285156 24 -27.445585250854492 25 -27.976341247558594
		 26 -28.413818359375 27 -28.755807876586914 28 -29.000875473022461 29 -29.148260116577148
		 30 -29.197517395019531;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "783071A2-4861-6304-BA24-60B64ABA26EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 16.391769409179688 1 16.467161178588867
		 2 16.618358612060547 3 16.742193222045898 4 16.80558967590332 5 16.852365493774414
		 6 16.943637847900391 7 17.111553192138672 8 17.290107727050781 9 17.371406555175781
		 10 17.300876617431641 11 17.105106353759766 12 16.851377487182617 13 16.606472015380859
		 14 16.434690475463867 15 16.383167266845703 16 16.465415954589844 17 16.643436431884766
		 18 16.851337432861328 19 17.066896438598633 20 17.261259078979492 21 17.397649765014648
		 22 17.451740264892578 23 17.422527313232422 24 17.319343566894531 25 17.159149169921875
		 26 16.963554382324219 27 16.758613586425781 28 16.574146270751953 29 16.441810607910156
		 30 16.391769409179688;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "019CA364-47E9-A5E2-E6EC-2A96967357F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -20.967266082763672 1 -21.124118804931641
		 2 -21.475957870483398 3 -21.836074829101563 4 -22.072580337524414 5 -22.162109375
		 6 -22.171428680419922 7 -22.280569076538086 8 -22.56500244140625 9 -22.9091796875
		 10 -23.179347991943359 11 -23.279336929321289 12 -23.192083358764648 13 -22.963171005249023
		 14 -22.729843139648438 15 -22.609611511230469 16 -22.658641815185547 17 -22.834751129150391
		 18 -23.038198471069336 19 -23.226383209228516 20 -23.348451614379883 21 -23.350250244140625
		 22 -23.210159301757813 23 -22.963840484619141 24 -22.642147064208984 25 -22.27562141418457
		 26 -21.897274017333984 27 -21.542041778564453 28 -21.245441436767578 29 -21.042446136474609
		 30 -20.967266082763672;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "F851C71E-4B18-C883-FA4B-B5BC6C6F1069";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.8806851588466333 1 5.2213906797189624
		 2 3.6268904847522201 3 1.748392185607486 4 0.41406862332716504 5 0.49097542327841126
		 6 2.7257669902369304 7 7.0760691015011687 8 12.537292989712221 9 18.574853528212117
		 10 24.543757097466067 11 29.709497375804606 12 33.696623374901343 13 36.329850965607307
		 14 37.685062613084746 15 37.855947934220573 16 36.878061284644417 17 35.064044443558785
		 18 32.810803622140114 19 30.081853732168845 20 26.912757429219333 21 23.488261972316316
		 22 20.01544800959611 23 16.761766366287738 24 13.896227793413503 25 11.465073150701704
		 26 9.4695179796995319 27 7.9080131707230423 28 6.7848617450031403 29 6.1071359472405158
		 30 5.8806851588466333;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "7FCBCA42-4F18-832C-2682-D5B911F8D4B6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.0365495067244694 1 4.2682874878984309
		 2 2.5484356502361614 3 0.78954558247416917 4 -0.36492801997030999 5 -0.79159883643302287
		 6 -0.79083115784530023 7 -1.1849413714684363 8 -2.2903690236626466 9 -3.5329226912687841
		 10 -4.324051068447571 11 -4.3191397028657441 12 -3.5318472097148006 13 -2.2297180973394615
		 14 -1.0413432456250402 15 -0.49164438591212523 16 -0.81865590727912008 17 -1.7980287532413977
		 18 -2.9390897917893977 19 -4.0472929166777716 20 -4.8839449652372204 21 -5.1788269654921564
		 22 -4.8052893252618434 23 -3.8962485501003359 24 -2.5794403803627644 25 -0.99516925985310678
		 26 0.69829958787517743 27 2.3285887877039211 28 3.7155795764277073 29 4.6775524901491794
		 30 5.0365495067244694;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "2C73B4A6-4052-BE9D-EE78-3A8AA3D08679";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 33.467410093817001 1 33.282548217658928
		 2 32.889269019174932 3 32.510277239463605 4 32.273116554052294 5 32.21397127401135
		 6 32.290153327076474 7 32.257000142553295 8 31.864393053195254 9 31.095725824038752
		 10 30.094011679266025 11 29.135354150807 12 28.451311680735298 13 28.160963308345696
		 14 28.156567946669121 15 28.27811699918206 16 28.433586032497345 17 28.600267840331895
		 18 28.815616387664491 19 29.125150909717608 20 29.550402755983104 21 30.076706455281418
		 22 30.658429305843676 23 31.215796929812939 24 31.719856597297738 25 32.17067069591733
		 26 32.57184253661201 27 32.920065157967421 28 33.202252595898706 29 33.395201604421075
		 30 33.467410093817001;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "BA23F867-4FC4-A5C5-9C72-059F2C682B3B";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA";
	rename -uid "0BFCCAD0-464C-6B50-F4A6-148D7027F2F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.1169586181640625 1 5.4471750259399414
		 2 10.61892032623291 3 13.589944839477539 4 14.192150115966797 5 14.330150604248047
		 6 17.015174865722656 7 22.133499145507813 8 25.814998626708984 9 21.579355239868164
		 10 1.2354106903076172 11 -26.341232299804688 12 -45.758842468261719 13 -55.099960327148438
		 14 -58.638278961181641 15 -58.9100341796875 16 -57.210197448730469 17 -55.961277008056641
		 18 -56.207881927490234 19 -56.708663940429688 20 -55.215980529785156 21 -51.513824462890625
		 22 -45.543933868408203 23 -38.039081573486328 24 -29.931808471679688 25 -21.970632553100586
		 26 -14.562717437744141 27 -7.9999980926513672 28 -2.7022781372070313 29 0.83184623718261719
		 30 2.1169586181640625;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA";
	rename -uid "21793DF8-4391-89D1-D0D0-9091E77E94F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 79.924430847167969 1 80.62060546875 2 82.6356201171875
		 3 86.658790588378906 4 92.079696655273438 5 95.832038879394531 6 95.583946228027344
		 7 92.350677490234375 8 88.465888977050781 9 82.048019409179688 10 71.29241943359375
		 11 64.846702575683594 12 66.361541748046875 13 70.127716064453125 14 74.88812255859375
		 15 80.723052978515625 16 86.720451354980469 17 91.328956604003906 18 93.402458190917969
		 19 93.663238525390625 20 92.637245178222656 21 90.503555297851563 22 88.021682739257813
		 23 85.913246154785156 24 84.428115844726563 25 83.357429504394531 26 82.499778747558594
		 27 81.633491516113281 28 80.789306640625 29 80.173690795898437 30 79.924430847167969;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA";
	rename -uid "8C599B59-470E-B6B0-2A75-7E8EE21F31C5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 30.566905975341797 1 25.386222839355469
		 2 13.37883186340332 3 0.10251617431640625 4 -9.13250732421875 5 -12.562374114990234
		 6 -10.311159133911133 7 -1.3904905319213867 8 12.760819435119629 9 33.99957275390625
		 10 50.692485809326172 11 48.687118530273438 12 35.338802337646484 13 21.767120361328125
		 14 12.969169616699219 15 9.2791194915771484 16 9.9503269195556641 17 11.63383674621582
		 18 12.715356826782227 19 14.324034690856934 20 17.457033157348633 21 21.32972526550293
		 22 25.107078552246094 23 28.06239128112793 24 29.929943084716797 25 30.883544921875
		 26 31.268678665161133 27 31.253360748291016 28 30.979001998901367 29 30.68537712097168
		 30 30.566905975341797;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "6D759F32-4650-6402-ECBC-B0BF7D0A49D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 74.728139844130311 1 86.381785342754327
		 2 113.59909541536254 3 144.35224506869912 4 166.41690164131296 5 174.85058955883579
		 6 171.98928603568044 7 155.93360861795443 8 124.76788028303683 9 83.626510631316108
		 10 46.8634062467383 11 14.863860801216685 12 -15.604364288178127 13 -39.755617864351478
		 14 -54.002481501582537 15 -55.89890155311852 16 -45.46709874556214 17 -30.265622441541584
		 18 -16.906264765886068 19 -6.5387617805217593 20 3.1428272173713969 21 13.068885861839391
		 22 23.081600545657857 23 32.963918994198714 24 42.446693229753315 25 51.232008497578654
		 26 59.018997104224582 27 65.521294712108997 28 70.472810422399277 29 73.623180434058241
		 30 74.728139844130311;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY";
	rename -uid "CC653FE9-4E81-DFB7-97EE-D8A4D916763E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.5996607568730972 1 4.2883362993770362
		 2 5.0192059158395876 3 3.5404923055078168 4 0.64171329053393344 5 -0.80572869325253738
		 6 -0.03186882815551121 7 7.2137835059335984 8 17.227634194456073 9 18.068004695121392
		 10 9.3973620577039672 11 0.42770561722988826 12 -3.9725963584477011 13 -4.6229891138636381
		 14 -2.3474495692581083 15 2.8427533088632244 16 7.9977965969131875 17 8.6826272905926682
		 18 4.771737748807003 19 1.0867460477480679 20 -0.19830728522542077 21 -1.3382556268035661
		 22 -2.0977450467012773 23 -2.3374215392330102 24 -2.0204989275928473 25 -1.2105552305694656
		 26 -0.05620926186907426 27 1.2344357968245432 28 2.424515154814086 29 3.2798868330492206
		 30 3.5996607568730972;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX";
	rename -uid "19671B1C-48C2-53D8-FDC5-43A41E766FBB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -68.573234376474701 1 -70.477563984137817
		 2 -73.662799637871998 3 -75.638550279144766 4 -76.150315906780534 5 -73.85467259282423
		 6 -72.026360098807302 7 -70.854099158169348 8 -69.406070785090847 9 -71.537074244162724
		 10 -75.167265577527459 11 -76.827065592258279 12 -72.677112476012837 13 -69.331825767246926
		 14 -68.472321897478494 15 -69.493646620282021 16 -68.891448757747114 17 -66.22650447919149
		 18 -64.659236462170242 19 -65.071762906599574 20 -65.750062587402709 21 -66.461773239547441
		 22 -67.173865027754502 23 -67.824882317933032 24 -68.347127958138756 25 -68.690115609747437
		 26 -68.841386902298865 27 -68.832279944449013 28 -68.730605487514566 29 -68.620210500225127
		 30 -68.573234376474701;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "7061398E-4891-35F4-4133-579B5183DADB";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA";
	rename -uid "60EA7321-4C5C-8DFF-2FC1-22835837C654";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -42.795326232910156 1 -50.150199890136719
		 2 -66.375946044921875 3 -79.105377197265625 4 -80.517471313476563 5 -76.993972778320312
		 6 -74.498924255371094 7 -75.235397338867187 8 -70.727760314941406 9 -47.695198059082031
		 10 4.4017047882080078 11 40.490554809570313 12 52.133979797363281 13 56.714271545410156
		 14 59.082534790039062 15 59.259956359863281 16 56.394336700439453 17 50.34649658203125
		 18 42.802356719970703 19 34.432430267333984 20 25.215591430664062 21 15.409736633300781
		 22 5.5305032730102539 23 -4.1046657562255859 24 -13.215288162231445 25 -21.516128540039063
		 26 -28.734352111816406 27 -34.648239135742187 28 -39.069976806640625 29 -41.837062835693359
		 30 -42.795326232910156;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA";
	rename -uid "B5E5CBA5-4035-A444-B96D-66AB64474B3F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 58.386558532714844 1 57.310943603515625
		 2 54.581928253173828 3 51.712249755859375 4 51.212314605712891 5 53.942153930664063
		 6 58.108081817626953 7 64.368736267089844 8 76.811309814453125 9 98.249801635742188
		 10 116.91600036621094 11 110.59834289550781 12 99.166664123535156 13 90.495590209960937
		 14 81.383636474609375 15 72.054878234863281 16 63.845664978027344 17 57.97381591796875
		 18 54.354156494140625 19 52.4375 20 51.3255615234375 21 51.049427032470703 22 51.331943511962891
		 23 52.067527770996094 24 53.103767395019531 25 54.251243591308594 26 55.430938720703125
		 27 56.54827880859375 28 57.493270874023438 29 58.145492553710938 30 58.386558532714844;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA";
	rename -uid "D005D365-4F1C-F5DE-B76C-DD8352083D5D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -42.794830322265625 1 -40.822288513183594
		 2 -30.796239852905273 3 -9.5295696258544922 4 11.899919509887695 5 22.653060913085938
		 6 22.151388168334961 7 7.9866361618041992 8 -17.88630485534668 9 -47.923965454101563
		 10 -51.775283813476562 11 -28.004766464233398 12 -12.633699417114258 13 -4.938995361328125
		 14 -3.5191249847412109 15 -6.6729526519775391 16 -14.367383003234863 17 -24.158470153808594
		 18 -33.076995849609375 19 -40.737800598144531 20 -46.894092559814453 21 -51.254524230957031
		 22 -53.708217620849609 23 -54.477470397949219 24 -53.858932495117188 25 -52.194599151611328
		 26 -49.880706787109375 27 -47.349044799804688 28 -45.046871185302734 29 -43.405731201171875
		 30 -42.794830322265625;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "F2D37039-4C34-2DD0-6FED-F281610216A8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 166.04873736411326 1 148.28684074389128
		 2 103.83508899186504 3 37.714238107009351 4 -61.515278438808735 5 -103.65270768833368
		 6 -113.14139796213591 7 -100.83786161333936 8 -71.019845369449925 9 -43.260918080461636
		 10 12.226773917624863 11 86.157520030847721 12 123.58991404544017 13 105.06032970541871
		 14 77.668966528415751 15 68.085340774484592 16 65.955321255041596 17 62.827619600780238
		 18 55.087088569656615 19 43.172703741038397 20 29.609047766149811 21 13.451797387603941
		 22 8.0399532327288714 23 -10.485296276802742 24 -22.19403872439706 25 -29.052957513346705
		 26 -30.17469937075068 27 -26.950484304833452 28 -21.45236736185263 29 -16.245796832178772
		 30 -13.951262635886771;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY";
	rename -uid "D9A51BFE-4166-5971-0BAD-968EA4F579CB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 57.995092867432319 1 60.356124780253815
		 2 66.139852409334836 3 74.587918420177303 4 72.944691846756143 5 54.585115270381515
		 6 36.483282950139404 7 22.073618053943804 8 4.7693905560013459 9 -23.50832224964886
		 10 -36.430835077413555 11 12.47702690400074 12 57.527426444386016 13 63.183620528611037
		 14 56.763247364241529 15 43.097282851751814 16 31.940536453504247 17 27.145791079445427
		 18 29.166568313717736 19 38.572933987509188 20 55.012596464080808 21 75.902258423594745
		 22 96.791766067965455 23 112.25026538812712 24 119.06552074234524 25 120.38324741164519
		 26 120.7595865334919 27 120.94201766454354 28 121.28968783784197 29 121.7611714407325
		 30 122.00490713256767;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX";
	rename -uid "762A9583-4992-B58B-C543-CAA79B69FC3F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -75.317575734977908 1 -81.245491749834059
		 2 -96.614911338519633 3 -126.83350182604572 4 -195.64298842868581 5 -216.92514360790204
		 6 -211.78657427866588 7 -190.73270478659816 8 -163.57304435328248 9 -151.54910701074468
		 10 -167.03233157712975 11 -214.15469724469114 12 -204.54865273036134 13 -236.14125139811432
		 14 -280.55354619231485 15 -309.46963978224892 16 -328.71454478934419 17 -342.24252019003768
		 18 -349.70152278862292 19 -347.11624149051318 20 -335.43618678503697 21 -321.30141482821068
		 22 -295.51388862902326 23 -285.85371246043769 24 -276.86732792841684 25 -271.29671227149191
		 26 -266.87620382945573 27 -262.82703220133754 28 -259.1259212742313 29 -256.37601964201218
		 30 -255.31757573497794;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "948BCCF9-4EFB-C89C-D7C7-1E94015EA16B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -13.043968200683594 1 -11.630785942077637
		 2 -8.5980243682861328 3 -2.2561373710632324 4 6.2323899269104004 5 13.944928169250488
		 6 19.763496398925781 7 22.716938018798828 8 21.529434204101563 9 21.159040451049805
		 10 19.455076217651367 11 16.442058563232422 12 12.315706253051758 13 7.0521335601806641
		 14 2.1404600143432617 15 0.19074058532714844 16 -1.8439207077026367 17 -4.7118396759033203
		 18 -5.2840518951416016 19 -6.2875194549560547 20 -8.4724960327148437 21 -11.148632049560547
		 22 -13.428915023803711 23 -14.012495040893555 24 -14.314728736877441 25 -14.302940368652344
		 26 -14.080390930175781 27 -13.753947257995605 28 -13.417770385742187 29 -13.153578758239746
		 30 -13.043968200683594;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA";
	rename -uid "29BBEC5C-4261-47C9-710C-61B23821EDDB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 31.650505065917969 1 31.382255554199219
		 2 30.621963500976562 3 30.018861770629883 4 30.177045822143555 5 30.944341659545898
		 6 31.437005996704102 7 30.702264785766602 8 27.974874496459961 9 28.10255241394043
		 10 28.470151901245117 11 28.765840530395508 12 28.491281509399414 13 27.010349273681641
		 14 25.736417770385742 15 26.30540657043457 16 26.676412582397461 17 26.758111953735352
		 18 28.944927215576172 19 30.819496154785156 20 30.910457611083984 21 30.486093521118164
		 22 30.201698303222656 23 30.625053405761719 24 30.993690490722656 25 31.267436981201172
		 26 31.455738067626953 27 31.571292877197266 28 31.629776000976563 29 31.649265289306641
		 30 31.650505065917969;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA";
	rename -uid "E104C774-47C7-3D19-D0D0-35BBC12F76BA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 28.093341827392578 1 27.764369964599609
		 2 26.698930740356445 3 25.555717468261719 4 24.673759460449219 5 24.016151428222656
		 6 23.560043334960938 7 23.584192276000977 8 23.723098754882813 9 24.958908081054688
		 10 26.03759765625 11 26.680168151855469 12 26.722476959228516 13 26.072528839111328
		 14 25.047946929931641 15 24.318412780761719 16 23.591964721679688 17 22.891115188598633
		 18 22.63066291809082 19 22.483078002929688 20 22.449819564819336 21 22.535186767578125
		 22 22.828037261962891 23 23.533975601196289 24 24.356258392333984 25 25.237812042236328
		 26 26.102273941040039 27 26.880985260009766 28 27.511829376220703 29 27.936391830444336
		 30 28.093341827392578;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "C38FD29C-42B0-D2E9-C673-DEB72855EE7D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -27.76265023056359 1 -23.96094828400657
		 2 -16.227766211911039 3 -2.5301694507416563 4 10.758077056782465 5 13.979962502296967
		 6 6.5230741169733841 7 -6.933368578156677 8 -24.298710262138272 9 -24.155751450224074
		 10 -28.438860172197668 11 -37.075858582740857 12 -49.552490362629904 13 -66.895260324276123
		 14 -81.940501343205796 15 -84.263079031141359 16 -84.40135066099171 17 -82.107034557649797
		 18 -63.484192226355773 19 -43.013012473645603 20 -29.685065533498147 21 -24.340211339398568
		 22 -27.198327365971171 23 -29.298956713395704 24 -30.561732042177155 25 -30.806269286543781
		 26 -30.371812402979494 27 -29.592706598080781 28 -28.745349280831821 29 -28.057277838644836
		 30 -27.76265023056359;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "7C553562-4010-6B12-FA24-CD9012BBA1B2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -0.37342159744703818 1 -1.2798463748749525
		 2 -3.7896806220074408 3 -6.487462257538402 4 -7.8357967096846926 5 -9.3327490691449846
		 6 -13.24676510136486 7 -16.57310985580558 8 -15.949143021765963 9 -13.201954290428068
		 10 -10.805599913248823 11 -9.060518981877701 12 -7.9700738720993511 13 -7.280732036765067
		 14 -6.8976842670476346 15 -7.62963686058837 16 -8.4591870448292283 17 -9.3558415028385511
		 18 -11.546480035637359 19 -12.094025800894579 20 -11.191914033213498 21 -10.230586277953252
		 22 -9.5000240561562013 23 -8.2155310636109213 24 -6.732259284852649 25 -5.1772677076391984
		 26 -3.6890189321397839 27 -2.3749518173328674 28 -1.3267696045919533 29 -0.62931241940425175
		 30 -0.37342159744703818;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "0186946B-45F6-64F8-6D49-529F54AD3154";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.11792002677073997 1 -0.44807719522292444
		 2 -2.2829495360381773 3 -8.3676901686820422 4 -17.327180693780168 5 -25.623090091454845
		 6 -25.981763065210547 7 -17.783210953141918 8 -8.2304244389419434 9 -9.3245963931461713
		 10 -6.3186344186480712 11 -3.2592318256824573 12 0.46392103082583064 13 4.8708519091753644
		 14 8.7915359227932992 15 12.003161887896763 16 13.118552147900383 17 11.217400681563273
		 18 5.6750516005445348 19 -1.4597558668538368 20 -5.7831556134985744 21 -6.4436372561507502
		 22 -4.2256013653917002 23 -2.8407605288448288 24 -1.8367572225318864 25 -1.1847230069099788
		 26 -0.73460861061158422 27 -0.39224734413709228 28 -0.12619943253296723 29 0.053033008050831526
		 30 0.11792002677073997;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "FB49D4BB-4026-037D-844E-B89B29CB5776";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -13.382806777954102 1 -13.525802612304687
		 2 -13.888504981994629 3 -14.340414047241211 4 -14.730937004089355 5 -14.986116409301758
		 6 -15.163008689880371 7 -15.277775764465332 8 -15.027336120605469 9 -13.934076309204102
		 10 -12.137880325317383 11 -10.245325088500977 12 -8.730107307434082 13 -7.6567792892456055
		 14 -7.05987548828125 15 -6.9055519104003906 16 -7.1218109130859375 17 -7.6596846580505371
		 18 -8.3455104827880859 19 -9.0434465408325195 20 -9.7581195831298828 21 -10.421717643737793
		 22 -11.03209400177002 23 -11.562846183776855 24 -12.015102386474609 25 -12.408267021179199
		 26 -12.74000072479248 27 -13.009379386901855 28 -13.211838722229004 29 -13.339159965515137
		 30 -13.382806777954102;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA";
	rename -uid "163BFC64-4C33-D4F0-5BE8-E387716A15F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 16.259443283081055 1 16.059347152709961
		 2 15.649526596069336 3 15.154268264770508 4 14.381963729858398 5 13.048585891723633
		 6 11.078765869140625 7 9.0718746185302734 8 7.8083095550537109 9 7.6094512939453125
		 10 8.2963733673095703 11 9.5278282165527344 12 10.925077438354492 13 12.535270690917969
		 14 14.174100875854492 15 15.215457916259766 16 14.815311431884766 17 13.585529327392578
		 18 12.620920181274414 19 12.211147308349609 20 12.110363006591797 21 12.348501205444336
		 22 12.787065505981445 23 13.368047714233398 24 14.009881973266602 25 14.601919174194336
		 26 15.138006210327148 27 15.59840202331543 28 15.955854415893555 29 16.182519912719727
		 30 16.259443283081055;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA";
	rename -uid "D6F7042A-44A9-D8CE-E61A-9C8D86769B13";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -22.966213226318359 1 -23.230941772460937
		 2 -23.793052673339844 3 -24.322525024414063 4 -24.625526428222656 5 -24.674705505371094
		 6 -24.536718368530273 7 -24.355276107788086 8 -24.235910415649414 9 -24.311252593994141
		 10 -24.538963317871094 11 -24.759086608886719 12 -24.764188766479492 13 -24.430761337280273
		 14 -23.848884582519531 15 -23.342979431152344 16 -23.487281799316406 17 -24.060478210449219
		 18 -24.561258316040039 19 -24.942295074462891 20 -25.182479858398438 21 -25.302297592163086
		 22 -25.274042129516602 23 -25.133218765258789 24 -24.893043518066406 25 -24.559053421020508
		 26 -24.159355163574219 27 -23.738052368164062 28 -23.353292465209961 29 -23.073162078857422
		 30 -22.966213226318359;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "2C8B21F8-4114-F5BE-07E7-798637204B8C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 41.98109203764043 1 42.893715248074045
		 2 44.755690901551205 3 46.849580676155519 4 49.784347768919062 5 54.77099835450592
		 6 62.473584057825583 7 71.141706206540448 8 77.438354946427381 9 78.835404600360505
		 10 75.586203633739615 11 69.656518601475625 12 63.204548519797996 13 56.403519461524077
		 14 50.105283898126807 15 46.447906292166842 16 48.110924226313635 17 52.896525240147717
		 18 56.947325232817882 19 59.115238073174957 20 60.130940904211492 21 59.678427069572464
		 22 58.189390932089474 23 55.892139824468977 24 53.145229588192244 25 50.426649985127931
		 26 47.831383469831216 27 45.508459052987348 28 43.639666610155665 29 42.412599441794683
		 30 41.98109203764043;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "CDD2ABA7-4383-ABF8-E4BE-CCBA9D636773";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.4502778849200428 1 2.8978804360712269
		 2 1.7960643407737067 3 0.78813431185014082 4 -0.017627095714726534 5 -0.87657748224907805
		 6 -2.0127998532316269 7 -2.971925940753628 8 -3.0201716072639919 9 -2.3695217005499498
		 10 -1.4005852789387403 11 -0.39973441285861139 12 0.76752220660072878 13 2.6492791243181815
		 14 5.2073645950130363 15 7.304989690771019 16 6.6506224102302536 17 4.2645286444044848
		 18 2.3291319275437976 19 1.1483099568487314 20 0.48741098235457347 21 0.14985668919036829
		 22 0.060923618949647804 23 0.16205033474600966 24 0.43095585246613527 25 0.8552458288667294
		 26 1.4339476954686969 27 2.1072738744237736 28 2.7646720897096806 29 3.2602744777302082
		 30 3.4502778849200428;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "5C6DB60E-412A-9348-C4CC-26830D296572";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 15.345079559958704 1 14.668240661207408
		 2 13.144060046949763 3 11.710029780770046 4 11.141053584903513 5 11.48801788428359
		 6 12.069127912502086 7 11.74032433979267 8 10.390403035788916 9 9.3366488866443493
		 10 8.6927121508016842 11 8.508759610151758 12 8.8633620290191679 13 9.5773646427521602
		 14 9.9727877286443327 15 9.8827844304777805 16 9.8561452795295459 17 9.5756068720165786
		 18 8.8092179501739345 19 7.7205392478575385 20 6.6609492632944987 21 6.1005471149930646
		 22 6.2338150916435948 23 6.9366032372372413 24 8.0887259182226625 25 9.5603858320466344
		 26 11.177696323397941 27 12.745703483103563 28 14.077345007842295 29 14.999307695422118
		 30 15.345079559958704;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "88519D72-4539-5AA6-5E4E-F4B4E553897C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -19.994743347167969 1 -15.54008960723877
		 2 -5.2962474822998047 3 1.8504657745361328 4 1.6874580383300781 5 0.010074615478515625
		 6 1.2122993469238281 7 5.8448505401611328 8 7.9079799652099609 9 -0.35945510864257813
		 10 -18.775688171386719 11 -38.500850677490234 12 -49.009620666503906 13 -50.774017333984375
		 14 -48.497947692871094 15 -45.276390075683594 16 -42.679771423339844 17 -41.648235321044922
		 18 -42.691986083984375 19 -45.249744415283203 20 -47.834377288818359 21 -50.287078857421875
		 22 -51.949111938476563 23 -51.79437255859375 24 -48.904563903808594 25 -43.335750579833984
		 26 -36.435268402099609 27 -29.911525726318359 28 -24.696794509887695 29 -21.246875762939453
		 30 -19.994743347167969;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA";
	rename -uid "2E87A78F-4CFB-3876-04D6-34BAF121678C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 78.131423950195313 1 80.163101196289062
		 2 86.812789916992187 3 95.256736755371094 4 101.62761688232422 5 104.32368469238281
		 6 103.58888244628906 7 99.913154602050781 8 91.769180297851563 9 80.528114318847656
		 10 70.762138366699219 11 66.906539916992188 12 69.690353393554687 13 74.6839599609375
		 14 80.299613952636719 15 85.693290710449219 16 90.477264404296875 17 94.130142211914062
		 18 96.030830383300781 19 96.642616271972656 20 96.367462158203125 21 95.279678344726563
		 22 93.063484191894531 23 89.498397827148438 24 85.121871948242188 25 81.127021789550781
		 26 78.3975830078125 27 77.26483154296875 28 77.321678161621094 29 77.833419799804688
		 30 78.131423950195313;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA";
	rename -uid "085AF7BE-4FCE-207E-79CA-1785DCB67101";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 33.265228271484375 1 33.050994873046875
		 2 28.501054763793945 3 17.063732147216797 4 6.7386298179626465 5 2.3456931114196777
		 6 3.312828540802002 7 11.910331726074219 8 25.716506958007812 9 37.974720001220703
		 10 40.757804870605469 11 30.050500869750977 12 13.480739593505859 13 0.32067394256591797
		 14 -6.1962399482727051 15 -7.7162952423095703 16 -6.6079502105712891 17 -5.2987766265869141
		 18 -4.8867931365966797 19 -4.6295862197875977 20 -3.3040142059326172 21 -0.46721458435058594
		 22 4.2989778518676758 23 10.818220138549805 24 18.141101837158203 25 24.72071647644043
		 26 29.22248649597168 27 31.725854873657227 28 32.8868408203125 29 33.230224609375
		 30 33.265228271484375;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "C1B6C575-498C-B97A-B3C4-8EB627E8E163";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 96.957508482769384 1 110.0627148633683
		 2 133.53652859183299 3 145.31146523713124 4 141.76581059780577 5 136.15247597252301
		 6 130.76530632444025 7 129.23402940371344 8 125.88560517572422 9 100.27014249762949
		 10 63.597491244832057 11 33.122767717058146 12 8.4591481743864581 13 -11.404068505079177
		 14 -27.88310871363446 15 -38.736425777022902 16 -41.267998314869374 17 -40.207651126642844
		 18 -37.519017624461654 19 -31.156165612284138 20 -19.572889077449759 21 -3.2212455749975697
		 22 17.109478980351273 23 38.578548562473131 24 58.145003367224355 25 73.909630578328986
		 26 84.655506889855999 27 91.235333118076795 28 94.957545773829366 29 96.575025039223036
		 30 96.957508482769384;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "F2A6FFBC-4B3F-E203-4737-5FBBD8612199";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 4.6018997964344059 1 1.1730358510370968
		 2 -10.772899407674789 3 -22.627231969050435 4 -25.292671173722372 5 -22.332269294044817
		 6 -20.989586312736122 7 -19.779409074046729 8 -8.5002131299015691 9 3.8997830928215591
		 10 1.3596785127040418 11 -5.2885714742891503 12 -8.5663560145262529 13 -11.763903116229505
		 14 -14.013403779572684 15 -12.850283454477387 16 -9.6777506275313279 17 -7.2006962589129424
		 18 -6.7543095728587641 19 -7.661412286442089 20 -9.6086024585146248 21 -12.340331067311455
		 22 -13.038532475954327 23 -9.2315992135283711 24 -1.7789611073226987 25 5.7279025247052049
		 26 10.577272117529512 27 11.273043336606095 28 8.9264478652536248 29 6.0110605959887211
		 30 4.6018997964344059;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "A2124BC8-496B-7518-976D-7C9569E5FE06";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -59.251408682579516 1 -51.185982047493837
		 2 -36.123347706512014 3 -20.610961296720575 4 -2.9156766927966435 5 8.3898884358983565
		 6 10.061826813549692 7 -1.1931828732366914 8 -18.706688726963375 9 -34.66950194857219
		 10 -47.785598654918331 11 -51.137953047563776 12 -47.143628331640635 13 -39.764446528247412
		 14 -30.997245163578768 15 -23.339932574279889 16 -18.061768435360808 17 -14.725772844412134
		 18 -13.639015676311987 19 -14.709751912735092 20 -16.950053811712415 21 -21.161412084572397
		 22 -28.364652584065926 23 -37.6167897810952 24 -46.034153534982941 25 -51.92129058949179
		 26 -55.908906633100408 27 -58.470514422995414 28 -59.516885389755181 29 -59.487540250103201
		 30 -59.251408682579516;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "30CE025C-475E-4B3D-0683-46928468AEBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -48.695053100585937 1 -53.581077575683594
		 2 -61.705204010009766 3 -63.502101898193359 4 -58.873458862304688 5 -55.187068939208984
		 6 -55.570980072021484 7 -60.06512451171875 8 -56.471046447753906 9 -32.415664672851563
		 10 0.25260639190673828 11 20.943874359130859 12 30.387397766113281 13 35.865421295166016
		 14 39.563526153564453 15 41.016632080078125 16 38.547645568847656 17 31.892307281494141
		 18 23.453714370727539 19 14.618824005126953 20 5.5370264053344727 21 -3.5605359077453613
		 22 -12.232678413391113 23 -20.270790100097656 24 -27.52398681640625 25 -33.8482666015625
		 26 -39.119373321533203 27 -43.268413543701172 28 -46.260154724121094 29 -48.077541351318359
		 30 -48.695053100585937;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA";
	rename -uid "1BAE6B4E-43BA-EA33-0CB7-A09805C52E26";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -29.12042236328125 1 -25.45599365234375
		 2 -13.781183242797852 3 2.6862506866455078 4 14.617525100708008 5 18.556674957275391
		 6 15.487483978271484 7 0.34400844573974609 8 -26.491146087646484 9 -46.344917297363281
		 10 -42.554595947265625 11 -26.79481315612793 12 -16.372158050537109 13 -12.923816680908203
		 14 -14.350347518920898 15 -19.290946960449219 16 -27.236730575561523 17 -35.774555206298828
		 18 -42.201690673828125 19 -46.644035339355469 20 -49.538433074951172 21 -50.760456085205078
		 22 -50.327732086181641 23 -48.54583740234375 24 -45.753650665283203 25 -42.304149627685547
		 26 -38.582912445068359 27 -34.997215270996094 28 -31.962669372558594 29 -29.882820129394531
		 30 -29.12042236328125;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA";
	rename -uid "29FEFB50-4DCD-6C34-7299-12AF1E9D8856";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 75.048683166503906 1 73.170623779296875
		 2 68.296684265136719 3 62.043464660644531 4 56.067634582519531 5 51.27734375 6 48.27203369140625
		 7 49.847179412841797 8 61.907440185546875 9 82.0181884765625 10 96.986457824707031
		 11 99.833297729492188 12 95.626510620117188 13 89.500198364257813 14 82.439750671386719
		 15 74.773246765136719 16 67.756935119628906 17 62.8658447265625 18 60.818885803222656
		 19 60.920433044433594 20 61.581504821777344 21 62.852279663085938 22 64.464508056640625
		 23 66.311660766601562 24 68.236129760742188 25 70.047447204589844 26 71.676986694335938
		 27 73.057289123535156 28 74.122398376464844 29 74.807159423828125 30 75.048683166503906;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "F9148656-4494-6D6C-57B1-3296F2DA1BCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 23.32502166384155 1 12.420084280130276
		 2 -15.807653741384879 3 -52.537816664215811 4 -83.30684728180205 5 -100.87186208960834
		 6 -109.39496967926061 7 -116.53304342041956 8 -120.90599433064227 9 -83.703298923906857
		 10 23.385565491528457 11 85.77398060592968 12 99.333233066987091 13 110.61318761137615
		 14 118.73910266137571 15 124.42273056725409 16 125.57799724537169 17 122.00201613429314
		 18 115.11835706590826 19 106.55027214500969 20 97.685613329348456 21 88.615308654046984
		 22 79.395044559576405 23 70.06474946413627 24 60.701220577582696 25 51.487441102468317
		 26 42.764147946200197 27 35.024507988497518 28 28.841763173594426 29 24.777292332085992
		 30 23.32502166384155;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "91929CFF-4E24-B5EA-BB7D-A39ED00106A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -48.830938122333585 1 -45.869208593137039
		 2 -38.508256026721931 3 -27.94783982259537 4 -12.627967213603188 5 6.9764352040329882
		 6 26.338871287020506 7 40.831322179262777 8 42.178763225093853 9 46.508680868412014
		 10 62.479697289470415 11 28.749179413940539 12 9.2250254277451926 13 2.791116243523347
		 14 -2.3836431504900601 15 -6.6047339909903959 16 -9.6867206195863673 17 -12.286928710948288
		 18 -16.528653336479138 19 -22.116977571138587 20 -27.229310580748574 21 -31.899007911222203
		 22 -36.117371285096141 23 -39.830603795660899 24 -42.953587416874356 25 -45.401625553715199
		 26 -47.131016918168967 27 -48.178796055664073 28 -48.675868617964426 29 -48.822241346063777
		 30 -48.830938122333585;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "20333C4F-4481-DA13-C57E-A6B07DECDAB0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -47.787920050703022 1 -51.499136492798257
		 2 -57.900598895008798 3 -60.981832161301185 4 -61.398231116181414 5 -63.609341463325933
		 6 -71.74423621410827 7 -97.904047075250091 8 -141.36595631278368 9 -166.85363702865286
		 10 -110.07474129693753 11 -58.624010411071652 12 -41.405101408661658 13 -35.844187692941034
		 14 -35.401176494334813 15 -39.594873874935388 16 -46.60495222282573 17 -53.81071265520044
		 18 -58.698354771602418 19 -61.306728181348859 20 -63.233540644553742 21 -64.380897465777622
		 22 -64.63464575895722 23 -63.90613707919799 24 -62.188307445843016 25 -59.613719157606702
		 26 -56.487108372168059 27 -53.259822117039889 28 -50.441361338059927 29 -48.497207054235282
		 30 -47.787920050703022;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "EFCBB33E-4620-A1C9-9BF3-10BAB0D7B921";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA";
	rename -uid "FA96744C-43F3-BD62-BDBA-648D8C12B3DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -24.125894546508789 1 -23.908048629760742
		 2 -23.24174690246582 3 -21.970661163330078 4 -20.012458801269531 5 -17.519529342651367
		 6 -14.753671646118164 7 -12.094311714172363 8 -9.8900318145751953 9 -8.5200710296630859
		 10 -7.1730446815490723 11 -6.1302633285522461 12 -5.5385584831237793 13 -5.1778602600097656
		 14 -5.1632089614868164 15 -5.5263533592224121 16 -6.6810994148254395 17 -8.7324199676513672
		 18 -11.217430114746094 19 -13.749795913696289 20 -15.974620819091797 21 -17.985027313232422
		 22 -19.628725051879883 23 -20.945579528808594 24 -21.993738174438477 25 -22.801170349121094
		 26 -23.3804931640625 27 -23.764875411987305 28 -23.99119758605957 29 -24.098489761352539
		 30 -24.125894546508789;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA";
	rename -uid "AFB7C0A1-49AB-96C3-AF3F-AB9D0E498E43";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 54.945686340332031 1 54.721103668212891
		 2 54.127670288085938 3 53.242012023925781 4 52.128711700439453 5 50.887073516845703
		 6 49.608940124511719 7 48.4129638671875 8 47.419639587402344 9 46.890079498291016
		 10 46.749351501464844 11 46.698238372802734 12 46.39129638671875 13 45.913475036621094
		 14 45.560874938964844 15 45.396461486816406 16 45.699802398681641 17 46.525787353515625
		 18 47.63360595703125 19 48.930168151855469 20 49.997589111328125 21 51.067970275878906
		 22 52.02496337890625 23 52.893688201904297 24 53.635490417480469 25 54.170539855957031
		 26 54.535030364990234 27 54.762519836425781 28 54.885635375976563 29 54.936119079589844
		 30 54.945686340332031;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA";
	rename -uid "2BB6C4A1-46A5-4AD9-32D3-28B0BDC9CC1A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.4979124069213867 1 2.1696028709411621
		 2 1.3911368846893311 3 0.48718339204788208 4 -0.28003883361816406 5 -0.74588894844055176
		 6 -0.79609811305999756 7 -0.82284915447235107 8 -1.3210878372192383 9 -1.9418377876281738
		 10 -2.6536898612976074 11 -3.3403310775756836 12 -3.9169468879699707 13 -4.3449869155883789
		 14 -4.8189382553100586 15 -5.4462900161743164 16 -6.2033014297485352 17 -7.0791854858398437
		 18 -7.9512534141540527 19 -8.6269302368164062 20 -8.8654766082763672 21 -8.5727672576904297
		 22 -7.6995830535888672 23 -6.4134726524353027 24 -4.8654050827026367 25 -3.1841225624084473
		 26 -1.5030336380004883 27 0.042640209197998047 28 1.3161139488220215 29 2.1800146102905273
		 30 2.4979124069213867;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ";
	rename -uid "7A54695D-435B-7947-062B-BE80C747A7E1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -4.1708668588936879 1 -5.1786088388147933
		 2 -8.0501956127601506 3 -12.409152936904194 4 -17.071235451032972 5 -20.405982778793291
		 6 -21.374360703806637 7 -19.455203518721824 8 -15.599195384483789 9 -11.246965172584988
		 10 -7.3196190635272105 11 -3.9756746158756919 12 -0.8358883575261199 13 1.9729048275349677
		 14 4.2558290053849284 15 5.965017242287848 16 7.0111826187797579 17 7.4091786952376024
		 18 7.2682781250990889 19 6.6715097917919532 20 5.7952843037225135 21 4.6928174379711054
		 22 3.4274602475632556 23 2.0715421845735085 24 0.70189673364967364 25 -0.60551758203182438
		 26 -1.7821800426523562 27 -2.7701421411279501 28 -3.5229035577037044 29 -4.0021013815316389
		 30 -4.1708668588936879;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY";
	rename -uid "91A529D9-4E77-E3A5-E151-4CA02FFFFAF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 15.334574372843704 1 16.003702412981912
		 2 17.495693566581267 3 18.819906627664128 4 19.24322485106924 5 19.004114538717992
		 6 18.897426441630721 7 18.813193308433515 8 18.041321521525326 9 16.500829668135935
		 10 14.695204414010144 11 13.372142563097357 12 12.448216779170938 13 11.301986706132089
		 14 10.124157909597296 15 9.369552337702947 16 9.4315991134223633 17 10.121245428209612
		 18 10.874278935641302 19 11.63634537896529 20 12.449806635601622 21 13.242229543175307
		 22 13.950963362829125 23 14.530613048257948 24 14.957608813018858 25 15.231171009001793
		 26 15.370387756859119 27 15.409240439181957 28 15.38934051948635 29 15.352610003152202
		 30 15.334574372843704;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX";
	rename -uid "53F54CF0-4AB3-F1F3-F2E5-31B04B28B5C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.386871940428331 1 -1.7327162042177742
		 2 -11.835709224738824 3 -24.492159829580938 4 -36.034688040585287 5 -43.680129815588025
		 6 -45.784279320685208 7 -41.512920846974133 8 -32.514289120217455 9 -20.489425682912376
		 10 -7.127178833861743 11 5.9336549592160557 12 17.492600165740431 13 26.849789427197621
		 14 33.607977642783418 15 37.570826224371196 16 38.226771748895445 17 36.708961377297086
		 18 34.712182786366519 19 32.307411655647762 20 29.436491293250473 21 26.206462741310165
		 22 22.731599199351919 23 19.136052371977868 24 15.553648160485073 25 12.125874226050419
		 26 8.9981133187471816 27 6.3166993601367487 28 4.2264677792082193 29 2.8698460901640028
		 30 2.386871940428331;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA";
	rename -uid "EFD758FE-4F6A-C488-4DAF-E1BD5CF0A7BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -32.560287475585938 1 -32.919490814208984
		 2 -34.865123748779297 3 -38.503349304199219 4 -41.404159545898437 5 -41.779747009277344
		 6 -39.705909729003906 7 -34.359306335449219 8 -26.354778289794922 9 -19.945529937744141
		 10 -17.039403915405273 11 -15.816045761108398 12 -13.055952072143555 13 -9.0567741394042969
		 14 -4.9851827621459961 15 -1.4798836708068848 16 0.45345687866210938 17 0.12885856628417969
		 18 -2.1732888221740723 19 -5.6973171234130859 20 -9.4977054595947266 21 -13.500589370727539
		 22 -17.374887466430664 23 -20.979116439819336 24 -24.20361328125 25 -26.940164566040039
		 26 -29.110715866088867 27 -30.708145141601563 28 -31.772274017333984 29 -32.369171142578125
		 30 -32.560287475585938;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA";
	rename -uid "5D41A525-4C68-1E89-1F09-98B5C360B48D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 98.593429565429687 1 98.338623046875 2 97.276313781738281
		 3 94.910324096679688 4 91.507904052734375 5 88.360023498535156 6 86.587562561035156
		 7 87.27532958984375 8 89.221626281738281 9 90.103775024414063 10 89.65087890625 11 89.330848693847656
		 12 89.462722778320313 13 89.429054260253906 14 89.247360229492188 15 88.8778076171875
		 16 88.659355163574219 17 88.91033935546875 18 89.744583129882813 19 91.110816955566406
		 20 92.3798828125 21 93.7281494140625 22 94.984710693359375 23 96.129104614257813
		 24 97.0909423828125 25 97.774726867675781 26 98.216697692871094 27 98.463760375976563
		 28 98.5709228515625 29 98.595916748046875 30 98.593429565429687;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA";
	rename -uid "0623A586-4A04-AA90-525A-D8BD4626995B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -1.5506343841552734 1 -2.2386875152587891
		 2 -3.6745424270629883 3 -3.7948517799377441 4 -2.0432877540588379 5 -0.70523977279663086
		 6 -1.2752528190612793 7 -3.4772944450378418 8 -4.3713197708129883 9 -2.3003330230712891
		 10 -0.49323844909667969 11 -2.3110599517822266 12 -6.0698533058166504 13 -8.6684150695800781
		 14 -10.226998329162598 15 -11.692010879516602 16 -13.55599308013916 17 -15.9381103515625
		 18 -18.091751098632812 19 -19.621532440185547 20 -20.478538513183594 21 -20.461196899414063
		 22 -19.451736450195313 23 -17.602298736572266 24 -15.107739448547363 25 -12.19611930847168
		 26 -9.1425809860229492 27 -6.2483644485473633 28 -3.8216400146484375 29 -2.1620979309082031
		 30 -1.5506343841552734;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ";
	rename -uid "992C6A0D-4C5C-035B-4708-A097F8DBDEE2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -30.995248267722573 1 -31.163946954393516
		 2 -34.600490206897398 3 -43.324021380823396 4 -53.085411152451968 5 -59.694735075626198
		 6 -61.695911978396026 7 -55.469249796065164 8 -42.527393621870303 9 -33.231864496116742
		 10 -33.662682938557829 11 -36.967881284658333 12 -34.461872863462602 13 -28.356036948277666
		 14 -20.854953028757269 15 -13.014274117991635 16 -5.9362190310329082 17 -1.2722835105068597
		 18 -0.078638264807413538 19 -1.5987735884097345 20 -4.3954319275481994 21 -8.093963199746673
		 22 -12.278844265683823 23 -16.532186172242518 24 -20.491398491356243 25 -23.898824122837382
		 26 -26.619083143131 27 -28.626853361541226 28 -29.973255276651059 29 -30.741647129159528
		 30 -30.995248267722573;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY";
	rename -uid "AEAE64DF-4CA4-E589-28D0-EABE114E3C9B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -4.1647232103758451 1 -2.9961551288882937
		 2 -0.46914373398820741 3 -0.89394557661776275 4 -5.4404351633414967 5 -8.6783152460638284
		 6 -7.181153156293548 7 -2.1651198811368086 8 -1.5675813492275612 9 -9.0603615720476434
		 10 -16.54274534271487 11 -15.268016584486558 12 -9.2933830072900268 13 -5.2810832877163616
		 14 -3.2356056599692176 15 -1.4630667610352164 16 1.032575698711081 17 4.5245518236413167
		 18 7.5680537909645755 19 9.615306521482248 20 11.11339509546794 21 11.827097940510413
		 22 11.615210452900959 23 10.463597913589215 24 8.4938163250044809 25 5.9421598784394458
		 26 3.1198608793700568 27 0.36997667593555777 28 -1.9667439868214907 29 -3.5728560214043199
		 30 -4.1647232103758451;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX";
	rename -uid "ED5721AA-4E55-ECB7-9AA0-C98C6CF1A57D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.47961850936799472 1 -10.88171195884768
		 2 -37.192785220982358 3 -66.606042133022854 4 -86.937645399845508 5 -94.296255666969145
		 6 -91.81970241702922 7 -77.163265580783559 8 -50.704867513396941 9 -18.053474940610414
		 10 15.675925430859474 11 43.540236499964777 12 60.346755481180601 13 68.101512562359645
		 14 69.036145722167532 15 65.831225171584592 16 59.135270765675827 17 51.330623634990864
		 18 45.041557081318118 19 39.806995129226713 20 34.507446098403719 21 29.172231876531765
		 22 23.91320464512555 23 18.898471509579082 24 14.302174829363898 25 10.260899698945513
		 26 6.8591783755628439 27 4.1431318767220802 28 2.145681375006089 29 0.90658001278569289
		 30 0.47961850936799472;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA";
	rename -uid "929D98B5-4A2B-E626-D0E3-91B5655EFFDF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -18.414773941040039 1 -18.236669540405273
		 2 -17.775680541992187 3 -14.95013427734375 4 -8.7445268630981445 5 -0.95510721206665039
		 6 6.8363733291625977 7 13.043097496032715 8 16.12870979309082 9 15.972179412841797
		 10 15.741472244262695 11 15.482584953308105 12 15.249013900756836 13 15.076263427734375
		 14 14.183178901672363 15 12.958208084106445 16 10.921762466430664 17 7.221369743347168
		 18 1.4853949546813965 19 -5.7164320945739746 20 -12.222169876098633 21 -16.9117431640625
		 22 -18.731298446655273 23 -18.750755310058594 24 -18.735992431640625 25 -18.693302154541016
		 26 -18.630504608154297 27 -18.557838439941406 28 -18.48802375793457 29 -18.435419082641602
		 30 -18.414773941040039;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA";
	rename -uid "E01E662A-4635-8A13-3A11-46A1AF28716C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 10.392141342163086 1 10.472504615783691
		 2 10.623923301696777 3 12.311683654785156 4 15.262638092041016 5 16.729160308837891
		 6 15.460118293762207 7 12.083505630493164 8 6.8158674240112305 9 6.9220151901245117
		 10 6.8931417465209961 11 6.6661472320556641 12 6.2475519180297852 13 5.7374143600463867
		 14 6.4234170913696289 15 7.5003128051757813 16 7.9015111923217773 17 7.4579324722290039
		 18 7.3534870147705078 19 8.5162725448608398 20 9.1360025405883789 21 9.1340980529785156
		 22 8.5271711349487305 23 8.7705755233764648 24 9.067845344543457 25 9.3837509155273437
		 26 9.6911602020263672 27 9.9665250778198242 28 10.188657760620117 29 10.337449073791504
		 30 10.392141342163086;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA";
	rename -uid "30340F9E-4902-F298-999F-2D9AF30F779C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 22.760416030883789 1 22.674100875854492
		 2 22.431097030639648 3 22.452199935913086 4 22.886329650878906 5 23.652780532836914
		 6 24.697294235229492 7 25.523141860961914 8 25.269092559814453 9 25.462047576904297
		 10 25.700485229492187 11 25.932018280029297 12 26.120132446289063 13 26.254291534423828
		 14 26.182733535766602 15 25.934370040893555 16 25.559587478637695 17 25.045444488525391
		 18 24.25225830078125 19 23.160806655883789 20 22.238941192626953 21 21.678791046142578
		 22 21.591251373291016 23 21.760709762573242 24 21.94671630859375 25 22.138132095336914
		 26 22.324184417724609 27 22.49299430847168 28 22.631492614746094 29 22.725606918334961
		 30 22.760416030883789;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "334F4DA9-4E5B-FF59-3EB5-579AC7392D78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -4.7693968548181977e-006 1 6.585162748762948e-006
		 2 -4.7693968548181977e-006 3 3.0951251133396944 4 9.3262938917848093 5 12.828871512388961
		 6 12.290741489802331 7 8.7625304557557033 8 7.6463699734985293e-006 9 -8.554254639741213e-006
		 10 -1.1015613048242278e-005 11 1.0446679335516967e-005 12 1.3246989360332607e-005
		 13 8.40092856643425e-006 14 6.585162748762948e-006 15 1.2262441991977003e-005 16 3.4044583317175197
		 17 11.137317694433724 18 19.442932997990521 19 24.71409988802225 20 20.993938936829654
		 21 11.471394779550636 22 3.509047877084813 23 -2.3846988958068706e-006 24 1.4768155559796793e-006
		 25 -4.430451346782598e-006 26 1.0523341372150573e-005 27 2.8769714225967563e-006
		 28 1.9690882178966232e-006 29 1.4768153260319438e-006 30 -4.7693968548181977e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY";
	rename -uid "BE6119AE-4687-BD67-9A43-D08F94C8CFA9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -29.162099886933031 1 -29.16209727075309
		 2 -29.162099886933031 3 -27.553142513786636 4 -26.289918630362859 5 -26.619741998589674
		 6 -26.525183638365821 7 -26.312194684399646 8 -29.162108449305116 9 -29.162133619399352
		 10 -29.162108449304593 11 -29.162113681663282 12 -29.162108449304633 13 -29.162097270752774
		 14 -29.16209727075309 15 -29.162097971749386 16 -29.119073900239304 17 -28.700883813568179
		 18 -27.752983602470152 19 -26.880575799470527 20 -27.518246065704847 21 -28.672790074008116
		 22 -29.116387385997054 23 -29.162099886933138 24 -29.162097270753289 25 -29.162118213028805
		 26 -29.162111065484016 27 -29.162116297842605 28 -29.162105833125842 29 -29.162092038392917
		 30 -29.162099886933031;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX";
	rename -uid "EC8AD308-471D-F543-9543-AD88EFC1B33D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 4.7693968465785991e-006 1 1.8157658135515968e-006
		 2 4.7693968465785991e-006 3 3.3504787665023548 4 10.029024262309816 5 13.771467942120326
		 6 13.194409723340817 7 9.4227215008690983 8 -9.0465243672930943e-006 9 5.7539456264809726e-006
		 10 1.5216078057959954e-005 11 -6.2462153456127831e-006 12 -3.4459051362989454e-006
		 13 8.4009285664342602e-006 14 1.8157658135515968e-006 15 7.3923486939053022e-014
		 16 -1.6581854964677414 17 -5.4009018368806405 18 -9.3346367384590057 19 -11.755064468665804
		 20 -10.054104117586437 21 -5.5612535193638761 22 -1.709087443919755 23 2.3846988874579146e-006
		 24 -5.6772798485127044e-006 25 1.7031844756647575e-005 26 -1.3323651052423828e-005
		 27 -4.277126237718684e-006 28 -7.5697072567424919e-006 29 -5.6772800285146528e-006
		 30 4.7693968465785991e-006;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA";
	rename -uid "5EC238DC-4286-0AE9-E74B-55AE7B5CC12E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -31.231805801391602 1 -31.281322479248047
		 2 -31.406246185302734 3 -31.561367034912109 4 -31.675254821777344 5 -31.666316986083984
		 6 -31.462245941162109 7 -31.051975250244141 8 -30.505870819091797 9 -29.870882034301758
		 10 -29.229116439819336 11 -28.683431625366211 12 -28.291030883789063 13 -28.071384429931641
		 14 -27.985746383666992 15 -27.987663269042969 16 -28.077932357788086 17 -28.227499008178711
		 18 -28.413858413696289 19 -28.656625747680664 20 -28.961324691772461 21 -29.313314437866211
		 22 -29.68787956237793 23 -30.046918869018555 24 -30.365940093994141 25 -30.63585090637207
		 26 -30.854490280151367 27 -31.021896362304687 28 -31.139350891113281 29 -31.208786010742188
		 30 -31.231805801391602;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA";
	rename -uid "0E903C9D-49FB-994F-95CC-05B943848A35";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 9.823974609375 1 9.876734733581543 2 9.9808635711669922
		 3 10.061116218566895 4 10.100701332092285 5 10.153989791870117 6 10.305360794067383
		 7 10.62376880645752 8 11.052704811096191 9 11.479358673095703 10 11.809104919433594
		 11 11.99681568145752 12 12.055781364440918 13 12.02070140838623 14 11.955911636352539
		 15 11.913968086242676 16 11.911726951599121 17 11.941445350646973 18 11.972842216491699
		 19 11.983512878417969 20 11.94959545135498 21 11.848115921020508 22 11.669155120849609
		 23 11.431336402893066 24 11.15367603302002 25 10.85427188873291 26 10.552993774414062
		 27 10.273059844970703 28 10.040412902832031 29 9.8820667266845703 30 9.823974609375;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA";
	rename -uid "FFE24D3E-4FBB-CD20-C61F-6EADA16435AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -21.009696960449219 1 -21.073732376098633
		 2 -21.218034744262695 3 -21.366514205932617 4 -21.46466064453125 5 -21.503208160400391
		 6 -21.513238906860352 7 -21.578977584838867 8 -21.740743637084961 9 -21.953020095825195
		 10 -22.150827407836914 11 -22.274528503417969 12 -22.30134391784668 13 -22.242294311523438
		 14 -22.15880012512207 15 -22.105279922485352 16 -22.109386444091797 17 -22.158084869384766
		 18 -22.213188171386719 19 -22.255653381347656 20 -22.263681411743164 21 -22.216276168823242
		 22 -22.107767105102539 23 -21.959131240844727 24 -21.786518096923828 25 -21.603645324707031
		 26 -21.424219131469727 27 -21.261989593505859 28 -21.130340576171875 29 -21.042028427124023
		 30 -21.009696960449219;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "EAF0F27D-49F3-4299-85FD-6CAE19468C6F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -1.1890681917998869e-005 1 -1.5483364242649528e-005
		 2 -3.3245563462489787e-006 3 -4.1601628946431909e-006 4 -5.5409315402119076e-006
		 5 -1.3552959219787188e-005 6 0 7 -1.1618105155587328e-005 8 -1.7413759084152409e-005
		 9 3.5926796550707551e-006 10 -1.9898254987564082e-005 11 1.7958929980808023e-005
		 12 -7.1853571667631704e-006 13 -1.3566349306146503e-005 14 -3.038585349142084e-006
		 15 1.8790068320456044e-005 16 1.7404840709608624e-005 17 1.3539575386768215e-005
		 18 1.0492067018842921e-005 19 -1.3763081571765372e-006 20 1.0496529033996914e-005
		 21 -5.8313624850255583e-006 22 1.0223945249910766e-005 23 8.0120332995740328e-006
		 24 4.1467715356677055e-006 25 -1.9348622395005395e-006 26 9.3972647784394607e-006
		 27 1.4924804750902376e-005 28 -1.6596010709299788e-005 29 1.3825542890008839e-005
		 30 -1.1890681917998869e-005;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY";
	rename -uid "1DBDADA4-4976-C3C3-D336-0084D6A862F2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 31.960573111769595 1 31.960595280596703
		 2 31.960584237800553 3 31.960605179961199 4 31.960605179961277 5 31.960569388742599
		 6 31.960573111770422 7 31.960613831150301 8 31.960573111768813 9 31.960598982104862
		 10 31.960569388741746 11 31.960578061452946 12 31.960575586612524 13 31.960589187481325
		 14 31.960585485979717 15 31.960583011136368 16 31.960574338428621 17 31.960575586611736
		 18 31.960576813272365 19 31.960575586612645 20 31.960596507262125 21 31.960589187481197
		 22 31.960571863586768 23 31.96057806145453 24 31.960586712642701 25 31.960573111770401
		 26 31.960578061454459 27 31.960578061453734 28 31.960576813271487 29 31.960578061453813
		 30 31.960573111769595;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX";
	rename -uid "A61B5788-438C-D14E-8D94-FEBE0351D631";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -1.0509911110621907e-005 1 -1.0650670761113959e-005
		 2 -1.1609175227475566e-005 3 -2.0729396559324296e-005 4 -1.9348627021800507e-005
		 5 -1.6314498776476037e-005 6 0 7 -1.576041385920676e-005 8 -4.9868316140409769e-006
		 9 1.5733655082520585e-014 10 -1.2578608205874883e-006 11 -5.5141554816634176e-006
		 12 -2.2897511173102411e-014 13 -3.4968278296247959e-005 14 1.7941078963081268e-006
		 15 -2.6118600323513207e-006 16 -7.4490210002548944e-006 17 -2.3392776895270544e-006
		 18 -1.2981022768945475e-005 19 7.598695275662066e-006 20 -6.7630957118115439e-006
		 21 -3.896983429386688e-005 22 -1.5126013377748658e-006 23 -3.034123323153664e-006
		 24 2.0756167852564895e-006 25 -1.0205071398087008e-014 26 1.8030318603891268e-006
		 27 2.497878550334053e-006 28 -2.073832038958539e-005 29 1.1064004214177226e-005 30 -1.0509911110621906e-005;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "4FF344E7-463C-2C0D-C993-FCB12315401C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -33.464076995849609 1 -29.373908996582031
		 2 -21.720983505249023 3 -18.447181701660156 4 -20.998722076416016 5 -23.310922622680664
		 6 -22.02155876159668 7 -16.0107421875 8 -10.519937515258789 9 -13.845709800720215
		 10 -24.010236740112305 11 -32.431934356689453 12 -34.297992706298828 13 -31.628669738769531
		 14 -27.391029357910156 15 -23.04231071472168 16 -19.794178009033203 17 -18.521854400634766
		 18 -19.534645080566406 19 -22.146175384521484 20 -24.933753967285156 21 -27.84019660949707
		 22 -30.475019454956055 23 -32.541938781738281 24 -33.912796020507813 25 -34.598312377929687
		 26 -34.7152099609375 27 -34.450225830078125 28 -34.014102935791016 29 -33.625102996826172
		 30 -33.464076995849609;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "69BAF953-4240-5350-2662-EEB1E18C065B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 93.607086181640625 1 94.99298095703125
		 2 98.3795166015625 3 101.91408538818359 4 103.6513671875 5 103.54185485839844 6 102.73013305664062
		 7 101.23175048828125 8 96.882865905761719 9 89.459342956542969 10 82.965995788574219
		 11 81.596534729003906 12 84.277961730957031 13 87.610824584960937 14 90.837265014648438
		 15 93.655075073242188 16 96.080902099609375 17 98.090377807617188 18 99.548736572265625
		 19 100.66238403320312 20 101.33408355712891 21 101.59377288818359 22 101.1719970703125
		 23 100.22975921630859 24 98.9281005859375 25 97.429733276367188 26 96.013771057128906
		 27 94.930130004882813 28 94.214065551757812 29 93.763870239257813 30 93.607086181640625;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "62369118-4A6A-6DA7-4F31-EBB7F18EBA15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 21.523422241210938 1 20.906454086303711
		 2 16.041990280151367 3 6.9407358169555664 4 0.41166448593139648 5 -1.4370884895324707
		 6 -0.95793485641479492 7 3.0006029605865479 8 11.822232246398926 9 20.736879348754883
		 10 21.201364517211914 11 12.553014755249023 12 2.0983810424804687 13 -4.693364143371582
		 14 -7.6945233345031738 15 -8.7383251190185547 16 -8.5153045654296875 17 -8.175567626953125
		 18 -8.0729541778564453 19 -7.6054887771606445 20 -6.4158039093017578 21 -4.3478012084960938
		 22 -1.3494424819946289 23 2.2759265899658203 24 6.1651191711425781 25 10.001058578491211
		 26 13.55402946472168 27 16.688333511352539 28 19.225767135620117 29 20.909948348999023
		 30 21.523422241210938;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "A6741F56-4061-5AF2-88F9-7888658903AB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -48.919929154046095 1 -48.72049575732192
		 2 -52.817700663002753 3 -63.493298941113288 4 -74.416723653672705 5 -80.78658401205179
		 6 -79.584338577702184 7 -67.821040024245178 8 -52.984428984524648 9 -38.038304213490683
		 10 -14.984722199474639 11 19.128843987217682 12 52.270931589444167 13 75.324217809257391
		 14 85.939643600628372 15 87.368168724822667 16 85.235810947629432 17 82.909127508417967
		 18 82.166012677216372 19 82.660317635873284 20 82.261907361642741 21 80.191712344859738
		 22 75.263049614987153 23 66.073176291750087 24 51.380824534196819 25 30.692919806245225
		 26 6.2647509233233594 27 -16.795132171366792 28 -34.295309200941851 29 -45.134443812759436
		 30 -48.919929154046095;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "3697A68D-45AD-02FC-328B-12A015E577B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 40.89497457285561 1 38.855267475422998
		 2 29.295399340556489 3 16.357443189307602 4 4.9111982831052696 5 -1.8953646626240948
		 6 -2.0819042304197564 7 3.1976843475669772 8 12.493368400324778 9 22.198843845519175
		 10 31.082082909182589 11 38.421155079078233 12 38.105167497614829 13 33.151261987835319
		 14 26.47320669916509 15 19.682717351946767 16 13.712693379185454 17 9.6443629646693552
		 18 8.5585370598595869 19 9.790732151222505 20 12.128514466039377 21 15.492240417367404
		 22 20.060880028765386 23 26.998924081372607 24 35.735987113779103 25 43.603261476437346
		 26 48.178508796551981 27 48.357338444217689 28 45.610930718140992 29 42.369825054644522
		 30 40.89497457285561;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "1BA97C3C-496C-F494-B2F0-2580734DFCE7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -42.134432549968601 1 -28.143243591112924
		 2 -3.2527668643033945 3 11.687833373551031 4 17.089293068979725 5 19.265125085814603
		 6 19.242115087688198 7 12.440352949537845 8 -3.3697138347667432 9 -23.415497896033319
		 10 -34.027642580453929 11 -29.568766293418832 12 -20.151419964848294 13 -12.49773117074392
		 14 -9.1321316049326651 15 -8.8878547965765975 16 -8.6995704639924618 17 -8.1703329552109576
		 18 -7.3756015620054436 19 -6.3370516290616274 20 -3.8440554071164366 21 0.49568116156906861
		 22 4.7657362095569233 23 6.7309467148699875 24 4.8713561475392924 25 -2.3193516733136086
		 26 -14.714066921837956 27 -27.355664986579136 28 -36.111326649514162 29 -40.776046564570755
		 30 -42.134432549968601;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "422054A4-4359-5029-6F5B-859767431A71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -35.873222351074219 1 -40.192100524902344
		 2 -49.517978668212891 3 -56.473461151123047 4 -57.241973876953125 5 -55.134792327880859
		 6 -52.982288360595703 7 -50.621131896972656 8 -43.493499755859375 9 -29.477291107177734
		 10 -13.285386085510254 11 -1.3358244895935059 12 6.8516702651977539 13 12.788151741027832
		 14 16.996150970458984 15 19.428173065185547 16 19.02338981628418 17 15.636092185974121
		 18 10.752547264099121 19 5.2819948196411133 20 -0.3629295825958252 21 -6.1242485046386719
		 22 -11.691228866577148 23 -16.935171127319336 24 -21.742122650146484 25 -25.977901458740234
		 26 -29.517955780029297 27 -32.294166564941406 28 -34.278900146484375 29 -35.471611022949219
		 30 -35.873222351074219;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "CA9DB5E4-41AF-6EE7-5910-019844C3EF56";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 93.981224060058594 1 92.432083129882813
		 2 88.100357055664063 3 81.878929138183594 4 75.585533142089844 5 70.963401794433594
		 6 68.856620788574219 7 71.114143371582031 8 78.479385375976563 9 87.883415222167969
		 10 94.478645324707031 11 96.073097229003906 12 94.227676391601563 13 91.184806823730469
		 14 87.730003356933594 15 84.086334228515625 16 81.031082153320312 17 79.327987670898437
		 18 79.315673828125 19 80.611221313476563 20 82.07305908203125 21 83.816596984863281
		 22 85.626708984375 23 87.443702697753906 24 89.155845642089844 25 90.621620178222656
		 26 91.826828002929687 27 92.765052795410156 28 93.436538696289062 29 93.843063354492188
		 30 93.981224060058594;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "F50135C9-430E-FC0F-3274-47BB435585BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -23.12449836730957 1 -22.536476135253906
		 2 -18.032955169677734 3 -8.0814809799194336 4 1.3819031715393066 5 5.4705014228820801
		 6 4.1576375961303711 7 -3.8175840377807617 8 -15.732616424560547 9 -23.634632110595703
		 10 -23.339351654052734 11 -19.847297668457031 12 -18.076547622680664 13 -17.760486602783203
		 14 -18.989181518554688 15 -21.739835739135742 16 -26.056552886962891 17 -30.924295425415039
		 18 -34.762550354003906 19 -37.484954833984375 20 -39.336513519287109 21 -40.143646240234375
		 22 -39.808242797851563 23 -38.4908447265625 24 -36.387367248535156 25 -33.727848052978516
		 26 -30.79905891418457 27 -27.928857803344727 28 -25.466087341308594 29 -23.757654190063477
		 30 -23.12449836730957;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "F97F6A43-42A5-47C6-4931-4AAD4EDAEC46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 64.302501174378193 1 76.864168899176804
		 2 108.28475335092126 3 146.65110902293196 4 173.58943091649556 5 180.60562498882334
		 6 167.47871712636399 7 112.28930261711926 8 50.249826802411278 9 8.1454274178232531
		 10 -34.429959005292197 11 -72.054475365331996 12 -93.397456969240636 13 -100.93478165739201
		 14 -100.52559867818948 15 -95.1399493531313 16 -84.910641126236342 17 -71.464610041399141
		 18 -57.552556211159121 19 -43.490838350671432 20 -28.238578111431128 21 -12.270738009185193
		 22 3.6097751505128284 23 18.411144411169147 24 31.315584047757238 25 41.937556313955582
		 26 50.275993586702207 27 56.515670476026955 28 60.858325678720988 29 63.438511247741801
		 30 64.302501174378193;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "89767715-448A-CEF5-75E4-F09AA2F664D6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 52.707429674243322 1 54.31258809568903
		 2 57.300960528970862 3 58.060314252299179 4 56.856611832536686 5 57.593180430290253
		 6 61.730925250632154 7 64.594357733308627 8 43.746667557498697 9 13.171313474902227
		 10 -7.0860544240595953 11 -9.5267097018381417 12 -3.3216782528941122 13 4.3165311899237597
		 14 13.155426570838086 15 23.315620595835711 16 34.063899809579858 17 43.766536674527075
		 18 50.851559622135831 19 55.539973726949263 20 59.037373416600794 21 61.3029566514072
		 22 62.333669748703116 23 62.231835705321217 24 61.223585036718433 25 59.612093942027776
		 26 57.715102884669754 27 55.828521448436838 28 54.216704746516207 29 53.111467863180359
		 30 52.707429674243322;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "2BDD3E9D-4A33-CB5D-A4EC-99B570E2C72D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 24.486126697653372 1 21.769188412920435
		 2 16.768541023477351 3 11.289875327417025 4 -0.34782470971629481 5 -20.371397769684233
		 6 -48.116772578522067 7 -102.71789704133272 8 -146.54817435973715 9 -139.79262142535532
		 10 -101.91376310033206 11 -61.332403812391718 12 -40.159464998175771 13 -33.935239598126422
		 14 -31.257099933143593 15 -30.267572516566599 16 -29.09951589655364 17 -26.540976946224056
		 18 -22.156160962853484 19 -16.575548377488701 20 -10.031840379006709 21 -2.7512316065319626
		 22 4.6755776497840893 23 11.427299578660113 24 16.824667107275609 25 20.607929617932083
		 26 22.909473773136579 27 24.072728203869783 28 24.492048015543201 29 24.529417629625851
		 30 24.486126697653372;
	setAttr ".roti" 5;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "BA43FE03-4F7C-ADF6-9F2F-12B9675A783C";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA";
	rename -uid "097B736C-48D7-78C9-95B0-ABA34114ECCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -35.179100036621094 1 -35.703636169433594
		 2 -39.196483612060547 3 -45.949447631835938 4 -51.325897216796875 5 -52.766937255859375
		 6 -51.020927429199219 7 -44.724876403808594 8 -33.757732391357422 9 -24.851715087890625
		 10 -22.409202575683594 11 -22.727291107177734 12 -19.79151725769043 13 -14.287008285522461
		 14 -8.2830314636230469 15 -2.7118396759033203 16 1.1326584815979004 17 2.1534013748168945
		 18 0.36156892776489258 19 -3.2943410873413086 20 -7.5120968818664551 21 -12.132547378540039
		 22 -16.736034393310547 23 -21.096311569213867 24 -25.030097961425781 25 -28.374517440795898
		 26 -31.021720886230469 27 -32.958412170410156 28 -34.238304138183594 29 -34.951225280761719
		 30 -35.179100036621094;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA";
	rename -uid "51AD38EC-445F-C65B-5BA3-BF9D560EE0F2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 111.65918731689453 1 111.43984985351562
		 2 109.98975372314453 3 106.15391540527344 4 100.58229064941406 5 95.876785278320313
		 6 94.100509643554688 7 96.807388305664062 8 101.5718994140625 9 103.62066650390625
		 10 102.50222778320312 11 101.71580505371094 12 102.43991088867187 13 103.19511413574219
		 14 103.58108520507812 15 103.48831176757812 16 103.23905181884766 17 103.26225280761719
		 18 103.88085174560547 19 105.12872314453125 20 106.31817626953125 21 107.60832214355469
		 22 108.80963134765625 23 109.88579559326172 24 110.75766754150391 25 111.32921600341797
		 26 111.64281463623047 27 111.75901794433594 28 111.74995422363281 29 111.6925048828125
		 30 111.65918731689453;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA";
	rename -uid "60355EE4-46D2-05FC-45F6-01A74E57A43D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -0.57772707939147949 1 -1.9251935482025146
		 2 -4.5785455703735352 3 -4.3850069046020508 4 -0.65190649032592773 5 2.0321445465087891
		 6 1.1742196083068848 7 -2.6438372135162354 8 -3.9801077842712402 9 0.32859086990356445
		 10 4.2804141044616699 11 1.73223876953125 12 -4.1583499908447266 13 -8.1295547485351562
		 14 -10.214593887329102 15 -11.931600570678711 16 -14.080522537231445 17 -16.982278823852539
		 18 -19.647945404052734 19 -21.523771286010742 20 -22.635129928588867 21 -22.727289199829102
		 22 -21.651180267333984 23 -19.554803848266602 24 -16.656108856201172 25 -13.22923755645752
		 26 -9.6108551025390625 27 -6.1700229644775391 28 -3.2814731597900391 29 -1.3056883811950684
		 30 -0.57772707939147949;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ";
	rename -uid "B0FFA190-47FC-8362-AED2-B99EC97B066C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.31909097498970923 1 -0.054977799241038558
		 2 -2.0966401679699995 3 -6.4395371049885419 4 -10.707266829655037 5 -12.094772584799863
		 6 -11.515140599575693 7 -12.144564869993644 8 -16.11649970223727 9 -21.492974125579341
		 10 -23.851099344218859 11 -22.324268684888985 12 -17.023193278748472 13 -8.9177658151810189
		 14 0.38073705165659655 15 9.0115533239983172 16 15.43322915343208 17 19.067418748629283
		 18 19.989651516276226 19 18.554071892738303 20 15.916547106769627 21 12.945697148037995
		 22 10.265600365472224 23 8.2256608668188704 24 6.9086442134692758 25 5.7374500426989909
		 26 4.3267871420059469 27 2.8745795008770796 28 1.5863885328071816 29 0.66816958797192105
		 30 0.31909097498970923;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY";
	rename -uid "21BE41BA-4727-0305-1D3C-8B92B6BFA397";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.94580894197846233 1 4.0479128910822118
		 2 10.667149488305228 3 16.52018461769665 4 17.94150242119207 5 12.207463355598385
		 6 0.67958028894748834 7 -12.972770411904818 8 -23.955574131629515 9 -26.554358662423621
		 10 -21.064461843889109 11 -12.64175268825166 12 -3.7850519423020921 13 3.5922512140015979
		 14 8.6878735767667532 15 11.946689730572064 16 14.52344256281491 17 16.815042264846063
		 18 18.094797332324383 19 17.017590676487441 20 13.394217315304022 21 8.3852041314975754
		 22 3.2512876525585956 23 -0.64058866453374919 24 -1.8452751611436964 25 -1.1610517900592339
		 26 -0.47190114407329808 27 0.12055199343084742 28 0.5659445204239647 29 0.8456176680648686
		 30 0.94580894197846233;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX";
	rename -uid "996C57A9-40B0-0729-6222-0BA68DF3AD0B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -3.2986230880193443 1 -6.0662772983835831
		 2 -13.164945935157284 3 -22.874903979775905 4 -32.591541659860475 5 -37.191857615612932
		 6 -34.999051245255473 7 -28.614911409921035 8 -20.040213140930742 9 -10.468370924883979
		 10 -2.000692794769531 11 5.3616507067342303 12 11.951981077483117 13 17.802859693043064
		 14 22.210587425408118 15 24.161282965085213 16 23.009171085984956 17 20.273800794370555
		 18 18.127253022990857 19 16.153267563430703 20 13.718589523246941 21 11.114211117895408
		 22 8.4825658921069174 23 5.8547315551800541 24 3.2597878918349776 25 1.0049921906669976
		 26 -0.70402900478637054 27 -1.9301448330402895 28 -2.7317978018073585 29 -3.1674861198037751
		 30 -3.2986230880193443;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA";
	rename -uid "F0467B37-4517-4DD6-0CD6-3595211B8DFF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -17.145322799682617 1 -15.631662368774414
		 2 -11.815838813781738 3 -6.7030353546142578 4 -1.2746877670288086 5 3.5812950134277344
		 6 7.2090053558349609 7 9.2726669311523437 8 9.7411136627197266 9 8.26177978515625
		 10 5.7496843338012695 11 2.2085075378417969 12 -2.0445742607116699 13 -6.2358875274658203
		 14 -9.9542760848999023 15 -12.80565071105957 16 -14.863043785095215 17 -16.699989318847656
		 18 -18.582052230834961 19 -20.181430816650391 20 -21.201993942260742 21 -21.798538208007813
		 22 -21.884555816650391 23 -21.569526672363281 24 -20.98369026184082 25 -20.227424621582031
		 26 -19.383996963500977 27 -18.553909301757813 28 -17.837623596191406 29 -17.334957122802734
		 30 -17.145322799682617;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA";
	rename -uid "9C2D79CC-4A50-E875-7C4F-7AB2713419DD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 52.418865203857422 1 52.194267272949219
		 2 51.600852966308594 3 50.715187072753906 4 49.601886749267578 5 48.360256195068359
		 6 47.082134246826172 7 45.886138916015625 8 44.892818450927734 9 44.363262176513672
		 10 44.2225341796875 11 44.171424865722656 12 43.864479064941406 13 43.386653900146484
		 14 43.034053802490234 15 42.869640350341797 16 43.172985076904297 17 43.998958587646484
		 18 45.106784820556641 19 46.403350830078125 20 47.470771789550781 21 48.541149139404297
		 22 49.498138427734375 23 50.366870880126953 24 51.108665466308594 25 51.643718719482422
		 26 52.008213043212891 27 52.235702514648437 28 52.358818054199219 29 52.409294128417969
		 30 52.418865203857422;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA";
	rename -uid "6AC09E4B-4A2D-6055-B211-FD8D67F1B816";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 29.644681930541992 1 28.949739456176758
		 2 26.986495971679688 3 23.994132995605469 4 20.566356658935547 5 17.70484733581543
		 6 16.619874954223633 7 17.319076538085938 8 18.686250686645508 9 20.509103775024414
		 10 22.219547271728516 11 23.420452117919922 12 23.894311904907227 13 23.664920806884766
		 14 22.798439025878906 15 21.621870040893555 16 20.60588264465332 17 19.794492721557617
		 18 19.093818664550781 19 18.655078887939453 20 18.672664642333984 21 19.196483612060547
		 22 20.23942756652832 23 21.609476089477539 24 23.146329879760742 25 24.727348327636719
		 26 26.240503311157227 27 27.58393669128418 28 28.662221908569336 29 29.381668090820312
		 30 29.644681930541992;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "BF2CFE88-461C-A32F-C858-7EB0DD44E534";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 6.6493499128949276 1 6.9472695100536113
		 2 9.1360321237846343 3 5.7627216181500742 4 -3.3463010512130076 5 -13.277758494149662
		 6 -21.537936701551612 7 -24.322197252995043 8 -17.408821701547954 9 -20.985374768360437
		 10 -23.580513303006647 11 -25.265800152511861 12 -25.539030359593383 13 -21.465740797236649
		 14 -17.31609638122255 15 -20.539368235954782 16 -20.726472079430838 17 -17.219854444787565
		 18 -21.954275985190733 19 -24.285543526671628 20 -20.045591707568466 21 -12.894327567908569
		 22 -5.8994462573322295 23 -3.1401922154824966 24 -0.50810294021347113 25 1.6344477375671007
		 26 3.3772622328780804 27 4.7635949479107067 28 5.7949875723320092 29 6.4357025258670504
		 30 6.6493499128949276;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY";
	rename -uid "7EDAEA7C-4870-747A-27A6-CCA10FBD1462";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -0.27306317554363835 1 -1.2602341116409235
		 2 -3.6614894707941286 3 -8.691130513858278 4 -15.649208699536096 5 -21.675515766839489
		 6 -23.274561565763424 7 -21.273412236631266 8 -18.020260929965215 9 -16.303572388393111
		 10 -14.487880036934264 11 -12.904792673516127 12 -11.717924825927129 13 -10.699412449044205
		 14 -10.376889521546056 15 -11.511071700703722 16 -12.295067722791515 17 -12.68488926883845
		 18 -13.76573244305683 19 -14.493711494629684 20 -14.477486916265644 21 -13.432913596021953
		 22 -11.476075519519272 23 -9.6897871353190119 24 -7.7621866950475731 25 -5.870749620605876
		 26 -4.1137392071779049 27 -2.5813025427665552 28 -1.3648619093559706 29 -0.56198347420400652
		 30 -0.27306317554363835;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX";
	rename -uid "45105F22-40CC-55D6-27FE-BF9008449432";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -2.0615326151095319 1 -1.5108836521616105
		 2 -0.17991489360574761 3 2.5682995908741719 4 8.0252221790748397 5 14.841135952939126
		 6 19.266884042273915 7 18.428767198723914 8 11.690188684494847 9 10.929555444508573
		 10 9.4895389473908125 11 7.9762464876702381 12 6.7913998985587902 13 5.6505699553478408
		 14 5.3006495441682109 15 6.7556398834285263 16 7.6610464360082728 17 7.5727518466585435
		 18 9.0569257868706128 19 9.7359600018443668 20 8.5437411592867196 21 6.3517746141141354
		 22 3.9916341225995264 23 2.6036414187550831 24 1.3243811066069144 25 0.26015874096136837
		 26 -0.58951104817994548 27 -1.2361432469619729 28 -1.6919496206675706 29 -1.9668748400618721
		 30 -2.0615326151095319;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA";
	rename -uid "CEAAA758-40B1-4DDA-CCB6-3C8B2894B71B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -17.145320892333984 1 -17.896478652954102
		 2 -19.708423614501953 3 -21.729747772216797 4 -23.069822311401367 5 -23.067554473876953
		 6 -21.277547836303711 7 -17.939201354980469 8 -13.861089706420898 9 -9.6744155883789063
		 10 -4.8841571807861328 11 -0.16605615615844727 12 3.9144086837768555 13 7.2227563858032227
		 14 9.4220113754272461 15 10.394540786743164 16 9.6992950439453125 17 7.5400881767272949
		 18 4.7474822998046875 19 1.7273054122924805 20 -1.148045539855957 21 -3.9512996673583984
		 22 -6.50408935546875 23 -8.8126611709594727 24 -10.893745422363281 25 -12.727151870727539
		 26 -14.272116661071777 27 -15.505461692810059 28 -16.406705856323242 29 -16.958343505859375
		 30 -17.145320892333984;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA";
	rename -uid "AEF0025F-40B8-3624-D3B3-DDA34B53A372";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 36.424163818359375 1 36.199577331542969
		 2 35.606170654296875 3 34.720466613769531 4 33.607170104980469 5 32.365547180175781
		 6 31.087419509887695 7 29.891410827636719 8 28.898105621337891 9 28.368553161621094
		 10 28.227832794189453 11 28.176725387573242 12 27.869779586791992 13 27.391948699951172
		 14 27.039358139038086 15 26.874944686889648 16 27.178264617919922 17 28.004240036010742
		 18 29.112096786499023 19 30.408636093139648 20 31.476072311401367 21 32.54644775390625
		 22 33.50341796875 23 34.372169494628906 24 35.113945007324219 25 35.649013519287109
		 26 36.013484954833984 27 36.240982055664063 28 36.364105224609375 29 36.414581298828125
		 30 36.424163818359375;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA";
	rename -uid "73A95C94-4AF0-C563-B26E-9B9FCFD6D14F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -17.509130477905273 1 -18.149621963500977
		 2 -19.502025604248047 3 -20.701328277587891 4 -21.248199462890625 5 -21.196538925170898
		 6 -20.956666946411133 7 -21.190681457519531 8 -22.135534286499023 9 -23.100252151489258
		 10 -23.719558715820313 11 -23.673500061035156 12 -22.881425857543945 13 -21.527393341064453
		 14 -20.190353393554688 15 -19.429662704467773 16 -19.645540237426758 17 -20.651819229125977
		 18 -21.884326934814453 19 -23.099994659423828 20 -24.004222869873047 21 -24.449310302734375
		 22 -24.335550308227539 23 -23.785917282104492 24 -22.915365219116211 25 -21.826114654541016
		 26 -20.63542366027832 27 -19.471284866333008 28 -18.469888687133789 29 -17.770637512207031
		 30 -17.509130477905273;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY";
	rename -uid "8F7F8A3C-4F1B-179F-1C88-C4BAE88ECF2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 19.354953368372353 1 18.322943313007606
		 2 16.155731970830576 3 14.311438806783949 4 13.627823435157323 5 13.9091383999921
		 6 14.203896422409096 7 12.991448380382163 8 9.8717967420147215 9 7.1814384778712519
		 10 5.7579197187288793 11 6.0343173477717968 12 7.6820304687382599 13 9.8892577475962575
		 14 11.443549268090448 15 11.841283897817208 16 11.821516231210031 17 11.161505263639439
		 18 9.7226834794699979 19 7.949222313276544 20 6.5262476318612261 21 5.9537051529894214
		 22 6.4168147204765802 23 7.699732629839211 24 9.5426769548379689 25 11.69383141588135
		 26 13.922046106252562 27 16.007442242470042 28 17.739512109097298 29 18.919250152513655
		 30 19.354953368372353;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX";
	rename -uid "46453AEE-4011-CA6F-4BF1-AC8D28E349A4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -7.8983403485937878 1 -7.9322506421821668
		 2 -7.860477589648216 3 -7.7462431129270675 4 -8.1081959795516063 5 -9.1103517150485676
		 6 -10.064350371944894 7 -9.821477472773374 8 -8.4260116178779842 9 -7.0796635516337636
		 10 -5.7955232213796455 11 -4.4818888659973206 12 -2.8705919690186885 13 -0.67727794864600199
		 14 1.6592944953472588 15 2.9586003688935416 16 2.0895919611006311 17 -0.074115570280077717
		 18 -1.9149283773801415 19 -2.9933071629229264 20 -3.4450134187921759 21 -3.4717959728032928
		 22 -3.4341010480595338 23 -3.5282753291315325 24 -3.8487467024618622 25 -4.4489534387102925
		 26 -5.2680572109862851 27 -6.1840466313113884 28 -7.0384068857262472 29 -7.6615471906480925
		 30 -7.8983403485937878;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "CE158B2A-4F4C-238A-BAD5-DF90521F2304";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 7.4464862061454662 1 5.7220839096193785
		 2 1.6110707408039744 3 -2.8993434843743144 4 -5.6996100765234621 5 -4.9437901417469536
		 6 0.85956052176784359 7 10.711481299551926 8 21.224592449838656 9 29.636867806820128
		 10 38.028939472481589 11 46.483520538927962 12 54.980407868098006 13 63.508981075958424
		 14 70.662440080617301 15 74.719268888313977 16 72.364757296139928 17 65.080448016750594
		 18 56.846040339372017 19 48.841097259818909 20 42.063724942919542 21 35.790484427617479
		 22 30.344974237599075 23 25.489323872003052 24 21.090212006792036 25 17.192290026800752
		 26 13.8627766608061 27 11.155303516654977 28 9.1371501828936346 29 7.8789464896494623
		 30 7.4464862061454662;
	setAttr ".roti" 5;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "7369837D-4ABC-D196-0180-2DBB39C51D14";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.86335647106170654 0.32122647762298584 -0.38913950324058533 0
		 -0.29285332560539246 0.9470025897026062 0.13199751079082489 0 0.41091713309288025 -8.1956386566162109e-008 0.91167294979095459 0
		 -2.2736303806304932 42.35760498046875 -2.1603424549102783 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.98064315319061279 0.18965749442577362 -0.048676371574401855 0
		 -0.19559116661548615 0.937225341796875 -0.28870946168899536 0 -0.0091351922601461411 0.29264158010482788 0.95617872476577759 0
		 22.798467636108398 43.034053802490234 -9.95428466796875 1;
	setAttr ".LeftLegGX" -type "matrix" 0.94098025560379028 0.22613014280796051 -0.25183627009391785 0
		 -0.28718331456184387 0.13967292010784149 -0.94763779640197754 0 -0.17911478877067566 0.96403157711029053 0.19637024402618408 0
		 25.047979354858398 25.736457824707031 2.1405229568481445 1;
	setAttr ".LeftFootGX" -type "matrix" 0.91267633438110352 -0.15795296430587769 -0.37692555785179138 0
		 -0.12908819317817688 0.76365697383880615 -0.63258540630340576 0 0.38776054978370667 0.62600231170654297 0.67658179998397827 0
		 26.35350227355957 12.309239387512207 10.633017539978027 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.96745282411575317 -0.11683660745620728 -0.2244657427072525 0
		 0.2508949339389801 0.32728159427642822 0.91100990772247314 0 -0.032975830137729645 -0.9376760721206665 0.34594312310218811 0
		 -20.190366744995117 27.039346694946289 9.4220218658447266 1;
	setAttr ".RightLegGX" -type "matrix" 0.98370981216430664 0.042247030884027481 -0.17472940683364868 0
		 0.10626567155122757 0.64731681346893311 0.75477731227874756 0 0.14499236643314362 -0.76104950904846191 0.63228243589401245 0
		 -23.84889030456543 14.17414665222168 -7.0598697662353516 1;
	setAttr ".RightFootGX" -type "matrix" 0.90495264530181885 -0.32652020454406738 0.27284723520278931 0
		 0.07509748637676239 0.7537112832069397 0.65290123224258423 0 -0.41883343458175659 -0.5703544020652771 0.70659375190734863 0
		 -22.729848861694336 16.434684753417969 -22.800151824951172 1;
	setAttr ".SpineGX" -type "matrix" 0.81987577676773071 0.28271263837814331 -0.49787291884422302 0
		 -0.27230203151702881 0.95748263597488403 0.095282614231109619 0 0.50364220142364502 0.057451900094747543 0.86199992895126343 0
		 -4.8189420700073242 45.560874938964844 -5.1632137298583984 1;
	setAttr ".LeftArmGX" -type "matrix" 0.06338268518447876 -0.44577950239181519 -0.89289605617523193 0
		 -0.1271500289440155 0.88379675149917603 -0.4502623975276947 0 0.9898563027381897 0.14207056164741516 -0.0006634629680775106 0
		 -7.6945672035217285 90.837242126464844 -27.391040802001953 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.85759806632995605 -0.24214835464954376 -0.45375138521194458 0
		 -0.057378970086574554 0.83168137073516846 -0.55228108167648315 0 0.51111042499542236 0.49967080354690552 0.69935387372970581 0
		 -6.1962800025939941 80.299583435058594 -48.497955322265625 1;
	setAttr ".LeftHandGX" -type "matrix" 0.58725690841674805 -0.040959030389785767 -0.80836397409439087 0
		 -0.74377095699310303 0.36664187908172607 -0.55890882015228271 0 0.31927222013473511 0.92946040630340576 0.18484881520271301 0
		 12.96912956237793 74.888107299804688 -58.638290405273437 1;
	setAttr ".RightArmGX" -type "matrix" -0.17379623651504517 0.213847815990448 -0.96128249168395996 0
		 -0.49194544553756714 0.82676172256469727 0.27286410331726074 0 0.8531029224395752 0.5203213095664978 -0.038486599922180176 0
		 -18.989212036132812 87.729988098144531 16.996150970458984 1;
	setAttr ".RightForeArmGX" -type "matrix" -0.48629602789878845 0.060052976012229919 -0.87172812223434448 0
		 -0.47454455494880676 0.81954169273376465 0.3211839497089386 0 0.73370546102523804 0.56986433267593384 -0.37004196643829346 0
		 -14.350374221801758 82.439750671386719 39.563526153564453 1;
	setAttr ".RightHandGX" -type "matrix" 0.1170513853430748 0.83641290664672852 -0.53545522689819336 0
		 -0.99312025308609009 0.10038623213768005 -0.060288410633802414 0 0.0033263266086578369 0.53882831335067749 0.84240901470184326 0
		 -3.5191450119018555 81.383651733398438 59.082534790039062 1;
	setAttr ".HeadGX" -type "matrix" 0.91517788171768188 0.14235226809978485 -0.37707450985908508 0
		 -0.15105132758617401 0.98850405216217041 0.0065689049661159515 0 0.37367478013038635 0.050945889204740524 0.92615962028503418 0
		 -10.214632034301758 103.58108520507812 -8.2830486297607422 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324482202529907 1.2979107566479797e-007 -0.48728200793266296 0
		 -1.2979108987565269e-007 1.0000002384185791 3.3762198370368424e-008 0 0.48728200793266296 3.3762194817654745e-008 0.87324482202529907 0
		 26.182731628417969 6.4234061241149902 14.183185577392578 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841245412826538 1.6409554604024379e-008 0.52933567762374878 0
		 1.6409556380381218e-008 1.0000001192092896 -5.730130325787286e-008 0 -0.52933567762374878 5.7301299705159181e-008 0.84841245412826538 0
		 -22.158807754516602 11.955905914306641 -27.985752105712891 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.1102604940533638 0.34144118428230286 -0.93341332674026489 0
		 -0.27463188767433167 0.91304212808609009 0.30154824256896973 0 0.95520675182342529 0.22309623658657074 0.19444313645362854 0
		 -5.2323083877563477 88.356430053710938 -18.015052795410156 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.067856729030609131 0.066639631986618042 -0.99546718597412109 0
		 -0.52406895160675049 0.85141044855117798 0.021272584795951843 0 0.84896844625473022 0.52024984359741211 0.092697679996490479 0
		 -15.221757888793945 90.138267517089844 8.0446662902832031 1;
	setAttr ".NeckGX" -type "matrix" 0.2684900164604187 -0.32853218913078308 -0.90552759170532227 0
		 0.066998958587646484 0.94413620233535767 -0.32267433404922485 0 0.96094983816146851 0.025965360924601555 0.27550232410430908 0
		 -14.660795211791992 97.004547119140625 -7.2153234481811523 1;
	setAttr ".Spine1GX" -type "matrix" 0.69987398386001587 0.18591201305389404 -0.6896476149559021 0
		 -0.24309699237346649 0.96989011764526367 0.014756753109395504 0 0.67162555456161499 0.15732337534427643 0.72399526834487915 0
		 -6.0831270217895508 52.406562805175781 -3.3577566146850586 1;
	setAttr ".Spine2GX" -type "matrix" 0.54236268997192383 0.067969493567943573 -0.83739060163497925 0
		 -0.23117639124393463 0.97032004594802856 -0.0709695965051651 0 0.80771297216415405 0.23207618296146393 0.54197829961776733 0
		 -10.834368705749512 67.114730834960938 -4.2144889831542969 1;
	setAttr ".Spine3GX" -type "matrix" 0.35720831155776978 -0.063727200031280518 -0.93184816837310791 0
		 -0.23728682100772858 0.95874613523483276 -0.15652661025524139 0 0.90338099002838135 0.27702793478965759 0.32735049724578857 0
		 -15.675105094909668 79.081535339355469 -6.378420352935791 1;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "BD6AD03B-4955-DE37-161E-738385478859";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.86335647106170654 0.32122647762298584 -0.38913950324058533 0
		 -0.29285332560539246 0.9470025897026062 0.13199751079082489 0 0.41091713309288025 -8.1956386566162109e-008 0.91167294979095459 0
		 -2.2736303806304932 42.35760498046875 -2.1603424549102783 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.98064315319061279 0.18965749442577362 -0.048676371574401855 0
		 -0.19559116661548615 0.937225341796875 -0.28870946168899536 0 -0.0091351922601461411 0.29264158010482788 0.95617872476577759 0
		 22.798467636108398 43.034053802490234 -9.95428466796875 1;
	setAttr ".LeftLegGX" -type "matrix" 0.94098025560379028 0.22613014280796051 -0.25183627009391785 0
		 -0.28718331456184387 0.13967292010784149 -0.94763779640197754 0 -0.17911478877067566 0.96403157711029053 0.19637024402618408 0
		 25.047979354858398 25.736457824707031 2.1405229568481445 1;
	setAttr ".LeftFootGX" -type "matrix" 0.91267633438110352 -0.15795296430587769 -0.37692555785179138 0
		 -0.12908819317817688 0.76365697383880615 -0.63258540630340576 0 0.38776054978370667 0.62600231170654297 0.67658179998397827 0
		 26.35350227355957 12.309239387512207 10.633017539978027 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.96745282411575317 -0.11683660745620728 -0.2244657427072525 0
		 0.2508949339389801 0.32728159427642822 0.91100990772247314 0 -0.032975830137729645 -0.9376760721206665 0.34594312310218811 0
		 -20.190366744995117 27.039346694946289 9.4220218658447266 1;
	setAttr ".RightLegGX" -type "matrix" 0.98370981216430664 0.042247030884027481 -0.17472940683364868 0
		 0.10626567155122757 0.64731681346893311 0.75477731227874756 0 0.14499236643314362 -0.76104950904846191 0.63228243589401245 0
		 -23.84889030456543 14.17414665222168 -7.0598697662353516 1;
	setAttr ".RightFootGX" -type "matrix" 0.90495264530181885 -0.32652020454406738 0.27284723520278931 0
		 0.07509748637676239 0.7537112832069397 0.65290123224258423 0 -0.41883343458175659 -0.5703544020652771 0.70659375190734863 0
		 -22.729848861694336 16.434684753417969 -22.800151824951172 1;
	setAttr ".SpineGX" -type "matrix" 0.81987577676773071 0.28271263837814331 -0.49787291884422302 0
		 -0.27230203151702881 0.95748263597488403 0.095282614231109619 0 0.50364220142364502 0.057451900094747543 0.86199992895126343 0
		 -4.8189420700073242 45.560874938964844 -5.1632137298583984 1;
	setAttr ".LeftArmGX" -type "matrix" 0.06338268518447876 -0.44577950239181519 -0.89289605617523193 0
		 -0.1271500289440155 0.88379675149917603 -0.4502623975276947 0 0.9898563027381897 0.14207056164741516 -0.0006634629680775106 0
		 -7.6945672035217285 90.837242126464844 -27.391040802001953 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.85759806632995605 -0.24214835464954376 -0.45375138521194458 0
		 -0.057378970086574554 0.83168137073516846 -0.55228108167648315 0 0.51111042499542236 0.49967080354690552 0.69935387372970581 0
		 -6.1962800025939941 80.299583435058594 -48.497955322265625 1;
	setAttr ".LeftHandGX" -type "matrix" 0.58725690841674805 -0.040959030389785767 -0.80836397409439087 0
		 -0.74377095699310303 0.36664187908172607 -0.55890882015228271 0 0.31927222013473511 0.92946040630340576 0.18484881520271301 0
		 12.96912956237793 74.888107299804688 -58.638290405273437 1;
	setAttr ".RightArmGX" -type "matrix" -0.17379623651504517 0.213847815990448 -0.96128249168395996 0
		 -0.49194544553756714 0.82676172256469727 0.27286410331726074 0 0.8531029224395752 0.5203213095664978 -0.038486599922180176 0
		 -18.989212036132812 87.729988098144531 16.996150970458984 1;
	setAttr ".RightForeArmGX" -type "matrix" -0.48629602789878845 0.060052976012229919 -0.87172812223434448 0
		 -0.47454455494880676 0.81954169273376465 0.3211839497089386 0 0.73370546102523804 0.56986433267593384 -0.37004196643829346 0
		 -14.350374221801758 82.439750671386719 39.563526153564453 1;
	setAttr ".RightHandGX" -type "matrix" 0.1170513853430748 0.83641290664672852 -0.53545522689819336 0
		 -0.99312025308609009 0.10038623213768005 -0.060288410633802414 0 0.0033263266086578369 0.53882831335067749 0.84240901470184326 0
		 -3.5191450119018555 81.383651733398438 59.082534790039062 1;
	setAttr ".HeadGX" -type "matrix" 0.91517788171768188 0.14235226809978485 -0.37707450985908508 0
		 -0.15105132758617401 0.98850405216217041 0.0065689049661159515 0 0.37367478013038635 0.050945889204740524 0.92615962028503418 0
		 -10.214632034301758 103.58108520507812 -8.2830486297607422 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324482202529907 1.2979107566479797e-007 -0.48728200793266296 0
		 -1.2979108987565269e-007 1.0000002384185791 3.3762198370368424e-008 0 0.48728200793266296 3.3762194817654745e-008 0.87324482202529907 0
		 26.182731628417969 6.4234061241149902 14.183185577392578 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841245412826538 1.6409554604024379e-008 0.52933567762374878 0
		 1.6409556380381218e-008 1.0000001192092896 -5.730130325787286e-008 0 -0.52933567762374878 5.7301299705159181e-008 0.84841245412826538 0
		 -22.158807754516602 11.955905914306641 -27.985752105712891 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.1102604940533638 0.34144118428230286 -0.93341332674026489 0
		 -0.27463188767433167 0.91304212808609009 0.30154824256896973 0 0.95520675182342529 0.22309623658657074 0.19444313645362854 0
		 -5.2323083877563477 88.356430053710938 -18.015052795410156 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.067856729030609131 0.066639631986618042 -0.99546718597412109 0
		 -0.52406895160675049 0.85141044855117798 0.021272584795951843 0 0.84896844625473022 0.52024984359741211 0.092697679996490479 0
		 -15.221757888793945 90.138267517089844 8.0446662902832031 1;
	setAttr ".NeckGX" -type "matrix" 0.2684900164604187 -0.32853218913078308 -0.90552759170532227 0
		 0.066998958587646484 0.94413620233535767 -0.32267433404922485 0 0.96094983816146851 0.025965360924601555 0.27550232410430908 0
		 -14.660795211791992 97.004547119140625 -7.2153234481811523 1;
	setAttr ".Spine1GX" -type "matrix" 0.69987398386001587 0.18591201305389404 -0.6896476149559021 0
		 -0.24309699237346649 0.96989011764526367 0.014756753109395504 0 0.67162555456161499 0.15732337534427643 0.72399526834487915 0
		 -6.0831270217895508 52.406562805175781 -3.3577566146850586 1;
	setAttr ".Spine2GX" -type "matrix" 0.54236268997192383 0.067969493567943573 -0.83739060163497925 0
		 -0.23117639124393463 0.97032004594802856 -0.0709695965051651 0 0.80771297216415405 0.23207618296146393 0.54197829961776733 0
		 -10.834368705749512 67.114730834960938 -4.2144889831542969 1;
	setAttr ".Spine3GX" -type "matrix" 0.35720831155776978 -0.063727200031280518 -0.93184816837310791 0
		 -0.23728682100772858 0.95874613523483276 -0.15652661025524139 0 0.90338099002838135 0.27702793478965759 0.32735049724578857 0
		 -15.675105094909668 79.081535339355469 -6.378420352935791 1;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAX";
	rename -uid "18F4DF21-4874-FFF4-D307-97B0499C09E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0 1 -2.9068115122262483 2 -10.163797856871406
		 3 -19.545743941567387 4 -28.828527425283625 5 -35.880931529847388 6 -38.677931510889657
		 7 -36.729124814533698 8 -31.405451048290523 9 -23.475780705855833 10 -13.735545339900764
		 11 -3.0477572067255485 12 7.661672961534741 13 17.457039534726352 14 25.452259193599804
		 15 30.827724817684878 16 32.796635185711942 17 32.327865240384412 18 31.013327173676451
		 19 28.989058827773452 20 26.390573949853557 21 23.354430911530081 22 20.019575265497263
		 23 16.527907969220045 24 13.024129196939683 25 9.6551320901587925 26 6.5689119915727856
		 27 3.9135075935717127 28 1.83620061328184 29 0.48323254755772954 30 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ";
	rename -uid "A77E7B77-4449-4BA3-22A6-4495363479C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0 1 -0.93338749229265594 2 -3.2495315073795581
		 3 -6.1694525372863831 4 -8.9105417114213523 5 -10.85193490976555 6 -11.580694201153829
		 7 -11.075591957121977 8 -9.6359976956285927 9 -7.3519676892019605 10 -4.3743276179467179
		 11 -0.97860414336313961 12 2.4545493101740083 13 5.5298850223774139 14 7.9350219129538164
		 15 9.4748795614962695 16 10.020188728512018 17 9.8913320583933615 18 9.526742152708966
		 19 8.956236452737393 20 8.2088206028048081 21 7.3159034263712446 22 6.3135312455951471
		 23 5.2431859870077657 24 4.1513891250027335 25 3.0883230446686802 26 2.1059616028070929
		 27 1.2562465614049452 28 0.58974969300659918 29 0.15522679880244808 30 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAY";
	rename -uid "31DD8D4A-4AED-4173-CEA2-3F9C376D2570";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 18.737105494509741 1 18.714682347043503
		 2 18.463156492895266 3 17.726824043379711 4 16.550091226086476 5 15.367454687697073
		 6 14.831849739942195 7 15.208960420375561 8 16.146285342380228 9 17.282327672490169
		 10 18.237196853243759 11 18.71245296328857 12 18.581365002507859 13 17.930566076019947
		 14 17.028857373269318 15 16.239680088422521 16 15.914638669730676 17 15.993756242582114
		 18 16.209854436608047 19 16.525897072134939 20 16.901582716551903 21 17.297239040573825
		 22 17.677449687352734 23 18.013899296644684 24 18.287557004134914 25 18.489856837308459
		 26 18.622594303534946 27 18.696460329810876 28 18.728158806600245 29 18.736490634876617
		 30 18.737105494509741;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX_tempLayer_inputA";
	rename -uid "22247B54-4F24-29C3-7C6F-15B92259F218";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.5844721794128418 1 3.0731871128082275
		 2 1.82908034324646 3 0.31137287616729736 4 -1.06531822681427 5 -1.9877506494522095
		 6 -2.2159380912780762 7 -2.1189095973968506 8 -2.274240255355835 9 -2.3761272430419922
		 10 -2.448359489440918 11 -2.4456846714019775 12 -2.3609588146209717 13 -2.2237262725830078
		 14 -2.2736291885375977 15 -2.638796329498291 16 -3.3049468994140625 17 -4.202202320098877
		 18 -5.1350717544555664 19 -5.9068593978881836 20 -6.2729806900024414 21 -6.1350078582763672
		 22 -5.4383430480957031 23 -4.3438396453857422 24 -2.9944119453430176 25 -1.5095860958099365
		 26 -0.012719631195068359 27 1.3715288639068604 28 2.5169873237609863 29 3.2967617511749268
		 30 3.5844721794128418;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ_tempLayer_inputA";
	rename -uid "C81B4F70-4D4B-BC3F-F3C5-3B8BF7ADF514";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -20.342348098754883 1 -20.076681137084961
		 2 -19.329708099365234 3 -18.038110733032227 4 -16.155101776123047 5 -13.784076690673828
		 6 -11.082172393798828 7 -8.3773136138916016 8 -6.0706911087036133 9 -4.6076197624206543
		 10 -3.2419288158416748 11 -2.2967972755432129 12 -1.9226542711257935 13 -1.8618228435516357
		 14 -2.1603395938873291 15 -2.7670397758483887 16 -4.0173749923706055 17 -6.0456347465515137
		 18 -8.4669866561889648 19 -10.904262542724609 20 -13.012393951416016 21 -14.894205093383789
		 22 -16.406511306762695 23 -17.597076416015625 24 -18.530324935913086 25 -19.238620758056641
		 26 -19.737033843994141 27 -20.059484481811523 28 -20.242362976074219 29 -20.323741912841797
		 30 -20.342348098754883;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY_tempLayer_inputA";
	rename -uid "780D35FB-405F-610C-A91F-8E9EBBC6A8A8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 51.742416381835938 1 51.517829895019531
		 2 50.924404144287109 3 50.038738250732422 4 48.925441741943359 5 47.683803558349609
		 6 46.405673980712891 7 45.209690093994141 8 44.21636962890625 9 43.686813354492188
		 10 43.54608154296875 11 43.494972229003906 12 43.188030242919922 13 42.710205078125
		 14 42.35760498046875 15 42.193191528320312 16 42.496536254882813 17 43.322513580322266
		 18 44.430335998535156 19 45.726898193359375 20 46.794319152832031 21 47.864700317382813
		 22 48.821693420410156 23 49.690422058105469 24 50.432216644287109 25 50.967269897460938
		 26 51.331756591796875 27 51.559249877929688 28 51.682369232177734 29 51.73284912109375
		 30 51.742416381835938;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX";
	rename -uid "51E05AF4-49F1-DCBA-BF05-DC91C168403C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -5.8783006942108935 1 -7.938296218525152
		 2 -12.621020956125943 3 -19.21808775588627 4 -24.241529476676678 5 -26.453828331628976
		 6 -26.220855939397449 7 -24.682100277655824 8 -25.151575659955189 9 -19.00291408973321
		 10 -12.799001561060654 11 -6.838735505936719 12 -0.84853960697901964 13 6.3271689840653487
		 14 13.999668392059363 15 17.837773873519367 16 20.095886592316255 17 21.650832241656278
		 18 19.307240479802449 19 17.155996732583759 20 16.370772883510771 21 15.407905043950448
		 22 13.484723825111397 23 10.26159892461132 24 6.9487863725413872 25 3.6716739984177611
		 26 0.63519527220880889 27 -1.9892577399387239 28 -4.0466429898705352 29 -5.3926265085906939
		 30 -5.8783006942108935;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "B3C7AD45-48BD-96ED-41CA-24AD800F795F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.5969551528766512 1 5.8727382129842134
		 2 8.4804591913496168 3 7.4881707039018659 4 4.9124449788413855 5 3.9647248041250065
		 6 0.88259805127348612 7 -3.9781169915215213 8 -3.9291036849173455 9 -11.561388001773992
		 10 -18.447785445440832 11 -23.658506165613897 12 -26.316254521426572 13 -23.399371064482473
		 14 -19.318354354042878 15 -22.701346030262069 16 -22.982414689070641 17 -19.524601908295057
		 18 -24.591024442327079 19 -27.047645264400163 20 -22.710427140129308 21 -15.322628437310858
		 22 -7.9197161939018947 23 -4.7588477761030976 24 -1.7704288425935479 25 0.62166565393448014
		 26 2.4874482529913102 27 3.8840497561229954 28 4.8540520426510003 29 5.4184178082391128
		 30 5.5969551528766512;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY";
	rename -uid "CF893C2F-4E9B-9AC1-136E-97BEE71EE80C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 18.078697047608539 1 16.581238734787068
		 2 13.380157893725741 3 6.1438032952146875 4 -5.8159613155845573 5 -17.783719057719207
		 6 -24.880937150715361 7 -24.643719457337856 8 -16.124338974865982 9 -13.402595699682282
		 10 -8.0187312881469737 11 -0.91167601006362098 12 6.8388577039033356 13 14.189091863402972
		 14 18.84529110578459 15 21.410105950413975 16 21.881526269613587 17 20.439706419028379
		 18 19.56487973020193 19 17.886607085473745 20 15.71623863612602 21 14.041354071835551
		 22 13.361248506207328 23 13.418859047787743 24 13.889237490965073 25 14.648417133641729
		 26 15.558028721950985 27 16.485136671842913 28 17.298477119257843 29 17.868426885084329
		 30 18.078697047608539;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ";
	rename -uid "5F1BD00A-4410-AD0B-02C3-4BBF54FFF2B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -34.106206373824712 1 -30.40483897011751
		 2 -24.425736794112236 3 -6.8223986065539197 4 15.757686009665617 5 28.245730291969966
		 6 27.661968593788586 7 16.924753579991972 8 -5.7754626578061501 9 -1.9687948267389288
		 10 -3.5152738495726195 11 -10.388892915627707 12 -22.543533391003638 13 -43.823714757772997
		 14 -62.838916455835367 15 -61.795798552501239 16 -61.588212290446016 17 -62.6100086646181
		 18 -39.499272462433353 19 -17.158491821916328 20 -8.1676761900886259 21 -9.8531598371285369
		 22 -19.616935936021306 23 -24.556022140067185 24 -28.61880685631689 25 -31.23444457749785
		 26 -32.795160723773719 27 -33.646683754849604 28 -34.03830552967873 29 -34.134264311020132
		 30 -34.106206373824712;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY";
	rename -uid "57C37137-4DD7-D3E7-1BB9-C3A0573D2AD0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -0.076412211346688977 1 -0.012143238107769126
		 2 0.11209039988879275 3 0.75266230651205623 4 2.5874475548413547 5 4.3319112547311418
		 6 4.3913931065298941 7 3.0174063286783941 8 1.0122069328939152 9 1.3436389449320383
		 10 1.3390269877151666 11 0.97581560680008217 12 0.43085428102710899 13 -0.099642601034736891
		 14 -0.45199667391380133 15 -0.6114545930133245 16 -0.63135035576174114 17 -0.4958224068432352
		 18 -0.056152860486705578 19 0.61842992324216461 20 1.0235072720981464 21 0.86529449272150794
		 22 0.39489714531910203 23 0.21907097426796221 24 0.097520656910822706 25 0.023307756684473453
		 26 -0.021814388744978479 27 -0.049684791589716448 28 -0.066313821917550003 29 -0.074487336254450406
		 30 -0.076412211346688977;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX";
	rename -uid "E486254A-4284-0111-3FF3-47BB9B6F49DB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.9973669760919477 1 2.5887041378671385
		 2 1.7843225968566785 3 -1.3101975497735507 4 -4.1494193667600037 5 -6.221879544177324
		 6 -6.4506927812351726 7 -4.283329026918369 8 -2.0470330896390849 9 -3.8822071424558269
		 10 -2.6457824402298913 11 -1.7323837368855879 12 -0.12090041575890281 13 2.0095703977678134
		 14 3.8777381156594739 15 5.9384389564715834 16 6.2167675858204721 17 4.105462964268888
		 18 1.5546088595570589 19 -1.0202289770014019 20 -2.1004087531540883 21 -1.6284247435141117
		 22 -0.061156767300132614 23 0.78438789445389923 24 1.4829116059952216 25 2.000628558657394
		 26 2.3803288910062816 27 2.6576358583215267 28 2.8497549716967709 29 2.9619735504083002
		 30 2.9973669760919477;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ";
	rename -uid "F61DEC64-4354-27E0-4D38-9586C1534B27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 17.952110477348128 1 15.804676666037899
		 2 12.435017273185592 3 2.1231714547331602 4 -12.094788722028419 5 -20.859131292199503
		 6 -20.999913097650168 7 -14.078372915353118 8 -0.21895127337413303 9 -1.8175045534584218
		 10 -0.14449022021255314 11 4.9217628980070618 12 13.24169584657168 13 26.40319453286093
		 14 37.765298173025037 15 36.840645374477376 16 36.33047986345354 17 36.70173607336897
		 18 22.939596245458553 19 9.6120218103608721 20 4.0751556258241948 21 4.9116914116939565
		 22 10.368396048943294 23 12.88168651136202 24 15.02517477377037 25 16.426536816059738
		 26 17.261120940615129 27 17.714376425362993 28 17.920923358478799 29 17.969095674838371
		 30 17.952110477348128;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY";
	rename -uid "2AF76C51-4FB9-E0D0-2111-3E95935F893D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 15.93442063082092 1 15.458136844097792
		 2 14.563441550908298 3 13.415442817185216 4 11.955513904393081 5 11.574242135258881
		 6 11.174997170031602 7 10.153116752156141 8 11.029850909324209 9 11.840036873085008
		 10 11.536086389692461 11 12.135021217646235 12 13.051299375524527 13 14.80209852141814
		 14 16.604600373361468 15 16.893759553368074 16 16.731518310814803 17 16.182101124081086
		 18 13.894664311933356 19 12.262099580741715 20 11.768210316072288 21 11.918704626886905
		 22 12.624906084553549 23 13.230579848362877 24 13.872368827383617 25 14.451425375456401
		 26 14.951562399560412 27 15.362270612293303 28 15.672631307929811 29 15.867863812496866
		 30 15.93442063082092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX";
	rename -uid "ADAEEB96-475C-E1D4-8D36-048A9CEEAAE0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -24.436306507811004 1 -24.923743915345359
		 2 -25.773114243353341 3 -24.113099861459627 4 -21.272326044464116 5 -18.027283809842427
		 6 -17.617299544518271 7 -20.85188041426553 8 -28.14700909097105 9 -25.547689564044685
		 10 -24.856840609858047 11 -23.574789215643165 12 -22.636631852871851 13 -21.630765501470957
		 14 -20.95745227432333 15 -23.49443899314225 16 -24.652410493809903 17 -23.572218174354603
		 18 -24.72290496339679 19 -24.997903702291932 20 -24.93462526404933 21 -25.085756001227622
		 22 -25.292745768793171 23 -25.122699814996722 24 -24.870984726651994 25 -24.638722260725114
		 26 -24.480167057557619 27 -24.406633215891247 28 -24.398757919723575 29 -24.421423217762722
		 30 -24.436306507811004;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ";
	rename -uid "943F81DF-408F-C16E-0917-4B90C9713B27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.5486968106674328 1 1.3513494649225357
		 2 -1.6307029370026684 3 -0.041883996381112384 4 8.9616890073118736 5 19.806140857569559
		 6 28.088639221082985 7 30.774257912875587 8 23.814581789467965 9 24.123650241449752
		 10 25.454944906995681 11 27.867442740910818 12 31.161470810756175 13 34.797333762594342
		 14 38.276412968372426 15 41.182975313479361 16 44.906138260166088 17 49.715255245415939
		 18 53.024157736238443 19 51.738515331409886 20 41.299303444618261 21 26.747992738655828
		 22 16.660584585669895 23 12.456679580855258 24 10.860645543320661 25 9.0302305331671029
		 26 7.150698563964732 27 5.3947705030003759 28 3.9303206535015809 29 2.9242636486808165
		 30 2.5486968106674328;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY";
	rename -uid "8AB76FB7-4DDF-3EBF-C04A-3489F08E5868";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.010426873067906442 1 0.16392527479425562
		 2 0.19097588803690529 3 0.0678329410620329 4 -0.51570110965647775 5 -1.3705409105701478
		 6 -1.266121760619114 7 -0.74729340740283967 8 1.8363746328795396 9 0.82440889947493712
		 10 -0.5352201921660239 11 -2.1494481966993928 12 -3.878760032699204 13 -5.4916205749620666
		 14 -6.6372272719696834 15 -7.1974191114476858 16 -7.2175960058467599 17 -6.4459272717105627
		 18 -4.6641722186843202 19 -2.1784277489026755 20 -0.081672033837477273 21 0.47185154766757531
		 22 0.088920201103029742 23 -0.23940625862915396 24 -0.44874225728919548 25 -0.53083404293375647
		 26 -0.4910825403448979 27 -0.36136517233395299 28 -0.19330626917295057 29 -0.04905752669493732
		 30 0.010426873067906444;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX";
	rename -uid "654D539A-4B84-1D30-C841-34A49BF4DA86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 9.1840395930213834 1 7.4000700372807371
		 2 2.5717389252213265 3 1.4623006158359213 4 4.625125036016934 5 4.4201861204781787
		 6 2.6552879963771105 7 1.3956223380133435 8 -4.7225330209411691 9 -2.0908279567408825
		 10 1.2704328607545514 11 4.5459543917815184 12 7.0876303232889963 13 8.646305994213785
		 14 9.149954293166024 15 8.9290892729889233 16 7.8632752008675766 17 5.955329632420379
		 18 3.846980637534819 19 1.8841679810440657 20 0.10196856342888341 21 -1.0529936746905137
		 22 -0.35546315341266332 23 1.3795221455593982 24 3.0928306629105959 25 4.7089440408901986
		 26 6.1639772140452731 27 7.3961896290065612 28 8.3477364442850295 29 8.9634668288644281
		 30 9.1840395930213834;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY";
	rename -uid "D5832DB6-422D-7AC3-A96D-DC91158C89F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 37.744698874691927 1 35.944995250749841
		 2 31.061630152041744 3 24.598050591197001 4 19.080961113907836 5 16.970950203884779
		 6 19.874352049032741 7 25.681595682402545 8 29.507797424282625 9 29.810283946300011
		 10 27.69532660830086 11 23.646798027719321 12 18.015534091401015 13 11.130508726469918
		 14 3.9689957331129113 15 -1.4780545732690409 16 -1.6334690917727468 17 2.1103973895598944
		 18 6.2782187847864943 19 10.203112990493908 20 13.57586244276143 21 17.029899450862938
		 22 20.532523577028584 23 24.03886916943808 24 27.403666952117565 25 30.437979283187303
		 26 33.008868758478663 27 35.043934036230226 28 36.516564408746341 29 37.424860400635694
		 30 37.744698874691927;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX";
	rename -uid "B1908A53-467A-3843-56E9-DAA2DF109B54";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -11.98778207991406 1 -15.677933755937048
		 2 -23.881634910526511 3 -32.993541782733381 4 -41.489749688868137 5 -48.523880890455793
		 6 -51.990496380108624 7 -48.82552595473463 8 -38.728957586702187 9 -25.535770909723645
		 10 -11.111000418556801 11 2.7082488292845248 12 14.774444802539884 13 24.445305375404168
		 14 31.104319646038704 15 34.635539424992885 16 35.41037644376523 17 34.384472144704077
		 18 32.582615033531738 19 30.102206192789428 20 27.020278997474602 21 23.484387285493888
		 22 19.501892959271512 23 15.078820461881328 24 10.264009487504893 25 5.185735807950218
		 26 0.12309460587162994 27 -4.5566930635087983 28 -8.424392558460708 29 -11.037408704657077
		 30 -11.98778207991406;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "12345117-41EC-DB1B-419C-29AA5DF6BE04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.9197862161148027 1 3.2550940881982742
		 2 -2.1330558712512628 3 -6.5328454765490305 4 -8.2065748242007324 5 -6.9227266150950539
		 6 -2.325531323818061 7 6.3898973998161521 8 18.43613145565056 9 29.481736228557999
		 10 40.05162677597103 11 49.493395808108147 12 57.666022774589436 13 64.626318748673896
		 14 69.276211672621514 15 70.930473610533426 16 68.194850842686222 17 62.080397496769564
		 18 55.006959033874786 19 47.918503759899195 20 41.858404565109083 21 36.355746713309536
		 22 31.661303604618752 23 27.350192296169908 24 23.126345368295851 25 18.970669354545198
		 26 15.005487463101236 27 11.433732560482728 28 8.5346182845477507 29 6.6081753581743472
		 30 5.9197862161148027;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ";
	rename -uid "D320BE58-44B4-B6C4-71E1-6EA346A807DB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 36.812727675331793 1 39.40792617562488
		 2 45.274990225563847 3 51.760782683459041 4 57.450679475870913 5 61.76056276951482
		 6 63.838729789120144 7 62.719740890533764 8 58.208588967641099 9 50.827921955585126
		 10 39.000079870419846 11 24.732342472661045 12 10.180401508232471 13 -4.6179014843368869
		 14 -17.754232397340239 15 -25.592910570850798 16 -21.64506569227478 17 -9.6530806952924877
		 18 2.366004387808895 19 12.214483581591139 20 19.750591133664589 21 25.457818110443835
		 22 29.455276237983629 23 32.16978266564545 24 34.035638083908559 25 35.419541213222445
		 26 36.295549724180162 27 36.733754299535022 28 36.860591957023153 29 36.838780082195768
		 30 36.812727675331793;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY";
	rename -uid "3A8477DC-410A-5569-6217-D7863F76DE04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.021013933637111154 1 0.029208731362961319
		 2 -0.029620537562825601 3 -0.21375920441105209 4 -0.47782791314068312 5 -0.76044983062630811
		 6 -1.0052530578405374 7 -1.1537945247417705 8 -1.1338973998446287 9 -0.83585906259713216
		 10 -0.32217199068849023 11 0.011315084211405341 12 -0.28031420908742527 13 -1.222187587882289
		 14 -2.2108862211118101 15 -2.4646497421632647 16 -2.1833488236772034 17 -1.5867429735550249
		 18 -0.91299676417460118 19 -0.42407322929711094 20 -0.16375173295823539 21 -0.045534058321718585
		 22 0.00013251744839916675 23 0.014718560593680003 24 0.019698128222311709 25 0.022426278307822334
		 26 0.023777075441207388 27 0.0238872264143874 28 0.022895818414180966 29 0.021600023918682331
		 30 0.021013933637111154;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX";
	rename -uid "EE99800E-4662-467A-7DB4-26850E6C2859";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -6.563226362957951 1 -6.03373321688884
		 2 -4.8744960144393641 3 -3.830733361238075 4 -3.5131833175985054 5 -4.1307333744530101
		 6 -5.3606374267612953 7 -6.0978523791532888 8 -5.5631379087047881 9 -4.7757182667879707
		 10 -4.8834001923707273 11 -6.4829074467882988 12 -9.1684438988694446 13 -12.105449204009624
		 14 -14.328303861994966 15 -15.259826584020029 16 -14.805190436808171 17 -13.331280267138776
		 18 -11.441220351288173 19 -9.5589918411761925 20 -8.1516121721599379 21 -7.1196489396967735
		 22 -6.5081721855944945 23 -6.2160497769877123 24 -6.1107627924870531 25 -6.1109741119616139
		 26 -6.1818248428681155 27 -6.2977769697282335 28 -6.4246172904890608 29 -6.5244294719251892
		 30 -6.563226362957951;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX";
	rename -uid "D6878ACB-4471-BDD9-EADC-C09E17DD964E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 35.390343278663707 1 35.200940480685894
		 2 34.717476826327989 3 34.147790478040221 4 33.721628480427114 5 33.551421823368202
		 6 33.600689504421496 7 33.714216615927633 8 33.874409148976952 9 34.050994140351627
		 10 34.04210624541696 11 33.637424005969422 12 33.028243934743401 13 32.63472613916823
		 14 32.750545119592189 15 33.36596378434907 16 33.682122916038381 17 33.63226497571803
		 18 33.633952721683791 19 33.780028920095177 20 34.044870037441584 21 34.199378503542235
		 22 34.297257125519465 23 34.360789845613525 24 34.421074603211046 25 34.525794554123685
		 26 34.696948470925506 27 34.917725992036488 28 35.145129996848723 29 35.321547595750538
		 30 35.390343278663707;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY";
	rename -uid "DA6B5E50-4138-2CD5-96D6-1AA89AAD8C63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -3.3136563322747685 1 -3.0996930535657485
		 2 -2.7069667397489208 3 -2.4628103871595299 4 -2.420226352196075 5 -2.300193369161962
		 6 -1.684168854759253 7 -0.59125000123343086 8 0.41095936897828217 9 0.23896121185331431
		 10 -0.75525763123687528 11 -2.0034239077404696 12 -3.1788689657421565 13 -4.5321255780642016
		 14 -6.1312380622099969 15 -7.4493781908702204 16 -6.9870578295535983 17 -5.3942880057084706
		 18 -4.0636480732436846 19 -3.1213731709881261 20 -2.3249378010002251 21 -1.8005951125789879
		 22 -1.5335748921986148 23 -1.5014627604854687 24 -1.6537455771907001 25 -1.9186696364519424
		 26 -2.2666584188019949 27 -2.6408312922673169 28 -2.9798637560730712 29 -3.2224222521636472
		 30 -3.3136563322747685;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ";
	rename -uid "125616A9-47CF-44F9-8E34-AF986ED7D46D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -37.563317406266265 1 -39.098364584167285
		 2 -42.443985197995154 3 -46.284296427224774 4 -50.502970043269436 5 -55.475616802222959
		 6 -61.034344752561573 7 -65.262580293454022 8 -65.778897067231327 9 -60.907611984181756
		 10 -51.600093058201352 11 -40.519307309017208 12 -30.128147575489557 13 -20.71323921504942
		 14 -12.997423835674198 15 -9.0959631757966406 16 -11.760196247900341 17 -18.420575844250074
		 18 -24.723005535670154 19 -29.54301799800648 20 -33.60782312288331 21 -36.501051693114327
		 22 -38.489246333995808 23 -39.53586659194125 24 -39.817743353690979 25 -39.73960014091103
		 26 -39.360145495422636 27 -38.794503075789649 28 -38.196329789038984 29 -37.737135612409368
		 30 -37.563317406266265;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ";
	rename -uid "7B8904EF-419B-10C3-502B-A091DD2EA857";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -2.9277483643209314 1 -2.814577862157956
		 2 -2.4415132938230917 3 -1.8220303867941445 4 -1.3126819479319949 5 -1.6022579586982817
		 6 -3.481447648941721 7 -7.3213383765120108 8 -12.434442774331462 9 -18.071082859194661
		 10 -23.387180569334724 11 -27.593918256327367 12 -30.376315381531434 13 -31.71577507899789
		 14 -32.052335188639177 15 -31.823846628070186 16 -31.238331567959037 17 -30.394390724958519
		 18 -29.278745013824075 19 -27.733589399214871 20 -25.646760527076207 21 -23.022104345021663
		 22 -19.97037262421706 23 -16.794947376985593 24 -13.710110035014411 25 -10.834522474943466
		 26 -8.258709400959555 27 -6.0775694734178556 28 -4.3934328730120171 29 -3.3100353087940952
		 30 -2.9277483643209314;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY";
	rename -uid "286D1911-4530-FA28-FE69-68B2A0AAE8C1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 1.3982047526747146 1 1.2686644051889555
		 2 0.96777655860680001 3 0.65006624766783583 4 0.45719643876119315 5 0.46639339669584573
		 6 0.79986154571460066 7 1.6388799409709043 8 2.9581124677999404 9 4.7294428832568736
		 10 6.8613123826514375 11 9.1373396434860688 12 11.330211964718933 13 13.163192281229259
		 14 14.331793260572447 15 14.622944585970023 16 13.963303553070766 17 12.643383568973018
		 18 11.09245311337839 19 9.3997487323869127 20 7.7049364698594989 21 6.1961180186867164
		 22 4.9695834962809915 23 4.0288678225880989 24 3.3286689851369502 25 2.7917155760005339
		 26 2.3533926411727282 27 1.9819130847235449 28 1.6795603618434087 29 1.473267746835625
		 30 1.3982047526747146;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX";
	rename -uid "E1FCEAF1-44E7-B32D-6E71-4D8557D2390A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 14.118717229646881 1 13.116511498296726
		 2 10.810648871766121 3 8.3214347614855271 4 6.6321113843409902 5 6.3020020467750815
		 6 7.4486224770317655 7 9.2737604258056336 8 10.866148129209565 9 12.318882496885294
		 10 13.762942057655895 11 15.257398702292878 12 16.838356060320322 13 18.442001713063242
		 14 19.694712912714397 15 20.213325280193477 16 19.78618328654677 17 18.621297375038314
		 18 17.180987739084031 19 15.58740955515465 20 14.00466340390723 21 12.675696536956528
		 22 11.765143099034498 23 11.277994322127016 24 11.214142660139768 25 11.513130362145811
		 26 12.068178333148527 27 12.748572922220584 28 13.413351954075688 29 13.91826061711614
		 30 14.118717229646881;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ";
	rename -uid "D9F24CCB-4FFC-9270-0BF8-478B11EA2023";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -4.3875784545952472 1 -4.6222258134726282
		 2 -5.3053466103282076 3 -6.3205297522555082 4 -7.261901099015331 5 -7.6447772385997395
		 6 -7.4388925189119384 7 -6.7319094715143617 8 -5.8078308150401829 9 -4.9572662731866677
		 10 -4.1905830365149441 11 -3.456552408538978 12 -2.6907233308673111 13 -2.0233324796337513
		 14 -1.4923857265370262 15 -1.0938670277253855 16 -0.828404284586293 17 -0.75435731589226063
		 18 -0.88386810187624321 19 -1.159932611532821 20 -1.510811159713648 21 -1.9084607709675037
		 22 -2.3270258315789212 23 -2.7434219624676635 24 -3.1381298921207312 25 -3.4949946110556009
		 26 -3.8019249749805071 27 -4.0501298170645663 28 -4.233637341261165 29 -4.3478853491977034
		 30 -4.3875784545952472;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAX";
	rename -uid "070C4C09-4F2C-DC05-9D1E-CDAE269C581E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.34814221170011234 1 -0.84966714281942091
		 2 -3.5215831081639082 3 -6.2990115043266535 4 -7.8942118960977954 5 -8.0238607124200865
		 6 -7.2430455114154642 7 -5.3543012415376641 8 -2.4732546158988615 9 0.90705663969326233
		 10 4.1794028968059971 11 6.5539392855910377 12 7.5503847681411562 13 7.3227858494378015
		 14 6.2905690899609628 15 4.9996455012821084 16 3.6653633172815443 17 2.5082723485178557
		 18 1.7373261560653035 19 1.2909294418019384 20 0.96156850234697133 21 0.72771517002158281
		 22 0.56859572238555423 23 0.46541528225320317 24 0.40220409779383437 25 0.36633592085905597
		 26 0.34838085682986752 27 0.34181788933993812 28 0.34213235222401478 29 0.3456703030143578
		 30 0.34814221170011234;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAY";
	rename -uid "247BAA1B-4347-9142-230A-61ABD453D032";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -3.2935213919950703 1 -2.907243177185026
		 2 -1.828538588514288 3 -0.28038781051901146 4 1.2968467306306724 5 2.4123772817218079
		 6 2.7444455792436417 7 1.684336862510545 8 -0.59679476542337695 9 -3.142783404626075
		 10 -5.032364032809431 11 -5.5680942569271048 12 -4.9941441014046033 13 -4.1482293528118444
		 14 -3.228325554524381 15 -2.2494620139758044 16 -1.3251425691896253 17 -0.60770939797593415
		 18 -0.26146630909031404 19 -0.23273139408160531 20 -0.3320530858668363 21 -0.53824204456194202
		 22 -0.82991106248263191 23 -1.1846641676880083 24 -1.5787659876303761 25 -1.9868836179525757
		 26 -2.3828160013930613 27 -2.7392507710329084 28 -3.0284412456513969 29 -3.222589561707685
		 30 -3.2935213919950703;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ";
	rename -uid "3D60CA97-445D-605F-55E3-D78DE90F1BD4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -8.9064865746532611 1 -9.3059690191863158
		 2 -10.461172960425484 3 -12.233416159220056 4 -14.024518216916778 5 -14.902641800871155
		 6 -14.636105026041589 7 -13.301587614711977 8 -11.544805775114684 9 -10.047559869506673
		 10 -8.7150657917980769 11 -7.2310906364858036 12 -5.5196880288166241 13 -4.060627124591651
		 14 -2.951263033336871 15 -2.1345945256860195 16 -1.6053354387556205 17 -1.4713292548676389
		 18 -1.7454405767540797 19 -2.3081762162210526 20 -3.0176949742963455 21 -3.8192340835121836
		 22 -4.6632079064896512 23 -5.5055067486595259 24 -6.3079115184441257 25 -7.0389038294303896
		 26 -7.6730777511472441 27 -8.1911673606535711 28 -8.57826761197399 29 -8.821436458728888
		 30 -8.9064865746532611;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY";
	rename -uid "3B932A6E-4419-9818-BD90-A2960BDCA8AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -6.0306789089568511 1 -6.0483849477381302
		 2 -5.7138539122152645 3 -4.6456475757393374 4 -2.8277249966475582 5 -0.87784368584203243
		 6 0.28830910476068433 7 -0.37329898417857199 8 -2.7318921055927516 9 -5.3745814088266366
		 10 -6.9398996679131697 11 -6.584115385501625 12 -5.0166066551559565 13 -3.6423556584481713
		 14 -2.5521031780729668 15 -1.4585421179030971 16 -0.46478203292507725 17 0.25320131788451244
		 18 0.48568843312445464 19 0.29360388669514448 20 -0.079079687477592031 21 -0.60311690345140967
		 22 -1.2480750853675748 23 -1.9807106427368146 24 -2.7639811105254899 25 -3.5569594118796579
		 26 -4.3150953750539873 27 -4.9909991396736011 28 -5.5355837282299296 29 -5.8987307014573629
		 30 -6.0306789089568511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX";
	rename -uid "FA4A9616-48EF-79B6-D2C9-3FA902F11203";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 2.7327511245327498 1 0.2244131357960005
		 2 -5.5024465364992023 3 -11.715600982667729 4 -15.721203822303833 5 -16.694402232976763
		 6 -15.451934015004019 7 -11.199446810113605 8 -4.2867323848324812 9 3.7244053254955727
		 10 11.100507127695078 11 15.900789428491072 12 17.398074497903927 13 16.431038126759031
		 14 13.906645510302216 15 10.865769005069845 16 7.7804443130590384 17 5.1552686741857814
		 18 3.4801915087123594 19 2.6068869145606919 20 2.0328625994838956 21 1.7066075768400961
		 22 1.5777007479646024 23 1.5981606312320074 24 1.7237457003883419 25 1.9145986329214177
		 26 2.1354454496915518 27 2.3552085984972035 28 2.5459381749229149 29 2.6809945487227753
		 30 2.7327511245327498;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ";
	rename -uid "43753223-4AED-4E59-C9C4-B786DCA1FA10";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -8.9248389169076816 1 -9.331382590957233
		 2 -10.466362139154505 3 -12.158861004481748 4 -13.863490157397372 5 -14.711846976783201
		 6 -14.470312132331067 7 -13.214999899168289 8 -11.538513077525623 9 -10.055825764918133
		 10 -8.6541045169248196 11 -7.0740103839872752 12 -5.3178942053414078 13 -3.8762722859977821
		 14 -2.8177363581038333 15 -2.0522699011804102 16 -1.562976907605538 17 -1.4529811247907451
		 18 -1.7373624023937579 19 -2.3036113684087516 20 -3.014794140566202 21 -3.817348517259838
		 22 -4.6623543580321387 23 -5.5061222385765669 24 -6.3106452981962287 25 -7.0443854810613926
		 26 -7.6818678180170483 27 -8.2033798771486168 28 -8.5935608059417934 29 -8.8389665841429323
		 30 -8.9248389169076816;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY";
	rename -uid "FD31155A-4B24-F8B5-4FD9-AFA28AC0167B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -5.7924479629026067 1 -6.0108983690174593
		 2 -6.1356722517452207 3 -5.5632341376337697 4 -4.0629283612032427 5 -2.1937763593144464
		 6 -0.93541552996456012 7 -1.263545651623702 8 -3.0662016381763006 9 -5.0592186183280035
		 10 -6.0347374354328815 11 -5.3070516681777642 12 -3.6295043624370766 13 -2.3333128920278634
		 14 -1.4412885577901644 15 -0.5888759530023514 16 0.15800406042783652 17 0.66478825335154457
		 18 0.76274878311734351 19 0.50139395847033885 20 0.083981557294272258 21 -0.46448520947746952
		 22 -1.1176938107460916 23 -1.8463597038365482 24 -2.6170578814119883 25 -3.3922264996928098
		 26 -4.130196164229508 27 -4.7863756894144069 28 -5.3139112063439491 29 -5.6650808635303518
		 30 -5.7924479629026067;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX";
	rename -uid "77FF4E5C-4AF1-0B10-EE81-53A52F7649C9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.2080861726087564 1 0.70995230590698788
		 2 -5.0274290816350407 3 -11.313228980843919 4 -15.45462908549217 5 -16.576344197429975
		 6 -15.426888964155619 7 -11.135000064029356 8 -4.054541732132793 9 4.1431464268594098
		 10 11.612986231731856 11 16.360673480018757 12 17.729356457627876 13 16.661045169273098
		 14 14.062128581631228 15 10.946421461158446 16 7.7926382796549492 17 5.1186119650113628
		 18 3.4301765925887788 19 2.5750146770557176 20 2.0326595259330666 21 1.7494159970533283
		 22 1.6725776160489865 23 1.7516870864635588 24 1.9396565104504837 25 2.1935309174215347
		 26 2.4745755205537567 27 2.7479976166265856 28 2.9819620698983109 29 3.145869316020891
		 30 3.2080861726087564;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ";
	rename -uid "2F2A80F4-409B-85EB-3805-AFA3DCA20809";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -8.7662343333443005 1 -9.184209860628588
		 2 -10.542293614136153 3 -12.756472138654999 4 -14.914402130554119 5 -15.835642787568148
		 6 -15.391192879942725 7 -13.715950102575466 8 -11.612956632809222 9 -9.9422071725815986
		 10 -8.7399062780477017 11 -7.6170283572748438 12 -6.1751554635850754 13 -4.7231672345382965
		 14 -3.4545303693670806 15 -2.4633028617546509 16 -1.7891319281339442 17 -1.5602311808511142
		 18 -1.7884056093149945 19 -2.3319226408589606 20 -3.0304968563725216 21 -3.8245280252733886
		 22 -4.6606441941755135 23 -5.4921487639926863 24 -6.2794006622561929 25 -6.9906622957471791
		 26 -7.6016430082039594 27 -8.0953516245877832 28 -8.4602275000854874 29 -8.6873102940397331
		 30 -8.7662343333443005;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY";
	rename -uid "2A20A5A6-4E86-5533-2EFE-EF8995318C3B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -6.618552830983929 1 -5.6254692260971311
		 2 -3.0232600366912235 3 0.41881315634320637 4 3.6554542165523025 5 5.8299460395003244
		 6 6.4210196298683302 7 4.140493882832688 8 -0.77825930744882599 9 -6.4175924611582431
		 10 -10.808655907369731 11 -12.386352338140236 12 -11.532837546333264 13 -9.8906305287215233
		 14 -7.8971429938247555 15 -5.6899243712296634 16 -3.5493719988883563 17 -1.8405303888204496
		 18 -0.95515236517566859 19 -0.78006266646824018 20 -0.89041173753205016 21 -1.2388961485482788
		 22 -1.7774504226153138 23 -2.4563548861951574 24 -3.2237923333103979 25 -4.0263386985238396
		 26 -4.8088984732429658 27 -5.5157269850344024 28 -6.0905819543458062 29 -6.4770598802669879
		 30 -6.618552830983929;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX";
	rename -uid "ACC65BB3-4AC7-9412-52BA-C4825C6369AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.064639052844944617 1 -2.2367856835186974
		 2 -7.3303885609123247 3 -12.584237374023392 4 -15.553731135626002 5 -15.694544380055726
		 6 -14.087201017561803 7 -10.421623097531866 8 -5.0220578148664279 9 1.2400356324798616
		 10 7.3893230618094092 11 11.995843480318339 12 14.02671228844407 13 13.671987147453526
		 14 11.759851794528078 15 9.3851612090538374 16 6.9435965238818449 17 4.8229606366498672
		 18 3.3817124618932857 19 2.5047586635811925 20 1.829250158295451 21 1.3196701640139967
		 22 0.94197957929607357 23 0.66557859915005357 24 0.46466347656265122 25 0.31915991000256982
		 26 0.21460173127765497 27 0.14175536702880831 28 0.095145568632851618 29 0.071007162047114228
		 30 0.064639052844944617;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ";
	rename -uid "4CCB7072-4388-19A3-954A-4EABA8489474";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -13.826424484316885 1 -13.178060711137988
		 2 -11.484797955383124 3 -9.1179529613969521 4 -6.4638344736027591 5 -3.9457909385396071
		 6 -1.0217570472039452 7 2.7933883335609941 8 6.8996871483272892 9 10.645898249202533
		 10 13.394615998711187 11 15.95246040432353 12 19.21318486547786 13 22.730663420678113
		 14 25.98839676601105 15 28.323210513468268 16 28.937425047020412 17 28.056072251785253
		 18 26.57304886478758 19 24.689484392746373 20 22.609361043583867 21 19.31118068722591
		 22 14.161811456886552 23 7.955457092499624 24 1.4897007713269417 25 -4.4629492998832552
		 26 -9.1841232706191214 27 -12.009810038042486 28 -13.219384979550204 29 -13.725397698236099
		 30 -13.826424484316885;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY";
	rename -uid "E87362CB-467A-D80C-0059-E1BB33E830F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -5.3593833091468115 1 -5.9044274355096702
		 2 -7.2939481702617712 3 -9.1531978714075581 4 -11.121920463879206 5 -12.876096318147351
		 6 -14.270331642151152 7 -15.124908519480648 8 -15.148946161287732 9 -14.105794880385218
		 10 -11.766806924893906 11 -7.7252284260591786 12 -2.3792666471639552 13 3.3414185123727118
		 14 8.55204888830621 15 12.434382731950201 16 14.216593292902335 17 14.207604374855297
		 18 13.290719808816714 19 11.543802571037959 20 9.0523258851406698 21 6.7256705040497664
		 22 5.1619534972369356 23 4.0732514114588287 24 3.2352222651913234 25 2.4057401903907571
		 26 1.259082543253534 27 -0.6275317835925206 28 -2.9245713494772354 29 -4.6671818423307956
		 30 -5.3593833091468115;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX";
	rename -uid "B9B3A598-4B00-8946-4FAD-93AEA650AA4C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 6.9922855747722616 1 6.6486792045089738
		 2 5.7308150133924167 3 4.4006617155424737 4 2.8487329380885869 5 1.3226096172798618
		 6 -0.93650885976194176 7 -4.2388165232512289 8 -7.5761446440636018 9 -9.9592312619569068
		 10 -10.519127311369457 11 -9.5629865121877451 12 -7.9352482639799087 13 -5.807648466451103
		 14 -3.5045101637996492 15 -1.5183936140835277 16 -0.44395863049380407 17 -0.22644456336106436
		 18 -0.3729013386361027 19 -0.78028413057724122 20 -1.3591090327272386 21 -1.7168815655580645
		 22 -1.4101845121736634 23 -0.41689470405193757 24 1.1383051007191789 25 2.9990727189426578
		 26 4.7959121981175645 27 6.0625265202216196 28 6.679226912893701 29 6.9431057408713075
		 30 6.9922855747722616;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ";
	rename -uid "E8E79E12-4D2E-5093-47A1-9087113B84CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -8.381865146375155 1 -0.5485657365310036
		 2 14.247214294323781 3 29.74213188265071 4 40.585381337783339 5 44.888053681480208
		 6 47.036512779302434 7 45.330669332770611 8 34.163096353156128 9 15.220406144610305
		 10 0.44098583411816478 11 -0.25794520197212545 12 5.578238268400014 13 12.777828753260568
		 14 17.16089414948928 15 18.494851671883442 16 22.878605846410181 17 30.62285073132583
		 18 38.568990856945398 19 46.305736230558459 20 53.29252687190791 21 57.79726185139485
		 22 58.427971575833077 23 55.297346028081925 24 47.641831712987383 25 35.724298169642438
		 26 22.468399452732211 27 10.702439000032351 28 1.2365156890550912 29 -5.6715949875166691
		 30 -8.381865146375155;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY";
	rename -uid "F811A369-4B5F-9CE6-2275-84B8E04703A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 40.357878794094511 1 36.988057138533854
		 2 29.486028376133177 3 24.244034021555972 4 22.886264387792266 5 24.89496432349549
		 6 28.906066411259765 7 30.407493128663948 8 32.576938607046387 9 36.674268830050543
		 10 37.712000338938168 11 38.474736073854054 12 40.639884687005789 13 42.399240283716935
		 14 43.921609152762841 15 45.469125687867333 16 45.128103709072441 17 42.396528982122831
		 18 38.497431444139821 19 33.723180048628954 20 29.205563351451474 21 25.225858694506456
		 22 22.681104450386883 23 23.465698041910283 24 27.174470602713154 25 31.421801737034492
		 26 34.776912095308845 27 37.219763142221332 28 39.053045429710671 29 40.030821296553057
		 30 40.357878794094511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX";
	rename -uid "D76000EF-428C-023A-5DBF-C5967337AAED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.8146011058006946 1 13.638619160086403
		 2 30.913789184092629 3 42.87557623264194 4 49.854172085330411 5 54.427562440097184
		 6 57.845903393074927 7 56.251593423207069 8 43.006865479566933 9 21.887709185874694
		 10 6.5617035479283272 11 2.5130229899330785 12 3.1202415133523127 13 7.4160893534379788
		 14 11.396694981848031 15 13.398515669485551 16 16.879761138017358 17 22.028013948781208
		 18 26.763058411726394 19 30.319372687846698 20 33.816583130852415 21 36.693097024095081
		 22 36.907209185359832 23 34.264687625452993 24 29.543584940988037 25 23.511502623176384
		 26 16.903299623311558 27 11.518580946472087 28 7.6142652533236257 29 4.8399605896982241
		 30 3.8146011058006946;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ";
	rename -uid "E73DF1E8-4153-7620-F3A1-CE81829DF0CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 62.930980634383602 1 68.663303319353346
		 2 76.589217916665376 3 76.30614295073083 4 67.235572813874867 5 58.880323493390513
		 6 54.836404301525967 7 61.817122707384819 8 71.404765144454984 9 65.906142921463029
		 10 56.092773248376815 11 57.392184476160281 12 61.561417944699159 13 61.59587168762323
		 14 55.145256355784298 15 46.730460974082284 16 42.88743070977349 17 41.986435266608936
		 18 43.961761582060909 19 50.611547801271691 20 61.23390547347816 21 74.21885995139597
		 22 87.712070999064267 23 98.694880203847106 24 104.80552781034785 25 104.65273747830609
		 26 98.559957377188084 27 88.336969267453 28 76.703923832983676 29 66.990412802929299
		 30 62.930980634383602;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY";
	rename -uid "B3394196-4AB2-EC4B-50B9-28B9CA5F95A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -7.3941419589522983 1 -7.7305299211917378
		 2 -8.0686757151449662 3 -8.059195646247348 4 -7.653826015377283 5 -7.1117195275327365
		 6 -6.7942977057487788 7 -7.3200808697547579 8 -7.8644493955288537 9 -7.57812803982943
		 10 -6.8966302973791196 11 -6.9989393631028314 12 -7.3026890256235459 13 -7.3050552202070014
		 14 -6.8197536930610871 15 -6.0573742616426731 16 -5.6642345405461052 17 -5.5682620913491601
		 18 -5.7768098237381365 19 -6.426406570562393 20 -7.2802098402859503 21 -7.9833226435687443
		 22 -8.2852310001804614 23 -8.1977654731443863 24 -8.0201105404138993 25 -8.025647464214229
		 26 -8.2006557617949287 27 -8.2882806469436137 28 -8.0724741267421365 29 -7.6401595577071122
		 30 -7.3941419589522983;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX";
	rename -uid "A00A8772-4FB5-0C39-0BB7-F9B49AF10D4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -4.5289283719285409 1 -5.2839379940493947
		 2 -6.37497588380658 3 -6.3352869244194761 4 -5.0928242944831617 5 -4.0173323080722714
		 6 -3.5275821316192779 7 -4.3862951743372367 8 -5.655981463386337 9 -4.9166444940880414
		 10 -3.6773244292635914 11 -3.8345316139042613 12 -4.3537682483183833 13 -4.358128358382209
		 14 -3.5641973237227504 15 -2.6188733989070578 16 -2.2263014555461651 17 -2.1381285764936626
		 18 -2.3333820004507624 19 -3.0410128115673531 20 -4.3121865754265389 21 -6.0439802977997665
		 22 -7.9618864409639025 23 -9.5409638984516612 24 -10.40370689741159 25 -10.382368893928954
		 26 -9.5217261800396322 27 -8.0519436692541877 28 -6.3910917951070632 29 -5.0601850953616756
		 30 -4.5289283719285409;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ";
	rename -uid "0C6E89B5-4ACC-563F-36E1-438C958488C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -12.363619147181401 1 -12.774536279026226
		 2 -7.5972611431953405 3 8.8412449070020305 4 28.133059095732197 5 38.43563648904172
		 6 40.592182455155061 7 29.857611233522057 8 7.6869798787301482 9 -5.1113266980729488
		 10 -5.2156356349804565 11 -7.3951054677298709 12 -14.016151364950652 13 -18.9161654819323
		 14 -17.976686115296427 15 -10.317048490872649 16 1.5108551151866563 17 13.88743221087733
		 18 22.854780080029766 19 26.012514307714223 20 24.423566319609499 21 19.152824097634841
		 22 10.504952167369213 23 -0.26880397229603575 24 -11.255156333230063 25 -19.63657265181287
		 26 -23.23251320423876 27 -22.017157590428329 28 -18.093697356519382 29 -14.12541396614893
		 30 -12.363619147181401;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY";
	rename -uid "F8269588-4253-F8EC-2A77-A1ABD749F56D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 18.577661590064899 1 20.317296975887039
		 2 24.271852730281523 3 24.746492451109031 4 22.127990651837084 5 21.820371929614463
		 6 22.327178937696583 7 24.124165078582401 8 24.652571954325978 9 21.003838439545554
		 10 17.75844351721641 11 17.670316010423445 12 20.113299241849337 13 22.307569232611069
		 14 22.252125936672737 15 20.856693597341284 16 18.102688118424265 17 12.680040962717039
		 18 5.9787747716104054 19 1.6981766293693188 20 1.8014659581569976 21 3.941832978850488
		 22 6.6921608885073542 23 8.8669504589657411 24 11.004972765370793 25 13.513429486241176
		 26 15.367338204709055 27 16.780609254758982 28 17.846877027963231 29 18.385838104767195
		 30 18.577661590064899;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX";
	rename -uid "0726354B-4718-7772-7289-6CA685638EF2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -9.7418046831765626 1 -20.444866547303533
		 2 -40.195950928281732 3 -53.247641089593856 4 -62.144204698197342 5 -66.356110109582616
		 6 -65.75692689548994 7 -60.079555098688907 8 -48.93001895177774 9 -34.598318080697254
		 10 -26.613407578992934 11 -27.622019145334146 12 -30.700115084852278 13 -37.461211521275388
		 14 -44.83916442175726 15 -49.579886256727995 16 -50.65130902690403 17 -50.080362814170527
		 18 -49.448327251415229 19 -48.531851393168168 20 -46.436133587866074 21 -42.673136969712047
		 22 -37.402440997593096 23 -30.796293194958306 24 -23.924364771998661 25 -18.210763027190158
		 26 -13.709274892675454 27 -10.789404115004658 28 -9.615444384234852 29 -9.5455346060775543
		 30 -9.7418046831765626;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY";
	rename -uid "C641F3A9-43BE-34C6-3249-03835C4508DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -16.687929796848362 1 -16.514365099874635
		 2 -16.088205018515644 3 -15.587996606911897 4 -15.146417813893613 5 -14.842270092814656
		 6 -14.728308973846833 7 -12.598382869481478 8 -7.227940247084029 9 -0.15409328146312501
		 10 7.0150264486932086 11 12.587166236209864 12 14.828425546567543 13 14.542611329809347
		 14 13.72934278334519 15 12.454860998820859 16 10.785723251391675 17 8.789085053339301
		 18 6.5319215012848302 19 4.0828040018362088 20 1.5092594554577519 21 -1.1209764729953926
		 22 -3.7409523570508343 23 -6.2844884478893634 24 -8.6865410489580626 25 -10.884185886831059
		 26 -12.815532807266047 27 -14.420590701012758 28 -15.640347552916543 29 -16.415901078755422
		 30 -16.687929796848362;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX";
	rename -uid "76FA00E2-43C0-7859-2EEA-CCB58C6DA01F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.5883568623633355 1 5.7728622260139009
		 2 6.1758360644793839 3 6.733057250667577 4 7.3488723986163338 5 7.8684705881667734
		 6 8.0881980858227287 7 6.8606389833099657 8 3.8054313733781591 9 -0.11323868051106782
		 10 -3.9356532930286305 11 -6.783604253577181 12 -7.8946103597339441 13 -7.7361687318022581
		 14 -7.2890787892702393 15 -6.5998754835308162 16 -5.7178426810794676 17 -4.6925638085884103
		 18 -3.571847569634429 19 -2.400508344592454 20 -1.2194529385864461 21 -0.065086234045044072
		 22 1.0312426530204934 23 2.0431868699690803 24 2.9493702286228975 25 3.7347075331102895
		 26 4.38830465193886 27 4.9042469030447515 28 5.2790416365341075 29 5.5091546346508125
		 30 5.5883568623633355;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ";
	rename -uid "DD349D04-4A72-83E3-0B3D-059760F620A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 23.09334783771487 1 22.110631132190441
		 2 19.396946987498481 3 15.765335364538249 4 12.060542208087529 5 9.1690071437582805
		 6 8.0026098979897853 7 8.5994513670961954 8 10.15323633688573 9 12.311487775210338
		 10 14.643865092351488 11 16.575796195092114 12 17.387078446019839 13 17.432526168058576
		 14 17.561105068217589 15 17.760591266186808 16 18.019144151073188 17 18.326296567872834
		 18 18.673439286295036 19 19.054169441643403 20 19.463256619480138 21 19.89617317375783
		 22 20.347750030186525 23 20.811153477170357 24 21.276599507464113 25 21.730586322006268
		 26 22.155335809280785 27 22.52910962123142 28 22.827034404863696 29 23.023247666080358
		 30 23.09334783771487;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ";
	rename -uid "843FD309-4342-6842-C208-429EB5BB792E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 54.15307408480556 1 53.022235945999014
		 2 50.007282705675877 3 45.565947721999635 4 40.100579481283589 5 33.847371477683318
		 6 26.793737096578827 7 18.895399339175761 8 10.57283360950008 9 2.4438542396487715
		 10 -4.3749233161303138 11 -8.61014924581381 12 -9.8619773196438612 13 -9.1343163992249643
		 14 -7.4299567166760498 15 -4.866411378704373 16 -1.5441769167195847 17 2.4465075482718279
		 18 7.0224900265726244 19 12.09223418070183 20 17.543155900598968 21 23.233680322379975
		 22 28.969827618734548 23 34.511506425358988 24 39.608916284217301 25 44.053624336847918
		 26 47.71452795422681 27 50.54189302413679 28 52.543254721177668 29 53.745101833406167
		 30 54.15307408480556;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY";
	rename -uid "0A1FCEED-4263-9E17-8FE5-0A9EC0343783";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 13.140750261756999 1 13.045526998872704
		 2 12.92197213967639 3 12.669058858288615 4 12.117606675596608 5 11.155541256547412
		 6 9.8693119202297375 7 9.0060020638090492 8 8.7009223927034363 9 9.1095850489411934
		 10 10.674472616999525 11 12.825937349770244 12 14.009631366083202 13 14.268855954576225
		 14 14.650412623350846 15 15.230765307997165 16 16.073104091664057 17 17.192795340637108
		 18 18.534171273849239 19 19.959425547781304 20 21.265560241957168 21 22.227075879180877
		 22 22.644256545925671 23 22.396568943435579 24 21.479161738256469 25 20.009366254888807
		 26 18.203357791565779 27 16.335589701493589 28 14.696718247595927 29 13.557775139429273
		 30 13.140750261756999;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX";
	rename -uid "8EFD2B8C-4E90-8B0C-1CB9-F4B4C194C25D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 19.074613769875452 1 13.396892063040825
		 2 -1.3684723909055649 3 -22.309228969191281 4 -46.408341687146972 5 -70.470890363361278
		 6 -91.149176114147707 7 -105.4617130173135 8 -111.04040817686915 9 -98.5768328757229
		 10 -69.242994193993624 11 -36.852922691506961 12 -15.393165078214956 13 -5.915482021315424
		 14 0.239735274745694 15 3.8108220691316244 16 5.587990163649919 17 6.3892502626242216
		 18 7.0302043001004337 19 7.8604838520474125 20 8.8429317356446049 21 10.098948916318269
		 22 11.619992509878101 23 13.28633286558556 24 14.920414222754514 25 16.354905933298834
		 26 17.483220961827378 27 18.274971864216223 28 18.761182727602044 29 19.005404817308087
		 30 19.074613769875452;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ";
	rename -uid "A7524E06-4247-BAAA-C62F-68A6E1136B70";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 52.942247258386068 1 55.294657827142522
		 2 61.504241284354052 3 70.299613501182208 4 80.397970190919722 5 90.502039208630634
		 6 99.311196781601424 7 105.53469075874193 8 107.89316480199301 9 92.332844182719242
		 10 58.059655417147148 11 24.004455121050405 12 8.4675598573129722 13 11.781079522295503
		 14 20.523695115186943 15 32.034014648935127 16 43.636665672139621 17 52.614040364352725
		 18 56.217221823214309 19 56.152763784776582 20 55.974522441373118 21 55.70527199478294
		 22 55.367851818020348 23 54.984928952118345 24 54.579312130278048 25 54.173778173949998
		 26 53.791008161351364 27 53.453763244171384 28 53.184738039606607 29 53.006672860534607
		 30 52.942247258386068;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY";
	rename -uid "8F8984FC-4D28-ABD3-0B93-2DAAD7D8BB0C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -6.3466047216384167 1 -6.5210504028589007
		 2 -6.9222622136931298 3 -7.3369232302081668 4 -7.5811682190610226 5 -7.5712803185225477
		 6 -7.3551392657318484 7 -7.0882612614836775 8 -6.963063323971868 9 -7.5421627089671128
		 10 -6.7104716690166057 11 -3.3297138410483136 12 -1.2214120322518609 13 -1.6889895865887392
		 14 -2.8785348586053598 15 -4.3092363541333114 16 -5.5424316705035199 17 -6.3213134817976355
		 18 -6.5861504652802951 19 -6.5816599584489559 20 -6.5692329343215494 21 -6.5502499359838486
		 22 -6.526283171069645 23 -6.4987756305137854 24 -6.4692753130011607 25 -6.4394406327059928
		 26 -6.4109155484973668 27 -6.3855523939933967 28 -6.3651478574248896 29 -6.3515342837505822
		 30 -6.3466047216384167;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX";
	rename -uid "78DB0D47-4253-A65F-2BB3-CFA20E59A956";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -3.8784285254330015 1 -4.1712875354376564
		 2 -4.9759394871647453 3 -6.178850341499345 4 -7.6183202136183628 5 -9.079117148650754
		 6 -10.334721847918415 7 -11.194992766103031 8 -11.512727080591956 9 -9.34257010723843
		 10 -4.5242345199979708 11 -1.014696278970205 12 -0.19730400723452268 13 -0.32319239929340993
		 14 -0.78241211667457355 15 -1.6512636868379773 16 -2.7964573731384332 17 -3.8381364150197461
		 18 -4.2880275001894947 19 -4.2798313148663958 20 -4.2572357099627771 21 -4.2231256205875551
		 22 -4.1805041640818956 23 -4.1323272705290659 24 -4.0814818430255819 25 -4.0308847699471926
		 26 -3.9832519944894336 27 -3.9414966732239534 28 -3.9082685450511296 29 -3.8863477899538035
		 30 -3.8784285254330015;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ";
	rename -uid "4E0DF214-44D4-023E-AFE3-D7AFF6F5DD32";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -49.658790052194092 1 -50.223353564141398
		 2 -51.652644199626074 3 -53.645573381619229 4 -56.061660255270048 5 -58.780514442095324
		 6 -61.524190724364068 7 -63.739517997176478 8 -64.650262393933673 9 -39.350593618460763
		 10 -21.473779617382537 11 -36.291328678204934 12 -49.658740500535743 13 -53.182275131023779
		 14 -58.832811976170916 15 -60.618242263792247 16 -58.14638874191953 17 -53.52365963071378
		 18 -51.056129247378337 19 -52.416365375095751 20 -54.623954054867752 21 -54.770679570020398
		 22 -50.78711764015943 23 -42.191294141775316 24 -33.42952600840033 25 -29.176550148723106
		 26 -29.592926116265421 27 -33.991294779655561 28 -40.760468329282013 29 -47.00465755613854
		 30 -49.658790052194092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY";
	rename -uid "BF635D95-406C-08D5-34EC-D387B6A24DBE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 55.849253617437533 1 53.62715855035507
		 2 47.748452174113936 3 39.406710922632882 4 29.848115983574878 5 20.366104077958081
		 6 12.233026364835171 7 6.6057428392833115 8 4.5071342220035575 9 -6.1537560689457589
		 10 -18.215379406461054 11 19.740116377789018 12 55.849243227577091 13 45.494842773448276
		 14 27.254861665167873 15 5.6963884917745853 16 -12.973696502799886 17 -24.362688927510167
		 18 -27.968401456577059 19 -23.442687445153091 20 -10.802383170957766 21 7.711098366848578
		 22 27.280480977735692 23 41.883428028169014 24 48.126819690800588 25 50.068612301437355
		 26 52.306993369126076 27 54.49012475798348 28 55.796669096001857 29 56.004574423345147
		 30 55.849253617437533;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX";
	rename -uid "06D3EE44-407C-4835-4E2F-8995F490A733";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 75.362643873534537 1 74.593993729091565
		 2 72.83312121473773 3 70.9263626087467 4 69.519434265081458 5 68.955355448940793
		 6 69.209560562854833 7 69.85604463682489 8 70.21146415631371 9 67.698338156571566
		 10 77.719342697862302 11 81.574400417014871 12 75.362700200568199 13 68.59914234266877
		 14 53.065641871688825 15 35.493962897608959 16 16.627418759132446 17 -0.5076085123987627
		 18 -8.1608743884313224 19 -0.56352764131060651 20 17.242863015471929 21 39.031047364625955
		 22 62.235906769737696 23 85.278785854129779 24 102.2069509839049 25 109.18571462344421
		 26 107.58505565556842 27 99.821303983993204 28 89.022369537898214 29 79.423238353267905
		 30 75.362643873534537;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ";
	rename -uid "6765FCB0-40E5-8A80-32FB-08A84F3231F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 30.934927579782283 1 30.537331396143369
		 2 29.731803181832209 3 28.976923321950039 4 28.256167121684069 5 27.074627232558075
		 6 24.768921739974271 7 21.718087659765111 8 18.796777019959801 9 16.467330588550134
		 10 14.845793320449225 11 13.897669638360288 12 13.579572217248916 13 13.736093084655801
		 14 14.177982525847472 15 14.870773393398846 16 15.773063892530589 17 16.849643496674258
		 18 18.064815751840598 19 19.383222479885625 20 20.771784145467141 21 22.196100566928834
		 22 23.625545663311392 23 25.024381469237383 24 26.359008745973291 25 27.595183195806232
		 26 28.692141600156727 27 29.614547314535038 28 30.322124020758118 29 30.775288829976738
		 30 30.934927579782283;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAY";
	rename -uid "50F3E2C1-4EC8-351F-5BD9-EDB130C5AF80";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 3.6589927377810646e-006 1 2.4077470164105348
		 2 8.2319893802805524 3 15.340783151009388 4 21.478505371034807 5 24.273856187453951
		 6 22.427044187023164 7 16.999031207475237 8 9.1928473800033146 9 0.41040910038543638
		 10 -7.8142572449025147 11 -13.899699620002561 12 -16.27172984373766 13 -16.116671995756821
		 14 -15.674470397713423 15 -14.983490580144121 16 -14.079879904249202 17 -13.003165863703773
		 18 -11.792400235985983 19 -10.487445863867348 20 -9.1275917277828427 21 -7.751401305334805
		 22 -6.3967797137897886 23 -5.0980688405070698 24 -3.8886552556894434 25 -2.7981623823438624
		 26 -1.8530418320609185 27 -1.0779701405436997 28 -0.49545382676167843 29 -0.12819254295323648
		 30 3.6589927377825948e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAX";
	rename -uid "1425C056-4BB5-227A-0505-5C8CE04C50E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0 1 0.1380908257416624 2 0.33744331157143681
		 3 0.35092040863787877 4 0.094894112666524838 5 -0.45110363129530645 6 -1.6495407578995152
		 7 -3.2217575823118345 8 -4.3310879544874341 9 -4.6841769678726104 10 -4.4481035670167275
		 11 -4.0152588912563356 12 -3.7990848854769999 13 -3.8095868999226998 14 -3.8340806805746781
		 15 -3.8592169823005356 16 -3.8664478504245445 17 -3.8380985340100944 18 -3.7582123570763661
		 19 -3.6140149150622305 20 -3.3987281748171259 21 -3.1112221294609723 22 -2.7573002540074185
		 23 -2.3487224223779819 24 -1.9039063007572672 25 -1.4462478587497325 26 -1.0035698770849044
		 27 -0.60653730569137254 28 -0.28693448653491288 29 -0.075613498633936876 30 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAZ";
	rename -uid "1A8729CE-4345-AE0B-47ED-9C933DC41AFB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 0.38736218029522645 1 1.7591084938631727
		 2 6.3610152759441618 3 11.50771375828565 4 12.132369274817107 5 2.0521407490113459
		 6 -13.158431331456908 7 -18.884126374730617 8 -17.849214285053836 9 -10.47340009031036
		 10 -2.6182521072262235 11 0.04783473437767153 12 -0.96933689301682791 13 -4.1217938419115114
		 14 -7.2809001719602975 15 -8.8287194817611088 16 -8.9472205393135269 17 -8.0441929601791777
		 18 -6.8232106438520486 19 -4.8770895827408536 20 -2.2076999518565015 21 0.28079694258785781
		 22 2.1412250621931914 23 3.2048967686449141 24 3.4824185645764691 25 3.2043947991088282
		 26 2.6149792811186616 27 1.8759661934087548 28 1.1514328125205227 29 0.60323907241185215
		 30 0.38736218029522645;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAY";
	rename -uid "4C22A70A-43B2-2540-0510-A1AA4F495B60";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 5.1104971418800194 1 2.2520585238995126
		 2 -7.2342732923685444 3 -24.045179734493459 4 -42.216889031912366 5 -52.312974871736095
		 6 -49.198303801561906 7 -36.222608490789433 8 -23.158412600925899 9 -12.02740468110129
		 10 2.3360915889565468 11 13.466872348931496 12 17.886760962603464 13 19.855229015176693
		 14 21.793308382850661 15 22.93634395279415 16 22.86963448293826 17 21.815030211335831
		 18 20.326978835196243 19 17.507189964916556 20 12.546830774673564 21 6.6296651160623581
		 22 1.0928687238852226 23 -2.6764608202133595 24 -3.287352466069962 25 -1.6854332947639588
		 26 0.13146361569447587 27 1.9517425675310667 28 3.5469666317825554 29 4.679799621616989
		 30 5.1104971418800194;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAX";
	rename -uid "09C36538-4AD2-FC64-36D0-B98766F74EFA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 31 ".ktv[0:30]"  0 -2.8183795147516344 1 6.3066433114239659
		 2 25.947799715170937 3 44.018725436752547 4 53.843603724465169 5 64.432448189928451
		 6 76.449736298833528 7 70.155308497426589 8 45.230939609936485 9 10.95831669441983
		 10 -20.699340412505705 11 -42.803476217197343 12 -54.047096709573871 13 -56.826265978431813
		 14 -54.408978636554544 15 -49.636700500950525 16 -43.625380099673464 17 -37.47791457466986
		 18 -32.180139214695039 19 -27.604578367273959 20 -23.438301628658824 21 -19.945951965357033
		 22 -17.084246147858774 23 -14.657156920617782 24 -12.480753150151729 25 -10.307081510137724
		 26 -8.0922051107817801 27 -6.0463349502547876 28 -4.3662490436271577 29 -3.2333888506407873
		 30 -2.8183795147516344;
	setAttr ".roti" 2;
createNode vstExportNode -n "overboss_attack_exportNode";
	rename -uid "73C1CBF2-4CD3-61F6-871E-E39DB33C132C";
	setAttr ".ei[0].exportFile" -type "string" "overboss_attack";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 30;
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 14;
	setAttr ".unw" 14;
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
connectAttr "RIGRN.phl[4]" "overboss_attack_exportNode.ei[0].objects[0]";
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
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKEffectorFromCharacter1.InputCharacterState"
		;
connectAttr "Character1.OutputCharacterDefinition" "HIKEffectorFromCharacter1.InputCharacterDefinition"
		;
connectAttr "HIKproperties1.OutputPropertySetState" "HIKEffectorFromCharacter1.InputPropertySetState"
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
connectAttr "Character1.OutputCharacterDefinition" "HIKState2FK2.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.decs" "HIKState2FK2.InputCharacterState";
connectAttr "Character1.OutputCharacterDefinition" "HIKState2FK1.InputCharacterDefinition"
		;
connectAttr "HIKSolverNode1.OutputCharacterState" "HIKState2FK1.InputCharacterState"
		;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
// End of overboss_attack.ma
