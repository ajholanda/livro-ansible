# Tips

1. The following Ansible mechanisms don't behave well in GitHub actions:

```
- name: Load OS specific vars
  ansible.builtin.include_vars: "{{ lookup('first_found', params) }}"
  vars:
    params:
      files:
        - "{{ ansible_distribution }}.yml"
        - "{{ ansible_os_family }}.yml"
        - "default.yml"
      paths:
        - vars
```

```
- name: Load OS specific vars
  ansible.builtin.include_vars:
  with_first_found:
    - files:
      - "{{ ansible_os_family }}.yml"
      skip: true
```

When the complete file path is specified, the molecule tests are
executed properly in GitHub:

```
- name: Load OS specific vars
  ansible.builtin.include_vars:
    file: "{{ role_path }}/vars/{{ ansible_os_family | lower }}.yml"
```
