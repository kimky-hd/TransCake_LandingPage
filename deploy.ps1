Write-Host "========================================="
Write-Host "   TRANSCAKE - AUTO DEPLOYMENT SCRIPT"
Write-Host "========================================="

Write-Host "`n[1/3] Dang dong goi ung dung bang Maven..."
mvn clean package
if ($LASTEXITCODE -ne 0) {
    Write-Host "Loi khi dong goi ung dung! Vui long kiem tra lai code." -ForegroundColor Red
    exit
}

Write-Host "`n[2/3] Dang day ban cap nhat len Server (Nhap mat khau khi duoc hoi)..."
scp .\target\TransCake_LandingPage-1.0-SNAPSHOT.war root@14.225.212.97:/opt/tomcat/webapps/ROOT.war

Write-Host "`n[3/3] Khoi dong lai may chu de ap dung thay doi (Nhap mat khau lan nua)..."
ssh root@14.225.212.97 "sh /opt/tomcat/bin/shutdown.sh; sleep 2; sh /opt/tomcat/bin/startup.sh"

Write-Host "`n========================================="
Write-Host " THANH CONG! Code moi da duoc dua len live!"
Write-Host "========================================="
