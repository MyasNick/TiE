@echo off
"d:\Soft\Programming\Compression & Protection\StripReloc\StripReloc.exe" "d:\Nick\Work\Type it Easy\TiE.exe"
sleep 500
del *.bak
del *.~*
"C:\Program Files (x86)\Inno Setup 5\ISCC.exe" "D:\Nick\Work\Type it Easy\typeiteasy.setup.iss"
"C:\Program Files\7-Zip\7z.exe" a -tzip typeiteasy.setup.zip "D:\Nick\Work\Type it Easy\typeiteasy.setup.exe"
"C:\Program Files\7-Zip\7z.exe" a -tzip typeiteasy.setup.zip "D:\Nick\Work\Type it Easy\file_id.diz"
"C:\Program Files\7-Zip\7z.exe" a -tzip typeiteasy.setup.zip "D:\Nick\Work\Type it Easy\license.txt"
"C:\Program Files\7-Zip\7z.exe" a -tzip typeiteasy.setup.zip "D:\Nick\Work\Type it Easy\readme.txt"
