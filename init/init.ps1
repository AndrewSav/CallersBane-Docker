$env:MYSQL_ROOT_PASSWORD="changeme"
$env:IP_ADDRESS="127.0.0.1"
$env:SERVER_NAME="Docker Server"
$env:SERVER_ID="docker-server"
$env:MYSQL_SERVER="mysql"

$env:COMPOSE_CONVERT_WINDOWS_PATHS="1"

if ($env:MYSQL_ROOT_PASSWORD -eq "changeme") {
    Write-Host "Please edit this file to specify MYSQL_ROOT_PASSWORD"
    exit
}

if ($env:IP_ADDRESS -eq "127.0.0.1") {
    Write-Host "Please specify non-local ip address Callers Baner server will be available on"
    exit
}

if  (Test-Path c:\mnt\docker\callersbane) {
    Write-Host "It appears that callersbane directories are already set up. Please remove /mnt/docker/callersbane if you want to delete all data, then re-run this script"
    exit
}

docker-compose up --build
docker-compose down
