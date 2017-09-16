// Created by Crowbar 0.44.0.0

$modelname "creeps/roshan_halloween/roshan_halloween.mdl"

$bodygroup "default"
{
	studio "roshan_halloween_reference.smd"
}

$lod 1
{
	replacemodel "roshan_halloween_reference.smd" "roshan_halloween_body0_model0_lod1.smd"
	replacebone "cape4_0" "Head_1"
	replacebone "hat3_0" "Head_1"
	replacebone "cape4_1" "cape4_0"
	replacebone "cape4_2" "cape4_1"
	replacebone "hat3_1" "hat3_0"
	replacebone "weapon1_0" "wrist_L"
}

$surfaceprop "default"

$contents "solid"

$maxeyedeflection 90

$cdmaterials ""

$attachment "attach_attack2" "weapon1_0" 0 0 0 rotate 0 0 0
$attachment "attach_hitloc" "Head_0" 80 0 0 rotate 0 0 0
$attachment "attach_attack1" "pail2_1" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -232.482 -236.059 -50.823 171.125 234.679 365.688

// $hboxset "default"
// $hbox 0 "knee_R" -66.259911 -21.228577 -35.892227 13.468923 16.24465 17.880543 "knee_R"
// $hbox 0 "thigh_R" -94.45369 -59.127979 -30.700693 4.720778 30.207651 26.456381 "thigh_R"
// $hbox 0 "tail0_3" 2.133259 -8.39517 -8.436268 31.30685 8.39517 18.543097 "tail0_3"
// $hbox 0 "tail0_2" 3.166167 -13.688034 -17.886847 63.173973 13.688034 16.32411 "tail0_2"
// $hbox 0 "tail0_1" -2.448216 -19.405121 -20.955669 45.841816 19.405121 26.759829 "tail0_1"
// $hbox 0 "tail0_0" -2.471666 -32.677612 -31.868782 59.432652 32.677612 39.582176 "tail0_0"
// $hbox 0 "knee_L" -13.468923 -16.24465 -17.880543 66.259911 21.228577 35.892227 "knee_L"
// $hbox 0 "thigh_L" -4.720778 -30.207651 -26.456381 94.45369 24.088913 30.700693 "thigh_L"
// $hbox 0 "elbow_L" -18.462805 -50.854267 -21.6425 76.241676 18.035076 75.146027 "elbow_L"
// $hbox 0 "bicep_L" -18.303968 -40.573799 -38.173679 75.737549 30.578638 33.493263 "bicep_L"
// $hbox 0 "cape4_2" -11.614398 -49.69767 -9.631812 26.577837 49.956593 0 "cape4_2"
// $hbox 0 "cape4_1" -2.800727 -31.626221 -4.672211 20.506464 33.198502 5.693996 "cape4_1"
// $hbox 0 "cape4_0" 17.163004 -29.098949 -3.698234 31.729834 30.77557 6.564233 "cape4_0"
// $hbox 0 "hat3_1" -4.889725 -31.802425 -34.733448 44.847237 32.624409 34.268856 "hat3_1"
// $hbox 0 "hat3_0" -0.734374 -38.867668 -25.044018 25.672304 38.969486 27.999496 "hat3_0"
// $hbox 0 "wingtip2_0_A_L" -0.686482 -26.790861 -19.627848 128.927338 59.350365 15.500454 "wingtip2_0_A_L"
// $hbox 0 "Wing0_2_L" -34.048695 -20.7761 -22.763874 155.168533 84.416565 87.718643 "Wing0_2_L"
// $hbox 0 "Wing0_1_L" -38.578632 -16.241798 -0.07534 66.935249 47.026245 68.668732 "Wing0_1_L"
// $hbox 0 "Wing0_0_L" -13.7048 -15.457152 -10.494563 61.358257 18.099966 16.907343 "Wing0_0_L"
// $hbox 0 "pail2_1" -24.553015 -52.038254 -63.880573 53.116684 52.897087 63.040749 "pail2_1"
// $hbox 0 "elbow_R" -77.090286 -20.108126 -75.146027 18.462805 50.854267 21.6425 "elbow_R"
// $hbox 0 "bicep_R" -75.737549 -25.818817 -33.493263 18.303968 29.776825 38.173679 "bicep_R"
// $hbox 0 "wingtip3_0_A_R" -128.808289 -24.35689 -19.627848 1.541565 63.910667 15.500454 "wingtip3_0_A_R"
// $hbox 0 "Wing1_2_R" -160.032455 -71.909485 -91.570648 33.497524 24.960707 22.754404 "Wing1_2_R"
// $hbox 0 "Wing1_1_R" -66.935249 -10.984704 -66.808395 16.285341 16.473684 -5.622403 "Wing1_1_R"
// $hbox 0 "Wing1_0_R" -61.358257 -18.099966 -16.907343 13.7048 15.457152 10.494563 "Wing1_0_R"
// $hbox 0 "Spine_2" -13.11989 -63.575016 -63.276123 62.871239 63.575016 61.930813 "Spine_2"
// $hbox 0 "Spine_1" -33.702812 -75.100647 -65.091331 89.347496 121.125763 91.794487 "Spine_1"
// $hbox 0 "Spine_0" -10.985093 -45.714195 -50.260929 57.17382 45.714195 64.036827 "Spine_0"
// $hboxset "feet"
// $hbox 0 "ankle_R" -77.699486 -19.452143 -43.371529 17.296995 46.075825 31.286453 "ankle_R"
// $hbox 0 "ankle_L" -17.296995 -46.075825 -31.286453 77.699486 19.452143 43.371529 "ankle_L"
// $hboxset "hands"
// $hbox 0 "wrist_L" -10.153651 -22.678314 -43.445118 77.645386 45.976784 27.697561 "wrist_L"
// $hbox 0 "wrist_R" -77.645386 -45.976788 -28.03525 10.153651 22.678314 43.445118 "wrist_R"
// $hboxset "head"
// $hbox 0 "Head_1" -65.853172 -50.252209 -42.743725 63.479469 49.43103 89.444038 "Head_1"
// $hboxset "select_high"
// $hbox 0 "Root_0" 3.854895 -67.974487 -173.774246 157.838562 67.974487 76.090256 "Root_0"
// $hboxset "select_low"
// $hbox 0 "Root_0" -71.719261 -139.595184 -174.953613 219.820786 139.595184 192.77478 "Root_0"
// $skipboneinbbox

$bonemerge "Root_0"
$bonemerge "Spine_0"
$bonemerge "Spine_1"
$bonemerge "Spine_2"
$bonemerge "Head_0"
$bonemerge "Wing1_0_R"
$bonemerge "Wing0_0_L"
$bonemerge "clavicle_L"
$bonemerge "Head_1"
$bonemerge "cape4_0"
$bonemerge "hat3_0"
$bonemerge "cape4_1"
$bonemerge "cape4_2"
$bonemerge "hat3_1"
$bonemerge "Wing1_1_R"
$bonemerge "Wing1_2_R"
$bonemerge "wingtip3_0_A_R"
$bonemerge "Wing0_1_L"
$bonemerge "Wing0_2_L"
$bonemerge "wingtip2_0_A_L"
$bonemerge "bicep_L"
$bonemerge "elbow_L"
$bonemerge "wrist_L"
$bonemerge "weapon1_0"


$sectionframes 30 130

$sequence "BindPose" {
	"roshan_halloween_anims\BindPose.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "roshan_capture" {
	"roshan_halloween_anims\roshan_capture.smd"
	activity "ACT_DOTA_CAPTURE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "tot_roshan_idle" {
	"roshan_halloween_anims\tot_roshan_idle.smd"
	activity "ACT_DOTA_IDLE" 1
	activitymodifier trickortreat
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "tot_roshan_run" {
	"roshan_halloween_anims\tot_roshan_run.smd"
	activity "ACT_DOTA_RUN" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 19 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 38 "RoshanDT.Footstep" }
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "tot_roshan_attack" {
	"roshan_halloween_anims\tot_roshan_attack.smd"
	activity "ACT_DOTA_ATTACK" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 2 "RoshanDT.grunt" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "tot_roshan_attack2" {
	"roshan_halloween_anims\tot_roshan_attack2.smd"
	activity "ACT_DOTA_ATTACK" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 3 "RoshanDT.grunt" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "tot_roshan_askforcandy" {
	"roshan_halloween_anims\tot_roshan_askforcandy.smd"
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 15 "RoshanDT.Beg" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "tot_roshan_eatcandy" {
	"roshan_halloween_anims\tot_roshan_eatcandy.smd"
	activity "ACT_DOTA_CHANNEL_ABILITY_6" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 6 "RoshanDT.Eat" }
	{ event AE_CL_PLAYSOUND 178 "RoshanDT.Scream" }
	{ event AE_CL_PLAYSOUND 93 "RoshanDT.Sniff" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_idle" {
	"roshan_halloween_anims\sr_roshan_idle.smd"
	activity "ACT_DOTA_IDLE" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 14 "RoshanDT.Idle" }
	{ event AE_CL_PLAYSOUND 44 "RoshanDT.Idle" }
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "sr_roshan_run" {
	"roshan_halloween_anims\sr_roshan_run.smd"
	activity "ACT_DOTA_RUN" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 0 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 11 "RoshanDT.Footstep" }
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "sr_roshan_run_noMod" {
	"roshan_halloween_anims\sr_roshan_run_noMod.smd"
	activity "ACT_DOTA_RUN" 1
	{ event AE_CL_PLAYSOUND 0 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 11 "RoshanDT.Footstep" }
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "sr_roshan_die" {
	"roshan_halloween_anims\sr_roshan_die.smd"
	activity "ACT_DOTA_DIE" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 1 "RoshanDT.Death1" }
	{ event AE_CL_PLAYSOUND 30 "RoshanDT.Death2" }
	fadein 0.2
	fadeout 0.2
	fps 30
	localhierarchy "pail2_0" "" range 0 0 260 260
	localhierarchy "pail2_0" "" range 0 0 260 260
}

$sequence "sr_roshan_die_TEMP" {
	"roshan_halloween_anims\sr_roshan_die_TEMP.smd"
	activity "ACT_DOTA_DIE" 1
	activitymodifier trickortreat
	{ event AE_CL_PLAYSOUND 9 "Roshan.Footstep" }
	{ event AE_CL_PLAYSOUND 27 "Roshan.Footstep" }
	fadein 0.2
	fadeout 0.2
	fps 30
	localhierarchy "pail2_0" "" range 0 0 260 260
	localhierarchy "pail2_0" "" range 0 0 260 260
}

$sequence "sr_roshan_attack" {
	"roshan_halloween_anims\sr_roshan_attack.smd"
	activity "ACT_DOTA_ATTACK" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 1 "RoshanDT.grunt" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_attack2" {
	"roshan_halloween_anims\sr_roshan_attack2.smd"
	activity "ACT_DOTA_ATTACK" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 3 "RoshanDT.grunt" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_summon" {
	"roshan_halloween_anims\sr_roshan_summon.smd"
	activity "ACT_DOTA_CAST_ABILITY_1" 1
	activitymodifier sugarrush
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_slam" {
	"roshan_halloween_anims\sr_roshan_slam.smd"
	activity "ACT_DOTA_CAST_ABILITY_2" 1
	activitymodifier sugarrush
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_toss" {
	"roshan_halloween_anims\sr_roshan_toss.smd"
	activity "ACT_DOTA_CAST_ABILITY_3" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_firebreath" {
	"roshan_halloween_anims\sr_roshan_firebreath.smd"
	activity "ACT_DOTA_CAST_ABILITY_4" 1
	activitymodifier sugarrush
	{ event AE_CL_PLAYSOUND 1 "RoshanDT.FireBreath1" }
	{ event AE_CL_PLAYSOUND 45 "RoshanDT.FireBreath2" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_transition" {
	"roshan_halloween_anims\sr_transition.smd"
	activity "ACT_DOTA_IDLE" 1
	activitymodifier transition
	{ event AE_CL_CREATE_PARTICLE_EFFECT 12 "HW_ROSH_TRANSITION fa attach_attack1 fa attach_hitloc" }
	{ event AE_CL_PLAYSOUND 10 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 12 "RoshanDT.BucketDrop" }
	{ event AE_CL_PLAYSOUND 21 "RoshanDT.Gobble" }
	{ event AE_CL_PLAYSOUND 145 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 148 "RoshanDT.Footstep" }
	{ event AE_CL_PLAYSOUND 149 "RoshanDT.Scream2" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_bellyache_start" {
	"roshan_halloween_anims\sr_roshan_bellyache_start.smd"
	activity "ACT_DOTA_BELLYACHE_START" 1
	{ event AE_CL_PLAYSOUND 0 "RoshanDT.Bellyache" }
	{ event AE_CL_PLAYSOUND 45 "RoshanDT.TossImpact" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sr_roshan_bellyache_loop" {
	"roshan_halloween_anims\sr_roshan_bellyache_loop.smd"
	activity "ACT_DOTA_BELLYACHE_LOOP" 1
	{ event AE_CL_PLAYSOUND 22 "RoshanDT.Idle" }
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "sr_roshan_bellyache_end" {
	"roshan_halloween_anims\sr_roshan_bellyache_end.smd"
	activity "ACT_DOTA_BELLYACHE_END" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$KeyValues
{
}
