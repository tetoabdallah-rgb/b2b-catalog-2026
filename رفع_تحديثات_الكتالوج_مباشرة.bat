@echo off
chcp 65001 >nul
title رفع وتحديث كتالوج 2B B2B 2026
color 0A

echo =========================================================
echo    جاري رفع أحدث بيانات وأسعار البضاعة إلى السيرفر...
echo =========================================================
echo.

cd /d "E:\AI\apk\b2b-catalog-2026"

echo 1. جاري فحص الملفات المحدثة...
"E:\AI\apk\mingit\cmd\git.exe" add -A

echo.
echo 2. جاري حفظ التحديثات (Commit)...
"E:\AI\apk\mingit\cmd\git.exe" commit -m "update: refresh products and catalog data [%date% %time%]"

echo.
echo 3. جاري الرفع المباشر إلى GitHub Pages (Push)...
"E:\AI\apk\mingit\cmd\git.exe" push origin main

echo.
if %errorlevel% equ 0 (
    echo =========================================================
    echo  ✅ تم رفع التحديث بنجاح إلى السيرفر!
    echo  ستظهر البضاعة والأسعار الجديدة فوراً لجميع العملاء والتطبيق.
    echo =========================================================
) else (
    echo.
    echo ❌ حدث خطأ أثناء الرفع! يرجى التأكد من اتصال الإنترنت والمحاولة مرة أخرى.
)

echo.
pause
