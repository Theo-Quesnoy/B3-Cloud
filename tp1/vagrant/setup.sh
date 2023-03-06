#Update OS
dnf update -y

#Install ansible
dnf install -y ansible

#Install python
dnf install -y python3

# Désactive SELinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

# Création user + sudo 
useradd -m vm
echo 'vm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# SSH
mkdir /home/vm/.ssh
chmod 700 /home/vm/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiCZ68jqOGMzCTwqsgjk9Ej7+hSiMFR6J5k3RE8choRhygOCnG08Vr9pFPFekgI7UMcydgvlZsjh0iJx3/IXd8dGSKO3O/j9m1nAn4LWTrDRu+Y4dJNw0wipQCR++yJDM+xlAx8XSLkiEDYUygw5+S3Z2uM39KOZqEoTc6ddrBbVDiigP2BsAqqYOKaZP2OxOS+7uaZe6UPjBeG2Koq2XYEP9Iy+xJbcJw2bFYK3smsjLdQL4r2KJt3cHqxydEFMaJ+/qou6etAeyXzBDCde12qjfMINZYi8x3xJUmdkSPk2Do93mdo63/DWOgG2J2QxsF91cVj1dOj6co3nZBIXjomyW9SZXDucB1R9alq5g7hjrfm+K50g8ScAGb8AbCFikPpVvGRuzw0WnR+R+Z6+r6vQ1mDHBpL2WEvqPGb4ofJoTRgnWNnmMkOOtT0r100uNc1NXSWzd9MLqa2nVGejkDT3hwfMpP/HpvcI46E3XN3mg+9Ow2hCHUxkUcrTZ0+yc8OJosIHb1C8WxPH0pQHVyMTuTqZ16HB3DmBGc/kfSoznA/Ao33ZqHseruCAgB5m0+sQ1zCjRGvHNbE2hxqCYFGgPLtp403H2r7JyHFTXkbIwIMDOOM9UMvkYXpQRT+NumFIoQ8fn3HTnUNvi8YEcJQTUsntaMzUiDkapowpVZjw== theoq@LENOVO-Théo" > /home/vm/.ssh/authorized_keys
chmod 600 /home/vm/.ssh/authorized_keys
chown -R vm:vm /home/vm/.ssh
