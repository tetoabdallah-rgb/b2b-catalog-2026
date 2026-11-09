@echo off
chcp 65001 > nul
title تحديث ورفع كتالوج 2B B2B والصور أونلاين
color 0B

echo ======================================================================
echo          🏢 نظام تحديث ورفع كتالوج 2B B2B Enterprise 2026
echo ======================================================================
echo.
echo [1/3] جاري قراءة الشيت الأساسي والصور وتوليد الكتالوج فائق السرعة...
echo.

"C:\Users\abdallah.ahmed\.local\bin\uv.exe" run --with openpyxl --with pymupdf --with pandas --with pillow python "E:\pdf\System_Engine\update_script.py"

if %errorlevel% neq 0 (
    color 0C
    echo.
    echo ❌ حدث خطأ أثناء قراءة البيانات أو معالجة الصور!
    echo يرجى التأكد من إغلاق ملف الإكسيل إذا كان مفتوحاً والمحاولة مرة أخرى.
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo ======================================================================
echo [2/3] جاري رفع التحديثات الجديدة والصور إلى السيرفر و GitHub Pages...
echo ======================================================================
echo.

"e:\AI\apk\SalesProWeb\node-v20.11.1-win-x64\node.exe" "E:\pdf\System_Engine\deploy_to_github.js"

echo.
echo ======================================================================
echo [3/3] جاري مزامنة مستودع Git لضمان تطابق كافة الأجهزة...
echo ======================================================================
echo.

if exist "E:\AI\apk\mingit\cmd\git.exe" (
    "E:\AI\apk\mingit\cmd\git.exe" -C "%~dp0" fetch origin main
    "E:\AI\apk\mingit\cmd\git.exe" -C "%~dp0" reset --hard origin/main
)

color 0A
echo.
echo ======================================================================
echo   🎉 تم التحديث والرفع بنجاح تام لجميع البضائع والصور الجديدة!
echo   🌐 رابط الكتالوج المباشر:
echo   https://tetoabdallah-rgb.github.io/b2b-catalog-2026/
echo ======================================================================
echo.
echo اضغط أي مفتاح للإغلاق...
pause > nul
