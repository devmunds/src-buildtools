@echo off
color a
title Build Tools

:menu
Time /t
Date /t

set appName="cota-facil"
set appDir=C:\xampp\htdocs\freteclick\cota-facil

set dirBundle="%appDir%\src-cordova\platforms\android\app\build\outputs\bundle\release\" 
set dirApk= "%appDir%\src-cordova\platforms\android\app\build\outputs\apk\release\"

echo/ **********************************************************************
echo/ *        ++   By Devmunds    ++        *                             *
echo/ **********************************************************************
echo/ *      1) Build App .aab               *                             *
echo/ *      2) Build App .apk               *                             *
echo/ *      3) Sign  App .aab               *                             * 
echo/ *      4) Sing  App .apk               *                             *
echo/ *      5) Zipalign  .aab               *                             *
echo/ *      6) Zipalign  .apk               *                             *
echo/ *      7) Icongenie                    *
echo/ *      8) Cordova Check                *                             *
echo/ *      9) Close                        *                             *
echo/ **********************************************************************
echo/ * App: %appDir%                                                      
echo/ **********************************************************************

set /p op= Qual tarfa executar?: 
if %op% equ 1 goto build-aab
if %op% equ 2 goto build-apk
if %op% equ 3 goto sign-aab
if %op% equ 4 goto sign-apk
if %op% equ 5 goto zipalign-aab
if %op% equ 6 goto zipalign-apk
if %op% equ 7 goto icongenie
if %op% equ 8 goto cordova-requirements
if %op% equ 9 goto sair

:build-aab   
    title Build .aab
    cd %appDir%
    call npx quasar build -m android -- -- --packageType=bundle
    xcopy %1 %2 %dirBundle% "%~dp0" /y 
    del "%dirBundle%app-release.aab" /f
    color a
    cls
    title Build Tools
    goto menu
:build-apk   
    title Build .apk
    cd %appDir%
    call npx quasar build -m android -- -- --packageType=apk
    xcopy %1 %2 %dirApk%app-release-unsigned.apk "%~dp0" /y 
    del "%dirApk%app-release-unsigned.apk" /f
    color a
    cls
    title Build Tools
    goto menu    
:sign-aab 
    title Assinando App      
    call jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "%~dp0keystore/onixcriativa.keystore" "%~dp0app-release.aab" onixcriativa -storepass "lw7q8a9w5@@qw" -keypass "lw7q8a9w5@@qw" 
    color a
    cls
    title Build App        
    goto menu
:sign-apk 
    title Assinando App      
    call jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "%~dp0keystore/onixcriativa.keystore" "%~dp0app-release-unsigned.apk" onixcriativa -storepass "lw7q8a9w5@@qw" -keypass "lw7q8a9w5@@qw" 
    color a
    cls
    title Build App        
    goto menu    
:zipalign-aab
    title Limpando AAB
    del "%~dp0builds\bundle\*.aab" /f 
    call zipalign -v 4 "%~dp0app-release.aab" "%~dp0builds/bundle/%appName%.aab"
    del "%~dp0app-release.aab" /f
    color a  
    cls
    title Build App  
    goto menu 
:zipalign-apk
    title Limpando APK
    del "%~dp0builds\apk\*.apk" /f 
    call zipalign -v 4 "%~dp0app-release-unsigned.apk" "%~dp0builds/apk/%appName%.apk"
    del "%~dp0app-release-unsigned.apk" /f
    color a  
    cls
    title Build App    
    goto menu   
:cordova-requirements
    cd "%appDir%\src-cordova"    
    call cordova requirements
    goto menu
:icongenie
    cd %appDir%
    call icongenie generate -m cordova -i "%~dp0assets/icon.png" -b "%~dp0assets/splash.png" --skip-trim
    color a
    cls
    goto menu
:sair   
    exit