###################################################
#                                                 #
# Pearson EasyBridge OnBoarding File Manipulation #
# Written by: Cory Robbins, Sys. Admin            #
# School System: West Fork Public Schools         #
# Last Update: 08/21/2017                         #
# Usage: Free to use and manipulate               #
#                                                 #
###################################################
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

# STUDENT.txt
$oldCSV = 'C:\Scripts\Pearson\Initial Download\student-pearson.csv'
$newCSV = 'C:\Scripts\Pearson\Edited for Import\STUDENT.csv'
$newTXT = 'C:\Scripts\Pearson\Edited for Import\TXT\STUDENT.txt'
$newCSVe = 'C:\Scripts\Pearson\Edited for Import\STUDENTe.csv'
Import-Csv $oldCSV | Select student_code,last_name,first_name, @{ Name = 'email'; Expression = {$_.combined.Split('-')[0].ToLower()+'@wftigers.org'} },student_number, @{ Name = 'federated_id'; Expression = {$_.combined2.Split('-')[0].ToLower()+'@wftigers.org'.ToLower()} } | ForEach-Object {
#Use if statements to correct names that will be badly modified when the "-" is removed.  Also used to fix other name weirdness  The top line of each statement is the output without correction.  The second, third, and fourth are the desired results.
    if ($_.federated_id -eq 'Cianna@wftigers.org') {
        $_.federated_id = 'cianna.rosa@wftigers.org'
        $_.email = 'cianna.rosa@wftigers.org'
    }
    if ($_.federated_id -eq 'Nealie.Den Herder@wftigers.org') {
        $_.federated_id = 'nealie.denherder@wftigers.org'
        $_.email = 'nealie.denherder@wftigers.org'
    }
    $_
} | Export-Csv $newCSV -force -NoTypeInformation
Clear-Content $newTXT
Add-Content -path $newTXT -value "student_code,last_name,first_name,email,student_number,federated_id"
Get-Content $newCSV | select -Skip 1 | Add-Content $newTXT

#PIF_SECTION_STUDENT.txt
$oldCSV2 = 'C:\Scripts\Pearson\Initial Download\section_student_pearson.csv'
$newCSV2 = 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION_STUDENT.csv'
$newTXT2 = 'C:\Scripts\Pearson\Edited for Import\TXT\PIF_SECTION_STUDENT.txt'
$newCSV2e = 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION_STUDENTe.csv'
$pearsonSecStu = 'C:\Scripts\Pearson\Manual Imports\manual-student-sections.txt'
Import-Csv $oldCSV2 | Select @{ Name = 'section_student_code'; Expression = {$_.student_code+$_.Course+$_.Section+$_.YearSub+"-"+$_.Year.Substring(2,2)} }, student_code, @{ Name = 'native_section_code'; Expression = {$_.Course+$_.Section+$_.school_code+$_.YearSub+"-"+$_.Year.Substring(2,2)} }, @{ Name = 'date_start'; Expression = {$_.YearSub+'-08-01'} }, @{ Name = 'date_end'; Expression = {$_.Year+'-06-30'} }, @{ Name = 'school_year'; Expression = {$_.YearSub} } | 
Export-Csv $newCSV2 -force -NoTypeInformation
Clear-Content $newTXT2
Add-Content -path $newTXT2 -value "section_student_code,student_code,native_section_code,date_start,date_end,school_year"
Get-Content -path $pearsonSecStu | Add-Content -Path $newTXT2
Get-Content $newCSV2 | select -Skip 1 | Add-Content -path $newTXT2

#PIF_SECTION.txt
$oldCSV3 = 'C:\Scripts\Pearson\Initial Download\PIF_SECTION.csv'
$newCSV3 = 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION.csv'
$newTXT3 = 'C:\Scripts\Pearson\Edited for Import\TXT\PIF_SECTION.txt'
$runningSection = 'C:\Scripts\Pearson\Manual Imports\manual-sections.txt'
Import-Csv $oldCSV3 | Select @{ Name = 'native_section_code'; Expression = {$_.course_number+$_.Section+$_.school_code+$_.YearSub+"-"+$_.Year.Substring(2,2)} }, school_code,  @{ Name = 'date_start'; Expression = {$_.YearSub+'-08-01'} }, @{ Name = 'date_end'; Expression = {$_.Year+'-06-30'} }, @{ Name = 'school_year'; Expression = {$_.YearSub} }, course_number, course_name, @{ Name = 'section_name'; Expression = {$_.YearSub+"-"+$_.Year.Substring(2,2)+" "+$_.course_name+"-"+$_.Section} }, @{ Name = 'section_number'; Expression = {$_.Section+"-"+$_.Year} } | 
Export-Csv $newCSV3 -force -NoTypeInformation
#Fix header to remove double quotes and set as a TXT file instead of csv
Clear-Content $newTXT3
Add-Content -path $newTXT3 -value "native_section_code,school_code,date_start,date_end,school_year,course_number,course_name,section_name,section_number"
Get-Content $runningSection | Add-Content -Path $newTXT3
Get-Content $newCSV3 | select -Skip 1 | Add-Content -path $newTXT3


#PIF_SECTION_STAFF.txt
$oldCSV4 = 'C:\Scripts\Pearson\Initial Download\PIF_SECTION_STAFF.csv'
$newCSV4 = 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION_STAFF.csv'
$newTXT4 = 'C:\Scripts\Pearson\Edited for Import\TXT\PIF_SECTION_STAFF.txt'
$newCSV4e = 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION_STAFFe.csv'
$runningStaff = 'C:\Scripts\Pearson\Manual Imports\manual-staff-sections.txt'
Import-Csv $oldCSV4 | Select @{ Name = 'section_teacher_code'; Expression = {$_.building+$_.staff+"_"+$_.Short+$_.section+$_.YearSub+"-"+$_.Year.Substring(2,2)} }, @{ Name = 'staff_code'; Expression = {$_.building+$_.staff} }, @{ Name = 'native_section_code'; Expression = {$_.Short+$_.Section+$_.building+$_.YearSub+"-"+$_.Year.Substring(2,2)} }, @{ Name = 'date_start'; Expression = {$_.YearSub+'-08-01'} }, @{ Name = 'date_end'; Expression = {$_.Year+'-06-30'} }, @{ Name = 'school_year'; Expression = {$_.YearSub} }, @{ Name = 'teacher_of_record'; Expression = {"True"} }, @{ Name = 'teaching_assignment'; Expression = {"Lead Teacher"} } | ForEach-Object {
#Use if statements to correct names that will import for multiple buildings.  The top line of each statement is the output without correction.  The second, third, and fourth are the desired results.
    if ($_.staff_code -eq '1168') {
        $_.building = '62'
    }
    $_
} |
Export-Csv $newCSV4 -force -NoTypeInformation
#Fix multiple buildings - First value after "Replace" is the string to find, the second is the value to replace the string with.
$newCSV4 = Import-CSV -Path 'C:\Scripts\Pearson\Edited for Import\PIF_SECTION_STAFF.csv'
$Headers = $newCSV4 | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name;
ForEach ($Record in $newCSV4) {
    foreach ($Header in $Headers) {
    #Tim Clingan
        if ($Header -eq "section_teacher_code") {
             $Record.$Header = $Record.$Header.Replace("611168","621168")
        }
        if ($Header -eq "staff_code") {
             $Record.$Header = $Record.$Header.Replace("611168","621168")
        }
    }
}
$Headers = $newCSV4 | Get-Member -MemberType NoteProperty
$newCSV4 | Export-Csv $newCSV4e -force -NoTypeInformation
#Fix header to remove double quotes and set as a TXT file instead of csv
Clear-Content $newTXT4
Add-Content -path $newTXT4 -value "section_teacher_code,staff_code,native_section_code,date_start,date_end,school_year,teacher_of_record,teaching_assignment"
Get-Content $runningStaff | Add-Content -Path $newTXT4
Get-Content $newCSV4e | select -Skip 1 | Add-Content -path $newTXT4

#Zip Files - Checks for existing and makes a time-stamped archive copy
$source = "C:\Scripts\Pearson\Edited for Import\TXT"
$destination = "C:\Scripts\Pearson\Edited for Import\Upload\EasyBridgeUpload.zip"
$backupDest = "C:\Scripts\Pearson\Edited for Import\Upload Archive\EasyBridgeArchive-$(get-date -f yyyy-MM-dd--HH-mm-ss).zip"
 If(Test-path $destination) {Move-item -Path $destination -Destination $backupDest}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($Source, $destination)

###########!!!!!DANGER FOLLOWS Comment out before testing!!!!###############

#SFTP Upload - Replace $Password and $Credential
Import-Module Posh-SSH #Load the Posh-SSH module

Set the credentials
$Password = ConvertTo-SecureString 'Pa$sW0Rd' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ('username', $Password)

#Set local file path and SFTP path
$LocalFiles = Get-ChildItem "C:\Scripts\Pearson\Edited for Import\Upload\"
$SftpPath = '/SIS/'
Set-Location "C:\Scripts\Pearson\Edited for Import\Upload"

#Set the IP of the SFTP server
$SftpIp = 'sftp.pifdata.net'

#Establish the SFTP connection
New-SFTPSession -ComputerName $SftpIp -Credential $Credential
ForEach ($LocalFile in $LocalFiles)
{
#Upload the file to the SFTP path
Set-SFTPFile -SessionId 0 -LocalFile "$LocalFile" -RemotePath $SftpPath -Overwrite
}
#Disconnect SFTP session
(Get-SFTPSession -SessionId 0).Disconnect()
Get-SFTPsession | Remove-SFTPSession