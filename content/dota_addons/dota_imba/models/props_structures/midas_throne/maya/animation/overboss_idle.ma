//Maya ASCII 2016 scene
//Name: overboss_idle.ma
//Last modified: Wed, May 27, 2015 09:56:14 AM
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
	setAttr ".t" -type "double3" -360.55766834577236 116.36021465156827 358.70358313036502 ;
	setAttr ".r" -type "double3" -6.3383527296227955 -42.199999999999783 5.3667233866492833e-016 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 516.56480312427277;
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
	rename -uid "EE39E26C-4CB6-DD63-CFB6-C2A70942F0FD";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "C52BADE7-47A7-2E4A-6091-A085B16C0D1A";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "6C5489A0-4128-9514-CCC0-1EA70233A7A5";
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
	rename -uid "514D43D3-49F8-0BFC-E072-8BBC3B6BFDE6";
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
	rename -uid "8EC63F10-467C-D18C-27D4-2C8DB21BD2AD";
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
	rename -uid "C19D9530-4F60-EEBD-0C8B-9C8B6617B673";
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
	rename -uid "74CBE31E-4D3B-5968-C8C4-7FAE5C308EED";
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
	rename -uid "1EFD13D5-47EF-02D0-5989-669A6D9637FD";
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
	rename -uid "0FF9829D-4BCD-70E0-C80B-2E8DAF2D047A";
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
	rename -uid "45ADBBB4-4FEA-4380-1557-5F8C2590BA98";
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
	rename -uid "D3AF1D50-43DC-F722-0858-4799BD62C666";
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
	rename -uid "25DF8EB5-4867-8FE8-8FAC-9E8826643AB2";
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
	rename -uid "09CFCB7E-426D-40B2-BC56-4483F66ADC63";
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
	rename -uid "2CE870EB-4034-DF36-5963-6F8F917D7E4C";
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
	rename -uid "D0E7C6E8-4BDB-7143-A617-9E95468FA44F";
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
	rename -uid "1CA322E2-419C-E30D-D124-6F859468CEB1";
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
	rename -uid "1DCCCC22-4D38-F993-EA77-97BE694B0C8E";
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
	rename -uid "578DA422-4C36-4F44-F8D5-F8BE4082903F";
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
	rename -uid "BAC964A2-41DD-C88D-3997-E0AFA11D295A";
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
	rename -uid "5AB627D3-4B45-9729-B18F-EA8F7D51365B";
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
	rename -uid "A3FABF29-405F-3AA8-F1F9-468ED9868B84";
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
	rename -uid "61530F29-4EF1-4472-B0A9-56B1E2AC6300";
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
	rename -uid "FA00A4C6-47F6-6255-DAA2-04B951BCC02C";
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
	rename -uid "674BEBFB-4273-4BCF-EB4E-5CB43AA69C29";
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
	rename -uid "51F02386-4269-EAE2-B932-C3B254C25084";
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
	rename -uid "3B1412CA-43E3-57DE-682D-5FAC1CB076C2";
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
	rename -uid "EE095A02-46B4-36D7-F1D1-5F88B28EB16A";
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
	rename -uid "AEBDDAD2-4EFD-31D1-4D7F-D597D2FDB738";
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
	rename -uid "B09BE538-4900-0EFD-EF03-C8A6B0F9C313";
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
	rename -uid "9C38D396-4508-0641-FCB0-349355578270";
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
	rename -uid "F1EBF371-4905-E2EB-893A-C1BE8B80697C";
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
	rename -uid "EBB9CBB4-4B38-1819-9C85-1A8F05B5A4BE";
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
	rename -uid "646C11FB-421C-EEA5-255C-A9A0C09A3404";
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
	rename -uid "7C51CB5A-48FD-AC34-8E23-59956941E982";
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
	rename -uid "5914AB25-454B-4A8A-2427-67901F510709";
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
	rename -uid "C42DF17A-41DA-F92E-DD0A-2A949983992F";
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
	rename -uid "680D7273-4C8F-6B40-97BC-1DA33EBA95BF";
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
	rename -uid "52B45199-4574-6243-3AEA-73B700D5F572";
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
	rename -uid "A1C99B75-416C-2B09-8648-53935657B8C3";
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
	rename -uid "BAD2E51A-48F8-F919-2F13-9287260F9039";
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
	rename -uid "9C015689-4881-0DC9-4D39-8E942ADA6206";
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
	rename -uid "BEED4786-49DC-2271-A2CD-0289891F0733";
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
	rename -uid "054216A2-46F5-A591-867D-9D9FFEDB9C85";
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
	rename -uid "2225105F-4CA6-DD74-5D07-DA881C045F23";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "198D9DD2-4D88-188A-55A3-EBB410F54E69";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "108584AC-4665-8B3B-B788-CA936CAF0D7B";
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
		2 "RIG:CTRL" "visibility" " 0"
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
	setAttr ".HipsTx" 4.7032566070556641;
	setAttr ".HipsTy" 51.758499145507812;
	setAttr ".HipsTz" -20.305294036865234;
	setAttr ".HipsRz" 18.737104454443628;
	setAttr ".HipsSx" 1.0000000826758291;
	setAttr ".HipsSy" 1.0000000826758291;
	setAttr ".HipsSz" 1.0000001192092896;
	setAttr ".LeftUpLegTx" 24.89636112976811;
	setAttr ".LeftUpLegTy" -7.7306260368556607;
	setAttr ".LeftUpLegTz" 3.1970268253056133;
	setAttr ".LeftUpLegRx" -5.7458918019729133;
	setAttr ".LeftUpLegRy" 17.407993855866842;
	setAttr ".LeftUpLegRz" 10.28322913795002;
	setAttr ".LeftUpLegSx" 1.0000000268451394;
	setAttr ".LeftUpLegSy" 1.0000000450950917;
	setAttr ".LeftUpLegSz" 0.99999996472754249;
	setAttr ".LeftLegTx" 21.226185895910739;
	setAttr ".LeftLegTy" 1.0034005796799583e-006;
	setAttr ".LeftLegTz" -2.7353932132712089e-006;
	setAttr ".LeftLegRx" 2.9302768844559859;
	setAttr ".LeftLegRy" 0.77689588664178821;
	setAttr ".LeftLegRz" -34.605166123126949;
	setAttr ".LeftLegSx" 0.99999990652826165;
	setAttr ".LeftLegSy" 1.0000000127059094;
	setAttr ".LeftLegSz" 0.99999999620970759;
	setAttr ".LeftFootTx" 15.941058631651366;
	setAttr ".LeftFootTy" -5.190898082929607e-006;
	setAttr ".LeftFootTz" -3.8200138163801967e-008;
	setAttr ".LeftFootRx" -18.568625196882127;
	setAttr ".LeftFootRy" -15.811168114741591;
	setAttr ".LeftFootRz" -18.713474243184312;
	setAttr ".LeftFootSx" 1.0000000293704365;
	setAttr ".LeftFootSy" 1.0000001561060745;
	setAttr ".LeftFootSz" 1.0000002076873387;
	setAttr ".RightUpLegTx" -24.89631307059809;
	setAttr ".RightUpLegTy" -7.7305989482694102;
	setAttr ".RightUpLegTz" 3.1970249179571901;
	setAttr ".RightUpLegRx" 16.825469191391292;
	setAttr ".RightUpLegRy" -39.60199025448906;
	setAttr ".RightUpLegRz" -5.6379231403766727;
	setAttr ".RightUpLegSx" 1.0000001718895857;
	setAttr ".RightUpLegSy" 1.0000001928103717;
	setAttr ".RightUpLegSz" 1.0000001680871198;
	setAttr ".RightLegTx" -21.226185835731314;
	setAttr ".RightLegTy" 1.6636590456364786e-005;
	setAttr ".RightLegTz" -7.517626347919304e-005;
	setAttr ".RightLegRx" 6.6685797690007078;
	setAttr ".RightLegRy" -0.89543699020083567;
	setAttr ".RightLegRz" 35.444620055812692;
	setAttr ".RightLegSx" 1.0000000493955552;
	setAttr ".RightLegSy" 1.0000000156968205;
	setAttr ".RightLegSz" 1.0000000511931164;
	setAttr ".RightFootTx" -15.941099446403442;
	setAttr ".RightFootTy" 3.844434625221993e-005;
	setAttr ".RightFootTz" 4.6860169920392991e-005;
	setAttr ".RightFootRx" -30.187649794752154;
	setAttr ".RightFootRy" -4.5310117024267056;
	setAttr ".RightFootRz" 36.307173425434662;
	setAttr ".RightFootSx" 0.99999992547020178;
	setAttr ".RightFootSy" 0.99999994056761909;
	setAttr ".RightFootSz" 1.0000000424787387;
	setAttr ".SpineTx" -1.3352494718787966e-006;
	setAttr ".SpineTy" 3.3825322223635368;
	setAttr ".SpineTz" -3.783547904068481;
	setAttr ".SpineRx" 0.70486440283396068;
	setAttr ".SpineRy" -3.1264326795496742;
	setAttr ".SpineRz" -6.0208067120219777;
	setAttr ".SpineSx" 1.000000046019222;
	setAttr ".SpineSy" 1.0000000644409519;
	setAttr ".SpineSz" 1.0000000370453563;
	setAttr ".LeftArmTx" 7.5598047890283766;
	setAttr ".LeftArmTy" -1.3346370417088309;
	setAttr ".LeftArmTz" 6.4182779033864676;
	setAttr ".LeftArmRx" 19.861840567250614;
	setAttr ".LeftArmRy" -13.613784651228563;
	setAttr ".LeftArmRz" 2.1700315325062172;
	setAttr ".LeftArmSx" 0.99999983558169891;
	setAttr ".LeftArmSy" 0.99999991363223162;
	setAttr ".LeftArmSz" 0.99999989769460595;
	setAttr ".LeftForeArmTx" 23.627864851722492;
	setAttr ".LeftForeArmTy" -0.36613222539874002;
	setAttr ".LeftForeArmTz" 0.61648753939162759;
	setAttr ".LeftForeArmRx" -8.5579566614878626;
	setAttr ".LeftForeArmRy" -10.753785696264739;
	setAttr ".LeftForeArmRz" 40.690465033447701;
	setAttr ".LeftForeArmSx" 1.0000000372226463;
	setAttr ".LeftForeArmSy" 1.00000013064715;
	setAttr ".LeftForeArmSz" 1.0000000467727195;
	setAttr ".LeftHandTx" 22.329464872764937;
	setAttr ".LeftHandTy" -0.34351699463847751;
	setAttr ".LeftHandTz" 0.83665808463152302;
	setAttr ".LeftHandRx" -18.011638967060986;
	setAttr ".LeftHandRy" 21.260765146630316;
	setAttr ".LeftHandRz" -18.507282406503673;
	setAttr ".LeftHandSx" 1.0000000395903132;
	setAttr ".LeftHandSy" 1.0000000292708522;
	setAttr ".LeftHandSz" 0.99999997840343691;
	setAttr ".RightArmTx" -7.5598887349040496;
	setAttr ".RightArmTy" 1.3346049436813985;
	setAttr ".RightArmTz" -6.4178992372730477;
	setAttr ".RightArmRx" 4.5640571793157418;
	setAttr ".RightArmRy" 5.0458563921909514;
	setAttr ".RightArmRz" -51.202750645733516;
	setAttr ".RightArmSx" 0.99999999958061991;
	setAttr ".RightArmSy" 0.99999990242155057;
	setAttr ".RightArmSz" 1.0000000131714335;
	setAttr ".RightForeArmTx" -23.627897285106442;
	setAttr ".RightForeArmTy" 0.36613670430534029;
	setAttr ".RightForeArmTz" -0.61642960409318448;
	setAttr ".RightForeArmRx" -2.9137247441178249;
	setAttr ".RightForeArmRy" -6.6187385664798271;
	setAttr ".RightForeArmRz" 14.616400337855625;
	setAttr ".RightForeArmSx" 1.0000002186168537;
	setAttr ".RightForeArmSy" 1.0000000196105046;
	setAttr ".RightForeArmSz" 1.0000000974011327;
	setAttr ".RightHandTx" -22.329450342064291;
	setAttr ".RightHandTy" 0.34352578335210815;
	setAttr ".RightHandTz" -0.83667910319852012;
	setAttr ".RightHandRx" -69.801863603650233;
	setAttr ".RightHandRy" -49.593371241937938;
	setAttr ".RightHandRz" -57.791279172282771;
	setAttr ".RightHandSx" 1.0000000636163968;
	setAttr ".RightHandSy" 1.0000001187792564;
	setAttr ".RightHandSz" 0.99999992896094125;
	setAttr ".HeadTx" 8.0099216899826757;
	setAttr ".HeadTy" 4.5063573850256944e-007;
	setAttr ".HeadTz" -4.9014095795385515e-006;
	setAttr ".HeadRx" -1.8493951157411823;
	setAttr ".HeadRy" 4.6951580071021333;
	setAttr ".HeadRz" 11.896199129196953;
	setAttr ".HeadSx" 1.0000001888632168;
	setAttr ".HeadSy" 1.0000001219095667;
	setAttr ".HeadSz" 1.0000002180556884;
	setAttr ".LeftToeBaseTx" 6.8757455550791136;
	setAttr ".LeftToeBaseTy" -1.732825648304015e-006;
	setAttr ".LeftToeBaseTz" 2.2481742867341836e-006;
	setAttr ".LeftToeBaseRx" 10.185520881421221;
	setAttr ".LeftToeBaseRy" 17.284284831805905;
	setAttr ".LeftToeBaseRz" 1.6752847922640308;
	setAttr ".LeftToeBaseSx" 1.0000000991305944;
	setAttr ".LeftToeBaseSy" 1.000000157092092;
	setAttr ".LeftToeBaseSz" 1.0000000482942599;
	setAttr ".RightToeBaseTx" -6.875752120809528;
	setAttr ".RightToeBaseTy" -9.3095831132927742e-007;
	setAttr ".RightToeBaseTz" 2.2128073062788189e-005;
	setAttr ".RightToeBaseRx" -10.214718374210486;
	setAttr ".RightToeBaseRy" 1.2172754290669046;
	setAttr ".RightToeBaseRz" 4.0649890413112839;
	setAttr ".RightToeBaseSx" 1.0000000737313353;
	setAttr ".RightToeBaseSy" 0.99999999111120663;
	setAttr ".RightToeBaseSz" 0.99999999708285137;
	setAttr ".LeftShoulderTx" 10.381337546627705;
	setAttr ".LeftShoulderTy" 5.2150751845488816;
	setAttr ".LeftShoulderTz" 13.982763266380058;
	setAttr ".LeftShoulderRx" -3.6824943124617806;
	setAttr ".LeftShoulderRy" 3.6169575101891911;
	setAttr ".LeftShoulderRz" 5.5567487126836452;
	setAttr ".LeftShoulderSx" 1.0000001077066683;
	setAttr ".LeftShoulderSy" 1.0000001825110008;
	setAttr ".LeftShoulderSz" 1.0000001625329611;
	setAttr ".RightShoulderTx" 10.381000596936005;
	setAttr ".RightShoulderTy" 5.2151831006922169;
	setAttr ".RightShoulderTz" -13.982799464253198;
	setAttr ".RightShoulderRx" 6.7990118645147328;
	setAttr ".RightShoulderRy" 1.6537958935524235;
	setAttr ".RightShoulderRz" -11.100559940792328;
	setAttr ".RightShoulderSx" 1.0000000335986303;
	setAttr ".RightShoulderSy" 0.99999990073427225;
	setAttr ".RightShoulderSz" 0.99999995418375898;
	setAttr ".NeckTx" 17.971177485401313;
	setAttr ".NeckTy" 1.6412649892494358e-006;
	setAttr ".NeckTz" 3.3465023658862947e-006;
	setAttr ".NeckRz" 30.934858113363482;
	setAttr ".NeckSx" 1.0000001388927084;
	setAttr ".NeckSy" 1.0000001059953905;
	setAttr ".NeckSz" 1.0000001837234336;
	setAttr ".Spine1Tx" 7.1917514351694791;
	setAttr ".Spine1Ty" -6.9087100129650025e-007;
	setAttr ".Spine1Tz" -6.7832915107146619e-007;
	setAttr ".Spine1Rx" 3.3800582901217937;
	setAttr ".Spine1Ry" -5.4388793897450531;
	setAttr ".Spine1Rz" -12.173120582710016;
	setAttr ".Spine1Sx" 1.0000000249854997;
	setAttr ".Spine1Sy" 1.0000001450854121;
	setAttr ".Spine1Sz" 1.0000000598559158;
	setAttr ".Spine2Tx" 15.480274663168245;
	setAttr ".Spine2Ty" 2.923263490384187e-006;
	setAttr ".Spine2Tz" -1.0697592429664837e-006;
	setAttr ".Spine2Rx" 3.8052380288420022;
	setAttr ".Spine2Ry" -5.1507968213041462;
	setAttr ".Spine2Rz" -12.183747135156636;
	setAttr ".Spine2Sx" 0.99999992852929565;
	setAttr ".Spine2Sy" 1.0000000085229119;
	setAttr ".Spine2Sz" 1.0000000483653824;
	setAttr ".Spine3Tx" 13.088919256312892;
	setAttr ".Spine3Ty" -2.6707523765878705e-006;
	setAttr ".Spine3Tz" 3.5445947510481801e-008;
	setAttr ".Spine3Rx" 0.89836778135160644;
	setAttr ".Spine3Ry" -6.3378253801837774;
	setAttr ".Spine3Rz" -12.06228186467572;
	setAttr ".Spine3Sx" 1.0000000484567593;
	setAttr ".Spine3Sy" 0.99999998312858562;
	setAttr ".Spine3Sz" 0.99999998185803407;
createNode vstExportNode -n "kobold_overboss_anim_exportNode";
	rename -uid "1F3F6F34-4D0E-BDCF-99B8-31A981634A25";
	setAttr ".ei[0].exportFile" -type "string" "overboss_idle";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 80;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "43918641-4EE7-D7BD-EEFF-ED99B94177A0";
	setAttr ".ihi" 0;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "23A03C66-4D07-0C8E-21D5-1888783770C9";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "E6A71924-492F-9C46-70B5-F1956AB1A3DB";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "D64467C1-4D28-402C-1B7C-9AAE762D5A77";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "ED821DB3-4D50-E476-51BB-268545B17807";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "D0330D60-4B7A-8F83-9E7E-65AE4AAB30BD";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "4DFCECE2-4645-7E46-FEEF-4EA0CFD07A22";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "F1713F7F-4E1C-7108-3157-BAAC4A24061F";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "72E2649A-4900-1D4E-5203-33AB63247668";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "B2AEF7DD-45C8-1718-B1C0-3793100BDF72";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "720D4878-49B3-DB32-2EAD-C6BF0D95C1C0";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "09E75243-4D45-0B57-31F2-90AF9804C57F";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "AF9D2811-4AEA-5B92-6F60-A493DC9116BB";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "8DAD3AAE-432B-B158-39B1-FB870749560A";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "B75B72BD-41FF-7C15-4300-A5B1E332E12B";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "E2CC1026-4059-1D5F-CDF2-45A3B2B259AB";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "68F14151-4B2F-EE95-43B2-5BBAA840A9FA";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700253009796143 0.32122635841369629 2.552283117738006e-016 0
		 -0.32122635841369629 0.94700253009796143 1.8293749079699429e-016 0 -1.8293749079699429e-016 -2.552283117738006e-016 1.0000001192092896 0
		 4.7032566070556641 51.758499145507812 -20.305294036865234 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99924123287200928 -0.022659184411168098 -0.031685046851634979 0
		 0.026394473388791084 0.99206435680389404 0.12293105572462082 0 0.028648082166910172 -0.12367404997348785 0.9919094443321228 0
		 30.763454437255859 52.434944152832031 -17.108266830444336 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99409908056259155 0.050936508923768997 -0.095775328576564789 0
		 -0.088994480669498444 0.88779163360595703 -0.45156008005142212 0 0.062027622014284134 0.45741885900497437 0.88708573579788208 0
		 28.75535774230957 31.687206268310547 -13.102032661437988 1;
	setAttr ".LeftFootGX" -type "matrix" 0.85706526041030884 -0.18317480385303497 -0.48154515027999878 0
		 0.1451030969619751 0.98264813423156738 -0.1155313178896904 0 0.49435195326805115 0.02914419025182724 0.86877298355102539 0
		 25.034614562988281 17.078479766845703 -18.284549713134766 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.91998326778411865 -0.38152283430099487 -0.089839503169059753 0
		 0.39047342538833618 0.91202819347381592 0.12543971836566925 0 0.034078042954206467 -0.15048237144947052 0.98802518844604492 0
		 -16.390342712402344 36.440250396728516 -17.108268737792969 1;
	setAttr ".RightLegGX" -type "matrix" 0.98286664485931396 -0.12770920991897583 -0.13290587067604065 0
		 0.18389689922332764 0.72822660207748413 0.66020321846008301 0 0.012471534311771393 -0.6733325719833374 0.7392348051071167 0
		 -22.504776000976563 16.458660125732422 -13.379880905151367 1;
	setAttr ".RightFootGX" -type "matrix" 0.82976675033569336 -0.26567628979682922 0.49081888794898987 0
		 0.20645104348659515 0.96316158771514893 0.1723303347826004 0 -0.51852196455001831 -0.041663914918899536 0.85404860973358154 0
		 -20.663156509399414 16.20556640625 -29.212223052978516 1;
	setAttr ".SpineGX" -type "matrix" 0.96267598867416382 0.27015161514282227 -0.016540765762329102 0
		 -0.27036726474761963 0.9570167064666748 -0.10498107969760895 0 -0.012531020678579807 0.10553481429815292 0.99433684349060059 0
		 3.616696834564209 54.961765289306641 -24.088842391967773 1;
	setAttr ".LeftArmGX" -type "matrix" 0.53387969732284546 -0.56969135999679565 0.62483948469161987 0
		 0.75937730073928833 0.64806342124938965 -0.057966843247413635 0 -0.37191236019134521 0.5054362416267395 0.77859854698181152 0
		 22.257574081420898 92.58502197265625 -38.02313232421875 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.21033807098865509 0.13100919127464294 0.96881091594696045 0
		 0.78925430774688721 0.60755383968353271 0.089197099208831787 0 -0.5769190788269043 0.78339964151382446 -0.2311912477016449 0
		 34.8778076171875 79.118240356445313 -23.252708435058594 1;
	setAttr ".LeftHandGX" -type "matrix" 0.25971925258636475 0.070883303880691528 0.96307921409606934 0
		 0.90363717079162598 0.33387875556945801 -0.26826286315917969 0 -0.34056699275970459 0.93994706869125366 0.022661967203021049 0
		 30.177217483520508 82.046005249023438 -1.6019420623779297 1;
	setAttr ".RightArmGX" -type "matrix" 0.27031615376472473 0.88366317749023438 0.38218921422958374 0
		 -0.75243920087814331 0.44155564904212952 -0.48873689770698547 0 -0.60063660144805908 -0.15546070039272308 0.78426247835159302 0
		 -22.873714447021484 92.535202026367188 -40.007472991943359 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.51895856857299805 0.8175690770149231 -0.24952483177185059 0
		 -0.79373413324356079 0.35254642367362976 -0.4956783652305603 0 -0.31728225946426392 0.4552929699420929 0.8318895697593689 0
		 -29.088834762573242 71.381072998046875 -48.531948089599609 1;
	setAttr ".RightHandGX" -type "matrix" -0.51435756683349609 0.84800279140472412 -0.12778013944625854 0
		 0.44181907176971436 0.13433146476745605 -0.88698995113372803 0 -0.7350049614906311 -0.51268571615219116 -0.44375792145729065 0
		 -40.933578491210937 53.260429382324219 -42.985153198242188 1;
	setAttr ".HeadGX" -type "matrix" 0.99820709228515625 0.016160633414983749 0.057631481438875198 0
		 -0.016508616507053375 0.99984818696975708 0.0055670305155217648 0 -0.057532768696546555 -0.0065084653906524181 0.99832236766815186 0
		 -0.16105359792709351 109.62644958496094 -42.9498291015625 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324464321136475 2.3695096729170473e-007 -0.48728254437446594 0
		 -1.956859989604709e-007 1.0000002384185791 1.3558717171235912e-007 0 0.48728254437446594 -2.3046382580105274e-008 0.87324464321136475 0
		 22.9093017578125 10.540621757507324 -18.408395767211914 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841299057006836 1.4715755014549359e-007 0.52933531999588013 0
		 -3.1125298960432701e-007 1.0000002384185791 2.2086840090196347e-007 0 -0.52933531999588013 -3.5214475246903021e-007 0.84841299057006836 0
		 -20.882583618164062 9.6408357620239258 -31.244985580444336 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.95104449987411499 -0.17271865904331207 0.25628578662872314 0
		 0.29953229427337646 0.71938163042068481 -0.62671393156051636 0 -0.07612212747335434 0.67279881238937378 0.73589885234832764 0
		 13.077133178710938 96.550613403320313 -37.676994323730469 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.93276643753051758 0.35455960035324097 -0.065072327852249146 0
		 -0.30336484313011169 0.67456924915313721 -0.67299783229827881 0 -0.19472208619117737 0.64749044179916382 0.73677647113800049 0
		 -14.844260215759277 98.109954833984375 -37.869129180908203 1;
	setAttr ".NeckGX" -type "matrix" 0.99842017889022827 -0.055767972022294998 0.0068790698423981667 0
		 0.056017551571130753 0.97825592756271362 -0.19969382882118225 0 0.0044070286676287651 0.19976368546485901 0.97983431816101074 0
		 -0.56314665079116821 102.09504699707031 -45.647079467773438 1;
	setAttr ".Spine1GX" -type "matrix" 0.98623800277709961 0.16214941442012787 -0.032292317599058151 0
		 -0.16407220065593719 0.93578189611434937 -0.31207883358001709 0 -0.020384833216667175 0.31308215856552124 0.94950759410858154 0
		 1.6885057687759399 61.867286682128906 -23.525684356689453 1;
	setAttr ".Spine2GX" -type "matrix" 0.99837976694107056 0.051438137888908386 -0.024337040260434151 0
		 -0.056679364293813705 0.86084431409835815 -0.50570237636566162 0 -0.0050619887188076973 0.50626230239868164 0.86236488819122314 0
		 -0.80894124507904053 75.81671142578125 -29.755870819091797 1;
	setAttr ".Spine3GX" -type "matrix" 0.99842017889022827 -0.055768672376871109 0.0068788034841418266 0
		 0.045784030109643936 0.73641008138656616 -0.6749846339225769 0 0.032577373087406158 0.67423313856124878 0.73779988288879395 0
		 -1.5275429487228394 85.740859985351562 -38.259674072265625 1;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "13771F23-4E03-0820-3C1C-A0A95BFD585D";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.94700253009796143 0.32122635841369629 2.552283117738006e-016 0
		 -0.32122635841369629 0.94700253009796143 1.8293749079699429e-016 0 -1.8293749079699429e-016 -2.552283117738006e-016 1.0000001192092896 0
		 4.7032566070556641 51.758499145507812 -20.305294036865234 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.99924123287200928 -0.022659184411168098 -0.031685046851634979 0
		 0.026394473388791084 0.99206435680389404 0.12293105572462082 0 0.028648082166910172 -0.12367404997348785 0.9919094443321228 0
		 30.763454437255859 52.434944152832031 -17.108266830444336 1;
	setAttr ".LeftLegGX" -type "matrix" 0.99409908056259155 0.050936508923768997 -0.095775328576564789 0
		 -0.088994480669498444 0.88779163360595703 -0.45156008005142212 0 0.062027622014284134 0.45741885900497437 0.88708573579788208 0
		 28.75535774230957 31.687206268310547 -13.102032661437988 1;
	setAttr ".LeftFootGX" -type "matrix" 0.85706526041030884 -0.18317480385303497 -0.48154515027999878 0
		 0.1451030969619751 0.98264813423156738 -0.1155313178896904 0 0.49435195326805115 0.02914419025182724 0.86877298355102539 0
		 25.034614562988281 17.078479766845703 -18.284549713134766 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.91998326778411865 -0.38152283430099487 -0.089839503169059753 0
		 0.39047342538833618 0.91202819347381592 0.12543971836566925 0 0.034078042954206467 -0.15048237144947052 0.98802518844604492 0
		 -16.390342712402344 36.440250396728516 -17.108268737792969 1;
	setAttr ".RightLegGX" -type "matrix" 0.98286664485931396 -0.12770920991897583 -0.13290587067604065 0
		 0.18389689922332764 0.72822660207748413 0.66020321846008301 0 0.012471534311771393 -0.6733325719833374 0.7392348051071167 0
		 -22.504776000976563 16.458660125732422 -13.379880905151367 1;
	setAttr ".RightFootGX" -type "matrix" 0.82976675033569336 -0.26567628979682922 0.49081888794898987 0
		 0.20645104348659515 0.96316158771514893 0.1723303347826004 0 -0.51852196455001831 -0.041663914918899536 0.85404860973358154 0
		 -20.663156509399414 16.20556640625 -29.212223052978516 1;
	setAttr ".SpineGX" -type "matrix" 0.96267598867416382 0.27015161514282227 -0.016540765762329102 0
		 -0.27036726474761963 0.9570167064666748 -0.10498107969760895 0 -0.012531020678579807 0.10553481429815292 0.99433684349060059 0
		 3.616696834564209 54.961765289306641 -24.088842391967773 1;
	setAttr ".LeftArmGX" -type "matrix" 0.53387969732284546 -0.56969135999679565 0.62483948469161987 0
		 0.75937730073928833 0.64806342124938965 -0.057966843247413635 0 -0.37191236019134521 0.5054362416267395 0.77859854698181152 0
		 22.257574081420898 92.58502197265625 -38.02313232421875 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.21033807098865509 0.13100919127464294 0.96881091594696045 0
		 0.78925430774688721 0.60755383968353271 0.089197099208831787 0 -0.5769190788269043 0.78339964151382446 -0.2311912477016449 0
		 34.8778076171875 79.118240356445313 -23.252708435058594 1;
	setAttr ".LeftHandGX" -type "matrix" 0.25971925258636475 0.070883303880691528 0.96307921409606934 0
		 0.90363717079162598 0.33387875556945801 -0.26826286315917969 0 -0.34056699275970459 0.93994706869125366 0.022661967203021049 0
		 30.177217483520508 82.046005249023438 -1.6019420623779297 1;
	setAttr ".RightArmGX" -type "matrix" 0.27031615376472473 0.88366317749023438 0.38218921422958374 0
		 -0.75243920087814331 0.44155564904212952 -0.48873689770698547 0 -0.60063660144805908 -0.15546070039272308 0.78426247835159302 0
		 -22.873714447021484 92.535202026367188 -40.007472991943359 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.51895856857299805 0.8175690770149231 -0.24952483177185059 0
		 -0.79373413324356079 0.35254642367362976 -0.4956783652305603 0 -0.31728225946426392 0.4552929699420929 0.8318895697593689 0
		 -29.088834762573242 71.381072998046875 -48.531948089599609 1;
	setAttr ".RightHandGX" -type "matrix" -0.51435756683349609 0.84800279140472412 -0.12778013944625854 0
		 0.44181907176971436 0.13433146476745605 -0.88698995113372803 0 -0.7350049614906311 -0.51268571615219116 -0.44375792145729065 0
		 -40.933578491210937 53.260429382324219 -42.985153198242188 1;
	setAttr ".HeadGX" -type "matrix" 0.99820709228515625 0.016160633414983749 0.057631481438875198 0
		 -0.016508616507053375 0.99984818696975708 0.0055670305155217648 0 -0.057532768696546555 -0.0065084653906524181 0.99832236766815186 0
		 -0.16105359792709351 109.62644958496094 -42.9498291015625 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.87324464321136475 2.3695096729170473e-007 -0.48728254437446594 0
		 -1.956859989604709e-007 1.0000002384185791 1.3558717171235912e-007 0 0.48728254437446594 -2.3046382580105274e-008 0.87324464321136475 0
		 22.9093017578125 10.540621757507324 -18.408395767211914 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.84841299057006836 1.4715755014549359e-007 0.52933531999588013 0
		 -3.1125298960432701e-007 1.0000002384185791 2.2086840090196347e-007 0 -0.52933531999588013 -3.5214475246903021e-007 0.84841299057006836 0
		 -20.882583618164062 9.6408357620239258 -31.244985580444336 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.95104449987411499 -0.17271865904331207 0.25628578662872314 0
		 0.29953229427337646 0.71938163042068481 -0.62671393156051636 0 -0.07612212747335434 0.67279881238937378 0.73589885234832764 0
		 13.077133178710938 96.550613403320313 -37.676994323730469 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.93276643753051758 0.35455960035324097 -0.065072327852249146 0
		 -0.30336484313011169 0.67456924915313721 -0.67299783229827881 0 -0.19472208619117737 0.64749044179916382 0.73677647113800049 0
		 -14.844260215759277 98.109954833984375 -37.869129180908203 1;
	setAttr ".NeckGX" -type "matrix" 0.99842017889022827 -0.055767972022294998 0.0068790698423981667 0
		 0.056017551571130753 0.97825592756271362 -0.19969382882118225 0 0.0044070286676287651 0.19976368546485901 0.97983431816101074 0
		 -0.56314665079116821 102.09504699707031 -45.647079467773438 1;
	setAttr ".Spine1GX" -type "matrix" 0.98623800277709961 0.16214941442012787 -0.032292317599058151 0
		 -0.16407220065593719 0.93578189611434937 -0.31207883358001709 0 -0.020384833216667175 0.31308215856552124 0.94950759410858154 0
		 1.6885057687759399 61.867286682128906 -23.525684356689453 1;
	setAttr ".Spine2GX" -type "matrix" 0.99837976694107056 0.051438137888908386 -0.024337040260434151 0
		 -0.056679364293813705 0.86084431409835815 -0.50570237636566162 0 -0.0050619887188076973 0.50626230239868164 0.86236488819122314 0
		 -0.80894124507904053 75.81671142578125 -29.755870819091797 1;
	setAttr ".Spine3GX" -type "matrix" 0.99842017889022827 -0.055768672376871109 0.0068788034841418266 0
		 0.045784030109643936 0.73641008138656616 -0.6749846339225769 0 0.032577373087406158 0.67423313856124878 0.73779988288879395 0
		 -1.5275429487228394 85.740859985351562 -38.259674072265625 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "04917FC2-4B08-BDA0-94D9-6D965B68142E";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "D639EE7A-418F-2272-98C2-53BB18465A2A";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "B1EAF810-46BC-9FD3-DF86-9A9D18941A3E";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700253009796143 0.32122635841369629 2.552283117738006e-016 0
		 -0.32122635841369629 0.94700253009796143 1.8293749079699429e-016 0 -1.8293749079699429e-016 -2.552283117738006e-016 1.0000001192092896 0
		 7.1865558624267578 44.437599182128906 -17.108268737792969 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.85706532001495361 -0.18317481875419617 -0.48154518008232117 0
		 0.1451030969619751 0.98264813423156738 -0.1155313178896904 0 0.49435195326805115 0.02914419025182724 0.86877298355102539 0
		 25.034614562988281 17.078479766845703 -18.284549713134766 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.82976675033569336 -0.26567628979682922 0.49081888794898987 0
		 0.20645104348659515 0.96316158771514893 0.1723303347826004 0 -0.51852196455001831 -0.041663914918899536 0.85404860973358154 0
		 -20.663156509399414 16.20556640625 -29.212223052978516 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.25971925258636475 0.070883303880691528 0.96307921409606934 0
		 0.90363717079162598 0.33387875556945801 -0.26826286315917969 0 -0.34056702256202698 0.93994712829589844 0.022661969065666199 0
		 30.177217483520508 82.046005249023438 -1.6019420623779297 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.51435756683349609 0.84800279140472412 -0.12778013944625854 0
		 0.44181907176971436 0.13433146476745605 -0.88698995113372803 0 -0.73500502109527588 -0.51268577575683594 -0.44375795125961304 0
		 -40.933578491210937 53.260429382324219 -42.985153198242188 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99409914016723633 0.050936512649059296 -0.095775336027145386 0
		 -0.088994480669498444 0.88779163360595703 -0.45156008005142212 0 0.062027622014284134 0.45741885900497437 0.88708573579788208 0
		 28.75535774230957 31.687206268310547 -13.102032661437988 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98286664485931396 -0.12770920991897583 -0.13290587067604065 0
		 0.18389689922332764 0.72822660207748413 0.66020321846008301 0 0.012471534311771393 -0.6733325719833374 0.7392348051071167 0
		 -22.504776000976563 16.458660125732422 -13.379880905151367 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.21033807098865509 0.13100919127464294 0.96881091594696045 0
		 0.78925430774688721 0.60755383968353271 0.089197099208831787 0 -0.5769190788269043 0.78339964151382446 -0.2311912477016449 0
		 34.8778076171875 79.118240356445313 -23.252708435058594 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.51895862817764282 0.81756913661956787 -0.24952484667301178 0
		 -0.79373419284820557 0.35254645347595215 -0.49567839503288269 0 -0.31728225946426392 0.4552929699420929 0.8318895697593689 0
		 -29.088834762573242 71.381072998046875 -48.531948089599609 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.96267598867416382 0.27015161514282227 -0.016540765762329102 0
		 -0.27036726474761963 0.9570167064666748 -0.10498107969760895 0 -0.012531021609902382 0.10553482174873352 0.99433690309524536 0
		 3.616696834564209 54.961765289306641 -24.088842391967773 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99842017889022827 -0.055768672376871109 0.0068788034841418266 0
		 0.045784030109643936 0.73641008138656616 -0.6749846339225769 0 0.032577373087406158 0.67423313856124878 0.73779988288879395 0
		 -0.88356351852416992 97.330284118652344 -37.773063659667969 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324464321136475 2.3695096729170473e-007 -0.48728254437446594 0
		 -1.956859989604709e-007 1.0000002384185791 1.3558717171235912e-007 0 0.48728254437446594 -2.3046382580105274e-008 0.87324464321136475 0
		 22.9093017578125 10.540621757507324 -18.408395767211914 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841299057006836 1.4715755014549359e-007 0.52933531999588013 0
		 -3.1125298960432701e-007 1.0000002384185791 2.2086840090196347e-007 0 -0.52933531999588013 -3.5214475246903021e-007 0.84841299057006836 0
		 -20.882583618164062 9.6408357620239258 -31.244985580444336 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.53387969732284546 -0.56969135999679565 0.62483948469161987 0
		 0.75937730073928833 0.64806342124938965 -0.057966843247413635 0 -0.37191236019134521 0.5054362416267395 0.77859854698181152 0
		 22.257574081420898 92.58502197265625 -38.02313232421875 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.27031615376472473 0.88366317749023438 0.38218921422958374 0
		 -0.75243926048278809 0.4415556788444519 -0.48873692750930786 0 -0.60063660144805908 -0.15546070039272308 0.78426247835159302 0
		 -22.873714447021484 92.535202026367188 -40.007472991943359 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.99820709228515625 0.016160633414983749 0.057631481438875198 0
		 -0.016508616507053375 0.99984818696975708 0.0055670305155217648 0 -0.057532768696546555 -0.0065084653906524181 0.99832236766815186 0
		 -0.16105359792709351 109.62644958496094 -42.9498291015625 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99924123287200928 -0.022659184411168098 -0.031685046851634979 0
		 0.026394473388791084 0.99206435680389404 0.12293105572462082 0 0.028648084029555321 -0.12367405742406845 0.99190950393676758 0
		 30.763454437255859 52.434944152832031 -17.108266830444336 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.91998326778411865 -0.38152283430099487 -0.089839503169059753 0
		 0.39047342538833618 0.91202819347381592 0.12543971836566925 0 0.034078042954206467 -0.15048237144947052 0.98802518844604492 0
		 -16.390342712402344 36.440250396728516 -17.108268737792969 1;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "A7803FA0-48AF-5931-52E0-5DA0BCC32FB6";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.94700253009796143 0.32122635841369629 2.552283117738006e-016 0
		 -0.32122635841369629 0.94700253009796143 1.8293749079699429e-016 0 -1.8293749079699429e-016 -2.552283117738006e-016 1.0000001192092896 0
		 7.1865558624267578 44.437599182128906 -17.108268737792969 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.85706532001495361 -0.18317481875419617 -0.48154518008232117 0
		 0.1451030969619751 0.98264813423156738 -0.1155313178896904 0 0.49435195326805115 0.02914419025182724 0.86877298355102539 0
		 25.034614562988281 17.078479766845703 -18.284549713134766 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.82976675033569336 -0.26567628979682922 0.49081888794898987 0
		 0.20645104348659515 0.96316158771514893 0.1723303347826004 0 -0.51852196455001831 -0.041663914918899536 0.85404860973358154 0
		 -20.663156509399414 16.20556640625 -29.212223052978516 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.25971925258636475 0.070883303880691528 0.96307921409606934 0
		 0.90363717079162598 0.33387875556945801 -0.26826286315917969 0 -0.34056702256202698 0.93994712829589844 0.022661969065666199 0
		 30.177217483520508 82.046005249023438 -1.6019420623779297 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" -0.51435756683349609 0.84800279140472412 -0.12778013944625854 0
		 0.44181907176971436 0.13433146476745605 -0.88698995113372803 0 -0.73500502109527588 -0.51268577575683594 -0.44375795125961304 0
		 -40.933578491210937 53.260429382324219 -42.985153198242188 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.99409914016723633 0.050936512649059296 -0.095775336027145386 0
		 -0.088994480669498444 0.88779163360595703 -0.45156008005142212 0 0.062027622014284134 0.45741885900497437 0.88708573579788208 0
		 28.75535774230957 31.687206268310547 -13.102032661437988 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98286664485931396 -0.12770920991897583 -0.13290587067604065 0
		 0.18389689922332764 0.72822660207748413 0.66020321846008301 0 0.012471534311771393 -0.6733325719833374 0.7392348051071167 0
		 -22.504776000976563 16.458660125732422 -13.379880905151367 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.21033807098865509 0.13100919127464294 0.96881091594696045 0
		 0.78925430774688721 0.60755383968353271 0.089197099208831787 0 -0.5769190788269043 0.78339964151382446 -0.2311912477016449 0
		 34.8778076171875 79.118240356445313 -23.252708435058594 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.51895862817764282 0.81756913661956787 -0.24952484667301178 0
		 -0.79373419284820557 0.35254645347595215 -0.49567839503288269 0 -0.31728225946426392 0.4552929699420929 0.8318895697593689 0
		 -29.088834762573242 71.381072998046875 -48.531948089599609 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.96267598867416382 0.27015161514282227 -0.016540765762329102 0
		 -0.27036726474761963 0.9570167064666748 -0.10498107969760895 0 -0.012531021609902382 0.10553482174873352 0.99433690309524536 0
		 3.616696834564209 54.961765289306641 -24.088842391967773 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.99842017889022827 -0.055768672376871109 0.0068788034841418266 0
		 0.045784030109643936 0.73641008138656616 -0.6749846339225769 0 0.032577373087406158 0.67423313856124878 0.73779988288879395 0
		 -0.88356351852416992 97.330284118652344 -37.773063659667969 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.87324464321136475 2.3695096729170473e-007 -0.48728254437446594 0
		 -1.956859989604709e-007 1.0000002384185791 1.3558717171235912e-007 0 0.48728254437446594 -2.3046382580105274e-008 0.87324464321136475 0
		 22.9093017578125 10.540621757507324 -18.408395767211914 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.84841299057006836 1.4715755014549359e-007 0.52933531999588013 0
		 -3.1125298960432701e-007 1.0000002384185791 2.2086840090196347e-007 0 -0.52933531999588013 -3.5214475246903021e-007 0.84841299057006836 0
		 -20.882583618164062 9.6408357620239258 -31.244985580444336 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.53387969732284546 -0.56969135999679565 0.62483948469161987 0
		 0.75937730073928833 0.64806342124938965 -0.057966843247413635 0 -0.37191236019134521 0.5054362416267395 0.77859854698181152 0
		 22.257574081420898 92.58502197265625 -38.02313232421875 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.27031615376472473 0.88366317749023438 0.38218921422958374 0
		 -0.75243926048278809 0.4415556788444519 -0.48873692750930786 0 -0.60063660144805908 -0.15546070039272308 0.78426247835159302 0
		 -22.873714447021484 92.535202026367188 -40.007472991943359 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.99820709228515625 0.016160633414983749 0.057631481438875198 0
		 -0.016508616507053375 0.99984818696975708 0.0055670305155217648 0 -0.057532768696546555 -0.0065084653906524181 0.99832236766815186 0
		 -0.16105359792709351 109.62644958496094 -42.9498291015625 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.99924123287200928 -0.022659184411168098 -0.031685046851634979 0
		 0.026394473388791084 0.99206435680389404 0.12293105572462082 0 0.028648084029555321 -0.12367405742406845 0.99190950393676758 0
		 30.763454437255859 52.434944152832031 -17.108266830444336 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.91998326778411865 -0.38152283430099487 -0.089839503169059753 0
		 0.39047342538833618 0.91202819347381592 0.12543971836566925 0 0.034078042954206467 -0.15048237144947052 0.98802518844604492 0
		 -16.390342712402344 36.440250396728516 -17.108268737792969 1;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "32234860-4B6C-A3DA-9EC2-C4A8C563F787";
	setAttr ".ihi" 0;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "6D8E64AA-4AF9-C168-B7B1-8AA6DCB0E0CE";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 4.4408920985006262e-016 1.110223024625156e-016 1 0
		 0.94700241615378666 0.32122643695513309 -2.7755575615628904e-016 0 -0.32122643695513303 0.94700241615378666 0 0
		 7.9291358081148218 56.084833144491164 -17.363649222729602 1;
	setAttr ".LeftUpLegGX" -type "matrix" -0.18769338797663776 -0.85357223821553541 0.48598962651466449 0
		 0.96980421055024857 -0.23949148252679414 -0.046086256989462407 0 0.15572831698985934 0.46266467455752536 0.87274886969682519 0
		 29.447518920182507 48.141885858686756 -13.407345837676068 1;
	setAttr ".LeftLegGX" -type "matrix" -0.13186215392320555 -0.35593436488565228 -0.92516134187249677 0
		 0.96980418983800942 -0.23949147741194229 -0.046086256005192006 0 -0.20516454453931149 -0.90330224173493368 0.37676641643945402 0
		 24.82803722642398 27.133893135853345 -1.4462415747999096 1;
	setAttr ".LeftFootGX" -type "matrix" 0.10028131022676787 -0.94902935197809046 0.29880971449227101 0
		 0.87724393991616079 -0.057367054446231192 -0.47660500383074034 0 0.46945387012332213 0.30992357450298019 0.82677729130239641 0
		 22.648275485175635 21.250081303989717 -16.739722585819482 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.10244272641805863 0.97773966268530399 -0.18311452874731515 0
		 0.99432867168704742 -0.10593773146109936 -0.009380914517843935 0 -0.028570822057251088 -0.18111496951995096 -0.98304685785826984 0
		 -13.589247303952899 48.141885858686749 -13.407345837676072 1;
	setAttr ".RightLegGX" -type "matrix" 0.033182935507571718 0.22522820550748102 0.97374078145881704 0
		 0.99432865045103636 -0.10593772919857299 -0.0093809143174944827 0 0.10104304759342124 0.96852970827758289 -0.22746618645452849 0
		 -16.11055241996387 24.077902988930102 -8.9005583449023469 1;
	setAttr ".RightFootGX" -type "matrix" 0.43865984158319377 0.89843933384025931 -0.019610653183532251 0
		 0.8066036883218326 -0.38401307386959227 0.44936027194893968 0 0.39619222979332713 -0.21293428790353192 -0.8931353779211193 0
		 -16.659086684718869 20.354742714800683 -24.997090645038906 1;
	setAttr ".SpineGX" -type "matrix" -0.064348904476481616 0.99247226728313676 -0.10420183065337514 0
		 0.99791697014253067 0.064475270342122831 -0.0021587533118307039 0 0.0045759384076227289 -0.10412368853957245 -0.99455383093001648 0
		 7.9291358081148235 69.726811446680344 -19.523013289275106 1;
	setAttr ".LeftArmGX" -type "matrix" 0.50200971244007586 -0.64735907734152653 0.57350939333202278 0
		 -0.74335560158310798 -0.66190550738821852 -0.096456726501400913 0 0.44205111712406087 -0.3778991296214842 -0.8135005714947281 0
		 29.980500478998479 107.55142426452362 -20.04543608804439 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.17171485310561888 0.049464657989301997 0.98390424810477894 0
		 -0.74335555779715257 -0.6619055104707009 -0.096456768307929069 0 0.64648044942960925 -0.74795368738715062 0.15042890570967127 0
		 47.723205654407352 84.671585404992328 0.22430852283257963 1;
	setAttr ".LeftHandGX" -type "matrix" 0.11903478125542268 0.12038979437704966 0.98556454369801327 0
		 -0.89893122211394028 -0.40842722937620113 0.15846202370109153 0 0.42160864467617082 -0.90481707798053423 0.059605194595003713 0
		 43.157632185624621 85.986757661861176 26.38447411907093 1;
	setAttr ".RightArmGX" -type "matrix" 0.26831813437642044 0.83191720208483777 0.48571564483860769 0
		 -0.80853693035968699 0.46859123838203753 -0.35593658423829583 0 -0.52371181562705138 -0.29721474817196841 0.79836690502292451 0
		 -15.437067113103582 105.24010053397129 -24.263037609267069 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.56232385097998505 0.79349339361097448 -0.23272508238240297 0
		 -0.8085369409532871 0.46859134981929701 -0.35593667049986716 0 -0.17338038256332217 0.38831840723610667 0.90506826442954669 0
		 -24.920328385044982 75.837360601443578 -41.429860258726947 1;
	setAttr ".RightHandGX" -type "matrix" -0.35173597472178081 0.92559420329357323 -0.13985019105826896 0
		 0.41022531808837204 0.018123421858457611 -0.91180445622634698 0 -0.84142618744573672 -0.37808445984544781 -0.38607659279687545 0
		 -39.871457598880419 54.73986778788062 -35.242135685060212 1;
	setAttr ".HeadGX" -type "matrix" -0.057531907233208987 -0.0065052365295343861 0.99832253152380512 0
		 0.99820743693659808 0.016158836967836224 0.057630549544420373 0 -0.016506635823936466 0.99984848161275164 0.0055639199657256944 0
		 8.2287501318826344 133.03648518261483 -14.673020298514563 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.48728228855299155 7.2550873642107661e-009 0.87324464103361943 0
		 0.8732446270872497 3.8354123865595724e-009 -0.48728232214071188 0 6.8845278089479933e-009 1.0000001559422351 4.4665383613917697e-009 0
		 24.423219533113688 4.4526006776580758 -11.450896642796369 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.529335751850318 1.8904659337959373e-008 -0.84841251877210855 0
		 0.84841258323638913 -3.4771415663437111e-008 0.52933565250167658 0 -3.2771002994591569e-009 -1.0000001442295317 2.1344585182658804e-008 0
		 -24.423219533113627 4.4526006776580793 -24.650025271457093 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.94691342546560919 -0.21672510134248166 0.23745663007414314 0
		 0.22831511133944737 -0.066663362356284867 -0.97130236470177178 0 0.22633525149433553 0.97395409815317269 -0.013642815848755131 0
		 9.4272453973088215 112.25555695753063 -25.199557431310396 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.90695373791213663 0.41870637813125949 -0.046047207728512576 0
		 0.020664566158492895 0.064957962675259634 0.99767404406739013 0 0.42072361574331379 -0.90579567066447486 0.050261467104940921 0
		 4.2488418230143434 114.32834339162041 -25.262515866553944 1;
	setAttr ".NeckGX" -type "matrix" 0.055887300392626162 0.88207912988093673 0.4677749046562148 0
		 0.99773309447302161 -0.066932799191697784 0.0070106702936638529 0 0.037493444490472753 0.46632265795116284 -0.883819893117472 0
		 7.2900875770944467 118.22140826437744 -22.529596999174075 1;
	setAttr ".Spine1GX" -type "matrix" 0.067031611398645413 0.99763886048481321 -0.014962352320594147 0
		 0.99773309447302161 -0.066932799191697784 0.0070106702936638529 0 0.0059926426477481436 -0.015398364646371718 -0.99986353357385083 0
		 6.0155795996521668 99.252765643529983 -22.245109771195494 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "3403C29F-4DD2-F099-D100-1E8FAF14066F";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAX";
	rename -uid "B3B3ADDC-4CD9-C2B1-69CE-0BB62166404A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0
		 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0
		 27 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0
		 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0
		 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 77 0
		 78 0 79 0 80 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAY";
	rename -uid "D9CAD984-46CF-3EE6-A5F9-D88AA492DB70";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.737105494509741 1 18.737105494509741
		 2 18.737105494509741 3 18.737105494509741 4 18.737105494509741 5 18.737105494509741
		 6 18.737105494509741 7 18.737105494509741 8 18.737105494509741 9 18.737105494509741
		 10 18.737105494509741 11 18.737105494509741 12 18.737105494509741 13 18.737105494509741
		 14 18.737105494509741 15 18.737105494509741 16 18.737105494509741 17 18.737105494509741
		 18 18.737105494509741 19 18.737105494509741 20 18.737105494509741 21 18.737105494509741
		 22 18.737105494509741 23 18.737105494509741 24 18.737105494509741 25 18.737105494509741
		 26 18.737105494509741 27 18.737105494509741 28 18.737105494509741 29 18.737105494509741
		 30 18.737105494509741 31 18.737105494509741 32 18.737105494509741 33 18.737105494509741
		 34 18.737105494509741 35 18.737105494509741 36 18.737105494509741 37 18.737105494509741
		 38 18.737105494509741 39 18.737105494509741 40 18.737105494509741 41 18.737105494509741
		 42 18.737105494509741 43 18.737105494509741 44 18.737105494509741 45 18.737105494509741
		 46 18.737105494509741 47 18.737105494509741 48 18.737105494509741 49 18.737105494509741
		 50 18.737105494509741 51 18.737105494509741 52 18.737105494509741 53 18.737105494509741
		 54 18.737105494509741 55 18.737105494509741 56 18.737105494509741 57 18.737105494509741
		 58 18.737105494509741 59 18.737105494509741 60 18.737105494509741 61 18.737105494509741
		 62 18.737105494509741 63 18.737105494509741 64 18.737105494509741 65 18.737105494509741
		 66 18.737105494509741 67 18.737105494509741 68 18.737105494509741 69 18.737105494509741
		 70 18.737105494509741 71 18.737105494509741 72 18.737105494509741 73 18.737105494509741
		 74 18.737105494509741 75 18.737105494509741 76 18.737105494509741 77 18.737105494509741
		 78 18.737105494509741 79 18.737105494509741 80 18.737105494509741;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ";
	rename -uid "B75908B2-4AB7-5E01-5615-52A27F288982";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0
		 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0
		 27 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0
		 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0
		 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 77 0
		 78 0 79 0 80 0;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX_tempLayer_inputA";
	rename -uid "EE5C34DC-4008-DD9A-81B6-11809DDA789C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.5844721794128418 1 3.6392514705657959
		 2 3.695793628692627 3 3.7538065910339355 4 3.8129839897155762 5 3.8730306625366211
		 6 3.9336428642272949 7 3.9945254325866699 8 4.0553736686706543 9 4.1158914566040039
		 10 4.1756429672241211 11 4.2342338562011719 12 4.2915821075439453 13 4.3473992347717285
		 14 4.4013853073120117 15 4.4532346725463867 16 4.5026583671569824 17 4.5493535995483398
		 18 4.5930156707763672 19 4.6333589553833008 20 4.670072078704834 21 4.7028603553771973
		 22 4.7314319610595703 23 4.7554798126220703 24 4.774712085723877 25 4.788820743560791
		 26 4.7975168228149414 27 4.8004922866821289 28 4.7975521087646484 29 4.788907527923584
		 30 4.7748541831970215 31 4.7556896209716797 32 4.7317218780517578 33 4.7032527923583984
		 34 4.6705770492553711 35 4.6339998245239258 36 4.5938186645507812 37 4.5503382682800293
		 38 4.5038576126098633 39 4.4546771049499512 40 4.4031038284301758 41 4.3494296073913574
		 42 4.2939634323120117 43 4.2368783950805664 44 4.1783537864685059 45 4.1189446449279785
		 46 4.0589561462402344 47 3.9986844062805176 48 3.9384369850158691 49 3.8785138130187988
		 50 3.8192222118377686 51 3.7608556747436523 52 3.7037253379821777 53 3.6481280326843262
		 54 3.5943706035614014 55 3.5427463054656982 56 3.4935643672943115 57 3.4471206665039062
		 58 3.4037232398986816 59 3.3636679649353027 60 3.3272576332092285 61 3.2947967052459717
		 62 3.2665829658508301 63 3.2429180145263672 64 3.2241053581237793 65 3.2104458808898926
		 66 3.2022409439086914 67 3.1997935771942139 68 3.2034029960632324 69 3.2133746147155762
		 70 3.2285189628601074 71 3.2474379539489746 72 3.2701106071472168 73 3.2965207099914551
		 74 3.3266491889953613 75 3.3604753017425537 76 3.3979842662811279 77 3.4391553401947021
		 78 3.4839720726013184 79 3.532418966293335 80 3.5844721794128418;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY_tempLayer_inputA";
	rename -uid "259C3AF2-4347-3DF8-5A55-9A96708652AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 51.742416381835938 1 51.744426727294922
		 2 51.746505737304688 3 51.748641967773438 4 51.750823974609375 5 51.753044128417969
		 6 51.755287170410156 7 51.757545471191406 8 51.759811401367188 9 51.762062072753906
		 10 51.763381958007813 11 51.762966156005859 12 51.762561798095703 13 51.762161254882813
		 14 51.761775970458984 15 51.761398315429688 16 51.761032104492188 17 51.760692596435547
		 18 51.760364532470703 19 51.760047912597656 20 51.759757995605469 21 51.759483337402344
		 22 51.759231567382813 23 51.759006500244141 24 51.758800506591797 25 51.758636474609375
		 26 51.758491516113281 27 51.758388519287109 28 51.758316040039062 29 51.758285522460938
		 30 51.758293151855469 31 51.758327484130859 32 51.758403778076172 33 51.758499145507812
		 34 51.758632659912109 35 51.7587890625 36 51.758975982666016 37 51.759193420410156
		 38 51.759429931640625 39 51.759689331054688 40 51.759971618652344 41 51.760276794433594
		 42 51.760601043701172 43 51.760025024414062 44 51.757659912109375 45 51.755287170410156
		 46 51.752925872802734 47 51.750579833984375 48 51.748275756835938 49 51.746009826660156
		 50 51.743801116943359 51 51.741661071777344 52 51.739601135253906 53 51.737632751464844
		 54 51.735759735107422 55 51.733997344970703 56 51.732357025146484 57 51.730842590332031
		 58 51.729469299316406 59 51.728240966796875 60 51.7271728515625 61 51.726284027099609
		 62 51.725593566894531 63 51.72509765625 64 51.724807739257813 65 51.724716186523438
		 66 51.724822998046875 67 51.725139617919922 68 51.725662231445313 69 51.726394653320313
		 70 51.727294921875 71 51.728324890136719 72 51.729476928710938 73 51.730743408203125
		 74 51.73211669921875 75 51.733600616455078 76 51.735179901123047 77 51.736858367919922
		 78 51.738624572753906 79 51.740482330322266 80 51.742416381835938;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ_tempLayer_inputA";
	rename -uid "1FE5B7FA-4602-AB0B-D150-E499807AD55E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -20.342348098754883 1 -20.335205078125
		 2 -20.328022003173828 3 -20.320837020874023 4 -20.313694000244141 5 -20.306631088256836
		 6 -20.299694061279297 7 -20.292919158935547 8 -20.286354064941406 9 -20.280036926269531
		 10 -20.274402618408203 11 -20.269832611083984 12 -20.265617370605469 13 -20.26179313659668
		 14 -20.258390426635742 15 -20.255451202392578 16 -20.253009796142578 17 -20.251100540161133
		 18 -20.249763488769531 19 -20.249032974243164 20 -20.248941421508789 21 -20.249591827392578
		 22 -20.251018524169922 23 -20.253170013427734 24 -20.256011962890625 25 -20.259494781494141
		 26 -20.263574600219727 27 -20.268209457397461 28 -20.273355484008789 29 -20.278964996337891
		 30 -20.285007476806641 31 -20.291437149047852 32 -20.298213958740234 33 -20.305294036865234
		 34 -20.312646865844727 35 -20.320220947265625 36 -20.327983856201172 37 -20.335886001586914
		 38 -20.343893051147461 39 -20.351966857910156 40 -20.360063552856445 41 -20.368143081665039
		 42 -20.376161575317383 43 -20.384475708007813 44 -20.393424987792969 45 -20.402200698852539
		 46 -20.410758972167969 47 -20.419055938720703 48 -20.427040100097656 49 -20.434669494628906
		 50 -20.441896438598633 51 -20.448677062988281 52 -20.454963684082031 53 -20.460714340209961
		 54 -20.46588134765625 55 -20.470418930053711 56 -20.474287033081055 57 -20.477434158325195
		 58 -20.479820251464844 59 -20.48139762878418 60 -20.482126235961914 61 -20.481712341308594
		 62 -20.479970932006836 63 -20.477006912231445 64 -20.472921371459961 65 -20.467823028564453
		 66 -20.461814880371094 67 -20.455001831054688 68 -20.447486877441406 69 -20.439376831054688
		 70 -20.430784225463867 71 -20.42182731628418 72 -20.41261100769043 73 -20.40324592590332
		 74 -20.393835067749023 75 -20.384485244750977 76 -20.375301361083984 77 -20.366388320922852
		 78 -20.357854843139648 79 -20.34980583190918 80 -20.342348098754883;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX";
	rename -uid "739277DF-45B0-6DFA-AEFF-9187B2AF5333";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.8783006942108935 1 -5.8981182663722516
		 2 -5.9184932714669891 3 -5.9394412144441171 4 -5.9605959380634159 5 -5.981997813298733
		 6 -6.0035333686760026 7 -6.0250562787118565 8 -6.0464745029364106 9 -6.0677064465246682
		 10 -6.0903889427545135 11 -6.1161386462019713 12 -6.1412909912240403 13 -6.1658312038222327
		 14 -6.1894986351296764 15 -6.2123293446482046 16 -6.2341083164586477 17 -6.2547779010862703
		 18 -6.2741257609185617 19 -6.292201416846293 20 -6.3087869838943105 21 -6.3238427808226074
		 22 -6.3372343465463494 23 -6.3488127161732848 24 -6.3584522627102738 25 -6.3660107788158546
		 26 -6.3714158792196924 27 -6.3743541853965882 28 -6.3748793059956324 29 -6.3729928479042037
		 30 -6.3688732038634983 31 -6.3625094367392494 32 -6.3540949592208067 33 -6.3437638299784744
		 34 -6.3315740949860624 35 -6.3176706537552132 36 -6.3021364544913485 37 -6.2850816437286969
		 38 -6.2665943131323827 39 -6.2467947917640778 40 -6.2258583677415666 41 -6.2037726080351483
		 42 -6.1807323808447938 43 -6.1587454292468014 44 -6.1395958396510721 45 -6.1198661773915495
		 46 -6.0996432273997732 47 -6.0790014917451449 48 -6.0580490817659323 49 -6.036928065422634
		 50 -6.0157414387634098 51 -5.99454920003976 52 -5.9735240207451277 53 -5.9527950491581398
		 54 -5.9323782017725 55 -5.9125346970024699 56 -5.8933578953526879 57 -5.8748952371605823
		 58 -5.8574371975506407 59 -5.8409669586482122 60 -5.8256137643998507 61 -5.811549108414912
		 62 -5.7986993997887808 63 -5.7873292169926085 64 -5.7775432980523673 65 -5.7696480506729229
		 66 -5.7637767740805836 67 -5.7599767877261492 68 -5.7585481136012797 69 -5.7596879463890751
		 70 -5.7628612932985988 71 -5.7674329887546048 72 -5.773517599120602 73 -5.7811460009518107
		 74 -5.7902353681672984 75 -5.8009548668417263 76 -5.8132418884086832 77 -5.827122831484191
		 78 -5.8424995140238485 79 -5.8595950289492489 80 -5.8783006942108935;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY";
	rename -uid "16C992BA-4CCC-8CF9-C026-B0B3CC1B4945";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.078697047608539 1 18.140766930372756
		 2 18.204929840882315 3 18.270774041352897 4 18.338197514413448 5 18.406727103084403
		 6 18.47603798997455 7 18.545816606470041 8 18.615719933203675 9 18.685336184166513
		 10 18.7529174196053 11 18.816571496202936 12 18.879068270355869 13 18.939936166683811
		 14 18.998974605627591 15 19.055776590409859 16 19.109995341103609 17 19.161270693434801
		 18 19.209353471894744 19 19.253788939329677 20 19.294309455392892 21 19.330492491383687
		 22 19.362090166742163 23 19.388682198152605 24 19.409962705203903 25 19.425605795620466
		 26 19.435186823663592 27 19.438490540312241 28 19.435205212451994 29 19.425649152409399
		 30 19.410005863382608 31 19.388783089003905 32 19.36226645996399 33 19.330769029045047
		 34 19.294613664960927 35 19.254226432582882 36 19.209942201877173 37 19.162069692930409
		 38 19.111002715598335 39 19.057060509093926 40 19.000559739672063 41 18.941909021573814
		 42 18.881449052218336 43 18.817826093733355 44 18.750014778391112 45 18.681329747801289
		 46 18.612144729795176 47 18.542891465250548 48 18.473766824411427 49 18.405171129955761
		 50 18.3374988639756 51 18.271076233212572 52 18.206183838199841 53 18.14322845296287
		 54 18.08254904512161 55 18.024371192113485 56 17.969045733857655 57 17.917019374094746
		 58 17.868419497906238 59 17.823662953385359 60 17.783186037898023 61 17.747089195411522
		 62 17.715875289994621 63 17.689798519903192 64 17.66919088654679 65 17.654374867340689
		 66 17.645553738753261 67 17.643289915773053 68 17.647734636975557 69 17.659223835213893
		 70 17.676461943083797 71 17.697966905331029 72 17.723629797330766 73 17.753505565589723
		 74 17.787577001952165 75 17.825758657305681 76 17.86806853164266 77 17.914521548003588
		 78 17.965197429018868 79 18.019889288044208 80 18.078697047608539;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "6D60256A-41A6-B587-C17F-ED9D02F91989";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.5969551528766512 1 5.6116017156047802
		 2 5.6269333047600725 3 5.6425522199313223 4 5.6591396708243913 5 5.6761679919519059
		 6 5.6935723432512768 7 5.7113586466461079 8 5.7294436005677811 9 5.7476284812655569
		 10 5.7609046456217792 11 5.7643496970472956 12 5.7680114401533977 13 5.7714853074077359
		 14 5.7752042961114149 15 5.7786319061400171 16 5.7819434748767806 17 5.784959822158676
		 18 5.7878753460990202 19 5.7901714240290003 20 5.7920873579440206 21 5.7932724509148148
		 22 5.7938362984502048 23 5.7936351226733862 24 5.7927872040011517 25 5.7911833700329218
		 26 5.7886220913735835 27 5.7855313614803237 28 5.7815663534336776 29 5.776972938738278
		 30 5.7715647781520918 31 5.7657424847247531 32 5.7594691033490868 33 5.75268224624896
		 34 5.7455740648993041 35 5.7382148621725531 36 5.7307290736274279 37 5.7231384938031802
		 38 5.7156579139366519 39 5.7083501345232843 40 5.7010476860292574 41 5.6942077065197099
		 42 5.6877215468677775 43 5.6762501482094372 44 5.6551609072744027 45 5.6344279031012769
		 46 5.6141726503840017 47 5.5947311660429726 48 5.5759742180665341 49 5.5579985176383939
		 50 5.5409609957905479 51 5.5250699789357203 52 5.5101226937431598 53 5.4963445005844287
		 54 5.4839552569793932 55 5.4726437288089604 56 5.4625822998693403 57 5.4539653096532614
		 58 5.4463830484072693 59 5.440264993650155 60 5.4357268251481701 61 5.4324905813462214
		 62 5.4312067730595679 63 5.4315445804361291 64 5.4335391033556446 65 5.4368849547776428
		 66 5.4414472885526068 67 5.4476657482084345 68 5.4550042603118181 69 5.4633715952055359
		 70 5.472609872322387 71 5.4828823162671947 72 5.4936619862166749 73 5.5050390810095848
		 74 5.5170991446626036 75 5.5294499369663441 76 5.5422332793486024 77 5.5553560642159514
		 78 5.5691625025029525 79 5.5829048215347354 80 5.5969551528766512;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX";
	rename -uid "AEE84719-4B61-656C-9228-4094E948CB29";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.9973669760919477 1 3.0063111442244814
		 2 3.0156234438266734 3 3.0252763564444094 4 3.0352373331397891 5 3.0454635790565754
		 6 3.0558493058396157 7 3.0664058586534386 8 3.0770611299536186 9 3.0877638656759014
		 10 3.0982983860675883 11 3.1085299458226827 12 3.1186457922717743 13 3.1285944303936839
		 14 3.1383335007157678 15 3.147747571400457 16 3.156858787788464 17 3.1655318774158623
		 18 3.1737770720410641 19 3.1814614770942651 20 3.1885887291178405 21 3.1950262765092998
		 22 3.2007691463158645 23 3.2057060326096991 24 3.2098225710908488 25 3.2130036774887487
		 26 3.2151925641118591 27 3.2163107543368921 28 3.2163360575818105 29 3.2152763931074344
		 30 3.2132230006325759 31 3.2102033042597093 32 3.2063066042574238 33 3.2015676474194663
		 34 3.1960784616427449 35 3.189890745910966 36 3.1830384751933529 37 3.1756294186358991
		 38 3.1676822386603911 39 3.1593109441781717 40 3.150526469759193 41 3.141424554248379
		 42 3.1320364807403704 43 3.1223163424392002 44 3.1121381571825943 45 3.1018332282091028
		 46 3.0914688860515334 47 3.081143702682835 48 3.0708392463592333 49 3.0606483752007958
		 50 3.0506129226025842 51 3.0407604608140728 52 3.0311517411626121 53 3.0218450136410469
		 54 3.0128587877383572 55 3.0042458961280603 56 2.9960833267143068 57 2.9883116754868508
		 58 2.9810467831241829 59 2.9743337963988949 60 2.9681545162105869 61 2.9625747008708005
		 62 2.9575698108122808 63 2.9532419423106258 64 2.9496004284252639 65 2.9467248135063642
		 66 2.9446544918865873 67 2.9434813111681559 68 2.9432635607302631 69 2.9440377437045671
		 70 2.9456022866295024 71 2.9478366570841037 72 2.9506540189724095 73 2.9540994066615869
		 74 2.958194832026189 75 2.9629528849022764 76 2.9684049537031365 77 2.9745431409326173
		 78 2.9814118972731887 79 2.9889993498598053 80 2.9973669760919477;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY";
	rename -uid "76EF125E-4547-36D1-33C3-D5B6604A4204";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.076412211346688977 1 -0.077184150212416702
		 2 -0.077970872497247379 3 -0.078804595459558549 4 -0.079688531659846365 5 -0.080610733269431772
		 6 -0.081526870426161871 7 -0.08248925086119506 8 -0.083464640245217658 9 -0.084457188003314379
		 10 -0.085388555094926474 11 -0.086183269380379943 12 -0.086988183659634968 13 -0.087782539924338363
		 14 -0.088564395499599519 15 -0.089356377445179436 16 -0.090111376694924347 17 -0.090854588659595323
		 18 -0.091503988666926966 19 -0.092196665673233133 20 -0.092801463658392438 21 -0.093319046533243827
		 22 -0.093859871522867927 23 -0.094287567859689156 24 -0.094646399303713866 25 -0.094927420995391282
		 26 -0.095134940237789206 27 -0.095207904540726598 28 -0.095269201891029651 29 -0.095183555695849395
		 30 -0.095013153380792845 31 -0.094771854733928226 32 -0.094464881501367032 33 -0.094075016742912854
		 34 -0.093599154112349786 35 -0.093062739901161456 36 -0.092514411269911903 37 -0.091912525204515177
		 38 -0.091247870102206668 39 -0.090579748757689621 40 -0.089888020481006581 41 -0.089150600875709904
		 42 -0.088430698328839277 43 -0.087602921160583214 44 -0.086651808692048679 45 -0.085678268852111328
		 46 -0.084748355948552997 47 -0.083807802797575867 48 -0.08287013020284105 49 -0.081948829259523487
		 50 -0.081089705297794926 51 -0.08019318889693583 52 -0.07937055862749591 53 -0.078564281831918076
		 54 -0.077827176916557772 55 -0.077089571079934444 56 -0.076437915672289428 57 -0.075808701137838955
		 58 -0.075217130808280533 59 -0.074670057889415456 60 -0.074181743773417741 61 -0.07372858493105329
		 62 -0.073311627735196422 63 -0.072974556384324332 64 -0.072675831862082721 65 -0.07248332569179991
		 66 -0.072307667987376437 67 -0.07219758936488925 68 -0.072159223003409628 69 -0.072211858433775866
		 70 -0.072314031443975038 71 -0.072472640212222841 72 -0.072663296195332419 73 -0.072942425892012996
		 74 -0.073258751705670172 75 -0.073605634671508852 76 -0.074055924276607052 77 -0.074542399087677874
		 78 -0.07512960800970242 79 -0.07571479879866419 80 -0.076412211346688977;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ";
	rename -uid "835EC0A9-4163-000E-8592-9EAC2A06BA0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -34.106206373824712 1 -34.132052098035395
		 2 -34.159879823028326 3 -34.188711810246751 4 -34.220226317323593 5 -34.253121396112917
		 6 -34.287437416053578 7 -34.323333553148345 8 -34.360440708623557 9 -34.398445139230226
		 10 -34.426983873062028 11 -34.435650519278745 12 -34.445446935675783 13 -34.455780933373994
		 14 -34.467413913181254 15 -34.479265362792624 16 -34.491608756664682 17 -34.50424516960129
		 18 -34.517364660906658 19 -34.530180565746306 20 -34.542907188189808 21 -34.554951593422771
		 22 -34.567004448549461 23 -34.57805297936406 24 -34.588278883522499 25 -34.597394727748821
		 26 -34.604739572392575 27 -34.610828143887886 28 -34.614953697776741 29 -34.617662619930059
		 30 -34.618211765740092 31 -34.617731211847669 32 -34.61598532907982 33 -34.612933900492642
		 34 -34.608885103610888 35 -34.603861845786568 36 -34.598367362016006 37 -34.592261343111431
		 38 -34.585965229085708 39 -34.579774654629396 40 -34.573024043510358 41 -34.56697752990793
		 42 -34.56120748215254 43 -34.544508244075629 44 -34.507262979080416 45 -34.470217156341327
		 46 -34.43360611038559 47 -34.398153158371784 48 -34.363415100896688 49 -34.329783912956685
		 50 -34.297340978434733 51 -34.266615043161003 52 -34.237127271508349 53 -34.209149061207377
		 54 -34.183155285687093 55 -34.158503145710348 56 -34.135609287404108 57 -34.114569976224793
		 58 -34.094638379239974 59 -34.076637912735968 60 -34.060431618511778 61 -34.045257440434618
		 62 -34.031858331655442 63 -34.019768679189923 64 -34.009367399483061 65 -34.000596139027252
		 66 -33.993188917054532 67 -33.988557037530057 68 -33.985703083760967 69 -33.98496479597874
		 70 -33.98620952673366 71 -33.989298652668772 72 -33.993807926190733 73 -33.999987785956066
		 74 -34.008425594860832 75 -34.018424186074881 76 -34.03072124357017 77 -34.045362711992674
		 78 -34.063223986064429 79 -34.083213345894819 80 -34.106206373824712;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX";
	rename -uid "E07C576F-4E0C-F85B-0B5A-6C883CCD8412";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -24.436306507811004 1 -24.429706076618647
		 2 -24.42287638705541 3 -24.415959711677125 4 -24.408817265925595 5 -24.401615148065215
		 6 -24.394308852711706 7 -24.386978820369382 8 -24.379629423604371 9 -24.372377994396381
		 10 -24.365732012298924 11 -24.360529713788321 12 -24.355398427951709 13 -24.350379300796863
		 14 -24.345485135435801 15 -24.340739112399383 16 -24.336206513387932 17 -24.331809923982313
		 18 -24.327617341951871 19 -24.323675459178315 20 -24.319967972886726 21 -24.316522789292105
		 22 -24.313307372972151 23 -24.310426326263723 24 -24.307865429455582 25 -24.305663316751563
		 26 -24.303916531001203 27 -24.302566561112084 28 -24.301745120685766 29 -24.301359452027015
		 30 -24.301494551288769 31 -24.302044517213087 32 -24.303000884305419 33 -24.304355931659643
		 34 -24.306143184217241 35 -24.308271426155308 36 -24.310736491156206 37 -24.313591344262282
		 38 -24.316731605993894 39 -24.320158777102392 40 -24.3239331151192 41 -24.327916973130655
		 42 -24.332176734547168 43 -24.337326895909104 44 -24.344010540410984 45 -24.350836276411908
		 46 -24.35785221170077 47 -24.364980987825522 48 -24.372176698121539 49 -24.379447937214124
		 50 -24.386720330363097 51 -24.393899516549421 52 -24.40107845908576 53 -24.408125826604095
		 54 -24.415021609620716 55 -24.421732358989818 56 -24.428232831481441 57 -24.434439524145844
		 58 -24.440361901709178 59 -24.445943263691156 60 -24.451112041383684 61 -24.455925593723489
		 62 -24.460268732333677 63 -24.464202917733239 64 -24.467574983741333 65 -24.470336681059301
		 66 -24.472456755199978 67 -24.473824458605712 68 -24.474454821651868 69 -24.474257110839975
		 70 -24.473361462043147 71 -24.47200643744177 72 -24.470133651013914 73 -24.4677888675253
		 74 -24.464884853546398 75 -24.461495861043758 76 -24.45756856364293 77 -24.453109926547654
		 78 -24.448043748853287 79 -24.442440306146874 80 -24.436306507811004;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY";
	rename -uid "4FD7F23A-4947-3033-D0C4-7CA7E257640A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.93442063082092 1 15.951161115325988
		 2 15.968525768155786 3 15.986345327262473 4 16.004714107515984 5 16.023373256267323
		 6 16.042258044073893 7 16.061340940522783 8 16.080463284346369 9 16.099580088932711
		 10 16.117562476674117 11 16.133349288108882 12 16.148876683494912 13 16.164025308408444
		 14 16.178810938173719 15 16.193046814881107 16 16.2066746759367 17 16.219653815654294
		 18 16.231838377942498 19 16.243210407918376 20 16.253582187697223 21 16.262899037436526
		 22 16.271205639412283 23 16.278254774410858 24 16.284018246457734 25 16.288360401647484
		 26 16.291231020105542 27 16.292519034517273 28 16.292201028759528 29 16.290280262103817
		 30 16.286828299513353 31 16.282012385994328 32 16.275841160409843 33 16.268439738396424
		 34 16.259886317056878 35 16.250195040121394 36 16.239588118805951 37 16.228058274723967
		 38 16.215730940488864 39 16.202743312467629 40 16.189039580644526 41 16.174862609769409
		 42 16.160198349659218 43 16.144060835204691 44 16.125596455091806 45 16.106870203165993
		 46 16.088046103711367 47 16.069165466810947 48 16.050348428131951 49 16.031690802634429
		 50 16.013277291200371 51 15.995178934910189 52 15.977590946309711 53 15.960389970002623
		 54 15.943884286224788 55 15.928036522812995 56 15.913001943268716 57 15.898793543178515
		 58 15.885493499429128 59 15.87326483467727 60 15.86211551935954 61 15.852095829783165
		 62 15.843356147516127 63 15.835972199164852 64 15.82999694262304 65 15.825589300766532
		 66 15.822771905004515 67 15.821699062897888 68 15.822392567016632 69 15.82498150333924
		 70 15.829165148084067 71 15.834518307661181 72 15.840941492297281 73 15.848556616139927
		 74 15.857347746438338 75 15.867205768319167 76 15.878306324733515 77 15.890527212696872
		 78 15.904008028579732 79 15.91860454698447 80 15.93442063082092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ";
	rename -uid "1C636D01-4958-5968-F2AC-5FA4E3CF2D94";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 17.952110477348128 1 17.971471083072764
		 2 17.99211138376711 3 18.013392049402103 4 18.03627331332909 5 18.0598918544725 6 18.084368035386593
		 7 18.109750879502236 8 18.135758732895269 9 18.162157231744484 10 18.183552734165247
		 11 18.194246309157524 12 18.205353397531724 13 18.21664010492276 14 18.228383000084811
		 15 18.239963245722212 16 18.251484104665234 17 18.262863952986642 18 18.274065750637281
		 19 18.284743081961583 20 18.294852553300565 21 18.304031747650249 22 18.312763323735311
		 23 18.320321772978883 24 18.326807257831536 25 18.33211643167418 26 18.335827490220275
		 27 18.338186612705336 28 18.338811390833392 29 18.338104162974865 30 18.335563347445113
		 31 18.331944507891361 32 18.327106470879624 33 18.321127040299565 34 18.314195930690722
		 35 18.306255702437706 36 18.297790474118731 37 18.288681289382396 38 18.279180867407117
		 39 18.269536539556789 40 18.259333916189156 41 18.249462745288206 42 18.239577289602071
		 43 18.223831908897296 44 18.197188609538642 45 18.170682941709611 46 18.14442798093901
		 47 18.118900758248301 48 18.093847028743962 49 18.069582293363844 50 18.046106208726318
		 51 18.02381280358231 52 18.002467431527549 53 17.982112975971894 54 17.963128670125005
		 55 17.945241579935164 56 17.928714816400465 57 17.913515072396493 58 17.899359281955686
		 59 17.886708633984018 60 17.875368898998826 61 17.865227296839233 62 17.856693665633337
		 63 17.849417331566787 64 17.843619382515168 65 17.839379238474404 66 17.83640515803414
		 67 17.835498928829107 68 17.836045799128033 69 17.838305250951983 70 17.842168589081457
		 71 17.84724935865469 72 17.853457269056058 73 17.860818968711676 74 17.869664482840093
		 75 17.879553911714883 76 17.890907973521518 77 17.90373877675972 78 17.918416303752796
		 79 17.934434989917087 80 17.952110477348128;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX";
	rename -uid "6A906474-4B40-08CB-38B8-0BA80260756A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -11.98778207991406 1 -12.017068520551859
		 2 -12.047338561214071 3 -12.078437783122917 4 -12.110179312205362 5 -12.142519147253925
		 6 -12.175112468555248 7 -12.207981925362411 8 -12.240877576002871 9 -12.27370610505184
		 10 -12.30713274099767 11 -12.34197037063764 12 -12.376296258234685 13 -12.409919615601476
		 14 -12.442742481291706 15 -12.474550261169423 16 -12.505337979166484 17 -12.534842542671733
		 18 -12.562935907030766 19 -12.589529137402016 20 -12.614446989384041 21 -12.637766964178741
		 22 -12.659212506558516 23 -12.678484669153871 24 -12.695518972459119 25 -12.709891695669103
		 26 -12.72149381275805 27 -12.72993399961045 28 -12.734981427846728 29 -12.736917213977678
		 30 -12.735648653834755 31 -12.731478838938482 32 -12.724431023647968 33 -12.714650968372519
		 34 -12.702361156064653 35 -12.687514094037772 36 -12.670339466576419 37 -12.651012448147268
		 38 -12.629590760957475 39 -12.606235161145781 40 -12.581106603292037 41 -12.55431389877832
		 42 -12.526037379967748 43 -12.497331279754512 44 -12.469201060773527 45 -12.440047591500448
		 46 -12.409983387481635 47 -12.379144463945083 48 -12.347654300075547 49 -12.315741505266987
		 50 -12.283508920296331 51 -12.251179173498695 52 -12.218840680775577 53 -12.186730617750092
		 54 -12.155111358409352 55 -12.124006689694061 56 -12.093707839811977 57 -12.064273939693573
		 58 -12.035986318092899 59 -12.009080401529323 60 -11.983630027821654 61 -11.959476018960718
		 62 -11.936796050405212 63 -11.915840336445633 64 -11.896923355957675 65 -11.880574649231857
		 66 -11.86701267226446 67 -11.856648083416244 68 -11.849792584421317 69 -11.846716855091376
		 70 -11.846804030876971 71 -11.849195080850468 72 -11.853844969339205 73 -11.860945507858942
		 74 -11.870613778342097 75 -11.88296468659855 76 -11.898067517742442 77 -11.915926887099074
		 78 -11.936759256459881 79 -11.960742304253328 80 -11.98778207991406;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY";
	rename -uid "339C25E2-428D-174F-F06C-D99F2831D7F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 37.744698874691927 1 37.835819242874379
		 2 37.929827346140222 3 38.026191098926304 4 38.124403376656851 5 38.223915000130788
		 6 38.32432707118906 7 38.425046609317896 8 38.525590653894241 9 38.625499299450979
		 10 38.724313714266863 11 38.821635958683132 12 38.916722098666611 13 39.009183347031339
		 14 39.098566957286017 15 39.184251206906225 16 39.265856190114448 17 39.342876449045399
		 18 39.414758032390097 19 39.481051080278 20 39.541287084799542 21 39.594869370028839
		 22 39.641441333320117 23 39.680464186334575 24 39.711441111083651 25 39.733904941746339
		 26 39.747384160631022 27 39.751442603790885 28 39.745714662911382 29 39.730521765506033
		 30 39.706426152301809 31 39.673911155220807 32 39.633429814433818 33 39.585528470523805
		 34 39.53066285941555 35 39.469365493792083 36 39.402141906395329 37 39.329413180553466
		 38 39.25171684624123 39 39.169604688570885 40 39.08349425091145 41 38.993908864424398
		 42 38.901348944995625 43 38.806362549688721 44 38.709487349457675 45 38.611126036957288
		 46 38.51178501154984 47 38.411975582983388 48 38.312155830551738 49 38.212905903575674
		 50 38.114640522303674 51 38.017931477861005 52 37.923234684587904 53 37.831119231342811
		 54 37.741997519070154 55 37.656442148158803 56 37.574979809846802 57 37.498063298729427
		 58 37.426243770045424 59 37.360045082089442 60 37.299914019487822 61 37.246493658245477
		 62 37.20022820063565 63 37.16160774409137 64 37.131193615424287 65 37.109408304194865
		 66 37.096760818106432 67 37.093729988538634 68 37.100826157604978 69 37.118487733399938
		 70 37.144793560880537 71 37.177364669227615 72 37.216182052098354 73 37.26115786159933
		 74 37.312249229533663 75 37.369465369810698 76 37.43265741628516 77 37.50183258181405
		 78 37.576967092357606 79 37.657905422360173 80 37.744698874691927;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "3FD21657-4F43-5112-712A-50A79C315D61";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.9197862161148027 1 5.9259799130402691
		 2 5.9320433281511349 3 5.937849734690527 4 5.943447025017691 5 5.9486463168238108
		 6 5.9536349832103062 7 5.9581279686773199 8 5.9622213716157475 9 5.9658179724719735
		 10 5.9676924958780395 11 5.9664142482006737 12 5.9645150473320321 13 5.962032823928757
		 14 5.9589474005821108 15 5.9551977320984575 16 5.9506404598226439 17 5.9454538105251284
		 18 5.9394758723855663 19 5.9327006688684456 20 5.9251202867793094 21 5.9163417449344387
		 22 5.9065469020050578 23 5.8960297662181391 24 5.8846325170832143 25 5.8727460807993275
		 26 5.8603799841286746 27 5.8479031526322025 28 5.8354630264293927 29 5.8228932207450743
		 30 5.8105264157999112 31 5.7982066680474409 32 5.7860540741827853 33 5.774144439198599
		 34 5.7624299216645039 35 5.7511267543843463 36 5.7402150495725621 37 5.7296377503993723
		 38 5.7195522460248469 39 5.7099660197086202 40 5.7008891812026912 41 5.6923935685590408
		 42 5.6845348334235677 43 5.6759606940794525 44 5.6654712892095294 45 5.6557024407333136
		 46 5.6466473853776025 47 5.638492581010353 48 5.6312339579615527 49 5.6248622031844366
		 50 5.619497692850107 51 5.6150992236993229 52 5.6118074748799751 53 5.6095928529141688
		 54 5.6083647533589254 55 5.608378909909443 56 5.6095237975660934 57 5.6120184603277457
		 58 5.6157030401352657 59 5.6206433899493069 60 5.6269099290003837 61 5.6353164896804895
		 62 5.6458637058148664 63 5.6584920840922281 64 5.6729040521533758 65 5.6885512477411648
		 66 5.7053108169935909 67 5.7227330057449359 68 5.7405574515863336 69 5.7585467790280749
		 70 5.7765756768867895 71 5.7945632327399368 72 5.8125178289894315 73 5.8300325665810915
		 74 5.8468634938801607 75 5.8627477926336704 76 5.8774444659381908 77 5.8908207194595565
		 78 5.9025391469330133 79 5.9121585583687493 80 5.9197862161148027;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX";
	rename -uid "7ED24E99-4C62-BAC0-B596-3BA636CB13FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.563226362957951 1 -6.5825822567834447
		 2 -6.6026048879179946 3 -6.6231335520583201 4 -6.644100916027794 5 -6.6653131747939884
		 6 -6.6868236032802715 7 -6.7083696261206471 8 -6.7299035872566613 9 -6.7513251665327925
		 10 -6.7728057722969845 11 -6.794453047619581 12 -6.8155699330851327 13 -6.8361174742914725
		 14 -6.8559989180695418 15 -6.8750250234071091 16 -6.8931241804929533 17 -6.9102028968486211
		 18 -6.9260683818222128 19 -6.9406399998747128 20 -6.9538358294240439 21 -6.9653713890915663
		 22 -6.975295282474951 23 -6.9834479716632165 24 -6.989701674902645 25 -6.9939793842769058
		 26 -6.9961307264080217 27 -6.9961546849207421 28 -6.993932655573051 29 -6.9894951362711177
		 30 -6.9830537666919259 31 -6.9747179280113407 32 -6.9645224425753645 33 -6.9527172564671345
		 34 -6.939275426823003 35 -6.9244564227410725 36 -6.9083599342360547 37 -6.8910371811846085
		 38 -6.8726603992227 39 -6.8533683608006397 40 -6.8332470030051029 41 -6.8124466211558454
		 42 -6.7910799040584662 43 -6.7694986183262067 44 -6.7481065412449714 45 -6.7264761937111439
		 46 -6.7047550179229365 47 -6.6830505746405917 48 -6.6614452268324609 49 -6.6400945468915689
		 50 -6.6190602235012426 51 -6.5984990319733283 52 -6.5784659691263672 53 -6.5591052768530789
		 54 -6.540435385010956 55 -6.5226761815569709 56 -6.5058795078241083 57 -6.4901616483620268
		 58 -6.4755624689465616 59 -6.4622990762098205 60 -6.4503606879480966 61 -6.4400207105900238
		 62 -6.4312804145449602 63 -6.4242613767176566 64 -6.4190822046515477 65 -6.4157525001731965
		 66 -6.4143465333506038 67 -6.4150004439411275 68 -6.4177362693291027 69 -6.4226218365927608
		 70 -6.4293241293569876 71 -6.4372644435916664 72 -6.4465346227617912 73 -6.4570210125876484
		 74 -6.4687045573718276 75 -6.481621667432206 76 -6.4956766931211858 77 -6.510896824196446
		 78 -6.5272771160251883 79 -6.5446769079941625 80 -6.563226362957951;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY";
	rename -uid "33C17828-49FE-6348-4185-0FB5DFC6543B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.021013933637111154 1 0.020437242643354499
		 2 0.0197747012088113 3 0.019124849000469197 4 0.018435073575202993 5 0.017681542895879469
		 6 0.016930193150862027 7 0.016136058491604849 8 0.015294476627767279 9 0.014428101752965139
		 10 0.013555436468143774 11 0.012674894605095058 12 0.011813464084189606 13 0.010948342973196188
		 14 0.010087364823827862 15 0.0092441154138418451 16 0.0084012458950342324 17 0.0075928458337222076
		 18 0.0068564633234664578 19 0.0061242784203100458 20 0.0055109177559059374 21 0.0049231345769209832
		 22 0.0044421107679398506 23 0.0040534385580027607 24 0.0037623524417602461 25 0.003546816158873695
		 26 0.0034838568744985001 27 0.0035225839800661798 28 0.003702960715979539 29 0.0039037564958279056
		 30 0.0043300659046310768 31 0.0047672969518878323 32 0.0053441931138243047 33 0.005990215931096987
		 34 0.0066513429596501599 35 0.0074548176902692687 36 0.0082300853100007471 37 0.0090717494545269478
		 38 0.0099467347764245085 39 0.010813610369971803 40 0.01172806730629007 41 0.012600178334436994
		 42 0.013504548968271765 43 0.014379138821723307 44 0.015256448480460125 45 0.016141004188690827
		 46 0.016961167817579323 47 0.017740142362662342 48 0.018504188097320715 49 0.019210543255034948
		 50 0.019925692421596069 51 0.020521920451510252 52 0.021145095972817923 53 0.02169878807990008
		 54 0.022210407545493662 55 0.022671443434418001 56 0.023083348516018107 57 0.023465937259508154
		 58 0.023834101897845877 59 0.024084543928721714 60 0.024365960934829116 61 0.024562394786888729
		 62 0.024723764195566461 63 0.024836839420452939 64 0.024964600807656886 65 0.024984591588393223
		 66 0.025021032282728704 67 0.024933691035472764 68 0.024866341669794775 69 0.024767907813190038
		 70 0.024566429538295693 71 0.024377101598778921 72 0.024138842045778219 73 0.023881366573740709
		 74 0.023600713071230593 75 0.023248327225415505 76 0.022877498358529869 77 0.022487085161696733
		 78 0.022045648011786569 79 0.021520125808931222 80 0.021013933637111154;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ";
	rename -uid "55B5CCE4-4972-27BE-286C-998F49A45E27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 36.812727675331793 1 36.737808643915116
		 2 36.660376816580211 3 36.580795385142089 4 36.499492163041971 5 36.416695900537732
		 6 36.33288942772279 7 36.248713264921157 8 36.164311870223599 9 36.080179783494643
		 10 36.000848401792361 11 35.930444861784295 12 35.861489804713109 13 35.794446307325302
		 14 35.729619414765935 15 35.667491209209828 16 35.60845495451936 17 35.553038462534388
		 18 35.501512699090839 19 35.454503347420754 20 35.412393809776908 21 35.375662729029756
		 22 35.34479626228611 23 35.320025566694248 24 35.301814884745582 25 35.290415967604339
		 26 35.286130330543635 27 35.289352297362278 28 35.299989224104635 29 35.318017360583909
		 30 35.342866603637063 31 35.374257275044407 32 35.41149488472275 33 35.454480164591537
		 34 35.502374013670504 35 35.554987633487677 36 35.611788314068008 37 35.672268362035382
		 38 35.736113005205432 39 35.802742969510369 40 35.871825582738268 41 35.942883341689573
		 42 36.015597148721398 43 36.093297083333852 44 36.179962930555448 45 36.266910372083835
		 46 36.353760301133789 47 36.440056840251088 48 36.525352221757799 49 36.609270277831108
		 50 36.691299578531648 51 36.771204239975425 52 36.848230928256214 53 36.922357345503229
		 54 36.993003817677909 55 37.059794754444503 56 37.122437540907313 57 37.180495440749532
		 58 37.233613556033433 59 37.281480035232477 60 37.323733908962367 61 37.359542835583866
		 62 37.388380336658173 63 37.410388681612837 64 37.42496543617272 65 37.432368154204745
		 66 37.432139844938384 67 37.42435741785269 68 37.408723994471977 69 37.385047846063507
		 70 37.354977413165102 71 37.319903748301627 72 37.280348166738705 73 37.236199123339233
		 74 37.187683058310547 75 37.134967630122205 76 37.07822569339055 77 37.017479975492265
		 78 36.952797719798028 79 36.88466488951817 80 36.812727675331793;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX";
	rename -uid "00BAA6E7-40D2-CC62-B37C-D3A6FB3EB6CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 35.390343278663707 1 35.403109654438204
		 2 35.416306133532707 3 35.429874404232429 4 35.443801873775044 5 35.457983960809891
		 6 35.472318308781794 7 35.486761315857152 8 35.50125279771823 9 35.515716520105492
		 10 35.529889706276919 11 35.543588048317659 12 35.557059258094007 13 35.57025593640747
		 14 35.583057833195291 15 35.595429880026508 16 35.607267127816755 17 35.618543899590321
		 18 35.629168635583873 19 35.639037114476274 20 35.648147158184592 21 35.656383073955162
		 22 35.663702661935503 23 35.670018963506443 24 35.675241457127207 25 35.679232972667528
		 26 35.682005281696668 27 35.683415897638568 28 35.683416085252261 29 35.681997845253484
		 30 35.679359479913565 31 35.675456965982626 32 35.670397147870496 33 35.664248521276548
		 34 35.657077952304562 35 35.64902236800021 36 35.640012147995783 37 35.630223103127847
		 38 35.619725070461932 39 35.608531179973454 40 35.596784623832058 41 35.584477524073499
		 42 35.571774594806485 43 35.558530907343417 44 35.544607610213447 45 35.530543090040645
		 46 35.516245239138037 47 35.501887395016482 48 35.487548926744566 49 35.473226952333121
		 50 35.459093498419321 51 35.445072268789467 52 35.431421544482859 53 35.418082446275442
		 54 35.405189321067901 55 35.392780395124618 56 35.380915529895013 57 35.369737388038928
		 58 35.359229226459938 59 35.34944319040607 60 35.340575439339801 61 35.332506160507187
		 62 35.325427496106116 63 35.319326335803559 64 35.314370400138451 65 35.310581938082187
		 66 35.308058072687039 67 35.306834942223716 68 35.307036459003712 69 35.308721255518513
		 70 35.31159238339508 71 35.315425333862123 72 35.32009937656958 73 35.325662208807273
		 74 35.332160219342818 75 35.339518902464654 76 35.347848352353758 77 35.357057492088281
		 78 35.367206729795548 79 35.378249438201543 80 35.390343278663707;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY";
	rename -uid "DE4F4CE6-45AE-3E88-D14A-B58118B6122F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.3136563322747685 1 -3.3328510261877331
		 2 -3.3525522714358185 3 -3.3727971077752503 4 -3.3934100234923665 5 -3.414365197993404
		 6 -3.435450501209564 7 -3.456610205250978 8 -3.4777451305069875 9 -3.4987654537145048
		 10 -3.5186988167067823 11 -3.5367480662175725 12 -3.5543900243462669 13 -3.5714918747581965
		 14 -3.5880735715431769 15 -3.6039342224803366 16 -3.6190785335856637 17 -3.6333376139676776
		 18 -3.6466361723907861 19 -3.6588853513201953 20 -3.6700121174941622 21 -3.6799264313519364
		 22 -3.6885364999331038 23 -3.6957400080919816 24 -3.7014565402532433 25 -3.7055632997128289
		 26 -3.7080511313269682 27 -3.7087196552713855 28 -3.7076338077800037 29 -3.704768580210446
		 30 -3.7002655237784436 31 -3.6941899918529431 32 -3.6866755817754906 33 -3.677702316496994
		 34 -3.6675386665243241 35 -3.6561355579552401 36 -3.6436021832021481 37 -3.6300842795123582
		 38 -3.6156384250802702 39 -3.6003633784284417 40 -3.5843414665721851 41 -3.5676943446908509
		 42 -3.550425714340363 43 -3.531958825927922 44 -3.5113995388581696 45 -3.4905975252125487
		 46 -3.4696273475149049 47 -3.4485419554453522 48 -3.4274819398860878 49 -3.4065723325558945
		 50 -3.3859096005012645 51 -3.3655169978754165 52 -3.3456358305075371 53 -3.3262777788316216
		 54 -3.3076430239962038 55 -3.2897529456917298 56 -3.2727497946079418 57 -3.2567056843402411
		 58 -3.2417915441327567 59 -3.2280545615269451 60 -3.2156175338380608 61 -3.2045985855880263
		 62 -3.1951720771871037 63 -3.1873125101078372 64 -3.1812250258615209 65 -3.1769729388645369
		 66 -3.1746741903753506 67 -3.174349205411104 68 -3.1761578618506134 69 -3.1801609746670354
		 70 -3.1859207256674913 71 -3.1930812121005099 72 -3.2014605740586819 73 -3.2111524819059625
		 74 -3.2221343510809244 75 -3.234358215528307 76 -3.2478030758613263 77 -3.2624485719721701
		 78 -3.2783320704144434 79 -3.2953950377939565 80 -3.3136563322747685;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ";
	rename -uid "C7604BB9-44C2-757F-F375-FDA135B08A7F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -37.563317406266265 1 -37.500812328801572
		 2 -37.436234873531717 3 -37.369825491535416 4 -37.302003458137392 5 -37.232824400797035
		 6 -37.162876269863098 7 -37.0925356799547 8 -37.022010578232859 9 -36.951645744929678
		 10 -36.884867615155052 11 -36.824545094484264 12 -36.765395479085257 13 -36.70782661415484
		 14 -36.652073630334392 15 -36.598537040724985 16 -36.547537322620485 17 -36.4995872960342
		 18 -36.454837695661716 19 -36.413853387132711 20 -36.376952695646978 21 -36.344368679583368
		 22 -36.31667923218464 23 -36.294142286008913 24 -36.27696901194831 25 -36.265576149258401
		 26 -36.260070450586305 27 -36.26098697480257 28 -36.268207816486211 29 -36.281630868989517
		 30 -36.300923347608219 31 -36.32577255662639 32 -36.355581077555513 33 -36.390334043808991
		 34 -36.429250485273606 35 -36.472324856550543 36 -36.519030048202829 37 -36.568877195628623
		 38 -36.62171753901341 39 -36.677023658791015 40 -36.734494283167137 41 -36.793756247880424
		 42 -36.854592386326551 43 -36.91918912953134 44 -36.990520672822484 45 -37.062206538834324
		 46 -37.133962100351859 47 -37.205420426660453 48 -37.276242580648685 49 -37.346043260902022
		 50 -37.41449949839069 51 -37.481325028407667 52 -37.545935268017885 53 -37.608305389177623
		 54 -37.667856234518609 55 -37.724377250835069 56 -37.777586512670617 57 -37.827221707387153
		 58 -37.872841129440921 59 -37.914164998745839 60 -37.95097811495333 61 -37.98280181399452
		 62 -38.008881020366694 63 -38.029543646342759 64 -38.044236942797923 65 -38.052950572914988
		 66 -38.05540645432378 67 -38.051525848541317 68 -38.041040013183014 69 -38.023755798024723
		 70 -38.001057620764051 71 -37.974028909682829 72 -37.94326849790469 73 -37.908505580934346
		 74 -37.869955300684047 75 -37.827632505454766 76 -37.781754323769022 77 -37.732334280514905
		 78 -37.679340790278985 79 -37.623028748082731 80 -37.563317406266265;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAX";
	rename -uid "67F3444A-4BDD-6989-59D2-49864D05C75A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.34814221170011234 1 0.33856952732060219
		 2 0.32935229496122087 3 0.32087885218755863 4 0.31353315395238301 5 0.30769468660948868
		 6 0.30376273756686323 7 0.30208394524498533 8 0.30280912271406946 9 0.30571684850023589
		 10 0.31066217269229796 11 0.31754014466631547 12 0.32620880047966511 13 0.33656044201971919
		 14 0.34847143449187851 15 0.36181884950078741 16 0.37646617187785636 17 0.3922814348009126
		 18 0.40914808719970314 19 0.42697319620172858 20 0.44560844715758707 21 0.46495696729670899
		 22 0.48486554789817704 23 0.50521481417054193 24 0.52587906274630758 25 0.54674726476873869
		 26 0.56766196985595108 27 0.58851068364555059 28 0.60914326343078251 29 0.62946302250458519
		 30 0.64931586277936193 31 0.66859638055705295 32 0.68715145978612124 33 0.70486383191996471
		 34 0.72160412296972321 35 0.73724001607457235 36 0.75165672193379851 37 0.76470243567989049
		 38 0.77627429491747857 39 0.78622491378038395 40 0.79443277491534758 41 0.80077066185407642
		 42 0.80524027389819086 43 0.80799567429766772 44 0.80910582653957031 45 0.80860422448369174
		 46 0.80660859270877472 47 0.80315886787108159 48 0.79834125548923007 49 0.79219627662419601
		 50 0.78481631468509405 51 0.77625515674319612 52 0.76659209283765473 53 0.75588297019231387
		 54 0.74420607820629436 55 0.73163817869078973 56 0.71821426716453585 57 0.70406228759458411
		 58 0.68921693876961831 59 0.67377602055273711 60 0.65779549151567573 61 0.64138479305600915
		 62 0.62460994057015484 63 0.60753717199257162 64 0.5902576574630225 65 0.57283804220108525
		 66 0.55536192470093959 67 0.53791159619302464 68 0.52055810898942267 69 0.50337296896748662
		 70 0.48644185818164798 71 0.46985448616066278 72 0.4536624505762214 73 0.43796131760306867
		 74 0.42283622605003035 75 0.40832985419716616 76 0.39455514945445908 77 0.38155932209181626
		 78 0.36945323453730061 79 0.35829674726155331 80 0.34814221170011234;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAY";
	rename -uid "F4161DB7-465F-A7D4-B5B1-B48020F326E0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.2935213919950703 1 -3.2973058195116196
		 2 -3.3008956675086782 3 -3.3041919330379641 4 -3.306989355884375 5 -3.3091961698947272
		 6 -3.3106103451451525 7 -3.3111290492932368 8 -3.3106387765081107 9 -3.3092820479388214
		 10 -3.3071512751031444 11 -3.3041839855280055 12 -3.3005160064416716 13 -3.2961223844959959
		 14 -3.2910577047583902 15 -3.2853702031651464 16 -3.2790786439117658 17 -3.2722829824047324
		 18 -3.2649356724495706 19 -3.2571319630355497 20 -3.2488924788574058 21 -3.2402536318797104
		 22 -3.2313248726813382 23 -3.2220572577803166 24 -3.2125937676887815 25 -3.2029144126761162
		 26 -3.1931493971737019 27 -3.1832648070822405 28 -3.1734307832400783 29 -3.1635955569404515
		 30 -3.1539721281345283 31 -3.1444640620608215 32 -3.1353157989228668 33 -3.1264329536622455
		 34 -3.1180762349296529 35 -3.1101367543537948 36 -3.1028528692904254 37 -3.0962582753971852
		 38 -3.0903728993851525 39 -3.0853513639459962 40 -3.0812022464398674 41 -3.0780762194757454
		 42 -3.07593612188266 43 -3.0747756461292877 44 -3.0744713701964059 45 -3.0750227501062248
		 46 -3.0763886218812861 47 -3.0785555607625894 48 -3.0813882090114517 49 -3.0849211054692645
		 50 -3.0891066668770084 51 -3.0938702282500015 52 -3.099168386117793 53 -3.1049673965584894
		 54 -3.1112559575955889 55 -3.1178907587480369 56 -3.1249040776710837 57 -3.1321949779144096
		 58 -3.139804919347251 59 -3.1475890751395665 60 -3.1555449594877256 61 -3.1636174674653064
		 62 -3.1717940962637754 63 -3.1799980463799358 64 -3.1882225136748445 65 -3.1964097993366489
		 66 -3.2045270816328908 67 -3.2125185290243272 68 -3.2204080410216842 69 -3.2281083200121246
		 70 -3.2355961701557518 71 -3.242858516525855 72 -3.2498601615902469 73 -3.256605560560859
		 74 -3.2629701928494974 75 -3.2690693933269452 76 -3.274761639722982 77 -3.2800865146008618
		 78 -3.285008933089856 79 -3.2894916826301164 80 -3.2935213919950703;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ";
	rename -uid "A61D4D70-4424-64B6-4C91-19AF70D37F6C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.3875784545952472 1 -4.3407184115029267
		 2 -4.2954566023523677 3 -4.2536979870675244 4 -4.2171475350086975 5 -4.187583890435258
		 6 -4.1668026004384755 7 -4.1565279677009972 8 -4.1573770268224326 9 -4.16833475088435
		 10 -4.1888369609610034 11 -4.2183561674048518 12 -4.2563451992459695 13 -4.3022233176259386
		 14 -4.3554758515783361 15 -4.4155348231798177 16 -4.4818360677914795 17 -4.5538024930882779
		 18 -4.6309319533497986 19 -4.7126727912484609 20 -4.7985312001488722 21 -4.8880342112675859
		 22 -4.9805649306443334 23 -5.0754763467545114 24 -5.1721989148591829 25 -5.2700543020547057
		 26 -5.3684676392690651 27 -5.4668165872251375 28 -5.5644411325705407 29 -5.6607983217196987
		 30 -5.7552331990955423 31 -5.8471042020758999 32 -5.9358530295150684 33 -6.0208202836256506
		 34 -6.1013832334755795 35 -6.176975266517001 36 -6.2469136454640122 37 -6.3106479273212308
		 38 -6.367549518549632 39 -6.4169592152153054 40 -6.4583203228023764 41 -6.4909703650479393
		 42 -6.5149882574427469 43 -6.5309901304090454 44 -6.5392499787240137 45 -6.5400695764374754
		 46 -6.5337914897901426 47 -6.520669612158529 48 -6.5010217648391633 49 -6.4751096133418224
		 50 -6.4432277562096756 51 -6.4057195240261251 52 -6.3628363690406555 53 -6.3148902635285786
		 54 -6.2621834125790157 55 -6.205008814255228 56 -6.1436162785779764 57 -6.0784265318235899
		 58 -6.0097918806959081 59 -5.9380888342088403 60 -5.8637016911991653 61 -5.7869910493184742
		 62 -5.7083307272621715 63 -5.6281020562037041 64 -5.5467086138235802 65 -5.4644572848860191
		 66 -5.3817759319400924 67 -5.2990332373338598 68 -5.2165808040384745 69 -5.134826434063803
		 70 -5.0540883889724686 71 -4.9748359651106524 72 -4.8973609861782581 73 -4.8220586874380666
		 74 -4.7493160005936526 75 -4.6795015178034953 76 -4.6130070045393827 77 -4.550179366084194
		 78 -4.4914268964629516 79 -4.43711180893178 80 -4.3875784545952472;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX";
	rename -uid "EAE7599C-4892-EC9B-B70E-3D898DFF74FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.8146011058006946 1 3.8728018575745353
		 2 3.9384152466233382 3 4.0202653005666988 4 4.1270298326032329 5 4.2676954773231142
		 6 4.4513532663233581 7 4.6873656631430309 8 4.9786075210936724 9 5.3194871912403325
		 10 5.7068548814696909 11 6.1374640029438696 12 6.6078911007328358 13 7.1115223189219998
		 14 7.6420597554115313 15 8.1961960013772597 16 8.7702818355700529 17 9.3604694238602786
		 18 9.962706520292187 19 10.572880878590254 20 11.186890555070718 21 11.800650701274277
		 22 12.410075629398277 23 13.011430742071292 24 13.600976077027271 25 14.17543495183673
		 26 14.731552390667344 27 15.266369202328354 28 15.777265578139758 29 16.261834798260409
		 30 16.717950656208735 31 17.143778000722037 32 17.537700105280301 33 17.898287826949517
		 34 18.224276142745779 35 18.514622685590489 36 18.768322259463023 37 18.984596415284443
		 38 19.162629452938521 39 19.301716196075752 40 19.401169737382158 41 19.460259666414618
		 42 19.482336809171986 43 19.474734155440153 44 19.442849859605364 45 19.385218600676126
		 46 19.297830594834281 47 19.182015405679714 48 19.039046479667576 49 18.869986631114923
		 50 18.676025630598112 51 18.412306307285409 52 18.039734473774438 53 17.567377749913206
		 54 17.003596461907073 55 16.356614408503312 56 15.634645688290515 57 14.846344710146207
		 58 14.00120899382839 59 13.109351212966441 60 12.182002668442887 61 11.232001808942496
		 62 10.273215154751588 63 9.3203949748418022 64 8.3893981980191725 65 7.4974969000910257
		 66 6.6624926052608462 67 5.9029957207418642 68 5.2376477427851889 69 4.6850454550392842
		 70 4.2628696820658503 71 3.9615043628901305 72 3.7516151507815469 73 3.6199887437447584
		 74 3.5532412282685142 75 3.5382933312153333 76 3.5623768410919916 77 3.6133491674392877
		 78 3.6795823443597691 79 3.7502277683617851 80 3.8146011058006946;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY";
	rename -uid "2829F751-4181-07A6-26E8-238C927A03CB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 40.357878794094511 1 40.286730734478851
		 2 40.222609072779939 3 40.169718827475371 4 40.132308352981894 5 40.114593331105354
		 6 40.120734338010763 7 40.154784395864738 8 40.216136968712497 9 40.298481331913116
		 10 40.397068400558339 11 40.506987531486701 12 40.623494097773126 13 40.732905953317498
		 14 40.824710235653178 15 40.898965058778707 16 40.955797981772236 17 40.995527146326019
		 18 41.018472759437913 19 41.025115794771665 20 41.016455704625308 21 40.993486149400084
		 22 40.956853136274425 23 40.907267068393999 24 40.845531924453994 25 40.772519932934493
		 26 40.689037084995604 27 40.596017714361714 28 40.494402171727913 29 40.385594032194703
		 30 40.270930257714234 31 40.151713085670401 32 40.02913923782129 33 39.904291798053414
		 34 39.778145165374994 35 39.651527661413553 36 39.525077128169976 37 39.399456226096447
		 38 39.275054502573177 39 39.152169326170792 40 39.031095210514124 41 38.911966847040674
		 42 38.796750298553235 43 38.689408173865345 44 38.592871030102415 45 38.504260401691326
		 46 38.418385171745598 47 38.335212178231146 48 38.254659162870986 49 38.176739015329005
		 50 38.101508654920792 51 38.054403790918073 52 38.057525160564232 53 38.106394106323641
		 54 38.196912956554172 55 38.325375412068695 56 38.487967725966513 57 38.680965919265368
		 58 38.900568246854249 59 39.142262962442338 60 39.401129587119776 61 39.671282494441392
		 62 39.946330333223095 63 40.219311502384613 64 40.482705494367018 65 40.728466901204342
		 66 40.948187511379111 67 41.13323326295162 68 41.274987169144183 69 41.365112522961937
		 70 41.394186634965827 71 41.367242903453025 72 41.30147735806591 73 41.205241634965837
		 74 41.086920915499121 75 40.954829871109006 76 40.816946905678861 77 40.68105399435867
		 78 40.554541554846907 79 40.444509423720589 80 40.357878794094511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ";
	rename -uid "985EAEF0-430C-CB69-BE0E-6F870657D8FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.381865146375155 1 -8.5153994138597717
		 2 -8.6387333073585726 3 -8.7441658890376974 4 -8.8242029909118997 5 -8.8710625456323768
		 6 -8.8769423922211708 7 -8.8338240200861833 8 -8.739809432388892 9 -8.600727612763448
		 10 -8.4201961066615887 11 -8.2017820393460461 12 -7.9493385912319665 13 -7.6708448170961763
		 14 -7.3734784986532169 15 -7.0602997757467856 16 -6.7348410936395977 17 -6.4008519387221101
		 18 -6.0623586476980993 19 -5.7233444378057943 20 -5.3880845291360115 21 -5.0606533030811232
		 22 -4.7446783930011067 23 -4.4432823423305781 24 -4.15943724747284 25 -3.8955266645752555
		 26 -3.653754675052499 27 -3.4359636476068438 28 -3.2434364276196037 29 -3.0771919170467146
		 30 -2.9378392480712461 31 -2.8255842310762826 32 -2.7403210880453339 33 -2.6816682617517218
		 34 -2.6489221555730782 35 -2.6411663368914677 36 -2.6573509348407898 37 -2.6961804667180749
		 38 -2.7563674197782659 39 -2.8365119456735219 40 -2.935147581242922 41 -3.050991758479908
		 42 -3.1796110455867623 43 -3.3132621660534309 44 -3.4455946786444573 45 -3.5790402125066936
		 46 -3.7194084505695697 47 -3.8657416053178806 48 -4.0171395224990407 49 -4.172990424486307
		 50 -4.3326274171865142 51 -4.4793333830958852 52 -4.5994747758014167 53 -4.6970621298692841
		 54 -4.7760183951203885 55 -4.8402460799041309 56 -4.8935923976005098 57 -4.9400097944729957
		 58 -4.9833130483687382 59 -5.027439509597464 60 -5.0760643622613131 61 -5.1319756867283823
		 62 -5.1980109616309527 63 -5.2771216587960037 64 -5.3719187727598268 65 -5.48415425608649
		 66 -5.6151881082646042 67 -5.7656018006896739 68 -5.9354878303127885 69 -6.1243649565974723
		 70 -6.3315938203539481 71 -6.5524931008287002 72 -6.7797703031416674 73 -7.0093529349422221
		 74 -7.2374395149037669 75 -7.460474900143236 76 -7.6749937779877957 77 -7.877675199334826
		 78 -8.0652833011685487 79 -8.234401130832488 80 -8.381865146375155;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX";
	rename -uid "D86FBF3E-47F4-AE62-61AF-D398A9A1E184";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.5289283719285409 1 -4.5321022367416477
		 2 -4.5352151294369181 3 -4.5376265033845584 4 -4.5387197630651022 5 -4.5379081109720758
		 6 -4.5345643678213881 7 -4.5280444439380503 8 -4.5185665224901497 9 -4.5071710652645578
		 10 -4.4946983529805467 11 -4.4820024081362027 12 -4.4698072485654805 13 -4.4615685192414576
		 14 -4.4596892999586331 15 -4.4635747577567022 16 -4.4727319139564825 17 -4.486450939071525
		 18 -4.5040340504765775 19 -4.5248140573730531 20 -4.5478865171756535 21 -4.572382075494092
		 22 -4.5977154703738439 23 -4.6233242450478658 24 -4.64872978975602 25 -4.673380621552635
		 26 -4.6968667263963413 27 -4.7187261481234337 28 -4.7386705811530909 29 -4.7564041634840635
		 30 -4.7717241280643332 31 -4.7844933726627303 32 -4.7946609953481447 33 -4.8022022589713078
		 34 -4.8071179188778501 35 -4.8095077143450258 36 -4.8094829471704577 37 -4.8072195904872483
		 38 -4.8029252893142518 39 -4.7968203887602066 40 -4.7891714596296113 41 -4.7801777398295888
		 42 -4.7697887310583136 43 -4.7574504455096003 44 -4.7429094439387089 45 -4.7269591043474612
		 46 -4.7108758261780368 47 -4.6948661715646969 48 -4.6790680987110989 49 -4.663604491380096
		 50 -4.6486614955449097 51 -4.6343708525606351 52 -4.6207663299129393 53 -4.6079613169241629
		 54 -4.596088541942116 55 -4.5851238841073343 56 -4.5752053403921575 57 -4.5663065214865277
		 58 -4.558286768900925 59 -4.5511229732827347 60 -4.5447102472849128 61 -4.5391393633222625
		 62 -4.534446336172806 63 -4.5305243938673776 64 -4.5273078105774784 65 -4.5247225987862851
		 66 -4.5227061831633693 67 -4.5212115570417053 68 -4.5202615679482019 69 -4.5198208749595841
		 70 -4.5197200617446462 71 -4.51968812640128 72 -4.5197789059897415 73 -4.5199820146929257
		 74 -4.5203316882548785 75 -4.5208747796427229 76 -4.5216870321195994 77 -4.5228050674902516
		 78 -4.5243395228169154 79 -4.5263389961126048 80 -4.5289283719285409;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY";
	rename -uid "3A52E751-4FA2-F075-14F1-19B8D2EE8206";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -7.3941419589522983 1 -7.3957301495536614
		 2 -7.397282887702171 3 -7.3985365275391111 4 -7.3990750568529009 5 -7.398647831613264
		 6 -7.3969778294112416 7 -7.3936716487260981 8 -7.3888634912585482 9 -7.3830541015268052
		 10 -7.3766643619087455 11 -7.370153115711366 12 -7.3638697597216067 13 -7.3595892488389385
		 14 -7.3586091370273179 15 -7.3606396268199541 16 -7.36537901259954 17 -7.3724415540255848
		 18 -7.3814478371762506 19 -7.3920353571155033 20 -7.4037075202967282 21 -7.4159658420949839
		 22 -7.4285620571854398 23 -7.4411900771853174 24 -7.4536328311284787 25 -7.4655643900737356
		 26 -7.4768516170787578 27 -7.4872758443936176 28 -7.496739536695455 29 -7.5050619115149662
		 30 -7.5122279577015103 31 -7.5181769470170847 32 -7.5229133335986234 33 -7.5263796355352932
		 34 -7.5286501553049412 35 -7.5297288202097477 36 -7.5297385934620022 37 -7.5286812571685955
		 38 -7.5267007514836708 39 -7.5238773989118162 40 -7.5203555817463119 41 -7.5162031704734229
		 42 -7.5113318761267571 43 -7.5055375955265795 44 -7.4987254424544796 45 -7.491179011851651
		 46 -7.4835490087487591 47 -7.475883946647861 48 -7.4682839428007588 49 -7.4608359205492567
		 50 -7.453610134535178 51 -7.4466119319732478 52 -7.4399436195583295 53 -7.4336425702243369
		 54 -7.4277776765332453 55 -7.4223229560387747 56 -7.4173931236174946 57 -7.4129518845729443
		 58 -7.408923411245059 59 -7.4053299905420813 60 -7.4021057584158836 61 -7.3992845349151661
		 62 -7.3969069461962142 63 -7.3949187107493577 64 -7.3933101985679812 65 -7.3919754116132372
		 66 -7.3909646981787294 67 -7.3901851650708226 68 -7.3897113996063188 69 -7.3895009827081291
		 70 -7.3894415849406112 71 -7.3894272673236809 72 -7.3894554693146306 73 -7.3895758305413386
		 74 -7.3897653901013669 75 -7.3900079457525241 76 -7.3904220214119638 77 -7.3910263209269109
		 78 -7.3917916350906001 79 -7.3928069155705893 80 -7.3941419589522983;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ";
	rename -uid "F3BF1871-43F0-4E45-77B2-FEB19F8A1F1B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 62.930980634383602 1 62.955462627295248
		 2 62.979699555088388 3 62.998555291307369 4 63.00711792201546 5 63.000651706177834
		 6 62.974520802566104 7 62.924010382240304 8 62.850339850745648 9 62.761747309142741
		 10 62.664689428656473 11 62.565601972440561 12 62.470822160120953 13 62.406353282961248
		 14 62.391577451710837 15 62.42214820176924 16 62.493519650539014 17 62.600381644739649
		 18 62.737424125086172 19 62.898997235461167 20 63.078108915893182 21 63.268030472408277
		 22 63.464163918269797 23 63.662194177004402 24 63.858073582530317 25 64.048043244474869
		 26 64.228643522224885 27 64.396681669564103 28 64.549537268762577 29 64.68523854954465
		 30 64.802459394847887 31 64.90021655624281 32 64.977914676991958 33 65.035460892490548
		 34 65.073017737347556 35 65.091193610352022 36 65.091048045612439 37 65.073823129499573
		 38 65.041000097059467 39 64.994348374862327 40 64.935812479209119 41 64.8673058532395
		 42 64.787715285310668 43 64.693250131024229 44 64.581794513442759 45 64.459702995073386
		 46 64.336316748859986 47 64.213191566323403 48 64.091619307079355 49 63.972831506139556
		 50 63.857798020229922 51 63.7473841187118 52 63.642435338193515 53 63.54357130813915
		 54 63.451499728343478 55 63.366776881320696 56 63.29004563894982 57 63.221032008500522
		 58 63.158919339779267 59 63.10327936526501 60 63.053540209058994 61 63.010341002131646
		 62 62.973850021998075 63 62.94341219203713 64 62.918382375822247 65 62.898171696979617
		 66 62.882506761475746 67 62.870983187794771 68 62.863526909068042 69 62.860164770836775
		 70 62.859248166216091 71 62.8591158809541 72 62.859788711502105 73 62.861400861635133
		 74 62.864154104126406 75 62.868430087583029 76 62.874667103835314 77 62.883397645978903
		 78 62.895236150268254 79 62.910855538009478 80 62.930980634383602;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX";
	rename -uid "8CAD383E-46BB-5C97-980C-9DA3F2610BF5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -9.7418046831765626 1 -10.148659959576248
		 2 -10.546475857056423 3 -10.934058084468665 4 -11.309979385641041 5 -11.672976728286852
		 6 -12.021699362276616 7 -12.354893101868726 8 -12.673468746916535 9 -12.981029647023306
		 10 -13.28018214481539 11 -13.573686015112962 12 -13.864119210326747 13 -14.161815827049674
		 14 -14.474331773890279 15 -14.799635305849042 16 -15.122431894021924 17 -15.429290594843764
		 18 -15.721309793156029 19 -15.999574174323536 20 -16.264958486818827 21 -16.518278992034972
		 22 -16.760391168700444 23 -16.992072945051142 24 -17.214012470559833 25 -17.426757794345974
		 26 -17.630906192140877 27 -17.826790940474538 28 -18.014770171003523 29 -18.194852876293893
		 30 -18.366905147330286 31 -18.53086178526808 32 -18.686654208597012 33 -18.834128193411729
		 34 -18.973196389350537 35 -19.103750539330242 36 -19.225789422767146 37 -19.339327139072051
		 38 -19.444396499720039 39 -19.541117712894835 40 -19.629714787323508 41 -19.710423835146553
		 42 -19.783054803703997 43 -19.846824190149302 44 -19.901224834872835 45 -19.922970706919902
		 46 -19.892438152174389 47 -19.814307986152002 48 -19.693322037126627 49 -19.534225676999615
		 50 -19.34176133882503 51 -19.057477653889123 52 -18.631934396607566 53 -18.082583080332512
		 54 -17.426055167893413 55 -16.678669167499947 56 -15.856818165239249 57 -14.977095710280269
		 58 -14.05664797903499 59 -13.113525691346108 60 -12.166661846372609 61 -11.236053542789367
		 62 -10.342856155672852 63 -9.4978183921951924 64 -8.7092108807156254 65 -7.9953910127119254
		 66 -7.3749461518764177 67 -6.8664879803119829 68 -6.4880163490195697 69 -6.2562567139693686
		 70 -6.1878349952214027 71 -6.2676599516089748 72 -6.4569218419867518 73 -6.7365817005930984
		 74 -7.0880087734827661 75 -7.4930441092962576 76 -7.9343495220984881 77 -8.3953665638284161
		 78 -8.8602308179178362 79 -9.313890394940076 80 -9.7418046831765626;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY";
	rename -uid "E8411F43-49E9-DEA9-0C82-C7966C8E3618";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.577661590064899 1 18.772991872038642
		 2 18.93636852424121 3 19.069438788782563 4 19.173734293371844 5 19.251076421134705
		 6 19.303403428628371 7 19.332672891916225 8 19.341913846483013 9 19.335301351977392
		 10 19.316555683113272 11 19.289560311698622 12 19.258014963162058 13 19.221977514052405
		 14 19.182482147087047 15 19.144551407234118 16 19.115538831041764 17 19.10262724561251
		 18 19.104485999411594 19 19.115548775225623 20 19.134139798949313 21 19.158655892529339
		 22 19.187793578446438 23 19.220275783375243 24 19.254846301036032 25 19.290300692458207
		 26 19.325601728821105 27 19.359673918652355 28 19.391638763623366 29 19.421075695089847
		 30 19.447716353628788 31 19.471301156957434 32 19.491759256116641 33 19.508947146175494
		 34 19.522953108661074 35 19.533711947401059 36 19.541348656971664 37 19.5459516662875
		 38 19.547633098568514 39 19.546524630396444 40 19.542809404684125 41 19.536492543916044
		 42 19.527352339394042 43 19.514923093304823 44 19.49912984868315 45 19.479296884546962
		 46 19.452818894541711 47 19.416357939142102 48 19.370168349560039 49 19.315921924276036
		 50 19.255182357606163 51 19.171352663986752 52 19.050390677874955 53 18.897078487661101
		 54 18.71593625599176 55 18.511107865260161 56 18.286781511805934 57 18.046959062709728
		 58 17.795757296453704 59 17.537631114837474 60 17.277315520332479 61 17.020029564974529
		 62 16.771566485398292 63 16.539993529583576 64 16.33438615934374 65 16.162964818622402
		 66 16.034369730720964 67 15.95781127105786 68 15.943004110282569 69 15.991500800438244
		 70 16.101422911051749 71 16.266279421648694 72 16.471516062143863 73 16.709381476101477
		 74 16.971676065353947 75 17.249916828574221 76 17.535560032197271 77 17.819876984838682
		 78 18.094101846707154 79 18.349577578043508 80 18.577661590064899;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ";
	rename -uid "F6653AD9-4677-15EE-FA00-F2A59F3AE55A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -12.363619147181401 1 -12.281205144860877
		 2 -12.251962272948591 3 -12.268030758233044 4 -12.32149223519221 5 -12.404692757984714
		 6 -12.509920706855249 7 -12.629594220576529 8 -12.759958319502017 9 -12.902024274817903
		 10 -13.055376309898005 11 -13.219872699048677 12 -13.395157466943818 13 -13.604143416486652
		 14 -13.861785506427722 15 -14.155516651421861 16 -14.472064220017026 17 -14.797995759009712
		 18 -15.130409468223991 19 -15.472477261991347 20 -15.820568755842061 21 -16.171065073490944
		 22 -16.521180922740445 23 -16.868209365220039 24 -17.209551356685981 25 -17.542540420879988
		 26 -17.864716598804787 27 -18.173515523018715 28 -18.466765543723795 29 -18.74281391057275
		 30 -19.000235620670271 31 -19.237816516953409 32 -19.454598749358677 33 -19.649658219741909
		 34 -19.822416836017581 35 -19.972432156305953 36 -20.099520681643686 37 -20.203628092698558
		 38 -20.284881954255635 39 -20.343518580307475 40 -20.380047537709199 41 -20.394934270089252
		 42 -20.387043234069516 43 -20.35346787777873 44 -20.292131079292378 45 -20.213968964918646
		 46 -20.13514810371516 47 -20.06034050088827 48 -19.989982311416014 49 -19.922919742693672
		 50 -19.857912848838041 51 -19.778339706423633 52 -19.670141732736685 53 -19.5356168043654
		 54 -19.377055297279075 55 -19.196494486279722 56 -18.996002385329696 57 -18.777023306655146
		 58 -18.540791598271039 59 -18.288579890726794 60 -18.021595288179661 61 -17.741305197680163
		 62 -17.448967226815252 63 -17.144505972628004 64 -16.827133289366376 65 -16.49682291763801
		 66 -16.153249441641286 67 -15.796102635380331 68 -15.425086687169275 69 -15.055398830574235
		 70 -14.705619344267737 71 -14.375935597909972 72 -14.064050245917066 73 -13.771304174589181
		 74 -13.499158505644735 75 -13.248807630917538 76 -13.021577818065712 77 -12.818500823405472
		 78 -12.640579058581347 79 -12.488744319915201 80 -12.363619147181401;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX";
	rename -uid "79ECF4CB-4FBB-3B57-3714-9089DBAD3F4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 19.074613769875452 1 18.93918945448819
		 2 18.796917128927642 3 18.649253093613847 4 18.497766056389381 5 18.344503934793881
		 6 18.191665072377681 7 18.041526806302485 8 17.899167611151835 9 17.772865714907319
		 10 17.669882798862705 11 17.597319569731305 12 17.562358413904494 13 17.585857164816655
		 14 17.68241455838201 15 17.847925339232084 16 18.07635762675395 17 18.362916195139466
		 18 18.702652493297279 19 19.090756651715616 20 19.522291431781586 21 19.992296061782863
		 22 20.495836116440394 23 21.027878818014035 24 21.583332408651188 25 22.157130911054395
		 26 22.743357685490071 27 23.336226832739253 28 23.930638997976331 29 24.520739319898365
		 30 25.100500701683359 31 25.663761398179247 32 26.200008810535511 33 26.698762238726346
		 34 27.15459481067202 35 27.561581569921408 36 27.914071084850605 37 28.206370875088805
		 38 28.432858043583643 39 28.58809252012064 40 28.666872318383728 41 28.669487548776967
		 42 28.602817971684352 43 28.471269072489182 44 28.280945170257056 45 28.035569522320099
		 46 27.73939270538175 47 27.397868002331141 48 27.016884923354851 49 26.602441275811181
		 50 26.16074507653137 51 25.698149031077751 52 25.221113902107525 53 24.736185012829829
		 54 24.249766570417219 55 23.768432599858286 56 23.298430978601012 57 22.845976438858443
		 58 22.414456468095569 59 22.006183456480766 60 21.624978343895041 61 21.27450625765179
		 62 20.951018122030334 63 20.64876322071958 64 20.368093692836716 65 20.105890549851765
		 66 19.859778568071956 67 19.631330761977861 68 19.424499320175997 69 19.241947564709506
		 70 19.084957172873661 71 18.955115107081426 72 18.852699856398377 73 18.778079592616887
		 74 18.731699526716103 75 18.71400270134875 76 18.725512749199865 77 18.7667920803583
		 78 18.838340175673302 79 18.940800345332413 80 19.074613769875452;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY";
	rename -uid "256959EA-4FF1-DD06-44E4-19B5F146C907";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 13.140750261756999 1 13.279430158897625
		 2 13.426515644895899 3 13.574745671796343 4 13.717020449842863 5 13.846468681911331
		 6 13.956400926622255 7 14.040323108269879 8 14.097686647221765 9 14.135590637499215
		 10 14.158953065813703 11 14.172565643370113 12 14.181187626512314 13 14.194394362083665
		 14 14.219423701543219 15 14.256416209376081 16 14.30421894544854 17 14.362436880425586
		 18 14.430648604684322 19 14.508386558645633 20 14.594949658820298 21 14.689664043664633
		 22 14.792207038952343 23 14.902026786080738 24 15.018663440131611 25 15.141418440282113
		 26 15.260191329994736 27 15.364866272198265 28 15.454621433109685 29 15.528837260735697
		 30 15.587016176055482 31 15.628828366185562 32 15.654694889147496 33 15.666209041139574
		 34 15.662962896969439 35 15.645539841935609 36 15.614471454587724 37 15.570364199190745
		 38 15.513906390412313 39 15.445948013889417 40 15.367112917095428 41 15.258334972954957
		 42 15.101554246736947 43 14.90287012310591 44 14.670997111304915 45 14.410203428388915
		 46 14.125470687487788 47 13.824781021051109 48 13.515581160888045 49 13.20467178148624
		 50 12.89848694214677 51 12.602673764005131 52 12.322498242401588 53 12.062753547511322
		 54 11.827867908598352 55 11.621899579758145 56 11.44882842950901 57 11.312216279380326
		 58 11.207750630836539 59 11.128368517847381 60 11.073539792630527 61 11.042690097406581
		 62 11.033461750001941 63 11.043218227331435 64 11.070972767578789 65 11.113278613684663
		 66 11.167304866451779 67 11.233116406229707 68 11.310527058520702 69 11.399612074675183
		 70 11.500351886485848 71 11.612844313917886 72 11.737003191497026 73 11.872868877450587
		 74 12.020274696345282 75 12.179152203120667 76 12.349337607038256 77 12.530687785431796
		 78 12.723046024482384 79 12.926412736442096 80 13.140750261756999;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ";
	rename -uid "E2CABCC8-4740-48AE-A407-2EB9CF58DDEF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 54.15307408480556 1 54.004144308057363
		 2 53.848925662461646 3 53.694646269235903 4 53.548638525752821 5 53.418314262423891
		 6 53.311216924031264 7 53.234963317824509 8 53.191580223673718 9 53.176005197858764
		 10 53.185090508568685 11 53.215658861441696 12 53.264372808874036 13 53.331334249658212
		 14 53.41465741971146 15 53.51133086595901 16 53.620836276733165 17 53.741113994408039
		 18 53.87010070581708 19 54.005907097899026 20 54.14695230570856 21 54.291725205214128
		 22 54.438438003027279 23 54.585514120936985 24 54.73164270971305 25 54.875559815492494
		 26 55.026201193715096 27 55.192088682478435 28 55.371327835791256 29 55.561441321107289
		 30 55.759648307813869 31 55.963213655619676 32 56.163223081628821 33 56.350457754212165
		 34 56.524232265737773 35 56.682482714924149 36 56.823602024514095 37 56.945929113883416
		 38 57.047663568846673 39 57.127151369582975 40 57.182929225020644 41 57.23372843852583
		 42 57.300426800163748 43 57.378520966880018 44 57.460794305515975 45 57.545101539893011
		 46 57.628886372563372 47 57.707890280618649 48 57.778444644358586 49 57.837029533321299
		 50 57.880729740915122 51 57.906804601479806 52 57.912880804720182 53 57.896934141178846
		 54 57.856993172891713 55 57.791384607750942 56 57.698548444756611 57 57.577009798828115
		 58 57.432477965774389 59 57.273284949133867 60 57.102019561736668 61 56.92155788734074
		 62 56.733246916797547 63 56.537901962339781 64 56.337267868505648 65 56.139131015940002
		 66 55.949768593486304 67 55.769170294433444 68 55.600892566387984 69 55.446399811512045
		 70 55.304758663154928 71 55.175508302364513 72 55.055971985713171 73 54.94366763636814
		 74 54.836008277270459 75 54.730580418211467 76 54.624935671458616 77 54.51675366962197
		 78 54.40357542477382 79 54.283176753509707 80 54.15307408480556;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX";
	rename -uid "6E2B14EB-404D-8E05-190B-009B59F05607";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.8784285254330015 1 -3.8733211653336599
		 2 -3.8627968630273055 3 -3.8474673819772853 4 -3.8278563330415016 5 -3.8045054407528327
		 6 -3.7778774416573837 7 -3.7484304735688152 8 -3.7163541553924686 9 -3.6813949206231893
		 10 -3.6434662913470297 11 -3.6025158157482009 12 -3.5584999082908495 13 -3.5103360194468798
		 14 -3.4576157511087464 15 -3.4006934406626299 16 -3.3400534433776636 17 -3.27612074878712
		 18 -3.209338849972323 19 -3.1402505649826922 20 -3.0693417732264088 21 -2.9972198015745342
		 22 -2.9243058385701506 23 -2.8510319424753758 24 -2.7778582634711957 25 -2.7052907568439903
		 26 -2.6370756958808887 27 -2.5766605606071291 28 -2.5240908781338303 29 -2.4792251276915263
		 30 -2.4419730777419018 31 -2.4120955279112515 32 -2.3885898502358938 33 -2.370201373039027
		 34 -2.3571120061045479 35 -2.3493034612863544 36 -2.3465784717592553 37 -2.3488955735819301
		 38 -2.3562436687322164 39 -2.368476956401445 40 -2.3856274103704806 41 -2.4137974480512678
		 42 -2.458596854832054 43 -2.5182390695785775 44 -2.5908051834927019 45 -2.67393006064317
		 46 -2.7653493311863193 47 -2.8630151922378992 48 -2.9649285079436742 49 -3.0691520952533367
		 50 -3.1737764909601713 51 -3.2769931241538068 52 -3.3770257168431641 53 -3.4720461359309205
		 54 -3.5604842001964805 55 -3.6406095900625592 56 -3.7108815596373272 57 -3.7696775405853522
		 58 -3.8185228555559889 59 -3.8599364816495849 60 -3.8942613511471014 61 -3.9216521087397815
		 62 -3.9428282419048744 63 -3.958714944593281 64 -3.9697798539028875 65 -3.9761075510696031
		 66 -3.9779691095586771 67 -3.9759543598895504 68 -3.9714105812774032 69 -3.9651641605852075
		 70 -3.9577136759255107 71 -3.9496223929755292 72 -3.9411008835755088 73 -3.9323030360286482
		 74 -3.9234419325792915 75 -3.9146721256361543 76 -3.9062072924559863 77 -3.8981694770798101
		 78 -3.8908048712460643 79 -3.8841957248624972 80 -3.8784285254330015;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY";
	rename -uid "9504712A-4DB6-116D-204C-A4A924C597BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.3466047216384167 1 -6.3434151184484087
		 2 -6.3368243563596636 3 -6.3271992696922039 4 -6.3148076273493698 5 -6.2999278014910214
		 6 -6.2828481214134655 7 -6.2638278136846708 8 -6.2428579435883549 9 -6.219778170931594
		 10 -6.1944562900350633 11 -6.1667613108986128 12 -6.1366084565478012 13 -6.1031305174844759
		 14 -6.0658901218956318 15 -6.0250204011043573 16 -5.9806164548159924 17 -5.9328925707444276
		 18 -5.8820231618106114 19 -5.8282571406239034 20 -5.7718468714748967 21 -5.7131302484838775
		 22 -5.6524010496092965 23 -5.5899266497707378 24 -5.5260583215730854 25 -5.4611746944502384
		 26 -5.3987645103059529 27 -5.3423034727691654 28 -5.2922175029745659 29 -5.2488200865887871
		 30 -5.2122392171955827 31 -5.1826142680207781 32 -5.1590559981112785 33 -5.1404940537251917
		 34 -5.1272309128760458 35 -5.1192868309497364 36 -5.1165077464900612 37 -5.1188849400217231
		 38 -5.1263594705758981 39 -5.1387702665893364 40 -5.1560626698932177 41 -5.1842803556939971
		 42 -5.2286333326527323 43 -5.2866216810374773 44 -5.3556082852711242 45 -5.4326652157037589
		 46 -5.5149459471644784 47 -5.6002373703141428 48 -5.6864182458636332 49 -5.7716879634235596
		 50 -5.8544880171219837 51 -5.9335564331073609 52 -6.0077707275573911 53 -6.0761367843548433
		 54 -6.1379682281048273 55 -6.1925322014881488 56 -6.2392621938973098 57 -6.2775955224167861
		 58 -6.3088703050599664 59 -6.3350397897339272 60 -6.3564441650068044 61 -6.373378413450256
		 62 -6.3863797679135619 63 -6.3960487103133685 64 -6.4027529189791386 65 -6.4066067008464174
		 66 -6.4077290119126316 67 -6.4065135616151947 68 -6.4037598588804752 69 -6.3999730529563017
		 70 -6.39546005179474 71 -6.3905086827397097 72 -6.385308191633901 73 -6.3799395566547972
		 74 -6.374467390322593 75 -6.3690761382930008 76 -6.3638540984240635 77 -6.3588965637599282
		 78 -6.3543389607108978 79 -6.3501863140035608 80 -6.3466047216384167;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ";
	rename -uid "A88A9674-477D-B5D2-B998-1EB13F133D0D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.942247258386068 1 52.900806244239185
		 2 52.815242053671348 3 52.690247411282172 4 52.530234617839149 5 52.339223434249661
		 6 52.120996260742025 7 51.879200903913549 8 51.614773537297964 9 51.325775955975196
		 10 51.011225744178127 11 50.670231039698095 12 50.302078151394568 13 49.897882351619678
		 14 49.45236872935061 15 48.969252794026936 16 48.45100991727989 17 47.900868562039413
		 18 47.322220509790526 19 46.718497793019289 20 46.093991265645172 21 45.452919412456396
		 22 44.798775341524589 23 44.135182988219299 24 43.466030689790543 25 42.795282272721899
		 26 42.158152619624786 27 41.588697637507501 28 41.088741292908765 29 40.658923522759011
		 30 40.299257914195863 31 40.009502466093927 32 39.780463074515019 33 39.600459305216226
		 34 39.472402172072655 35 39.395230909006123 36 39.368590736904672 37 39.39179561806904
		 38 39.463946460506435 39 39.583910326008166 40 39.75144136079939 41 40.026004602438938
		 42 40.460032995673686 43 41.032987566289037 44 41.722703726226719 45 42.503325293919374
		 46 43.35074079718666 47 44.244085941933591 48 45.163885785509763 49 46.092108593095674
		 50 47.012105016526199 51 47.908511203080558 52 48.767108338594412 53 49.574681761381399
		 54 50.318767986025712 55 50.987539206492755 56 51.569549427757096 57 52.05385953920652
		 58 52.453907062439328 59 52.792009132238299 60 53.070924888099682 61 53.293107484117037
		 62 53.464683953266977 63 53.593043801090069 64 53.682192361664818 65 53.733302297911536
		 66 53.748229126328852 67 53.732218592367374 68 53.695387549192837 69 53.644953123111144
		 70 53.584803609451896 71 53.519517883267582 72 53.450537034135451 73 53.379373751644387
		 74 53.307599951530001 75 53.236615688327021 76 53.167972477216935 77 53.102985733154711
		 78 53.042953363654547 79 52.989066883703899 80 52.942247258386068;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX";
	rename -uid "904896FB-49C4-F615-191F-8EAD8177B528";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 75.362643873534537 1 75.561149744908491
		 2 75.766451585753458 3 75.967393129172208 4 76.152536963465295 5 76.310864473535034
		 6 76.431317423581163 7 76.503153301092738 8 76.525116920184644 9 76.508104978022644
		 10 76.459623554036611 11 76.387152171140727 12 76.298504274380647 13 76.21562006031354
		 14 76.154178721118768 15 76.11311918816412 16 76.092300311209343 17 76.091104473193681
		 18 76.108783481457905 19 76.144647576747118 20 76.197446656790817 21 76.265905030860367
		 22 76.349278955455219 23 76.446572652313037 24 76.556455690649514 25 76.677529017364904
		 26 76.805889456697656 27 76.937827093159626 28 77.071505265175986 29 77.204374589870241
		 30 77.333600811662805 31 77.456142613337789 32 77.563940226734431 33 77.648947989703132
		 34 77.709073288293183 35 77.741864310959457 36 77.74488458536662 37 77.715852068747282
		 38 77.652467228837551 39 77.552755419758284 40 77.414892681711081 41 77.23931456642643
		 42 77.03073619473362 43 76.789090640968638 44 76.516192901269974 45 76.212892857741878
		 46 75.880798231748372 47 75.525333660586156 48 75.152049666042387 49 74.766450260280038
		 50 74.374309313322527 51 73.981451923619957 52 73.593730665291162 53 73.217052767595789
		 54 72.857389776853239 55 72.520698824508699 56 72.21301694472649 57 71.940044571319405
		 58 71.70386917559216 59 71.505333487711781 60 71.347452597049084 61 71.233266138760655
		 62 71.158664931762289 63 71.117595445688167 64 71.110100321825129 65 71.137631442619352
		 66 71.201308227201281 67 71.300549785413054 68 71.438032426252704 69 71.614456089794814
		 70 71.828298314145314 71 72.07819432244159 72 72.360960501915329 73 72.672973579744209
		 74 73.010687133183538 75 73.3704584628871 76 73.748412748619501 77 74.140670076819831
		 78 74.543197529870596 79 74.951886402733905 80 75.362643873534537;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY";
	rename -uid "BD8888D7-444F-15FE-5C70-EDA01A00B54A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 55.849253617437533 1 55.909755796741102
		 2 55.964969127404117 3 56.011513743855197 4 56.046364414438713 5 56.066407877114294
		 6 56.068566711859376 7 56.049845610790797 8 56.008725755055941 9 55.946102316338703
		 10 55.862007166206538 11 55.756488786194168 12 55.629482286685239 13 55.481944366324186
		 14 55.314695933983266 15 55.128760398829122 16 54.926117509831165 17 54.708339320548546
		 18 54.476906070664882 19 54.233292904235611 20 53.978702908524433 21 53.714401208844173
		 22 53.442009177401538 23 53.16315993076482 24 52.879526022469932 25 52.59256926939117
		 26 52.30488907159841 27 52.018518373910389 28 51.734589243958233 29 51.454198890380894
		 30 51.178688243733419 31 50.909251339147154 32 50.649888260404218 33 50.404330526967605
		 34 50.172990598073611 35 49.956387009481475 36 49.755028103676239 37 49.569422532681372
		 38 49.4000760719684 39 49.247476711094158 40 49.11229107038811 41 48.998772425690518
		 42 48.910837778765668 43 48.846888395144006 44 48.805974635147791 45 48.79013104677513
		 46 48.800910955663966 47 48.837902192241565 48 48.900489377693852 49 48.988104453127889
		 50 49.099801377658864 51 49.234662682391537 52 49.391534425578961 53 49.569012440443757
		 54 49.765558860710541 55 49.979529316364555 56 50.208919015105081 57 50.451590670204553
		 58 50.706623019788012 59 50.973906184996679 60 51.251983107459203 61 51.539361705436775
		 62 51.833253575640448 63 52.130474943318426 64 52.42881994765937 65 52.728493944421515
		 66 53.029123570108808 67 53.327731419025881 68 53.619960911689844 69 53.902320715318339
		 70 54.172347266060839 71 54.427579064090487 72 54.66650268365251 73 54.887718854698022
		 74 55.089960554525184 75 55.272116577519093 76 55.433117689633733 77 55.572022938331095
		 78 55.688123516288144 79 55.780679336516371 80 55.849253617437533;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ";
	rename -uid "15C9B504-4BEB-B889-E6F4-5DB4F68A938D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -49.658790052194092 1 -49.385914018359628
		 2 -49.091087707973102 3 -48.787584238730105 4 -48.488789060277604 5 -48.207480864653412
		 6 -47.956346026023382 7 -47.747857359766471 8 -47.584084875360077 9 -47.454637720115933
		 10 -47.352574330433789 11 -47.271266163835399 12 -47.203867876172424 13 -47.125486203674519
		 14 -47.019743906608952 15 -46.889711778997366 16 -46.735897166138074 17 -46.560384857235668
		 18 -46.365544274465364 19 -46.153580907744463 20 -45.928056347310971 21 -45.692363895964625
		 22 -45.448372952268706 23 -45.198023179479208 24 -44.943669716477565 25 -44.687574853708959
		 26 -44.452483429471727 27 -44.259654785946708 28 -44.109984956888212 29 -44.004071787020379
		 30 -43.942493472954759 31 -43.92568247430593 32 -43.954907463932571 33 -44.029482082070281
		 34 -44.15039158381407 35 -44.316438115096581 36 -44.526891039507554 37 -44.780836041102049
		 38 -45.077162295767344 39 -45.414452075962046 40 -45.791942162994872 41 -46.241308709593859
		 42 -46.787522086905277 43 -47.419571097891954 44 -48.124344350979676 45 -48.88219567152418
		 46 -49.67537053772871 47 -50.489247344120201 48 -51.309795913472868 49 -52.1238660155811
		 50 -52.918618224754795 51 -53.681992618497112 52 -54.402288942513565 53 -55.068091142738247
		 54 -55.668253021625802 55 -56.191714417497472 56 -56.627456399484686 57 -56.964931063172216
		 58 -57.211308586891946 59 -57.379914959786618 60 -57.470734242717036 61 -57.483096177570332
		 62 -57.425003104189138 63 -57.307079471958261 64 -57.132847290390636 65 -56.900294237968239
		 66 -56.608819077933099 67 -56.263930388185571 68 -55.870043241158974 69 -55.432405919887273
		 70 -54.95702716586888 71 -54.45014009069515 72 -53.918534721737359 73 -53.369443411873114
		 74 -52.810105932739127 75 -52.247883868935972 76 -51.690325085204357 77 -51.144956710149934
		 78 -50.619445984004393 79 -50.121528413444949 80 -49.658790052194092;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAX";
	rename -uid "0DE318F9-4F8E-78E8-1EAC-A48C952523C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.8183795147516344 1 -2.8243923340738846
		 2 -2.8304317430218755 3 -2.8365057236203222 4 -2.8423672497486687 5 -2.8479680797013436
		 6 -2.8530959065021553 7 -2.8576982974120093 8 -2.8616375722290988 9 -2.8649624433631433
		 10 -2.8676764022644585 11 -2.8698538643608154 12 -2.8714993465865213 13 -2.8726754834960611
		 14 -2.8735039949545151 15 -2.8739700103010879 16 -2.8742496294459814 17 -2.874362250126751
		 18 -2.8743506281939672 19 -2.8743663539231927 20 -2.8742666773088681 21 -2.8741248973470017
		 22 -2.8739975870514058 23 -2.873944194674356 24 -2.8740892008427026 25 -2.8744637268435338
		 26 -2.8751083807063309 27 -2.8759885096780762 28 -2.8771558713318677 29 -2.878566882029661
		 30 -2.8801644631665706 31 -2.8819398923250428 32 -2.8837749366491425 33 -2.8856478373311787
		 34 -2.8874049582089332 35 -2.8889518424968506 36 -2.8902183700948751 37 -2.8910157648584076
		 38 -2.891284407347924 39 -2.8908780879717826 40 -2.8896810114402482 41 -2.8875785252571968
		 42 -2.8845639115542538 43 -2.8806519086961617 44 -2.8759778217801384 45 -2.8705512633347228
		 46 -2.8645171918794787 47 -2.8578445640821251 48 -2.8507024132899978 49 -2.8432121924376403
		 50 -2.835457661942697 51 -2.8275493780794703 52 -2.8195814706181519 53 -2.8117291749095066
		 54 -2.8041061712652113 55 -2.7967687088500508 56 -2.789948657028464 57 -2.7836603817478776
		 58 -2.7779332087396305 59 -2.7728687652676332 60 -2.76842192448122 61 -2.76468740089806
		 62 -2.7617274511178036 63 -2.759503370147832 64 -2.7580570359072114 65 -2.7573605074797629
		 66 -2.7574474778909082 67 -2.75833793665339 68 -2.7599632773182647 69 -2.7622632976965855
		 70 -2.7652706467010915 71 -2.7688867994993038 72 -2.7730869372759632 73 -2.7777976014005672
		 74 -2.7829512152621034 75 -2.7884630295588626 76 -2.794250304081396 77 -2.8002447155691135
		 78 -2.806316985423309 79 -2.8123969907956137 80 -2.8183795147516344;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAY";
	rename -uid "B4CC7FAE-4099-2F11-139D-3382BE632B9C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.1104971418800194 1 5.1355619289885359
		 2 5.1596794310679339 3 5.1817889546095186 4 5.2008016123457494 5 5.2157571496947819
		 6 5.2255819296819777 7 5.2293621609104983 8 5.2266226023515374 9 5.2180377172396364
		 10 5.2039375492874633 11 5.1846648683121757 12 5.1605421250012382 13 5.131903232453122
		 14 5.0991020912883931 15 5.0624696820105637 16 5.0223526760942523 17 4.979104964906889
		 18 4.9329833940941477 19 4.8844485795695878 20 4.8337580320947371 21 4.7813204308611237
		 22 4.7274282163358743 23 4.6724237362992218 24 4.6167277982478927 25 4.5606374145375579
		 26 4.5045555075953532 27 4.4487686330421949 28 4.3936388620229971 29 4.3396283676070002
		 30 4.2869262817230922 31 4.2359441369515007 32 4.1870321470791465 33 4.1405726570811314
		 34 4.0967547953378673 35 4.0560484853524335 36 4.0187351284531418 37 3.9851200337291361
		 38 3.9555230651177831 39 3.9303356079874066 40 3.9098383469328888 41 3.8943192305059893
		 42 3.8837265838561361 43 3.8777891183439288 44 3.8761078275876804 45 3.8786711949969184
		 46 3.8851373821400408 47 3.8953947414070615 48 3.9092682705535058 49 3.9265559191138504
		 50 3.9470543740475432 51 3.9706615876538063 52 3.9970566771801783 53 4.0261768845301589
		 54 4.0577781988020805 55 4.0916101365128119 56 4.1276661032969013 57 4.1656363908575216
		 58 4.2053659638825502 59 4.2466614782180079 60 4.2892364166927281 61 4.3330101640201226
		 62 4.3777235876866847 63 4.4232027154111151 64 4.4692061284153892 65 4.5155197706455228
		 66 4.5620188162612374 67 4.6084278754744599 68 4.6545834256731347 69 4.700176587161935
		 70 4.7451200057990874 71 4.7891773119501728 72 4.8320914490534141 73 4.8736748435023687
		 74 4.9137610839353156 75 4.9520636019560023 76 4.9884365666846362 77 5.0226909183323674
		 78 5.054559702145105 79 5.0839151341567517 80 5.1104971418800194;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAZ";
	rename -uid "F5B69EF2-4C2A-D292-4785-C38AA9230756";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.38736218029522645 1 0.058086792006573684
		 2 -0.25936094251704284 3 -0.55255669096464544 4 -0.80904496276661952 5 -1.0164167385034257
		 6 -1.1622207375840363 7 -1.2340256454689964 8 -1.2278639698445792 9 -1.1506857737478626
		 10 -1.0063161508797223 11 -0.79868160766291729 12 -0.53162160903814626 13 -0.20903256814183957
		 14 0.16520089339027622 15 0.58720601310045506 16 1.053111255962746 17 1.5590185214528114
		 18 2.1010532393401644 19 2.6753447183224099 20 3.2786946353701794 21 3.907596076963201
		 22 4.55771317286308 23 5.2246820257938795 24 5.9041806691291354 25 6.5918569525471069
		 26 7.2833776320036963 27 7.9744052695704211 28 8.660619291490546 29 9.3376789312734587
		 30 10.001244362581904 31 10.646974142127577 32 11.270557779454014 33 11.867676617774752
		 34 12.433957244390189 35 12.965102240561336 36 13.456771875468565 37 13.904670098951335
		 38 14.30441981506663 39 14.651696379688692 40 14.942187701806821 41 15.171559795346228
		 42 15.340032353862842 43 15.452098915011314 44 15.509842076380277 45 15.515341441221317
		 46 15.470669976381851 47 15.377938214802205 48 15.239213495451645 49 15.056595067047615
		 50 14.832144862831107 51 14.567950469599458 52 14.266114199607816 53 13.928695981478082
		 54 13.55778145877253 55 13.155462896803312 56 12.723800374169048 57 12.265236592161893
		 58 11.78258251446618 59 11.278455836276279 60 10.755470954532274 61 10.216289220415216
		 62 9.6634883101667999 63 9.0997197567272874 64 8.5276412221824813 65 7.9498359639578693
		 66 7.3689605131671057 67 6.7876266088664554 68 6.2084758465236174 69 5.6341254572074302
		 70 5.0672484937707631 71 4.5104407483534601 72 3.9663367787534876 73 3.4375792589477703
		 74 2.9267895468179672 75 2.4366320637570147 76 1.9697289556493502 77 1.5287172459525662
		 78 1.1162275209826824 79 0.73488808071786738 80 0.38736218029522645;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX";
	rename -uid "2E7F8D45-442C-478F-2A20-E090AB7D431D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 9.1840395930213834 1 9.2478711520281678
		 2 9.3138356718899153 3 9.3816085960823639 4 9.4508610709211229 5 9.5211933471203984
		 6 9.5923069060971073 7 9.6638609500814709 8 9.7354091446965896 9 9.8067270747870854
		 10 9.8773925144181476 11 9.947097131375898 12 10.015473513887349 13 10.082183088807882
		 14 10.146886332320925 15 10.20926854550361 16 10.268932051304485 17 10.325571992066585
		 18 10.378830576928957 19 10.428364352159655 20 10.473833856359766 21 10.514978089915479
		 22 10.551401360981345 23 10.582742345616104 24 10.608584491416529 25 10.628521828857869
		 26 10.642191525235139 27 10.649151821490996 28 10.649134176529737 29 10.642384889879031
		 30 10.629236134785392 31 10.610023246004765 32 10.585091353998386 33 10.554799713670748
		 34 10.519432231346379 35 10.479414274450624 36 10.43501445669979 37 10.386586747113855
		 38 10.334512619440517 39 10.279106713580934 40 10.220725453912992 41 10.159682993776721
		 42 10.096334251319213 43 10.031064938065795 44 9.9641478896402074 45 9.8959569964856939
		 46 9.8268640317661458 47 9.7571944341614536 48 9.6872960753027559 49 9.6175308605791106
		 50 9.5482242997673641 51 9.479747423736125 52 9.4124633613039865 53 9.3466492201212876
		 54 9.2827031215344018 55 9.221020403269593 56 9.1618918907714484 57 9.1056707729471427
		 58 9.0527595018747338 59 9.0034801273002785 60 8.9581729576577835 61 8.9170070003653858
		 62 8.8802498742355009 63 8.8483997650145714 64 8.8218559010821576 65 8.8010889299754513
		 66 8.7865828594494388 67 8.7787448383953706 68 8.7780488448323961 69 8.7849477958891899
		 70 8.7980408518858724 71 8.8156221625624926 72 8.8377216660283882 73 8.8644469994041746
		 74 8.8958104293819087 75 8.9318493662177705 76 8.9726396102484856 77 9.0181843724143391
		 78 9.068582215684442 79 9.1238454448255464 80 9.1840395930213834;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY";
	rename -uid "C46C2405-4028-102B-12DA-688A1702665B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.010426873067906442 1 0.018021724659246723
		 2 0.025983613583854696 3 0.034193672536024844 4 0.042647451505287995 5 0.051297595192315089
		 6 0.060124403576364872 7 0.069061803639361638 8 0.078078441029689249 9 0.087130623826179282
		 10 0.0961261953741539 11 0.1050757370063794 12 0.11388440376882347 13 0.12249957341093785
		 14 0.13088114692155375 15 0.13892641947431394 16 0.14660966816072982 17 0.15381404074898705
		 18 0.1605504931147875 19 0.16672689121413772 20 0.17225056041763764 21 0.17705463728604248
		 22 0.18107892297300543 23 0.18424985979520969 24 0.18657650128597653 25 0.18796387697348274
		 26 0.18838816602732694 27 0.1877731887250044 28 0.1861592000869805 29 0.18357940815332913
		 30 0.18006301931387728 31 0.17573400842169487 32 0.17055085112100926 33 0.1646486440642729
		 34 0.15813766751583433 35 0.15098399753798805 36 0.14330767785000065 37 0.13523367907783931
		 38 0.12675781181267617 39 0.11793893089861207 40 0.10884362260990073 41 0.099609493017325704
		 42 0.09024012080597682 43 0.080747736874642304 44 0.071286929169689373 45 0.061846449175318667
		 46 0.052496864473593037 47 0.043317442815766161 48 0.034291400036089846 49 0.025501584771063849
		 50 0.017021240069355629 51 0.0088223611915477264 52 0.00099488143782949963 53 -0.0064543967636488805
		 54 -0.013471362373563375 55 -0.020030447349384351 56 -0.026102156124540806 57 -0.03165724139133206
		 58 -0.036697939071247077 59 -0.04117414254604547 60 -0.045057296198065165 61 -0.048245501500340293
		 62 -0.050741422137738017 63 -0.05250334887242477 64 -0.053572293047221324 65 -0.053913119309217855
		 66 -0.053563579201721175 67 -0.052441328342120799 68 -0.050609187219566032 69 -0.048037777084334994
		 70 -0.044831151250615951 71 -0.041168060894218338 72 -0.037087526413890598 73 -0.032534227278289085
		 74 -0.027597967026676943 75 -0.022250528990293419 76 -0.016456956515821949 77 -0.010309303081625197
		 78 -0.0037931760024769723 79 0.0031429259502416991 80 0.010426873067906441;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ";
	rename -uid "B99D5D62-4D66-1CA5-4648-F8A0E14D7DE6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.5486968106674328 1 2.5023475079760247
		 2 2.4547891456442441 3 2.4062614824898834 4 2.3570037498560081 5 2.3073111253840128
		 6 2.2574141312961769 7 2.2075742657164472 8 2.1580650869273201 9 2.1091368279170037
		 10 2.0610150887303202 11 2.013988494819217 12 1.968312155364049 13 1.9242200387053592
		 14 1.8819881979373625 15 1.8418392609364003 16 1.8040575472626887 17 1.7688900548931603
		 18 1.7365734878001944 19 1.7073757403834342 20 1.6815443139876107 21 1.6593783785569318
		 22 1.6411796803743259 23 1.6270645001152235 24 1.617182471299599 25 1.6117213141554059
		 26 1.6107813402440092 27 1.6145644694750247 28 1.6231154638510676 29 1.6362588244327256
		 30 1.6537235912826316 31 1.6752685379733991 32 1.7006168249348967 33 1.7295077447939478
		 34 1.7617039340942058 35 1.79691435598198 36 1.8348992324645694 37 1.8754040345268388
		 38 1.9181507440748937 39 1.9629047559469046 40 2.0093652260295851 41 2.0573303005293448
		 42 2.1065025008501341 43 2.1566092634773324 44 2.2074207920086568 45 2.2586654027900996
		 46 2.3100611020114359 47 2.3613559716476282 48 2.4122945574591315 49 2.4626103497793688
		 50 2.5120361688691255 51 2.5603010961514592 52 2.6071287367837872 53 2.6523058827974286
		 54 2.6955312377633915 55 2.7365152069275753 56 2.7750302589051317 57 2.8107971672095431
		 58 2.8435302314655657 59 2.87298810674422 60 2.8988974895766635 61 2.9206958493589439
		 62 2.9379206940522558 63 2.9505034450041392 64 2.9583527177142654 65 2.9614080502850277
		 66 2.9595516100271864 67 2.9527687571318117 68 2.9409254369134139 69 2.9239661120747429
		 70 2.9028531580508443 71 2.8786947853419553 72 2.8516598743302133 73 2.8218506324572088
		 74 2.7894504367588766 75 2.7545903951328707 76 2.7174404566009631 77 2.6781101005037495
		 78 2.6367753228554358 79 2.5935929555795791 80 2.5486968106674328;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX";
	rename -uid "EFDE83F8-4130-6A90-C2D7-F7898FF96F69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 14.118717229646881 1 14.185350060281273
		 2 14.254019549260761 3 14.324257790508314 4 14.395749793206228 5 14.468082359043358
		 6 14.540936260633604 7 14.613896471698652 8 14.686638969966403 9 14.758765691873442
		 10 14.829921384341205 11 14.899743159654893 12 14.967877930309815 13 15.034008382931569
		 14 15.09768797742467 15 15.15864059199788 16 15.216426961010479 17 15.270753728010442
		 18 15.321243259923209 19 15.36755599080883 20 15.409279967623002 21 15.446087596427704
		 22 15.477596488344686 23 15.503507959587827 24 15.52350235486759 25 15.537281875811344
		 26 15.544556638243424 27 15.545009091115212 28 15.538418225239168 29 15.525058419789071
		 30 15.505307461064636 31 15.479514809753205 32 15.448026098991395 33 15.411256342283341
		 34 15.369503606688765 35 15.323164683210459 36 15.272569337369989 37 15.218140353502502
		 38 15.160155817591567 39 15.099023840057187 40 15.035116521990094 41 14.968794348462639
		 42 14.900408895094756 43 14.830312002509103 44 14.758899258693107 45 14.686529225002218
		 46 14.613543882100185 47 14.540343749140543 48 14.467308476242883 49 14.394763321342927
		 50 14.32311359109252 51 14.252738895268237 52 14.184021999409579 53 14.117306759503833
		 54 14.052991366146705 55 13.991434036221072 56 13.933041294148863 57 13.878171159909471
		 58 13.827211334408652 59 13.780531725931626 60 13.738536015519403 61 13.70171289089571
		 62 13.670576405845562 63 13.645404292934129 64 13.626453142983728 65 13.613996753410266
		 66 13.608398332715542 67 13.609858652470619 68 13.618684540912712 69 13.635164210262031
		 70 13.657852004481452 71 13.6850770149086 72 13.716744822438379 73 13.752760825745064
		 74 13.79300289512604 75 13.837420289570376 76 13.885924174152873 77 13.938397033707407
		 78 13.994741499337865 79 14.054889638828197 80 14.118717229646881;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY";
	rename -uid "0CA3A5E6-4134-137C-4B3F-4185410F43AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 1.3982047526747146 1 1.3964412242555841
		 2 1.394404257648941 3 1.3921692136748098 4 1.3897194834140054 5 1.3870795867114054
		 6 1.3842239722099294 7 1.3812220625562861 8 1.3779717524510244 9 1.3745891509089563
		 10 1.3710670179475049 11 1.3674089688977977 12 1.3636527273426611 13 1.3597400750108797
		 14 1.3558287625243495 15 1.3518036271138691 16 1.3478149667900761 17 1.3437762246966356
		 18 1.3397929779378848 19 1.3358815418030086 20 1.3320275423681367 21 1.3282994969323738
		 22 1.3246864398036258 23 1.3212335185785635 24 1.3180531322278792 25 1.3151497640789562
		 26 1.3126409266238679 27 1.310527196148189 28 1.3088836965062203 29 1.307682656723741
		 30 1.3069393007121068 31 1.3065154874166982 32 1.3065492866198558 33 1.306902389038733
		 34 1.3076399361893107 35 1.3086277243193516 36 1.3099246282850667 37 1.3114254403190069
		 38 1.3131869185544147 39 1.3151550978315925 40 1.3172570168187896 41 1.3194957334889679
		 42 1.3218657321120542 43 1.3243512303908176 44 1.3268920128915194 45 1.3294863680632898
		 46 1.3321348798330341 47 1.3348034864883536 48 1.3374617825701556 49 1.340147258651438
		 50 1.3428003139732057 51 1.3454878496811606 52 1.3480980043123938 53 1.3506826665032696
		 54 1.3532289581466379 55 1.3557772494501878 56 1.3582716139887905 57 1.360721369876942
		 58 1.3631786537025359 59 1.3656159901840803 60 1.3680254224202406 61 1.3705273790208508
		 62 1.3731356977116744 63 1.3758617330196543 64 1.37858515978114 65 1.3813140338016656
		 66 1.3839750546386949 67 1.3865158167588172 68 1.3889140747291446 69 1.3910998417445937
		 70 1.3930810765507742 71 1.3949310161008348 72 1.3966016105304764 73 1.3980408213193503
		 74 1.3992423683685875 75 1.4001351450478139 76 1.4006549056488737 77 1.4008043965514143
		 78 1.4004537326778717 79 1.3996132227738454 80 1.3982047526747146;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ";
	rename -uid "E6494C10-4080-C05A-D1D1-4EA41998B95D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.9277483643209314 1 -2.8937146153341282
		 2 -2.8583746821146536 3 -2.8218991614754221 4 -2.7844945536696644 5 -2.746334405201754
		 6 -2.707592927527064 7 -2.6684714076114791 8 -2.6291351901244946 9 -2.5897994200489149
		 10 -2.5506036252681663 11 -2.5117828209197017 12 -2.4734576816929366 13 -2.4358440720986168
		 14 -2.3991337275681324 15 -2.3635193339117762 16 -2.3291304199469733 17 -2.2961901371723541
		 18 -2.264854259076619 19 -2.2353401305511422 20 -2.2078007922812208 21 -2.1823497443534734
		 22 -2.1591641025011867 23 -2.1385431187277084 24 -2.1207370070364027 25 -2.1060378343461341
		 26 -2.0947147217668016 27 -2.0870186186835649 28 -2.0832064870940545 29 -2.08311140472575
		 30 -2.0866098390981653 31 -2.0934888260983135 32 -2.1035817747910404 33 -2.1166845500037503
		 34 -2.1326657240305309 35 -2.1513053708154413 36 -2.1724367761395764 37 -2.1959080178513197
		 38 -2.2215110588717217 39 -2.2490667753425995 40 -2.2784203262707856 41 -2.309397179173422
		 42 -2.341773823983424 43 -2.3754171121501351 44 -2.4101220940356889 45 -2.445721360901727
		 46 -2.4820361679805023 47 -2.5188734489768465 48 -2.5560732838445359 49 -2.5934467662652247
		 50 -2.6308179021078306 51 -2.6679684259038039 52 -2.704771459448911 53 -2.74101880553355
		 54 -2.7765258858518371 55 -2.8111471642202606 56 -2.8446488258151161 57 -2.8768895215900798
		 58 -2.9076523212844045 59 -2.9367828959130495 60 -2.9640815191923164 61 -2.9896558452734614
		 62 -3.0135156386924211 63 -3.0352756810702237 64 -3.0545605598775878 65 -3.0710727882338138
		 66 -3.0844094736578431 67 -3.0942295559859967 68 -3.1001856115385973 69 -3.1019007285374558
		 70 -3.1001892600538863 71 -3.0959646408951684 72 -3.0891400489023231 73 -3.0796073385108005
		 74 -3.0672541824508293 75 -3.0519518481122621 76 -3.0336338456448084 77 -3.0121514867613808
		 78 -2.9874102196557608 79 -2.9593099036497801 80 -2.9277483643209314;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX";
	rename -uid "09C1C8D9-48D2-3C7B-D65A-32A732CC735E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.9922855747722616 1 6.992243795077588
		 2 6.9922945575207764 3 6.9922641707633817 4 6.9922652008786388 5 6.9922706762125255
		 6 6.9922688163510216 7 6.9922572780728451 8 6.9922830989710825 9 6.9922758899347981
		 10 6.9922990869270594 11 6.9922765288446991 12 6.9922824448459977 13 6.9922975524737092
		 14 6.9922703008454059 15 6.9922931076798669 16 6.9923056679047404 17 6.9922841542081065
		 18 6.9922866763180966 19 6.992285061823754 20 6.9922741809092903 21 6.992285976822866
		 22 6.99227462150637 23 6.9922597367496033 24 6.9923011211966077 25 6.992295152810418
		 26 6.9922753024109792 27 6.9922694342226785 28 6.9922840536858901 29 6.9922649399745929
		 30 6.9922642853342261 31 6.9922708820335 32 6.9922772745314852 33 6.9922738409855896
		 34 6.9923064937889068 35 6.9922906506386058 36 6.9922645003944828 37 6.9922837903600383
		 38 6.9922960886545962 39 6.9923081125851443 40 6.9922881471583169 41 6.9922659871295201
		 42 6.9922362077943445 43 6.9923118956104879 44 6.992277165564591 45 6.9922673863526716
		 46 6.9922423189280307 47 6.9923015429506004 48 6.9923092509206537 49 6.9923085220803989
		 50 6.9922676485828603 51 6.9922569256148419 52 6.9923062322092226 53 6.9922860028607934
		 54 6.9922963813877752 55 6.9922760095311922 56 6.9922658205927775 57 6.9922859555388754
		 58 6.9922646335398859 59 6.9922600888879485 60 6.9923060339180401 61 6.9922902886700218
		 62 6.9922666220258076 63 6.9922697725580987 64 6.9922806758763114 65 6.9922653760020683
		 66 6.9922887849099489 67 6.9922770102860916 68 6.9922830813603243 69 6.9922966270890292
		 70 6.9922317714487967 71 6.9923091601213061 72 6.9922879737984065 73 6.9922812792274103
		 74 6.992280086132391 75 6.9922826442530939 76 6.9922735783050856 77 6.9922709140223018
		 78 6.9922834749196827 79 6.9922526795705764 80 6.9922855747722616;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY";
	rename -uid "73A1539F-4E9D-7C9D-3EC5-2081C289C7C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.3593833091468115 1 -5.3593843320726196
		 2 -5.3593859171783498 3 -5.359397375468915 4 -5.3593803227312788 5 -5.3593711835291096
		 6 -5.3593794922914499 7 -5.3593976049339469 8 -5.3593793228760713 9 -5.3593800902984459
		 10 -5.3593693427614042 11 -5.3593765535860944 12 -5.3593772681104719 13 -5.3593769281208585
		 14 -5.359380133535784 15 -5.3593782264904348 16 -5.3593856980053509 17 -5.3593927480760257
		 18 -5.3593853415131116 19 -5.3594034093381184 20 -5.3593709136582861 21 -5.3593699996996094
		 22 -5.3593930791323805 23 -5.3593887971949012 24 -5.3593677456618503 25 -5.3593816674100756
		 26 -5.3593838751066842 27 -5.3593803529415807 28 -5.3593767271972199 29 -5.3593985529369137
		 30 -5.3593882018428589 31 -5.3593900388727551 32 -5.3593819036878445 33 -5.3593789090566668
		 34 -5.35937629911726 35 -5.3593910031892245 36 -5.359391918884894 37 -5.3593869313157878
		 38 -5.3593853503034126 39 -5.3593802167172058 40 -5.3593863425343526 41 -5.3593867762016449
		 42 -5.3593912567813442 43 -5.3593836443320706 44 -5.3593807801906399 45 -5.3593885009021047
		 46 -5.359387212833373 47 -5.3593749588907578 48 -5.3593671159698744 49 -5.359381593502742
		 50 -5.35938126375813 51 -5.3593735646692666 52 -5.359372663086015 53 -5.359377188261802
		 54 -5.3593886866354445 55 -5.3593776057569222 56 -5.3593946793524658 57 -5.3593741205286092
		 58 -5.3593963272154186 59 -5.3593983982934086 60 -5.3593749094580909 61 -5.3593884024808141
		 62 -5.359379151535915 63 -5.3593884141666353 64 -5.3593709850682343 65 -5.3593871078125366
		 66 -5.3593836909979418 67 -5.3593929189154705 68 -5.3593786850145255 69 -5.3593695577042899
		 70 -5.359393188076103 71 -5.3593788559897462 72 -5.3593878220296256 73 -5.359387222721784
		 74 -5.3593888918357697 75 -5.3593810822837558 76 -5.3594003383195279 77 -5.3593783952300154
		 78 -5.3593732255412707 79 -5.3593941298699379 80 -5.3593833091468115;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ";
	rename -uid "A6E014B6-4B8F-F8BA-7C0A-689B7E163CEF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.826424484316885 1 -13.826450772827027
		 2 -13.82638284248827 3 -13.82642297175745 4 -13.826436177217687 5 -13.826450134607622
		 6 -13.826444161147 7 -13.826429112398658 8 -13.826410676994156 9 -13.826424971051404
		 10 -13.826375664118979 11 -13.826422470925902 12 -13.826421016915054 13 -13.826394367207646
		 14 -13.826440324716426 15 -13.826399199814245 16 -13.82638837319338 17 -13.826401938428932
		 18 -13.826413992164314 19 -13.826433892350819 20 -13.8264163373966 21 -13.826425345049723
		 22 -13.826438607527146 23 -13.826431375590779 24 -13.826404938043131 25 -13.826407410944723
		 26 -13.826430554468294 27 -13.826431296923193 28 -13.826435954708357 29 -13.826413743600789
		 30 -13.826406946750719 31 -13.826419550498395 32 -13.826416213859138 33 -13.826410231928939
		 34 -13.826413676274466 35 -13.826418160639406 36 -13.826439081088928 37 -13.82638988274539
		 38 -13.826400985359747 39 -13.826396090754971 40 -13.826404634766821 41 -13.826427647376635
		 42 -13.826451036353383 43 -13.82638658542292 44 -13.82641943049631 45 -13.826401194422143
		 46 -13.826442496918236 47 -13.826407358153288 48 -13.826396169112794 49 -13.8264032022074
		 50 -13.826438553992697 51 -13.826438725013531 52 -13.826413377313157 53 -13.82641038532355
		 54 -13.826412849487511 55 -13.826414753601552 56 -13.826427953640797 57 -13.826409765347188
		 58 -13.826415011610518 59 -13.826432397818726 60 -13.826399631991597 61 -13.826402974889573
		 62 -13.826415231593073 63 -13.82641888156361 64 -13.826418319123627 65 -13.826434691060534
		 66 -13.826391458095308 67 -13.826423125244023 68 -13.826415526079694 69 -13.826420899163123
		 70 -13.82644576556514 71 -13.826382088492974 72 -13.826395136895103 73 -13.826413558521628
		 74 -13.826405064649066 75 -13.826409224757008 76 -13.826431781120609 77 -13.826437164875344
		 78 -13.826432342185246 79 -13.826449741170574 80 -13.826424484316885;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX";
	rename -uid "C27D6087-4D7F-DA4D-11B1-4A9766FF3FE2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.5883568623633355 1 5.6443762242691164
		 2 5.7073556404664094 3 5.7754118638760934 4 5.84702887600303 5 5.9203334093278572
		 6 5.9935866875022574 7 6.0649728081893359 8 6.1325944871728106 9 6.1944941204695638
		 10 6.2487783492433397 11 6.293426506405269 12 6.3265251737932351 13 6.3452450933613171
		 14 6.3471073785023489 15 6.3326118731515209 16 6.3035756031711241 17 6.2610967715705117
		 18 6.206347880016831 19 6.1404082339443891 20 6.0644735245088377 21 5.9797497054681461
		 22 5.887400666404889 23 5.7886002380515436 24 5.6846235062770907 25 5.5764932825342699
		 26 5.4654513718982205 27 5.352660818355826 28 5.239215306809478 29 5.1262169304663008
		 30 5.0147406337741831 31 4.9057992686011822 32 4.8004201032791043 33 4.6995688464245875
		 34 4.6041825815771995 35 4.5151614010476244 36 4.4333462703088546 37 4.3596685314947328
		 38 4.2948749319168522 39 4.2397582016868336 40 4.1950956514147695 41 4.1611746191498264
		 42 4.1377693257038528 43 4.1235032400215887 44 4.1162073683423035 45 4.1155056534193015
		 46 4.1207826020493679 47 4.1317671510528404 48 4.1477949399776319 49 4.1684224351364421
		 50 4.1932228436292043 51 4.2218493519719917 52 4.2538893620571194 53 4.2888385134956994
		 54 4.3264520879744701 55 4.3662658091778512 56 4.4080208341615634 57 4.4513915651963032
		 58 4.4960604132702846 59 4.5416558407590726 60 4.5880207898999403 61 4.634754967735609
		 62 4.6819312020513459 63 4.7297845842996518 64 4.7781675363439327 65 4.8296746923518876
		 66 4.8864207571910843 67 4.9473103980059756 68 5.0113534859248938 69 5.0774388067390932
		 70 5.1443642686452655 71 5.2111276390919929 72 5.2762702771599139 73 5.3386495264929126
		 74 5.3970022496101899 75 5.4499740323019266 76 5.4962833857116342 77 5.5346005048884592
		 78 5.5635715091429745 79 5.5819065738688805 80 5.5883568623633355;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY";
	rename -uid "C363AF37-4CA4-2410-23B2-2F92886D7D97";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -16.687929796848362 1 -16.693029607477435
		 2 -16.683138162157402 3 -16.659617105526884 4 -16.624017112934268 5 -16.577763477780383
		 6 -16.522323915883121 7 -16.459048873238629 8 -16.389335945919562 9 -16.314479872725702
		 10 -16.235913538184604 11 -16.15490075760076 12 -16.072834363337673 13 -15.985721679003383
		 14 -15.892052515422312 15 -15.794024828435095 16 -15.690800393212864 17 -15.583406334618752
		 18 -15.472857091893353 19 -15.360206345117497 20 -15.246443837996997 21 -15.132615914231744
		 22 -15.019710327574005 23 -14.908720496164792 24 -14.800619411512955 25 -14.696338266288231
		 26 -14.596742934789393 27 -14.502734609507522 28 -14.415176797508238 29 -14.334851091574166
		 30 -14.262475821514441 31 -14.198817436251442 32 -14.144594527927266 33 -14.100446591791568
		 34 -14.067052744321344 35 -14.045009681722565 36 -14.034921928292942 37 -14.037429782253843
		 38 -14.053072100386997 39 -14.082484034335547 40 -14.126246699272262 41 -14.182526161231836
		 42 -14.247196644541429 43 -14.321549196413063 44 -14.407971001688747 45 -14.505224675368682
		 46 -14.611990432535505 47 -14.727037855730494 48 -14.849048402591055 49 -14.976790810447387
		 50 -15.10897187023248 51 -15.244350455499518 52 -15.381721525868413 53 -15.519719479482037
		 54 -15.657163793192339 55 -15.792727096088104 56 -15.925152912216019 57 -16.053195557165925
		 58 -16.175543702097283 59 -16.290870537330331 60 -16.397922560508892 61 -16.495351703939072
		 62 -16.584335168415834 63 -16.666823220749308 64 -16.742629529057847 65 -16.805542830609522
		 66 -16.850776558062986 67 -16.880234259240531 68 -16.895865115953317 69 -16.89961726825593
		 70 -16.893354033144128 71 -16.879019460678933 72 -16.858389785508631 73 -16.83332991785587
		 74 -16.805715195715326 75 -16.777335146484887 76 -16.75004371616054 77 -16.725624012185815
		 78 -16.705900672494579 79 -16.692721695362263 80 -16.687929796848362;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ";
	rename -uid "6D8A6752-430A-AC7D-90BE-02A1D8D3F2B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 23.09334783771487 1 23.251167132968543
		 2 23.415058489610765 3 23.58127121071476 4 23.746195892610302 5 23.906173792390959
		 6 24.057585328873266 7 24.196809229438152 8 24.320208209470461 9 24.424229179801223
		 10 24.505267944683858 11 24.55972457345414 12 24.583993458675522 13 24.568414337764821
		 14 24.506131899925151 15 24.399645055847987 16 24.253283654024404 17 24.070236476723171
		 18 23.853689946745277 19 23.606870638923077 20 23.33292579343512 21 23.035034834615676
		 22 22.716408031721919 23 22.380283204174091 24 22.029838892099885 25 21.668380100579057
		 26 21.299142407746466 27 20.925482220207048 28 20.550690137098897 29 20.178181939182856
		 30 19.811275075452119 31 19.453380817898012 32 19.107984312794358 33 18.778558796614359
		 34 18.468501249351593 35 18.181416036253136 36 17.920767928322963 37 17.690079851080807
		 38 17.492847583258339 39 17.332683579944089 40 17.213036073035607 41 17.134589915723982
		 42 17.094901031013961 43 17.090198217997496 44 17.115967245033588 45 17.17013144808897
		 46 17.250526149689776 47 17.355045974461969 48 17.481606509583312 49 17.62805549377514
		 50 17.792258193812167 51 17.972056899491264 52 18.165309895776385 53 18.369919451984028
		 54 18.583668550164365 55 18.804473465116537 56 19.030147580775424 57 19.2585386211165
		 58 19.487552135460842 59 19.714990252168437 60 19.938736572079016 61 20.156687124804129
		 62 20.369678790906303 63 20.579490825591236 64 20.785356235857094 65 20.990388977604361
		 66 21.19674630919851 67 21.402323472819877 68 21.605111235147099 69 21.803052113589931
		 70 21.994190873229464 71 22.17642876727966 72 22.347876872851131 73 22.506502556478313
		 74 22.650365605774581 75 22.777511255910447 76 22.885941950316401 77 22.973705900972714
		 78 23.03886125484566 79 23.079397329467007 80 23.09334783771487;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAX";
	rename -uid "3BAEACDC-45D0-98BA-DF77-D094EB50B0D7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 -1.5163287635830526e-006 2 7.9294975342558698e-006
		 3 -2.2804390617863887e-006 4 2.0371156525442059e-006 5 -4.1250861001382897e-006 6 -4.9226292716088143e-006
		 7 0 8 -3.0332133116403027e-021 9 -5.3275522941547211e-006 10 9.1360243324569565e-006
		 11 0 12 4.1250595602262912e-006 13 0 14 -3.9554039840757344e-006 15 -6.7034363332620589e-006
		 16 0 17 0 18 -5.011985167401373e-006 19 -3.1989031721640881e-006 20 5.6375820405282742e-006
		 21 -5.353792191521666e-006 22 2.6425841379612675e-006 23 0 24 -2.1814970972058491e-006
		 25 -6.7499839073893191e-006 26 -8.126110433069256e-006 27 -2.365897914672971e-006
		 28 2.2999117804901519e-006 29 3.791516639546772e-022 30 1.7303149765673834e-006 31 0
		 32 -2.307083222685399e-006 33 0 34 2.188902215747241e-006 35 -4.3581649645954815e-006
		 36 6.931349081521135e-006 37 -2.0770687645840595e-006 38 0 39 2.5899041520324018e-006
		 40 -1.3746843942548695e-005 41 -6.8064049347532555e-006 42 9.5518256736937115e-006
		 43 -7.0924138634470903e-006 44 1.8156583348445104e-006 45 -6.3104301302866957e-006
		 46 4.7996688519871141e-006 47 -6.596458812160547e-006 48 -3.3427126869432159e-006
		 49 2.9320139484101141e-006 50 -4.080959166206681e-006 51 -4.6834724960396279e-006
		 52 -4.3529541032657368e-006 53 -3.9887912172033375e-006 54 0 55 3.087551349701876e-006
		 56 1.9769900342138588e-006 57 1.6118059817650744e-006 58 0 59 -2.2625814097175749e-006
		 60 -5.4242943608923083e-006 61 -8.0732508403917305e-006 62 6.5414267884628789e-006
		 63 1.3718147170331976e-006 64 -1.895758319773386e-022 65 -5.5033407726488946e-006
		 66 -2.0612937991021646e-006 67 -2.3929842663971802e-006 68 7.7140896584730721e-006
		 69 0 70 1.4230951700495593e-006 71 3.6650918603543228e-006 72 -3.6632244133725948e-006
		 73 0 74 4.9506792492247122e-006 75 6.1463736695355139e-006 76 -3.9484398213834015e-006
		 77 9.0910286067481839e-006 78 0 79 -1.5242729982559588e-005 80 0;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAY";
	rename -uid "140142BB-40D7-017E-B8B8-AB95792DA81F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.6589927377810646e-006 1 7.8908057610034362e-005
		 2 6.5583357057100573e-005 3 8.9598496832821722e-006 4 0.0001104118767644605 5 0 6 7.0961115388977938e-006
		 7 -4.9499024601277909e-006 8 7.903729295240277e-005 9 1.1759611804834974e-005 10 0.00011535977813986333
		 11 0 12 -1.895758319773386e-022 13 7.1443134399344545e-005 14 6.549780296375709e-005
		 15 7.5192596568705793e-005 16 8.0306968931220224e-005 17 1.9609668206582525e-006
		 18 4.2224656645076664e-006 19 2.5229185384056845e-006 20 2.199920837207357e-006 21 5.0795180932736286e-006
		 22 2.0386278029757266e-006 23 0 24 3.3248951025144848e-006 25 7.6412244041561332e-005
		 26 4.2771603352173166e-006 27 3.2790501869618898e-006 28 7.1880485482662749e-006
		 29 -4.6241787932370305e-006 30 0 31 7.9403120907582525e-006 32 2.7180014695864939e-006
		 33 0 34 2.6025618753636831e-006 35 3.5362616409149888e-006 36 -2.7694277958990326e-006
		 37 7.231386719851012e-006 38 3.2878640572455691e-006 39 0 40 -9.9209266637099127e-006
		 41 -7.4105428293401437e-006 42 -1.2724792859696687e-006 43 1.6585297637837157e-006
		 44 2.7026909341562521e-006 45 1.1373275567753337e-005 46 0 47 -5.5253740423511986e-006
		 48 0 49 8.0468487713378228e-006 50 3.3272038423302444e-006 51 -9.3361815335537142e-006
		 52 5.3495491899511001e-006 53 0 54 -4.5336434659604207e-006 55 -1.5972998479658917e-006
		 56 0 57 -7.8607833744339225e-006 58 1.5482715567557419e-006 59 -1.8010353611549916e-006
		 60 5.6695414061137955e-005 61 0 62 3.0551478996075399e-006 63 4.8964757475150264e-006
		 64 -3.6161972336470284e-006 65 0 66 -1.3891444059113446e-006 67 1.3969376269084143e-006
		 68 -3.0522124420039652e-006 69 -4.5372384317232693e-006 70 6.3267270588405634e-005
		 71 -2.6650780949680592e-006 72 5.204622457167337e-006 73 0 74 -5.0851475610273717e-006
		 75 7.1684598029976538e-006 76 8.5455938594552246e-005 77 4.0362581672896965e-006
		 78 0 79 1.334234926535102e-006 80 3.6589927377810646e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ";
	rename -uid "F3E26A50-4528-5F8D-131F-199D10018351";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 30.934927579782283 1 30.934948606129911
		 2 30.934912455393917 3 30.934677200108503 4 30.934852295068456 5 30.935293070327393
		 6 30.936176714223556 7 30.934695955392673 8 30.934900804221702 9 30.935289020814963
		 10 30.935037192240088 11 30.934672964194206 12 30.934911004135287 13 30.934734944082432
		 14 30.935461586666644 15 30.93477693738917 16 30.934816667586272 17 30.935849444380352
		 18 30.934631819693919 19 30.934662527809923 20 30.934815287852636 21 30.934678550510412
		 22 30.934796743449159 23 30.934664012475125 24 30.935093705324409 25 30.934692837719624
		 26 30.934893471062267 27 30.934753593277236 28 30.934674846256343 29 30.934665431362919
		 30 30.935700115357328 31 30.934683418525548 32 30.934633411631452 33 30.93487415683844
		 34 30.934808096327792 35 30.935244120837162 36 30.934951872068126 37 30.934684489890724
		 38 30.934692093031231 39 30.934866204375638 40 30.934736553804875 41 30.935570781260925
		 42 30.935113920126096 43 30.934966258425966 44 30.934669181641933 45 30.935281287962447
		 46 30.934652631960198 47 30.934687605001226 48 30.935962942118188 49 30.934689139031473
		 50 30.93470559924873 51 30.934648424906054 52 30.934696988543603 53 30.934726295434537
		 54 30.935301214437633 55 30.934908427915609 56 30.934458640283509 57 30.936039164373124
		 58 30.934668467726958 59 30.934683282503389 60 30.93480461774918 61 30.935492081045801
		 62 30.934696691993125 63 30.934984399697885 64 30.935863532119296 65 30.934652804487332
		 66 30.934659108920592 67 30.935549851930279 68 30.934671713229889 69 30.93465533508305
		 70 30.93511314312272 71 30.934677791103354 72 30.934708164521549 73 30.934684086539072
		 74 30.93472188785735 75 30.934623989393721 76 30.934646272532643 77 30.934665525934214
		 78 30.934734667294713 79 30.934657453930281 80 30.934927579782283;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX";
	rename -uid "31D8A43F-4BE4-59B7-5C82-42997229A9DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.7327511245327498 1 2.7145062588619755
		 2 2.6969122170485846 3 2.6807118233110669 4 2.6666232416053046 5 2.6553526134466066
		 6 2.6476513984118033 7 2.6442702730481069 8 2.6454081614541516 9 2.6506530140614832
		 10 2.6597752540057167 11 2.6725203295727145 12 2.6886707474313045 13 2.7079636674374754
		 14 2.7301445315996493 15 2.7549732605773571 16 2.7822042159584699 17 2.8115850348479521
		 18 2.8428992343789226 19 2.8758609831747766 20 2.9102722696080177 21 2.9459010553858618
		 22 2.9824981366283394 23 3.0198262588413027 24 3.0576196379276572 25 3.0956433273702078
		 26 3.1336376360505369 27 3.1713995933914831 28 3.2086852208895165 29 3.2452664289350714
		 30 3.2809021282549735 31 3.3154044567491412 32 3.3485108296915476 33 3.3800640688275725
		 34 3.4097876908694871 35 3.4375420339311242 36 3.4630429557979721 37 3.4861246006084348
		 38 3.506573785588408 39 3.5241875418039448 40 3.5387497019858438 41 3.5500467483781906
		 42 3.5581312802394671 43 3.5632305257271679 44 3.5654452918983957 45 3.5649583559105475
		 46 3.5618322656730945 47 3.5561724649432676 48 3.5481221922234085 49 3.5377760290609004
		 50 3.5252035774419346 51 3.5105920863976361 52 3.4939727293293181 53 3.4755134711225022
		 54 3.4552523817489518 55 3.4333450023122296 56 3.4099055925749386 57 3.3850074999449848
		 58 3.3588271188065186 59 3.3314620628176677 60 3.303080899612326 61 3.2737856878964697
		 62 3.2437006197281204 63 3.2129940219099686 64 3.1817865861181631 65 3.1502136429011074
		 66 3.1184191137278967 67 3.0865521639610125 68 3.0547436002428352 69 3.0231594153278007
		 70 2.9919240609803839 71 2.9612189979701937 72 2.9311505995075473 73 2.9018830956266979
		 74 2.8735944746482076 75 2.8464319938217013 76 2.8205168541677028 77 2.7960565300889262
		 78 2.7731465957859069 79 2.751986643123276 80 2.7327511245327498;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY";
	rename -uid "B31D27BB-4F5A-D7A4-0E97-7DAF1B7564EF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.0306789089568511 1 -6.0450446348955227
		 2 -6.0588541760070767 3 -6.0714289378181086 4 -6.0822954128768725 5 -6.0908092690155868
		 6 -6.0964809858287028 7 -6.0987163764027894 8 -6.097375441134961 9 -6.0927669451730697
		 10 -6.0850743631825717 11 -6.0744109827269437 12 -6.0610333712259505 13 -6.0450514098569919
		 14 -6.0266228743273587 15 -6.0059297035239503 16 -5.9830937001280642 17 -5.9582869042589763
		 18 -5.9316630238950543 19 -5.9033904973390534 20 -5.873632645770801 21 -5.842551166395384
		 22 -5.8103136796653096 23 -5.7771576133180016 24 -5.743212316098159 25 -5.7087085977973784
		 26 -5.6738596645116175 27 -5.6388423056966142 28 -5.6039405206541328 29 -5.569337601614385
		 30 -5.5352915908419016 31 -5.5020323844040897 32 -5.4697995243024069 33 -5.4388714749645075
		 34 -5.4094619922758138 35 -5.3818922172165609 36 -5.3563670547130071 37 -5.3331759784407788
		 38 -5.3126000189783751 39 -5.294914499297267 40 -5.2803564433004233 41 -5.2691928402586141
		 42 -5.2614373675569217 43 -5.2568268563315774 44 -5.2552596762199428 45 -5.2565899048488616
		 46 -5.2607057062067835 47 -5.2674412881448829 48 -5.2766942180031018 49 -5.2883010531660171
		 50 -5.3021011786090479 51 -5.3179769347021502 52 -5.3357897086954837 53 -5.3553606009608492
		 54 -5.3765706256386192 55 -5.3992367653459317 56 -5.423231412623152 57 -5.4483878867002762
		 58 -5.4745924756006836 59 -5.5016583421154017 60 -5.5294022273104773 61 -5.5577237449072383
		 62 -5.5864635576578676 63 -5.6154947288144879 64 -5.6446672650581062 65 -5.6738431736030517
		 66 -5.7029056393469819 67 -5.7316968261597898 68 -5.7601057670915008 69 -5.7880235335488086
		 70 -5.8153215523651953 71 -5.8419059699516938 72 -5.867630331833265 73 -5.8924024730621571
		 74 -5.9161140150872917 75 -5.9386813299474737 76 -5.9600057460874245 77 -5.9799527250816897
		 78 -5.9984072500772534 79 -6.0153666396947516 80 -6.0306789089568511;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ";
	rename -uid "7165240F-47ED-9E6E-8C42-42BF6066A482";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.9064865746532611 1 -8.8124749348407434
		 2 -8.7218868091677386 3 -8.6381895630218413 4 -8.5649259186026896 5 -8.5057042013819917
		 6 -8.4640264009861585 7 -8.4434672663740731 8 -8.4451476543276502 9 -8.4670772159734611
		 10 -8.5081786169654254 11 -8.5673151970586758 12 -8.6433980274065298 13 -8.7353307334992643
		 14 -8.8419448128352176 15 -8.9622073082288995 16 -9.0949548917023577 17 -9.2391018562309668
		 18 -9.3935281507519175 19 -9.557125780008235 20 -9.7289770177958665 21 -9.9081101044199045
		 22 -10.09324673653984 23 -10.283159743936382 24 -10.476619195360271 25 -10.672378010640639
		 26 -10.869191609845432 27 -11.065830143260831 28 -11.261069783727093 29 -11.45367984093201
		 30 -11.642410274392173 31 -11.826041557881076 32 -12.003368893763943 33 -12.173122699089749
		 34 -12.334104376967238 35 -12.485073911971355 36 -12.624814018682402 37 -12.752131818110966
		 38 -12.865749994087368 39 -12.964464297457953 40 -13.047069731133583 41 -13.112308408353565
		 42 -13.160271452088731 43 -13.192249066046667 44 -13.208768094906043 45 -13.210507633132959
		 46 -13.197968723905957 47 -13.171825651538949 48 -13.132603239389125 49 -13.08092774117222
		 50 -13.017345048932684 51 -12.942462595960968 52 -12.856900070364976 53 -12.761180413454527
		 54 -12.655962851343981 55 -12.541760578418803 56 -12.419213281569144 57 -12.288972498961027
		 58 -12.151850360235674 59 -12.008601653969484 60 -11.85995971598849 61 -11.706646454298081
		 62 -11.549434165715594 63 -11.389072877095465 64 -11.226290779267966 65 -11.061857549347303
		 66 -10.896508258426838 67 -10.730994600817114 68 -10.566060346919638 69 -10.402468571220838
		 70 -10.240940189706134 71 -10.082303481722365 72 -9.927218248982518 73 -9.7764785866386514
		 74 -9.6308730683163866 75 -9.4910959995071646 76 -9.3579189820612125 77 -9.2321345513434121
		 78 -9.1144425116464767 79 -9.0056418861844261 80 -8.9064865746532611;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX";
	rename -uid "09CA05EF-4EBD-DF83-75A4-34893EF75B7A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.2080861726087564 1 3.1910536277743273
		 2 3.1746578652741362 3 3.1595336271880137 4 3.146357296382531 5 3.1358341818174398
		 6 3.1286296435696657 7 3.1254340674254717 8 3.1264537393368497 9 3.1313047521216131
		 10 3.1397667474101159 11 3.1516210870494015 12 3.1666248493821736 13 3.1845406940809613
		 14 3.205147300191721 15 3.228220531302449 16 3.2535077973052462 17 3.2807970417088081
		 18 3.3098219002241924 19 3.3403876998002975 20 3.3722601048032006 21 3.4052436820578236
		 22 3.4391162258594541 23 3.4736205182358435 24 3.5085385397743694 25 3.5436171397130969
		 26 3.5786742174670407 27 3.6134671965766638 28 3.6478062471418395 29 3.6814546562099988
		 30 3.7142345697565244 31 3.7459005150950517 32 3.7763252330788468 33 3.8052399184355323
		 34 3.8325081808621695 35 3.8579022818876254 36 3.8812519070465732 37 3.9023978432535373
		 38 3.921119074804301 39 3.9372381871863933 40 3.9505796908930155 41 3.9609392201319005
		 42 3.9683600245130326 43 3.9730519763370862 44 3.9751632906243963 45 3.9747673430581356
		 46 3.9719684065883896 47 3.9668963862967157 48 3.9596098277414447 49 3.9502221780342652
		 50 3.9388542130530384 51 3.9255466986474583 52 3.9104427469173872 53 3.8935960093179141
		 54 3.875142204715635 55 3.8551478900794285 56 3.8336985235632173 57 3.8109405208349898
		 58 3.786954581388692 59 3.7618881145997358 60 3.7358347050319214 61 3.7089364382017243
		 62 3.681286987380445 63 3.6530248567082082 64 3.6242840243780745 65 3.5951838826688087
		 66 3.5658699498786639 67 3.5364459617739454 68 3.5070404556720649 69 3.4778292231196
		 70 3.4489122305171946 71 3.4204538191064686 72 3.3925826199223121 73 3.3654368868471027
		 74 3.3391690982285289 75 3.3139075583250732 76 3.2898194592904559 77 3.2670538134742961
		 78 3.2457421895364438 79 3.2260375817886295 80 3.2080861726087564;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY";
	rename -uid "0CBA5075-42DE-3CFA-DDFE-9986FFBC615B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -5.7924479629026067 1 -5.8082568391220466
		 2 -5.8233866680836144 3 -5.8372460353084845 4 -5.8491724946565951 5 -5.8585752638869861
		 6 -5.8648655698800214 7 -5.8673785986757645 8 -5.8659513851782279 9 -5.8609083955702683
		 10 -5.8525082424829433 11 -5.8408961681256395 12 -5.8262690683879406 13 -5.8087825596857536
		 14 -5.7886538944956261 15 -5.7660129876166009 16 -5.7410628839360536 17 -5.7139767930907022
		 18 -5.6849581349714127 19 -5.6541437081493378 20 -5.6217142833909097 21 -5.5879029370284243
		 22 -5.5528570463028384 23 -5.5167862300462893 24 -5.4799313177690383 25 -5.4425296823422187
		 26 -5.4047163030139345 27 -5.3668395341319126 28 -5.3290655033113774 29 -5.2916631281074098
		 30 -5.2548718366255196 31 -5.2189396138227089 32 -5.1841780068270102 33 -5.1508081653491953
		 34 -5.1191253397981562 35 -5.0894155114982453 36 -5.0619449859206984 37 -5.0370081181062938
		 38 -5.0148586897852869 39 -4.9958044202747161 40 -4.9801256786317625 41 -4.9681083711229386
		 42 -4.9597330808023186 43 -4.9547425569099595 44 -4.95298204142488 45 -4.9543511241493468
		 46 -4.9586915101507429 47 -4.9658712027719361 48 -4.9757353996460534 49 -4.9881104156315192
		 50 -5.0028715781387536 51 -5.0199086481858544 52 -5.0389509245328936 53 -5.059963786220365
		 54 -5.0826813886172602 55 -5.1070373801844662 56 -5.1328388577616835 57 -5.1599304005995137
		 58 -5.1881158114360284 59 -5.2172493869894492 60 -5.2472028546406886 61 -5.2777915660438861
		 62 -5.3088556485486489 63 -5.3402524145405348 64 -5.3718113551394469 65 -5.4034176680032244
		 66 -5.4348945063699787 67 -5.4661562955010528 68 -5.4970186612248959 69 -5.5273785547724765
		 70 -5.5570893661461849 71 -5.5860321298247628 72 -5.6140674545514688 73 -5.6411065645050984
		 74 -5.6670308333385231 75 -5.6916771684136487 76 -5.7149749826379939 77 -5.7368143236646976
		 78 -5.7570895829846904 79 -5.7756613586429566 80 -5.7924479629026067;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ";
	rename -uid "B82303BF-495E-F83E-3E24-E1972F58E0EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.9248389169076816 1 -8.8310425624860329
		 2 -8.7406496311520918 3 -8.65711188113786 4 -8.5840377603665221 5 -8.5249135474371389
		 6 -8.4833181711108754 7 -8.4627935581933595 8 -8.4644506520717808 9 -8.486324118239887
		 10 -8.5273085437962663 11 -8.5863031928900853 12 -8.662216813363548 13 -8.7539055600138855
		 14 -8.8602872925491543 15 -8.9802688334619329 16 -9.1127089082051125 17 -9.2565294418075421
		 18 -9.4105829775734176 19 -9.5738169980169712 20 -9.7452658309772726 21 -9.9239613072794484
		 22 -10.108685435774994 23 -10.298159288783388 24 -10.491173417006326 25 -10.686474212582951
		 26 -10.882828050906321 27 -11.079015581428038 28 -11.273818737210451 29 -11.465972721820528
		 30 -11.654281078542654 31 -11.837463064411139 32 -12.014375176685597 33 -12.183740576462757
		 34 -12.344372135436734 35 -12.494983123572966 36 -12.634409185051338 37 -12.761419290248257
		 38 -12.874788827461039 39 -12.973284899261905 40 -13.055717528793881 41 -13.120810446801032
		 42 -13.168674579209766 43 -13.200570104344175 44 -13.217110848982971 45 -13.218825244659035
		 46 -13.206350031797591 47 -13.180272229956428 48 -13.141170120418629 49 -13.089604043890844
		 50 -13.02619865017496 51 -12.951519298445641 52 -12.866174612159675 53 -12.770711293254314
		 54 -12.665745499098874 55 -12.551839931722482 56 -12.429573898884451 57 -12.299658829560219
		 58 -12.162874843323419 59 -12.019939294485862 60 -11.871652604441731 61 -11.718711688933524
		 62 -11.561874476842434 63 -11.401876202810609 64 -11.23947101155192 65 -11.075422870487195
		 66 -10.910456966873589 67 -10.745318349942304 68 -10.580754477613089 69 -10.417532843525322
		 70 -10.256386704157643 71 -10.0980968960778 72 -9.9433656477784265 73 -9.792973375286806
		 74 -9.6476620707663603 75 -9.508193230755575 76 -9.3753258914742705 77 -9.2497912870548316
		 78 -9.1323674604672629 79 -9.0237911647064042 80 -8.9248389169076816;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX";
	rename -uid "9D5A8BCC-45F0-F949-5489-0AA2B7DD07B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.064639052844944617 1 0.042085646426786055
		 2 0.020375560795062565 3 0.00040987828611747381 4 -0.01692705515371476 5 -0.030713103782419964
		 6 -0.040043264554040635 7 -0.044078741338015842 8 -0.042481832436083639 9 -0.035817108222558423
		 10 -0.024321615084496873 11 -0.0083160428913337924 12 0.011915859286426052 13 0.036088266516405156
		 14 0.063908772782152665 15 0.095081702968246334 16 0.12932041469985897 17 0.16632506563348973
		 18 0.20583485244291819 19 0.24753207529639384 20 0.29114808628733391 21 0.33645199176731971
		 22 0.38308085585298507 23 0.43075428842949032 24 0.47917597338665108 25 0.52805852028939504
		 26 0.57703628241046578 27 0.62586845908527045 28 0.67422298996312535 29 0.72181716271679619
		 30 0.76832054290937646 31 0.81344939983622033 32 0.85689894347865447 33 0.89837088806236109
		 34 0.93757504116181023 35 0.97420021376959676 36 1.0079510134695282 37 1.0385257275510122
		 38 1.0656298768114338 39 1.0889653332071643 40 1.1082345217930385 41 1.123124539118413
		 42 1.1336709846686615 43 1.1402222056241196 44 1.1429027850151969 45 1.1418982760599621
		 46 1.1373528056681745 47 1.1294407612099384 48 1.1182951624294253 49 1.1041023883407144
		 50 1.086979827127964 51 1.0671228950941722 52 1.0446692747157293 53 1.0197720931617176
		 54 0.99261383132010306 55 0.9633075857742619 56 0.93207117101045989 57 0.89902734520267369
		 58 0.8643876314884138 59 0.82832675577218307 60 0.79102804043719399 61 0.75265423337758119
		 62 0.71340989052267401 63 0.67348230644875129 64 0.63301410155198645 65 0.59223165626556695
		 66 0.55127783360963689 67 0.51037658873309744 68 0.46967943491932429 69 0.42938363378344374
		 70 0.38967048413894001 71 0.35071245240917964 72 0.312702858852412 73 0.27583883917505486
		 74 0.24027627386182296 75 0.20619889028664595 76 0.1738248335647469 77 0.14327611117105474
		 78 0.1147846953479042 79 0.088513897718681345 80 0.064639052844944617;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY";
	rename -uid "6AC23BE7-4791-E045-9073-3BA71C1D055B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -6.618552830983929 1 -6.624356779787183
		 2 -6.6299010483905088 3 -6.634879129177147 4 -6.6391120654609841 5 -6.6423831107215321
		 6 -6.6444713587762791 7 -6.645174456730798 8 -6.6443899138933062 9 -6.6423012763224358
		 10 -6.6389232495344785 11 -6.6343226636717292 12 -6.6285642028616181 13 -6.6217277060439743
		 14 -6.6137856742999466 15 -6.6048655592248888 16 -6.5949491002257909 17 -6.5840887548366434
		 18 -6.572322468788288 19 -6.5597403065599931 20 -6.5463939888370781 21 -6.5322842553505431
		 22 -6.5175529590711339 23 -6.5022380588709341 24 -6.4864126644857558 25 -6.4701436369761396
		 26 -6.4535604730646865 27 -6.4367595921131544 28 -6.4198218912055287 29 -6.4029169841131113
		 30 -6.3861141335957665 31 -6.3695787160433719 32 -6.3534147136654298 33 -6.337819642062839
		 34 -6.3228872668472285 35 -6.3088209270822482 36 -6.2957475240705101 37 -6.2838487866320385
		 38 -6.2732484919892331 39 -6.2641543458859337 40 -6.2566828313880265 41 -6.2510202573274452
		 42 -6.2471684862795369 43 -6.2450232108246526 44 -6.2444818906093653 45 -6.2455148268148104
		 46 -6.2479795465438626 47 -6.2518801982132279 48 -6.2570913933996337 49 -6.2635451720024671
		 50 -6.2711361373398784 51 -6.2797661354536904 52 -6.2893842817904213 53 -6.2998537310170004
		 54 -6.311094355419975 55 -6.3230168254965617 56 -6.3355314353209167 57 -6.3485230540426318
		 58 -6.3619460543613719 59 -6.3756700608313253 60 -6.3896327645804192 61 -6.403763188369668
		 62 -6.4179528086870041 63 -6.4321364240594541 64 -6.4462529778329856 65 -6.4602269508989085
		 66 -6.474033288304148 67 -6.4875229624142392 68 -6.5007149694700592 69 -6.51352758956304
		 70 -6.5259226599831512 71 -6.537870177057612 72 -6.5493051220290921 73 -6.5601740559564803
		 74 -6.5704810689337139 75 -6.580189670410312 76 -6.5892357520340958 77 -6.5976214961498547
		 78 -6.6053174729812865 79 -6.6123032477267829 80 -6.618552830983929;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ";
	rename -uid "A4566ECE-4D8A-D8A5-29DA-8CB1718CC4FB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -8.7662343333443005 1 -8.671560247348479
		 2 -8.5803050212643956 3 -8.4960130426266147 4 -8.4222746209572339 5 -8.3626355450853147
		 6 -8.3206959297500696 7 -8.300018458721441 8 -8.3017625576097203 9 -8.3239126420392484
		 10 -8.3653811802987441 11 -8.4250041878374766 12 -8.5017106123469883 13 -8.5944037011386563
		 14 -8.7018898175234103 15 -8.8231472282757046 16 -8.9569949924625512 17 -9.1023118741905513
		 18 -9.2580353102256989 19 -9.4229939186734128 20 -9.5963026261149711 21 -9.7769515076394615
		 22 -9.9636632299074392 23 -10.155213029693829 24 -10.350374034572454 25 -10.54783268806198
		 26 -10.746390982194088 27 -10.944803804760289 28 -11.141798819086603 29 -11.336148473221231
		 30 -11.526605974065927 31 -11.711955125131787 32 -11.890929371594877 33 -12.062275144705852
		 34 -12.224765290051863 35 -12.377165247178695 36 -12.518219730080515 37 -12.646721206563761
		 38 -12.761412896695253 39 -12.861066741807347 40 -12.944398099084012 41 -13.010250733697841
		 42 -13.058587528650685 43 -13.090850286198465 44 -13.107444667366934 45 -13.109103814994162
		 46 -13.096354726855642 47 -13.069884359483405 48 -13.030205097185146 49 -12.977913509418556
		 50 -12.913592294704266 51 -12.83793255917492 52 -12.751448866272749 53 -12.654730031593182
		 54 -12.548393067640703 55 -12.433051420646567 56 -12.309236552225615 57 -12.177716648862893
		 58 -12.039254553987076 59 -11.894610659044949 60 -11.744551950342055 61 -11.589816646872222
		 62 -11.43112505291217 63 -11.269294238886507 64 -11.105054936095627 65 -10.939113611426185
		 66 -10.772331469460406 67 -10.605366355302907 68 -10.439019444975903 69 -10.27404051431013
		 70 -10.111162407315204 71 -9.9512009283686371 72 -9.7948625170081431 73 -9.6429215919021942
		 74 -9.4961503765128263 75 -9.3552595803005083 76 -9.221070550443633 77 -9.094318161064562
		 78 -8.9757567273514951 79 -8.8661281741432827 80 -8.7662343333443005;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA";
	rename -uid "7D3B2CB6-4E98-FF41-5312-62A9F59DB348";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.0677757263183594 1 6.1225566864013672
		 2 6.1790962219238281 3 6.2371101379394531 4 6.2962875366210938 5 6.3563346862792969
		 6 6.4169464111328125 7 6.4778289794921875 8 6.5386772155761719 9 6.5991935729980469
		 10 6.6589488983154297 11 6.7175388336181641 12 6.7748889923095703 13 6.8307037353515625
		 14 6.8846912384033203 15 6.9365406036376953 16 6.9859619140625 17 7.0326595306396484
		 18 7.0763225555419922 19 7.1166610717773438 20 7.1533756256103516 21 7.1861648559570313
		 22 7.2147350311279297 23 7.2387866973876953 24 7.2580165863037109 25 7.272125244140625
		 26 7.2808189392089844 27 7.2837982177734375 28 7.2808551788330078 29 7.2722110748291016
		 30 7.2581577301025391 31 7.2389965057373047 32 7.2150287628173828 33 7.1865558624267578
		 34 7.1538829803466797 35 7.1173019409179687 36 7.0771236419677734 37 7.0336418151855469
		 38 6.9871597290039062 39 6.9379806518554687 40 6.8864059448242188 41 6.832733154296875
		 42 6.7772693634033203 43 6.7201805114746094 44 6.6616573333740234 45 6.6022491455078125
		 46 6.5422611236572266 47 6.4819869995117187 48 6.4217395782470703 49 6.36181640625
		 50 6.3025264739990234 51 6.2441596984863281 52 6.1870288848876953 53 6.1314315795898437
		 54 6.0776748657226562 55 6.0260505676269531 56 5.9768695831298828 57 5.9304237365722656
		 58 5.8870258331298828 59 5.8469715118408203 60 5.8105602264404297 61 5.7781009674072266
		 62 5.7498855590820312 63 5.7262210845947266 64 5.7074089050292969 65 5.6937484741210938
		 66 5.6855449676513672 67 5.6830978393554687 68 5.68670654296875 69 5.6966781616210938
		 70 5.711822509765625 71 5.7307415008544922 72 5.7534141540527344 73 5.7798233032226562
		 74 5.8099517822265625 75 5.843780517578125 76 5.8812885284423828 77 5.9224605560302734
		 78 5.9672756195068359 79 6.0157241821289062 80 6.0677757263183594;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA";
	rename -uid "329EE5B3-4A2D-54F0-9246-D4A1383FEC44";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 44.421516418457031 1 44.42352294921875
		 2 44.425605773925781 3 44.427742004394531 4 44.429924011230469 5 44.432144165039063
		 6 44.43438720703125 7 44.4366455078125 8 44.438911437988281 9 44.441162109375 10 44.442481994628906
		 11 44.442062377929688 12 44.441658020019531 13 44.441261291503906 14 44.440872192382813
		 15 44.440498352050781 16 44.440132141113281 17 44.439788818359375 18 44.439460754394531
		 19 44.43914794921875 20 44.438858032226563 21 44.438583374023438 22 44.438331604003906
		 23 44.438102722167969 24 44.437896728515625 25 44.437736511230469 26 44.437591552734375
		 27 44.437484741210938 28 44.437416076660156 29 44.437385559082031 30 44.437393188476563
		 31 44.437423706054687 32 44.4375 33 44.437599182128906 34 44.437728881835938 35 44.437889099121094
		 36 44.438072204589844 37 44.43829345703125 38 44.438529968261719 39 44.438789367675781
		 40 44.439071655273438 41 44.439376831054687 42 44.439697265625 43 44.439125061035156
		 44 44.436759948730469 45 44.43438720703125 46 44.432022094726562 47 44.429679870605469
		 48 44.427375793457031 49 44.42510986328125 50 44.422897338867188 51 44.420761108398438
		 52 44.418701171875 53 44.416732788085938 54 44.41485595703125 55 44.413093566894531
		 56 44.411453247070313 57 44.409942626953125 58 44.4085693359375 59 44.407341003417969
		 60 44.406272888183594 61 44.405380249023438 62 44.404693603515625 63 44.404197692871094
		 64 44.403907775878906 65 44.403816223144531 66 44.403923034667969 67 44.40423583984375
		 68 44.404762268066406 69 44.405494689941406 70 44.406394958496094 71 44.407424926757813
		 72 44.408576965332031 73 44.409843444824219 74 44.411216735839844 75 44.412696838378906
		 76 44.414276123046875 77 44.41595458984375 78 44.417724609375 79 44.419578552246094
		 80 44.421516418457031;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA";
	rename -uid "D1C3F961-46DC-807B-3E25-90946D3AF245";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145320892333984 1 -17.138179779052734
		 2 -17.130996704101562 3 -17.123809814453125 4 -17.116668701171875 5 -17.109603881835938
		 6 -17.102668762207031 7 -17.095893859863281 8 -17.089328765869141 9 -17.083011627197266
		 10 -17.077377319335937 11 -17.072807312011719 12 -17.068592071533203 13 -17.064765930175781
		 14 -17.061363220214844 15 -17.058425903320312 16 -17.055984497070313 17 -17.054073333740234
		 18 -17.052738189697266 19 -17.052005767822266 20 -17.051914215087891 21 -17.052566528320313
		 22 -17.053993225097656 23 -17.056144714355469 24 -17.058986663818359 25 -17.062469482421875
		 26 -17.066547393798828 27 -17.071182250976562 28 -17.076328277587891 29 -17.081939697265625
		 30 -17.087982177734375 31 -17.094409942626953 32 -17.101188659667969 33 -17.108268737792969
		 34 -17.115619659423828 35 -17.123195648193359 36 -17.130958557128906 37 -17.138858795166016
		 38 -17.146865844726563 39 -17.154941558837891 40 -17.163036346435547 41 -17.171115875244141
		 42 -17.179134368896484 43 -17.187450408935547 44 -17.196399688720703 45 -17.205173492431641
		 46 -17.213733673095703 47 -17.222030639648437 48 -17.230014801025391 49 -17.237644195556641
		 50 -17.244869232177734 51 -17.251651763916016 52 -17.257938385009766 53 -17.263687133789063
		 54 -17.268856048583984 55 -17.273391723632813 56 -17.277259826660156 57 -17.280406951904297
		 58 -17.282794952392578 59 -17.284370422363281 60 -17.285099029541016 61 -17.284687042236328
		 62 -17.282943725585937 63 -17.279979705810547 64 -17.275894165039063 65 -17.270797729492188
		 66 -17.264789581298828 67 -17.257976531982422 68 -17.250461578369141 69 -17.242351531982422
		 70 -17.233757019042969 71 -17.224800109863281 72 -17.215583801269531 73 -17.206218719482422
		 74 -17.196807861328125 75 -17.187458038330078 76 -17.178276062011719 77 -17.169361114501953
		 78 -17.16082763671875 79 -17.152778625488281 80 -17.145320892333984;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX";
	rename -uid "7F101A42-4B41-0C3D-DBD0-DAB385547AF7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0
		 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0
		 27 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0
		 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0
		 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 77 0
		 78 0 79 0 80 0;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY";
	rename -uid "CBA5840A-40A7-CDAA-60C8-C78395878DB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 18.737105422408931 1 18.737105422408931
		 2 18.737105422408931 3 18.737105422408931 4 18.737105422408931 5 18.737105422408931
		 6 18.737105422408931 7 18.737105422408931 8 18.737105422408931 9 18.737105422408931
		 10 18.737105422408931 11 18.737105422408931 12 18.737105422408931 13 18.737105422408931
		 14 18.737105422408931 15 18.737105422408931 16 18.737105422408931 17 18.737105422408931
		 18 18.737105422408931 19 18.737105422408931 20 18.737105422408931 21 18.737105422408931
		 22 18.737105422408931 23 18.737105422408931 24 18.737105422408931 25 18.737105422408931
		 26 18.737105422408931 27 18.737105422408931 28 18.737105422408931 29 18.737105422408931
		 30 18.737105422408931 31 18.737105422408931 32 18.737105422408931 33 18.737105422408931
		 34 18.737105422408931 35 18.737105422408931 36 18.737105422408931 37 18.737105422408931
		 38 18.737105422408931 39 18.737105422408931 40 18.737105422408931 41 18.737105422408931
		 42 18.737105422408931 43 18.737105422408931 44 18.737105422408931 45 18.737105422408931
		 46 18.737105422408931 47 18.737105422408931 48 18.737105422408931 49 18.737105422408931
		 50 18.737105422408931 51 18.737105422408931 52 18.737105422408931 53 18.737105422408931
		 54 18.737105422408931 55 18.737105422408931 56 18.737105422408931 57 18.737105422408931
		 58 18.737105422408931 59 18.737105422408931 60 18.737105422408931 61 18.737105422408931
		 62 18.737105422408931 63 18.737105422408931 64 18.737105422408931 65 18.737105422408931
		 66 18.737105422408931 67 18.737105422408931 68 18.737105422408931 69 18.737105422408931
		 70 18.737105422408931 71 18.737105422408931 72 18.737105422408931 73 18.737105422408931
		 74 18.737105422408931 75 18.737105422408931 76 18.737105422408931 77 18.737105422408931
		 78 18.737105422408931 79 18.737105422408931 80 18.737105422408931;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ";
	rename -uid "0EE4B491-407F-5EC7-3A03-0388C2F0926D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0
		 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 18 0 19 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0
		 27 0 28 0 29 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0
		 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 54 0 55 0 56 0 57 0 58 0 59 0 60 0
		 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68 0 69 0 70 0 71 0 72 0 73 0 74 0 75 0 76 0 77 0
		 78 0 79 0 80 0;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "392243B2-4F67-7030-65E0-03B17816D221";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 24.701837539672852 1 24.718145370483398
		 2 24.734981536865234 3 24.752241134643555 4 24.769853591918945 5 24.787714004516602
		 6 24.80572509765625 7 24.823814392089844 8 24.841882705688477 9 24.859851837158203
		 10 24.877622604370117 11 24.895099639892578 12 24.912210464477539 13 24.928855895996094
		 14 24.944948196411133 15 24.960397720336914 16 24.975116729736328 17 24.989030838012695
		 18 25.002021789550781 19 25.014026641845703 20 25.024944305419922 21 25.034687042236328
		 22 25.043180465698242 23 25.050329208374023 24 25.056022644042969 25 25.060207366943359
		 26 25.062774658203125 27 25.063638687133789 28 25.062755584716797 29 25.060163497924805
		 30 25.055965423583984 31 25.050247192382813 32 25.043102264404297 33 25.034614562988281
		 34 25.024871826171875 35 25.013973236083984 36 25.001993179321289 37 24.989036560058594
		 38 24.975173950195313 39 24.960512161254883 40 24.945140838623047 41 24.929130554199219
		 42 24.912582397460938 43 24.895589828491211 44 24.878229141235352 45 24.860607147216797
		 46 24.842798233032227 47 24.824893951416016 48 24.807003021240234 49 24.78919792175293
		 50 24.771577835083008 51 24.754219055175781 52 24.737232208251953 53 24.720678329467773
		 54 24.704685211181641 55 24.689313888549805 56 24.674667358398438 57 24.660831451416016
		 58 24.647903442382813 59 24.635971069335938 60 24.625106811523438 61 24.615432739257812
		 62 24.607017517089844 63 24.59996223449707 64 24.594358444213867 65 24.590288162231445
		 66 24.587841033935547 67 24.587118148803711 68 24.588197708129883 69 24.591169357299805
		 70 24.595695495605469 71 24.601339340209961 72 24.608112335205078 73 24.615989685058594
		 74 24.624977111816406 75 24.635066986083984 76 24.646251678466797 77 24.658533096313477
		 78 24.671894073486328 79 24.686325073242188 80 24.701837539672852;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "4EE81AAC-4035-28A8-5871-7CA0F7DA7C1D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.987054824829102 1 16.992385864257813
		 2 16.997838973999023 3 17.00337028503418 4 17.008974075317383 5 17.014602661132812
		 6 17.020225524902344 7 17.025823593139648 8 17.031364440917969 9 17.036819458007813
		 10 17.042148590087891 11 17.047323226928711 12 17.052341461181641 13 17.057138442993164
		 14 17.061738967895508 15 17.066082000732422 16 17.070156097412109 17 17.073953628540039
		 18 17.077419281005859 19 17.080541610717773 20 17.083297729492188 21 17.085651397705078
		 22 17.087594985961914 23 17.089117050170898 24 17.090152740478516 25 17.090763092041016
		 26 17.090875625610352 27 17.09050178527832 28 17.089624404907227 29 17.08824348449707
		 30 17.086429595947266 31 17.084165573120117 32 17.08152961730957 33 17.078483581542969
		 34 17.075088500976562 35 17.071371078491211 36 17.067338943481445 37 17.063043594360352
		 38 17.058475494384766 39 17.053674697875977 40 17.048666000366211 41 17.043491363525391
		 42 17.038150787353516 43 17.03270149230957 44 17.027072906494141 45 17.021421432495117
		 46 17.015707015991211 47 17.009983062744141 48 17.004283905029297 49 16.998594284057617
		 50 16.993011474609375 51 16.987518310546875 52 16.982156753540039 53 16.976978302001953
		 54 16.971990585327148 55 16.967216491699219 56 16.962724685668945 57 16.958528518676758
		 58 16.954677581787109 59 16.951164245605469 60 16.948060989379883 61 16.945446014404297
		 62 16.94331169128418 63 16.941738128662109 64 16.940685272216797 65 16.940212249755859
		 66 16.940309524536133 67 16.940969467163086 68 16.942256927490234 69 16.944126129150391
		 70 16.946500778198242 71 16.949226379394531 72 16.952297210693359 73 16.955703735351563
		 74 16.959384918212891 75 16.963394165039063 76 16.967657089233398 77 16.972185134887695
		 78 16.976919174194336 79 16.981889724731445 80 16.987054824829102;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "2295A1DB-45A1-9E58-3BE6-57A511A64CE2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -18.297317504882812 1 -18.295261383056641
		 2 -18.293169021606445 3 -18.291107177734375 4 -18.289043426513672 5 -18.286996841430664
		 6 -18.284996032714844 7 -18.283029556274414 8 -18.281131744384766 9 -18.279302597045898
		 10 -18.277551651000977 11 -18.275909423828125 12 -18.274379730224609 13 -18.27296257019043
		 14 -18.271673202514648 15 -18.270538330078125 16 -18.269559860229492 17 -18.268764495849609
		 18 -18.26814079284668 19 -18.267728805541992 20 -18.267536163330078 21 -18.267574310302734
		 22 -18.267858505249023 23 -18.268396377563477 24 -18.269174575805664 25 -18.270172119140625
		 26 -18.271364212036133 27 -18.272760391235352 28 -18.274349212646484 29 -18.276092529296875
		 30 -18.278013229370117 31 -18.280069351196289 32 -18.282253265380859 33 -18.284551620483398
		 34 -18.286943435668945 35 -18.289432525634766 36 -18.29197883605957 37 -18.294589996337891
		 38 -18.297258377075195 39 -18.299934387207031 40 -18.30262565612793 41 -18.305320739746094
		 42 -18.308010101318359 43 -18.310659408569336 44 -18.313289642333984 45 -18.315849304199219
		 46 -18.31834602355957 47 -18.320751190185547 48 -18.323066711425781 49 -18.325283050537109
		 50 -18.327365875244141 51 -18.329307556152344 52 -18.331113815307617 53 -18.332742691040039
		 54 -18.334217071533203 55 -18.335500717163086 56 -18.336585998535156 57 -18.337455749511719
		 58 -18.338096618652344 59 -18.338508605957031 60 -18.338665008544922 61 -18.338493347167969
		 62 -18.337928771972656 63 -18.337005615234375 64 -18.335750579833984 65 -18.334203720092773
		 66 -18.332405090332031 67 -18.330364227294922 68 -18.328130722045898 69 -18.325735092163086
		 70 -18.323192596435547 71 -18.320550918579102 72 -18.317834854125977 73 -18.315078735351562
		 74 -18.312324523925781 75 -18.309581756591797 76 -18.306896209716797 77 -18.304283142089844
		 78 -18.301811218261719 79 -18.299467086791992 80 -18.297317504882812;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "E80909B6-4ED3-700D-10E5-26A452D9D91C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -27.817066159610302 1 -27.816294905919506
		 2 -27.815530229981999 3 -27.814779949488255 4 -27.81401547317212 5 -27.813258419680174
		 6 -27.812531208050075 7 -27.811821864741308 8 -27.811123339097293 9 -27.810504774087473
		 10 -27.809847930849202 11 -27.809270101035359 12 -27.808703859476882 13 -27.808141200053043
		 14 -27.807643430653883 15 -27.807154317451275 16 -27.806684353293342 17 -27.806222198655782
		 18 -27.805755079953691 19 -27.80531609445481 20 -27.804855640498094 21 -27.804395971330941
		 22 -27.803909333846235 23 -27.803408979565933 24 -27.802895469695436 25 -27.802367748943023
		 26 -27.801841939750155 27 -27.801296683762104 28 -27.80075868747511 29 -27.800248407888759
		 30 -27.799739742005109 31 -27.799238692810263 32 -27.79875592490842 33 -27.798285827635102
		 34 -27.797874661061115 35 -27.797460872200677 36 -27.797092606686977 37 -27.796779102496092
		 38 -27.796522260028855 39 -27.796316428113805 40 -27.796172508375086 41 -27.796097197545265
		 42 -27.796118683311725 43 -27.796160774452311 44 -27.796333840728437 45 -27.796545316573244
		 46 -27.796851644789839 47 -27.797262988394447 48 -27.797724091607659 49 -27.798282801857045
		 50 -27.798897071137958 51 -27.799594890251342 52 -27.800378165943837 53 -27.801196535279978
		 54 -27.802088289734346 55 -27.803032662485684 56 -27.804012269945577 57 -27.805054613707746
		 58 -27.806101650390485 59 -27.807169815577357 60 -27.808259123200525 61 -27.809357503784355
		 62 -27.810495374959281 63 -27.811667366521839 64 -27.81280070766012 65 -27.813886573065997
		 66 -27.814896711560156 67 -27.81582755481989 68 -27.816625777841633 69 -27.817279898173098
		 70 -27.817811410318292 71 -27.818262832704143 72 -27.81859996892484 73 -27.818866356257924
		 74 -27.818989227377443 75 -27.819015993817473 76 -27.81889208526831 77 -27.818660200813571
		 78 -27.81826634985088 79 -27.817739335580388 80 -27.817066159610302;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "5C9AF4F4-4788-D8B0-C17D-308338AA0B2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 11.767878665944169 1 11.846335327659595
		 2 11.927289974103426 3 12.010321444999922 4 12.095008397705344 5 12.180885330406593
		 6 12.267552858846363 7 12.354575744755586 8 12.441510088434688 9 12.527933205545384
		 10 12.613443120776624 11 12.697571224444772 12 12.779914728358705 13 12.860022128637878
		 14 12.937490020243562 15 13.011894834020055 16 13.082791995833663 17 13.149756580531356
		 18 13.212385578435523 19 13.270229283005737 20 13.322861467942712 21 13.369886533575974
		 22 13.410850096856997 23 13.445337763733187 24 13.472922436944179 25 13.493150449980496
		 26 13.505649941937307 27 13.509955164272093 28 13.505775678658894 29 13.493449928438871
		 30 13.473370675608251 31 13.445976949176121 32 13.41166729931005 33 13.370935168397921
		 34 13.324157469861083 35 13.271774064055853 36 13.2142245854153 37 13.151923213466199
		 38 13.085327076452151 39 13.014836119937645 40 12.940885697415023 41 12.863925548386247
		 42 12.784343865183118 43 12.702602717213704 44 12.61912759227055 45 12.534344780918742
		 46 12.448709340921708 47 12.362642052181631 48 12.276544134054175 49 12.190875497436043
		 50 12.106073875647686 51 12.02254738925005 52 11.940809483320342 53 11.861170408788805
		 54 11.78414023969871 55 11.710168015933709 56 11.639638724782371 57 11.573019927765444
		 58 11.510758415329567 59 11.453263244623324 60 11.40099101630965 61 11.354335958464965
		 62 11.313753886849549 63 11.279708722855343 64 11.252569132301149 65 11.23286337509931
		 66 11.220981737542353 67 11.217347479929559 68 11.222408682120189 69 11.236593499004941
		 70 11.258237625143456 71 11.285294543160092 72 11.317689981302486 73 11.355498038006751
		 74 11.398625563649919 75 11.447060843475404 76 11.500781215867335 77 11.559744163639449
		 78 11.623919500465387 79 11.693326606942273 80 11.767878665944169;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "435F6A03-4EF6-7B63-5AB0-4CB63F5C4F56";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -10.121490879014077 1 -10.110195600227099
		 2 -10.098822591561177 3 -10.087421895607214 4 -10.076062072159239 5 -10.06484112987421
		 6 -10.05377005213751 7 -10.04295567321897 8 -10.032427990942919 9 -10.022317474708489
		 10 -10.012590568659476 11 -10.003404320534088 12 -9.9947762661391959 13 -9.9867711346676042
		 14 -9.9794736475963681 15 -9.9729483362841176 16 -9.9672326220134533 17 -9.9624209750532309
		 18 -9.9585562984492579 19 -9.9557179111516767 20 -9.9539595485473029 21 -9.9534292053222924
		 22 -9.9542224658420064 23 -9.9562395851709642 24 -9.9594570559446538 25 -9.9638248456166707
		 26 -9.969312653562076 27 -9.975815512461196 28 -9.9833213649456223 29 -9.9917522543578503
		 30 -10.001025344179212 31 -10.011089091469369 32 -10.021869752723171 33 -10.03328479575784
		 34 -10.045260902698661 35 -10.057764493236549 36 -10.070674041451174 37 -10.083930253934199
		 38 -10.097474817718538 39 -10.111270855253968 40 -10.125190560406651 41 -10.139170933041934
		 42 -10.153181941133774 43 -10.167112934300574 44 -10.180918296082284 45 -10.194492479306945
		 46 -10.207798347116828 47 -10.22075483284045 48 -10.233279254462989 49 -10.245326991130248
		 50 -10.256797756696995 51 -10.26762969397064 52 -10.277739723561851 53 -10.287110221892187
		 54 -10.295607593020875 55 -10.303172349096288 56 -10.309744748262707 57 -10.315253043059299
		 58 -10.319625491669481 59 -10.322785820105484 60 -10.324657928108671 61 -10.324850041804867
		 62 -10.323051980402786 63 -10.319435923348829 64 -10.314122261130018 65 -10.307240553636197
		 66 -10.298949983509164 67 -10.289396540303489 68 -10.278692642940261 69 -10.267002483440212
		 70 -10.254518062330478 71 -10.241417527857982 72 -10.227870744612723 73 -10.214026025640626
		 74 -10.200041741542888 75 -10.18605741799227 76 -10.172233448380741 77 -10.158705540472685
		 78 -10.145626641481439 79 -10.133171616849657 80 -10.121490879014077;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "DEE919DF-470F-5374-BEF2-F9A02D74F82A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -20.967266082763672 1 -20.952354431152344
		 2 -20.936983108520508 3 -20.921226501464844 4 -20.90516471862793 5 -20.888889312744141
		 6 -20.872474670410156 7 -20.856006622314453 8 -20.839565277099609 9 -20.823223114013672
		 10 -20.807075500488281 11 -20.791183471679688 12 -20.77564811706543 13 -20.760532379150391
		 14 -20.745929718017578 15 -20.731910705566406 16 -20.71855354309082 17 -20.7059326171875
		 18 -20.694137573242187 19 -20.683235168457031 20 -20.673301696777344 21 -20.664430618286133
		 22 -20.65667724609375 23 -20.650146484375 24 -20.644903182983398 25 -20.641010284423828
		 26 -20.638587951660156 27 -20.637687683105469 28 -20.638374328613281 29 -20.640583038330078
		 30 -20.644252777099609 31 -20.649286270141602 32 -20.655616760253906 33 -20.663158416748047
		 34 -20.671844482421875 35 -20.681583404541016 36 -20.692291259765625 37 -20.70390510559082
		 38 -20.716341018676758 39 -20.729520797729492 40 -20.743366241455078 41 -20.757797241210937
		 42 -20.772735595703125 43 -20.788087844848633 44 -20.803789138793945 45 -20.819766998291016
		 46 -20.835920333862305 47 -20.852176666259766 48 -20.868453979492188 49 -20.884674072265625
		 50 -20.900747299194336 51 -20.916585922241211 52 -20.932132720947266 53 -20.947273254394531
		 54 -20.961944580078125 55 -20.976058959960938 56 -20.989526748657227 57 -21.002262115478516
		 58 -21.014190673828125 59 -21.025226593017578 60 -21.035266876220703 61 -21.044252395629883
		 62 -21.052097320556641 63 -21.058704376220703 64 -21.064004898071289 65 -21.067895889282227
		 66 -21.070295333862305 67 -21.071107864379883 68 -21.070261001586914 69 -21.067659378051758
		 70 -21.063648223876953 71 -21.05859375 72 -21.052509307861328 73 -21.045400619506836
		 74 -21.037258148193359 75 -21.028112411499023 76 -21.017948150634766 77 -21.006771087646484
		 78 -20.994598388671875 79 -20.981422424316406 80 -20.967266082763672;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "390BEA3E-46A9-D1C6-37E9-CCBF171CDD7E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.391769409179688 1 16.383060455322266
		 2 16.374042510986328 3 16.364749908447266 4 16.355262756347656 5 16.345603942871094
		 6 16.335819244384766 7 16.325969696044922 8 16.316097259521484 9 16.306270599365234
		 10 16.296489715576172 11 16.286849975585938 12 16.277381896972656 13 16.268138885498047
		 14 16.25916862487793 15 16.250518798828125 16 16.242229461669922 17 16.234390258789063
		 18 16.227016448974609 19 16.220169067382812 20 16.21392822265625 21 16.208282470703125
		 22 16.203338623046875 23 16.199119567871094 24 16.195667266845703 25 16.193099975585938
		 26 16.191404342651367 27 16.190677642822266 28 16.190942764282227 29 16.192146301269531
		 30 16.194257736206055 31 16.197227478027344 32 16.201015472412109 33 16.205556869506836
		 34 16.210762023925781 35 16.216653823852539 36 16.22313117980957 37 16.230159759521484
		 38 16.237682342529297 39 16.245655059814453 40 16.253997802734375 41 16.262702941894531
		 42 16.271694183349609 43 16.280937194824219 44 16.290363311767578 45 16.299945831298828
		 46 16.309574127197266 47 16.319286346435547 48 16.328968048095703 49 16.338607788085938
		 50 16.34814453125 51 16.3575439453125 52 16.366714477539063 53 16.375679016113281
		 54 16.384317398071289 55 16.392616271972656 56 16.400554656982422 57 16.408054351806641
		 58 16.415067672729492 59 16.42158317565918 60 16.427518844604492 61 16.432861328125
		 62 16.437538146972656 63 16.441558837890625 64 16.444828033447266 65 16.447301864624023
		 66 16.448936462402344 67 16.449634552001953 68 16.449386596679687 69 16.448143005371094
		 70 16.446094512939453 71 16.443397521972656 72 16.440128326416016 73 16.436264038085938
		 74 16.431758880615234 75 16.426654815673828 76 16.420936584472656 77 16.414588928222656
		 78 16.407611846923828 79 16.400028228759766 80 16.391769409179688;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "00F04E24-440E-8317-136E-89857BD97D00";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.197517395019531 1 -29.196853637695313
		 2 -29.196229934692383 3 -29.195648193359375 4 -29.195106506347656 5 -29.194606781005859
		 6 -29.194187164306641 7 -29.193805694580078 8 -29.193487167358398 9 -29.193241119384766
		 10 -29.193059921264648 11 -29.192947387695313 12 -29.19293212890625 13 -29.19297981262207
		 14 -29.193120956420898 15 -29.193340301513672 16 -29.19366455078125 17 -29.194084167480469
		 18 -29.194585800170898 19 -29.195207595825195 20 -29.195915222167969 21 -29.196781158447266
		 22 -29.197757720947266 23 -29.198841094970703 24 -29.200010299682617 25 -29.201269149780273
		 26 -29.202579498291016 27 -29.203920364379883 28 -29.205280303955078 29 -29.206663131713867
		 30 -29.208065032958984 31 -29.209453582763672 32 -29.210834503173828 33 -29.212217330932617
		 34 -29.213611602783203 35 -29.214971542358398 36 -29.216329574584961 37 -29.217645645141602
		 38 -29.218954086303711 39 -29.220218658447266 40 -29.221450805664062 41 -29.222631454467773
		 42 -29.223770141601563 43 -29.224870681762695 44 -29.225889205932617 45 -29.226863861083984
		 46 -29.227767944335938 47 -29.228597640991211 48 -29.229351043701172 49 -29.230010986328125
		 50 -29.230598449707031 51 -29.23109245300293 52 -29.231460571289062 53 -29.231746673583984
		 54 -29.231904983520508 55 -29.23194694519043 56 -29.231861114501953 57 -29.23164176940918
		 58 -29.231298446655273 59 -29.230810165405273 60 -29.230157852172852 61 -29.229293823242188
		 62 -29.228153228759766 63 -29.226778030395508 64 -29.225217819213867 65 -29.223487854003906
		 66 -29.22161865234375 67 -29.219673156738281 68 -29.217672348022461 69 -29.215663909912109
		 70 -29.213626861572266 71 -29.211584091186523 72 -29.209558486938477 73 -29.207561492919922
		 74 -29.205663681030273 75 -29.203874588012695 76 -29.202219009399414 77 -29.200719833374023
		 78 -29.199422836303711 79 -29.198335647583008 80 -29.197517395019531;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "12175501-4605-6467-C15C-5BAC66D03A90";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 33.467410093817001 1 33.483481873045534
		 2 33.500130114811931 3 33.517219915808369 4 33.534735433144732 5 33.552537458419927
		 6 33.570514772341866 7 33.588626541428788 8 33.606784616495688 9 33.624867205134201
		 10 33.642783826444294 11 33.660482422634409 12 33.677807369681638 13 33.694747815815049
		 14 33.71112625923287 15 33.726896222489344 16 33.741925366701722 17 33.756161344796041
		 18 33.769479404257908 19 33.781780359014171 20 33.792970463094711 21 33.802961602664709
		 22 33.811661265296429 23 33.818958606449051 24 33.824752118224197 25 33.828965101451573
		 26 33.831495161351768 27 33.832264096551981 28 33.831189966189108 29 33.828357986422603
		 30 33.823848687884023 31 33.817769123365778 32 33.810204948183205 33 33.801277839510931
		 34 33.791074147413987 35 33.779710321694971 36 33.767242640075629 37 33.753779666456609
		 38 33.739444330058511 39 33.724323446118625 40 33.708505165619734 41 33.69209755600636
		 42 33.67519081329835 43 33.657890730084702 44 33.640255681437836 45 33.622437645496369
		 46 33.604465840421454 47 33.586483038760356 48 33.568579048545516 49 33.550808231481824
		 50 33.533259407671537 51 33.516034456112784 52 33.499231707618655 53 33.482941416031792
		 54 33.46722711546127 55 33.452177766799245 56 33.437872511032005 57 33.424440909907801
		 58 33.411902610263034 59 33.40034499037521 60 33.38990996352679 61 33.38059992351171
		 62 33.372590279264557 63 33.365891621159456 64 33.360609439892805 65 33.356864320377746
		 66 33.354645901062284 67 33.354122340273399 68 33.355302892229957 69 33.358312147702961
		 70 33.362826978185197 71 33.368451123771848 72 33.375160292640295 73 33.382927405742684
		 74 33.391778392697489 75 33.401704490660428 76 33.41272696607863 77 33.424793162353033
		 78 33.437923202371664 79 33.45212377876733 80 33.467410093817001;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "3020551C-4C3A-783E-13BF-BA9B1307ABE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.0365495067244694 1 5.1086666770308504
		 2 5.1831249581719323 3 5.2594424810697511 4 5.3372277112834157 5 5.4161143821208935
		 6 5.4956933477303798 7 5.5755814173237637 8 5.6553583013965634 9 5.7346610070213284
		 10 5.8130573658840898 11 5.8901913495508476 12 5.9656616838678751 13 6.0391155712488853
		 14 6.1101168649919915 15 6.1782958484112545 16 6.2432646857233491 17 6.3046434054685934
		 18 6.3620706457102143 19 6.4151247360735875 20 6.46341762223875 21 6.5066306202676847
		 22 6.5443165975762385 23 6.5761090911910633 24 6.6016209074480612 25 6.6204385708905154
		 26 6.6322149231171545 27 6.6365358645564676 28 6.6330838027229406 29 6.6222096494301477
		 30 6.6042472797773133 31 6.5795739563140199 32 6.5486283399078724 33 6.511755004074181
		 34 6.4693729659706678 35 6.4218317741590303 36 6.3695457702642138 37 6.3128927033897488
		 38 6.2522375809714772 39 6.1880137154139963 40 6.1205895979588565 41 6.0502964470738183
		 42 5.9776318841322142 43 5.902898160860155 44 5.8265284679072931 45 5.7489185929527338
		 46 5.6704118579730789 47 5.5914839618313099 48 5.5124792495917116 49 5.4338014803074888
		 50 5.3558413650912193 51 5.2790398698527232 52 5.2037584394220069 53 5.1304263149701779
		 54 5.0594246609198059 55 4.9911429255341666 56 4.926026608855171 57 4.8644378158618329
		 58 4.8068390809297386 59 4.7535906820560312 60 4.7051184964607016 61 4.6617845139258947
		 62 4.624017231464391 63 4.5922151931772 64 4.5668029812788724 65 4.5481690832676769
		 66 4.5367752286698808 67 4.5329721768096158 68 4.5372371446354647 69 4.549945735462142
		 70 4.569515303353473 71 4.5941015315100264 72 4.6236374824148223 73 4.6581310792327155
		 74 4.697555499435059 75 4.7419109330329388 76 4.7911521681371108 77 4.8452605999082676
		 78 4.9042141632647285 79 4.9679879604235184 80 5.0365495067244694;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "01A9E64F-498F-5D41-7764-0D855DB76DF8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 5.8806851588466333 1 5.8879186964695673
		 2 5.895101619132368 3 5.9022030810784996 4 5.909176295918944 5 5.915986697925641
		 6 5.9225830050816093 7 5.9289056956407666 8 5.9349272549874801 9 5.9406152136070336
		 10 5.9459173984692928 11 5.9507826719653467 12 5.9551719019870522 13 5.9590482579718449
		 14 5.9624001481202544 15 5.9651530091599652 16 5.967230018206604 17 5.9686544468966023
		 18 5.9693608600560024 19 5.9692769843716906 20 5.9683954609735768 21 5.9665931507091106
		 22 5.9638065522769894 23 5.9601324949155732 24 5.9556358281848674 25 5.9503385319476614
		 26 5.9444002462057783 27 5.9378290407757559 28 5.9307158909157422 29 5.923076959502084
		 30 5.9150302866485021 31 5.9065274670305108 32 5.8976991982966966 33 5.8885803563926258
		 34 5.8791833976157442 35 5.8695619537081294 36 5.859773745256466 37 5.8498926854399906
		 38 5.8399200957864741 39 5.829921663709027 40 5.8199580723769309 41 5.8100749648104379
		 42 5.8002999716147263 43 5.7907013236078324 44 5.781294864214864 45 5.7721913431976324
		 46 5.7633359813828129 47 5.7549002823681619 48 5.7468555664467811 49 5.739283085491615
		 50 5.7321889316105237 51 5.7256602651960256 52 5.7197333457237809 53 5.7144812220138759
		 54 5.7099048796693124 55 5.7061052952290066 56 5.7030953312115686 57 5.7009290036279863
		 58 5.699661903181326 59 5.6993704809184305 60 5.700059371171732 61 5.702113452441635
		 62 5.7058122011430203 63 5.7110229103655916 64 5.717508956634024 65 5.7251750578242264
		 66 5.7338456060996732 67 5.7433450387542972 68 5.7535273579950372 69 5.7642868368848621
		 70 5.775445229364637 71 5.7869102034652187 72 5.7985654917427691 73 5.8102760064239947
		 74 5.8218393743510353 75 5.8331816498259643 76 5.8440790093927619 77 5.8544343261957099
		 78 5.864074223497024 79 5.8728903915214756 80 5.8806851588466333;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA";
	rename -uid "E1983FF1-4ABE-B85B-BE79-D6B89FD5E4CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 30.566905975341797 1 30.576675415039063
		 2 30.586877822875977 3 30.597217559814453 4 30.607553482055664 5 30.61762809753418
		 6 30.627193450927734 7 30.63603401184082 8 30.643871307373047 9 30.65052604675293
		 10 30.655656814575195 11 30.658903121948242 12 30.660289764404297 13 30.658882141113281
		 14 30.653934478759766 15 30.645742416381836 16 30.63438606262207 17 30.620168685913086
		 18 30.603185653686523 19 30.583751678466797 20 30.562101364135742 21 30.538488388061523
		 22 30.513103485107422 23 30.48619270324707 24 30.457941055297852 25 30.428525924682617
		 26 30.398128509521484 27 30.366958618164062 28 30.335245132446289 29 30.303220748901367
		 30 30.271183013916016 31 30.239274978637695 32 30.207923889160156 33 30.17719841003418
		 34 30.147420883178711 35 30.118741989135742 36 30.091379165649414 37 30.065546035766602
		 38 30.041349411010742 39 30.019027709960938 40 29.998634338378906 41 29.980411529541016
		 42 29.964431762695313 43 29.950712203979492 44 29.939168930053711 45 29.929832458496094
		 46 29.922300338745117 47 29.916419982910156 48 29.912172317504883 49 29.909481048583984
		 50 29.908260345458984 51 29.910518646240234 52 29.917861938476562 53 29.929904937744141
		 54 29.94636344909668 55 29.966808319091797 56 29.990978240966797 57 30.018587112426758
		 58 30.049333572387695 59 30.082841873168945 60 30.118688583374023 61 30.156417846679688
		 62 30.19537353515625 63 30.23499870300293 64 30.274616241455078 65 30.313522338867188
		 66 30.350828170776367 67 30.385747909545898 68 30.417503356933594 69 30.445222854614258
		 70 30.467906951904297 71 30.485830307006836 72 30.500288009643555 73 30.512006759643555
		 74 30.521562576293945 75 30.529630661010742 76 30.536741256713867 77 30.543535232543945
		 78 30.550487518310547 79 30.55811882019043 80 30.566905975341797;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA";
	rename -uid "2C735BE0-459E-F8D9-6B20-82B8BF481CED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 79.924430847167969 1 79.789505004882813
		 2 79.654693603515625 3 79.52056884765625 4 79.387710571289063 5 79.256759643554688
		 6 79.128341674804688 7 79.003105163574219 8 78.882766723632813 9 78.770309448242188
		 10 78.667411804199219 11 78.575904846191406 12 78.500022888183594 13 78.45208740234375
		 14 78.441085815429687 15 78.464576721191406 16 78.520065307617188 17 78.605072021484375
		 18 78.717147827148437 19 78.853775024414063 20 79.012458801269531 21 79.190650939941406
		 22 79.386039733886719 23 79.596298217773438 24 79.819168090820313 25 80.052467346191406
		 26 80.294029235839844 27 80.541763305664063 28 80.79351806640625 29 81.047409057617188
		 30 81.301467895507813 31 81.553802490234375 32 81.802566528320312 33 82.046012878417969
		 34 82.282257080078125 35 82.509696960449219 36 82.726593017578125 37 82.931205749511719
		 38 83.121940612792969 39 83.297096252441406 40 83.455055236816406 41 83.594070434570313
		 42 83.711738586425781 43 83.803779602050781 44 83.866127014160156 45 83.904808044433594
		 46 83.926895141601562 47 83.933113098144531 48 83.924301147460937 49 83.901107788085938
		 50 83.864334106445312 51 83.816940307617188 52 83.761550903320313 53 83.698280334472656
		 54 83.627449035644531 55 83.549179077148438 56 83.463752746582031 57 83.371315002441406
		 58 83.271858215332031 59 83.165626525878906 60 83.052604675292969 61 82.932998657226563
		 62 82.806907653808594 63 82.674446105957031 64 82.535804748535156 65 82.390998840332031
		 66 82.240303039550781 67 82.083953857421875 68 81.922233581542969 69 81.75543212890625
		 70 81.58380126953125 71 81.408554077148438 72 81.231658935546875 73 81.054473876953125
		 74 80.878448486328125 75 80.704902648925781 76 80.535369873046875 77 80.371116638183594
		 78 80.213653564453125 79 80.06427001953125 80 79.924430847167969;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA";
	rename -uid "5461A2F9-4EBB-077D-C508-7EA4F5FDE62B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.1169586181640625 1 2.2017059326171875
		 2 2.2817287445068359 3 2.3535137176513672 4 2.4136085510253906 5 2.4584560394287109
		 6 2.4845542907714844 7 2.4883937835693359 8 2.4689083099365234 9 2.4282321929931641
		 10 2.3671760559082031 11 2.2867393493652344 12 2.1888465881347656 13 2.0747261047363281
		 14 1.9455413818359375 15 1.8026409149169922 16 1.6473922729492187 17 1.4811744689941406
		 18 1.305267333984375 19 1.1209774017333984 20 0.92973899841308594 21 0.73288154602050781
		 22 0.53164863586425781 23 0.32737541198730469 24 0.12133598327636719 25 -0.085132598876953125
		 26 -0.29076957702636719 27 -0.49431610107421875 28 -0.69449043273925781 29 -0.89006996154785156
		 30 -1.0798015594482422 31 -1.2624835968017578 32 -1.4369297027587891 33 -1.6019668579101563
		 34 -1.7564277648925781 35 -1.8991298675537109 36 -2.0289859771728516 37 -2.1448726654052734
		 38 -2.2456855773925781 39 -2.3302726745605469 40 -2.3976325988769531 41 -2.4465522766113281
		 42 -2.4771709442138672 43 -2.4910163879394531 44 -2.4892082214355469 45 -2.4718952178955078
		 46 -2.4400596618652344 47 -2.3945541381835937 48 -2.336029052734375 49 -2.2653026580810547
		 50 -2.1830806732177734 51 -2.0900592803955078 52 -1.9869461059570313 53 -1.8744297027587891
		 54 -1.7532577514648437 55 -1.6241073608398438 56 -1.4877300262451172 57 -1.3448352813720703
		 58 -1.1960544586181641 59 -1.0420284271240234 60 -0.88352584838867188 61 -0.72106170654296875
		 62 -0.55534172058105469 63 -0.3871002197265625 64 -0.2170257568359375 65 -0.045833587646484375
		 66 0.12568855285644531 67 0.29686355590820313 68 0.4669036865234375 69 0.6350250244140625
		 70 0.80047607421875 71 0.9622955322265625 72 1.1197624206542969 73 1.2718982696533203
		 74 1.4178409576416016 75 1.5567607879638672 76 1.6878166198730469 77 1.8101634979248047
		 78 1.9230022430419922 79 2.0255298614501953 80 2.1169586181640625;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX";
	rename -uid "91A28D4B-4376-BD6B-FADD-DB9A962276A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -68.573234376474701 1 -68.815330860891748
		 2 -69.037968826849948 3 -69.242907857111504 4 -69.431709008584889 5 -69.606075422733326
		 6 -69.76761846269784 7 -69.917899205478179 8 -70.058482952246607 9 -70.190997966559351
		 10 -70.316930909146222 11 -70.437793731633931 12 -70.555172053086253 13 -70.670438740394403
		 14 -70.785217892412547 15 -70.900871110224813 16 -71.00581182718004 17 -71.09028811621863
		 18 -71.155414835399441 19 -71.200556673064938 20 -71.226943654565432 21 -71.235835683999966
		 22 -71.228589302602174 23 -71.206339805974764 24 -71.170497521827656 25 -71.122234907640618
		 26 -71.0629552854612 27 -70.993801223580533 28 -70.91619807903372 29 -70.831322606510113
		 30 -70.740506185178418 31 -70.644842466445581 32 -70.545817168438788 33 -70.444459212046368
		 34 -70.342091584769875 35 -70.239820039055999 36 -70.138847912994521 37 -70.040432930394658
		 38 -69.945590249456941 39 -69.85551816557718 40 -69.771348481333931 41 -69.694155250930862
		 42 -69.625081556074932 43 -69.565240039332963 44 -69.51580467294059 45 -69.45012458817321
		 46 -69.342994249277652 47 -69.197794283307331 48 -69.019213514792028 49 -68.812583997467996
		 50 -68.583236902521634 51 -68.336542053005516 52 -68.077733605570984 53 -67.812289570511354
		 54 -67.545538862723802 55 -67.282771487815751 56 -67.029438139768388 57 -66.790907502654008
		 58 -66.572664707475269 59 -66.380048080635007 60 -66.218464402295993 61 -66.093357180367093
		 62 -66.010247446208936 63 -65.963554201269872 64 -65.944682700348167 65 -65.95403158580956
		 66 -65.992111255589691 67 -66.059412846435578 68 -66.156375444850781 69 -66.278740177450956
		 70 -66.420908706537247 71 -66.581201560938638 72 -66.758089335563724 73 -66.949853514494194
		 74 -67.154835665656577 75 -67.371514711396529 76 -67.598208499519174 77 -67.833378501851698
		 78 -68.075319649207813 79 -68.322447617102199 80 -68.573234376474701;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY";
	rename -uid "2857D367-4272-E6F1-33C8-97A2452D1AD2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.5996607568730972 1 3.5312094146979729
		 2 3.4049015660022004 3 3.2285728577206592 4 3.0101150742630209 5 2.7572599471894788
		 6 2.4780429712685299 7 2.1802003086080064 8 1.871680976830473 9 1.5603142388574023
		 10 1.2539659743915135 11 0.9605782342491338 12 0.68803088980887717 13 0.44412038724364317
		 14 0.23683922419603354 15 0.074050607817165867 16 -0.034543790060622498 17 -0.079493017389737297
		 18 -0.064169984386998336 19 0.00060961369509669326 20 0.11114881055137718 21 0.26386039405207401
		 22 0.45515818610439629 23 0.68133079226188342 24 0.93877084771588826 25 1.2238371486267379
		 26 1.5329285583669077 27 1.862494116066383 28 2.2087156755367849 29 2.5681326057394331
		 30 2.9370720712046032 31 3.3118957977835644 32 3.6889791835844279 33 4.0647410350897797
		 34 4.4354681771408391 35 4.7975769155990831 36 5.1474722129186539 37 5.4814937929080045
		 38 5.796052997367438 39 6.0874725785826946 40 6.352212472214247 41 6.586539046602101
		 42 6.7868826047582136 43 6.9496369240845839 44 7.0711551934599024 45 7.151795558262215
		 46 7.1918933800067659 47 7.188063295146395 48 7.1422501576669593 49 7.058450384487025
		 50 6.9404543527779206 51 6.7922901536081213 52 6.6178901169599103 53 6.4210920879684856
		 54 6.2058359876654894 55 5.9760248115366448 56 5.7354297897135522 57 5.4880803504232585
		 58 5.2377036105029191 59 4.9882789549084583 60 4.743522872721166 61 4.5074037738324506
		 62 4.2837046620071444 63 4.0779489285868689 64 3.8962639800584364 65 3.7430482434477907
		 66 3.6230869790197504 67 3.5409458375503462 68 3.5012829101666463 69 3.4918733353528415
		 70 3.4953403271568675 71 3.5088784195205438 72 3.5295078114822531 73 3.5543165681216715
		 74 3.580386860273574 75 3.6047657438249963 76 3.6246109327889462 77 3.6369281015894934
		 78 3.6388724051034309 79 3.6273976418257603 80 3.5996607568730972;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "A4A8FBAD-44C3-8677-3DC1-86B074C3EED7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 74.728139844130311 1 74.756848428073809
		 2 74.786313470335031 3 74.816120449409212 4 74.846051731127602 5 74.875751456946546
		 6 74.904981049604928 7 74.933417580341498 8 74.960906889907235 9 74.987146041813574
		 10 75.012217410159636 11 75.03586147187427 12 75.058082651902154 13 75.078901738596926
		 14 75.098326563156604 15 75.116297960091273 16 75.131418668335527 17 75.142315581233717
		 18 75.149232808782628 19 75.152407280937894 20 75.152053561370295 21 75.148320939172322
		 22 75.141429159151627 23 75.131489985625109 24 75.118732100076954 25 75.103315104876955
		 26 75.085374377770407 27 75.06513426366017 28 75.042817815889876 29 75.018549029561825
		 30 74.992628898257962 31 74.965363383069985 32 74.936923194191053 33 74.907732735719435
		 34 74.877981741269679 35 74.848097125202329 36 74.818437384826439 37 74.789369381341217
		 38 74.761328785633538 39 74.734693393323226 40 74.709889519968726 41 74.687375739575444
		 42 74.667556490670464 43 74.65099141172881 44 74.637991348933653 45 74.625853475792866
		 46 74.611870482047877 47 74.596721872845194 48 74.580769181066572 49 74.564352149930471
		 50 74.547826017805576 51 74.531392430609287 52 74.515346477905524 53 74.499976442734265
		 54 74.485452287353795 55 74.472131757882295 56 74.460223989012533 57 74.450001603866042
		 58 74.441751322907706 59 74.435781406620123 60 74.432338656306683 61 74.431861803346266
		 62 74.4346409578107 63 74.439846397796018 64 74.446564156751705 65 74.454487013001383
		 66 74.4636969229024 67 74.474010214605954 68 74.485407740645527 69 74.497962871614433
		 70 74.51192424367423 71 74.527380970601982 72 74.544222054867376 73 74.562465710973996
		 74 74.582034466831786 75 74.603068928544232 76 74.625414783899359 77 74.649126328535814
		 78 74.674177372677306 79 74.700490745400771 80 74.728139844130311;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA";
	rename -uid "B592E8B8-4550-5B93-4DED-33AB6DBBDD3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.794830322265625 1 -42.702972412109375
		 2 -42.612277984619141 3 -42.523334503173828 4 -42.436710357666016 5 -42.352870941162109
		 6 -42.272342681884766 7 -42.195552825927734 8 -42.122581481933594 9 -42.052742004394531
		 10 -41.985569000244141 11 -41.920791625976563 12 -41.857627868652344 13 -41.79498291015625
		 14 -41.732120513916016 15 -41.669097900390625 16 -41.606338500976562 17 -41.544120788574219
		 18 -41.482749938964844 19 -41.422451019287109 20 -41.363563537597656 21 -41.306369781494141
		 22 -41.251178741455078 23 -41.1983642578125 24 -41.148139953613281 25 -41.100860595703125
		 26 -41.057872772216797 27 -41.020572662353516 28 -40.989082336425781 29 -40.963554382324219
		 30 -40.944023132324219 31 -40.930587768554688 32 -40.926216125488281 33 -40.933551788330078
		 34 -40.952114105224609 35 -40.981269836425781 36 -41.020545959472656 37 -41.069320678710937
		 38 -41.127109527587891 39 -41.193302154541016 40 -41.26727294921875 41 -41.350746154785156
		 42 -41.444850921630859 43 -41.548423767089844 44 -41.660152435302734 45 -41.778488159179688
		 46 -41.902126312255859 47 -42.029788970947266 48 -42.160102844238281 49 -42.291820526123047
		 50 -42.423583984375 51 -42.554115295410156 52 -42.682182312011719 53 -42.806568145751953
		 54 -42.926013946533203 55 -43.039405822753906 56 -43.145515441894531 57 -43.243228912353516
		 58 -43.332382202148438 59 -43.41326904296875 60 -43.485313415527344 61 -43.548038482666016
		 62 -43.601192474365234 63 -43.644527435302734 64 -43.677783966064453 65 -43.700801849365234
		 66 -43.713455200195313 67 -43.715255737304688 68 -43.703792572021484 69 -43.677818298339844
		 70 -43.638778686523438 71 -43.588020324707031 72 -43.526813507080078 73 -43.456199645996094
		 74 -43.377395629882813 75 -43.291465759277344 76 -43.199604034423828 77 -43.102897644042969
		 78 -43.002429962158203 79 -42.899383544921875 80 -42.794830322265625;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA";
	rename -uid "E11D1F58-410B-467C-7C43-1288A58DDD8C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 58.386558532714844 1 58.412433624267578
		 2 58.42681884765625 3 58.428848266601563 4 58.417621612548828 5 58.392230987548828
		 6 58.351787567138672 7 58.295364379882812 8 58.222640991210938 9 58.134326934814453
		 10 58.0299072265625 11 57.908767700195313 12 57.773197174072266 13 57.622165679931641
		 14 57.455413818359375 15 57.274124145507813 16 57.07940673828125 17 56.87255859375
		 18 56.654693603515625 19 56.427009582519531 20 56.190864562988281 21 55.947433471679688
		 22 55.698188781738281 23 55.444438934326172 24 55.187606811523438 25 54.929103851318359
		 26 54.675762176513672 27 54.433807373046875 28 54.20404052734375 29 53.986976623535156
		 30 53.783447265625 31 53.593990325927734 32 53.419563293457031 33 53.260402679443359
		 34 53.117595672607422 35 52.991615295410156 36 52.883140563964844 37 52.792778015136719
		 38 52.721141815185547 39 52.668960571289062 40 52.636848449707031 41 52.636093139648438
		 42 52.676017761230469 43 52.752174377441406 44 52.860275268554687 45 52.998405456542969
		 46 53.162948608398438 47 53.350418090820313 48 53.557174682617188 49 53.779800415039062
		 50 54.014694213867187 51 54.258338928222656 52 54.507076263427734 53 54.757369995117188
		 54 55.005538940429688 55 55.247810363769531 56 55.480655670166016 57 55.700187683105469
		 58 55.908111572265625 59 56.108139038085938 60 56.299716949462891 61 56.482559204101563
		 62 56.656837463378906 63 56.82293701171875 64 56.980869293212891 65 57.130180358886719
		 66 57.270660400390625 67 57.402427673339844 68 57.525638580322266 69 57.640384674072266
		 70 57.746788024902344 71 57.844936370849609 72 57.935050964355469 73 58.01727294921875
		 74 58.091728210449219 75 58.158683776855469 76 58.218284606933594 77 58.270698547363281
		 78 58.316062927246094 79 58.354625701904297 80 58.386558532714844;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA";
	rename -uid "D173D8D5-4EC4-230B-27E2-A196446BDAF0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.795326232910156 1 -42.708309173583984
		 2 -42.617382049560547 3 -42.526638031005859 4 -42.440166473388672 5 -42.362014770507813
		 6 -42.296169281005859 7 -42.246540069580078 8 -42.214286804199219 9 -42.196853637695312
		 10 -42.193168640136719 11 -42.201961517333984 12 -42.220878601074219 13 -42.248481750488281
		 14 -42.283214569091797 15 -42.323719024658203 16 -42.369167327880859 17 -42.418407440185547
		 18 -42.470317840576172 19 -42.523880004882813 20 -42.577934265136719 21 -42.631538391113281
		 22 -42.683799743652344 23 -42.733928680419922 24 -42.781242370605469 25 -42.825054168701172
		 26 -42.8641357421875 27 -42.897480010986328 28 -42.925136566162109 29 -42.947185516357422
		 30 -42.963840484619141 31 -42.975284576416016 32 -42.982151031494141 33 -42.985172271728516
		 34 -42.984489440917969 35 -42.980361938476563 36 -42.973064422607422 37 -42.962879180908203
		 38 -42.949951171875 39 -42.934482574462891 40 -42.916538238525391 41 -42.896190643310547
		 42 -42.874420166015625 43 -42.853279113769531 44 -42.834079742431641 45 -42.820625305175781
		 46 -42.816097259521484 47 -42.819786071777344 48 -42.830810546875 49 -42.84820556640625
		 50 -42.870933532714844 51 -42.897972106933594 52 -42.928302764892578 53 -42.960853576660156
		 54 -42.994720458984375 55 -43.029006958007813 56 -43.063068389892578 57 -43.096187591552734
		 58 -43.127922058105469 59 -43.157741546630859 60 -43.18524169921875 61 -43.209922790527344
		 62 -43.231491088867188 63 -43.249595642089844 64 -43.263923645019531 65 -43.275321960449219
		 66 -43.284320831298828 67 -43.290275573730469 68 -43.292396545410156 69 -43.289955139160156
		 70 -43.282352447509766 71 -43.269016265869141 72 -43.249317169189453 73 -43.222759246826172
		 74 -43.188777923583984 75 -43.146816253662109 76 -43.096195220947266 77 -43.036392211914063
		 78 -42.966705322265625 79 -42.886573791503906 80 -42.795326232910156;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX";
	rename -uid "1F677F1A-411B-A859-5C75-31B656AA2824";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -75.317575734977908 1 -75.317623118125056
		 2 -75.317592431749645 3 -75.317635694697529 4 -75.317605050503403 5 -75.317644833040262
		 6 -75.317634262038965 7 -75.317660312184586 8 -75.317563844000517 9 -75.317536134440275
		 10 -75.317643222522534 11 -75.317611499453733 12 -75.317675946635816 13 -75.317613429470612
		 14 -75.317588519678466 15 -75.317623733795443 16 -75.317589313403346 17 -75.317608865220876
		 18 -75.317606583710884 19 -75.317598167060595 20 -75.317597013497192 21 -75.317564108824058
		 22 -75.317611262101494 23 -75.317600832323336 24 -75.317666253028051 25 -75.317682132634644
		 26 -75.317588552741157 27 -75.317651716522491 28 -75.317630149429419 29 -75.317589145604146
		 30 -75.31763927085737 31 -75.317554549036487 32 -75.317610481469856 33 -75.317676064547911
		 34 -75.317594394665861 35 -75.317605186290393 36 -75.317613731884236 37 -75.317596760926435
		 38 -75.317576335399593 39 -75.317609783077359 40 -75.317647831979627 41 -75.317617349772348
		 42 -75.31756703405776 43 -75.317647251394376 44 -75.317591144250542 45 -75.317591664467244
		 46 -75.317594963868601 47 -75.317644917939276 48 -75.31767629627646 49 -75.3176075129103
		 50 -75.317603739475601 51 -75.317630252165557 52 -75.317615451822832 53 -75.317570253179426
		 54 -75.317637750962049 55 -75.317683146702734 56 -75.317602389887881 57 -75.317627646582622
		 58 -75.317638639758769 59 -75.317647627260527 60 -75.317671609638197 61 -75.317669175383699
		 62 -75.317638183581721 63 -75.317619277101286 64 -75.317679353491101 65 -75.317643004928399
		 66 -75.317645407073741 67 -75.317581061664256 68 -75.317551375881862 69 -75.317649417955593
		 70 -75.317544533102023 71 -75.317596334262888 72 -75.317668165190767 73 -75.31766058921616
		 74 -75.317651657251332 75 -75.317573162245282 76 -75.317612419083503 77 -75.317563808000884
		 78 -75.317649698766601 79 -75.317597834400573 80 -75.317575734977908;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY";
	rename -uid "C19D586B-4926-685D-902B-95A37A6BDA6F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 57.995092867432319 1 57.995122631836011
		 2 57.995059229344392 3 57.995083376895501 4 57.995078996086669 5 57.99512077513117
		 6 57.995143797579544 7 57.995074441127421 8 57.995060610951235 9 57.995063692424679
		 10 57.995111830994396 11 57.995040750683252 12 57.995076376590141 13 57.995101729695129
		 14 57.995095387824904 15 57.995059767168961 16 57.995076427489352 17 57.995108900695186
		 18 57.995126875533366 19 57.995105941639586 20 57.99512232845202 21 57.995069944907328
		 22 57.995037360409846 23 57.99509547229443 24 57.995111713483233 25 57.995126143943082
		 26 57.995077926196522 27 57.995100893821608 28 57.995122020638789 29 57.995084067715453
		 30 57.995133118812966 31 57.995066429830565 32 57.995108568005413 33 57.995066962167506
		 34 57.995101035571523 35 57.99505681449569 36 57.995102199705059 37 57.995123632647193
		 38 57.995086920939457 39 57.995136607545064 40 57.995090772284115 41 57.995093381155122
		 42 57.995074535999052 43 57.995095268909566 44 57.995107403872552 45 57.995116136338659
		 46 57.995122156846257 47 57.995128822331054 48 57.995086693495267 49 57.995069893974033
		 50 57.995096990898141 51 57.995117300673606 52 57.995058079812246 53 57.995088171223607
		 54 57.995110527722389 55 57.995084273819224 56 57.995116263680892 57 57.995074642966834
		 58 57.995091871198746 59 57.995134757093815 60 57.995101745489329 61 57.995108537622684
		 62 57.995112221454328 63 57.995056491705277 64 57.995100403282422 65 57.995112343940896
		 66 57.995083946202257 67 57.995086739618706 68 57.995085869095561 69 57.995078440112287
		 70 57.995090329256243 71 57.995074784285094 72 57.995086582750389 73 57.995087348978899
		 74 57.995089184181289 75 57.995106360206066 76 57.995070999415319 77 57.995100469433901
		 78 57.99506540078216 79 57.995093472157798 80 57.995092867432319;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "A10729CF-4DCD-E3C6-9A38-2C8464BB63F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 166.04873736411326 1 166.0486608047199
		 2 166.0487515504139 3 166.04868672873766 4 166.04870439384456 5 166.04866070518653
		 6 166.04867954221393 7 166.04869048614242 8 166.0487326538649 9 166.0487472782188
		 10 166.04870188483321 11 166.04872384652165 12 166.04865569665884 13 166.04871178129216
		 14 166.04870858689915 15 166.0487200223682 16 166.04871378279063 17 166.04869234897117
		 18 166.04873843568453 19 166.04872019193101 20 166.04872199123551 21 166.0487321277883
		 22 166.04872433568394 23 166.04872453799456 24 166.0486618112337 25 166.04865467735834
		 26 166.04870597006462 27 166.04866524098858 28 166.0486947300156 29 166.04872195544601
		 30 166.04865428314767 31 166.04874318556372 32 166.0486892571459 33 166.04865605137633
		 34 166.04874059322427 35 166.04870311884017 36 166.04870177765559 37 166.04872346752691
		 38 166.04872049272049 39 166.04871453499723 40 166.04869931669194 41 166.04869478005318
		 42 166.04876443715793 43 166.04868428150544 44 166.04872807271613 45 166.04874203679933
		 46 166.04869978664317 47 166.04866367670084 48 166.04863780823601 49 166.04870541370309
		 50 166.04872153417384 51 166.04869607183809 52 166.04868397463309 53 166.04873268862954
		 54 166.04869212955748 55 166.04864496085739 56 166.04869754790153 57 166.04871990488914
		 58 166.04871119021232 59 166.04864546630799 60 166.04864521578409 61 166.0486578202898
		 62 166.04868343082001 63 166.04867344251807 64 166.04864859528737 65 166.04869452612903
		 66 166.0486684854317 67 166.0487177232794 68 166.04874615950465 69 166.04865623666399
		 70 166.04874681785756 71 166.04872020586765 72 166.04866179470088 73 166.04867057639566
		 74 166.04868878457387 75 166.04872346665709 76 166.04869914667077 77 166.04875754194325
		 78 166.04868063290962 79 166.04869020733938 80 166.04873736411326;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA";
	rename -uid "DD03C0D5-4FA2-30BD-4400-068A89A78579";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 28.093341827392578 1 28.12565803527832
		 2 28.158971786499023 3 28.193138122558594 4 28.227924346923828 5 28.26318359375 6 28.298730850219727
		 7 28.334383010864258 8 28.369972229003906 9 28.405328750610352 10 28.440568923950195
		 11 28.475801467895508 12 28.510255813598633 13 28.54376220703125 14 28.576107025146484
		 15 28.607158660888672 16 28.636724472045898 17 28.66462516784668 18 28.690681457519531
		 19 28.714729309082031 20 28.736595153808594 21 28.756109237670898 22 28.7730712890625
		 23 28.787342071533203 24 28.798713684082031 25 28.807037353515625 26 28.8121337890625
		 27 28.813817977905273 28 28.811988830566406 29 28.806745529174805 30 28.798297882080078
		 31 28.78679084777832 32 28.772411346435547 33 28.755350112915039 34 28.735767364501953
		 35 28.713855743408203 36 28.689767837524414 37 28.663702011108398 38 28.635807037353516
		 39 28.60627555847168 40 28.575305938720703 41 28.543025970458984 42 28.509649276733398
		 43 28.475669860839844 44 28.441551208496094 45 28.406875610351563 46 28.371814727783203
		 47 28.336540222167969 48 28.301250457763672 49 28.266092300415039 50 28.231279373168945
		 51 28.19694709777832 52 28.163314819335938 53 28.130546569824219 54 28.098823547363281
		 55 28.068332672119141 56 28.03924560546875 57 28.011751174926758 58 27.986061096191406
		 59 27.962326049804688 60 27.940727233886719 61 27.921474456787109 62 27.90472412109375
		 63 27.890682220458984 64 27.879518508911133 65 27.871417999267578 66 27.866573333740234
		 67 27.865133285522461 68 27.8673095703125 69 27.873270034790039 70 27.882303237915039
		 71 27.893569946289063 72 27.907070159912109 73 27.922773361206055 74 27.940664291381836
		 75 27.960758209228516 76 27.983011245727539 77 28.007411956787109 78 28.033935546875
		 79 28.062587738037109 80 28.093341827392578;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA";
	rename -uid "C01D9786-49BA-B0F9-121F-38909C418FD9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 31.650505065917969 1 31.652824401855469
		 2 31.655265808105469 3 31.657726287841797 4 31.660293579101563 5 31.662899017333984
		 6 31.665546417236328 7 31.668228149414063 8 31.670951843261719 9 31.673648834228516
		 10 31.67578125 11 31.676746368408203 12 31.677745819091797 13 31.678688049316406
		 14 31.679645538330078 15 31.680564880371094 16 31.681449890136719 17 31.682327270507813
		 18 31.683170318603516 19 31.683971405029297 20 31.684711456298828 21 31.685359954833984
		 22 31.685993194580078 23 31.686576843261719 24 31.687046051025391 25 31.687488555908203
		 26 31.687770843505859 27 31.687995910644531 28 31.688125610351562 29 31.688117980957031
		 30 31.688014984130859 31 31.687816619873047 32 31.68756103515625 33 31.687210083007813
		 34 31.686775207519531 35 31.686286926269531 36 31.685718536376953 37 31.68511962890625
		 38 31.684444427490234 39 31.683731079101563 40 31.682952880859375 41 31.682159423828125
		 42 31.681354522705078 43 31.679924011230469 44 31.677280426025391 45 31.674644470214844
		 46 31.671951293945313 47 31.669296264648437 48 31.666679382324219 49 31.664043426513672
		 50 31.661479949951172 51 31.658973693847656 52 31.656524658203125 53 31.654170989990234
		 54 31.651908874511719 55 31.649715423583984 56 31.647651672363281 57 31.645721435546875
		 58 31.643905639648438 59 31.642234802246094 60 31.640716552734375 61 31.639369964599609
		 62 31.638168334960938 63 31.637172698974609 64 31.6363525390625 65 31.635761260986328
		 66 31.635360717773438 67 31.635208129882813 68 31.635311126708984 69 31.635654449462891
		 70 31.636192321777344 71 31.63690185546875 72 31.637779235839844 73 31.638813018798828
		 74 31.639995574951172 75 31.641323089599609 76 31.642833709716797 77 31.644493103027344
		 78 31.646350860595703 79 31.648342132568359 80 31.650505065917969;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "18A16C79-47AC-1817-688D-3194CF4CF335";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.043968200683594 1 -13.043879508972168
		 2 -13.044087409973145 3 -13.044445991516113 4 -13.045233726501465 5 -13.046258926391602
		 6 -13.047580718994141 7 -13.049238204956055 8 -13.051193237304688 9 -13.053423881530762
		 10 -13.054598808288574 11 -13.053328514099121 12 -13.052422523498535 13 -13.051843643188477
		 14 -13.051687240600586 15 -13.051836967468262 16 -13.052335739135742 17 -13.053204536437988
		 18 -13.054462432861328 19 -13.056039810180664 20 -13.057975769042969 21 -13.060222625732422
		 22 -13.062944412231445 23 -13.06593132019043 24 -13.069188117980957 25 -13.072653770446777
		 26 -13.076206207275391 27 -13.079875946044922 28 -13.083547592163086 29 -13.087272644042969
		 30 -13.09093189239502 31 -13.094646453857422 32 -13.098362922668457 33 -13.102069854736328
		 34 -13.105769157409668 35 -13.109443664550781 36 -13.113153457641602 37 -13.116844177246094
		 38 -13.120569229125977 39 -13.124333381652832 40 -13.128002166748047 41 -13.131780624389648
		 42 -13.135543823242188 43 -13.137791633605957 44 -13.137259483337402 45 -13.136634826660156
		 46 -13.13593578338623 47 -13.135251045227051 48 -13.134471893310547 49 -13.133673667907715
		 50 -13.132796287536621 51 -13.131917953491211 52 -13.130941390991211 53 -13.129861831665039
		 54 -13.128741264343262 55 -13.127458572387695 56 -13.126070976257324 57 -13.124540328979492
		 58 -13.122737884521484 59 -13.120759010314941 60 -13.118541717529297 61 -13.115853309631348
		 62 -13.112668991088867 63 -13.108972549438477 64 -13.104875564575195 65 -13.10047721862793
		 66 -13.095778465270996 67 -13.091023445129395 68 -13.086153984069824 69 -13.081296920776367
		 70 -13.076491355895996 71 -13.071738243103027 72 -13.067087173461914 73 -13.062606811523438
		 74 -13.058462142944336 75 -13.054597854614258 76 -13.051198959350586 77 -13.048340797424316
		 78 -13.04619026184082 79 -13.04466724395752 80 -13.043968200683594;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "1774B059-4983-E747-776E-95A28C526003";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.11792002677073997 1 0.13373682145458909
		 2 0.15012179361942782 3 0.16700608382398052 4 0.18430782100324167 5 0.20194643788923866
		 6 0.21977887664440876 7 0.23778121014995654 8 0.25582611024334978 9 0.27381978579813221
		 10 0.29161138923804814 11 0.30908084571683497 12 0.32627479118949854 13 0.34310425301075154
		 14 0.35945153164498472 15 0.37522093586759686 16 0.39036953310391614 17 0.40471188408905412
		 18 0.41823954323052154 19 0.43078966695520526 20 0.44231927944630473 21 0.45269348677224458
		 22 0.46184152909907811 23 0.46966190668813046 24 0.47604278989271914 25 0.48088911366845344
		 26 0.48411010146347427 27 0.48558979621963216 28 0.48527628930178929 29 0.48321847925963157
		 30 0.47953387716281826 31 0.47431117171318837 32 0.46762602671087605 33 0.45958591841658208
		 34 0.45029345453559494 35 0.43984520676646044 36 0.42830997536213505 37 0.41583545072203493
		 38 0.4024575753138584 39 0.38830680498922571 40 0.37348342502912868 41 0.35806865193273374
		 42 0.34215175555063354 43 0.32579455537706936 44 0.30895522604916337 45 0.29183585446009674
		 46 0.27455174005461197 47 0.25719497436774197 48 0.23981358910341663 49 0.22253022121737456
		 50 0.2054282876778471 51 0.18854847506608796 52 0.17203501496844709 53 0.15594436982024976
		 54 0.14035147617445837 55 0.12534268202321111 56 0.11101448453517687 57 0.097405048973232072
		 58 0.084626439656669522 59 0.072765001057586751 60 0.061852952385197613 61 0.051983582941593706
		 62 0.043157887794149398 63 0.03552528635893399 64 0.029158662276454469 65 0.02418142323635062
		 66 0.020668800512065929 67 0.018775434699636807 68 0.018602811049974306 69 0.020235494820600747
		 70 0.023362626110158363 71 0.02760687897947375 72 0.032956234554795912 73 0.039425911217678002
		 74 0.047057811815933673 75 0.055846031561154509 76 0.065825714225008589 77 0.077006436079346569
		 78 0.089401695756057969 79 0.10302908168303475 80 0.11792002677073997;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "ADA95612-4890-6502-0DA1-959F12886AA5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.37342159744703818 1 -0.31458040142870292
		 2 -0.25386340996976159 3 -0.19156531254668258 4 -0.1280784514643834 5 -0.063672469143141494
		 6 0.0013740856688723966 7 0.066663523131204272 8 0.13192130746938116 9 0.19678754445704794
		 10 0.26146813080220505 11 0.32603316333608545 12 0.38924696115324536 13 0.45078910326945959
		 14 0.5102996319862334 15 0.56752092665956144 16 0.62207647011722322 17 0.67363782940326677
		 18 0.72194668239415727 19 0.76658580938797971 20 0.80732798319499988 21 0.8438446325240897
		 22 0.87571789264387245 23 0.90271283030339611 24 0.92445615037704054 25 0.94063324937425385
		 26 0.95088904132484453 27 0.95490569252242985 28 0.95237750009366307 29 0.94366392101107321
		 30 0.92899286445137896 31 0.90869287287493317 32 0.88310950268897614 33 0.85258755248879547
		 34 0.81740434426285036 35 0.77795740906832422 36 0.73448788450468461 37 0.68735495550715897
		 38 0.63690605439953363 39 0.58339237627611307 40 0.5272208226281293 41 0.4686714389080579
		 42 0.40807751128542702 43 0.34627373569815545 44 0.284032863576479 45 0.22077190250280143
		 46 0.15676880111934108 47 0.092412856708361732 48 0.027939983430115573 49 -0.036282784406657963
		 50 -0.099937989227753446 51 -0.16266031649557275 52 -0.22420356809311781 53 -0.28413732137964981
		 54 -0.34225646287480632 55 -0.39812895827842892 56 -0.45152661024485868 57 -0.50201363081922923
		 58 -0.54928377397482608 59 -0.59307753467092916 60 -0.63297847817303854 61 -0.66874096734450994
		 62 -0.70005394239667684 63 -0.72657445456555791 64 -0.74795396736773778 65 -0.76382087417674627
		 66 -0.77382117419008134 67 -0.7776136493000444 68 -0.77484520132798618 69 -0.7651639026263688
		 70 -0.74986717047279261 71 -0.7305145220086805 72 -0.70706604986562882 73 -0.67953595719850191
		 74 -0.6479628847802148 75 -0.61226858236213944 76 -0.57258383005334834 77 -0.52881950692212065
		 78 -0.48108056544750183 79 -0.42923133169112587 80 -0.37342159744703818;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "136089B0-47D9-9CAD-6DAE-83974E135B0D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -27.76265023056359 1 -27.758709598742822
		 2 -27.755569555358626 3 -27.752685028264928 4 -27.751150730324454 5 -27.750281329016051
		 6 -27.750251100514017 7 -27.751293004381331 8 -27.753219751446704 9 -27.756002957823735
		 10 -27.754334364575548 11 -27.742820882079972 12 -27.732517194386666 13 -27.723327653340903
		 14 -27.715674395895935 15 -27.709073432383867 16 -27.70373974338343 17 -27.699754008743444
		 18 -27.697175460910334 19 -27.695834936465779 20 -27.695790249269702 21 -27.696903647103888
		 22 -27.699828222672689 23 -27.703794149475019 24 -27.708968734959392 25 -27.715261078771693
		 26 -27.722298977688826 27 -27.730286705348707 28 -27.738901828624449 29 -27.748384769097939
		 30 -27.758118458008312 31 -27.768716977699487 32 -27.77990815121192 33 -27.791605491524642
		 34 -27.803862121014006 35 -27.816530313876569 36 -27.829873240414564 37 -27.843671554482718
		 38 -27.858026735647847 39 -27.873088672244467 40 -27.888254086703025 41 -27.904262210607392
		 42 -27.920674884705171 43 -27.93155515642372 44 -27.931796470910506 45 -27.932132480299153
		 46 -27.932567067316235 47 -27.933417491692769 48 -27.934298397208856 49 -27.935401733506655
		 50 -27.936561297083049 51 -27.938036521395279 52 -27.939450876924631 53 -27.940765004881477
		 54 -27.94215677624582 55 -27.943234046017224 56 -27.944131404313804 57 -27.944685926384448
		 58 -27.944467669999803 59 -27.943811163109842 60 -27.942379405002967 61 -27.939615818642448
		 62 -27.935545215688173 63 -27.929946725712032 64 -27.923082284022655 65 -27.915085813053167
		 66 -27.905778366662531 67 -27.896014296600583 68 -27.885258664961189 69 -27.873840407655486
		 70 -27.862102317322027 71 -27.850146441201371 72 -27.8380590031427 73 -27.826000619482919
		 74 -27.814463788444439 75 -27.803151202667458 76 -27.792636450392699 77 -27.783074742845546
		 78 -27.774982151469477 79 -27.768008320628063 80 -27.76265023056359;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA";
	rename -uid "3DDBF4C7-4AB3-DFF0-20A8-1FA5D2528845";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -22.966213226318359 1 -22.943878173828125
		 2 -22.920814514160156 3 -22.897098541259766 4 -22.87286376953125 5 -22.848220825195313
		 6 -22.823305130004883 7 -22.798242568969727 8 -22.773136138916016 9 -22.748111724853516
		 10 -22.723482131958008 11 -22.699504852294922 12 -22.675992965698242 13 -22.653072357177734
		 14 -22.630867004394531 15 -22.609504699707031 16 -22.589111328125 17 -22.569812774658203
		 18 -22.551731109619141 19 -22.534999847412109 20 -22.519741058349609 21 -22.506088256835938
		 22 -22.494157791137695 23 -22.484094619750977 24 -22.476028442382813 25 -22.470064163208008
		 26 -22.466346740722656 27 -22.465019226074219 28 -22.466133117675781 29 -22.469623565673828
		 30 -22.475357055664063 31 -22.483226776123047 32 -22.493061065673828 33 -22.504783630371094
		 34 -22.518238067626953 35 -22.533294677734375 36 -22.549839019775391 37 -22.567724227905273
		 38 -22.586832046508789 39 -22.607040405273438 40 -22.628211975097656 41 -22.650222778320312
		 42 -22.672962188720703 43 -22.696422576904297 44 -22.720691680908203 45 -22.745279312133789
		 46 -22.770076751708984 47 -22.794952392578125 48 -22.819772720336914 49 -22.844436645507812
		 50 -22.868778228759766 51 -22.892723083496094 52 -22.916118621826172 53 -22.938854217529297
		 54 -22.960800170898438 55 -22.981857299804688 56 -23.001895904541016 57 -23.020793914794922
		 58 -23.038436889648437 59 -23.054708480834961 60 -23.069482803344727 61 -23.082653045654297
		 62 -23.094104766845703 63 -23.103721618652344 64 -23.111379623413086 65 -23.116958618164063
		 66 -23.120328903198242 67 -23.12138557434082 68 -23.119998931884766 69 -23.116039276123047
		 70 -23.110004425048828 71 -23.10243034362793 72 -23.093351364135742 73 -23.082748413085938
		 74 -23.070613861083984 75 -23.056991577148437 76 -23.041849136352539 77 -23.025196075439453
		 78 -23.007041931152344 79 -22.987380981445313 80 -22.966213226318359;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA";
	rename -uid "27EB9CAA-4BD7-0088-161B-13BD18ADDC8A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 16.259443283081055 1 16.269285202026367
		 2 16.279481887817383 3 16.290006637573242 4 16.300836563110352 5 16.31193733215332
		 6 16.323183059692383 7 16.334558486938477 8 16.34602165222168 9 16.357538223266602
		 10 16.368135452270508 11 16.37708854675293 12 16.385953903198242 13 16.394643783569336
		 14 16.403142929077148 15 16.411359786987305 16 16.419294357299805 17 16.426836013793945
		 18 16.434000015258789 19 16.440679550170898 20 16.446859359741211 21 16.45246696472168
		 22 16.457487106323242 23 16.46177864074707 24 16.465330123901367 25 16.468137741088867
		 26 16.470067977905273 27 16.47105598449707 28 16.471139907836914 29 16.470277786254883
		 30 16.468545913696289 31 16.465970993041992 32 16.462701797485352 33 16.458646774291992
		 34 16.453939437866211 35 16.448629379272461 36 16.442731857299805 37 16.436368942260742
		 38 16.42951774597168 39 16.42228889465332 40 16.414678573608398 41 16.406797409057617
		 42 16.398595809936523 43 16.389455795288086 44 16.378461837768555 45 16.367364883422852
		 46 16.356161117553711 47 16.344987869262695 48 16.333833694458008 49 16.322771072387695
		 50 16.311880111694336 51 16.30119514465332 52 16.290769577026367 53 16.280649185180664
		 54 16.270895004272461 55 16.261533737182617 56 16.25261116027832 57 16.244211196899414
		 58 16.236330032348633 59 16.229074478149414 60 16.222414016723633 61 16.216436386108398
		 62 16.211153030395508 63 16.206560134887695 64 16.202821731567383 65 16.199934005737305
		 66 16.197980880737305 67 16.196985244750977 68 16.197042465209961 69 16.198209762573242
		 70 16.200296401977539 71 16.203065872192383 72 16.206457138061523 73 16.210588455200195
		 74 16.215383529663086 75 16.22089958190918 76 16.22712516784668 77 16.234079360961914
		 78 16.24177360534668 79 16.250234603881836 80 16.259443283081055;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "C75FAECA-4161-1308-8FE9-3FA09379C933";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -13.382806777954102 1 -13.381056785583496
		 2 -13.37934398651123 3 -13.377640724182129 4 -13.37601375579834 5 -13.374420166015625
		 6 -13.372905731201172 7 -13.371467590332031 8 -13.370121955871582 9 -13.368864059448242
		 10 -13.367738723754883 11 -13.36674976348877 12 -13.365874290466309 13 -13.365130424499512
		 14 -13.364506721496582 15 -13.364028930664063 16 -13.363683700561523 17 -13.363485336303711
		 18 -13.363445281982422 19 -13.363567352294922 20 -13.363842964172363 21 -13.364298820495605
		 22 -13.364941596984863 23 -13.365765571594238 24 -13.366730690002441 25 -13.367836952209473
		 26 -13.369045257568359 27 -13.370388984680176 28 -13.371807098388672 29 -13.373282432556152
		 30 -13.374851226806641 31 -13.376470565795898 32 -13.378149032592773 33 -13.37989330291748
		 34 -13.38166618347168 35 -13.38348388671875 36 -13.385346412658691 37 -13.387221336364746
		 38 -13.389134407043457 39 -13.391061782836914 40 -13.392982482910156 41 -13.394919395446777
		 42 -13.396847724914551 43 -13.398775100708008 44 -13.400716781616211 45 -13.402631759643555
		 46 -13.404514312744141 47 -13.406352043151855 48 -13.408132553100586 49 -13.40984058380127
		 50 -13.411492347717285 51 -13.413042068481445 52 -13.414498329162598 53 -13.415835380554199
		 54 -13.417028427124023 55 -13.418086051940918 56 -13.418977737426758 57 -13.419717788696289
		 58 -13.420253753662109 59 -13.420594215393066 60 -13.420706748962402 61 -13.420548439025879
		 62 -13.420001983642578 63 -13.419149398803711 64 -13.417998313903809 65 -13.416565895080566
		 66 -13.414885520935059 67 -13.412990570068359 68 -13.410905838012695 69 -13.408681869506836
		 70 -13.406335830688477 71 -13.403861045837402 72 -13.401346206665039 73 -13.398806571960449
		 74 -13.396265029907227 75 -13.393747329711914 76 -13.391290664672852 77 -13.388948440551758
		 78 -13.386721611022949 79 -13.38465404510498 80 -13.382806777954102;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "59475AEE-4B73-D1E3-4E6F-A49C7E94CB39";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.345079559958704 1 15.418198364222075
		 2 15.493467572962729 3 15.570486399119712 4 15.648818029089307 5 15.728077797174917
		 6 15.807815511519687 7 15.887695289239314 8 15.967264115318256 9 16.046167930783312
		 10 16.123976995302321 11 16.200366542351745 12 16.274913799179622 13 16.34727739455359
		 14 16.417106876184231 15 16.483962002117057 16 16.54754210728332 17 16.607471961289715
		 18 16.663361420914498 19 16.714879662976806 20 16.761649852534212 21 16.803342850243808
		 22 16.839585870342155 23 16.870022734777201 24 16.894283171059485 25 16.911996680596225
		 26 16.92285903792401 27 16.926451460784598 28 16.92251621120624 29 16.911354525961734
		 30 16.893315843754259 31 16.868766619079896 32 16.838095512049794 33 16.801619569954294
		 34 16.759779429017293 35 16.712859824364706 36 16.661250657984201 37 16.60529552138475
		 38 16.545374452353251 39 16.481869705531512 40 16.415119591671207 41 16.345481781615039
		 42 16.273361540086423 43 16.199117678861082 44 16.123110383972321 45 16.045755502021624
		 46 15.967396972148151 47 15.88846386937597 48 15.809322425205318 49 15.730411699153377
		 50 15.652094920574754 51 15.574798885659554 52 15.498926766016792 53 15.424940865625242
		 54 15.353235977706518 55 15.284195513650575 56 15.21831420805834 57 15.155954083062321
		 58 15.097640258337503 59 15.043714773974589 60 14.994650358067224 61 14.950878092220702
		 62 14.912852596266086 63 14.880986126073697 64 14.855702732301188 65 14.837436339378204
		 66 14.826612337284123 67 14.823574537821099 68 14.828808888086005 69 14.842674844564414
		 70 14.863548653253156 71 14.88955047826642 72 14.920578957469269 73 14.956619037766243
		 74 14.997636845975597 75 15.043579964455702 76 15.094373678266225 77 15.149965557262544
		 78 15.210315835511665 79 15.275390540824295 80 15.345079559958704;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "3DE3FED0-4959-6DD1-D4AD-4F8B0F8B4007";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 3.4502778849200428 1 3.4879112746461591
		 2 3.5269165855824216 3 3.5672027651624592 4 3.6085147822535206 5 3.6507719062698576
		 6 3.6936767004534214 7 3.7370111751074226 8 3.7805977923278218 9 3.8242507711286162
		 10 3.8666021977597418 11 3.9064716486963089 12 3.9457810169448608 13 3.9842248925167776
		 14 4.0216517382485266 15 4.0577833721358632 16 4.092446139968426 17 4.125337709012169
		 18 4.1563021659361619 19 4.1850060417884078 20 4.2112934525185528 21 4.2349419330452598
		 22 4.2556663652046129 23 4.2732373730329503 24 4.2874454790956058 25 4.297947413559962
		 26 4.3046742505909128 27 4.3072293978042033 28 4.3055816031831542 29 4.2997845043084446
		 30 4.290182737972259 31 4.2768563457923054 32 4.2601951139623226 33 4.2402514565430574
		 34 4.2174432600598903 35 4.1919080026583435 36 4.1638434261822832 37 4.1336267182738542
		 38 4.1013774525409072 39 4.0673553954360067 40 4.0318349934190145 41 3.9949621499519852
		 42 3.9570310052625715 43 3.917219154955887 44 3.8745565267803679 45 3.8315794800626977
		 46 3.7883837173341144 47 3.7452213757161648 48 3.7023287696113352 49 3.6598811984467599
		 50 3.6181683861925023 51 3.5772270198161693 52 3.5374834578823764 53 3.4989294082541735
		 54 3.4619161591419343 55 3.4265188061913849 56 3.3929490118159653 57 3.3613758747239095
		 58 3.3320199649614644 59 3.3049865810405681 60 3.2805149833676457 61 3.258689193296576
		 62 3.2397878405872604 63 3.2238357243558604 64 3.211191974017559 65 3.2018945305674031
		 66 3.1962829567966278 67 3.1943623271387342 68 3.1964995039240698 69 3.2028255526670275
		 70 3.2124991832576004 71 3.2248320390769249 72 3.2395605495847848 73 3.2568697754432172
		 74 3.2767543885631523 75 3.2991679033040469 76 3.3241611944326066 77 3.3517242813245751
		 78 3.3819451485851686 79 3.4147349028485197 80 3.4502778849200428;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "4B8A8E7D-4332-DC7E-83AA-B199408C6C11";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 41.98109203764043 1 41.919711179416019
		 2 41.856093366956813 3 41.790491942503117 4 41.723320834330991 5 41.654636188890208
		 6 41.585016920140511 7 41.514803841295453 8 41.444209478982202 9 41.373585148467988
		 10 41.306248849625078 11 41.244988349317424 12 41.18463976623157 13 41.125587992765382
		 14 41.068087782953953 15 41.012488973062965 16 40.959027736783902 17 40.908283850574499
		 18 40.860349149589524 19 40.815735824922605 20 40.774779270176531 21 40.737582606472685
		 22 40.70468846536653 23 40.676474223167062 24 40.653224926904805 25 40.635385757487114
		 26 40.623260152272557 27 40.617393629004518 28 40.617797430147391 29 40.624333671897752
		 30 40.636804131899659 31 40.654810343775786 32 40.677866137281939 33 40.705971403361978
		 34 40.738338045921765 35 40.775023611346349 36 40.81551374974859 37 40.859392344165023
		 38 40.906504636676594 39 40.956343723927226 40 41.008681037034421 41 41.063143257872241
		 42 41.119540613569967 43 41.180027206448912 44 41.247505550086736 45 41.315830699160507
		 46 41.384624199253295 47 41.453667270912611 48 41.522567884778638 49 41.590978495337225
		 50 41.658569930803971 51 41.725072162646022 52 41.789940346756339 53 41.853143192846801
		 54 41.914090737785919 55 41.972626041616856 56 42.028421234116863 57 42.081238314221693
		 58 42.130637768043137 59 42.176374763150186 60 42.218190156300103 61 42.255926772572558
		 62 42.289093537879445 63 42.317801846662206 64 42.341262413570753 65 42.359287641329026
		 66 42.371405395954554 67 42.377295424664666 68 42.37653419703669 69 42.368774496574986
		 70 42.35536294665858 71 42.337488762368402 72 42.315621402163856 73 42.289371015249621
		 74 42.25877017211355 75 42.223760291659147 76 42.184357390874872 77 42.140475416270739
		 78 42.091933232430016 79 42.038885152250323 80 41.98109203764043;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA";
	rename -uid "F898DDDB-4A9C-73B3-F372-F6B8A7B637F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 33.265228271484375 1 33.334140777587891
		 2 33.403053283691406 3 33.470745086669922 4 33.536163330078125 5 33.598178863525391
		 6 33.655731201171875 7 33.707740783691406 8 33.754196166992188 9 33.796463012695312
		 10 33.83538818359375 11 33.871788024902344 12 33.906852722167969 13 33.944355010986328
		 14 33.987045288085938 15 34.034355163574219 16 34.085617065429687 17 34.140182495117188
		 18 34.197257995605469 19 34.256175994873047 20 34.316032409667969 21 34.37591552734375
		 22 34.435188293457031 23 34.493167877197266 24 34.549217224121094 25 34.602638244628906
		 26 34.652778625488281 27 34.699020385742187 28 34.740875244140625 29 34.778053283691406
		 30 34.810443878173828 31 34.837852478027344 32 34.860359191894531 33 34.877796173095703
		 34 34.890281677246094 35 34.897834777832031 36 34.900615692138672 37 34.898796081542969
		 38 34.892547607421875 39 34.882156372070313 40 34.867820739746094 41 34.849929809570313
		 42 34.828208923339844 43 34.801918029785156 44 34.770408630371094 45 34.735198974609375
		 46 34.698089599609375 47 34.659393310546875 48 34.619461059570313 49 34.578636169433594
		 50 34.537178039550781 51 34.487693786621094 52 34.423728942871094 53 34.346939086914063
		 54 34.258796691894531 55 34.160572052001953 56 34.053604125976563 57 33.939163208007813
		 58 33.818592071533203 59 33.693389892578125 60 33.5653076171875 61 33.436470031738281
		 62 33.30914306640625 63 33.185897827148438 64 33.069530487060547 65 32.963088989257812
		 66 32.8697509765625 67 32.792854309082031 68 32.735824584960938 69 32.701904296875
		 70 32.693290710449219 71 32.70709228515625 72 32.737586975097656 73 32.782081604003906
		 74 32.837776184082031 75 32.902023315429687 76 32.972183227539063 77 33.045852661132813
		 78 33.120689392089844 79 33.194503784179687 80 33.265228271484375;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA";
	rename -uid "802E6CD6-41C2-A0CE-0B60-E49ED4364CCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 78.131423950195313 1 78.110908508300781
		 2 78.089088439941406 3 78.066215515136719 4 78.04248046875 5 78.018165588378906 6 77.993476867675781
		 7 77.968757629394531 8 77.944572448730469 9 77.921890258789063 10 77.900566101074219
		 11 77.880630493164063 12 77.864486694335937 13 77.855445861816406 14 77.85589599609375
		 15 77.86529541015625 16 77.883125305175781 17 77.908966064453125 18 77.942436218261719
		 19 77.983139038085938 20 78.030853271484375 21 78.085235595703125 22 78.145965576171875
		 23 78.21270751953125 24 78.285049438476562 25 78.3626708984375 26 78.445159912109375
		 27 78.532150268554688 28 78.623146057128906 29 78.7176513671875 30 78.815048217773438
		 31 78.914718627929688 32 79.0159912109375 33 79.118240356445313 34 79.220649719238281
		 35 79.322593688964844 36 79.423255920410156 37 79.52178955078125 38 79.61749267578125
		 39 79.709465026855469 40 79.796928405761719 41 79.87896728515625 42 79.954299926757813
		 43 80.020187377929688 44 80.074005126953125 45 80.118911743164063 46 80.157569885253906
		 47 80.189979553222656 48 80.216293334960938 49 80.236503601074219 50 80.250762939453125
		 51 80.250320434570313 52 80.227813720703125 53 80.185203552246094 54 80.124496459960937
		 55 80.04754638671875 56 79.956352233886719 57 79.852859497070313 58 79.739036560058594
		 59 79.617088317871094 60 79.489128112792969 61 79.357345581054687 62 79.223945617675781
		 63 79.091285705566406 64 78.961715698242188 65 78.837493896484375 66 78.720870971679688
		 67 78.614051818847656 68 78.519119262695313 69 78.438041687011719 70 78.373062133789063
		 71 78.322784423828125 72 78.282989501953125 73 78.251808166503906 74 78.227485656738281
		 75 78.208198547363281 76 78.1923828125 77 78.178321838378906 78 78.164497375488281
		 79 78.149345397949219 80 78.131423950195313;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "B7E63292-495A-8D4C-4057-AA9ADA255526";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -19.994743347167969 1 -19.911678314208984
		 2 -19.832546234130859 3 -19.760971069335937 4 -19.700565338134766 5 -19.655006408691406
		 6 -19.627948760986328 7 -19.623088836669922 8 -19.641471862792969 9 -19.680728912353516
		 10 -19.73992919921875 11 -19.817951202392578 12 -19.91270637512207 13 -20.022163391113281
		 14 -20.144521713256836 15 -20.278606414794922 16 -20.423088073730469 17 -20.576658248901367
		 18 -20.737995147705078 19 -20.905780792236328 20 -21.07861328125 21 -21.255199432373047
		 22 -21.434295654296875 23 -21.614658355712891 24 -21.795114517211914 25 -21.974494934082031
		 26 -22.151756286621094 27 -22.325893402099609 28 -22.495941162109375 29 -22.660955429077148
		 30 -22.819992065429688 31 -22.972194671630859 32 -23.116714477539063 33 -23.252735137939453
		 34 -23.379451751708984 35 -23.496026992797852 36 -23.601713180541992 37 -23.695724487304688
		 38 -23.777236938476563 39 -23.845438003540039 40 -23.899547576904297 41 -23.938610076904297
		 42 -23.963167190551758 43 -23.975269317626953 44 -23.976459503173828 45 -23.966045379638672
		 46 -23.943717956542969 47 -23.910041809082031 48 -23.865447998046875 49 -23.81043815612793
		 50 -23.745508193969727 51 -23.671346664428711 52 -23.588642120361328 53 -23.497817993164063
		 54 -23.399394989013672 55 -23.293766021728516 56 -23.181428909301758 57 -23.062864303588867
		 58 -22.938518524169922 59 -22.808864593505859 60 -22.674480438232422 61 -22.535717010498047
		 62 -22.393150329589844 63 -22.247478485107422 64 -22.099376678466797 65 -21.949613571166992
		 66 -21.798992156982422 67 -21.648262023925781 68 -21.498231887817383 69 -21.349639892578125
		 70 -21.203203201293945 71 -21.059677124023438 72 -20.919366836547852 73 -20.782920837402344
		 74 -20.65092658996582 75 -20.524024963378906 76 -20.402956008911133 77 -20.288545608520508
		 78 -20.181705474853516 79 -20.083423614501953 80 -19.994743347167969;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "75D9F70D-47E8-73C9-9267-D2A8986C35A3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -59.251408682579516 1 -59.157021826286886
		 2 -59.069065318953534 3 -58.988128696961354 4 -58.914611366258072 5 -58.84884651995354
		 6 -58.790925889210506 7 -58.740774163300777 8 -58.696311647361313 9 -58.653167916276985
		 10 -58.607768664843796 11 -58.556485225292853 12 -58.495957514464152 13 -58.414451742699377
		 14 -58.303326970677439 15 -58.163660247523232 16 -57.996564713276165 17 -57.803126633270331
		 18 -57.584109743479409 19 -57.340571580761029 20 -57.073592675547268 21 -56.784339896295236
		 22 -56.474078853037327 23 -56.144129449091992 24 -55.796102575886223 25 -55.431680159046948
		 26 -55.052807020504019 27 -54.661487744560972 28 -54.26024626644061 29 -53.851685984205162
		 30 -53.438884505299072 31 -53.024709311483193 32 -52.6124686320819 33 -52.205181435757282
		 34 -51.806190427810357 35 -51.418599149308278 36 -51.0455536592819 37 -50.690248029886256
		 38 -50.355616702852075 39 -50.044708433484161 40 -49.760284007218978 41 -49.505093556032826
		 42 -49.282266463596017 43 -49.095631746793948 44 -48.948713534357417 45 -48.836949399460934
		 46 -48.752755670127179 47 -48.695184339872718 48 -48.663118945138109 49 -48.655582632239316
		 50 -48.671643316803845 51 -48.76427100041878 52 -48.978835739588185 53 -49.3040134960995
		 54 -49.729136430628998 55 -50.243839100787071 56 -50.837969218757515 57 -51.500912368852532
		 58 -52.221830991609487 59 -52.988710820567164 60 -53.788768654498483 61 -54.608048589089726
		 62 -55.431555896498807 63 -56.243151350847612 64 -57.025939724048143 65 -57.762231603492616
		 66 -58.433943760799075 67 -59.022910096225921 68 -59.511501165368927 69 -59.882717715529729
		 70 -60.119866879062918 71 -60.23552786532251 72 -60.264341948511145 73 -60.22289480245508
		 74 -60.127470285683145 75 -59.994018886165257 76 -59.837438942813648 77 -59.671989393064862
		 78 -59.510905117469875 79 -59.366731358044809 80 -59.251408682579516;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "66C99BB3-4781-43BF-5E90-828C0D657FF6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 4.6018997964344059 1 4.3076854574237604
		 2 4.0172084916421706 3 3.7313354492287556 4 3.4510264916420361 5 3.1771745082407277
		 6 2.9108375693615196 7 2.6528337619478304 8 2.40606114388325 9 2.1757365343880224
		 10 1.9664252094286956 11 1.7828447533823066 12 1.6296385457127029 13 1.5298553057609563
		 14 1.5005118781404703 15 1.536628783810932 16 1.6332212983905814 17 1.7849641353824366
		 18 1.986609716573142 19 2.2327192350271989 20 2.5174844908951099 21 2.835242914106896
		 22 3.1809589867111874 23 3.549552912865698 24 3.9363159432764161 25 4.3364896580294783
		 26 4.7456066654513842 27 5.1592556679232571 28 5.5732353148529397 29 5.9839580418038514
		 30 6.3879722185446308 31 6.7819454335549976 32 7.1629216946817387 33 7.5279318766536667
		 34 7.8741807447237377 35 8.1991246135320388 36 8.5003100222740446 37 8.7753796625984108
		 38 9.0220295820839382 39 9.2379989302615897 40 9.4211790946158018 41 9.5693236271715403
		 42 9.6794000108133957 43 9.7474338472886988 44 9.7696154817626333 45 9.7534100856682588
		 46 9.7102978046899775 47 9.6421737024990541 48 9.5508111595652032 49 9.4380205210918806
		 50 9.3054124996326966 51 9.183464287957527 52 9.0980484002456183 53 9.0444292977441965
		 54 9.018135982574691 55 9.0147202788434484 56 9.0296885175621409 57 9.0583811267039582
		 58 9.0956974519659806 59 9.1364923662822868 60 9.1752798968694158 61 9.2069281802307383
		 62 9.2258947255415382 63 9.2264255052033768 64 9.2028416016641756 65 9.149396228196446
		 66 9.0609305507336 67 8.9323642977421223 68 8.7590520834877044 69 8.5367701589477516
		 70 8.2603637035725583 71 7.9367004876240062 72 7.5819543514226515 73 7.2044973602497588
		 74 6.8126611926138976 75 6.4145009364289116 76 6.0180498051241766 77 5.6309971118306938
		 78 5.2610399893330255 79 4.9155598547226163 80 4.6018997964344059;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "DB9FB1FD-4E3B-0E1D-4729-4285FDD47A23";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 96.957508482769384 1 97.10789533766301
		 2 97.257345803870933 3 97.403449278886043 4 97.543851588985603 5 97.676317389508071
		 6 97.798727980615809 7 97.90885127853268 8 98.00742441378739 9 98.098385539819347
		 10 98.184879538969255 11 98.269948177989249 12 98.356569514457746 13 98.457050307747252
		 14 98.580444519924455 15 98.724608513055614 16 98.887528379341461 17 99.06686463868985
		 18 99.260365373683697 19 99.465590801058141 20 99.67967803895003 21 99.899746279083459
		 22 100.12363923097782 23 100.3491081276899 24 100.57403902123173 25 100.79617335822361
		 26 101.01338191063483 27 101.22346073994103 28 101.42447185553607 29 101.61493321402251
		 30 101.79369037993411 31 101.95965839311603 32 102.11183520023792 33 102.24937215726791
		 34 102.3715155818745 35 102.47768289038387 36 102.56751848250795 37 102.6406889781462
		 38 102.69709492156447 39 102.73667137013983 40 102.75963333545673 41 102.76612641152602
		 42 102.75504828999829 43 102.72414224890625 44 102.67177941090915 45 102.60213682898694
		 46 102.52168188973124 47 102.43169158733399 48 102.33332732301531 49 102.22777255032391
		 50 102.11609138999403 51 101.97439931354462 52 101.78229748780747 53 101.54501828684739
		 54 101.26718555628338 55 100.95311825381685 56 100.6070439538245 57 100.23293563869626
		 58 99.834987650150453 59 99.41813025016171 60 98.987852600460897 61 98.550944217251129
		 62 98.114890202929843 63 97.687788233379223 64 97.278647592038425 65 96.897197809485306
		 66 96.553955884764648 67 96.259589987155621 68 96.024987021011526 69 95.860766384670129
		 70 95.775052698735706 71 95.759702078689884 72 95.796502449539204 73 95.876701702792914
		 74 95.991494530789907 75 96.132406013691707 76 96.291246593138723 77 96.460299713658557
		 78 96.632227363927299 79 96.800143224033732 80 96.957508482769384;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA";
	rename -uid "77CC4FDE-45F5-D856-2C39-F4A4A8AB14A7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.12042236328125 1 -29.051950454711914
		 2 -28.987846374511719 3 -28.927494049072266 4 -28.870391845703125 5 -28.81597900390625
		 6 -28.763811111450195 7 -28.713399887084961 8 -28.66490364074707 9 -28.618984222412109
		 10 -28.576229095458984 11 -28.537332534790039 12 -28.502483367919922 13 -28.473806381225586
		 14 -28.452720642089844 15 -28.438848495483398 16 -28.432241439819336 17 -28.432701110839844
		 18 -28.440090179443359 19 -28.454118728637695 20 -28.474554061889648 21 -28.501100540161133
		 22 -28.533468246459961 23 -28.571493148803711 24 -28.614780426025391 25 -28.66307258605957
		 26 -28.714385986328125 27 -28.766790390014648 28 -28.819950103759766 29 -28.87346076965332
		 30 -28.926742553710938 31 -28.979413986206055 32 -29.032930374145508 33 -29.088829040527344
		 34 -29.146110534667969 35 -29.204048156738281 36 -29.261850357055664 37 -29.318746566772461
		 38 -29.374032974243164 39 -29.426935195922852 40 -29.476690292358398 41 -29.520120620727539
		 42 -29.554777145385742 43 -29.581308364868164 44 -29.600521087646484 45 -29.613044738769531
		 46 -29.619806289672852 47 -29.62188720703125 48 -29.620342254638672 49 -29.616144180297852
		 50 -29.610208511352539 51 -29.603395462036133 52 -29.5965576171875 53 -29.590431213378906
		 54 -29.585720062255859 55 -29.583154678344727 56 -29.583250045776367 57 -29.586601257324219
		 58 -29.592342376708984 59 -29.599296569824219 60 -29.607114791870117 61 -29.615535736083984
		 62 -29.623397827148438 63 -29.629241943359375 64 -29.632505416870117 65 -29.633125305175781
		 66 -29.630958557128906 67 -29.625148773193359 68 -29.613563537597656 69 -29.594846725463867
		 70 -29.570003509521484 71 -29.540060043334961 72 -29.505552291870117 73 -29.466852188110352
		 74 -29.424535751342773 75 -29.378986358642578 76 -29.330743789672852 77 -29.280271530151367
		 78 -29.228063583374023 79 -29.174596786499023 80 -29.12042236328125;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA";
	rename -uid "6FC73CBE-4E42-05B8-E3D1-8CB38F7A3340";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 75.048683166503906 1 75.103103637695312
		 2 75.150047302246094 3 75.187332153320312 4 75.212913513183594 5 75.224739074707031
		 6 75.220893859863281 7 75.199470520019531 8 75.160064697265625 9 75.104377746582031
		 10 75.03253173828125 11 74.944610595703125 12 74.843429565429687 13 74.730682373046875
		 14 74.60772705078125 15 74.475143432617188 16 74.333648681640625 17 74.184005737304688
		 18 74.026786804199219 19 73.862640380859375 20 73.692192077636719 21 73.515960693359375
		 22 73.334930419921875 23 73.149871826171875 24 72.961761474609375 25 72.771530151367188
		 26 72.581993103027344 27 72.395698547363281 28 72.21331787109375 29 72.03533935546875
		 30 71.862503051757813 31 71.695343017578125 32 71.534683227539063 33 71.381057739257813
		 34 71.235458374023438 35 71.098648071289063 36 70.971481323242188 37 70.854843139648438
		 38 70.749610900878906 39 70.656776428222656 40 70.577194213867188 41 70.5155029296875
		 42 70.475151062011719 43 70.453483581542969 44 70.448318481445312 45 70.461013793945313
		 46 70.491104125976563 47 70.537567138671875 48 70.599365234375 49 70.675529479980469
		 50 70.764984130859375 51 70.866676330566406 52 70.979415893554687 53 71.102096557617188
		 54 71.233444213867188 55 71.372077941894531 56 71.516838073730469 57 71.666069030761719
		 58 71.819786071777344 59 71.978538513183594 60 72.141632080078125 61 72.308563232421875
		 62 72.478187561035156 63 72.649154663085938 64 72.820663452148438 65 72.992385864257813
		 66 73.163925170898437 67 73.334281921386719 68 73.502578735351563 69 73.667900085449219
		 70 73.829322814941406 71 73.985931396484375 72 74.136917114257813 73 74.281410217285156
		 74 74.418624877929688 75 74.547836303710938 76 74.668304443359375 77 74.779296875
		 78 74.880111694335938 79 74.970123291015625 80 75.048683166503906;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "E9177BFE-42E9-16FA-2A12-4B85DDA990B1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.695053100585937 1 -48.581474304199219
		 2 -48.459613800048828 3 -48.334339141845703 4 -48.210487365722656 5 -48.092842102050781
		 6 -47.98614501953125 7 -47.895027160644531 8 -47.8211669921875 9 -47.762371063232422
		 10 -47.717948913574219 11 -47.687076568603516 12 -47.667892456054687 13 -47.658416748046875
		 14 -47.657054901123047 15 -47.663078308105469 16 -47.675514221191406 17 -47.693546295166016
		 18 -47.716423034667969 19 -47.743457794189453 20 -47.774074554443359 21 -47.807853698730469
		 22 -47.84405517578125 23 -47.8819580078125 24 -47.920967102050781 25 -47.960453033447266
		 26 -48.004898071289063 27 -48.058731079101563 28 -48.121383666992188 29 -48.192096710205078
		 30 -48.270030975341797 31 -48.354274749755859 32 -48.442508697509766 33 -48.531967163085937
		 34 -48.622257232666016 35 -48.712333679199219 36 -48.801261901855469 37 -48.888107299804688
		 38 -48.971775054931641 39 -49.051162719726563 40 -49.125339508056641 41 -49.203800201416016
		 42 -49.296253204345703 43 -49.401138305664063 44 -49.516063690185547 45 -49.638454437255859
		 46 -49.766151428222656 47 -49.895721435546875 48 -50.023929595947266 49 -50.147830963134766
		 50 -50.264724731445313 51 -50.37225341796875 52 -50.46826171875 53 -50.550750732421875
		 54 -50.618003845214844 55 -50.668365478515625 56 -50.700366973876953 57 -50.712638854980469
		 58 -50.707736968994141 59 -50.689476013183594 60 -50.658660888671875 61 -50.615715026855469
		 62 -50.561489105224609 63 -50.49700927734375 64 -50.423107147216797 65 -50.340324401855469
		 66 -50.249252319335938 67 -50.150894165039062 68 -50.047065734863281 69 -49.939128875732422
		 70 -49.827949523925781 71 -49.714645385742188 72 -49.599658966064453 73 -49.483638763427734
		 74 -49.367225646972656 75 -49.251022338867188 76 -49.135639190673828 77 -49.021751403808594
		 78 -48.909942626953125 79 -48.800857543945313 80 -48.695053100585937;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "F54DC42E-4627-56E8-640C-B680970356E8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -47.787920050703022 1 -47.625041024071663
		 2 -47.455028077985354 3 -47.285205815212571 4 -47.122507934761359 5 -46.974089225621434
		 6 -46.847138737452497 7 -46.748972523300374 8 -46.682702737886075 9 -46.646305815983062
		 10 -46.639317537540109 11 -46.66142882973277 12 -46.712398883561356 13 -46.785272436297596
		 14 -46.876090337680331 15 -46.985564541457997 16 -47.111469142932904 17 -47.253315674178296
		 18 -47.410830782066242 19 -47.583751075892671 20 -47.772821385553193 21 -47.978801439728734
		 22 -48.200785104733988 23 -48.437747125591123 24 -48.688981902875746 25 -48.953613398815627
		 26 -49.245957138119472 27 -49.580131379672693 28 -49.954062087652012 29 -50.364949687898523
		 30 -50.8087634905174 31 -51.281379165477446 32 -51.771092833079038 33 -52.264877498448151
		 34 -52.759961333352571 35 -53.251778524419066 36 -53.735704845071865 37 -54.207434664862191
		 38 -54.662631648304249 39 -55.096855504650662 40 -55.506539098118935 41 -55.909255431763178
		 42 -56.319241386033013 43 -56.727253856713816 44 -57.12332988847615 45 -57.489145567855573
		 46 -57.810553972570382 47 -58.082143359778122 48 -58.300185032429795 49 -58.462037953887616
		 50 -58.566575752989174 51 -58.613453031672456 52 -58.603005158691182 53 -58.535887987374508
		 54 -58.413372956853152 55 -58.236451524564103 56 -58.006103980300033 57 -57.723576184627206
		 58 -57.395547488337805 59 -57.030244916724399 60 -56.630991805813203 61 -56.20041319692649
		 62 -55.743544242713803 63 -55.266540897345294 64 -54.773226498558856 65 -54.262031224579452
		 66 -53.732628290998186 67 -53.190650801599226 68 -52.645016442216857 69 -52.103080311632013
		 70 -51.569976367412806 71 -51.051797519604065 72 -50.552533296456907 73 -50.076516973755126
		 74 -49.628258660647866 75 -49.212284346208733 76 -48.833575682756162 77 -48.496803972013922
		 78 -48.207061817466951 79 -47.96915238770454 80 -47.787920050703022;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "9BC8F1E0-40DD-06DF-738F-3F9F4D52E5A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.830938122333585 1 -48.941146716198709
		 2 -49.067122071481414 3 -49.203980743871107 4 -49.34720855502286 5 -49.492496753100021
		 6 -49.635843936181558 7 -49.773337704141106 8 -49.904627030975028 9 -50.033499185757606
		 10 -50.162556463744053 11 -50.294394053330251 12 -50.43129217037481 13 -50.583990099006066
		 14 -50.759168422131772 15 -50.954549448348388 16 -51.168940607059767 17 -51.400418229630525
		 18 -51.646952756696777 19 -51.906553276703129 20 -52.176459507661953 21 -52.454127711413655
		 22 -52.737607482175605 23 -53.024953091934663 24 -53.3141422643072 25 -53.603195552613613
		 26 -53.874953194938833 27 -54.113012674625288 28 -54.316421200044829 29 -54.484460689121519
		 30 -54.616311287147667 31 -54.71172005963961 32 -54.769816379816049 33 -54.791937907162151
		 34 -54.777516269236202 35 -54.727916802694935 36 -54.644108870032589 37 -54.527458944307881
		 38 -54.379430198837305 39 -54.201631309485023 40 -53.99532464741484 41 -53.732508479839062
		 42 -53.389112288166608 43 -52.974586781782399 44 -52.499617319084194 45 -51.979750963078651
		 46 -51.429231312565925 47 -50.859184266914667 48 -50.280377546553318 49 -49.702767753259756
		 50 -49.136026495494647 51 -48.589179198049472 52 -48.070950078225579 53 -47.58950488760734
		 54 -47.152838639453329 55 -46.768699094104036 56 -46.444664461613591 57 -46.187833543757925
		 58 -45.991060455512603 59 -45.842248530668392 60 -45.740248962065444 61 -45.684173457838376
		 62 -45.669055811984123 63 -45.688519266988528 64 -45.739627689424132 65 -45.822938801420662
		 66 -45.937969713387247 67 -46.080702129514158 68 -46.247592385413384 69 -46.4350221303879
		 70 -46.639452521526785 71 -46.857194687235356 72 -47.084674514135713 73 -47.318275830035773
		 74 -47.554423893965286 75 -47.789618275371971 76 -48.020388991741392 77 -48.243328698706556
		 78 -48.455001063792238 79 -48.652000358567442 80 -48.830938122333585;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "9C3343BE-467D-8881-B9F3-E1A0D6D41599";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 23.32502166384155 1 23.267190485470103
		 2 23.198404734415551 3 23.119596569969008 4 23.031494928383953 5 22.93508736376678
		 6 22.83144942027004 7 22.721794354054147 8 22.608122928968804 9 22.493842127593567
		 10 22.382020010436502 11 22.275807151163516 12 22.178630367365553 13 22.093424661347672
		 14 22.023551650995852 15 21.97061378323999 16 21.933718151893114 17 21.913594611168214
		 18 21.911123523198313 19 21.927053259405291 20 21.963060942020672 21 22.0206471558331
		 22 22.099914012996241 23 22.200657272800083 24 22.322731944408243 25 22.465727123088119
		 26 22.647221177575375 27 22.883917251152045 28 23.172786002377343 29 23.509575381734074
		 30 23.888621204768935 31 24.30405468780874 32 24.740290712707054 33 25.180066881779457
		 34 25.619165349443474 35 26.050903912589696 36 26.46893768355546 37 26.86714388228339
		 38 27.239568389240713 39 27.580356961833424 40 27.884850271271265 41 28.178825256854815
		 42 28.486578239648615 43 28.796439584700348 44 29.097695638907112 45 29.371041241031289
		 46 29.602155618787332 47 29.787633514095706 48 29.925659282467588 49 30.015672469551117
		 50 30.058347978925042 51 30.055120105954249 52 30.007809038715109 53 29.918376846815679
		 54 29.788860673344722 55 29.620911468145199 56 29.415566507987094 57 29.17372459853291
		 58 28.903420866069709 59 28.615301660868635 60 28.313050369639921 61 27.999443796840616
		 62 27.675745286419939 63 27.343597225113953 64 27.005648300897864 65 26.660443169862621
		 66 26.307458700691186 67 25.950926150666628 68 25.599305462162462 69 25.259059823360641
		 70 24.934128245094168 71 24.629472814290345 72 24.34767463936025 73 24.091723997757175
		 74 23.86494101549053 75 23.670731391701956 76 23.513015782025541 77 23.395540961692227
		 78 23.322415873126847 79 23.297570269134113 80 23.32502166384155;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA";
	rename -uid "74A0A801-4F12-3E7F-B0FE-D19015303EB3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.4979124069213867 1 2.5526885986328125
		 2 2.6092338562011719 3 2.6672468185424805 4 2.7264242172241211 5 2.786470890045166
		 6 2.8470830917358398 7 2.9079656600952148 8 2.9688146114349365 9 3.0293323993682861
		 10 3.0890839099884033 11 3.1476740837097168 12 3.2050223350524902 13 3.2608401775360107
		 14 3.3148226737976074 15 3.3666756153106689 16 3.4160993099212646 17 3.4627909660339355
		 18 3.5064558982849121 19 3.546799898147583 20 3.5835130214691162 21 3.6163012981414795
		 22 3.6448729038238525 23 3.6689200401306152 24 3.6881523132324219 25 3.7022616863250732
		 26 3.7109577655792236 27 3.7139296531677246 28 3.7109930515289307 29 3.7023484706878662
		 30 3.6882951259613037 31 3.6691269874572754 32 3.6451621055603027 33 3.6166937351226807
		 34 3.5840144157409668 35 3.547440767288208 36 3.5072588920593262 37 3.4637792110443115
		 38 3.4172985553741455 39 3.3681180477142334 40 3.316544771194458 41 3.2628705501556396
		 42 3.2074007987976074 43 3.1503193378448486 44 3.0917947292327881 45 3.0323855876922607
		 46 2.9723963737487793 47 2.9121246337890625 48 2.8518772125244141 49 2.7919540405273437
		 50 2.7326593399047852 51 2.6742959022521973 52 2.6171655654907227 53 2.5615682601928711
		 54 2.507807731628418 55 2.4561834335327148 56 2.4070014953613281 57 2.3605608940124512
		 58 2.3171634674072266 59 2.2771081924438477 60 2.2406978607177734 61 2.2082338333129883
		 62 2.180023193359375 63 2.1563582420349121 64 2.1375455856323242 65 2.1238861083984375
		 66 2.1156811714172363 67 2.1132307052612305 68 2.1168432235717773 69 2.1268148422241211
		 70 2.1419591903686523 71 2.1608781814575195 72 2.1835508346557617 73 2.2099609375
		 74 2.2400894165039062 75 2.2739124298095703 76 2.3114213943481445 77 2.3525924682617187
		 78 2.3974123001098633 79 2.4458560943603516 80 2.4979124069213867;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA";
	rename -uid "6CF0158E-48D1-2924-895F-AB9EF3AA3591";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 54.945686340332031 1 54.94769287109375
		 2 54.949775695800781 3 54.951911926269531 4 54.954093933105469 5 54.956314086914063
		 6 54.95855712890625 7 54.9608154296875 8 54.963081359863281 9 54.96533203125 10 54.966651916503906
		 11 54.966232299804688 12 54.965827941894531 13 54.965431213378906 14 54.965038299560547
		 15 54.964668273925781 16 54.964302062988281 17 54.963954925537109 18 54.963630676269531
		 19 54.96331787109375 20 54.963027954101562 21 54.962753295898437 22 54.962501525878906
		 23 54.962272644042969 24 54.962066650390625 25 54.961906433105469 26 54.961761474609375
		 27 54.961650848388672 28 54.961585998535156 29 54.961555480957031 30 54.961563110351563
		 31 54.961589813232422 32 54.961669921875 33 54.961769104003906 34 54.961894989013672
		 35 54.962059020996094 36 54.962242126464844 37 54.96246337890625 38 54.962699890136719
		 39 54.962959289550781 40 54.963241577148438 41 54.963546752929688 42 54.963863372802734
		 43 54.963294982910156 44 54.960929870605469 45 54.95855712890625 46 54.956192016601563
		 47 54.953849792480469 48 54.951545715332031 49 54.94927978515625 50 54.947063446044922
		 51 54.944931030273438 52 54.94287109375 53 54.940902709960937 54 54.93902587890625
		 55 54.937259674072266 56 54.935619354248047 57 54.934112548828125 58 54.9327392578125
		 59 54.931510925292969 60 54.930442810058594 61 54.929550170898437 62 54.928863525390625
		 63 54.928367614746094 64 54.928077697753906 65 54.927986145019531 66 54.928092956542969
		 67 54.92840576171875 68 54.928932189941406 69 54.929664611816406 70 54.930564880371094
		 71 54.931594848632813 72 54.932746887207031 73 54.934013366699219 74 54.935386657714844
		 75 54.936862945556641 76 54.938446044921875 77 54.940120697021484 78 54.94189453125
		 79 54.943744659423828 80 54.945686340332031;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA";
	rename -uid "FE8367F9-4907-E7C6-A22F-B7AC495A6B6B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -24.125894546508789 1 -24.118751525878906
		 2 -24.111568450927734 3 -24.10438346862793 4 -24.097240447998047 5 -24.090177536010742
		 6 -24.083240509033203 7 -24.076465606689453 8 -24.069900512695313 9 -24.063583374023438
		 10 -24.057949066162109 11 -24.053382873535156 12 -24.049167633056641 13 -24.045339584350586
		 14 -24.041942596435547 15 -24.038997650146484 16 -24.036556243896484 17 -24.034652709960937
		 18 -24.033313751220703 19 -24.03257942199707 20 -24.032487869262695 21 -24.033138275146484
		 22 -24.034564971923828 23 -24.036720275878906 24 -24.039562225341797 25 -24.043041229248047
		 26 -24.047121047973633 27 -24.051761627197266 28 -24.056901931762695 29 -24.062511444091797
		 30 -24.068553924560547 31 -24.074989318847656 32 -24.081764221191406 33 -24.088840484619141
		 34 -24.096199035644531 35 -24.103767395019531 36 -24.111534118652344 37 -24.11943244934082
		 38 -24.127439498901367 39 -24.135513305664063 40 -24.143610000610352 41 -24.151689529418945
		 42 -24.159713745117188 43 -24.168022155761719 44 -24.176971435546875 45 -24.185747146606445
		 46 -24.194309234619141 47 -24.202602386474609 48 -24.210586547851563 49 -24.218215942382813
		 50 -24.225448608398438 51 -24.232223510742187 52 -24.238510131835938 53 -24.244260787963867
		 54 -24.249427795410156 55 -24.253971099853516 56 -24.257839202880859 57 -24.260980606079102
		 58 -24.26336669921875 59 -24.264944076538086 60 -24.26567268371582 61 -24.2652587890625
		 62 -24.263517379760742 63 -24.260553359985352 64 -24.256467819213867 65 -24.251369476318359
		 66 -24.245361328125 67 -24.238548278808594 68 -24.231033325195313 69 -24.222923278808594
		 70 -24.214330673217773 71 -24.205373764038086 72 -24.196157455444336 73 -24.186792373657227
		 74 -24.17738151550293 75 -24.168037414550781 76 -24.158847808837891 77 -24.149940490722656
		 78 -24.141401290893555 79 -24.133358001708984 80 -24.125894546508789;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX";
	rename -uid "481BFB62-4FF4-74B0-D196-4D93912052F4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 2.386871940428331 1 2.3927732732249036
		 2 2.3985014472981834 3 2.4038153897139933 4 2.4085364093719162 5 2.412459002118708
		 6 2.4153877962323262 7 2.4171029905262018 8 2.4175518884686187 9 2.4168482889604803
		 10 2.415031593457301 11 2.4121715818866942 12 2.4083056083456333 13 2.4035175856704152
		 14 2.397852018554461 15 2.3913718846807974 16 2.384127495692284 17 2.3761756735663666
		 18 2.3675638850183396 19 2.3583817534420066 20 2.3486420344956995 21 2.3384047747336991
		 22 2.3277187221249549 23 2.316677121738445 24 2.3053448368920595 25 2.2938328034118878
		 26 2.2821740717318244 27 2.2704627257236418 28 2.2587673878078869 29 2.2471706516140566
		 30 2.2357356005547158 31 2.2245710561189149 32 2.2137092896117734 33 2.2032514226028526
		 34 2.1932765609482643 35 2.1838409597293973 36 2.1750565953887859 37 2.1669553898777378
		 38 2.1596446883837666 39 2.1531961263567978 40 2.147674373178821 41 2.1431721665336716
		 42 2.1396663068771611 43 2.1371057509463789 44 2.1354700258412636 45 2.1346929274396875
		 46 2.1347757939252632 47 2.1356775587044461 48 2.1373775592168869 49 2.1398285748198842
		 50 2.1430257504679817 51 2.1469079364117643 52 2.1514705707884398 53 2.1566656750910189
		 54 2.1624706177312478 55 2.1688653333851602 56 2.1758002136677148 57 2.1832630219350655
		 58 2.1911721755108409 59 2.1994995841976559 60 2.2081726713441117 61 2.2171821419043387
		 62 2.2264690022230771 63 2.235972141553435 64 2.2456498724801768 65 2.2554663522717857
		 66 2.2653634758944374 67 2.275301815331872 68 2.2852356913256036 69 2.2951008064079632
		 70 2.3048791337058652 71 2.3145044926729503 72 2.323933023215389 73 2.3331275815031995
		 74 2.3420494713754039 75 2.350617933424425 76 2.3588162933876626 77 2.3665791770436115
		 78 2.3738817870203817 79 2.3806663515050861 80 2.386871940428331;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY";
	rename -uid "A880485C-4BC5-9827-8736-B89CDE3259CC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 15.334574372843704 1 15.329120604935541
		 2 15.323907792225048 3 15.319103515077805 4 15.314978355623236 5 15.311691692049974
		 6 15.30951483847835 7 15.308618961756819 8 15.309139245995352 9 15.310898697464316
		 10 15.313780733402936 11 15.317824953520084 12 15.322873755530273 13 15.328921739549447
		 14 15.335892945079458 15 15.343710457712881 16 15.352328815298788 17 15.361623756542309
		 18 15.371616630171598 19 15.382183096430252 20 15.393286114762549 21 15.404864446732182
		 22 15.416785689651817 23 15.429068239773803 24 15.441554720771091 25 15.454234620171416
		 26 15.466963617406549 27 15.479753339875696 28 15.492417561676119 29 15.504990596312119
		 30 15.51724749228007 31 15.529266409604118 32 15.540794750116085 33 15.551914086305837
		 34 15.56235307244169 35 15.572212183220593 36 15.581242633465719 37 15.589404002610435
		 38 15.596668042164207 39 15.602872857045876 40 15.608001446146277 41 15.611892502412497
		 42 15.614592993953876 43 15.616123696309536 44 15.616619055991968 45 15.616087316101424
		 46 15.61457578600214 47 15.612105836614189 48 15.608816961723905 49 15.604679197944876
		 50 15.599742030650647 51 15.594088840620909 52 15.587761906848852 53 15.580801181413454
		 54 15.573220415574957 55 15.56516479556638 56 15.556604818925145 57 15.547649465382184
		 58 15.538257981060941 59 15.528585759292834 60 15.518638309348885 61 15.508479412161856
		 62 15.498129582619512 63 15.487669824951928 64 15.477120894180507 65 15.466544572474264
		 66 15.455986808568399 67 15.445514353237288 68 15.435114451697201 69 15.42488389411244
		 70 15.414860977341549 71 15.405072810889274 72 15.395568053114296 73 15.386357061448727
		 74 15.377577875353026 75 15.369133911590557 76 15.36118311387925 77 15.353699744985496
		 78 15.346737916571906 79 15.340353303192014 80 15.334574372843704;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ";
	rename -uid "D76A6D20-40AF-776D-1E16-578CEC2A543D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.1708668588936879 1 -4.1225292963404332
		 2 -4.0758404948174398 3 -4.0327671150722271 4 -3.9950658411580768 5 -3.9645669055077803
		 6 -3.9431265049786273 7 -3.9325188908435549 8 -3.9333781337239291 9 -3.9446605914480144
		 10 -3.9657863574490131 11 -3.9962082377352703 12 -4.035367819942504 13 -4.0826607006030082
		 14 -4.1375639039015706 15 -4.1994903839035738 16 -4.2678582071216207 17 -4.3420759139927121
		 18 -4.4216276808835238 19 -4.5059413052219632 20 -4.5945129108382945 21 -4.6868542999374645
		 22 -4.7823316057924954 23 -4.8802777582717791 24 -4.9801039023536671 25 -5.0811106695056774
		 26 -5.1827075631644073 27 -5.2842484208119922 28 -5.3850542462570159 29 -5.4845627882353618
		 30 -5.5821018766768011 31 -5.6770011814680599 32 -5.7686867366214498 33 -5.8564765758227537
		 34 -5.9397262251916336 35 -6.0178458249278171 36 -6.0901322573462542 37 -6.1560135948263977
		 38 -6.2148367760583083 39 -6.2659228670867302 40 -6.3086900510664989 41 -6.3424556104345626
		 42 -6.3672993723542648 43 -6.3838575750951536 44 -6.3924120718303401 45 -6.3932738416926789
		 46 -6.386801504772019 47 -6.3732514147439074 48 -6.3529547804317303 49 -6.3261837194341561
		 50 -6.2932409628822361 51 -6.2544845270121057 52 -6.2101730690073982 53 -6.1606321116442047
		 54 -6.1061725005477685 55 -6.0470973950556699 56 -5.983667103668167 57 -5.9163189308744695
		 58 -5.8454136744464433 59 -5.7713439485952804 60 -5.6945063004571459 61 -5.6152742918523586
		 62 -5.5340353704686596 63 -5.4511819663380061 64 -5.3671335134444105 65 -5.2822052592596185
		 66 -5.1968402295456828 67 -5.1114184393714917 68 -5.0263022562025741 69 -4.9419146695339995
		 70 -4.8585811964402899 71 -4.7767866443831526 72 -4.6968323060669626 73 -4.6191287945034141
		 74 -4.5440662461463681 75 -4.4720311633460739 76 -4.4034272511363257 77 -4.3386084852770583
		 78 -4.2779968677389144 79 -4.2219651065913029 80 -4.1708668588936879;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA";
	rename -uid "0895602A-401F-E4A1-CFBD-13953EEF5C99";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.5506343841552734 1 -1.4853935241699219
		 2 -1.4188013076782227 3 -1.3516321182250977 4 -1.2846393585205078 5 -1.2185487747192383
		 6 -1.1540966033935547 7 -1.092015266418457 8 -1.0327835083007812 9 -0.97641754150390625
		 10 -0.92316246032714844 11 -0.87338829040527344 12 -0.82692146301269531 13 -0.78398895263671875
		 14 -0.74476051330566406 15 -0.70936107635498047 16 -0.67800140380859375 17 -0.65079498291015625
		 18 -0.62794876098632813 19 -0.60958480834960938 20 -0.59587764739990234 21 -0.58696937561035156
		 22 -0.58295917510986328 23 -0.58406257629394531 24 -0.59036445617675781 25 -0.60207748413085938
		 26 -0.61928176879882813 27 -0.64217472076416016 28 -0.67069149017333984 29 -0.70456409454345703
		 30 -0.74321174621582031 31 -0.78630256652832031 32 -0.83320522308349609 33 -0.88357162475585938
		 34 -0.93682956695556641 35 -0.99257469177246094 36 -1.050288200378418 37 -1.1094751358032227
		 38 -1.1697320938110352 39 -1.2305011749267578 40 -1.2913923263549805 41 -1.3518705368041992
		 42 -1.4116849899291992 43 -1.4708032608032227 44 -1.5292243957519531 45 -1.5864553451538086
		 46 -1.6423149108886719 47 -1.6965904235839844 48 -1.7491388320922852 49 -1.7997303009033203
		 50 -1.8481731414794922 51 -1.894261360168457 52 -1.9378395080566406 53 -1.9786758422851563
		 54 -2.0165777206420898 55 -2.0514044761657715 56 -2.0829057693481445 57 -2.1109423637390137
		 58 -2.1352071762084961 59 -2.1555910110473633 60 -2.1718645095825195 61 -2.1838064193725586
		 62 -2.19122314453125 63 -2.1938977241516113 64 -2.1916160583496094 65 -2.184173583984375
		 66 -2.1713457107543945 67 -2.1529583930969238 68 -2.1287555694580078 69 -2.0985221862792969
		 70 -2.0635709762573242 71 -2.025324821472168 72 -1.983942985534668 73 -1.9394712448120117
		 74 -1.8920803070068359 75 -1.841771125793457 76 -1.7887210845947266 77 -1.7329788208007813
		 78 -1.6746711730957031 79 -1.6138591766357422 80 -1.5506343841552734;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA";
	rename -uid "62370203-4BE8-D36E-9CB7-A89D95BB3C11";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 98.593429565429687 1 98.62017822265625
		 2 98.645492553710938 3 98.668548583984375 4 98.688583374023438 5 98.704933166503906
		 6 98.716911315917969 7 98.723884582519531 8 98.72564697265625 9 98.72265625 10 98.714141845703125
		 11 98.699386596679688 12 98.680206298828125 13 98.656547546386719 14 98.628402709960938
		 15 98.595718383789063 16 98.558425903320313 17 98.516510009765625 18 98.469924926757813
		 19 98.41864013671875 20 98.362678527832031 21 98.302001953125 22 98.23681640625 23 98.16729736328125
		 24 98.093734741210937 25 98.016502380371094 26 97.93597412109375 27 97.852645874023438
		 28 97.767105102539063 29 97.679946899414063 30 97.591903686523438 31 97.503692626953125
		 32 97.416213989257813 33 97.330284118652344 34 97.246856689453125 35 97.16693115234375
		 36 97.091506958007812 37 97.021583557128906 38 96.958236694335938 39 96.902542114257813
		 40 96.855461120605469 41 96.818084716796875 42 96.790557861328125 43 96.771438598632812
		 44 96.75958251953125 45 96.756454467773438 46 96.761756896972656 47 96.77508544921875
		 48 96.796051025390625 49 96.824172973632812 50 96.859001159667969 51 96.900054931640625
		 52 96.94677734375 53 96.998687744140625 54 97.055221557617188 55 97.115837097167969
		 56 97.180068969726563 57 97.247268676757813 58 97.316825866699219 59 97.388198852539062
		 60 97.460784912109375 61 97.53411865234375 62 97.607681274414063 63 97.681015014648438
		 64 97.753677368164063 65 97.825233459472656 66 97.89532470703125 67 97.963638305664063
		 68 98.029861450195313 69 98.093719482421875 70 98.15496826171875 71 98.213363647460938
		 72 98.268753051757813 73 98.320999145507813 74 98.3699951171875 75 98.415679931640625
		 76 98.4580078125 77 98.4969482421875 78 98.532485961914063 79 98.564651489257813
		 80 98.593429565429687;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA";
	rename -uid "E71CC802-41C7-CA4F-8AB7-5DA73C7AE92E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -32.560287475585938 1 -32.401039123535156
		 2 -32.247154235839844 3 -32.104457855224609 4 -31.978731155395508 5 -31.875783920288086
		 6 -31.801458358764648 7 -31.76152229309082 8 -31.757892608642578 9 -31.787359237670898
		 10 -31.848596572875977 11 -31.940147399902344 12 -32.059524536132813 13 -32.204925537109375
		 14 -32.374568939208984 15 -32.566696166992187 16 -32.77947998046875 17 -33.0111083984375
		 18 -33.259811401367188 19 -33.5238037109375 20 -33.801544189453125 21 -34.091499328613281
		 22 -34.391647338867187 23 -34.699859619140625 24 -35.014106750488281 25 -35.332229614257813
		 26 -35.652206420898438 27 -35.971992492675781 28 -36.289501190185547 29 -36.602752685546875
		 30 -36.909713745117188 31 -37.208377838134766 32 -37.496837615966797 33 -37.773075103759766
		 34 -38.035186767578125 35 -38.281234741210938 36 -38.509326934814453 37 -38.717609405517578
		 38 -38.904167175292969 39 -39.067100524902344 40 -39.204586029052734 41 -39.314682006835938
		 42 -39.397586822509766 43 -39.455677032470703 44 -39.490234375 45 -39.50140380859375
		 46 -39.490077972412109 47 -39.4571533203125 48 -39.403434753417969 49 -39.329788208007813
		 50 -39.237014770507813 51 -39.126007080078125 52 -38.997581481933594 53 -38.8525390625
		 54 -38.691761016845703 55 -38.516017913818359 56 -38.326141357421875 57 -38.123176574707031
		 58 -37.908256530761719 59 -37.682479858398438 60 -37.446987152099609 61 -37.202590942382813
		 62 -36.950294494628906 63 -36.69140625 64 -36.427200317382813 65 -36.158966064453125
		 66 -35.888046264648438 67 -35.615730285644531 68 -35.343345642089844 69 -35.072250366210937
		 70 -34.803726196289062 71 -34.539268493652344 72 -34.280059814453125 73 -34.02752685546875
		 74 -33.783042907714844 75 -33.547916412353516 76 -33.323520660400391 77 -33.111213684082031
		 78 -32.912330627441406 79 -32.728248596191406 80 -32.560287475585938;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX";
	rename -uid "F55775F4-4D63-40EC-B4A3-9CA20C397D03";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.47961850936799472 1 0.46707499530426982
		 2 0.4549793400712927 3 0.44396591055375106 4 0.43465919244028528 5 0.42776112819533352
		 6 0.42392499430755082 7 0.42380097804911243 8 0.42759194907580084 9 0.43489178036599657
		 10 0.44547286089729032 11 0.45903430555548619 12 0.47529590200739325 13 0.49396752902636715
		 14 0.51473640194452619 15 0.5373077410456919 16 0.5613688954780327 17 0.58663314133030142
		 18 0.61278767879665763 19 0.63957161891480574 20 0.66663148928722404 21 0.6937189707206195
		 22 0.72060159479975006 23 0.74706272039215427 24 0.77293035999692516 25 0.79803394425110163
		 26 0.8221954983969697 27 0.84528922313345134 28 0.86723656545802386 29 0.88788264660075356
		 30 0.90718097163444544 31 0.92503423928975437 32 0.94141714796546716 33 0.95625332084882619
		 34 0.96958459790268137 35 0.98131616498508945 36 0.99148108794157652 37 1.0000632782194814
		 38 1.0070369501903815 39 1.0124336868233346 40 1.0161859394596842 41 1.0183016269041225
		 42 1.018865557749103 43 1.018060996158074 44 1.0159559012576611 45 1.0126515232449855
		 46 1.008197152471616 47 1.0026665299369304 48 0.9960612325861995 49 0.98848148985700579
		 50 0.97992828461526416 51 0.97044079013542417 52 0.96005249142182081 53 0.94878961129171779
		 54 0.9367147068926116 55 0.92379136487464608 56 0.91013896109517134 57 0.89571181416575141
		 58 0.88057813929852924 59 0.86470796700648966 60 0.84813192993260433 61 0.83090407535069921
		 62 0.81304958770153146 63 0.79463592211107792 64 0.77570152499826084 65 0.75633053859044264
		 66 0.73657916321249728 67 0.71653390601116695 68 0.69627551414493094 69 0.6759192250188143
		 70 0.6555587743679151 71 0.63530912030839282 72 0.61528757213070595 73 0.59563489307958561
		 74 0.57645391638098531 75 0.55791222654273442 76 0.54013505389435501 77 0.52326524904386718
		 78 0.50745321297590662 79 0.4928572961526998 80 0.47961850936799472;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY";
	rename -uid "1EB01B88-4964-D5E9-1EB1-A7BE3474FA15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.1647232103758451 1 -4.1905155227448629
		 2 -4.2152898789237829 3 -4.2378665150115804 4 -4.257206876260816 5 -4.2722504576165203
		 6 -4.2819560036361004 7 -4.2852412570411715 8 -4.2817152481116336 9 -4.2720439379848205
		 10 -4.2566288641919572 11 -4.2356160451988316 12 -4.2095366542115471 13 -4.178603374075311
		 14 -4.1431201888991378 15 -4.1034922003767971 16 -4.0599482022726141 17 -4.0129046929405421
		 18 -3.9626164264521311 19 -3.9094792092971264 20 -3.8538411007091851 21 -3.7960469896179529
		 22 -3.7365455283444131 23 -3.6756230474221914 24 -3.6137066797034425 25 -3.5511200239733562
		 26 -3.4883081578130746 27 -3.4256373599179963 28 -3.3635859928494756 29 -3.3024741231328099
		 30 -3.2428111236629258 31 -3.1848529561746783 32 -3.1292122206538595 33 -3.0761571394236054
		 34 -3.0262066420274856 35 -2.9797276832238269 36 -2.9371661896148731 37 -2.8989822040973188
		 38 -2.8654541895867967 39 -2.8371448582494314 40 -2.8143342841310717 41 -2.7975136514019865
		 42 -2.7866042484146569 43 -2.781196259727174 44 -2.7809222516603493 45 -2.7856333578320149
		 46 -2.7949897246869084 47 -2.8088517911599102 48 -2.8268473142992119 49 -2.848782174919342
		 50 -2.8743876731931195 51 -2.9034410540257869 52 -2.9356432191006125 53 -2.9707795410623672
		 54 -3.0085824226221694 55 -3.0487537176225628 56 -3.0911076449250152 57 -3.1353216600844127
		 58 -3.18130356448007 59 -3.2286745084419795 60 -3.2772617594018598 61 -3.3268435386594031
		 62 -3.3771657637158956 63 -3.4280121229136991 64 -3.4791651598966418 65 -3.5304003814510212
		 66 -3.5815286163203157 67 -3.6322293046986456 68 -3.6823828878068903 69 -3.7317575179547764
		 70 -3.7801072762902006 71 -3.8273014193423056 72 -3.8730459299887685 73 -3.9171965100383246
		 74 -3.9594952869739859 75 -3.9998545346533572 76 -4.0379686891805546 77 -4.0737160276168272
		 78 -4.1068546915727033 79 -4.1372596897075882 80 -4.1647232103758451;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ";
	rename -uid "329E7F99-4CD2-A782-607A-C39DD36E4B8D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -30.995248267722573 1 -30.665820987973568
		 2 -30.348273109238765 3 -30.055002975173608 4 -29.798478738414619 5 -29.591121307324908
		 6 -29.445456727939725 7 -29.373887571490766 8 -29.380422928588391 9 -29.458066909252061
		 10 -29.602963151337065 11 -29.811190523856929 12 -30.078929813586118 13 -30.402247308221629
		 14 -30.77720142672975 15 -31.200062541630647 16 -31.666771038769632 17 -32.173466640920651
		 18 -32.716321300728019 19 -33.291436032646793 20 -33.895542008257834 21 -34.525198909402405
		 22 -35.176021311679833 23 -35.843644895190202 24 -36.523819718591866 25 -37.21205442452257
		 26 -37.904105525697226 27 -38.595639638215758 28 -39.282266483509162 29 -39.959726518103835
		 30 -40.623643793702492 31 -41.26965468603192 32 -41.893552045783046 33 -42.490877614584612
		 34 -43.057342788215891 35 -43.588608770464802 36 -44.080328167818337 37 -44.52827076691495
		 38 -44.928042506998395 39 -45.275264134429541 40 -45.565676846501283 41 -45.794897152073027
		 42 -45.963167897866683 43 -46.075105104881878 44 -46.13254834187935 45 -46.137744871323676
		 46 -46.092746104447905 47 -45.999742602236765 48 -45.860695049241627 49 -45.677677554885086
		 50 -45.452754029246371 51 -45.188151131832889 52 -44.885897846135087 53 -44.547991411683682
		 54 -44.176638460884675 55 -43.773846540698763 56 -43.34164599422769 57 -42.882623707716476
		 58 -42.399465166082592 59 -41.894823325333483 60 -41.371382249605105 61 -40.831678353920587
		 62 -40.278345412430006 63 -39.714079336517408 64 -39.141497241905995 65 -38.563161130834629
		 66 -37.981820211637249 67 -37.400006322321829 68 -36.820363103135854 69 -36.245585322536172
		 70 -35.678175059469872 71 -35.121024468258334 72 -34.57649418244845 73 -34.047333761280996
		 74 -33.536218944123235 75 -33.045689003289063 76 -32.578472279576964 77 -32.137187003923067
		 78 -31.724462817739205 79 -31.342920886627038 80 -30.995248267722573;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA";
	rename -uid "C045D011-4A5F-225C-92FC-46A0F770C481";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 22.760416030883789 1 22.767675399780273
		 2 22.775178909301758 3 22.782873153686523 4 22.790733337402344 5 22.7987060546875
		 6 22.806745529174805 7 22.814830780029297 8 22.822906494140625 9 22.830949783325195
		 10 22.838899612426758 11 22.846725463867188 12 22.854391098022461 13 22.861854553222656
		 14 22.869068145751953 15 22.876001358032227 16 22.882602691650391 17 22.888856887817383
		 18 22.894685745239258 19 22.900081634521484 20 22.904987335205078 21 22.90936279296875
		 22 22.913185119628906 23 22.916402816772461 24 22.918954849243164 25 22.920839309692383
		 26 22.921989440917969 27 22.922374725341797 28 22.921979904174805 29 22.920806884765625
		 30 22.918914794921875 31 22.916337966918945 32 22.913124084472656 33 22.909303665161133
		 34 22.90492057800293 35 22.900022506713867 36 22.894636154174805 37 22.888820648193359
		 38 22.882587432861328 39 22.876007080078125 40 22.869119644165039 41 22.8619384765625
		 42 22.854522705078125 43 22.846914291381836 44 22.839141845703125 45 22.831256866455078
		 46 22.823291778564453 47 22.815284729003906 48 22.807296752929688 49 22.799350738525391
		 50 22.791492462158203 51 22.78375244140625 52 22.776180267333984 53 22.768804550170898
		 54 22.761690139770508 55 22.754848480224609 56 22.748334884643555 57 22.742179870605469
		 58 22.73643684387207 59 22.73114013671875 60 22.726303100585938 61 22.722013473510742
		 62 22.71827507019043 63 22.715143203735352 64 22.712657928466797 65 22.710849761962891
		 66 22.70976448059082 67 22.709444046020508 68 22.709918975830078 69 22.711233139038086
		 70 22.713239669799805 71 22.715740203857422 72 22.718751907348633 73 22.722244262695313
		 74 22.726230621337891 75 22.730714797973633 76 22.735683441162109 77 22.741144180297852
		 78 22.747089385986328 79 22.753503799438477 80 22.760416030883789;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA";
	rename -uid "8D184589-4E00-DA0F-E986-2494EBE6D8B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 10.392141342163086 1 10.400161743164062
		 2 10.40839958190918 3 10.41680908203125 4 10.425352096557617 5 10.433979034423828
		 6 10.442646026611328 7 10.451315879821777 8 10.45993709564209 9 10.468471527099609
		 10 10.476859092712402 11 10.48505687713623 12 10.493043899536133 13 10.50074577331543
		 14 10.508160591125488 15 10.515222549438477 16 10.521893501281738 17 10.52815055847168
		 18 10.533926010131836 19 10.539185523986816 20 10.543889045715332 21 10.547980308532715
		 22 10.551441192626953 23 10.554235458374023 24 10.556294441223145 25 10.557644844055176
		 26 10.558204650878906 27 10.557981491088867 28 10.55692195892334 29 10.555056571960449
		 30 10.552464485168457 31 10.549156188964844 32 10.545212745666504 33 10.540624618530273
		 34 10.535470008850098 35 10.529786109924316 36 10.52359676361084 37 10.516988754272461
		 38 10.509944915771484 39 10.502537727355957 40 10.494816780090332 41 10.486823081970215
		 42 10.478589057922363 43 10.470178604125977 44 10.461543083190918 45 10.452850341796875
		 46 10.444076538085937 47 10.435300827026367 48 10.42656135559082 49 10.41787052154541
		 50 10.409319877624512 51 10.400928497314453 52 10.392741203308105 53 10.384824752807617
		 54 10.377206802368164 55 10.369908332824707 56 10.363037109375 57 10.35659122467041
		 58 10.350648880004883 59 10.345210075378418 60 10.340377807617187 61 10.336227416992187
		 62 10.33275032043457 63 10.33006763458252 64 10.328130722045898 65 10.327027320861816
		 66 10.326752662658691 67 10.327317237854004 68 10.328795433044434 69 10.331154823303223
		 70 10.334268569946289 71 10.337916374206543 72 10.342083930969238 73 10.346776008605957
		 74 10.35190486907959 75 10.357559204101562 76 10.363645553588867 77 10.370168685913086
		 78 10.377086639404297 79 10.384421348571777 80 10.392141342163086;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA";
	rename -uid "4A15B2C6-4007-595D-932E-AB973B6BF632";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -18.414773941040039 1 -18.413852691650391
		 2 -18.412899017333984 3 -18.411975860595703 4 -18.411037445068359 5 -18.410099029541016
		 6 -18.409181594848633 7 -18.408269882202148 8 -18.407390594482422 9 -18.406534194946289
		 10 -18.405706405639648 11 -18.404930114746094 12 -18.404205322265625 13 -18.403522491455078
		 14 -18.40289306640625 15 -18.402334213256836 16 -18.40184211730957 17 -18.401443481445313
		 18 -18.40110969543457 19 -18.400884628295898 20 -18.400762557983398 21 -18.400741577148437
		 22 -18.40083122253418 23 -18.401044845581055 24 -18.401376724243164 25 -18.401811599731445
		 26 -18.402334213256836 27 -18.402959823608398 28 -18.403684616088867 29 -18.404474258422852
		 30 -18.405364990234375 31 -18.406314849853516 32 -18.407329559326172 33 -18.408397674560547
		 34 -18.409509658813477 35 -18.410669326782227 36 -18.41185188293457 37 -18.413066864013672
		 38 -18.414318084716797 39 -18.415554046630859 40 -18.416801452636719 41 -18.418048858642578
		 42 -18.419292449951172 43 -18.420511245727539 44 -18.421726226806641 45 -18.422901153564453
		 46 -18.424043655395508 47 -18.425136566162109 48 -18.426187515258789 49 -18.427196502685547
		 50 -18.428134918212891 51 -18.42900276184082 52 -18.429813385009766 53 -18.43052864074707
		 54 -18.431184768676758 55 -18.431753158569336 56 -18.432229995727539 57 -18.432607650756836
		 58 -18.432878494262695 59 -18.433052062988281 60 -18.433109283447266 61 -18.433023452758789
		 62 -18.432762145996094 63 -18.432344436645508 64 -18.43177604675293 65 -18.431085586547852
		 66 -18.430290222167969 67 -18.42938232421875 68 -18.428396224975586 69 -18.427343368530273
		 70 -18.426219940185547 71 -18.425054550170898 72 -18.423858642578125 73 -18.422639846801758
		 74 -18.421430587768555 75 -18.420215606689453 76 -18.419029235839844 77 -18.417863845825195
		 78 -18.416778564453125 79 -18.415729522705078 80 -18.414773941040039;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX";
	rename -uid "D1724112-4C8D-E465-6F20-6CB1FC20CA48";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 4.7693968465785991e-006 1 1.7524116336910666e-005
		 2 9.0465218575372515e-006 3 -2.9536330311738934e-006 4 -7.4069212364487347e-014 5 -9.8777444534455483e-006
		 6 -4.7693975391688282e-006 7 2.6493978726230844e-005 8 -7.6463672805731364e-006 9 1.4231533503558715e-005
		 10 -5.7539430819573903e-006 11 6.6618256474625612e-006 12 -5.6772810189895024e-006
		 13 -2.6790417517410633e-014 14 -4.6927362574131053e-006 15 1.3400312231475458e-005
		 16 8.1386412008136317e-006 17 1.5139418641457252e-005 18 4.2771262294790872e-006
		 19 -5.6772801141272188e-006 20 -1.5631684549436115e-005 21 2.9512546746716498e-014
		 22 -1.1770170281921107e-005 23 -1.1431223898033839e-005 24 -7.5697072567424902e-006
		 25 1.8157658135515968e-006 26 1.4877128509705773e-005 27 4.6927362547888278e-006
		 28 1.6200620804839661e-005 29 3.8615162959349623e-006 30 5.6772797334157449e-006
		 31 -1.8924267042893693e-006 32 1.8016387759127987e-005 33 1.7031844756647571e-005
		 34 -7.723031409732146e-006 35 2.2293516060683832e-005 36 1.2339108768498241e-005
		 37 -2.6501045175963782e-014 38 -5.3383292483845568e-006 39 -1.1354559031813496e-005
		 40 1.0523345927667183e-005 41 -1.7185166747976733e-005 42 -1.3323651052423833e-005
		 43 1.6539570997172554e-005 44 1.4231531185593718e-005 45 1.8157653561597514e-006
		 46 -5.7539430819573903e-006 47 -1.99088109009406e-005 48 -1.3323651052423833e-005
		 49 -2.8769728993902232e-006 50 -5.6772798485127044e-006 51 2.1801241334979395e-005
		 52 1.5478362166305514e-005 53 1.2415767906537481e-005 54 -3.2159194996634247e-006
		 55 5.2616698499631444e-006 56 1.6123956451727909e-005 57 1.8924266694385688e-006
		 58 4.7693968465785991e-006 59 1.7031842320875281e-005 60 5.0316827687982402e-006
		 61 -2.3846982332666155e-006 62 -1.1354559031813496e-005 63 -9.0465243664648587e-006
		 64 2.2370174870314922e-005 65 -4.7693968548181977e-006 66 6.6618256474625612e-006
		 67 -2.3846987716443249e-006 68 -2.6501045175963782e-014 69 9.9544068037551919e-006
		 70 3.3692431257597986e-006 71 -8.554249518774762e-006 72 -1.969087557891608e-006
		 73 -2.4613590937247887e-006 74 1.8157653561597523e-006 75 -3.5071246068666333e-014
		 76 4.2004648784677855e-006 77 1.1404442235826502e-014 78 2.4109274990229968e-005
		 79 -1.969087557891608e-006 80 4.7693968465785991e-006;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY";
	rename -uid "7A9C22A1-4852-FF65-05A3-32BFA2300791";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -29.162099886933031 1 -29.162118213028709
		 2 -29.16209203839259 3 -29.162108449304849 4 -29.162108449304455 5 -29.162108449305229
		 6 -29.162105833125811 7 -29.162108449304014 8 -29.162092739390914 9 -29.162116297842104
		 10 -29.162111065484403 11 -29.16211891402104 12 -29.162116297842598 13 -29.162094654573036
		 14 -29.162092038392924 15 -29.162108449303769 16 -29.162106534120579 17 -29.162134927488587
		 18 -29.162116297842605 19 -29.162109150299965 20 -29.16209465457273 21 -29.162100587929114
		 22 -29.162097270753026 23 -29.162116297841969 24 -29.162105833125842 25 -29.16209727075309
		 26 -29.162108449302554 27 -29.162118914021171 28 -29.162118914019786 29 -29.16211891402088
		 30 -29.162125454466434 31 -29.162089422212421 32 -29.162108449304654 33 -29.162118213028805
		 34 -29.162108449304139 35 -29.162115596848679 36 -29.162134927488619 37 -29.162105833125874
		 38 -29.162094654572318 39 -29.162100587928936 40 -29.162134927488065 41 -29.162108449303432
		 42 -29.162111065484016 43 -29.162113681663346 44 -29.162121530198963 45 -29.162108449305251
		 46 -29.162111065484403 47 -29.162109150299031 48 -29.162111065484016 49 -29.162133315849331
		 50 -29.162097270753289 51 -29.162108449304295 52 -29.162118914020237 53 -29.162113681662742
		 54 -29.162111065484442 55 -29.162108449305261 56 -29.162089422211722 57 -29.162092038392991
		 58 -29.162099886933031 59 -29.162113681663261 60 -29.162132007758977 61 -29.162100587929174
		 62 -29.162100587928936 63 -29.162108449305116 64 -29.162113681661527 65 -29.162099886933031
		 66 -29.16211891402104 67 -29.162105833125928 68 -29.162105833125874 69 -29.162116297842434
		 70 -29.162106534121087 71 -29.162100587928919 72 -29.162099886932861 73 -29.162097971749716
		 74 -29.162108449305251 75 -29.162133315849307 76 -29.162089422212301 77 -29.162111065484773
		 78 -29.162121530198345 79 -29.162099886932861 80 -29.162099886933031;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "5F56721C-4876-FA30-1272-28B2E21E3410";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -4.7693968548181977e-006 1 -6.3228786468142205e-006
		 2 -7.6463670748832927e-006 3 1.1354562528761628e-005 4 1.4154871355355903e-005 5 -2.7236478114366285e-006
		 6 4.7693975309292296e-006 7 -6.8918102740455937e-006 8 9.0465212108403001e-006 9 -7.2307599435919214e-006
		 10 8.55425274575156e-006 11 -5.2616708633871184e-006 12 1.4768168669106301e-006 13 -7.0774347103288183e-006
		 14 -2.3080381714994092e-006 15 -1.7600777257672254e-005 16 -1.0938949234582433e-005
		 17 -3.938181613531591e-006 18 -2.8769714308363515e-006 19 1.4768162534543152e-006
		 20 5.8306011069128264e-006 21 3.7848528350127539e-006 22 -2.2313768777035517e-006
		 23 1.003106954911695e-005 24 1.9690882178966232e-006 25 6.585162748762948e-006 26 -2.3278057621449356e-005
		 27 2.3080367661368949e-006 28 -1.480046555455936e-005 29 -8.0619799818122108e-006
		 30 -1.4768170168467548e-006 31 -4.6769457288634904e-016 32 -8.2153033470739429e-006
		 33 -4.4304513467825971e-006 34 1.6123960971202235e-005 35 -1.1092278254049672e-005
		 36 -6.7384907958312194e-006 37 3.7848536143024382e-006 38 1.3739257898102518e-005
		 39 2.9536312898504857e-006 40 -1.3323653993949667e-005 41 1.8585322056526154e-005
		 42 1.0523341372150576e-005 43 -2.5380234902240482e-006 44 -7.2307596361196163e-006
		 45 6.5851637391057622e-006 46 8.5542527457515617e-006 47 8.7075742450743652e-006
		 48 1.0523341372150576e-005 49 4.2771276704169002e-006 50 1.4768155559796802e-006
		 51 -9.1998472217575503e-006 52 8.3242650989651512e-006 53 -1.3815923202431595e-005
		 54 -7.9853175649938858e-006 55 -6.6618247087869171e-006 56 -7.7230271609977742e-006
		 57 3.8155745709280244e-015 58 -4.7693968548181977e-006 59 -4.4304499940971367e-006
		 60 1.4570482369839982e-005 61 2.3846982250270191e-006 62 2.9536312898504853e-006
		 63 7.6463699738460974e-006 64 -1.8169710880411291e-005 65 4.7693968465786008e-006
		 66 -5.2616708633871201e-006 67 2.3846987634047255e-006 68 3.7848536143024382e-006
		 69 -4.3537885168755e-006 70 -6.1695525581432666e-006 71 5.7539407885155867e-006 72 7.5697063316896635e-006
		 73 9.4621322042020961e-006 74 6.585163739105763e-006 75 5.1850099055627189e-006 76 4.2004648784677787e-006
		 77 -3.2925813730504392e-006 78 -4.5071137044623972e-006 79 7.5697063316896635e-006
		 80 -4.7693968548181977e-006;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA";
	rename -uid "2C49C9FD-4661-093E-276A-2D94EBA298E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -21.009696960449219 1 -21.003446578979492
		 2 -20.997014999389648 3 -20.990423202514648 4 -20.98370361328125 5 -20.976902008056641
		 6 -20.970041275024414 7 -20.963163375854492 8 -20.956302642822266 9 -20.949480056762695
		 10 -20.942745208740234 11 -20.936111450195313 12 -20.929634094238281 13 -20.923336029052734
		 14 -20.917251586914062 15 -20.911415100097656 16 -20.905855178833008 17 -20.900596618652344
		 18 -20.89569091796875 19 -20.891151428222656 20 -20.88701057434082 21 -20.883321762084961
		 22 -20.880083084106445 23 -20.877363204956055 24 -20.875175476074219 25 -20.87353515625
		 26 -20.872516632080078 27 -20.872129440307617 28 -20.872394561767578 29 -20.873291015625
		 30 -20.874797821044922 31 -20.876865386962891 32 -20.879474639892578 33 -20.882583618164062
		 34 -20.886177062988281 35 -20.890205383300781 36 -20.894632339477539 37 -20.899438858032227
		 38 -20.904590606689453 39 -20.910055160522461 40 -20.915802001953125 41 -20.921792984008789
		 42 -20.928001403808594 43 -20.934381484985352 44 -20.940908432006836 45 -20.947565078735352
		 46 -20.954292297363281 47 -20.961071014404297 48 -20.967859268188477 49 -20.974632263183594
		 50 -20.981346130371094 51 -20.987958908081055 52 -20.994466781616211 53 -21.000802993774414
		 54 -21.006948471069336 55 -21.012868881225586 56 -21.018518447875977 57 -21.023860931396484
		 58 -21.028877258300781 59 -21.033523559570313 60 -21.037746429443359 61 -21.041532516479492
		 62 -21.044849395751953 63 -21.047645568847656 64 -21.049901962280273 65 -21.051567077636719
		 66 -21.052606582641602 67 -21.052972793579102 68 -21.052648544311523 69 -21.051582336425781
		 70 -21.049930572509766 71 -21.047836303710937 72 -21.045307159423828 73 -21.042348861694336
		 74 -21.038949966430664 75 -21.035139083862305 76 -21.030895233154297 77 -21.026220321655273
		 78 -21.02113151550293 79 -21.015617370605469 80 -21.009696960449219;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA";
	rename -uid "3C1DAC69-4DBB-07EA-AB0D-5686141CD408";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 9.823974609375 1 9.8155612945556641 2 9.8068408966064453
		 3 9.7978620529174805 4 9.7886943817138672 5 9.77935791015625 6 9.7699089050292969
		 7 9.7603921890258789 8 9.7508649826049805 9 9.7413740158081055 10 9.7319307327270508
		 11 9.7226171493530273 12 9.713465690612793 13 9.7045402526855469 14 9.6958637237548828
		 15 9.687495231628418 16 9.6794528961181641 17 9.6718387603759766 18 9.6646623611450195
		 19 9.6579780578613281 20 9.6518621444702148 21 9.6462955474853516 22 9.6413822174072266
		 23 9.637141227722168 24 9.6336164474487305 25 9.6309270858764648 26 9.6290702819824219
		 27 9.6281223297119141 28 9.6281261444091797 29 9.6290121078491211 30 9.6307802200317383
		 31 9.633366584777832 32 9.6367301940917969 33 9.6408224105834961 34 9.6455593109130859
		 35 9.6509599685668945 36 9.656926155090332 37 9.6634311676025391 38 9.6704263687133789
		 39 9.6778736114501953 40 9.6856822967529297 41 9.6938629150390625 42 9.7023382186889648
		 43 9.7110824584960937 44 9.7200193405151367 45 9.7291297912597656 46 9.7383041381835937
		 47 9.7475996017456055 48 9.7568807601928711 49 9.7661600112915039 50 9.7753610610961914
		 51 9.7844505310058594 52 9.7933578491210937 53 9.8020811080932617 54 9.8105278015136719
		 55 9.8186655044555664 56 9.8264780044555664 57 9.8338937759399414 58 9.8408670425415039
		 59 9.8473711013793945 60 9.8533449172973633 61 9.8587713241577148 62 9.8635845184326172
		 63 9.8678054809570312 64 9.8713159561157227 65 9.8740692138671875 66 9.8760166168212891
		 67 9.8770532608032227 68 9.8771562576293945 69 9.8762798309326172 70 9.8746223449707031
		 71 9.872319221496582 72 9.8694372177124023 73 9.8659763336181641 74 9.8618659973144531
		 75 9.8571529388427734 76 9.8518123626708984 77 9.845829963684082 78 9.839198112487793
		 79 9.8319416046142578 80 9.823974609375;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA";
	rename -uid "55CFA03A-4E58-3420-01DE-F89CA7B021A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -31.231805801391602 1 -31.231880187988281
		 2 -31.23198127746582 3 -31.232109069824219 4 -31.232259750366211 5 -31.232429504394531
		 6 -31.232643127441406 7 -31.232866287231445 8 -31.233108520507813 9 -31.23338508605957
		 10 -31.233676910400391 11 -31.233989715576172 12 -31.234342575073242 13 -31.234699249267578
		 14 -31.235092163085938 15 -31.235492706298828 16 -31.235929489135742 17 -31.236392974853516
		 18 -31.236860275268555 19 -31.237361907958984 20 -31.23786735534668 21 -31.238437652587891
		 22 -31.239017486572266 23 -31.239614486694336 24 -31.240217208862305 25 -31.240833282470703
		 26 -31.241439819335938 27 -31.242027282714844 28 -31.242584228515625 29 -31.243122100830078
		 30 -31.243644714355469 31 -31.244117736816406 32 -31.244562149047852 33 -31.244985580444336
		 34 -31.245393753051758 35 -31.245754241943359 36 -31.246105194091797 37 -31.246410369873047
		 38 -31.246700286865234 39 -31.246944427490234 40 -31.247171401977539 41 -31.247350692749023
		 42 -31.247501373291016 43 -31.247634887695313 44 -31.247709274291992 45 -31.247772216796875
		 46 -31.247791290283203 47 -31.247777938842773 48 -31.247730255126953 49 -31.247634887695313
		 50 -31.247518539428711 51 -31.247373580932617 52 -31.247158050537109 53 -31.246936798095703
		 54 -31.246654510498047 55 -31.246339797973633 56 -31.24598503112793 57 -31.245582580566406
		 58 -31.245153427124023 59 -31.244686126708984 60 -31.244155883789063 61 -31.243568420410156
		 62 -31.242887496948242 63 -31.242136001586914 64 -31.241336822509766 65 -31.240501403808594
		 66 -31.239631652832031 67 -31.238777160644531 68 -31.237936019897461 69 -31.237148284912109
		 70 -31.236366271972656 71 -31.235612869262695 72 -31.234895706176758 73 -31.23420524597168
		 74 -31.233591079711914 75 -31.233057022094727 76 -31.232593536376953 77 -31.232219696044922
		 78 -31.231960296630859 79 -31.2318115234375 80 -31.231805801391602;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX";
	rename -uid "C9C07828-491E-6FB5-E2D7-E8B2909F81DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.0509911110621907e-005 1 -1.3816622122275963e-005
		 2 -1.839011966677919e-005 3 -1.9489380418115641e-005 4 2.8543149971597049e-014 5 -1.9348627021800507e-005
		 6 4.4327408238275659e-006 7 -1.75545208044774e-005 8 -1.5908127028812625e-014 9 -2.0597564923091009e-005
		 10 -3.4474626663334675e-006 11 -2.3640614109967042e-005 12 -1.2858116304138595e-005
		 13 -6.367604215111824e-006 14 -1.9348627021800507e-005 15 -3.8697248874699539e-006
		 16 -8.7158077106197171e-006 17 3.4563857130161658e-006 18 -5.5141589591130911e-006
		 19 5.3823252900338823e-006 20 1.2576603623571093e-005 21 -1.230401953105922e-005
		 22 2.8543149971597049e-014 23 -4.1637392862222408e-015 24 -1.9259386923919702e-006
		 25 4.9689862730229002e-006 26 -7.0535272051402252e-006 27 -9.5335577119925584e-006
		 28 3.1838039581290172e-006 29 -1.9348627021800507e-005 30 -2.2110169515065054e-005
		 31 2.6207859086905285e-006 32 -2.005239633240259e-005 33 2.005238750589434e-005 34 -8.8476351595172669e-006
		 35 -2.6297101524424298e-006 36 -1.3825550398666777e-005 37 6.3586786356946741e-006
		 38 5.3912481223283947e-006 39 -1.7967858095061416e-005 40 -3.2479326234622757e-005
		 41 3.5971399313774933e-006 42 -4.5556477310074468e-006 43 -9.2520503170985175e-006
		 44 2.488954796879585e-006 45 -3.579293526060469e-006 46 1.7818176482221785e-005 47 -1.3977541353795017e-014
		 48 5.3912485059217788e-006 49 -6.7630957118115439e-006 50 -3.8697248874699599e-006
		 51 -6.2179272941424569e-006 52 6.4905110223900793e-006 53 -8.0120337578557575e-006
		 54 -5.6638333397215939e-006 55 -9.6743114269737656e-006 56 -4.1423091206939294e-006
		 57 6.6312635752683562e-006 58 -5.2594187709128509e-006 59 -3.1748783482256874e-006
		 60 -6.0771724320794584e-006 61 4.2830630055002942e-006 62 -9.5514051358619554e-006
		 63 1.3977541353795017e-014 64 6.3586786356946732e-006 65 -2.2523502190178284e-005
		 66 -4.5556477310074468e-006 67 1.2444774031943205e-005 68 -1.3720857345565023e-013
		 69 6.3675993899454303e-006 70 8.4829709859831523e-015 71 -1.6314498776476037e-005
		 72 -5.2594187709128509e-006 73 1.5760403597225015e-005 74 2.6207856687654451e-006
		 75 -2.3303529511224495e-006 76 -9.6743114269737656e-006 77 -9.8150708218575592e-006
		 78 -1.1749929246344623e-005 79 -5.9364175936393864e-006 80 -1.0509911110621909e-005;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY";
	rename -uid "423046CD-4EA4-4B97-4507-E8BC492F2207";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 31.960573111769595 1 31.960607654802029
		 2 31.960586712640708 3 31.960569388742844 4 31.96058548597961 5 31.960605179961277
		 6 31.960580536295506 7 31.960605179961245 8 31.960584237800756 9 31.960576813272002
		 10 31.960575586612222 11 31.960589187482054 12 31.960597755438641 13 31.960581762957293
		 14 31.960605179961277 15 31.960575586612766 16 31.960595280596849 17 31.960578061454886
		 18 31.960574338428582 19 31.960581762958089 20 31.960559594129013 21 31.960564543814815
		 22 31.96058548597961 23 31.960576813273523 24 31.960579288115415 25 31.960573111770032
		 26 31.960581762958196 27 31.960589187484281 28 31.960598982104589 29 31.960605179961277
		 30 31.96062362577608 31 31.960573111770167 32 31.960571863584025 33 31.960554644438918
		 34 31.960581762958348 35 31.960589187484256 36 31.960605179961238 37 31.960560842314685
		 38 31.960578061454829 39 31.960605179961309 40 31.960586712640247 41 31.960578061454701
		 42 31.960570636927528 43 31.960596507262309 44 31.960575586612769 45 31.960575586610798
		 46 31.960578061453575 47 31.960581762958395 48 31.960580536296703 49 31.960596507262125
		 50 31.960575586612766 51 31.960606406629186 52 31.960594032420449 53 31.960586712642574
		 54 31.960575586612713 55 31.960585485979546 56 31.960570636927645 57 31.960575586612681
		 58 31.960581762957879 59 31.960570636927631 60 31.960584237800674 61 31.960575586612777
		 62 31.960576813270425 63 31.960581762958395 64 31.960560842314685 65 31.960597755438322
		 66 31.960570636927528 67 31.960578061453937 68 31.960569388742456 69 31.960560842313448
		 70 31.960553417785821 71 31.960569388742599 72 31.960581762957879 73 31.960559594128302
		 74 31.960573111770167 75 31.960578061451095 76 31.960585485979546 77 31.960606406628923
		 78 31.960579288115778 79 31.96057063692739 80 31.960573111769595;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "097E41D8-4E2B-2468-6149-808469D89D2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -1.1890681917998869e-005 1 1.371842145765901e-006
		 2 -1.7699734110175136e-005 3 -9.1336030018047629e-006 4 -5.5275406915376189e-006
		 5 -5.5409315402119076e-006 6 1.5478898801164398e-005 7 -8.5795188762206801e-006 8 3.8697255043974022e-006
		 9 -1.3003331149034322e-005 10 9.6698505045942186e-006 11 -1.7427149926033239e-005
		 12 -1.0786962388642258e-005 13 -1.6032993099787919e-005 14 -5.5409315402119084e-006
		 15 -1.2331617439951287e-014 16 -1.492927144380883e-005 17 2.7660010440582249e-006
		 18 1.7958933482166867e-005 19 -9.1157582769059567e-006 20 3.6015989592348099e-006
		 21 -8.8520946773822918e-006 22 -5.5275406915376189e-006 23 -1.9348626193455529e-006
		 24 1.1881757533140222e-005 25 -7.4579413963666306e-006 26 -9.1246815205670258e-006
		 27 7.8996692034100494e-014 28 8.016498719447703e-006 29 -5.5409315402119067e-006
		 30 -2.7793967798272453e-006 31 -6.3542183411328406e-006 32 -2.350432050094987e-005
		 33 2.3504312509123828e-005 34 -6.0860957523813282e-006 35 -6.0816347790478857e-006
		 36 -1.106401097470291e-005 37 3.5971391481622127e-006 38 3.320093635604403e-006 39 -6.9217023186072247e-006
		 40 -1.1077394133611445e-005 41 6.3586788471343308e-006 42 5.8001252790319099e-006
		 43 8.007572509308156e-006 44 2.488954796879585e-006 45 1.8513022837779933e-005 46 -9.106834484364795e-006
		 47 6.9083120435339748e-006 48 3.3200940416307444e-006 49 1.0496529033996914e-005
		 50 -1.2331616681647959e-014 51 1.1711574860861608e-014 52 -5.2460332408953169e-006
		 53 3.034123631403237e-006 54 1.9304007402458639e-006 55 -2.770463374320994e-006 56 4.1423090953975039e-006
		 57 -1.6533542214343295e-006 58 -1.2163268248453227e-005 59 4.4193554163999542e-006
		 60 3.5882173076104859e-006 61 1.3648797903563114e-014 62 -2.404949093626303e-005
		 63 -6.9083111091298196e-006 64 3.5971391481622127e-006 65 -1.2194449012590422e-013
		 66 5.8001252790319099e-006 67 1.24447740319432e-005 68 -1.6305577161708638e-005 69 1.603298747634613e-005
		 70 8.8431716125243331e-006 71 -1.3552959219787181e-005 72 -1.2163268248453229e-005
		 73 1.1618093299200862e-005 74 -6.354217381432481e-006 75 2.5975423994427564e-005
		 76 -2.7704633743209928e-006 77 -6.3631467900097263e-006 78 -6.9172349915880679e-006
		 79 7.1808956215140332e-006 80 -1.1890681917998869e-005;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "07943707-4B7F-4DA9-60E7-78BDC0A89525";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 21.523422241210938 1 21.586992263793945
		 2 21.651992797851563 3 21.717685699462891 4 21.783412933349609 5 21.8485107421875
		 6 21.912296295166016 7 21.974103927612305 8 22.033500671386719 9 22.09040641784668
		 10 22.144573211669922 11 22.195589065551758 12 22.24363899230957 13 22.288448333740234
		 14 22.329843521118164 15 22.367658615112305 16 22.401697158813477 17 22.431802749633789
		 18 22.457742691040039 19 22.479381561279297 20 22.496545791625977 21 22.50904655456543
		 22 22.516742706298828 23 22.519432067871094 24 22.517002105712891 25 22.509204864501953
		 26 22.495927810668945 27 22.476959228515625 28 22.452333450317383 29 22.422300338745117
		 30 22.387413024902344 31 22.34797477722168 32 22.304576873779297 33 22.257564544677734
		 34 22.207481384277344 35 22.154685974121094 36 22.09968376159668 37 22.042934417724609
		 38 21.984832763671875 39 21.925907135009766 40 21.866508483886719 41 21.807161331176758
		 42 21.748106002807617 43 21.689401626586914 44 21.631082534790039 45 21.573640823364258
		 46 21.517280578613281 47 21.462230682373047 48 21.408641815185547 49 21.356760025024414
		 50 21.306785583496094 51 21.258968353271484 52 21.213447570800781 53 21.170480728149414
		 54 21.130271911621094 55 21.092994689941406 56 21.058879852294922 57 21.028127670288086
		 58 21.001001358032227 59 20.977689743041992 60 20.958395004272461 61 20.943367004394531
		 62 20.932796478271484 63 20.926935195922852 64 20.926006317138672 65 20.930234909057617
		 66 20.939834594726562 67 20.955022811889648 68 20.976068496704102 69 21.003177642822266
		 70 21.035064697265625 71 21.070314407348633 72 21.108781814575195 73 21.150453567504883
		 74 21.195146560668945 75 21.242881774902344 76 21.293489456176758 77 21.346939086914063
		 78 21.403116226196289 79 21.461967468261719 80 21.523422241210938;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "8B7C4738-4E95-190E-633C-F2800D7A76EF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 93.607086181640625 1 93.630050659179687
		 2 93.651824951171875 3 93.671783447265625 4 93.689292907714844 5 93.703842163085938
		 6 93.714828491210937 7 93.721786499023437 8 93.724533081054688 9 93.723426818847656
		 10 93.717628479003906 11 93.706466674804688 12 93.691642761230469 13 93.67315673828125
		 14 93.650985717773438 15 93.625045776367188 16 93.595291137695313 17 93.561698913574219
		 18 93.524200439453125 19 93.482757568359375 20 93.437362670898438 21 93.387962341308594
		 22 93.334709167480469 23 93.277778625488281 24 93.217369079589844 25 93.153823852539063
		 26 93.087440490722656 27 93.018638610839844 28 92.9478759765625 29 92.875686645507813
		 30 92.802642822265625 31 92.729385375976562 32 92.656593322753906 33 92.585014343261719
		 34 92.515388488769531 35 92.448593139648438 36 92.385429382324219 37 92.326736450195313
		 38 92.273429870605469 39 92.226371765136719 40 92.186424255371094 41 92.154449462890625
		 42 92.130584716796875 43 92.113487243652344 44 92.102088928222656 45 92.097915649414063
		 46 92.100730895996094 47 92.110191345214844 48 92.126029968261719 49 92.1478271484375
		 50 92.17523193359375 51 92.207832336425781 52 92.245231628417969 53 92.286972045898437
		 54 92.3326416015625 55 92.381790161132813 56 92.434043884277344 57 92.488876342773438
		 58 92.545745849609375 59 92.604225158691406 60 92.663795471191406 61 92.724090576171875
		 62 92.78466796875 63 92.845130920410156 64 92.905143737792969 65 92.964317321777344
		 66 93.022354125976562 67 93.078994750976563 68 93.134002685546875 69 93.187110900878906
		 70 93.238143920898438 71 93.286849975585938 72 93.333145141601563 73 93.376876831054688
		 74 93.417991638183594 75 93.456382751464844 76 93.492057800292969 77 93.524971008300781
		 78 93.55511474609375 79 93.582481384277344 80 93.607086181640625;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "CFCD9E8F-4707-1C60-64EC-CCB1059AA351";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -33.464076995849609 1 -33.32623291015625
		 2 -33.193065643310547 3 -33.069644927978516 4 -32.960994720458984 5 -32.872173309326172
		 6 -32.808258056640625 7 -32.774261474609375 8 -32.771858215332031 9 -32.798233032226563
		 10 -32.852291107177734 11 -32.932796478271484 12 -33.037490844726563 13 -33.164813995361328
		 14 -33.313205718994141 15 -33.481151580810547 16 -33.66705322265625 17 -33.869342803955078
		 18 -34.086475372314453 19 -34.316917419433594 20 -34.559284210205078 21 -34.812225341796875
		 22 -35.074008941650391 23 -35.342800140380859 24 -35.616847991943359 25 -35.894268035888672
		 26 -36.173305511474609 27 -36.452190399169922 28 -36.729103088378906 29 -37.002326965332031
		 30 -37.270065307617188 31 -37.530582427978516 32 -37.782199859619141 33 -38.023147583007812
		 34 -38.251754760742187 35 -38.466300964355469 36 -38.665134429931641 37 -38.846611022949219
		 38 -39.009044647216797 39 -39.1507568359375 40 -39.2701416015625 41 -39.365467071533203
		 42 -39.436939239501953 43 -39.486663818359375 44 -39.515842437744141 45 -39.524505615234375
		 46 -39.513450622558594 47 -39.483486175537109 48 -39.435329437255859 49 -39.369758605957031
		 50 -39.287490844726563 51 -39.1893310546875 52 -39.076026916503906 53 -38.948291778564453
		 54 -38.806919097900391 55 -38.652610778808594 56 -38.486114501953125 57 -38.308361053466797
		 58 -38.120304107666016 59 -37.92291259765625 60 -37.717174530029297 61 -37.503753662109375
		 62 -37.283504486083984 63 -37.057567596435547 64 -36.827072143554688 65 -36.5931396484375
		 66 -36.356948852539063 67 -36.119632720947266 68 -35.882339477539062 69 -35.646255493164062
		 70 -35.412498474121094 71 -35.182384490966797 72 -34.956920623779297 73 -34.737361907958984
		 74 -34.524887084960938 75 -34.320640563964844 76 -34.125808715820312 77 -33.941570281982422
		 78 -33.769084930419922 79 -33.609539031982422 80 -33.464076995849609;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "9AFFC3F6-469F-841D-02FF-1AB542D50463";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -42.134432549968601 1 -41.743371958410833
		 2 -41.360054116013778 3 -40.989717363824546 4 -40.6373824998267 5 -40.308053711975568
		 6 -40.006729714357149 7 -39.738148723040375 8 -39.502959666629621 9 -39.296836104482331
		 10 -39.116677916454918 11 -38.95943383593805 12 -38.822231068427037 13 -38.698607312909992
		 14 -38.583815697085996 15 -38.47739073185074 16 -38.379049870296932 17 -38.288909848226972
		 18 -38.206950392410988 19 -38.133413597660486 20 -38.069160182063086 21 -38.014883218317983
		 22 -37.970356652197644 23 -37.934943419397214 24 -37.908323886133822 25 -37.889771087812996
		 26 -37.878761345483078 27 -37.874501967801621 28 -37.876264620750099 29 -37.883429812768291
		 30 -37.895402490156954 31 -37.911205869712823 32 -37.930241948498995 33 -37.951325934161162
		 34 -37.973587144334218 35 -37.995890781948873 36 -38.017112554286349 37 -38.036078180386923
		 38 -38.05153635941533 39 -38.062201093172135 40 -38.066782090634959 41 -38.063956119933614
		 42 -38.053494965048372 43 -38.036312390056381 44 -38.01240397701573 45 -37.982319742467098
		 46 -37.946815305578731 47 -37.906348652654458 48 -37.861305752638764 49 -37.812245688250634
		 50 -37.759591700363281 51 -37.767940181411248 52 -37.893073752703756 53 -38.123686995087255
		 54 -38.449454766838855 55 -38.860504026976216 56 -39.347060713003287 57 -39.899269260092069
		 58 -40.506842211705113 59 -41.158110001931632 60 -41.840199637150647 61 -42.53840958782633
		 62 -43.236413825867139 63 -43.916500387295301 64 -44.559475219237505 65 -45.1444167563264
		 66 -45.649596711763621 67 -46.052403341331718 68 -46.330194553928195 69 -46.460791768013038
		 70 -46.422224653842626 71 -46.230345319604361 72 -45.929274858704645 73 -45.540756554298191
		 74 -45.086615727092351 75 -44.58839706828924 76 -44.066926829348908 77 -43.54217919986106
		 78 -43.033169703426253 79 -42.558081477970504 80 -42.134432549968601;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "72E743A0-46A4-55C8-E4F6-E194674FFBA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 40.89497457285561 1 41.034508377068917
		 2 41.174735602358474 3 41.312815579035089 4 41.446058152852935 5 41.571849044437499
		 6 41.687493188645306 7 41.790403034781363 8 41.878041592767957 9 41.948290676858647
		 10 41.998942892809708 11 42.027535786355301 12 42.031839861352495 13 42.001053736633949
		 14 41.927279202974802 15 41.812284121571849 16 41.657709653214624 17 41.46516773505828
		 18 41.236027627315138 19 40.971784434301952 20 40.673603216819615 21 40.342755475576347
		 22 39.981214782892074 23 39.591160926501892 24 39.174856322462546 25 38.734848344135408
		 26 38.273735508980998 27 37.79431725069297 28 37.299814322790013 29 36.793568373280912
		 30 36.279437689838382 31 35.761210848598296 32 35.242931895920698 33 34.728703643513256
		 34 34.222885352181429 35 33.729692883807679 36 33.253564348566066 37 32.798997286749277
		 38 32.370354401806416 39 31.972218022135543 40 31.608948229192087 41 31.285015154422243
		 42 31.004084962420162 43 30.76971297366935 44 30.585907274610744 45 30.447824978603705
		 46 30.347108465025443 47 30.282682672580588 48 30.253285497248022 49 30.257685942809356
		 50 30.294625556658218 51 30.387430806709549 52 30.555912841980291 53 30.793609769164807
		 54 31.094256975038327 55 31.451810383913148 56 31.860296740925158 57 32.31323238366042
		 58 32.804095422404956 59 33.325907005836306 60 33.871642096404436 61 34.434206578601348
		 62 35.006218105043658 63 35.579743738881021 64 36.146723205259619 65 36.699175879184992
		 66 37.229012276407111 67 37.728268808533073 68 38.189214801131719 69 38.604229875542536
		 70 38.9649177182418 71 39.274182154381776 72 39.544246717037645 73 39.780133755377463
		 74 39.986805474934307 75 40.169506455559322 76 40.333058399577666 77 40.482564110143436
		 78 40.622813192143269 79 40.758698062639553 80 40.89497457285561;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "67E6E65E-487E-1041-91B5-C3A28D894CFB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -48.919929154046095 1 -48.791322015140167
		 2 -48.667219182100624 3 -48.551856083206395 4 -48.449372875495293 5 -48.363853871849777
		 6 -48.299476046556457 7 -48.260284134638113 8 -48.246620856116053 9 -48.254270347975933
		 10 -48.280177654701994 11 -48.321190815137982 12 -48.374393236019671 13 -48.430917671007848
		 14 -48.484045042746487 15 -48.53392276499487 16 -48.580966839616607 17 -48.625936339394805
		 18 -48.669504874399351 19 -48.71249314474813 20 -48.756619362192069 21 -48.803362268237542
		 22 -48.852879029385555 23 -48.90492764747664 24 -48.959459858667287 25 -49.01605127325336
		 26 -49.074311203007532 27 -49.133656663327095 28 -49.193499267289177 29 -49.253587508557047
		 30 -49.313638746612781 31 -49.373126400415117 32 -49.431683999946756 33 -49.488557960633187
		 34 -49.543110602898423 35 -49.594562239285793 36 -49.642026796729965 37 -49.684642237130539
		 38 -49.72145749000213 39 -49.75142637536554 40 -49.773562766380678 41 -49.786867699796851
		 42 -49.791878525866707 43 -49.790578783197894 44 -49.783784878895439 45 -49.770686824362322
		 46 -49.749882482202132 47 -49.721578390837387 48 -49.685866555286502 49 -49.643039529894565
		 50 -49.593325050818031 51 -49.553165453646123 52 -49.536807066561757 53 -49.541824498294012
		 54 -49.566177155712786 55 -49.608256973137593 56 -49.666452818224393 57 -49.73951987245065
		 58 -49.826462624154381 59 -49.925493736231367 60 -50.034426810905408 61 -50.149866878360243
		 62 -50.267817146682653 63 -50.383932390255261 64 -50.493148921752294 65 -50.58941658743683
		 66 -50.666162953322726 67 -50.71622244923136 68 -50.732218430831168 69 -50.706988974007253
		 70 -50.632309947991459 71 -50.512276660307748 72 -50.361427182747882 73 -50.187334202092018
		 74 -49.997585481649807 75 -49.799773161920697 76 -49.600884694448865 77 -49.407584927581489
		 78 -49.225973622559842 79 -49.061662188218762 80 -48.919929154046095;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "FB5CE5D1-43A9-EB79-F1DF-4CA911144732";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -23.12449836730957 1 -23.051645278930664
		 2 -22.97859001159668 3 -22.906087875366211 4 -22.834884643554688 5 -22.765724182128906
		 6 -22.699386596679688 7 -22.636587142944336 8 -22.577884674072266 9 -22.523357391357422
		 10 -22.473297119140625 11 -22.42817497253418 12 -22.387884140014648 13 -22.353546142578125
		 14 -22.325881958007813 15 -22.304653167724609 16 -22.289880752563477 17 -22.281394958496094
		 18 -22.279109954833984 19 -22.282842636108398 20 -22.292455673217773 21 -22.307815551757813
		 22 -22.328727722167969 23 -22.355108261108398 24 -22.386791229248047 25 -22.423715591430664
		 26 -22.465732574462891 27 -22.51275634765625 28 -22.564544677734375 29 -22.620603561401367
		 30 -22.680156707763672 31 -22.742671966552734 32 -22.807373046875 33 -22.87371826171875
		 34 -22.941020965576172 35 -23.008695602416992 36 -23.076101303100586 37 -23.142627716064453
		 38 -23.207712173461914 39 -23.270679473876953 40 -23.330984115600586 41 -23.388309478759766
		 42 -23.442882537841797 43 -23.494709014892578 44 -23.543691635131836 45 -23.589536666870117
		 46 -23.632257461547852 47 -23.671781539916992 48 -23.708179473876953 49 -23.741367340087891
		 50 -23.771337509155273 51 -23.798061370849609 52 -23.821577072143555 53 -23.841815948486328
		 54 -23.858779907226563 55 -23.872549057006836 56 -23.883035659790039 57 -23.890310287475586
		 58 -23.894296646118164 59 -23.89509391784668 60 -23.892673492431641 61 -23.887060165405273
		 62 -23.877908706665039 63 -23.86469841003418 64 -23.847301483154297 65 -23.825969696044922
		 66 -23.800874710083008 67 -23.771732330322266 68 -23.738178253173828 69 -23.699907302856445
		 70 -23.658124923706055 71 -23.614156723022461 72 -23.568096160888672 73 -23.519870758056641
		 74 -23.469598770141602 75 -23.417192459106445 76 -23.362739562988281 77 -23.306224822998047
		 78 -23.247674942016602 79 -23.187099456787109 80 -23.12449836730957;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "31E8E012-47AB-E26D-4E2B-ACA825F67F76";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 93.981224060058594 1 94.015495300292969
		 2 94.04754638671875 3 94.075775146484375 4 94.098678588867187 5 94.114852905273438
		 6 94.122894287109375 7 94.121482849121094 8 94.110481262207031 9 94.091415405273438
		 10 94.064346313476562 11 94.029281616210938 12 93.988906860351562 13 93.944999694824219
		 14 93.898880004882813 15 93.850479125976563 16 93.799575805664063 17 93.746131896972656
		 18 93.68994140625 19 93.630882263183594 20 93.568817138671875 21 93.503555297851563
		 22 93.435203552246094 23 93.363739013671875 24 93.289321899414063 25 93.212135314941406
		 26 93.132369995117188 27 93.050323486328125 28 92.966407775878906 29 92.880966186523438
		 30 92.794570922851563 31 92.707679748535156 32 92.62103271484375 33 92.535202026367188
		 34 92.45098876953125 35 92.369178771972656 36 92.290596008300781 37 92.216094970703125
		 38 92.146553039550781 39 92.082916259765625 40 92.025993347167969 41 91.977279663085938
		 42 91.937568664550781 43 91.905418395996094 44 91.879737854003906 45 91.862220764160156
		 46 91.852775573730469 47 91.851242065429687 48 91.857398986816406 49 91.871047973632813
		 50 91.891937255859375 51 91.919837951660156 52 91.954399108886719 53 91.995391845703125
		 54 92.042488098144531 55 92.095306396484375 56 92.153694152832031 57 92.217147827148438
		 58 92.285324096679688 59 92.357810974121094 60 92.434219360351562 61 92.514259338378906
		 62 92.597061157226563 63 92.681632995605469 64 92.767463684082031 65 92.854080200195313
		 66 92.941024780273437 67 93.027801513671875 68 93.11395263671875 69 93.199043273925781
		 70 93.28265380859375 71 93.364425659179688 72 93.444061279296875 73 93.521308898925781
		 74 93.595932006835938 75 93.667800903320312 76 93.736747741699219 77 93.802665710449219
		 78 93.865409851074219 79 93.924957275390625 80 93.981224060058594;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "E27D8F4C-4D97-57EC-77D1-4C9FD3694A78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -35.873222351074219 1 -35.731979370117188
		 2 -35.592384338378906 3 -35.459499359130859 4 -35.338348388671875 5 -35.233974456787109
		 6 -35.151454925537109 7 -35.095737457275391 8 -35.068840026855469 9 -35.068767547607422
		 10 -35.095111846923828 11 -35.147315979003906 12 -35.223842620849609 13 -35.323738098144531
		 14 -35.446193695068359 15 -35.589973449707031 16 -35.753211975097656 17 -35.934429168701172
		 18 -36.132190704345703 19 -36.34503173828125 20 -36.571697235107422 21 -36.810951232910156
		 22 -37.061088562011719 23 -37.320289611816406 24 -37.586814880371094 25 -37.858760833740234
		 26 -38.134334564208984 27 -38.411693572998047 28 -38.688934326171875 29 -38.964206695556641
		 30 -39.235603332519531 31 -39.501201629638672 32 -39.7591552734375 33 -40.007484436035156
		 34 -40.244308471679688 35 -40.467697143554687 36 -40.675746917724609 37 -40.866603851318359
		 38 -41.038333892822266 39 -41.189037322998047 40 -41.316905975341797 41 -41.420131683349609
		 42 -41.49871826171875 43 -41.555164337158203 44 -41.591361999511719 45 -41.607376098632813
		 46 -41.604034423828125 47 -41.582160949707031 48 -41.542518615722656 49 -41.485908508300781
		 50 -41.413082122802734 51 -41.324882507324219 52 -41.222057342529297 53 -41.105342864990234
		 54 -40.975528717041016 55 -40.833305358886719 56 -40.679401397705078 57 -40.514701843261719
		 58 -40.340179443359375 59 -40.156726837158203 60 -39.965293884277344 61 -39.766456604003906
		 62 -39.560935974121094 63 -39.349704742431641 64 -39.1337890625 65 -38.913070678710937
		 66 -38.687747955322266 67 -38.459247589111328 68 -38.229034423828125 69 -37.998611450195313
		 70 -37.769378662109375 71 -37.542972564697266 72 -37.320713043212891 73 -37.104148864746094
		 74 -36.894794464111328 75 -36.694099426269531 76 -36.503578186035156 77 -36.324729919433594
		 78 -36.159034729003906 79 -36.008037567138672 80 -35.873222351074219;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "EED8AAED-40BE-FD2D-DA0D-AABF77063E9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 24.486126697653372 1 24.633287393355278
		 2 24.759199754494659 3 24.86075500335885 4 24.935039079787135 5 24.978784393846436
		 6 24.98871462879011 7 24.961270066704575 8 24.896044722508513 9 24.79653455990973
		 10 24.665088279512194 11 24.503985901402743 12 24.314992685763247 13 24.105641962186542
		 14 23.880111721048014 15 23.637127232773132 16 23.376024660681168 17 23.095524730575441
		 18 22.79436361040694 19 22.471357691368709 20 22.125002481852125 21 21.754106717349568
		 22 21.35788422963763 23 20.936083822121606 24 20.488699411377201 25 20.016269003844908
		 26 19.53362165639604 27 19.058392809628476 28 18.595027644350377 29 18.147112595714127
		 30 17.717567977969594 31 17.310046660151166 32 16.913576442492644 33 16.516520913722541
		 34 16.125336375241471 35 15.744087920245827 36 15.377475478205213 37 15.030093323067804
		 38 14.70631913219939 39 14.410225203024986 40 14.146411408283241 41 13.962164623828567
		 42 13.901649957820611 43 13.949091556148685 44 14.08666302021838 45 14.300996741343987
		 46 14.577415740072924 47 14.898079411175473 48 15.247368190742886 49 15.611231247877029
		 50 15.978291691319042 51 16.339170531541928 52 16.68707050456851 53 17.016877799918692
		 54 17.325192873323218 55 17.610378376298875 56 17.871684444013844 57 18.109057535728464
		 58 18.331289188771283 59 18.549847371602702 60 18.768027117967261 61 18.989114905414262
		 62 19.213497179552792 63 19.440511287479804 64 19.671116062315033 65 19.908984128611671
		 66 20.156620853504833 67 20.414192118610824 68 20.688365033477343 69 20.98158589223619
		 70 21.291998376377485 71 21.618265795191178 72 21.955345601661534 73 22.298424527879302
		 74 22.64290078386658 75 22.984082018089847 76 23.317613279463107 77 23.63906993615366
		 78 23.943936249066539 79 24.227872803023697 80 24.486126697653372;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "EB7C4DD0-4CAA-242A-3EB2-36A7FCE9CB3A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.707429674243322 1 52.626581525259901
		 2 52.566403992873994 3 52.52929446304784 4 52.517517034051693 5 52.533490629342424
		 6 52.57967052257105 7 52.658502726578959 8 52.771201661101891 9 52.917340214928387
		 10 53.096966883039542 11 53.310159065914888 12 53.556893224180378 13 53.838062237777073
		 14 54.154069096590653 15 54.503085813781077 16 54.88197875856865 17 55.288263258037034
		 18 55.719479004981054 19 56.173040923526045 20 56.64654083589717 21 57.137458535218137
		 22 57.642771154608624 23 58.15934414104732 24 58.684061781402669 25 59.213701899390138
		 26 59.736202094014402 27 60.240399084940819 28 60.724216029136635 29 61.18603457008652
		 30 61.624052446924814 31 62.03687040739571 32 62.422771672620165 33 62.780683792409938
		 34 63.108664165341658 35 63.405739971097816 36 63.670827527702819 37 63.902967349422454
		 38 64.101250593235619 39 64.264794908231835 40 64.392657175763773 41 64.467081711821777
		 42 64.473107780882771 43 64.417378837337793 44 64.306092960495391 45 64.141761106696421
		 46 63.927417984626558 47 63.668572695540718 48 63.370790055295274 49 63.039256218649328
		 50 62.679348728538798 51 62.29621199254067 52 61.895005703570881 53 61.480830513346262
		 54 61.058761291712557 55 60.633881077701673 56 60.211159946271209 57 59.796004925652603
		 58 59.386547671080443 59 58.978207197483165 60 58.572148465667595 61 58.169478459798164
		 62 57.771381478584857 63 57.379244541448081 64 56.994383303083282 65 56.61583864706504
		 66 56.243171542941525 67 55.87844590191127 68 55.523339592339234 69 55.179798406415912
		 70 54.849605551336715 71 54.534714871867585 72 54.236952678843345 73 53.958320112861536
		 74 53.700763334174702 75 53.466172656531256 76 53.256587427855472 77 53.073911178446956
		 78 52.920154984489855 79 52.797314550314205 80 52.707429674243322;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "B679EC10-4ED7-47F6-E9B1-86BAA49FBB96";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 64.302501174378193 1 64.337666023608506
		 2 64.338452769161776 3 64.309257797289916 4 64.254475367931491 5 64.177907960626655
		 6 64.083271357117326 7 63.973933573614481 8 63.850394955941972 9 63.709695604343473
		 10 63.549874454394043 11 63.368987215301537 12 63.16458099591263 13 62.930260856944123
		 14 62.660529549990216 15 62.355545181118117 16 62.015370325723971 17 61.639772524513312
		 18 61.228551000799229 19 60.78164087747632 20 60.299001786945254 21 59.780859078486095
		 22 59.227540677376645 23 58.640027733011749 24 58.019734571518711 25 57.36862826376391
		 26 56.709250688382951 27 56.066555605287064 28 55.446168659823755 29 54.853138877345479
		 30 54.291915043088302 31 53.767778893931784 32 53.272618740444344 33 52.79735528653547
		 34 52.350532523772621 35 51.937847846551307 36 51.565721719690849 37 51.240393151415972
		 38 50.967694744551636 39 50.753104301353176 40 50.602469184754746 41 50.570979245062162
		 42 50.706783865722549 43 50.991548265774924 44 51.40308733272969 45 51.924240498030947
		 46 52.53588300174497 47 53.213514723618005 48 53.934956633919398 49 54.679650246566474
		 50 55.429881020503672 51 56.169978886060186 52 56.886995288287942 53 57.569837107819126
		 54 58.209255629676036 55 58.79783094837655 56 59.329276631177997 57 59.798233101105346
		 58 60.214400259416145 59 60.592477302585969 60 60.934501452497948 61 61.242867386367401
		 62 61.522277034427006 63 61.777617712961892 64 62.011051134992975 65 62.226081446414902
		 66 62.425367043058564 67 62.610797468996104 68 62.790234517775659 69 62.967658085306411
		 70 63.142914474659221 71 63.316384784586042 72 63.484875055361009 73 63.645396005395405
		 74 63.795023898307953 75 63.930826343046043 76 64.050024491873103 77 64.149773899167613
		 78 64.227072378684795 79 64.279083757804386 80 64.302501174378193;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA";
	rename -uid "CB3BE8BA-4CEC-8B82-D1F1-D08F6009529A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.57772707939147949 1 -0.50656372308731079
		 2 -0.43429204821586609 3 -0.36193576455116272 4 -0.29049581289291382 5 -0.22094199061393738
		 6 -0.15425458550453186 7 -0.09142303466796875 8 -0.032991468906402588 9 0.021178245544433594
		 10 0.070901632308959961 11 0.11587634682655334 12 0.15637859702110291 13 0.19223001599311829
		 14 0.22334098815917969 15 0.24965280294418335 16 0.2710300087928772 17 0.28745734691619873
		 18 0.29876053333282471 19 0.30492633581161499 20 0.305858314037323 21 0.30148470401763916
		 22 0.29181781411170959 23 0.27669641375541687 24 0.25615203380584717 25 0.23002138733863831
		 26 0.19835400581359863 27 0.16101011633872986 28 0.11818805336952209 29 0.070211946964263916
		 30 0.017804741859436035 31 -0.03867793083190918 32 -0.098432272672653198 33 -0.16105660796165466
		 34 -0.2258593738079071 35 -0.29235196113586426 36 -0.35991600155830383 37 -0.42794892191886902
		 38 -0.4959646463394165 39 -0.56328749656677246 40 -0.62947142124176025 41 -0.69384503364562988
		 42 -0.75619864463806152 43 -0.81658643484115601 44 -0.87508589029312134 45 -0.93124139308929443
		 46 -0.98494410514831543 47 -1.0360264778137207 48 -1.084415078163147 49 -1.1299571990966797
		 50 -1.1724858283996582 51 -1.2118678092956543 52 -1.2480130195617676 53 -1.2807369232177734
		 54 -1.3099098205566406 55 -1.3354557752609253 56 -1.3571875095367432 57 -1.3750057220458984
		 58 -1.3886748552322388 59 -1.398124098777771 60 -1.4031891822814941 61 -1.4036897420883179
		 62 -1.3995101451873779 63 -1.3904614448547363 64 -1.3763835430145264 65 -1.3571454286575317
		 66 -1.3325453996658325 67 -1.3024661540985107 68 -1.2667300701141357 69 -1.2251294851303101
		 70 -1.1790516376495361 71 -1.1299545764923096 72 -1.0780549049377441 73 -1.023429274559021
		 74 -0.96631592512130737 75 -0.90673398971557617 76 -0.84492111206054688 77 -0.78097105026245117
		 78 -0.71504926681518555 79 -0.64725810289382935 80 -0.57772707939147949;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA";
	rename -uid "68C3FFDC-48F3-28B2-4FC1-E8956314F9DA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 111.65918731689453 1 111.70033264160156
		 2 111.73912811279297 3 111.77425384521484 4 111.80467224121094 5 111.82923126220703
		 6 111.84690093994141 7 111.85651397705078 8 111.85801696777344 9 111.852294921875
		 10 111.83808135986328 11 111.81523132324219 12 111.785400390625 13 111.7484130859375
		 14 111.70437622070312 15 111.65298461914062 16 111.59423828125 17 111.5281982421875
		 18 111.45426940917969 19 111.3729248046875 20 111.28402709960937 21 111.18733215332031
		 22 111.08334350585937 23 110.97225189208984 24 110.85464477539062 25 110.73077392578125
		 26 110.60163879394531 27 110.46778106689453 28 110.33025360107422 29 110.19002532958984
		 30 110.04846954345703 31 109.90615081787109 32 109.76507568359375 33 109.62651824951172
		 34 109.49184417724609 35 109.36286926269531 36 109.24093627929687 37 109.12788391113281
		 38 109.02543640136719 39 108.93540954589844 40 108.85906982421875 41 108.79861450195312
		 42 108.75376892089844 43 108.72312927246094 44 108.70523834228516 45 108.70152282714844
		 46 108.71139526367187 47 108.73422241210937 48 108.76959991455078 49 108.81600189208984
		 50 108.87345886230469 51 108.94088745117187 52 109.01743316650391 53 109.10231018066406
		 54 109.19456481933594 55 109.29354858398437 56 109.39793395996094 57 109.50734710693359
		 58 109.62005615234375 59 109.73582458496094 60 109.85340881347656 61 109.97221374511719
		 62 110.0909423828125 63 110.20925903320312 64 110.32647705078125 65 110.44144439697266
		 66 110.55403137207031 67 110.66372680664062 68 110.76953125 69 110.87150573730469
		 70 110.96914672851563 71 111.06197357177734 72 111.14989471435547 73 111.23259735107422
		 74 111.30998229980469 75 111.38192749023437 76 111.44845581054687 77 111.50933074951172
		 78 111.56480407714844 79 111.61466217041016 80 111.65918731689453;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA";
	rename -uid "B3DD7580-4E63-6A50-8D0D-C79C4EF9719C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -35.179100036621094 1 -34.944599151611328
		 2 -34.718086242675781 3 -34.508281707763672 4 -34.32373046875 5 -34.173225402832031
		 6 -34.065460205078125 7 -34.009178161621094 8 -34.007083892822266 9 -34.054298400878906
		 10 -34.148872375488281 11 -34.288177490234375 12 -34.468898773193359 13 -34.688335418701172
		 14 -34.943695068359375 15 -35.232414245605469 16 -35.551647186279297 17 -35.898555755615234
		 18 -36.270702362060547 19 -36.665096282958984 20 -37.079452514648438 21 -37.511489868164063
		 22 -37.958042144775391 23 -38.415988922119141 24 -38.882213592529297 25 -39.353691101074219
		 26 -39.827224731445313 27 -40.299884796142578 28 -40.768577575683594 29 -41.230365753173828
		 30 -41.682197570800781 31 -42.121379852294922 32 -42.544891357421875 33 -42.949855804443359
		 34 -43.333538055419922 35 -43.693115234375 36 -44.025924682617188 37 -44.329238891601563
		 38 -44.600296020507813 39 -44.836372375488281 40 -45.034934997558594 41 -45.19305419921875
		 42 -45.311206817626953 43 -45.392677307128906 44 -45.439239501953125 45 -45.451465606689453
		 46 -45.430717468261719 47 -45.378303527832031 48 -45.295387268066406 49 -45.183406829833984
		 50 -45.043380737304687 51 -44.876674652099609 52 -44.684463500976562 53 -44.467952728271484
		 54 -44.228404998779297 55 -43.966915130615234 56 -43.684841156005859 57 -43.383533477783203
		 58 -43.064872741699219 59 -42.730281829833984 60 -42.381515502929688 61 -42.019863128662109
		 62 -41.647026062011719 63 -41.264701843261719 64 -40.874774932861328 65 -40.479209899902344
		 66 -40.079795837402344 67 -39.678413391113281 68 -39.277183532714844 69 -38.877853393554688
		 70 -38.482368469238281 71 -38.092926025390625 72 -37.711246490478516 73 -37.33941650390625
		 74 -36.979442596435547 75 -36.633251190185547 76 -36.302833557128906 77 -35.990283966064453
		 78 -35.697425842285156 79 -35.426425933837891 80 -35.179100036621094;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX";
	rename -uid "366991DA-40BC-397F-C768-60984BE6E521";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -3.2986230880193443 1 -3.2986741937443362
		 2 -3.2986334300881479 3 -3.2986251856938611 4 -3.2986818590054425 5 -3.2986680060055873
		 6 -3.2987052993679624 7 -3.2986046978675385 8 -3.2986544149104251 9 -3.2986618326996067
		 10 -3.298683395670869 11 -3.2986114104383035 12 -3.2986332966935072 13 -3.2986417577991798
		 14 -3.2987073459906515 15 -3.2986314040684377 16 -3.298641675267894 17 -3.2986842853703475
		 18 -3.2985812396235112 19 -3.29860839589348 20 -3.2986104914789807 21 -3.2986180039081145
		 22 -3.2986276475641829 23 -3.2985978144514059 24 -3.2986323659125785 25 -3.2986319090758354
		 26 -3.2986410380240745 27 -3.2986175718816679 28 -3.2986110144121623 29 -3.2986151123558285
		 30 -3.2986713728675889 31 -3.2986111330678698 32 -3.2986018773688408 33 -3.2986408765707615
		 34 -3.2986175121464818 35 -3.2986374424047655 36 -3.2986227881316958 37 -3.2986151361547438
		 38 -3.2986049918755502 39 -3.2986104362665913 40 -3.2986147620592234 41 -3.2986590214305691
		 42 -3.2986346981290198 43 -3.2986264138078676 44 -3.2986047638993523 45 -3.2986404008657293
		 46 -3.2986214155038338 47 -3.2986150690606757 48 -3.2986734258334209 49 -3.2986044097288678
		 50 -3.2986143973827824 51 -3.2986219218221984 52 -3.2986046824725204 53 -3.298617859365907
		 54 -3.2986511940343068 55 -3.2986062307934771 56 -3.2985930920020494 57 -3.2986823929797109
		 58 -3.2986048439199429 59 -3.2986282260765374 60 -3.2986414723686428 61 -3.2986530895327659
		 62 -3.2986217120381007 63 -3.2986401609070413 64 -3.298703691798972 65 -3.2986080283255421
		 66 -3.2986015906110442 67 -3.2986732831266536 68 -3.2986285781952778 69 -3.2986118722226765
		 70 -3.2986753034824678 71 -3.2986153436403711 72 -3.2986283746815688 73 -3.2986148379826052
		 74 -3.2986113406377582 75 -3.2986118634895156 76 -3.2986489943061539 77 -3.2986148257143104
		 78 -3.2986141767247998 79 -3.2986179536531619 80 -3.2986230880193443;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY";
	rename -uid "C9DF7A87-4C66-EC37-79D8-C792F3AE7974";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.94580894197846233 1 0.94587684345242229
		 2 0.94585280273778349 3 0.94582883532154516 4 0.94590929163464432 5 0.94582345138396184
		 6 0.94579237532600358 7 0.94580607573935493 8 0.94588662903736154 9 0.94584624258954986
		 10 0.94588663563805886 11 0.9458510209614952 12 0.94582697180338648 13 0.94585933397858235
		 14 0.94587472158784858 15 0.9458425741488079 16 0.94586989944516753 17 0.94580843638478951
		 18 0.94577812002076311 19 0.94579433321604178 20 0.94579755830269585 21 0.94585144287039269
		 22 0.9458310670905713 23 0.94580349766453253 24 0.94579591363644799 25 0.94586180957616428
		 26 0.94582699345603816 27 0.94584450003430764 28 0.94578316239123539 29 0.94583941311554387
		 30 0.94579053141704073 31 0.94583192910489045 32 0.94578931675436129 33 0.94587350533154391
		 34 0.94581826086904175 35 0.94583942068886129 36 0.94584234489592012 37 0.94578670589576652
		 38 0.94578632997870837 39 0.9457642783657173 40 0.94580792197559194 41 0.94582774178472762
		 42 0.94581873333921873 43 0.9458378674116007 44 0.94581716381193259 45 0.94584580671566088
		 46 0.94582657818506155 47 0.94576075617869959 48 0.94580181713142075 49 0.94581139244671752
		 50 0.9458086527961922 51 0.94584239918717772 52 0.94584480765937673 53 0.9458549794675708
		 54 0.94583824232869984 55 0.94578886013195018 56 0.94578785584723635 57 0.94583411232038039
		 58 0.94579122657254444 59 0.9458278574172575 60 0.94585411096243299 61 0.9458127160452402
		 62 0.94582297610171817 63 0.94585002712032096 64 0.94585130452120803 65 0.94580493156320511
		 66 0.94578750813834234 67 0.94582682990333633 68 0.94585113151017675 69 0.94579330725476263
		 70 0.94588074976827752 71 0.94581285135575199 72 0.94582285462565419 73 0.94580001946298076
		 74 0.94585476586691764 75 0.94581048430598491 76 0.94587790427592922 77 0.94582402460634507
		 78 0.94582092086567804 79 0.94582211617839385 80 0.94580894197846233;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ";
	rename -uid "48E4F08C-4E51-B77F-BDB0-378D6833292D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 0.31909097498970923 1 0.31912450516177748
		 2 0.31906911407643335 3 0.31882731283896082 4 0.31900224006707995 5 0.31946776147397338
		 6 0.32034129447323112 7 0.31886746338830346 8 0.31904925325922123 9 0.31942279252187877
		 10 0.31917363117534353 11 0.31883361518734105 12 0.31906474311297611 13 0.31887923468712459
		 14 0.31964363473132545 15 0.31889348977609777 16 0.31894393709428015 17 0.3200113053833965
		 18 0.31879329666923362 19 0.3188148213345583 20 0.31899064440191849 21 0.31884551492184954
		 22 0.31896560759334758 23 0.31884367110030448 24 0.31922796193017061 25 0.318845104148199
		 26 0.31905622208198414 27 0.31890208372400641 28 0.31885090885778711 29 0.31883905046789635
		 30 0.31986841110228287 31 0.31887686553721739 32 0.31876546255590427 33 0.31901385112845798
		 34 0.31893700919172946 35 0.31937525076774981 36 0.31911906709500221 37 0.31884740455599048
		 38 0.31883555504893363 39 0.31901892607023152 40 0.31887414433368261 41 0.31973421374712696
		 42 0.31930755669561695 43 0.31908157681094956 44 0.31883808868128843 45 0.31947416479238305
		 46 0.31887182513983026 47 0.31884303766117034 48 0.3200782021263826 49 0.31882453792104476
		 50 0.31890315304083511 51 0.31882528078933353 52 0.31884926377484002 53 0.3189052238418742
		 54 0.31944699612101018 55 0.3190455518274406 56 0.31864941446180972 57 0.32019166022445167
		 58 0.31883030229098913 59 0.3188563744967729 60 0.31893067622407101 61 0.319628789805255
		 62 0.31886170426890298 63 0.31914267492575588 64 0.32001669445285719 65 0.31883327075775614
		 66 0.31881508945513948 67 0.31970001140783255 68 0.31883347522214994 69 0.31878404012912659
		 70 0.31932591380073905 71 0.31880567082593153 72 0.31885821181086865 73 0.31884018092323213
		 74 0.31884377732614066 75 0.31878694787353445 76 0.31881375217953556 77 0.31884460932219022
		 78 0.31891475975668104 79 0.31883435855944553 80 0.31909097498970923;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA";
	rename -uid "971DAA6F-4D57-F01B-072F-2AB37FFDEE0E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 29.644681930541992 1 29.699460983276367
		 2 29.756002426147461 3 29.814016342163086 4 29.873193740844727 5 29.933238983154297
		 6 29.993852615356445 7 30.05473518371582 8 30.115583419799805 9 30.176097869873047
		 10 30.235855102539063 11 30.294441223144531 12 30.35179328918457 13 30.407609939575195
		 14 30.461593627929688 15 30.513446807861328 16 30.562868118286133 17 30.609561920166016
		 18 30.653226852416992 19 30.693565368652344 20 30.730281829833984 21 30.763071060180664
		 22 30.791641235351563 23 30.815690994262695 24 30.834918975830078 25 30.849031448364258
		 26 30.857723236083984 27 30.860702514648438 28 30.857761383056641 29 30.849117279052734
		 30 30.835063934326172 31 30.815900802612305 32 30.791933059692383 33 30.763462066650391
		 34 30.730785369873047 35 30.694206237792969 36 30.654026031494141 37 30.61054801940918
		 38 30.564064025878906 39 30.514886856079102 40 30.463310241699219 41 30.409639358520508
		 42 30.354171752929687 43 30.297084808349609 44 30.238563537597656 45 30.179155349731445
		 46 30.119163513183594 47 30.058893203735352 48 29.998645782470703 49 29.938722610473633
		 50 29.879430770874023 51 29.821063995361328 52 29.763935089111328 53 29.708337783813477
		 54 29.654579162597656 55 29.602954864501953 56 29.553773880004883 57 29.507329940795898
		 58 29.463932037353516 59 29.423877716064453 60 29.387466430664063 61 29.355005264282227
		 62 29.326791763305664 63 29.303127288818359 64 29.28431510925293 65 29.270654678344727
		 66 29.262451171875 67 29.260002136230469 68 29.263612747192383 69 29.273584365844727
		 70 29.288728713989258 71 29.307647705078125 72 29.330320358276367 73 29.356729507446289
		 74 29.386857986450195 75 29.420684814453125 76 29.458192825317383 77 29.499364852905273
		 78 29.544181823730469 79 29.592628479003906 80 29.644681930541992;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA";
	rename -uid "F1756BF7-424B-6F63-42C8-50A1773637A6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 52.418865203857422 1 52.420875549316406
		 2 52.422954559326172 3 52.425090789794922 4 52.427272796630859 5 52.429492950439453
		 6 52.431735992431641 7 52.433994293212891 8 52.436260223388672 9 52.438510894775391
		 10 52.439830780029297 11 52.439414978027344 12 52.439010620117188 13 52.438610076904297
		 14 52.438224792480469 15 52.437847137451172 16 52.437480926513672 17 52.437141418457031
		 18 52.436813354492188 19 52.436496734619141 20 52.436206817626953 21 52.435932159423828
		 22 52.435680389404297 23 52.435455322265625 24 52.435249328613281 25 52.435085296630859
		 26 52.434940338134766 27 52.434837341308594 28 52.434764862060547 29 52.434734344482422
		 30 52.434741973876953 31 52.434776306152344 32 52.434852600097656 33 52.434947967529297
		 34 52.435081481933594 35 52.435237884521484 36 52.4354248046875 37 52.435642242431641
		 38 52.435878753662109 39 52.436138153076172 40 52.436420440673828 41 52.436725616455078
		 42 52.437049865722656 43 52.436473846435547 44 52.434108734130859 45 52.431735992431641
		 46 52.429374694824219 47 52.427028656005859 48 52.424724578857422 49 52.422458648681641
		 50 52.420249938964844 51 52.418109893798828 52 52.416049957275391 53 52.414081573486328
		 54 52.412208557128906 55 52.410446166992188 56 52.408805847167969 57 52.407291412353516
		 58 52.405918121337891 59 52.404689788818359 60 52.403621673583984 61 52.402732849121094
		 62 52.402042388916016 63 52.401546478271484 64 52.401256561279297 65 52.401165008544922
		 66 52.401271820068359 67 52.401588439941406 68 52.402111053466797 69 52.402843475341797
		 70 52.403743743896484 71 52.404773712158203 72 52.405925750732422 73 52.407192230224609
		 74 52.408565521240234 75 52.410049438476562 76 52.411628723144531 77 52.413307189941406
		 78 52.415073394775391 79 52.41693115234375 80 52.418865203857422;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA";
	rename -uid "07A679D7-47D4-C776-B315-87B612C82B89";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145322799682617 1 -17.138179779052734
		 2 -17.130996704101562 3 -17.123811721801758 4 -17.116668701171875 5 -17.10960578918457
		 6 -17.102668762207031 7 -17.095893859863281 8 -17.089328765869141 9 -17.083011627197266
		 10 -17.077377319335937 11 -17.072807312011719 12 -17.068592071533203 13 -17.064767837524414
		 14 -17.061365127563477 15 -17.058425903320312 16 -17.055984497070313 17 -17.054075241088867
		 18 -17.052738189697266 19 -17.052007675170898 20 -17.051916122436523 21 -17.052566528320313
		 22 -17.053993225097656 23 -17.056144714355469 24 -17.058986663818359 25 -17.062469482421875
		 26 -17.066549301147461 27 -17.071184158325195 28 -17.076330184936523 29 -17.081939697265625
		 30 -17.087982177734375 31 -17.094411849975586 32 -17.101188659667969 33 -17.108268737792969
		 34 -17.115621566772461 35 -17.123195648193359 36 -17.130958557128906 37 -17.138860702514648
		 38 -17.146867752075195 39 -17.154941558837891 40 -17.16303825378418 41 -17.171117782592773
		 42 -17.179136276245117 43 -17.187450408935547 44 -17.196399688720703 45 -17.205175399780273
		 46 -17.213733673095703 47 -17.222030639648437 48 -17.230014801025391 49 -17.237644195556641
		 50 -17.244871139526367 51 -17.251651763916016 52 -17.257938385009766 53 -17.263689041137695
		 54 -17.268856048583984 55 -17.273393630981445 56 -17.277261734008789 57 -17.28040885925293
		 58 -17.282794952392578 59 -17.284372329711914 60 -17.285100936889648 61 -17.284687042236328
		 62 -17.28294563293457 63 -17.27998161315918 64 -17.275896072387695 65 -17.270797729492188
		 66 -17.264789581298828 67 -17.257976531982422 68 -17.250461578369141 69 -17.242351531982422
		 70 -17.233758926391602 71 -17.224802017211914 72 -17.215585708618164 73 -17.206220626831055
		 74 -17.196809768676758 75 -17.187459945678711 76 -17.178276062011719 77 -17.169363021850586
		 78 -17.160829544067383 79 -17.152780532836914 80 -17.145322799682617;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX";
	rename -uid "1A5AD468-4441-8A38-E6CC-6D8F1CFD7B10";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -2.0615326151095319 1 -2.0859808570957981
		 2 -2.1111960359146411 3 -2.1370703249737306 4 -2.1634526292090661 5 -2.1902151997198072
		 6 -2.2172256015302994 7 -2.2443398764966096 8 -2.2714374093515617 9 -2.2983750210564531
		 10 -2.3252124269227448 11 -2.3520177094929635 12 -2.3782883649027395 13 -2.4038846941543661
		 14 -2.4286831544759782 15 -2.4525512645829286 16 -2.4753298473384406 17 -2.4969044730352863
		 18 -2.5171253395746835 19 -2.5358809133104163 20 -2.553029323471272 21 -2.5684190851796247
		 22 -2.5819526978618725 23 -2.5934362586579844 24 -2.6027841993243688 25 -2.6098186963847803
		 26 -2.6144055849253713 27 -2.6163646747480058 28 -2.6156446459619027 29 -2.612321898981389
		 30 -2.6065166916777023 31 -2.5983419974171929 32 -2.587981108535947 33 -2.5755475920288209
		 34 -2.5611569645103764 35 -2.544977245020879 36 -2.5271282498191585 37 -2.5077270302771235
		 38 -2.4869283917584508 39 -2.4648709869456518 40 -2.4416774258660352 41 -2.4174781277557913
		 42 -2.3924333312235957 43 -2.3668687454354367 44 -2.34110996334344 45 -2.3148788399087086
		 46 -2.2883014133022344 47 -2.2615561107700337 48 -2.2347105164138346 49 -2.2079377868516397
		 50 -2.1813882153126665 51 -2.1551897088559713 52 -2.129451233705582 53 -2.1043734990487932
		 54 -2.0800414700026368 55 -2.0566165381683019 56 -2.0342518839885564 57 -2.0130524184593486
		 58 -1.9931834722067348 59 -1.9747626297674687 60 -1.957953821837078 61 -1.9428466940710383
		 62 -1.929570945913788 63 -1.9182885498670748 64 -1.9091147442339911 65 -1.9022597218875046
		 66 -1.897817311028783 67 -1.8959714454626173 68 -1.8968565410797069 69 -1.9006379614341993
		 70 -1.9067320365255125 71 -1.9145523627744363 72 -1.9240510911194084 73 -1.9352792014723954
		 74 -1.9481877518066113 75 -1.9628188201296257 76 -1.979154769096497 77 -1.9971911678458019
		 78 -2.0169388513608348 79 -2.0383823725175625 80 -2.0615326151095319;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY";
	rename -uid "65153FA7-4A09-C580-5A50-DEAB5D087929";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -0.27306317554363835 1 -0.21205731174925155
		 2 -0.14900365592783718 3 -0.084288960598431606 4 -0.018057320874840167 5 0.049252785759869293
		 6 0.11732131494938963 7 0.18583452550148247 8 0.2544561675717214 9 0.32278831521604007
		 10 0.38939761452455668 11 0.45269997426484926 12 0.51483449891843247 13 0.57535543455997185
		 14 0.63403593215180387 15 0.69050326438462095 16 0.74440034104183372 17 0.79537839731223337
		 18 0.84317777460302135 19 0.88737557473743189 20 0.92769037718260883 21 0.96372248667230354
		 22 0.99521774846369027 23 1.0217652250648384 24 1.0430522717048081 25 1.0587603412795641
		 26 1.0684791096944533 27 1.0719668752887093 28 1.0689337453765311 29 1.0596822478348635
		 30 1.0444074785057493 31 1.0235911723192399 32 0.9975197723050524 33 0.96651134672474581
		 34 0.93087513456956006 35 0.89103237443427608 36 0.84730941199818965 37 0.80001288586015318
		 38 0.74952277233412712 39 0.69615322906234678 40 0.64023128340739288 41 0.58213522936810957
		 42 0.52221271818070247 43 0.45944707748956165 44 0.39310546310170458 45 0.3258741090974755
		 46 0.25811593060085303 47 0.19024212512278854 48 0.12245614161696643 49 0.055150727335957973
		 50 -0.011289212190281436 51 -0.076552893358536725 52 -0.14034895875974621 53 -0.2022843127466698
		 54 -0.26203596983715494 55 -0.3193589986693558 56 -0.37391588033225853 57 -0.42527161694418575
		 58 -0.47327545547648536 59 -0.51753750936773235 60 -0.55763058632843221 61 -0.59343730069550982
		 62 -0.62449776242908273 63 -0.65053703372214833 64 -0.67122641758561852 65 -0.68622324482498775
		 66 -0.69531746557604102 67 -0.69797536498703727 68 -0.69401226967870966 69 -0.68308578772692996
		 70 -0.66647888261226207 71 -0.64568010159687395 72 -0.62076564247948562 73 -0.59168378830747248
		 74 -0.55845908884398765 75 -0.52115076060639842 76 -0.47974971221900725 77 -0.43423516651206684
		 78 -0.38454904992458072 79 -0.3308507229218543 80 -0.27306317554363835;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "6D3A72A9-4FF4-B0A0-BEBC-C3929E1B4C84";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 6.6493499128949276 1 6.6673716694318657
		 2 6.6861678902905473 3 6.7053385712537912 4 6.7255205608522495 5 6.7461793199784559
		 6 6.7672328862517972 7 6.788668937751221 8 6.8103799572356882 9 6.8321529357349995
		 10 6.8491400361200174 11 6.8565748167007374 12 6.8641351934784467 13 6.8714069010390606
		 14 6.8787892776451551 15 6.8857502868247114 16 6.89243115696876 17 6.8986331280521638
		 18 6.9045312398418268 19 6.9096075652979128 20 6.914068340673662 21 6.917554988988825
		 22 6.9201556764032839 23 6.9217062404757002 24 6.9223038898679237 25 6.9218193243227537
		 26 6.9200375363565616 27 6.9173440033900189 28 6.9133971012800748 29 6.9084467738394642
		 30 6.9023322818446369 31 6.8954544377377953 32 6.8878061654439087 33 6.8793480242318772
		 34 6.8702753995631403 35 6.8606870179083499 36 6.85071889750109 37 6.8404100640449572
		 38 6.829993011449071 39 6.8195436241802652 40 6.8089259721104138 41 6.7985980745419541
		 42 6.7884832893069476 43 6.7734451004618652 44 6.7490337764615269 45 6.7248857239879571
		 46 6.7011401681413263 47 6.6781467206010348 48 6.6557930123633229 49 6.6342008164249435
		 50 6.6135452803903547 51 6.5940469269218438 52 6.5755325535172302 53 6.5582504775839379
		 54 6.542428098938653 55 6.5277838188166539 56 6.5145141847197534 57 6.502834194455593
		 58 6.4923599954217819 59 6.4835344711376317 60 6.4764892836913468 61 6.4709791098670539
		 62 6.4676537047215579 63 6.4662164096555399 64 6.4667214870984768 65 6.4689033878031941
		 66 6.4726464099495287 67 6.47840555497236 68 6.485684717037711 69 6.4944137504293193
		 70 6.5043560773786702 71 6.5155657325942773 72 6.5275392151146816 73 6.5403538689469354
		 74 6.5540980613359112 75 6.5683874860337026 76 6.5833609207334796 77 6.598926200928668
		 78 6.6154171876641099 79 6.6321020637018941 80 6.6493499128949276;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA";
	rename -uid "2BE3C223-43CA-4FE2-2600-C09A1C497A4F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.509130477905273 1 -17.454347610473633
		 2 -17.397809982299805 3 -17.33979606628418 4 -17.280618667602539 5 -17.220569610595703
		 6 -17.15995979309082 7 -17.099077224731445 8 -17.038228988647461 9 -16.977710723876953
		 10 -16.917957305908203 11 -16.859363555908203 12 -16.80201530456543 13 -16.74620246887207
		 14 -16.692211151123047 15 -16.640365600585938 16 -16.590944290161133 17 -16.544242858886719
		 18 -16.500581741333008 19 -16.460243225097656 20 -16.423530578613281 21 -16.390741348266602
		 22 -16.362171173095703 23 -16.338117599487305 24 -16.318885803222656 25 -16.304780960083008
		 26 -16.296085357666016 27 -16.293106079101563 28 -16.296051025390625 29 -16.304695129394531
		 30 -16.318748474121094 31 -16.337907791137695 32 -16.361875534057617 33 -16.390350341796875
		 34 -16.423019409179688 35 -16.459602355957031 36 -16.499778747558594 37 -16.543264389038086
		 38 -16.589744567871094 39 -16.638925552368164 40 -16.690498352050781 41 -16.744173049926758
		 42 -16.799633026123047 43 -16.856723785400391 44 -16.915248870849609 45 -16.97465705871582
		 46 -17.034641265869141 47 -17.094919204711914 48 -17.155166625976563 49 -17.215089797973633
		 50 -17.274377822875977 51 -17.332744598388672 52 -17.389877319335937 53 -17.445474624633789
		 54 -17.499229431152344 55 -17.550853729248047 56 -17.600034713745117 57 -17.646482467651367
		 58 -17.68988037109375 59 -17.729934692382812 60 -17.766345977783203 61 -17.798803329467773
		 62 -17.827020645141602 63 -17.850685119628906 64 -17.869497299194336 65 -17.883157730102539
		 66 -17.891361236572266 67 -17.893806457519531 68 -17.890199661254883 69 -17.880228042602539
		 70 -17.865083694458008 71 -17.846164703369141 72 -17.823492050170898 73 -17.797082901000977
		 74 -17.76695442199707 75 -17.733123779296875 76 -17.695615768432617 77 -17.654443740844727
		 78 -17.609630584716797 79 -17.561180114746094 80 -17.509130477905273;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA";
	rename -uid "0F8D7367-4366-CC2C-E35B-7893FFC190F3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 36.424163818359375 1 36.426170349121094
		 2 36.428253173828125 3 36.430389404296875 4 36.432571411132812 5 36.434791564941406
		 6 36.437034606933594 7 36.439292907714844 8 36.441558837890625 9 36.443809509277344
		 10 36.44512939453125 11 36.444709777832031 12 36.444305419921875 13 36.44390869140625
		 14 36.443519592285156 15 36.443145751953125 16 36.442779541015625 17 36.442436218261719
		 18 36.442108154296875 19 36.441795349121094 20 36.441505432128906 21 36.441230773925781
		 22 36.44097900390625 23 36.440750122070313 24 36.440544128417969 25 36.440383911132812
		 26 36.440238952636719 27 36.440132141113281 28 36.4400634765625 29 36.440032958984375
		 30 36.440040588378906 31 36.440071105957031 32 36.440147399902344 33 36.44024658203125
		 34 36.440376281738281 35 36.440536499023438 36 36.440719604492188 37 36.440940856933594
		 38 36.441177368164063 39 36.441436767578125 40 36.441719055175781 41 36.442024230957031
		 42 36.442344665527344 43 36.4417724609375 44 36.439407348632813 45 36.437034606933594
		 46 36.434669494628906 47 36.432327270507812 48 36.430023193359375 49 36.427757263183594
		 50 36.425544738769531 51 36.423408508300781 52 36.421348571777344 53 36.419380187988281
		 54 36.417503356933594 55 36.415740966796875 56 36.414100646972656 57 36.412590026855469
		 58 36.411216735839844 59 36.409988403320313 60 36.408920288085937 61 36.408027648925781
		 62 36.407341003417969 63 36.406845092773438 64 36.40655517578125 65 36.406463623046875
		 66 36.406570434570312 67 36.406883239746094 68 36.40740966796875 69 36.40814208984375
		 70 36.409042358398438 71 36.410072326660156 72 36.411224365234375 73 36.412490844726563
		 74 36.413864135742187 75 36.41534423828125 76 36.416923522949219 77 36.418601989746094
		 78 36.420372009277344 79 36.422225952148438 80 36.424163818359375;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA";
	rename -uid "5B3FE16B-4228-1AC8-D0DF-13993CE7FB35";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -17.145320892333984 1 -17.138177871704102
		 2 -17.13099479675293 3 -17.123809814453125 4 -17.116666793823242 5 -17.109603881835938
		 6 -17.102666854858398 7 -17.095891952514648 8 -17.089326858520508 9 -17.083009719848633
		 10 -17.077375411987305 11 -17.072805404663086 12 -17.06859016418457 13 -17.064765930175781
		 14 -17.061363220214844 15 -17.05842399597168 16 -17.05598258972168 17 -17.054073333740234
		 18 -17.052736282348633 19 -17.052005767822266 20 -17.051914215087891 21 -17.05256462097168
		 22 -17.053991317749023 23 -17.056142807006836 24 -17.058984756469727 25 -17.062467575073242
		 26 -17.066547393798828 27 -17.071182250976562 28 -17.076328277587891 29 -17.081937789916992
		 30 -17.087980270385742 31 -17.094409942626953 32 -17.101186752319336 33 -17.108266830444336
		 34 -17.115619659423828 35 -17.123193740844727 36 -17.130956649780273 37 -17.138858795166016
		 38 -17.146865844726563 39 -17.154939651489258 40 -17.163036346435547 41 -17.171115875244141
		 42 -17.179134368896484 43 -17.187448501586914 44 -17.19639778137207 45 -17.205173492431641
		 46 -17.21373176574707 47 -17.222028732299805 48 -17.230012893676758 49 -17.237642288208008
		 50 -17.244869232177734 51 -17.251649856567383 52 -17.257936477661133 53 -17.263687133789063
		 54 -17.268854141235352 55 -17.273391723632813 56 -17.277259826660156 57 -17.280406951904297
		 58 -17.282793045043945 59 -17.284370422363281 60 -17.285099029541016 61 -17.284685134887695
		 62 -17.282943725585937 63 -17.279979705810547 64 -17.275894165039063 65 -17.270795822143555
		 66 -17.264787673950195 67 -17.257974624633789 68 -17.250459671020508 69 -17.242349624633789
		 70 -17.233757019042969 71 -17.224800109863281 72 -17.215583801269531 73 -17.206218719482422
		 74 -17.196807861328125 75 -17.187458038330078 76 -17.178274154663086 77 -17.169361114501953
		 78 -17.16082763671875 79 -17.152778625488281 80 -17.145320892333984;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX";
	rename -uid "E17C6F76-44BE-FEF9-6594-968718877EC8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 -7.8983403485937878 1 -7.9274141464752113
		 2 -7.9573439989028225 3 -7.9879462638188565 4 -8.0190625815001759 5 -8.0505953855638328
		 6 -8.0822748384931309 7 -8.1140415485486876 8 -8.1456908779549675 9 -8.1771094467334731
		 10 -8.2085579020863264 11 -8.2403782565512742 12 -8.271525484502364 13 -8.3018258924596644
		 14 -8.3311866397901611 15 -8.3593983034568247 16 -8.3864160819348079 17 -8.4120509520699152
		 18 -8.4361363993937957 19 -8.4585971140465546 20 -8.4792672881009548 21 -8.498111963035571
		 22 -8.5149286458897162 23 -8.529533026703314 24 -8.541823381421354 25 -8.5515244779953576
		 26 -8.5585457144292523 27 -8.5626342749701969 28 -8.5636214174958187 29 -8.5617196221075815
		 30 -8.5569383938060017 31 -8.5495130127801939 32 -8.5394898014654235 33 -8.5270297211615809
		 34 -8.512319933648806 35 -8.4953707699379315 36 -8.4763923617188794 37 -8.4555228150640911
		 38 -8.4328622185136251 39 -8.4085528052931995 40 -8.3827405100581593 41 -8.3555548706489802
		 42 -8.3271676232326648 43 -8.2981648377885762 44 -8.269134328569173 45 -8.239352147514392
		 46 -8.2089171133766499 47 -8.1780042386131946 48 -8.1467364178397155 49 -8.1153120980074611
		 50 -8.0838658817815379 51 -8.0525961467700959 52 -8.0216199008163951 53 -7.9911578691020422
		 54 -7.9614242277170257 55 -7.9325176207067258 56 -7.9046799684209743 57 -7.8780320218407542
		 58 -7.8527900715476697 59 -7.8291986918689851 60 -7.8073456730823088 61 -7.7873316718771344
		 62 -7.7693204215031164 63 -7.7535331997349815 64 -7.7401757676303813 65 -7.7295823141615472
		 66 -7.7219194776161384 67 -7.7174401550579868 68 -7.7163563214534898 69 -7.7188524452674487
		 70 -7.7243150932196976 71 -7.7319116993946633 72 -7.741607253605256 73 -7.7534580862600393
		 74 -7.7674963235179284 75 -7.7837480327449038 76 -7.8022080632217365 77 -7.8228366064965096
		 78 -7.8457260814298833 79 -7.8709154829042109 80 -7.8983403485937878;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY";
	rename -uid "F681CFFE-4662-09CA-3688-CBAE931A30FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 19.354953368372353 1 19.445492335574482
		 2 19.538919336370036 3 19.634710391144477 4 19.732358561178295 5 19.831326293943722
		 6 19.931201122549862 7 20.031412319138798 8 20.131472214602024 9 20.230923786796335
		 10 20.329382632686535 11 20.426524953499598 12 20.521473791515515 13 20.613836010492719
		 14 20.70316060494353 15 20.788833376976186 16 20.870480710383994 17 20.94759096010845
		 18 21.019619493946081 19 21.086117009991419 20 21.14661695365448 21 21.200548007630221
		 22 21.247544435188228 23 21.287050551951022 24 21.318580094344195 25 21.341647698484486
		 26 21.355780206121693 27 21.3605257567027 28 21.355509059155711 29 21.341058693812318
		 30 21.317720576997075 31 21.285984192758491 32 21.246291129432095 33 21.199189077159662
		 34 21.145128343871576 35 21.08463342511245 36 21.018204479302081 37 20.946269215037113
		 38 20.869354024281268 39 20.788005131935343 40 20.702639559218227 41 20.613778365069589
		 42 20.521915386648956 43 20.427671469896964 44 20.331656585451359 45 20.234117469242552
		 46 20.13556343705504 47 20.036487701827678 48 19.937355360873379 49 19.838739352543794
		 50 19.741044687817435 51 19.644849824030629 52 19.550596297290202 53 19.458855723860438
		 54 19.370045346435329 55 19.284715573592376 56 19.203406785766372 57 19.126550551111333
		 58 19.054708855301065 59 18.988399424670369 60 18.928065674729361 61 18.874300458107633
		 62 18.827546582050662 63 18.788296869250733 64 18.757130445106057 65 18.734498846437514
		 66 18.720917390409717 67 18.716889214395131 68 18.722940931515115 69 18.739524487688747
		 70 18.764729276537317 71 18.796184821862859 72 18.833876166964139 73 18.877737329484312
		 74 18.927739302563936 75 18.983904501347535 76 19.046101130420475 77 19.114343845730669
		 78 19.188623091707655 79 19.26881129416277 80 19.354953368372353;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "D3AE6A56-4D8E-47DC-532F-AC82B8935B80";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 81 ".ktv[0:80]"  0 7.4464862061454662 1 7.4585519145120767
		 2 7.4707254326160859 3 7.4828701808549205 4 7.4949789584945021 5 7.5068560049563615
		 6 7.5186292832644952 7 7.5300180019802916 8 7.5410646001610733 9 7.551657441751094
		 10 7.5607402510023869 11 7.5671022979815001 12 7.5727902987491795 13 7.5778075425292837
		 14 7.5820965611890303 15 7.5855679768563276 16 7.5880685414416558 17 7.589709428775584
		 18 7.5903111365489115 19 7.5898338957495968 20 7.5882347712104057 21 7.585142575085257
		 22 7.580678448414182 23 7.57504095770501 24 7.5680595917456364 25 7.5600174258876445
		 26 7.5508856884258924 27 7.5409295908916176 28 7.5302418354472502 29 7.5187019620725968
		 30 7.5066321650218875 31 7.4939408699747672 32 7.4807562282541831 33 7.4671910772303027
		 34 7.4532333791779699 35 7.4391059996889455 36 7.4248337806359634 37 7.410399731628857
		 38 7.3959828714966775 39 7.381626815900705 40 7.367375680710067 41 7.3533358170441323
		 42 7.339585157397611 43 7.3250528039062424 44 7.3087836484108637 45 7.2929913910753639
		 46 7.2777162122839982 47 7.2631458011372025 48 7.2493275329918943 49 7.2362905399556983
		 50 7.2241701502956053 51 7.2129817709651709 52 7.202875506161547 53 7.1938777682730484
		 54 7.1859380894875908 55 7.1793210201376869 56 7.1739747187949678 57 7.1701169599502244
		 58 7.1676569092474045 59 7.1666923309629693 60 7.1673130037620538 61 7.1702571892214513
		 62 7.1755530838481478 63 7.1831913119268958 64 7.1929625535137873 65 7.2044367440650809
		 66 7.2175472142466601 67 7.231950880288645 68 7.2474623338109279 69 7.2639157478156129
		 70 7.2810555852892547 71 7.2986280655558708 72 7.3166409599966755 73 7.3347457685797872
		 74 7.3527299515688052 75 7.3703729208359272 76 7.3874663869853929 77 7.403900478882691
		 78 7.4193847797920061 79 7.4335510303512518 80 7.4464862061454662;
	setAttr ".roti" 5;
createNode pairBlend -n "pairBlend1";
	rename -uid "77999D75-469A-59B3-AA4E-7C9B7C653F52";
createNode pairBlend -n "pairBlend2";
	rename -uid "EBD746ED-4EDD-87BF-1A8E-4880E7CA2DF7";
createNode pairBlend -n "pairBlend3";
	rename -uid "F4618FCB-4E87-D0F0-0ED9-C29E5B961543";
createNode pairBlend -n "pairBlend4";
	rename -uid "0E1FDCB9-4F74-98CB-063E-EE89559AE349";
createNode pairBlend -n "pairBlend5";
	rename -uid "D97B9EA3-4FF0-1B10-ED97-C79F8AC9AE85";
createNode pairBlend -n "pairBlend6";
	rename -uid "424E560A-487C-4C3F-0088-699AE03BF61B";
createNode pairBlend -n "pairBlend7";
	rename -uid "0EAF9BE4-4441-51ED-23A4-9597FAE1F9A9";
createNode pairBlend -n "pairBlend8";
	rename -uid "DA526ECC-4904-6EEB-2802-129C8444BCC2";
createNode pairBlend -n "pairBlend9";
	rename -uid "F2B7B370-4D6E-8D06-681F-0C9D3628B6C4";
createNode pairBlend -n "pairBlend10";
	rename -uid "CB75C9EA-42E9-AB4D-1469-B38AB1F4BD62";
createNode pairBlend -n "pairBlend11";
	rename -uid "7B0EA953-4CDC-CCF2-7C0F-199A173E090A";
createNode pairBlend -n "pairBlend12";
	rename -uid "4B33DDC4-4D66-116D-04EE-C5A655E91D25";
createNode pairBlend -n "pairBlend13";
	rename -uid "19E81782-4DCA-1AD7-2E0C-5EA303B8D3BE";
createNode pairBlend -n "pairBlend14";
	rename -uid "97E794EA-47A1-FFA8-9A83-7F921702F14F";
createNode pairBlend -n "pairBlend15";
	rename -uid "1534D61A-4395-570D-998B-629FAC9AEEC9";
createNode pairBlend -n "pairBlend16";
	rename -uid "7C02DAEF-47C2-7798-A148-F1A415B01098";
createNode pairBlend -n "pairBlend17";
	rename -uid "FDDD55C5-4BFA-81C5-FE56-AC87D8CC599E";
createNode pairBlend -n "pairBlend18";
	rename -uid "92FD9800-43AC-4566-E4A3-8D9FB7E33DE8";
createNode pairBlend -n "pairBlend19";
	rename -uid "DFCBCCC9-4467-88BE-3970-C98235F288FC";
createNode pairBlend -n "pairBlend20";
	rename -uid "B36B2BAA-4550-131D-9492-12BA2BB6827E";
createNode pairBlend -n "pairBlend21";
	rename -uid "42ABA406-42B5-C6F4-BFAE-808BF09E3A1E";
createNode pairBlend -n "pairBlend22";
	rename -uid "DDBB3C34-4437-C092-74F5-029EC15ADE84";
createNode pairBlend -n "pairBlend23";
	rename -uid "5454C0E9-4E5A-17F8-F60B-619198A06778";
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 33;
	setAttr ".unw" 33;
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
// End of overboss_idle.ma
