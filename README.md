# Synology Docker Installer

Install docker and docker-compose on any unsupported Synology NAS.

## Disclaimer

Docker will work but be careful not to run RAM / CPU / HDD intensive containers that your NAS would not be able to handle (read bellow).
I'm not responsible for any damage.

## Informations
The following script is automatically installing the latest docker and docker-compose compatible with your Synology NAS.
Only use this script if you can't install Docker using the synology package manager.  

### Storage driver
Due to some OS limitations, the script sets the storage driver to `vfs`, while it will work in most cases, performance of this storage driver is poor, and is not recommended for production use.

### Firewall
Because Synology runs its own firewall software, the script sets the `iptables` option to false, you need to manage firewall rules yourself through the Synology tool.

### Docker Volumes
Because the DSM partition is having a size limitation (~2 GB), the script creates a docker directory outside of it (`/volume1/@Docker/lib`) and mounts it to `/docker`. All your containers related data will be in that directory.

## Instructions

- Connect to your NAS using SSH (admin user required) ([help](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General_Setup/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet))
- Use the command `sudo -i` to switch to root user
- Run the installer:   
`curl https://raw.githubusercontent.com/AlexPresso/Synology-Docker-Installer/main/install.sh | bash`
