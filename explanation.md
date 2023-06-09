### Ansible Instrumentation

- Create a directory for the project mkdir ansible-IP
- cd ansible-IP
- Create a custom Vagrantfile using the geerlingguy/ubuntu2004 image

#### Disable SSH host keys checking

- Create a hosts file with the IP addresses of the client, backend virtual machines on GCP, file is under inventory.ini
- Create ansible.cfg file 
  - Disable host key checking by typing host_key_checking = False in the file

#### Provision the servers 

- Create a playbook.yaml that will clone the repo and run the commands that will fire up the application.
