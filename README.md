###################################################
#                                                 #
# Pearson EasyBridge OnBoarding File Manipulation #
# Written by: Cory Robbins, Sys. Admin            #
# School System: West Fork Public Schools         #
# Last Update: 08/21/2017                         #
# Usage: Free to use and manipulate               #
#                                                 #
###################################################

**** The PearsonDownloader.ps1 script is not mine.  That was written and edited by Charlie Weber, Keln Taylor, Brian Johnson and Brian Lawarence
#
#This code script takes 4 cognos reports and edits them to fit the requirements of Pearson EasyBridge.
#When run in combination with scheduled reports, it automates EasyBridge roster sync.
#Includes variables to allow for manual file additions.
#Creates files, generates .txt files, combines into a .zip archive, backs up existing archives, and then uploads via SFTP to EasyBridge.
#
#Script Requires Posh-SSH to be installed for upload!
#
#Expected File Structure:
# C:\Scripts\Pearson (Contains PearsonBuilder.ps1, Cognose download Script [called PearsonDownloader.ps1], and PearsonSync.bat)
#                    > Edited for Import
#                           > TXT
#                           > Upload
#                           > Upload Archive
#                    > Initial Download
#                    > Manual Imports

Please note that this script only generates STUDENT.TXT, PIF_SECTION_STUDENT.TXT, PIF_SECTION_STAFF.TXT,  and PIF_SECTION.TXT.  You must manually specify the contents of STAFF.TXT, CODE_DISTRICT.TXT, SCHOOL.TXT, and ASSIGNMENT.TXT.  Set the contents in Pearson\Edited for Import\TXT\

Cognos Report Requirements and notes:
I filtered all of my report for active students and to only include math courses taught at our school.  Some of the report names are a little odd because of name overlaps.  You can rename them if you want, but make sure to edit the PearsonSync.bat file to reflect your names.

For Student.txt:
  Report Name: student-pearson
  Headers (and descriptions): student_code (student ID number), last_name, first_name, combined (username before @domain.tld), student_number (student ID number), combined2 (same as combined)

For PIF_Section_Student.txt:
  Report Name: section_student_pearson
  Headers (and descriptions): student_code, Course (course number), Section (section number), Year (school year), YearSub (school year - 1 formatted to have no comma or decimals), school_code (building number)

For PIF_Section_Staff.txt:
  Report Name: PIF_SECTION_STAFF
  Headers (and descriptions): course_name, staff (primary staff ID), name (teacher name Last, First), section (section number), Short (course number), building (building number), Year, YearSub
  
For PIF_Section.txt:
  Report Name: PIF_SECTION
  Headers (and descriptions): school_code (building number), course_number, course_name, sectionName1 (course name), Section,  YearSub, Year
