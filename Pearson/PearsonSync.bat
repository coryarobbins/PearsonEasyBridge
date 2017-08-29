@ECHO OFF
PowerShell.exe -File "C:\Scripts\Pearson\PearsonDownloader.ps1" student-pearson "C:\Scripts\Pearson\Initial Download"
PowerShell.exe -File "C:\Scripts\Pearson\PearsonDownloader.ps1" section_student_pearson "C:\Scripts\Pearson\Initial Download"
PowerShell.exe -File "C:\Scripts\Pearson\PearsonDownloader.ps1" PIF_SECTION "C:\Scripts\Pearson\Initial Download"
PowerShell.exe -File "C:\Scripts\Pearson\PearsonDownloader.ps1" PIF_SECTION_STAFF "C:\Scripts\Pearson\Initial Download"
PowerShell.exe -File "C:\Scripts\Pearson\PearsonBuilder.ps1"