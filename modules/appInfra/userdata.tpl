#!/bin/bash

echo "Install ASPNET CORE"
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum install dotnet-sdk-6.0 -y 

echo "Install git"
sudo yum install -y git
