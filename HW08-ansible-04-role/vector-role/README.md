Vector
=========

This role install Vector

Role Variables
--------------

|vars| description                       | default   |
|------|-----------------------------------|-----------|
| vector_version | Version of Vector to install      | 0.29.1    |
| ip_clickhouse | Ip address of deployed clickhouse | 127.0.0.1 |
| port_clickhouse | Connection port to clickhouse     | 8123      |
| vector_config | Vector config file in yaml format |       |




Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- name: Vector role 
  hosts: servers
  vars:
    vector_version: "0.29.1"
    vector_config:
      data_dir: /var/lib/vector
      sources:
        sample_file:
          type: file
          read_from: beginning
          ignore_older_secs: 600
          include:
            - /var/log/**/*.log
        vector_log:
          type: internal_logs
      sinks:
        to_clickhouse:
          type: clickhouse
          inputs:
            - sample_file
          endpoint: http://127.0.0.1:8123
          database: logs
          table: local_log
          skip_unknown_fields: true
          compression: gzip
  roles:
    - role: vector
```



License
-------

MIT

Author Information
------------------

Aleksey Shelkovin
