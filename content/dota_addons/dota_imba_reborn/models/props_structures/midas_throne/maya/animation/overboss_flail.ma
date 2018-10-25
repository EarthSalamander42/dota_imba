//Maya ASCII 2016 scene
//Name: overboss_flail.ma
//Last modified: Wed, May 27, 2015 09:55:57 AM
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
	setAttr ".t" -type "double3" -399.00020978927233 164.35758770195861 649.13130488953686 ;
	setAttr ".r" -type "double3" -8.1383527296242555 -24.999999999999797 2.1933461284872631e-016 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "D9DD50B2-4074-3E2F-107E-DF9134A13DBB";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 795.46771738896769;
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
	rename -uid "7C81D8D1-409C-986B-718E-7AB35E8DA8D3";
	addAttr -s false -ci true -sn "ch" -ln "ControlSet" -at "message";
	setAttr -k off -cb on ".v";
	setAttr -l on ".ra";
createNode locator -n "Character1_Ctrl_ReferenceShape" -p "Character1_Ctrl_Reference";
	rename -uid "23205D55-4B9B-6013-E1E4-7E81A0B2AC76";
	setAttr -k off ".v";
createNode hikIKEffector -n "Character1_Ctrl_HipsEffector" -p "Character1_Ctrl_Reference";
	rename -uid "46517E69-4F8E-9212-EA49-F89F5DE71137";
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
	rename -uid "41E57E82-44C4-D56B-2CA6-DCA90886E4FA";
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
	rename -uid "651FB264-4EEE-D228-0138-3C80D0C965CC";
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
	rename -uid "447A3AAE-4FEB-3B45-7C15-DFA19FEF4B1E";
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
	rename -uid "D61694B5-4053-4224-4527-FB9C3F814AB2";
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
	rename -uid "FAD4B659-48B8-BE23-6824-11AAF04A7E4D";
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
	rename -uid "DF8B3817-41B4-CB7C-7B5A-3EAAC654A211";
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
	rename -uid "384E5DB6-45F6-B8DD-8E89-149B0A2C9914";
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
	rename -uid "C550B4AD-4B2C-FDA4-F329-12893D42175B";
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
	rename -uid "37428639-4C2F-BC6E-FE44-2E8230873C7C";
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
	rename -uid "0CDE2E9B-4F8B-090F-89CA-FEA92C62EF48";
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
	rename -uid "1F0ECAFC-4780-7330-9785-5DBF4777D93A";
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
	rename -uid "B91F4AD3-4EE3-ECA8-B7DD-7B91F22C07B6";
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
	rename -uid "B305AB47-4301-787C-31FD-1AA77FF4DECC";
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
	rename -uid "1D5649D1-49DF-833E-410E-64B1D09F2E6B";
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
	rename -uid "F537542C-4342-98E7-ACC0-1A8B105116E0";
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
	rename -uid "BF9E5718-4A2A-314E-D9C2-A0A16FE2D708";
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
	rename -uid "1C6539AD-4E29-9D02-0CCA-B4B8235CDDA2";
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
	rename -uid "549F96DF-4F35-DC96-2856-B6B2DDC7200D";
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
	rename -uid "02A2F730-4603-A088-30E4-21BA92778E45";
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
	rename -uid "8AB855F3-42F9-FA34-60E0-0AAA0AA86295";
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
	rename -uid "BAEE2069-4C72-918A-9AFA-16BBCF0FD4E0";
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
	rename -uid "7ACEE873-4298-D7ED-B9CF-11B94DF7097A";
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
	rename -uid "D9D13012-4F3D-3BA2-8DD5-1E880C25057F";
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
	rename -uid "509549B6-4490-E815-05D2-3DBC92C308C0";
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
	rename -uid "206F70A4-487D-BD12-A6FD-74997328FF95";
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
	rename -uid "ACA49D7E-4016-7B6D-638D-38B49015FA00";
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
	rename -uid "D0060A9F-4FF6-667B-023C-828B8D0C5DC6";
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
	rename -uid "69D9524C-4C8E-1323-BFBA-2AB1CE19850D";
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
	rename -uid "1982AB0E-40CB-A8BE-0F8B-ECBF3BF7286E";
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
	rename -uid "710793E9-4E91-0D27-D854-C6A950A1EA9E";
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
	rename -uid "9BD4263D-4937-7D9E-5BF4-FB820ADB333A";
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
	rename -uid "1AD227FD-4095-5EF4-6846-E18A9A7AC23D";
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
	rename -uid "E4BC2D7F-4C01-760A-2647-18A6A38DDC9D";
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
	rename -uid "ED12F099-431D-9BD1-CCF1-B6888F721D98";
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
	rename -uid "EF4BE572-4D47-8E1B-FFB8-69A845004BF8";
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
	rename -uid "C51650DA-4364-E6F2-053A-30A73E883B15";
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
	rename -uid "AB002682-466F-E93E-BD88-B6B712598C88";
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
	rename -uid "72D32A77-4507-883D-CAE0-0D9DD41B4EED";
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
	rename -uid "539D97CC-4D52-D069-B848-7DA14B3A8B89";
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
	rename -uid "D7D6EFC2-4B66-E344-7E9F-0DA4E15CABC8";
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
	rename -uid "9394B346-466D-7399-BDE1-7CA4CC012E05";
	setAttr -s 13 ".lnk";
	setAttr -s 13 ".slnk";
createNode displayLayerManager -n "layerManager";
	rename -uid "C1DBC8E4-4865-4792-CE3C-9FB11E22A422";
createNode displayLayer -n "defaultLayer";
	rename -uid "44FDF528-4835-9DA2-EDA9-9EAB466875E0";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "2DF8729E-45D2-24FF-70F1-47B6488581D1";
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
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 26 -ast 0 -aet 200 ";
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
	setAttr ".HipsTx" 3.8409147262573242;
	setAttr ".HipsTy" 49.940830230712891;
	setAttr ".HipsTz" -19.296712875366211;
	setAttr ".HipsRx" -5.2591819587659812;
	setAttr ".HipsRy" -8.1970805644807285;
	setAttr ".HipsRz" 37.700664019715873;
	setAttr ".HipsSx" 1.0000002913114197;
	setAttr ".HipsSy" 1.0000002482037325;
	setAttr ".HipsSz" 1.0000002881151464;
	setAttr ".LeftUpLegTx" 24.896364151136176;
	setAttr ".LeftUpLegTy" -7.7306243377217996;
	setAttr ".LeftUpLegTz" 3.1970302485717639;
	setAttr ".LeftUpLegRx" -19.138826112860741;
	setAttr ".LeftUpLegRy" 3.4516163491977134;
	setAttr ".LeftUpLegRz" -30.817574693724399;
	setAttr ".LeftUpLegSx" 1.0000000509241238;
	setAttr ".LeftUpLegSy" 0.9999999901198533;
	setAttr ".LeftUpLegSz" 0.99999993591177294;
	setAttr ".LeftLegTx" 21.226190881260528;
	setAttr ".LeftLegTy" -1.948555961917009e-006;
	setAttr ".LeftLegTz" -3.6339915965299951e-007;
	setAttr ".LeftLegRx" -4.2351298040797039;
	setAttr ".LeftLegRy" 9.9745815505161666;
	setAttr ".LeftLegRz" 41.43664000753602;
	setAttr ".LeftLegSx" 1.0000001144261812;
	setAttr ".LeftLegSy" 1.0000002623050535;
	setAttr ".LeftLegSz" 1.0000001202196633;
	setAttr ".LeftFootTx" 15.941071839823191;
	setAttr ".LeftFootTy" -1.1345874959545199e-006;
	setAttr ".LeftFootTz" -1.9202440100229978e-006;
	setAttr ".LeftFootRx" 8.3891593724193338;
	setAttr ".LeftFootRy" -28.185964575479339;
	setAttr ".LeftFootRz" 10.9451992484146;
	setAttr ".LeftFootSx" 1.0000001211777334;
	setAttr ".LeftFootSy" 1.0000001384389308;
	setAttr ".LeftFootSz" 1.0000001181787275;
	setAttr ".RightUpLegTx" -24.8963110412585;
	setAttr ".RightUpLegTy" -7.7306063986825855;
	setAttr ".RightUpLegTz" 3.1970259939114101;
	setAttr ".RightUpLegRx" 42.992514114833597;
	setAttr ".RightUpLegRy" -40.388444512287066;
	setAttr ".RightUpLegRz" -26.686138720706399;
	setAttr ".RightUpLegSx" 0.99999997411220887;
	setAttr ".RightUpLegSy" 0.99999992396648507;
	setAttr ".RightUpLegSz" 0.99999987644664634;
	setAttr ".RightLegTx" -21.22618220071055;
	setAttr ".RightLegTy" 1.6378196706412496e-005;
	setAttr ".RightLegTz" -7.6884156403167481e-005;
	setAttr ".RightLegRx" 15.507068180685851;
	setAttr ".RightLegRy" -0.61447392738932438;
	setAttr ".RightLegRz" 42.58325840946641;
	setAttr ".RightLegSx" 1.0000000577274293;
	setAttr ".RightLegSy" 0.99999998819129432;
	setAttr ".RightLegSz" 1.0000000525635158;
	setAttr ".RightFootTx" -15.941102680875696;
	setAttr ".RightFootTy" 4.3502433875630686e-005;
	setAttr ".RightFootTz" 5.3568733100917143e-005;
	setAttr ".RightFootRx" -37.274176809650498;
	setAttr ".RightFootRy" -11.813604619770237;
	setAttr ".RightFootRz" 28.820000256973742;
	setAttr ".RightFootSx" 1.0000000268296756;
	setAttr ".RightFootSy" 1.000000029706934;
	setAttr ".RightFootSz" 0.99999996677294323;
	setAttr ".SpineTx" -1.7122452433682156e-007;
	setAttr ".SpineTy" 3.3825343216512707;
	setAttr ".SpineTz" -3.7835497222172378;
	setAttr ".SpineRx" -0.95407716725396763;
	setAttr ".SpineRy" -3.8618452413238198;
	setAttr ".SpineRz" -4.4656496550144196;
	setAttr ".SpineSx" 1.0000000160822828;
	setAttr ".SpineSy" 0.99999990612315937;
	setAttr ".SpineSz" 0.99999997662025053;
	setAttr ".LeftArmTx" 7.5598062155616645;
	setAttr ".LeftArmTy" -1.3346393460169637;
	setAttr ".LeftArmTz" 6.4182892394230322;
	setAttr ".LeftArmRx" 13.086543150489657;
	setAttr ".LeftArmRy" 0.80626721484068054;
	setAttr ".LeftArmRz" -25.680297712610475;
	setAttr ".LeftArmSx" 0.99999984372906403;
	setAttr ".LeftArmSy" 0.99999998044078009;
	setAttr ".LeftArmSz" 1.0000000004556626;
	setAttr ".LeftForeArmTx" 23.62784814282691;
	setAttr ".LeftForeArmTy" -0.36614245452298633;
	setAttr ".LeftForeArmTz" 0.61648083504879025;
	setAttr ".LeftForeArmRx" -15.723793288827761;
	setAttr ".LeftForeArmRy" -11.132418566156208;
	setAttr ".LeftForeArmRz" 71.257635933005886;
	setAttr ".LeftForeArmSx" 0.999999998993647;
	setAttr ".LeftForeArmSy" 1.0000001124429263;
	setAttr ".LeftForeArmSz" 1.0000000478724842;
	setAttr ".LeftHandTx" 22.329464849004182;
	setAttr ".LeftHandTy" -0.34351806837514687;
	setAttr ".LeftHandTz" 0.83666450207276455;
	setAttr ".LeftHandRx" -29.892119608718453;
	setAttr ".LeftHandRy" 28.878794982901677;
	setAttr ".LeftHandRz" -15.143379316688067;
	setAttr ".LeftHandSx" 1.0000002092525857;
	setAttr ".LeftHandSy" 1.0000003961911699;
	setAttr ".LeftHandSz" 1.00000026496996;
	setAttr ".RightArmTx" -7.5598968905853283;
	setAttr ".RightArmTy" 1.3346021549324831;
	setAttr ".RightArmTz" -6.4178997469375361;
	setAttr ".RightArmRx" -9.8999742025991715;
	setAttr ".RightArmRy" 26.595206395388864;
	setAttr ".RightArmRz" 19.453200195978283;
	setAttr ".RightArmSx" 1.0000002567956456;
	setAttr ".RightArmSy" 1.0000000461441121;
	setAttr ".RightArmSz" 1.0000000307257793;
	setAttr ".RightForeArmTx" -23.627900773843635;
	setAttr ".RightForeArmTy" 0.36613784780633551;
	setAttr ".RightForeArmTz" -0.61643174231457465;
	setAttr ".RightForeArmRx" -10.862261150387111;
	setAttr ".RightForeArmRy" -11.280131925373903;
	setAttr ".RightForeArmRz" 51.526871445209217;
	setAttr ".RightForeArmSx" 1.0000001489873145;
	setAttr ".RightForeArmSy" 1.0000000479494551;
	setAttr ".RightForeArmSz" 1.0000000459896021;
	setAttr ".RightHandTx" -22.329460407809577;
	setAttr ".RightHandTy" 0.34352678861728947;
	setAttr ".RightHandTz" -0.83667778811972937;
	setAttr ".RightHandRx" -85.284573391769385;
	setAttr ".RightHandRy" -9.3662981150078526;
	setAttr ".RightHandRz" -46.625667995124687;
	setAttr ".RightHandSx" 1.0000001716179774;
	setAttr ".RightHandSy" 1.0000000392931727;
	setAttr ".RightHandSz" 1.0000000518770724;
	setAttr ".HeadTx" 8.0099824461090918;
	setAttr ".HeadTy" 9.8597496958063857e-006;
	setAttr ".HeadTz" -1.9364385557274488e-006;
	setAttr ".HeadRx" -60.85312136226527;
	setAttr ".HeadRy" 8.2223287489692396;
	setAttr ".HeadRz" -57.602754725071833;
	setAttr ".HeadSx" 0.99999995457771962;
	setAttr ".HeadSy" 1.0000000232739761;
	setAttr ".HeadSz" 0.99999988880140234;
	setAttr ".LeftToeBaseTx" 6.8757487018353487;
	setAttr ".LeftToeBaseTy" 1.7176464606194486e-007;
	setAttr ".LeftToeBaseTz" -8.5975449337638565e-007;
	setAttr ".LeftToeBaseRx" -0.45840187966051765;
	setAttr ".LeftToeBaseRy" 31.717325653720192;
	setAttr ".LeftToeBaseRz" -22.530187342384114;
	setAttr ".LeftToeBaseSx" 1.0000002762830025;
	setAttr ".LeftToeBaseSy" 1.0000003429401758;
	setAttr ".LeftToeBaseSz" 1.0000002415497466;
	setAttr ".RightToeBaseTx" -6.8757612247676692;
	setAttr ".RightToeBaseTy" 3.7162586004058085e-006;
	setAttr ".RightToeBaseTz" 2.3852340348184953e-005;
	setAttr ".RightToeBaseRx" -2.3224409094210774;
	setAttr ".RightToeBaseRy" -3.0638455079134412;
	setAttr ".RightToeBaseRz" -62.449309299829501;
	setAttr ".RightToeBaseSx" 1.0000000562483553;
	setAttr ".RightToeBaseSy" 1.0000001483183971;
	setAttr ".RightToeBaseSz" 1.0000000529798609;
	setAttr ".LeftShoulderTx" 10.381340587404196;
	setAttr ".LeftShoulderTy" 5.2150708691167669;
	setAttr ".LeftShoulderTz" 13.982760047278674;
	setAttr ".LeftShoulderRx" -3.682493416369097;
	setAttr ".LeftShoulderRy" 3.6169420380387418;
	setAttr ".LeftShoulderRz" 5.556760727183562;
	setAttr ".LeftShoulderSx" 1.0000000814055499;
	setAttr ".LeftShoulderSy" 1.0000001468345954;
	setAttr ".LeftShoulderSz" 1.0000001612361957;
	setAttr ".RightShoulderTx" 10.381000937794539;
	setAttr ".RightShoulderTy" 5.21518268506086;
	setAttr ".RightShoulderTz" -13.982805368166176;
	setAttr ".RightShoulderRx" 1.1504135353776574;
	setAttr ".RightShoulderRy" 10.369800074340901;
	setAttr ".RightShoulderRz" -12.691450627030225;
	setAttr ".RightShoulderSx" 0.99999994084268473;
	setAttr ".RightShoulderSy" 0.99999997376575556;
	setAttr ".RightShoulderSz" 0.99999990127615324;
	setAttr ".NeckTx" 17.971363539794993;
	setAttr ".NeckTy" -1.2670011017235083e-005;
	setAttr ".NeckTz" -3.1625357412856658e-006;
	setAttr ".NeckRy" -7.4602902202243959e-005;
	setAttr ".NeckRz" 30.93538742415836;
	setAttr ".NeckSx" 0.9999999195183974;
	setAttr ".NeckSy" 0.99999996371876942;
	setAttr ".NeckSz" 0.99999989622790109;
	setAttr ".Spine1Tx" 7.1917507570938142;
	setAttr ".Spine1Ty" 1.1487426121448152e-007;
	setAttr ".Spine1Tz" -1.1977796354756265e-006;
	setAttr ".Spine1Rx" 0.62317617174554085;
	setAttr ".Spine1Ry" -7.9251402013312777;
	setAttr ".Spine1Rz" -9.0496319146195354;
	setAttr ".Spine1Sx" 0.99999999440199316;
	setAttr ".Spine1Sy" 1.0000000084219161;
	setAttr ".Spine1Sz" 1.0000001033689956;
	setAttr ".Spine2Tx" 15.480270309676555;
	setAttr ".Spine2Ty" 3.9449107092082158e-007;
	setAttr ".Spine2Tz" 5.4429868967531547e-007;
	setAttr ".Spine2Rx" 1.2598986189946606;
	setAttr ".Spine2Ry" -7.8496275245259488;
	setAttr ".Spine2Rz" -9.0928752479547565;
	setAttr ".Spine2Sx" 0.99999999533751904;
	setAttr ".Spine2Sy" 1.0000002145175433;
	setAttr ".Spine2Sz" 1.0000001521643502;
	setAttr ".Spine3Tx" 13.088922812061085;
	setAttr ".Spine3Ty" 3.0915634194883523e-006;
	setAttr ".Spine3Tz" 8.9229767397114301e-007;
	setAttr ".Spine3Rx" -2.6379336793204398;
	setAttr ".Spine3Ry" -7.5016691097809121;
	setAttr ".Spine3Rz" -8.8334914746563431;
	setAttr ".Spine3Sx" 1.0000001223423161;
	setAttr ".Spine3Sy" 1.0000001830016898;
	setAttr ".Spine3Sz" 1.0000000883073992;
createNode vstExportNode -n "kobold_overboss_anim_exportNode";
	rename -uid "18EAED41-4682-B4DC-A24A-4B900285098F";
	setAttr ".ei[0].exportFile" -type "string" "overboss_flail";
	setAttr ".ei[0].t" 6;
	setAttr ".ei[0].fe" 26;
createNode HIKControlSetNode -n "Character1_ControlRig";
	rename -uid "49E042FD-411A-D929-34D7-C9B80EED2F8D";
	setAttr ".ihi" 0;
createNode keyingGroup -n "Character1_FullBodyKG";
	rename -uid "16B46E67-4606-D9A5-269B-E983773726E6";
	setAttr ".ihi" 0;
	setAttr -s 11 ".dnsm";
	setAttr -s 41 ".act";
	setAttr ".cat" -type "string" "FullBody";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HipsBPKG";
	rename -uid "E682B15D-483F-E4A4-162B-248F3A29B22D";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 2 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_ChestBPKG";
	rename -uid "A4D03904-46A4-C479-1784-2E8495BB3964";
	setAttr ".ihi" 0;
	setAttr -s 24 ".dnsm";
	setAttr -s 6 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftArmBPKG";
	rename -uid "638E1D52-4240-5929-A752-F5B32D6B4977";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightArmBPKG";
	rename -uid "75925688-4AF5-275C-2789-ED95EECCE45E";
	setAttr ".ihi" 0;
	setAttr -s 30 ".dnsm";
	setAttr -s 7 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftLegBPKG";
	rename -uid "B62F23A7-4B02-94F6-1E04-FE9E6DAA569A";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightLegBPKG";
	rename -uid "A1935F0F-4DC5-3F80-042C-6B8FB026A59A";
	setAttr ".ihi" 0;
	setAttr -s 36 ".dnsm";
	setAttr -s 8 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_HeadBPKG";
	rename -uid "9DFD92BA-4961-A821-8CE7-C79B895BC3B3";
	setAttr ".ihi" 0;
	setAttr -s 12 ".dnsm";
	setAttr -s 3 ".act";
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftHandBPKG";
	rename -uid "B75019E0-446C-C3FE-B4BA-26AE9D9AA412";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightHandBPKG";
	rename -uid "850E2DEB-4C2F-E552-3418-35B2F39434C9";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_LeftFootBPKG";
	rename -uid "7F9D0847-41C9-B5BE-85EE-2087A27EEA24";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode keyingGroup -n "Character1_RightFootBPKG";
	rename -uid "36F219B4-4A8B-0315-A60E-8CAEB6AB2D3D";
	setAttr ".ihi" 0;
	setAttr ".cat" -type "string" "BodyPart";
	setAttr ".mr" yes;
createNode HIKFK2State -n "HIKFK2State1";
	rename -uid "214ECABA-4801-CF25-28A6-0B881A7682B0";
	setAttr ".ihi" 0;
	setAttr ".OutputCharacterState" -type "HIKCharacterState" ;
createNode HIKEffector2State -n "HIKEffector2State1";
	rename -uid "EB64D574-4882-9EFE-D47A-B8BAC24F53EA";
	setAttr ".ihi" 0;
	setAttr ".EFF" -type "HIKEffectorState" ;
	setAttr ".EFFNA" -type "HIKEffectorState" ;
createNode HIKPinning2State -n "HIKPinning2State1";
	rename -uid "5C993BE8-4AA2-8283-4B6A-D89318D7E192";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
	setAttr ".OutputEffectorStateNoAux" -type "HIKEffectorState" ;
createNode HIKState2FK -n "HIKState2FK1";
	rename -uid "2EC9C91E-4DFC-B7D7-EEDB-88AD9BC450A6";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.78313320875167847 0.60528862476348877 0.14257854223251343 0
		 -0.59862160682678223 0.79587793350219727 -0.090724766254425049 0 -0.16838973760604858 -0.014301043003797531 0.98561704158782959 0
		 3.8409147262573242 49.940830230712891 -19.296712875366211 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.90269178152084351 0.41338524222373962 -0.11941792815923691 0
		 -0.40328487753868103 0.71603888273239136 -0.56978070735931396 0 -0.15003103017807007 0.5624956488609314 0.81307417154312134 0
		 27.427455902099609 58.811962127685547 -11.894618988037109 1;
	setAttr ".LeftLegGX" -type "matrix" 0.95028936862945557 0.2643229067325592 -0.16457214951515198 0
		 -0.25046417117118835 0.96291595697402954 0.10030435770750046 0 0.18498185276985168 -0.054098717868328094 0.98125201463699341 0
		 33.077007293701172 47.34698486328125 5.0520057678222656 1;
	setAttr ".LeftFootGX" -type "matrix" 0.96275246143341064 -0.21646182239055634 -0.16202658414840698 0
		 0.18319053947925568 0.96294230222702026 -0.19794958829879761 0 0.19887071847915649 0.16089466214179993 0.96672850847244263 0
		 29.776742935180664 37.01025390625 -6.6260967254638672 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.94810038805007935 -0.31147581338882446 -0.06394544243812561 0
		 0.30804580450057983 0.94959414005279541 -0.05813194066286087 0 0.078828878700733185 0.035416770726442337 0.99625903367996216 0
		 -11.566851615905762 28.673036575317383 -18.993991851806641 1;
	setAttr ".RightLegGX" -type "matrix" 0.98209816217422485 0.11772007495164871 -0.14705713093280792 0
		 -0.006552964448928833 0.80155467987060547 0.59788602590560913 0 0.18825745582580566 -0.58621883392333984 0.78797644376754761 0
		 -15.684040069580078 9.2562999725341797 -11.471366882324219 1;
	setAttr ".RightFootGX" -type "matrix" 0.80436837673187256 -0.034691296517848969 0.59311729669570923 0
		 -0.14505627751350403 0.95661640167236328 0.25267338752746582 0 -0.57615131139755249 -0.28927785158157349 0.76443976163864136 0
		 -13.907528877258301 8.2139501571655273 -27.278842926025391 1;
	setAttr ".SpineGX" -type "matrix" 0.8207927942276001 0.54900097846984863 0.15779086947441101 0
		 -0.52796822786331177 0.83456510305404663 -0.15732534229755402 0 -0.21805846691131592 0.045822899788618088 0.97485983371734619 0
		 2.4531674385070801 52.687023162841797 -23.332723617553711 1;
	setAttr ".LeftArmGX" -type "matrix" 0.78690224885940552 -0.57702028751373291 0.21870581805706024 0
		 0.56178337335586548 0.81652647256851196 0.13298109173774719 0 -0.25531190633773804 0.018222171813249588 0.96668702363967896 0
		 10.911223411560059 95.09521484375 -26.66339111328125 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.40478917956352234 -0.046098198741674423 0.91324722766876221 0
		 0.62222766876220703 0.71795904636383057 0.31203776597976685 0 -0.67005854845046997 0.69455724954605103 -0.26193845272064209 0
		 29.512588500976563 81.455192565917969 -21.493463516235352 1;
	setAttr ".LeftHandGX" -type "matrix" 0.11179912090301514 0.11615008115768433 0.98691964149475098 0
		 0.94008731842041016 0.3095308244228363 -0.14292223751544952 0 -0.3220822811126709 0.94376909732818604 -0.074585855007171631 0
		 20.466445922851563 80.424995422363281 -1.0844211578369141 1;
	setAttr ".RightArmGX" -type "matrix" 0.91083061695098877 0.29938638210296631 0.28417497873306274 0
		 0.035754680633544922 0.62863141298294067 -0.77688103914260864 0 -0.41122889518737793 0.71776765584945679 0.56187230348587036 0
		 -29.855953216552734 85.487037658691406 -44.527442932128906 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.61104971170425415 -0.53385186195373535 -0.58448302745819092 0
		 -0.13778002560138702 0.65536683797836304 -0.74263781309127808 0 0.77950942516326904 0.53431874513626099 0.32690760493278503 0
		 -51.535999298095703 78.340476989746094 -50.667011260986328 1;
	setAttr ".RightHandGX" -type "matrix" 0.94129979610443115 0.051101110875606537 -0.33368057012557983 0
		 -0.20043870806694031 -0.71075588464736938 -0.674277663230896 0 -0.27162176370620728 0.70158016681671143 -0.65879195928573608 0
		 -65.131500244140625 90.508056640625 -37.762153625488281 1;
	setAttr ".HeadGX" -type "matrix" 0.12194295227527618 0.69999420642852783 0.70366066694259644 0
		 0.17921990156173706 0.68176925182342529 -0.70927518606185913 0 -0.97622251510620117 0.21260099112987518 -0.042315918952226639 0
		 -13.504547119140625 106.74164581298828 -35.910789489746094 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.9300616979598999 0.089464925229549408 -0.35634472966194153 0
		 0.013618260622024536 0.96083849668502808 0.27677458524703979 0 0.36715129017829895 -0.26227021217346191 0.89242058992385864 0
		 27.734441757202148 30.445869445800781 -6.5086479187011719 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.74611127376556396 0.15991237759590149 0.64633262157440186 0
		 -0.66533768177032471 0.14207723736763 0.73289823532104492 0 0.025370299816131592 -0.9768531322479248 0.21240116655826569 0
		 -11.70195198059082 2.1575107574462891 -29.672807693481445 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.84882354736328125 0.0073784585110843182 0.52862483263015747 0
		 0.21556314826011658 0.90817838907241821 -0.35881021618843079 0 -0.48273313045501709 0.41851857304573059 0.76929259300231934 0
		 1.2212047576904297 96.438583374023438 -28.76702880859375 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.79332423210144043 0.4455755352973938 0.41484805941581726 0
		 -0.13763241469860077 0.79504227638244629 -0.59073257446289063 0 -0.59303766489028931 0.41154596209526062 0.69205194711685181 0
		 -24.58856201171875 91.042427062988281 -38.084239959716797 1;
	setAttr ".NeckGX" -type "matrix" 0.9229128360748291 0.19294489920139313 0.33317276835441589 0
		 -0.20406836271286011 0.97895526885986328 -0.0016421973705291748 0 -0.32647809386253357 -0.066474407911300659 0.94286429882049561 0
		 -10.751740455627441 100.31006622314453 -39.811641693115234 1;
	setAttr ".Spine1GX" -type "matrix" 0.87951004505157471 0.43120080232620239 0.20131602883338928 0
		 -0.36920067667961121 0.88519746065139771 -0.28304827213287354 0 -0.30025508999824524 0.17461776733398438 0.93773967027664185 0
		 -1.5663309097290039 58.648303985595703 -23.165258407592773 1;
	setAttr ".Spine2GX" -type "matrix" 0.91405379772186279 0.31075891852378845 0.26064246892929077 0
		 -0.19304405152797699 0.89849293231964111 -0.39426451921463013 0 -0.3567066490650177 0.31006348133087158 0.88126111030578613 0
		 -6.8052582740783691 72.025672912597656 -28.930534362792969 1;
	setAttr ".Spine3GX" -type "matrix" 0.92291265726089478 0.19294622540473938 0.33317351341247559 0
		 -0.0072069540619850159 0.87386929988861084 -0.48610812425613403 0 -0.3849426805973053 0.44623401761054993 0.8078952431678772 0
		 -8.4700965881347656 82.887245178222656 -36.042106628417969 1;
createNode HIKState2FK -n "HIKState2FK2";
	rename -uid "95EA6DAC-457E-A3B9-E488-B3AF639770F5";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.78313320875167847 0.60528862476348877 0.14257854223251343 0
		 -0.59862160682678223 0.79587793350219727 -0.090724766254425049 0 -0.16838973760604858 -0.014301043003797531 0.98561704158782959 0
		 3.8409147262573242 49.940830230712891 -19.296712875366211 1;
	setAttr ".LeftUpLegGX" -type "matrix" 0.90269178152084351 0.41338524222373962 -0.11941792815923691 0
		 -0.40328487753868103 0.71603888273239136 -0.56978070735931396 0 -0.15003103017807007 0.5624956488609314 0.81307417154312134 0
		 27.427455902099609 58.811962127685547 -11.894618988037109 1;
	setAttr ".LeftLegGX" -type "matrix" 0.95028936862945557 0.2643229067325592 -0.16457214951515198 0
		 -0.25046417117118835 0.96291595697402954 0.10030435770750046 0 0.18498185276985168 -0.054098717868328094 0.98125201463699341 0
		 33.077007293701172 47.34698486328125 5.0520057678222656 1;
	setAttr ".LeftFootGX" -type "matrix" 0.96275246143341064 -0.21646182239055634 -0.16202658414840698 0
		 0.18319053947925568 0.96294230222702026 -0.19794958829879761 0 0.19887071847915649 0.16089466214179993 0.96672850847244263 0
		 29.776742935180664 37.01025390625 -6.6260967254638672 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.94810038805007935 -0.31147581338882446 -0.06394544243812561 0
		 0.30804580450057983 0.94959414005279541 -0.05813194066286087 0 0.078828878700733185 0.035416770726442337 0.99625903367996216 0
		 -11.566851615905762 28.673036575317383 -18.993991851806641 1;
	setAttr ".RightLegGX" -type "matrix" 0.98209816217422485 0.11772007495164871 -0.14705713093280792 0
		 -0.006552964448928833 0.80155467987060547 0.59788602590560913 0 0.18825745582580566 -0.58621883392333984 0.78797644376754761 0
		 -15.684040069580078 9.2562999725341797 -11.471366882324219 1;
	setAttr ".RightFootGX" -type "matrix" 0.80436837673187256 -0.034691296517848969 0.59311729669570923 0
		 -0.14505627751350403 0.95661640167236328 0.25267338752746582 0 -0.57615131139755249 -0.28927785158157349 0.76443976163864136 0
		 -13.907528877258301 8.2139501571655273 -27.278842926025391 1;
	setAttr ".SpineGX" -type "matrix" 0.8207927942276001 0.54900097846984863 0.15779086947441101 0
		 -0.52796822786331177 0.83456510305404663 -0.15732534229755402 0 -0.21805846691131592 0.045822899788618088 0.97485983371734619 0
		 2.4531674385070801 52.687023162841797 -23.332723617553711 1;
	setAttr ".LeftArmGX" -type "matrix" 0.78690224885940552 -0.57702028751373291 0.21870581805706024 0
		 0.56178337335586548 0.81652647256851196 0.13298109173774719 0 -0.25531190633773804 0.018222171813249588 0.96668702363967896 0
		 10.911223411560059 95.09521484375 -26.66339111328125 1;
	setAttr ".LeftForeArmGX" -type "matrix" -0.40478917956352234 -0.046098198741674423 0.91324722766876221 0
		 0.62222766876220703 0.71795904636383057 0.31203776597976685 0 -0.67005854845046997 0.69455724954605103 -0.26193845272064209 0
		 29.512588500976563 81.455192565917969 -21.493463516235352 1;
	setAttr ".LeftHandGX" -type "matrix" 0.11179912090301514 0.11615008115768433 0.98691964149475098 0
		 0.94008731842041016 0.3095308244228363 -0.14292223751544952 0 -0.3220822811126709 0.94376909732818604 -0.074585855007171631 0
		 20.466445922851563 80.424995422363281 -1.0844211578369141 1;
	setAttr ".RightArmGX" -type "matrix" 0.91083061695098877 0.29938638210296631 0.28417497873306274 0
		 0.035754680633544922 0.62863141298294067 -0.77688103914260864 0 -0.41122889518737793 0.71776765584945679 0.56187230348587036 0
		 -29.855953216552734 85.487037658691406 -44.527442932128906 1;
	setAttr ".RightForeArmGX" -type "matrix" 0.61104971170425415 -0.53385186195373535 -0.58448302745819092 0
		 -0.13778002560138702 0.65536683797836304 -0.74263781309127808 0 0.77950942516326904 0.53431874513626099 0.32690760493278503 0
		 -51.535999298095703 78.340476989746094 -50.667011260986328 1;
	setAttr ".RightHandGX" -type "matrix" 0.94129979610443115 0.051101110875606537 -0.33368057012557983 0
		 -0.20043870806694031 -0.71075588464736938 -0.674277663230896 0 -0.27162176370620728 0.70158016681671143 -0.65879195928573608 0
		 -65.131500244140625 90.508056640625 -37.762153625488281 1;
	setAttr ".HeadGX" -type "matrix" 0.12194295227527618 0.69999420642852783 0.70366066694259644 0
		 0.17921990156173706 0.68176925182342529 -0.70927518606185913 0 -0.97622251510620117 0.21260099112987518 -0.042315918952226639 0
		 -13.504547119140625 106.74164581298828 -35.910789489746094 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.9300616979598999 0.089464925229549408 -0.35634472966194153 0
		 0.013618260622024536 0.96083849668502808 0.27677458524703979 0 0.36715129017829895 -0.26227021217346191 0.89242058992385864 0
		 27.734441757202148 30.445869445800781 -6.5086479187011719 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.74611127376556396 0.15991237759590149 0.64633262157440186 0
		 -0.66533768177032471 0.14207723736763 0.73289823532104492 0 0.025370299816131592 -0.9768531322479248 0.21240116655826569 0
		 -11.70195198059082 2.1575107574462891 -29.672807693481445 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.84882354736328125 0.0073784585110843182 0.52862483263015747 0
		 0.21556314826011658 0.90817838907241821 -0.35881021618843079 0 -0.48273313045501709 0.41851857304573059 0.76929259300231934 0
		 1.2212047576904297 96.438583374023438 -28.76702880859375 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.79332423210144043 0.4455755352973938 0.41484805941581726 0
		 -0.13763241469860077 0.79504227638244629 -0.59073257446289063 0 -0.59303766489028931 0.41154596209526062 0.69205194711685181 0
		 -24.58856201171875 91.042427062988281 -38.084239959716797 1;
	setAttr ".NeckGX" -type "matrix" 0.9229128360748291 0.19294489920139313 0.33317276835441589 0
		 -0.20406836271286011 0.97895526885986328 -0.0016421973705291748 0 -0.32647809386253357 -0.066474407911300659 0.94286429882049561 0
		 -10.751740455627441 100.31006622314453 -39.811641693115234 1;
	setAttr ".Spine1GX" -type "matrix" 0.87951004505157471 0.43120080232620239 0.20131602883338928 0
		 -0.36920067667961121 0.88519746065139771 -0.28304827213287354 0 -0.30025508999824524 0.17461776733398438 0.93773967027664185 0
		 -1.5663309097290039 58.648303985595703 -23.165258407592773 1;
	setAttr ".Spine2GX" -type "matrix" 0.91405379772186279 0.31075891852378845 0.26064246892929077 0
		 -0.19304405152797699 0.89849293231964111 -0.39426451921463013 0 -0.3567066490650177 0.31006348133087158 0.88126111030578613 0
		 -6.8052582740783691 72.025672912597656 -28.930534362792969 1;
	setAttr ".Spine3GX" -type "matrix" 0.92291265726089478 0.19294622540473938 0.33317351341247559 0
		 -0.0072069540619850159 0.87386929988861084 -0.48610812425613403 0 -0.3849426805973053 0.44623401761054993 0.8078952431678772 0
		 -8.4700965881347656 82.887245178222656 -36.042106628417969 1;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter1";
	rename -uid "FA5D3863-45AF-C3E8-75D6-3D96A39C3DBD";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKEffectorFromCharacter -n "HIKEffectorFromCharacter2";
	rename -uid "0571A14F-4557-F306-C038-73AD1186FA13";
	setAttr ".ihi" 0;
	setAttr ".OutputEffectorState" -type "HIKEffectorState" ;
createNode HIKState2Effector -n "HIKState2Effector1";
	rename -uid "1895B487-45A9-AADA-F325-ADB1DA1AE123";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.78313320875167847 0.60528862476348877 0.14257854223251343 0
		 -0.59862160682678223 0.79587793350219727 -0.090724766254425049 0 -0.16838973760604858 -0.014301043003797531 0.98561704158782959 0
		 7.9303021430969238 43.742500305175781 -15.444305419921875 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.96275246143341064 -0.21646182239055634 -0.16202658414840698 0
		 0.18319053947925568 0.96294230222702026 -0.19794958829879761 0 0.19887071847915649 0.16089466214179993 0.96672850847244263 0
		 29.776742935180664 37.01025390625 -6.6260967254638672 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.80436837673187256 -0.034691296517848969 0.59311729669570923 0
		 -0.14505627751350403 0.95661640167236328 0.25267338752746582 0 -0.57615131139755249 -0.28927785158157349 0.76443976163864136 0
		 -13.907528877258301 8.2139501571655273 -27.278842926025391 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.11179912090301514 0.11615008115768433 0.98691964149475098 0
		 0.94008737802505493 0.30953085422515869 -0.14292225241661072 0 -0.3220822811126709 0.94376909732818604 -0.074585855007171631 0
		 20.466445922851563 80.424995422363281 -1.0844211578369141 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.94129979610443115 0.051101110875606537 -0.33368057012557983 0
		 -0.20043870806694031 -0.71075588464736938 -0.674277663230896 0 -0.27162176370620728 0.70158016681671143 -0.65879195928573608 0
		 -65.131500244140625 90.508056640625 -37.762153625488281 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.95028936862945557 0.2643229067325592 -0.16457214951515198 0
		 -0.25046417117118835 0.96291595697402954 0.10030435770750046 0 0.18498185276985168 -0.054098717868328094 0.98125201463699341 0
		 33.077007293701172 47.34698486328125 5.0520057678222656 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98209816217422485 0.11772007495164871 -0.14705713093280792 0
		 -0.006552964448928833 0.80155467987060547 0.59788602590560913 0 0.18825747072696686 -0.58621889352798462 0.78797650337219238 0
		 -15.684040069580078 9.2562999725341797 -11.471366882324219 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.40478920936584473 -0.046098202466964722 0.91324728727340698 0
		 0.62222766876220703 0.71795904636383057 0.31203776597976685 0 -0.67005854845046997 0.69455724954605103 -0.26193845272064209 0
		 29.512588500976563 81.455192565917969 -21.493463516235352 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.61104971170425415 -0.53385186195373535 -0.58448302745819092 0
		 -0.13778002560138702 0.65536683797836304 -0.74263781309127808 0 0.77950942516326904 0.53431874513626099 0.32690760493278503 0
		 -51.535999298095703 78.340476989746094 -50.667011260986328 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.8207927942276001 0.54900097846984863 0.15779086947441101 0
		 -0.52796828746795654 0.83456516265869141 -0.15732535719871521 0 -0.21805846691131592 0.045822899788618088 0.97485983371734619 0
		 2.4531674385070801 52.687023162841797 -23.332723617553711 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.92291265726089478 0.19294622540473938 0.33317351341247559 0
		 -0.0072069540619850159 0.87386929988861084 -0.48610812425613403 0 -0.38494271039962769 0.44623404741287231 0.80789530277252197 0
		 -11.68367862701416 93.740509033203125 -33.425636291503906 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.9300616979598999 0.089464925229549408 -0.35634472966194153 0
		 0.013618260622024536 0.96083849668502808 0.27677458524703979 0 0.36715129017829895 -0.26227021217346191 0.89242058992385864 0
		 27.734441757202148 30.445869445800781 -6.5086479187011719 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.74611127376556396 0.15991237759590149 0.64633262157440186 0
		 -0.66533768177032471 0.14207723736763 0.73289823532104492 0 0.025370299816131592 -0.9768531322479248 0.21240116655826569 0
		 -11.70195198059082 2.1575107574462891 -29.672807693481445 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.78690230846405029 -0.57702034711837769 0.21870583295822144 0
		 0.56178337335586548 0.81652647256851196 0.13298109173774719 0 -0.25531190633773804 0.018222171813249588 0.96668702363967896 0
		 10.911223411560059 95.09521484375 -26.66339111328125 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.91083061695098877 0.29938638210296631 0.28417497873306274 0
		 0.035754680633544922 0.62863141298294067 -0.77688103914260864 0 -0.41122889518737793 0.71776765584945679 0.56187230348587036 0
		 -29.855953216552734 85.487037658691406 -44.527442932128906 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.12194295227527618 0.69999420642852783 0.70366066694259644 0
		 0.17921990156173706 0.68176925182342529 -0.70927518606185913 0 -0.97622257471084595 0.21260100603103638 -0.042315922677516937 0
		 -13.504547119140625 106.74164581298828 -35.910789489746094 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.90269178152084351 0.41338524222373962 -0.11941792815923691 0
		 -0.40328487753868103 0.71603888273239136 -0.56978070735931396 0 -0.15003104507923126 0.56249570846557617 0.81307423114776611 0
		 27.427455902099609 58.811962127685547 -11.894618988037109 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.94810038805007935 -0.31147581338882446 -0.06394544243812561 0
		 0.30804580450057983 0.94959414005279541 -0.05813194066286087 0 0.078828886151313782 0.035416774451732635 0.99625909328460693 0
		 -11.566851615905762 28.673036575317383 -18.993991851806641 1;
createNode HIKState2Effector -n "HIKState2Effector2";
	rename -uid "FB94BB68-499A-9C5C-E9E5-87B08AA4ED38";
	setAttr ".ihi" 0;
	setAttr ".HipsEffectorGXM[0]" -type "matrix" 0.78313320875167847 0.60528862476348877 0.14257854223251343 0
		 -0.59862160682678223 0.79587793350219727 -0.090724766254425049 0 -0.16838973760604858 -0.014301043003797531 0.98561704158782959 0
		 7.9303021430969238 43.742500305175781 -15.444305419921875 1;
	setAttr ".LeftAnkleEffectorGXM[0]" -type "matrix" 0.96275246143341064 -0.21646182239055634 -0.16202658414840698 0
		 0.18319053947925568 0.96294230222702026 -0.19794958829879761 0 0.19887071847915649 0.16089466214179993 0.96672850847244263 0
		 29.776742935180664 37.01025390625 -6.6260967254638672 1;
	setAttr ".RightAnkleEffectorGXM[0]" -type "matrix" 0.80436837673187256 -0.034691296517848969 0.59311729669570923 0
		 -0.14505627751350403 0.95661640167236328 0.25267338752746582 0 -0.57615131139755249 -0.28927785158157349 0.76443976163864136 0
		 -13.907528877258301 8.2139501571655273 -27.278842926025391 1;
	setAttr ".LeftWristEffectorGXM[0]" -type "matrix" 0.11179912090301514 0.11615008115768433 0.98691964149475098 0
		 0.94008737802505493 0.30953085422515869 -0.14292225241661072 0 -0.3220822811126709 0.94376909732818604 -0.074585855007171631 0
		 20.466445922851563 80.424995422363281 -1.0844211578369141 1;
	setAttr ".RightWristEffectorGXM[0]" -type "matrix" 0.94129979610443115 0.051101110875606537 -0.33368057012557983 0
		 -0.20043870806694031 -0.71075588464736938 -0.674277663230896 0 -0.27162176370620728 0.70158016681671143 -0.65879195928573608 0
		 -65.131500244140625 90.508056640625 -37.762153625488281 1;
	setAttr ".LeftKneeEffectorGXM[0]" -type "matrix" 0.95028936862945557 0.2643229067325592 -0.16457214951515198 0
		 -0.25046417117118835 0.96291595697402954 0.10030435770750046 0 0.18498185276985168 -0.054098717868328094 0.98125201463699341 0
		 33.077007293701172 47.34698486328125 5.0520057678222656 1;
	setAttr ".RightKneeEffectorGXM[0]" -type "matrix" 0.98209816217422485 0.11772007495164871 -0.14705713093280792 0
		 -0.006552964448928833 0.80155467987060547 0.59788602590560913 0 0.18825747072696686 -0.58621889352798462 0.78797650337219238 0
		 -15.684040069580078 9.2562999725341797 -11.471366882324219 1;
	setAttr ".LeftElbowEffectorGXM[0]" -type "matrix" -0.40478920936584473 -0.046098202466964722 0.91324728727340698 0
		 0.62222766876220703 0.71795904636383057 0.31203776597976685 0 -0.67005854845046997 0.69455724954605103 -0.26193845272064209 0
		 29.512588500976563 81.455192565917969 -21.493463516235352 1;
	setAttr ".RightElbowEffectorGXM[0]" -type "matrix" 0.61104971170425415 -0.53385186195373535 -0.58448302745819092 0
		 -0.13778002560138702 0.65536683797836304 -0.74263781309127808 0 0.77950942516326904 0.53431874513626099 0.32690760493278503 0
		 -51.535999298095703 78.340476989746094 -50.667011260986328 1;
	setAttr ".ChestOriginEffectorGXM[0]" -type "matrix" 0.8207927942276001 0.54900097846984863 0.15779086947441101 0
		 -0.52796828746795654 0.83456516265869141 -0.15732535719871521 0 -0.21805846691131592 0.045822899788618088 0.97485983371734619 0
		 2.4531674385070801 52.687023162841797 -23.332723617553711 1;
	setAttr ".ChestEndEffectorGXM[0]" -type "matrix" 0.92291265726089478 0.19294622540473938 0.33317351341247559 0
		 -0.0072069540619850159 0.87386929988861084 -0.48610812425613403 0 -0.38494271039962769 0.44623404741287231 0.80789530277252197 0
		 -11.68367862701416 93.740509033203125 -33.425636291503906 1;
	setAttr ".LeftFootEffectorGXM[0]" -type "matrix" 0.9300616979598999 0.089464925229549408 -0.35634472966194153 0
		 0.013618260622024536 0.96083849668502808 0.27677458524703979 0 0.36715129017829895 -0.26227021217346191 0.89242058992385864 0
		 27.734441757202148 30.445869445800781 -6.5086479187011719 1;
	setAttr ".RightFootEffectorGXM[0]" -type "matrix" 0.74611127376556396 0.15991237759590149 0.64633262157440186 0
		 -0.66533768177032471 0.14207723736763 0.73289823532104492 0 0.025370299816131592 -0.9768531322479248 0.21240116655826569 0
		 -11.70195198059082 2.1575107574462891 -29.672807693481445 1;
	setAttr ".LeftShoulderEffectorGXM[0]" -type "matrix" 0.78690230846405029 -0.57702034711837769 0.21870583295822144 0
		 0.56178337335586548 0.81652647256851196 0.13298109173774719 0 -0.25531190633773804 0.018222171813249588 0.96668702363967896 0
		 10.911223411560059 95.09521484375 -26.66339111328125 1;
	setAttr ".RightShoulderEffectorGXM[0]" -type "matrix" 0.91083061695098877 0.29938638210296631 0.28417497873306274 0
		 0.035754680633544922 0.62863141298294067 -0.77688103914260864 0 -0.41122889518737793 0.71776765584945679 0.56187230348587036 0
		 -29.855953216552734 85.487037658691406 -44.527442932128906 1;
	setAttr ".HeadEffectorGXM[0]" -type "matrix" 0.12194295227527618 0.69999420642852783 0.70366066694259644 0
		 0.17921990156173706 0.68176925182342529 -0.70927518606185913 0 -0.97622257471084595 0.21260100603103638 -0.042315922677516937 0
		 -13.504547119140625 106.74164581298828 -35.910789489746094 1;
	setAttr ".LeftHipEffectorGXM[0]" -type "matrix" 0.90269178152084351 0.41338524222373962 -0.11941792815923691 0
		 -0.40328487753868103 0.71603888273239136 -0.56978070735931396 0 -0.15003104507923126 0.56249570846557617 0.81307423114776611 0
		 27.427455902099609 58.811962127685547 -11.894618988037109 1;
	setAttr ".RightHipEffectorGXM[0]" -type "matrix" 0.94810038805007935 -0.31147581338882446 -0.06394544243812561 0
		 0.30804580450057983 0.94959414005279541 -0.05813194066286087 0 0.078828886151313782 0.035416774451732635 0.99625909328460693 0
		 -11.566851615905762 28.673036575317383 -18.993991851806641 1;
createNode HIKRetargeterNode -n "HIKRetargeterNode1";
	rename -uid "A968AEB0-44C6-CAC9-FBD1-D7A5C2A564D7";
	setAttr ".ihi" 0;
createNode HIKSK2State -n "HIKSK2State1";
	rename -uid "5873AFB7-44A3-AA41-6A6A-C4988ADE57FD";
	setAttr ".ihi" 0;
	setAttr ".HipsGX" -type "matrix" 0.029921165684402062 0.067430611131083312 0.99727520601214958 0
		 0.79640263719899218 -0.60452832497491271 0.016980688016599792 0 0.60402612799992117 0.79372452210166433 -0.071790108705223066 0
		 6.6941943584216208 56.084833144491164 -17.464665548584261 1;
	setAttr ".LeftUpLegGX" -type "matrix" -0.086644049147899749 -0.95340781128177166 0.28897516321727207 0
		 0.99593835439000933 -0.075762369978087774 0.048653649784936116 0 -0.02449332515598597 0.29201698144918942 0.95609971180892428 0
		 27.905799894691363 46.593351673390558 -18.792494556709368 1;
	setAttr ".LeftLegGX" -type "matrix" -0.059289155381806902 -0.9584903749011886 -0.27889292210449235 0
		 0.99593833311961977 -0.075762368360020635 0.048653648745833562 0 -0.067763635462297772 -0.27487542196244497 0.95908920254634222 0
		 25.773329469245915 23.128220704308553 -11.680280904307157 1;
	setAttr ".LeftFootGX" -type "matrix" -0.11290165786335719 -0.93886708834167076 0.32524145218641287 0
		 0.79362688929114578 -0.28216234695047671 -0.53901862671378153 0 0.59783757347000666 0.19726421514724296 0.77696675834078277 0
		 24.793243466111928 7.283789185468839 -16.290550487212748 1;
	setAttr ".RightUpLegGX" -type "matrix" 0.3684785031802823 0.92963487599322248 -0.0016973076838240897 0
		 0.9215962805917931 -0.36553064064725815 -0.13056782984572091 0 -0.12200079248649606 0.046547193166226894 -0.99143795279546898 0
		 -14.010631415148927 49.171810451548247 -9.3835847576058757 1;
	setAttr ".RightLegGX" -type "matrix" -0.08809454150678564 -0.52458272676372442 0.84678943139346552 0
		 0.92159626090913749 -0.36553063284057113 -0.13056782705716621 0 0.37802111263507382 0.76889571669988088 0.51565464136893557 0
		 -23.07956942268666 26.291775423011703 -9.3418108738339551 1;
	setAttr ".RightFootGX" -type "matrix" 0.28171336795161411 0.84367058463483446 -0.45700946496522254 0
		 0.95152216203521156 -0.18435813039832555 0.24620696123452773 0 0.12346416254140513 -0.50421453824614804 -0.85470727858762996 0
		 -21.623313010282974 34.96344863735861 -23.339759483566592 1;
	setAttr ".SpineGX" -type "matrix" 0.12088957785767313 0.99051629251420681 -0.065293097447374618 0
		 0.95152380291425698 -0.13436841538938121 -0.27667233586561796 0 -0.28282178640272521 -0.028681134499486102 -0.9587435705154751 0
		 7.251119350486106 69.825516973656789 -18.749137280234681 1;
	setAttr ".LeftArmGX" -type "matrix" 0.60662890998361263 -0.65555401395381452 -0.44972322919090718 0
		 -0.71107971774456691 -0.70039224206473361 0.061779019906293559 0 -0.3554818801989949 0.28231199957042463 -0.89102895810895977 0
		 32.140943874522833 103.18643739767708 -33.764601727641036 1;
	setAttr ".LeftForeArmGX" -type "matrix" 0.48627171060205027 -0.42641726290700532 0.76269811797997833 0
		 -0.7110797237558556 -0.70039220379614908 0.061778956014216103 0 0.50784429940961773 -0.57238055683454636 -0.64379755539124639 0
		 53.581240835362152 80.016963436511972 -49.65932734224949 1;
	setAttr ".LeftHandGX" -type "matrix" 0.57322449767352834 0.096091687745846449 0.81374467528144967 0
		 -0.65446216517334499 -0.54387240464455433 0.52524512239913723 0 0.49304502778276971 -0.83364841568374137 -0.24887267921398826 0
		 66.51029375373399 68.679330575448347 -29.380617449152858 1;
	setAttr ".RightArmGX" -type "matrix" 0.65687655759180097 0.56116469906084165 -0.50359510673202723 0
		 -0.56064474132382647 0.81011593886210553 0.1714356361118442 0 0.50417376406204661 0.16972592713565784 0.84675983638570129 0
		 -7.1315676273992477 110.82195882223097 -8.7354254215932077 1;
	setAttr ".RightForeArmGX" -type "matrix" -0.053476387087158683 0.17117904444465185 -0.98378790608718514 0
		 -0.56064481686316547 0.81011600481487045 0.1714356110725774 0 0.82632824636360191 0.56072321362503319 0.052648391216950863 0
		 -30.347786171668901 90.988519200094458 9.0633113040721565 1;
	setAttr ".RightHandGX" -type "matrix" -0.26339345092613975 0.12970616535365304 -0.95592933009091174 0
		 -0.95208022848735885 0.12473622929991807 0.27925801986287624 0 0.15546048297602383 0.98367581706862672 0.090635932736965491 0
		 -28.925946763085634 86.437189937385767 35.220378758687858 1;
	setAttr ".HeadGX" -type "matrix" 0.91853668964795077 0.20434206264639512 -0.33843036163422147 0
		 0.020285494134073115 -0.87929095359870058 -0.47585327538074412 0 -0.39481537671421946 0.43022336007684125 -0.81180590134753461 0
		 25.5988532808176 129.12392908362162 -12.885487754989402 1;
	setAttr ".LeftToeBaseGX" -type "matrix" 0.4861020032449469 -0.66422447275727592 0.56790045492962926 0
		 0.72507862801596212 -0.056196896580891088 -0.68636961388830298 0 0.48781760284196385 0.74541795577408809 0.45429753703147402 0
		 22.794924214642062 -9.3338257854742803 -10.533893690615475 1;
	setAttr ".RightToeBaseGX" -type "matrix" 0.18866046932845146 0.87548764149671821 -0.44489183531951199 0
		 0.94942114311295944 -0.046808638894382429 0.31049743723925466 0 0.25101188474194636 -0.48096841591958439 -0.84003728919179688 0
		 -26.609539151174531 20.030779358423441 -15.250852503709639 1;
	setAttr ".LeftShoulderGX" -type "matrix" 0.79930011251125599 -0.38450796723628128 -0.46181534106059452 0
		 -0.44278437814040877 0.14272592569504733 -0.88519567457491777 0 0.40627778293599121 0.9120215370582313 -0.056173275315770585 0
		 14.791713591631055 111.53238564264205 -23.740656289287607 1;
	setAttr ".RightShoulderGX" -type "matrix" 0.83771510996496401 0.062770627536372775 -0.54248844348165504 0
		 0.54568555640569438 -0.13526897568028545 0.82700038819896249 0 -0.021470524553898036 -0.98881873784587992 -0.147569912045625 0
		 11.051481038117208 112.18442817986548 -20.510421988237923 1;
	setAttr ".NeckGX" -type "matrix" 0.55142910427914693 0.72826643603735108 0.40688362447165072 0
		 0.7334740751392721 -0.19089725426399604 -0.65236071083721403 0 -0.39741924619242863 0.65816915429000844 -0.63943059820586712 0
		 16.337251882850541 116.89223396259473 -19.71935656773514 1;
	setAttr ".Spine1GX" -type "matrix" 0.29231951518948296 0.95505485511098309 0.049192780218847931 0
		 0.7334740751392721 -0.19089725426399604 -0.65236071083721403 0 -0.61364925815269733 0.22677930762649645 -0.75631067694345544 0
		 10.77922418405695 98.733263871941091 -20.65468527523312 1;
createNode animLayer -n "BaseAnimation";
	rename -uid "3515BE0F-4E45-8DF7-013C-C5BF691F23F2";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAX";
	rename -uid "26FB4332-4366-C1CE-4888-57A7C069652B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -12.13500825116952 1 -14.775341397196255
		 2 -17.31676091248222 3 -19.719436489761613 4 -21.818796121609981 5 -23.246598168446386
		 6 -23.472814451070136 7 -21.882638584208316 8 -18.507537761642627 9 -13.951365898941809
		 10 -8.5720718488051055 11 -2.9525989801019836 12 2.1516092790307706 13 7.0100451695920354
		 14 10.142480185904418 15 12.279105234562405 16 13.638235552149235 17 14.314130891539184
		 18 14.260611284644506 19 13.324402313646161 20 11.292888799191326 21 8.1917473346984711
		 22 4.3143989600441257 23 -0.092356241159469304 24 -4.6517080143262728 25 -8.8541447522861496
		 26 -12.13500825116952;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAY";
	rename -uid "44B090CC-4527-4360-4238-46A94D2FA37D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 36.771235946670785 1 35.400777886885258
		 2 31.566582374431402 3 25.669573652663903 4 18.142427799478892 5 9.4737443694068357
		 6 0.19976939973998237 7 -9.1146223742117627 8 -17.896259268073056 9 -25.585255332359903
		 10 -31.659450385953782 11 -35.654848428242779 12 -37.158783221135906 13 -36.136894453251813
		 14 -33.230217103683025 15 -28.72781986819604 16 -22.874070089743324 17 -15.948300608676774
		 18 -8.2742898767241595 19 -0.21145694995255584 20 7.8608121624848915 21 15.55971741067024
		 22 22.515961641930431 23 28.390542752078112 24 32.888423689939565 25 35.759135851224059
		 26 36.771235946670785;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Hips_rotate_tempLayer_inputAZ";
	rename -uid "EB5DD329-4B58-EE89-F811-7B9C07809598";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -6.5032651792622556 1 -5.7833986392006
		 2 -3.9990173373424827 3 -1.8104554351222468 4 0.20830261119021126 5 1.6771360807928539
		 6 2.38900459008816 7 2.2599055222237818 8 1.3056504605203696 9 -0.33677404047025361
		 10 -2.3504064316015554 11 -4.1920533601531602 12 -5.1681681916621063 13 -5.378227938034045
		 14 -4.1779183184901285 15 -2.3593595678496695 16 -0.42140424549293543 17 1.2378683415872023
		 18 2.3552706883477437 19 2.7850933454384239 20 2.4724000291658812 21 1.4401831123919917
		 22 -0.20193954794936508 23 -2.2310102301673798 24 -4.2853530147127366 25 -5.8792071425712535
		 26 -6.5032651792622556;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateX_tempLayer_inputA";
	rename -uid "127C91BF-4C8E-1696-4239-75A56974CD35";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 3.8409156799316406 1 4.1099672317504883
		 2 4.5904397964477539 3 5.2224998474121094 4 6.0016207695007324 5 6.9438509941101074
		 6 7.961540699005127 7 8.9069042205810547 8 9.6965456008911133 9 10.308938980102539
		 10 10.708385467529297 11 10.64567756652832 12 10.368254661560059 13 10.155607223510742
		 14 10.034418106079102 15 9.7893218994140625 16 9.379547119140625 17 8.8081579208374023
		 18 8.1304988861083984 19 7.4038681983947754 20 6.6494045257568359 21 5.8990230560302734
		 22 5.185572624206543 23 4.57574462890625 24 4.1157541275024414 25 3.8517851829528809
		 26 3.8409156799316406;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateY_tempLayer_inputA";
	rename -uid "82C82577-402A-2443-8758-A0872766B83A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 49.940830230712891 1 49.867828369140625
		 2 50.013004302978516 3 50.006855010986328 4 49.701030731201172 5 49.512653350830078
		 6 49.361011505126953 7 49.076629638671875 8 48.729217529296875 9 48.433864593505859
		 10 48.2791748046875 11 48.134002685546875 12 48.334098815917969 13 48.776332855224609
		 14 49.310428619384766 15 49.833091735839844 16 50.277847290039063 17 50.540077209472656
		 18 50.260238647460938 19 50.059986114501953 20 50.051464080810547 21 50.2354736328125
		 22 50.272560119628906 23 50.24658203125 24 50.239627838134766 25 50.160610198974609
		 26 49.940830230712891;
createNode animCurveTL -n "Character1_Ctrl_Hips_translateZ_tempLayer_inputA";
	rename -uid "F20CB301-4B0F-4630-A005-81A05ECA8937";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -19.296710968017578 1 -19.329488754272461
		 2 -19.439052581787109 3 -19.238346099853516 4 -18.696565628051758 5 -18.286661148071289
		 6 -18.087291717529297 7 -18.096343994140625 8 -18.294338226318359 9 -18.604068756103516
		 10 -19.011438369750977 11 -20.007991790771484 12 -20.848600387573242 13 -21.253677368164063
		 14 -21.253776550292969 15 -21.028087615966797 16 -20.685739517211914 17 -20.301261901855469
		 18 -19.727102279663086 19 -19.335075378417969 20 -19.121397018432617 21 -18.988809585571289
		 22 -19.210981369018555 23 -19.516769409179688 24 -19.603767395019531 25 -19.471872329711914
		 26 -19.296710968017578;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAX";
	rename -uid "BC76133C-46A0-CDDC-3A2D-CC8CBE1C18E1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -17.19660779747986 1 -24.912797865935229
		 2 -27.421886494030826 3 -26.881101532124962 4 -23.631957467410391 5 -17.064899581462075
		 6 -7.9165315619885659 7 2.9801421833777817 8 14.349952370867179 9 24.112108360097871
		 10 31.129273944971775 11 35.555811868483211 12 34.761972674003552 13 30.224569905873253
		 14 25.013816048979141 15 20.712277996417921 16 17.831194066324553 17 16.452582944470524
		 18 15.969342829092055 19 15.876320508449016 20 15.54611165913551 21 14.335432460395507
		 22 11.522534345957988 23 6.5793914063917303 24 -0.17865255389513374 25 -7.8836965748933041
		 26 -17.19660779747986;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAY";
	rename -uid "AAC61F62-4581-0861-C86C-BFBACE84F39D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.5950886275398775 1 -7.761058325106748
		 2 -8.7831637057295371 3 -10.900726832904136 4 -16.825207969208805 5 -25.147305858909331
		 6 -33.553461285814514 7 -40.869781397102649 8 -43.592856200595847 9 -44.685105796534408
		 10 -45.797797502852625 11 -46.515629612857261 12 -46.670612723673273 13 -45.047315389141232
		 14 -41.279354136035046 15 -34.184434989024886 16 -25.810657389575713 17 -18.276921285199773
		 18 -11.786045111521711 19 -6.0712177320632925 20 -0.5786679399230934 21 4.7259467007529965
		 22 9.3147946307972997 23 11.890914499514048 24 10.633144263266272 25 4.4462543982284277
		 26 -3.595088627539877;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "97E735A0-4DA1-FB13-3383-AB8BA63FF422";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -30.802777497431194 1 -38.634571879751363
		 2 -40.243339005226012 3 -38.961151124113265 4 -38.730229717257146 5 -39.718836488371252
		 6 -40.154042068013347 7 -40.83256203390156 8 -42.935405014061274 9 -43.098846070611756
		 10 -40.346265924522193 11 -36.391429322231581 12 -27.959974040192904 13 -15.314652619214376
		 14 -2.9776654279105146 15 6.8555505615058898 16 14.560452026908262 17 21.025962073630268
		 18 27.076690605630148 19 31.555632041633267 20 32.930296549909002 21 30.559225744547124
		 22 23.451345357272213 23 12.205444846812279 24 -1.7989451282299627 25 -16.396872523197015
		 26 -30.802777497431194;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAX";
	rename -uid "56BBF576-41E2-BA59-E72B-9A9C8C98EF8D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.8726935973635017 1 -0.11893353393685654
		 2 1.350797237340239 3 4.4539937758008108 4 7.987247060478297 5 11.061082187250355
		 6 14.235731643587249 7 18.331903276677984 8 21.462005203265445 9 24.33541603997325
		 10 26.941888894453953 11 28.439679483174881 12 28.724288109408153 13 28.337668095233482
		 14 26.732171623137813 15 23.154008860368894 16 18.847827080733648 17 14.979759232990931
		 18 11.581584549011003 19 8.0381457106723833 20 4.1412861668873893 21 -0.076793550167962993
		 22 -4.426527715943835 23 -8.011094109795426 24 -11.336738633775051 25 -10.817745142778167
		 26 -3.8726935973635017;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAY";
	rename -uid "6F650117-4463-FE19-6845-C68F290BE9C5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 10.987239672749395 1 6.7305560839391738
		 2 2.6021233396027883 3 0.23318437478927673 4 0.14454051761356873 5 2.0433540954001095
		 6 5.7975694238062641 7 10.758544820762172 8 10.009877787557601 9 8.5625323810808869
		 10 8.2646313047238706 11 8.3262179919785755 12 8.7994177957744437 13 9.9888663822634545
		 14 11.265802164604485 15 9.5894725628044917 16 6.2795608317491416 17 3.8621374486500746
		 18 2.0474980808896639 19 0.77220817748925741 20 0.065595078304340609 21 0.057868822964030807
		 22 0.88553593089457383 23 2.7370613164085924 24 5.8787837903812701 25 10.113227747979668
		 26 10.987239672749395;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftLeg_rotate_tempLayer_inputAZ";
	rename -uid "0267C0BE-4697-5617-282F-E98D2BB4E1D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 41.223678863981405 1 31.965426124525187
		 2 16.053412108039865 3 -0.3388172830044982 4 -7.5747067911874959 5 -5.1669571374448813
		 6 2.0239902559878771 7 9.1258563709513609 8 16.024604169072116 9 22.013166592432768
		 10 26.398635920173533 11 29.272609661556288 12 29.688773515115798 13 27.730557645044577
		 14 24.239048597165553 15 19.560327417950603 16 14.01734195933696 17 8.5377210112256545
		 18 4.9530368934000073 19 3.3013858585767686 20 5.2106965525834852 21 10.579884119114215
		 22 20.050450819977598 23 30.287462029398096 24 38.340219268368976 25 42.669867375152599
		 26 41.223678863981405;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAX";
	rename -uid "22F57C73-433A-7170-1781-98AA9C290384";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 2.4743329596075334 1 -1.1524306031314744
		 2 -1.5802242149330992 3 -1.9031477776494223 4 -4.4942862270435926 5 -9.1984146459597049
		 6 -13.772138312959099 7 -17.77498707109492 8 -24.667784619420893 9 -31.343071036623225
		 10 -35.852926507569677 11 -38.260417814723205 12 -38.553513514771588 13 -38.131049195076514
		 14 -37.231954542110536 15 -38.139844550084746 16 -39.037487502333242 17 -37.641636725538589
		 18 -34.49350404224969 19 -30.478543752756924 20 -26.432598221035342 21 -22.755099557727831
		 22 -19.59117699312046 23 -16.345406518970151 24 -10.308233166722554 25 0.023726128278407164
		 26 2.4743329596075334;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAY";
	rename -uid "E9DA244D-4382-1AE5-C8EE-C09351FF1B4F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 27.903358244105853 1 21.389234063973724
		 2 19.478316643006398 3 17.152373003976205 4 14.864997357709308 5 13.042517816067793
		 6 11.144024651691208 7 9.5202019357383278 8 10.409533294329465 9 11.431227528083413
		 10 11.81293362298624 11 12.431692550793302 12 12.482267398174237 13 12.523131209594158
		 14 13.421716210363886 15 14.954038185394115 16 17.269790508200803 17 19.731037993363838
		 18 21.677551411161723 19 23.365689183618496 20 24.815685895892596 21 26.937594099163498
		 22 30.07664334762887 23 33.983662438408011 24 38.987189611962101 25 39.03124011633944
		 26 27.903358244105853;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftFoot_rotate_tempLayer_inputAZ";
	rename -uid "E5C69ED8-4495-25BF-3600-DA84C55660D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.697246710084983 1 -3.1250789914273338
		 2 -2.3107603672573926 3 -0.11349745167791263 4 3.3866816723725774 5 5.0196378348554953
		 6 3.0026303288235368 7 1.6507833672242802 8 -1.6626062470977625 9 -6.2955056078301421
		 10 -11.26621114879647 11 -15.593842057794401 12 -20.017820724901664 13 -23.813417377895501
		 14 -23.883307756773647 15 -21.406438318506581 16 -17.111606548212311 17 -12.388399656984932
		 18 -11.392716390123821 19 -14.133839054911208 20 -20.189660635407282 21 -28.253441469138952
		 22 -37.256769223781653 23 -43.231327251447254 24 -41.743341092325615 25 -29.585544227865579
		 26 -11.697246710084981;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAX";
	rename -uid "0E38234D-48FD-D293-459F-C3A0641CE925";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -39.187548514697838 1 -31.318195991124227
		 2 -28.150857613461696 3 -27.311992566195027 4 -27.487261777154504 5 -28.722155331377959
		 6 -29.863644821554189 7 -29.095721758769052 8 -26.616754974780033 9 -23.079468542624507
		 10 -18.500335365272264 11 -12.920363848715372 12 -6.7733172065796365 13 0.3291028284841771
		 14 7.4758650910409798 15 13.944374690230886 16 18.366317305377308 17 20.087918406772097
		 18 18.756511006821672 19 13.399736750244681 20 3.0925860756124171 21 -10.813418426638389
		 22 -25.323801009050793 23 -37.777972358079694 24 -45.981973100697743 25 -47.283335589633836
		 26 -39.187548514697838;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAY";
	rename -uid "62373D4A-4B5D-CB54-1973-53AE5BD63A19";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 45.281730506779297 1 46.110692818343999
		 2 43.44433701353843 3 39.920355221085849 4 35.806070219297439 5 29.571182522265815
		 6 21.877381401535963 7 14.790199770664744 8 8.5939340367774069 9 3.4619789089923354
		 10 -0.48917054487241746 11 -2.8040611931952859 12 -3.8040051826409145 13 -2.8529129185499045
		 14 -0.73900308539830017 15 1.652891141015798 16 3.9100033369415925 17 6.2322928840552896
		 18 11.633003474834618 19 20.082720781029174 20 27.678210463163573 21 30.958318759604531
		 22 30.7946079597364 23 30.242376845192823 24 32.655593512369464 25 38.703547321819514
		 26 45.281730506779297;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightUpLeg_rotate_tempLayer_inputAZ";
	rename -uid "5472C3B6-41C1-F4D7-2582-0E8692A9E683";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -14.717558484578825 1 -0.69348124498408181
		 2 6.7383804323792411 3 11.838232553926579 4 16.18284590779443 5 17.789303124816033
		 6 17.084811314618619 7 16.855838606006795 8 16.533710921015565 9 15.260305923123589
		 10 12.349960564899835 11 8.4098527955798072 12 2.9175909020487105 13 -6.2316463961677968
		 14 -14.776454885422499 15 -19.424778179179366 16 -20.615469328801534 17 -19.387116049326163
		 18 -20.679090658903867 19 -25.919462668934578 20 -34.326188643742853 21 -43.392828284277215
		 22 -49.991421759749585 23 -51.140529149572437 24 -45.690347456306959 25 -33.646675003476005
		 26 -14.717558484578825;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAX";
	rename -uid "CC9E939B-42C7-4E51-52BB-78A9C5B2423A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -15.911381358341909 1 -16.219166825987493
		 2 -16.555198337414804 3 -17.284536435759694 4 -17.286545676956074 5 -14.927111124935402
		 6 -10.86087553243823 7 -6.6986298130810571 8 -2.5638233224154825 9 1.5786164470317394
		 10 5.9641815259496207 11 10.154910748325578 12 13.202873014817573 13 13.419961714399509
		 14 9.1644826217387152 15 3.3445520641209585 16 -1.2317186124468444 17 -5.8111428026494201
		 18 -9.6848656466125842 19 -10.926316938061504 20 -10.740491041697284 21 -9.5034064765205635
		 22 -8.6141027931784091 23 -9.2672015751414669 24 -11.611291836236704 25 -14.349547118908456
		 26 -15.911381358341909;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAY";
	rename -uid "3428F055-4AAE-5372-EE35-AA9AA6C9717F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -0.42328130073741954 1 -0.96229868578012911
		 2 -1.9751843654990306 3 -3.7001773502722397 4 -5.0448009501378994 5 -3.7092314241200777
		 6 -1.3405569983148435 7 -0.16499997014708781 8 -0.015879046502222705 9 -0.54428753551503417
		 10 -1.483128408724816 11 -2.0900466172900947 12 -2.4395078854539616 13 -3.3897197779374713
		 14 -3.4815979168141338 15 -1.8559902395655785 16 -0.27276402336715633 17 0.21403482668380303
		 18 -0.41447670898494882 19 -2.5191649845808226 20 -4.0095965513687171 21 -2.9166600688989832
		 22 -1.3966395881409568 23 -0.54445709362021455 24 -0.21607492337804882 25 -0.18406264972725941
		 26 -0.42328130073741954;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightLeg_rotate_tempLayer_inputAZ";
	rename -uid "A99AC1B5-4085-23B4-7029-95BDCD325088";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 42.585143377642353 1 36.056652679690949
		 2 28.412961081238922 3 19.673989246209665 4 11.529789422119118 5 7.259479545064635
		 6 7.8728034909734959 7 9.7028309754500661 8 11.940996137405278 9 14.031909631651578
		 10 15.751580801736452 11 16.414343985696856 12 14.367745062537834 13 13.402046984849424
		 14 9.1549288174326229 15 -1.0799345252416566 16 -15.800880218906308 17 -32.186320341029543
		 18 -36.719616145866169 19 -27.805148840203703 20 -11.61430656888165 21 5.9320647857654869
		 22 21.888163505656344 23 34.725860803066766 24 43.256937591334449 25 46.25513100158507
		 26 42.585143377642353;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAX";
	rename -uid "DA7AFF0E-4BB4-315F-32C2-79B290E96C06";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 42.87367686070148 1 41.614140308954909
		 2 38.82328433215249 3 34.245552468907619 4 29.341068452362926 5 25.218164780817386
		 6 21.588201271319821 7 18.422321770698002 8 15.978859689255597 9 14.167003740263329
		 10 12.545314764735593 11 13.217581834638834 12 14.517014749781193 13 12.775933100438232
		 14 12.359614163278955 15 12.833037215185053 16 12.177559069600152 17 12.181541048698209
		 18 13.81790983893206 19 15.493715226902211 20 18.766401837381832 21 24.661844958989914
		 22 31.54711454963407 23 37.579641220541582 24 41.714558061653399 25 43.328038284101957
		 26 42.87367686070148;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAY";
	rename -uid "3B091D7B-499D-E58B-CB43-0A87D4477451";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.116841024160657 1 -9.6502154259808552
		 2 -10.678470895948832 3 -11.942796402162147 4 -12.796280192865614 5 -14.358989765323278
		 6 -15.96392826070594 7 -17.17073795470241 8 -18.905713904672677 9 -22.070456680839094
		 10 -26.74611090401244 11 -34.07787762627521 12 -39.516435515860195 13 -36.640068111917024
		 14 -25.570888708068168 15 -14.111820162544468 16 -6.2717691329491263 17 -1.010174151795304
		 18 3.5029664603413373 19 7.1357494252039828 20 8.5386335611340343 21 5.6651409187833934
		 22 -0.52054606389602953 23 -7.8260483675716435 24 -13.037043797339615 25 -13.963102541678602
		 26 -11.116841024160657;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightFoot_rotate_tempLayer_inputAZ";
	rename -uid "BA15A4BA-4E9E-85AF-6466-39906615E244";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -29.075386318126085 1 -26.072365533342744
		 2 -13.67923343449962 3 0.93285135554625365 4 12.150713818900122 5 17.320444848522861
		 6 16.840856148897998 7 13.13695191496724 8 6.6799604979827141 9 -1.3570438118574599
		 10 -9.1502328728330617 11 -20.969024188967474 12 -29.640757163842437 13 -28.790789753338128
		 14 -23.63860626959578 15 -17.824114294149126 16 -10.569907510025246 17 -1.8621910525656107
		 18 2.7169842702518054 19 3.4538519761106539 20 2.382135265388321 21 0.66045644833632122
		 22 -1.3315743729748251 23 -5.4485887501331476 24 -12.847736064653192 25 -21.770133359548506
		 26 -29.075386318126085;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAX";
	rename -uid "04258299-4CBD-6562-4B29-59993E307166";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -0.9541086226652542 1 0.45033373968962703
		 2 2.1267784819147875 3 3.9192498160887297 4 5.667221989943342 5 7.2037846669445287
		 6 8.3574139582332752 7 8.9567008847533796 8 9.000688407126324 9 8.6268507264789225
		 10 7.8794142266034859 11 6.7845572833498178 12 5.411953661156172 13 3.8577727930495125
		 14 2.2011321421723551 15 0.52485567325348914 16 -1.0875853894609211 17 -2.5500901521587007
		 18 -3.7723356311366691 19 -4.6595973552839327 20 -5.1132000307861993 21 -5.1042982923605376
		 22 -4.7252402784658267 23 -4.0660667291270531 24 -3.1813243263612825 25 -2.1262665676102617
		 26 -0.9541086226652542;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAY";
	rename -uid "4822B76C-4D5C-6F32-6331-05A418250F69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.861861573824509 1 -3.7488254725377401
		 2 -3.3467181350197972 3 -2.717937742562091 4 -1.9186515364263748 5 -1.0008370067328485
		 6 -0.017865526868470507 7 0.96890374403293156 8 1.900308865589651 9 2.724933806423333
		 10 3.3868154201565037 11 3.8322157066020255 12 4.0137804252854927 13 3.938239584435125
		 14 3.6750427310939546 15 3.256705009931983 16 2.7114934667101647 17 2.0638450146061897
		 18 1.3361678964065919 19 0.55090331785186464 20 -0.26593948566762021 21 -1.0865206262651783
		 22 -1.8944730026783483 23 -2.6421546236699909 24 -3.2520082311165139 25 -3.6744416750010238
		 26 -3.861861573824509;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine_rotate_tempLayer_inputAZ";
	rename -uid "A7156D28-4DAC-F1B6-B82C-2399D46DBC32";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -4.4656235100083137 1 -4.4883462735767949
		 2 -4.4929481432689933 3 -4.4645283611581243 4 -4.3983834827747277 5 -4.3043008783231125
		 6 -4.2070780119125599 7 -4.1426120441925409 8 -4.1363594220893729 9 -4.1834705443190963
		 10 -4.2659421504335908 11 -4.354409492839264 12 -4.4151987749779398 13 -4.4291177707726357
		 14 -4.3927897235451407 15 -4.3111934656509883 16 -4.197691787741042 17 -4.0728207112494097
		 18 -3.9617516044257015 19 -3.8916251216639948 20 -3.8861611381448413 21 -3.9500493386123088
		 22 -4.0609278603917307 23 -4.1923905385881435 24 -4.3178926279579324 25 -4.4144413747358993
		 26 -4.4656235100083137;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAX";
	rename -uid "DCB2EB79-498B-C585-8F2F-DBA628F6BC40";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 25.307203827422118 1 27.167792334939321
		 2 29.657470727990816 3 31.566494186684043 4 32.663893052417748 5 33.624671086472105
		 6 35.255723834165643 7 37.18915863380137 8 38.6082417726073 9 39.19076562623512 10 38.65239730570562
		 11 37.040386891698923 12 34.343310093644689 13 31.111589898201952 14 27.354000943746524
		 15 22.413450147312243 16 16.14907583017758 17 9.6773501570027385 18 4.6175146842599215
		 19 4.0160260957752794 20 6.8217355486528266 21 10.365130144205342 22 14.317695357289653
		 23 18.192156037028276 24 21.465139214430575 25 23.845928509700585 26 25.307203827422118;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAY";
	rename -uid "B516E3B5-47F3-2686-BA9D-788B4DA11255";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 25.65073540145066 1 22.264795224819256
		 2 16.941655178525679 3 10.521617089355622 4 4.0340158036727045 5 -1.3002631315671114
		 6 -4.4697178386604071 7 -4.8866077239744818 8 -3.0765086260342875 9 0.017882405452621607
		 10 4.2682273927184111 11 9.317729593151638 12 15.035321911143699 13 21.238744090439816
		 14 27.50669749109068 15 33.137872624819963 16 37.377616758215041 17 39.435822941530567
		 18 39.218918953284039 19 37.667748744150856 20 36.154182624555212 21 35.11592959803265
		 22 34.120062795485843 23 32.757407587774715 24 30.733275665163116 25 28.175162836591632
		 26 25.65073540145066;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftArm_rotate_tempLayer_inputAZ";
	rename -uid "69AF4E8A-441C-B068-1BAD-5F80A169F489";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 30.175113347727372 1 28.199255099132269
		 2 24.674398333837544 3 20.212808459476474 4 15.735496847371818 5 11.684322859440915
		 6 7.7878669178341831 7 4.0429700495074821 8 1.8788834601571882 9 2.0732644385173229
		 10 4.2807437019623658 11 7.9982481265870637 12 12.008251572345864 13 15.427555159028376
		 14 18.055948089006304 15 18.870314830732241 16 17.286023722782229 17 13.861814565203286
		 18 10.949129181972785 19 13.497443676419133 20 19.131931554973555 21 23.456275475554779
		 22 26.689038255487034 23 29.058330708670614 24 30.491488887281751 25 30.908021063204369
		 26 30.175113347727372;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAX";
	rename -uid "478F4F48-4084-402E-570C-06AA849CAED0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -9.061586180780969 1 -10.155681819298342
		 2 -11.20370410708623 3 -11.98250792495371 4 -12.356084989162785 5 -12.275234264891621
		 6 -11.782274772110059 7 -10.9948480755414 8 -10.124369187965641 9 -9.2895009169850606
		 10 -8.439406954647902 11 -7.5040774652737685 12 -6.3592447816584015 13 -5.1860948382552428
		 14 -4.1590245292523074 15 -3.2108579165492102 16 -2.3231485494849795 17 -1.5658821723181455
		 18 -1.0825622220828275 19 -1.2901635848384052 20 -2.1295893496440712 21 -3.194680666685958
		 22 -4.4284189597451684 23 -5.7261824597511728 24 -6.9308353662595819 25 -8.0280384159572762
		 26 -9.061586180780969;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAY";
	rename -uid "7266AB00-4D69-6CD6-33F6-029468D597FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -8.256193820133463 1 -8.0809635878615023
		 2 -7.7669283960055324 3 -7.4302054585321038 4 -7.2334244990636902 5 -7.2780690029984383
		 6 -7.5259328806384751 7 -7.8416678732958722 8 -8.0880831036105594 9 -8.2319031836184635
		 10 -8.2904306156849508 11 -8.254509245291219 12 -8.0649636465176151 13 -7.6919214586089604
		 14 -7.1947063979789263 15 -6.5613095241722963 16 -5.7662243566529767 17 -4.8604889870446204
		 18 -4.107277118678172 19 -4.4530628189014427 20 -5.5587955349851619 21 -6.5487615587736547
		 22 -7.3423278803852341 23 -7.8874855436292579 24 -8.1800688005284439 25 -8.2875758784070683
		 26 -8.256193820133463;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftForeArm_rotate_tempLayer_inputAZ";
	rename -uid "C9CAE003-4F2A-5267-892D-89A9903F820B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 95.345606911818052 1 103.03457234836495
		 2 110.62595962601232 3 116.51030084116699 4 119.43705388370638 5 118.79699383600553
		 6 114.97192793975456 7 109.08786290763064 8 102.81183993517891 9 96.935046205983213
		 10 91.023925014160781 11 84.529943791524417 12 76.476994657939656 13 67.933901233261054
		 14 60.01806411417256 15 52.113125072831238 16 43.859794970680696 17 35.696111720359887
		 18 29.520061685338444 19 32.301094583918527 20 41.898372527699401 21 51.971491543028236
		 22 62.147227164956867 23 71.917181649186446 24 80.520950122394581 25 88.171067883876376
		 26 95.345606911818052;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAX";
	rename -uid "DBD6B51E-496B-BC6A-D25A-709AD8A1E0AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -30.762038453843182 1 -30.680035939031828
		 2 -30.980924958905536 3 -32.78324375943567 4 -35.885626378710661 5 -38.882644874892414
		 6 -40.918578137306 7 -41.58929342453952 8 -40.216757304795252 9 -36.415268047568404
		 10 -30.633387639167651 11 -23.304672051961358 12 -14.828638233444662 13 -5.4926082071469144
		 14 4.6668649022908086 15 9.7920157987683378 16 3.1416103731970919 17 -7.2868183625722436
		 18 -15.161890064542353 19 -20.922271100236724 20 -24.55890116373628 21 -25.84009091052949
		 22 -26.49343013370779 23 -27.908287666586986 24 -29.352703037418202 25 -30.378028608934358
		 26 -30.762038453843182;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAY";
	rename -uid "434D7EA5-43BD-A461-E795-338AB2253FB7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 27.445949803009871 1 24.849974502242222
		 2 18.770323856911858 3 11.879906898045045 4 8.0142733651437812 5 8.0688478145689011
		 6 9.9619421533901775 7 11.149950654828119 8 11.779684974347248 9 13.611515645239773
		 10 16.554178909105104 11 20.544326306538409 12 25.548525161649078 13 31.513249247292453
		 14 38.274929993844289 15 42.560519279455569 16 41.191707846857199 17 37.428292533311712
		 18 35.342243214879453 19 34.530288437550311 20 34.474406882612016 21 34.597455466752514
		 22 33.870195774259003 23 32.112409547896519 24 29.986697236458145 25 28.196499843391766
		 26 27.445949803009871;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftHand_rotate_tempLayer_inputAZ";
	rename -uid "B1270DC2-4C68-FB48-4412-F6943D1DB712";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -16.547330097101536 1 -16.271852614257302
		 2 -15.015941486141687 3 -12.252332326127769 4 -7.0817512274814813 5 -0.67651340288179496
		 6 4.584767402673247 7 6.7618723051158165 8 6.9902464901526882 9 7.5851842253478585
		 10 8.4559559412454934 11 9.6096090612609526 12 11.204214996414011 13 13.611491248301991
		 14 17.498456566554943 15 20.117860692865591 16 16.568248885961417 17 11.379273532252434
		 18 7.8470030675190987 19 5.3190503571462866 20 3.6959800603648056 21 3.1147243034410952
		 22 0.99536480932876936 23 -3.9784513486156241 24 -9.7866011458873885 25 -14.564133441620541
		 26 -16.547330097101536;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAX";
	rename -uid "5569E11C-4432-E893-46B7-56838947F1FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -16.86917085524944 1 -15.372276436349184
		 2 -13.343098978415396 3 -11.235404534908602 4 -9.338769026539266 5 -7.7051671350302424
		 6 -6.2149720388178764 7 -4.6372245093906121 8 -2.7736672878398179 9 -0.61249932262196716
		 10 1.7759945697287884 11 4.3344228834664875 12 6.9940856736782688 13 9.5596769079065353
		 14 12.15826144006031 15 14.612433809433142 16 16.517169724933538 17 16.942402902611796
		 18 15.109864983618008 19 10.887188141423531 20 4.8364452630149639 21 -1.9172301276366719
		 22 -8.1765588123289952 23 -13.038027225771046 24 -16.038137603712865 25 -17.22895936732812
		 26 -16.86917085524944;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAY";
	rename -uid "BE759A1F-44C6-E185-4DD9-3AA4DA570703";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.427920643896845 1 -3.5969322254797103
		 2 -2.7922896617957624 3 -0.95462672440597929 4 1.9094666398113551 5 5.6791885446987322
		 6 10.077384389243567 7 14.658439772153262 8 18.958138982205032 9 22.675631278306028
		 10 25.674659431755529 11 27.944974951727449 12 29.572413227977382 13 30.687248821840363
		 14 31.18005428088604 15 30.89820315954622 16 29.204054878694976 17 26.086869063854003
		 18 22.383386840492513 19 18.749955869432089 20 15.386513327420625 21 12.033922464065425
		 22 8.414781970413852 23 4.5861697220512783 24 0.93405048571472415 25 -1.9352007158007685
		 26 -3.427920643896845;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightArm_rotate_tempLayer_inputAZ";
	rename -uid "8017F306-4EA6-5BF9-3939-25B9C7DE2B49";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -13.080205264372056 1 -12.814297057017674
		 2 -12.138492748732116 3 -10.881695192721212 4 -8.8444932855578386 5 -6.085488299859299
		 6 -2.9505658458230455 7 0.33240088680964647 8 3.4877440587652297 9 6.2060585240042849
		 10 8.201691747431191 11 9.2906869938164434 12 9.4676827849028005 13 8.9606214680585801
		 14 8.1724473311503516 15 7.6145867475431546 16 7.8836795354380751 17 8.6029578982767632
		 18 8.8367378689770728 19 8.0794245828277393 20 6.0563081633235916 21 2.7488231448712104
		 22 -1.4324325116736358 23 -5.7829451840607247 24 -9.5744116091625209 25 -12.184728896273354
		 26 -13.080205264372056;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAX";
	rename -uid "82E1A22A-4D89-E5F1-3B77-7EBB2FD15B24";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.0636382654669028 1 -7.0793328387540004
		 2 -7.1395284057373072 3 -7.2487518356479104 4 -7.3968656289703301 5 -7.5262225157608622
		 6 -7.5450418972054605 7 -7.399447424313867 8 -7.0611339066145726 9 -6.5312482161918988
		 10 -5.8414576741568611 11 -5.0529323981073349 12 -4.2524467525106013 13 -3.5450664995657815
		 14 -3.0451669195553963 15 -2.859118555009025 16 -3.2037067847131748 17 -4.0788450993220211
		 18 -5.2087819693888653 19 -6.3279082571557739 20 -7.2277804665426002 21 -7.7833836978800566
		 22 -7.9639018473094279 23 -7.8291077649910363 24 -7.5139985034144878 25 -7.1993014441153544
		 26 -7.0636382654669028;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAY";
	rename -uid "421F496F-4594-D674-6945-D3B4E9D17526";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.5176477924111431 1 -7.5199461057334096
		 2 -7.5285524836578954 3 -7.5430208856676106 4 -7.5603002012466778 5 -7.5732042296247863
		 6 -7.5749057312917953 7 -7.5605602486874304 8 -7.5172681146055389 9 -7.4208662079145258
		 10 -7.2411434668817982 11 -6.9551267007826505 12 -6.5665582766823052 13 -6.1273344628502429
		 14 -5.7523150823299254 15 -5.596899827959553 16 -5.8777181585688405 17 -6.4677479999708138
		 18 -7.0188561091128632 19 -7.3743938824927753 20 -7.540345539462554 21 -7.5928575117581971
		 22 -7.6019024945429363 23 -7.5955108054132836 24 -7.5720645600101042 25 -7.536641352933735
		 26 -7.5176477924111431;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightForeArm_rotate_tempLayer_inputAZ";
	rename -uid "040416D0-4433-202D-A121-67A460A299B6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 76.540406386775317 1 76.649953571782149
		 2 77.070009652253759 3 77.831042264555819 4 78.861173974412722 5 79.759118928839271
		 6 79.889825866649531 7 78.879007846048495 8 76.522794025542524 9 72.801889580681078
		 10 67.877096808236942 11 62.082135520062266 12 55.936839753800214 13 50.189546001018385
		 14 45.879787556858773 15 44.208839821590601 16 47.272945286389096 17 54.55842829235462
		 18 63.244897633051828 19 71.361222248264653 20 77.684891041293596 21 81.541052144525281
		 22 82.789552026223475 23 81.857193448411635 24 79.674409498117967 25 77.486685251810812
		 26 76.540406386775317;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAX";
	rename -uid "38FA24F9-4535-D0D6-E6ED-C48E73A6FAF2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 86.371534988859423 1 97.458570612217841
		 2 107.40385226060575 3 115.41488889346881 4 120.56249482713419 5 121.5315731362461
		 6 116.9834644396289 7 106.1071385905833 8 92.027821891090213 9 78.314638583086094
		 10 65.657018776040545 11 53.647889591546104 12 42.19600206076759 13 31.850200634432461
		 14 23.971422284660509 15 19.55323655967139 16 19.295964604158943 17 21.805545212088983
		 18 24.935742946291167 19 28.462837495989064 20 32.634156647308529 21 38.021075562013706
		 22 44.991214194163597 23 53.587957881960172 24 63.672192250778885 25 74.822508707485099
		 26 86.371534988859423;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAY";
	rename -uid "0DA6A3E7-42B6-9967-175A-42A746FE86FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 8.7197517795469839 1 0.95757325761877177
		 2 -8.5522636678537918 3 -18.563614273226037 4 -27.951966924254727 5 -35.71261194096892
		 6 -40.674845194341351 7 -40.579395784744825 8 -34.557213232640315 9 -24.273652108839659
		 10 -12.157177856993087 11 -0.5621673161095222 12 8.7835190456895873 13 15.214632901403681
		 14 18.989650436809239 15 21.109244529825272 16 22.5080851262287 17 23.264582927912045
		 18 23.478890434196337 19 23.475215583029502 20 23.379712092815335 21 23.061358564579681
		 22 22.223596202537777 23 20.588086784080389 24 17.977100155938867 25 14.178383786813002
		 26 8.7197517795469839;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightHand_rotate_tempLayer_inputAZ";
	rename -uid "3DBBEABC-4E5B-818F-1524-DB9B0F2B953B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -41.269192344059348 1 -36.94389329144547
		 2 -33.930648992398041 3 -31.834656116629809 4 -29.495845996225917 5 -25.246107661296882
		 6 -17.577992700452448 7 -6.8399893613138047 8 3.181983396506634 9 9.183688743810249
		 10 10.358322374370928 11 7.0781564507800105 12 0.22785247381521775 13 -8.7265430487267786
		 14 -17.79074680678157 15 -25.147384361406623 16 -30.095312870992309 17 -34.104617881646135
		 18 -38.716834965864649 19 -43.272388524709804 20 -47.276969416970914 21 -50.18257049271503
		 22 -51.547063923807052 23 -51.172008753577771 24 -49.124601096374249 25 -45.719581776365999
		 26 -41.269192344059348;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAX";
	rename -uid "D97A8321-41B8-9FE2-5907-108004477108";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -61.122924424357571 1 -56.776627559575736
		 2 -45.549773275000128 3 -29.500132105733798 4 -10.14131827632364 5 10.437149672389095
		 6 29.755184593084834 7 45.879743656709117 8 57.065958194400906 9 61.373649147691523
		 10 61.391075810990237 11 60.985531327819388 12 60.038088248299637 13 58.389351279787654
		 14 55.986533099668641 15 52.866097517562913 16 45.456737223663104 17 31.410455793013593
		 18 12.602287178519466 19 -8.452932967579649 20 -28.572212528849995 21 -44.902188955308091
		 22 -55.328610183301109 23 -60.436471351652322 24 -62.011138541059111 25 -61.692587192642257
		 26 -61.122924424357571;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAY";
	rename -uid "38F0B2EB-46CE-9A8E-7AAB-81A3F32FB1E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.4763790189967332 1 -1.6078928897552145
		 2 2.0414269016779731 3 7.0545735063655091 4 10.166836510741048 5 9.255773304753685
		 6 6.0265385618156255 7 2.3042900413620999 8 -0.57545750096664849 9 -2.7651577854917928
		 10 -5.0113639301390913 11 -7.1559266113236939 12 -9.0835958548706746 13 -10.620936712709337
		 14 -11.906324822781169 15 -13.247108564613209 16 -15.59827163463337 17 -18.9448435772054
		 18 -21.50722232348501 19 -21.783876789391986 20 -19.088998726766683 21 -14.572760293121432
		 22 -10.553303421946472 23 -7.8610886751147682 24 -6.1084976383028176 25 -4.7608505898323132
		 26 -3.4763790189967332;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Head_rotate_tempLayer_inputAZ";
	rename -uid "9AC317BC-4AE8-17C8-4293-43ADF57C078B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -50.715004028639179 1 -54.536257802018255
		 2 -59.068978268196084 3 -60.964184204276322 4 -58.797767146677351 5 -55.292268206218566
		 6 -53.554627490613349 7 -54.615184283645803 8 -57.877643091992681 9 -62.040367564282114
		 10 -66.08846298467509 11 -69.647739651689008 12 -72.305274866554299 13 -73.660655037377225
		 14 -73.988554492227692 15 -73.826232028842327 16 -72.270340265998968 17 -68.202996439751445
		 18 -61.675062619287665 19 -53.832631825600437 20 -46.890825798432836 21 -42.912563795685138
		 22 -42.158624420807833 23 -43.433044862874148 24 -45.66695688209262 25 -48.229294429669451
		 26 -50.715004028639179;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAX";
	rename -uid "0161052A-41CB-7F20-762F-A5B19CF0658A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 14.397809719293935 1 13.946661482492427
		 2 10.288854555455641 3 4.6323222376354938 4 2.1447399741387736 5 2.9627489463052554
		 6 4.5595640959285966 7 6.5174852902617761 8 8.3973748461444 9 9.8630091468586851
		 10 10.757532273080392 11 11.078634704299734 12 10.893352211820034 13 10.248136750222036
		 14 8.3754174065349201 15 5.5129436696060417 16 2.6501254619817027 17 0.54460264810557868
		 18 -0.2674864564961989 19 0.10046507659864674 20 1.1575226408957866 21 2.8915609516559151
		 22 5.2778237492118416 23 8.153943006911101 24 11.105474785324914 25 13.45216238712961
		 26 14.397809719293935;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAY";
	rename -uid "0B138ABB-4F55-8B05-A00F-CF843A8B492E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -15.40565527134706 1 -19.212776900341272
		 2 -26.287055249672747 3 -30.472474544680878 4 -31.273396554345112 5 -30.687601246375738
		 6 -29.711198528699075 7 -28.270085913915132 8 -26.397496308763021 9 -24.267492799097081
		 10 -22.129292700149822 11 -20.212233663936242 12 -18.672222211693885 13 -17.579304916232726
		 14 -15.804712251583561 15 -12.968582845783052 16 -9.7856368123261284 17 -7.1700616397721131
		 18 -6.090354900575198 19 -6.5128854057354451 20 -7.6457120853976921 21 -9.2782861399095644
		 22 -11.147995930373074 23 -12.931058366326097 24 -14.317022787598457 25 -15.139171790481869
		 26 -15.40565527134706;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftToeBase_rotate_tempLayer_inputAZ";
	rename -uid "43BEF189-4E94-196A-0B48-03B5B2367004";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 22.051283828563928 1 28.389014230739708
		 2 42.481079865848244 3 55.644022659996203 4 60.641744874510842 5 58.882325280148649
		 6 55.421416035860759 7 50.904228093865264 8 46.0362766483426 9 41.444949056447015
		 10 37.58173397133487 11 34.725185280810436 12 33.057341920165186 13 32.762217373365011
		 14 33.951785239993569 15 35.972294286029673 16 38.038371370157705 17 39.574067228307655
		 18 40.172314578960574 19 39.638266142382946 20 38.148007613884552 21 35.816343095737629
		 22 32.772998543087752 23 29.276131500154307 24 25.8149507774787 25 23.124382049071176
		 26 22.051283828563928;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAX";
	rename -uid "8A632470-4555-B1E9-5465-E6AA560701AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 6.1520001197843932 1 8.5011175055624157
		 2 13.145733385959327 3 18.090932714084992 4 21.273257201877588 5 22.327108126694196
		 6 21.803421411590371 7 20.175002514694206 8 17.319217330955404 9 13.456336956210214
		 10 9.5135709027536777 11 5.3510885348740329 12 4.202166199112698 13 4.5813843194510326
		 14 4.5700248184277941 15 4.5364097559486138 16 4.4821014043468672 17 4.4102507232244523
		 18 4.3265910708343673 19 4.240702231340272 20 4.1677081523673127 21 4.1306518908141534
		 22 4.1631594376404903 23 4.3124667054141224 24 4.641137729891482 25 5.2263363564077299
		 26 6.1520001197843932;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAY";
	rename -uid "D4046FD3-45A6-27EB-7F22-2AB47C8D1146";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -10.385728710105687 1 -13.534159254641134
		 2 -16.338491441007434 3 -16.896612895787836 4 -16.122774508824595 5 -15.630904746138517
		 6 -15.883423778671348 7 -16.422352156784211 8 -16.693555012264667 9 -15.868852827044336
		 10 -13.349737847454611 11 -6.6778647550850279 12 1.4846621940541793 13 4.7918697676177544
		 14 4.7122321377937055 15 4.4753414195374086 16 4.0803526429137014 17 3.522002825507526
		 18 2.7910510364835037 19 1.8750650553804602 20 0.7595186136395885 21 -0.57053883260674298
		 22 -2.1272163264653727 23 -3.9144404902936598 24 -5.9199246960485432 25 -8.1037459012786268
		 26 -10.385728710105687;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightToeBase_rotate_tempLayer_inputAZ";
	rename -uid "A25B6E39-4C03-8C42-1B44-A3924593607C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 64.05547487356543 1 57.01845389120529
		 2 45.453574964061133 3 33.914637084798322 4 26.050876422091637 5 23.225274765433223
		 6 24.632085604614954 7 28.708617231253267 8 35.300109880658965 9 43.837708612672671
		 10 52.890190814484164 11 65.137504929778189 12 75.911871211404446 13 79.977126875800323
		 14 79.934404921297599 15 79.797561822662686 16 79.551071498420356 17 79.175547068903512
		 18 78.647391594893548 19 77.937875679871098 20 77.012312492275981 21 75.829089665574344
		 22 74.338684082229705 23 72.483139980771398 24 70.196808654053385 25 67.409467628002119
		 26 64.05547487356543;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAX";
	rename -uid "FD3EE7CA-4F58-411F-01A5-35B04E818CCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 6.9922821238927604 1 6.9923158631463807
		 2 6.9923062721649663 3 6.9922943794430594 4 6.9922834769208722 5 6.9922700025271443
		 6 6.9922824225381897 7 6.9922630626830564 8 6.9922818578860646 9 6.9922810082168576
		 10 6.992254845499108 11 6.992265905135941 12 6.9922866782978979 13 6.9922575766070656
		 14 6.9922745366541159 15 6.9922751884353556 16 6.9922626873782212 17 6.9922839298208279
		 18 6.992255782322947 19 6.9922990393497138 20 6.9922801302787363 21 6.9922889201869616
		 22 6.9922758100665954 23 6.992262882199193 24 6.9922919086097304 25 6.9922848541744109
		 26 6.9922821238927604;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAY";
	rename -uid "B9AFE7DF-46EE-9D66-563D-189C38597164";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -5.3593815520805324 1 -5.3593658623771363
		 2 -5.3593938106672487 3 -5.3593760776255337 4 -5.3593670150888428 5 -5.3593694131446075
		 6 -5.3593870135156472 7 -5.359379451228266 8 -5.3594072183949546 9 -5.3593831040661311
		 10 -5.3593328085629892 11 -5.3593633207316795 12 -5.3593798541710225 13 -5.359376679480472
		 14 -5.3593933060751109 15 -5.35937716557366 16 -5.3593974435400895 17 -5.3593961085741926
		 18 -5.3593949388180757 19 -5.3593532050005566 20 -5.3593585854028571 21 -5.3593579564120262
		 22 -5.359388504535155 23 -5.3593987340104521 24 -5.3593664939178076 25 -5.3593932059250147
		 26 -5.3593815520805324;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulder_rotate_tempLayer_inputAZ";
	rename -uid "3A34A17E-45C4-A931-7528-429D8E7C2967";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -13.82642736673403 1 -13.826392705611415
		 2 -13.826380843555148 3 -13.82641048570426 4 -13.826423510126071 5 -13.826434380081118
		 6 -13.826413274853202 7 -13.826397114346824 8 -13.826415224758023 9 -13.826422025146549
		 10 -13.826394663804647 11 -13.826415594699657 12 -13.826422885056916 13 -13.826402225293425
		 14 -13.826410758756712 15 -13.826426051033156 16 -13.826434076045667 17 -13.826420811773533
		 18 -13.826413907427998 19 -13.826419642438651 20 -13.826419996294586 21 -13.826392410079288
		 22 -13.826419722977198 23 -13.8264271330341 24 -13.826379930204775 25 -13.826420159390164
		 26 -13.82642736673403;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAX";
	rename -uid "F75A4CE1-49E6-23DE-CF30-B9BD22C73B09";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -0.021121157804303223 1 -0.021082301983323379
		 2 -0.02106564566335067 3 -0.021103263983246034 4 -0.021119458023819145 5 -0.021137386441856053
		 6 -0.021146034302753729 7 -0.021132051857532363 8 -0.021114722827234797 9 -0.021116323310268185
		 10 -0.02112798411711388 11 -0.021121860244033629 12 -0.021119171527494613 13 -0.021139878592526071
		 14 -0.021115148013939974 15 -0.02112389646367285 16 -0.021126118629178646 17 -0.021139073713444707
		 18 -0.021147033877142243 19 -0.021112189289894681 20 -0.021133556731083216 21 -0.021101889056954388
		 22 -0.021128733368050219 23 -0.021137894340583371 24 -0.021097332799620658 25 -0.021133395450628825
		 26 -0.021121157804303223;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAY";
	rename -uid "C86FAFF2-411C-1EF7-BE46-FDB8A9A63DF6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -13.621819180649346 1 -13.621831736209904
		 2 -13.621854202739524 3 -13.621836797938682 4 -13.62182573444386 5 -13.621813805041949
		 6 -13.621831810206553 7 -13.621826725633007 8 -13.621866558351512 9 -13.621835300119836
		 10 -13.621802805307063 11 -13.621803578898142 12 -13.621816041672565 13 -13.621818694434788
		 14 -13.621838759122282 15 -13.621826203976969 16 -13.621826626018507 17 -13.621839846947836
		 18 -13.621834633266003 19 -13.621806204105948 20 -13.621813224971191 21 -13.621804853145239
		 22 -13.62183943553881 23 -13.621834998032529 24 -13.621821756598926 25 -13.621842858161655
		 26 -13.621819180649346;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_RightShoulder_rotate_tempLayer_inputAZ";
	rename -uid "B5C261A0-4FBF-7072-B78A-708E3E69D6EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 10.568441127496676 1 10.568440930848434
		 2 10.568449542944109 3 10.568438193924651 4 10.568455249864478 5 10.568446176199172
		 6 10.568451005222673 7 10.568466549633921 8 10.568439811728963 9 10.56844435958835
		 10 10.568483490680066 11 10.568460362516712 12 10.568443891212286 13 10.568468861454399
		 14 10.568440573416886 15 10.568441250955715 16 10.568459646697571 17 10.568457454615661
		 18 10.568468079358853 19 10.568438757487016 20 10.568437935611533 21 10.568443503583751
		 22 10.568444659561473 23 10.568452698262428 24 10.568445445790275 25 10.568453046471136
		 26 10.568441127496676;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAX";
	rename -uid "59710DFB-427A-AD3B-AE05-10ABB9707EA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.6964938341057734e-006 1 -1.2904505527433569e-006
		 2 5.5398776736787664e-006 3 0 4 -1.3600575669106507e-005 5 0 6 -7.2357711877867954e-006
		 7 3.2663781385565806e-006 8 -6.3763498660278698e-005 9 -1.2376201281737341e-005 10 3.3863728477817036e-006
		 11 2.5182168065330078e-006 12 1.7679076577277161e-006 13 -4.2080587593140972e-006
		 14 0 15 -3.0773280530053153e-006 16 -5.2184498184001959e-006 17 -4.7148862975537818e-006
		 18 5.7516932679670335e-006 19 -3.4254012101810895e-006 20 1.4060732676282031e-006
		 21 7.2403156777253947e-006 22 2.0692558511286803e-006 23 5.4435889222338193e-006
		 24 -5.3530383518867682e-006 25 -3.8139192669416201e-006 26 -7.6964938341057734e-006;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAY";
	rename -uid "74F4713E-43AE-96A0-AA9F-E88E87AB8C0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -6.2019397961506079e-005 1 2.2971307205280268e-006
		 2 5.3936225818734841e-006 3 -1.6514318285746373e-006 4 2.0338961248515553e-006 5 0
		 6 -3.791516639546772e-022 7 3.5683715504047716e-006 8 0 9 8.6449750976182212e-005
		 10 -1.6243237631808094e-005 11 -5.6062999366418178e-006 12 0 13 0 14 0.0001268255537353957
		 15 -7.4888313945184023e-006 16 1.9758507231793102e-006 17 -2.3730475951457781e-006
		 18 -2.9719525540162344e-006 19 -1.9134720421729057e-006 20 -1.7310887855688101e-006
		 21 5.8231185924634692e-006 22 0 23 3.0416371690632736e-006 24 -9.8950206708557233e-005
		 25 3.6526878115325077e-006 26 -6.2019397961506079e-005;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Neck_rotate_tempLayer_inputAZ";
	rename -uid "F9840EBD-4EF8-D785-C6DA-D5AA25CEB935";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 30.93454632922839 1 30.934690481466468
		 2 30.934846974667646 3 30.934723076108735 4 30.934643593696666 5 30.934672888991148
		 6 30.934551733339511 7 30.934668499265531 8 30.934653030442302 9 30.934730980361717
		 10 30.934884372794915 11 30.934832285779752 12 30.93463029485844 13 30.934692936864874
		 14 30.934670746961597 15 30.935138058878913 16 30.934677332370068 17 30.935156171256818
		 18 30.934756761778402 19 30.934638551561733 20 30.934660875196535 21 30.935444582117736
		 22 30.934624179557996 23 30.934681238964814 24 30.934647275904062 25 30.934737671659864
		 26 30.93454632922839;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAX";
	rename -uid "02ABC062-4AA0-385A-C3D5-2AA91000DA3C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 0.62317131696962158 1 3.2222748952322249
		 2 6.1462379025201477 3 9.1430107761307156 4 11.955472921893261 5 14.311662537644882
		 6 15.922236172296968 7 16.487255006358421 8 16.022074573200037 9 14.808791312888404
		 10 12.961576808172998 11 10.569230648000861 12 7.8084425525875236 13 4.8729250522069387
		 14 1.8762813579647055 15 -1.0461237176389537 16 -3.7606093529240332 17 -6.1275558403368118
		 18 -7.995961943409073 19 -9.2011923334228065 20 -9.5670304044787997 21 -9.047903843586047
		 22 -7.8245445379235861 23 -6.0963477539426245 24 -4.0181796978208046 25 -1.7322661216662216
		 26 0.62317131696962158;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAY";
	rename -uid "AEA4E7BB-4CFF-BDAE-701B-16BE884EB4A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.9251435128417311 1 -6.8267732447329603
		 2 -5.0099738097062536 3 -2.6980582919213831 4 -0.10469970212915204 5 2.5661911853026895
		 6 5.1153647371326194 7 7.3374342243858885 8 9.1312667480377669 9 10.480825445246797
		 10 11.298788492168656 11 11.488942174232657 12 10.995104195849608 13 9.8879782734053041
		 14 8.3528820667918229 15 6.5095599800180315 16 4.4697689740267341 17 2.3366191030488652
		 18 0.20692510005244119 19 -1.8234707364347298 20 -3.6519431533605968 21 -5.2109245165078244
		 22 -6.5223513674310807 23 -7.544944657437382 24 -8.1599132675745008 25 -8.305128107992152
		 26 -7.9251435128417311;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine1_rotate_tempLayer_inputAZ";
	rename -uid "C87BB063-4DC9-2F1F-B1C9-C682FC6D2C6A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -9.0496303874135435 1 -9.1491260225279145
		 2 -9.1413112281885898 3 -8.9739852331287242 4 -8.6413150670276568 5 -8.1946113018508449
		 6 -7.7407268294559053 7 -7.4251588819721954 8 -7.3398095959723237 9 -7.467389703276031
		 10 -7.7616888795605377 11 -8.1396889921836539 12 -8.489241113430678 13 -8.7229685754466519
		 14 -8.8022928623999501 15 -8.7188125926559845 16 -8.4961101918705939 17 -8.1853419886380756
		 18 -7.8595368766398037 19 -7.6046722774612237 20 -7.5060095123496398 21 -7.6010155869857225
		 22 -7.8479371643601716 23 -8.185410733363744 24 -8.543498565354577 25 -8.8518426733201618
		 26 -9.0496303874135435;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAX";
	rename -uid "6404A3C8-4501-A480-8546-AAAD88218857";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 1.2598982449896945 1 3.7601915063518088
		 2 6.5263835410283288 3 9.3275547966864067 4 11.926370820468946 5 14.068014642135367
		 6 15.477595064808646 7 15.868539398338923 8 15.261379294734477 9 13.93907928038826
		 10 12.024300234706219 11 9.6161786059785079 12 6.8983493051298552 13 4.0592977304164357
		 14 1.196508910587168 15 -1.5662593350032574 16 -4.1064133861062038 17 -6.2941686760124886
		 18 -7.9870112722382478 19 -9.0278359829834507 20 -9.247694780697099 21 -8.6054218612330615
		 22 -7.2791785034976506 23 -5.4717636454230441 24 -3.348343508452027 25 -1.0568644236324407
		 26 1.2598982449896945;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAY";
	rename -uid "4C42B08E-4AFD-1D70-0F4D-9BAEE5D43058";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.8496257064582977 1 -6.5468383544049473
		 2 -4.5026526205724968 3 -1.960321494497554 4 0.84637778508060857 5 3.693013352096258
		 6 6.3592003403315349 7 8.6181731203205469 8 10.370650148330087 9 11.621956161008242
		 10 12.293155157877534 11 12.29450387419686 12 11.583472521002831 13 10.245929291765179
		 14 8.4760981752947639 15 6.4047788526414591 16 4.1544286095642855 17 1.8392900212346051
		 18 -0.43216104123979071 19 -2.551648220266217 20 -4.4032870558124451 21 -5.9162955794543164
		 22 -7.1264938764785351 23 -8.008207502870949 24 -8.4552333445079224 25 -8.4169922656572247
		 26 -7.8496257064582977;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine2_rotate_tempLayer_inputAZ";
	rename -uid "9263C0C5-4B23-D15F-5474-2F882768F1A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -9.092880529321123 1 -9.1720157054723899
		 2 -9.1290153412280741 3 -8.9181400647125031 4 -8.5419552263162064 5 -8.0610288817305396
		 6 -7.5915166789704269 7 -7.2862766380843009 8 -7.2344535504188974 9 -7.4076275790540418
		 10 -7.749679094716722 11 -8.1678075243514776 12 -8.541381405089723 13 -8.7806867632698822
		 14 -8.8506378921714859 15 -8.7469769863519087 16 -8.4983107019433035 17 -8.161415723295141
		 18 -7.8148866176143681 19 -7.549941606023487 20 -7.4553923586990907 21 -7.5680713241806563
		 22 -7.8405831244955433 23 -8.2044623776304171 24 -8.5826233366014293 25 -8.8998299667355099
		 26 -9.092880529321123;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAX";
	rename -uid "19C4847F-4B53-F8BE-1471-1BA2E2C69524";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -2.6379308110341784 1 0.18792401590124655
		 2 3.6102096379040431 3 7.3011616604882308 4 10.92855959124191 5 14.152442274180428
		 6 16.626566765781668 7 18.003607659825448 8 18.272345772665695 9 17.694251864144611
		 10 16.341778011393838 11 14.253011221200396 12 11.555649816537112 13 8.4440723897067986
		 14 5.0923260006940998 15 1.6733832918996576 16 -1.6406282035518209 17 -4.6741347943847957
		 18 -7.244732109856038 19 -9.1610867175380779 20 -10.222940421320189 21 -10.367191361285162
		 22 -9.7730371587350007 23 -8.6082395276407624 24 -6.9645298200812817 25 -4.9416330826229764
		 26 -2.6379308110341784;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAY";
	rename -uid "DDB24B2D-4885-32CB-B4C8-11B1E8D9DE26";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -7.5016585929877264 1 -7.5434167673136239
		 2 -7.0577927478962135 3 -6.1408245001279562 4 -4.8785562772155355 5 -3.3480155592507264
		 6 -1.6244239011817843 7 0.20784906941529327 8 2.0402099100358906 9 3.7482201408700333
		 10 5.2116248206596349 11 6.3149191819389383 12 6.9452529524547684 13 7.0953423902801145
		 14 6.8890464805246996 15 6.3777332323600575 16 5.6044085368889593 17 4.6027544543074317
		 18 3.399040243548614 19 2.0168268074697839 20 0.48390485089549767 21 -1.1524285726737591
		 22 -2.8400859510877514 23 -4.4637529257725852 24 -5.8553535490055824 25 -6.9031316673651713
		 26 -7.5016585929877264;
	setAttr ".roti" 2;
createNode animCurveTA -n "Character1_Ctrl_Spine3_rotate_tempLayer_inputAZ";
	rename -uid "097AF7A0-4BA9-F344-4A3E-698E381573A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -8.8334851181627698 1 -8.9692857476971994
		 2 -9.0948915928762322 3 -9.1503732271855611 4 -9.0973194840289899 5 -8.9325611793247983
		 6 -8.6939505048323884 7 -8.4567053256311944 8 -8.2994396696887218 9 -8.2495675655893166
		 10 -8.3004987669924528 11 -8.4155890385804781 12 -8.5383283458010819 13 -8.6202808494545398
		 14 -8.6326105902112626 15 -8.5660889913002709 16 -8.4296121342376118 17 -8.2482254483589816
		 18 -8.060304913831402 19 -7.9130168692060501 20 -7.8549888485038721 21 -7.9090623271692291
		 22 -8.0516210154857877 23 -8.2516443581221957 24 -8.4736026123093993 25 -8.6793673027832359
		 26 -8.8334851181627698;
	setAttr ".roti" 2;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateX_tempLayer_inputA";
	rename -uid "BE19FBDA-4144-A323-300A-76A308FF9D45";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 7.9302978515625 1 7.9236693382263184 2 7.8265433311462402
		 3 7.5990066528320313 4 7.2796192169189453 5 6.9716758728027344 6 6.7151031494140625
		 7 6.5058212280273437 8 6.3552532196044922 9 6.2752437591552734 10 6.2452259063720703
		 11 6.0056934356689453 12 5.7944397926330566 13 5.9118709564208984 14 6.2689599990844727
		 15 6.6698713302612305 16 7.0691680908203125 17 7.4440312385559082 18 7.7973251342773437
		 19 8.1121578216552734 20 8.3268871307373047 21 8.4115619659423828 22 8.3681545257568359
		 23 8.246973991394043 24 8.0958213806152344 25 7.9700946807861328 26 7.9302978515625;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateY_tempLayer_inputA";
	rename -uid "FCB7012A-4346-AEA7-FF3D-C7BCCEC27A21";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 43.742500305175781 1 43.440132141113281
		 2 43.158229827880859 3 42.670711517333984 4 41.974006652832031 5 41.597156524658203
		 6 41.510475158691406 7 41.521190643310547 8 41.61724853515625 9 41.8125 10 42.084091186523438
		 11 42.198463439941406 12 42.413673400878906 13 42.628818511962891 14 42.782707214355469
		 15 42.861812591552734 16 42.885185241699219 17 42.824684143066406 18 42.375980377197266
		 19 42.184684753417969 20 42.350929260253906 21 42.833152770996094 22 43.234607696533203
		 23 43.572925567626953 24 43.863864898681641 25 43.957901000976563 26 43.742500305175781;
createNode animCurveTL -n "Character1_Ctrl_HipsEffector_translateZ_tempLayer_inputA";
	rename -uid "7E2E34C3-4109-C988-A077-138F43987CF9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -15.444307327270508 1 -15.571335792541504
		 2 -15.900260925292969 3 -15.995404243469238 4 -15.756628036499023 5 -15.579677581787109
		 6 -15.479780197143555 7 -15.425508499145508 8 -15.423954010009766 9 -15.462369918823242
		 10 -15.593179702758789 11 -16.371589660644531 12 -17.105300903320312 13 -17.487766265869141
		 14 -17.621494293212891 15 -17.614322662353516 16 -17.524404525756836 17 -17.369482040405273
		 18 -16.950262069702148 19 -16.603548049926758 20 -16.315847396850586 21 -16.009506225585937
		 22 -15.998184204101563 23 -16.057323455810547 24 -15.930572509765625 25 -15.657523155212402
		 26 -15.444307327270508;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAX";
	rename -uid "33885DCB-4B8E-F4A5-8A2E-F6AFEF195730";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -12.135009113528454 1 -14.775338943700707
		 2 -17.316762322758688 3 -19.719434075206195 4 -21.818796575257078 5 -23.246595737337245
		 6 -23.472814585814074 7 -21.882639832815197 8 -18.50753758025008 9 -13.951366748386288
		 10 -8.5720724394753098 11 -2.9525991131530396 12 2.1516088092529939 13 7.0100448665038932
		 14 10.142480309910285 15 12.279104940274202 16 13.638235063112596 17 14.314131653512908
		 18 14.260612336028853 19 13.324402371259401 20 11.292890013508073 21 8.1917477938076058
		 22 4.3143990406481425 23 -0.092356270694616924 24 -4.6517073405957934 25 -8.854145166893348
		 26 -12.135009113528454;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAY";
	rename -uid "33C78F27-409F-339F-E280-D588B48C479F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 36.771236180408579 1 35.400778436696143
		 2 31.566584413220159 3 25.669572813019737 4 18.142427869387635 5 9.4737439300292188
		 6 0.19976937628794617 7 -9.1146230340284387 8 -17.896259901472739 9 -25.585256653140263
		 10 -31.659452188245695 11 -35.654848938438825 12 -37.158782614335962 13 -36.136893419578151
		 14 -33.230217410999025 15 -28.727820595383236 16 -22.87407093052294 17 -15.948301640150724
		 18 -8.2742896261382022 19 -0.21145695083826554 20 7.8608120731843751 21 15.55971818017316
		 22 22.515961127074927 23 28.39054379409416 24 32.888422853605917 25 35.759136991799082
		 26 36.771236180408579;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HipsEffector_rotate_tempLayer_inputAZ";
	rename -uid "AB4712B6-4E56-BDA2-BC1E-6EAB8020D3F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -6.5032652616520163 1 -5.7833982908623396
		 2 -3.9990178472793025 3 -1.8104552407530403 4 0.20830269193372447 5 1.6771360581398134
		 6 2.3890044597953914 7 2.2599057700210596 8 1.3056507116324025 9 -0.33677387962354133
		 10 -2.3504065155148695 11 -4.1920533746369761 12 -5.1681680418615574 13 -5.378227673034087
		 14 -4.1779183968522622 15 -2.3593597547355789 16 -0.42140433634812335 17 1.2378683443364671
		 18 2.3552706960786156 19 2.7850932628222118 20 2.4723999907466987 21 1.4401831684967943
		 22 -0.20193958835929171 23 -2.2310102841474908 24 -4.2853527756410346 25 -5.8792074792738793
		 26 -6.5032652616520163;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "D66496A5-4A3B-474C-6C56-C7B0DAEE8FA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 29.776741027832031 1 28.879409790039062
		 2 28.527957916259766 3 28.504920959472656 4 28.756441116333008 5 29.271665573120117
		 6 29.811399459838867 7 30.101528167724609 8 30.00750732421875 9 29.466238021850586
		 10 28.49481201171875 11 27.201730728149414 12 25.786258697509766 13 24.712148666381836
		 14 24.217597961425781 15 24.266885757446289 16 24.896595001220703 17 26.067287445068359
		 18 27.693655014038086 19 29.455499649047852 20 30.995121002197266 21 32.125095367431641
		 22 32.724113464355469 23 32.746047973632812 24 32.195541381835938 25 31.144382476806641
		 26 29.776741027832031;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "496700FA-4F2F-168A-DE6E-5CAE4D6E4CCF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 37.010269165039063 1 35.313201904296875
		 2 31.06721305847168 3 26.006902694702148 4 21.714887619018555 5 18.178384780883789
		 6 14.753273010253906 7 11.527475357055664 8 8.5901737213134766 9 6.0381717681884766
		 10 3.9982013702392578 11 2.6238288879394531 12 2.0847873687744141 13 2.6541252136230469
		 14 4.3791036605834961 15 6.8616323471069336 16 9.8029279708862305 17 13.099352836608887
		 18 16.768577575683594 19 20.759010314941406 20 24.780780792236328 21 28.492904663085938
		 22 31.634998321533203 23 34.069118499755859 24 35.768089294433594 25 36.750953674316406
		 26 37.010269165039063;
createNode animCurveTL -n "Character1_Ctrl_LeftAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "20BCEBEE-4786-24DF-6435-0B94CFE94AEB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -6.6260919570922852 1 -0.70334339141845703
		 2 3.8563346862792969 3 8.0132541656494141 4 11.129909515380859 5 12.062321662902832
		 6 10.563902854919434 7 7.8741483688354492 8 4.2129669189453125 9 -0.26335906982421875
		 10 -5.4374904632568359 11 -11.218930244445801 12 -17.547239303588867 13 -24.331544876098633
		 14 -30.314413070678711 15 -35.179222106933594 16 -38.970848083496094 17 -41.741966247558594
		 18 -43.501125335693359 19 -44.057662963867188 20 -42.908164978027344 21 -39.955295562744141
		 22 -35.446968078613281 23 -29.589944839477539 24 -22.625274658203125 25 -14.858070373535156
		 26 -6.6260919570922852;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "35CB6BF3-4314-800C-57E7-049C604EACF4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -8.5474006671026483 1 -6.0293534386954475
		 2 -1.1285648655637548 3 1.8857325178643516 4 0.84653943425814582 5 -3.1560173277749111
		 6 -8.0515687291947504 7 -13.429334460323036 8 -18.812005666527185 9 -23.734789739668766
		 10 -27.824434375132654 11 -30.831490772516119 12 -32.618259902285232 13 -33.904201597526118
		 14 -33.478269823426302 15 -31.81394247824328 16 -29.327860437413442 17 -26.843607664604924
		 18 -24.959669793208498 19 -23.834939962224404 20 -22.886579762350369 21 -21.287511823411482
		 22 -18.715351333393198 23 -15.423441491023446 24 -12.086739257199945 25 -9.538726307196578
		 26 -8.5474006671026483;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "2F56405B-43F0-643E-0EB7-A7823D1A7AC3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 12.678423489353479 1 12.63871643656833
		 2 12.103137797716771 3 11.047997662801302 4 10.345898888093849 5 10.564189036747406
		 6 11.530023432553552 7 13.331914178235884 8 15.888448955750899 9 18.959361314176959
		 10 22.207532296715016 11 25.263866262560335 12 27.756638857524724 13 30.408975249483049
		 14 32.732654943663348 15 33.661045889121759 16 33.074421396698575 17 31.258859424635975
		 18 28.87086435752213 19 25.868172814345595 20 22.150167264104887 21 18.434572847057172
		 22 15.405142902825666 23 13.497394226133064 24 12.705094508232262 25 12.614405928509612
		 26 12.678423489353479;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "1D97C063-47BC-F72D-6E95-CC992951AF41";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -12.109398603172293 1 -18.075521320146322
		 2 -30.101091167142894 3 -39.901177640611543 4 -43.053547585112092 5 -41.182953687459133
		 6 -37.998816996012273 7 -33.972309115183847 8 -29.568749226980618 9 -25.155652000903807
		 10 -20.948748714703832 11 -17.020608371436754 12 -13.363285935699457 13 -9.2369612582223688
		 14 -2.3045472161360543 15 6.5892384452096033 16 15.643344769691973 17 22.765877996719688
		 18 26.099026678434022 19 24.880240256779608 20 20.300009158747351 21 13.713889577023787
		 22 6.3229792684776127 23 -0.79509437853102727 24 -6.7001808653175079 25 -10.660410351740362
		 26 -12.109398603172293;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateX_tempLayer_inputA";
	rename -uid "B9DC6E9D-4155-93F8-AC9C-AE8C8E7A7A12";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -13.907529830932617 1 -13.209287643432617
		 2 -13.550272941589355 3 -14.81928539276123 4 -16.773288726806641 5 -19.066379547119141
		 6 -21.286666870117188 7 -23.152904510498047 8 -24.491119384765625 9 -25.261808395385742
		 10 -25.520509719848633 11 -25.722908020019531 12 -25.707908630371094 13 -24.403177261352539
		 14 -22.152301788330078 15 -20.057731628417969 16 -18.355094909667969 17 -17.147632598876953
		 18 -16.425926208496094 19 -16.117467880249023 20 -16.111204147338867 21 -16.259195327758789
		 22 -16.407482147216797 23 -16.38279914855957 24 -16.004245758056641 25 -15.162965774536133
		 26 -13.907529830932617;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateY_tempLayer_inputA";
	rename -uid "CCE98F5D-406F-2E1C-32B0-38BDACA2710C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 8.2139530181884766 1 8.6845502853393555
		 2 9.6113662719726563 3 10.923376083374023 4 12.887117385864258 5 15.664486885070801
		 6 19.048076629638672 7 22.662685394287109 8 26.202266693115234 9 29.308263778686523
		 10 31.61614990234375 11 32.758384704589844 12 32.240501403808594 13 30.619014739990234
		 14 27.979690551757813 15 24.32337760925293 16 20.198591232299805 17 16.224082946777344
		 18 12.970058441162109 19 10.810489654541016 20 9.7016849517822266 21 9.3225994110107422
		 22 9.2270603179931641 23 9.0778942108154297 24 8.7452297210693359 25 8.3520774841308594
		 26 8.2139530181884766;
createNode animCurveTL -n "Character1_Ctrl_RightAnkleEffector_translateZ_tempLayer_inputA";
	rename -uid "84C7BC47-4F58-6E12-49EC-4480349A5B7F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -27.278831481933594 1 -32.932182312011719
		 2 -37.579219818115234 3 -41.438060760498047 4 -44.208335876464844 5 -45.145271301269531
		 6 -44.088737487792969 7 -42.01971435546875 8 -39.210250854492188 9 -35.8731689453125
		 10 -32.031314849853516 11 -28.606161117553711 12 -24.487205505371094 13 -18.300037384033203
		 14 -12.092168807983398 15 -6.5947895050048828 16 -1.8097419738769531 17 2.0332956314086914
		 18 4.5566568374633789 19 5.4130496978759766 20 4.3066911697387695 21 1.4175748825073242
		 22 -2.7275724411010742 23 -7.8025970458984375 24 -13.637945175170898 25 -20.150835037231445
		 26 -27.278831481933594;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAX";
	rename -uid "66BD30D8-43CD-C151-AEA3-AD952658F240";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 35.349161493044306 1 34.058157129700191
		 2 30.81673249795562 3 26.975855510453432 4 24.416715853894228 5 23.964437886319221
		 6 24.975215927080288 7 26.265679484373752 8 27.028105801041228 9 26.438253616501708
		 10 24.096199355644469 11 18.723437000036771 12 12.314427840594846 13 8.4837423625019941
		 14 7.5713519786848043 15 7.0846040343814805 16 7.1811270503506268 17 8.1670336170874087
		 18 10.552403119469609 19 14.802492518283293 20 20.446930998192215 21 26.370027065053826
		 22 31.362119367259687 23 34.608556404860423 24 35.936033400442589 25 35.836040885791583
		 26 35.349161493044306;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAY";
	rename -uid "C07D02C7-4AAA-AFDF-0FA7-018387C86799";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -14.075005073590946 1 -14.162463555857359
		 2 -14.032275053024085 3 -13.03644070815732 4 -11.093834551029909 5 -8.3464496912270008
		 6 -4.9361491773775157 7 -1.1503046203913627 8 2.6942429081197936 9 6.0239951829027225
		 10 8.1121835054391536 11 7.1931323991349334 12 3.9959479818139561 13 2.9907580108756302
		 14 4.5406336618698946 15 6.4768877150697479 16 8.6827894045845717 17 10.962271129589816
		 18 12.876936607401069 19 13.623767596410714 20 12.516728465507557 21 9.2063424976497839
		 22 3.957583238033525 23 -2.2971806055452562 24 -8.2353804267375139 25 -12.516988311865727
		 26 -14.075005073590946;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightAnkleEffector_rotate_tempLayer_inputAZ";
	rename -uid "95D4A3AC-46A7-B5FD-FB6B-0E82FA16D8EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 9.9731496488122637 1 17.865954947441264
		 2 29.999134460575934 3 41.526706022108456 4 49.123848085396851 5 51.550056081941804
		 6 49.615212883196541 7 44.857534710098854 8 37.356098734184101 9 27.420273176984811
		 10 16.117060041447214 11 0.19790102383171065 12 -14.658292138877218 13 -23.576935813089253
		 14 -30.810693329457301 15 -39.131857135150099 16 -46.937583934009453 17 -52.598973505236302
		 18 -54.46215399302455 19 -51.327169001319461 20 -44.127826574827438 21 -34.540780183115601
		 22 -24.074072806911762 23 -13.745716132423285 24 -4.164058419684185 25 4.0612690376983966
		 26 9.9731496488122637;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateX_tempLayer_inputA";
	rename -uid "98549624-4D86-2E70-745E-4C93D74AF3FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 20.466442108154297 1 22.760936737060547
		 2 26.485176086425781 3 31.244688034057617 4 36.724655151367188 5 42.592071533203125
		 6 48.345436096191406 7 53.529964447021484 8 57.826755523681641 9 61.130348205566406
		 10 63.648994445800781 11 65.45965576171875 12 67.007705688476563 13 67.684799194335938
		 14 67.42510986328125 15 65.83135986328125 16 62.821990966796875 17 58.519157409667969
		 18 53.35809326171875 19 47.223648071289063 20 40.251960754394531 21 33.360115051269531
		 22 27.279335021972656 23 22.698015213012695 24 20.181785583496094 25 19.605319976806641
		 26 20.466442108154297;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateY_tempLayer_inputA";
	rename -uid "FDB94D6C-4C32-250D-4E67-C9ADF4B0E216";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 80.424972534179688 1 82.200355529785156
		 2 84.049713134765625 3 85.2525634765625 4 85.316246032714844 5 84.339500427246094
		 6 82.122566223144531 7 78.748550415039063 8 74.613937377929688 9 70.197769165039063
		 10 65.9937744140625 11 62.249755859375 12 59.687889099121094 13 58.559978485107422
		 14 58.814712524414063 15 60.221038818359375 16 62.415981292724609 17 64.93927001953125
		 18 67.16143798828125 19 69.506278991699219 20 71.762336730957031 21 73.756942749023438
		 22 75.217193603515625 23 76.408294677734375 24 77.642265319824219 25 78.979171752929688
		 26 80.424972534179688;
createNode animCurveTL -n "Character1_Ctrl_LeftWristEffector_translateZ_tempLayer_inputA";
	rename -uid "2626D492-4CA6-4C95-8A11-A5944BD5FC4F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -1.0843849182128906 1 -5.320709228515625
		 2 -10.608190536499023 3 -16.138513565063477 4 -21.531023025512695 5 -26.975004196166992
		 6 -32.206878662109375 7 -36.652816772460937 8 -40.298149108886719 9 -43.252616882324219
		 10 -45.034336090087891 11 -45.69610595703125 12 -44.082260131835938 13 -40.195281982421875
		 14 -33.224464416503906 15 -24.562503814697266 16 -15.264604568481445 17 -6.3840389251708984
		 18 1.3198757171630859 19 6.6583156585693359 20 9.6090259552001953 21 10.674013137817383
		 22 9.8009204864501953 23 7.6629886627197266 24 4.9967880249023437 25 2.1069393157958984
		 26 -1.0843849182128906;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAX";
	rename -uid "12F1C732-44EF-FAC0-AFF1-63B211677EF0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -71.841919304199038 1 -71.604554719392723
		 2 -69.390715689070376 3 -67.712319013870356 4 -67.840692238840703 5 -69.19422578977084
		 6 -71.122397681631796 7 -72.591651816937301 8 -72.947757875965252 9 -72.060840399597765
		 10 -70.05585743546763 11 -66.899819831235789 12 -62.351075795428578 13 -57.120423985997661
		 14 -52.032033144004465 15 -50.347741752727792 16 -54.302408822050296 17 -59.064503983123025
		 18 -61.462007309851131 19 -64.554988594251455 20 -68.041194871007391 21 -70.128381176675489
		 22 -71.18146080894762 23 -71.768966605046273 24 -71.644306229875568 25 -71.370271160251676
		 26 -71.841919304199038;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAY";
	rename -uid "7ED784AC-4222-BBCF-3DA2-04BF98F78EF3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 6.6699459713289171 1 8.7928595325289312
		 2 7.4453782949800029 3 4.0778076120872653 4 2.024761779102866 5 1.7845831786051347
		 6 1.1535236524331438 7 -1.5719780412009747 8 -4.7380031598502379 9 -5.7375078037951939
		 10 -4.8002302968283219 11 -2.6157541795854788 12 0.16701666787254621 13 3.5529618448822489
		 14 7.9937616065459673 15 10.171615739450417 16 6.0714778017490731 17 0.36013536101046939
		 18 -2.1751253221091154 19 -1.1813513281325696 20 1.8328893854303081 21 5.2817064999004195
		 22 7.0234905194128849 23 6.2766722265227139 24 4.7796816185731377 25 4.3419749523503208
		 26 6.6699459713289171;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "BCD5DB86-40E2-E58B-CA6D-7F81332406C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 83.537068706236681 1 86.56801296647177
		 2 91.792953109000635 3 95.863050848517759 4 96.385249836741693 5 92.992212465786395
		 6 86.922022682189706 7 79.790510651020469 8 72.811900485455908 9 66.362080178397491
		 10 59.889029517599113 11 53.073133698509146 12 45.949224639996416 13 39.480765918755175
		 14 35.406385741761852 15 34.16462484812984 16 36.720120317992404 17 41.107782516955176
		 18 44.617812267174905 19 49.842794640926662 20 57.554880103106193 21 65.928259100051463
		 22 73.502181502923335 23 78.849912825262692 24 81.718379670549453 25 82.810051851832867
		 26 83.537068706236681;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateX_tempLayer_inputA";
	rename -uid "0DA2B71C-4A8B-FD80-10EF-14AE3D399FC7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -65.131462097167969 1 -64.203475952148438
		 2 -60.82550048828125 3 -54.570533752441406 4 -45.627235412597656 5 -34.912750244140625
		 6 -23.913637161254883 7 -14.334281921386719 8 -7.2149429321289062 9 -2.8117809295654297
		 10 -1.3397617340087891 11 -3.1136703491210938 12 -7.5761775970458984 13 -13.353858947753906
		 14 -20.04347038269043 15 -26.709728240966797 16 -32.732379913330078 17 -37.897537231445313
		 18 -42.262260437011719 19 -46.048637390136719 20 -49.586662292480469 21 -53.123161315917969
		 22 -56.599048614501953 23 -59.750999450683594 24 -62.416133880615234 25 -64.336746215820313
		 26 -65.131462097167969;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateY_tempLayer_inputA";
	rename -uid "C5669DAE-423C-4084-2417-3A93BFC3689B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 90.508071899414063 1 92.292312622070312
		 2 94.90264892578125 3 97.295265197753906 4 98.550331115722656 5 98.519699096679688
		 6 96.954925537109375 7 93.884124755859375 8 89.879302978515625 9 85.608055114746094
		 10 81.646644592285156 11 78.22906494140625 12 75.787010192871094 13 74.066474914550781
		 14 72.710990905761719 15 71.645462036132812 16 71.288368225097656 17 71.804283142089844
		 18 72.651924133300781 19 74.260978698730469 20 76.511344909667969 21 79.16888427734375
		 22 81.836357116699219 23 84.488533020019531 24 86.945037841796875 25 89.02593994140625
		 26 90.508071899414063;
createNode animCurveTL -n "Character1_Ctrl_RightWristEffector_translateZ_tempLayer_inputA";
	rename -uid "8BC9834D-42BF-C1EC-5D30-27B0F491895D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -37.762130737304688 1 -30.894096374511719
		 2 -21.706012725830078 3 -11.204404830932617 4 -0.8650360107421875 5 7.6487693786621094
		 6 13.65234375 7 17.045486450195313 8 18.332912445068359 9 18.22772216796875 10 17.095733642578125
		 11 14.511874198913574 12 11.135354995727539 13 7.3204421997070313 14 2.4398937225341797
		 15 -3.5095615386962891 16 -10.279762268066406 17 -17.445165634155273 18 -24.309633255004883
		 19 -30.679302215576172 20 -36.011913299560547 21 -39.897136688232422 22 -42.761081695556641
		 23 -44.420753479003906 24 -44.304939270019531 25 -42.116657257080078 26 -37.762130737304688;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAX";
	rename -uid "E5C17311-4E0F-E2EB-364E-6AB223961F16";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 135.37218488310893 1 145.33829809499812
		 2 154.99616389603617 3 163.68664753292538 4 170.26317132011988 5 173.14589365169149
		 6 170.5948201635164 7 159.81616249215386 8 142.35695030014125 9 124.19407058842981
		 10 108.86906112064591 11 96.612491440178644 12 86.595951422539997 13 78.114689547661172
		 14 71.02216171575958 15 66.349606112385345 16 66.987895758772765 17 71.526107979636748
		 18 75.897993733559048 19 80.092091975401431 20 84.732666369936084 21 90.462736224427502
		 22 97.448305413696914 23 105.66998811590297 24 115.03198302488636 25 125.13185747231127
		 26 135.37218488310893;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAY";
	rename -uid "2B878ADA-44F0-B11B-71E2-D89E250A65AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 2.9291434324058137 1 -6.9557629968180201
		 2 -16.811898158207232 3 -25.662241589515155 4 -32.976099707834869 5 -38.630292706469874
		 6 -42.579979564329719 7 -43.689580296237381 8 -39.941418398004892 9 -30.493148563797053
		 10 -16.525652581150137 11 -0.31296254327087031 12 16.057085802037772 13 31.058915015709267
		 14 43.562644491859473 15 52.620404697116705 16 57.229063740280267 17 58.107047438258554
		 18 57.056606972388629 19 54.236858950207079 20 49.777187154376861 21 43.873206701749424
		 22 36.772713946183671 23 28.885368971884958 24 20.639212762926402 25 12.067303133024401
		 26 2.9291434324058132;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightWristEffector_rotate_tempLayer_inputAZ";
	rename -uid "23E3A652-4D18-2690-8308-F3A6928E6AFE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 19.518857641946681 1 23.493526084255237
		 2 28.000458427299922 3 33.127246871096567 4 39.286735611510046 5 47.135099328389678
		 6 57.425684944057899 7 71.338816427711976 8 87.054122438477762 9 99.644823031794104
		 10 105.94096861884964 11 105.58029667644874 12 99.502985961075268 13 89.800102895316883
		 14 77.06506580747282 15 64.230416063750695 16 55.041284608809178 17 48.524567747127655
		 18 41.264536455710186 19 33.794622790053978 20 27.177473900136391 21 22.205223755429564
		 22 18.736213881418074 23 16.561536494769317 24 15.866073979042399 25 16.805193022002584
		 26 19.518857641946681;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateX_tempLayer_inputA";
	rename -uid "DA5074A4-4235-8C67-CCA7-5484C47FB9DD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 33.076999664306641 1 31.954399108886719
		 2 31.06159782409668 3 30.762826919555664 4 31.129798889160156 5 32.043838500976563
		 6 33.262100219726563 7 34.486610412597656 8 34.404682159423828 9 33.757469177246094
		 10 32.909332275390625 11 31.781644821166992 12 30.594459533691406 13 29.765895843505859
		 14 29.400398254394531 15 29.005220413208008 16 28.93206787109375 17 29.564651489257813
		 18 30.647914886474609 19 31.923435211181641 20 33.086715698242188 21 33.965526580810547
		 22 34.473087310791016 23 34.555862426757813 24 34.305221557617188 25 33.979171752929688
		 26 33.076999664306641;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateY_tempLayer_inputA";
	rename -uid "F9F2B00E-490E-08A4-F5A9-AB98BC62F3EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 47.346965789794922 1 48.443302154541016
		 2 45.933021545410156 3 41.678184509277344 4 37.478229522705078 5 33.875850677490234
		 6 30.226654052734375 7 26.508066177368164 8 22.987054824829102 9 19.45881462097168
		 10 15.967700958251953 11 12.948356628417969 12 10.451065063476562 13 8.832122802734375
		 14 8.6480789184570312 15 9.8693695068359375 16 12.219911575317383 17 15.301839828491211
		 18 18.486932754516602 19 22.024023056030273 20 25.569124221801758 21 28.91920280456543
		 22 31.815668106079102 23 34.816890716552734 24 38.481971740722656 25 42.906620025634766
		 26 47.346965789794922;
createNode animCurveTL -n "Character1_Ctrl_LeftKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "9CFD467E-4373-C0C0-8F81-E493C9BB18A1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 5.0520124435424805 1 7.7973623275756836
		 2 9.0240669250488281 3 9.8652591705322266 4 11.159713745117188 5 12.209774971008301
		 6 12.232536315917969 7 11.10987377166748 8 9.458125114440918 9 7.1924362182617187
		 10 4.1207571029663086 11 0.030330657958984375 12 -4.8585138320922852 13 -10.532657623291016
		 14 -15.85649299621582 15 -20.258808135986328 16 -23.739618301391602 17 -26.346046447753906
		 18 -27.930740356445312 19 -28.359699249267578 20 -27.124610900878906 21 -24.126579284667969
		 22 -19.603187561035156 23 -13.769621849060059 24 -7.0592541694641113 25 -0.4293212890625
		 26 5.0520124435424805;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "004403C7-475B-8B82-02C8-BEBE11FE645F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -18.54917372739181 1 -6.6453333577292462
		 2 0.43003017325650644 3 5.5988320792056614 4 8.8291885000525223 5 10.631964623856025
		 6 11.221602649716344 7 11.366026119727422 8 12.586635375278801 9 13.931282686661207
		 10 14.79041127681935 11 14.901072111662323 12 14.713403350147134 13 14.829514072377744
		 14 14.527865131199992 15 13.862667395267799 16 12.229284113534188 17 9.1032140578480174
		 18 4.7138002690255645 19 -1.0218919131856528 20 -7.6203326971953134 21 -14.58260844917595
		 22 -21.514409160906684 23 -27.333345866340061 24 -32.19847624887354 25 -31.456995420221027
		 26 -18.54917372739181;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "E05ABD35-4AE0-4E7E-68F0-6E854627306C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -2.3853491551108386 1 -2.7203991862377297
		 2 -3.4260896533634879 3 -2.6642826403111828 4 -1.1075817657645584 5 0.24237396903562816
		 6 1.7296822664575846 7 4.2402642786899367 8 3.2940905910977212 9 2.0369965970752819
		 10 1.9329872983988454 11 2.3637966924645779 12 3.3673441900968104 13 4.7881411570408963
		 14 5.938219095514695 15 4.8271175281759238 16 2.5189994607078092 17 0.66237458168695562
		 18 -1.057437781521215 19 -2.5673798836604234 20 -3.6534957089440883 21 -4.3449710157886887
		 22 -4.5282918889822019 23 -4.6376638414355495 24 -4.5911365286846895 25 -3.3509418111798683
		 26 -2.385349155110839;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "6442BD33-463F-0EBF-9BB3-BA9ED0DF827E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 0.29877808826547575 1 -14.985658191455363
		 2 -28.665743843949016 3 -40.987524590092718 4 -47.378770993091919 5 -46.695054874832387
		 6 -40.836419615837514 7 -34.511374982870478 8 -27.028324170240317 9 -18.407564477843678
		 10 -9.2001016720111988 11 -0.69718669632283115 12 8.0387985963817723 13 16.819123817279888
		 14 24.037983706101961 15 29.024682182698005 16 31.640741343455201 17 32.754305576045567
		 18 34.822000405811266 19 36.731303716856701 20 38.652634428940935 21 40.090278803796735
		 22 41.018672906659653 23 38.963173923853546 24 31.728541244419741 25 18.437634637612767
		 26 0.29877808826547481;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateX_tempLayer_inputA";
	rename -uid "74404C84-4A59-4EAF-E6D9-77B9BBE1CE15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -15.684041976928711 1 -15.136869430541992
		 2 -15.65966796875 3 -17.165737152099609 4 -19.107162475585938 5 -20.746194839477539
		 6 -22.101299285888672 7 -23.320297241210937 8 -24.205862045288086 9 -24.600845336914063
		 10 -24.494850158691406 11 -24.276718139648438 12 -23.694158554077148 13 -22.360622406005859
		 14 -20.753692626953125 15 -19.555570602416992 16 -18.724979400634766 17 -18.040338516235352
		 18 -17.913204193115234 19 -18.65814208984375 20 -19.630359649658203 21 -19.936481475830078
		 22 -19.575046539306641 23 -18.771823883056641 24 -17.810054779052734 25 -16.809066772460937
		 26 -15.684041976928711;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateY_tempLayer_inputA";
	rename -uid "6A22856C-4E28-8015-C9F4-CB80AD3C725F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 9.256317138671875 1 8.2527809143066406
		 2 9.2611446380615234 3 11.40858268737793 4 14.342649459838867 5 17.911111831665039
		 6 21.700155258178711 7 25.591352462768555 8 29.433164596557617 9 33.060443878173828
		 10 36.249710083007813 11 38.530776977539063 12 39.866325378417969 13 40.547622680664062
		 14 40.332748413085937 15 38.728298187255859 16 35.851325988769531 17 32.115589141845703
		 18 28.624288558959961 19 26.406942367553711 20 25.249483108520508 21 24.518829345703125
		 22 23.431680679321289 23 21.315517425537109 24 17.722265243530273 25 13.157085418701172
		 26 9.256317138671875;
createNode animCurveTL -n "Character1_Ctrl_RightKneeEffector_translateZ_tempLayer_inputA";
	rename -uid "5E4C7852-4B54-3C30-37FA-03A4FC86936F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.471363067626953 1 -17.113945007324219
		 2 -21.782188415527344 3 -25.678066253662109 4 -28.506328582763672 5 -29.452930450439453
		 6 -28.390922546386719 7 -26.350852966308594 8 -23.602611541748047 9 -20.394054412841797
		 10 -16.813018798828125 11 -13.817429542541504 12 -10.634025573730469 13 -5.9968223571777344
		 14 -2.1139698028564453 15 0.21438026428222656 16 1.1859264373779297 17 1.1491918563842773
		 18 1.9390268325805664 19 3.3121404647827148 20 4.3035898208618164 21 4.5273303985595703
		 22 3.7773828506469727 23 2.1297740936279297 24 -0.58915519714355469 25 -5.0405473709106445
		 26 -11.471363067626953;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAX";
	rename -uid "FCDAFA4D-4325-972E-2E28-64B5F363A746";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 1.2686408493807833 1 0.48824603415164453
		 2 0.2459983943794487 3 0.90308628810923275 4 3.047049564123804 5 7.1203441571694217
		 6 12.982913433330223 7 19.485281108928525 8 26.081298213568324 9 32.335702626101856
		 10 37.793642762325746 11 41.658106632978274 12 41.10818384955882 13 34.300599036251157
		 14 21.564049529869745 15 9.1052691432567219 16 1.550924265591517 17 -2.9258236303084635
		 18 -5.0432752471512101 19 -4.4687348390035879 20 -3.22872775304171 21 -2.1727257065250996
		 22 -1.3036614648477192 23 -0.13434671749921911 24 1.2376677870141064 25 1.8641680122111348
		 26 1.2686408493807833;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAY";
	rename -uid "C418E571-4664-51C2-EB93-3FBC4B324000";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 4.9209919051021203 1 3.5235953709382808
		 2 2.9238473606648578 3 2.5690191434654497 4 3.1508088770593989 5 5.9002390941511376
		 6 9.1861914868937191 7 11.625282846064461 8 13.38200531363514 9 14.96253045115572
		 10 16.646212318368494 11 18.592882032586278 12 21.204680185300855 13 21.676029034406724
		 14 19.172679959212658 15 14.981068586756392 16 10.036844652390622 17 5.7433423783773563
		 18 2.3735518428145852 19 -0.9870656304672254 20 -3.0335292577007582 21 -1.7272981648318728
		 22 1.7114491572130375 23 5.5367976515481967 24 7.7145285564847379 25 7.1577690847222151
		 26 4.9209919051021203;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightKneeEffector_rotate_tempLayer_inputAZ";
	rename -uid "7C91A2B8-47D5-9658-677D-E2B744396285";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 37.93149092829541 1 43.087211298293724
		 2 42.687765811010934 3 39.579955866414657 4 36.129788183251044 5 33.660666189465488
		 6 32.651618705445379 7 31.959981623356928 8 31.049735238730243 9 29.248444446520558
		 10 25.99452509152534 11 21.586755469776698 12 13.834415145183007 13 3.1114176978386285
		 14 -9.7622521386557946 15 -23.722518232519302 16 -38.017647995262863 17 -51.615047299634774
		 18 -57.358246686435024 19 -54.800056187977006 20 -46.720980997131385 21 -35.494806825124869
		 22 -23.089514707733727 23 -9.05656461168366 24 7.3114475294163634 25 24.24148802824125
		 26 37.93149092829541;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateX_tempLayer_inputA";
	rename -uid "62EBB9C3-42EB-34C5-F417-A2803A1FE678";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 29.512588500976563 1 32.202247619628906
		 2 35.97442626953125 3 39.857841491699219 4 43.11944580078125 5 45.558990478515625
		 6 47.557304382324219 7 49.652347564697266 8 51.714122772216797 9 53.366870880126953
		 10 54.612144470214844 11 55.40313720703125 12 56.140636444091797 13 56.469409942626953
		 14 56.717254638671875 15 55.999958038330078 16 53.934085845947266 17 50.439182281494141
		 18 45.834064483642578 19 41.050727844238281 20 36.668083190917969 21 32.81170654296875
		 22 29.865653991699219 23 28.063880920410156 24 27.486799240112305 25 28.047588348388672
		 26 29.512588500976563;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateY_tempLayer_inputA";
	rename -uid "8DC4B31E-4BFA-4FFA-C194-34BF3C73A2A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 81.455169677734375 1 81.902725219726563
		 2 83.231048583984375 3 84.700851440429688 4 85.704849243164063 5 86.223861694335938
		 6 85.9091796875 7 84.377716064453125 8 81.669395446777344 9 78.275917053222656 10 74.694580078125
		 11 71.355461120605469 12 69.217376708984375 13 68.561805725097656 14 69.227638244628906
		 15 71.008346557617188 16 73.600845336914063 17 76.532035827636719 18 78.892303466796875
		 19 80.440582275390625 20 81.319793701171875 21 81.941818237304688 22 82.0064697265625
		 23 81.76959228515625 24 81.619415283203125 25 81.5521240234375 26 81.455169677734375;
createNode animCurveTL -n "Character1_Ctrl_LeftElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "60EFFD10-4855-030E-DFCC-20AED9F3D627";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -21.493427276611328 1 -25.574008941650391
		 2 -30.82469367980957 3 -36.752399444580078 4 -42.940807342529297 5 -49.044662475585937
		 6 -54.2174072265625 7 -57.929557800292969 8 -60.602806091308594 9 -62.588981628417969
		 10 -63.529060363769531 11 -63.454933166503906 12 -61.126869201660156 13 -56.736186981201172
		 14 -49.847820281982422 15 -41.485885620117187 16 -32.449684143066406 17 -23.697181701660156
		 18 -16.15007209777832 19 -11.828411102294922 20 -10.27147102355957 21 -10.113729476928711
		 22 -11.332931518554687 23 -13.358123779296875 24 -15.745491027832031 25 -18.424283981323242
		 26 -21.493427276611328;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "555EBC58-4822-7986-9CBF-53AB62AEE14E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -44.050863868160725 1 -42.109613003902361
		 2 -38.933493692407282 3 -35.397064491076875 4 -32.359573337101928 5 -30.483794670059822
		 6 -29.881417782472969 7 -30.324709294063098 8 -32.096644662033206 9 -35.153210211585431
		 10 -39.177576943813321 11 -43.589498441706162 12 -47.548431938835989 13 -51.1797719838655
		 14 -54.566562001267513 15 -56.7328937173464 16 -56.935846418445898 17 -54.608578473143609
		 18 -50.517373000644561 19 -47.921502908785321 20 -47.045500389222312 21 -46.628097744557941
		 22 -46.649277191392422 23 -46.750171689946086 24 -46.277894760622132 25 -45.269627281257002
		 26 -44.050863868160725;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "F540126D-4DD8-C381-0246-D48D1ED60345";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -2.6421823346864901 1 0.76309367550073137
		 2 2.0993869072767213 3 1.4146229433918647 4 -0.99635875461764145 5 -4.8369047360331887
		 6 -9.7552792317264458 7 -14.589327178662961 8 -18.403786349616386 9 -21.190764263429831
		 10 -22.913212396527388 11 -24.045029761902075 12 -25.240424678941324 13 -26.586838007103836
		 14 -27.771678734503347 15 -28.861988165031676 16 -30.032512728696883 17 -31.248004169215864
		 18 -31.66306837097726 19 -29.293234992708289 20 -25.319732218948232 21 -21.484546559714737
		 22 -17.686054201950117 23 -13.880807228209012 24 -10.251339097662919 25 -6.6112723297406593
		 26 -2.6421823346864901;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "35EFF9CB-42EE-1DB0-B8F1-E584A34F9968";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 113.9049399047324 1 114.99311919595343
		 2 115.14445069213649 3 112.67673797764579 4 106.63012759424326 5 97.656604858008933
		 6 87.949273633832988 7 79.671361999476005 8 73.245787751160378 9 68.124723726501855
		 10 63.959024809724568 11 60.477828668618585 12 57.479748617379691 13 55.861130004183103
		 14 57.212600867334508 15 59.846168761636058 16 62.652561156069964 17 64.981751902689993
		 18 66.699195766004834 19 71.535275113884325 20 79.780983340563282 21 88.488789717131823
		 22 96.97705285902704 23 104.31959460647273 24 109.40125405524969 25 112.35204540373581
		 26 113.9049399047324;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateX_tempLayer_inputA";
	rename -uid "41AC4C37-4B9C-C8E2-C4A8-DFB7C5A1AE52";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -51.535980224609375 1 -52.625667572021484
		 2 -52.138999938964844 3 -49.473033905029297 4 -44.408424377441406 5 -37.320842742919922
		 6 -29.211505889892578 7 -21.455081939697266 8 -15.045856475830078 9 -10.355043411254883
		 10 -7.6252803802490234 11 -7.1910896301269531 12 -8.6834487915039062 13 -11.337121963500977
		 14 -14.765815734863281 15 -18.562301635742187 16 -22.360616683959961 17 -25.672412872314453
		 18 -28.236850738525391 19 -30.345500946044922 20 -32.647186279296875 21 -35.650726318359375
		 22 -39.244377136230469 23 -42.953769683837891 24 -46.435951232910156 25 -49.388778686523438
		 26 -51.535980224609375;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateY_tempLayer_inputA";
	rename -uid "B2B94C0B-41AE-7737-F070-ABA5B919A152";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 78.340484619140625 1 79.805137634277344
		 2 82.325111389160156 3 84.956466674804687 4 86.858154296875 5 87.905426025390625
		 6 87.823844909667969 7 86.598724365234375 8 84.732742309570313 9 82.771980285644531
		 10 81.128425598144531 11 79.868110656738281 12 79.339912414550781 13 79.263473510742188
		 14 79.274169921875 15 79.153190612792969 16 78.869392395019531 17 78.433700561523438
		 18 77.529685974121094 19 76.736618041992188 20 76.118209838867187 21 75.755401611328125
		 22 75.594940185546875 23 75.892974853515625 24 76.611915588378906 25 77.521232604980469
		 26 78.340484619140625;
createNode animCurveTL -n "Character1_Ctrl_RightElbowEffector_translateZ_tempLayer_inputA";
	rename -uid "C06E3A67-4348-8367-AA0B-F0B2324D90A3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -50.666999816894531 1 -45.366405487060547
		 2 -38.008548736572266 3 -29.126258850097656 4 -19.871078491210937 5 -11.869466781616211
		 6 -6.0448341369628906 7 -2.8452110290527344 8 -1.9553155899047852 9 -2.6164178848266602
		 10 -4.3436298370361328 11 -7.3995542526245117 12 -10.900382995605469 13 -14.320880889892578
		 14 -18.260200500488281 15 -22.917701721191406 16 -28.565765380859375 17 -34.938594818115234
		 18 -41.010498046875 19 -46.386154174804687 20 -50.583198547363281 21 -53.405815124511719
		 22 -55.381870269775391 23 -56.395416259765625 24 -56.021736145019531 25 -54.100906372070312
		 26 -50.666999816894531;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAX";
	rename -uid "8E903EC7-4908-F365-9FFC-9FB508A4E05E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -39.859435373145402 1 -38.22850240762947
		 2 -35.992475877246051 3 -33.665859006168212 4 -32.077793108574582 5 -31.96436508837758
		 6 -33.478910371006201 7 -36.075435269230077 8 -38.864521197543972 9 -41.164953969777621
		 10 -42.668702597290782 11 -43.387250568750112 12 -43.628204909400999 13 -43.834647273962837
		 14 -44.078391279548768 15 -44.627689846816189 16 -45.852538278147222 17 -47.464451279571101
		 18 -48.677042848390563 19 -49.070532925357178 20 -48.59795179412459 21 -47.411806976073215
		 22 -45.742747537998582 23 -43.964352828693784 24 -42.419654001567416 25 -41.112793867669794
		 26 -39.859435373145402;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAY";
	rename -uid "B68556FC-4C73-34F5-F5E3-BC9DCBA5CB27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 32.49384345712231 1 33.543535993280948
		 2 33.926934437837183 3 33.321995699610007 4 31.497226073175025 5 28.433651642641593
		 6 24.286703991154898 7 19.249482621762183 8 13.553640602491697 9 7.5170576470262889
		 10 1.515371015361731 11 -4.0856212900655029 12 -9.1169588609769541 13 -13.512793663737526
		 14 -17.248141658393379 15 -19.894270494894375 16 -20.165723397204452 17 -17.645974460093207
		 18 -13.044447750304199 19 -6.8406955660950688 20 0.4928533241280772 21 8.2484612765034218
		 22 15.668036092799479 23 22.067204697302667 24 26.992371785939088 25 30.453431097725741
		 26 32.49384345712231;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightElbowEffector_rotate_tempLayer_inputAZ";
	rename -uid "F81617BF-4647-01B5-8B01-7BBB1687E23B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 42.89686920279663 1 50.67630217657009
		 2 61.234472120080802 3 73.381200333966191 4 85.603649097267763 5 96.356764332379242
		 6 104.44674710730921 7 109.16218055462078 8 110.64121366068137 9 109.49835740547961
		 10 106.01032686310326 11 100.27618398801864 12 92.671798766149578 13 84.523943290646244
		 14 75.585474292473023 15 67.137853549833721 16 60.338426181093723 17 54.912894886996177
		 18 49.780432462824024 19 44.748372158867021 20 40.382839609114228 21 37.334203572163069
		 22 35.599630943134599 23 35.011640849722426 24 35.731639310698775 25 38.157797352351821
		 26 42.89686920279663;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateX_tempLayer_inputA";
	rename -uid "228CC71C-4913-ED82-E93A-8DBD97932FF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 2.4531688690185547 1 2.9370179176330566
		 2 3.779266357421875 3 4.9078822135925293 4 6.284696102142334 5 7.8600597381591797
		 6 9.4567794799804687 7 10.835079193115234 8 11.878874778747559 9 12.592458724975586
		 10 12.963798522949219 11 12.775718688964844 12 12.298186302185059 13 11.777422904968262
		 14 11.330743789672852 15 10.709517478942871 16 9.8723917007446289 17 8.8381443023681641
		 18 7.6949763298034668 19 6.5443854331970215 20 5.4528388977050781 21 4.4723367691040039
		 22 3.6273236274719238 23 2.9727761745452881 24 2.5366830825805664 25 2.3476786613464355
		 26 2.4531688690185547;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateY_tempLayer_inputA";
	rename -uid "DC71AEC3-4D6E-611D-0E04-159127046C37";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 52.687023162841797 1 52.798439025878906
		 2 53.224227905273438 3 53.494243621826172 4 53.366024017333984 5 53.195060729980469
		 6 52.8905029296875 7 52.329093933105469 8 51.660037994384766 9 51.06915283203125
		 10 50.706722259521484 11 50.485595703125 12 50.763771057128906 13 51.415203094482422
		 14 52.225128173828125 15 53.031013488769531 16 53.714023590087891 17 54.127826690673828
		 18 53.889446258544922 19 53.620609283447266 20 53.457912445068359 21 53.442569732666016
		 22 53.274944305419922 23 53.075637817382813 24 52.956462860107422 25 52.846626281738281
		 26 52.687023162841797;
createNode animCurveTL -n "Character1_Ctrl_ChestOriginEffector_translateZ_tempLayer_inputA";
	rename -uid "90BA44C5-411C-E7C4-1A13-4C98D8F3D4FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -23.332717895507812 1 -23.303464889526367
		 2 -23.284418106079102 3 -22.912023544311523 4 -22.195774078369141 5 -21.656711578369141
		 6 -21.413515090942383 7 -21.481662750244141 8 -21.81634521484375 9 -22.291559219360352
		 10 -22.855510711669922 11 -23.969017028808594 12 -24.864675521850586 13 -25.273981094360352
		 14 -25.201034545898438 15 -24.859973907470703 16 -24.387977600097656 17 -23.890684127807617
		 18 -23.247890472412109 19 -22.847911834716797 20 -22.688064575195313 21 -22.654308319091797
		 22 -22.994413375854492 23 -23.413400650024414 24 -23.589008331298828 25 -23.506689071655273
		 26 -23.332717895507812;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAX";
	rename -uid "77D204D7-4BC8-B019-96C5-64B1347F3D9E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -8.1816675611967398 1 -9.5698796561563384
		 2 -11.028443185117505 3 -12.531646920441604 4 -13.925848693772958 5 -14.885094512600109
		 6 -14.967875755484537 7 -13.704961665982912 8 -11.155326206141815 9 -7.8190505982999232
		 10 -4.0143418899930401 11 -0.22027083463281963 12 3.0527521553621715 13 6.272284308164715
		 14 8.0582075524205461 15 9.1105589921153953 16 9.6408189068709298 17 9.7508116320411347
		 18 9.4227840579935496 19 8.5519297863473422 20 6.9933917631801599 21 4.7859805341332047
		 22 2.1276482769776881 23 -0.82587032275427197 24 -3.7796269151176203 25 -6.3599310510157636
		 26 -8.1816675611967398;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAY";
	rename -uid "95B8A9F6-478F-110B-25FE-ECA2B89ED25D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 33.980019474403498 1 33.032439295343309
		 2 29.920706323367696 3 24.966335038361301 4 18.513643627997183 5 10.94748965705379
		 6 2.6920839190888493 7 -5.7997554560428881 8 -13.989098912450368 9 -21.293664724121736
		 10 -27.214193460994256 11 -31.299828262854696 12 -33.131135748735126 13 -32.709683241567788
		 14 -30.441824164929812 15 -26.64847196379522 16 -21.558177306060102 17 -15.424857329260396
		 18 -8.5339824015662327 19 -1.1978863543427996 20 6.2539883306914259 21 13.453342180134502
		 22 20.001142691388189 23 25.574457434048252 24 29.922192926595468 25 32.802168635362023
		 26 33.980019474403498;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestOriginEffector_rotate_tempLayer_inputAZ";
	rename -uid "E13736E5-42A1-C036-0505-DFB0495C30F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -8.9095529974517866 1 -8.2081415258004888
		 2 -6.7313307393413924 3 -5.0303855776628525 4 -3.5657087112009713 5 -2.6236095476681069
		 6 -2.3286568584009451 7 -2.6789264106355981 8 -3.6047060115190708 9 -4.9720330812536728
		 10 -6.4966738364743986 11 -7.749779775402744 12 -8.2343579508112796 13 -8.1498400602416421
		 14 -6.9562363091345389 15 -5.3194596646163754 16 -3.6492138919563404 17 -2.2728672401212267
		 18 -1.4046843459654048 19 -1.1567650211697766 20 -1.5564292681119489 21 -2.5543639487665364
		 22 -4.022475051405598 23 -5.7357214791699684 24 -7.3735714660407909 25 -8.5535982257192718
		 26 -8.9095529974517866;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateX_tempLayer_inputA";
	rename -uid "B10828B1-4FC4-8E93-1E37-1AA1AE445D0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.68366813659668 1 -10.567856788635254
		 2 -8.2205667495727539 3 -4.8074874877929687 4 -0.48866939544677734 5 4.5045666694641113
		 6 9.7561321258544922 7 14.760018348693848 8 19.138519287109375 9 22.663253784179688
		 10 25.151140213012695 11 26.279750823974609 12 26.212196350097656 13 25.095867156982422
		 14 23.391384124755859 15 20.887380599975586 16 17.598987579345703 17 13.641510009765625
		 18 9.2524814605712891 19 4.7305593490600586 20 0.36594581604003906 21 -3.5680036544799805
		 22 -6.8123846054077148 23 -9.2239503860473633 24 -10.848470687866211 25 -11.679325103759766
		 26 -11.68366813659668;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateY_tempLayer_inputA";
	rename -uid "69081678-4746-4765-BCDE-6CBF35CC4316";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 93.740509033203125 1 94.114891052246094
		 2 95.19451904296875 3 96.3006591796875 4 96.97113037109375 5 97.371826171875 6 97.284820556640625
		 7 96.544891357421875 8 95.349380493164063 9 94.014373779296875 10 92.88360595703125
		 11 92.079544067382813 12 92.155891418457031 13 93.042724609375 14 94.39886474609375
		 15 95.906356811523438 16 97.300682067871094 17 98.299209594726563 18 98.410873413085938
		 19 98.191673278808594 20 97.763824462890625 21 97.2099609375 22 96.338127136230469
		 23 95.403282165527344 24 94.628501892089844 25 94.061531066894531 26 93.740509033203125;
createNode animCurveTL -n "Character1_Ctrl_ChestEndEffector_translateZ_tempLayer_inputA";
	rename -uid "A2C32974-43BF-DBD8-2E57-C7AA5DE8BCA2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -33.425605773925781 1 -33.09954833984375
		 2 -32.391059875488281 3 -31.17701530456543 4 -29.708517074584961 5 -28.700021743774414
		 6 -28.372701644897461 7 -28.725749969482422 8 -29.620061874389648 9 -30.797275543212891
		 10 -32.009574890136719 11 -33.519454956054688 12 -34.38055419921875 13 -34.430606842041016
		 14 -33.514766693115234 15 -32.124279022216797 16 -30.593847274780273 17 -29.228034973144531
		 18 -28.074838638305664 19 -27.630731582641602 20 -27.917922973632812 21 -28.742471694946289
		 22 -30.177539825439453 23 -31.715217590332031 24 -32.843891143798828 25 -33.394454956054687
		 26 -33.425605773925781;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAX";
	rename -uid "6F87C54B-4DE5-F04E-6F68-B4960C5D3E40";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -21.496239871255703 1 -14.50169344360644
		 2 -5.511785246199433 3 4.7000087631174408 4 15.333499567680535 5 25.572147372300169
		 6 34.600702382706523 7 41.622927585972633 8 46.35987786521504 9 48.965055636265468
		 10 49.308296193171209 11 47.111944299018347 12 42.382651959174524 13 36.121117288399546
		 14 27.669004089718534 15 18.050811482020698 16 7.9081936954063092 17 -2.1162764576981759
		 18 -11.395989930351586 19 -19.333740275070831 20 -25.363510540156085 21 -29.173795674244818
		 22 -31.003531406571316 23 -31.145043836459326 24 -29.612634602055731 25 -26.397257675694679
		 26 -21.496239871255703;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAY";
	rename -uid "B8A04FEB-43C5-5679-E96A-259B4584AC78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 7.2939607105210564 1 6.7956378833951625
		 2 6.0401536295144753 3 5.0686894415997159 4 3.8587984265301158 5 2.3740991167365171
		 6 0.62109139013784254 7 -1.3168096508032314 8 -3.2435127754015936 9 -4.9139625368196622
		 10 -6.1356928796046528 11 -6.7865738105715634 12 -6.7929915141350339 13 -6.1018243894109547
		 14 -5.0473374097990398 15 -3.7342487111030378 16 -2.2007239618109229 17 -0.46672014041907928
		 18 1.4229279853561494 19 3.3658231876413005 20 5.1983195600865422 21 6.7148575179996079
		 22 7.6338287715988322 23 7.9378557750343832 24 7.8949532859877793 25 7.6344458665367281
		 26 7.2939607105210564;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_ChestEndEffector_rotate_tempLayer_inputAZ";
	rename -uid "F32F42A0-4283-4D11-E411-09A81B52DC3B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -30.389585314024554 1 -30.786779579459086
		 2 -30.837178521651285 3 -30.511439737427583 4 -29.852464416083762 5 -28.980369052593822
		 6 -28.069618746663338 7 -27.301410246885492 8 -26.80572586441393 9 -26.610610127289679
		 10 -26.662183723926585 11 -26.88119188232443 12 -27.107145832636427 13 -27.250812308658233
		 14 -27.114047791371405 15 -26.753965652426853 16 -26.217464302952102 17 -25.613970726297069
		 18 -25.102077330863462 19 -24.858916924350844 20 -25.037570781282017 21 -25.678231301654776
		 22 -26.633300821503489 23 -27.70440708101053 24 -28.765453387710096 25 -29.695142624147742
		 26 -30.389585314024554;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateX_tempLayer_inputA";
	rename -uid "EB55377A-471B-B27F-52BD-FEA132F30120";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 27.734437942504883 1 26.856582641601563
		 2 26.613803863525391 3 26.766860961914063 4 27.120136260986328 5 27.59782600402832
		 6 28.005977630615234 7 28.066001892089844 8 27.659439086914063 9 26.75677490234375
		 10 25.416879653930664 11 23.789154052734375 12 22.109046936035156 13 20.763225555419922
		 14 20.0379638671875 15 20.002065658569336 16 20.701604843139648 17 22.066648483276367
		 18 23.941196441650391 19 26.005067825317383 20 27.921257019042969 21 29.438070297241211
		 22 30.363048553466797 23 30.597970962524414 24 30.141693115234375 25 29.106668472290039
		 26 27.734437942504883;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateY_tempLayer_inputA";
	rename -uid "96D80774-444D-ED53-20BD-62BFFA628EF5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 30.445886611938477 1 28.792366027832031
		 2 24.836313247680664 3 20.202304840087891 4 16.075870513916016 5 12.433085441589355
		 6 8.8599987030029297 7 5.4976530075073242 8 2.4790573120117187 9 -0.077512741088867188
		 10 -2.049626350402832 11 -3.3080501556396484 12 -3.7187824249267578 13 -2.9722957611083984
		 14 -1.0145463943481445 15 1.7424917221069336 16 4.9893569946289062 17 8.5383834838867187
		 18 12.273548126220703 19 16.028509140014648 20 19.588100433349609 21 22.78021240234375
		 22 25.487957000732422 23 27.647689819335937 24 29.226505279541016 25 30.184309005737305
		 26 30.445886611938477;
createNode animCurveTL -n "Character1_Ctrl_LeftFootEffector_translateZ_tempLayer_inputA";
	rename -uid "74DAF37D-4B6B-70BC-00CF-E5B4CD7A2566";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -6.508643627166748 1 0.11073368787765503
		 2 6.0444350242614746 3 11.26312255859375 4 14.707599639892578 5 15.44841480255127
		 6 13.611141204833984 7 10.476781845092773 8 6.3145618438720703 9 1.3281978368759155
		 10 -4.3302760124206543 11 -10.553347587585449 12 -17.277994155883789 13 -24.490245819091797
		 14 -31.160009384155273 15 -36.876735687255859 16 -41.521816253662109 17 -44.977428436279297
		 18 -47.105236053466797 19 -47.662208557128906 20 -46.204113006591797 21 -42.679424285888672
		 22 -37.425636291503906 23 -30.784465789794922 24 -23.140350341796875 25 -14.910379409790039
		 26 -6.508643627166748;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAX";
	rename -uid "523F6CDB-4220-41C9-0455-9EA342A07315";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -0.83888416345908923 1 -1.2211172898593092
		 2 -2.3156416370912019 3 -4.0660883368276597 4 -6.4291740113566691 5 -9.3552573063870401
		 6 -12.769531102404168 7 -16.556107296671883 8 -20.548698422134819 9 -24.532580345350485
		 10 -28.259866589931814 11 -31.473504185374047 12 -33.931863686513019 13 -36.715536824493142
		 14 -38.831691905750382 15 -39.874193573612111 16 -39.582869387282727 17 -38.116658980879144
		 18 -35.770799249637633 19 -32.623775757906799 20 -28.507049540900947 21 -23.261460422098271
		 22 -17.131942730399501 23 -10.908450037666292 24 -5.6270026432141389 25 -2.106539288658531
		 26 -0.83888416345908934;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAY";
	rename -uid "4BD34BE0-4A42-CDFC-161C-CBBE961E1045";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -21.540030193305256 1 -21.872250199547587
		 2 -22.778538139573058 3 -24.10515325223437 4 -25.681182423340285 5 -27.327486190028576
		 6 -28.866660567172456 7 -30.134570386473495 8 -30.993431546228656 9 -31.344429537024531
		 10 -31.136366286525693 11 -30.368107384434669 12 -29.084717392367601 13 -26.835770954818475
		 14 -22.359463688452635 15 -16.99034917091954 16 -12.019576769838944 17 -8.6488961623498941
		 18 -7.793222579290541 19 -9.7392711282093387 20 -13.385367571456705 21 -17.322375207319975
		 22 -20.391327865856262 23 -21.983596581256631 24 -22.22586783147705 25 -21.809632051952978
		 26 -21.540030193305256;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "0041D29E-4F14-C92B-54BB-A2B5EB7D942B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 16.377340673529044 1 16.712891491048826
		 2 17.686106673392775 3 19.257219988448046 4 21.392119098454259 5 24.052029122634892
		 6 27.181651873304656 7 30.698401277782729 8 34.486866049044842 9 38.403586318739329
		 10 42.293884904563015 11 46.016985010447932 12 49.470150262264433 13 54.347412226253816
		 14 60.752757761673557 15 67.496658579183432 16 73.575758045603791 17 78.011887538930864
		 18 79.57303369300071 19 77.029970884641827 20 70.582462834741349 21 61.00897229670214
		 22 49.413628072078545 23 37.364128113456324 24 26.707833578765406 25 19.201687083361687
		 26 16.377340673529044;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateX_tempLayer_inputA";
	rename -uid "F7D017E5-4CB0-8CD4-4222-599A8B49A52B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.70195484161377 1 -11.011890411376953
		 2 -11.414623260498047 3 -12.861971855163574 4 -15.092350959777832 5 -17.724491119384766
		 6 -20.332769393920898 7 -22.615406036376953 8 -24.365177154541016 9 -25.482810974121094
		 10 -25.950786590576172 11 -26.021091461181641 12 -25.640825271606445 13 -24.244216918945313
		 14 -22.211654663085938 15 -20.395784378051758 16 -19.008697509765625 17 -18.114234924316406
		 18 -17.633325576782227 19 -17.388858795166016 20 -17.200899124145508 21 -16.896697998046875
		 22 -16.366443634033203 23 -15.560432434082031 24 -14.465676307678223 25 -13.128310203552246
		 26 -11.70195484161377;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateY_tempLayer_inputA";
	rename -uid "A99F7494-4D61-6FC3-B25F-7B8CE584BAB0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 2.1575164794921875 1 3.022334098815918
		 2 4.7571601867675781 3 7.0221281051635742 4 9.6831541061401367 5 12.659934043884277
		 6 15.785831451416016 7 18.866645812988281 8 21.662021636962891 9 23.939235687255859
		 10 25.520151138305664 11 26.028156280517578 12 25.376274108886719 13 23.900279998779297
		 14 21.492698669433594 15 18.234058380126953 16 14.602842330932617 17 11.057088851928711
		 18 7.9663314819335937 19 5.5732126235961914 20 3.954035758972168 21 3.0137224197387695
		 22 2.5186395645141602 23 2.2579154968261719 24 2.0955514907836914 25 2.0232057571411133
		 26 2.1575164794921875;
createNode animCurveTL -n "Character1_Ctrl_RightFootEffector_translateZ_tempLayer_inputA";
	rename -uid "F8F500F3-4F58-A314-AC7E-1C8F5D51DD78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -29.672792434692383 1 -36.155029296875
		 2 -41.955486297607422 3 -46.750801086425781 4 -50.055133819580078 5 -51.182487487792969
		 6 -50.065681457519531 7 -47.72735595703125 8 -44.372261047363281 9 -40.162769317626953
		 10 -35.182449340820312 11 -29.981338500976562 12 -24.094913482666016 13 -16.847652435302734
		 14 -9.8137044906616211 15 -3.4195971488952637 16 2.13187575340271 17 6.4654340744018555
		 18 9.1152563095092773 19 9.6827669143676758 20 7.9195995330810547 21 4.0760879516601562
		 22 -1.2204563617706299 23 -7.5067310333251953 24 -14.468941688537598 25 -21.906276702880859
		 26 -29.672792434692383;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAX";
	rename -uid "BB9C0D0D-4FB8-7DFE-B9B4-0E8FC33F34BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 41.724675439636961 1 41.281572109563569
		 2 40.05100380577484 3 38.178380837097478 4 35.804521105445779 5 33.064339744305741
		 6 30.087719155325619 7 27.002437612476076 8 23.938787076427747 9 21.0345415470582
		 10 18.437900071123259 11 16.307598351659855 12 14.809248847755708 13 13.181353934116396
		 14 12.162363899989442 15 11.351218144302194 16 10.833386707964136 17 10.930092026087999
		 18 12.305108853352019 19 15.730257223581509 20 20.992133035051555 21 27.085512448270613
		 22 32.76455782804431 23 37.131818621125198 24 39.91290782364181 25 41.317171029428494
		 26 41.724675439636961;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAY";
	rename -uid "67220C63-4994-90E9-C3F2-689F95F55841";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -1.4537586743218749 1 -1.2672633766294505
		 2 -0.73094430476254058 3 0.11679244870701344 4 1.2265844390023375 5 2.5341969573575498
		 6 3.96127652194129 7 5.4206700016148526 8 6.8258549796477812 9 8.1029916343282711
		 10 9.2035282512221936 11 10.115958078435002 12 10.87462129457418 13 11.588252041249884
		 14 13.098022304636268 15 15.089129134107202 16 17.396508008009317 17 19.801244313843718
		 18 21.935964741674791 19 23.150884548688374 20 22.780437806581308 21 20.339478383987046
		 22 15.896502607991367 23 10.220237054594758 24 4.5442786167850402 25 0.23157415942600398
		 26 -1.4537586743218749;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightFootEffector_rotate_tempLayer_inputAZ";
	rename -uid "82C57B1E-4733-2A64-DF7D-B991BDBDAAD6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 77.732876941103356 1 77.758034589687099
		 2 77.788072206352268 3 77.737108098557115 4 77.508853459191371 5 77.010806308364067
		 6 76.166590879763788 7 74.925055965076581 8 73.265915874306529 9 71.200993020405761
		 10 68.770211929159046 11 66.03400089314998 12 63.061937117560284 13 58.204254016405628
		 14 50.777926581272759 15 42.237528043474221 16 34.161560505641255 17 28.179182182645818
		 18 26.005567164967541 19 28.959132607481429 20 36.093394728670518 21 45.527752165086994
		 22 55.379048337517361 23 64.242449865193635 24 71.296109364549423 25 75.995510677469937
		 26 77.732876941103356;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "C9BC0E00-4B57-59B5-012B-C295E0810823";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 10.911225318908691 1 12.693582534790039
		 2 15.39381217956543 3 18.506864547729492 4 21.723356246948242 5 24.915441513061523
		 6 28.004402160644531 7 30.965297698974609 8 33.776473999023438 9 36.346885681152344
		 10 38.630691528320312 11 40.416591644287109 12 41.800697326660156 13 42.498294830322266
		 14 42.91607666015625 15 42.309967041015625 16 40.366676330566406 17 37.034233093261719
		 18 32.579967498779297 19 27.508955001831055 20 22.427896499633789 21 17.91032600402832
		 22 14.348922729492188 23 11.912166595458984 24 10.559713363647461 25 10.250727653503418
		 26 10.911225318908691;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "0B9B4854-4C29-E69B-8B39-968112B607FB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 95.095207214355469 1 94.795936584472656
		 2 94.815925598144531 3 94.614212036132813 4 93.920028686523438 5 93.0869140625 6 92.018112182617188
		 7 90.567825317382813 8 88.863212585449219 9 87.142036437988281 10 85.707077026367188
		 11 84.682266235351563 12 84.713844299316406 13 85.852951049804688 14 87.815071105957031
		 15 90.243858337402344 16 92.7901611328125 17 95.041488647460938 18 96.377891540527344
		 19 97.266609191894531 20 97.793647766113281 21 98.030525207519531 22 97.71923828125
		 23 97.094520568847656 24 96.430389404296875 25 95.755325317382813 26 95.095207214355469;
createNode animCurveTL -n "Character1_Ctrl_LeftShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "028634F8-43F0-A76A-056D-8BA9981A6B86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -26.663358688354492 1 -29.033283233642578
		 2 -31.833440780639648 3 -34.596046447753906 4 -37.152275085449219 5 -39.79632568359375
		 6 -42.421028137207031 7 -44.842697143554688 8 -46.9910888671875 9 -48.786766052246094
		 10 -50.034332275390625 11 -50.941360473632813 12 -50.495986938476563 13 -48.6978759765625
		 14 -45.070381164550781 15 -40.315845489501953 16 -34.99615478515625 17 -29.738397598266602
		 18 -24.946226119995117 19 -21.435443878173828 20 -19.470304489135742 21 -18.939352035522461
		 22 -19.766733169555664 23 -21.299034118652344 24 -23.018636703491211 25 -24.774885177612305
		 26 -26.663358688354492;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "F8435F8F-4860-5EC2-4BA7-F39029A8FB06";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -1.2784115793224902 1 -0.66183726205461824
		 2 1.1799468413842973 3 3.1101978489736108 4 4.8999770438181693 5 7.0953160367820658
		 6 10.154252545267218 7 13.348994866115186 8 16.014484855784936 9 17.904988379681086
		 10 18.41220260668646 11 17.230066157042931 12 13.661486702672395 13 7.7828074862673242
		 14 -0.13770922387070786 15 -10.001372714872925 16 -19.900553902384214 17 -26.612676066593448
		 18 -28.801602224457451 19 -25.290586266460569 20 -18.892211221415067 21 -13.272560783773969
		 22 -8.6555210459154281 23 -5.08084512286836 24 -2.6322704167683022 25 -1.3793722751791826
		 26 -1.2784115793224902;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "00741C4A-4BE9-8A6E-565D-838EF97FFF9B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 35.241262555389689 1 33.053868218942497
		 2 29.345902023612997 3 24.794799361298413 4 20.336333106984014 5 16.877770496063324
		 6 14.976863851137402 7 15.180652261323061 8 17.7174618733263 9 22.028477410872053
		 10 27.766310877883541 11 34.316923296607968 12 40.961657846498554 13 47.010175213295454
		 14 51.84227907430791 15 54.461828489986665 16 54.269691296599369 17 51.537405107988704
		 18 47.705950843247265 19 45.381461167346124 20 44.178906226690003 21 42.891165900192355
		 22 41.659679391750956 23 40.413358814857958 24 38.796449093673779 25 36.930430173490592
		 26 35.241262555389689;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "2E2B1068-4B3D-AB11-7063-EBA7457FA542";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -15.532349423865234 1 -10.055158346155682
		 2 -2.8060730879742732 3 5.7670589829621752 4 15.138500188466583 5 24.132451760963495
		 6 31.102827750371446 7 35.004202219316362 8 37.192499846751936 9 39.040028450201177
		 10 40.177715807967154 11 39.861462798313973 12 36.551309852659365 13 29.914070803916584
		 14 19.093884426100118 15 4.8850158635013443 16 -10.630187350337582 17 -24.259674007202822
		 18 -33.570430108522316 19 -35.353291356034113 20 -32.861524688102669 21 -30.636911770163938
		 22 -28.5253830858268 23 -26.180799242971005 24 -23.251993996614857 25 -19.638340390204068
		 26 -15.532349423865234;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateX_tempLayer_inputA";
	rename -uid "06958643-4FF1-6718-44D4-538A2B92BBDB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -29.855926513671875 1 -30.173702239990234
		 2 -29.242046356201172 3 -26.808395385742188 4 -22.770517349243164 5 -17.331539154052734
		 6 -11.11994457244873 7 -5.0253067016601562 8 0.24312019348144531 9 4.2996482849121094
		 10 6.8338279724121094 11 7.4443950653076172 12 6.3862361907958984 13 4.1753463745117187
		 14 1.3885135650634766 15 -1.7633495330810547 16 -5.0336380004882812 17 -8.2537879943847656
		 18 -11.327258110046387 19 -14.251955986022949 20 -17.114727020263672 21 -19.958934783935547
		 22 -22.633039474487305 23 -24.977092742919922 24 -27.012180328369141 25 -28.682731628417969
		 26 -29.855926513671875;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateY_tempLayer_inputA";
	rename -uid "0FBC676F-4AC7-4E97-81A1-2B8EB004B6BB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 85.487045288085938 1 86.296882629394531
		 2 88.200210571289062 3 90.447341918945313 4 92.429885864257813 5 94.138374328613281
		 6 95.211967468261719 7 95.418106079101563 8 94.967483520507813 9 94.207321166992188
		 10 93.483856201171875 11 92.890647888183594 12 92.892158508300781 13 93.341285705566406
		 14 93.90472412109375 15 94.364799499511719 16 94.579689025878906 17 94.406288146972656
		 18 93.463134765625 19 92.352790832519531 20 91.178138732910156 21 89.981086730957031
		 22 88.600608825683594 23 87.311111450195313 24 86.308334350585938 25 85.675949096679688
		 26 85.487045288085938;
createNode animCurveTL -n "Character1_Ctrl_RightShoulderEffector_translateZ_tempLayer_inputA";
	rename -uid "D48539F3-4548-2474-4EDE-5AAA3CCA4EAD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -44.527420043945313 1 -41.822532653808594
		 2 -37.938831329345703 3 -32.993560791015625 4 -27.587882995605469 5 -22.8408203125
		 6 -19.345319747924805 7 -17.373561859130859 8 -16.797466278076172 9 -17.220024108886719
		 10 -18.381771087646484 11 -20.628646850585937 12 -23.067295074462891 13 -25.273965835571289
		 14 -27.413124084472656 15 -29.640403747558594 16 -31.994239807128906 17 -34.428226470947266
		 18 -36.653579711914063 19 -38.907814025878906 20 -41.057777404785156 21 -42.908683776855469
		 22 -44.718482971191406 23 -46.135902404785156 24 -46.66815185546875 25 -46.128955841064453
		 26 -44.527420043945313;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAX";
	rename -uid "0FD63E64-4CA9-5177-66F9-B3A817131C7D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -49.595285158936633 1 -49.561177786982753
		 2 -48.587508629580235 3 -46.64936316536388 4 -43.848600546974431 5 -40.417973618743311
		 6 -36.65280139507324 7 -32.770641437632072 8 -28.960101427916126 9 -25.4931143736382
		 10 -22.704000886896115 11 -20.872636562222478 12 -20.034640004788258 13 -20.003470201643477
		 14 -20.061597008151207 15 -19.661475195631755 16 -18.260970766794884 17 -16.316780272381745
		 18 -15.292433258572027 19 -16.504805743953522 20 -20.464004964378933 21 -26.590685652149119
		 22 -33.613519082699121 23 -40.105953487206207 24 -45.077079559218546 25 -48.255206074118263
		 26 -49.595285158936633;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAY";
	rename -uid "FFC986FC-4D12-5CB5-A082-A184E9A75C7A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 16.440194270080376 1 14.74982871079723
		 2 13.183958835280018 3 12.238718854520197 4 12.490107748885794 5 14.221093795074127
		 6 17.228489955021317 7 20.988562398878688 8 24.774953678305543 9 28.060355881989228
		 10 30.630364730428344 11 32.518009026658859 12 34.02776951524374 13 35.55222003987128
		 14 37.176555707037537 15 38.925109840477987 16 40.463735029731261 17 41.302023326656226
		 18 41.214174459537993 19 40.257430576507254 20 38.551898666794415 21 36.001800193134855
		 22 32.370634233688982 23 27.841602021130441 24 23.135649277385031 25 19.05919286297102
		 26 16.440194270080376;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightShoulderEffector_rotate_tempLayer_inputAZ";
	rename -uid "D834FB5F-4CB3-5528-4AF3-BC997D1898DA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 16.5213916019156 1 9.7287460316434338
		 2 0.98453836461206301 3 -8.8257258106420871 4 -18.722641315573874 5 -27.796869520696578
		 6 -35.283853638303903 7 -40.36204805938128 8 -42.946499922916495 9 -43.63071079399235
		 10 -42.841584449211801 11 -40.781209927058896 12 -37.592276956092938 13 -33.9166086092226
		 14 -28.275130884809702 15 -20.641862954742351 16 -10.189578975069944 17 2.4468095370380021
		 18 14.982169172740786 19 25.28964845029374 20 31.813983081223434 21 34.092056437160849
		 22 33.084625677818799 23 30.199686199913156 24 26.293061458478832 25 21.712429164232777
		 26 16.5213916019156;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateX_tempLayer_inputA";
	rename -uid "D21C2444-493A-2CD3-9B80-148BC835CA49";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -13.504489898681641 1 -12.233871459960938
		 2 -9.6588802337646484 3 -5.9594359397888184 4 -1.2967257499694824 5 4.0997233390808105
		 6 9.8067865371704102 7 15.295499801635742 8 20.142898559570313 9 24.066051483154297
		 10 26.838214874267578 11 28.108539581298828 12 28.022417068481445 13 26.71734619140625
		 14 24.725688934326172 15 21.863733291625977 16 18.159223556518555 17 13.737616539001465
		 18 8.8528480529785156 19 3.8326666355133057 20 -0.99099588394165039 21 -5.2964181900024414
		 22 -8.7623805999755859 23 -11.244756698608398 24 -12.851524353027344 25 -13.605416297912598
		 26 -13.504489898681641;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateY_tempLayer_inputA";
	rename -uid "CE2E0A10-46F5-7ADC-B421-41978BC16DE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 106.74150085449219 1 107.12073516845703
		 2 108.22593688964844 3 109.37385559082031 4 110.09507751464844 5 110.54484558105469
		 6 110.49299621582031 7 109.76475524902344 8 108.55549621582031 9 107.18928527832031
		 10 106.02402496337891 11 105.19596862792969 12 105.27046203613281 13 106.18014526367187
		 14 107.57574462890625 15 109.127685546875 16 110.56223297119141 17 111.58784484863281
		 18 111.70504760742187 19 111.46588897705078 20 110.99423980712891 21 110.38143157958984
		 22 109.45266723632812 23 108.47411346435547 24 107.66542053222656 25 107.07498168945312
		 26 106.74150085449219;
createNode animCurveTL -n "Character1_Ctrl_HeadEffector_translateZ_tempLayer_inputA";
	rename -uid "F0C40A2A-491F-C805-4996-2BA388052CD2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -35.910816192626953 1 -35.666542053222656
		 2 -34.966133117675781 3 -33.683479309082031 4 -32.080528259277344 5 -30.896617889404297
		 6 -30.387517929077148 7 -30.587398529052734 8 -31.382795333862305 9 -32.521209716796875
		 10 -33.742034912109375 11 -35.289535522460937 12 -36.182945251464844 13 -36.246162414550781
		 14 -35.277351379394531 15 -33.786361694335938 16 -32.121871948242187 17 -30.614677429199219
		 18 -29.348606109619141 19 -28.857822418212891 20 -29.195465087890625 21 -30.172584533691406
		 22 -31.8280029296875 23 -33.609222412109375 24 -34.975509643554688 25 -35.730678558349609
		 26 -35.910816192626953;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAX";
	rename -uid "1FA194E7-445D-247C-7E61-BBBC84ACF0DB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -82.87983395165368 1 -72.185557198532081
		 2 -53.723447505444597 3 -30.178101952414607 4 -1.6797668642539596 5 29.517389281130974
		 6 58.251514328624445 7 80.827923591316718 8 95.468318803124447 9 100.67806911795068
		 10 99.105337904890703 11 94.894649710881382 12 88.734800472824062 13 81.763734548920084
		 14 73.70361045734856 15 64.78861496914125 16 51.447569281699842 17 30.537195837834421
		 18 2.8395726428850803 19 -27.995697513078031 20 -55.459481764636919 21 -75.61517284678807
		 22 -87.508627417812974 23 -92.361230389960497 24 -92.032525274317479 25 -88.242324255359321
		 26 -82.87983395165368;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAY";
	rename -uid "C26E402A-4905-D1DD-0302-40B271C3D999";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -10.324644966477551 1 -5.9919078693978474
		 2 2.2271929296181052 3 13.930632138557707 4 23.751620471039001 5 27.572678070750985
		 6 27.617174195400075 7 27.112248383327611 8 27.719870927904601 9 28.791838268393001
		 10 28.829480329754094 11 27.15973277741255 12 23.254455202871515 13 17.733635015100528
		 14 9.9811123586693835 15 0.87942638346790769 16 -9.8332533153223647 17 -20.95049511761907
		 18 -28.857343002191215 19 -30.673370731708079 20 -26.72219586689134 21 -20.838180389296479
		 22 -16.752955730604022 23 -14.903859304103358 24 -13.970791090069783 25 -12.75153649075563
		 26 -10.324644966477551;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_HeadEffector_rotate_tempLayer_inputAZ";
	rename -uid "DB0DBA23-4682-1FE8-9D39-D49AAA0FDED3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -46.133543686881595 1 -52.494618327244986
		 2 -58.985211977073156 3 -60.87273323829023 4 -55.74549288022115 5 -47.720712546906285
		 6 -42.326312294280598 7 -41.124345930776286 8 -42.724287836280524 9 -45.924195837520422
		 10 -50.570849112762069 11 -56.288896535913707 12 -62.078348867647037 13 -66.468891238031119
		 14 -69.229790176355962 15 -70.350454662202168 16 -68.722474840497952 17 -62.592468108339276
		 18 -51.529565922923425 19 -38.452327776989634 20 -29.16905729688764 21 -26.343135471430095
		 22 -27.935695866221256 23 -31.513159925503505 24 -36.042374932279863 25 -41.072910381915577
		 26 -46.133543686881595;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateX_tempLayer_inputA";
	rename -uid "0204212A-45D7-2562-6494-FFA1475F8915";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 27.427431106567383 1 27.546115875244141
		 2 28.077568054199219 3 28.72233772277832 4 29.243436813354492 5 29.534830093383789
		 6 29.551149368286133 7 29.316619873046875 8 28.821681976318359 9 28.067920684814453
		 10 27.199808120727539 11 26.208175659179687 12 25.621952056884766 13 25.86810302734375
		 14 26.768686294555664 15 28.002368927001953 16 29.360891342163086 17 30.638946533203125
		 18 31.675313949584961 19 32.338127136230469 20 32.511772155761719 21 32.150764465332031
		 22 31.301586151123047 23 30.148952484130859 24 28.933193206787109 25 27.932239532470703
		 26 27.427431106567383;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateY_tempLayer_inputA";
	rename -uid "04B78AD0-4324-EE8D-6B2D-3D820BEF2DCF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 58.81195068359375 1 57.954311370849609
		 2 56.086956024169922 3 53.08319091796875 4 49.137199401855469 5 45.073089599609375
		 6 41.176651000976563 7 37.498458862304688 8 34.1842041015625 9 31.413536071777344
		 10 29.325796127319336 11 27.838129043579102 12 27.363117218017578 13 27.83613395690918
		 14 29.068889617919922 15 30.961076736450195 16 33.437744140625 17 36.330799102783203
		 18 39.158451080322266 19 42.374164581298828 20 45.897193908691406 21 49.53033447265625
		 22 52.734756469726563 23 55.403167724609375 24 57.451377868652344 25 58.650318145751953
		 26 58.81195068359375;
createNode animCurveTL -n "Character1_Ctrl_LeftHipEffector_translateZ_tempLayer_inputA";
	rename -uid "964B9B37-46A4-CCC4-F380-AC816A34663F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.894623756408691 1 -10.659595489501953
		 2 -9.3755149841308594 3 -7.9199447631835937 4 -6.4772415161132813 5 -5.6473608016967773
		 6 -5.5685091018676758 7 -6.2980165481567383 8 -7.6884765625 9 -9.3986787796020508
		 10 -11.355503082275391 11 -14.033186912536621 12 -16.68254280090332 13 -19.146984100341797
		 14 -21.015567779541016 15 -22.423294067382812 16 -23.325397491455078 17 -23.666566848754883
		 18 -23.220573425292969 19 -22.338830947875977 20 -21.042579650878906 21 -19.389642715454102
		 22 -17.90461540222168 23 -16.478048324584961 24 -14.924013137817383 25 -13.318151473999023
		 26 -11.894623756408691;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAX";
	rename -uid "31DAED4A-4BD2-88A5-4D01-22BACD5B314F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 18.970366511079622 1 13.169177628351086
		 2 8.5241130576470372 3 5.2750442696767026 4 3.5678964782166585 5 3.5971947367648385
		 6 4.9090458968977959 7 6.5694749632527207 8 7.3046688000770104 9 7.6767885672080762
		 10 7.7043092698724625 11 7.419414792220131 12 6.4062889017947704 13 5.3843904121371597
		 14 4.9469995175463559 15 4.2824797507402872 16 3.5580015532491216 17 3.2242220896380589
		 18 3.0985603170807869 19 2.7947226431393646 20 2.5479958840963119 21 3.0887384842465679
		 22 5.2714835677185281 23 9.428675466478726 24 14.849229408573157 25 19.450977172397099
		 26 18.970366511079622;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAY";
	rename -uid "01DBF0B1-466D-E130-6592-659F6C5AB977";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -18.953423094551898 1 -15.146615524882399
		 2 -11.340776846621871 3 -8.9810122504477619 4 -8.5981612087885004 5 -10.216108558733181
		 6 -13.465617853428281 7 -17.525293306941734 8 -18.72230396992709 9 -19.155933404551323
		 10 -19.429668845940878 11 -19.26897008493555 12 -17.839445413177856 13 -15.046147844085027
		 14 -11.607406666543083 15 -7.1041596369658748 16 -3.0930859633722076 17 -1.169944763505242
		 18 -1.0925726614818991 19 -2.5921571766049296 20 -5.253799106274271 21 -8.7609492577313226
		 22 -12.741502294994618 23 -16.402917397490665 24 -19.139395161472493 25 -20.726613081600281
		 26 -18.953423094551898;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_LeftHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "BC331F35-471B-D600-2479-1893963B2B80";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -38.948601973844085 1 -45.670616426154993
		 2 -43.799431114105744 3 -39.856843171696312 4 -39.033640431776604 5 -40.506513683061343
		 6 -41.177373573856421 7 -40.719416872269377 8 -39.888891118797517 9 -37.226233186465244
		 10 -32.1082315771338 11 -26.135234446858366 12 -17.496853209208759 13 -6.6636330584045389
		 14 3.7075087445216868 15 12.059351206339649 16 18.981340629942821 17 25.070864732649124
		 18 30.640763405604176 19 34.353875547063375 20 34.646345628753451 21 31.058224333900586
		 22 22.806458260283495 23 10.549366611217765 24 -4.7935664712388979 25 -22.030299554112119
		 26 -38.948601973844085;
	setAttr ".roti" 5;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateX_tempLayer_inputA";
	rename -uid "FBDDF80C-4431-87B4-4090-4DAD506F54FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -11.566835403442383 1 -11.698777198791504
		 2 -12.424481391906738 3 -13.524324417114258 4 -14.684198379516602 5 -15.59147834777832
		 6 -16.120943069458008 7 -16.304977416992187 8 -16.111175537109375 9 -15.517433166503906
		 10 -14.709356307983398 11 -14.196788787841797 12 -14.033072471618652 13 -14.044361114501953
		 14 -14.230766296386719 15 -14.662626266479492 16 -15.222555160522461 17 -15.750884056091309
		 18 -16.080663681030273 19 -16.113811492919922 20 -15.857997894287109 21 -15.327640533447266
		 22 -14.565276145935059 23 -13.655004501342773 24 -12.741551399230957 25 -11.992050170898437
		 26 -11.566835403442383;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateY_tempLayer_inputA";
	rename -uid "678255F0-4930-DB78-6184-1C8D5313DDE7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 28.673051834106445 1 28.925949096679687
		 2 30.229501724243164 3 32.258232116699219 4 34.810813903808594 5 38.121223449707031
		 6 41.84429931640625 7 45.543922424316406 8 49.050289154052734 9 52.211460113525391
		 10 54.842384338378906 11 56.558799743652344 12 57.4642333984375 13 57.421501159667969
		 14 56.496528625488281 15 54.762550354003906 16 52.332626342773438 17 49.318569183349609
		 18 45.593509674072266 19 41.995204925537109 20 38.804664611816406 21 36.135971069335938
		 22 33.734458923339844 23 31.742681503295898 24 30.27635383605957 25 29.265485763549805
		 26 28.673051834106445;
createNode animCurveTL -n "Character1_Ctrl_RightHipEffector_translateZ_tempLayer_inputA";
	rename -uid "88320158-456F-5FBB-E7FC-B5A0F04B1286";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -18.993991851806641 1 -20.483076095581055
		 2 -22.425006866455078 3 -24.070863723754883 4 -25.036014556884766 5 -25.511993408203125
		 6 -25.39105224609375 7 -24.553001403808594 8 -23.159431457519531 9 -21.52606201171875
		 10 -19.830856323242188 11 -18.709991455078125 12 -17.528060913085937 13 -15.828547477722168
		 14 -14.227419853210449 15 -12.805349349975586 16 -11.72341251373291 17 -11.07239818572998
		 18 -10.679951667785645 19 -10.868266105651855 20 -11.589114189147949 21 -12.629371643066406
		 22 -14.091753959655762 23 -15.636600494384766 24 -16.937131881713867 25 -17.996894836425781
		 26 -18.993991851806641;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAX";
	rename -uid "35EADBE8-4C44-2B70-C210-3EA772F213BA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -10.215512587082937 1 -7.8568480811025658
		 2 -6.6085115575425535 3 -5.7241918099438109 4 -4.806743989485522 5 -4.1622665965101078
		 6 -4.5977782961357372 7 -5.7972624474423631 8 -7.6938145897702537 9 -10.341233611871113
		 10 -13.725458496134497 11 -16.827294183409979 12 -19.269470577128061 13 -21.343246063513703
		 14 -19.132679009209856 15 -13.116894956010162 16 -6.3237614051642419 17 -0.74113734538431431
		 18 2.5353023557664196 19 3.6460689139688629 20 2.501291854864268 21 -0.68347019248677621
		 22 -5.2798228972290762 23 -10.110871739460904 24 -13.273292629181778 25 -13.220554358870739
		 26 -10.215512587082937;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAY";
	rename -uid "719D6029-4614-9189-E44D-56A51400920F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 15.67104305277822 1 13.7647650171421 2 13.082948903009203
		 3 14.032882845592679 4 16.005990940770197 5 17.978915307410329 6 20.381962798330534
		 7 23.426418883850531 8 26.655227123327702 9 29.679221471583709 10 31.893706970040633
		 11 32.840977524312784 12 31.559873680536928 13 27.452006480860511 14 22.138964961373453
		 15 17.515017564596253 16 13.710434179453273 17 10.481392231448595 18 9.2055075037927754
		 19 10.971138723813437 20 14.051544294706282 21 16.062730962173941 22 16.961710638492079
		 23 17.280578717890421 24 17.517173282889164 25 17.307494587460042 26 15.67104305277822;
	setAttr ".roti" 5;
createNode animCurveTA -n "Character1_Ctrl_RightHipEffector_rotate_tempLayer_inputAZ";
	rename -uid "12664146-4ACC-1BE9-013E-EFA95D59F326";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -3.4026916772878995 1 8.720191647559334
		 2 16.324576093394803 3 22.609485938148417 4 27.983250545708223 5 29.501861628731238
		 6 26.978238629455099 7 23.683743980012125 8 19.816371749166805 9 15.06828317612983
		 10 9.0112139652372463 11 2.7803187355144012 12 -3.7148527745930857 13 -12.852764091474285
		 14 -19.552969061288053 15 -21.680115310646094 16 -20.554106055243508 17 -17.73989608924856
		 18 -18.978235538699206 19 -24.748195787291031 20 -32.212204368562389 21 -38.771287814325966
		 22 -43.028391222390589 23 -42.596675365382765 24 -35.352703030804953 25 -21.414328339380102
		 26 -3.4026916772879012;
	setAttr ".roti" 5;
createNode pairBlend -n "pairBlend1";
	rename -uid "8E826DA9-41B4-499A-80C4-9994606C99B0";
createNode pairBlend -n "pairBlend2";
	rename -uid "698B4CDD-4983-3CFF-9AB0-4493ABA10509";
createNode pairBlend -n "pairBlend3";
	rename -uid "29F17F7D-4F1D-E7AB-070D-C89397A17878";
createNode pairBlend -n "pairBlend4";
	rename -uid "15F7472C-430B-67B2-38F7-FFA9C09D5550";
createNode pairBlend -n "pairBlend5";
	rename -uid "6F1059CC-4A6C-2F74-4CD2-D78D9FB8DE64";
createNode pairBlend -n "pairBlend6";
	rename -uid "21F6B1C2-4C5A-ABF2-80EF-3BB959EB30E2";
createNode pairBlend -n "pairBlend7";
	rename -uid "40E0EDE7-4EFA-B9FD-F65B-08AAE4FF937A";
createNode pairBlend -n "pairBlend8";
	rename -uid "C32F9F03-4B98-5038-CF3C-19AECA705940";
createNode pairBlend -n "pairBlend9";
	rename -uid "16C0F9F6-4C74-7242-D079-18B0AA837AF1";
createNode pairBlend -n "pairBlend10";
	rename -uid "4E022054-4180-B33E-D533-E488D865FEA9";
createNode pairBlend -n "pairBlend11";
	rename -uid "BAFA21BC-4EFD-F2C4-E5F4-D0BCCF5E6A7F";
createNode pairBlend -n "pairBlend12";
	rename -uid "F45AAD5C-4F00-5138-2F68-7AA855B6BF5F";
createNode pairBlend -n "pairBlend13";
	rename -uid "243CF604-4037-18F2-893D-40A52704B345";
createNode pairBlend -n "pairBlend14";
	rename -uid "4B1F469F-4941-90F4-8BEE-62ACC57576AD";
createNode pairBlend -n "pairBlend15";
	rename -uid "E4C931E1-4AA7-624D-12D0-9C93D5A173A0";
createNode pairBlend -n "pairBlend16";
	rename -uid "6E653D3C-405B-8510-432F-BC8E6ADEDF49";
createNode pairBlend -n "pairBlend17";
	rename -uid "2D70042C-4958-59F4-3799-2FB9155099EC";
createNode pairBlend -n "pairBlend18";
	rename -uid "A4C3DB75-4D2A-54B5-836B-F7B10DDB2F66";
createNode pairBlend -n "pairBlend19";
	rename -uid "0DECCC43-407B-06D2-5AFE-9CBE1E41B4FE";
createNode pairBlend -n "pairBlend20";
	rename -uid "4E67BD6C-4DC0-FD5F-D4FC-8D9B52B24184";
createNode pairBlend -n "pairBlend21";
	rename -uid "F67C8CEA-4F48-2AAF-B5E1-2D88EA07D5A5";
createNode pairBlend -n "pairBlend22";
	rename -uid "3D177CE8-48EF-3D02-3317-098AEB4D195F";
createNode pairBlend -n "pairBlend23";
	rename -uid "9015D90E-4B21-7FEC-3E76-51BDD3B101C9";
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 26;
	setAttr ".unw" 26;
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
// End of overboss_flail.ma
