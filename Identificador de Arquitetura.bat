@echo off
set APP=Identificador de Arquitetura
set AUTHOR=POMBO
set AVATAR=\Õ/
set MADE_BY=MADE BY:
set SPACE= 
set KEY=EWEP
echo %APP%%SPACE%%MADE_BY%%SPACE%%SPACE%%AUTHOR%%SPACE%%SPACE%%AVATAR%%SPACE%%KEY%

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Selecione um arquivo .EXE ou .DLL para verificar a arquitetura!', 'Identificador de Arquitetura', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"

setlocal

set "tempFile=%temp%\tempScript.ps1"

echo Write-Output $concatenatedString >> "%tempFile%"
echo Add-Type -AssemblyName System.Windows.Forms >> "%tempFile%"
echo $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog >> "%tempFile%"
echo $OpenFileDialog.Filter = "Executáveis e DLLs (*.exe;*.dll)|*.exe;*.dll" >> "%tempFile%"
echo $OpenFileDialog.ShowDialog() ^| Out-Null >> "%tempFile%"
echo $filePath = $OpenFileDialog.FileName >> "%tempFile%"
echo if ($filePath) { >> "%tempFile%"
echo     function Get-PEArchitecture { >> "%tempFile%"
echo         param ( >> "%tempFile%"
echo             [string]$filePath >> "%tempFile%"
echo         ) >> "%tempFile%"
echo         $fs = [System.IO.File]::OpenRead($filePath) >> "%tempFile%"
echo         $br = New-Object System.IO.BinaryReader($fs) >> "%tempFile%"
echo         $fs.Position = 0x3C >> "%tempFile%"
echo         $peHeaderOffset = $br.ReadInt32() >> "%tempFile%"
echo         $fs.Position = $peHeaderOffset + 0x4 >> "%tempFile%"
echo         $machine = $br.ReadUInt16() >> "%tempFile%"
echo         $br.Close() >> "%tempFile%"
echo         $fs.Close() >> "%tempFile%"
echo         switch ($machine) { >> "%tempFile%"
echo             0x8664 { return "64-bit" } >> "%tempFile%"
echo             0x014C { return "32-bit" } >> "%tempFile%"
echo             0x0200 { return "Itanium" } >> "%tempFile%"
echo             default { return "Unknown" } >> "%tempFile%"
echo         } >> "%tempFile%"
echo     } >> "%tempFile%"
echo     $architecture = Get-PEArchitecture -filePath $filePath >> "%tempFile%"
echo     [System.Windows.Forms.MessageBox]::Show("O arquivo possui a arquitetura: $architecture", "Identificador de Arquitetura - Resultado") >> "%tempFile%"
echo } else { >> "%tempFile%"
echo     [System.Windows.Forms.MessageBox]::Show("Nenhum arquivo foi selecionado.", "Identificador de Arquitetura - Erro") >> "%tempFile%"
echo } >> "%tempFile%"

powershell.exe -ExecutionPolicy Bypass -File "%tempFile%"

del "%tempFile%"

endlocal

exit