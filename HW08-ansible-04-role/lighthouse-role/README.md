Lighthouse
=========

This role install Lighthouse from github

Requirements
------------

To install Lighthouse, you first need to install git and nginx on the server

Role Variables
--------------

- You can specify the directory in which the lighthouse will be found

    
    lighthouse_home_dir: "/usr/share/nginx/html/lighthouse"


Dependencies
------------

variable *"nginx_config_dir"* and **handlers** used from nginx-role 



Example Playbook
----------------

    - name: nginx role 
      hosts: servers
      roles:
        - role: nginx
        - role: lighthouse

License
-------

MIT

Author Information
------------------

Aleksey Shelkovin

