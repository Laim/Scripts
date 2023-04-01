:: Strips all of the garbage metadata tags from mkv files.
:: i.e things like GalaxyTV - small excellence! which is the worlds most annoying thing.
:: This removes the random names and comments, as well as wiping the title.

:: Usage - download mkvtoolnix and put it somewhere (portable or installer) then point the below paths to the mkvpropedit executable

:: https://github.com/laim/scripts

for %%A IN (*.mkv) do ( "C:\_MediaPrograms\mkvtoolnix\mkvpropedit.exe" -d title "%%~A") 
for %%A IN (*.mkv) do ( "C:\_MediaPrograms\mkvtoolnix\mkvpropedit.exe" "%%~A" --tags all:) 

@pause