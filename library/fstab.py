#!/usr/bin/python

# Copyright: (c) 2024, Adriano J. Holanda <ajholanda@example.net>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: fstab

short_description: Add a fstab entry.

# It's prepared to be part of an Ansible collection,
# version must be in the semantic versioning format
# (https://semver.org/).
version_added: "0.1.0"

description: Write an entry to /etc/fstab.

options:
    spec:
        description: Specify the device or partition to be mounted.
        required: true
        type: str
    path:
        description: Directory where the filesystem should be mounted.
        required: true
        type: str
    type:
        description: Filesystem type.
        required: true
        type: str
    options:
        description: Mount options.
        required: false
        default: defaults
        type: str
    dump:
        description: Used by the `dump` command to determine whether a filesystem should be backed up.
                     When the value is 0 no dump is done.
        required: false
        default: 0
        type: int
    passno:
        description: Used by the `fsck` command to determine the order in which filesystems should be checked at boot time.
                     When the value is 0 no check is performed.
        required: false
        default: 0
        type: int

author:
- Adriano J. Holanda (@ajholanda)
'''

EXAMPLES = r'''
- name: Add a NFS entry to fstab.
  fstab:
    spec: '192.168.64.16:/home'
    path: /home
    type: nfs

- name: Create an entry for root partition.
  spec: /dev/sda1
  path: /
  type: ext4
  dump: 1
  passno: 1

- name: Add an entry for the CD-ROM device.
  spec: /dev/sr0
  path: /media/cdrom0
  type: 'udf,iso9660'
  options: 'user,noauto'
'''

RETURN = r'''
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # Parameters
    module_args = dict(
        spec=dict(type='str', required=True),
        path=dict(type='str', required=True),
        type=dict(type='str', required=True),
        options=dict(type='str', required=False, default='defaults'),
        dump=dict(type='int', required=False, default=0),
        passno=dict(type='int', required=False, default=0)
    )

    # The result dict in the object must be filled,
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task.
    result = dict(
        changed=False,
    )

    # The AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode.
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    with open("/etc/fstab", "a+") as file:
        # Mount specification exists?
        spec_exists = False
        spec = module.params['spec']
        for line in file:
            fields = line.split()
            if fields[0] == spec:
                spec_exists = True
                break

        if not spec_exists:
            path = module.params['path']
            type = module.params['type']
            opts = module.params['options']
            dump = module.params['dump']
            passno = module.params['passno']

            if opts is None:
                opts = 'defaults'
            if dump is None:
                dump = '0'
            if passno is None:
                passno = '0'

            entry = f'{spec} {path} {type} {opts} {dump} {passno}\n'
            # Only change if the execution is not in check mode.
            if not module.check_mode:
                file.write(entry)
                result['changed'] = True

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
