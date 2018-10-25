//Maya ASCII 2016 scene
//Name: overboss_idle_drink.ma
//Last modified: Wed, May 27, 2015 09:56:34 AM
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
	setAttr ".t" -type "double3" -320.3459872635342 97.202955502459801 201.20544696815776 ;
	setAttr ".r" -type "double3" -2.7383527296234731 -53.399999999999558 3.3340552522725859e-016 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 376.11899072049493;
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
	rename -uid "8B7DE4E4-4FD5-C71B-9C95-49AA8B20AD05";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "95C3BFE4-4849-FA2F-4BD6-0BBF7A36FA72";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "6076C9CB-4D2D-5766-5133-05BD9DA4FBCC";
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
	rename -uid "91501DE7-40B6-563C-43C1-AD80CC305A61";
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
	rename -uid "B62643BF-42E8-D7A6-6369-F48210AC387A";
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
	rename -uid "31912B11-4869-63D4-F09D-9895FE150F0D";
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
	rename -uid "9D44BB7C-4A2D-BC7B-FDA1-02B3A3063F8F";
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
	rename -uid "F25F4C22-4C79-B2F2-AE99-119D21C30EEA";
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
	rename -uid "55FF1A26-441E-2C44-7A70-D2B48B5DAF69";
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
	rename -uid "D2EFC1C9-4DC8-49CD-4B5D-02A5910F4D41";
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
	rename -uid "7211FE9C-4C0F-67C8-5CA2-FB9ED979C9D9";
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
	rename -uid "35EC5204-4F3D-4583-6608-2E9F374DDDEE";
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
	rename -uid "BC55F5B8-498B-8B8C-F50B-678CB0B012C1";
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
	rename -uid "4C0CE2C2-4159-6CC0-84AF-33A8027CF150";
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
	rename -uid "7E4D7142-480E-0371-FA47-BCA75FE9FEB4";
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
	rename -uid "A712584A-40CE-6F69-A121-0B82BC9F1B87";
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
	rename -uid "8C2AE696-49F8-79F9-6E91-6390BF8E7C50";
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
	rename -uid "FB89323F-4E7A-6874-4E5F-FB9670637713";
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
	rename -uid "418872E9-4CE9-96D8-D7BB-F38CBD34883B";
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
	rename -uid "C5A63CC3-4DB5-76C2-3472-67A1C2EBA155";
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
	rename -uid "BF08057E-44A3-DF6B-71FB-CD845B5E1201";
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
	rename -uid "FD9CF316-4656-255D-F899-16A234D6EA7A";
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
	rename -uid "80FAF6FB-4D7D-3B55-9E7D-A9BC945BAB7B";
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
	rename -uid "5A76DEEC-43AA-C716-D838-10A9F61152D8";
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
	rename -uid "75D00AC4-44F8-005A-955F-79A94BDCB65D";
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
	rename -uid "ADD6D17F-40B7-447D-7C8B-03880477AC71";
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
	rename -uid "6BA4201A-4064-FB3F-C3DA-328663793822";
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
	rename -uid "D219BB16-40FA-A72D-CA56-84B4A7AAD552";
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
	rename -uid "B2CC66C4-4EF1-463F-8078-15B4549B21A1";
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
	rename -uid "6B27F588-46CC-6DA5-14EC-DEA5A53219A8";
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
	rename -uid "12BDE8C2-4857-C70C-3F60-3883E1524545";
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
	rename -uid "387BCB00-498F-2FA1-0CBB-E9B36D1E7332";
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
	rename -uid "0A91B5BC-40AB-45D5-2862-74BFE7518BF8";
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
	rename -uid "71266483-4B07-906E-DED8-20B7F69A4324";
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
	rename -uid "97349180-4922-2061-D4C2-2188BBCF742C";
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
	rename -uid "8A137398-4073-CDC2-27D3-11A81D1FECC5";
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
	rename -uid "16C924DA-4EE5-BE60-1933-0491B6A01141";
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
	rename -uid "2C2CBA46-4D77-D71B-7B0E-94AC3C4EECF1";
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
	rename -uid "FE09F45F-49DC-0B0C-F20D-EC8322FC9792";
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
	rename -uid "0B64C53F-4BEA-9E67-92D3-31A3E207F508";
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
	rename -uid "2AEC7504-4579-E4DD-B152-DFBF40A52AD3";
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
	rename -uid "AF932CBA-4D08-3676-D03C-1EB4A9EDD33A";
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
	rename -uid "85C33958-41ED-7E59-31D0-CCA10A5E3E48";
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
	rename -uid "C85CFEE1-42CA-CCBB-7876-C3B0C3F9DE6A";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "BD88F60D-4183-3CB3-BDB4-218D4F133262";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "59FBB8A1-4227-0F17-5A3B-BF8569ED0864";
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
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 80 -ast 0 -aet 200 ";
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
	setAttr ".HipsTx" 3.496955394744873;
	setAttr ".HipsTy" 48.822834014892578;
	setAttr ".HipsTz" -20.230829238891602;
	setAttr ".HipsRx" 7.053660941871545;
	setAttr ".HipsRy" -2.3852051878862621;
	setAttr ".HipsRz" 18.590082358817483;
	setAttr ".HipsSx" 1.0000001150045736;
	setAttr ".HipsSy" 1.000000027359391;
	setAttr ".HipsSz" 1.0000000982155282;
	setAttr ".LeftUpLegTx" 24.896361470206259;
	setAttr ".LeftUpLegTy" -7.7306243708979281;
	setAttr ".LeftUpLegTz" 3.197025108212582;
	setAttr ".LeftUpLegRx" -9.4905680143968087;
	setAttr ".LeftUpLegRy" 16.334799658450532;
	setAttr ".LeftUpLegRz" -8.2854199069748926;
	setAttr ".LeftUpLegSx" 1.0000001306641275;
	setAttr ".LeftUpLegSy" 1.0000000771896749;
	setAttr ".LeftUpLegSz" 1.0000000414739558;
	setAttr ".LeftLegTx" 21.226196357932061;
	setAttr ".LeftLegTy" 4.5428074688658171e-006;
	setAttr ".LeftLegTz" -4.2026911337700312e-006;
	setAttr ".LeftLegRx" 0.16011479807079745;
	setAttr ".LeftLegRy" 0.91549315966388378;
	setAttr ".LeftLegRz" -7.5682937912185109;
	setAttr ".LeftLegSx" 1.000000093367674;
	setAttr ".LeftLegSy" 1.0000002480841623;
	setAttr ".LeftLegSz" 1.0000000314346043;
	setAttr ".LeftFootTx" 15.941054057650781;
	setAttr ".LeftFootTy" 1.5710673757496352e-006;
	setAttr ".LeftFootTz" -1.8248680184740351e-006;
	setAttr ".LeftFootRx" -18.654092014013656;
	setAttr ".LeftFootRy" -14.459727075161787;
	setAttr ".LeftFootRz" -0.61358069153133621;
	setAttr ".LeftFootSx" 1.0000001251001109;
	setAttr ".LeftFootSy" 1.0000000920322025;
	setAttr ".LeftFootSz" 1.0000002279843625;
	setAttr ".RightUpLegTx" -24.89629771000147;
	setAttr ".RightUpLegTy" -7.7306005032885423;
	setAttr ".RightUpLegTz" 3.1970260527078835;
	setAttr ".RightUpLegRx" 22.400865793192867;
	setAttr ".RightUpLegRy" -33.564440929869875;
	setAttr ".RightUpLegRz" -18.086159504412333;
	setAttr ".RightUpLegSx" 0.99999996394524626;
	setAttr ".RightUpLegSy" 1.0000000400786833;
	setAttr ".RightUpLegSz" 0.99999998633890841;
	setAttr ".RightLegTx" -21.226189776226811;
	setAttr ".RightLegTy" 1.3902637332918744e-005;
	setAttr ".RightLegTz" -7.7936547139501045e-005;
	setAttr ".RightLegRx" 4.1440179996088125;
	setAttr ".RightLegRy" -0.971059857527931;
	setAttr ".RightLegRz" 51.089977351652628;
	setAttr ".RightLegSx" 1.0000001127134479;
	setAttr ".RightLegSy" 1.0000000372959119;
	setAttr ".RightLegSz" 1.0000001384870978;
	setAttr ".RightFootTx" -15.941092074998606;
	setAttr ".RightFootTy" 4.1320567123470653e-005;
	setAttr ".RightFootTz" 5.4602787486146553e-005;
	setAttr ".RightFootRx" -29.448725586029106;
	setAttr ".RightFootRy" -3.7538021459024429;
	setAttr ".RightFootRz" 47.505858123691027;
	setAttr ".RightFootSx" 1.0000000339084243;
	setAttr ".RightFootSy" 1.000000107092347;
	setAttr ".RightFootSz" 0.9999999756499881;
	setAttr ".SpineTx" -6.1045167143447543e-008;
	setAttr ".SpineTy" 3.3825339972562318;
	setAttr ".SpineTz" -3.7835487689816993;
	setAttr ".SpineRx" -0.54676000574695083;
	setAttr ".SpineRy" -3.4359125028492641;
	setAttr ".SpineRz" 1.6879714977711138;
	setAttr ".SpineSx" 1.0000000342250546;
	setAttr ".SpineSy" 1.0000000096732742;
	setAttr ".SpineSz" 0.99999991944060873;
	setAttr ".LeftArmTx" 7.5598114728764756;
	setAttr ".LeftArmTy" -1.3346424311842711;
	setAttr ".LeftArmTz" 6.4182886377990087;
	setAttr ".LeftArmRx" -15.13826469320021;
	setAttr ".LeftArmRy" -22.563528886944599;
	setAttr ".LeftArmRz" -1.0518869765275756;
	setAttr ".LeftArmSx" 0.99999995176049994;
	setAttr ".LeftArmSy" 0.9999999607915605;
	setAttr ".LeftArmSz" 0.99999996321688511;
	setAttr ".LeftForeArmTx" 23.627844516607389;
	setAttr ".LeftForeArmTy" -0.36614363223318236;
	setAttr ".LeftForeArmTz" 0.61649031119760878;
	setAttr ".LeftForeArmRx" -12.281835045704131;
	setAttr ".LeftForeArmRy" -11.422730395620325;
	setAttr ".LeftForeArmRz" 56.671433949573064;
	setAttr ".LeftForeArmSx" 1.000000051362214;
	setAttr ".LeftForeArmSy" 1.0000001118207453;
	setAttr ".LeftForeArmSz" 1.000000028967857;
	setAttr ".LeftHandTx" 22.329476221598522;
	setAttr ".LeftHandTy" -0.34351420022125012;
	setAttr ".LeftHandTz" 0.83664984435653267;
	setAttr ".LeftHandRx" 18.842902082492682;
	setAttr ".LeftHandRy" 6.0374654299365949;
	setAttr ".LeftHandRz" 7.7606254437288742;
	setAttr ".LeftHandSx" 1.0000001026569485;
	setAttr ".LeftHandSy" 1.0000002670279533;
	setAttr ".LeftHandSz" 1.0000001299735048;
	setAttr ".RightArmTx" -7.5598901731642627;
	setAttr ".RightArmTy" 1.3346114525037374;
	setAttr ".RightArmTz" -6.4179034362574825;
	setAttr ".RightArmRx" -11.312294926338941;
	setAttr ".RightArmRy" -12.908670336560546;
	setAttr ".RightArmRz" 1.4915904866913274;
	setAttr ".RightArmSx" 1.0000000811939029;
	setAttr ".RightArmSy" 1.0000000498189141;
	setAttr ".RightArmSz" 1.0000000680942831;
	setAttr ".RightForeArmTx" -23.627920338732526;
	setAttr ".RightForeArmTy" 0.36613207557977212;
	setAttr ".RightForeArmTz" -0.61643186146663709;
	setAttr ".RightForeArmRx" 0.7025047887036896;
	setAttr ".RightForeArmRy" 2.5126581987744245;
	setAttr ".RightForeArmRz" -23.701969613773638;
	setAttr ".RightForeArmSx" 1.0000001575355488;
	setAttr ".RightForeArmSy" 1.0000000722846476;
	setAttr ".RightForeArmSz" 1.0000001068590063;
	setAttr ".RightHandTx" -22.329466956936923;
	setAttr ".RightHandTy" 0.34352906168062258;
	setAttr ".RightHandTz" -0.83669206917525685;
	setAttr ".RightHandRx" -141.37935545789523;
	setAttr ".RightHandRy" -67.327770657218267;
	setAttr ".RightHandRz" 23.330023100554044;
	setAttr ".RightHandSx" 1.0000000085805514;
	setAttr ".RightHandSy" 1.0000001478653948;
	setAttr ".RightHandSz" 1.0000000317173305;
	setAttr ".HeadTx" 8.0099482710704883;
	setAttr ".HeadTy" 1.1775801468161262e-005;
	setAttr ".HeadTz" -4.3898908010930882e-006;
	setAttr ".HeadRx" -1.5582605660527138;
	setAttr ".HeadRy" 5.6231011962482134;
	setAttr ".HeadRz" -33.417903509881789;
	setAttr ".HeadSx" 1.0000001102399623;
	setAttr ".HeadSy" 1.0000000540484852;
	setAttr ".HeadSz" 1.0000001529269122;
	setAttr ".LeftToeBaseTx" 6.8757456427425794;
	setAttr ".LeftToeBaseTy" -7.8982160722773642e-007;
	setAttr ".LeftToeBaseTz" 8.4984346671035382e-008;
	setAttr ".LeftToeBaseRx" 9.4152398643473845;
	setAttr ".LeftToeBaseRy" 17.270692108452891;
	setAttr ".LeftToeBaseRz" -0.16937363184916396;
	setAttr ".LeftToeBaseSx" 1.0000002161847354;
	setAttr ".LeftToeBaseSy" 1.0000002753299397;
	setAttr ".LeftToeBaseSz" 1.000000241474063;
	setAttr ".RightToeBaseTx" -6.8757593409095161;
	setAttr ".RightToeBaseTy" 4.0057145795913129e-006;
	setAttr ".RightToeBaseTz" 2.2372334839815267e-005;
	setAttr ".RightToeBaseRx" -9.8140268365592114;
	setAttr ".RightToeBaseRy" 1.5930429067826135;
	setAttr ".RightToeBaseRz" 4.4136519790628927;
	setAttr ".RightToeBaseSx" 1.0000002198013027;
	setAttr ".RightToeBaseSy" 1.000000069076884;
	setAttr ".RightToeBaseSz" 1.0000000657678529;
	setAttr ".LeftShoulderTx" 10.381337432667593;
	setAttr ".LeftShoulderTy" 5.2150664976717422;
	setAttr ".LeftShoulderTz" 13.982755998117227;
	setAttr ".LeftShoulderRx" -9.8679346677245654;
	setAttr ".LeftShoulderRy" -5.5122869131044121;
	setAttr ".LeftShoulderRz" 19.841127265332425;
	setAttr ".LeftShoulderSx" 1.0000002843707796;
	setAttr ".LeftShoulderSy" 1.0000001317812455;
	setAttr ".LeftShoulderSz" 1.0000001044620388;
	setAttr ".RightShoulderTx" 10.38099827463239;
	setAttr ".RightShoulderTy" 5.2151764399411036;
	setAttr ".RightShoulderTz" -13.982803028260527;
	setAttr ".RightShoulderRx" 8.9840749715312285;
	setAttr ".RightShoulderRy" 0.60822782728207492;
	setAttr ".RightShoulderRz" -19.105520253016397;
	setAttr ".RightShoulderSx" 0.99999992831534523;
	setAttr ".RightShoulderSy" 0.99999994863454789;
	setAttr ".RightShoulderSz" 0.99999985813017966;
	setAttr ".NeckTx" 17.971184009797227;
	setAttr ".NeckTy" 8.5464497203702194e-006;
	setAttr ".NeckTz" 1.5810716025299598e-006;
	setAttr ".NeckRz" 30.934568050098584;
	setAttr ".NeckSx" 0.99999998646409505;
	setAttr ".NeckSy" 1.0000000034430705;
	setAttr ".NeckSz" 0.99999992839269958;
	setAttr ".Spine1Tx" 7.1917514235775215;
	setAttr ".Spine1Ty" 7.0404355057007706e-007;
	setAttr ".Spine1Tz" -1.1579443484066587e-006;
	setAttr ".Spine1Rx" 0.75517933302692131;
	setAttr ".Spine1Ry" -6.9165084531519012;
	setAttr ".Spine1Rz" 3.3006525633329846;
	setAttr ".Spine1Sx" 0.99999997985771727;
	setAttr ".Spine1Sy" 0.99999998345832064;
	setAttr ".Spine1Sz" 0.99999999053559929;
	setAttr ".Spine2Tx" 15.480272918805419;
	setAttr ".Spine2Ty" 2.2151356944277723e-006;
	setAttr ".Spine2Tz" 1.2927526782391396e-007;
	setAttr ".Spine2Rx" 1.3093513326604707;
	setAttr ".Spine2Ry" -6.8336975313184523;
	setAttr ".Spine2Rz" 3.2681137259283028;
	setAttr ".Spine2Sx" 0.99999998633511311;
	setAttr ".Spine2Sy" 1.0000000952895161;
	setAttr ".Spine2Sz" 0.99999998301304582;
	setAttr ".Spine3Tx" 13.0889194794605;
	setAttr ".Spine3Ty" -2.7506167725732666e-006;
	setAttr ".Spine3Tz" -3.8307026661854593e-008;
	setAttr ".Spine3Rx" -2.105190683161041;
	setAttr ".Spine3Ry" -6.6327756698427738;
	setAttr ".Spine3Rz" 3.4682853670260685;
	setAttr ".Spine3Sx" 1.0000000877852451;
	setAttr ".Spine3Sy" 1.0000000828690825;
	setAttr ".Spine3Sz" 1.0000001481307697;
createNode vstExportNode -n "kobold_overboss_anim_exportNode";
	rename -uid "C9012981-4EAA-85D4-B21F-5B9ECA191799";
	setAttr ".ei[0].exportFile" -type "string" "overboss_idle_drink";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 80;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "F470E095-451E-BB37-ACD2-72AE6E7F90C4";
	setAttr ".ihi" 0;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "471786B9-4580-C7EA-2C33-34896E0171AE";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "DAF6C06D-49EE-A958-E23C-95AB17A58FD7";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "C75DCC2A-4585-C812-428A-A8BCEE290C8C";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "C479B0DA-4293-A1B0-EECA-9DA4B8CA2804";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "E9B6D6AE-45F4-A0A6-4E71-C68E3742BBF2";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "25BCB942-4E87-3776-1E4C-39A5348DFA40";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "C713E957-435B-5EDB-DE62-C68ECA89EFD4";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "C140B702-43C7-9154-EBF5-2B9F052B1028";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "F25D7ACC-4373-183B-E731-48AA2E613655";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "E5EAD376-4361-5D85-28CA-A88B71C8993C";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "03E6B81F-49BC-ACE5-CC24-E89C71F4C372";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "140230F9-4B3D-12DA-BFF7-6A85F5E3B0CB";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "C35079D2-4815-CF95-5CC0-B2942A769239";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "7624E7B1-4090-50C6-063E-BBACF3C9766C";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "E59ADFC4-45B4-BEDD-40AA-DEB7A1869E20";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "FF3A26A6-4BAC-784B-6A81-C490899A73DC";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700253009796143 0.31851908564567566 0.041617665439844131 0
		 -0.32122641801834106 0.93902087211608887 0.12269248068332672 0 4.0978193283081055e-008 -0.12955877184867859 0.99157184362411499 0
		 3.496955394744873 48.822834014892578 -20.230829238891602 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99866151809692383 0.032715849578380585 -0.040062591433525085 0
		 -0.034800387918949127 0.99801492691040039 -0.052490372210741043 0 0.038265794515609741 0.053814303129911423 0.99781757593154907 0
		 29.557153701782227 49.079380035400391 -16.973110198974609 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99664020538330078 0.042733587324619293 -0.069877736270427704 0
		 -0.054725706577301025 0.9821631908416748 -0.17989255487918854 0 0.060943860560655594 0.18311217427253723 0.98120152950286865 0
		 28.845050811767578 29.270174026489258 -9.3810224533081055 1;
	setAttr ".LeftFootGX" -type "matrix" 0.8609650731086731 -0.17507317662239075 -0.47758612036705017 0
		 0.12372653931379318 0.98278284072875977 -0.13722065091133118 0 0.4933871328830719 0.059052124619483948 0.86780297756195068 0
		 24.773853302001953 16.879360198974609 -18.546737670898438 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.92512321472167969 -0.36888831853866577 -0.089824020862579346 0
		 0.37390777468681335 0.92627620697021484 0.046961620450019836 0 0.065878264605998993 -0.07703118771314621 0.99484986066818237 0
		 -17.596628189086914 33.219490051269531 -19.045360565185547 1;
	setAttr ".RightLegGX" -type "matrix" 0.98854386806488037 -0.091378703713417053 -0.12013036012649536 0
		 0.15092143416404724 0.58776175975799561 0.79483276605606079 0 -0.0020227767527103424 -0.80385714769363403 0.59481918811798096 0
		 -23.162681579589844 13.448036193847656 -13.691879272460937 1;
	setAttr ".RightFootGX" -type "matrix" 0.83229619264602661 -0.2567431628704071 0.4912906289100647 0
		 0.19550460577011108 0.96528041362762451 0.17324039340019226 0 -0.5187113881111145 -0.048137716948986053 0.85359346866607666 0
		 -20.792228698730469 16.287248611450195 -29.197952270507813 1;
	setAttr ".SpineGX" -type "matrix" 0.9647209644317627 0.26146820187568665 0.030790485441684723 0
		 -0.26305010914802551 0.95245039463043213 0.1537630558013916 0 0.010877743363380432 -0.15643785893917084 0.98762792348861694 0
		 2.4103958606719971 52.489295959472656 -23.567478179931641 1;
	setAttr ".LeftArmGX" -type "matrix" 0.16398537158966064 -0.97173184156417847 -0.16984151303768158 0
		 0.9844849705696106 0.15031544864177704 0.090524584054946899 0 -0.0624358169734478 -0.18205110728740692 0.98130488395690918 0
		 21.908823013305664 86.931968688964844 -10.584022521972656 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.17550507187843323 -0.35179781913757324 0.91947627067565918 0
		 0.9830668568611145 -0.012625395320355892 0.18281246721744537 0 -0.052704125642776489 0.93599104881286621 0.34805673360824585 0
		 25.785219192504883 63.961471557617188 -14.598859786987305 1;
	setAttr ".LeftHandGX" -type "matrix" -0.059836860746145248 -0.24159057438373566 0.96853166818618774 0
		 0.93312203884124756 0.33108556270599365 0.14023527503013611 0 -0.35454627871513367 0.91214942932128906 0.20562243461608887 0
		 21.863073348999023 56.099575042724609 5.9493980407714844 1;
	setAttr ".RightArmGX" -type "matrix" 0.54286611080169678 0.74270778894424438 0.39202228188514709 0
		 -0.71093851327896118 0.65490412712097168 -0.25625580549240112 0 -0.44706019759178162 -0.13959115743637085 0.88354480266571045 0
		 -22.111734390258789 92.884872436523438 -13.52207088470459 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.54676145315170288 0.74390184879302979 0.38426798582077026 0
		 -0.7109839916229248 0.65489053726196289 -0.2561640739440918 0 -0.44221442937850952 -0.13314774632453918 0.88697123527526855 0
		 -34.736564636230469 74.960746765136719 -22.361309051513672 1;
	setAttr ".RightHandGX" -type "matrix" -0.23600947856903076 0.92909491062164307 -0.28474947810173035 0
		 0.83390748500823975 0.043201088905334473 -0.55021101236343384 0 -0.49889674782752991 -0.36730974912643433 -0.78497493267059326 0
		 -47.196029663085938 58.494060516357422 -30.907260894775391 1;
	setAttr ".HeadGX" -type "matrix" 0.99991476535797119 -0.012987232767045498 0.0013197518419474363 0
		 0.012093177065253258 0.95963376760482788 0.28099259734153748 0 -0.0049157943576574326 -0.28095269203186035 0.95970898866653442 0
		 0.61381560564041138 102.77214050292969 0.49030923843383789 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324464321136475 1.5359071880993724e-007 -0.48728260397911072 0
		 -1.3483392535817984e-007 1.0000002384185791 7.3566681635384157e-008 0 0.48728260397911072 1.4605205933548859e-009 0.87324464321136475 0
		 22.791261672973633 10.295684814453125 -18.525789260864258 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841299057006836 1.3299732870564185e-007 0.52933543920516968 0
		 -1.5350924797985499e-007 1.0000003576278687 -5.2105413317349303e-009 0 -0.52933543920516968 -7.6837181950395461e-008 0.84841299057006836 0
		 -20.936428070068359 9.722050666809082 -31.235954284667969 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.81727379560470581 -0.55529725551605225 0.15397703647613525 0
		 0.47262859344482422 0.79880845546722412 0.3721930980682373 0 -0.32967591285705566 -0.23140965402126312 0.915294349193573 0
		 13.038082122802734 91.182228088378906 -8.7477922439575195 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.90805459022521973 0.18929845094680786 0.37363478541374207 0
		 -0.27441313862800598 0.94280529022216797 0.1892504096031189 0 -0.31643998622894287 -0.27437996864318848 0.90806454420089722 0
		 -14.756891250610352 93.548927307128906 -6.7701892852783203 1;
	setAttr ".NeckGX" -type "matrix" 0.99389904737472534 -0.084640838205814362 -0.070719115436077118 0
		 0.10868336260318756 0.64231026172637939 0.75870025157928467 0 -0.018793415278196335 -0.76175719499588013 0.64759033918380737 0
		 -0.052858352661132813 101.53196716308594 -7.3949165344238281 1;
	setAttr ".Spine1GX" -type "matrix" 0.98931169509887695 0.14577217400074005 0.0036458279937505722 0
		 -0.14318935573101044 0.96644961833953857 0.21324251592159271 0 0.027561312541365623 -0.21148531138896942 0.97699272632598877 0
		 0.56467700004577637 59.018585205078125 -21.183574676513672 1;
	setAttr ".Spine2GX" -type "matrix" 0.99909645318984985 0.029701214283704758 -0.030396675691008568 0
		 -0.02046959288418293 0.96312332153320313 0.26828044652938843 0 0.037244003266096115 -0.267415851354599 0.96286112070083618 0
		 -1.6828086376190186 74.226005554199219 -19.360935211181641 1;
	setAttr ".Spine3GX" -type "matrix" 0.99389868974685669 -0.084640920162200928 -0.070719689130783081 0
		 0.10288488119840622 0.94253247976303101 0.31787937879562378 0 0.039750002324581146 -0.32321590185165405 0.94549012184143066 0
		 -2.0324110984802246 87.251678466796875 -18.124233245849609 1;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "6271047C-4B0B-30B2-8816-A7A03A97211A";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700253009796143 0.31851908564567566 0.041617665439844131 0
		 -0.32122641801834106 0.93902087211608887 0.12269248068332672 0 4.0978193283081055e-008 -0.12955877184867859 0.99157184362411499 0
		 3.496955394744873 48.822834014892578 -20.230829238891602 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99866151809692383 0.032715849578380585 -0.040062591433525085 0
		 -0.034800387918949127 0.99801492691040039 -0.052490372210741043 0 0.038265794515609741 0.053814303129911423 0.99781757593154907 0
		 29.557153701782227 49.079380035400391 -16.973110198974609 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99664020538330078 0.042733587324619293 -0.069877736270427704 0
		 -0.054725706577301025 0.9821631908416748 -0.17989255487918854 0 0.060943860560655594 0.18311217427253723 0.98120152950286865 0
		 28.845050811767578 29.270174026489258 -9.3810224533081055 1;
	setAttr ".LeftFootGX" -type "matrix" 0.8609650731086731 -0.17507317662239075 -0.47758612036705017 0
		 0.12372653931379318 0.98278284072875977 -0.13722065091133118 0 0.4933871328830719 0.059052124619483948 0.86780297756195068 0
		 24.773853302001953 16.879360198974609 -18.546737670898438 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.92512321472167969 -0.36888831853866577 -0.089824020862579346 0
		 0.37390777468681335 0.92627620697021484 0.046961620450019836 0 0.065878264605998993 -0.07703118771314621 0.99484986066818237 0
		 -17.596628189086914 33.219490051269531 -19.045360565185547 1;
	setAttr ".RightLegGX" -type "matrix" 0.98854386806488037 -0.091378703713417053 -0.12013036012649536 0
		 0.15092143416404724 0.58776175975799561 0.79483276605606079 0 -0.0020227767527103424 -0.80385714769363403 0.59481918811798096 0
		 -23.162681579589844 13.448036193847656 -13.691879272460937 1;
	setAttr ".RightFootGX" -type "matrix" 0.83229619264602661 -0.2567431628704071 0.4912906289100647 0
		 0.19550460577011108 0.96528041362762451 0.17324039340019226 0 -0.5187113881111145 -0.048137716948986053 0.85359346866607666 0
		 -20.792228698730469 16.287248611450195 -29.197952270507813 1;
	setAttr ".SpineGX" -type "matrix" 0.9647209644317627 0.26146820187568665 0.030790485441684723 0
		 -0.26305010914802551 0.95245039463043213 0.1537630558013916 0 0.010877743363380432 -0.15643785893917084 0.98762792348861694 0
		 2.4103958606719971 52.489295959472656 -23.567478179931641 1;
	setAttr ".LeftArmGX" -type "matrix" 0.16398537158966064 -0.97173184156417847 -0.16984151303768158 0
		 0.9844849705696106 0.15031544864177704 0.090524584054946899 0 -0.0624358169734478 -0.18205110728740692 0.98130488395690918 0
		 21.908823013305664 86.931968688964844 -10.584022521972656 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.17550507187843323 -0.35179781913757324 0.91947627067565918 0
		 0.9830668568611145 -0.012625395320355892 0.18281246721744537 0 -0.052704125642776489 0.93599104881286621 0.34805673360824585 0
		 25.785219192504883 63.961471557617188 -14.598859786987305 1;
	setAttr ".LeftHandGX" -type "matrix" -0.059836860746145248 -0.24159057438373566 0.96853166818618774 0
		 0.93312203884124756 0.33108556270599365 0.14023527503013611 0 -0.35454627871513367 0.91214942932128906 0.20562243461608887 0
		 21.863073348999023 56.099575042724609 5.9493980407714844 1;
	setAttr ".RightArmGX" -type "matrix" 0.54286611080169678 0.74270778894424438 0.39202228188514709 0
		 -0.71093851327896118 0.65490412712097168 -0.25625580549240112 0 -0.44706019759178162 -0.13959115743637085 0.88354480266571045 0
		 -22.111734390258789 92.884872436523438 -13.52207088470459 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.54676145315170288 0.74390184879302979 0.38426798582077026 0
		 -0.7109839916229248 0.65489053726196289 -0.2561640739440918 0 -0.44221442937850952 -0.13314774632453918 0.88697123527526855 0
		 -34.736564636230469 74.960746765136719 -22.361309051513672 1;
	setAttr ".RightHandGX" -type "matrix" -0.23600947856903076 0.92909491062164307 -0.28474947810173035 0
		 0.83390748500823975 0.043201088905334473 -0.55021101236343384 0 -0.49889674782752991 -0.36730974912643433 -0.78497493267059326 0
		 -47.196029663085938 58.494060516357422 -30.907260894775391 1;
	setAttr ".HeadGX" -type "matrix" 0.99991476535797119 -0.012987232767045498 0.0013197518419474363 0
		 0.012093177065253258 0.95963376760482788 0.28099259734153748 0 -0.0049157943576574326 -0.28095269203186035 0.95970898866653442 0
		 0.61381560564041138 102.77214050292969 0.49030923843383789 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324464321136475 1.5359071880993724e-007 -0.48728260397911072 0
		 -1.3483392535817984e-007 1.0000002384185791 7.3566681635384157e-008 0 0.48728260397911072 1.4605205933548859e-009 0.87324464321136475 0
		 22.791261672973633 10.295684814453125 -18.525789260864258 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841299057006836 1.3299732870564185e-007 0.52933543920516968 0
		 -1.5350924797985499e-007 1.0000003576278687 -5.2105413317349303e-009 0 -0.52933543920516968 -7.6837181950395461e-008 0.84841299057006836 0
		 -20.936428070068359 9.722050666809082 -31.235954284667969 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.81727379560470581 -0.55529725551605225 0.15397703647613525 0
		 0.47262859344482422 0.79880845546722412 0.3721930980682373 0 -0.32967591285705566 -0.23140965402126312 0.915294349193573 0
		 13.038082122802734 91.182228088378906 -8.7477922439575195 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.90805459022521973 0.18929845094680786 0.37363478541374207 0
		 -0.27441313862800598 0.94280529022216797 0.1892504096031189 0 -0.31643998622894287 -0.27437996864318848 0.90806454420089722 0
		 -14.756891250610352 93.548927307128906 -6.7701892852783203 1;
	setAttr ".NeckGX" -type "matrix" 0.99389904737472534 -0.084640838205814362 -0.070719115436077118 0
		 0.10868336260318756 0.64231026172637939 0.75870025157928467 0 -0.018793415278196335 -0.76175719499588013 0.64759033918380737 0
		 -0.052858352661132813 101.53196716308594 -7.3949165344238281 1;
	setAttr ".Spine1GX" -type "matrix" 0.98931169509887695 0.14577217400074005 0.0036458279937505722 0
		 -0.14318935573101044 0.96644961833953857 0.21324251592159271 0 0.027561312541365623 -0.21148531138896942 0.97699272632598877 0
		 0.56467700004577637 59.018585205078125 -21.183574676513672 1;
	setAttr ".Spine2GX" -type "matrix" 0.99909645318984985 0.029701214283704758 -0.030396675691008568 0
		 -0.02046959288418293 0.96312332153320313 0.26828044652938843 0 0.037244003266096115 -0.267415851354599 0.96286112070083618 0
		 -1.6828086376190186 74.226005554199219 -19.360935211181641 1;
	setAttr ".Spine3GX" -type "matrix" 0.99389868974685669 -0.084640920162200928 -0.070719689130783081 0
		 0.10288488119840622 0.94253247976303101 0.31787937879562378 0 0.039750002324581146 -0.32321590185165405 0.94549012184143066 0
		 -2.0324110984802246 87.251678466796875 -18.124233245849609 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "0D8C4935-4EA8-B508-FAAC-36B1286E289E";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "F14058A0-4BD0-8C85-6C12-A5BA41F9CDB9";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "73B09FC8-4502-CB38-C54A-C78FC4D1C09C";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700253009796143 0.31851908564567566 0.041617665439844131 0
		 -0.32122644782066345 0.93902093172073364 0.12269248813390732 0 4.0978193283081055e-008 -0.12955877184867859 0.99157184362411499 0
		 5.9802627563476563 41.149436950683594 -18.009235382080078 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.8609650731086731 -0.17507317662239075 -0.47758612036705017 0
		 0.12372654676437378 0.98278290033340454 -0.13722066581249237 0 0.4933871328830719 0.059052124619483948 0.86780297756195068 0
		 24.773853302001953 16.879360198974609 -18.546737670898438 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.83229619264602661 -0.2567431628704071 0.4912906289100647 0
		 0.19550460577011108 0.96528041362762451 0.17324039340019226 0 -0.5187113881111145 -0.048137716948986053 0.85359346866607666 0
		 -20.792228698730469 16.287248611450195 -29.197952270507813 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" -0.059836864471435547 -0.24159058928489685 0.96853172779083252 0
		 0.93312203884124756 0.33108556270599365 0.14023527503013611 0 -0.35454627871513367 0.91214942932128906 0.20562243461608887 0
		 21.863073348999023 56.099575042724609 5.9493980407714844 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.23600947856903076 0.92909491062164307 -0.28474947810173035 0
		 0.83390748500823975 0.043201088905334473 -0.55021101236343384 0 -0.49889674782752991 -0.36730974912643433 -0.78497493267059326 0
		 -47.196029663085938 58.494060516357422 -30.907260894775391 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99664020538330078 0.042733587324619293 -0.069877736270427704 0
		 -0.054725706577301025 0.9821631908416748 -0.17989255487918854 0 0.060943864285945892 0.18311218917369843 0.98120158910751343 0
		 28.845050811767578 29.270174026489258 -9.3810224533081055 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98854386806488037 -0.091378703713417053 -0.12013036012649536 0
		 0.15092143416404724 0.58776175975799561 0.79483276605606079 0 -0.0020227767527103424 -0.80385714769363403 0.59481918811798096 0
		 -23.162681579589844 13.448036193847656 -13.691879272460937 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.17550507187843323 -0.35179781913757324 0.91947627067565918 0
		 0.98306691646575928 -0.012625396251678467 0.18281248211860657 0 -0.052704125642776489 0.93599104881286621 0.34805673360824585 0
		 25.785219192504883 63.961471557617188 -14.598859786987305 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.54676145315170288 0.74390184879302979 0.38426798582077026 0
		 -0.7109839916229248 0.65489053726196289 -0.2561640739440918 0 -0.44221442937850952 -0.13314774632453918 0.88697123527526855 0
		 -34.736564636230469 74.960746765136719 -22.361309051513672 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.9647209644317627 0.26146820187568665 0.030790485441684723 0
		 -0.26305010914802551 0.95245039463043213 0.1537630558013916 0 0.010877744294703007 -0.15643787384033203 0.98762798309326172 0
		 2.4103958606719971 52.489295959472656 -23.567478179931641 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99389874935150146 -0.084640927612781525 -0.070719696581363678 0
		 0.10288488119840622 0.94253247976303101 0.31787937879562378 0 0.039750002324581146 -0.32321590185165405 0.94549012184143066 0
		 -0.85940456390380859 92.365577697753906 -7.7589907646179199 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324464321136475 1.5359071880993724e-007 -0.48728260397911072 0
		 -1.3483392535817984e-007 1.0000002384185791 7.3566681635384157e-008 0 0.48728260397911072 1.4605205933548859e-009 0.87324464321136475 0
		 22.791261672973633 10.295684814453125 -18.525789260864258 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841299057006836 1.3299732870564185e-007 0.52933543920516968 0
		 -1.5350924797985499e-007 1.0000003576278687 -5.2105413317349303e-009 0 -0.52933543920516968 -7.6837181950395461e-008 0.84841299057006836 0
		 -20.936428070068359 9.722050666809082 -31.235954284667969 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.16398537158966064 -0.97173184156417847 -0.16984151303768158 0
		 0.9844849705696106 0.15031544864177704 0.090524584054946899 0 -0.062435820698738098 -0.18205112218856812 0.98130494356155396 0
		 21.908823013305664 86.931968688964844 -10.584022521972656 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.54286611080169678 0.74270778894424438 0.39202228188514709 0
		 -0.71093851327896118 0.65490412712097168 -0.25625580549240112 0 -0.44706019759178162 -0.13959115743637085 0.88354480266571045 0
		 -22.111734390258789 92.884872436523438 -13.52207088470459 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.99991482496261597 -0.012987233698368073 0.0013197519583627582 0
		 0.012093177065253258 0.95963376760482788 0.28099259734153748 0 -0.0049157948233187199 -0.28095272183418274 0.9597090482711792 0
		 0.61381560564041138 102.77214050292969 0.49030923843383789 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99866151809692383 0.032715849578380585 -0.040062591433525085 0
		 -0.034800387918949127 0.99801492691040039 -0.052490372210741043 0 0.038265794515609741 0.053814303129911423 0.99781757593154907 0
		 29.557153701782227 49.079380035400391 -16.973110198974609 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.92512327432632446 -0.36888834834098816 -0.089824028313159943 0
		 0.37390777468681335 0.92627620697021484 0.046961620450019836 0 0.065878264605998993 -0.07703118771314621 0.99484986066818237 0
		 -17.596628189086914 33.219490051269531 -19.045360565185547 1;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "8A315110-4FED-6985-2115-209AC085E356";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700253009796143 0.31851908564567566 0.041617665439844131 0
		 -0.32122644782066345 0.93902093172073364 0.12269248813390732 0 4.0978193283081055e-008 -0.12955877184867859 0.99157184362411499 0
		 5.9802627563476563 41.149436950683594 -18.009235382080078 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.8609650731086731 -0.17507317662239075 -0.47758612036705017 0
		 0.12372654676437378 0.98278290033340454 -0.13722066581249237 0 0.4933871328830719 0.059052124619483948 0.86780297756195068 0
		 24.773853302001953 16.879360198974609 -18.546737670898438 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.83229619264602661 -0.2567431628704071 0.4912906289100647 0
		 0.19550460577011108 0.96528041362762451 0.17324039340019226 0 -0.5187113881111145 -0.048137716948986053 0.85359346866607666 0
		 -20.792228698730469 16.287248611450195 -29.197952270507813 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" -0.059836864471435547 -0.24159058928489685 0.96853172779083252 0
		 0.93312203884124756 0.33108556270599365 0.14023527503013611 0 -0.35454627871513367 0.91214942932128906 0.20562243461608887 0
		 21.863073348999023 56.099575042724609 5.9493980407714844 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.23600947856903076 0.92909491062164307 -0.28474947810173035 0
		 0.83390748500823975 0.043201088905334473 -0.55021101236343384 0 -0.49889674782752991 -0.36730974912643433 -0.78497493267059326 0
		 -47.196029663085938 58.494060516357422 -30.907260894775391 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99664020538330078 0.042733587324619293 -0.069877736270427704 0
		 -0.054725706577301025 0.9821631908416748 -0.17989255487918854 0 0.060943864285945892 0.18311218917369843 0.98120158910751343 0
		 28.845050811767578 29.270174026489258 -9.3810224533081055 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98854386806488037 -0.091378703713417053 -0.12013036012649536 0
		 0.15092143416404724 0.58776175975799561 0.79483276605606079 0 -0.0020227767527103424 -0.80385714769363403 0.59481918811798096 0
		 -23.162681579589844 13.448036193847656 -13.691879272460937 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.17550507187843323 -0.35179781913757324 0.91947627067565918 0
		 0.98306691646575928 -0.012625396251678467 0.18281248211860657 0 -0.052704125642776489 0.93599104881286621 0.34805673360824585 0
		 25.785219192504883 63.961471557617188 -14.598859786987305 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.54676145315170288 0.74390184879302979 0.38426798582077026 0
		 -0.7109839916229248 0.65489053726196289 -0.2561640739440918 0 -0.44221442937850952 -0.13314774632453918 0.88697123527526855 0
		 -34.736564636230469 74.960746765136719 -22.361309051513672 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.9647209644317627 0.26146820187568665 0.030790485441684723 0
		 -0.26305010914802551 0.95245039463043213 0.1537630558013916 0 0.010877744294703007 -0.15643787384033203 0.98762798309326172 0
		 2.4103958606719971 52.489295959472656 -23.567478179931641 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99389874935150146 -0.084640927612781525 -0.070719696581363678 0
		 0.10288488119840622 0.94253247976303101 0.31787937879562378 0 0.039750002324581146 -0.32321590185165405 0.94549012184143066 0
		 -0.85940456390380859 92.365577697753906 -7.7589907646179199 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324464321136475 1.5359071880993724e-007 -0.48728260397911072 0
		 -1.3483392535817984e-007 1.0000002384185791 7.3566681635384157e-008 0 0.48728260397911072 1.4605205933548859e-009 0.87324464321136475 0
		 22.791261672973633 10.295684814453125 -18.525789260864258 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841299057006836 1.3299732870564185e-007 0.52933543920516968 0
		 -1.5350924797985499e-007 1.0000003576278687 -5.2105413317349303e-009 0 -0.52933543920516968 -7.6837181950395461e-008 0.84841299057006836 0
		 -20.936428070068359 9.722050666809082 -31.235954284667969 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.16398537158966064 -0.97173184156417847 -0.16984151303768158 0
		 0.9844849705696106 0.15031544864177704 0.090524584054946899 0 -0.062435820698738098 -0.18205112218856812 0.98130494356155396 0
		 21.908823013305664 86.931968688964844 -10.584022521972656 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.54286611080169678 0.74270778894424438 0.39202228188514709 0
		 -0.71093851327896118 0.65490412712097168 -0.25625580549240112 0 -0.44706019759178162 -0.13959115743637085 0.88354480266571045 0
		 -22.111734390258789 92.884872436523438 -13.52207088470459 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.99991482496261597 -0.012987233698368073 0.0013197519583627582 0
		 0.012093177065253258 0.95963376760482788 0.28099259734153748 0 -0.0049157948233187199 -0.28095272183418274 0.9597090482711792 0
		 0.61381560564041138 102.77214050292969 0.49030923843383789 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99866151809692383 0.032715849578380585 -0.040062591433525085 0
		 -0.034800387918949127 0.99801492691040039 -0.052490372210741043 0 0.038265794515609741 0.053814303129911423 0.99781757593154907 0
		 29.557153701782227 49.079380035400391 -16.973110198974609 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.92512327432632446 -0.36888834834098816 -0.089824028313159943 0
		 0.37390777468681335 0.92627620697021484 0.046961620450019836 0 0.065878264605998993 -0.07703118771314621 0.99484986066818237 0
		 -17.596628189086914 33.219490051269531 -19.045360565185547 1;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "0125CB26-4283-5744-0728-C6B088D08AD2";
	setAttr ".ihi" 0;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "3437D5B9-45FB-2653-4DAB-92B91A3A3034";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 2.2204460492503131e-016 -0.12955878364949983 0.99157174303187068 0
		 0.94700241615378689 0.31851905799951852 0.041617706447969464 0 -0.32122643695513298 0.9390208364410032 0.12269248115002207 0
		 6.6941943584216208 53.522106149377045 -17.12007590430197 1;
	setAttr ".LeftUpLegGX" -type "matrix" -0.17304938195293895 -0.82807248123385224 0.5332449418899422 0
		 0.97117408929832016 -0.23357971215755052 -0.047557611705660252 0 0.16393634041870273 0.50964382707303812 0.84462331554928771 0
		 28.212577470489315 45.133530210065778 -14.226195849762458 1;
	setAttr ".LeftLegGX" -type "matrix" -0.10095347552076663 -0.22230095899044677 -0.96973762943516106 0
		 0.97117406855682431 -0.23357970716895715 -0.047557610689965932 0 -0.21593890432606996 -0.9465850229644972 0.23947351507544357 0
		 23.953511870654058 24.753133705948592 -1.1020508071223745 1;
	setAttr ".LeftFootGX" -type "matrix" 0.1208194097796271 -0.93934340388829418 0.32099367118597322 0
		 0.87841083562266209 -0.04945198110821139 -0.47534107427425976 0 0.46238218348297166 0.33939476013686221 0.81915454494020934 0
		 22.284689478619317 21.078363801533335 -17.132405211478254 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.077812580770657447 0.96934812780796031 -0.23304441682070215 0
		 0.99675842659727876 -0.080435449709783335 -0.0017576349295283997 0 -0.020448786934719562 -0.23215215583728899 -0.97246453532005728 0
		 -14.824188753646103 45.133530210065778 -14.226195849762462 1;
	setAttr ".RightLegGX" -type "matrix" 0.0058439558646646659 0.05059533493081167 0.9987021223236886 0
		 0.9967584053093751 -0.080435447991912629 -0.0017576348919903543 0 0.080242128797866741 0.9954750607212357 -0.050901433002708302 0
		 -16.739300395505833 21.276078546156654 -8.4905413925588 1;
	setAttr ".RightFootGX" -type "matrix" 0.42867050732191403 0.90324502547106567 -0.019755821605392847 0
		 0.81042495419762495 -0.37477042906129376 0.45028737713818467 0 0.39931596481440074 -0.20903550014485711 -0.89266512069972948 0
		 -16.835904598394102 20.439706275830886 -24.999699863214399 1;
	setAttr ".SpineGX" -type "matrix" -0.061880150537205331 0.92554124331557119 0.37355623169253543 0
		 0.997916970142531 0.064211541648869941 0.0062127788168104409 0 -0.018236438498964676 0.37316255059691483 -0.92758673313488416 0
		 6.6941943584216199 67.328870934799824 -17.49380218020238 1;
	setAttr ".LeftArmGX" -type "matrix" 0.16398530856950277 -0.97173195369519116 -0.16984204035533529 0
		 -0.96518981088987688 -0.12248965906018366 -0.23109587962121581 0 0.20375932367704039 0.20182591794657323 -0.95799195075634747 0
		 26.617666334763193 92.2926843691138 5.3185540629806063 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.17550495877930869 -0.35179782451956698 0.91947628659845437 0
		 -0.96518978533581212 -0.1224896558171856 -0.23109587350279329 0 0.19392539340749831 -0.9280274594827761 -0.31805416359547856 0
		 32.413457493243726 57.948419636983978 -0.684232342218003 1;
	setAttr ".LeftHandGX" -type "matrix" -0.2002055970283034 -0.12800839133344141 0.97135579979003173 0
		 -0.88807294777302648 -0.3950379171064774 -0.23509959202634639 0 0.41381705436360938 -0.9097028969034946 -0.03459208644739864 0
		 27.747112067606906 48.594774169820774 23.762913504075751 1;
	setAttr ".RightArmGX" -type "matrix" 0.54286615706943941 0.7427078810717197 0.39202287972209743 0
		 -0.76797928646142322 0.62792722690540503 -0.12615754854459066 0 -0.33985999705280945 -0.23257856041923125 0.9112643844538717 0
		 -15.815023695511206 100.52883754990367 -5.9503766560615201 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.54286620381749096 0.74270795731417427 0.39202297462869035 0
		 -0.76797933293169152 0.62792730063336755 -0.12615762387492327 0 -0.33986011060279853 -0.23257857700546355 0.91126443826788206 0
		 -36.226815482129837 72.60298835428523 -20.690454369520932 1;
	setAttr ".RightHandGX" -type "matrix" -0.078762151229906097 0.97561882498496777 -0.20485382407710356 0
		 0.80307271437534355 -0.059658231627878422 -0.5928878407903182 0 -0.59065366955198406 -0.21120970172052336 -0.77879376402294831 0
		 -51.582210405773289 51.594913484980438 -31.779130570327077 1;
	setAttr ".HeadGX" -type "matrix" -0.0049146370373998154 -0.28095508114629109 0.95970844849266457 0
		 0.99991503065084197 -0.012987267744477345 0.0013185049831028403 0 0.012093538194285165 0.95963315878380551 0.28099511852096126 0
		 8.3282985371040468 108.38714860169813 24.942810442053645 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.4872822875219095 4.9270050594962811e-008 0.87324463474729286 0
		 0.87324462883472453 1.3417787206402437e-008 -0.48728231059102067 0 -1.7157298637382468e-008 1.0000001660361506 -6.0850174898874343e-009 0
		 24.423219533113695 4.4526006776580722 -11.450896642796369 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.52933574789923421 6.2570184866661549e-009 -0.84841251738249968 0
		 0.84841258594239555 -2.7949760519896394e-008 0.5293356520770548 0 -3.4781137414618968e-009 -1.0000001454289003 2.1049449128174302e-008 0
		 -24.423219533113624 4.4526006776580811 -24.650025271457093 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.81727388070243023 -0.5552972009338597 0.15397662512842866 0
		 0.52793961386056221 0.61443581013461079 -0.58630073819233985 0 0.2309623943677124 0.56045859726187441 0.79532565017075674 0
		 8.8783056563530049 104.34570384722568 1.9764095644498454 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.90805479129031919 0.18929854737377269 0.37363486543298868 0
		 -0.12660687137621057 -0.72626748421649667 0.6756525041498791 0 0.39925889262788256 -0.66083414971939336 -0.63552414047595263 0
		 3.8947840899841335 104.63766161062389 2.159565856953046 1;
	setAttr ".NeckGX" -type "matrix" 0.082919023657752763 0.15058884324532151 0.98511307927590641 0
		 0.99389890321329577 -0.084641260772486765 -0.070719899071621489 0 0.072731571905142317 0.98496653925280642 -0.15668828326023448 0
		 6.9356211165931079 105.85791477021172 8.3972123940391903 1;
	setAttr ".Spine1GX" -type "matrix" 0.10767957572888991 0.60575595744967403 0.78833066274478036 0
		 0.99389890321329577 -0.084641260772486765 -0.070719899071621489 0 0.023886291469085722 0.79113576337066061 -0.61117408006611917 0
		 4.8882515957672652 94.340351924958469 -6.5917412250669454 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "B7883301-4952-09BD-71F0-E8B8085B4FF0";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAX";
	rename -uid "E2766DB4-4E0B-3AE7-4A14-2D873BB8F473";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 -5.4128432023666271e-006 2 4.3950739551772977e-006
		 3 4.0569922241925357e-006 4 -4.7895045592634914e-006 5 -5.014893258274846e-006 6 0
		 7 -4.1981871508082523e-016 8 0 9 -3.7189083481900182e-006 10 1.9158011931421409e-006
		 11 -1.239636197316499e-006 12 -5.4093215073038716e-006 13 -4.1981871312712797e-016
		 14 -3.8316020066661607e-006 15 -4.9585448221196656e-006 16 0 17 3.211784123981294e-006
		 18 -2.9300497080853121e-006 19 -1.73267385958616e-006 20 0 21 2.8173547617705298e-006
		 22 -4.1696851951298229e-006 23 -4.056990929961262e-006 24 2.0990897741190002e-016
		 25 -5.860097953116482e-006 26 1.4650246043093265e-006 27 -2.0990935656356399e-016
		 28 0 29 -5.071238665448735e-006 30 0 31 4.6204623248251517e-006 32 -2.2538845574472371e-006
		 33 -4.0569917101380673e-006 34 -4.7331564840267323e-006 35 -1.352330647077007e-006
		 36 0 37 0 38 -4.5077679867544768e-006 39 2.2538840022507949e-006 40 -4.1981871312712797e-016
		 41 4.0569910375638096e-006 42 2.2538842173549326e-006 43 2.0284962010642871e-006
		 44 2.4792730852079803e-006 45 2.2538844322572659e-006 46 4.1981871312712797e-016
		 47 -1.3523308169710235e-006 48 -2.0990935656356399e-016 49 4.3950738289367549e-006
		 50 2.0990973571522793e-016 51 -1.915801002208769e-006 52 2.7046610625967518e-006
		 53 2.3665783188385036e-006 54 2.1411900996509352e-006 55 2.6553575933976716e-006
		 56 2.6483138236648675e-006 57 0 58 2.4792726214651704e-006 59 -5.4093197161279036e-006
		 60 -1.4650248627262739e-006 61 -1.6904128813820781e-006 62 -4.1981871312712797e-016
		 63 2.0990935439965374e-016 64 3.042743093386148e-006 65 -2.0990935656356399e-016
		 66 -5.4093226010349903e-006 67 1.2396362490082101e-006 68 -1.239636226689187e-006
		 69 0 70 -2.479271840487354e-006 71 0 72 0 73 1.6340659304225979e-006 74 -2.1411895681540437e-006
		 75 -1.8594545021185572e-006 76 2.1130165837110914e-006 77 -2.6201401214845857e-006
		 78 -5.3388864020816127e-006 79 0 80 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAY";
	rename -uid "009F88E8-4836-F449-7F10-19BBD7AC2EF8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.737105494509741 1 18.737108659581491
		 2 18.737107454249266 3 18.737110239934697 4 18.737108134905835 5 18.737110050643587
		 6 18.737106181909329 7 18.737111809556954 8 18.737105676859478 9 18.737109711029614
		 10 18.737107109991193 11 18.737106014291971 12 18.737105925522314 13 18.737108207382985
		 14 18.737110149950521 15 18.737103643978053 16 18.737107370188184 17 18.737103566951117
		 18 18.737111610838454 19 18.737113630680089 20 18.737102937429153 21 18.73710737464533
		 22 18.737108355101014 23 18.737107367521638 24 18.737106523196942 25 18.737106837420146
		 26 18.737108295908872 27 18.737104362639002 28 18.7371122719439 29 18.737106072514781
		 30 18.737108508514229 31 18.737109021316328 32 18.737109762484334 33 18.737108545021691
		 34 18.737110684787378 35 18.737111961476014 36 18.73710665443155 37 18.737109199642397
		 38 18.737108673764677 39 18.737110392767967 40 18.737107862821922 41 18.73710891105582
		 42 18.737108705558029 43 18.737110682859392 44 18.737106441500856 45 18.737112100142252
		 46 18.737106781417431 47 18.737110371795776 48 18.737103722603702 49 18.737111121602201
		 50 18.737111805997881 51 18.737103138331722 52 18.737108394029558 53 18.737101425712964
		 54 18.737107954242418 55 18.737107315210679 56 18.737108078408635 57 18.737109624255339
		 58 18.737111228760913 59 18.737100169901446 60 18.737107402575742 61 18.737110662649052
		 62 18.737102876828917 63 18.737109282207722 64 18.737102131281471 65 18.737105091069854
		 66 18.737106938171905 67 18.737104963368505 68 18.737109644784102 69 18.737106589431452
		 70 18.737098178298695 71 18.737108481126725 72 18.737101633949322 73 18.73710441182109
		 74 18.737107879220343 75 18.737108956720537 76 18.737105643767642 77 18.737106911781826
		 78 18.737106111340683 79 18.737107184935944 80 18.737105494509741;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ";
	rename -uid "A70699D1-4BE0-1AA7-60B9-1E80AE7186BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0.25992103081164736 2 0.97262519589865193
		 3 2.0374781323378484 4 3.3538665644240853 5 4.8211843587561853 6 6.338811496631048
		 7 7.8061308526810214 8 9.1225207833370305 9 10.187372770466197 10 10.900072505652162
		 11 11.159994949746102 12 10.929820043876468 13 10.279263122937843 14 9.2682424178970724
		 15 7.9567169469617589 16 6.4046086781968139 17 4.6718482734136533 18 2.8183756394633885
		 19 0.90412009026136497 20 -1.010973113192956 21 -2.8669693182397125 22 -4.6039499007145457
		 23 -6.1619632507102349 24 -7.4810759619556277 25 -8.5013681027665804 26 -9.1628780614913694
		 27 -9.6027774736478619 28 -9.9991540930406106 29 -10.353477600621249 30 -10.667212231925625
		 31 -10.94185517261382 32 -11.178877806976695 33 -11.379743124275748 34 -11.545932705955181
		 35 -11.678920880015275 36 -11.780188482854882 37 -11.851205302303134 38 -11.893446006586844
		 39 -11.908378518779269 40 -11.897498018414197 41 -11.862261195493115 42 -11.804154991239651
		 43 -11.72464712668296 44 -11.62522258870802 45 -11.507345473652412 46 -11.372497484146061
		 47 -11.222143814706689 48 -11.057773913691847 49 -10.880853323374073 50 -10.692870738923494
		 51 -9.9954211158860105 52 -8.4292369856087195 53 -6.2044484554753412 54 -3.5311840886758117
		 55 -0.61955639168464194 56 2.3202789211473838 57 5.0782026195942693 58 7.4440974297756579
		 59 9.2078191198314414 60 10.159254546919446 61 10.514495223879738 62 10.644679065570903
		 63 10.572157678967171 64 10.319300800319855 65 9.9084791086953086 66 9.3620535487960108
		 67 8.7024062079418876 68 7.9518787605517645 69 7.1328690723641825 70 6.2677230792091629
		 71 5.3788220065518608 72 4.4885114682340532 73 3.6191845396926787 74 2.7931973894447077
		 75 2.0329203058457086 76 1.3607165337679796 77 0.7989534761305811 78 0.36999991922390352
		 79 0.096226676839106545 80 0;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX_tempLayer_inputA";
	rename -uid "ABC559CF-471E-977F-1295-0A83D274D24D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.5844721794128418 1 3.5839476585388184
		 2 3.582517147064209 3 3.5803978443145752 4 3.577817440032959 5 3.5749785900115967
		 6 3.5720505714416504 7 3.5691795349121094 8 3.5664360523223877 9 3.5639147758483887
		 10 3.5616590976715088 11 3.5597662925720215 12 3.5582904815673828 13 3.5572354793548584
		 14 3.5556426048278809 15 3.5530152320861816 16 3.5500273704528809 17 3.5471553802490234
		 18 3.5447618961334229 19 3.5430402755737305 20 3.5389645099639893 21 3.5346188545227051
		 22 3.5306453704833984 23 3.5268983840942383 24 3.5232586860656738 25 3.5196397304534912
		 26 3.5159754753112793 27 3.5124940872192383 28 3.5095467567443848 29 3.5072517395019531
		 30 3.505728006362915 31 3.5051145553588867 32 3.5049991607666016 33 3.5048971176147461
		 34 3.5048010349273682 35 3.5047447681427002 36 3.5047287940979004 37 3.5047769546508789
		 38 3.5049469470977783 39 3.505258321762085 40 3.5056331157684326 41 3.5060019493103027
		 42 3.5062940120697021 43 3.506420373916626 44 3.5063371658325195 45 3.5059497356414795
		 46 3.5050144195556641 47 3.5033595561981201 48 3.5011279582977295 49 3.4924046993255615
		 50 3.4820766448974609 51 3.4736862182617187 52 3.4662773609161377 53 3.4612729549407959
		 54 3.4598917961120605 55 3.4629085063934326 56 3.4704930782318115 57 3.4821860790252686
		 58 3.4969477653503418 59 3.5134346485137939 60 3.5302088260650635 61 3.5456662178039551
		 62 3.5584890842437744 63 3.5682065486907959 64 3.5744800567626953 65 3.578369140625
		 66 3.5813117027282715 67 3.5834543704986572 68 3.5849189758300781 69 3.5858547687530518
		 70 3.5863637924194336 71 3.5865428447723389 72 3.5865011215209961 73 3.5863003730773926
		 74 3.5860016345977783 75 3.5856630802154541 76 3.5853149890899658 77 3.5850002765655518
		 78 3.5847244262695312 79 3.5845434665679932 80 3.5844721794128418;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY_tempLayer_inputA";
	rename -uid "6F582654-4DEF-B7AB-698F-63B0259859B6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 51.742416381835938 1 51.735973358154297
		 2 51.717666625976562 3 51.689144134521484 4 51.65203857421875 5 51.607940673828125
		 6 51.558238983154297 7 51.504161834716797 8 51.446758270263672 9 51.386878967285156
		 10 51.325405120849609 11 51.263336181640625 12 51.200550079345703 13 51.134979248046875
		 14 51.027675628662109 15 50.852817535400391 16 50.625110626220703 17 50.353744506835938
		 18 50.047012329101563 19 49.712123870849609 20 49.3326416015625 21 48.931552886962891
		 22 48.520988464355469 23 48.107696533203125 24 47.699573516845703 25 47.305698394775391
		 26 46.934585571289063 27 46.597053527832031 28 46.3043212890625 29 46.065475463867188
		 30 45.889701843261719 31 45.786148071289063 32 45.726753234863281 33 45.677131652832031
		 34 45.636951446533203 35 45.605892181396484 36 45.583675384521484 37 45.5699462890625
		 38 45.565021514892578 39 45.568527221679688 40 45.579128265380859 41 45.595466613769531
		 42 45.616230010986328 43 45.640110015869141 44 45.665767669677734 45 45.691852569580078
		 46 45.714561462402344 47 45.731193542480469 48 45.741992950439453 49 45.707649230957031
		 50 45.718387603759766 51 45.845016479492188 52 46.062767028808594 53 46.363639831542969
		 54 46.740318298339844 55 47.185226440429688 56 47.689266204833984 57 48.240409851074219
		 58 48.822841644287109 59 49.417106628417969 60 50.001258850097656 61 50.544120788574219
		 62 51.013221740722656 63 51.380851745605469 64 51.619834899902344 65 51.767539978027344
		 66 51.879062652587891 67 51.958290100097656 68 52.009075164794922 69 52.035308837890625
		 70 52.040817260742188 71 52.029361724853516 72 52.004619598388672 73 51.970169067382813
		 74 51.92950439453125 75 51.886039733886719 76 51.843112945556641 77 51.80401611328125
		 78 51.772014617919922 79 51.750373840332031 80 51.742416381835938;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ_tempLayer_inputA";
	rename -uid "32E7D1A5-48B9-AEA8-3A5A-81AC9E72AD32";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -20.342348098754883 1 -20.33172607421875
		 2 -20.29884147644043 3 -20.242183685302734 4 -20.160243988037109 5 -20.051555633544922
		 6 -19.914699554443359 7 -19.748325347900391 8 -19.551153182983398 9 -19.321861267089844
		 10 -19.05914306640625 11 -18.761592864990234 12 -18.427719116210938 13 -18.056085586547852
		 14 -17.647869110107422 15 -17.136516571044922 16 -16.476768493652344 17 -15.702675819396973
		 18 -14.848369598388672 19 -13.948410987854004 20 -13.053242683410645 21 -12.188907623291016
		 22 -11.38736629486084 23 -10.684219360351562 24 -10.084447860717773 25 -9.5649642944335937
		 26 -9.119511604309082 27 -8.7417726516723633 28 -8.4252109527587891 29 -8.1632461547851562
		 30 -7.949282169342041 31 -7.7766647338867187 32 -7.6401290893554687 33 -7.534672737121582
		 34 -7.45391845703125 35 -7.3915576934814453 36 -7.3412399291992188 37 -7.296595573425293
		 38 -7.2361955642700195 39 -7.1553831100463867 40 -7.073246955871582 41 -7.0088033676147461
		 42 -6.9810781478881836 43 -7.0091228485107422 44 -7.111933708190918 45 -7.3084988594055176
		 46 -7.6756339073181152 47 -8.257542610168457 48 -9.0240745544433594 49 -9.9796485900878906
		 50 -11.068775177001953 51 -12.24029541015625 52 -13.466437339782715 53 -14.712808609008789
		 54 -15.947393417358398 55 -17.141260147094727 56 -18.268613815307617 57 -19.306005477905273
		 58 -20.230831146240234 59 -21.019887924194336 60 -21.647968292236328 61 -22.087558746337891
		 62 -22.309295654296875 63 -22.384986877441406 64 -22.410739898681641 65 -22.390369415283203
		 66 -22.327224731445313 67 -22.227252960205078 68 -22.096431732177734 69 -21.940788269042969
		 70 -21.76641845703125 71 -21.579399108886719 72 -21.385852813720703 73 -21.191921234130859
		 74 -21.003740310668945 75 -20.827484130859375 76 -20.669376373291016 77 -20.535587310791016
		 78 -20.432365417480469 79 -20.365877151489258 80 -20.342348098754883;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX";
	rename -uid "D9136DC3-4876-CC43-D3A2-879C4A590707";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.8783006942108935 1 -5.947512765108244
		 2 -6.1351569883698627 3 -6.4098951940646121 4 -6.7400082551174085 5 -7.0950176598508632
		 6 -7.4465154187292981 7 -7.7687682954902071 8 -8.0385703310864276 9 -8.2348220459658688
		 10 -8.3376398552101278 11 -8.3274731335464214 12 -8.1979444936140524 13 -7.9646301300722975
		 14 -7.6700678222504157 15 -7.3147626686420075 16 -6.871686757866013 17 -6.3523168161645049
		 18 -5.7717431131495056 19 -5.1492873354472737 20 -4.5405766670733305 21 -3.9496400775330245
		 22 -3.3979520434496115 23 -2.9167213695977292 24 -2.5203612193891272 25 -2.2060463140132076
		 26 -1.9802686854818516 27 -1.8108984037434266 28 -1.6601670354420499 29 -1.5242758192403338
		 30 -1.3990156691182341 31 -1.2793646516715915 32 -1.17287910402408 33 -1.0884289651053038
		 34 -1.0220507497120697 35 -0.96983755198927168 36 -0.92779407721885765 37 -0.89186133668903655
		 38 -0.84839014718569861 39 -0.794283792790203 40 -0.74160625760239307 41 -0.70237594862952579
		 42 -0.68865666011609283 43 -0.71255725163510986 44 -0.78606607702374265 45 -0.92065873204760884
		 46 -1.1638652698180874 47 -1.5404719009452317 48 -2.0268964806981011 49 -2.6535781566671277
		 50 -3.3383182700175063 51 -4.0972035977825421 52 -4.978715998096896 53 -5.9202785376951832
		 54 -6.8652769415732227 55 -7.7638087798137727 56 -8.5721266345861888 57 -9.2509885595896328
		 58 -9.7629293484901538 59 -10.069746853149889 60 -10.128287680612567 61 -9.976293144752173
		 62 -9.6994102361066972 63 -9.36720542995754 64 -9.0696199055969497 65 -8.802597535232275
		 66 -8.5229681847424548 67 -8.2386283049635516 68 -7.9561991902729607 69 -7.6806206383789659
		 70 -7.4156278443515964 71 -7.1637960663429077 72 -6.9272985486575278 73 -6.7079943207172885
		 74 -6.5081138673651981 75 -6.3300090575730756 76 -6.1766570701081047 77 -6.0513203919569705
		 78 -5.9574010812876068 79 -5.8986287809258204 80 -5.8783006942108935;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY";
	rename -uid "21150EAC-4B2E-99A5-2A24-D0B10823EC4F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.078697047608539 1 18.039086031426383
		 2 17.928636691170432 3 17.759425922014479 4 17.544069429950238 5 17.296202582780136
		 6 17.03095684352424 7 16.765156782889076 8 16.517221567469523 9 16.306262686182471
		 10 16.151996280059404 11 16.073104290224638 12 16.075233019987394 13 16.143422359996549
		 14 16.222657888670057 15 16.28748730542457 16 16.357579425923795 17 16.434239824819532
		 18 16.515185033594779 19 16.595147160333781 20 16.642484735142258 21 16.670466043984241
		 22 16.678977366627073 23 16.662768779158633 24 16.624357030853616 25 16.572369092860704
		 26 16.511025263191019 27 16.451765292985627 28 16.404249614080872 29 16.370770701521842
		 30 16.354462641469713 31 16.358340820841406 32 16.37098949946142 33 16.379663075317065
		 34 16.385632033421818 35 16.390270587871512 36 16.395006590926997 37 16.400979485914288
		 38 16.413188908325793 39 16.432404287561788 40 16.45394069150105 41 16.473291809307305
		 42 16.485884568921964 43 16.487254534392466 44 16.472926394833014 45 16.437847170897296
		 46 16.36290877434881 47 16.23505737959934 48 16.058017842212728 49 15.801583645274594
		 50 15.5248208741538 51 15.260545038656614 52 14.979931182880854 53 14.69297560343167
		 54 14.415546629227398 55 14.169212947612952 56 13.981576114000699 57 13.884331838045753
		 58 13.913868207673948 59 14.106174675472628 60 14.494911380608865 61 15.023350321876904
		 62 15.580497182205315 63 16.094865720265492 64 16.48948497279515 65 16.786251670844379
		 66 17.052827246452789 67 17.285109872752841 68 17.481632372136637 69 17.642859167493679
		 70 17.771250374900056 71 17.87056225771628 72 17.944664792857306 73 17.99798203384751
		 74 18.034555641002466 75 18.058045668206365 76 18.071657186780264 77 18.078059044142893
		 78 18.079931157611412 79 18.079356744265748 80 18.078697047608539;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "50945361-4650-EE10-D601-9AB41AB06907";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.5969551528766512 1 5.275092097653272
		 2 4.3956599820334805 3 3.0905414731035505 4 1.4925246115035691 5 -0.26836390201334537
		 6 -2.0661473680931821 7 -3.7797857700571456 8 -5.2925247251977723 9 -6.4909293828660877
		 10 -7.2630865548151791 11 -7.4978635021882125 12 -7.1563019967020738 13 -6.3204601639701075
		 14 -5.1844244591967907 15 -3.8193757752103439 16 -2.1688151500109432 17 -0.27562169757951688
		 18 1.8050864735129166 19 4.0041780193311496 20 6.1473339945505794 21 8.2091391530406899
		 22 10.110927287789057 23 11.744991776069403 24 13.048073303388607 25 14.002986142654272
		 26 14.566631263608455 27 14.904218257559535 28 15.216974120246686 29 15.523587987591496
		 30 15.844485601559807 31 16.202040121741124 32 16.549032483038641 33 16.828700680642388
		 34 17.051774061124096 35 17.228981376842942 36 17.371499789674818 37 17.490285280558574
		 38 17.622793019586304 39 17.777601390949759 40 17.922307783880726 41 18.024434825673495
		 42 18.05109793823922 43 17.969672898874379 44 17.747754983379711 45 17.354530988849877
		 46 16.662273262621188 47 15.607560019831602 48 14.259508560147058 49 12.542993603537917
		 50 10.745381828647108 51 8.6069263520596664 52 5.7821269162021904 53 2.5272713738165056
		 54 -0.91219055157233919 55 -4.3020863081672172 56 -7.4166571438033859 57 -10.037876613861497
		 58 -11.951238087680677 59 -12.949233702556713 60 -12.823289108117537 61 -11.85054219098302
		 62 -10.533941395982792 63 -9.1099963378622952 64 -7.8577901033755904 65 -6.7360660020014356
		 66 -5.5705356372512425 67 -4.3891845152931772 68 -3.2147267026768822 69 -2.065118340833068
		 70 -0.95424374262376033 71 0.1070131093056714 72 1.1088236259950488 73 2.0416658641785048
		 74 2.8948671313632719 75 3.6569066828917625 76 4.3142627868699721 77 4.8523701286227139
		 78 5.2561118817065458 79 5.5092816520149928 80 5.5969551528766512;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX";
	rename -uid "66EFB380-4D3D-BEDB-8525-C9B3FADF392F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.9973669760919477 1 2.9895303042269212
		 2 2.9675645827817174 3 2.9342444282875926 4 2.8924035494717044 5 2.8442250106452041
		 6 2.7908503759668286 7 2.7321212958381622 8 2.6665674216153246 9 2.5919622729519216
		 10 2.5057984623031673 11 2.4061784968061013 12 2.2931255324263771 13 2.1685602033035272
		 14 2.0017073386340476 15 1.7665769252797485 16 1.4815393864696489 17 1.1701269621887831
		 18 0.85267854043364633 19 0.54449845847156242 20 -0.83206557394362834 21 -0.94976525733164796
		 22 -1.0440928212005389 23 -1.1237752658663827 24 -1.1976050236325946 25 -1.2699611573205423
		 26 -1.3457405829258982 27 -1.4188591853513657 28 -1.4794172739068381 29 -1.5239040251608333
		 30 -1.5489710426313106 31 -1.5504176223198618 32 -1.5400853973446744 33 -1.5323755781744512
		 34 -1.5264037138387085 35 -1.5213268668383393 36 -1.5161947343227669 37 -1.5098419670990764
		 38 -1.4979101698364674 39 -1.4794840389809789 40 -1.4588577298481173 41 -1.440459203937231
		 42 -1.428727183081794 43 -1.4281146589051572 44 -1.4429196117629164 45 -1.4764582935060124
		 46 -1.5430110196692648 47 -1.6461322277011765 48 -1.771301742090126 49 -1.8771725577335603
		 50 -1.9377779430023565 51 -1.9425333649805447 52 -1.8802501093076658 53 -1.7313375242077353
		 54 -1.4864504657287541 55 -1.1491858327682132 56 -0.73754522182313753 57 -0.282531386331343
		 58 0.17334302185727093 59 0.57853679548852988 60 0.87806701500075968 61 2.3928994412540736
		 62 2.8746069272586188 63 3.2221195175538213 64 3.4344513019185454 65 3.5488697096839426
		 66 3.6174408121442134 67 3.6471006144119444 68 3.644683078666803 69 3.6166578256590713
		 70 3.5689904388901503 71 3.5071018514530725 72 3.4359650365279055 73 3.3600016538703876
		 74 3.2832523455738651 75 3.2093896822546322 76 3.1417510437569396 77 3.0836000535295613
		 78 3.0379977593630474 79 3.008153026206378 80 2.9973669760919477;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY";
	rename -uid "8935FF82-4F46-2E48-F7EE-31A208DE2B72";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.076412211346688977 1 -0.07306001026990662
		 2 -0.06380008686310136 3 -0.049712375833052519 4 -0.032052028744879613 5 -0.011870436905746294
		 6 0.0098132879659305079 7 0.032320614046639627 8 0.055140256411169299 9 0.077782025539425537
		 10 0.099925900068177545 11 0.1210742532929262 12 0.14091438674545056 13 0.15951423780315435
		 14 0.18526075625598609 15 0.22489709050865597 16 0.27495574097430331 17 0.3312052656766693
		 18 0.38957148318109608 19 0.44657035735536571 20 0.50160849110542238 21 0.55335245344862205
		 22 0.60338220689981081 23 0.65575656320863684 24 0.71357170614600673 25 0.77767140011597091
		 26 0.84998542731491056 27 0.92326779560813665 28 0.98693745895016194 29 1.0367401133939562
		 30 1.0681183322088574 31 1.0765523784247832 32 1.0728866402150994 33 1.0705199959747895
		 34 1.0688879443093309 35 1.0673140744608023 36 1.0651544937212492 37 1.0616354736868814
		 38 1.0538193051900633 39 1.0412037497113071 40 1.0268071675096904 41 1.0135725484345566
		 42 1.0044049517231175 43 1.0023025273253645 44 1.0099718098029826 45 1.0301936542960677
		 46 1.0737631174327325 47 1.1461016611300971 48 1.2413484722020969 49 1.3544560506894292
		 50 1.4443423330871663 51 1.496781029352489 52 1.5242426413945229 53 1.5101747521934188
		 54 1.4425515712049384 55 1.3178694918176899 56 1.142872326620846 57 0.93404306556645245
		 58 0.71324355333353917 59 0.50275493772281254 60 0.31857685853055528 61 0.17143452173374615
		 62 0.063922924885587581 63 -0.010102495841733864 64 -0.055507994201474183 65 -0.082498271910482188
		 66 -0.10206552859551653 67 -0.11534788935028137 68 -0.12338493025034052 69 -0.12703116193627692
		 70 -0.1271315262404549 71 -0.12443013530792028 72 -0.11966051430258876 73 -0.11345075754485363
		 74 -0.10649850715064887 75 -0.099249380908473336 76 -0.092293586370560454 77 -0.086079106374544606
		 78 -0.081053395881928891 79 -0.077659855289061497 80 -0.076412211346688977;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ";
	rename -uid "6224D755-4D75-1C0D-19A0-598B58448BA1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -34.106206373824712 1 -33.906921751804347
		 2 -33.356333351389409 3 -32.530427865060574 4 -31.507167802333541 5 -30.35907757815124
		 6 -29.149989134040634 7 -27.933948678671403 8 -26.756406724798332 9 -25.656280532018144
		 10 -24.669070512652528 11 -23.829894657688548 12 -23.145760914964921 13 -22.577429719556314
		 14 -21.783006443150235 15 -20.529956314577245 16 -18.970834009468348 17 -17.239915219925649
		 18 -15.440245070476552 19 -13.640621123015348 20 -11.700307655311638 21 -9.7673916291406684
		 22 -7.8790025877713692 23 -6.0140135015672049 24 -4.1731515813981135 25 -2.3886088687282365
		 26 -0.67918223148369627 27 0.87215907677870452 28 2.181666530261396 29 3.2128477745823276
		 30 3.9255083468321392 31 4.2757061798322598 32 4.4207305031183486 33 4.5480650533179006
		 34 4.6539175000449813 35 4.7341877239634282 36 4.7841992104894127 37 4.7991603186731231
		 38 4.7546413593673744 39 4.6471052606445937 40 4.5034218566334152 41 4.3509338617079871
		 42 4.217969638717129 43 4.1324784976866908 44 4.1214503773923425 45 4.2088968566720641
		 46 4.4853419579050549 47 4.9801424301244959 48 5.6162521392699007 49 6.5677627760542645
		 50 7.2354105948644944 51 7.256361250818034 52 6.7918057254102528 53 5.8038543364822068
		 54 4.2613195364962371 55 2.1444577565452079 56 -0.55159746224937778 57 -3.8096511422631334
		 58 -7.5899682241191559 59 -11.820485461356961 60 -16.41682070009151 61 -21.085364137181209
		 62 -25.367715009270036 63 -28.957489362903459 64 -31.517958546773439 65 -33.234195425860584
		 66 -34.605522576924749 67 -35.637133224843176 68 -36.347079294625701 69 -36.764081968230883
		 70 -36.926928955564577 71 -36.880124822516194 72 -36.670340490795638 73 -36.344794909299054
		 74 -35.946949164991125 75 -35.517844335901252 76 -35.094300321539137 77 -34.709748983084744
		 78 -34.396351870367795 79 -34.184327744866685 80 -34.106206373824712;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX";
	rename -uid "6C2F6BE7-4014-F278-78BC-0EBFCC3E5BB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -24.436306507811004 1 -24.461300165432103
		 2 -24.5300731480413 3 -24.632959770349601 4 -24.760201318073541 5 -24.902312961291809
		 6 -25.050413102892001 7 -25.196116379190329 8 -25.331456978029113 9 -25.448839741019672
		 10 -25.54087527458984 11 -25.600334411435163 12 -25.624982104492126 13 -25.620640219549742
		 14 -25.589198397444925 15 -25.540592901944507 16 -25.483323678689949 17 -25.416469562344002
		 18 -25.340755800754895 19 -25.258142821720874 20 -24.210335834403313 21 -24.26776616508559
		 22 -24.326684798585873 23 -24.38619640441307 24 -24.44569721979272 25 -24.506063334241087
		 26 -24.567030117493101 27 -24.620638590572881 28 -24.660746395584603 29 -24.690092378955956
		 30 -24.711125227121819 31 -24.726006170247295 32 -24.736758676373107 33 -24.744754423708883
		 34 -24.75071694889542 35 -24.755289765323187 36 -24.75914422071472 37 -24.763001767261386
		 38 -24.769502120885164 39 -24.779049858453611 40 -24.789148658431007 41 -24.797402809685742
		 42 -24.801710191230015 43 -24.799760379645381 44 -24.789343388745952 45 -24.768205408423377
		 46 -24.72656053219594 47 -24.65684998787183 48 -24.55920312397857 49 -24.461545190645978
		 50 -24.35086278956776 51 -24.24883610953361 52 -24.191956370587956 53 -24.186763858288341
		 54 -24.23062792282574 55 -24.308856421420352 56 -24.395422215013266 57 -24.456720771092531
		 58 -24.456187149812038 59 -24.357040947532511 60 -24.122760944686707 61 -24.96641859232632
		 62 -24.989004126357631 63 -24.97515457518471 64 -24.930559008245631 65 -24.876267632507961
		 66 -24.816079121223154 67 -24.755235522823465 68 -24.697576929890296 69 -24.645798577606982
		 70 -24.600995932570026 71 -24.563349712464952 72 -24.532362383109955 73 -24.507114273599985
		 74 -24.486785897916995 75 -24.470556755283603 76 -24.45780128718911 77 -24.448197947771742
		 78 -24.441488421854931 79 -24.437568513255187 80 -24.436306507811004;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY";
	rename -uid "A33FD784-49DE-E717-B853-7DA1FCCC3BDD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.93442063082092 1 15.921094787054615
		 2 15.883715718872862 3 15.826234136427621 4 15.752771057138069 5 15.667408103955539
		 6 15.574629609751637 7 15.478787518783255 8 15.38470366646955 9 15.297758714908042
		 10 15.223188791507077 11 15.16596296018397 12 15.127179106208599 13 15.102204835445976
		 14 15.066406165972415 15 15.005241849379253 16 14.928951529251611 17 14.844831236488265
		 18 14.757446441418615 19 14.669272374433477 20 15.078429074608922 21 14.905127915557506
		 22 14.732629600440873 23 14.563312496583684 24 14.401353638958717 25 14.252428572748492
		 26 14.121412116291724 27 14.009481571406052 28 13.915066008418471 29 13.839540686026849
		 30 13.784383189075848 31 13.751473733866748 32 13.731818764341181 33 13.714985677837731
		 34 13.701099499245398 35 13.690241991129769 36 13.682413259724052 37 13.677893164861979
		 38 13.677366849557217 39 13.680951546985986 40 13.687493157280505 41 13.6958490360618
		 42 13.704942502198588 43 13.713367481345156 44 13.720055374705124 45 13.72395963804559
		 46 13.721458610949449 47 13.711610261640594 48 13.697633745475965 49 13.64463417899683
		 50 13.597693558419014 51 13.602203507178976 52 13.649641389769133 53 13.727327700529958
		 54 13.824968423983959 55 13.938556252714347 56 14.073410218356543 57 14.244059160196025
		 58 14.470521227964106 59 14.771594081803942 60 15.158223158673415 61 14.951306016882734
		 62 15.239904049717351 63 15.511255422385396 64 15.720091384532008 65 15.867729878258476
		 66 15.989619197351512 67 16.083386420363919 68 16.148791622477763 69 16.187410186938635
		 70 16.202314795608281 71 16.197316290038987 72 16.176973588800642 73 16.145763069433837
		 74 16.107792050118917 75 16.066972396596992 76 16.026883990977037 77 15.990722039594591
		 78 15.961392878864935 79 15.941672174111291 80 15.93442063082092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ";
	rename -uid "4BF354F8-4004-3296-7D75-5A9FABDA4A04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 17.952110477348128 1 17.768292067817839
		 2 17.262416459303871 3 16.505541714730576 4 15.569780416464511 5 14.524801882130902
		 6 13.435610114254368 7 12.362141501571354 8 11.359741112948132 9 10.480240258552261
		 10 9.7735051426591379 11 9.2898243385578478 12 9.0459511595924944 13 9.0013068471702962
		 14 8.9386752029923962 15 8.7266577911202514 16 8.4555209080936553 17 8.1793338595959586
		 18 7.9310726507009726 19 7.7209026335266362 20 7.500894404054721 21 7.2063413591387162
		 22 6.8817910319979294 23 6.4846064935752521 24 5.9981845015134265 25 5.4350548083214534
		 26 4.7945364500303356 27 4.1639309079218192 28 3.6399698925808535 29 3.2445531321841128
		 30 3.0015211999471147 31 2.9370250646496578 32 2.9646213976110913 33 2.981684900229308
		 34 2.9930460294271963 35 3.003703981018603 36 3.0188057794836514 37 3.0437871142699935
		 38 3.0998515105305517 39 3.1908003053524734 40 3.2957009628088691 41 3.3933261625902058
		 42 3.4618993356458843 43 3.4798845013055693 44 3.4261728000466403 45 3.2808044859748153
		 46 2.9664966675533693 47 2.4491690600656209 48 1.7785194168675831 49 0.89667258978837028
		 50 0.13273304798540123 51 -0.45414564302622984 52 -1.052579670049854 53 -1.5798256704431375
		 54 -1.9408706808590463 55 -2.0319303892833482 56 -1.7509067426381559 57 -1.0120228858715599
		 58 0.24228170803615015 59 2.0325946360266478 60 4.3569462948830289 61 6.8923175188739343
		 62 9.3489009141306152 63 11.480170403384326 64 13.057573127994846 65 14.187355003493698
		 66 15.159848537242938 67 15.971414450259811 68 16.625994405589484 69 17.133402960292081
		 70 17.509486041355082 71 17.772959647570055 72 17.943680996773303 73 18.041853771555918
		 74 18.084980386733697 75 18.089149902412437 76 18.068111365622528 77 18.033389545024985
		 78 17.995716668264283 79 17.964982368685032 80 17.952110477348128;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX";
	rename -uid "87C0758C-44EB-504C-C0E4-F4A8FC07DE45";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -11.98778207991406 1 -12.21619577210901
		 2 -12.835807056536449 3 -13.746289884486528 4 -14.84603452003563 5 -16.033066818271642
		 6 -17.210385719679802 7 -18.287163978363203 8 -19.180820225634271 9 -19.816784462254471
		 10 -20.123722906887387 11 -20.026829003440763 12 -19.490596572574567 13 -18.55379344822062
		 14 -17.263187276543452 15 -15.573323937284885 16 -13.443458334513442 17 -10.950533043444395
		 18 -8.1972196630584104 19 -5.3091203654577237 20 -2.4460342803420607 21 0.27532384089216538
		 22 2.7417234853909118 23 4.8542628412269897 24 6.5740263355961988 25 7.9113406591082587
		 26 8.8588563088851284 27 9.5531261248485748 28 10.145250609671743 29 10.649418048731851
		 30 11.079561574014308 31 11.449048907631651 32 11.758715865582943 33 12.007106399045192
		 34 12.203697156631607 35 12.357803331643174 36 12.478641585587045 37 12.574874493240548
		 38 12.674198783058948 39 12.782477364552124 40 12.877748762807547 41 12.937661509156019
		 42 12.939812855236573 43 12.861419268504873 44 12.679609478026874 45 12.371356998433786
		 46 11.842037747054343 47 11.037081133786806 48 9.9924577843715294 49 8.7039917387115135
		 50 7.2540960091440896 51 5.330820549356365 52 2.6230990159519156 53 -0.7587614892297424
		 54 -4.6566708422681096 55 -8.8334750636106758 56 -12.972414803134965 57 -16.722935152609452
		 58 -19.778617538919118 59 -21.940069213939914 60 -23.113288123710539 61 -23.563562780618291
		 62 -23.621526977229923 63 -23.425384231812 64 -23.119924733300682 65 -22.705280145925069
		 66 -22.163180985573554 67 -21.508089391472495 68 -20.75469664134388 69 -19.918815854305247
		 70 -19.018432706148044 71 -18.073919417092597 72 -17.10856204311791 73 -16.147872838802957
		 74 -15.220005224033576 75 -14.353693651479883 76 -13.57876388290609 77 -12.925408235392105
		 78 -12.423155018019019 79 -12.101238386446544 80 -11.98778207991406;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY";
	rename -uid "94E1876C-49EA-A638-878B-D0856600D29D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 37.744698874691927 1 37.724981814968878
		 2 37.664101988420967 3 37.554152531731049 4 37.387882247914227 5 37.165690687376923
		 6 36.899314802493137 7 36.613473815328838 8 36.344632590357797 9 36.137116253409573
		 10 36.037357230497186 11 36.086355306625471 12 36.292332048533034 13 36.615382676471896
		 14 37.007628793955512 15 37.434763344269065 16 37.838325569769601 17 38.135817676931026
		 18 38.261362882113772 19 38.175349702808433 20 37.876019624797351 21 37.386561025058356
		 22 36.758323930264567 23 36.065142105887794 24 35.382732009083497 25 34.77461109615713
		 26 34.30338422234589 27 33.93637004269732 28 33.604633384922174 29 33.309469001173419
		 30 33.050567675622815 31 32.826675651234638 32 32.636697905155444 33 32.479037592841252
		 34 32.350948554189138 35 32.24887750061783 36 32.168880659666605 37 32.107060746873486
		 38 32.050064639032662 39 31.994567313726847 40 31.951039730956051 41 31.930328805735193
		 42 31.943275281718297 43 32.000509525887125 44 32.111763234873457 45 32.285708510200216
		 46 32.561364805880544 47 32.952277218097706 48 33.426067482839187 49 33.974492097721217
		 50 34.547733376562078 51 35.294832941654754 52 36.252878695154202 53 37.201586608031938
		 54 37.934061656345669 55 38.284923697179856 56 38.166849230982542 57 37.607203725364762
		 58 36.757542487743933 59 35.860861527905051 60 35.184634388796169 61 34.794953872681788
		 62 34.613075783597942 63 34.596748173421823 64 34.679689502156705 65 34.843303014146116
		 66 35.070938300029532 67 35.344677491472645 68 35.646516440957008 69 35.960208903582064
		 70 36.270533978837442 71 36.564909885198688 72 36.83333824190067 73 37.068545772440359
		 74 37.266653815580703 75 37.426414402201992 76 37.54940744087348 77 37.638794514790064
		 78 37.698813786157189 79 37.733278938115603 80 37.744698874691927;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "7C983725-43E4-E848-C6FE-B1838778C19B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.9197862161148027 1 5.4164571982939265
		 2 4.0460886592609269 3 2.0183369569175391 4 -0.45609206602243879 5 -3.1643047737140071
		 6 -5.895628309285402 7 -8.4416658924825363 8 -10.598281990169278 9 -12.166411500467593
		 10 -12.949173720855642 11 -12.747723152659429 12 -11.481715480120274 13 -9.276437912450394
		 14 -6.2431523478206827 15 -2.321601159836816 16 2.493882031056617 17 7.9957163661377075
		 18 13.957234727320438 19 20.13791199179369 20 26.261652218153348 21 32.120291858361803
		 22 37.509119742066048 23 42.235969876682532 24 46.199081933453186 25 49.372554548938453
		 26 51.693320282951454 27 53.441661118103312 28 54.951909687253135 29 56.240980057896685
		 30 57.325212504568633 31 58.220738945674078 32 58.953084357254703 33 59.548705137588918
		 34 60.025416073308882 35 60.400680905606038 36 60.692221341704006 37 60.917051441471365
		 38 61.127246551650472 39 61.335256023373297 40 61.501287214705549 41 61.584707648640411
		 42 61.544821394799214 43 61.340474224598879 44 60.930785824185953 45 60.275515051041346
		 46 59.204329890916149 47 57.625035042771252 48 55.614491611644709 49 53.186041343834006
		 50 50.425748631851242 51 46.522372839995015 52 40.837098384052432 53 33.690384133179094
		 54 25.431101840065601 55 16.489540852728098 56 7.4072112851877696 57 -1.1840145671212914
		 58 -8.6348837225977242 59 -14.362474105349945 60 -17.888128797888523 61 -19.643968539446945
		 62 -20.360993018252316 63 -20.312919289500247 64 -19.814067126170837 65 -18.921304849641519
		 66 -17.671010997223405 67 -16.117294647959184 68 -14.313754414508956 69 -12.31387586698378
		 70 -10.172748047882388 71 -7.9468123228546172 72 -5.6944256702640041 73 -3.4757044447565533
		 74 -1.3522692117848776 75 0.61403958592158192 76 2.3611283463283566 77 3.8266077052210865
		 78 4.9490311584772471 79 5.6669569616419544 80 5.9197862161148027;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX";
	rename -uid "EC89F26F-4325-9068-1071-3BB2E54D9B46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.563226362957951 1 -6.5359846156804613
		 2 -6.4617527077634236 3 -6.3514729400230987 4 -6.2158973562444695 5 -6.0662133378617638
		 6 -5.9129195969578801 7 -5.7669258757332296 8 -5.6395041769791936 9 -5.5421361327215717
		 10 -5.4865986836683938 11 -5.4845499217334819 12 -5.5403251903902699 13 -5.6457196390208821
		 14 -5.7739324332864159 15 -5.9177955631448649 16 -6.0879402902122424 17 -6.2779544585428733
		 18 -6.4824181892235995 19 -6.6960051500864992 20 -6.9190572849421823 21 -7.1366609904231098
		 22 -7.332225544795401 23 -7.4850860593133044 24 -7.5845774045958958 25 -7.6340447653845009
		 26 -7.630679983275356 27 -7.599786565077256 28 -7.5734729605421593 29 -7.5605855796661396
		 30 -7.5704376052981033 31 -7.6129401215395509 32 -7.6681459766063131 33 -7.7108126540777029
		 34 -7.7438089813576632 35 -7.7701569727427424 36 -7.7931134848162094 37 -7.8159381626687834
		 38 -7.8512693452626356 39 -7.9011617083747634 40 -7.9545003383924922 41 -7.9995851376692535
		 42 -8.0245648126985323 43 -8.017446915281397 44 -7.9668916791055393 45 -7.8629285771009991
		 46 -7.6647391514144818 47 -7.359345471486769 48 -6.9812955001269605 49 -6.5760381249878073
		 50 -6.2211810157791705 51 -5.9215425408421565 52 -5.657079311864055 53 -5.447851406054923
		 54 -5.2883163283609926 55 -5.1535074764136333 56 -5.0150536083045321 57 -4.8623196944246461
		 58 -4.7141986487934595 59 -4.6142715525905373 60 -4.6126463196742487 61 -4.7022437222386433
		 62 -4.8400120004929592 63 -4.9948644444977752 64 -5.1277641428195402 65 -5.2453875057199673
		 66 -5.3679874104475651 67 -5.4931498223472675 68 -5.6183677989471716 69 -5.7420120231284004
		 70 -5.8621781471526928 71 -5.9774154479594568 72 -6.0862972673314051 73 -6.1873711023611655
		 74 -6.2791584142300652 75 -6.3603861617556516 76 -6.4298837821817321 77 -6.4862235626162406
		 78 -6.5281605805682821 79 -6.5542429778482942 80 -6.563226362957951;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY";
	rename -uid "A2CF109A-45F5-4045-E5A1-08B539991A32";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.021013933637111154 1 0.021993338885532645
		 2 0.024461735663788706 3 0.027345934328327191 4 0.029807371777448275 5 0.031220523731029504
		 6 0.031450222169341457 7 0.030613316727053218 8 0.029186628256712688 9 0.027671477426634627
		 10 0.02663475066748423 11 0.026448972999892052 12 0.027305153278535055 13 0.028755480434283456
		 14 0.029605977319430352 15 0.029678285915882018 16 0.029140022315297203 17 0.027276248444048169
		 18 0.022940391024955611 19 0.01468367822001085 20 0.0016766352478245722 21 -0.016247368810458716
		 22 -0.037053737656101891 23 -0.056267077210700067 24 -0.070045418594431252 25 -0.077245723488146623
		 26 -0.07680119357168598 27 -0.072376301309227981 28 -0.068738977425783471 29 -0.067081099073611095
		 30 -0.068657879914418463 31 -0.074999000492203802 32 -0.083455912175955008 33 -0.090198209657020662
		 34 -0.095519429229588435 35 -0.09981922156503692 36 -0.10361949454056769 37 -0.10751703557642452
		 38 -0.11378213353475053 39 -0.12289026116283028 40 -0.13301312252021094 41 -0.14184517074987929
		 42 -0.14694302928280525 43 -0.14565832713709823 44 -0.13586652904158589 45 -0.1164137763125085
		 46 -0.082594012347558005 47 -0.039533584016389671 48 -0.0026806473150292158 49 0.014718534452579358
		 50 0.0070357651446778784 51 -0.021346875330262194 52 -0.069407793720231731 53 -0.12903154098562955
		 54 -0.18767416655012517 55 -0.23243062424828242 56 -0.25440785983375924 57 -0.25028653092541525
		 58 -0.22229772849674209 59 -0.17690050271947527 60 -0.1223791143382036 61 -0.070424019351323086
		 62 -0.029333729762606564 63 -0.0017596172729409927 64 0.012945693232351851 65 0.021080709882681601
		 66 0.02661974397610475 67 0.030172170267109204 68 0.032216600220656998 69 0.033131272969326366
		 70 0.033176215416064067 71 0.032605042751274162 72 0.031542957307291765 73 0.030091589439993967
		 74 0.028426876199669181 75 0.026672396048126275 76 0.024941821139354486 77 0.023348197452880831
		 78 0.022125866993345743 79 0.021296933556742382 80 0.021013933637111154;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ";
	rename -uid "8EDAA24E-47D0-DE32-DA28-139ADD5E9E0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 36.812727675331793 1 36.994136823170805
		 2 37.48082302610532 3 38.181624475302378 4 39.006264041603522 5 39.868497812804073
		 6 40.696925229815363 7 41.433058854809893 8 42.032151146657839 9 42.45913909468004
		 10 42.682659673498776 11 42.663958897358157 12 42.378194679275204 13 41.834815128652757
		 14 41.161067564330665 15 40.330509181888161 16 39.180520970671758 17 37.683686121179797
		 18 35.840169435540666 19 33.69000467414444 20 31.425312986079408 21 29.086431883175585
		 22 26.798110367027817 23 24.742900166573627 24 23.039898789175375 25 21.727415116422616
		 26 20.88142248985778 27 20.331766120689611 28 19.839852213775426 29 19.369951730782443
		 30 18.883155859254259 31 18.337311695334719 32 17.806224257980364 33 17.381898875332961
		 34 17.045938041536346 35 16.779174128318925 36 16.56171227193834 37 16.372835522588581
		 38 16.139632780184524 39 15.848856263798684 40 15.562750142433615 41 15.346105222791776
		 42 15.264016163237656 43 15.380897629408393 44 15.759794376140306 45 16.458766568561057
		 46 17.719151270857346 47 19.64917714169367 48 22.10061525331006 49 25.155192332992193
		 50 28.319060910401852 51 31.724642095976801 52 35.646018714765752 53 39.675012585705751
		 54 43.44721858918362 55 46.655993188175934 56 49.070391439833543 57 50.55691631885901
		 58 51.09638503365688 59 50.777983200126194 60 49.75883165383572 61 48.374006762534677
		 62 46.935991382846211 63 45.652240914567017 64 44.723301969907943 65 44.028417078510394
		 66 43.373533377053427 67 42.749586198817845 68 42.147238210006222 69 41.557670703814175
		 70 40.975178844252355 71 40.396928933227073 72 39.824121222118151 73 39.261647926313231
		 74 38.721202437878908 75 38.214701257757454 76 37.758407961246988 77 37.370878778702142
		 78 37.071697355958769 79 36.879870182533118 80 36.812727675331793;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX";
	rename -uid "C00983E1-4DC3-EB59-2FAC-D982CA3885F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 35.390343278663707 1 35.379313236989418
		 2 35.348767756526357 3 35.302379928985786 4 35.243854850206326 5 35.176732352292959
		 6 35.104627493555228 7 35.030970125886348 8 34.95904169587488 9 34.892200961609703
		 10 34.833559655276041 11 34.78571185768471 12 34.748480052177925 13 34.717294128819411
		 14 34.683964803072541 15 34.631566310690829 16 34.547447439778722 17 34.429207503154629
		 18 34.27636034715416 19 34.090768981782745 20 33.872633082003297 21 33.633266916547811
		 22 33.384953676502874 23 33.14101523233154 24 32.907093118445744 25 32.680162275635652
		 26 32.461422429569524 27 32.258206735665823 28 32.07954445952516 29 31.929181736874728
		 30 31.810621335699189 31 31.727060516398478 32 31.66878790980957 33 31.62279112511596
		 34 31.58712632677004 35 31.559641219450508 36 31.538289227524618 37 31.520893570953717
		 38 31.500528019724847 39 31.475646424115382 40 31.452110600638001 41 31.435702679865294
		 42 31.432223780970773 43 31.447552969419981 44 31.487346775144808 45 31.557484307757708
		 46 31.681975760405471 47 31.874428976249536 48 32.124099744446298 49 32.411190943208886
		 50 32.74473889892473 51 33.108793118358356 52 33.463043995576463 53 33.785664678898009
		 54 34.061561959384164 55 34.28711879123982 56 34.468510244778834 57 34.615648991504706
		 58 34.736381257460224 59 34.837864668576721 60 34.931266418651227 61 35.01333987628977
		 62 35.073406653315089 63 35.118050974812341 64 35.15258976966502 65 35.182077061056681
		 66 35.211057136630131 67 35.239067229186915 68 35.265666584379893 69 35.290294611346219
		 70 35.31240286815715 71 35.331734743537062 72 35.347981457151434 73 35.361189167705852
		 74 35.371462302860124 75 35.378998010219483 76 35.384204419696395 77 35.387500338770955
		 78 35.389306645308459 79 35.390154269890054 80 35.390343278663707;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY";
	rename -uid "3C66AF5B-4D9F-EE03-371D-1CAD98A5E2AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.3136563322747685 1 -3.3154816975482717
		 2 -3.3219442019003931 3 -3.3353093367084754 4 -3.3578363397964228 5 -3.3905554646315439
		 6 -3.4325479326204085 7 -3.4803740330165844 8 -3.5282824578846403 9 -3.5692786946625432
		 10 -3.5956996914806831 11 -3.6013410302832036 12 -3.5858866249070696 13 -3.5570985054677386
		 14 -3.515828209120297 15 -3.4721642379636051 16 -3.4479000971757787 17 -3.4582735059764711
		 18 -3.5134842421694419 19 -3.6168333149331895 20 -3.7414680617786984 21 -3.8938374970315475
		 22 -4.0660652845792207 23 -4.2418171871040427 24 -4.4086368367572213 25 -4.5589181996860235
		 26 -4.6829924192238872 27 -4.7856355061277762 28 -4.8771800673085046 29 -4.9573823047830015
		 30 -5.0260439979673022 31 -5.0835357799595444 32 -5.1307137986518523 33 -5.1687473561820223
		 34 -5.1991765442620093 35 -5.2231902664026357 36 -5.2420526149308708 37 -5.2573035595862549
		 38 -5.2733951919487563 39 -5.2914225187980612 40 -5.3074687052972331 41 -5.3177081719755677
		 42 -5.3182518770328233 43 -5.3056152477385403 44 -5.2758112130636965 45 -5.2252648806458346
		 46 -5.1380911902026716 47 -5.0042084205659565 48 -4.8282174391431765 49 -4.5709336530994022
		 50 -4.2648149032469949 51 -3.9112786464007483 52 -3.5038773256331988 53 -3.0954462226057142
		 54 -2.7450459672254088 55 -2.5088264340347357 56 -2.4246386422012289 57 -2.4972554196343029
		 58 -2.6917523453009213 59 -2.9436035880735543 60 -3.1799902445351091 61 -3.3676191165776457
		 62 -3.5088652038857076 63 -3.5990910672112828 64 -3.6400877231059443 65 -3.6466840194187284
		 66 -3.6357123166826981 67 -3.6115099298212598 68 -3.5782736162562854 69 -3.5399602595013682
		 70 -3.499875299993771 71 -3.4608210680674882 72 -3.4250316123921127 73 -3.3939775203080673
		 74 -3.3684496905954302 75 -3.3486263629488513 76 -3.334110843688701 77 -3.3243220846947863
		 78 -3.3181450252728308 79 -3.3148042812495606 80 -3.3136563322747685;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ";
	rename -uid "8E1D8598-42A1-A786-25E8-A881C1D47FF2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -37.563317406266265 1 -37.621191765804411
		 2 -37.771430249893733 3 -37.973692510809386 4 -38.188272057960738 5 -38.380579675568192
		 6 -38.529680640498285 7 -38.627869302737473 8 -38.681039160122658 9 -38.704045401492486
		 10 -38.715209702762962 11 -38.725570547582628 12 -38.729668353689675 13 -38.703848111425685
		 14 -38.731138715091795 15 -38.788433568205001 16 -38.71792037663112 17 -38.444470080481899
		 18 -37.919630823825564 19 -37.134872821134557 20 -36.204602139116844 21 -35.143631405224575
		 22 -34.037773357658061 23 -33.020693008605896 24 -32.179975469435313 25 -31.541776756228291
		 26 -31.159546453993954 27 -30.936523434154857 28 -30.727721984114289 29 -30.506587691037964
		 30 -30.24391660845577 31 -29.907740622520659 32 -29.563588765769659 33 -29.291162301344311
		 34 -29.076854015468086 35 -28.906493315882241 36 -28.765711100549748 37 -28.638910457268757
		 38 -28.471446256950014 39 -28.253799968756702 40 -28.033713060525589 41 -27.860408499410063
		 42 -27.783472003456101 43 -27.851544717039928 44 -28.112826405576737 45 -28.61242225261346
		 46 -29.53600517872859 47 -30.972984212631879 48 -32.820158450447707 49 -35.141042775442095
		 50 -37.546996128130971 51 -40.021086947972194 52 -42.685129468599072 53 -45.206892267208119
		 54 -47.272757234125692 55 -48.624334602307336 56 -49.105035207021764 57 -48.702110168404921
		 58 -47.560567910520476 59 -45.948524641145269 60 -44.181073650667251 61 -42.499551976517076
		 62 -41.023501022573782 63 -39.875198393675738 64 -39.156605683607239 65 -38.739067607421291
		 66 -38.436935030057292 67 -38.227885643261658 68 -38.089740309281801 69 -38.001663494515469
		 70 -37.945400638879327 71 -37.905805454186542 72 -37.871281091287507 73 -37.833673579056416
		 74 -37.791308803352159 75 -37.742761913569751 76 -37.69120166673153 77 -37.641491598328294
		 78 -37.600148629300932 79 -37.572686598428746 80 -37.563317406266265;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAX";
	rename -uid "11432534-4641-4EF3-DC79-2CBB76ECC833";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.34814221170011234 1 0.31094253506571157
		 2 0.21323326070725798 3 0.076245901876170738 4 -0.07904012286594056 5 -0.23241999623524356
		 6 -0.36462198549154801 7 -0.457206313895553 8 -0.49210571445878387 9 -0.44901603151198172
		 10 -0.32789973304375702 11 -0.14012690246478854 12 0.10287049026989716 13 0.38819756749769263
		 14 0.70122428429444728 15 1.0253884079016562 16 1.3426917283695914 17 1.6338444443265647
		 18 1.8785189049714761 19 2.073065581872398 20 2.2203710064197355 21 2.3090973020804388
		 22 2.3633488568734582 23 2.4146994311456931 24 2.4629564035420102 25 2.5078886898882513
		 26 2.549282950739614 27 2.5869286981831086 28 2.6206276409491482 29 2.6501184141631478
		 30 2.675251789233791 31 2.6958012955461732 32 2.7115413184518053 33 2.7222917313819939
		 34 2.7278768341310164 35 2.7280776547038497 36 2.7227091533011021 37 2.711591054761842
		 38 2.6945374559956585 39 2.6713809175700947 40 2.6419242937061895 41 2.6059758834742777
		 42 2.5633855097359861 43 2.5029919663225195 44 2.4157721492972004 45 2.3048869027373167
		 46 2.1575269486205242 47 1.9656690271304491 48 1.7390807000956603 49 1.4871586910791323
		 50 1.2191442419759426 51 0.94408810357629636 52 0.67068149864201421 53 0.40716265524814171
		 54 0.16082197146618563 55 -0.06216349922545876 56 -0.2568229621198721 57 -0.41933801346033417
		 58 -0.54676435875926221 59 -0.64396823521964686 60 -0.71724138525445269 61 -0.76539434356984604
		 62 -0.78696113656281053 63 -0.77987570642688031 64 -0.74105563183809975 65 -0.67238562859202
		 66 -0.57955609388659313 67 -0.46863250015820884 68 -0.34607732407957742 69 -0.21868706647072206
		 70 -0.093548863484911607 71 0.021917892077353292 72 0.12503911903451256 73 0.21459167803817875
		 74 0.28521698815924068 75 0.33151953082817859 76 0.34816051938220971 77 0.34814244133228339
		 78 0.34815754810075494 79 0.34814252396549 80 0.34814221170011234;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAY";
	rename -uid "F844069A-4F6C-4C4A-02F0-30AD22C63119";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.2935213919950703 1 -3.3059848030971737
		 2 -3.3372844364243606 3 -3.3770844494667296 4 -3.4163872976149956 5 -3.4491082927645076
		 6 -3.472339923940083 7 -3.4858662577655268 8 -3.4903399882822868 9 -3.4878256619068613
		 10 -3.4770344982993673 11 -3.4506199106357696 12 -3.4000663867769054 13 -3.318614201147227
		 14 -3.2034112028220725 15 -3.0566027426557727 16 -2.8865150467903895 17 -2.7073527541296598
		 18 -2.538701240424226 19 -2.3923681213067236 20 -2.2757724435320812 21 -2.2037743413092663
		 22 -2.1597844252244411 23 -2.1172984179034766 24 -2.0766718376925657 25 -2.0382115812122708
		 26 -2.0021998824893528 27 -1.9690307468889954 28 -1.9389172823854315 29 -1.9123026044337839
		 30 -1.8893878001386155 31 -1.8705486481184559 32 -1.8560405279408043 33 -1.8460648324952669
		 34 -1.8409276380740607 35 -1.8408225774649081 36 -1.8459301691099266 37 -1.8565071547148453
		 38 -1.8725341558333444 39 -1.8942171157601704 40 -1.921641037944533 41 -1.9546899864062974
		 42 -1.9934666380366017 43 -2.0476849816599882 44 -2.1242839686346269 45 -2.21854942045255
		 46 -2.3371166969143644 47 -2.4812567144724138 48 -2.6379465554012262 49 -2.7951045359019804
		 50 -2.9421689995474241 51 -3.0718335767049072 52 -3.17918857600255 53 -3.262569358651056
		 54 -3.3231961115785351 55 -3.3648509797646295 56 -3.3930173275008397 57 -3.414449184019098
		 58 -3.4359008300048419 59 -3.458065457892856 60 -3.4782566567685622 61 -3.49648743174289
		 62 -3.5125549669798324 63 -3.5255233881671972 64 -3.5341964506348922 65 -3.5373225343896353
		 66 -3.5339126136689751 67 -3.5233421706228838 68 -3.5052881213425118 69 -3.4802229999258718
		 70 -3.4494141581037145 71 -3.414943114074283 72 -3.3797176049846205 73 -3.3467466025366135
		 74 -3.3192156983079411 75 -3.3004235477712749 76 -3.2935106310384361 77 -3.2935345848302995
		 78 -3.2935499202369081 79 -3.2935262982695903 80 -3.2935213919950703;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ";
	rename -uid "3CC7A290-4EC9-60FC-1D99-F0AF14ED179B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.3875784545952472 1 -4.1754564439894022
		 2 -3.6158661506964735 3 -2.8242511354764441 4 -1.9162924767943932 5 -1.0078082554409451
		 6 -0.21483179219261922 7 0.34626459686940164 8 0.55907495157586518 9 0.25021754015446696
		 10 -0.60233449410749995 11 -1.8871079153436046 12 -3.4925654857305051 13 -5.3068135919475177
		 14 -7.2183229554130479 15 -9.115451621725045 16 -10.887537843843367 17 -12.424436885187681
		 18 -13.617076797446536 19 -14.512385397426156 20 -15.200733187207652 21 -15.638738434774783
		 22 -15.92749944668946 23 -16.196931535312547 24 -16.446513373225947 25 -16.675815395458564
		 26 -16.884425340865135 27 -17.071939506088835 28 -17.237887031470784 29 -17.381787261648498
		 30 -17.503300657847614 31 -17.601978197412198 32 -17.677331106811902 33 -17.728877425331216
		 34 -17.756352876990523 35 -17.759156709906065 36 -17.736923919526301 37 -17.689040405102247
		 38 -17.615170290026075 39 -17.514844634260783 40 -17.387516699972249 41 -17.232708032154328
		 42 -17.04994159904496 43 -16.794757334616563 44 -16.431146529247137 45 -15.971602053212512
		 46 -15.284998336656756 47 -14.270745960667726 48 -12.986904409701907 49 -11.491684387620424
		 50 -9.8439257244795382 51 -8.1026780057812626 52 -6.3273949661019531 53 -4.5779100679809579
		 54 -2.9139409832843031 55 -1.3954141056413945 56 -0.082329406089604817 57 0.9653662397505548
		 58 1.6879809063196896 59 2.1368302229014011 60 2.4057554513941457 61 2.4986695947917452
		 62 2.4197375118149629 63 2.1727633838936744 64 1.7567580565884067 65 1.1960202925849801
		 66 0.53173918731200331 67 -0.19464194433700549 68 -0.94154340068999798 69 -1.6676160038055492
		 70 -2.3317054835588382 71 -2.8924471108821241 72 -3.3650288459333577 73 -3.7754149374987263
		 74 -4.0991228288534405 75 -4.3113671870853807 76 -4.3876391674978787 77 -4.3876141677747285
		 78 -4.3876541915710181 79 -4.3875994569736347 80 -4.3875784545952472;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX";
	rename -uid "BAE24E2B-48D4-BDBC-89D2-01A06FB861FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.8146011058006946 1 4.0673595903679818
		 2 4.4148445384996631 3 5.2718985877552003 4 7.598238584344255 5 10.478891786756906
		 6 11.408366380770406 7 8.1532713594021331 8 -0.0061152043480876333 9 -12.644059845722369
		 10 -25.516322845701087 11 -34.221989077108134 12 -37.284681527593236 13 -35.056675316219376
		 14 -26.512619002928876 15 -13.989054440956819 16 -0.52880882401462659 17 10.613922551102489
		 18 16.152479966351049 19 17.042978342116879 20 15.332130154693077 21 12.932175738421046
		 22 10.868534181529322 23 9.411244092470934 24 8.7782662002577769 25 8.8565128170999721
		 26 9.56080015940233 27 10.656253041859078 28 11.849236710503172 29 12.893322174857245
		 30 13.527288281363953 31 13.499016387558303 32 12.99386229942295 33 12.381012873551427
		 34 11.701059488579338 35 10.994603405310277 36 10.300149271541409 37 9.6526614066505889
		 38 9.0828645749432315 39 8.6173038221092462 40 8.2787520240772299 41 8.087373688659099
		 42 8.06263075738892 43 8.3727085513281878 44 9.1665478427727578 45 10.651487169381154
		 46 13.730378606546772 47 18.663554715554525 48 24.224959019350873 49 28.288957924831013
		 50 27.921647045001027 51 19.826983122378774 52 4.1005027881886233 53 -10.820979143992092
		 54 -19.323459949403482 55 -22.070974617659161 56 -21.619664087002857 57 -19.744597812544711
		 58 -17.08763826249675 59 -14.123085878852493 60 -11.188265907023617 61 -8.5323725533854748
		 62 -6.3442749061853636 63 -4.7354690323120385 64 -3.7578952649616508 65 -3.1156994587514171
		 66 -2.4134954364468943 67 -1.5484351970937891 68 -0.4703574032043929 69 0.8001080523273485
		 70 2.1665496982081565 71 3.4538355340333071 72 4.4643208020460481 73 5.2459826305377213
		 74 5.7649063202239672 75 5.8917035489942693 76 5.5659342041531685 77 4.9868570768208098
		 78 4.4185108879066668 79 3.9841977113254545 80 3.8146011058006946;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY";
	rename -uid "5F7F69C3-4AF5-140F-E8A9-E8A0A5BE990A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 40.357878794094511 1 38.349208420412943
		 2 32.670999142897564 3 23.718497531209021 4 13.447131022276004 5 5.7872918801786222
		 6 2.5946430861105623 7 2.8727678300481041 8 5.5648131236779799 9 12.744021443152414
		 10 21.12048049439591 11 30.151859187133073 12 38.62239659020846 13 42.646870397148518
		 14 42.655169589812772 15 37.047351670237965 16 26.585863961568428 17 15.433857169539175
		 18 7.3824009480818074 19 2.2168683352427201 20 -1.0470007718655747 21 -3.2212544789154727
		 22 -4.6461406421700833 23 -5.2753009791201197 24 -5.1836325188180519 25 -4.5810023526591968
		 26 -3.6378328402581444 27 -2.4687202533482515 28 -1.1849549939617432 29 0.04612958866047253
		 30 1.0432032109007896 31 1.5657387974870658 32 1.7365865723428193 33 1.8612292696166739
		 34 1.9420780416039842 35 1.983008608499037 36 1.9899268175764824 37 1.9706977359658595
		 38 1.9346723618639379 39 1.8923937539184867 40 1.8546876400729664 41 1.8317569284877997
		 42 1.8321155767411081 43 1.7969011546968452 44 1.6798497636240546 45 1.6003740216278555
		 46 1.2831307991596295 47 0.49016531503418442 48 -0.31351911597081722 49 -0.2004890947888037
		 50 2.1621624766327687 51 8.8267536556348567 52 21.002405471951519 53 32.996493999370713
		 54 40.425827539270223 55 44.522998551124346 56 46.943992768562708 57 48.576399807436523
		 58 49.635262683644875 59 50.254244558000792 60 50.517936973650734 61 50.490658074296547
		 62 50.228552146089761 63 49.758981924342478 64 49.083007815175613 65 48.217470343323399
		 66 47.204441865408562 67 46.081495383987757 68 44.904640004032878 69 43.742873750751549
		 70 42.664622374370509 71 41.67987106749495 72 40.823868135326798 73 40.142397414995848
		 74 39.672384684338148 75 39.447946571354208 76 39.498724610635023 77 39.735550855158216
		 78 40.017727894244452 79 40.258042427032905 80 40.357878794094511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ";
	rename -uid "748658D0-48B1-6870-6F22-D9BFA9CB4157";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.381865146375155 1 -10.007595256480558
		 2 -15.151894440044588 3 -23.371490971540474 4 -32.801634241122514 5 -41.588488566317871
		 6 -48.75186150346638 7 -53.074875188442455 8 -52.561168465208951 9 -49.516435261016291
		 10 -48.187055858675933 11 -43.691910281406045 12 -36.938273403591047 13 -29.645515920446599
		 14 -20.730246766912519 15 -14.307945899582286 16 -12.934643719965587 17 -14.813055250165139
		 18 -17.145207658486285 19 -18.803572827758238 20 -19.979958546895162 21 -20.927370860698705
		 22 -21.436583387281203 23 -20.966481350791732 24 -19.695758491360124 25 -18.263536325429079
		 26 -16.837315354523394 27 -15.552238655572621 28 -14.501692094290021 29 -13.756224056697523
		 30 -13.363172784114226 31 -13.313269078850185 32 -13.593478821340668 33 -14.18836457927892
		 34 -15.061562116522058 35 -16.176347374340704 36 -17.49438191047674 37 -18.975139791072717
		 38 -20.575335740672955 39 -22.248205732490373 40 -23.943276054144185 41 -25.606018912251212
		 42 -27.177590850087892 43 -28.61521176116263 44 -29.872503795795605 45 -30.365621592358846
		 46 -29.925268516122635 47 -29.125890124866043 48 -28.250448309021746 49 -26.983885972571755
		 50 -24.280953944494975 51 -19.086515724092273 52 -13.096827006518327 53 -10.336557572503864
		 54 -9.525062444644723 55 -8.2187450879909019 56 -6.2130757192838217 57 -3.840103952938354
		 58 -1.3581982406426689 59 0.97505349903527083 60 2.9247969070509336 61 4.2824122959743924
		 62 4.8677995556820308 63 4.5274797668919708 64 3.1273224304607385 65 0.94541657519279665
		 66 -1.5809091037162752 67 -4.3216109002428116 68 -7.1236103222725005 69 -9.8046662309197963
		 70 -12.151024445465476 71 -13.956307468035142 72 -15.112123646041814 73 -15.442154448125043
		 74 -14.963965147827063 75 -13.913632675849879 76 -12.521049420501942 77 -11.035586740288618
		 78 -9.7061211502164451 79 -8.7494069774448722 80 -8.381865146375155;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX";
	rename -uid "2C6F3E09-4481-5677-E06D-B3976D0DEE71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.5289283719285409 1 -4.9218533526031347
		 2 -5.6826043816351879 3 -6.1554613237212052 4 -5.9776985016770157 5 -5.2604629618630128
		 6 -4.2665241052430574 7 -3.3525935672094631 8 -3.1397935929390517 9 -3.2570214849685399
		 10 -3.0682330251491554 11 -3.8268705857751946 12 -4.9786518105311055 13 -5.6932358105095799
		 14 -6.2867335861286877 15 -6.6401818874185965 16 -6.776385715445846 17 -6.7645039999154024
		 18 -6.588321594136481 19 -6.2485234141673027 20 -5.7892096012049139 21 -5.3068491917016845
		 22 -4.9413390525084973 23 -4.8506253157602393 24 -5.0035026593139111 25 -5.2390892573981764
		 26 -5.5058864044984297 27 -5.7576868186860981 28 -5.9618108162848875 29 -6.1019062479402582
		 30 -6.175296211549286 31 -6.1894835999866773 32 -6.1477730399046973 33 -6.0535436790436599
		 34 -5.9134609294665346 35 -5.7339391253024399 36 -5.5216357761195116 37 -5.2838470857468831
		 38 -5.0287844730987299 39 -4.7656348722190502 40 -4.5045768132678941 41 -4.2566591638066962
		 42 -4.0337643673505843 43 -3.8478962506775769 44 -3.7110842647236617 45 -3.7357125306763743
		 46 -3.9816893904083979 47 -4.3730282461081753 48 -4.8323678555813876 49 -5.2914457280570257
		 50 -5.6978990114183015 51 -6.0192167384959907 52 -6.2427558619969705 53 -6.3724024578562943
		 54 -6.4801799996306908 55 -6.6149003513209204 56 -6.7557254572222529 57 -6.8835929360484771
		 58 -6.981809523744877 59 -7.0355895825374342 60 -7.0320159721428155 61 -6.9592962305180599
		 62 -6.8056805804528162 63 -6.5586945180176439 64 -6.2031017482816138 65 -5.7582300682416196
		 66 -5.2746457764431307 67 -4.7832808680962788 68 -4.3177575740012655 69 -3.9140307568293444
		 70 -3.6095786047728367 71 -3.4186293141945212 72 -3.3282840781339131 73 -3.3507184071630909
		 74 -3.4772385979502904 75 -3.6724978333939249 76 -3.9016207129068068 77 -4.1322197954839339
		 78 -4.333114382558036 79 -4.4750372569430192 80 -4.5289283719285409;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY";
	rename -uid "8466B841-4CBD-7798-9112-218DF6A6E055";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -7.3941419589522983 1 -7.5804470090621336
		 2 -7.8732627009892058 3 -8.013683135187506 4 -7.9644740104669713 5 -7.7214015252059172
		 6 -7.2551679554713244 7 -6.6684440382152816 8 -6.5057442619678971 9 -6.5967042410240451
		 10 -6.4485305025767063 11 -6.9940671034042374 12 -7.6053250750327619 13 -7.8767718019513477
		 14 -8.0473393070739139 15 -8.1267158556016241 16 -8.1530466676554578 17 -8.1508469710479918
		 18 -8.1161004694914034 19 -8.0377641767486061 20 -7.9075958035036562 21 -7.7393494147640114
		 22 -7.5890410430936068 23 -7.5485215547931883 24 -7.6160674735577309 25 -7.7130391824953524
		 26 -7.8128151283467302 27 -7.8976093975328254 28 -7.9598622730282367 29 -7.9993018385084662
		 30 -8.018897571014632 31 -8.0226186401077122 32 -8.0116473820167862 33 -7.9859672755294149
		 34 -7.9456307049279262 35 -7.8899912013669438 36 -7.8183826195039936 37 -7.7304881537938455
		 38 -7.6268529363349211 39 -7.5093917565624944 40 -7.3817285961688066 41 -7.2497048097226706
		 42 -7.1215220883595638 43 -7.0074205454435265 44 -6.9189880661069427 45 -6.9352092022246916
		 46 -7.0902273752811675 47 -7.3130179849425128 48 -7.5402306546659315 49 -7.7334302684622998
		 50 -7.8782944369311219 51 -7.9763454373027969 52 -8.036305376581355 53 -8.068046451178768
		 54 -8.0927780191671896 55 -8.1215753154753596 56 -8.1492196590809609 57 -8.1721384533036936
		 58 -8.1883366610021255 59 -8.1967359024968172 60 -8.1961454857893195 61 -8.1847204477697897
		 62 -8.1583789895752457 63 -8.1098436042249258 64 -8.0261749418602566 65 -7.8977902039041599
		 66 -7.7269169358593599 67 -7.5176012196186619 68 -7.2832530637934685 69 -7.0487987112099066
		 70 -6.8509083906890185 71 -6.7167523945596006 72 -6.6503796950737906 73 -6.6670581415328263
		 74 -6.7587723192841214 75 -6.8933786993627866 76 -7.0410833158284252 77 -7.1792596208702557
		 78 -7.2915854113097494 79 -7.3665536406957361 80 -7.3941419589522983;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ";
	rename -uid "09E0C5EC-47AA-D378-56C4-59B82047CE33";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 62.930980634383602 1 65.945768583299696
		 2 71.599298566443508 3 75.019863432252762 4 73.740933666640387 5 68.488490499702408
		 6 60.872906384107608 7 53.343530101622939 8 51.488704262045019 9 52.51585350498744
		 10 50.85436104967161 11 57.329211864045305 12 66.375577480381182 13 71.67693214659181
		 14 75.959762378549627 15 78.471793300813161 16 79.433572493893109 17 79.349825069903687
		 18 78.104572291549715 19 75.686490768065809 20 72.375884969489917 21 68.83309895244129
		 22 66.093297505188616 23 65.404558153295653 24 66.56333317188566 25 68.329445904213841
		 26 70.304432993873348 27 72.146692141060726 28 73.626357537633183 29 74.635458830359255
		 30 75.162108880139897 31 75.263687486162738 32 74.964647966262973 33 74.287639229818069
		 34 73.276905589678606 35 71.973652614546751 36 70.420112608775824 37 68.662492368589398
		 38 66.753743876781357 39 64.755833176603502 40 62.741417722144284 41 60.794972424805472
		 42 59.013007932778088 43 57.501860723135025 44 56.373355850537202 45 56.577485393689471
		 46 58.591949593040724 47 61.712899496433891 48 65.265737846303693 49 68.719054335259116
		 50 71.711029912548071 51 74.040450134333398 52 75.645297397631211 53 76.570845461208933
		 54 77.33739037550464 55 78.29291539363804 56 79.287880655268893 57 80.188779938833989
		 58 80.87878494895925 59 81.256226185007947 60 81.231288101065687 61 80.720759928290406
		 62 79.640344339417965 63 77.8945247614067 64 75.361366261443592 65 72.1505689460121
		 66 68.594025729641274 67 64.890940950018958 68 61.277970144294507 69 58.042195548050159
		 70 55.526558208470092 71 53.910180709435281 72 53.133850310652278 73 53.327352919250906
		 74 54.409637537951717 75 56.052486288194011 76 57.941173791627484 77 59.803737148401005
		 78 61.399038376303785 79 62.511395760249101 80 62.930980634383602;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX";
	rename -uid "079C5483-4E5E-B242-D560-2AAD731E81F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -9.7418046831765626 1 -12.982279547762353
		 2 -21.845752820950917 3 -34.82740639642882 4 -48.548763236624133 5 -58.150732542413856
		 6 -61.0523830909829 7 -56.442550173200218 8 -43.91649743901079 9 -23.2103825253214
		 10 -3.661249591324732 11 10.179180941816997 12 18.387068488190536 13 20.72394815416645
		 14 19.034514352376487 15 13.256883431228994 16 1.8225023110727474 17 -15.227505567509038
		 18 -30.212212957015918 19 -37.999414294444087 20 -40.359329416432409 21 -40.455292858963837
		 22 -39.784733135690168 23 -38.613483170238602 24 -37.314732705954263 25 -36.084122306561987
		 26 -34.996283336246883 27 -33.985316317312787 28 -32.96870094816898 29 -31.990608243355872
		 30 -31.126580922168802 31 -30.482863174951781 32 -30.045600686768879 33 -29.723232042226623
		 34 -29.514817957289878 35 -29.416588940105221 36 -29.422969581299245 37 -29.52740271117689
		 38 -29.723492645670571 39 -30.005308204171644 40 -30.368322448270938 41 -30.809762166216093
		 42 -31.328984114428152 43 -32.842789101079489 44 -35.936885265007895 45 -40.055801448209216
		 46 -45.769789289499798 47 -53.242211134218365 48 -60.672717676834999 49 -65.249190149537839
		 50 -63.380314485185039 51 -50.516530848172771 52 -26.132339131725477 53 -3.9990886462577993
		 54 8.3866350706253581 55 14.155367528978596 56 16.812673390161631 57 18.228292480030881
		 58 18.957509930103253 59 19.281269499932399 60 19.274606605433405 61 18.876876493236143
		 62 17.979852076134698 63 16.553433297153454 64 14.563705755838905 65 12.014295173423617
		 66 8.9548061044513592 67 5.4279833664596104 68 1.5414964915827831 69 -2.4935904994609808
		 70 -6.3506966119411441 71 -9.6673516848543617 72 -12.210004901370503 73 -13.912580412786246
		 74 -14.704321768005391 75 -14.608569983288008 76 -13.7130598301215 77 -12.39462651062898
		 78 -11.105388617520546 79 -10.126247381387072 80 -9.7418046831765626;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY";
	rename -uid "F67B2249-4FD6-54CB-5074-8CB368BD50B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.577661590064899 1 19.229934796444898
		 2 20.495566459207179 3 21.181018644158595 4 21.097175598604931 5 22.044036764787833
		 6 24.590628110251512 7 27.850249562100146 8 30.941595662403781 9 31.234220425959695
		 10 26.118208437827203 11 19.697586769723362 12 14.750545955672429 13 12.953137445122156
		 14 15.968601254719086 15 25.047265067174447 16 38.210606771316385 17 48.629355383378986
		 18 51.42097752634804 19 49.351952540167467 20 45.504903892940433 21 41.622123183483822
		 22 38.620495333954409 23 37.011789603587467 24 36.854003935911955 25 37.662107494956075
		 26 39.185818655148658 27 41.10471445213706 28 43.070809773087262 29 44.76457759869264
		 30 45.866549263034756 31 46.056491360480535 32 45.573866578675386 33 44.902111450402131
		 34 44.089362797472496 35 43.182462468501896 36 42.225780152912506 37 41.260709604746829
		 38 40.325572000765995 39 39.456142475374776 40 38.686332244419361 41 38.04932578050748
		 42 37.578933383243921 43 37.00306370542139 44 35.984617748504249 45 34.780031252381747
		 46 33.7227369315884 47 32.453956559145269 48 30.626931012025707 49 28.641281965068075
		 50 27.503870729037089 51 27.68136999183249 52 26.834567701500745 53 23.160377212731703
		 54 19.243219612856556 55 15.871059342174142 56 12.765178943563086 57 9.7170362825812724
		 58 6.9663257048657483 59 4.7800983833453401 60 3.4658887303442243 61 3.3396575285862342
		 62 4.2261842625674193 63 5.678901618797215 64 7.5626292028602036 65 9.7282505978662783
		 66 12.019494568996617 67 14.261024975419284 68 16.273785212112294 69 17.907395803732225
		 70 19.086192641351005 71 19.792485395559748 72 20.123289933694508 73 20.229516578852195
		 74 20.177311452768073 75 19.977240747946436 76 19.631901179448164 77 19.237758088060112
		 78 18.903331627310418 79 18.666688018411669 80 18.577661590064899;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ";
	rename -uid "9946EBE4-4A88-4D6E-D830-CEBA0E4DB496";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -12.363619147181401 1 -15.91379845059503
		 2 -23.986755113438914 3 -32.551819496908173 4 -38.087435203562073 5 -39.461613191236758
		 6 -37.276131174900343 7 -31.282063723269314 8 -22.669915285228644 9 -9.1083460737665369
		 10 5.7182661679124944 11 11.908086828472387 12 13.368816202899394 13 14.180722860565476
		 14 14.722011057404194 15 13.704366280606779 16 8.3236565823275726 17 -2.6024074179452326
		 18 -12.908474604172479 19 -17.326097543009976 20 -17.256902430268479 21 -15.588608242641561
		 22 -13.962997103067506 23 -13.186692425192758 24 -13.352495539547858 25 -13.909810136290821
		 26 -14.639303994013847 27 -15.301588998341323 28 -15.714461158519017 29 -15.838810949571645
		 30 -15.717094057711018 31 -15.449559432764364 32 -15.094926663662147 33 -14.652167080250615
		 34 -14.130884753604562 35 -13.53527282120703 36 -12.867450480331735 37 -12.130855095308689
		 38 -11.332995669047461 39 -10.487313458505696 40 -9.6152286470841304 41 -8.7470697499984258
		 42 -7.9222835403604135 43 -8.4056663630318145 44 -11.075576567623004 45 -15.67093515198995
		 46 -22.283865996834557 47 -30.241992791837124 48 -37.955831853164305 49 -43.770644369439452
		 50 -46.300293051697174 51 -43.883303384989489 52 -35.941454225372468 53 -27.877185185431095
		 54 -21.533776376745234 55 -15.118648233066418 56 -8.0956676334730791 57 -0.67671528228059497
		 58 6.6024563608096969 59 13.142648251627429 60 18.321199020739598 61 21.496652404212199
		 62 22.769932045798534 63 22.842802593677643 64 21.942717819051506 65 20.319364516672341
		 66 18.123199499035579 67 15.455332379740442 68 12.437352461013543 69 9.2214261546652398
		 70 5.9885953867942536 71 3.1026561738850411 72 0.55072347361558793 73 -2.0353538200790018
		 74 -4.5483251009265695 75 -6.8319204121371255 76 -8.7549410435751156 77 -10.284440265023843
		 78 -11.417693408109917 79 -12.120588689709496 80 -12.363619147181401;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX";
	rename -uid "97567632-44CD-1453-6EE2-B8A3B08E969A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 19.074613769875452 1 19.489129513707663
		 2 20.536013248063547 3 21.256170177080058 4 20.978204029320239 5 19.545728097964542
		 6 17.33608745018358 7 15.177584189797484 8 14.146485147308702 9 15.398683486173882
		 10 18.741032417521435 11 23.140435955370702 12 27.591506127695443 13 30.757289662593884
		 14 31.474458032659395 15 29.221858588508645 16 24.257356238438774 17 17.730859059198753
		 18 11.386616127034253 19 6.7224458673827572 20 4.6702157657826016 21 5.3494195489292329
		 22 7.7861806135619496 23 11.245457742163927 24 15.377427997731314 25 19.713004293380489
		 26 23.797655061220624 27 27.456615066853956 28 30.680507245942199 29 33.354578853844302
		 30 35.61861878824871 31 37.676809733950158 32 39.558365449183881 33 41.290136436635272
		 34 42.878554131964457 35 44.320799609804169 36 45.602529747541297 37 46.695407494291317
		 38 47.561575162999269 39 48.140309526371233 40 48.331397561168224 41 47.996144852621924
		 42 46.953193880456936 43 44.188186093823177 44 38.743327867534063 45 30.882069712204004
		 46 19.409304035044865 47 6.7220121941033355 48 -2.1479682955348345 49 -6.0011792836383755
		 50 -5.4657789790797455 51 -1.3866552073160694 52 2.3366721324022173 53 3.175272349775851
		 54 3.3316018711240742 55 1.7674983304161567 56 -1.7550005525916486 57 -6.8535684065158931
		 58 -12.499770643046549 59 -17.671882622750342 60 -21.728163363129891 61 -24.181117736855764
		 62 -24.791934284818083 63 -23.779306983630654 64 -21.510665127219941 65 -13.324216264333238
		 66 -6.5378409978996554 67 -0.072469561420292303 68 5.7467764560554624 69 10.567013294894295
		 70 14.204448376513046 71 16.66568443879941 72 18.170612003200109 73 18.952243619847884
		 74 19.202642783289878 75 19.169502706979667 76 19.126208653504698 77 19.138655360674875
		 78 19.117013681077374 79 19.088082366436318 80 19.074613769875452;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY";
	rename -uid "907279DF-45E6-EAB8-E75E-10A5F3A85FB6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 13.140750261756999 1 14.384859781699584
		 2 17.891966545554158 3 23.012111494481939 4 28.968540068415827 5 34.941385865134478
		 6 40.243122477626308 7 44.43714291292104 8 47.292861957509864 9 48.486616126538628
		 10 47.791786609460729 11 44.930952435420082 12 39.48707689974772 13 31.375176806942992
		 14 21.253171068262628 15 10.377741271220144 16 0.10558051471796148 17 -8.6141957373574325
		 18 -15.557387238298684 19 -21.273368922595267 20 -26.167926085603955 21 -29.936548128157234
		 22 -32.747096578981058 23 -34.974988284382363 24 -36.530678797463203 25 -37.455017304288802
		 26 -37.899068483680651 27 -38.096394593856495 28 -38.285199164168993 29 -38.701103384388873
		 30 -39.424510623147569 31 -40.399204585113466 32 -41.619775976143544 33 -43.066662059946005
		 34 -44.727116532616947 35 -46.581934163095461 36 -48.605841738706026 37 -50.76836079916432
		 38 -53.034634409365758 39 -55.364963094277023 40 -57.717137221176486 41 -60.046291358326798
		 42 -62.302117910542712 43 -64.323388926726082 44 -65.842305656696752 45 -66.584400802727941
		 46 -65.741696143160667 47 -62.174131318951261 48 -56.021810627598718 49 -47.798500415887887
		 50 -37.882268562018965 51 -26.197527410084881 52 -12.790908642417753 53 -0.46251489678506919
		 54 11.075491382431357 55 21.128060211745964 56 29.222706217443438 57 35.018656044122885
		 58 38.517725300302502 59 40.30847244229313 60 41.066685654577221 61 41.386181071072592
		 62 41.715684723370273 63 42.1268256505548 64 42.466823552701982 65 43.321130033240259
		 66 42.769601027836799 67 41.215058094528715 68 38.742680313752849 69 35.544778676231324
		 70 31.920724834759895 71 28.223596340935707 72 24.659671822243123 73 21.352486310760519
		 74 18.523992519827416 75 16.365151526792378 76 15.035672487395557 77 14.25175947705957
		 78 13.654582508722287 79 13.274246235049274 80 13.140750261756999;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ";
	rename -uid "AC9E95F3-47A0-B0F5-4DEE-7B88A6A5D2C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 54.15307408480556 1 53.22019189761307
		 2 50.500150342949652 3 46.499143124221128 4 41.668574116108658 5 36.477511837478275
		 6 31.547261616802697 7 27.725076766486247 8 26.00411736881102 9 27.432562742928837
		 10 31.616416637842665 11 37.524608880299759 12 44.420346724303592 13 51.325441665500406
		 14 57.39183219868103 15 62.246180956466915 16 65.756053716851014 17 67.632870279681157
		 18 67.520284380371479 19 65.388321134623141 20 61.381140567828844 21 56.014929044353579
		 22 49.828632268547622 23 43.007649657266242 24 35.957009134183053 25 29.138659321761008
		 26 23.015022096294718 27 17.792379837832247 28 13.522412171633205 29 10.343051541254423
		 30 7.8471164415429993 31 5.5634956243450588 32 3.4691205458786838 33 1.5353328533556632
		 34 -0.23563222340593484 35 -1.8369135147796192 36 -3.2549872597263088 37 -4.4671722592025693
		 38 -5.4628110023014198 39 -6.1931101983156456 40 -6.5498080680459614 41 -6.3928916128984961
		 42 -5.5445241437002073 43 -3.035392773413859 44 2.044870194582074 45 9.461269209951876
		 46 20.338503810713878 47 32.361349570934955 48 40.695676040872634 49 44.653235754530137
		 50 44.957631469871906 51 40.323845385903276 52 33.052071829272776 53 31.79469830797478
		 54 28.179464816653155 55 22.520302243195378 56 15.18693487087535 57 6.7225937635994635
		 58 -1.9457128694245662 59 -9.8389266767013357 60 -16.261021189140919 61 -20.62105331324052
		 62 -22.493064206519954 63 -22.222314692413448 64 -20.346479185061622 65 -9.7933184081005091
		 66 -1.3009537415517589 67 7.0961550165856089 68 15.199450264568602 69 22.671103382089594
		 70 29.282574829865808 71 34.934805069042689 72 39.745441451940728 73 43.848521649891488
		 74 47.215918885458635 75 49.795691173571321 76 51.505577012030088 77 52.616024243517494
		 78 53.448038460347313 79 53.971169948889163 80 54.15307408480556;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX";
	rename -uid "40A4E1E5-4B84-A636-65CA-D58686978253";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.8784285254330015 1 -3.812363545056447
		 2 -3.5974485749851901 3 -3.2977226395059334 4 -2.9766490394547009 5 -2.6850519883868662
		 6 -2.4475501807465037 7 -2.2543579612079094 8 -2.0669034298516196 9 -1.8602590134608397
		 10 -1.6347572486163879 11 -1.4776931862354292 12 -1.5281449143202346 13 -1.8974382392170315
		 14 -2.6358600031501491 15 -3.6851381576127284 16 -4.8845405894136373 17 -6.0202589906714117
		 18 -6.874681174476672 19 -7.4415471040280039 20 -7.8055481351384168 21 -7.9373564947716257
		 22 -7.8942352060271679 23 -7.7394449386315856 24 -7.4862051158196907 25 -7.15625197588846
		 26 -6.7817276656345671 27 -6.4331337349817446 28 -6.1870720238903534 29 -6.0870216298995574
		 30 -6.0678225754286848 31 -6.0386664821732143 32 -6.0046543603294804 33 -5.9701830806207052
		 34 -5.9339909045142631 35 -5.8941757629657063 36 -5.8484675730059834 37 -5.7942711231413409
		 38 -5.7254770684504699 39 -5.6396745231554606 40 -5.5407483204955437 41 -5.4333868436960975
		 42 -5.3233752653789548 43 -5.2216358055039178 44 -5.1372684641709832 45 -5.0736943332375057
		 46 -4.9025388111074255 47 -4.4669364813447991 48 -3.7185848856669468 49 -2.7971440115928234
		 50 -1.8449887724306835 51 -0.66367411141718857 52 -3.9475823387242413e-006 53 -1.4523407743958265e-005
		 54 2.0685580906524206e-006 55 6.9791541694453031e-006 56 5.8220256067935202e-006
		 57 -5.1818558685149417e-006 58 -6.3547026850577497e-006 59 -1.9003022326285674e-006
		 60 9.04683510547999e-006 61 -6.2126580118417848e-006 62 0 63 0 64 -1.3299573398451698e-005
		 65 -0.34219868249895313 66 -0.68251386915220491 67 -1.0447693147771535 68 -1.4312522281035962
		 69 -1.8295635946866937 70 -2.216822964918141 71 -2.5640286951495166 72 -2.8676675085022159
		 73 -3.1398371278529971 74 -3.3714888440438022 75 -3.5542784030346795 76 -3.6803022779003776
		 77 -3.7646754406564291 78 -3.8267633645511347 79 -3.8651912746289558 80 -3.8784285254330015;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY";
	rename -uid "92299501-4FE3-D4A3-8FB8-BCB5115B94FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.3466047216384167 1 -6.3049337697908721
		 2 -6.1633377529762425 3 -5.9491588110251721 4 -5.6961560379066825 5 -5.4428034380503991
		 6 -5.2177722588354847 7 -5.020900372401484 8 -4.8166699539078035 9 -4.5746236205270439
		 10 -4.287277097942721 11 -4.07062979817431 12 -4.1418511331003423 13 -4.6195734744646595
		 14 -5.3976439082843495 15 -6.2222553220384462 16 -6.8820508061424466 17 -7.2937989045836833
		 18 -7.4873835088684269 19 -7.5649895513574243 20 -7.5941829802474761 21 -7.6008345091230813
		 22 -7.5989063931623928 23 -7.5900532123617559 24 -7.5694559567030986 25 -7.5308794431606128
		 26 -7.4708630757517982 27 -7.3991462490743203 28 -7.3390795967087232 29 -7.3123769404220331
		 30 -7.3071158126738647 31 -7.2990163370513752 32 -7.2894058432845359 33 -7.2795274297140109
		 34 -7.2689386391622364 35 -7.2571528982165292 36 -7.2433169138602986 37 -7.2265494688132161
		 38 -7.2046489569021075 39 -7.1764499985379988 40 -7.1426441782364805 41 -7.1043886685735202
		 42 -7.0634181647247862 43 -7.0238710508662958 44 -6.9900709403145624 45 -6.9638314099355565
		 46 -6.8900547008647148 47 -6.6811900109488072 48 -6.2444042753482547 49 -5.5430453313758994
		 50 -4.5560588949292891 51 -2.6181169663844295 52 3.6329151347621658e-006 53 9.4754592653474623e-006
		 54 1.1706579505872489e-005 55 2.1550291368788921e-005 56 2.6353105744014136e-006
		 57 8.7318712426199492e-006 58 -5.2909039388827923e-006 59 0 60 2.0803464839672549e-005
		 61 -1.7847751559308047e-005 62 7.64977782940818e-006 63 -1.0529109567299336e-005
		 64 3.1276047523235164e-006 65 -1.7512988560355995 66 -2.6610238703077087 67 -3.3834909347266242
		 68 -4.0036472559801703 69 -4.5370006604494879 70 -4.9810879351895503 71 -5.3303537424755918
		 72 -5.6042377466670308 73 -5.8279193403035787 74 -6.0037470817146774 75 -6.1336869614896896
		 76 -6.2190618171603687 77 -6.2743450092859447 78 -6.3141069175219764 79 -6.3383238552663368
		 80 -6.3466047216384167;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ";
	rename -uid "5DD278AF-4229-3563-C584-A39ED917218F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.942247258386068 1 52.403534684441162
		 2 50.627954327598296 3 48.087249573338568 4 45.268939452804872 5 42.606774236809677
		 6 40.353307082976315 7 38.454197934999591 8 36.546264766382002 9 34.35657831763799
		 10 31.84525766852509 11 30.006219933392714 12 30.605973372164168 13 34.758113827991288
		 14 42.147051435097289 15 51.356853195242763 16 60.814859750155946 17 69.164583888373116
		 18 75.218530948482709 19 79.17137539984185 20 81.694040652352143 21 82.60597362768344
		 22 82.307823492595162 23 81.236733997276332 24 79.481510814717836 25 77.186719395538475
		 26 74.56633892532534 27 72.107994680477802 28 70.358419629378545 29 69.643001240013433
		 30 69.505489982508962 31 69.296651726671925 32 69.052409421299373 33 68.804797021050845
		 34 68.544387965944821 35 68.257526633828633 36 67.927596803580258 37 67.536067020003458
		 38 67.037336302918803 39 66.413535627696135 40 65.691489815077858 41 64.904609825429034
		 42 64.0938397975399 43 63.340094309195976 44 62.712527459553662 45 62.237819439632297
		 46 60.950683473758176 47 57.615370426584953 48 51.633395624310928 49 43.643111633340645
		 50 34.19166180543148 51 18.561903601413217 52 0.50189602298412672 53 0.50189495217977764
		 54 0.50191250996941472 55 0.501906671465424 56 0.50190245149370927 57 0.50191683194444336
		 58 0.5018983052609427 59 0.50191176877738441 60 0.50191725999911196 61 0.50189132635592881
		 62 0.50190376792759173 63 0.50190397768950001 64 0.5019027200807672 65 12.226965387616605
		 66 18.88284277711313 67 24.427327071921955 68 29.446169604315443 69 34.023065138841638
		 70 38.077488135419792 71 41.469207162139966 72 44.286522040066338 73 46.714694626546681
		 74 48.720086677802961 75 50.26679798923697 76 51.316681188024234 77 52.012704705392906
		 78 52.521269857558444 79 52.834700362990972 80 52.942247258386068;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX";
	rename -uid "7ADC9229-413E-E062-65D9-91B5A8ED81DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 75.362643873534537 1 77.154461983999994
		 2 81.786211622395115 3 87.769079962704566 4 93.836035527902183 5 99.155324061072648
		 6 103.25939764092426 7 105.85730089219936 8 106.67639274831079 9 105.10184617838787
		 10 101.51102899102872 11 96.653041367582091 12 90.858398142207719 13 84.696294923881183
		 14 78.701906841177447 15 73.134697471971464 16 68.143096286184331 17 63.950194298609553
		 18 60.648337719320757 19 58.35472394164232 20 57.24514310507611 21 57.194535830520294
		 22 57.642194918014106 23 58.122913054260621 24 58.557553398486505 25 58.835972931463075
		 26 58.885882564531109 27 58.726554753032985 28 58.383436141207369 29 57.806620832328349
		 30 57.0925407685652 31 56.373289712453044 32 55.658840996365846 33 54.956715076295083
		 34 54.27382926496022 35 53.616456009118664 36 52.98989279108406 37 52.398082536244218
		 38 51.822401925176848 39 51.264220277188542 40 50.754279816826099 41 50.321113960146533
		 42 49.899460720804633 43 49.50416024221213 44 49.220525885026063 45 49.055865233932352
		 46 49.057326944303846 47 49.22783250543182 48 49.556458591685015 49 51.08607193021161
		 50 55.156976243871426 51 61.99785023381677 52 73.21839866715159 53 91.131870438036543
		 54 109.68851843031811 55 124.53481673439011 56 134.56404788491787 57 140.54802048280766
		 58 143.34723266237489 59 143.9939016123445 60 143.27749566068101 61 141.59043626579805
		 62 139.30114080148564 63 136.40663567687002 64 132.8481819534932 65 128.3009811726111
		 66 123.68185161162492 67 118.8444436216147 68 113.85650040987069 69 108.80539656446385
		 70 103.7927118428637 71 98.9523343757606 72 94.24174910398618 73 89.633533709487764
		 74 85.383826211415823 75 81.827222477553207 76 79.35415929950338 77 77.719103802066627
		 78 76.457767276076112 79 75.647685835192505 80 75.362643873534537;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY";
	rename -uid "CE955216-4747-07D7-021A-02B490A683E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 55.849253617437533 1 56.129481608257372
		 2 56.789247455721537 3 57.377489020031732 4 57.686860740513026 5 57.733326135403836
		 6 57.629220669367193 7 57.504190569457442 8 57.469587615111571 9 57.486634512374046
		 10 57.345634042755648 11 56.695971100638722 12 55.101504975211967 13 52.209313203347442
		 14 47.866169904958447 15 42.151536556052662 16 35.394443268680952 17 28.380901869930728
		 18 22.345299655612425 19 17.852859326726726 20 14.973272316129117 21 13.928379544279544
		 22 13.964945897267917 23 14.314389108152174 24 14.898166658268211 25 15.62869121491973
		 26 16.432152454348557 27 17.210283815711445 28 17.88848031721254 29 18.443336181754095
		 30 18.970866933666777 31 19.578799191525679 32 20.272802296833255 33 21.057922333506976
		 34 21.93389993878661 35 22.897608054365126 36 23.942188915006046 37 25.056589776521392
		 38 26.220037174060494 39 27.414140923868601 40 28.625271710440497 41 29.836857601385287
		 42 31.015835791183992 43 32.131706349258074 44 33.183500509347148 45 34.210895525036484
		 46 35.333895666297344 47 36.909061997216817 48 39.360680882503885 49 43.065961431417087
		 50 48.038147188102648 51 54.106367026856013 52 60.507785941369221 53 64.062761281558792
		 54 64.876615768061697 55 63.708044620040148 56 61.747723495345163 57 59.778350021908587
		 58 58.124436034519675 59 56.855300270283728 60 55.95605254020434 61 55.408169715066677
		 62 55.231767326806342 63 55.335807077843633 64 55.615945317601941 65 55.01728184693328
		 66 54.887180213863211 67 54.851004497160126 68 54.844459756266097 69 54.85622614023972
		 70 54.903020840040952 71 55.025875417265802 72 55.171195868078684 73 55.245403994035357
		 74 55.270746333458895 75 55.303604444768325 76 55.430013198754892 77 55.610360792377094
		 78 55.741318602750781 79 55.821683211492363 80 55.849253617437533;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ";
	rename -uid "3B3842B6-4A34-06E3-C8C8-4F98D4E6F7E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -49.658790052194092 1 -47.591202207740615
		 2 -42.103075715601548 3 -34.780719603949407 4 -27.044327805112442 5 -19.925208377827246
		 6 -14.055876666129093 7 -9.7681337935012955 8 -7.2336853664176219 9 -7.3127341813457303
		 10 -10.254067651948242 11 -16.153507936429879 12 -25.39287162668133 13 -37.657701026114097
		 14 -51.875930007372219 15 -66.585790702543292 16 -80.439579176484173 17 -92.334840257804174
		 18 -101.39944704253055 19 -108.17797221667158 20 -113.57445712824325 21 -117.397581229257
		 22 -120.10731254705328 23 -122.21503120480223 24 -123.66372086854567 25 -124.46183635678995
		 26 -124.67091613542297 27 -124.66094620556002 28 -124.87250754945286 29 -125.50014969304171
		 30 -126.2508251772297 31 -126.71038115888889 32 -126.9355389546956 33 -126.99144904159643
		 34 -126.88054105471731 35 -126.6047348922136 36 -126.16614444665696 37 -125.5675946936563
		 38 -124.80662864881292 39 -123.8900612466026 40 -122.83864567099728 41 -121.67722376584319
		 42 -120.44021051347501 43 -119.11733166088224 44 -117.70302053102186 45 -116.22925729350345
		 46 -113.56601864570325 47 -108.61592770161337 48 -101.34314601567516 49 -91.886358403241388
		 50 -79.895475210702372 51 -62.251290303711414 52 -39.274831779612924 53 -20.99169791556815
		 54 -2.2225551476410401 55 12.791505273801551 56 22.910501754352548 57 28.759764396698117
		 58 30.990544830571686 59 30.726395572117234 60 29.035415368845612 61 26.66136373231755
		 62 24.461393998514524 63 22.148725637069678 64 19.207890536792995 65 8.4320349970259851
		 66 0.78495579171711138 67 -6.3380853164422213 68 -13.151361756098233 69 -19.564984122704402
		 70 -25.383614424334667 71 -30.35320937908666 72 -34.728851795372634 73 -38.85558912330491
		 74 -42.510156700770956 75 -45.400596633750105 76 -47.184418768874323 77 -48.196003034432529
		 78 -48.977753044751623 79 -49.481179314251676 80 -49.658790052194092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAX";
	rename -uid "B95BBC78-425B-EAF3-BF39-30A8E2D9E0E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.8183795147516344 1 -2.8183839575124625
		 2 -2.8183785653411277 3 -2.8183885615171764 4 -2.8183575699033421 5 -2.8184147265134101
		 6 -2.8183808214326005 7 -2.8183646738323156 8 -2.8183972266071899 9 -2.8183714665809325
		 10 -2.8183787360925971 11 -2.8183756072159367 12 -2.8183861261723933 13 -2.8183483205422344
		 14 -2.8183964390812908 15 -2.8183823432717583 16 -2.8183974302171548 17 -2.8183809458876978
		 18 -2.8183673828928293 19 -2.8183977707778221 20 -2.8183843960714636 21 -2.818370354565348
		 22 -2.8183829948288373 23 -2.8183849296901151 24 -2.8183762926733746 25 -2.8183884724137394
		 26 -2.818390614763437 27 -2.8184031553056714 28 -2.8183885134137201 29 -2.8183767906454604
		 30 -2.8184053346967404 31 -2.8183920990444689 32 -2.8183644403941277 33 -2.8183828980650372
		 34 -2.8183821249668215 35 -2.8183591929631455 36 -2.8183761760532984 37 -2.8183799104616596
		 38 -2.8183865874282139 39 -2.8183829204757207 40 -2.8183655431565038 41 -2.818381545214669
		 42 -2.8183788871666446 43 -2.8183790170840441 44 -2.818416436442754 45 -2.8183976529206327
		 46 -2.8183973658338122 47 -2.8184131146503333 48 -2.8183802996865257 49 -2.8183881605191115
		 50 -2.8183802252704959 51 -2.8184297456695524 52 -2.8184077325717776 53 -2.8184499388021593
		 54 -2.8184001628996245 55 -2.8183666361892579 56 -2.8183923056734757 57 -2.8183862020396173
		 58 -2.818425138315463 59 -2.8183779747654238 60 -2.8184059410162177 61 -2.818416482410401
		 62 -2.8183909291459859 63 -2.8184071446466468 64 -2.8183956044315082 65 -2.8184093742454768
		 66 -2.8183505703098382 67 -2.8183806082200147 68 -2.8183618612827543 69 -2.8183879196248824
		 70 -2.8183732894317912 71 -2.8183952921012092 72 -2.8183643170773922 73 -2.8183860381597126
		 74 -2.8184048751250308 75 -2.8183956123854363 76 -2.8183839143388578 77 -2.8183671350403174
		 78 -2.8184093965335681 79 -2.8184059563348853 80 -2.8183795147516344;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAY";
	rename -uid "D62B81CB-4EEE-0DA3-9EB6-AB9DD2F21170";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.1104971418800194 1 5.1105087348795681
		 2 5.110487956702622 3 5.1104766254314971 4 5.1105123111509547 5 5.1105381529118885
		 6 5.1104977992123786 7 5.1104870886172309 8 5.1104843739190917 9 5.110419867693488
		 10 5.1104785736100418 11 5.1104721365333825 12 5.1105045980798671 13 5.1104845191212211
		 14 5.1105529996343657 15 5.1104881355993186 16 5.110499721589286 17 5.1105506479995837
		 18 5.1105065586985772 19 5.1104966094451649 20 5.1104765456778223 21 5.1104952573410714
		 22 5.1104944664456431 23 5.1105169882306125 24 5.1104915942413029 25 5.1104988612631068
		 26 5.1104871279620365 27 5.110544585772713 28 5.1104949838289757 29 5.1105053734711721
		 30 5.1105107005582191 31 5.1105050015040323 32 5.1104743887333903 33 5.1104808655247549
		 34 5.1105079504042354 35 5.1104941769389294 36 5.1104894106133107 37 5.1104912691036848
		 38 5.1104899014694141 39 5.1104939149229498 40 5.1104706105591333 41 5.1105015012229407
		 42 5.1104808221842513 43 5.1104759285168795 44 5.1105161483640043 45 5.1105080993321419
		 46 5.1105038039786939 47 5.1104927648901111 48 5.1104981412943467 49 5.1104903139170563
		 50 5.1104791155681131 51 5.1104934149124626 52 5.1104781435012363 53 5.1105007909770137
		 54 5.1104969260748874 55 5.1104935511426488 56 5.1104964564662065 57 5.1104951060086243
		 58 5.1104715758313493 59 5.1104657074709072 60 5.1104513870309445 61 5.1104811232394525
		 62 5.1104876922742619 63 5.1105163183897302 64 5.1105070824625258 65 5.1105147853027404
		 66 5.1105101852528536 67 5.1104832065225008 68 5.1104747127865711 69 5.1105111440297311
		 70 5.1104829271627841 71 5.1105080271799812 72 5.1105000524396091 73 5.1104622235576045
		 74 5.1104746706201993 75 5.1105376850851751 76 5.1105234434102726 77 5.1104922173508118
		 78 5.1105372598901946 79 5.1104921225010553 80 5.1104971418800194;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAZ";
	rename -uid "4E636FEA-4EEC-EBA2-4070-35B6A8C456BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.38736218029522645 1 -0.84863918782942527
		 2 -4.1072048130208545 3 -8.7140948967735099 4 -13.995182212691617 5 -19.276287218744208
		 6 -23.883188623198258 7 -27.141738132615565 8 -28.377731802092107 9 -25.013159938011157
		 10 -16.601673556730084 11 -5.6667514960698622 12 5.2681621475230616 13 13.679648267711592
		 14 17.044243113842274 15 15.434328398442709 16 11.190024625944895 17 5.1894695001566395
		 18 -1.6891781530879442 19 -8.5678752217005023 20 -14.568440049783952 21 -18.812717772058207
		 22 -20.42261366005787 23 -19.39515725398525 24 -16.86476413668268 25 -13.659620991936906
		 26 -10.607727895873493 27 -8.5373156115638444 28 -7.321662525888283 29 -6.2796300580579629
		 30 -5.4077252148117303 31 -4.702316405658002 32 -4.1599239524000371 33 -3.7768688285328484
		 34 -3.549636117656779 35 -3.4746930171457078 36 -3.7847288337311022 37 -4.6175340302074792
		 38 -5.8273951909763904 39 -7.2684465295272744 40 -8.7948952016953612 41 -10.203284139654254
		 42 -11.527789097443542 43 -12.979059567540656 44 -14.767948316249171 45 -17.105121035174342
		 46 -20.201329548204605 47 -24.559260725049249 48 -30.16521646450866 49 -36.455424192090312
		 50 -42.866071737131691 51 -48.833535800973173 52 -53.793946111731479 53 -57.183629260077744
		 54 -58.438821268593514 55 -56.385221793249237 56 -50.881595393809377 57 -42.913651125877941
		 58 -33.467179120701346 59 -23.5277960486995 60 -14.081331980344649 61 -6.1134013488557626
		 62 -0.60980724840095923 63 1.4437915859401189 64 0.57632416473485604 65 -1.6607587060176718
		 66 -4.7196227883998025 67 -8.0523985198887615 68 -11.111285580784257 69 -13.348349856665635
		 70 -14.215778768399183 71 -13.134080062884626 72 -10.429765854687748 73 -6.9142145861157953
		 74 -3.3986501354374528 75 -0.69434432507386534 76 0.38735890553643865 77 0.38736495265997467
		 78 0.38736178310238034 79 0.38736755803728046 80 0.38736218029522645;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX";
	rename -uid "744E136E-4E8B-7197-7E4D-94A0F2A2E389";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 9.1840395930213834 1 9.2013158829052397
		 2 9.2463246702272155 3 9.3090584998221679 4 9.3794061599260701 5 9.4470866886007236
		 6 9.5014907195138356 7 9.5316551118708226 8 9.5264839667357251 9 9.4745452308297455
		 10 9.3642789934711352 11 9.1838562263114181 12 8.9276670823559421 13 8.6010875704855714
		 14 8.2124282781982529 15 7.7189837240799202 16 7.0902223854435675 17 6.3548017370640926
		 18 5.5439051590009347 19 4.6912394954983805 20 3.8320466261172905 21 3.0015885223244059
		 22 2.2337714091820993 23 1.559983004126404 24 0.98683282901017055 25 0.50002502610159605
		 26 0.097412561563092928 27 -0.23675133399249934 28 -0.51947989844385989 29 -0.75430149125734391
		 30 -0.94466411675196249 31 -1.0939351080193036 32 -1.2096384699990161 33 -1.300273852829992
		 34 -1.3704973556480082 35 -1.424852282168751 36 -1.4678355629381803 37 -1.5038088584069691
		 38 -1.5470698196707999 39 -1.6006443179023304 40 -1.6522905149855118 41 -1.6898439938406253
		 42 -1.7012922400917732 43 -1.6746188006574418 44 -1.5974110979528702 45 -1.4567841610128371
		 46 -1.2002452160348256 47 -0.79267810402335637 48 -0.24546859078399552 49 0.42977497241433499
		 50 1.2237611016228458 51 2.1591594236566283 52 3.2442757002677425 53 4.4373482129957909
		 54 5.6871061591120986 55 6.9347682248472715 56 8.1192933967011882 57 9.1842101206408859
		 58 10.08295941394096 59 10.780861688286294 60 11.253004655327127 61 11.521944482960928
		 62 11.621987508017552 63 11.616041086989171 64 11.577065078581869 65 11.505271856988054
		 66 11.397644399089728 67 11.259485251383152 68 11.096046373513955 69 10.912466651493059
		 70 10.714133211494337 71 10.506371670048942 72 10.294844501366031 73 10.085278777461737
		 74 9.8835953257525393 75 9.6958611975765514 76 9.5282596963762423 77 9.3870062036544866
		 78 9.2783969179277914 79 9.2086645702782217 80 9.1840395930213834;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY";
	rename -uid "E06BFC3E-412B-CEFD-8AD6-95B8F94C0DE3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.010426873067906442 1 0.0061315943200873314
		 2 -0.0050332642091413761 3 -0.020644299181632096 4 -0.03809042130623351 5 -0.054620634100224871
		 6 -0.067150243604786664 7 -0.072367931637760827 8 -0.066804125205912585 9 -0.047173549575803386
		 10 -0.010662244667524577 11 0.04470915065019232 12 0.11785056415977949 13 0.20367141018549645
		 14 0.29715909973365329 15 0.40249203698726405 16 0.51364233428320272 17 0.61125783073241513
		 18 0.67889946041685678 19 0.70519679091338383 20 0.6851020608023678 21 0.62089192466772813
		 22 0.52156313307849167 23 0.40187582417272694 24 0.27520687636376728 25 0.14882125670516763
		 26 0.030557939990696767 27 -0.07759552699637072 28 -0.17647071931684793 29 -0.26385537097247952
		 30 -0.33814825840597162 31 -0.39840187950631112 32 -0.44626111614096214 33 -0.48453939926228451
		 34 -0.51470719804747944 35 -0.5383473730103151 36 -0.55717533372205597 37 -0.57305488502685509
		 38 -0.59216901548614598 39 -0.61604663657238734 40 -0.63918664790743784 41 -0.65611438509937237
		 42 -0.661137592443239 43 -0.64878387862795106 44 -0.61381257755481844 45 -0.55153643934939367
		 46 -0.44233167615979591 47 -0.27977362548638984 48 -0.081624565474800709 49 0.13245500751537731
		 50 0.34277335930511743 51 0.5346290398658019 52 0.68463359935994117 53 0.762066899859702
		 54 0.74592519274211 55 0.62961086486997508 56 0.42337620773015477 57 0.15344006816526054
		 58 -0.14229974897084963 59 -0.42091571998894739 60 -0.64086783434429984 61 -0.7852283596719396
		 62 -0.85349654029823796 63 -0.86833200546054734 64 -0.86183635805913494 65 -0.83620932488974442
		 66 -0.7932585414001303 67 -0.7363806858444667 68 -0.66896003084956546 69 -0.59423035058568574
		 70 -0.51534487065977974 71 -0.43515881327873845 72 -0.35621682346772654 73 -0.28083488079914781
		 74 -0.21101639728602758 75 -0.14845956601751301 76 -0.09455191111764219 77 -0.050539091701159847
		 78 -0.017584862662281799 79 0.0031610197120895398 80 0.010426873067906442;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ";
	rename -uid "9A35AB19-4AE9-5B17-ECCE-4F8C352AB231";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.5486968106674328 1 2.575301325897267
		 2 2.6441289963717378 3 2.7389927529275933 4 2.8437189776847211 5 2.9414319233191066
		 6 3.0144259268102189 7 3.0441903114622613 8 3.0113341499723769 9 2.8960086203963429
		 10 2.6778708284286967 11 2.3366443700923174 12 1.8630628518144368 13 1.2668940774159814
		 14 0.55507614278422868 15 -0.3535844606268756 16 -1.5090980244855445 17 -2.8585646804284992
		 18 -4.3468444287359924 19 -5.9164544829410355 20 -7.508435635186629 21 -9.0633478617438072
		 22 -10.522592774406627 23 -11.829204403593815 24 -12.968122216900156 25 -13.961437981394083
		 26 -14.809084212215666 27 -15.531300663390565 28 -16.149700100341558 29 -16.665613309970894
		 30 -17.080393665301784 31 -17.395585948170311 32 -17.633479047883394 33 -17.820989789662903
		 34 -17.966942395482413 35 -18.080018107101512 36 -18.168855780052752 37 -18.242109999042491
		 38 -18.327614986907598 39 -18.431548635247513 40 -18.530182923002332 41 -18.599902476033947
		 42 -18.617239948946555 43 -18.558729617960591 44 -18.400697999653566 45 -18.11892328125721
		 46 -17.614108370057838 47 -16.82484061773085 48 -15.781945688243177 49 -14.516367206959709
		 50 -13.031215397025047 51 -11.28766599851429 52 -9.2904850951107996 53 -7.1121961933153512
		 54 -4.8347375338642173 55 -2.5492712825558286 56 -0.35170454567369486 57 1.664197737408504
		 58 3.4132709773433656 59 4.8225255079697584 60 5.8307470189449448 61 6.459227438350581
		 62 6.7555916536343217 63 6.8295487638337162 64 6.8125448247743305 65 6.7142248398999573
		 66 6.5418752720213522 67 6.3068082809488812 68 6.0199984748435851 69 5.6923935437967721
		 70 5.3348338373641164 71 4.9582073580945565 72 4.5735029832337615 73 4.1917585262478285
		 74 3.8241575297975587 75 3.4819219610207268 76 3.1763928597169158 77 2.9189176610444787
		 78 2.72086148708155 79 2.5936415033570386 80 2.5486968106674328;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX";
	rename -uid "C46E482D-4D6B-C560-3B17-73A9E10BE405";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 14.118717229646881 1 14.112176245852963
		 2 14.09631690937195 3 14.076379203517053 4 14.057745076265121 5 14.046233037911582
		 6 14.04868382489296 7 14.072846923469999 8 14.127377396464107 9 14.221503751411602
		 10 14.364329510961593 11 14.564230972640829 12 14.823664015466834 13 15.135936914984212
		 14 15.50792119942763 15 15.982008480783522 16 16.565752559606704 17 17.218658570581002
		 18 17.90238836260658 19 18.582817423440154 20 19.231729485145539 21 19.82801217849056
		 22 20.357554671325659 23 20.81290509054595 24 21.200433192861176 25 21.534189446464808
		 26 21.821388929819985 27 22.065672742248651 28 22.26734905572868 29 22.427215009862781
		 30 22.545385665367302 31 22.621405273814897 32 22.670121779097403 33 22.708385424842167
		 34 22.737938843833053 35 22.760418782301269 36 22.777245363528561 37 22.789777346935203
		 38 22.801580586495636 39 22.813504949366141 40 22.822868119766454 41 22.827158698355202
		 42 22.823872808572244 43 22.810446073346089 44 22.783981507897437 45 22.740748045721361
		 46 22.666228714872794 47 22.54622103635414 48 22.375265671410084 49 22.146495590629804
		 50 21.82065462833587 51 21.364706791767041 52 20.772704108520145 53 20.036207611988104
		 54 19.157679873970178 55 18.156014812058952 56 17.06956671820177 57 15.95488020628658
		 58 14.88119472430386 59 13.92247038345813 60 13.149331297348025 61 12.58873438412909
		 62 12.242773678626211 63 12.062766408718701 64 11.982209227365553 65 11.9808711045072
		 66 12.033812956016156 67 12.132619692613417 68 12.268884273910626 69 12.43442561952816
		 70 12.621330939884217 71 12.821892812847775 72 13.02878127274659 73 13.23486199738455
		 74 13.433374099603917 75 13.617876954056134 76 13.782224930217325 77 13.920346955788986
		 78 14.026459312499815 79 14.09459382546448 80 14.118717229646881;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY";
	rename -uid "1EF90375-4DDD-5EF0-975D-CBBA495A0E48";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 1.3982047526747146 1 1.3917861125205253
		 2 1.3753659013838013 3 1.3530907682727245 4 1.3291791116569973 5 1.3079638518801722
		 6 1.2940600055052915 7 1.2924296476188617 8 1.3084559442808104 9 1.3479858652820504
		 10 1.4174075583684069 11 1.5238233928439988 12 1.6719054652284659 13 1.8614488224992425
		 14 2.0962214428059678 15 2.4095216946856923 16 2.8254842619674392 17 3.3344059347111448
		 18 3.9226129661857563 19 4.5716263276491054 20 5.2582775488413622 21 5.9556641885055237
		 22 6.63452250331326 23 7.2645381272831031 24 7.8334012147272913 25 8.3463793218859959
		 26 8.7999376357256818 27 9.1971298747924148 28 9.5410405803902929 29 9.8287084610413871
		 30 10.057400828578148 31 10.224785355175657 32 10.346815746440642 33 10.443536381410707
		 34 10.519040443640844 35 10.577527409258446 36 10.623073833616635 37 10.65985038503122
		 38 10.701088513253158 39 10.749784019533957 40 10.794868995421266 41 10.825278121757416
		 42 10.830041714467704 43 10.798169216970443 44 10.718621592327633 45 10.580259257749089
		 46 10.336892030541513 47 9.9609148511298571 48 9.4689082573596917 49 8.8782374340836689
		 50 8.1800830684949197 51 7.3610535490818991 52 6.4429541407316941 53 5.4689372604721811
		 54 4.4861333442865732 55 3.5435407799979268 56 2.6868575786006579 57 1.9520279862509489
		 58 1.3607100853892089 59 0.91932427042596065 60 0.62267338109075143 61 0.44384625805396971
		 62 0.35613231172804755 63 0.32584732742729006 64 0.32108822581332802 65 0.33764940826811429
		 66 0.37212356300737015 67 0.42228544417543351 68 0.48624228553432103 69 0.56198220075516914
		 70 0.6474979391622655 71 0.74043298122257273 72 0.83829429459966998 73 0.93815174617592056
		 74 1.0368695310711284 75 1.130991420065697 76 1.2167555658909803 77 1.2903414442869832
		 78 1.3477370200585221 79 1.3849627088318948 80 1.3982047526747146;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ";
	rename -uid "8DF139A5-420D-CF8B-5F82-1ABFB1F3FE41";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.9277483643209314 1 -2.9050368405208546
		 2 -2.846628552135507 3 -2.7666942665264438 4 -2.6794439819092961 5 -2.5998707915158126
		 6 -2.5438036462129978 7 -2.528197077792834 8 -2.5707862894419504 9 -2.6898640098063646
		 10 -2.9038501519025046 11 -3.2307861814783787 12 -3.6778301661288864 13 -4.2344888104512144
		 14 -4.8964400355459476 15 -5.7376549596667541 16 -6.7960711447638937 17 -8.0163511728457291
		 18 -9.3435661834709727 19 -10.723975057308056 20 -12.105923693698699 21 -13.440524141114503
		 22 -14.681910836404899 23 -15.786930345647351 24 -16.747098840899074 25 -17.583281669317746
		 26 -18.297446725358384 27 -18.905888482270001 28 -19.425247440927247 29 -19.856777318305973
		 30 -20.2014858275123 31 -20.460443818971399 32 -20.654108017707156 33 -20.806800283793358
		 34 -20.925686606140772 35 -21.017708187748763 36 -21.089874810711652 37 -21.149074729787504
		 38 -21.217549347940338 39 -21.300355488652976 40 -21.378534746126011 41 -21.433300795491093
		 42 -21.445984731727002 43 -21.397895113152249 44 -21.270124504716136 45 -21.043363068478641
		 46 -20.6383521678531 47 -20.005849764770591 48 -19.169773863765538 49 -18.153495435823121
		 50 -16.950251279046235 51 -15.521521987054626 52 -13.866594442823017 53 -12.032728404345765
		 54 -10.075138741183565 55 -8.0604035541828623 56 -6.0668474386113829 57 -4.181238577639645
		 58 -2.4933837680754105 59 -1.0900290964288684 60 -0.050182131932553255 61 0.62660762131716596
		 62 0.97258027208884668 63 1.0887459658011389 64 1.1006785453820336 65 1.022558688043876
		 66 0.86823300805267434 67 0.64963419129965239 68 0.37844586083847453 69 0.066156946896485075
		 70 -0.27589149985180289 71 -0.63647887828248884 72 -1.0045347130847686 73 -1.3691227379232784
		 74 -1.7194057360607127 75 -2.0447180798304978 76 -2.3344395341429904 77 -2.5781307759972361
		 78 -2.7652440740518909 79 -2.8853376525529 80 -2.9277483643209314;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX";
	rename -uid "2EFB8CCA-4398-7C6B-54EA-3CA5210D5936";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.9922855747722616 1 7.2051318672588209
		 2 7.7706088683987113 3 8.5741974728926298 4 9.5077092207312628 5 10.479689105191447
		 6 11.419609389416449 7 12.276507558385655 8 13.011622566715065 9 13.585379817038655
		 10 14.103893447290416 11 14.705775757397626 12 15.387593418170706 13 16.14497673256874
		 14 16.972311169520648 15 17.862661999408093 16 18.807582874801852 17 19.797247924064457
		 18 20.820123253125466 19 21.863271637810666 20 22.912424849072352 21 23.951908025509177
		 22 24.965085877935987 23 25.934478694637761 24 26.841920280537078 25 27.669181595536479
		 26 28.39804086752531 27 29.010554212457627 28 29.489561713052236 29 29.819073804779951
		 30 29.984131458841084 31 30.018315113998657 32 29.966645758661102 33 29.833476418306603
		 34 29.623397522910871 35 29.341457626517339 36 28.992949696933515 37 28.583281421439363
		 38 28.118076411716 39 27.602865524111504 40 27.043195406853762 41 26.444615958311147
		 42 25.812395798914714 43 25.151745497913456 44 24.467588365533672 45 23.764651578548413
		 46 23.047385761328382 47 22.320008571507937 48 21.586379502756188 49 20.850129226824077
		 50 20.114601967489421 51 19.382884958658654 52 18.65771908270041 53 17.941704517311877
		 54 17.237101877279823 55 16.545941223093408 56 15.870178455351979 57 15.211420313770519
		 58 14.571202367294278 59 13.950818894158875 60 13.351519219465731 61 12.774348403219047
		 62 12.220250454902061 63 11.690137008895537 64 11.184760917962072 65 10.704911008907789
		 66 10.25116474910198 67 9.8242173021615873 68 9.4246522576565361 69 9.0529957447883351
		 70 8.7098194326861922 71 8.3957551861877331 72 8.1113861358764634 73 7.8572564141915775
		 74 7.6340978096757839 75 7.4426521915469968 76 7.283681604063772 77 7.1580821745524075
		 78 7.0668457133280516 79 7.011146698848516 80 6.9922855747722616;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY";
	rename -uid "C7B4C2D9-4EA4-4D98-9AE2-EFAD65BEA8B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.3593833091468115 1 -5.9380331492167606
		 2 -7.5094805854909685 3 -9.8265951057263212 4 -12.641078773400269 5 -15.703104862410255
		 6 -18.762302420989545 7 -21.56890418832252 8 -23.874388342282998 9 -25.431341442945655
		 10 -26.530195917103594 11 -27.620712894301981 12 -28.695011082027762 13 -29.745198303135137
		 14 -30.763738754622064 15 -31.743364648601773 16 -32.677430186541429 17 -33.559685644447875
		 18 -34.384635092109328 19 -35.147556392884681 20 -35.844404938893376 21 -36.471978763658086
		 22 -37.027986319161471 23 -37.510720250067443 24 -37.919313983117995 25 -38.253252465970434
		 26 -38.512468216716996 27 -38.69701048376249 28 -38.806787195523071 29 -38.841211111947018
		 30 -38.799120874476124 31 -38.687276318464555 32 -38.515475518915991 33 -38.286053325546128
		 34 -38.001191702528629 35 -37.66277726256299 36 -37.272620869589304 37 -36.832477558200289
		 38 -36.343956181515885 39 -35.808755702030716 40 -35.228446152938794 41 -34.604811670027523
		 42 -33.939525684813191 43 -33.234514743428001 44 -32.491739389323513 45 -31.713250901553732
		 46 -30.901228673088983 47 -30.058042556786209 48 -29.186147354218704 49 -28.288132043350458
		 50 -27.3667119581945 51 -26.42470904227406 52 -25.465084754185266 53 -24.490890220540049
		 54 -23.505289485679235 55 -22.511515485321663 56 -21.512857834214067 57 -20.512765526760006
		 58 -19.51466677658512 59 -18.522046329233074 60 -17.538443265701051 61 -16.567465766543251
		 62 -15.612736816552003 63 -14.677883780190204 64 -13.766548127052154 65 -12.882379269926554
		 66 -12.029106171608618 67 -11.210345841943205 68 -10.429758965444769 69 -9.6910535639866282
		 70 -8.9978771640908448 71 -8.3538315620793764 72 -7.7625429469605045 73 -7.2276469180124296
		 74 -6.7527228498110565 75 -6.3412948201673967 76 -5.9969175214006745 77 -5.7230995007804371
		 78 -5.523286590081562 79 -5.4009083292054569 80 -5.3593833091468115;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ";
	rename -uid "7DF45857-4016-FFC2-5518-54B6BA55C4D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.826424484316885 1 -13.879346240572968
		 2 -14.041943554484646 3 -14.323313965364367 4 -14.731727026272564 5 -15.271286309204127
		 6 -15.94056184697456 7 -16.732965642703778 8 -17.635950128644005 9 -18.628307215152603
		 10 -19.698813261155514 11 -20.85201173623982 12 -22.079107787488773 13 -23.371045658251177
		 14 -24.717969232839636 15 -26.109087139793644 16 -27.532636544062736 17 -28.975763159959865
		 18 -30.424632489599027 19 -31.864147993310453 20 -33.278324653738245 21 -34.650183358350326
		 22 -35.962040845636118 23 -37.195530497311012 24 -38.332139233551629 25 -39.353050677223997
		 26 -40.239690183983043 27 -40.973856173810567 28 -41.538166182493029 29 -41.915890815792615
		 30 -42.091665948924792 31 -42.111261697301181 32 -42.033477226373691 33 -41.86321052802414
		 34 -41.605873317691895 35 -41.267165307382676 36 -40.852971964816057 37 -40.369370065640851
		 38 -39.822466769888571 39 -39.218428979914478 40 -38.563322362492961 41 -37.863123528009446
		 42 -37.123631401407764 43 -36.350463759435769 44 -35.548968272066759 45 -34.72428501325264
		 46 -33.881258851077227 47 -33.024388553405466 48 -32.157932771092064 49 -31.285827609305329
		 50 -30.411724185728321 51 -29.53896322694326 52 -28.670683809877392 53 -27.809635577229702
		 54 -26.958437978745199 55 -26.119473174891748 56 -25.294915741967841 57 -24.486749822027331
		 58 -23.696783041682302 59 -22.926716363633957 60 -22.17816718485518 61 -21.452589484318505
		 62 -20.751381412014439 63 -20.075941851647393 64 -19.4275381360243 65 -18.807488620507364
		 66 -18.216981161699248 67 -17.657419319226179 68 -17.129972605200457 69 -16.635968784988215
		 70 -16.176733985252532 71 -15.75365148432515 72 -15.368074838044324 73 -15.021624529139288
		 74 -14.715676843541418 75 -14.451864359299899 76 -14.231903591878378 77 -14.057488528791183
		 78 -13.930502408420116 79 -13.852819261593634 80 -13.826424484316885;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX";
	rename -uid "09ACF591-48F1-448D-C7A8-3BAEDDEC4598";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.5883568623633355 1 5.5831703556526424
		 2 5.4686623671433541 3 5.2532122548516886 4 4.9460182568722173 5 4.5564952740668092
		 6 4.0946056944865079 7 3.5704254234356507 8 2.9941423093986206 9 2.3758433285500065
		 10 1.725600793302182 11 1.052929419066106 12 0.36733376878864377 13 -0.32237639658420697
		 14 -1.0078626354799085 15 -1.6814060940818305 16 -2.3359729528760322 17 -2.9651036458047839
		 18 -3.5633294212180551 19 -4.1257696976305072 20 -4.6480219944983316 21 -5.1265405325907807
		 22 -5.5582838609149361 23 -5.9404756339729863 24 -6.2708171411283589 25 -6.5470466139316228
		 26 -6.7668112370720106 27 -6.9277604511810802 28 -7.0269992286094496 29 -7.0609291546157849
		 30 -7.0381961404282816 31 -6.9721174308865548 32 -6.8662777427909374 33 -6.724177993956415
		 34 -6.5494788296914983 35 -6.3458490827343699 36 -6.1167480874919908 37 -5.8655977038538305
		 38 -5.595615445646243 39 -5.3098135428812459 40 -5.0110473539421854 41 -4.7018743766582265
		 42 -4.3845202717736722 43 -4.0611934059207382 44 -3.7336290401690264 45 -3.4035395330978266
		 46 -3.0722420997218114 47 -2.741052410322605 48 -2.4110978116266275 49 -2.0834557437056325
		 50 -1.7592460281599633 51 -1.4396870910999309 52 -1.126300511162835 53 -0.82094545746480885
		 54 -0.52611818692506263 55 -0.24499278895703988 56 0.018313954572249595 57 0.27916703057127351
		 58 0.55461622538353894 59 0.84215649652054059 60 1.1393783325046813 61 1.4438333578497509
		 62 1.7531203793626347 63 2.0648641839912338 64 2.3767757895932489 65 2.6864856041715157
		 66 2.9918023817005919 67 3.2904029845327072 68 3.5801440438222194 69 3.8587698921448093
		 70 4.1241732203176573 71 4.3742489156159161 72 4.6068346012069954 73 4.8198128098747679
		 74 5.0111447977179751 75 5.1787946954223996 76 5.320636649185861 77 5.4345838191697693
		 78 5.5185662238296826 79 5.57050392845382 80 5.5883568623633355;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY";
	rename -uid "B56160B2-4A62-32FA-58B2-2D9E344E1A4C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -16.687929796848362 1 -16.674147427065659
		 2 -16.608989093440471 3 -16.496781595417989 4 -16.342512164573733 5 -16.151520539387963
		 6 -15.92947839186893 7 -15.682074091783457 8 -15.414882834635263 9 -15.133209118193895
		 10 -14.842088235300414 11 -14.545964050726193 12 -14.248883777379838 13 -13.954357119553057
		 14 -13.665367939640657 15 -13.384373326808007 16 -13.11343302522368 17 -12.854211311931696
		 18 -12.608133735646867 19 -12.376338882878857 20 -12.159962802052405 21 -11.96004822842532
		 22 -11.777796045704156 23 -11.614339339090614 24 -11.471169263039613 25 -11.349812213769169
		 26 -11.252002729112133 27 -11.179625565120608 28 -11.134659241302574 29 -11.119186830439379
		 30 -11.166018942985694 31 -11.301314010677 32 -11.517658912805935 33 -11.807657294182382
		 34 -12.164100215852871 35 -12.579736932738147 36 -13.047471562397014 37 -13.560097061811499
		 38 -14.110465788772043 39 -14.691347422182485 40 -15.295382840619498 41 -15.915199496257012
		 42 -16.543220757196007 43 -17.171751760009421 44 -17.792850521484635 45 -18.398492404726898
		 46 -18.980294861277528 47 -19.529780195063985 48 -20.038054425254256 49 -20.496116972308553
		 50 -20.894587029496538 51 -21.223969199805346 52 -21.474382934631922 53 -21.635899502327941
		 54 -21.698379055837485 55 -21.651466995758451 56 -21.484915551536577 57 -21.249864378219652
		 58 -21.005415669118914 59 -20.753133709977536 60 -20.494690147941654 61 -20.231734376417325
		 62 -19.965930906312082 63 -19.698962947671752 64 -19.432538768425925 65 -19.168359667908859
		 66 -18.908190344970087 67 -18.653748349800811 68 -18.406833331612123 69 -18.169178668726754
		 70 -17.942627144793363 71 -17.728959640805812 72 -17.530018617198937 73 -17.347586674305909
		 74 -17.183542654213667 75 -17.039721168350138 76 -16.917927598869607 77 -16.820032865923093
		 78 -16.747832134426595 79 -16.703189591067392 80 -16.687929796848362;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ";
	rename -uid "16C0328D-4D24-73DC-FA3C-4FA27A5FBC33";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 23.09334783771487 1 23.141023209351374
		 2 22.986604100948359 3 22.644142166691534 4 22.127089082020984 5 21.448458895062686
		 6 20.621098425471938 7 19.657793366597723 8 18.571415712221977 9 17.374952295220972
		 10 16.082033094447546 11 14.706026782304111 12 13.261334912406006 13 11.762525287887463
		 14 10.224627566587051 15 8.6631705538280865 16 7.0941025440464971 17 5.5337053763908033
		 18 3.9986478671532395 19 2.5059569616292534 20 1.0727474641581847 21 -0.28359113407334169
		 22 -1.5455867400486498 23 -2.6957092721635196 24 -3.7164087631917955 25 -4.5901416449955761
		 26 -5.299557124930331 27 -5.8272724270355436 28 -6.1562614110758815 29 -6.269642477693445
		 30 -6.1554642889524853 31 -5.8242890040998763 32 -5.2932513211443144 33 -4.5796660768890911
		 34 -3.7008249296573692 35 -2.6740763498210791 36 -1.5168020507910327 37 -0.24637881316867369
		 38 1.1198181189525183 39 2.5644478706258793 40 4.0702223184898862 41 5.6198709921517445
		 42 7.1961117688693763 43 8.7818357880661466 44 10.359904558286463 45 11.91325245872153
		 46 13.424842694677757 47 14.877844252244044 48 16.255408301116145 49 17.540847676919483
		 50 18.717637244751614 51 19.769352972593431 52 20.679857350343497 53 21.433288873307529
		 54 22.014062749027303 55 22.406920286296621 56 22.59694826496392 57 22.675925130236234
		 58 22.745871922487076 59 22.807451864648609 60 22.861247406544919 61 22.907962396469649
		 62 22.948159750398972 63 22.982381320465166 64 23.011221885641845 65 23.035128924688753
		 66 23.054694553751215 67 23.070244140548361 68 23.082305546560324 69 23.091324310152388
		 70 23.097671183573549 71 23.101697536280795 72 23.103818559090001 73 23.104335242773487
		 74 23.103654106141967 75 23.10206881245076 76 23.099962576571095 77 23.097679340240557
		 78 23.095547265729781 79 23.093967518697465 80 23.09334783771487;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAX";
	rename -uid "2DE6BA08-4F5F-E288-E26D-BCA71ACA0908";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 5.441642480203152e-006 2 2.8587652951350137e-006
		 3 0 4 -3.9454083104100277e-006 5 -2.5380449994526251e-006 6 3.2692671400182841e-006
		 7 -4.7800038129778841e-006 8 0 9 -3.6776803358305563e-006 10 7.2987212950793349e-005
		 11 -1.7968789195285386e-006 12 0 13 -4.6660757333788923e-006 14 -1.1410709242666534e-005
		 15 8.9233187247781161e-006 16 0 17 -2.7525754203944191e-006 18 -1.4554272910240793e-006
		 19 1.895758319773386e-022 20 4.6616656291126032e-006 21 0 22 6.4628949501541855e-006
		 23 0 24 -3.0187874417870739e-006 25 -3.5213758999679153e-006 26 0 27 0 28 0 29 7.7110463883576627e-006
		 30 2.924542842024408e-006 31 -2.6384797863021235e-006 32 0 33 0 34 0 35 2.146454916098936e-006
		 36 4.1535556211604918e-006 37 0 38 3.2006478778207896e-006 39 2.9509062873241532e-006
		 40 0 41 -6.6142184990616983e-006 42 1.573852512315395e-006 43 -2.1892179718998952e-006
		 44 0 45 0 46 -4.3183635026364783e-006 47 -5.9768027185983839e-006 48 -2.64401696670465e-006
		 49 1.6263348601258151e-006 50 6.3252148315719244e-006 51 5.9061820421535139e-006
		 52 2.3596236180851448e-006 53 2.3145621356633011e-006 54 -8.6169666744873208e-006
		 55 3.81354192242769e-006 56 4.6414785246242387e-006 57 0 58 1.6060798430316979e-006
		 59 -6.4255866536990458e-006 60 -7.5830332790935439e-022 61 2.6065611639849011e-006
		 62 -2.0928248269824944e-006 63 0 64 -2.8581412421027952e-006 65 3.791516639546772e-022
		 66 3.0332133116392878e-021 67 -2.078916302181837e-006 68 -1.6340372113758664e-006
		 69 -4.9951442911864511e-006 70 4.8093478190074401e-006 71 0 72 0 73 0 74 5.2109686079316328e-006
		 75 -7.3338482314166887e-006 76 -4.4895878801083163e-006 77 -1.1323701630652512e-005
		 78 2.7202022153997101e-006 79 0 80 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAY";
	rename -uid "38F361B8-4F61-3BD5-8655-95B86E1A129B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.6589927377810646e-006 1 2.5085529216615588e-006
		 2 7.9557453982037087e-005 3 0 4 8.8520777774006712e-005 5 -2.1472115040034705e-006
		 6 8.4301288902894342e-005 7 -4.9742789213936722e-006 8 -5.6952651633880024e-006 9 2.5505766860915584e-006
		 10 0.0001655692424943857 11 0 12 2.4998769998289959e-006 13 7.5293105987206139e-005
		 14 0 15 6.7792147761017984e-005 16 -4.2231629737532265e-006 17 -1.3513719840321492e-006
		 18 3.8684666575670368e-006 19 -2.5120157993182702e-006 20 3.8958860177584408e-006
		 21 2.0416023039525991e-006 22 5.3464908099129952e-006 23 1.2963750820420552e-006
		 24 2.0740560973380378e-006 25 1.8092059276540134e-006 26 3.3677669539692167e-006
		 27 -3.7396735722380317e-006 28 3.7559993931325504e-006 29 4.2864789546778212e-006
		 30 -5.9440666515003083e-006 31 -1.5195400271538805e-006 32 2.6417283247466772e-006
		 33 2.7312605289894492e-006 34 -2.9916865735283664e-006 35 3.9821346792011361e-006
		 36 2.1395760828799453e-006 37 -2.1300099952201505e-006 38 5.6371461671743279e-006
		 39 -3.2207899967553466e-006 40 0 41 -4.6285656095156255e-006 42 6.3646371532640901e-006
		 43 -3.8728294555416016e-006 44 4.442060079205053e-006 45 -1.7485941876132676e-006
		 46 7.9302601400690984e-006 47 2.7992988825507184e-006 48 6.4486815702767956e-006
		 49 -6.2015600707167765e-006 50 9.0153639612118236e-006 51 1.2744991315513447e-006
		 52 2.7018299540207076e-006 53 -1.220234834758225e-005 54 9.5084937560509307e-006
		 55 0.00010551678483321872 56 3.4195024038749456e-006 57 5.5869976717145777e-005 58 -1.287424284389817e-006
		 59 -3.7054385518346336e-006 60 7.285241760640988e-006 61 2.7531315114607914e-006
		 62 -3.1989955292829509e-006 63 -1.0471688899326763e-005 64 1.7658634307146078e-006
		 65 -7.1294723209373585e-006 66 6.3617152203845309e-005 67 2.666051019544051e-006
		 68 7.8675523548623483e-005 69 6.9695657109978087e-006 70 7.3978182366382306e-005
		 71 1.5367673553334137e-006 72 0 73 0 74 6.5045596407488293e-006 75 0 76 -6.8532413498365533e-006
		 77 8.167769675432772e-005 78 -4.0593842590380439e-006 79 -0.00011590533102809442
		 80 3.6589927377810663e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ";
	rename -uid "A11DC157-403B-B486-83F7-4ABCCFB15FDE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 30.934927579782283 1 30.935276824179997
		 2 30.934888161604722 3 30.934686098008203 4 30.934747924299909 5 30.934589598191206
		 6 30.934581517780238 7 30.935668708755209 8 30.93471176338716 9 30.93533345950279
		 10 30.934471590073759 11 30.93556476585589 12 30.935236492245117 13 30.935331839422286
		 14 30.934763384657607 15 30.935723890467159 16 30.935212824271524 17 30.934976870063352
		 18 30.934695505465498 19 30.934933886206487 20 30.93460799097732 21 30.934704279268402
		 22 30.934705749933066 23 30.934970540290823 24 30.934695355295805 25 30.935008337901689
		 26 30.934682631142497 27 30.934672899715402 28 30.93466845655135 29 30.934698181342473
		 30 30.934672512409158 31 30.935231681266849 32 30.934662088582993 33 30.93468897760777
		 34 30.934718183271315 35 30.934676043758188 36 30.934730725542483 37 30.934668689455943
		 38 30.934544429498377 39 30.934661581282537 40 30.934533056750805 41 30.934340312814125
		 42 30.934680575597497 43 30.934645934995707 44 30.934699389847481 45 30.934826233264161
		 46 30.934581553517429 47 30.935151572799352 48 30.934786423097037 49 30.934698707790115
		 50 30.934692562353728 51 30.934770537976082 52 30.935368376326789 53 30.934680522388604
		 54 30.934693372363704 55 30.934567672663018 56 30.935846968026159 57 30.934531668570457
		 58 30.934643535642415 59 30.935373795436938 60 30.93470729360951 61 30.935827567213206
		 62 30.934754399361456 63 30.935624834939834 64 30.9355766942444 65 30.934521035047315
		 66 30.934583886144672 67 30.934587411866715 68 30.93464216884302 69 30.935428785517139
		 70 30.934608965955885 71 30.93422857129006 72 30.935810849798969 73 30.935497678072142
		 74 30.934596567652004 75 30.934653262547219 76 30.934688882042465 77 30.934578200056141
		 78 30.935190154219871 79 30.935424822195909 80 30.934927579782283;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX";
	rename -uid "E8B93247-4B2E-51B7-D98C-0BB5BF4FEC63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.7327511245327498 1 2.6588633971285405
		 2 2.4628177572993497 3 2.1827858131997835 4 1.8581351276136848 5 1.5301925651301105
		 6 1.2419534410678037 7 1.037110053362833 8 0.95924271320243348 9 1.0598381115230577
		 10 1.3386060466262251 11 1.7597596109851543 12 2.2848069365779708 13 2.8724310865641121
		 14 3.480274164335897 15 4.068077799614966 16 4.6009884740509808 17 5.0516910008185736
		 18 5.4003910896966874 19 5.6584169054094673 20 5.8440933617816464 21 5.9526742442213694
		 22 6.0183667852316889 23 6.079201394730875 24 6.1351284511538795 25 6.1861824358058106
		 26 6.2323103533975202 27 6.2735070109713398 28 6.3097653841331267 29 6.3410764696618855
		 30 6.3673848360045806 31 6.3886534658582619 32 6.4048275561071835 33 6.4158194974428779
		 34 6.4215314423179546 35 6.4218000942715845 36 6.416463587388475 37 6.4053050061573336
		 38 6.3880732231151374 39 6.3644526131554464 40 6.3340660326956675 41 6.2965050332129762
		 42 6.2512813136297423 43 6.1858983071139289 44 6.0888370513068617 45 5.9607837561461201
		 46 5.7804496687222375 47 5.5283142668532737 48 5.2068177552847965 49 4.8199582375508419
		 50 4.3752839373709369 51 3.8847790178292496 52 3.3648168704172821 53 2.8348933850083378
		 54 2.3163206849080571 55 1.8303896034532996 56 1.3969466121742811 57 1.0334956649906826
		 58 0.75517918488180735 59 0.55125628976714591 60 0.40316547561574939 61 0.31338958972173142
		 62 0.28494990696003053 63 0.32102786233801367 64 0.4271564981731138 65 0.59713267998457165
		 66 0.81627307759882228 67 1.0692339186215651 68 1.340342926181266 69 1.6138075708338817
		 70 1.8740613148227276 71 2.1059291230702186 72 2.3074204433908081 73 2.4799358214296947
		 74 2.614294491036929 75 2.7015629743281782 76 2.7327447903021644 77 2.7327457979765732
		 78 2.7327462263491911 79 2.7327548585447827 80 2.7327511245327498;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY";
	rename -uid "E6BFFDD6-4303-BFBC-0D28-7FA2764D8786";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.0306789089568511 1 -6.0831458473115019
		 2 -6.2165122790548191 3 -6.3928097608595724 4 -6.5772761488647387 5 -6.7428983039568919
		 6 -6.8720526792450505 7 -6.9548141528204459 8 -6.9843498888859159 9 -6.953170479048997
		 10 -6.8559816008581418 11 -6.6790644446848306 12 -6.406412863096163 13 -6.0282084977985848
		 14 -5.5468510283753059 15 -4.9803824521237772 16 -4.3636771187804904 17 -3.7470061437780759
		 18 -3.1928247801780754 19 -2.7286925699803719 20 -2.3638144212508156 21 -2.1390630765131258
		 22 -2.0001067554198215 23 -1.8670910849056026 24 -1.740811362723623 25 -1.622077906466372
		 26 -1.5117586136702332 27 -1.4106272484036539 28 -1.3195314477911495 29 -1.2392242628040893
		 30 -1.1704704390468395 31 -1.1140378784489546 32 -1.0706243817035985 33 -1.0408699236611501
		 34 -1.0254827419812771 35 -1.0249728933479327 36 -1.039895414852154 37 -1.0707102614197674
		 38 -1.1178387425421581 39 -1.1816329742615082 40 -1.2623439265953524 41 -1.3601439465176697
		 42 -1.4751453221553605 43 -1.6365103174363798 44 -1.8657697891918996 45 -2.1509101288509984
		 46 -2.5205981670665829 47 -2.9870462397851614 48 -3.5127383478687135 49 -4.0614847003965497
		 50 -4.6008382603019369 51 -5.1038804322363394 52 -5.5508098698189103 53 -5.9298637364740934
		 54 -6.2374382997839932 55 -6.4777503452741385 56 -6.661191392773242 57 -6.8023003392834935
		 58 -6.9165152791164912 59 -7.0121922878860747 60 -7.0897650969594626 61 -7.1499026118269713
		 62 -7.1917482497450536 63 -7.212927127478368 64 -7.2085388438045346 65 -7.1761380763423226
		 66 -7.1157509575124331 67 -7.028232142570479 68 -6.916343883327662 69 -6.7850369911256614
		 70 -6.6418126083760711 71 -6.4965149868892018 72 -6.3569300282661478 73 -6.2299443042359632
		 74 -6.1260570234785598 75 -6.0561214783577171 76 -6.0306743379278842 77 -6.0306825399271622
		 78 -6.0306901109139872 79 -6.0306700848554007 80 -6.0306789089568511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ";
	rename -uid "7679523B-4FB1-09C9-642D-FCAC74B5A7BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.9064865746532611 1 -8.4811845062412949
		 2 -7.359125923583659 3 -5.770836590771772 4 -3.9474750655216422 5 -2.1215190889009596
		 6 -0.52673452878763938 7 0.60229182769872158 8 1.0307550206674243 9 0.40917215784036493
		 10 -1.3058911201109513 11 -3.8888498380800125 12 -7.1130213445044994 13 -10.751442980988777
		 14 -14.57775395885845 15 -18.367552442271926 16 -21.899461869891308 17 -24.955706102608861
		 18 -27.321927454348572 19 -29.094969849617776 20 -30.456993047035169 21 -31.323749233912025
		 22 -31.895582202151882 23 -32.428794893168714 24 -32.922603164465393 25 -33.37615569198163
		 26 -33.788663080365666 27 -34.159283427240652 28 -34.487176958664847 29 -34.771548447511535
		 30 -35.011563363598398 31 -35.206411738648725 32 -35.355225389562172 33 -35.457146734872467
		 34 -35.511364277427475 35 -35.516932148951682 36 -35.472967536340335 37 -35.378682060167343
		 38 -35.233063840149832 39 -35.035153910642713 40 -34.784042002743554 41 -34.478726137631412
		 42 -34.118201153019477 43 -33.614759444578063 44 -32.897502760324961 45 -31.990400606961462
		 46 -30.63241663577562 47 -28.622099328208552 48 -26.072967878793413 49 -23.099211345522708
		 50 -19.81615786705364 51 -16.340584031900697 52 -12.790921949497987 53 -9.2869475635169252
		 54 -5.9496104085074295 55 -2.9004629556001467 56 -0.26134958452295387 57 1.8461375813441383
		 58 3.30065016561143 59 4.2049622543320933 60 4.7475874691210542 61 4.9360422784527538
		 62 4.7780772682875776 63 4.281521849562802 64 3.444455210841233 65 2.3153645156725213
		 66 0.97795309321404367 67 -0.48403005050069497 68 -1.9869372783179837 69 -3.4472929425976924
		 70 -4.7819794306687227 71 -5.9082439938899292 72 -6.8566268160433657 73 -7.6797569421841914
		 74 -8.3284841026179137 75 -8.7537714836292988 76 -8.9064795709460665 77 -8.9064726690222926
		 78 -8.9064701123128529 79 -8.9064613018838834 80 -8.9064865746532611;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX";
	rename -uid "36AF2642-4E10-EA40-36CA-0DA0A211C9E2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.2080861726087564 1 3.1387146768343155
		 2 2.9541763193296844 3 2.6894223753544573 4 2.3808778441467475 5 2.0675498056912969
		 6 1.7908073687320525 7 1.593404242119449 8 1.5182021674649788 9 1.6159317620285021
		 10 1.8858340572534256 11 2.2911162562218679 12 2.7921684019813782 13 3.3470547663218788
		 14 3.9137926329521799 15 4.4538060825155057 16 4.9351886276105885 17 5.334810544674685
		 18 5.6379206206783499 19 5.8579590575148028 20 6.0138593119899886 21 6.1041406661975284
		 22 6.1585477240606412 23 6.2085629606493198 24 6.2542304818829217 25 6.2956383348775695
		 26 6.3328211974527315 27 6.3658353565127666 28 6.3947213424194302 29 6.4195132478036019
		 30 6.4402792581489061 31 6.4569795877194407 32 6.4696498823308399 33 6.4782382777932535
		 34 6.4826882903663856 35 6.4829167685852118 36 6.4787862697058127 37 6.4701253769042175
		 38 6.4567092853539201 39 6.4382483632657976 40 6.4143883605926488 41 6.3847443976030958
		 42 6.3488141631408928 43 6.2965045639432704 44 6.2180454011098751 45 6.1131650037525285
		 46 5.9629517851307545 47 5.7489436389082371 48 5.4706174403509849 49 5.1291202851617719
		 50 4.7293451319540587 51 4.2811329991906417 52 3.7990673618342283 53 3.3017077234616354
		 54 2.8099051074042198 55 2.3451798549748522 56 1.9281564889618625 57 1.5774195437889924
		 58 1.3093510537807898 59 1.1138974808231232 60 0.97260026141602962 61 0.88803431533280708
		 62 0.86307249345462977 63 0.90079502411785628 64 1.0061741373142188 65 1.1729305128930378
		 66 1.3864020081761599 67 1.6313819451573428 68 1.8924405498811627 69 2.1542830896104039
		 70 2.4019906851449342 71 2.6212542766904985 72 2.8106938123378247 73 2.9723075447483347
		 74 3.097770776087625 75 3.1790779196382317 76 3.2080918001529808 77 3.2080910370825539
		 78 3.2080749446763108 79 3.2080745531389572 80 3.2080861726087564;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY";
	rename -uid "3A0C8CAD-4276-6180-1A0D-39A407B410D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.7924479629026067 1 -5.8506943937163305
		 2 -5.9993153539414381 3 -6.1974220102333728 4 -6.4072374705758612 5 -6.5985995687913936
		 6 -6.7504094055126522 7 -6.8492960071529856 8 -6.8849559379314469 9 -6.8458273413043962
		 10 -6.7266457441487226 11 -6.5165598894634797 12 -6.2027908889860974 13 -5.778851916027298
		 14 -5.2504364425053813 15 -4.6388799261918132 16 -3.9815768326054339 17 -3.3309363769297571
		 18 -2.750704066790727 19 -2.2675042916920947 20 -1.8889997128574612 21 -1.6562860760213378
		 22 -1.5125777865640266 23 -1.3751284673441426 24 -1.2447525223736635 25 -1.1223645475749355
		 26 -1.0087089461690046 27 -0.90463742533656477 28 -0.81092892866299804 29 -0.72839552434195143
		 30 -0.65778308808963359 31 -0.59982674780792333 32 -0.55525184394124782 33 -0.52475792153204448
		 34 -0.50892722108010435 35 -0.50838670637825412 36 -0.52367135429973055 37 -0.55529235339323912
		 38 -0.603658511767169 39 -0.66914089784770758 40 -0.75200379631417413 41 -0.85250043301528877
		 42 -0.97073488711887168 43 -1.136801553192696 44 -1.3730169440818467 45 -1.6674914104133749
		 46 -2.0503562297929214 47 -2.5353830764205578 48 -3.0850282335521491 49 -3.6629053463632411
		 50 -4.2359853419826026 51 -4.7765649454055943 52 -5.2636211429163602 53 -5.683789273796549
		 54 -6.0318934869620362 55 -6.3102668242577904 56 -6.527822954926596 57 -6.6975732546942632
		 58 -6.8336975513660345 59 -6.945395726678556 60 -7.0345719709333991 61 -7.1017002322858866
		 62 -7.1457229931162907 63 -7.163941353503045 64 -7.1510532584678934 65 -7.1051237009989965
		 66 -7.0273758345973247 67 -6.919886756497867 68 -6.7866628272073557 69 -6.6338842769767137
		 70 -6.4703151223694526 71 -6.3069329855124554 72 -6.1517013584576734 73 -6.0113234754720253
		 74 -5.8970177379869684 75 -5.8203481033119386 76 -5.7924614096121223 77 -5.7924539773826851
		 78 -5.7924488278372932 79 -5.7924656890930208 80 -5.7924479629026067;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ";
	rename -uid "DFFDF2C8-4AD5-0B4A-F4F1-B0A77CDC6FC9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.9248389169076816 1 -8.5003038039790955
		 2 -7.3802121563567322 3 -5.79455448306389 4 -3.9739793922968336 5 -2.1505816272149327
		 6 -0.55778395594010943 7 0.56996799219867944 8 0.99795372546010419 9 0.37689710010026017
		 10 -1.3365559031300547 11 -3.9165845480135304 12 -7.1364527294015554 13 -10.769168974315836
		 14 -14.588628324070909 15 -18.371046270456805 16 -21.895728228956717 17 -24.945577812805123
		 18 -27.306788070155001 19 -29.076145433505605 20 -30.435572744686823 21 -31.30081229361436
		 22 -31.871791467810649 23 -32.404244270692061 24 -32.89734543202897 25 -33.35022637650529
		 26 -33.762159102634193 27 -34.132258037795616 28 -34.459735284810115 29 -34.743754362307442
		 30 -34.983496888270636 31 -35.1780619561629 32 -35.326708777442654 33 -35.428505047040744
		 34 -35.482645448602476 35 -35.488206548793485 36 -35.44437171473156 37 -35.35017431263865
		 38 -35.204715284163385 39 -35.00711573054717 40 -34.756339955688127 41 -34.451470001536983
		 42 -34.091468738556827 43 -33.588854164402683 44 -32.872814670141445 45 -31.967439593700266
		 46 -30.611975669341589 47 -28.605185573581689 48 -26.060644613524229 49 -23.092323542470414
		 50 -19.815283577828687 51 -16.346009215771581 52 -12.802415525053133 53 -9.304017116236281
		 54 -5.9714500724308479 55 -2.9261799945922702 56 -0.29002548253081545 57 1.8152527035648474
		 58 3.26810801238992 59 4.1711533853248328 60 4.7127549355955853 61 4.9005081388663791
		 62 4.7420728846181612 63 4.2453434114287276 64 3.4084918780259281 65 2.2799890263370197
		 66 0.94358774546000579 67 -0.51700320941493894 68 -2.0181589332135368 69 -3.4765000758813076
		 70 -4.8090292096834935 71 -5.9331526566018988 72 -6.8795373984468684 73 -7.7008676965036358
		 74 -8.3481647502460952 75 -8.7724801999467044 76 -8.9248463650026792 77 -8.9248484274362259
		 78 -8.9248291389136121 79 -8.9248416729939173 80 -8.9248389169076816;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX";
	rename -uid "CA7E6B1F-4ECF-7A53-EE3D-73AF2067FACA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.064639052844944617 1 -0.024377552464631976
		 2 -0.25817004534648136 3 -0.58629953666457146 4 -0.95851759427671357 5 -1.3259681643926031
		 6 -1.6421866693131193 7 -1.8631864727829195 8 -1.9464095593030768 9 -1.8417367786112111
		 10 -1.5472872411249359 11 -1.0900091657337567 12 -0.49849071363035008 13 0.19353245983314368
		 14 0.94625717955479427 15 1.7152489330617871 16 2.4541655148863177 17 3.1173496746415847
		 18 3.6613446952305022 19 4.085468324157282 20 4.402970235132984 21 4.5931570730922102
		 22 4.7093885622563052 23 4.818748698790781 24 4.9208946426344591 25 5.0154801472125179
		 26 5.1021678984949785 27 5.1806220215382721 28 5.2505135012564326 29 5.3115049586251732
		 30 5.3632613421048632 31 5.405453688039163 32 5.4377213239091802 33 5.4597565768201273
		 34 5.4711735695144084 35 5.4716264298914501 36 5.4607484263900874 37 5.4381347121750281
		 38 5.4033879498707789 39 5.3560902787567706 40 5.2957857252684226 41 5.2220182526851433
		 42 5.1342896686996324 43 5.0094090780623528 44 4.8281378344663377 45 4.5958071454037714
		 46 4.2813765745392542 47 3.861830777075026 48 3.3544450786649573 49 2.7774581642793414
		 50 2.1509962403275429 51 1.4970821404917853 52 0.83886244267207555 53 0.19921860739754321
		 54 -0.40076228941434061 55 -0.94329439876942256 56 -1.4144882765193372 57 -1.8042837285631013
		 58 -2.1051861962063714 59 -2.3305163324421807 60 -2.4974381571087747 61 -2.6039680423716427
		 62 -2.6470224170009882 63 -2.6227020110403174 64 -2.5240012899596613 65 -2.355515574673086
		 66 -2.1306646931275179 67 -1.8638002891493843 68 -1.5703136680037133 69 -1.2667125793621674
		 70 -0.97028707262563307 71 -0.6989070197873074 72 -0.45763116452242752 73 -0.24797961190933235
		 74 -0.082658504619835413 75 0.025733208996811387 76 0.06464184087036498 77 0.064652697023427713
		 78 0.064657105484314623 79 0.064650109285580071 80 0.064639052844944617;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY";
	rename -uid "7A87B18E-4910-DEC5-CC7C-4D96AC52990C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.618552830983929 1 -6.6367915295644764
		 2 -6.6798547815424785 3 -6.7283412995017748 4 -6.7663476956226267 5 -6.7858035293701304
		 6 -6.7879331878144242 7 -6.7811863336626637 8 -6.7768667021349991 9 -6.7888298881739901
		 10 -6.8121350361454747 11 -6.8198157979927165 12 -6.7818311881447144 13 -6.6725124539720957
		 14 -6.4769170346784497 15 -6.1952542446098784 16 -5.8453390846417141 17 -5.4621301100685713
		 18 -5.0949032940442178 19 -4.7735484294515764 20 -4.5139369948954844 21 -4.3516746950683958
		 22 -4.2507754287386534 23 -4.1533121773590915 24 -4.0600689127387399 25 -3.9717701979819293
		 26 -3.8892068869469272 27 -3.8131020111773113 28 -3.7441635873625581 29 -3.6831384905116238
		 30 -3.6306943587788387 31 -3.5875162944261039 32 -3.5542063278533811 33 -3.531357026690749
		 34 -3.5195240406314019 35 -3.5191709743096502 36 -3.5307106725976305 37 -3.5544804708803146
		 38 -3.5907700620315572 39 -3.6397525939297357 40 -3.7015105373976369 41 -3.776053756832376
		 42 -3.8632633569748496 43 -3.9848701702534659 44 -4.1559661754183752 45 -4.3657819883353648
		 46 -4.6319709855875235 47 -4.9578680215629447 48 -5.3099987176595196 49 -5.6568177392053869
		 50 -5.9715659806320351 51 -6.2344868471480623 52 -6.4340614101903988 53 -6.5674605856600952
		 54 -6.6400299149993147 55 -6.6641848073006686 56 -6.6575124434047179 57 -6.6403001444305341
		 58 -6.6327695675802394 59 -6.6382466974557932 60 -6.6495931380063009 61 -6.6684835864619236
		 62 -6.6953279581147722 63 -6.7291837220296609 64 -6.7678385226925055 65 -6.8065473493196889
		 66 -6.839471904865186 67 -6.8612250179637693 68 -6.8679766315869415 69 -6.8579727173849525
		 70 -6.8317868435337292 71 -6.7922459997638525 72 -6.7456992005673184 73 -6.6990107170728201
		 74 -6.6580888939451439 75 -6.6292767403201047 76 -6.6185439672918864 77 -6.618544513097409
		 78 -6.6185479276284838 79 -6.6185250825541573 80 -6.618552830983929;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ";
	rename -uid "BEF2EDDD-48F4-18A5-D522-D08397A2425F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.7662343333443005 1 -8.3384678375651085
		 2 -7.2103028598839289 3 -5.6144439798867634 4 -3.7840445333951882 5 -1.9527509883310588
		 6 -0.35474801001981915 7 0.77571119922124121 8 1.2045474626846775 9 0.58278790713055784
		 10 -1.1336148301886437 11 -3.7211917729253661 12 -6.9556041130388264 13 -10.611438365551242
		 14 -14.462636505326433 15 -18.283410659144042 16 -21.849373163525847 17 -24.939100491356296
		 18 -27.334263057365941 19 -29.130489055157522 20 -30.509961982165397 21 -31.387117226207263
		 22 -31.965275144697294 23 -32.504499666845831 24 -33.003852938410652 25 -33.462498758481708
		 26 -33.879712250861196 27 -34.254526465706981 28 -34.586176126238058 29 -34.87382042102751
		 30 -35.116573024409675 31 -35.313646496575423 32 -35.464134480048521 33 -35.567248777485958
		 34 -35.622048732328373 35 -35.627638148654285 36 -35.583161429535657 37 -35.487663189042664
		 38 -35.340182922437648 39 -35.139769965426936 40 -34.885438004706629 41 -34.576146580540787
		 42 -34.210884201033139 43 -33.700689934861181 44 -32.973534858744642 45 -32.053666221212737
		 46 -30.678375662204079 47 -28.645115607333238 48 -26.068810280002545 49 -23.065442628821256
		 50 -19.752511293741197 51 -16.248903404938165 52 -12.674881719232898 53 -9.1515128922655613
		 54 -5.8001380377185372 55 -2.7419653220077831 56 -0.097767953164432375 57 2.0122477511761456
		 58 3.4682929463688588 59 4.3739140478201683 60 4.9176711242565281 61 5.1073541348696043
		 62 4.9508325481059465 63 4.4559696912646993 64 3.6206280133018156 65 2.4929026504330385
		 66 1.1560397809953089 67 -0.30663612382641181 68 -1.8117045481065082 69 -3.275725025832839
		 70 -4.6153050916322593 71 -5.7472254428376566 72 -6.7014919655993062 73 -7.530258913828126
		 74 -8.1837624737475121 75 -8.6123282343046696 76 -8.7662414926310976 77 -8.7662284790179061
		 78 -8.7662252667777008 79 -8.7662220276701337 80 -8.7662343333443005;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA";
	rename -uid "48E45E9B-4A57-ACF0-234B-D28BA88F48F8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.0677757263183594 1 6.0672531127929687
		 2 6.0658187866210937 3 6.0637054443359375 4 6.0611171722412109 5 6.0582695007324219
		 6 6.0553493499755859 7 6.052459716796875 8 6.0497474670410156 9 6.0472126007080078
		 10 6.0449733734130859 11 6.0430755615234375 12 6.0415973663330078 13 6.0405368804931641
		 14 6.0389518737792969 15 6.0363197326660156 16 6.0333347320556641 17 6.0304622650146484
		 18 6.0280609130859375 19 6.0263576507568359 20 6.0222835540771484 21 6.0179195404052734
		 22 6.013946533203125 23 6.0101966857910156 24 6.006561279296875 25 6.0029449462890625
		 26 5.9992771148681641 27 5.9957942962646484 28 5.9928340911865234 29 5.9905471801757812
		 30 5.9890270233154297 31 5.9884223937988281 32 5.9883136749267578 33 5.9882011413574219
		 34 5.9881076812744141 35 5.9880485534667969 36 5.9880352020263672 37 5.9880714416503906
		 38 5.9882469177246094 39 5.9885673522949219 40 5.9889373779296875 41 5.98931884765625
		 42 5.9895820617675781 43 5.9897193908691406 44 5.9896373748779297 45 5.9892520904541016
		 46 5.9883060455322266 47 5.9866600036621094 48 5.9844303131103516 49 5.9757041931152344
		 50 5.9653835296630859 51 5.9569797515869141 52 5.9495906829833984 53 5.9445819854736328
		 54 5.9431972503662109 55 5.9462070465087891 56 5.9537982940673828 57 5.9654960632324219
		 58 5.9802570343017578 59 5.9967365264892578 60 6.0135154724121094 61 6.0289649963378906
		 62 6.0417957305908203 63 6.0515060424804687 64 6.0577850341796875 65 6.0616626739501953
		 66 6.0646076202392578 67 6.0667495727539062 68 6.0682201385498047 69 6.0691680908203125
		 70 6.0696525573730469 71 6.0698604583740234 72 6.0698051452636719 73 6.0695972442626953
		 74 6.069305419921875 75 6.0689620971679687 76 6.0686283111572266 77 6.0683021545410156
		 78 6.0680484771728516 79 6.0678501129150391 80 6.0677757263183594;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA";
	rename -uid "0A691BB4-4408-BA2D-140B-4B90563BF721";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 44.421516418457031 1 44.400634765625 2 44.343551635742188
		 3 44.259208679199219 4 44.156646728515625 5 44.044235229492188 6 43.929107666015625
		 7 43.816875457763672 8 43.711563110351563 9 43.615947723388672 10 43.532047271728516
		 11 43.462081909179688 12 43.406257629394531 13 43.361083984375 14 43.287445068359375
		 15 43.159843444824219 16 42.993274688720703 17 42.796768188476562 18 42.577770233154297
		 19 42.341697692871094 20 42.069278717041016 21 41.779708862304688 22 41.480323791503906
		 23 41.172252655029297 24 40.857231140136719 25 40.537868499755859 26 40.216205596923828
		 27 39.912052154541016 28 39.649726867675781 29 39.438350677490234 30 39.287086486816406
		 31 39.205162048339844 32 39.164577484130859 33 39.130947113037109 34 39.104076385498047
		 35 39.083717346191406 36 39.069648742675781 37 39.061676025390625 38 39.060165405273437
		 39 39.064888000488281 40 39.074592590332031 41 39.088077545166016 42 39.104148864746094
		 43 39.121616363525391 44 39.139266967773438 45 39.155887603759766 46 39.167808532714844
		 47 39.172454833984375 48 39.170181274414063 49 39.121849060058594 50 39.1177978515625
		 51 39.190135955810547 52 39.289581298828125 53 39.431133270263672 54 39.630214691162109
		 55 39.899326324462891 56 40.244930267333984 57 40.665245056152344 58 41.149436950683594
		 59 41.678962707519531 60 42.231227874755859 61 42.762725830078125 62 43.227748870849609
		 63 43.597648620605469 64 43.844646453857422 65 44.005706787109375 66 44.135612487792969
		 67 44.237945556640625 68 44.316272735595703 69 44.374073028564453 70 44.414634704589844
		 71 44.441001892089844 72 44.455955505371094 73 44.462059020996094 74 44.461502075195313
		 75 44.456333160400391 76 44.448345184326172 77 44.439239501953125 78 44.430618286132813
		 79 44.424118041992188 80 44.421516418457031;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA";
	rename -uid "C77D92FE-4741-89FD-C763-808D8B71507C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145320892333984 1 -17.167936325073242
		 2 -17.226547241210938 3 -17.307460784912109 4 -17.396984100341797 5 -17.481132507324219
		 6 -17.545497894287109 7 -17.575260162353516 8 -17.555261611938477 9 -17.470069885253906
		 10 -17.304155349731445 11 -17.041976928710937 12 -16.67677116394043 13 -16.216758728027344
		 14 -15.671659469604492 15 -14.983660697937012 16 -14.1163330078125 17 -13.112546920776367
		 18 -12.015179634094238 19 -10.867301940917969 20 -9.7275428771972656 21 -8.6297054290771484
		 22 -7.6130199432373047 23 -6.7198405265808105 24 -5.9614567756652832 25 -5.3207969665527344
		 26 -4.7974891662597656 27 -4.3682928085327148 28 -4.0055866241455078 29 -3.7025582790374756
		 30 -3.4523653984069824 31 -3.2481505870819092 32 -3.0844404697418213 33 -2.9559941291809082
		 34 -2.8562743663787842 35 -2.7787666320800781 36 -2.716923713684082 37 -2.6642189025878906
		 38 -2.599022388458252 39 -2.5165138244628906 40 -2.4356074333190918 41 -2.3751606941223145
		 42 -2.3540389537811279 43 -2.3911280632019043 44 -2.5052556991577148 45 -2.7152538299560547
		 46 -3.0977897644042969 47 -3.6968982219696045 48 -4.4822549819946289 49 -5.4581475257873535
		 50 -6.5689091682434082 51 -7.8211030960083008 52 -9.2307872772216797 53 -10.743284225463867
		 54 -12.305522918701172 55 -13.865259170532227 56 -15.370595932006836 57 -16.769535064697266
		 58 -18.009235382080078 59 -19.035514831542969 60 -19.792362213134766 61 -20.280160903930664
		 62 -20.519584655761719 63 -20.585422515869141 64 -20.57684326171875 65 -20.500772476196289
		 66 -20.363693237304687 67 -20.174699783325195 68 -19.942924499511719 69 -19.677543640136719
		 70 -19.38775634765625 71 -19.082708358764648 72 -18.771554946899414 73 -18.463396072387695
		 74 -18.167264938354492 75 -17.892169952392578 76 -17.647090911865234 77 -17.440952301025391
		 78 -17.282678604125977 79 -17.181148529052734 80 -17.145320892333984;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX";
	rename -uid "14CBA6CB-431C-18BD-BD5A-45ADCBDDAD3B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 -5.412473787235632e-006 2 4.4027556969844681e-006
		 3 4.0597375520417292e-006 4 -4.7759094886317663e-006 5 -5.0165228568744074e-006 6 1.9479520704692827e-009
		 7 1.2834556967744317e-008 8 -6.2042817696773233e-009 9 -3.7822610825985362e-006 10 1.9661323363602991e-006
		 11 -1.3100975814321327e-006 12 -5.5116150686168881e-006 13 -1.0405636601305983e-008
		 14 -3.7522190076269766e-006 15 -4.8983711033325022e-006 16 -1.3567035727445148e-008
		 17 3.2540717746652298e-006 18 -2.9224453000211425e-006 19 -1.727569007705825e-006
		 20 4.4023340756858135e-009 21 2.8100126819143263e-006 22 -4.1906981205566382e-006
		 23 -4.0293406892339041e-006 24 -6.9006110755308958e-009 25 -5.8856823982610066e-006
		 26 1.4244388041675052e-006 27 4.7578728380789355e-009 28 -3.6322954335925073e-008
		 29 -5.0929503619752856e-006 30 -4.3338229487504758e-009 31 4.6600535777467825e-006
		 32 -2.2902820606960163e-006 33 -3.9956130846205871e-006 34 -4.7809021985213166e-006
		 35 -1.2827140868816013e-006 36 -4.43946988347056e-009 37 -5.7042279798416002e-009
		 38 -4.513334018513889e-006 39 2.1717371576937703e-006 40 -4.298528009792538e-008
		 41 4.0311708463957194e-006 42 2.1694221449193291e-006 43 1.9443637827722709e-006
		 44 2.4282514603447117e-006 45 2.2749286953487299e-006 46 -5.3166371140865586e-008
		 47 -1.402251505287666e-006 48 -1.0793204918452984e-009 49 4.4856602796743531e-006
		 50 -2.3261147443663137e-010 51 -1.8302284982602436e-006 52 2.6801975893877152e-006
		 53 2.3762069836318699e-006 54 2.1544483880139331e-006 55 2.6587279712461482e-006
		 56 2.6671404556408361e-006 57 -9.3147184564491961e-009 58 2.4197824890007458e-006
		 59 -5.4862175540929898e-006 60 -1.4919399878321128e-006 61 -1.69441673147385e-006
		 62 4.2891593041849784e-008 63 -2.9090879013013149e-008 64 3.0284609364282298e-006
		 65 -8.7318505715578152e-009 66 -5.3865436178568028e-006 67 1.2826419051521945e-006
		 68 -1.2817805820236858e-006 69 2.3190318680490931e-008 70 -2.5032037765604717e-006
		 71 5.5493022653191601e-009 72 -9.2799046285402396e-009 73 1.6588883556898693e-006
		 74 -2.1261402137996998e-006 75 -1.8687489730055482e-006 76 2.1045715098356565e-006
		 77 -2.6148232185554678e-006 78 -5.3358118459185339e-006 79 -1.5235120737862195e-010
		 80 0;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY";
	rename -uid "99546370-463C-0635-8A05-009F27ECB9D8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.737105422408931 1 18.737108350816687
		 2 18.737108888515802 3 18.737110386136916 4 18.737107993423315 5 18.737110594737494
		 6 18.737106843404355 7 18.737112171574672 8 18.737105095444136 9 18.737109037957495
		 10 18.737107609561019 11 18.737105533069769 12 18.737105115478201 13 18.737107984348349
		 14 18.737111669905751 15 18.737105057172997 16 18.737106903901925 17 18.73710512953204
		 18 18.737111903588982 19 18.737114763291096 20 18.737102094147023 21 18.737107194214055
		 22 18.737108394892239 23 18.737106881043943 24 18.737106297264511 25 18.737107654937585
		 26 18.737108775553242 27 18.737103866179314 28 18.73711366351365 29 18.737106299462553
		 30 18.737108211423966 31 18.737108243169661 32 18.737110114689564 33 18.737107574627547
		 34 18.737110744827248 35 18.737111316852857 36 18.737107380260166 37 18.737109792836133
		 38 18.737108724367801 39 18.737111138658555 40 18.73710930220205 41 18.737108758760019
		 42 18.737109091727891 43 18.737112101506398 44 18.737107558649129 45 18.737111515208539
		 46 18.737108399780894 47 18.737110852986635 48 18.737103946223048 49 18.737109834206066
		 50 18.737111810791436 51 18.737102802929673 52 18.737109301892101 53 18.737100813139126
		 54 18.737107092406976 55 18.73710672486208 56 18.737108380831199 57 18.737108776696552
		 58 18.737110362746872 59 18.737098833723461 60 18.737107604687306 61 18.737111211636464
		 62 18.73710396798155 63 18.737108675894113 64 18.737101594819304 65 18.737104896928599
		 66 18.737107201623402 67 18.737105661227993 68 18.737108641174391 69 18.737107899245903
		 70 18.737097913769706 71 18.737108264345107 72 18.73710072391458 73 18.737105282595849
		 74 18.737108583237493 75 18.737109038663455 76 18.737104508431525 77 18.737108211209051
		 78 18.737107127294024 79 18.737106836634638 80 18.737105422408931;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ";
	rename -uid "C52BC2C8-488D-CC96-F505-2F910F08128E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0.25992104214274797 2 0.9726252522077069
		 3 2.0374781489775038 4 3.3538666748863371 5 4.8211845058760563 6 6.3388114208693276
		 7 7.8061310107656494 8 9.1225212135554337 9 10.187372386474751 10 10.900072810715329
		 11 11.159995172530067 12 10.929819985633811 13 10.279262994541428 14 9.2682431708777688
		 15 7.9567174171911024 16 6.4046085112226319 17 4.6718486678893658 18 2.818375685556449
		 19 0.90412012063982716 20 -1.0109731028339872 21 -2.8669694089135906 22 -4.6039502872799805
		 23 -6.1619630831185237 24 -7.4810761372734662 25 -8.501368616364644 26 -9.1628783074883486
		 27 -9.6027771545133653 28 -9.9991549055931017 29 -10.353477732218803 30 -10.667212297600217
		 31 -10.941855015174397 32 -11.17887802758726 33 -11.379742946939485 34 -11.545933232603398
		 35 -11.678920458058991 36 -11.780188245048395 37 -11.851205514511607 38 -11.89344604032334
		 39 -11.908379016684362 40 -11.897498272129175 41 -11.862261670261269 42 -11.804155806566227
		 43 -11.724647336763676 44 -11.625222585209636 45 -11.507345573472122 46 -11.372498679137141
		 47 -11.222144117283895 48 -11.057774537759839 49 -10.880852841217852 50 -10.692870741794714
		 51 -9.9954209612061327 52 -8.4292372993248037 53 -6.2044486116922517 54 -3.5311839969263898
		 55 -0.6195563712557477 56 2.3202789684626821 57 5.0782024348234893 58 7.4440970691970012
		 59 9.2078191820763546 60 10.159254635119684 61 10.514495629352485 62 10.644680047611731
		 63 10.572157319923614 64 10.319300636817891 65 9.9084790009841477 66 9.3620536868633977
		 67 8.7024070688538266 68 7.9518787148920858 69 7.1328693588836627 70 6.2677230559792232
		 71 5.3788220806313278 72 4.4885115842070382 73 3.6191847063579394 74 2.7931976345893097
		 75 2.0329202801153698 76 1.3607164871381687 77 0.7989534962441216 78 0.36999993672432913
		 79 0.096226674967121964 80 0;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "00FE7A3E-4193-6BC0-EDF1-038B8DA76A93";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 24.701837539672852 1 24.702201843261719
		 2 24.703212738037109 3 24.704727172851563 4 24.706624984741211 5 24.708744049072266
		 6 24.710981369018555 7 24.713253021240234 8 24.715522766113281 9 24.717750549316406
		 10 24.719953536987305 11 24.722179412841797 12 24.724498748779297 13 24.727056503295898
		 14 24.730813980102539 15 24.736785888671875 16 24.745162963867188 17 24.755962371826172
		 18 24.769083023071289 19 24.784347534179688 20 24.801401138305664 21 24.819774627685547
		 22 24.838882446289063 23 24.858062744140625 24 24.876861572265625 25 24.895172119140625
		 26 24.912836074829102 27 24.929134368896484 28 24.943408966064453 29 24.955268859863281
		 30 24.964338302612305 31 24.970211029052734 32 24.973966598510742 33 24.977027893066406
		 34 24.979410171508789 35 24.98126220703125 36 24.982662200927734 37 24.983684539794922
		 38 24.984640121459961 39 24.98558235168457 40 24.986324310302734 41 24.986625671386719
		 42 24.986284255981445 43 24.985092163085938 44 24.982826232910156 45 24.979314804077148
		 46 24.973670959472656 47 24.965499877929688 48 24.955356597900391 49 24.943815231323242
		 50 24.928939819335938 51 24.910415649414063 52 24.890293121337891 53 24.869396209716797
		 54 24.848400115966797 55 24.827945709228516 56 24.808528900146484 57 24.790481567382812
		 58 24.773853302001953 59 24.75885009765625 60 24.74517822265625 61 24.733110427856445
		 62 24.723098754882813 63 24.71539306640625 64 24.710384368896484 65 24.707118988037109
		 66 24.704498291015625 67 24.702447891235352 68 24.700874328613281 69 24.699760437011719
		 70 24.699033737182617 71 24.698657989501953 72 24.698593139648437 73 24.698785781860352
		 74 24.699172973632813 75 24.699672698974609 76 24.700263977050781 77 24.700843811035156
		 78 24.701356887817383 79 24.701702117919922 80 24.701837539672852;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "A08839F3-4909-65E3-CB2D-4AA5D6A21E57";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.987054824829102 1 16.984071731567383
		 2 16.976325988769531 3 16.965513229370117 4 16.953487396240234 5 16.942022323608398
		 6 16.933162689208984 7 16.928934097290039 8 16.931434631347656 9 16.942781448364258
		 10 16.964956283569336 11 16.999723434448242 12 17.047300338745117 13 17.105770111083984
		 14 17.173166275024414 15 17.25535774230957 16 17.353992462158203 17 17.460832595825195
		 18 17.568332672119141 19 17.669981002807617 20 17.760875701904297 21 17.837966918945313
		 22 17.899940490722656 23 17.947063446044922 24 17.981864929199219 25 18.007579803466797
		 26 18.02659797668457 27 18.040184020996094 28 18.04998779296875 29 18.056844711303711
		 30 18.061389923095703 31 18.064098358154297 32 18.065675735473633 33 18.066768646240234
		 34 18.067510604858398 35 18.067998886108398 36 18.068349838256836 37 18.068580627441406
		 38 18.068758010864258 39 18.068883895874023 40 18.068914413452148 41 18.068857192993164
		 42 18.068765640258789 43 18.068611145019531 44 18.068325042724609 45 18.067607879638672
		 46 18.065568923950195 47 18.060029983520508 48 18.048299789428711 49 18.02716064453125
		 50 17.99224853515625 51 17.937417984008789 52 17.856578826904297 53 17.746225357055664
		 54 17.605766296386719 55 17.438817977905273 56 17.253538131713867 57 17.062175750732422
		 58 16.879360198974609 59 16.721729278564453 60 16.60377311706543 61 16.529207229614258
		 62 16.495437622070313 63 16.489595413208008 64 16.494592666625977 65 16.509021759033203
		 66 16.532299041748047 67 16.562761306762695 68 16.59882926940918 69 16.638975143432617
		 70 16.681751251220703 71 16.725820541381836 72 16.769828796386719 73 16.81260871887207
		 74 16.852960586547852 75 16.889837265014648 76 16.922201156616211 77 16.949073791503906
		 78 16.969478607177734 79 16.982492446899414 80 16.987054824829102;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "E1F8B71E-461D-60C3-8FBE-7CAC0EF8BD2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -18.297317504882812 1 -18.303936004638672
		 2 -18.321071624755859 3 -18.344776153564453 4 -18.371021270751953 5 -18.395711898803711
		 6 -18.414545059204102 7 -18.423009872436523 8 -18.416488647460937 9 -18.390134811401367
		 10 -18.339065551757812 11 -18.258268356323242 12 -18.145339965820313 13 -18.002410888671875
		 14 -17.831417083740234 15 -17.612649917602539 16 -17.333076477050781 17 -17.004743576049805
		 18 -16.64056396484375 19 -16.254379272460937 20 -15.860877990722656 21 -15.475099563598633
		 22 -15.112192153930664 23 -14.786975860595703 24 -14.503716468811035 25 -14.257049560546875
		 26 -14.047016143798828 27 -13.86862850189209 28 -13.715860366821289 29 -13.58827018737793
		 30 -13.485397338867188 31 -13.406644821166992 32 -13.34684944152832 33 -13.29974365234375
		 34 -13.263092994689941 35 -13.234683990478516 36 -13.212325096130371 37 -13.193843841552734
		 38 -13.172119140625 39 -13.145612716674805 40 -13.120368957519531 41 -13.102407455444336
		 42 -13.097711563110352 43 -13.11229419708252 44 -13.152168273925781 45 -13.223540306091309
		 46 -13.351711273193359 47 -13.552351951599121 48 -13.817558288574219 49 -14.139259338378906
		 50 -14.515165328979492 51 -14.954328536987305 52 -15.45538330078125 53 -15.998661041259766
		 54 -16.562177658081055 55 -17.121986389160156 56 -17.653877258300781 57 -18.135204315185547
		 58 -18.54673957824707 59 -18.873065948486328 60 -19.102375030517578 61 -19.242105484008789
		 62 -19.305091857910156 63 -19.317646026611328 64 -19.310649871826172 65 -19.28584098815918
		 66 -19.244161605834961 67 -19.188148498535156 68 -19.120243072509766 69 -19.042850494384766
		 70 -18.958436965942383 71 -18.86949348449707 72 -18.778535842895508 73 -18.688138961791992
		 74 -18.6009521484375 75 -18.519660949707031 76 -18.446964263916016 77 -18.385618209838867
		 78 -18.338401794433594 79 -18.30803108215332 80 -18.297317504882812;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "1BD67160-4ACA-D88B-3A28-BFB2CCA70F43";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -27.817066159610302 1 -27.814414102262759
		 2 -27.807476992771115 3 -27.797778578987817 4 -27.786922093935335 5 -27.776591523909158
		 6 -27.768576800019439 7 -27.764822115451611 8 -27.76735106097308 9 -27.778037097961796
		 10 -27.798565572320477 11 -27.830169517954459 12 -27.872392966955509 13 -27.922555486425221
		 14 -27.977657790344328 15 -28.04054214987282 16 -28.108727140707067 17 -28.171793914114826
		 18 -28.220787266077689 19 -28.249179077719084 20 -28.253595975497714 21 -28.234229236100049
		 22 -28.194677479194535 23 -28.141550495615792 24 -28.081438085050618 25 -28.018399691402113
		 26 -27.956632036823013 27 -27.898237579275378 28 -27.84422673622792 29 -27.796373921956761
		 30 -27.756253046598207 31 -27.724945041014379 32 -27.700895071006858 33 -27.68153428044555
		 34 -27.66623435656356 35 -27.654229642862099 36 -27.644736432338846 37 -27.636869877135641
		 38 -27.627733352168804 39 -27.616579935377828 40 -27.605953739709076 41 -27.598431914461703
		 42 -27.59667177257483 43 -27.603276627818261 44 -27.620624036271231 45 -27.650834463094
		 46 -27.702864543385495 47 -27.779188943176678 48 -27.870724795686332 49 -27.967735553155386
		 50 -28.062597002264866 51 -28.147651188807984 52 -28.209383711086396 53 -28.233384452577951
		 54 -28.210054950559581 55 -28.136672054609431 56 -28.018740224078606 57 -27.869390521250264
		 58 -27.707864228803402 59 -27.556366778309254 60 -27.436909693381374 61 -27.358610259045324
		 62 -27.321853480467102 63 -27.314388753034759 64 -27.318531054331867 65 -27.333194545090503
		 66 -27.357528778013272 67 -27.389692228899079 68 -27.427813433828266 69 -27.470117920291646
		 70 -27.514863284722399 71 -27.560466357704055 72 -27.605495258187055 73 -27.648632099193453
		 74 -27.688723207250774 75 -27.724801115533676 76 -27.756002506780199 77 -27.781538185608678
		 78 -27.800726683640679 79 -27.812819932121133 80 -27.817066159610302;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "9D400754-42F7-D232-A899-07BB20B5BBA0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 11.767878665944169 1 11.770298768277261
		 2 11.776824333526404 3 11.786435882968201 4 11.798080867018054 5 11.810733589538753
		 6 11.823608644716076 7 11.835882162515077 8 11.847081027075449 9 11.85669628185121
		 10 11.864417872307147 11 11.869758110769522 12 11.872587579977584 13 11.873244961649476
		 14 11.876020968072911 15 11.883063141757976 16 11.89211108953601 17 11.902354572248083
		 18 11.91317257742929 19 11.924251824930844 20 11.93572097877542 21 11.948071114243469
		 22 11.96229227160492 23 11.979640563017435 24 12.000725494911158 25 12.025174161998121
		 26 12.053063285611552 27 12.081366187175599 28 12.105940679543785 29 12.125327253610456
		 30 12.138016324569797 31 12.142456851756728 32 12.142404464930962 33 12.142584379336316
		 34 12.14281307785555 35 12.142896182563435 36 12.142647477909037 37 12.141873983481293
		 38 12.139737065849122 39 12.136090962467636 40 12.13179551006413 41 12.127698860719011
		 42 12.12471397301325 43 12.123607250015406 44 12.125280879445887 45 12.130501357351866
		 46 12.142409270796437 47 12.162668400442374 48 12.189712027157249 49 12.221878720193954
		 50 12.247338598323546 51 12.263866467300621 52 12.277361240181556 53 12.284014822173033
		 54 12.280490802569966 55 12.264567487352386 56 12.235626779266914 57 12.194657642092894
		 58 12.144127946191324 59 12.087328845102352 60 12.027576701241621 61 11.970298232845387
		 62 11.920412605765771 63 11.880847756095397 64 11.854472342227231 65 11.837019381352661
		 66 11.822548995901855 67 11.810639332374096 68 11.800963312895771 69 11.793125521781731
		 70 11.786860416125501 71 11.781874941058808 72 11.777940512954425 73 11.774907311401186
		 74 11.772563180560153 75 11.770793142584527 76 11.769535636962086 77 11.768677459917235
		 78 11.768175827413826 79 11.767949191217854 80 11.767878665944169;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "EE69478F-400C-412E-E427-F3AC81BBD077";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -10.121490879014077 1 -10.152753399372752
		 2 -10.233802162533976 3 -10.345826546369993 4 -10.470023834258667 5 -10.586858625867057
		 6 -10.675919793646765 7 -10.715905171478807 8 -10.684710322705879 9 -10.559653534431805
		 10 -10.317626443782492 11 -9.9355013203391245 12 -9.4026958514774783 13 -8.7304263212674993
		 14 -7.9286561376761284 15 -6.9067478668991855 16 -5.6067320136244083 17 -4.0874174122819236
		 18 -2.4100829783463134 19 -0.63882913702391408 20 1.1601507486545513 21 2.9195937563816705
		 22 4.5723990714249396 23 6.0525422525404506 24 7.3417642857316325 25 8.4646818342541117
		 26 9.4204761970641755 27 10.233372156913777 28 10.929888736797464 29 11.512050621886484
		 30 11.98192248097577 31 12.341931667518963 32 12.615551476334153 33 12.831190463557702
		 34 12.999017934116921 35 13.129110710790661 36 13.231525296864788 37 13.316272387680634
		 38 13.415845337103152 39 13.537480096956434 40 13.653358134245975 41 13.735844336939774
		 42 13.757421644888698 43 13.690613677633475 44 13.507706712987201 45 13.180481114603172
		 46 12.593279437657111 47 11.675228236771174 48 10.463786699095726 49 8.9966784807294964
		 50 7.2850487083227193 51 5.2872112729896488 52 3.0072363160073841 53 0.53069953851037754
		 54 -2.0476172861768092 55 -4.6242141751161538 56 -7.0917409078878428 57 -9.3461922719653661
		 58 -11.293709892847815 59 -12.854144039031112 60 -13.960293696674452 61 -14.639152557378711
		 62 -14.947085089145387 63 -15.009524498455164 64 -14.976336937067373 65 -14.856159423160824
		 66 -14.654066704658865 67 -14.382597392465083 68 -14.053977740731884 69 -13.680315847705238
		 70 -13.273744804127391 71 -12.846332973065028 72 -12.41040649165706 73 -11.978259586608274
		 74 -11.562445921557142 75 -11.175554914181731 76 -10.830319971440165 77 -10.539468493368773
		 78 -10.315813747868425 79 -10.172208103124916 80 -10.121490879014077;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "38680901-4D98-7CA3-A632-699C4A5CCF42";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -20.967266082763672 1 -20.965898513793945
		 2 -20.962247848510742 3 -20.956932067871094 4 -20.950616836547852 5 -20.943939208984375
		 6 -20.937450408935547 7 -20.931674957275391 8 -20.927108764648438 9 -20.924177169799805
		 10 -20.923318862915039 11 -20.925085067749023 12 -20.929824829101563 13 -20.937461853027344
		 14 -20.946346282958984 15 -20.957183837890625 16 -20.972497940063477 17 -20.992725372314453
		 18 -21.017885208129883 19 -21.047431945800781 20 -21.080310821533203 21 -21.114768981933594
		 22 -21.148616790771484 23 -21.179229736328125 24 -21.205295562744141 25 -21.227066040039063
		 26 -21.244033813476562 27 -21.257612228393555 28 -21.269618988037109 29 -21.280372619628906
		 30 -21.29026985168457 31 -21.299707412719727 32 -21.308042526245117 33 -21.31458854675293
		 34 -21.319669723510742 35 -21.323648452758789 36 -21.326889038085938 37 -21.329757690429688
		 38 -21.333576202392578 39 -21.338529586791992 40 -21.343540191650391 41 -21.347446441650391
		 42 -21.349092483520508 43 -21.347370147705078 44 -21.341133117675781 45 -21.329294204711914
		 46 -21.307361602783203 47 -21.272937774658203 48 -21.228132247924805 49 -21.175134658813477
		 50 -21.118923187255859 51 -21.060121536254883 52 -20.998146057128906 53 -20.937898635864258
		 54 -20.884067535400391 55 -20.840673446655273 56 -20.810489654541016 57 -20.794589996337891
		 58 -20.792234420776367 59 -20.801239013671875 60 -20.818675994873047 61 -20.839893341064453
		 62 -20.86085319519043 63 -20.878692626953125 64 -20.891025543212891 65 -20.899700164794922
		 66 -20.907453536987305 67 -20.91444206237793 68 -20.920783996582031 69 -20.926652908325195
		 70 -20.932178497314453 71 -20.937412261962891 72 -20.942432403564453 73 -20.947237014770508
		 74 -20.951759338378906 75 -20.955921173095703 76 -20.95965576171875 77 -20.962783813476563
		 78 -20.965204238891602 79 -20.966716766357422 80 -20.967266082763672;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "FBFA9F12-4785-19EE-C731-6284FF9B06C9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.391769409179688 1 16.390357971191406
		 2 16.386642456054688 3 16.381328582763672 4 16.375511169433594 5 16.369556427001953
		 6 16.364448547363281 7 16.361011505126953 8 16.360069274902344 9 16.362358093261719
		 10 16.368572235107422 11 16.379184722900391 12 16.394065856933594 13 16.412143707275391
		 14 16.431587219238281 15 16.452957153320312 16 16.475883483886719 17 16.49696159362793
		 18 16.513368606567383 19 16.523708343505859 20 16.526767730712891 21 16.522724151611328
		 22 16.512523651123047 23 16.497753143310547 24 16.48005485534668 25 16.460603713989258
		 26 16.440399169921875 27 16.420768737792969 28 16.402956008911133 29 16.387771606445313
		 30 16.375904083251953 31 16.368015289306641 32 16.362810134887695 33 16.358570098876953
		 34 16.355218887329102 35 16.352592468261719 36 16.35063362121582 37 16.349140167236328
		 38 16.347463607788086 39 16.345920562744141 40 16.344663619995117 41 16.344017028808594
		 42 16.344383239746094 43 16.346052169799805 44 16.34943962097168 45 16.354730606079102
		 46 16.363212585449219 47 16.3748779296875 48 16.388370513916016 49 16.401662826538086
		 50 16.416196823120117 51 16.430498123168945 52 16.439647674560547 53 16.440639495849609
		 54 16.430940628051758 55 16.409276962280273 56 16.376018524169922 57 16.333740234375
		 58 16.287258148193359 59 16.243259429931641 60 16.209403991699219 61 16.188987731933594
		 62 16.182392120361328 63 16.185157775878906 64 16.190406799316406 65 16.198469161987305
		 66 16.209821701049805 67 16.223821640014648 68 16.239797592163086 69 16.257091522216797
		 70 16.275074005126953 71 16.293157577514648 72 16.310791015625 73 16.327302932739258
		 74 16.342849731445313 75 16.356719970703125 76 16.368656158447266 77 16.37835693359375
		 78 16.385631561279297 79 16.390161514282227 80 16.391769409179688;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "2197E605-46A1-FE63-A60A-22846D172340";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.197517395019531 1 -29.202346801757813
		 2 -29.214641571044922 3 -29.231304168701172 4 -29.249050140380859 5 -29.264715194702148
		 6 -29.274656295776367 7 -29.274967193603516 8 -29.261590957641602 9 -29.230173110961914
		 10 -29.176406860351563 11 -29.096040725708008 12 -28.987323760986328 13 -28.852630615234375
		 14 -28.691793441772461 15 -28.486318588256836 16 -28.227579116821289 17 -27.929304122924805
		 18 -27.605175018310547 19 -27.268348693847656 20 -26.931859970092773 21 -26.607635498046875
		 22 -26.306602478027344 23 -26.038717269897461 24 -25.80565071105957 25 -25.602256774902344
		 26 -25.427774429321289 27 -25.278837203979492 28 -25.152133941650391 29 -25.047456741333008
		 30 -24.964712142944336 31 -24.903772354125977 32 -24.858970642089844 33 -24.823652267456055
		 34 -24.796154022216797 35 -24.774890899658203 36 -24.758298873901367 37 -24.744806289672852
		 38 -24.729719161987305 39 -24.711442947387695 40 -24.69438362121582 41 -24.682674407958984
		 42 -24.680404663085938 43 -24.691692352294922 44 -24.720710754394531 45 -24.771772384643555
		 46 -24.862621307373047 47 -25.004781723022461 48 -25.193445205688477 49 -25.424289703369141
		 50 -25.701881408691406 51 -26.036550521850586 52 -26.427745819091797 53 -26.865335464477539
		 54 -27.336738586425781 55 -27.826007843017578 56 -28.313846588134766 57 -28.778644561767578
		 58 -29.197948455810547 59 -29.550222396850586 60 -29.815967559814453 61 -29.994136810302734
		 62 -30.091249465942383 63 -30.130521774291992 64 -30.141096115112305 65 -30.127519607543945
		 66 -30.094842910766602 67 -30.046012878417969 68 -29.983861923217773 69 -29.911256790161133
		 70 -29.830997467041016 71 -29.745790481567383 72 -29.658390045166016 73 -29.57160758972168
		 74 -29.48786735534668 75 -29.409910202026367 76 -29.340360641479492 77 -29.281740188598633
		 78 -29.236701965332031 79 -29.207738876342773 80 -29.197517395019531;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "5F92FE12-47D5-8FF5-DAD2-C2B72319F27B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 33.467410093817001 1 33.46804413369442
		 2 33.469861724688116 3 33.472681191369851 4 33.476309529312196 5 33.480612185044741
		 6 33.485700045494909 7 33.491816509815813 8 33.499165583515065 9 33.507951037904206
		 10 33.518168369678847 11 33.529146250622375 12 33.539525298678328 13 33.547292779715264
		 14 33.552267784513781 15 33.552007531105964 16 33.53815519745951 17 33.502908719099807
		 18 33.440781498123513 19 33.349544599090059 20 33.230868148879352 21 33.09040439292631
		 22 32.937356619823845 23 32.783830533114575 24 32.637951308764002 25 32.501862746814055
		 26 32.379798796003818 27 32.271182188335565 28 32.174047697507547 29 32.089786717648842
		 30 32.019487410665008 31 31.96377194436479 32 31.92038367557323 33 31.885879035691037
		 34 31.858837409636127 35 31.837697422089384 36 31.82099551835957 37 31.807026757936207
		 38 31.790400262817521 39 31.769903813161768 40 31.7502025460578 41 31.735994972247678
		 42 31.732049294269871 43 31.743040654397728 44 31.773509857827641 45 31.827803623409817
		 46 31.923942477957233 47 32.070392886885124 48 32.25612061276847 49 32.469192822099494
		 50 32.69869412995817 51 32.939565570180221 52 33.17966324807842 53 33.39587130570294
		 54 33.56798929506261 55 33.681454754023378 56 33.730090071036898 57 33.717863924933397
		 58 33.658227227797816 59 33.571527602574371 60 33.480759606801001 61 33.403794049566841
		 62 33.350602564883175 63 33.319600704743863 64 33.303897388822001 65 33.300094186255585
		 66 33.303612650533537 67 33.312909033226994 68 33.326513159425204 69 33.342965632821013
		 70 33.360889553997701 71 33.379204943592121 72 33.396829350892794 73 33.41312286039652
		 74 33.427574042445656 75 33.439825391417514 76 33.449792881389037 77 33.457484879901884
		 78 33.462919180427939 79 33.466257081058743 80 33.467410093817001;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "7D14A1A4-454C-6DF2-140D-1D9BE00C7E34";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.0365495067244694 1 5.0427132675936308
		 2 5.0593786505082985 3 5.0836673292235117 4 5.1127848145622368 5 5.1438927934460743
		 6 5.1745188899391747 7 5.2023663059189431 8 5.2255140177793029 9 5.242193545019318
		 10 5.2506536475698296 11 5.2489085890136522 12 5.2358363758367394 13 5.2120708253643446
		 14 5.1863739959647859 15 5.1584005712009251 16 5.1190017334925866 17 5.0668839911355592
		 18 5.001985085202981 19 4.9261228822868182 20 4.8429898987366364 21 4.7580130889263472
		 22 4.6780528103693531 23 4.6110178616569604 24 4.5603282693048453 25 4.5246579863583563
		 26 4.5049756596644235 27 4.4947746239089792 28 4.4855515070310643 29 4.4751706940818146
		 30 4.461340237997236 31 4.4416250799037424 32 4.4207974680708952 33 4.4047164532790397
		 34 4.3923193710943798 35 4.3825673434972083 36 4.3743238894325396 37 4.3665554482254487
		 38 4.3553635502044079 39 4.339930179051005 40 4.3238682580870673 41 4.3107252114734083
		 42 4.3040438152622462 43 4.3073159810725254 44 4.3240843696053428 45 4.3577877251737753
		 46 4.4225170254110706 47 4.5262442159930769 48 4.6632708464896986 49 4.8276350931271699
		 50 4.9974558786249856 51 5.1702320103200599 52 5.3535849369574713 53 5.5316755582629735
		 54 5.6885398762616726 55 5.8097675305639065 56 5.8848796560147738 57 5.9091569323484485
		 58 5.8843531773380899 59 5.817821891542585 60 5.7201959895759895 61 5.6101241479185724
		 62 5.5047631354183988 63 5.416376537813651 64 5.3557696258852872 65 5.3136441827016112
		 66 5.2766686842533712 67 5.2441049984940831 68 5.2152394789813954 69 5.1893957597393303
		 70 5.1659887708172088 71 5.1445530576812049 72 5.1248495281493645 73 5.1066710151598356
		 74 5.0900418775214638 75 5.0750919569530515 76 5.0621313522133287 77 5.0513884849279433
		 78 5.0433332568043134 79 5.0382595083381947 80 5.0365495067244694;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "99845193-41C0-9B03-69E5-09804B15B188";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.8806851588466333 1 5.8569099016773825
		 2 5.7962598649240888 3 5.7142872333919117 4 5.626617607340374 5 5.5497133264995133
		 6 5.5014533320275447 7 5.5011613554738235 8 5.5693746832867799 9 5.7275504189514219
		 10 5.9973687239016975 11 6.4001375190283198 12 6.9444631857396697 13 7.6185147895040828
		 14 8.4239595115381523 15 9.4540505617312967 16 10.752310718317005 17 12.251164676407061
		 18 13.883334326181792 19 15.582694397677832 20 17.285812201227905 21 18.932883241587824
		 22 20.468458207371501 23 21.841348936016651 24 23.0420246750293 25 24.095494488054861
		 26 25.004683622787699 27 25.785025473403536 28 26.450701512964443 29 27.00139493212793
		 30 27.436454496303394 31 27.75510919764687 32 27.988044189410754 33 28.171948818028845
		 34 28.31514311569423 35 28.425835174789942 36 28.512098452464567 37 28.581994928118942
		 38 28.660908198004211 39 28.754660301998008 40 28.841822669603363 41 28.90126929485249
		 42 28.911820653453635 43 28.852470432448655 44 28.701777894373279 45 28.437576544083367
		 46 27.969136663248715 47 27.238569078145627 48 26.270889556116121 49 25.090155324757838
		 50 23.668781725637206 51 21.955555175357016 52 19.958476520936408 53 17.730364323438948
		 54 15.33590574041115 55 12.856135781380843 56 10.388082719598827 57 8.0400680616880464
		 58 5.9240052494317696 59 4.1474057176864187 60 2.8074975231974983 61 1.9091954308061256
		 62 1.4194364050358763 63 1.2207980593739021 64 1.1668959096676659 65 1.2342890629904248
		 66 1.3974913560937008 67 1.6416985653790368 68 1.9524049995781694 69 2.3153865980014232
		 70 2.7166537911315629 71 3.1423750880936354 72 3.578975241097214 73 4.0129939144357918
		 74 4.4311148626334749 75 4.8203234958229588 76 5.1675855629671714 77 5.4601168602714987
		 78 5.685063976338701 79 5.8295768750619485 80 5.8806851588466333;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA";
	rename -uid "738B3C4B-4180-20E9-1EDB-5C99ED535350";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 30.566905975341797 1 29.865716934204102
		 2 27.958110809326172 3 25.21307373046875 4 22.015567779541016 5 18.505416870117188
		 6 15.033889770507812 7 12.432027816772461 8 11.301938056945801 9 11.27323055267334
		 10 11.475020408630371 11 11.641462326049805 12 12.021895408630371 13 12.710155487060547
		 14 13.305742263793945 15 13.290188789367676 16 12.886945724487305 17 12.769550323486328
		 18 12.92338752746582 19 13.137496948242188 20 13.341157913208008 21 13.520130157470703
		 22 13.624302864074707 23 13.571035385131836 24 13.305524826049805 25 12.861313819885254
		 26 12.309558868408203 27 11.720418930053711 28 11.159275054931641 29 10.685708999633789
		 30 10.355081558227539 31 10.226259231567383 32 10.22332763671875 33 10.230718612670898
		 34 10.252479553222656 35 10.292716979980469 36 10.355598449707031 37 10.445287704467773
		 38 10.565546035766602 39 10.719914436340332 40 10.91118335723877 41 11.141290664672852
		 42 11.411558151245117 43 11.727697372436523 44 12.090648651123047 45 12.516490936279297
		 46 12.973726272583008 47 13.450787544250488 48 13.998647689819336 49 14.630379676818848
		 50 15.319553375244141 51 16.100303649902344 52 17.260490417480469 53 18.700922012329102
		 54 19.863182067871094 55 20.661821365356445 56 21.205568313598633 57 21.590877532958984
		 58 21.863058090209961 59 22.080678939819336 60 22.293739318847656 61 22.525371551513672
		 62 22.793230056762695 63 23.110082626342773 64 23.488548278808594 65 23.93402099609375
		 66 24.433755874633789 67 24.968721389770508 68 25.520267486572266 69 26.06805419921875
		 70 26.587818145751953 71 27.117525100708008 72 27.684232711791992 73 28.24083137512207
		 74 28.762729644775391 75 29.238384246826172 76 29.657434463500977 77 30.015970230102539
		 78 30.304256439208984 79 30.4969482421875 80 30.566905975341797;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA";
	rename -uid "D4BBAA42-4A85-D38C-A795-38ADB927E459";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 79.924430847167969 1 80.853645324707031
		 2 82.835403442382812 3 84.544883728027344 4 84.859779357910156 5 83.235519409179688
		 6 80.289451599121094 7 77.419883728027344 8 75.838455200195313 9 75.752662658691406
		 10 77.702911376953125 11 82.493247985839844 12 88.826065063476563 13 95.977935791015625
		 14 102.62384033203125 15 108.43474578857422 16 112.8543701171875 17 115.38884735107422
		 18 116.35460662841797 19 116.07881927490234 20 114.7271728515625 21 112.85224914550781
		 22 110.66569519042969 23 107.98126983642578 24 105.18764495849609 25 102.68698883056641
		 26 100.65779113769531 27 99.027603149414063 28 97.639434814453125 29 96.480621337890625
		 30 95.520896911621094 31 94.718002319335937 32 94.068672180175781 33 93.599708557128906
		 34 93.310943603515625 35 93.204536437988281 36 93.283317565917969 37 93.550163269042969
		 38 94.007110595703125 39 94.65313720703125 40 95.482925415039062 41 96.486343383789063
		 42 97.64752197265625 43 99.166763305664063 44 101.15643310546875 45 103.35064697265625
		 46 105.93502807617187 47 108.61318206787109 48 110.26399993896484 49 109.94614410400391
		 50 107.40655517578125 51 103.07010650634766 52 97.27789306640625 53 89.862419128417969
		 54 81.238739013671875 55 72.609687805175781 56 65.178779602050781 57 59.618160247802734
		 58 56.099605560302734 59 54.172588348388672 60 53.311195373535156 61 53.159965515136719
		 62 53.396286010742188 63 53.917877197265625 64 54.70648193359375 65 55.837570190429688
		 66 57.405326843261719 67 59.4105224609375 68 61.806598663330078 69 64.489990234375
		 70 67.303718566894531 71 70.013175964355469 72 72.544853210449219 73 74.882423400878906
		 74 76.831626892089844 75 78.247650146484375 76 79.018486022949219 77 79.394622802734375
		 78 79.67974853515625 79 79.860824584960938 80 79.924430847167969;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA";
	rename -uid "396C950C-4DFE-F2B0-C020-EFB9DBC49A55";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.1169586181640625 1 2.7364177703857422
		 2 4.6560230255126953 3 8.0107240676879883 4 12.582191467285156 5 17.458686828613281
		 6 21.756439208984375 7 25.048210144042969 8 26.734127044677734 9 27.071393966674805
		 10 27.035102844238281 11 24.694557189941406 12 20.309968948364258 13 14.905104637145996
		 14 7.6598920822143555 15 -1.1275386810302734 16 -11.047470092773438 17 -21.238044738769531
		 18 -30.857536315917969 19 -39.676906585693359 20 -47.594104766845703 21 -53.697105407714844
		 22 -58.158332824707031 23 -61.404815673828125 24 -63.366146087646484 25 -64.343002319335937
		 26 -64.490814208984375 27 -64.153579711914062 28 -63.693687438964844 29 -63.295806884765625
		 30 -63.140815734863281 31 -63.406143188476563 32 -63.959671020507813 33 -64.533203125
		 34 -65.096733093261719 35 -65.618385314941406 36 -66.06475830078125 37 -66.400711059570313
		 38 -66.574516296386719 39 -66.549491882324219 40 -66.310989379882812 41 -65.842842102050781
		 42 -65.127593994140625 43 -63.895908355712891 44 -61.898002624511719 45 -58.8782958984375
		 46 -53.906589508056641 47 -46.476295471191406 48 -37.151084899902344 49 -26.899150848388672
		 50 -16.883049011230469 51 -7.6647071838378906 52 0.47044467926025391 53 6.9971122741699219
		 54 11.064138412475586 55 12.310284614562988 56 11.238981246948242 57 8.7832555770874023
		 58 5.9493961334228516 59 3.3432369232177734 60 1.1525344848632813 61 -0.40625190734863281
		 62 -1.2081432342529297 63 -1.2902317047119141 64 -0.72340965270996094 65 0.33422279357910156
		 66 1.6401424407958984 67 3.0246505737304687 68 4.315460205078125 69 5.3597984313964844
		 70 6.0466098785400391 71 6.3288650512695313 72 6.2605209350585937 73 5.8619403839111328
		 74 5.2016525268554687 75 4.4364700317382812 76 3.7280178070068359 77 3.1216812133789063
		 78 2.6071243286132813 79 2.2503185272216797 80 2.1169586181640625;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX";
	rename -uid "60809570-4283-0B2A-19A0-9B9D90AF6589";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -68.573234376474701 1 -68.709076378016192
		 2 -69.11398728061917 3 -69.777498808156949 4 -70.595062173974128 5 -71.308135993312519
		 6 -71.862560585974407 7 -72.319296219005054 8 -72.371094892792598 9 -71.585643876425792
		 10 -69.680900996998275 11 -66.570466835447689 12 -62.146406116557039 13 -55.619257771344174
		 14 -43.654108414695195 15 -14.707353804260284 16 40.581569364811045 17 72.575289008153462
		 18 84.957788630254697 19 91.120229849630306 20 94.883358643473997 21 97.131969231518852
		 22 98.625014997112501 23 99.874930540196871 24 100.90869471756828 25 101.7423764150962
		 26 102.38359261807614 27 102.89212522516695 28 103.32943548726695 29 103.69953862226947
		 30 104.00526186911317 31 104.24842704562072 32 104.43046065723786 33 104.55192359428294
		 34 104.61318491931904 35 104.61422296556405 36 104.55447401260884 37 104.43330684278047
		 38 104.24946837312513 39 104.00154013001935 40 103.68750684243366 41 103.3047395107882
		 42 102.84992021250812 43 102.34012518991018 44 101.8873272319918 45 101.69215867269108
		 46 101.7036063051615 47 101.82072062225231 48 101.69915581019799 49 113.88643810674903
		 50 107.53729472422313 51 108.92025761946303 52 110.73864738668992 53 112.36054193100836
		 54 113.40921028013541 55 113.59271270288707 56 112.87338450151083 57 111.50803152341052
		 58 109.94953291385937 59 108.63197415646555 60 107.74724619053511 61 107.29375362604175
		 62 107.08988227519501 63 107.0664528602192 64 107.27489372132202 65 107.69718035960688
		 66 108.26780365022684 67 108.91321960746414 68 109.55975330907751 69 110.14154921842665
		 70 110.60862328220965 71 110.93359232774334 72 111.13874008942675 73 111.2433219257591
		 74 111.26255476196297 75 111.24706541290006 76 111.27530812057338 77 111.34565969978733
		 78 111.39352070044536 79 111.41932196215473 80 111.42676562352527;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY";
	rename -uid "224D1021-4269-3039-9D2E-2E9F484008DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.5996607568730972 1 3.1153051072596512
		 2 1.9723853691140971 3 0.6427909560445596 4 -0.37997037221053087 5 -0.59130967889657027
		 6 -0.13160928603827654 7 1.0598755393476287 8 3.7673890408298707 9 9.1520231714854248
		 10 17.339059399102293 11 27.575115900248242 12 39.077790145301265 13 51.406492079867171
		 14 63.967585676499624 15 74.362300875711256 16 75.590887999437001 17 67.840329754470943
		 18 59.275088974340861 19 51.924669303854813 20 45.741401253052139 21 41.210633678150707
		 22 37.767446620016656 23 34.609205619234537 24 31.801983420343376 25 29.410297847655055
		 26 27.497428194945446 27 25.936228344974339 28 24.558627274314276 29 23.366245121745848
		 30 22.360250164206715 31 21.541945639549265 32 20.912522215589036 33 20.473087001524597
		 34 20.224487973559622 35 20.168017184091063 36 20.304416036445907 37 20.634777293715661
		 38 21.160001160000345 39 21.880809093160899 40 22.798222406662006 41 23.912933778467313
		 42 25.225686982636269 43 27.936020299245488 44 32.987323476081656 45 40.000136381788401
		 46 49.558000776099291 47 62.014238210113788 48 76.598079505553557 49 92.555166149246162
		 50 108.96641553976099 51 125.62206113639982 52 142.07671128104545 53 157.37116961612148
		 54 170.2987927593517 55 180.35947702769769 56 187.62719307989627 57 192.14725923734582
		 58 193.98043511492975 59 193.99258111983346 60 193.3551819775434 61 193.02876188823839
		 62 193.3152525257882 63 193.52851499743397 64 193.42555215230462 65 192.92363064353637
		 66 192.05365310765694 67 190.84758122337539 68 189.34190472253098 69 187.57924002423329
		 70 185.60839011711411 71 183.48255229122458 72 181.29784040001491 73 179.26232746085694
		 74 177.59651212417782 75 176.51687087710786 76 176.23295764421664 77 176.36136543141373
		 78 176.40738606461139 79 176.40823488211291 80 176.40033924312692;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "FBDB0485-42CC-5CBB-8302-07BD950472F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 74.728139844130311 1 75.45640325759986
		 2 77.422899897308028 3 80.297908000609468 4 83.76570072912476 5 87.527878348641707
		 6 91.116862620018807 7 94.244458706064052 8 96.910806596713897 9 99.223611363232976
		 10 101.4017226961262 11 103.72372427628035 12 106.56977304732267 13 111.15218118857655
		 14 121.13440313693164 15 148.13438570784118 16 201.52463143536076 17 231.70896611108901
		 18 242.45146983018361 19 247.19120146513248 20 249.78739952936471 21 251.23721301665216
		 22 252.16698912982099 23 252.88350952406935 24 253.42697659914182 25 253.82829078137186
		 26 254.110814687112 27 254.31716059558295 28 254.48282327086326 29 254.6143426268456
		 30 254.71711302043548 31 254.79555613961671 32 254.85322829851532 33 254.89286657342134
		 34 254.91664853325776 35 254.92606044594939 36 254.92182469659704 37 254.90403129287972
		 38 254.87209862202664 39 254.82461703991987 40 254.75945077026753 41 254.67347137334693
		 42 254.56255113461501 43 254.79995077720466 44 255.62789775767746 45 256.86947315841053
		 46 258.14592967810415 47 259.03374203591522 48 258.98705995602285 49 270.53186965653003
		 50 262.94619261024775 51 262.72089377940858 52 262.87052064353924 53 263.22996821850444
		 54 264.14453815788573 55 265.78263940736906 56 268.04072860561052 57 270.73026068333502
		 58 273.5353061028585 59 276.03441419638523 60 277.83450415773024 61 278.63135680657501
		 62 278.57390261170684 63 278.03847181824671 64 277.08206763078624 65 275.77524953967941
		 66 274.20178872884833 67 272.44798609925834 68 270.60204513116389 69 268.75424950453396
		 70 266.99643541717757 71 265.42219539800277 72 263.89660660135524 73 262.27463303118299
		 74 260.63825521801516 75 259.07512581365467 76 257.67849373062074 77 256.49670963033338
		 78 255.56266681868536 79 254.94890501832771 80 254.72813984413028;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA";
	rename -uid "2FC69D81-4BF9-D7BA-032E-498D8C76CE61";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.794830322265625 1 -42.646183013916016
		 2 -42.367301940917969 3 -42.0225830078125 4 -41.666278839111328 5 -41.337108612060547
		 6 -41.061374664306641 7 -40.858329772949219 8 -40.744022369384766 9 -40.727565765380859
		 10 -40.903125762939453 11 -41.353668212890625 12 -42.069408416748047 13 -43.053352355957031
		 14 -44.300556182861328 15 -45.77471923828125 16 -47.393466949462891 17 -49.031055450439453
		 18 -50.570945739746094 19 -51.960731506347656 20 -53.192020416259766 21 -54.286705017089844
		 22 -55.286128997802734 23 -56.206329345703125 24 -57.040279388427734 25 -57.776332855224609
		 26 -58.397674560546875 27 -58.87469482421875 28 -59.1741943359375 29 -59.270633697509766
		 30 -59.241237640380859 31 -59.182109832763672 32 -59.0947265625 33 -58.98040771484375
		 34 -58.841640472412109 35 -58.680923461914062 36 -58.500408172607422 37 -58.302043914794922
		 38 -58.087226867675781 39 -57.857196807861328 40 -57.613254547119141 41 -57.356674194335938
		 42 -57.088783264160156 43 -56.804531097412109 44 -56.500278472900391 45 -56.180610656738281
		 46 -55.868465423583984 47 -55.565437316894531 48 -55.225204467773437 49 -54.797359466552734
		 50 -54.226387023925781 51 -53.331886291503906 52 -51.745880126953125 53 -50.362667083740234
		 54 -49.201713562011719 55 -48.326072692871094 56 -47.733516693115234 57 -47.382919311523438
		 58 -47.196033477783203 59 -47.047657012939453 60 -46.848659515380859 61 -46.553268432617188
		 62 -46.161090850830078 63 -45.757236480712891 64 -45.425037384033203 65 -45.077198028564453
		 66 -44.748291015625 67 -44.449920654296875 68 -44.187919616699219 69 -43.963455200195313
		 70 -43.775619506835938 71 -43.62066650390625 72 -43.493076324462891 73 -43.385715484619141
		 74 -43.287773132324219 75 -43.186130523681641 76 -43.066104888916016 77 -42.948341369628906
		 78 -42.863491058349609 79 -42.812145233154297 80 -42.794830322265625;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA";
	rename -uid "F5FC5865-4B02-68D7-85DB-89B5900CD130";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 58.386558532714844 1 58.511337280273438
		 2 58.801200866699219 3 59.107856750488281 4 59.297481536865234 5 59.296878814697266
		 6 59.116798400878906 7 58.844017028808594 8 58.602851867675781 9 58.488269805908203
		 10 58.462638854980469 11 58.397453308105469 12 58.146778106689453 13 57.621353149414063
		 14 56.801338195800781 15 55.724918365478516 16 54.457122802734375 17 53.054752349853516
		 18 51.574390411376953 19 50.154170989990234 20 48.945785522460938 21 48.087070465087891
		 22 47.449684143066406 23 46.825092315673828 24 46.221042633056641 25 45.650566101074219
		 26 45.130325317382813 27 44.654342651367188 28 44.213550567626953 29 43.822616577148438
		 30 43.473175048828125 31 43.150733947753906 32 42.854026794433594 33 42.581146240234375
		 34 42.334789276123047 35 42.118309020996094 36 41.935249328613281 37 41.789985656738281
		 38 41.686790466308594 39 41.631027221679688 40 41.629062652587891 41 41.687580108642578
		 42 41.814029693603516 43 42.112010955810547 44 42.668609619140625 45 43.462684631347656
		 46 44.410480499267578 47 45.431743621826172 48 46.499397277832031 49 47.579517364501953
		 50 48.698375701904297 51 49.871002197265625 52 52.003150939941406 53 54.685714721679688
		 54 56.907264709472656 55 58.394256591796875 56 59.064849853515625 57 59.021690368652344
		 58 58.494071960449219 59 57.80615234375 60 57.219947814941406 61 56.881641387939453
		 62 56.833091735839844 63 56.970489501953125 64 57.162139892578125 65 57.514114379882812
		 66 57.990524291992188 67 58.452224731445313 68 58.83514404296875 69 59.097602844238281
		 70 59.221710205078125 71 59.216659545898438 72 59.115428924560547 73 58.953392028808594
		 74 58.769447326660156 75 58.607536315917969 76 58.510593414306641 77 58.462104797363281
		 78 58.422634124755859 79 58.396171569824219 80 58.386558532714844;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA";
	rename -uid "C0ED4C33-495D-0DB9-0009-07A163FB2D8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.795326232910156 1 -42.148689270019531
		 2 -40.409744262695313 3 -37.901218414306641 4 -34.957309722900391 5 -31.926202774047852
		 6 -29.159439086914063 7 -26.996410369873047 8 -25.756740570068359 9 -25.669536590576172
		 10 -26.630365371704102 11 -28.367742538452148 12 -30.672080993652344 13 -33.329246520996094
		 14 -36.194293975830078 15 -39.184989929199219 16 -42.254287719726563 17 -45.353481292724609
		 18 -48.394245147705078 19 -51.187088012695313 20 -53.570026397705078 21 -55.506137847900391
		 22 -57.169513702392578 23 -58.716941833496094 24 -60.132015228271484 25 -61.397361755371094
		 26 -62.497798919677734 27 -63.390190124511719 28 -64.017318725585937 29 -64.340469360351563
		 30 -64.496688842773438 31 -64.64996337890625 32 -64.80078125 33 -64.949546813964844
		 34 -65.096366882324219 35 -65.241348266601562 36 -65.384597778320312 37 -65.526123046875
		 38 -65.66357421875 39 -65.79693603515625 40 -65.929405212402344 41 -66.063430786132812
		 42 -66.200576782226562 43 -66.326370239257813 44 -66.419708251953125 45 -66.466300964355469
		 46 -66.585838317871094 47 -66.819252014160156 48 -67.0462646484375 49 -66.717422485351563
		 50 -65.365135192871094 51 -63.202339172363281 52 -59.797119140625 53 -55.055530548095703
		 54 -49.877700805664062 55 -44.595203399658203 56 -39.525890350341797 57 -34.917655944824219
		 58 -30.907264709472656 59 -27.544988632202148 60 -24.924907684326172 61 -23.128501892089844
		 62 -22.274404525756836 63 -22.198696136474609 64 -22.634254455566406 65 -23.152511596679688
		 66 -24.147754669189453 67 -25.556941986083984 68 -27.278661727905273 69 -29.22309684753418
		 70 -31.301342010498047 71 -33.425731658935547 72 -35.491928100585938 73 -37.393913269042969
		 74 -39.048049926757813 75 -40.373359680175781 76 -41.290428161621094 77 -41.9117431640625
		 78 -42.386165618896484 79 -42.688907623291016 80 -42.795326232910156;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX";
	rename -uid "245DB72F-4548-E294-3B25-CFB2793C949C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -75.317575734977908 1 -75.317717777187781
		 2 -75.317706182739371 3 -75.317597523301188 4 -75.317648071327241 5 -75.317711908851393
		 6 -75.317575140604333 7 -75.317599313017212 8 -75.317669333824739 9 -75.317617061456858
		 10 -75.204924858571331 11 -74.893593216296111 12 -74.436739855453368 13 -73.900841276257978
		 14 -73.36118891206678 15 -72.897658577328656 16 -72.590111203679371 17 -72.512033996441758
		 18 -72.723411333052013 19 -73.262600414227748 20 -74.136742023780315 21 -75.315623268092907
		 22 -76.731747934548494 23 -78.284870633464706 24 -79.85723205166569 25 -81.329759925424327
		 26 -82.597184473902843 27 -83.575095397899915 28 -84.198768032100872 29 -84.416971909783157
		 30 -84.416724418223723 31 -84.41684623045208 32 -84.417083774573229 33 -84.416846652890499
		 34 -84.41702498306762 35 -84.416951243713726 36 -84.416884346941231 37 -84.416973942258977
		 38 -84.416899064727588 39 -84.416826031579717 40 -84.41703110490279 41 -84.416846446663442
		 42 -84.468379417829212 43 -84.618924638772057 44 -84.863268400969801 45 -85.196432930609319
		 46 -85.612799294017663 47 -86.107045793747801 48 -86.674399471315297 49 -87.144872263675538
		 50 -87.36132426433565 51 -87.339981718695569 52 -88.137752797052926 53 -87.673227834365107
		 54 -87.018590147615583 55 -86.213344822571187 56 -85.298023226785801 57 -84.311706056387038
		 58 -83.291922889996627 59 -82.269463312045119 60 -81.270864696247827 61 -80.320678944989837
		 62 -79.438069523399733 63 -78.64044209961294 64 -77.940837554977264 65 -76.390091819197181
		 66 -75.89625935907705 67 -75.508186395165339 68 -75.219122962177622 69 -75.019767693675277
		 70 -74.899521663294479 71 -74.845725883438192 72 -74.845583883090512 73 -74.885410515363347
		 74 -74.952673194968128 75 -75.034662003993986 76 -75.120250725203519 77 -75.198928600186619
		 78 -75.262394573402361 79 -75.303411304064568 80 -75.317575734977908;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY";
	rename -uid "C907C498-462D-C537-3033-9C886BC162A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 57.995092867432319 1 57.995045382816429
		 2 57.995060750966594 3 57.995130028911319 4 57.995105479846863 5 57.99510459206968
		 6 57.995046306211158 7 57.995105714924385 8 57.995058437223264 9 57.995113155433081
		 10 58.115999491824859 11 58.461195725502279 12 59.002607615018363 13 59.710227983884138
		 14 60.551913347760085 15 61.492655102349261 16 62.495107556658844 17 63.519544438389076
		 18 64.525140424708482 19 65.471569158408627 20 66.322440232551671 21 67.04730275743124
		 22 67.626839417916372 23 68.054472970333222 24 68.33824746905556 25 68.499542967645596
		 26 68.569102747757867 27 68.582340438066154 28 68.572919802630764 29 68.56642420852836
		 30 68.566404099761954 31 68.56640518269792 32 68.566384765170937 33 68.566471029662992
		 34 68.566430918850571 35 68.566465758900634 36 68.566395134303178 37 68.566449660756732
		 38 68.566449391579098 39 68.566442538649468 40 68.566449957769947 41 68.566433862213117
		 42 68.573463001975639 43 68.593981906149253 44 68.627640901217717 45 68.673900163963609
		 46 68.732470595591806 47 68.803135964354283 48 68.885562597490846 49 68.969893440466535
		 50 69.043573425703613 51 69.101698854166912 52 69.221062199433177 53 69.15256606014789
		 54 69.055508463409794 55 68.927372286470813 56 68.76183305354887 57 68.55236822957707
		 58 68.29416635489649 59 67.982614513487675 60 67.615690072106617 61 67.19399480501248
		 62 66.720799348385 63 66.200738044675816 64 65.640729001663857 65 65.168767350497134
		 66 64.527624879760609 67 63.86917211650141 68 63.203072619115829 69 62.539037832646123
		 70 61.886744691169547 71 61.255813344082981 72 60.655701558537864 73 60.095378861636625
		 74 59.583730932728884 75 59.129382959365984 76 58.74047034001039 77 58.425060074373647
		 78 58.190887425334282 79 58.045182466023647 80 57.995092867432319;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "17655CD7-41B5-CC8B-1A14-FDB2E63A0BC2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 166.04873736411326 1 166.04860506097512
		 2 166.04860230743321 3 166.04870845307977 4 166.04866855064708 5 166.04860629887906
		 6 166.04871821638929 7 166.04871494254084 8 166.04863867447833 9 166.04867918187423
		 10 165.80967084654009 11 165.11472901664004 12 163.98441756398438 13 162.42631959711105
		 14 160.43925047564161 15 158.0172015784367 16 155.15415638077326 17 151.84971289454882
		 18 148.11664250719514 19 143.98853809431179 20 139.52973854485242 21 134.84162415898106
		 22 130.06244412667422 23 125.36302397215815 24 120.93221262871137 25 116.9600554030323
		 26 113.6232839801778 27 111.07816309628201 28 109.4613398617434 29 108.89600769290078
		 30 108.89625540987062 31 108.89611822648517 32 108.89590638431854 33 108.89616832641667
		 34 108.89598733254192 35 108.89605435979314 36 108.8961106232714 37 108.89604066552688
		 38 108.89612069134517 39 108.89616316696302 40 108.89598170868058 41 108.8961556995575
		 42 108.93603664121788 43 109.05320300729218 44 109.24338758200739 45 109.50202402857106
		 46 109.82511426880691 47 110.20824080479422 48 110.64668256701148 49 111.30317368291242
		 50 112.32758937338095 51 113.69406998777248 52 114.73303140636364 53 116.739206545055
		 54 118.99910240578144 55 121.4667924633583 56 124.0958048137479 57 126.83983355302271
		 58 129.65306967570794 59 132.49564662743109 60 135.33159852074394 61 138.12706544126945
		 62 140.85354229294259 63 143.4834431647003 64 145.99344167373337 65 148.95802573663724
		 66 151.18905579918669 67 153.26205902995861 68 155.17372800839325 69 156.92350812940586
		 70 158.5119499429523 71 159.94178875820259 72 161.21578846111382 73 162.33747004397969
		 74 163.30946194196486 75 164.13429275079233 76 164.81315688791258 77 165.34637784400542
		 78 165.73240574155889 79 165.96837599242295 80 166.04873736411326;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA";
	rename -uid "9087004D-4B51-53A1-E676-09B1B17B1AC2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 28.093341827392578 1 28.098789215087891
		 2 28.113677978515625 3 28.135581970214844 4 28.162010192871094 5 28.190671920776367
		 6 28.219673156738281 7 28.247587203979492 8 28.273464202880859 9 28.296550750732422
		 10 28.316461563110352 11 28.332895278930664 12 28.346111297607422 13 28.357135772705078
		 14 28.375364303588867 15 28.405359268188477 16 28.441326141357422 17 28.479740142822266
		 18 28.517965316772461 19 28.554405212402344 20 28.591917037963867 21 28.627601623535156
		 22 28.661264419555664 23 28.694173812866211 24 28.726291656494141 25 28.756036758422852
		 26 28.782743453979492 27 28.805557250976562 28 28.824119567871094 29 28.837852478027344
		 30 28.846115112304688 31 28.848011016845703 32 28.846799850463867 33 28.846307754516602
		 34 28.846115112304688 35 28.84596061706543 36 28.84550666809082 37 28.844348907470703
		 38 28.841156005859375 39 28.835657119750977 40 28.829257965087891 41 28.823299407958984
		 42 28.819118499755859 43 28.818086624145508 44 28.821517944335937 45 28.830734252929688
		 46 28.850950241088867 47 28.885185241699219 48 28.931402206420898 49 28.991695404052734
		 50 29.051784515380859 51 29.096635818481445 52 29.123489379882813 53 29.129520416259766
		 54 29.113115310668945 55 29.074398040771484 56 29.015117645263672 57 28.937847137451172
		 58 28.845046997070313 59 28.738822937011719 60 28.619884490966797 61 28.492631912231445
		 62 28.367893218994141 63 28.258356094360352 64 28.178539276123047 65 28.124149322509766
		 66 28.079975128173828 67 28.046274185180664 68 28.02275276184082 69 28.008703231811523
		 70 28.002954483032227 71 28.004161834716797 72 28.01075553894043 73 28.021173477172852
		 74 28.033987045288086 75 28.047832489013672 76 28.061521530151367 77 28.073905944824219
		 78 28.084016799926758 79 28.090818405151367 80 28.093341827392578;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA";
	rename -uid "5403B196-4638-B6DA-63AE-989B34332B47";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 31.650505065917969 1 31.632640838623047
		 2 31.582901000976563 3 31.506904602050781 4 31.410385131835938 5 31.2989501953125
		 6 31.178417205810547 7 31.054378509521484 8 30.932598114013672 9 30.818862915039063
		 10 30.718952178955078 11 30.638885498046875 12 30.580574035644531 13 30.538875579833984
		 14 30.481437683105469 15 30.379428863525391 16 30.2352294921875 17 30.053268432617188
		 18 29.837923049926758 19 29.593618392944336 20 29.308481216430664 21 28.999406814575195
		 22 28.676359176635742 23 28.345884323120117 24 28.012960433959961 25 27.680566787719727
		 26 27.352949142456055 27 27.046884536743164 28 26.781949996948242 29 26.566030502319336
		 30 26.406976699829102 31 26.312456130981445 32 26.258100509643555 33 26.213827133178711
		 34 26.17869758605957 35 26.151758193969727 36 26.132135391235352 37 26.11890983581543
		 38 26.109907150268555 39 26.104421615600586 40 26.103612899780273 41 26.10862922668457
		 42 26.120489120483398 43 26.140146255493164 44 26.168668746948242 45 26.207307815551758
		 46 26.262495040893555 47 26.339468002319336 48 26.438436508178711 49 26.53333854675293
		 50 26.694429397583008 51 26.938955307006836 52 27.214845657348633 53 27.51490592956543
		 54 27.834260940551758 55 28.170480728149414 56 28.522680282592773 57 28.890012741088867
		 58 29.270193099975586 59 29.659957885742188 60 30.055252075195313 61 30.425876617431641
		 62 30.736923217773438 63 30.981647491455078 64 31.149822235107422 65 31.264995574951172
		 66 31.36212158203125 67 31.442855834960938 68 31.508766174316406 69 31.561229705810547
		 70 31.601615905761719 71 31.631336212158203 72 31.651660919189453 73 31.664005279541016
		 74 31.669742584228516 75 31.670421600341797 76 31.667453765869141 77 31.66241455078125
		 78 31.656883239746094 79 31.652370452880859 80 31.650505065917969;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "85955E32-49CB-9EAD-99F9-5D991DFB8481";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.043968200683594 1 -13.012439727783203
		 2 -12.923480987548828 3 -12.786511421203613 4 -12.611245155334473 5 -12.406453132629395
		 6 -12.179218292236328 7 -11.93476390838623 8 -11.676657676696777 9 -11.407052993774414
		 10 -11.127302169799805 11 -10.838510513305664 12 -10.539340972900391 13 -10.224797248840332
		 14 -9.8486595153808594 15 -9.3411531448364258 16 -8.7000331878662109 17 -7.9669647216796875
		 18 -7.179072380065918 19 -6.3685116767883301 20 -5.5457596778869629 21 -4.7494511604309082
		 22 -4.0047497749328613 23 -3.3298401832580566 24 -2.7276182174682617 25 -2.1887478828430176
		 26 -1.7116942405700684 27 -1.300018310546875 28 -0.956146240234375 29 -0.67951011657714844
		 30 -0.47001504898071289 31 -0.32825279235839844 32 -0.23188686370849609 33 -0.15549993515014648
		 34 -0.095908164978027344 35 -0.050067901611328125 36 -0.014939308166503906 37 0.012398242950439453
		 38 0.040923595428466797 39 0.072725772857666016 40 0.10054922103881836 41 0.11724042892456055
		 42 0.11578702926635742 43 0.089062690734863281 44 0.029857635498046875 45 -0.069505691528320313
		 46 -0.24086809158325195 47 -0.50612068176269531 48 -0.85938787460327148 49 -1.2793693542480469
		 50 -1.811180591583252 51 -2.4817624092102051 52 -3.2644038200378418 53 -4.1436505317687988
		 54 -5.1032199859619141 55 -6.1257791519165039 56 -7.1930656433105469 57 -8.2853918075561523
		 58 -9.3810367584228516 59 -10.454093933105469 60 -11.476021766662598 61 -12.396232604980469
		 62 -13.139662742614746 63 -13.70114803314209 64 -14.084468841552734 65 -14.315751075744629
		 66 -14.46930980682373 67 -14.549367904663086 68 -14.562198638916016 69 -14.515787124633789
		 70 -14.419926643371582 71 -14.285173416137695 72 -14.122550010681152 73 -13.943185806274414
		 74 -13.757558822631836 75 -13.575815200805664 76 -13.407485008239746 77 -13.261465072631836
		 78 -13.146524429321289 79 -13.071101188659668 80 -13.043968200683594;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "DCFDBDB4-4008-2D12-9AF0-00840E88914D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.11792002677073997 1 0.11853337465615443
		 2 0.11952828236288948 3 0.11998821670143331 4 0.11896699561855961 5 0.11495876901293019
		 6 0.10563212069203531 7 0.087649572597737618 8 0.056738282155091101 9 0.0079032261803756495
		 10 -0.063894604003890118 11 -0.16311581177504744 12 -0.29077543028809816 13 -0.44336070235561026
		 14 -0.64386355176360166 15 -0.91887244533876367 16 -1.2575455212928193 17 -1.63655929044235
		 18 -2.0343119081183776 19 -2.4324393797121777 20 -3.9051170105614448 21 -4.1188621788567588
		 22 -4.302636619510217 23 -4.4586552289291319 24 -4.5934646237866366 25 -4.7138900341400793
		 26 -4.8254559502187861 27 -4.9267117822751958 28 -5.0120709413748488 29 -5.0788143268449089
		 30 -5.1241319908232565 31 -5.1448626462149596 32 -5.1515299687861136 33 -5.1568725735095358
		 34 -5.1609500771648786 35 -5.1636875362691983 36 -5.1649184862652735 37 -5.1644128924144868
		 38 -5.1605519017913632 39 -5.1531021917812296 40 -5.1438255238947992 41 -5.1345558703977972
		 42 -5.1271512389587333 43 -5.1234926178931195 44 -5.1251316929886981 45 -5.1330929862368979
		 46 -5.1516400850630886 47 -5.1793442561296095 48 -5.206897975125389 49 -5.1990786549807275
		 50 -5.1353224746183601 51 -5.0042633060559929 52 -4.7932006940406442 53 -4.4858340227524751
		 54 -4.0780375362158736 55 -3.5826743414899549 56 -3.0310349450088925 57 -2.4698004607313964
		 58 -1.9551375527704318 59 -1.546465095571488 60 -1.2993478406467691 61 0.12584735374374417
		 62 0.50766335784391792 63 0.76492960346846273 64 0.91153045499159346 65 0.9780613361931545
		 66 1.0038712713920908 67 0.99566699083490906 68 0.95973845953973613 69 0.90196122998335193
		 70 0.82769951581969969 71 0.74191812425546255 72 0.6490828102931141 73 0.55346186812911824
		 74 0.45901996251535276 75 0.36947359992781625 76 0.28837920438018116 77 0.21920977236634165
		 78 0.16539183316612119 79 0.13043100231048668 80 0.11792002677073997;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "6C0D4145-4AC0-116A-10D6-8C9BABAF15FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.37342159744703818 1 -0.37217389064032191
		 2 -0.36929249227812755 3 -0.36616306292128031 4 -0.36424355376048512 5 -0.36467017542622082
		 6 -0.3683964848399412 7 -0.37575690379908278 8 -0.38664593118382146 9 -0.40110113268766978
		 10 -0.41866614290377274 11 -0.43899787838203636 12 -0.46171427551271937 13 -0.48661225902938005
		 14 -0.49818741601398264 15 -0.49672889907225304 16 -0.49634418219758791 17 -0.49723030835632176
		 18 -0.49925041493169453 19 -0.50168052784553419 20 -0.49198862811441052 21 -0.47483671930448856
		 22 -0.44890077037896015 23 -0.40895893982031462 24 -0.35591769781478066 25 -0.29740734942095703
		 26 -0.23733310945078082 27 -0.17968023808629044 28 -0.1284814677766751 29 -0.088641624825537196
		 30 -0.065064264504854863 31 -0.063039298685528197 32 -0.071395756778542943 33 -0.076279661641964661
		 34 -0.079158265812799819 35 -0.08145679482816838 36 -0.084515069540224905 37 -0.089995004299471118
		 38 -0.10350237376691472 39 -0.12611806692227764 40 -0.15219115798991295 41 -0.1761568106881671
		 42 -0.19254983107265555 43 -0.1956818979563065 44 -0.18012545402138966 45 -0.14058976345440466
		 46 -0.055843891570204328 47 0.085727192929567916 48 0.27471061211869846 49 0.52119340520246848
		 50 0.76935013339040093 51 0.96591117898964018 52 1.1046179648670404 53 1.1777122765889403
		 54 1.1835091805331022 55 1.1282487349128443 56 1.0255767342378956 57 0.8930419403513814
		 58 0.74740305777711113 59 0.60014853131302948 60 0.45469044780400564 61 0.30700154808820385
		 62 0.15414154385002551 63 0.014897791193072376 64 -0.083576780741108983 65 -0.15158010453422732
		 66 -0.2106077477984592 67 -0.26043251827615904 68 -0.30101475308893066 69 -0.33282371457045612
		 70 -0.35648614373362164 71 -0.37284773229531337 72 -0.38314273299740437 73 -0.3884696092839392
		 74 -0.3899351483232178 75 -0.38859504280602108 76 -0.38546296056760027 77 -0.3815505262092645
		 78 -0.3776520623084888 79 -0.3746392675013922 80 -0.37342159744703818;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "2F39A10D-43FA-D40A-9128-3F8F39B4B2AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -27.76265023056359 1 -27.614350882301416
		 2 -27.201204152368522 3 -26.573704735119666 4 -25.783374022092179 5 -24.878645193888389
		 6 -23.902589924081628 7 -22.89249300287365 8 -21.880392134863367 9 -20.894495753138457
		 10 -19.960713873798117 11 -19.105423955895155 12 -18.33474167974212 13 -17.620317131132573
		 14 -16.755640904193839 15 -15.521556511733525 16 -13.952906740442678 17 -12.162916939133661
		 18 -10.246032949196037 19 -8.2764524001613378 20 -6.2238926050269541 21 -4.1970879137479722
		 22 -2.2475162681979142 23 -0.39737531658285052 24 1.35219356663027 25 3.012980565391691
		 26 4.5849240660632349 27 6.0063162390124907 28 7.2082452532716887 29 8.1708150327943834
		 30 8.8722842239583262 31 9.2889810251365574 32 9.5296883084202459 33 9.7241325696158292
		 34 9.8774170335375384 35 9.9944116061216093 36 10.079823200474026 37 10.138001133239532
		 38 10.179539650669419 39 10.20772648216715 40 10.216295525871148 41 10.199421191553633
		 42 10.151942042975058 43 10.06848830591264 44 9.9430437853855818 45 9.7679564353471964
		 46 9.5074383504687141 47 9.1265951153855855 48 8.6129573052695587 49 8.0609749722783164
		 50 7.15463475306671 51 5.789603104874721 52 4.1530019445172162 53 2.245130908463445
		 54 0.06325803747073605 55 -2.3947195866666804 56 -5.1240170899321802 57 -8.1051854506023115
		 58 -11.298797702944343 59 -14.640167879297373 60 -18.052693384190789 61 -21.305811153669616
		 62 -24.074487211368048 63 -26.269712796106479 64 -27.81075225987728 65 -28.814476794370883
		 66 -29.57720801201944 67 -30.108504632611986 68 -30.42518015017869 69 -30.54974180616961
		 70 -30.510585734155239 71 -30.338745441366324 72 -30.066590342378877 73 -29.726640211395516
		 74 -29.348962023646386 75 -28.962181185656213 76 -28.592721487428964 77 -28.2647840466528
		 78 -28.001825334999513 79 -27.826541747870834 80 -27.76265023056359;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA";
	rename -uid "6B225117-4E66-EFE1-CA6D-0A95808673F2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -22.966213226318359 1 -22.968612670898438
		 2 -22.97511100769043 3 -22.984535217285156 4 -22.995725631713867 5 -23.007663726806641
		 6 -23.019510269165039 7 -23.030773162841797 8 -23.041278839111328 9 -23.050968170166016
		 10 -23.059959411621094 11 -23.068241119384766 12 -23.075653076171875 13 -23.082019805908203
		 14 -23.088451385498047 15 -23.096244812011719 16 -23.104578018188477 17 -23.111839294433594
		 18 -23.116708755493164 19 -23.118330001831055 20 -23.120803833007813 21 -23.121189117431641
		 22 -23.118743896484375 23 -23.114383697509766 24 -23.109931945800781 25 -23.107973098754883
		 26 -23.110881805419922 27 -23.116588592529297 28 -23.121150970458984 29 -23.124135971069336
		 30 -23.125095367431641 31 -23.123449325561523 32 -23.120452880859375 33 -23.117799758911133
		 34 -23.115451812744141 35 -23.113460540771484 36 -23.111865997314453 37 -23.110610961914063
		 38 -23.109676361083984 39 -23.109006881713867 40 -23.108684539794922 41 -23.108770370483398
		 42 -23.109321594238281 43 -23.110361099243164 44 -23.111907958984375 45 -23.113882064819336
		 46 -23.116189956665039 47 -23.118484497070313 48 -23.12030029296875 49 -23.130622863769531
		 50 -23.139345169067383 51 -23.148967742919922 52 -23.166641235351563 53 -23.185995101928711
		 54 -23.201969146728516 55 -23.210357666015625 56 -23.207633972167969 57 -23.191585540771484
		 58 -23.162696838378906 59 -23.124748229980469 60 -23.083705902099609 61 -23.0469970703125
		 62 -23.019313812255859 63 -23.000595092773438 64 -22.989463806152344 65 -22.98321533203125
		 66 -22.979110717773438 67 -22.976646423339844 68 -22.97528076171875 69 -22.974594116210937
		 70 -22.974262237548828 71 -22.973968505859375 72 -22.973548889160156 73 -22.972885131835938
		 74 -22.971954345703125 75 -22.970790863037109 76 -22.969526290893555 77 -22.968254089355469
		 78 -22.967195510864258 79 -22.966445922851563 80 -22.966213226318359;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA";
	rename -uid "444E6C6C-45AB-65B7-CA52-BEB82765C6AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.259443283081055 1 16.249227523803711
		 2 16.222463607788086 3 16.18659782409668 4 16.149168014526367 5 16.115377426147461
		 6 16.086854934692383 7 16.060911178588867 8 16.030706405639648 9 15.986639022827148
		 10 15.917947769165039 11 15.815874099731445 12 15.679372787475586 13 15.517515182495117
		 14 15.30595588684082 15 15.026803970336914 16 14.711732864379883 17 14.396963119506836
		 18 14.111520767211914 19 13.874120712280273 20 13.66868782043457 21 13.507650375366211
		 22 13.383630752563477 23 13.27568244934082 24 13.16438102722168 25 13.03700065612793
		 26 12.879465103149414 27 12.714670181274414 28 12.578254699707031 29 12.477920532226563
		 30 12.421911239624023 31 12.419347763061523 32 12.443798065185547 33 12.463191986083984
		 34 12.478857040405273 35 12.492155075073242 36 12.504728317260742 37 12.518308639526367
		 38 12.539972305297852 39 12.570981979370117 40 12.604623794555664 41 12.633811950683594
		 42 12.651514053344727 43 12.650693893432617 44 12.624746322631836 45 12.567913055419922
		 46 12.456632614135742 47 12.283014297485352 48 12.066671371459961 49 11.781791687011719
		 50 11.538516998291016 51 11.352458953857422 52 11.184961318969727 53 11.105278015136719
		 54 11.175662994384766 55 11.443141937255859 56 11.92888069152832 57 12.616918563842773
		 58 13.448007583618164 59 14.326845169067383 60 15.143777847290039 61 15.830617904663086
		 62 16.362668991088867 63 16.733423233032227 64 16.94862174987793 65 17.05042839050293
		 66 17.097188949584961 67 17.098554611206055 68 17.064054489135742 69 17.002756118774414
		 70 16.922929763793945 71 16.832052230834961 72 16.736551284790039 73 16.641721725463867
		 74 16.551931381225586 75 16.470418930053711 76 16.399660110473633 77 16.341535568237305
		 78 16.297574996948242 79 16.269472122192383 80 16.259443283081055;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "1EAE000B-4701-F0EE-F939-22B94884CD90";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.382806777954102 1 -13.388175010681152
		 2 -13.401991844177246 3 -13.420886039733887 4 -13.44129467010498 5 -13.459814071655273
		 6 -13.472539901733398 7 -13.475528717041016 8 -13.464746475219727 9 -13.436067581176758
		 10 -13.385585784912109 11 -13.309704780578613 12 -13.207484245300293 13 -13.08180046081543
		 14 -12.935433387756348 15 -12.753876686096191 16 -12.528520584106445 17 -12.269865989685059
		 18 -11.986452102661133 19 -11.685997009277344 20 -11.382372856140137 21 -11.083389282226562
		 22 -10.800235748291016 23 -10.547045707702637 24 -10.329951286315918 25 -10.147171020507812
		 26 -10.002054214477539 27 -9.8863868713378906 28 -9.7878093719482422 29 -9.7036571502685547
		 30 -9.6311588287353516 31 -9.5675230026245117 32 -9.5137853622436523 33 -9.4713525772094727
		 34 -9.4381837844848633 35 -9.4121999740600586 36 -9.3914222717285156 37 -9.3736810684204102
		 38 -9.3522300720214844 39 -9.325286865234375 40 -9.2991046905517578 41 -9.2797393798828125
		 42 -9.2731752395629883 43 -9.2853631973266602 44 -9.3223390579223633 45 -9.3901729583740234
		 46 -9.5138282775878906 47 -9.7087306976318359 48 -9.9664506912231445 49 -10.293144226074219
		 50 -10.660449981689453 51 -11.070969581604004 52 -11.534646034240723 53 -12.012775421142578
		 54 -12.466374397277832 55 -12.864686965942383 56 -13.194469451904297 57 -13.463345527648926
		 58 -13.691876411437988 59 -13.896231651306152 60 -14.072619438171387 61 -14.210634231567383
		 62 -14.297975540161133 63 -14.340795516967773 64 -14.356904983520508 65 -14.346144676208496
		 66 -14.313865661621094 67 -14.263084411621094 68 -14.197216033935547 69 -14.119853019714355
		 70 -14.034504890441895 71 -13.944498062133789 72 -13.852954864501953 73 -13.762855529785156
		 74 -13.676668167114258 75 -13.597058296203613 76 -13.5264892578125 77 -13.46733283996582
		 78 -13.422060966491699 79 -13.393025398254395 80 -13.382806777954102;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "EE875709-411C-5D42-D4C2-6FB611AE2497";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.345079559958704 1 15.365696818976437
		 2 15.422093976765249 3 15.50530907622703 4 15.606735795871018 5 15.718185407189607
		 6 15.833703719664506 7 15.948648744758676 8 16.059990281881554 9 16.165800890960643
		 10 16.264267512491042 11 16.352778739697442 12 16.429597213470036 13 16.495690481767195
		 14 16.580671622887117 15 16.706560762984367 16 16.857777154824383 17 17.019093658463476
		 18 17.178668027085319 19 17.329075827650861 20 17.463618144661837 21 17.585865992387319
		 22 17.703058981844656 23 17.826916371296875 24 17.967115137865736 25 18.127139908754007
		 26 18.312374315725453 27 18.500201034728963 28 18.65979317360841 29 18.782686118754391
		 30 18.859673193469664 31 18.881089685271657 32 18.872762699719214 33 18.86675407857825
		 34 18.862181473587402 35 18.857729004727549 36 18.851943612093685 37 18.84338198783313
		 38 18.825303425526489 39 18.796863364606839 40 18.76427488957507 41 18.734270457805291
		 42 18.713705113087446 43 18.709478769838743 44 18.727808711790694 45 18.773872035003361
		 46 18.868458131794949 47 19.014903828640364 48 19.190267649542115 49 19.366148732267916
		 50 19.461963046969476 51 19.471444300980259 52 19.424966782568941 53 19.306890793376173
		 54 19.119991160805718 55 18.878292817266921 56 18.594132323695874 57 18.268075694807173
		 58 17.89003571726332 59 17.454401634290583 60 16.974864663687377 61 16.500115964965797
		 62 16.087709807273548 63 15.765151514990686 64 15.550889955384038 65 15.418390354492068
		 66 15.320630460406392 67 15.253204336115752 68 15.211310944723827 69 15.190177946612133
		 70 15.185118901686403 71 15.191902064391959 72 15.206946270566409 73 15.226913100869659
		 74 15.249728745402958 75 15.273003647932837 76 15.295121675523843 77 15.314703855074033
		 78 15.330486727191209 79 15.341109254218573 80 15.345079559958704;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "CB2763E9-4A4D-3BA6-3700-DBB19CFB2D75";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.4502778849200428 1 3.4315312834232627
		 2 3.3814279014837947 3 3.3103582200824411 4 3.2287293115166178 5 3.1453811712867537
		 6 3.0656701317612058 7 2.9911012152645013 8 2.9194491320506071 9 2.8460700199278715
		 10 2.765069247972312 11 2.6724527862902985 12 2.5689225685346582 13 2.4604761183581334
		 14 2.3222512724474758 15 2.1385756715632827 16 1.940074410841456 17 1.7595851347597027
		 18 1.6240717744412136 19 1.5501729971570251 20 1.5105333149599132 21 1.5193667720973947
		 22 1.5663226180018082 23 1.6231352798150025 24 1.6632777508650909 25 1.6682309324825315
		 26 1.6162117922116075 27 1.5353768580848479 28 1.4722388728056286 29 1.4351604212500535
		 30 1.4333178141508247 31 1.4768590908300203 32 1.5398626304200673 33 1.5906580043880119
		 34 1.6315978291275 35 1.6649840083701335 36 1.6932418789322412 37 1.7193839092071597
		 38 1.7539748637412671 39 1.7986547373060735 40 1.8439997836592001 41 1.8801238061374761
		 42 1.8970484261441691 43 1.8853633551005691 44 1.835554095969858 45 1.7394258692163778
		 46 1.5621191415532885 47 1.2892657499555491 48 0.94468494806766967 49 0.48366733802315198
		 50 0.045103383062180161 51 -0.36236494381670414 52 -0.79263443601151695 53 -1.1446157719472199
		 54 -1.3284558457488513 55 -1.2768790426596246 56 -0.95967354980260167 57 -0.39587522836302225
		 58 0.34372237875689721 59 1.1529249398098791 60 1.9208702188985964 61 2.5693746247604627
		 62 3.0654093726540061 63 3.4092766045777956 64 3.6122421889134619 65 3.7182123673622738
		 66 3.7803588344742325 67 3.8071240548308283 68 3.8064935047551853 69 3.7857886726297179
		 70 3.751461889063318 71 3.7091504005684026 72 3.6636338819389445 73 3.6187252951146256
		 74 3.5767294399096974 75 3.5397255396848339 76 3.5086889664008769 77 3.4840746784782053
		 78 3.4659225367151665 79 3.4544566432779118 80 3.4502778849200428;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "9FC05DA5-405C-A511-27A4-65A2274A1771";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 41.98109203764043 1 42.010111803215025
		 2 42.085803330263133 3 42.185444793308712 4 42.287071268101691 5 42.374579172274181
		 6 42.446631652011426 7 42.51624113671545 8 42.610918652893254 9 42.767776787714432
		 10 43.027501464358267 11 43.423217706710957 12 43.958555770874099 13 44.597618235573648
		 14 45.418717083272924 15 46.487425458216237 16 47.693013989045795 17 48.89657250491949
		 18 49.985854059853324 19 50.888754054699014 20 51.654470408070715 21 52.239025523970554
		 22 52.67086943511525 23 53.028049180766239 24 53.384439587597726 25 53.788609757466041
		 26 54.293403664840554 27 54.823603541107168 28 55.258071403027671 29 55.572068741764213
		 30 55.738092349728454 31 55.725869979142161 32 55.625399578257763 33 55.545465142465247
		 34 55.481226347996937 35 55.427218124754269 36 55.377656590043138 37 55.325604540626003
		 38 55.244040278683215 39 55.129612671819025 40 55.006595561597955 41 54.90095461475034
		 42 54.838947162751268 43 54.846161204424206 44 54.947345940607256 45 55.163627289464522
		 46 55.582538467863579 47 56.232654934662278 48 57.041163363128732 49 58.093141655585931
		 50 59.001256848030174 51 59.699451699205795 52 60.305952805887188 53 60.557485253491613
		 54 60.216696600213197 55 59.112342571460992 56 57.185323448059165 57 54.526241564192148
		 58 51.382342814066462 59 48.116898344348442 60 45.130770544224291 61 42.657643102226075
		 62 40.775431081013529 63 39.489383655194615 64 38.756055774942233 65 38.430919966582167
		 66 38.311738282584038 67 38.362306076489901 68 38.546718294623233 69 38.830600458843527
		 70 39.182299809012008 71 39.573362980256434 72 39.979052103425069 73 40.378128205738435
		 74 40.755788662645273 75 41.097855974733122 76 41.394565246149504 77 41.638079679673808
		 78 41.822096090747372 79 41.939329544106386 80 41.98109203764043;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA";
	rename -uid "7DA2CDA1-4A01-22A3-855B-E19836EB7E84";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 33.265228271484375 1 33.794204711914063
		 2 34.951641082763672 3 35.813819885253906 4 35.298439025878906 5 33.107322692871094
		 6 30.028858184814453 7 27.254039764404297 8 25.999557495117188 9 25.147333145141602
		 10 23.477443695068359 11 22.591806411743164 12 22.175704956054688 13 22.482795715332031
		 14 23.925069808959961 15 26.270305633544922 16 28.761194229125977 17 30.2779541015625
		 18 30.597234725952148 19 30.365715026855469 20 29.904392242431641 21 29.364349365234375
		 22 28.891796112060547 23 28.6500244140625 24 28.594657897949219 25 28.547937393188477
		 26 28.487003326416016 27 28.393196105957031 28 28.263603210449219 29 28.116682052612305
		 30 27.983537673950195 31 27.904462814331055 32 27.839015960693359 33 27.727573394775391
		 34 27.579391479492188 35 27.403127670288086 36 27.207550048828125 37 27.001916885375977
		 38 26.796188354492188 39 26.601634979248047 40 26.430837631225586 41 26.298101425170898
		 42 26.219831466674805 43 26.227455139160156 44 26.347612380981445 45 26.747053146362305
		 46 27.498409271240234 47 28.432270050048828 48 29.380578994750977 49 30.279689788818359
		 50 31.201969146728516 51 31.880954742431641 52 30.948846817016602 53 28.513229370117188
		 54 26.692848205566406 55 25.891067504882812 56 25.653081893920898 57 25.645709991455078
		 58 25.785200119018555 59 26.024824142456055 60 26.337818145751953 61 26.705438613891602
		 62 27.112693786621094 63 27.552978515625 64 28.02256965637207 65 28.51960563659668
		 66 29.037313461303711 67 29.555524826049805 68 30.052986145019531 69 30.513456344604492
		 70 30.93339729309082 71 31.337852478027344 72 31.732931137084961 73 32.126930236816406
		 74 32.506599426269531 75 32.828910827636719 76 33.052200317382813 77 33.180583953857422
		 78 33.244468688964844 79 33.263664245605469 80 33.265228271484375;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA";
	rename -uid "458266BC-4146-D717-574B-E5900A1980CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 78.131423950195313 1 78.674980163574219
		 2 80.356063842773438 3 83.038185119628906 4 85.662452697753906 5 86.472938537597656
		 6 85.056625366210937 7 82.513992309570313 8 79.882965087890625 9 77.644493103027344
		 10 77.492279052734375 11 78.439224243164063 12 80.235466003417969 13 83.508155822753906
		 14 87.364044189453125 15 92.350677490234375 16 98.176376342773438 17 102.34841156005859
		 18 103.28582763671875 19 102.02519989013672 20 99.728233337402344 21 97.356674194335938
		 22 95.114501953125 23 92.821380615234375 24 90.675575256347656 25 88.839401245117188
		 26 87.394790649414063 27 86.247207641601563 28 85.251510620117188 29 84.392730712890625
		 30 83.652008056640625 31 83.010383605957031 32 82.472122192382813 33 82.053352355957031
		 34 81.75323486328125 35 81.571640014648438 36 81.50872802734375 37 81.565231323242188
		 38 81.742752075195313 39 82.042144775390625 40 82.462928771972656 41 83.003387451171875
		 42 83.659576416015625 43 84.591133117675781 44 85.901718139648438 45 87.46990966796875
		 46 89.522125244140625 47 92.045600891113281 48 94.495925903320313 49 96.131622314453125
		 50 95.91485595703125 51 92.386871337890625 52 84.983444213867188 53 77.416351318359375
		 54 71.872825622558594 55 67.957565307617188 56 65.452499389648437 57 64.20623779296875
		 58 63.961505889892578 59 64.326675415039062 60 65.0018310546875 61 65.782447814941406
		 62 66.521965026855469 63 67.164215087890625 64 67.716598510742188 65 68.32562255859375
		 66 69.152023315429688 67 70.242256164550781 68 71.590042114257813 69 73.122650146484375
		 70 74.703704833984375 71 76.167228698730469 72 77.424873352050781 73 78.410072326660156
		 74 79.030677795410156 75 79.262245178222656 76 79.116943359375 77 78.781929016113281
		 78 78.462776184082031 79 78.224433898925781 80 78.131423950195313;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "8FBF8C6B-41F7-9593-9BA7-62A73764E633";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -19.994743347167969 1 -19.155220031738281
		 2 -16.423980712890625 3 -11.605006217956543 4 -5.3717460632324219 5 0.85367584228515625
		 6 5.8867244720458984 7 9.1177024841308594 8 10.392621994018555 9 9.6543598175048828
		 10 8.1851606369018555 11 5.6399564743041992 12 2.3509979248046875 13 -0.85632896423339844
		 14 -4.7413654327392578 15 -9.6270828247070312 16 -16.703235626220703 17 -26.015668869018555
		 18 -34.890518188476562 19 -41.936794281005859 20 -47.256191253662109 21 -50.821224212646484
		 22 -53.209857940673828 23 -54.906757354736328 24 -55.945556640625 25 -56.494625091552734
		 26 -56.629135131835938 27 -56.53106689453125 28 -56.385879516601563 29 -56.262535095214844
		 30 -56.227783203125 31 -56.346691131591797 32 -56.568412780761719 33 -56.789531707763672
		 34 -56.996089935302734 35 -57.172527313232422 36 -57.301559448242188 37 -57.363986968994141
		 38 -57.323856353759766 39 -57.160316467285156 40 -56.874725341796875 41 -56.467124938964844
		 42 -55.936538696289062 43 -55.136287689208984 44 -53.932098388671875 45 -52.1912841796875
		 46 -49.539310455322266 47 -45.773906707763672 48 -40.917621612548828 49 -34.879180908203125
		 50 -27.612098693847656 51 -19.337863922119141 52 -12.214126586914063 53 -8.7584190368652344
		 54 -8.0423526763916016 55 -8.9131879806518555 56 -10.660055160522461 57 -12.709324836730957
		 58 -14.598852157592773 59 -16.169879913330078 60 -17.459226608276367 61 -18.367965698242187
		 62 -18.771787643432617 63 -18.732082366943359 64 -18.318939208984375 65 -17.622501373291016
		 66 -16.805595397949219 67 -15.976869583129883 68 -15.259057998657227 69 -14.76826286315918
		 70 -14.587806701660156 71 -14.736263275146484 72 -15.168811798095703 73 -15.860794067382813
		 74 -16.720272064208984 75 -17.597633361816406 76 -18.360189437866211 77 -18.992410659790039
		 78 -19.512939453125 79 -19.865076065063477 80 -19.994743347167969;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "AD704873-4349-356C-3AAA-F8B7CF8A104F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -59.251408682579516 1 -56.532818238284932
		 2 -49.359685349525911 3 -39.64286269580699 4 -30.355782421716146 5 -24.739171208548125
		 6 -24.044490416067219 7 -28.09566332483406 8 -36.92394343186406 9 -49.794426947343425
		 10 -61.34339825361797 11 -69.318825541959228 12 -72.085024089568336 13 -67.413297751907095
		 14 -52.889198420767173 15 -26.115943427563391 16 4.6669105586329085 17 29.818873487018003
		 18 48.593830240381813 19 63.756783762698788 20 77.254519571691603 21 88.218341268586499
		 22 96.367776352344308 23 101.79803883803703 24 104.55128618981311 25 105.59752378896674
		 26 105.43505819197723 27 104.61901348736041 28 103.65693249697898 29 102.85334662495774
		 30 102.49811543132508 31 102.88153097376026 32 103.75156643646947 33 104.63638897905939
		 34 105.50053312382425 35 106.31088876520512 36 107.03735236442922 37 107.65122835829938
		 38 108.12421330429254 39 108.42606098670902 40 108.52130672911493 41 108.36570410286308
		 42 107.90154881930863 43 106.75481773004779 44 104.50971613008838 45 100.43512389018282
		 46 92.734223027038396 47 80.14881747637348 48 64.462679764175974 49 48.780039950165332
		 50 32.740168752277079 51 11.55440211926933 52 -18.664972065602594 53 -50.516030455401882
		 54 -70.922629845594628 55 -80.822489830882432 56 -85.828601588738763 57 -88.85181362425395
		 58 -90.772798090747472 59 -92.001158229467478 60 -92.680036484173783 61 -92.77858153459087
		 62 -92.269226207925655 63 -91.03055695208883 64 -88.939298845836078 65 -86.035618822455262
		 66 -82.482140976350067 67 -78.418076293099944 68 -74.021212787951924 69 -69.537289366402234
		 70 -65.290957005507011 71 -61.58002253224614 72 -58.612786962522797 73 -56.522639525121278
		 74 -55.388399977784694 75 -55.192003068133538 76 -55.875694651523595 77 -57.011421085455893
		 78 -58.103136125051826 79 -58.927750872910579 80 -59.251408682579516;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "B7D2DC10-451D-9425-BA6A-8A9B20D1EE22";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 4.6018997964344059 1 5.594590788966209
		 2 6.3697142779347198 3 3.8658430005647801 4 -2.0583637189911235 5 -8.3294994163375602
		 6 -12.316859607014237 7 -13.176235355310542 8 -10.426871249265416 9 -4.856139994132735
		 10 0.54001723301075188 11 10.451636431555013 12 22.606833631651131 13 33.9167560835755
		 14 43.065438912381573 15 46.031121542981531 16 41.056196146607931 17 35.698713216402858
		 18 35.788249344002885 19 38.966075810710777 20 42.156664220451866 21 43.898535476059436
		 22 44.096718395718554 23 42.715801124374536 24 40.494461331083393 25 38.289902376429062
		 26 36.404500675611501 27 34.881933562430483 28 33.664247591894927 29 32.744879831655133
		 30 32.079772366382024 31 31.593054775096014 32 31.259345006038902 33 31.108956117737709
		 34 31.142939186670301 35 31.368439949414974 36 31.794889990459662 37 32.431561806141495
		 38 33.284426474308475 39 34.35417230201066 40 35.634198920684902 41 37.10834126796108
		 42 38.749825918221667 43 40.70908700370758 44 43.047590971891715 45 45.285265490254588
		 46 47.259189863134459 47 47.84677869114018 48 44.876191262726472 49 38.181988908621769
		 50 30.945434687143109 51 28.557780121938901 52 33.376757065604394 53 33.843517663506212
		 54 24.777693170144651 55 12.015095662639325 56 -0.70178654390765205 57 -11.847277281362905
		 58 -20.597316674161021 59 -27.024194984819172 60 -31.541957990311136 61 -34.389811767964325
		 62 -35.968295408380349 63 -36.351442855334057 64 -35.603039214249854 65 -33.973213976341995
		 66 -31.710785201777714 67 -28.992142775176401 68 -25.962413717516334 69 -22.723678636806895
		 70 -19.337297394721837 71 -15.984463501052456 72 -12.613134407934782 73 -9.0822536731404426
		 74 -5.6471275242574634 75 -2.6021415580205818 76 -0.25243357704015013 77 1.5710412884417277
		 78 3.1216311048410899 79 4.1991786500889967 80 4.6018997964344059;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "2236F55E-44D0-D5F9-BD2D-29A89793D392";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 96.957508482769384 1 100.17356148293331
		 2 108.35384428338382 3 118.38766764354537 4 126.49515629330774 5 131.32732138064398
		 6 133.37660235930448 7 132.93561499226885 8 131.96834446819469 9 128.54019987088736
		 10 122.48633344897625 11 119.88520676792741 12 119.48334094806724 13 121.80037294437564
		 14 130.57377396947763 15 146.78269697882149 16 160.38974371810747 17 164.73693879253554
		 18 167.14580509989258 19 172.52696030297059 20 181.16874560463927 21 190.28774056391424
		 22 197.95843466319511 23 203.3128512508936 24 205.88962998841581 25 206.57983320782515
		 26 205.91813620534165 27 204.56909051613454 28 203.13454936485874 29 201.97372702662352
		 30 201.4127202687655 31 201.76834923381702 32 202.76210704100629 33 203.87297031015024
		 34 205.05693360479998 35 206.27135190990859 36 207.47492349663221 37 208.62602267731305
		 38 209.68098370455652 39 210.59130526353695 40 211.30043705429537 41 211.74016683783969
		 42 211.82662691454959 43 211.13708042352692 44 209.19373991640558 45 205.16905317835756
		 46 196.7349603218 47 182.68427308844898 48 166.24082841450831 49 152.98166089720527
		 50 145.95977152767301 51 143.50917200236418 52 137.17971067469654 53 121.91398130741317
		 54 109.66954835207353 55 103.84138510368396 56 101.48015947754156 57 100.68393737463094
		 58 100.80634734484899 59 101.42713537691127 60 102.25902643245645 61 103.10074096866322
		 62 103.81664409383178 63 104.29077772598485 64 104.44964053027225 65 104.32537553009909
		 66 104.01320612347644 67 103.57109221034138 68 103.03776217557173 69 102.4542105014561
		 70 101.89261614123687 71 101.3290161839854 72 100.69892719261361 73 100.14267094713378
		 74 99.691581108683053 75 99.255170802654462 76 98.737481741207532 77 98.143965404536573
		 78 97.571419152474434 79 97.130860900212738 80 96.957508482769384;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA";
	rename -uid "BA758A8A-4B03-3624-9455-EF864B24B637";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.12042236328125 1 -29.193126678466797
		 2 -29.461835861206055 3 -29.791576385498047 4 -30.082248687744141 5 -30.288768768310547
		 6 -30.4100341796875 7 -30.469078063964844 8 -30.497594833374023 9 -30.518835067749023
		 10 -30.607231140136719 11 -30.78570556640625 12 -30.937213897705078 13 -30.90690803527832
		 14 -30.587095260620117 15 -29.996763229370117 16 -29.325658798217773 17 -28.918987274169922
		 18 -29.083461761474609 19 -29.828119277954102 20 -30.997776031494141 21 -32.359451293945313
		 22 -33.7449951171875 23 -35.100944519042969 24 -36.345848083496094 25 -37.416778564453125
		 26 -38.270393371582031 27 -38.908485412597656 28 -39.344978332519531 29 -39.568840026855469
		 30 -39.643421173095703 31 -39.639617919921875 32 -39.565696716308594 33 -39.432113647460938
		 34 -39.242668151855469 35 -39.001953125 36 -38.715354919433594 37 -38.389183044433594
		 38 -38.031219482421875 39 -37.649398803710937 40 -37.251041412353516 41 -36.842857360839844
		 42 -36.430557250976562 43 -36.003749847412109 44 -35.553878784179688 45 -35.08489990234375
		 46 -34.593887329101563 47 -34.143943786621094 48 -33.901885986328125 49 -33.987312316894531
		 50 -34.471389770507812 51 -35.971244812011719 52 -37.719978332519531 53 -36.894123077392578
		 54 -36.179317474365234 55 -35.61358642578125 56 -35.201198577880859 57 -34.921878814697266
		 58 -34.736579895019531 59 -34.586143493652344 60 -34.426979064941406 61 -34.237022399902344
		 62 -34.016834259033203 63 -33.809886932373047 64 -33.658878326416016 65 -33.167434692382813
		 66 -32.832256317138672 67 -32.521213531494141 68 -32.205024719238281 69 -31.872716903686523
		 70 -31.52421760559082 71 -31.169485092163086 72 -30.811943054199219 73 -30.450336456298828
		 74 -30.102033615112305 75 -29.791967391967773 76 -29.550128936767578 77 -29.371877670288086
		 78 -29.236410140991211 79 -29.150463104248047 80 -29.12042236328125;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA";
	rename -uid "38B9F9F5-493A-D1D5-0C63-CD814077208F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 75.048683166503906 1 75.381858825683594
		 2 76.194046020507813 3 77.139656066894531 4 77.933456420898438 5 78.420906066894531
		 6 78.590850830078125 7 78.543930053710938 8 78.4298095703125 9 78.357009887695313
		 10 78.290695190429687 11 78.066726684570313 12 77.404029846191406 13 75.9061279296875
		 14 73.189857482910156 15 69.168777465820312 16 64.185447692871094 17 58.902000427246094
		 18 54.099822998046875 19 49.990768432617188 20 46.480983734130859 21 43.836814880371094
		 22 41.821018218994141 23 40.085430145263672 24 38.665634155273437 25 37.578819274902344
		 26 36.823646545410156 27 36.257598876953125 28 35.710220336914063 29 35.13238525390625
		 30 34.590488433837891 31 34.182514190673828 32 33.886138916015625 33 33.676231384277344
		 34 33.554939270019531 35 33.525436401367188 36 33.591049194335938 37 33.755470275878906
		 38 34.026168823242187 39 34.40570068359375 40 34.889053344726563 41 35.469707489013672
		 42 36.140068054199219 43 36.996292114257813 44 38.1170654296875 45 39.470062255859375
		 46 41.382854461669922 47 44.187175750732422 48 47.848724365234375 49 52.059158325195313
		 50 56.532611846923828 51 61.525211334228516 52 66.412399291992188 53 69.736526489257813
		 54 72.393096923828125 55 74.159835815429687 56 75.032089233398438 57 75.194740295410156
		 58 74.960739135742187 59 74.653190612792969 60 74.477813720703125 61 74.527450561523438
		 62 74.786201477050781 63 75.178634643554687 64 75.603469848632813 65 76.355789184570313
		 66 76.894035339355469 67 77.256515502929688 68 77.419692993164062 69 77.3826904296875
		 70 77.179855346679688 71 76.88140869140625 72 76.524467468261719 73 76.116218566894531
		 74 75.715957641601563 75 75.393783569335937 76 75.223159790039063 77 75.1556396484375
		 78 75.10009765625 79 75.062461853027344 80 75.048683166503906;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "741D0C30-46DB-87FC-E93D-ACA8D26A2889";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.695053100585937 1 -47.964523315429688
		 2 -45.919803619384766 3 -42.869110107421875 4 -39.192123413085937 5 -35.336277008056641
		 6 -31.754421234130859 7 -28.840267181396484 8 -26.908357620239258 9 -26.330999374389648
		 10 -27.145900726318359 11 -29.295455932617188 12 -32.829704284667969 13 -37.518943786621094
		 14 -42.735008239746094 15 -47.536212921142578 16 -51.105113983154297 17 -53.146888732910156
		 18 -53.991916656494141 19 -54.276374816894531 20 -54.444053649902344 21 -54.762054443359375
		 22 -55.24072265625 23 -55.790672302246094 24 -56.379745483398438 25 -56.952228546142578
		 26 -57.466457366943359 27 -57.888507843017578 28 -58.193328857421875 29 -58.36199951171875
		 30 -58.459571838378906 31 -58.560207366943359 32 -58.667518615722656 33 -58.785942077636719
		 34 -58.914352416992188 35 -59.050788879394531 36 -59.192001342773437 37 -59.333549499511719
		 38 -59.459209442138672 39 -59.562923431396484 40 -59.654445648193359 41 -59.7432861328125
		 42 -59.839225769042969 43 -59.9561767578125 44 -60.098819732666016 45 -60.265239715576172
		 46 -60.449996948242187 47 -60.574729919433594 48 -60.495101928710937 49 -59.913177490234375
		 50 -58.452281951904297 51 -55.314975738525391 52 -50.046707153320313 53 -45.490234375
		 54 -40.389350891113281 55 -35.147357940673828 56 -30.176486968994141 57 -25.830432891845703
		 58 -22.361309051513672 59 -19.778947830200195 60 -18.048076629638672 61 -17.098676681518555
		 62 -16.831441879272461 63 -17.183986663818359 64 -18.062856674194336 65 -21.548700332641602
		 66 -24.444662094116211 67 -27.434955596923828 68 -30.510883331298828 69 -33.569675445556641
		 70 -36.481216430664063 71 -39.113239288330078 72 -41.453174591064453 73 -43.520565032958984
		 74 -45.2427978515625 75 -46.557331085205078 76 -47.408554077148438 77 -47.947341918945313
		 78 -48.351734161376953 79 -48.6063232421875 80 -48.695053100585937;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "0B9D4E64-4DDB-1DE2-43E7-F8AA4B10BBBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -47.787920050703022 1 -46.950142564235904
		 2 -44.474744541064979 3 -40.748193595774815 4 -36.100476655007974 5 -30.940296407247466
		 6 -25.798273757056872 7 -21.179923897031667 8 -17.41044412790874 9 -15.759751943883268
		 10 -17.175224281225251 11 -22.5967046461808 12 -32.686947457605157 13 -45.698873236554626
		 14 -58.15024284493343 15 -68.073499387517472 16 -75.69625518439608 17 -81.659445682431098
		 18 -86.049138268053241 19 -89.151294529906735 20 -91.24241155794985 21 -92.095410708351153
		 22 -92.192697029832814 23 -92.093546856236742 24 -91.808611202456945 25 -91.356640375981925
		 26 -90.762874463678003 27 -90.111317797623741 28 -89.461009784113642 29 -88.79507527626042
		 30 -88.067193693435115 31 -87.248207429677848 32 -86.338926709726167 33 -85.339422833016812
		 34 -84.256458200651068 35 -83.09919004142543 36 -81.880802289667045 37 -80.617503572924619
		 38 -79.329525432341242 39 -78.037374767987259 40 -76.761075096213233 41 -75.520712696840647
		 42 -74.335515374661099 43 -73.241557760074073 44 -72.253865598794164 45 -71.328387211295009
		 46 -70.392319041402985 47 -69.061998860760895 48 -66.721577497829713 49 -62.818000045984846
		 50 -56.849385427642204 51 -46.555989276829557 52 -30.373106906724885 53 -19.87694793284107
		 54 -10.14316837939052 55 -1.8730461113277681 56 4.6279694703961649 57 9.1759610575011354
		 58 11.583029776869225 59 12.221632198628962 60 11.648786188827019 61 10.410304004367081
		 62 9.3857194251234422 63 8.3474053103311494 64 6.7013096480591008 65 -5.8033948648352531
		 66 -14.920774051592234 67 -22.913783264633032 68 -29.829212518492724 69 -35.492463637777291
		 70 -39.78659309384863 71 -42.660378468566599 72 -44.603748507905813 73 -46.140187527259698
		 74 -47.258039395609089 75 -47.925893679120101 76 -48.090746239698035 77 -47.981029118150147
		 78 -47.883091278039323 79 -47.813774916595612 80 -47.787920050703022;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "FA615FF3-47CE-7818-6D85-9A9C2F9D73CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.830938122333585 1 -49.638853462701626
		 2 -51.726139316835209 3 -54.418626731046899 4 -57.137985411587891 5 -59.489040222917694
		 6 -61.28026992887439 7 -62.49202892956734 8 -63.195865717272433 9 -63.431768125088766
		 10 -63.205240877796193 11 -62.333824823387133 12 -60.173271238484723 13 -55.544181388874101
		 14 -47.778338545347552 15 -37.581539598963062 16 -26.413936394621807 17 -15.799665039088191
		 18 -7.1439773368771364 19 -0.25137523999885886 20 5.6562938028326668 21 10.287927292930602
		 22 13.914753104799322 23 16.883183360783946 24 19.095324939928645 25 20.51314929459641
		 26 21.165222562483102 27 21.41835471633771 28 21.716702331010133 29 22.237583609197728
		 30 22.775048269820314 31 23.014891676039973 32 23.014438658728785 33 22.838526847808243
		 34 22.489426039218518 35 21.968979690313944 36 21.279750958361529 37 20.426007964413952
		 38 19.401913111686131 39 18.218145974368316 40 16.908198471803814 41 15.509410512183582
		 42 14.062712264041906 43 12.587507425864196 44 11.105126392405641 45 9.6437891664844511
		 46 7.13742367054925 47 2.5442678396071843 48 -4.1068950498723149 49 -12.204904866411965
		 50 -21.158522688960176 51 -32.046211929983187 52 -40.700728821267063 53 -42.884279751345836
		 54 -44.406933499067584 55 -45.40628745682146 56 -46.139661758743273 57 -46.903433548014554
		 58 -48.01688915934642 59 -49.496311282848339 60 -51.1442729217775 61 -52.752917651506863
		 62 -54.065995731912722 63 -55.185229036242774 64 -56.236807560255286 65 -58.139799586576991
		 66 -58.442421851873377 67 -57.960958211964027 68 -56.917621527465087 69 -55.542626204365412
		 70 -54.096546616340376 71 -52.843172433511732 72 -51.782360521405295 73 -50.785518266043802
		 74 -49.92816388643859 75 -49.303732255274596 76 -49.02050672760987 77 -48.948950553672645
		 78 -48.888549033767106 79 -48.846611150529149 80 -48.830938122333585;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "AFA7EE13-457B-039F-E93F-56AE3E10CEF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 23.32502166384155 1 23.37596508289559
		 2 23.13771697484945 3 22.141690375416591 4 20.12043514085974 5 17.170762821800139
		 6 13.663435485795794 7 9.9697423270580003 8 6.2410504896341585 9 3.473607300094995
		 10 2.612518397354386 11 4.8088818814626784 12 10.872876671341386 13 19.032577378470588
		 14 25.501256012135251 15 27.817997022227626 16 25.929838021711042 17 20.934697839963164
		 18 14.308040919701339 19 7.6324858617496032 20 1.9393450556691827 21 -2.2519925599838859
		 22 -5.4138194270711484 23 -8.1773335635832716 24 -10.546784265698138 25 -12.573469728600172
		 26 -14.28253673344827 27 -15.646056687510915 28 -16.60292645820115 29 -17.110886046786234
		 30 -17.348712923745158 31 -17.533195737210896 32 -17.66004727145031 33 -17.725277379159927
		 34 -17.733191684976966 35 -17.691388889123569 36 -17.612016306401607 37 -17.511020116274484
		 38 -17.430207062334699 39 -17.390271708011451 40 -17.378245509458793 41 -17.379691477766563
		 42 -17.37688608563278 43 -17.294397107607505 44 -17.065241924091321 45 -16.659969751220441
		 46 -16.376637615624084 47 -16.555561805916003 48 -17.405334190723465 49 -18.46462040042238
		 50 -19.686422544786392 51 -24.922599886494112 52 -35.452147753137567 53 -36.060225241999269
		 54 -36.782287360425059 55 -37.343207108948306 56 -37.459210680329932 57 -36.842008037275235
		 58 -35.186335726252537 59 -32.665314629146046 60 -29.691936537878654 61 -26.792935362448958
		 62 -24.839767041760933 63 -23.462747386467331 64 -21.915775707147116 65 -8.1335370425537459
		 66 1.1352186160176734 67 8.795211829492926 68 15.04591380207269 69 19.786985412210949
		 70 22.962779924796134 71 24.601525967887905 72 25.223790460335813 73 25.379565503996091
		 74 25.187335854134364 75 24.793131058022414 76 24.356566673102478 77 23.964877650897499
		 78 23.634481113649393 79 23.408121955663479 80 23.32502166384155;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA";
	rename -uid "E4BDE82F-4F7A-6D61-AAFF-389499B07D0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.4979124069213867 1 2.4973907470703125
		 2 2.4959568977355957 3 2.4938364028930664 4 2.4912586212158203 5 2.4884190559387207
		 6 2.485490083694458 7 2.4826207160949707 8 2.479874849319458 9 2.4773547649383545
		 10 2.4750995635986328 11 2.4732072353363037 12 2.4717307090759277 13 2.4706764221191406
		 14 2.4690835475921631 15 2.4664497375488281 16 2.4634699821472168 17 2.4605932235717773
		 18 2.4582014083862305 19 2.4564807415008545 20 2.4524073600769043 21 2.4480576515197754
		 22 2.4440834522247314 23 2.4403352737426758 24 2.4367003440856934 25 2.4330806732177734
		 26 2.4294159412384033 27 2.4259374141693115 28 2.4229867458343506 29 2.4206929206848145
		 30 2.4191689491271973 31 2.4185543060302734 32 2.4184412956237793 33 2.418337345123291
		 34 2.418241024017334 35 2.4181857109069824 36 2.4181680679321289 37 2.4182219505310059
		 38 2.4183874130249023 39 2.4186985492706299 40 2.4190735816955566 41 2.4194414615631104
		 42 2.419734001159668 43 2.4198606014251709 44 2.4197762012481689 45 2.4193873405456543
		 46 2.418454647064209 47 2.4168028831481934 48 2.4145655632019043 49 2.4058487415313721
		 50 2.3955168724060059 51 2.3871264457702637 52 2.3797178268432617 53 2.3747129440307617
		 54 2.3733320236206055 55 2.3763494491577148 56 2.3839259147644043 57 2.3956270217895508
		 58 2.4103856086730957 59 2.4268729686737061 60 2.4436497688293457 61 2.4591050148010254
		 62 2.4719295501708984 63 2.4816470146179199 64 2.4879188537597656 65 2.4918098449707031
		 66 2.4947528839111328 67 2.4969000816345215 68 2.498359203338623 69 2.4992923736572266
		 70 2.4998126029968262 71 2.4999809265136719 72 2.4999411106109619 73 2.499741792678833
		 74 2.4994492530822754 75 2.4991011619567871 76 2.4987564086914062 77 2.4984397888183594
		 78 2.4981727600097656 79 2.4979839324951172 80 2.4979124069213867;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA";
	rename -uid "7C98384D-4FF4-8840-165F-D7BAA5A53425";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 54.945686340332031 1 54.956375122070313
		 2 54.984699249267578 3 55.02490234375 4 55.0711669921875 5 55.117870330810547 6 55.159652709960938
		 7 55.191635131835937 8 55.209381103515625 9 55.208835601806641 10 55.186336517333984
		 11 55.138336181640625 12 55.063102722167969 13 54.961994171142578 14 54.798492431640625
		 15 54.548984527587891 16 54.230438232421875 17 53.854534149169922 18 53.432441711425781
		 19 52.974693298339844 20 52.468647003173828 21 51.941574096679688 22 51.410224914550781
		 23 50.886333465576172 24 50.382965087890625 25 49.914436340332031 26 49.494480133056641
		 27 49.124279022216797 28 48.801982879638672 29 48.536605834960938 30 48.337253570556641
		 31 48.213016510009766 32 48.135719299316406 33 48.070896148681641 34 48.018112182617188
		 35 47.976951599121094 36 47.947036743164062 37 47.927902221679688 38 47.919761657714844
		 39 47.922130584716797 40 47.933563232421875 41 47.952583312988281 42 47.977767944335938
		 43 48.007694244384766 44 48.040904998779297 45 48.075939178466797 46 48.108871459960937
		 47 48.136886596679688 48 48.160110473632813 49 48.139114379882813 50 48.164016723632813
		 51 48.34295654296875 52 48.676807403564453 53 49.139236450195313 54 49.704475402832031
		 55 50.347396850585938 56 51.0430908203125 57 51.766010284423828 58 52.489303588867188
		 59 53.184524536132812 60 53.821662902832031 61 54.384033203125 62 54.860256195068359
		 63 55.223926544189453 64 55.449050903320313 65 55.574081420898438 66 55.655143737792969
		 67 55.6971435546875 68 55.704967498779297 69 55.68359375 70 55.638004302978516 71 55.573192596435547
		 72 55.494163513183594 73 55.4058837890625 74 55.313343048095703 75 55.221508026123047
		 76 55.135330200195313 77 55.059730529785156 78 54.999649047851562 79 54.959991455078125
		 80 54.945686340332031;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA";
	rename -uid "5B8DA75E-4E94-D4E5-33CE-DBBD70A1F16E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -24.125894546508789 1 -24.1007080078125
		 2 -24.027471542358398 3 -23.909452438354492 4 -23.749912261962891 5 -23.552495956420898
		 6 -23.321456909179688 7 -23.061737060546875 8 -22.778980255126953 9 -22.479204177856445
		 10 -22.168701171875 11 -21.853603363037109 12 -21.535274505615234 13 -21.207294464111328
		 14 -20.866117477416992 15 -20.440227508544922 16 -19.87938117980957 17 -19.212753295898437
		 18 -18.46983528137207 19 -17.680942535400391 20 -16.892726898193359 21 -16.127939224243164
		 22 -15.415826797485352 23 -14.789743423461914 24 -14.25285530090332 25 -13.780488967895508
		 26 -13.364872932434082 27 -13.006662368774414 28 -12.707485198974609 29 -12.460882186889648
		 30 -12.260393142700195 31 -12.099453926086426 32 -11.972915649414063 33 -11.875882148742676
		 34 -11.802051544189453 35 -11.745203971862793 36 -11.69907283782959 37 -11.657353401184082
		 38 -11.598689079284668 39 -11.518488883972168 40 -11.435910224914551 41 -11.370016098022461
		 42 -11.339897155761719 43 -11.36466121673584 44 -11.463356971740723 45 -11.655027389526367
		 46 -12.016538619995117 47 -12.592147827148438 48 -13.351764678955078 49 -14.299853324890137
		 50 -15.380974769592285 51 -16.522407531738281 52 -17.678678512573242 53 -18.820394515991211
		 54 -19.921054840087891 55 -20.959222793579102 56 -21.91937255859375 57 -22.791164398193359
		 58 -23.567478179931641 59 -24.242111206054688 60 -24.807186126708984 61 -25.223039627075195
		 62 -25.436031341552734 63 -25.516592025756836 64 -25.55927848815918 65 -25.566278457641602
		 66 -25.539291381835938 67 -25.482583999633789 68 -25.400457382202148 69 -25.29730224609375
		 70 -25.177642822265625 71 -25.046016693115234 72 -24.907114028930664 73 -24.765720367431641
		 74 -24.626697540283203 75 -24.495018005371094 76 -24.375791549682617 77 -24.274101257324219
		 78 -24.195152282714844 79 -24.144039154052734 80 -24.125894546508789;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX";
	rename -uid "7076E76D-4A14-E8D7-20C4-3FB849AC3EBB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.386871940428331 1 2.4197458699551273
		 2 2.5067341593139707 3 2.6305381443062674 4 2.7736327136074355 5 2.9179798470829121
		 6 3.0449247242977737 7 3.1352704672083305 8 3.1696521206773722 9 3.1121007018757565
		 10 2.9548636743500012 11 2.7216808748591994 12 2.4363954827202536 13 2.1221208347107852
		 14 1.800882987450934 15 1.493523573414917 16 1.2195384914976719 17 0.99705847226503541
		 18 0.84269689556188887 19 0.73744567654996096 20 0.65417168568422102 21 0.59619044159339551
		 22 0.5537511021456073 23 0.51488206851148788 24 0.47956662114417481 25 0.44770206541870639
		 26 0.41923889956424459 27 0.39407962689363168 28 0.37219553931930877 29 0.3534809120580899
		 30 0.33791273603562816 31 0.32540984251424981 32 0.31589921185016206 33 0.30938022154678896
		 34 0.30576173432620668 35 0.30503253049272189 36 0.30712393770896007 37 0.3120621609958758
		 38 0.31977411346933898 39 0.33026274626455382 40 0.34349671990160374 41 0.35945627798728796
		 42 0.37814166260221238 43 0.4033050102692125 44 0.43799243842062924 45 0.48114350922053256
		 46 0.56371930129358949 47 0.71128896726015711 48 0.91417852355635187 49 1.1621421676091255
		 50 1.4444086416301132 51 1.7498467291818534 52 2.0668067368152911 53 2.3831655828245406
		 54 2.6861884937849183 55 2.9623357100653633 56 3.1972913629983779 57 3.3760123144218905
		 58 3.4829422432591763 59 3.5307346076228514 60 3.5440598728049961 61 3.5255740253810792
		 62 3.4781865224205109 63 3.4051652267406309 64 3.3091157623422687 65 3.1957730456028091
		 66 3.0725544817424368 67 2.9466996857639325 68 2.8252068113122077 69 2.7148253660665449
		 70 2.6220627638190463 71 2.5532701864906349 72 2.5009029390575499 73 2.4552665189463796
		 74 2.4191429103791355 75 2.3954059697724359 76 2.3868719593252306 77 2.3868573357737213
		 78 2.3868561193374354 79 2.3868652881894805 80 2.386871940428331;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY";
	rename -uid "0A15A0E8-4F7F-0F5F-0026-F29B521BE171";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.334574372843704 1 15.314458823817404
		 2 15.261723874748611 3 15.188539116205387 4 15.106526630076869 5 15.026366621887595
		 6 14.95788142755435 7 14.910183929324338 8 14.892275390639725 9 14.914207847527846
		 10 14.975771275859309 11 15.07088235974469 12 15.194023148658388 13 15.339705307232334
		 14 15.502068106791578 15 15.67477506723433 16 15.850197142763166 17 16.019171130279371
		 18 16.170424868303655 19 16.298218710090623 20 16.397350843374269 21 16.456802171068798
		 22 16.4919035740865 23 16.525650563335901 24 16.55780264052078 25 16.588155397041266
		 26 16.616522477023963 27 16.642596400086656 28 16.666269904066613 29 16.687154142511996
		 30 16.70514357103497 31 16.71991600385573 32 16.731280600130326 33 16.739084098540214
		 34 16.743061040030447 35 16.743049790481443 36 16.738878242331136 37 16.730325161412072
		 38 16.717385542184132 39 16.699848472332587 40 16.677595496939599 41 16.650708366955847
		 42 16.619022728299509 43 16.574377983798353 44 16.51075005480152 45 16.431774417435708
		 46 16.333711409131375 47 16.214805734431113 48 16.081406371336637 49 15.939249921943748
		 50 15.793618595943256 51 15.648303458095864 52 15.506909331309119 53 15.372159224299464
		 54 15.246341014319563 55 15.131338231356246 56 15.02914463129097 57 14.941634920541183
		 58 14.871014979497795 59 14.816847767710131 60 14.776972923201299 61 14.751881545350882
		 62 14.741728648573819 63 14.746963569805155 64 14.768119193050458 65 14.803647413407298
		 66 14.850534666385006 67 14.905767178642359 68 14.966626011146122 69 15.030241798674874
		 70 15.093671557026068 71 15.153736837635847 72 15.209120151900777 73 15.258567107460941
		 74 15.298415546812294 75 15.32495699616307 76 15.334586142849778 77 15.334563497607448
		 78 15.334548138684347 79 15.334570473249153 80 15.334574372843704;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ";
	rename -uid "06E4EF97-4678-0E0C-B96D-6C80800BBE8A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.1708668588936879 1 -3.6919798208252779
		 2 -2.4018049733193885 3 -0.52042627436266797 4 1.7319845285859461 5 4.1353784954622901
		 6 6.469709455622338 7 8.5147317716275879 8 10.050196792020181 9 10.796831266565155
		 10 10.630994348937502 11 9.5664791006276655 12 7.680225088809304 13 5.1564570278034942
		 14 2.1693076006630894 15 -1.1065939736520349 16 -4.4970209627198541 17 -7.8273933355290364
		 18 -10.923290915630213 19 -13.772129481123688 20 -16.40682456265888 21 -18.721078429654622
		 22 -20.760229519100477 23 -22.600350970434331 24 -24.180931561138891 25 -25.441579100341343
		 26 -26.321866503965111 27 -26.958516065674491 28 -27.529092089338121 29 -28.034532468105866
		 30 -28.475923239957641 31 -28.854261712862474 32 -29.170485020946671 33 -29.425537504474676
		 34 -29.620606628447035 35 -29.756524349795772 36 -29.834380217493166 37 -29.85500565476508
		 38 -29.819521197170332 39 -29.728918833536639 40 -29.584137286581662 41 -29.386153352158267
		 42 -29.135989364566313 43 -28.788442563228916 44 -28.307353585309098 45 -27.707615323624392
		 46 -26.854301428971027 47 -25.644890432164274 48 -24.142535371847355 49 -22.410239341681873
		 50 -20.511246159346225 51 -18.008652599080602 52 -14.604703322849538 53 -10.571124866203244
		 54 -6.1793128893374982 55 -1.7007997727030568 56 2.5927730287411181 57 6.4297932542104839
		 58 9.5388812825185418 59 11.763277891716006 60 12.99006653602385 61 13.439542617080017
		 62 13.487247458264418 63 13.15952763525889 64 12.477753756974993 65 11.489255026538778
		 66 10.258683125060557 67 8.8509792429480658 68 7.3312364387644235 69 5.764386655089945
		 70 4.2151895351345807 71 2.7487109816421311 72 1.3716038373063422 73 0.079397383689098322
		 74 -1.080256338310227 75 -2.0593617899063958 76 -2.8102127374626007 77 -3.371950303543068
		 78 -3.8009462682128095 79 -4.0746627202851853 80 -4.1708668588936879;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA";
	rename -uid "67391FD0-4BC6-98EC-5E4B-A795A54C9C21";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.5506343841552734 1 -1.519658088684082
		 2 -1.4369487762451172 3 -1.3179950714111328 4 -1.1790533065795898 5 -1.0379219055175781
		 6 -0.91370201110839844 7 -0.82595920562744141 8 -0.79424285888671875 9 -0.83546829223632813
		 10 -0.94058322906494141 11 -1.0854158401489258 12 -1.244328498840332 13 -1.3957195281982422
		 14 -1.5281877517700195 15 -1.6423177719116211 16 -1.7487916946411133 17 -1.8652448654174805
		 18 -2.0093622207641602 19 -2.1558437347412109 20 -2.2619233131408691 21 -2.3098897933959961
		 22 -2.3241472244262695 23 -2.339867115020752 24 -2.3568425178527832 25 -2.3747386932373047
		 26 -2.3932332992553711 27 -2.4115972518920898 28 -2.4291110038757324 29 -2.4450874328613281
		 30 -2.4590067863464355 31 -2.4702048301696777 32 -2.4785962104797363 33 -2.4842724800109863
		 34 -2.4866743087768555 35 -2.4853630065917969 36 -2.4798750877380371 37 -2.4697360992431641
		 38 -2.4545230865478516 39 -2.4337701797485352 40 -2.4071931838989258 41 -2.3745584487915039
		 42 -2.3355875015258789 43 -2.2778925895690918 44 -2.1921653747558594 45 -2.0833396911621094
		 46 -1.9930658340454102 47 -1.9513912200927734 48 -1.9427976608276367 49 -1.9542665481567383
		 50 -1.9607715606689453 51 -1.9399423599243164 52 -1.8794097900390625 53 -1.7721748352050781
		 54 -1.6204652786254883 55 -1.4349708557128906 56 -1.2328901290893555 57 -1.0343618392944336
		 58 -0.85941982269287109 59 -0.71858596801757813 60 -0.61195278167724609 61 -0.54102230072021484
		 62 -0.50535678863525391 63 -0.50336360931396484 64 -0.53401565551757813 65 -0.59116554260253906
		 66 -0.66667461395263672 67 -0.75537300109863281 68 -0.85354709625244141 69 -0.95859146118164063
		 70 -1.0685567855834961 71 -1.1816234588623047 72 -1.2926826477050781 73 -1.39312744140625
		 74 -1.4748334884643555 75 -1.5296688079833984 76 -1.5497980117797852 77 -1.5501012802124023
		 78 -1.5503568649291992 79 -1.5505704879760742 80 -1.5506343841552734;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA";
	rename -uid "88254FD5-4E75-D842-DE1B-37A0EC0DCBA0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 98.593429565429687 1 98.744338989257813
		 2 99.046768188476563 3 99.230239868164063 4 99.0777587890625 5 98.521255493164062
		 6 97.673858642578125 7 96.801177978515625 8 96.245468139648438 9 96.395149230957031
		 10 97.257919311523438 11 98.42535400390625 12 99.323974609375 13 99.361099243164063
		 14 98.074920654296875 15 95.321685791015625 16 91.358917236328125 17 86.745262145996094
		 18 82.208755493164062 19 78.044692993164063 20 74.240097045898438 21 71.12579345703125
		 22 68.510467529296875 23 66.050094604492188 24 63.814476013183594 25 61.872703552246094
		 26 60.290699005126953 27 58.980827331542969 28 57.820125579833984 29 56.819034576416016
		 30 55.987655639648437 31 55.3359375 32 54.836383819580078 33 54.455169677734375 34 54.192268371582031
		 35 54.047950744628906 36 54.022323608398437 37 54.115653991699219 38 54.328811645507813
		 39 54.661994934082031 40 55.114555358886719 41 55.685714721679687 42 56.374614715576172
		 43 57.330532073974609 44 58.6719970703125 45 60.349563598632812 46 62.772891998291016
		 47 66.217254638671875 48 70.387130737304688 49 74.890243530273437 50 79.426658630371094
		 51 83.955696105957031 52 88.151885986328125 53 91.441482543945313 54 93.490234375
		 55 94.265518188476563 56 94.020072937011719 57 93.207412719726563 58 92.365585327148438
		 59 91.820220947265625 60 91.676445007324219 61 91.946090698242188 62 92.515899658203125
		 63 93.339569091796875 64 94.352790832519531 65 95.489082336425781 66 96.663528442382813
		 67 97.750717163085938 68 98.650764465332031 69 99.301567077636719 70 99.68560791015625
		 71 99.829666137695313 72 99.799034118652344 73 99.645431518554687 74 99.416915893554688
		 75 99.172256469726563 76 98.971038818359375 77 98.820831298828125 78 98.700942993164063
		 79 98.621833801269531 80 98.593429565429687;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA";
	rename -uid "9F9F2B00-4FA8-E9C8-E3FF-E3BD643D91EF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -32.560287475585938 1 -31.650249481201172
		 2 -29.215583801269531 3 -25.711334228515625 4 -21.623416900634766 5 -17.45301628112793
		 6 -13.673020362854004 7 -10.690975189208984 8 -8.8524980545043945 9 -8.6600484848022461
		 10 -10.292746543884277 11 -13.660284042358398 12 -18.594673156738281 13 -24.688968658447266
		 14 -31.358875274658203 15 -37.839805603027344 16 -43.430126190185547 17 -47.70611572265625
		 18 -50.524810791015625 19 -52.240447998046875 20 -53.246391296386719 21 -53.669887542724609
		 22 -53.792793273925781 23 -53.822822570800781 24 -53.775543212890625 25 -53.643627166748047
		 26 -53.438560485839844 27 -53.212791442871094 28 -53.012382507324219 29 -52.837882995605469
		 30 -52.689098358154297 31 -52.56488037109375 32 -52.46466064453125 33 -52.387283325195313
		 34 -52.329326629638672 35 -52.286510467529297 36 -52.253635406494141 37 -52.224510192871094
		 38 -52.176944732666016 39 -52.104534149169922 40 -52.023632049560547 41 -51.949451446533203
		 42 -51.896194458007812 43 -51.86859130859375 44 -51.854244232177734 45 -51.836692810058594
		 46 -51.756362915039063 47 -51.405433654785156 48 -50.535793304443359 49 -48.979164123535156
		 50 -46.610061645507813 51 -43.112716674804687 52 -38.305702209472656 53 -32.530349731445313
		 54 -26.314865112304688 55 -20.259754180908203 56 -14.909563064575195 57 -10.663665771484375
		 58 -7.7589826583862305 59 -6.0455904006958008 60 -5.2935619354248047 61 -5.2392768859863281
		 62 -5.5510673522949219 63 -6.2819013595581055 64 -7.5435924530029297 65 -9.3064737319946289
		 66 -11.490542411804199 67 -13.997759819030762 68 -16.704082489013672 69 -19.461523056030273
		 70 -22.10565185546875 71 -24.465072631835938 72 -26.552070617675781 73 -28.423854827880859
		 74 -29.980636596679688 75 -31.126899719238281 76 -31.771364212036133 77 -32.099075317382813
		 78 -32.347549438476562 79 -32.505115509033203 80 -32.560287475585938;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX";
	rename -uid "E65AA8C3-40D1-5DB6-8210-E1AA4E943EBF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.47961850936799472 1 0.46097246430040684
		 2 0.40562495557159839 3 0.31092192737631369 4 0.17694241687199427 5 0.01379550179774579
		 6 -0.15386173796668132 7 -0.28738600819159255 8 -0.34136948107739418 9 -0.32021662932031725
		 10 -0.27174072064637855 11 -0.2252708861097423 12 -0.20100942747195505 13 -0.19687898099398821
		 14 -0.19054677862328878 15 -0.15425308446737271 16 -0.072637236286926588 17 0.04655345680179717
		 18 0.17603793275000915 19 0.27386196013109737 20 0.32973921623662522 21 0.35574355470467878
		 22 0.37021753930685769 23 0.38511725672063024 24 0.39987039327304158 25 0.41406164985297816
		 26 0.42725913000129478 27 0.4392744154085893 28 0.44982987804670982 29 0.45895227478570766
		 30 0.4664974003304006 31 0.47254297932252232 32 0.47712109375117151 33 0.48021489762112035
		 34 0.48198571240959975 35 0.48240185389910023 36 0.48150548477582311 37 0.47929416893313259
		 38 0.47554254846517141 39 0.47012708803166681 40 0.46270723738563363 41 0.45269386904499781
		 42 0.43954587689378155 43 0.41832403974025278 44 0.38137174724387601 45 0.32251796697867152
		 46 0.23762423245454645 47 0.14688126060477208 48 0.084093954676081092 49 0.079492758208090944
		 50 0.14893921094921372 51 0.28815133805100951 52 0.47078252426101824 53 0.65483640861526893
		 54 0.79319045947626809 55 0.84535398159861841 56 0.78654702321954895 57 0.61064578269179604
		 58 0.32641806434658877 59 -0.01003354046760644 60 -0.33447040377848641 61 -0.62273922471583598
		 62 -0.85526274487848575 63 -1.0166092978458419 64 -1.0921290538405262 65 -1.0867395838287464
		 66 -1.0172954570757129 67 -0.89859069088674748 68 -0.7426555643535685 69 -0.55873935094216354
		 70 -0.35364948811291325 71 -0.13192148660625849 72 0.078852646862055967 73 0.24903835597553411
		 74 0.37448599319481635 75 0.45245644348720176 76 0.47961276430911287 77 0.47962150864002012
		 78 0.47961978444573067 79 0.47961866153220001 80 0.47961850936799472;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY";
	rename -uid "D47AF182-45C7-6B84-2748-73A885184C07";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.1647232103758451 1 -4.2472576748016069
		 2 -4.4673589176354085 3 -4.7835563796184042 4 -5.1518848299524054 5 -5.5243272890505395
		 6 -5.8506867684940813 7 -6.081340936234314 8 -6.1685987273236549 9 -6.0626743509422445
		 10 -5.7798155160980311 11 -5.3822596518709274 12 -4.9371653626358558 13 -4.5020455230761813
		 14 -4.1104829125369555 15 -3.7646598405952414 16 -3.4408287405542839 17 -3.1044983171060001
		 18 -2.7274116676348945 19 -2.3655809622212733 20 -2.1091960498196274 21 -1.990757964433719
		 22 -1.9501775617725881 23 -1.9071383183736565 24 -1.8624900405586287 25 -1.8171971622915608
		 26 -1.7722623196534026 27 -1.7286525259824619 28 -1.687318294826869 29 -1.649324818105655
		 30 -1.615607612179407 31 -1.5872051161872862 32 -1.565090829006468 33 -1.5501993874418896
		 34 -1.543543910220101 35 -1.5459844297867207 36 -1.5584925393042319 37 -1.5819217848174305
		 38 -1.6172110108320552 39 -1.6652052698951016 40 -1.7267267755811067 41 -1.8026643778488891
		 42 -1.8937581570688167 43 -2.0287508695227188 44 -2.2301364917640427 45 -2.4887076491278637
		 46 -2.7299187809861851 47 -2.8944346450022125 48 -3.0021466577713145 49 -3.0843597675812227
		 50 -3.1816462768977547 51 -3.3369564628695696 52 -3.5843472776070331 53 -3.9392216379819995
		 54 -4.3922447479023594 55 -4.9102272310031214 56 -5.4425626427073688 57 -5.9317869649808053
		 58 -6.3240309381775441 59 -6.6051447396658185 60 -6.7928181020817888 61 -6.8921642644495416
		 62 -6.9116058401872964 63 -6.8598577769276652 64 -6.7423911652837631 65 -6.5715617870343292
		 66 -6.362398244479035 67 -6.1259493707249391 68 -5.8705722974362882 69 -5.6026117017493577
		 70 -5.3276350098720044 71 -5.0515771319787763 72 -4.7838076568428107 73 -4.5414761445893559
		 74 -4.3444702131728148 75 -4.2125940982015386 76 -4.1647121014999486 77 -4.1647397509917647
		 78 -4.1647541760245899 79 -4.1647020241089372 80 -4.1647232103758451;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ";
	rename -uid "80FAF895-47BD-DBCA-4DB9-81BA4301890B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -30.995248267722573 1 -29.252033520398474
		 2 -24.628258572834678 3 -18.032782016444209 4 -10.374463990520269 5 -2.5625735828433061
		 6 4.4923307812030364 7 9.8779247403063248 8 12.680896691315885 9 11.597408366202522
		 10 6.3796909762072316 11 -2.3005179330143082 12 -13.709620484456567 13 -27.008382953667194
		 14 -41.368134275897994 15 -55.959079572914241 16 -69.949960860731039 17 -82.507871728361479
		 18 -92.799147250241575 19 -101.07226534103562 20 -107.88023650864073 21 -112.846099708194
		 22 -116.62899572268518 23 -120.09757325806989 24 -123.18831996324866 25 -125.83785699151828
		 26 -127.98303699222782 27 -129.75745694070329 28 -131.33584373256267 29 -132.71622546279875
		 30 -133.8967653851611 31 -134.87552508306285 32 -135.65056131622183 33 -136.21989611962931
		 34 -136.58184159490551 35 -136.73419519844262 36 -136.67525727222272 37 -136.40295488684481
		 38 -135.91540586064789 39 -135.21073113221084 40 -134.2869198689761 41 -133.14203412376946
		 42 -131.77417039670124 43 -129.8655738717585 44 -127.16106959281451 45 -123.75292293945314
		 46 -118.73344954255516 47 -111.41109359661476 48 -102.20253390172293 49 -91.524325345176237
		 50 -79.792969222493682 51 -66.924083214553832 52 -52.971542379854924 53 -38.557562490912382
		 54 -24.302603243350489 55 -10.826115086283947 56 1.2527077204287063 57 11.314198233429662
		 58 18.737361562326729 59 23.66517123194361 60 26.53150371112315 61 27.576415305397902
		 62 27.195597260458001 63 25.435981644908473 64 22.31038182815993 65 18.007762789651199
		 66 12.839433193912964 67 7.1168338469667134 68 1.1513708188367819 69 -4.7458897569424705
		 70 -10.264332357675734 71 -15.093237616938776 72 -19.309954989481383 73 -23.067920740000574
		 74 -26.171765667460768 75 -28.425846037767698 76 -29.634597514496033 77 -30.196322229032674
		 78 -30.625287433407578 79 -30.899009506664594 80 -30.995248267722573;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA";
	rename -uid "CA542771-4BA1-FA12-5201-46B25D408CA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 22.760416030883789 1 22.760553359985352
		 2 22.760950088500977 3 22.761556625366211 4 22.7623291015625 5 22.76319694519043
		 6 22.76411247253418 7 22.765039443969727 8 22.765966415405273 9 22.766864776611328
		 10 22.767759323120117 11 22.768722534179688 12 22.769853591918945 13 22.77131462097168
		 14 22.773632049560547 15 22.777524948120117 16 22.78349494934082 17 22.791879653930664
		 18 22.802839279174805 19 22.816373825073242 20 22.832189559936523 21 22.849742889404297
		 22 22.868257522583008 23 22.886764526367188 24 22.90458869934082 25 22.921577453613281
		 26 22.937463760375977 27 22.951847076416016 28 22.964530944824219 29 22.975252151489258
		 30 22.983787536621094 31 22.989879608154297 32 22.994209289550781 33 22.997705459594727
		 34 23.000425338745117 35 23.00255012512207 36 23.004201889038086 37 23.005502700805664
		 38 23.006923675537109 39 23.008556365966797 40 23.010055541992188 41 23.011014938354492
		 42 23.011066436767578 43 23.009847640991211 44 23.006980895996094 45 23.002141952514648
		 46 22.993865966796875 47 22.981512069702148 48 22.966018676757813 49 22.948400497436523
		 50 22.928266525268555 51 22.905738830566406 52 22.882482528686523 53 22.860084533691406
		 54 22.839818954467773 55 22.822637557983398 56 22.808965682983398 57 22.798727035522461
		 58 22.791261672973633 59 22.785930633544922 60 22.781595230102539 61 22.777730941772461
		 62 22.774215698242188 63 22.771217346191406 64 22.769163131713867 65 22.767608642578125
		 66 22.766159057617188 67 22.764822006225586 68 22.763584136962891 69 22.762506484985352
		 70 22.761589050292969 71 22.760856628417969 72 22.760324478149414 73 22.759986877441406
		 74 22.75982666015625 75 22.759794235229492 76 22.759895324707031 77 22.760051727294922
		 78 22.760231018066406 79 22.760354995727539 80 22.760416030883789;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA";
	rename -uid "A79E8BF5-44AA-6771-2DB2-76A7E20F104E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 10.392141342163086 1 10.38914966583252
		 2 10.381430625915527 3 10.370692253112793 4 10.358806610107422 5 10.347573280334473
		 6 10.339012145996094 7 10.335143089294434 8 10.338067054748535 9 10.349941253662109
		 10 10.372846603393555 11 10.408782005310059 12 10.458325386047363 13 10.520009994506836
		 14 10.592506408691406 15 10.683223724365234 16 10.795780181884766 17 10.923227310180664
		 18 11.058882713317871 19 11.196418762207031 20 11.330216407775879 21 11.455534934997559
		 22 11.5684814453125 23 11.665956497192383 24 11.748283386230469 25 11.818209648132324
		 26 11.876992225646973 27 11.925909996032715 28 11.967002868652344 29 12.000662803649902
		 30 12.027215003967285 31 12.04688835144043 32 12.061407089233398 33 12.072805404663086
		 34 12.081638336181641 35 12.088425636291504 36 12.093749046325684 37 12.098087310791016
		 38 12.103075981140137 39 12.109058380126953 40 12.114672660827637 41 12.118578910827637
		 42 12.11945915222168 43 12.11595344543457 44 12.106693267822266 45 12.090133666992188
		 46 12.060245513916016 47 12.012520790100098 48 11.947564125061035 49 11.865692138671875
		 50 11.764735221862793 51 11.639558792114258 52 11.487808227539063 53 11.311792373657227
		 54 11.11562442779541 55 10.905947685241699 56 10.691854476928711 57 10.484503746032715
		 58 10.295687675476074 59 10.138278961181641 60 10.022817611694336 61 9.9503250122070312
		 62 9.9169893264770508 63 9.9102554321289062 64 9.9141159057617187 65 9.9270849227905273
		 66 9.9484786987304687 67 9.9768095016479492 68 10.010646820068359 69 10.04863452911377
		 70 10.089466094970703 71 10.131900787353516 72 10.174676895141602 73 10.216641426086426
		 74 10.256585121154785 75 10.293425559997559 76 10.326016426086426 77 10.353277206420898
		 78 10.374105453491211 79 10.387446403503418 80 10.392141342163086;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA";
	rename -uid "BEA3EEB8-4946-A6C8-9279-20890044FF4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -18.414773941040039 1 -18.417715072631836
		 2 -18.425315856933594 3 -18.435840606689453 4 -18.447473526000977 5 -18.458415985107422
		 6 -18.466762542724609 7 -18.470504760742187 8 -18.467620849609375 9 -18.4559326171875
		 10 -18.433261871337891 11 -18.397314071655273 12 -18.346912384033203 13 -18.282859802246094
		 14 -18.205873489379883 15 -18.106794357299805 16 -17.979227066040039 17 -17.828092575073242
		 18 -17.658828735351563 19 -17.477489471435547 20 -17.290802001953125 21 -17.105876922607422
		 22 -16.930198669433594 23 -16.771295547485352 24 -16.631732940673828 25 -16.509260177612305
		 26 -16.404155731201172 27 -16.314422607421875 28 -16.237197875976562 29 -16.172466278076172
		 30 -16.120161056518555 31 -16.080089569091797 32 -16.049663543701172 33 -16.025657653808594
		 34 -16.006956100463867 35 -15.992444038391113 36 -15.981021881103516 37 -15.971591949462891
		 38 -15.960506439208984 39 -15.947001457214355 40 -15.934137344360352 41 -15.924996376037598
		 42 -15.922632217407227 43 -15.930129051208496 44 -15.950519561767578 45 -15.986939430236816
		 46 -16.052135467529297 47 -16.153741836547852 48 -16.287254333496094 49 -16.448024749755859
		 50 -16.634424209594727 51 -16.850152969360352 52 -17.09345817565918 53 -17.353887557983398
		 54 -17.620281219482422 55 -17.881027221679688 56 -18.125041961669922 57 -18.342523574829102
		 58 -18.525791168212891 59 -18.669164657592773 60 -18.768821716308594 61 -18.829021453857422
		 62 -18.855945587158203 63 -18.861194610595703 64 -18.858097076416016 65 -18.847379684448242
		 66 -18.829397201538086 67 -18.80522346496582 68 -18.775871276855469 69 -18.742328643798828
		 70 -18.705642700195313 71 -18.666885375976563 72 -18.627124786376953 73 -18.587488174438477
		 74 -18.549144744873047 75 -18.513303756713867 76 -18.481161117553711 77 -18.4539794921875
		 78 -18.433034896850586 79 -18.419530868530273 80 -18.414773941040039;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX";
	rename -uid "8BFC48E5-4F5E-A0F6-4DCA-19A76C979E9C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 4.7693968465785991e-006 1 -3.8615161548624593e-006
		 2 -1.4001544685220361e-006 3 1.7524116336910663e-005 4 -1.0446678750843987e-005 5 4.6927362547888286e-006
		 6 -8.554252753991151e-006 7 -1.5708344206214542e-005 8 -8.5542495187747603e-006 9 -2.384698365392469e-006
		 10 -4.769397539168829e-006 11 2.8769714786978914e-006 12 -1.4308193541676322e-005
		 13 -1.1431223898033839e-005 14 4.2004648784677855e-006 15 7.5697064516909751e-006
		 16 1.8157658135515968e-006 17 7.5697065716922757e-006 18 4.277126229479088e-006 19 7.5697065716922757e-006
		 20 1.4723808777147228e-005 21 1.8508659230264798e-005 22 -6.6618234567989188e-006
		 23 0 24 -4.277126237718684e-006 25 -5.6772810189895016e-006 26 1.2831379162881467e-005
		 27 1.8016387759127987e-005 28 1.620062193264359e-005 29 4.2771252195049996e-006 30 6.6618258733124616e-006
		 31 -5.6772801141272179e-006 32 1.7031842320875281e-005 33 1.8157653561597514e-006
		 34 2.3080362693520666e-006 35 1.4723808777147228e-005 36 -1.969087557891608e-006
		 37 -3.8615146460125727e-006 38 -1.1770170281921107e-005 39 3.7081910325325355e-006
		 40 4.277126229479088e-006 41 1.9000930699708017e-005 42 -5.6772801141272171e-006
		 43 -1.3323651052423833e-005 44 -3.8615161548624601e-006 45 5.2616698499631478e-006
		 46 1.8157653561597523e-006 47 1.233910876849824e-005 48 3.86151402225589e-006 49 8.4775898320863206e-006
		 50 -2.3846983653924686e-006 51 1.4723808777147228e-005 52 3.7848540272850136e-006
		 53 -4.2771250864078538e-006 54 -1.0446678834510288e-005 55 7.5697064516909785e-006
		 56 -4.277126237718684e-006 57 2.3080362693520654e-006 58 1.2262444055454434e-005
		 59 7.6463701588227906e-006 60 -2.3846983653924686e-006 61 1.8924269051377442e-006
		 62 -4.277126237718684e-006 63 1.400154460282439e-006 64 1.8157653561597514e-006 65 -4.7693968548181977e-006
		 66 -4.769397539168829e-006 67 -7.1540979179742783e-006 68 2.8769714225967534e-006
		 69 -8.5542495187747603e-006 70 8.1386412008136334e-006 71 -4.277126237718684e-006
		 72 1.2415767906537478e-005 73 -1.9690875578916068e-006 74 -7.646367074883291e-006
		 75 4.6927362547888278e-006 76 -1.7720026858462498e-014 77 -2.3846982332666143e-006
		 78 5.5239575356679742e-006 79 -3.8615146460125727e-006 80 4.7693968465786e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY";
	rename -uid "98790DBB-4759-6249-52A8-F294668A848C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.162099886933031 1 -29.162116297842338
		 2 -29.162109150300019 3 -29.162118213028709 4 -29.162108449305162 5 -29.162118914021171
		 6 -29.162111065484531 7 -29.162100587928016 8 -29.162100587928919 9 -29.162089422212414
		 10 -29.162105833125811 11 -29.162113681663772 12 -29.162105833124699 13 -29.162116297841969
		 14 -29.162089422212301 15 -29.16209727075325 16 -29.16209727075309 17 -29.162094654573181
		 18 -29.162116297842605 19 -29.162094654573181 20 -29.162118213028677 21 -29.162108449304462
		 22 -29.162100587929007 23 -29.16209988693317 24 -29.162116297842605 25 -29.162116297842598
		 26 -29.162116297842076 27 -29.162108449304654 28 -29.162108449304075 29 -29.162092038392927
		 30 -29.162113681663687 31 -29.162109150299965 32 -29.162113681663261 33 -29.162108449305251
		 34 -29.162124146377462 35 -29.162118213028677 36 -29.162099886932861 37 -29.162099886932815
		 38 -29.162097270753026 39 -29.16212414637732 40 -29.162116297842605 41 -29.162124146376339
		 42 -29.162109150299965 43 -29.162111065484016 44 -29.162116297842338 45 -29.162108449305261
		 46 -29.162108449305251 47 -29.162134927488619 48 -29.162097270753016 49 -29.162113681663687
		 50 -29.162089422212414 51 -29.162118213028677 52 -29.162108449305475 53 -29.162097270753289
		 54 -29.162121530199173 55 -29.16209727075325 56 -29.162116297842605 57 -29.162124146377462
		 58 -29.16211629784237 59 -29.162113681663403 60 -29.162089422212414 61 -29.162118914021228
		 62 -29.162116297842605 63 -29.162109150300019 64 -29.162108449305251 65 -29.162099886933031
		 66 -29.162105833125811 67 -29.162111065484499 68 -29.162116297842587 69 -29.162100587928919
		 70 -29.162106534120579 71 -29.162116297842605 72 -29.162113681662742 73 -29.162099886932861
		 74 -29.162092038392533 75 -29.162118914021171 76 -29.16212414637755 77 -29.162100587929174
		 78 -29.162105833124986 79 -29.162099886932815 80 -29.162099886933031;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "F74F1C2F-497F-BDD3-29C9-5DB22AE1DCE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.7693968548181977e-006 1 8.0619801010648545e-006
		 2 -1.4001544685220342e-006 3 -6.3228786468142205e-006 4 6.2462146570569254e-006 5 2.3080367661368936e-006
		 6 5.7539430737177968e-006 7 1.2908035475955528e-005 8 5.7539407885155892e-006 9 2.3846983571528692e-006
		 10 4.7693975309292305e-006 11 -4.2771263083871087e-006 12 1.4308193533436726e-005
		 13 1.003106954911695e-005 14 4.2004648784677787e-006 15 -1.9690874045931666e-006
		 16 6.5851627487629489e-006 17 -1.9690872512946874e-006 18 -2.8769714308363515e-006
		 19 -1.9690872512946874e-006 20 -9.1231890038085745e-006 21 -1.0107731067409921e-005
		 22 5.2616686213446987e-006 23 0 24 2.8769714225967559e-006 25 1.4768168669106301e-006
		 26 -8.6309152166792187e-006 27 -8.2153033470739429e-006 28 -1.4800467556504117e-005
		 29 -2.8769702037485291e-006 30 -5.2616705938974715e-006 31 1.4768162534543152e-006
		 32 -4.4304499940971367e-006 33 6.585163739105763e-006 34 4.692736139695873e-006 35 -9.1231890038085728e-006
		 36 7.5697063316896668e-006 37 8.0619795786556055e-006 38 -2.2313768777035517e-006
		 39 6.0928899704664225e-006 40 -2.8769714308363515e-006 41 -1.2000159223070652e-005
		 42 1.4768162534543152e-006 43 1.0523341372150576e-005 44 8.0619801010648545e-006
		 45 -6.6618247087869137e-006 46 6.5851637391057622e-006 47 -6.7384907958312194e-006
		 48 -8.0619778495675651e-006 49 1.3234927443088933e-006 50 2.3846983571528692e-006
		 51 -9.1231890038085745e-006 52 -1.9805282904970449e-014 53 2.8769703164092339e-006
		 54 6.2462158916423997e-006 55 -1.9690874045931666e-006 56 2.8769714225967563e-006
		 57 4.692736139695873e-006 58 9.1373200272760688e-016 59 -9.0465249885119841e-006
		 60 2.3846983571528688e-006 61 3.4888963598096824e-015 62 2.8769714225967559e-006
		 63 1.4001544602824373e-006 64 6.5851637391057639e-006 65 4.7693968465786e-006 66 4.7693975309292305e-006
		 67 7.1540979097346831e-006 68 -4.277126237718684e-006 69 5.7539407885155892e-006
		 70 -1.0938949234582434e-005 71 2.8769714225967547e-006 72 -1.38159232024316e-005
		 73 7.5697063316896668e-006 74 9.0465218575372549e-006 75 2.3080367661368919e-006
		 76 -3.2925813746522988e-006 77 2.3846982250270191e-006 78 1.2678054304446224e-005
		 79 8.0619795786556055e-006 80 -4.769396854818196e-006;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA";
	rename -uid "E0DCB04A-4FB7-FE33-5A88-E587195CFC2C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -21.009696960449219 1 -21.009044647216797
		 2 -21.007331848144531 3 -21.004852294921875 4 -21.001943588256836 5 -20.998926162719727
		 6 -20.996067047119141 7 -20.993633270263672 8 -20.991910934448242 9 -20.991130828857422
		 10 -20.991558074951172 11 -20.993541717529297 12 -20.997333526611328 13 -21.002956390380859
		 14 -21.009860992431641 15 -21.018911361694336 16 -21.031732559204102 17 -21.048637390136719
		 18 -21.069631576538086 19 -21.094316482543945 20 -21.121952056884766 21 -21.151239395141602
		 22 -21.180576324462891 23 -21.208011627197266 24 -21.232498168945313 25 -21.254125595092773
		 26 -21.272443771362305 27 -21.288080215454102 28 -21.301858901977539 29 -21.313800811767578
		 30 -21.323993682861328 31 -21.332515716552734 32 -21.339424133300781 33 -21.344888687133789
		 34 -21.349151611328125 35 -21.352476119995117 36 -21.355133056640625 37 -21.357397079467773
		 38 -21.36024284362793 39 -21.363790512084961 40 -21.367286682128906 41 -21.369899749755859
		 42 -21.370794296264648 43 -21.369184494018555 44 -21.364242553710937 45 -21.355207443237305
		 46 -21.338861465454102 47 -21.313552856445313 48 -21.280902862548828 49 -21.242593765258789
		 50 -21.200990676879883 51 -21.156394958496094 52 -21.109405517578125 53 -21.06346321105957
		 54 -21.021770477294922 55 -20.987001419067383 56 -20.960958480834961 57 -20.944286346435547
		 58 -20.936435699462891 59 -20.935930252075195 60 -20.94085693359375 61 -20.948501586914063
		 62 -20.956682205200195 63 -20.963871002197266 64 -20.96891975402832 65 -20.972555160522461
		 66 -20.975906372070312 67 -20.97905158996582 68 -20.982023239135742 69 -20.98492431640625
		 70 -20.987813949584961 71 -20.990690231323242 72 -20.993595123291016 73 -20.996501922607422
		 74 -20.999330520629883 75 -21.002006530761719 76 -21.004480361938477 77 -21.006587982177734
		 78 -21.00825309753418 79 -21.009302139282227 80 -21.009696960449219;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA";
	rename -uid "F758F528-4C8B-3C39-F84F-A78CEF8E392E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 9.823974609375 1 9.8217267990112305 2 9.8158855438232422
		 3 9.8077030181884766 4 9.7988386154174805 5 9.7902212142944336 6 9.7834653854370117
		 7 9.7800426483154297 8 9.7814788818359375 9 9.7893056869506836 10 9.8050527572631836
		 11 9.830164909362793 12 9.8651390075683594 13 9.9088954925537109 14 9.9602127075195313
		 15 10.024204254150391 16 10.103775024414062 17 10.194306373596191 18 10.291228294372559
		 19 10.390749931335449 20 10.488600730895996 21 10.581299781799316 22 10.66572380065918
		 23 10.739093780517578 24 10.801185607910156 25 10.85377311706543 26 10.897235870361328
		 27 10.933345794677734 28 10.963890075683594 29 10.989261627197266 30 11.009805679321289
		 31 11.02586555480957 32 11.038293838500977 33 11.048032760620117 34 11.055606842041016
		 35 11.061452865600586 36 11.066106796264648 37 11.069982528686523 38 11.07438850402832
		 39 11.080086708068848 40 11.085585594177246 41 11.089557647705078 42 11.090763092041016
		 43 11.087844848632813 44 11.07958984375 45 11.064550399780273 46 11.037261962890625
		 47 10.993863105773926 48 10.935809135437012 49 10.863971710205078 50 10.779281616210938
		 51 10.67870044708252 52 10.560516357421875 53 10.427957534790039 54 10.284907341003418
		 55 10.136415481567383 56 9.9884824752807617 57 9.8479452133178711 58 9.7220640182495117
		 59 9.6181535720825195 60 9.543187141418457 61 9.4971580505371094 62 9.4772176742553711
		 63 9.4746551513671875 64 9.4784212112426758 65 9.4881792068481445 66 9.5037641525268555
		 67 9.5242242813110352 68 9.5486173629760742 69 9.5759944915771484 70 9.6054525375366211
		 71 9.6360578536987305 72 9.6669206619262695 73 9.6969661712646484 74 9.7259035110473633
		 75 9.752558708190918 76 9.7761621475219727 77 9.795872688293457 78 9.8109655380249023
		 79 9.8205690383911133 80 9.823974609375;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA";
	rename -uid "2E65AFC3-4E4D-C7BC-203B-58BDC61B2FB3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -31.231805801391602 1 -31.233911514282227
		 2 -31.2392578125 3 -31.246524810791016 4 -31.254217147827148 5 -31.261051177978516
		 6 -31.265434265136719 7 -31.265678405761719 8 -31.260078430175781 9 -31.246715545654297
		 10 -31.22374153137207 11 -31.18927001953125 12 -31.142433166503906 13 -31.084115982055664
		 14 -31.014139175415039 15 -30.9241943359375 16 -30.809970855712891 17 -30.676925659179688
		 18 -30.530635833740234 19 -30.376508712768555 20 -30.220443725585938 21 -30.068000793457031
		 22 -29.924587249755859 23 -29.795448303222656 24 -29.681947708129883 25 -29.582042694091797
		 26 -29.495765686035156 27 -29.421697616577148 28 -29.358259201049805 29 -29.305501937866211
		 30 -29.263519287109375 31 -29.232322692871094 32 -29.209201812744141 33 -29.190952301025391
		 34 -29.176708221435547 35 -29.165674209594727 36 -29.157045364379883 37 -29.150001525878906
		 38 -29.142200469970703 39 -29.132574081420898 40 -29.123552322387695 41 -29.117326736450195
		 42 -29.116043090820313 43 -29.121894836425781 44 -29.137056350708008 45 -29.163734436035156
		 46 -29.211093902587891 47 -29.28485107421875 48 -29.381853103637695 49 -29.499265670776367
		 50 -29.638168334960938 51 -29.802646636962891 52 -29.991376876831055 53 -30.198188781738281
		 54 -30.416231155395508 55 -30.637725830078125 56 -30.85406494140625 57 -31.056375503540039
		 58 -31.235946655273438 59 -31.384843826293945 60 -31.49604606628418 61 -31.570095062255859
		 62 -31.610282897949219 63 -31.626453399658203 64 -31.630769729614258 65 -31.62507438659668
		 66 -31.611442565917969 67 -31.591081619262695 68 -31.565105438232422 69 -31.534698486328125
		 70 -31.501014709472656 71 -31.46513557434082 72 -31.428224563598633 73 -31.391534805297852
		 74 -31.355953216552734 75 -31.322742462158203 76 -31.293041229248047 77 -31.267932891845703
		 78 -31.248630523681641 79 -31.236183166503906 80 -31.231805801391602;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX";
	rename -uid "2BCB9B1F-4A5C-4264-C674-F092A95A46D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.0509911110621907e-005 1 -6.0771724320794584e-006
		 2 3.5673175117507531e-014 3 8.5606398813052653e-015 4 1.3986234207708265e-006 5 5.9453413343457765e-006
		 6 9.5335577222042893e-006 7 1.5733655082520585e-014 8 -2.2523502190178291e-005 9 -3.4474626663334645e-006
		 10 5.6638342326147735e-006 11 1.7614561273313539e-014 12 7.598695275662061e-006 13 -9.8239859054999912e-006
		 14 5.5320017349229325e-006 15 -3.0341233231536648e-006 16 -4.0015553798756821e-006
		 17 -1.839011966677919e-005 18 6.0751380119058579e-015 19 6.7630947319451856e-006
		 20 -1.8662700087016362e-005 21 4.8371560384701982e-006 22 5.1186636025953139e-006
		 23 2.620785668765446e-006 24 8.7068793838042983e-006 25 -3.1748783482256865e-006
		 26 -4.5556477310074476e-006 27 -1.9259386923919715e-006 28 1.0665005494715532e-016
		 29 -7.4334403877131279e-014 30 -1.4229960462198988e-005 31 -7.8712799169482999e-006
		 32 -1.4652221317584671e-005 33 -3.7200460910871237e-006 34 -1.9489373353439418e-005
		 35 -1.4924803321906277e-005 36 -2.6824411104597673e-005 37 -1.3825540416364225e-005
		 38 -1.547889796679148e-005 39 -1.671891563534347e-005 40 -3.1380062073587665e-005
		 41 -2.6029418188962612e-006 42 -1.9911642749806131e-005 43 -1.4247808531587095e-005
		 44 1.2489373549156111e-006 45 -1.6446330668892178e-005 46 -7.8712799169482965e-006
		 47 -1.8267207416542437e-005 48 -5.5141589591130911e-006 49 6.3675993899454328e-006
		 50 -1.0654708493825853e-014 51 -2.5162135295012895e-005 52 -1.4933724848690733e-005
		 53 5.3912481223283938e-006 54 -1.1077094442869617e-013 55 -1.0380831655302273e-014
		 56 -9.0158588264679983e-015 57 3.4563857130161658e-006 58 -4.1637389276910131e-015
		 59 0 60 -1.0650670761113959e-005 61 5.3912481223283938e-006 62 -9.4017308606147094e-006
		 63 -7.8712799169482965e-006 64 -9.26097468964014e-006 65 1.0664929664382743e-016
		 66 -2.9577036622312667e-005 67 6.2268448969321137e-006 68 1.686859029017207e-005
		 69 -5.9364175936393856e-006 70 -9.26097468964014e-006 71 -1.4792981380513729e-005
		 72 -7.0535272051402236e-006 73 8.1617069594331842e-006 74 1.7941085555649074e-006
		 75 6.3676063421677398e-006 76 2.4889547482851337e-006 77 -1.4924808748841749e-005
		 78 6.0751380119058579e-015 79 4.9689862730228977e-006 80 -1.0509911110621907e-005;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY";
	rename -uid "55230B17-4EF4-3C37-9005-7C8A33C5A422";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 31.960573111769595 1 31.960584237800674
		 2 31.960585485979518 3 31.960585485979763 4 31.960603931785052 5 31.960585485979589
		 6 31.960575586612613 7 31.960598982104862 8 31.960597755438322 9 31.960575586612222
		 10 31.960581762958572 11 31.960575586612638 12 31.960575586612645 13 31.96056329562893
		 14 31.960575586612517 15 31.96057806145453 16 31.960598982104514 17 31.960586712640708
		 18 31.960578061454772 19 31.960573111769612 20 31.960569388742599 21 31.960575586612766
		 22 31.960575586612407 23 31.960573111770167 24 31.960575586612649 25 31.960570636927631
		 26 31.960570636927528 27 31.960579288115415 28 31.960579288116215 29 31.960573111769332
		 30 31.960581762958107 31 31.960575586612364 32 31.960569388743238 33 31.960578061453596
		 34 31.96055836747113 35 31.960539900143864 36 31.960570636923464 37 31.960558367471329
		 38 31.960570636927237 39 31.960576813272912 40 31.960586712639248 41 31.960569388738385
		 42 31.960571863584796 43 31.960576813270805 44 31.96055341778596 45 31.960569388743309
		 46 31.960575586612364 47 31.960575586604509 48 31.960574338428582 49 31.960560842313448
		 50 31.960580536296156 51 31.960586712639877 52 31.960564543814012 53 31.960578061454829
		 54 31.960573111767971 55 31.960580536296192 56 31.960580536296344 57 31.960578061454886
		 58 31.960576813273523 59 31.960585485979792 60 31.960595280596703 61 31.960578061454829
		 62 31.960605179961647 63 31.960575586612364 64 31.960576813273281 65 31.960579288116215
		 66 31.960600230278459 67 31.960552169597499 68 31.960562068970905 69 31.96057063692739
		 70 31.960576813273281 71 31.960605179961142 72 31.960581762958196 73 31.960557119284985
		 74 31.960579288116172 75 31.960594032419348 76 31.96057806145491 77 31.960605179961647
		 78 31.960578061454772 79 31.960573111770032 80 31.960573111769595;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "40A1F35C-4F19-0987-6814-35B3A73638C9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.1890681917998869e-005 1 3.5882173076104867e-006
		 2 -6.9083099697428136e-006 3 -1.6578159316857127e-006 4 2.3490936024329386e-005 5 5.2549564478957091e-006
		 6 3.0380494669414924e-014 7 3.5926796550707568e-006 8 -1.2194449012590422e-013 9 9.6698505045942169e-006
		 10 -1.9304008164852162e-006 11 5.5275400421197902e-006 12 -1.3763081571765402e-006
		 13 -1.8798990409057018e-005 14 6.9127715676442685e-006 15 8.0120332995740328e-006
		 16 7.7349891090198145e-006 17 -1.769973411017514e-005 18 5.5275399582250688e-006
		 19 -1.0496526924462302e-005 20 -1.2449235364691035e-005 21 1.385231328083818e-006
		 22 8.5705877045484818e-006 23 -6.3542173814324776e-006 24 2.493415965160231e-006
		 25 4.4193554163999533e-006 26 5.8001252790319099e-006 27 1.1881757533140221e-005
		 28 1.6578161953525883e-006 29 -1.4093666317620681e-005 30 3.0296620320262126e-006
		 31 6.6268028467756494e-006 32 -7.7483719460120091e-006 33 1.4920342130102577e-005
		 34 -9.1335995032349514e-006 35 -2.4978723594228973e-006 36 -2.5443642201666428e-005
		 37 -1.1064000658996293e-005 38 -4.4327391380273306e-006 39 -3.5978320926478221e-014
		 40 -1.9643521047128551e-005 41 3.1225924228519604e-005 42 -1.991164274980612e-005
		 43 -2.1842043265344285e-005 44 7.4624017036664386e-006 45 -4.7097855925552907e-006
		 46 6.6268028467756503e-006 47 -3.8978752028255185e-005 48 1.795893348216687e-005
		 49 1.6032987476346134e-005 50 1.0778035391354954e-005 51 -1.9639058519785534e-005
		 52 -1.4933724848690729e-005 53 3.3200936356044055e-006 54 -2.100197535942116e-005
		 55 1.0500989102000502e-005 56 9.1202193020317081e-006 57 2.7660010440582249e-006
		 58 -1.9348626193455521e-006 59 0 60 -1.5483364242649528e-005 61 3.3200936356044055e-006
		 62 -8.0209616284830359e-006 63 6.626802846775652e-006 64 -4.428279422839328e-006
		 65 1.6578161953525883e-006 66 -1.0246261195519857e-005 67 1.2440309586164863e-005
		 68 1.5487819565985823e-005 69 7.1808956215140349e-006 70 -4.4282794228393297e-006
		 71 -1.1341057340484068e-005 72 -9.1246815205670258e-006 73 1.2994401719671508e-005
		 74 -3.0385862990046849e-006 75 1.603299607417915e-005 76 2.4889547482851312e-006
		 77 -2.4978832604052922e-006 78 5.5275399582250688e-006 79 -7.4579413963666264e-006
		 80 -1.1890681917998869e-005;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "09A6F40A-4552-DDFB-8466-F98EC93F7E49";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 21.523422241210938 1 21.576250076293945
		 2 21.712867736816406 3 21.896806716918945 4 22.090961456298828 5 22.261728286743164
		 6 22.382961273193359 7 22.438270568847656 8 22.420633316040039 9 22.330080032348633
		 10 22.181787490844727 11 21.993574142456055 12 21.784755706787109 13 21.572704315185547
		 14 21.368085861206055 15 21.172910690307617 16 20.980815887451172 17 20.778018951416016
		 18 20.548761367797852 19 20.313011169433594 20 20.107933044433594 21 19.951419830322266
		 22 19.82623291015625 23 19.705654144287109 24 19.591796875 25 19.48689079284668 26 19.393131256103516
		 27 19.313121795654297 28 19.249286651611328 29 19.203977584838867 30 19.17918586730957
		 31 19.171525955200195 32 19.175765991210938 33 19.191211700439453 34 19.217796325683594
		 35 19.255268096923828 36 19.303365707397461 37 19.361822128295898 38 19.430244445800781
		 39 19.508289337158203 40 19.595418930053711 41 19.690994262695313 42 19.79444694519043
		 43 19.914834976196289 44 20.058330535888672 45 20.219577789306641 46 20.362215042114258
		 47 20.46208381652832 48 20.534551620483398 49 20.590797424316406 50 20.652027130126953
		 51 20.735252380371094 52 20.84727668762207 53 20.990863800048828 54 21.162254333496094
		 55 21.352527618408203 56 21.549295425415039 57 21.739053726196289 58 21.908803939819336
		 59 22.051609039306641 60 22.167116165161133 61 22.253793716430664 62 22.311338424682617
		 63 22.340295791625977 64 22.340667724609375 65 22.316583633422852 66 22.273920059204102
		 67 22.216217041015625 68 22.14617919921875 69 22.065824508666992 70 21.976800918579102
		 71 21.880725860595703 72 21.782960891723633 73 21.692161560058594 74 21.616050720214844
		 75 21.562328338623047 76 21.538354873657227 77 21.532192230224609 78 21.527471542358398
		 79 21.524457931518555 80 21.523422241210938;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "A149C15E-46C9-8034-B770-53A4286F8662";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 93.607086181640625 1 93.797050476074219
		 2 94.19580078125 3 94.492271423339844 4 94.423896789550781 5 93.886947631835938 6 92.981971740722656
		 7 91.98828125 8 91.282135009765625 9 91.287513732910156 10 92.064178466796875 11 93.313301086425781
		 12 94.594398498535156 13 95.399559020996094 14 95.257164001464844 15 93.908988952636719
		 16 91.427238464355469 17 88.1768798828125 18 84.741973876953125 19 81.433357238769531
		 20 78.303688049316406 21 75.688980102539063 22 73.466217041015625 23 71.346946716308594
		 24 69.399085998535156 25 67.691848754882813 26 66.292709350585937 27 65.123603820800781
		 28 64.070335388183594 29 63.144012451171875 30 62.355293273925781 31 61.720516204833984
		 32 61.219707489013672 33 60.820632934570313 34 60.524391174316406 35 60.331974029541016
		 36 60.243759155273438 37 60.259849548339844 38 60.380561828613281 39 60.605110168457031
		 40 60.9315185546875 41 61.357410430908203 42 61.879962921142578 43 62.636486053466797
		 44 63.728496551513672 45 65.096954345703125 46 67.066108703613281 47 69.810989379882813
		 48 73.020706176757813 49 76.32366943359375 50 79.48626708984375 51 82.527290344238281
		 52 85.236549377441406 53 87.229904174804688 54 88.328590393066406 55 88.574050903320312
		 56 88.191665649414063 57 87.51971435546875 58 86.931991577148438 59 86.635391235351563
		 60 86.687873840332031 61 87.081283569335938 62 87.715744018554688 63 88.547561645507813
		 64 89.521446228027344 65 90.588638305664063 66 91.68505859375 67 92.702964782714844
		 68 93.554840087890625 69 94.184806823730469 70 94.575675964355469 71 94.750152587890625
		 72 94.758354187011719 73 94.639175415039063 74 94.437179565429688 75 94.207237243652344
		 76 94.00555419921875 77 93.847084045410156 78 93.720527648925781 79 93.637062072753906
		 80 93.607086181640625;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "619DD581-40B4-94BA-B362-A5BA1241AFB5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -33.464076995849609 1 -32.602687835693359
		 2 -30.279874801635742 3 -26.899105072021484 4 -22.909976959228516 5 -18.798147201538086
		 6 -15.03021240234375 7 -11.997110366821289 8 -10.004411697387695 9 -9.4432792663574219
		 10 -10.382821083068848 11 -12.722855567932129 12 -16.4228515625 13 -21.266014099121094
		 14 -26.876169204711914 15 -32.657009124755859 16 -37.980079650878906 17 -42.377452850341797
		 18 -45.564922332763672 19 -47.742702484130859 20 -49.207553863525391 21 -49.986164093017578
		 22 -50.389087677001953 23 -50.707305908203125 24 -50.940708160400391 25 -51.066181182861328
		 26 -51.080005645751953 27 -51.041545867919922 28 -51.011043548583984 29 -50.985694885253906
		 30 -50.962532043457031 31 -50.936763763427734 32 -50.905120849609375 33 -50.865718841552734
		 34 -50.814704895019531 35 -50.747711181640625 36 -50.659706115722656 37 -50.544956207275391
		 38 -50.382011413574219 39 -50.165489196777344 40 -49.913070678710938 41 -49.641666412353516
		 42 -49.36749267578125 43 -49.059001922607422 44 -48.680259704589844 45 -48.237548828125
		 46 -47.644359588623047 47 -46.71600341796875 48 -45.316703796386719 49 -43.397369384765625
		 50 -40.938377380371094 51 -37.704986572265625 52 -33.584278106689453 53 -28.905313491821289
		 54 -24.086357116699219 55 -19.550439834594727 56 -15.647871971130371 57 -12.615411758422852
		 58 -10.584012985229492 59 -9.4375762939453125 60 -9.0265693664550781 61 -9.1304521560668945
		 62 -9.4680404663085938 63 -10.108304977416992 64 -11.173746109008789 65 -12.65562629699707
		 66 -14.501648902893066 67 -16.640897750854492 68 -18.976490020751953 69 -21.387355804443359
		 70 -23.735115051269531 71 -25.872983932495117 72 -27.791709899902344 73 -29.518077850341797
		 74 -30.961906433105469 75 -32.03717041015625 76 -32.662300109863281 77 -32.997600555419922
		 78 -33.249858856201172 79 -33.408748626708984 80 -33.464076995849609;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "2A4A196D-47BD-2A79-6D0B-31A6A71122E4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.134432549968601 1 -38.70837051121724
		 2 -30.73763422609775 3 -21.376692065163081 4 -12.588252231586777 5 -6.2899715287102849
		 6 -4.7175771221232266 7 -9.046327728509322 8 -18.10875884717225 9 -32.257418001381147
		 10 -48.530643944582728 11 -60.492316526287276 12 -67.413840954965622 13 -68.767923955634856
		 14 -64.795297143764898 15 -56.809817393073438 16 -48.22628580496896 17 -45.319135361081685
		 18 -52.682917952080409 19 -69.084440595599062 20 -90.462058991466279 21 -110.08401061813987
		 22 -125.19718651206385 23 -135.43091919772411 24 -140.94067230711545 25 -143.63609764490135
		 26 -144.2310048919131 27 -143.64674511190984 28 -142.77461317684819 29 -142.1159733040684
		 30 -142.1599234497819 31 -143.36009583759775 32 -145.40774688043999 33 -147.65401404760775
		 34 -150.00609085944936 35 -152.37051634642793 36 -154.65356733900478 37 -156.75864073806676
		 38 -158.58521010585028 39 -160.02382478714165 40 -160.94904774875243 41 -161.20988053629569
		 42 -160.61285805136581 43 -158.25830493366882 44 -153.08243341352158 45 -142.69426876415386
		 46 -122.84669836290502 47 -95.208134282215553 48 -68.114479653351026 49 -46.762101398362439
		 50 -34.161483478043948 51 -32.922361095357218 52 -43.059566381554298 53 -55.755300438902566
		 54 -62.742028242236991 55 -61.411126707685845 56 -46.128362562233995 57 5.5389071599424007
		 58 50.454316110232988 59 64.541313172625067 60 69.620665825586187 61 71.177276777938928
		 62 70.654796201793431 63 67.892494747216944 64 61.700933930697552 65 50.128417186287045
		 66 31.642058791369038 67 9.1901969670356731 68 -9.1993349718365938 69 -20.508864483351655
		 70 -26.678961733712686 71 -29.88955445636083 72 -31.890935804193305 73 -33.511612996250541
		 74 -35.009239046878974 75 -36.531535984685881 76 -38.019340742364449 77 -39.44225628420056
		 78 -40.768359334805325 79 -41.753418271456837 80 -42.134432549968601;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "B0F3D4C1-420F-1C6D-8102-94AFCC9123C0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 40.89497457285561 1 39.770605531386096
		 2 35.836135587794018 3 28.982844803024783 4 21.755059010618581 5 18.278644523405838
		 6 19.588951313451361 7 23.627905020981839 8 28.830800750577879 9 35.250151768106925
		 10 38.056779896037462 11 38.992997217251443 12 37.404101103200688 13 30.201845975798651
		 14 19.506044387596656 15 3.7797882708330905 16 -16.589460390214501 17 -36.834466332307649
		 18 -51.671620269928518 19 -60.587440959365466 20 -65.003319270083537 21 -66.436602187551131
		 22 -66.319252167799718 23 -65.29115155129891 24 -64.167210713548627 25 -63.458975053367027
		 26 -63.213441794427808 27 -63.329391833333624 28 -63.641983068719476 29 -64.013148049323121
		 30 -64.279880911819305 31 -64.241637675796653 32 -64.033535213589687 33 -63.924758926979052
		 34 -63.903368639141668 35 -63.963125682835724 36 -64.103180571665789 37 -64.328322674374974
		 38 -64.648031857249592 39 -65.075066231012102 40 -65.623538824713094 41 -66.305351322865477
		 42 -67.124710351156168 43 -68.242005372181282 44 -69.719124657844318 45 -71.165286917499913
		 46 -71.799215058875106 47 -70.152737642464515 48 -65.295644607035214 49 -56.923736888991819
		 50 -44.026102649398347 51 -24.65127262529543 52 0.61349248616588126 53 24.528600255262827
		 54 44.117765850666409 55 60.709338885019626 56 74.142798218428013 57 80.484598634430213
		 58 76.344250763234498 59 70.688767767452475 60 66.548213921841537 61 64.291765895191432
		 62 63.710901570042388 63 64.768098635410752 64 67.282578580737663 65 70.356549529553206
		 66 72.406572603662852 67 71.835502576637396 68 68.308448554164556 69 62.999462476128762
		 70 57.209172225966512 71 51.824599558236713 72 47.160957045591971 73 43.357403221719132
		 74 40.673595292875369 75 39.214504182495489 76 39.03828899544844 77 39.591389046245055
		 78 40.199832052009029 79 40.693154996774545 80 40.89497457285561;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "49D4B0CD-424F-30B2-B895-BE94F230FB25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.919929154046095 1 -47.7426752623929
		 2 -46.304769431998807 3 -47.699071292723168 4 -53.017760966160672 5 -61.106251128335295
		 6 -69.92080009073878 7 -77.152033142976961 8 -80.048026474818059 9 -81.60831771116672
		 10 -86.008437717154976 11 -88.134019916314713 12 -88.807069162082428 13 -87.446808341022901
		 14 -83.410473190643614 15 -77.51949716614638 16 -69.913879288628536 17 -59.859822965919037
		 18 -46.730084881573113 19 -30.008425606402835 20 -11.265377623527977 21 5.0696675874309216
		 22 17.283584392402599 23 25.150382942800896 24 29.070448266246004 25 30.925746858552831
		 26 31.39178505047904 27 31.155823934496507 28 30.805713882006252 29 30.62803756764465
		 30 30.880541965175055 31 31.777644471570486 32 33.173249040137449 33 34.75871064845083
		 34 36.474010843675906 35 38.25676508414665 36 40.040225555044422 37 41.749949906375107
		 38 43.302192901916264 39 44.599383669366553 40 45.524159166070476 41 45.93133247032489
		 42 45.633413161107775 43 43.911871099626211 44 39.863376418298436 45 31.203564349678199
		 46 14.871137027342925 47 -6.7412677120538111 48 -26.440945913284345 49 -41.320943142964644
		 50 -51.632608462652122 51 -58.749387923690279 52 -64.700112247994355 53 -69.525557670887466
		 54 -70.980182971378255 55 -66.893745359926868 56 -50.553692859866494 57 1.3770930449922254
		 58 46.005027499361738 59 59.452065544402224 60 63.683484189362318 61 64.270129261869613
		 62 62.703290055132243 63 58.848864578976972 64 51.508047886787807 65 38.684848168169793
		 66 18.811320290988849 67 -5.1697838989515459 68 -25.180838637684982 69 -38.08025769072087
		 70 -45.6035508449974 71 -49.662620300365404 72 -51.753116806993447 73 -52.618571973740615
		 74 -52.59487235157593 75 -52.036548944638803 76 -51.164376870813882 77 -50.249021300344857
		 78 -49.537248345631873 79 -49.08234168568206 80 -48.919929154046095;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "C10E9B9F-43D5-FAE2-3EEE-C5A487C794A7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -23.12449836730957 1 -23.096565246582031
		 2 -23.037988662719727 3 -22.959070205688477 4 -22.87047004699707 5 -22.785184860229492
		 6 -22.719198226928711 7 -22.69111442565918 8 -22.721294403076172 9 -22.824071884155273
		 10 -22.986883163452148 11 -23.184658050537109 12 -23.391376495361328 13 -23.586402893066406
		 14 -23.760173797607422 15 -23.914754867553711 16 -24.060752868652344 17 -24.213956832885742
		 18 -24.389093399047852 19 -24.558658599853516 20 -24.680801391601563 21 -24.739118576049805
		 22 -24.758604049682617 23 -24.775253295898438 24 -24.790082931518555 25 -24.804018020629883
		 26 -24.81794548034668 27 -24.832290649414063 28 -24.847230911254883 29 -24.862825393676758
		 30 -24.875932693481445 31 -24.882997512817383 32 -24.883504867553711 33 -24.876861572265625
		 34 -24.861690521240234 35 -24.836658477783203 36 -24.800420761108398 37 -24.751794815063477
		 38 -24.689826965332031 39 -24.613712310791016 40 -24.523170471191406 41 -24.418258666992188
		 42 -24.299346923828125 43 -24.15582275390625 44 -23.980401992797852 45 -23.779129028320313
		 46 -23.591648101806641 47 -23.448509216308594 48 -23.340070724487305 49 -23.26002311706543
		 50 -23.189754486083984 51 -23.112030029296875 52 -23.017162322998047 53 -22.898109436035156
		 54 -22.754619598388672 55 -22.593647003173828 56 -22.428590774536133 57 -22.265628814697266
		 58 -22.111749649047852 59 -21.981752395629883 60 -21.882427215576172 61 -21.817859649658203
		 62 -21.789825439453125 63 -21.798566818237305 64 -21.844417572021484 65 -21.921100616455078
		 66 -22.019233703613281 67 -22.132423400878906 68 -22.255914688110352 69 -22.386234283447266
		 70 -22.520797729492188 71 -22.657493591308594 72 -22.789348602294922 73 -22.906501770019531
		 74 -23.001914978027344 75 -23.068719863891602 76 -23.10015869140625 77 -23.110454559326172
		 78 -23.118083953857422 79 -23.122871398925781 80 -23.12449836730957;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "B9ADCCDC-4E3B-B5AE-A05B-33AD4C69CD5E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 93.981224060058594 1 94.258865356445313
		 2 94.958480834960938 3 95.782516479492188 4 96.463531494140625 5 96.840950012207031
		 6 96.901924133300781 7 96.777091979980469 8 96.686576843261719 9 96.887184143066406
		 10 97.381462097167969 11 97.843254089355469 12 97.802192687988281 13 96.804649353027344
		 14 94.540580749511719 15 90.997970581054688 16 86.509674072265625 17 81.633796691894531
		 18 77.030105590820312 19 72.897140502929688 20 69.159255981445312 21 66.095985412597656
		 22 63.506885528564453 23 61.070106506347656 24 58.856002807617188 25 56.933914184570313
		 26 55.369537353515625 27 54.081142425537109 28 52.953704833984375 29 52.000225067138672
		 30 51.229442596435547 31 50.648014068603516 32 50.22735595703125 33 49.931842803955078
		 34 49.759136199951172 35 49.706649780273438 36 49.771270751953125 37 49.949733734130859
		 38 50.239120483398437 39 50.635833740234375 40 51.135398864746094 41 51.733287811279297
		 42 52.42529296875 43 53.328876495361328 44 54.536762237548828 45 56.008480072021484
		 46 58.103778839111328 47 61.088016510009766 48 64.7554931640625 49 68.819931030273437
		 50 73.087898254394531 51 77.610404968261719 52 82.15545654296875 53 86.186408996582031
		 54 89.315093994140625 55 91.377296447753906 56 92.454826354980469 57 92.823013305664063
		 58 92.884880065917969 59 92.9637451171875 60 93.207122802734375 61 93.652168273925781
		 62 94.223258972167969 63 94.874435424804688 64 95.53582763671875 65 96.161346435546875
		 66 96.707954406738281 67 97.096969604492188 68 97.277854919433594 69 97.23614501953125
		 70 96.995613098144531 71 96.614479064941406 72 96.148918151855469 73 95.635658264160156
		 74 95.133392333984375 75 94.707725524902344 76 94.424148559570313 77 94.246612548828125
		 78 94.106216430664063 79 94.014144897460938 80 93.981224060058594;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "9895D755-44E8-A046-03DE-DB8EC4A2FF3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -35.873222351074219 1 -35.108287811279297
		 2 -33.058170318603516 3 -30.041284561157227 4 -26.408599853515625 5 -22.561691284179688
		 6 -18.934593200683594 7 -15.962089538574219 8 -14.062661170959473 9 -13.832394599914551
		 10 -15.472637176513672 11 -18.811878204345703 12 -23.568641662597656 13 -29.245231628417969
		 14 -35.229568481445313 15 -40.806655883789063 16 -45.386615753173828 17 -48.683662414550781
		 18 -50.681785583496094 19 -51.761917114257812 20 -52.303176879882813 21 -52.470359802246094
		 22 -52.455001831054688 23 -52.353286743164063 24 -52.183921813964844 25 -51.943172454833984
		 26 -51.646358489990234 27 -51.333026885986328 28 -51.033058166503906 29 -50.746147155761719
		 30 -50.468402862548828 31 -50.198246002197266 32 -49.938827514648438 33 -49.692459106445313
		 34 -49.459018707275391 35 -49.237297058105469 36 -49.025016784667969 37 -48.818805694580078
		 38 -48.599216461181641 39 -48.362663269042969 40 -48.128372192382812 41 -47.914615631103516
		 42 -47.738922119140625 43 -47.640941619873047 44 -47.639278411865234 45 -47.717247009277344
		 46 -47.874088287353516 47 -47.974681854248047 48 -47.79071044921875 49 -47.15411376953125
		 50 -45.904815673828125 51 -43.708972930908203 52 -40.311447143554687 53 -35.882728576660156
		 54 -30.786434173583984 55 -25.512424468994141 56 -20.57954216003418 57 -16.457267761230469
		 58 -13.522062301635742 59 -11.738754272460937 60 -10.931928634643555 61 -10.869540214538574
		 62 -11.219552993774414 63 -12.02686882019043 64 -13.38188648223877 65 -15.220059394836426
		 66 -17.424783706665039 67 -19.87043571472168 68 -22.420076370239258 69 -24.930282592773438
		 70 -27.258106231689453 71 -29.267213821411133 72 -30.998004913330078 73 -32.526283264160156
		 74 -33.782276153564453 75 -34.701442718505859 76 -35.222000122070313 77 -35.492591857910156
		 78 -35.697669982910156 79 -35.827682495117188 80 -35.873222351074219;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "F2BD85C4-43BE-8887-44C8-C78E46FB9AFD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 24.486126697653372 1 25.299713797685044
		 2 27.058327010472269 3 29.252843337765761 4 31.532450826208457 5 33.695882364544644
		 6 35.576754429964275 7 36.941964738091279 8 37.459190997201006 9 36.458353586236157
		 10 33.240397973596473 11 27.613558311517902 12 20.226309054666395 13 12.142304421447706
		 14 3.862188436355583 15 -5.1093548154693851 16 -16.017646860441417 17 -30.469274455095793
		 18 -48.07762839441051 19 -65.131498116170434 20 -77.624933937303865 21 -83.775058709249407
		 22 -86.471029321096594 23 -88.058227958851219 24 -88.867804534572571 25 -89.126969365316413
		 26 -88.979431912452668 27 -88.615768460105286 28 -88.151352822439719 29 -87.561156445726894
		 30 -86.820187324566831 31 -85.923503089891312 32 -84.871859368532739 33 -83.668563613328459
		 34 -82.314620168649043 35 -80.814109356900261 36 -79.177090663810802 37 -77.420051667116624
		 38 -75.571249226435256 39 -73.66220565535113 40 -71.722193724773888 41 -69.782197182842552
		 42 -67.871789124715306 43 -66.005731050563654 44 -64.174511898957604 45 -62.321718658452248
		 46 -60.12956980858317 47 -57.153064213040629 48 -53.300301976328726 49 -48.37855680367467
		 50 -42.436599411004359 51 -37.294897818057009 52 -32.64035512396844 53 -22.00289059175498
		 54 -12.071951453806962 55 -3.5914710823989657 56 3.1029942809599271 57 7.8138972215428755
		 58 10.350670890440561 59 11.093248759760426 60 10.603852841375515 61 9.4254307691840626
		 62 8.4315357224121552 63 7.397300854887253 64 5.7355349447819686 65 11.201469666481211
		 66 13.083197018049599 67 14.294089426892205 68 15.329556446035243 69 16.375723360176298
		 70 17.513269781227699 71 18.782983583895117 72 19.974084619792237 73 20.899700803189042
		 74 21.635336044772675 75 22.288493762660831 76 22.992152143001721 77 23.659875643862282
		 78 24.122826329685839 79 24.39553745787142 80 24.486126697653372;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "90A2067A-4DC4-F42B-F1C2-468D94B31D83";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.707429674243322 1 52.477455362082139
		 2 52.004746257746561 3 51.495028010461574 4 51.027346236812441 5 50.581846009063177
		 6 50.152894489608762 7 49.852287509938698 8 49.941163142101473 9 50.98819005167239
		 10 53.204808246414046 11 56.076893246160047 12 58.882855669512999 13 61.337783147907921
		 14 63.768896455355204 15 66.622333440940778 16 69.978046242876971 17 73.192488416071427
		 18 74.943806591692905 19 74.609221054976885 20 72.468699081950348 21 69.174424064640021
		 22 65.396216965662916 23 61.446032940250198 24 57.531533295288057 25 53.845388040324806
		 26 50.57580356408122 27 47.848059123583091 28 45.763566663385561 29 44.459058495622735
		 30 43.683119886978027 31 43.105752526108567 32 42.700194041973354 33 42.427702530546973
		 34 42.271485252974401 35 42.211523455715842 36 42.22585285000951 37 42.29132506755365
		 38 42.373373936715588 39 42.45121563600366 40 42.526112540899966 41 42.604177585259606
		 42 42.696109017222497 43 42.872447039130265 44 43.18047658410692 45 43.595291164807534
		 46 44.23072757123478 47 44.864507429213447 48 44.894495667629371 49 44.385473316939866
		 50 43.653453164538199 51 41.989528206904012 52 40.75741880233096 53 43.108411438564623
		 54 44.737261718373098 55 45.783914488997183 56 46.520142419375446 57 47.257361310268649
		 58 48.326333433354812 59 49.75565768483407 60 51.356674305410372 61 52.927388381022787
		 62 54.21783270534381 63 55.323277853423711 64 56.361578459053327 65 55.864659247897521
		 66 55.941172233101547 67 56.09558507123846 68 56.213652025627439 69 56.236356553559531
		 70 56.117335319767392 71 55.804976700605032 72 55.38420782589067 73 54.981945289213627
		 74 54.593185693897595 75 54.195920252121674 76 53.754688166149911 77 53.322676507282971
		 78 52.992117492645285 79 52.781327880509643 80 52.707429674243322;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "8F0D69DC-4CFB-8CCB-A55C-7184445D5B92";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 64.302501174378193 1 64.009544516845153
		 2 62.877563428770259 3 61.419310472203506 4 60.070343553514981 5 59.103381412492254
		 6 58.598329095182365 7 58.443482126221461 8 58.381681575973374 9 57.910944302989435
		 10 56.308676634085558 11 53.397266625933895 12 50.067715172612374 13 47.631871627674457
		 14 46.683347455661718 15 46.603610810079935 16 45.704087322430532 17 41.505470924566211
		 18 33.358962982778088 19 24.374453407606822 20 18.255261232730227 21 16.592234511400235
		 22 17.218270082610147 23 18.49315729916 24 20.09382779220897 25 21.839223342696229
		 26 23.603650702010867 27 25.202141964365911 28 26.529545265307867 29 27.628691052102415
		 30 28.666013815478149 31 29.777108850642843 32 30.958573808272824 33 32.206856059758188
		 34 33.517913912092858 35 34.88641954062647 36 36.304059368555869 37 37.759221608122914
		 38 39.24743821414679 39 40.746551514148088 40 42.217328931898003 41 43.624372436436943
		 42 44.938026941643429 43 46.098132895682518 44 47.079354756938613 45 47.925099939970764
		 46 48.731874330002391 47 49.55598493989848 48 50.134681885125964 49 49.838025769385283
		 50 47.982254172586757 51 42.137043845093203 52 33.732541962966692 53 34.62396343314748
		 54 35.67620401563132 55 36.55884891261794 56 36.950017419984668 57 36.540268577541688
		 58 35.013313675188243 59 32.558616793034084 60 29.611029219195458 61 26.710582103227843
		 62 24.743970476919994 63 23.335826377311175 64 21.732295779485554 65 29.282155121494938
		 66 32.807548704682823 67 35.79115476309579 68 38.769419566776754 69 41.898311789893846
		 70 45.195145655790753 71 48.604601912001996 72 51.906208404325966 73 54.918340108292682
		 74 57.573714979065542 75 59.785447330647379 76 61.452658639748364 77 62.661350189728267
		 78 63.554343075140736 79 64.110297497884474 80 64.302501174378193;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA";
	rename -uid "58091F75-4F22-C1D4-EA97-A4A1D89224EF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.57772707939147949 1 -0.52767002582550049
		 2 -0.39413648843765259 3 -0.20227551460266113 4 0.021395564079284668 5 0.24800014495849609
		 6 0.44692480564117432 7 0.58735555410385132 8 0.63896232843399048 9 0.57332712411880493
		 10 0.40290254354476929 11 0.16611766815185547 12 -0.095991730690002441 13 -0.34845498204231262
		 14 -0.57190650701522827 15 -0.76624679565429688 16 -0.94757020473480225 17 -1.1415917873382568
		 18 -1.3727227449417114 19 -1.6028776168823242 20 -1.7683477401733398 21 -1.8437491655349731
		 22 -1.867377758026123 23 -1.8930319547653198 24 -1.9203208684921265 25 -1.9486813545227051
		 26 -1.9775698184967041 27 -2.006026029586792 28 -2.0331058502197266 29 -2.0578835010528564
		 30 -2.0796115398406982 31 -2.0973892211914062 32 -2.1109070777893066 33 -2.1200351715087891
		 34 -2.1239807605743408 35 -2.1220963001251221 36 -2.113699197769165 37 -2.0981121063232422
		 38 -2.0747013092041016 39 -2.0427982807159424 40 -2.0019254684448242 41 -1.9516565799713135
		 42 -1.8915407657623291 43 -1.8025223016738892 44 -1.6701053380966187 45 -1.5014095306396484
		 46 -1.3554707765579224 47 -1.2760317325592041 48 -1.2427418231964111 49 -1.2351007461547852
		 50 -1.2185474634170532 51 -1.1607339382171631 52 -1.0415387153625488 53 -0.85065221786499023
		 54 -0.592792809009552 55 -0.28663718700408936 56 0.038696050643920898 57 0.34964686632156372
		 58 0.61379921436309814 59 0.81774997711181641 60 0.96588891744613647 61 1.0581053495407104
		 62 1.0968714952468872 63 1.0859382152557373 64 1.0276412963867187 65 0.93096166849136353
		 66 0.80740714073181152 67 0.66462403535842896 68 0.50817424058914185 69 0.34207707643508911
		 70 0.16951781511306763 71 -0.0063113868236541748 72 -0.17828965187072754 73 -0.334016352891922
		 74 -0.46077173948287964 75 -0.54579740762710571 76 -0.57689434289932251 77 -0.57719194889068604
		 78 -0.57743668556213379 79 -0.5776483416557312 80 -0.57772707939147949;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA";
	rename -uid "98176414-4845-3B09-A541-3B9056D65C25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 111.65918731689453 1 111.88237762451172
		 2 112.31704711914062 3 112.53926086425781 4 112.21026611328125 5 111.23224639892578
		 6 109.80142211914062 7 108.35984802246094 8 107.46806335449219 9 107.75244140625
		 10 109.20135498046875 11 111.12155914306641 12 112.56387329101562 13 112.57173919677734
		 14 110.45668792724609 15 106.0667724609375 16 99.880035400390625 17 92.8336181640625
		 18 86.079498291015625 19 80.037796020507812 20 74.654403686523438 21 70.383255004882813
		 22 66.889892578125 23 63.63055419921875 24 60.690254211425781 25 58.151531219482422
		 26 56.091953277587891 27 54.391426086425781 28 52.88690185546875 29 51.588172912597656
		 30 50.504631042480469 31 49.645591735839844 32 48.983070373535156 33 48.482803344726562
		 34 48.14453125 35 47.968574523925781 36 47.955223083496094 37 48.105247497558594
		 38 48.420215606689453 39 48.901298522949219 40 49.549087524414063 41 50.364131927490234
		 42 51.347206115722656 43 52.718326568603516 44 54.656764984130859 45 57.099033355712891
		 46 60.668052673339844 47 65.809371948242187 48 72.118759155273438 49 79.042976379394531
		 50 86.069976806640625 51 93.007339477539063 52 99.295745849609375 53 104.05231475830078
		 54 106.76800537109375 55 107.41912841796875 56 106.44406890869141 57 104.60091400146484
		 58 102.77214813232422 59 101.47438812255859 60 100.85958862304687 61 100.95133209228516
		 62 101.58542633056641 63 102.70317840576172 64 104.21739196777344 65 105.99544525146484
		 66 107.86262512207031 67 109.61088562011719 68 111.07463073730469 69 112.15099334716797
		 70 112.810546875 71 113.09658813476562 72 113.11343383789063 73 112.94107055664062
		 74 112.65350341796875 75 112.3414306640625 76 112.09524536132812 77 111.92176818847656
		 78 111.78337097167969 79 111.69219207763672 80 111.65918731689453;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA";
	rename -uid "21CC4E62-4B34-D909-32C9-40A69C779E71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -35.179100036621094 1 -33.870079040527344
		 2 -30.36871337890625 3 -25.332614898681641 4 -19.475467681884766 5 -13.542160987854004
		 6 -8.2334690093994141 7 -4.139641284942627 8 -1.7450180053710937 9 -1.7646265029907227
		 10 -4.4559531211853027 11 -9.6903085708618164 12 -17.213916778564453 13 -26.392127990722656
		 14 -36.287887573242187 15 -45.732418060302734 16 -53.690113067626953 17 -59.577339172363281
		 18 -63.297012329101563 19 -65.440414428710938 20 -66.591873168945313 21 -67.002128601074219
		 22 -67.047317504882812 23 -66.955421447753906 24 -66.758842468261719 25 -66.468948364257813
		 26 -66.11590576171875 27 -65.75433349609375 28 -65.423011779785156 29 -65.126304626464844
		 30 -64.867340087890625 31 -64.647842407226563 32 -64.469734191894531 33 -64.333641052246094
		 34 -64.237754821777344 35 -64.178802490234375 36 -64.152107238769531 37 -64.151542663574219
		 38 -64.154487609863281 39 -64.153549194335938 40 -64.163650512695313 41 -64.197708129882813
		 42 -64.267333984375 43 -64.399307250976563 44 -64.586990356445313 45 -64.783226013183594
		 46 -64.935150146484375 47 -64.743194580078125 48 -63.765644073486328 49 -61.658073425292969
		 50 -58.178672790527344 51 -52.909568786621094 52 -45.628963470458984 53 -36.847187042236328
		 54 -27.392719268798828 55 -18.214836120605469 56 -10.160992622375488 57 -3.8232135772705078
		 58 0.49032926559448242 59 3.062537670135498 60 4.2823567390441895 61 4.5008072853088379
		 62 4.1285300254821777 63 3.115847110748291 64 1.3317389488220215 65 -1.1935629844665527
		 66 -4.3543152809143066 67 -8.0112781524658203 68 -11.980596542358398 69 -16.038028717041016
		 70 -19.932952880859375 71 -23.404647827148437 72 -26.469966888427734 73 -29.214981079101563
		 74 -31.491111755371094 75 -33.157218933105469 76 -34.079185485839844 77 -34.535472869873047
		 78 -34.881908416748047 79 -35.101837158203125 80 -35.179100036621094;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX";
	rename -uid "8BEE4AD6-480E-9953-414B-9C8C3A15E542";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.2986230880193443 1 -3.2439890728201455
		 2 -3.0895519982840218 3 -2.8458669447361506 4 -2.5307199760657597 5 -2.1781193907822676
		 6 -1.8410731350873377 7 -1.5866784547749266 8 -1.4867525115750653 9 -1.8444451155137973
		 10 -2.7008933788013292 11 -3.7040747321414917 12 -4.5347099517438911 13 -4.9971612774899548
		 14 -5.0256749056685788 15 -4.7324734158222279 16 -4.2812908009936743 17 -3.730767411808154
		 18 -3.169317142975498 19 -2.7179906340333928 20 -2.4216824808236481 21 -2.253854100103819
		 22 -2.1904686635083404 23 -2.2145393495420964 24 -2.285355109068508 25 -2.3751211951135573
		 26 -2.4573680759780587 27 -2.5070432477316533 28 -2.5299648694513492 29 -2.5479847592652716
		 30 -2.5619835663173105 31 -2.5725179852426328 32 -2.5801632613803878 33 -2.5856359060738292
		 34 -2.5891950456643626 35 -2.5912552719957245 36 -2.5854274499351373 37 -2.5674724616273594
		 38 -2.5409837089942355 39 -2.5091953778512588 40 -2.4755599094615 41 -2.4459241837054804
		 42 -2.4190425687715469 43 -2.391702913933329 44 -2.358597536370314 45 -2.3077742874842659
		 46 -2.2287643255213827 47 -2.0822837513619494 48 -1.8394899066163772 49 -1.5052474902738644
		 50 -1.0925040078322754 51 -0.61909072394221365 52 -0.10807687601822057 53 0.40893648533632115
		 54 0.88008799533246407 55 1.1811592074922481 56 1.156988704633916 57 0.68388739153938538
		 58 -0.28165230377658518 59 -1.5957233792201333 60 -2.9934387362296291 61 -4.2283645599624506
		 62 -5.1001614479082322 63 -5.4769952399171773 64 -5.4261421968894323 65 -5.140387359942344
		 66 -4.7074270608882935 67 -4.210183803020783 68 -3.7248706776159426 69 -3.3164186484317542
		 70 -3.0346312739778392 71 -2.9162211443849104 72 -2.9336554728098942 73 -3.0330237171172265
		 74 -3.1554724028097829 75 -3.2564683795488625 76 -3.2986113232596681 77 -3.2986364241354593
		 78 -3.2986719805882374 79 -3.2986199458933751 80 -3.2986230880193443;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY";
	rename -uid "CC343526-4EB6-9FB6-10BF-3DA65D1DAC04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.94580894197846233 1 0.85954451555869793
		 2 0.63303258266816387 3 0.3169293778460302 4 -0.036328275693115059 5 -0.37666949697779395
		 6 -0.66016264947215486 7 -0.8520189160891507 8 -0.9226292999987955 9 -0.88222602345377044
		 10 -0.67434257124038877 11 -0.20336455944784432 12 0.47599022262729529 13 1.163898765582756
		 14 1.6351148170214114 15 1.8629015674548379 16 1.9938851828891637 17 2.1421906754837758
		 18 2.39995018082793 19 2.7312301799935694 20 3.0126695043096205 21 3.1681706224723185
		 22 3.2268779646789345 23 3.2604423985164024 24 3.2812453376798079 25 3.2999235679313346
		 26 3.3233732935694538 27 3.3542011803003176 28 3.3881143402429501 29 3.419907097496659
		 30 3.4484698155223468 31 3.4727154627592745 32 3.4916249914053781 33 3.504305745291064
		 34 3.5097068269127201 35 3.5069276760631567 36 3.4959557106130954 37 3.4766146330614855
		 38 3.4476874233097656 39 3.4079063447579028 40 3.3558324198101515 41 3.2893678977536722
		 42 3.2076386618685446 43 3.0832450733057843 44 2.8950063754338138 45 2.6532480103533538
		 46 2.4341700296184876 47 2.3069572896748518 48 2.2704493383590836 49 2.3171325502401405
		 50 2.4309747063592075 51 2.5799517014404385 52 2.7108469307699568 53 2.7482859368759449
		 54 2.5995303349205456 55 2.1282921613625669 56 1.3039345778767237 57 0.28083250067044174
		 58 -0.69291892290358004 59 -1.3807920349075897 60 -1.6883040001323499 61 -1.6647661810967351
		 62 -1.4699972561613648 63 -1.2952155816040545 64 -1.2030934595951477 65 -1.1330058591136853
		 66 -1.0498115155810619 67 -0.92266711242303578 68 -0.73698734804878752 69 -0.49778726661196643
		 70 -0.22441970096665306 71 0.058159065740874864 72 0.32743083761193015 73 0.5672299427327322
		 74 0.76293939877689987 75 0.89638977983875623 76 0.9458331805834137 77 0.94584526362947807
		 78 0.9458144179853698 79 0.94572562472508848 80 0.94580894197846233;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ";
	rename -uid "5475711F-494A-486F-A88D-0D8EA8342461";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.31909097498970923 1 0.82951736260160636
		 2 2.2016522160498755 3 4.1994923828412212 4 6.5858013439823173 5 9.1228642337549104
		 6 11.573854687382912 7 13.702404276457779 8 15.26820884319074 9 17.538602510557393
		 10 20.70331271612638 11 22.919748454655281 12 22.401396124354537 13 17.479529132031903
		 14 6.4740976208665497 15 -9.7105685226628058 16 -27.917585635159401 17 -46.43989271484061
		 18 -63.57243419466181 19 -78.692685366521417 20 -91.479895579123678 21 -100.67717498910577
		 22 -106.0649517863704 23 -108.50727178807139 24 -109.07288717704694 25 -108.52339874981253
		 26 -107.62292665197205 27 -107.33049023989895 28 -107.69483618093386 29 -108.03444137377701
		 30 -108.34410148057013 31 -108.61766461515103 32 -108.85143686037301 33 -109.03810022597266
		 34 -109.17303746908995 35 -109.25063708236311 36 -109.5012302214093 37 -110.06041110299613
		 38 -110.78084025161893 39 -111.51472213504034 40 -112.11500663458223 41 -112.37657264416136
		 42 -112.33104897963671 43 -111.87208976626403 44 -110.95479882149935 45 -109.88163561404528
		 46 -107.95572752504025 47 -104.98385618026062 48 -101.36772565293192 49 -96.957823257311446
		 50 -91.606668321713599 51 -84.666906283632287 52 -75.630467935722137 53 -64.562729699139695
		 54 -51.527514485173306 55 -35.987855910971611 56 -18.433028930067834 57 -0.46837831248037043
		 58 16.320773298113238 59 31.112019364948445 60 43.359789478002916 61 52.318880096217292
		 62 57.396293807154336 63 57.66581288042218 64 53.668897851602289 65 47.138421317408657
		 66 38.930817836115956 67 29.900007392426129 68 20.902008873407091 69 12.793784209462702
		 70 6.4288199308409144 71 2.696679488834933 72 1.1939018980733558 73 0.95259202643366847
		 74 1.3611041512881383 75 1.80813465476655 76 1.6795014341987493 77 1.1176746094926409
		 78 0.68931505553016581 79 0.41583580571840245 80 0.31909097498970923;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA";
	rename -uid "7BBA22A2-4457-22D1-F883-D295EB123A1E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 29.644681930541992 1 29.644161224365234
		 2 29.642715454101563 3 29.640581130981445 4 29.63800048828125 5 29.635194778442383
		 6 29.63226318359375 7 29.629335403442383 8 29.626676559448242 9 29.624109268188477
		 10 29.621856689453125 11 29.619972229003906 12 29.6185302734375 13 29.617437362670898
		 14 29.615852355957031 15 29.613239288330078 16 29.610237121582031 17 29.607364654541016
		 18 29.604944229125977 19 29.603233337402344 20 29.599180221557617 21 29.594842910766602
		 22 29.590864181518555 23 29.587108612060547 24 29.583467483520508 25 29.579833984375
		 26 29.576147079467773 27 29.572669982910156 28 29.569740295410156 29 29.567422866821289
		 30 29.565954208374023 31 29.565357208251953 32 29.565185546875 33 29.565139770507813
		 34 29.565017700195313 35 29.56492805480957 36 29.564943313598633 37 29.564949035644531
		 38 29.565130233764648 39 29.565441131591797 40 29.565845489501953 41 29.566246032714844
		 42 29.566495895385742 43 29.566614151000977 44 29.566558837890625 45 29.566177368164063
		 46 29.565214157104492 47 29.563541412353516 48 29.561365127563477 49 29.552610397338867
		 50 29.542259216308594 51 29.533884048461914 52 29.526510238647461 53 29.521509170532227
		 54 29.520124435424805 55 29.523090362548828 56 29.530729293823242 57 29.542425155639648
		 58 29.557161331176758 59 29.57365608215332 60 29.590394973754883 61 29.605892181396484
		 62 29.618705749511719 63 29.62840461730957 64 29.634723663330078 65 29.638551712036133
		 66 29.641494750976562 67 29.64366340637207 68 29.645158767700195 69 29.646080017089844
		 70 29.646537780761719 71 29.646785736083984 72 29.646720886230469 73 29.646501541137695
		 74 29.646211624145508 75 29.645856857299805 76 29.645563125610352 77 29.645198822021484
		 78 29.644952774047852 79 29.644725799560547 80 29.644681930541992;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA";
	rename -uid "4DCE0E54-465F-FC42-1129-5A8B6CDB40FB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.418865203857422 1 52.397911071777344
		 2 52.339748382568359 3 52.251499176025391 4 52.140293121337891 5 52.013294219970703
		 6 51.877571105957031 7 51.7401123046875 8 51.607772827148438 9 51.487213134765625
		 10 51.385101318359375 11 51.308219909667969 12 51.258548736572266 13 51.230072021484375
		 14 51.180393218994141 15 51.080204010009766 16 50.940711975097656 17 50.767551422119141
		 18 50.565444946289062 19 50.338043212890625 20 50.065391540527344 21 49.767059326171875
		 22 49.451873779296875 23 49.123401641845703 24 48.786510467529297 25 48.447345733642578
		 26 48.111503601074219 27 47.797351837158203 28 47.525608062744141 29 47.30548095703125
		 30 47.146244049072266 31 47.057132720947266 32 47.010185241699219 33 46.971088409423828
		 34 46.939609527587891 35 46.915500640869141 36 46.898567199707031 37 46.8885498046875
		 38 46.885829925537109 39 46.890117645263672 40 46.900146484375 41 46.914653778076172
		 42 46.932380676269531 43 46.952106475830078 44 46.972568511962891 45 46.992488861083984
		 46 47.008136749267578 47 47.016891479492188 48 47.019069671630859 49 46.975425720214844
		 50 46.976280212402344 51 47.06610107421875 52 47.200550079345703 53 47.381645202636719
		 54 47.612392425537109 55 47.896202087402344 56 48.235725402832031 57 48.631217956542969
		 58 49.079387664794922 59 49.573265075683594 60 50.103195190429687 61 50.625801086425781
		 62 51.087493896484375 63 51.459243774414063 64 51.712646484375 65 51.883769989013672
		 66 52.026432037353516 67 52.143234252929688 68 52.236736297607422 69 52.309539794921875
		 70 52.364189147949219 71 52.403141021728516 72 52.428791046142578 73 52.443470001220703
		 74 52.449367523193359 75 52.448654174804688 76 52.443450927734375 77 52.435817718505859
		 78 52.427814483642578 79 52.421451568603516 80 52.418865203857422;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA";
	rename -uid "F09AE1B1-48D6-5A17-A1E4-2EA970C96210";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145322799682617 1 -17.131654739379883
		 2 -17.090795516967773 3 -17.023130416870117 4 -16.929117202758789 5 -16.808979034423828
		 6 -16.662527084350586 7 -16.489048004150391 8 -16.287309646606445 9 -16.055593490600586
		 10 -15.791884422302246 11 -15.494089126586914 12 -15.160415649414063 13 -14.789663314819336
		 14 -14.383627891540527 15 -13.876623153686523 16 -13.224237442016602 17 -12.461172103881836
		 18 -11.6219482421875 19 -10.741109848022461 20 -9.8686437606811523 21 -9.0297107696533203
		 22 -8.254948616027832 23 -7.5782709121704102 24 -7.0027017593383789 25 -6.5030651092529297
		 26 -6.0709996223449707 27 -5.702385425567627 28 -5.3941969871520996 29 -5.1398425102233887
		 30 -4.9327120780944824 31 -4.7661547660827637 32 -4.6349053382873535 33 -4.5339593887329102
		 34 -4.456972599029541 35 -4.3976478576660156 36 -4.3496456146240234 37 -4.306640625
		 38 -4.2472095489501953 39 -4.1667442321777344 40 -4.0843544006347656 41 -4.0190982818603516
		 42 -3.9900364875793457 43 -4.0162582397460937 44 -4.1167964935302734 45 -4.3106789588928223
		 46 -4.6747612953186035 47 -5.253288745880127 48 -6.0161395072937012 49 -6.9677896499633789
		 50 -8.0527725219726562 51 -9.209197998046875 52 -10.403104782104492 53 -11.607610702514648
		 54 -12.798094749450684 55 -13.951736450195312 56 -15.046820640563965 57 -16.061647415161133
		 58 -16.973110198974609 59 -17.755805969238281 60 -18.381752014160156 61 -18.820766448974609
		 62 -19.042327880859375 63 -19.118118286132813 64 -19.144247055053711 65 -19.124629974365234
		 66 -19.062742233276367 67 -18.964679718017578 68 -18.836557388305664 69 -18.684505462646484
		 70 -18.5146484375 71 -18.333034515380859 72 -18.145687103271484 73 -17.958564758300781
		 74 -17.777542114257812 75 -17.60847282409668 76 -17.457180023193359 77 -17.329437255859375
		 78 -17.231029510498047 79 -17.167718887329102 80 -17.145322799682617;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX";
	rename -uid "6921A60E-4617-730E-E1B8-20A929C61775";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.0615326151095319 1 -2.0496840693638112
		 2 -2.0167086199020732 3 -1.9663947724909057 4 -1.902631878653158 5 -1.8292621056520419
		 6 -1.7499780910638427 7 -1.6683112397356767 8 -1.5875858805599827 9 -1.5109279573737855
		 10 -1.4414549336512723 11 -1.3824451496964243 12 -1.3353227097678757 13 -1.2979976326160318
		 14 -1.2621082835846147 15 -1.2132814883405301 16 -1.1479475678549367 17 -1.0713162884103811
		 18 -0.98788936337906519 19 -0.90121938048655237 20 -0.81687838588424799 21 -0.73441094592389022
		 22 -0.65365712067431692 23 -0.57456567909127254 24 -0.49442615339497287 25 -0.40839833071743648
		 26 -0.31300343608424758 27 -0.21837729156565447 28 -0.13783580490764147 29 -0.073494367398672197
		 30 -0.027659421398291108 31 -0.0024414321678974714 32 0.010042391159696296 33 0.019455884860260973
		 34 0.026424094639817455 35 0.031500306489137007 36 0.035181587881812255 37 0.038089687665292832
		 38 0.041831832711583396 39 0.046819663936627336 40 0.051646952859523032 41 0.054953643119076398
		 42 0.055479861942640228 43 0.051826462295640856 44 0.042631430772697189 45 0.026513566043668193
		 46 -0.0025527843124579538 47 -0.048882808337315425 48 -0.11162579552003864 49 -0.19753841782315995
		 50 -0.31811525718960759 51 -0.44659993562193073 52 -0.55322907324484871 53 -0.64697879166390138
		 54 -0.73797125218509962 55 -0.83596291970920877 56 -0.94890975402924926 57 -1.0809046088425889
		 58 -1.2317198556273272 59 -1.3961620599603946 60 -1.5668026598693627 61 -1.7200493713511356
		 62 -1.831190909884749 63 -1.9056185317401404 64 -1.9540627462778504 65 -1.9851461878182453
		 66 -2.0084705548389135 67 -2.0255464584584821 68 -2.037898750989183 69 -2.0466479019761561
		 70 -2.0527876573565629 71 -2.056997600299086 72 -2.0598284142718168 73 -2.0615874319058833
		 74 -2.0625817142526923 75 -2.0629806777209847 76 -2.0629588311198406 77 -2.0626454979989721
		 78 -2.062185895666234 79 -2.0617523885888227 80 -2.0615326151095319;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY";
	rename -uid "B350EFA6-47D7-921E-C311-FFA7E9E04434";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.27306317554363835 1 -0.28965155677282439
		 2 -0.33500614895420777 3 -0.40173952544427993 4 -0.48209277943211015 5 -0.56914576499854486
		 6 -0.6572433160659843 7 -0.74209130101996601 8 -0.82049655156568591 9 -0.89061097162671277
		 10 -0.95087946952035818 11 -1.0001974535092666 12 -1.0391642503273306 13 -1.0707628567984411
		 14 -1.1237572175005113 15 -1.2118883051165819 16 -1.3169968687694582 17 -1.4279813683590561
		 18 -1.5367320917260019 19 -1.6382574075745511 20 -1.7494810426675256 21 -1.8566338428881166
		 22 -1.9576228189851781 23 -2.0566310385091047 24 -2.1538390812783303 25 -2.244900394427729
		 26 -2.3280104433029991 27 -2.4000020852700401 28 -2.4588099648015129 29 -2.5026765542772402
		 30 -2.5290069410834244 31 -2.5352071617827225 32 -2.5315899284732217 33 -2.5298954837776639
		 34 -2.5293094039109367 35 -2.5288024240684073 36 -2.5272367602839299 37 -2.5237386130561998
		 38 -2.5139056661166155 39 -2.4970645220663061 40 -2.4774119910196699 41 -2.4590749397132527
		 42 -2.4462921015149068 43 -2.4431709847811116 44 -2.4536375427382371 45 -2.4818374933222516
		 46 -2.5434268437727212 47 -2.6467151066124686 48 -2.7842001202622191 49 -2.9767683569167751
		 50 -3.1701310039064348 51 -3.3139377584791148 52 -3.4044278476966046 53 -3.43126231647997
		 54 -3.3878672011503124 55 -3.2734552716610237 56 -3.0923648695901758 57 -2.8533455086656558
		 58 -2.5653500469333146 59 -2.2369051895416385 60 -1.8731050781943188 61 -1.4881462515037209
		 62 -1.114449762630636 63 -0.78764127936548867 64 -0.54990882255687012 65 -0.38813683687185702
		 66 -0.25653918654654972 67 -0.1557869957960383 68 -0.084931161574279698 69 -0.041888037081455477
		 70 -0.023225572622214724 71 -0.024684388969761942 72 -0.042016487827029707 73 -0.070622514135788669
		 74 -0.10622429414197564 75 -0.14494720567049757 76 -0.18328093044777691 77 -0.21822171789811504
		 78 -0.24667190374868256 79 -0.26597019686017365 80 -0.27306317554363835;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "5FD666B4-4155-51AE-CE1F-B395CE9F8D30";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.6493499128949276 1 6.6005911880542332
		 2 6.4692512528866857 3 6.2798383599379362 4 6.0577211162949176 5 5.8260878379972274
		 6 5.6050159770386445 7 5.410820260342085 8 5.256629795292123 9 5.1531381403391343
		 10 5.109988775395351 11 5.1360100221981932 12 5.2323612385544607 13 5.3884644566438986
		 14 5.4721936798477024 15 5.4726228701105111 16 5.5058264941244488 17 5.5908542459986599
		 18 5.7346978927491268 19 5.9306712001801181 20 6.0698963590125539 21 6.1893890738797666
		 22 6.2740448758473688 23 6.2806456179770169 24 6.2087682189591851 25 6.1021115335403406
		 26 5.979221658178929 27 5.8614336063490224 28 5.7638181923504455 29 5.7028552661884158
		 30 5.6967114334586313 31 5.7653812451767159 32 5.8617283295372449 33 5.9294945161159749
		 34 5.9775437441259989 35 6.0147352338892004 36 6.0503493974511331 37 6.0934548532479473
		 38 6.1786134565300603 39 6.3125797858579826 40 6.4626785140011256 41 6.5962057170451764
		 42 6.6800846932062754 43 6.681485787413898 44 6.5677630460597047 45 6.3077071766788499
		 46 5.776604104688297 47 4.9109722483693163 48 3.7744202001374312 49 2.29022221232723
		 50 0.73381240257051683 51 -0.64473335045242308 52 -1.8208568933937592 53 -2.7574419547354085
		 54 -3.426003757129874 55 -3.8072939859884598 56 -3.8888528212224087 57 -3.6649434216983581
		 58 -3.1329719153977726 59 -2.2983412990030048 60 -1.1681372876093912 61 0.195076859289746
		 62 1.6609476861182655 63 3.015005583242643 64 4.0050493324237566 65 4.6980873609500851
		 66 5.2916058782492135 67 5.7813056620911052 68 6.1682712936263409 69 6.4583933645671436
		 70 6.661547129722333 71 6.7905322296966135 72 6.8590268310521365 73 6.8810008040908075
		 74 6.869170552127156 75 6.8353442027855902 76 6.7893351673346345 77 6.7398792428074206
		 78 6.6951430236327525 79 6.6622005883775941 80 6.6493499128949276;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA";
	rename -uid "099B357F-4DB4-FE52-2A02-B9828BEBB7F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.509130477905273 1 -17.509654998779297
		 2 -17.511077880859375 3 -17.51317024230957 4 -17.515766143798828 5 -17.518655776977539
		 6 -17.521564483642578 7 -17.524415969848633 8 -17.527181625366211 9 -17.529684066772461
		 10 -17.531909942626953 11 -17.533821105957031 12 -17.535335540771484 13 -17.53636360168457
		 14 -17.537948608398438 15 -17.540599822998047 16 -17.543567657470703 17 -17.546440124511719
		 18 -17.548822402954102 19 -17.550518035888672 20 -17.55461311340332 21 -17.559003829956055
		 22 -17.562971115112305 23 -17.566715240478516 24 -17.570344924926758 25 -17.573944091796875
		 26 -17.577592849731445 27 -17.581081390380859 28 -17.584072113037109 29 -17.586328506469727
		 30 -17.587900161743164 31 -17.588512420654297 32 -17.588558197021484 33 -17.588737487792969
		 34 -17.588802337646484 35 -17.588830947875977 36 -17.588872909545898 37 -17.58880615234375
		 38 -17.58863639831543 39 -17.588306427001953 40 -17.587970733642578 41 -17.587608337402344
		 42 -17.587331771850586 43 -17.587175369262695 44 -17.587284088134766 45 -17.587673187255859
		 46 -17.588602066040039 47 -17.590221405029297 48 -17.592504501342773 49 -17.601202011108398
		 50 -17.611492156982422 51 -17.619924545288086 52 -17.627328872680664 53 -17.632345199584961
		 54 -17.633729934692383 55 -17.63067626953125 56 -17.623132705688477 57 -17.611433029174805
		 58 -17.596647262573242 59 -17.580183029174805 60 -17.563364028930664 61 -17.547962188720703
		 62 -17.535114288330078 63 -17.525392532348633 64 -17.519153594970703 65 -17.515226364135742
		 66 -17.512279510498047 67 -17.510164260864258 68 -17.508718490600586 69 -17.507743835449219
		 70 -17.507232666015625 71 -17.507064819335938 72 -17.507110595703125 73 -17.507307052612305
		 74 -17.507600784301758 75 -17.507932662963867 76 -17.508306503295898 77 -17.508594512939453
		 78 -17.508855819702148 79 -17.509025573730469 80 -17.509130477905273;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA";
	rename -uid "8D1888CD-45B2-65FC-9753-5A842A740C7F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 36.424163818359375 1 36.403358459472656
		 2 36.347354888916016 3 36.266914367675781 4 36.172996520996094 5 36.075172424316406
		 6 35.980644226074219 7 35.893638610839844 8 35.815349578857422 9 35.744682312011719
		 10 35.678993225097656 11 35.615943908691406 12 35.553962707519531 13 35.492099761962891
		 14 35.394493103027344 15 35.239486694335938 16 35.04583740234375 17 34.825981140136719
		 18 34.590095520019531 19 34.345352172851562 20 34.073165893554687 21 33.7923583984375
		 22 33.508769989013672 23 33.221103668212891 24 32.927947998046875 25 32.628391265869141
		 26 32.320907592773438 27 32.026752471923828 28 31.773847579956055 29 31.571222305297852
		 30 31.427928924560547 31 31.353189468383789 32 31.3189697265625 33 31.290805816650391
		 34 31.268545150756836 35 31.251937866210938 36 31.240732192993164 37 31.23480224609375
		 38 31.234504699707031 39 31.239656448364258 40 31.249038696289063 41 31.261501312255859
		 42 31.275920867919922 43 31.291126251220703 44 31.305967330932617 45 31.319284439086914
		 46 31.327480316162109 47 31.328018188476562 48 31.321296691894531 49 31.268272399902344
		 50 31.259315490722656 51 31.314168930053711 52 31.378616333007813 53 31.480619430541992
		 54 31.648036956787109 55 31.902448654174805 56 32.254135131835937 57 32.699272155761719
		 58 33.219490051269531 59 33.784660339355469 60 34.359260559082031 61 34.899654388427734
		 62 35.368003845214844 63 35.736057281494141 64 35.976646423339844 65 36.127647399902344
		 66 36.244796752929688 67 36.332656860351562 68 36.395809173583984 69 36.438606262207031
		 70 36.465080261230469 71 36.478858947753906 72 36.483119964599609 73 36.480644226074219
		 74 36.473640441894531 75 36.464012145996094 76 36.453239440917969 77 36.442665100097656
		 78 36.433418273925781 79 36.426780700683594 80 36.424163818359375;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA";
	rename -uid "9307D4F8-475D-F0A1-EFF3-E2A234B6CCAB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145320892333984 1 -17.204217910766602
		 2 -17.362297058105469 3 -17.591789245605469 4 -17.864852905273438 5 -18.153284072875977
		 6 -18.428466796875 7 -18.661472320556641 8 -18.823213577270508 9 -18.884544372558594
		 10 -18.816425323486328 11 -18.589862823486328 12 -18.193126678466797 13 -17.643854141235352
		 14 -16.959690093994141 15 -16.0906982421875 16 -15.008428573608398 17 -13.763920783996582
		 18 -12.408411026000977 19 -10.993494987487793 20 -9.5864410400390625 21 -8.2297000885009766
		 22 -6.9710907936096191 23 -5.8614101409912109 24 -4.9202117919921875 25 -4.1385288238525391
		 26 -3.5239782333374023 27 -3.0341997146606445 28 -2.6169757843017578 29 -2.2652740478515625
		 30 -1.9720187187194824 31 -1.7301464080810547 32 -1.5339756011962891 33 -1.3780288696289062
		 34 -1.2555761337280273 35 -1.1598854064941406 36 -1.0842018127441406 37 -1.0217971801757812
		 38 -0.95083522796630859 39 -0.86628341674804688 40 -0.78686046600341797 41 -0.73122310638427734
		 42 -0.71804141998291016 43 -0.76599788665771484 44 -0.89371490478515625 45 -1.1198287010192871
		 46 -1.5208182334899902 47 -2.140507698059082 48 -2.9483699798583984 49 -3.9485054016113281
		 50 -5.0850458145141602 51 -6.4330081939697266 52 -8.0584688186645508 53 -9.8789567947387695
		 54 -11.812950134277344 55 -13.778781890869141 56 -15.694370269775391 57 -17.477424621582031
		 58 -19.04536247253418 59 -20.315223693847656 60 -21.202972412109375 61 -21.739555358886719
		 62 -21.996841430664063 63 -22.052726745605469 64 -22.009437561035156 65 -21.876914978027344
		 66 -21.664642333984375 67 -21.384719848632812 68 -21.049293518066406 69 -20.670581817626953
		 70 -20.2608642578125 71 -19.832382202148438 72 -19.397422790527344 73 -18.968227386474609
		 74 -18.556987762451172 75 -18.175865173339844 76 -17.837001800537109 77 -17.552467346191406
		 78 -17.334327697753906 79 -17.194580078125 80 -17.145320892333984;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX";
	rename -uid "04EF9FE3-49EF-B3B2-470D-18AB7F70773E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -7.8983403485937878 1 -7.9372819782790245
		 2 -8.0419572225263725 3 -8.1936705213342442 4 -8.3738598457906566 5 -8.5639573021757585
		 6 -8.7472809652908587 7 -8.9082866718704068 8 -9.0328973521327338 9 -9.108525222473757
		 10 -9.122801284818344 11 -9.0626678933956004 12 -8.9217801535638053 13 -8.7066768726944037
		 14 -8.4403816487179366 15 -8.1076464319721442 16 -7.6803045730484856 17 -7.169495273567267
		 18 -6.5900168892243309 19 -5.9617177776307217 20 -5.32065697588546 21 -4.6866033956481985
		 22 -4.0882268230420227 23 -3.56002492868486 24 -3.1199052645354439 25 -2.7676987834842084
		 26 -2.5126404395083086 27 -2.323226248043174 28 -2.1584926046993047 29 -2.0125600012214373
		 30 -1.8789868848464004 31 -1.7511323610611618 32 -1.6368499823664915 33 -1.5459628137707628
		 34 -1.4745199076265936 35 -1.4182769212033612 36 -1.3728614655941116 37 -1.3340973568733379
		 38 -1.2869029999845452 39 -1.2284887098872397 40 -1.171582630359578 41 -1.1292118957978934
		 42 -1.1144206002801129 43 -1.1403085033385403 44 -1.2196134013456172 45 -1.3646299350957365
		 46 -1.6261751478521786 47 -2.0300075543267151 48 -2.5504518909157996 49 -3.1864012786692775
		 50 -3.8682412870497087 51 -4.6310614097154055 52 -5.523651250693522 53 -6.4819400296197749
		 54 -7.4467516015059418 55 -8.3636026281853297 56 -9.1826162341409088 57 -9.8599408626715199
		 58 -10.360452244829359 59 -10.662301057169902 60 -10.757041125884562 61 -10.69909651241424
		 62 -10.555638906541846 63 -10.380501728075686 64 -10.231943609651363 65 -10.095521363885917
		 66 -9.9452038431440766 67 -9.783005525466729 68 -9.6108213303067167 69 -9.4306366640184898
		 70 -9.2447113482208056 71 -9.0556690863601155 72 -8.8668397425840126 73 -8.681837835580172
		 74 -8.5052880119113148 75 -8.3416228855129191 76 -8.1959016403945935 77 -8.0734512693090537
		 78 -7.9795173968533319 79 -7.9194673772628184 80 -7.8983403485937878;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY";
	rename -uid "FB41430E-4F0C-BDF1-E0CA-8CAA41E4BF83";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 19.354953368372353 1 19.361716747120205
		 2 19.379910219853144 3 19.405726891385552 4 19.435532843322108 5 19.466299601196482
		 6 19.495740057682223 7 19.522496842625447 8 19.546246062527111 9 19.567283214061963
		 10 19.585991006133035 11 19.602090487920705 12 19.614638139684615 13 19.622154514323814
		 14 19.623325021761612 15 19.617329170649977 16 19.599647780375378 17 19.56469292946629
		 18 19.508637185638037 19 19.430232533164791 20 19.335593076166624 21 19.226056835232427
		 22 19.106866774166942 23 18.98676099254164 24 18.875484235220881 25 18.782009180875356
		 26 18.715887110178819 27 18.669118399198041 28 18.627112682805759 29 18.589092931720007
		 30 18.553754500557034 31 18.519862859423995 32 18.488967271588141 33 18.463122507564837
		 34 18.442101195955459 35 18.425243210484521 36 18.411835582902143 37 18.401263846751149
		 38 18.391083573390237 39 18.380656947942942 40 18.371991654017712 41 18.367200434734347
		 42 18.368404578698687 43 18.377632339379321 44 18.396566136235819 45 18.426767424252564
		 46 18.474953565883023 47 18.542860819654113 48 18.623718907040189 49 18.723643257244685
		 50 18.821632417693348 51 18.940525465149886 52 19.098752194366593 53 19.270462774824395
		 54 19.43445562210335 55 19.57204666740666 56 19.666226075729018 57 19.706049120695408
		 58 19.691430351731174 59 19.636313576937802 60 19.564199106324466 61 19.49954016830678
		 62 19.45528085966243 63 19.430001600617071 64 19.417266189004707 65 19.412757479142229
		 66 19.41214484773732 67 19.413980985025383 68 19.416516106222737 69 19.418819445908039
		 70 19.419655705775629 71 19.418424001301524 72 19.41486825486497 73 19.408768224878621
		 74 19.400639413388358 75 19.390942579753411 76 19.380705600561285 77 19.370893522546375
		 78 19.362676474814943 79 19.357010160964254 80 19.354953368372353;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "F82CDDBD-494C-E37B-C436-6CA3BB89ABCC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 7.4464862061454662 1 7.2903971558183764
		 2 6.8694788688992681 3 6.253706960746257 4 5.5129312007793576 5 4.7191409584127921
		 6 3.9444772484162809 7 3.263061696244653 8 2.7502725828896781 9 2.4816008417477202
		 10 2.5326460739069705 11 2.9786169232913471 12 3.8491418609903416 13 5.0964969237504283
		 14 6.6720048640562561 15 8.6740331228739702 16 11.154167667025147 17 13.991787497796825
		 18 17.065593948558806 19 20.255642189821405 20 23.417706520684828 21 26.460024599843553
		 22 29.282189070859381 23 31.778365658476883 24 33.9058457822835 25 35.680455873137994
		 26 37.08351462394004 27 38.210436507133856 28 39.176009678222407 29 39.990854663514178
		 30 40.665812125905255 31 41.212137960941419 32 41.649487627035171 33 41.998791267215381
		 34 42.273991816640859 35 42.48917923792542 36 42.658883857150478 37 42.797142013646585
		 38 42.950860590429642 39 43.130157457042984 40 43.296323982678878 41 43.409768600251127
		 42 43.430875914754324 43 43.319816789941413 44 43.037449810114431 45 42.545945022277692
		 46 41.688196904677334 47 40.383259248224974 48 38.708736455730659 49 36.682042846228214
		 50 34.391739483603821 51 31.633022030737866 52 28.254012180514483 53 24.385841086734956
		 54 20.143813819180025 55 15.656064414602813 56 11.095293056796523 57 6.6979719368027695
		 58 2.754744333248262 59 -0.4295249557750056 60 -2.5827403678001457 61 -3.7984665364121191
		 62 -4.317676367909165 63 -4.3550105210353083 64 -4.1702214516091001 65 -3.7943328499152265
		 66 -3.2411777376518089 67 -2.540064616084718 68 -1.7195696888171166 69 -0.80706021545416862
		 70 0.169804443278714 71 1.1838049910953981 72 2.2074663210243255 73 3.2131992817632367
		 74 4.1731871881362883 75 5.0601083383716912 76 5.8467839905621251 77 6.5057847834848079
		 78 7.01022376371386 79 7.3328058746640776 80 7.4464862061454662;
	setAttr ".roti" 5;
createNode pairBlend -n "pairBlend1";
	rename -uid "4130AD65-4D18-090A-1FE3-3D9929552B64";
createNode pairBlend -n "pairBlend2";
	rename -uid "8EACD74A-4BD2-6FBC-0AF3-61B305DF130E";
createNode pairBlend -n "pairBlend3";
	rename -uid "C3DDA32C-474F-E9F9-2656-EC829982F073";
createNode pairBlend -n "pairBlend4";
	rename -uid "41C2921B-4477-9D6B-525A-FCA821B3811A";
createNode pairBlend -n "pairBlend5";
	rename -uid "73619A34-406E-50A1-0A40-8DABFF7BB5AF";
createNode pairBlend -n "pairBlend6";
	rename -uid "2945BE14-4C04-3DEC-CA16-EA96927C0DA5";
createNode pairBlend -n "pairBlend7";
	rename -uid "42F5DE18-45E8-885B-5473-31ACF2EAFAC6";
createNode pairBlend -n "pairBlend8";
	rename -uid "37B7BE26-4C1F-320B-ACEE-7989577DAA7D";
createNode pairBlend -n "pairBlend9";
	rename -uid "0F2A70DB-4A5D-798E-E813-ECBB926F9B08";
createNode pairBlend -n "pairBlend10";
	rename -uid "FAB28B1B-45D8-7793-8AC8-1FB37C81143D";
createNode pairBlend -n "pairBlend11";
	rename -uid "BEC30505-42E3-386A-D68A-BBB19CD982A6";
createNode pairBlend -n "pairBlend12";
	rename -uid "E1266FBF-4AF0-7924-8889-129A8C7FC32D";
createNode pairBlend -n "pairBlend13";
	rename -uid "84C2CE7C-4C65-2D84-5BAB-ABA0943A61D5";
createNode pairBlend -n "pairBlend14";
	rename -uid "111B5182-4EB9-6FF9-0D52-399723CF1269";
createNode pairBlend -n "pairBlend15";
	rename -uid "9D947A5F-4A5B-1ACD-4DCA-358FF0586171";
createNode pairBlend -n "pairBlend16";
	rename -uid "3702641F-4B2B-A485-2B90-2FAED06B1A2D";
createNode pairBlend -n "pairBlend17";
	rename -uid "2E4C9FC1-4307-881B-BFD6-40B736D83492";
createNode pairBlend -n "pairBlend18";
	rename -uid "05E8B260-4FF1-2119-937A-EC82C8687C51";
createNode pairBlend -n "pairBlend19";
	rename -uid "25100742-4027-28AB-730F-4381E9F79F49";
createNode pairBlend -n "pairBlend20";
	rename -uid "C6BE5AC9-4C3D-BF9C-FAEB-5590BA502F0B";
createNode pairBlend -n "pairBlend21";
	rename -uid "86C39005-49BD-5BC8-744A-84B5850669C3";
createNode pairBlend -n "pairBlend22";
	rename -uid "9BCA0387-455B-CD2B-3AC5-C9B631B7EB27";
createNode pairBlend -n "pairBlend23";
	rename -uid "8008F6A6-4FA3-671D-5FF0-068DD9C53270";
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 58;
	setAttr ".unw" 58;
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
// End of overboss_idle_drink.ma
