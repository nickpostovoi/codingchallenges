CREATE SCHEMA mps_data;

-- increase timeout times
SET GLOBAL wait_timeout=28800; 
SET GLOBAL max_execution_time = 28800;
SET GLOBAL interactive_timeout=28800;

SET GLOBAL local_infile=TRUE; --allow load from local files
SET GLOBAL innodb_buffer_pool_size = 4294967296; --increase buffer size to 4GB

-- create a table for use of force data
CREATE TABLE mps_data.use_of_force (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Date_time TIMESTAMP,
    Incident_Location_StreetHighway BIT,
    Incident_Location_Public_Transport BIT,
    Incident_Location_Retail_Premises BIT,
    Incident_Location_Open_ground_eg_park_car_park_field BIT,
    Incident_Location_Licensed_Premises BIT,
    Incident_Location_Sports_or_Event_Stadia BIT,
    Incident_Location_HospitalAE_non_mental_health_setting BIT,
    Incident_Location_Mental_Health_Setting BIT,
    Incident_Location_Police_vehicle_with_prisoner_handling_cage BIT,
    Incident_Location_Police_vehicle_without_prisoner_handling_cage BIT,
    Incident_Location_Dwelling BIT,
    Incident_Location_Police_station_excluding_custody_block BIT,
    Incident_Location_Custody_Block BIT,
    Incident_Location_Ambulance BIT,
    Incident_Location_Other BIT,
    Borough ENUM('Islington', 'Heathrow', 'Brent', 'Wandsworth', 'Southwark',
       'Greenwich', 'Croydon', 'Camden', 'Haringey', 'Harrow', 'Ealing',
       'Havering', 'Westminster', 'Newham', 'Barnet', 'Bromley',
       'Redbridge', 'Lambeth', 'Hillingdon', 'Enfield',
       'Hammersmith and Fulham', 'Hackney', 'Hounslow', 'Lewisham',
       'Bexley', 'Kingston upon Thames', 'Kensington and Chelsea',
       'Out of force', 'Barking and Dagenham', 'Sutton', 'Tower Hamlets',
       'Waltham Forest', 'Merton', 'Richmond upon Thames'),
    PrimaryConduct TINYINT CHECK (PrimaryConduct BETWEEN 0 AND 5),
    AssaultedBySubject BIT,
    ThreatenedWithWeapon TEXT,
    AssaultedWithWeapon TEXT,
    Impact_Factor_Possesion_of_a_weapon BIT,
    Impact_Factor_Alcohol BIT,
    Impact_Factor_Drugs BIT,
    Impact_Factor_Mental_Health BIT,
    Impact_Factor_Prior_Knowledge BIT,
    Impact_Factor_SizeGenderBuild BIT,
    Impact_Factor_Acute_Behavioural_Disorder BIT,
    Impact_Factor_Crowd BIT,
    Impact_Factor_Other BIT,
    Reason_for_Force_Protect_self BIT,
    Reason_for_Force_Protect_Public BIT,
    Reason_for_Force_Protect_Subject BIT,
    Reason_for_Force_Protect_Other_Officers BIT,
    Reason_for_Force_Prevent_Offence BIT,
    Reason_for_Force_Secure_Evidence BIT,
    Reason_for_Force_Effect_Search BIT,
    Reason_for_Force_Effect_Arrest BIT,
    Reason_for_Force_Method_of_Entry BIT,
    Reason_for_Force_Remove_Handcuffs BIT,
    Reason_for_Force_Prevent_Harm BIT,
    Reason_for_Force_Prevent_Escape BIT,
    Reason_for_Force_Other BIT,
    MainDuty VARCHAR(255),
    SingleCrewed BIT,
    TrainedCED BIT,
    CarryingCED BIT,
    Tactic_1 TINYINT,
    Effective_1 BIT,
    Tactic_2 TINYINT,
    Effective_2 BIT,
    Tactic_3 TINYINT,
    Effective_3 BIT,
    Tactic_4 TINYINT,
    Effective_4 BIT,
    Tactic_5 TINYINT,
    Effective_5 BIT,
    Tactic_6 TINYINT,
    Effective_6 BIT,
    Tactic_7 TINYINT,
    Effective_7 BIT,
    Tactic_8 TINYINT,
    Effective_8 BIT,
    Tactic_9 TINYINT,
    Effective_9 BIT,
    Tactic_10 TINYINT,
    Effective_10 BIT,
    Tactic_11 TINYINT,
    Effective_11 BIT,
    Tactic_12 TINYINT,
    Effective_12 BIT,
    Tactic_13 TINYINT,
    Effective_13 BIT,
    Tactic_14 TINYINT,
    Effective_14 BIT,
    Tactic_15 TINYINT,
    Effective_15 BIT,
    Tactic_16 TINYINT,
    Effective_16 BIT,
    Tactic_17 TINYINT,
    Effective_17 BIT,
    Tactic_18 TINYINT,
    Effective_18 BIT,
    Tactic_19 TINYINT,
    Effective_19 BIT,
    Tactic_20 TINYINT,
    Tactic_Effective_20 BIT,
    SubjectAge TINYINT CHECK (SubjectAge BETWEEN 0 AND 5),
    SubjectGender VARCHAR(255),
    SubjectEthnicity VARCHAR(255),
    PhysicalDisability BIT,
    MentalDisability BIT,
    StaffInjured VARCHAR(255),
    StaffInjuryIntentional BIT,
    StaffInjuryLevel VARCHAR(255),
    StaffMedProvided BIT,
    SubjectInjured BIT,
    SubjectNatureOfInjury VARCHAR(255),
    SubjectMedOffered BIT,
    SubjectMedProvided BIT,
    Outcome_Made_offescaped BIT,
    Outcome_Arrested BIT,
    Outcome_Hospitalised BIT,
    Outcome_Detained___Mental_Health_Act BIT,
    Outcome_Fatality BIT,
    Outcome_Other BIT
);

-- specify the function for tactics mapping
DELIMITER //
CREATE FUNCTION GetTacticValue(Tactic VARCHAR(255))
RETURNS INT DETERMINISTIC
BEGIN
    RETURN (CASE 
        WHEN Tactic = 'Tactical Communications' THEN 1
        WHEN Tactic = 'Compliant Handcuffing' THEN 2
        WHEN Tactic = 'Unarmed Skills (including pressure points, strikes, restraints and take-downs)' THEN 3
        WHEN Tactic = 'Non-Compliant Handcuffing' THEN 4
        WHEN Tactic = 'Ground Restraint' THEN 5
        WHEN Tactic = 'Limb/Body Restraints' THEN 6
        WHEN Tactic = 'Spit Guard' THEN 7
        WHEN Tactic = 'Shield' THEN 8
        WHEN Tactic = 'Dog Deployed' THEN 9
        WHEN Tactic = 'Other/Improvised' THEN 10
        WHEN Tactic = 'Irritant Spray - CS Drawn' THEN 11
        WHEN Tactic = 'Irritant Spray - PAVA Drawn' THEN 12
        WHEN Tactic = 'CED (Taser) Drawn' THEN 13
        WHEN Tactic = 'Baton Drawn' THEN 14
        WHEN Tactic = 'CED (Taser) Red-Dotted' THEN 15
        WHEN Tactic = 'CED (Taser) Aimed' THEN 16
        WHEN Tactic = 'CED (Taser) Arced' THEN 17
        WHEN Tactic = 'AEP Aimed' THEN 18
        WHEN Tactic = 'Firearm Aimed' THEN 19
        WHEN Tactic = 'Irritant Spray - CS Used' THEN 20
        WHEN Tactic = 'Irritant Spray - PAVA Used' THEN 21
        WHEN Tactic = 'CED (Taser) Drive Stun' THEN 22
        WHEN Tactic = 'CED (Taser) Angle Drive Stun' THEN 23
        WHEN Tactic = 'CED (Taser) Fired' THEN 24
        WHEN Tactic = 'Dog Bite' THEN 25
        WHEN Tactic = 'Baton Used' THEN 26
        WHEN Tactic = 'Firearm Fired' THEN 27
        ELSE NULL
    END);
END//
DELIMITER ;

-- load the data into created table
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/use_of_force_data.csv' 
INTO TABLE `use_of_force` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@Incident_Location_StreetHighway,
@Incident_Location_Public_Transport,
@Incident_Location_Retail_Premises,
@Incident_Location_Open_ground_eg_park_car_park_field,
@Incident_Location_Licensed_Premises,
@Incident_Location_Sports_or_Event_Stadia,
@Incident_Location_HospitalAE_non_mental_health_setting,
@Incident_Location_Mental_Health_Setting,
@Incident_Location_Police_vehicle_with_prisoner_handling_cage,
@Incident_Location_Police_vehicle_without_prisoner_handling_cage,
@Incident_Location_Dwelling,
@Incident_Location_Police_station_excluding_custody_block,
@Incident_Location_Custody_Block,
@Incident_Location_Ambulance,
@Incident_Location_Other,
@Borough,
@PrimaryConduct,
@AssaultedBySubject,
@ThreatenedWithWeapon,
@AssaultedWithWeapon,
@Impact_Factor_Possesion_of_a_weapon,
@Impact_Factor_Alcohol,
@Impact_Factor_Drugs,
@Impact_Factor_Mental_Health,
@Impact_Factor_Prior_Knowledge,
@Impact_Factor_SizeGenderBuild,
@Impact_Factor_Acute_Behavioural_Disorder,
@Impact_Factor_Crowd,
@Impact_Factor_Other,
@Reason_for_Force_Protect_self,
@Reason_for_Force_Protect_Public,
@Reason_for_Force_Protect_Subject,
@Reason_for_Force_Protect_Other_Officers,
@Reason_for_Force_Prevent_Offence,
@Reason_for_Force_Secure_Evidence,
@Reason_for_Force_Effect_Search,
@Reason_for_Force_Effect_Arrest,
@Reason_for_Force_Method_of_Entry,
@Reason_for_Force_Remove_Handcuffs,
@Reason_for_Force_Prevent_Harm,
@Reason_for_Force_Prevent_Escape,
@Reason_for_Force_Other,
@MainDuty,
@SingleCrewed,
@TrainedCED,
@CarryingCED,
@Tactic_1,
@Effective_1,
@Tactic_2,
@Effective_2,
@Tactic_3,
@Effective_3,
@Tactic_4,
@Effective_4,
@Tactic_5,
@Effective_5,
@Tactic_6,
@Effective_6,
@Tactic_7,
@Effective_7,
@Tactic_8,
@Effective_8,
@Tactic_9,
@Effective_9,
@Tactic_10,
@Effective_10,
@Tactic_11,
@Effective_11,
@Tactic_12,
@Effective_12,
@Tactic_13,
@Effective_13,
@Tactic_14,
@Effective_14,
@Tactic_15,
@Effective_15,
@Tactic_16,
@Effective_16,
@Tactic_17,
@Effective_17,
@Tactic_18,
@Effective_18,
@Tactic_19,
@Effective_19,
@Tactic_20,
@Tactic_Effective_20,
@CED_Drawn,
@CED_Aimed,
@CED_Arced,
@CED_Red_Dotted,
@CED_Drive_Stun,
@CED_Drive_Stun_Repeat_Application,
@CED_Angle_Drive_Stun,
@CED_Fired,
@CED_Fired_Cartridge_Number,
@CED_Fired_5_Secs_Cycle_Interrupted,
@CED_Fired_Repeat_Cycle_Same_Cartridge,
@CED_Fired_Total_Number_Of_Cycles,
@CED_Fired_Cycle_Extended_Beyond_5_Secs,
@CED_Fired_Miss_With_One_Probe,
@CED_Fired_Miss_With_Both_Probes,
@CED_Front_1,
@CED_Front_2,
@CED_Front_3,
@CED_Front_4,
@CED_Front_5,
@CED_Front_6,
@CED_Front_7,
@CED_Front_8,
@CED_Front_9,
@CED_Front_10,
@CED_Front_11,
@CED_Front_12,
@CED_Front_13,
@CED_Front_14,
@CED_Front_15,
@CED_Back_A,
@CED_Back_B,
@CED_Back_C,
@CED_Back_D,
@CED_Back_E,
@CED_Back_F,
@CED_Back_G,
@CED_Back_H,
@CED_Back_J,
@CED_Back_K,
@CED2_Drawn,
@CED2_Aimed,
@CED2_ArCED2,
@CED2_Red_Dotted,
@CED2_Drive_Stun,
@CED2_Drive_Stun_Repeat_Application,
@CED2_Angle_Drive_Stun,
@CED2_Fired,
@CED2_Fired_Cartridge_Number,
@CED2_Fired_5_Secs_Cycle_Interrupted,
@CED2_Fired_Repeat_Cycle_Same_Cartridge,
@CED2_Fired_Total_Number_Of_Cycles,
@CED2_Fired_Cycle_Extended_Beyond_5_Secs,
@CED2_Fired_Miss_With_One_Probe,
@CED2_Fired_Miss_With_Both_Probes,
@CED2_Front_1,
@CED2_Front_2,
@CED2_Front_3,
@CED2_Front_4,
@CED2_Front_5,
@CED2_Front_6,
@CED2_Front_7,
@CED2_Front_8,
@CED2_Front_9,
@CED2_Front_10,
@CED2_Front_11,
@CED2_Front_12,
@CED2_Front_13,
@CED2_Front_14,
@CED2_Front_15,
@CED2_Back_A,
@CED2_Back_B,
@CED2_Back_C,
@CED2_Back_D,
@CED2_Back_E,
@CED2_Back_F,
@CED2_Back_G,
@CED2_Back_H,
@CED2_Back_J,
@CED2_Back_K,
@CED3_Drawn,
@CED3_Aimed,
@CED3_ArCED3,
@CED3_Red_Dotted,
@CED3_Drive_Stun,
@CED3_Drive_Stun_Repeat_Application,
@CED3_Angle_Drive_Stun,
@CED3_Fired,
@CED3_Fired_Cartridge_Number,
@CED3_Fired_5_Secs_Cycle_Interrupted,
@CED3_Fired_Repeat_Cycle_Same_Cartridge,
@CED3_Fired_Total_Number_Of_Cycles,
@CED3_Fired_Cycle_Extended_Beyond_5_Secs,
@CED3_Fired_Miss_With_One_Probe,
@CED3_Fired_Miss_With_Both_Probes,
@CED3_Front_1,
@CED3_Front_2,
@CED3_Front_3,
@CED3_Front_4,
@CED3_Front_5,
@CED3_Front_6,
@CED3_Front_7,
@CED3_Front_8,
@CED3_Front_9,
@CED3_Front_10,
@CED3_Front_11,
@CED3_Front_12,
@CED3_Front_13,
@CED3_Front_14,
@CED3_Front_15,
@CED3_Back_A,
@CED3_Back_B,
@CED3_Back_C,
@CED3_Back_D,
@CED3_Back_E,
@CED3_Back_F,
@CED3_Back_G,
@CED3_Back_H,
@CED3_Back_J,
@CED3_Back_K,
@CED4_Drawn,
@CED4_Aimed,
@CED4_ArCED4,
@CED4_Red_Dotted,
@CED4_Drive_Stun,
@CED4_Drive_Stun_Repeat_Application,
@CED4_Angle_Drive_Stun,
@CED4_Fired,
@CED4_Fired_Cartridge_Number,
@CED4_Fired_5_Secs_Cycle_Interrupted,
@CED4_Fired_Repeat_Cycle_Same_Cartridge,
@CED4_Fired_Total_Number_Of_Cycles,
@CED4_Fired_Cycle_Extended_Beyond_5_Secs,
@CED4_Fired_Miss_With_One_Probe,
@CED4_Fired_Miss_With_Both_Probes,
@CED4_Front_1,
@CED4_Front_2,
@CED4_Front_3,
@CED4_Front_4,
@CED4_Front_5,
@CED4_Front_6,
@CED4_Front_7,
@CED4_Front_8,
@CED4_Front_9,
@CED4_Front_10,
@CED4_Front_11,
@CED4_Front_12,
@CED4_Front_13,
@CED4_Front_14,
@CED4_Front_15,
@CED4_Back_A,
@CED4_Back_B,
@CED4_Back_C,
@CED4_Back_D,
@CED4_Back_E,
@CED4_Back_F,
@CED4_Back_G,
@CED4_Back_H,
@CED4_Back_J,
@CED4_Back_K,
@Firearms_Aimed,
@Firearms_Fired,
@SubjectAge,
@SubjectGender,
@SubjectEthnicity,
@PhysicalDisability,
@MentalDisability,
@StaffInjured,
@StaffInjuryIntentional,
@StaffInjuryLevel,
@StaffMedProvided,
@SubjectInjured,
@SubjectNatureOfInjury,
@SubjectMedOffered,
@SubjectMedProvided,
@Outcome_Made_offescaped,
@Outcome_Arrested,
@Outcome_Hospitalised,
@Outcome_Detained___Mental_Health_Act,
@Outcome_Fatality,
@Outcome_Other,
@Date_time)
SET
	--one-hot encoding
    Incident_Location_StreetHighway = IF(@Incident_Location_StreetHighway='Yes', 1, IF(@Incident_Location_StreetHighway='No', 0, NULL)),
    Incident_Location_Public_Transport = IF(@Incident_Location_Public_Transport='Yes', 1, IF(@Incident_Location_Public_Transport='No', 0, NULL)),
    Incident_Location_Retail_Premises = IF(@Incident_Location_Retail_Premises='Yes', 1, IF(@Incident_Location_Retail_Premises='No', 0, NULL)),
    Incident_Location_Open_ground_eg_park_car_park_field = IF(@Incident_Location_Open_ground_eg_park_car_park_field='Yes', 1, IF(@Incident_Location_Open_ground_eg_park_car_park_field='No', 0, NULL)),
    Incident_Location_Licensed_Premises = IF(@Incident_Location_Licensed_Premises='Yes', 1, IF(@Incident_Location_Licensed_Premises='No', 0, NULL)),
    Incident_Location_Sports_or_Event_Stadia = IF(@Incident_Location_Sports_or_Event_Stadia='Yes', 1, IF(@Incident_Location_Sports_or_Event_Stadia='No', 0, NULL)),
    Incident_Location_HospitalAE_non_mental_health_setting = IF(@Incident_Location_HospitalAE_non_mental_health_setting='Yes', 1, IF(@Incident_Location_HospitalAE_non_mental_health_setting='No', 0, NULL)),
    Incident_Location_Mental_Health_Setting = IF(@Incident_Location_Mental_Health_Setting='Yes', 1, IF(@Incident_Location_Mental_Health_Setting='No', 0, NULL)),
    Incident_Location_Police_vehicle_with_prisoner_handling_cage = IF(@Incident_Location_Police_vehicle_with_prisoner_handling_cage='Yes', 1, IF(@Incident_Location_Police_vehicle_with_prisoner_handling_cage='No', 0, NULL)),
    Incident_Location_Police_vehicle_without_prisoner_handling_cage = IF(@Incident_Location_Police_vehicle_without_prisoner_handling_cage='Yes', 1, IF(@Incident_Location_Police_vehicle_without_prisoner_handling_cage='No', 0, NULL)),
    Incident_Location_Dwelling = IF(@Incident_Location_Dwelling='Yes', 1, IF(@Incident_Location_Dwelling='No', 0, NULL)),
    Incident_Location_Police_station_excluding_custody_block = IF(@Incident_Location_Police_station_excluding_custody_block='Yes', 1, IF(@Incident_Location_Police_station_excluding_custody_block='No', 0, NULL)),
    Incident_Location_Custody_Block = IF(@Incident_Location_Custody_Block='Yes', 1, IF(@Incident_Location_Custody_Block='No', 0, NULL)),
    Incident_Location_Ambulance = IF(@Incident_Location_Ambulance='Yes', 1, IF(@Incident_Location_Ambulance='No', 0, NULL)),
    Incident_Location_Other = IF(@Incident_Location_Other='Yes', 1, IF(@Incident_Location_Other='No', 0, NULL)),
    AssaultedBySubject = IF(@AssaultedBySubject='Yes', 1, IF(@AssaultedBySubject='No', 0, NULL)),
	Impact_Factor_Possesion_of_a_weapon = IF(@Impact_Factor_Possesion_of_a_weapon='Yes', 1, IF(@Impact_Factor_Possesion_of_a_weapon='No', 0, NULL)),
	Impact_Factor_Alcohol = IF(@Impact_Factor_Alcohol='Yes', 1, IF(@Impact_Factor_Alcohol='No', 0, NULL)),
	Impact_Factor_Drugs = IF(@Impact_Factor_Drugs='Yes', 1, IF(@Impact_Factor_Drugs='No', 0, NULL)),
	Impact_Factor_Mental_Health = IF(@Impact_Factor_Mental_Health='Yes', 1, IF(@Impact_Factor_Mental_Health='No', 0, NULL)),
	Impact_Factor_Prior_Knowledge = IF(@Impact_Factor_Prior_Knowledge='Yes', 1, IF(@Impact_Factor_Prior_Knowledge='No', 0, NULL)),
	Impact_Factor_SizeGenderBuild = IF(@Impact_Factor_SizeGenderBuild='Yes', 1, IF(@Impact_Factor_SizeGenderBuild='No', 0, NULL)),
	Impact_Factor_Acute_Behavioural_Disorder = IF(@Impact_Factor_Acute_Behavioural_Disorder='Yes', 1, IF(@Impact_Factor_Acute_Behavioural_Disorder='No', 0, NULL)),
	Impact_Factor_Crowd = IF(@Impact_Factor_Crowd='Yes', 1, IF(@Impact_Factor_Crowd='No', 0, NULL)),
	Impact_Factor_Other = IF(@Impact_Factor_Other='Yes', 1, IF(@Impact_Factor_Other='No', 0, NULL)),
	Reason_for_Force_Protect_self = IF(@Reason_for_Force_Protect_self='Yes', 1, IF(@Reason_for_Force_Protect_self='No', 0, NULL)),
	Reason_for_Force_Protect_Public = IF(@Reason_for_Force_Protect_Public='Yes', 1, IF(@Reason_for_Force_Protect_Public='No', 0, NULL)),
	Reason_for_Force_Protect_Subject = IF(@Reason_for_Force_Protect_Subject='Yes', 1, IF(@Reason_for_Force_Protect_Subject='No', 0, NULL)),
	Reason_for_Force_Protect_Other_Officers = IF(@Reason_for_Force_Protect_Other_Officers='Yes', 1, IF(@Reason_for_Force_Protect_Other_Officers='No', 0, NULL)),
	Reason_for_Force_Prevent_Offence = IF(@Reason_for_Force_Prevent_Offence='Yes', 1, IF(@Reason_for_Force_Prevent_Offence='No', 0, NULL)),
	Reason_for_Force_Secure_Evidence = IF(@Reason_for_Force_Secure_Evidence='Yes', 1, IF(@Reason_for_Force_Secure_Evidence='No', 0, NULL)),
	Reason_for_Force_Effect_Search = IF(@Reason_for_Force_Effect_Search='Yes', 1, IF(@Reason_for_Force_Effect_Search='No', 0, NULL)),
	Reason_for_Force_Effect_Arrest = IF(@Reason_for_Force_Effect_Arrest='Yes', 1, IF(@Reason_for_Force_Effect_Arrest='No', 0, NULL)),
	Reason_for_Force_Method_of_Entry = IF(@Reason_for_Force_Method_of_Entry='Yes', 1, IF(@Reason_for_Force_Method_of_Entry='No', 0, NULL)),
	Reason_for_Force_Remove_Handcuffs = IF(@Reason_for_Force_Remove_Handcuffs='Yes', 1, IF(@Reason_for_Force_Remove_Handcuffs='No', 0, NULL)),
	Reason_for_Force_Prevent_Harm = IF(@Reason_for_Force_Prevent_Harm='Yes', 1, IF(@Reason_for_Force_Prevent_Harm='No', 0, NULL)),
	Reason_for_Force_Prevent_Escape = IF(@Reason_for_Force_Prevent_Escape='Yes', 1, IF(@Reason_for_Force_Prevent_Escape='No', 0, NULL)),
	Reason_for_Force_Other = IF(@Reason_for_Force_Other='Yes', 1, IF(@Reason_for_Force_Other='No', 0, NULL)),
	SingleCrewed = IF(@SingleCrewed='Yes', 1, IF(@SingleCrewed='No', 0, NULL)),
	TrainedCED = IF(@TrainedCED='Yes', 1, IF(@TrainedCED='No', 0, NULL)),
	CarryingCED = IF(@CarryingCED='Yes', 1, IF(@CarryingCED='No', 0, NULL)),
	Effective_1 = IF(@Effective_1='Yes', 1, IF(@Effective_1='No', 0, NULL)),
	Effective_2 = IF(@Effective_2='Yes', 1, IF(@Effective_2='No', 0, NULL)),
	Effective_3 = IF(@Effective_3='Yes', 1, IF(@Effective_3='No', 0, NULL)),
	Effective_4 = IF(@Effective_4='Yes', 1, IF(@Effective_4='No', 0, NULL)),
	Effective_5 = IF(@Effective_5='Yes', 1, IF(@Effective_5='No', 0, NULL)),
	Effective_6 = IF(@Effective_6='Yes', 1, IF(@Effective_6='No', 0, NULL)),
	Effective_7 = IF(@Effective_7='Yes', 1, IF(@Effective_7='No', 0, NULL)),
	Effective_8 = IF(@Effective_8='Yes', 1, IF(@Effective_8='No', 0, NULL)),
	Effective_9 = IF(@Effective_9='Yes', 1, IF(@Effective_9='No', 0, NULL)),
	Effective_10 = IF(@Effective_10='Yes', 1, IF(@Effective_10='No', 0, NULL)),
	Effective_11 = IF(@Effective_11='Yes', 1, IF(@Effective_11='No', 0, NULL)),
	Effective_12 = IF(@Effective_12='Yes', 1, IF(@Effective_12='No', 0, NULL)),
	Effective_13 = IF(@Effective_13='Yes', 1, IF(@Effective_13='No', 0, NULL)),
	Effective_14 = IF(@Effective_14='Yes', 1, IF(@Effective_14='No', 0, NULL)),
	Effective_15 = IF(@Effective_15='Yes', 1, IF(@Effective_15='No', 0, NULL)),
	Effective_16 = IF(@Effective_16='Yes', 1, IF(@Effective_16='No', 0, NULL)),
	Effective_17 = IF(@Effective_17='Yes', 1, IF(@Effective_17='No', 0, NULL)),
	Effective_18 = IF(@Effective_18='Yes', 1, IF(@Effective_18='No', 0, NULL)),
	Effective_19 = IF(@Effective_19='Yes', 1, IF(@Effective_19='No', 0, NULL)),
	Tactic_Effective_20 = IF(@Tactic_Effective_20='Yes', 1, IF(@Tactic_Effective_20='No', 0, NULL)),
	PhysicalDisability = IF(@PhysicalDisability='Yes', 1, IF(@PhysicalDisability='No', 0, NULL)),
	MentalDisability = IF(@MentalDisability='Yes', 1, IF(@MentalDisability='No', 0, NULL)),
	StaffInjuryIntentional = IF(@StaffInjuryIntentional='Yes', 1, IF(@StaffInjuryIntentional='No', 0, NULL)),
	StaffMedProvided = IF(@StaffMedProvided='Yes', 1, IF(@StaffMedProvided='No', 0, NULL)),
	SubjectInjured = IF(@SubjectInjured='Yes', 1, IF(@SubjectInjured='No', 0, NULL)),
	SubjectMedOffered = IF(@SubjectMedOffered='Yes', 1, IF(@SubjectMedOffered='No', 0, NULL)),
	SubjectMedProvided = IF(@SubjectMedProvided='Yes', 1, IF(@SubjectMedProvided='No', 0, NULL)),
	Outcome_Made_offescaped = IF(@Outcome_Made_offescaped='Yes', 1, IF(@Outcome_Made_offescaped='No', 0, NULL)),
	Outcome_Arrested = IF(@Outcome_Arrested='Yes', 1, IF(@Outcome_Arrested='No', 0, NULL)),
	Outcome_Hospitalised = IF(@Outcome_Hospitalised='Yes', 1, IF(@Outcome_Hospitalised='No', 0, NULL)),
	Outcome_Detained___Mental_Health_Act = IF(@Outcome_Detained___Mental_Health_Act='Yes', 1, IF(@Outcome_Detained___Mental_Health_Act='No', 0, NULL)),
	Outcome_Fatality = IF(@Outcome_Fatality='Yes', 1, IF(@Outcome_Fatality='No', 0, NULL)),
	Outcome_Other = IF(@Outcome_Other='Yes', 1, IF(@Outcome_Other='No', 0, NULL)),
    --integer encoding (remapping)
    PrimaryConduct = 
        CASE 
            WHEN @PrimaryConduct='Compliant' THEN 0
            WHEN @PrimaryConduct='Passive resistance' THEN 1
            WHEN @PrimaryConduct='Verbal resistance/gestures' THEN 2
            WHEN @PrimaryConduct='Active resistance' THEN 3
            WHEN @PrimaryConduct='Aggressive resistance' THEN 4
            WHEN @PrimaryConduct='Serious or aggravated resistance' THEN 5
            ELSE NULL
        END,
	SubjectAge = 
        CASE 
            WHEN @SubjectAge='0-10' THEN 0
            WHEN @SubjectAge='11-17' THEN 1
            WHEN @SubjectAge='18-34' THEN 2
            WHEN @SubjectAge='35-49' THEN 3
            WHEN @SubjectAge='50-64' THEN 4
            WHEN @SubjectAge='65 and over' THEN 5
            ELSE NULL
        END,
	Tactic_1 = GetTacticValue(@Tactic_1),
    Tactic_2 = GetTacticValue(@Tactic_2),
    Tactic_3 = GetTacticValue(@Tactic_3),
    Tactic_4 = GetTacticValue(@Tactic_4),
    Tactic_5 = GetTacticValue(@Tactic_5),
    Tactic_6 = GetTacticValue(@Tactic_6),
    Tactic_7 = GetTacticValue(@Tactic_7),
    Tactic_8 = GetTacticValue(@Tactic_8),
	Tactic_9 = GetTacticValue(@Tactic_9),
	Tactic_10 = GetTacticValue(@Tactic_10),
	Tactic_11 = GetTacticValue(@Tactic_11),
	Tactic_12 = GetTacticValue(@Tactic_12),
	Tactic_13 = GetTacticValue(@Tactic_13),
	Tactic_14 = GetTacticValue(@Tactic_14),
	Tactic_15 = GetTacticValue(@Tactic_15),
	Tactic_16 = GetTacticValue(@Tactic_16),
	Tactic_17 = GetTacticValue(@Tactic_17),
	Tactic_18 = GetTacticValue(@Tactic_18),
	Tactic_19 = GetTacticValue(@Tactic_19),
	Tactic_20 = GetTacticValue(@Tactic_20),
	--other columns
    Borough = IF(@Borough='City of Westminster', 'Westminster', @Borough),
    Date_time = STR_TO_DATE(TRIM(@Date_time), '%Y-%m-%d %H:%i:%s'),
    ThreatenedWithWeapon = NULLIF(@ThreatenedWithWeapon, ''),
	AssaultedWithWeapon = NULLIF(@AssaultedWithWeapon, ''),
	MainDuty = NULLIF(@MainDuty, ''),
	SubjectGender = NULLIF(@SubjectGender, ''),
	SubjectEthnicity = NULLIF(@SubjectEthnicity, ''),
	StaffInjured = NULLIF(@StaffInjured, ''),
	StaffInjuryLevel = NULLIF(@StaffInjuryLevel, ''),
	SubjectNatureOfInjury = NULLIF(@SubjectNatureOfInjury, '')
    ;
    
SHOW TABLE STATUS LIKE 'use_of_force';
    
-- create census tables 
CREATE TABLE mps_data.census_popdensity (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    population_density DOUBLE
    );
CREATE TABLE mps_data.census_sex (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
    female DOUBLE,
    male DOUBLE
    );
CREATE TABLE mps_data.census_deprivation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
    not_deprived DOUBLE,
    deprived_1dim DOUBLE,
    deprived_2dim DOUBLE,
    deprived_3dim DOUBLE,
    deprived_4dim DOUBLE
    );
CREATE TABLE mps_data.census_residence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
    born_uk DOUBLE,
    10_more DOUBLE,
    5_to_10 DOUBLE,
    2_to_5 DOUBLE,
    2_less DOUBLE
    );
CREATE TABLE mps_data.census_ethnic (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
	asian DOUBLE,
    black DOUBLE,
    mixed DOUBLE,
    white DOUBLE,
    other DOUBLE
    );
CREATE TABLE mps_data.census_heating (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
	no_heating DOUBLE,
    gas_only DOUBLE,
    bottled_gas_only DOUBLE,
    electric_only DOUBLE,
    district_only DOUBLE,
    other_central_heating_only DOUBLE,
    two_or_more_no_renewable DOUBLE,
    two_or_more_with_renewable DOUBLE
    );
CREATE TABLE mps_data.census_qualification (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
	no_qualifications DOUBLE,
    level_1 DOUBLE,
    level_2 DOUBLE,
    apprenticeship DOUBLE,
    level_3 DOUBLE,
    level_4 DOUBLE,
    other_qualifications DOUBLE
    );
CREATE TABLE mps_data.census_student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
	student DOUBLE
    );
CREATE TABLE mps_data.census_orientation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    geography VARCHAR(255),
    total DOUBLE,
	hetero DOUBLE,
    gay_lesbian DOUBLE,
    bisexual DOUBLE,
    other DOUBLE,	
    no_answer DOUBLE
    );

-- load data into census tables
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts006-ltla.csv' 
INTO TABLE `census_popdensity` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @population_density)
SET
    geography = @geography,
    population_density = @population_density
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts008-ltla.csv' 
INTO TABLE `census_sex` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @sex_total, @sex_female, @sex_male)
SET
    geography = @geography,
    total = @sex_total,
    female = @sex_female,
    male = @sex_male
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts011-ltla.csv' 
INTO TABLE `census_deprivation` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@not_deprived, @deprived_1dim, @deprived_2dim, 
@deprived_3dim, @deprived_4dim)
SET
	geography = @geography, 
    total = @total, 
    not_deprived = @not_deprived,
    deprived_1dim = @deprived_1dim,
    deprived_2dim = @deprived_2dim,
    deprived_3dim = @deprived_3dim,
    deprived_4dim = @deprived_4dim
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts016-ltla.csv' 
INTO TABLE `census_residence` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@born_uk, @10_more, @5_to_10, 
@2_to_5, @2_less)
SET
	geography = @geography, 
    total = @total, 
	born_uk = @born_uk,
    10_more = @10_more,
	5_to_10 = @5_to_10,
    2_to_5 = @2_to_5,
    2_less = @2_less
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts021-ltla.csv' 
INTO TABLE `census_ethnic` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@asian_total, @asian_bangladeshi, @asian_chinese, @asian_indian, @asian_pakistani, @asian_other,
@black_total, @black_african, @black_carribean, @black_other,
@mixed_total, @mixed_white_asian, @mixed_white_blackafr, @mixed_white_blackcar, @mixed_other,
@white_total, @white_british, @white_irish, @white_gypsy, @white_roma, @white_other,
@other_total, @other_arab, @other_other)
SET
	geography = @geography, 
    total = @total, 
	asian = @asian_total,
    black = @black_total,
    mixed = @mixed_total,
    white = @white_total,
    other = @other_total
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts046-ltla.csv' 
INTO TABLE `census_heating` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@no_central_heating,
@gas_only,
@tank_or_bottled_gas_only,
@electric_only,
@oil_only,
@wood_only,
@solid_fuel_only,
@renewable_energy_only,
@district_or_communal_heat_networks_only,
@other_central_heating_only,
@two_or_more_no_renewable,
@two_or_more_with_renewable)
SET
	geography = @geography, 
    total = @total, 
	no_heating = @no_central_heating,
    gas_only = @gas_only, 
    bottled_gas_only = @tank_or_bottled_gas_only,
    electric_only = @electric_only,
    district_only = @district_or_communal_heat_networks_only,
    other_central_heating_only = @other_central_heating_only,
    two_or_more_no_renewable = @two_or_more_no_renewable,
    two_or_more_with_renewable = @two_or_more_with_renewable
    ;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts067-ltla.csv' 
INTO TABLE `census_qualification` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@no_qualifications, @level_1, @level_2, @apprenticeship,
@level_3, @level_4, @other_qualifications)
SET
	geography = @geography, 
    total = @total, 
	no_qualifications = @no_qualifications,
    level_1 = @level_1,
    level_2 = @level_2,
    apprenticeship = @apprenticeship,
    level_3 = @level_3,
    level_4 = @level_4,
    other_qualifications = @other_qualifications
    ;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts068-ltla.csv' 
INTO TABLE `census_student` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@student, @not_student)
SET
	geography = @geography, 
    total = @total, 
	student = @student
    ;
    
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/census2021-ts077-ltla.csv' 
INTO TABLE `census_orientation` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@date, @geography, @geography_code, @total, 
@hetero, @gay_lesbian, @bisexual, 
@other, @no_answer)
SET
	geography = @geography, 
    total = @total, 
	hetero = @hetero,
    gay_lesbian = @gay_lesbian,
    bisexual = @bisexual,
    other = @other,
    no_answer = @no_answer
    ;

-- street-crime data table
CREATE TABLE mps_data.street_crime (
    id INT AUTO_INCREMENT PRIMARY KEY,
    yearmonth TIMESTAMP,
    reported_by VARCHAR(255),
    falls_within VARCHAR(255),
    longitude DECIMAL(10,6),
    latitude DECIMAL(9,6),
    lsoa VARCHAR(255),
    crime_type VARCHAR(255)
    );

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/street_crime_data.csv' 
INTO TABLE `street_crime` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@crimeid, @month, @reported_by, @falls_within, 
@longitude, @latitude, @location, @lsoa_code,
@lsoa_name, @crime_type, @last_outcome, @context)
SET
    yearmonth = STR_TO_DATE(CONCAT(@month, '-01'), '%Y-%m-%d'),
    reported_by = @reported_by,
    falls_within = @falls_within,
    longitude = IF(@longitude='', NULL, @longitude),
    latitude = IF(@latitude='', NULL, @latitude),
    lsoa = SUBSTRING(@lsoa_name, 1, CHAR_LENGTH(@lsoa_name) - LOCATE(' ', REVERSE(@lsoa_name))),
    crime_type = @crime_type
    ;

DELETE FROM street_crime
WHERE reported_by != 'Metropolitan Police Service' 
OR falls_within != 'Metropolitan Police Service' 
OR latitude IS NULL 
OR longitude IS NULL 
OR lsoa IS NULL;

ALTER TABLE street_crime
DROP COLUMN reported_by,
DROP COLUMN falls_within;

-- 4. DATABASE NORMALISATION

-- create a dictionary for boroughs
CREATE TABLE borough_dict (
    id INT AUTO_INCREMENT PRIMARY KEY,
    borough VARCHAR(255) UNIQUE
);

-- insert unique Borough values from both street_crime (from lsoa column) and use_of_force tables:
INSERT INTO borough_dict (borough)
SELECT DISTINCT lsoa FROM street_crime
WHERE lsoa IN (SELECT DISTINCT Borough FROM use_of_force);

-- add a new column borough_id in all three tables and update it with the id values from the borough_dict table
-- street crime
ALTER TABLE street_crime
ADD COLUMN borough_id INT;
UPDATE street_crime sc
INNER JOIN borough_dict bd ON sc.lsoa = bd.borough
SET sc.borough_id = bd.id;
DELETE FROM street_crime
WHERE borough_id IS NULL;
ALTER TABLE street_crime
DROP COLUMN lsoa;

--use of force
ALTER TABLE use_of_force
ADD COLUMN borough_id INT;
UPDATE use_of_force uof
INNER JOIN borough_dict bd ON uof.Borough = bd.borough
SET uof.borough_id = bd.id;
DELETE FROM use_of_force
WHERE borough_id IS NULL;
ALTER TABLE use_of_force
DROP COLUMN Borough;

--census
ALTER TABLE census_deprivation
ADD COLUMN borough_id INT;
UPDATE census_deprivation c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_deprivation
WHERE borough_id IS NULL;
ALTER TABLE census_deprivation
DROP COLUMN geography;

ALTER TABLE census_ethnic
ADD COLUMN borough_id INT;
UPDATE census_ethnic c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_ethnic
WHERE borough_id IS NULL;
ALTER TABLE census_ethnic
DROP COLUMN geography;

ALTER TABLE census_heating
ADD COLUMN borough_id INT;
UPDATE census_heating c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_heating
WHERE borough_id IS NULL;
ALTER TABLE census_heating
DROP COLUMN geography;

ALTER TABLE census_orientation
ADD COLUMN borough_id INT;
UPDATE census_orientation c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_orientation
WHERE borough_id IS NULL;
ALTER TABLE census_orientation
DROP COLUMN geography;

ALTER TABLE census_popdensity
ADD COLUMN borough_id INT;
UPDATE census_popdensity c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_popdensity
WHERE borough_id IS NULL;
ALTER TABLE census_popdensity
DROP COLUMN geography;

ALTER TABLE census_qualification
ADD COLUMN borough_id INT;
UPDATE census_qualification c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_qualification
WHERE borough_id IS NULL;
ALTER TABLE census_qualification
DROP COLUMN geography;

ALTER TABLE census_residence
ADD COLUMN borough_id INT;
UPDATE census_residence c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_residence
WHERE borough_id IS NULL;
ALTER TABLE census_residence
DROP COLUMN geography;

ALTER TABLE census_sex
ADD COLUMN borough_id INT;
UPDATE census_sex c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_sex
WHERE borough_id IS NULL;
ALTER TABLE census_sex
DROP COLUMN geography;

ALTER TABLE census_student
ADD COLUMN borough_id INT;
UPDATE census_student c
INNER JOIN borough_dict bd ON c.geography = bd.borough
SET c.borough_id = bd.id;
DELETE FROM census_student
WHERE borough_id IS NULL;
ALTER TABLE census_student
DROP COLUMN geography;

--index the crime type
ALTER TABLE street_crime ADD INDEX crime_type_index (crime_type);

DROP TABLE tactic_dict;
--create a tactics dictioary
CREATE TABLE mps_data.tactic_dict (
    id TINYINT UNIQUE NOT NULL,
    tactic VARCHAR(255),
    ranking_1 TINYINT,
    ranking_2 TINYINT,
    ranking_3 TINYINT,
    ranking_4 TINYINT
    );
--load data into a tactics dictionary
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tactics_dictionary_copy.csv' 
INTO TABLE `tactic_dict` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(@tactic,@id,@ranking_1,@ranking_2,@ranking_3,@ranking_4)
SET
    id = @id,
    tactic = @tactic,
    ranking_1 = @ranking_1, --tactics on a scale from 0 to 5
    ranking_2 = @ranking_2, --whether physical force was used or not
    ranking_3 = @ranking_3, --whether the subject was compliant or NOT
    ranking_4 = @ranking_4 --tactics on a winsorized scale
    ;

--ensure that you cannot add a record to tables unless the 'borough_id' exists in 'borough_dict'
ALTER TABLE street_crime
ADD CONSTRAINT street_crime_borough_fk
FOREIGN KEY (borough_id) REFERENCES borough_dict(id);
ALTER TABLE use_of_force
ADD CONSTRAINT use_of_force_borough_fk
FOREIGN KEY (borough_id) REFERENCES borough_dict(id);

CREATE TABLE crime_rates AS
SELECT sc.borough_id, ROUND(COUNT(*) / total, 5) AS crime_rate
FROM street_crime sc
LEFT JOIN (
    SELECT total, borough_id from census_ethnic
) c_e ON sc.borough_id = c_e.borough_id
WHERE crime_type IN ('Criminal damage and arson',
                     'Violence and sexual offences',
                     'Burglary', 'Robbery',
                     'Possession of weapons')
GROUP BY sc.borough_id;

--create a view for inference modelling
CREATE VIEW inference_view AS
SELECT 
    --time-based features
    uof.Date_time AS date_time,
    YEAR(uof.Date_time) AS year,
    MONTH(uof.Date_time) AS month,
    DAY(uof.Date_time) AS day_of_month,
    DAYOFWEEK(uof.Date_time) AS day_of_week,
    HOUR(uof.Date_time) AS hour_of_day,
    MINUTE(uof.Date_time) AS minute_of_hour,
    CASE
        WHEN DAYOFWEEK(uof.Date_time) IN (1,7) THEN 1
        ELSE 0
    END AS is_weekend,
    --officer-related
    uof.MainDuty as main_duty,
    COALESCE(uof.TrainedCED, 0) AS ced_trained,
    COALESCE(uof.CarryingCED, 0) AS ced_carrying,
    --location-related
    bd.borough AS borough,
    uof.Incident_Location_StreetHighway AS location_street, 
    uof.Incident_Location_Public_Transport AS location_pubtrans, 
    uof.Incident_Location_Retail_Premises AS location_retail,
    uof.Incident_Location_Open_ground_eg_park_car_park_field AS location_openground, 
    uof.Incident_Location_Licensed_Premises AS location_licensed, 
    uof.Incident_Location_HospitalAE_non_mental_health_setting AS location_hospital, 
    uof.Incident_Location_Mental_Health_Setting AS location_mentalhealth, 
    uof.Incident_Location_Dwelling AS location_dwelling,
    uof.Incident_Location_Other AS location_other,
    --encounter-related
    uof.PrimaryConduct as primary_conduct, 
    uof.AssaultedBySubject as officer_assaulted,
    uof.Impact_Factor_Possesion_of_a_weapon AS impfct_weapon,
    uof.Impact_Factor_Alcohol AS impfct_alcohol, 
    uof.Impact_Factor_Drugs AS impfct_drugs, 
    uof.Impact_Factor_Mental_Health AS impfct_mentalhealth, 
    uof.Impact_Factor_Prior_Knowledge AS impfct_pknowledge, 
    uof.Impact_Factor_SizeGenderBuild AS impfct_sizegenderbuild, 
    uof.Impact_Factor_Acute_Behavioural_Disorder AS impfct_ABD, 
    uof.Impact_Factor_Crowd AS impfct_crowd, 
    uof.Impact_Factor_Other AS impfct_other,
    uof.Reason_for_Force_Protect_self AS reason_protectself, 
    uof.Reason_for_Force_Protect_Public  AS reason_protectpublic, 
    uof.Reason_for_Force_Protect_Subject AS reason_protectsubject, 
    uof.Reason_for_Force_Protect_Other_Officers AS reason_protectofficers,  
    uof.Reason_for_Force_Prevent_Offence AS reason_preventoffence,  
    uof.Reason_for_Force_Secure_Evidence AS reason_evidence,  
    uof.Reason_for_Force_Effect_Search AS reason_search, 
    uof.Reason_for_Force_Effect_Arrest AS reason_arrest, 
    uof.Reason_for_Force_Prevent_Harm AS reason_preventharm,
    uof.Reason_for_Force_Prevent_Escape AS reason_preventescape, 
    uof.Reason_for_Force_Other AS reason_other,
    IF(FIND_IN_SET('Firearm', AssaultedWithWeapon) > 0, 1, 0) AS assaulted_with_firearm,
    IF(FIND_IN_SET('Firearm', ThreatenedWithWeapon) > 0, 1, 0) AS threatened_with_firearm,
    IF(FIND_IN_SET('Spit', AssaultedWithWeapon) > 0
        OR FIND_IN_SET('Missile/object thrown', AssaultedWithWeapon) > 0, 1, 0) AS assaulted_spit_throw,
    IF(FIND_IN_SET('Bite', AssaultedWithWeapon) > 0, 1, 0) AS assaulted_bite,
    IF(FIND_IN_SET('Kick', AssaultedWithWeapon) > 0
       OR FIND_IN_SET('Punch', AssaultedWithWeapon) > 0
       OR FIND_IN_SET('Headbutt', AssaultedWithWeapon) > 0, 1, 0) AS assaulted_without_weapon,
    IF(FIND_IN_SET('Pointed weapon/object', ThreatenedWithWeapon) > 0
       OR FIND_IN_SET('Bladed weapon/object', ThreatenedWithWeapon) > 0
       OR FIND_IN_SET('Blunt weapon/object', ThreatenedWithWeapon) > 0, 1, 0) AS threatened_with_object,
    IF(FIND_IN_SET('Pointed weapon/object', AssaultedWithWeapon) > 0
       OR FIND_IN_SET('Bladed weapon/object', AssaultedWithWeapon) > 0
       OR FIND_IN_SET('Blunt weapon/object', AssaultedWithWeapon) > 0, 1, 0) AS assaulted_with_object,
	CASE 
           WHEN StaffInjured = 'Yes' THEN 1
           WHEN StaffInjured = 'Yes, I was injured as a result of an assault' THEN 1
           ELSE 0
       END AS is_staffinjured,
	--subject-related
	CASE 
           WHEN SubjectEthnicity = 'White' THEN 1
           ELSE 0
       END AS is_white,
	CASE 
           WHEN SubjectGender = 'Male' THEN 1
           ELSE 0
       END AS is_male,
    uof.SubjectAge AS subject_age,
    uof.PhysicalDisability AS physical_disability,
    uof.MentalDisability AS mental_disability,
   --integration variables
   c_d.not_deprived AS census_not_deprived,
   c_e.white AS census_white_ethnic,
   c_h.no_heating AS census_no_heating,
   c_o.hetero AS census_heterosexual,
   c_o.gay_lesbian AS census_gay_lesbian,
   c_o.no_answer AS census_no_answer_orientation,
   c_p.population_density AS census_pop_density,
   c_q.entry_level AS census_low_qualification,
   c_q.high_qualification AS census_high_qualification,
   c_r.born_uk AS census_born_uk,
   c_s.student AS census_student,
   s_c.crime_rate AS mps_crime_rate,
   --response (target) variables
	GREATEST(
	   COALESCE(t1.ranking_1, 0),
	   COALESCE(t2.ranking_1, 0),
	   COALESCE(t3.ranking_1, 0),
	   COALESCE(t4.ranking_1, 0),
	   COALESCE(t5.ranking_1, 0),
	   COALESCE(t6.ranking_1, 0),
	   COALESCE(t7.ranking_1, 0),
	   COALESCE(t8.ranking_1, 0),
	   COALESCE(t9.ranking_1, 0),
	   COALESCE(t10.ranking_1, 0),
	   COALESCE(t11.ranking_1, 0),
	   COALESCE(t12.ranking_1, 0),
	   COALESCE(t13.ranking_1, 0),
	   COALESCE(t14.ranking_1, 0),
	   COALESCE(t15.ranking_1, 0),
	   COALESCE(t16.ranking_1, 0),
	   COALESCE(t17.ranking_1, 0),
	   COALESCE(t18.ranking_1, 0),
	   COALESCE(t19.ranking_1, 0),
	   COALESCE(t20.ranking_1, 0)
   ) AS max_tactic,
   (
    IF(uof.Tactic_1 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_2 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_3 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_4 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_5 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_6 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_7 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_8 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_9 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_10 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_11 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_12 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_13 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_14 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_15 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_16 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_17 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_18 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_19 IS NOT NULL, 1, 0) +
    IF(uof.Tactic_20 IS NOT NULL, 1, 0)
    ) AS tactics_count
FROM use_of_force uof
-- Joins
LEFT JOIN ( 
SELECT 
	ROUND(not_deprived/total, 5) as not_deprived,
	ROUND(deprived_1dim/total, 5) as deprived_1dim,
    ROUND(deprived_2dim/total, 5) as deprived_2dim,
    ROUND(deprived_3dim/total, 5) as deprived_3dim,
    ROUND(deprived_4dim/total, 5) as deprived_4dim,
    borough_id
FROM census_deprivation
) c_d ON uof.borough_id = c_d.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(white/total, 5) as white,
    borough_id
FROM census_ethnic
) c_e ON uof.borough_id = c_e.borough_id
LEFT JOIN ( 
SELECT
	ROUND(no_heating/total, 5) as no_heating,
    borough_id
FROM census_heating
) c_h ON uof.borough_id = c_h.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(hetero/total, 5) as hetero,
    ROUND(gay_lesbian/total, 5) as gay_lesbian,
    ROUND(no_answer/total, 5) as no_answer,
    borough_id
from census_orientation
) c_o ON uof.borough_id = c_o.borough_id
LEFT JOIN ( 
SELECT 
	population_density,
    borough_id
from census_popdensity
) c_p ON uof.borough_id = c_p.borough_id
LEFT JOIN ( 
SELECT 
	ROUND((no_qualifications+level_1)/total, 5) as entry_level,
    ROUND(other_qualifications/total, 5) as high_qualification,
    borough_id
from census_qualification c_q
) c_q ON uof.borough_id = c_q.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(born_uk/total, 5) as born_uk,
    borough_id
from census_residence c_r
) c_r ON uof.borough_id = c_r.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(student/total, 5) as student,
    borough_id
FROM census_student c_s
) c_s ON uof.borough_id = c_s.borough_id
LEFT JOIN ( 
	-- SELECT sc.borough_id, ROUND(COUNT(*)/total, 5) AS crime_rate
	-- FROM street_crime sc
	-- LEFT JOIN ( 
	-- 	SELECT total, borough_id from census_ethnic
	-- ) c_e ON sc.borough_id = c_e.borough_id
	-- WHERE crime_type IN ('Criminal damage and arson', 
	-- 					'Violence and sexual offences',
	-- 					'Burglary', 'Robbery', 
    --                     'Possession of weapons')
	-- GROUP BY sc.borough_id
    SELECT * FROM crime_rates
) s_c ON uof.borough_id = s_c.borough_id
LEFT JOIN borough_dict bd ON uof.borough_id = bd.id
LEFT JOIN tactic_dict t1 ON uof.Tactic_1 = t1.id
LEFT JOIN tactic_dict t2 ON uof.Tactic_2 = t2.id
LEFT JOIN tactic_dict t3 ON uof.Tactic_3 = t3.id
LEFT JOIN tactic_dict t4 ON uof.Tactic_4 = t4.id
LEFT JOIN tactic_dict t5 ON uof.Tactic_5 = t5.id
LEFT JOIN tactic_dict t6 ON uof.Tactic_6 = t6.id
LEFT JOIN tactic_dict t7 ON uof.Tactic_7 = t7.id
LEFT JOIN tactic_dict t8 ON uof.Tactic_8 = t8.id
LEFT JOIN tactic_dict t9 ON uof.Tactic_9 = t9.id
LEFT JOIN tactic_dict t10 ON uof.Tactic_10 = t10.id
LEFT JOIN tactic_dict t11 ON uof.Tactic_11 = t11.id
LEFT JOIN tactic_dict t12 ON uof.Tactic_12 = t12.id
LEFT JOIN tactic_dict t13 ON uof.Tactic_13 = t13.id
LEFT JOIN tactic_dict t14 ON uof.Tactic_14 = t14.id
LEFT JOIN tactic_dict t15 ON uof.Tactic_15 = t15.id
LEFT JOIN tactic_dict t16 ON uof.Tactic_16 = t16.id
LEFT JOIN tactic_dict t17 ON uof.Tactic_17 = t17.id
LEFT JOIN tactic_dict t18 ON uof.Tactic_18 = t18.id
LEFT JOIN tactic_dict t19 ON uof.Tactic_19 = t19.id
LEFT JOIN tactic_dict t20 ON uof.Tactic_20 = t20.id
-- Filters
WHERE uof.Outcome_Made_offescaped != 1 AND
uof.Incident_Location_Police_vehicle_with_prisoner_handling_cage != 1 AND
uof.Incident_Location_Police_vehicle_without_prisoner_handling_cage != 1 AND
uof.Incident_Location_Police_station_excluding_custody_block != 1 AND
uof.Incident_Location_Custody_Block != 1 AND
uof.Incident_Location_Ambulance != 1 AND
uof.Incident_Location_Sports_or_Event_Stadia != 1;

-- DROP VIEW modelling_view;
--create view for foreknowledge modelling
CREATE VIEW modelling_view AS
SELECT 
    --time-based features
    uof.Date_time AS date_time,
    YEAR(uof.Date_time) AS year,
    MONTH(uof.Date_time) AS month,
    DAY(uof.Date_time) AS day_of_month,
    DAYOFWEEK(uof.Date_time) AS day_of_week,
    HOUR(uof.Date_time) AS hour_of_day,
    CASE
        WHEN DAYOFWEEK(uof.Date_time) IN (1,7) THEN 1
        ELSE 0
    END AS is_weekend,
    --officer-related
    uof.MainDuty as main_duty,
    COALESCE(uof.TrainedCED, 0) AS ced_trained,
    COALESCE(uof.CarryingCED, 0) AS ced_carrying,
    --location-related
    bd.borough AS borough,
    uof.Incident_Location_StreetHighway AS location_street, 
    uof.Incident_Location_Public_Transport AS location_pubtrans, 
    uof.Incident_Location_Retail_Premises AS location_retail,
    uof.Incident_Location_Open_ground_eg_park_car_park_field AS location_openground, 
    uof.Incident_Location_Licensed_Premises AS location_licensed, 
    uof.Incident_Location_HospitalAE_non_mental_health_setting AS location_hospital, 
    uof.Incident_Location_Mental_Health_Setting AS location_mentalhealth, 
    uof.Incident_Location_Dwelling AS location_dwelling,
    uof.Incident_Location_Other AS location_other,
    --encounter-related
    uof.Impact_Factor_Possesion_of_a_weapon AS impfct_weapon,
    uof.Impact_Factor_Alcohol AS impfct_alcohol, 
    uof.Impact_Factor_Drugs AS impfct_drugs, 
    uof.Impact_Factor_Mental_Health AS impfct_mentalhealth, 
    uof.Impact_Factor_Prior_Knowledge AS impfct_pknowledge, 
    uof.Impact_Factor_SizeGenderBuild AS impfct_sizegenderbuild, 
    uof.Impact_Factor_Acute_Behavioural_Disorder AS impfct_ABD, 
    uof.Impact_Factor_Crowd AS impfct_crowd, 
    uof.Impact_Factor_Other AS impfct_other,
	--subject-related
	CASE 
           WHEN SubjectEthnicity = 'White' THEN 1
           ELSE 0
       END AS is_white,
	CASE 
           WHEN SubjectGender = 'Male' THEN 1
           ELSE 0
       END AS is_male,
    uof.SubjectAge AS subject_age,
    uof.PhysicalDisability AS physical_disability,
    uof.MentalDisability AS mental_disability,
   --integration variables
   c_d.not_deprived AS census_not_deprived,
   c_e.white AS census_white_ethnic,
   c_h.no_heating AS census_no_heating,
   c_o.hetero AS census_heterosexual,
   c_o.gay_lesbian AS census_gay_lesbian,
   c_o.no_answer AS census_no_answer_orientation,
   c_p.population_density AS census_pop_density,
   c_q.entry_level AS census_low_qualification,
   c_q.high_qualification AS census_high_qualification,
   c_r.born_uk AS census_born_uk,
   c_s.student AS census_student,
   s_c.crime_rate AS mps_crime_rate,
   --response (target) variables
	GREATEST(
	   COALESCE(t1.ranking_2, 0),
	   COALESCE(t2.ranking_2, 0),
	   COALESCE(t3.ranking_2, 0),
	   COALESCE(t4.ranking_2, 0),
	   COALESCE(t5.ranking_2, 0),
	   COALESCE(t6.ranking_2, 0),
	   COALESCE(t7.ranking_2, 0),
	   COALESCE(t8.ranking_2, 0),
	   COALESCE(t9.ranking_2, 0),
	   COALESCE(t10.ranking_2, 0),
	   COALESCE(t11.ranking_2, 0),
	   COALESCE(t12.ranking_2, 0),
	   COALESCE(t13.ranking_2, 0),
	   COALESCE(t14.ranking_2, 0),
	   COALESCE(t15.ranking_2, 0),
	   COALESCE(t16.ranking_2, 0),
	   COALESCE(t17.ranking_2, 0),
	   COALESCE(t18.ranking_2, 0),
	   COALESCE(t19.ranking_2, 0),
	   COALESCE(t20.ranking_2, 0)
   ) AS physical_force_applied,
   	GREATEST(
	   COALESCE(t1.ranking_3, 0),
	   COALESCE(t2.ranking_3, 0),
	   COALESCE(t3.ranking_3, 0),
	   COALESCE(t4.ranking_3, 0),
	   COALESCE(t5.ranking_3, 0),
	   COALESCE(t6.ranking_3, 0),
	   COALESCE(t7.ranking_3, 0),
	   COALESCE(t8.ranking_3, 0),
	   COALESCE(t9.ranking_3, 0),
	   COALESCE(t10.ranking_3, 0),
	   COALESCE(t11.ranking_3, 0),
	   COALESCE(t12.ranking_3, 0),
	   COALESCE(t13.ranking_3, 0),
	   COALESCE(t14.ranking_3, 0),
	   COALESCE(t15.ranking_3, 0),
	   COALESCE(t16.ranking_3, 0),
	   COALESCE(t17.ranking_3, 0),
	   COALESCE(t18.ranking_3, 0),
	   COALESCE(t19.ranking_3, 0),
	   COALESCE(t20.ranking_3, 0)
   ) AS non_compliant,
   	GREATEST(
	   COALESCE(t1.ranking_1, 0),
	   COALESCE(t2.ranking_1, 0),
	   COALESCE(t3.ranking_1, 0),
	   COALESCE(t4.ranking_1, 0),
	   COALESCE(t5.ranking_1, 0),
	   COALESCE(t6.ranking_1, 0),
	   COALESCE(t7.ranking_1, 0),
	   COALESCE(t8.ranking_1, 0),
	   COALESCE(t9.ranking_1, 0),
	   COALESCE(t10.ranking_1, 0),
	   COALESCE(t11.ranking_1, 0),
	   COALESCE(t12.ranking_1, 0),
	   COALESCE(t13.ranking_1, 0),
	   COALESCE(t14.ranking_1, 0),
	   COALESCE(t15.ranking_1, 0),
	   COALESCE(t16.ranking_1, 0),
	   COALESCE(t17.ranking_1, 0),
	   COALESCE(t18.ranking_1, 0),
	   COALESCE(t19.ranking_1, 0),
	   COALESCE(t20.ranking_1, 0)
   ) AS max_tactic,
   uof.`PrimaryConduct` as primary_conduct
FROM use_of_force uof
-- Joins
LEFT JOIN ( 
SELECT 
	ROUND(not_deprived/total, 5) as not_deprived,
	ROUND(deprived_1dim/total, 5) as deprived_1dim,
    ROUND(deprived_2dim/total, 5) as deprived_2dim,
    ROUND(deprived_3dim/total, 5) as deprived_3dim,
    ROUND(deprived_4dim/total, 5) as deprived_4dim,
    borough_id
FROM census_deprivation
) c_d ON uof.borough_id = c_d.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(white/total, 5) as white,
    borough_id
FROM census_ethnic
) c_e ON uof.borough_id = c_e.borough_id
LEFT JOIN ( 
SELECT
	ROUND(no_heating/total, 5) as no_heating,
    borough_id
FROM census_heating
) c_h ON uof.borough_id = c_h.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(hetero/total, 5) as hetero,
    ROUND(gay_lesbian/total, 5) as gay_lesbian,
    ROUND(no_answer/total, 5) as no_answer,
    borough_id
from census_orientation
) c_o ON uof.borough_id = c_o.borough_id
LEFT JOIN ( 
SELECT 
	population_density,
    borough_id
from census_popdensity
) c_p ON uof.borough_id = c_p.borough_id
LEFT JOIN ( 
SELECT 
	ROUND((no_qualifications+level_1)/total, 5) as entry_level,
    ROUND(other_qualifications/total, 5) as high_qualification,
    borough_id
from census_qualification c_q
) c_q ON uof.borough_id = c_q.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(born_uk/total, 5) as born_uk,
    borough_id
from census_residence c_r
) c_r ON uof.borough_id = c_r.borough_id
LEFT JOIN ( 
SELECT 
	ROUND(student/total, 5) as student,
    borough_id
FROM census_student c_s
) c_s ON uof.borough_id = c_s.borough_id
LEFT JOIN ( 
    -- SELECT sc.borough_id, ROUND(COUNT(*)/total, 5) AS crime_rate
	-- FROM street_crime sc
	-- LEFT JOIN ( 
	-- 	SELECT total, borough_id from census_ethnic
	-- ) c_e ON sc.borough_id = c_e.borough_id
	-- WHERE crime_type IN ('Criminal damage and arson', 
	-- 					'Violence and sexual offences',
	-- 					'Burglary', 'Robbery', 
    --                     'Possession of weapons')
	-- GROUP BY sc.borough_id
    SELECT * FROM crime_rates
) s_c ON uof.borough_id = s_c.borough_id
LEFT JOIN borough_dict bd ON uof.borough_id = bd.id
LEFT JOIN tactic_dict t1 ON uof.Tactic_1 = t1.id
LEFT JOIN tactic_dict t2 ON uof.Tactic_2 = t2.id
LEFT JOIN tactic_dict t3 ON uof.Tactic_3 = t3.id
LEFT JOIN tactic_dict t4 ON uof.Tactic_4 = t4.id
LEFT JOIN tactic_dict t5 ON uof.Tactic_5 = t5.id
LEFT JOIN tactic_dict t6 ON uof.Tactic_6 = t6.id
LEFT JOIN tactic_dict t7 ON uof.Tactic_7 = t7.id
LEFT JOIN tactic_dict t8 ON uof.Tactic_8 = t8.id
LEFT JOIN tactic_dict t9 ON uof.Tactic_9 = t9.id
LEFT JOIN tactic_dict t10 ON uof.Tactic_10 = t10.id
LEFT JOIN tactic_dict t11 ON uof.Tactic_11 = t11.id
LEFT JOIN tactic_dict t12 ON uof.Tactic_12 = t12.id
LEFT JOIN tactic_dict t13 ON uof.Tactic_13 = t13.id
LEFT JOIN tactic_dict t14 ON uof.Tactic_14 = t14.id
LEFT JOIN tactic_dict t15 ON uof.Tactic_15 = t15.id
LEFT JOIN tactic_dict t16 ON uof.Tactic_16 = t16.id
LEFT JOIN tactic_dict t17 ON uof.Tactic_17 = t17.id
LEFT JOIN tactic_dict t18 ON uof.Tactic_18 = t18.id
LEFT JOIN tactic_dict t19 ON uof.Tactic_19 = t19.id
LEFT JOIN tactic_dict t20 ON uof.Tactic_20 = t20.id
-- Filters
WHERE uof.Outcome_Made_offescaped != 1 AND
uof.Incident_Location_Police_vehicle_with_prisoner_handling_cage != 1 AND
uof.Incident_Location_Police_vehicle_without_prisoner_handling_cage != 1 AND
uof.Incident_Location_Police_station_excluding_custody_block != 1 AND
uof.Incident_Location_Custody_Block != 1 AND
uof.Incident_Location_Ambulance != 1 AND
uof.Incident_Location_Sports_or_Event_Stadia != 1;

----
SELECT DISTINCT(borough) from borough_dict;

SELECT bd.borough, 
       DATE_FORMAT(date_time, '%Y-%m-%d %H:00:00') as hour, 
       COUNT(*) as count
FROM use_of_force uof
LEFT JOIN borough_dict bd ON uof.borough_id = bd.id
GROUP BY bd.borough, hour;


--create view for the time-series modelling
CREATE VIEW time_series_view AS
SELECT borough_id, 
       DATE_FORMAT(date_time, '%Y-%m-%d %H:00:00') as hour, 
       COUNT(*) as count
FROM use_of_force
GROUP BY borough_id, hour;

CREATE TABLE rq1_inference_result (
    id INT NOT NULL AUTO_INCREMENT,
    predictor VARCHAR(255),
    coefficient_22_21 FLOAT,
    p_value_22_21 FLOAT,
    t_test_22_21 FLOAT,
    coefficient_21_20 FLOAT,
    p_value_21_20 FLOAT,
    t_test_21_20 FLOAT,
    coefficient_20_19 FLOAT,
    p_value_20_19 FLOAT,
    t_test_20_19 FLOAT,
    PRIMARY KEY (id)
);
SELECT * FROM rq1_inference_result;

-- DROP TABLE rq2_test_predictions;
CREATE TABLE rq2_test_predictions (
    id INT NOT NULL AUTO_INCREMENT,
    true_label INT,
    nn_0 FLOAT,
    nn_1 FLOAT,
    nn_2 FLOAT,
    xgb_0 FLOAT,
    xgb_1 FLOAT,
    xgb_2 FLOAT,
    logreg_0 FLOAT,
    logreg_1 FLOAT,
    logreg_2 FLOAT,
    PRIMARY KEY (id)
);
select * from rq2_test_predictions;

-- DROP TABLE rq3_add_variables;
CREATE TABLE rq3_add_variables (
    id INT NOT NULL AUTO_INCREMENT,
    date DATE,
    boxing_day INT,
    boxing_day_obs INT,
    christmas_day INT,
    christmas_day_obs INT,
    good_friday INT,
    may_day INT,
    new_years_day INT,
    new_years_day_obs INT,
    platinum_jubilee INT,
    spring_bank_holiday INT,
    state_funeral INT,
    outlier INT,
    PRIMARY KEY (id)
);
SELECT * FROM rq3_add_variables;

-- DROP TABLE rq3_test_predictions_daily;
CREATE TABLE rq3_test_predictions_daily (
    id INT NOT NULL AUTO_INCREMENT,
    true_label INT,
    prophet FLOAT,
    lstm_nn FLOAT,
    transformer_nn FLOAT,
    PRIMARY KEY (id)
);
SELECT * FROM rq3_test_predictions_daily;

-- DROP TABLE rq3_test_predictions_hourly;
CREATE TABLE rq3_test_predictions_hourly (
    id INT NOT NULL AUTO_INCREMENT,
    true_label INT,
    prophet FLOAT,
    lstm_nn FLOAT,
    transformer_nn FLOAT,
    PRIMARY KEY (id)
);
select * from rq3_test_predictions_hourly;
