# Copyright: (c) 2024, Adriano J. Holanda <ajholanda@example.net>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)


DOCUMENTATION = r'''
---
module: fstab

short_description: Add a fstab entry.

version_added: "2.16"

description: The M(fstab) module writes an entry to /etc/fstab file.

options:
    spec:
        description:
          - Specify the device or partition to be mounted.
        required: true
        type: str
    path:
        description:
          - Directory where the filesystem should be mounted.
        required: true
        type: str
    type:
        description:
          - Filesystem type.
        required: true
        type: str
    options:
        description:
          - Mount options.
        required: false
        default: defaults
        type: str
    dump:
        description:
          - Used by the C(dump) command to determine whether a filesystem should be backed up.
          - When the value is V(0) no dump is done.
        required: false
        default: 0
        type: int
    passno:
        description:
          - Used by the C(fsck) command to determine the order in which filesystems should be checked at boot time.
          - When the value is V(0) no check is performed.
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
  fstab:
    spec: /dev/sda1
    path: /
    type: ext4
    dump: 1
    passno: 1

- name: Add an entry for the CD-ROM device.
  fstab:
    spec: /dev/sr0
    path: /media/cdrom0
    type: 'udf,iso9660'
    options: 'user,noauto'
'''

RETURN = r'''
msg:
    description: Provide a descriptive message using some parameters.
    type: str
    returned: always
    sample: '/dev/sda1 on / type ext4 (rw,relatime,discard,errors=remount-ro)'
'''

import os
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

    spec = module.params['spec']
    path = module.params['path']
    type = module.params['type']
    opts = module.params['options']
    if opts is None:
        opts = 'defaults'
    dump = module.params['dump']
    if dump is None:
        dump = 0
    passno = module.params['passno']
    if passno is None:
        passno = 0

    fname = '/etc/fstab'
    if not os.path.exists(fname):
        module.fail_json(msg="%s not found" % (fname))
    if not os.access(fname, os.R_OK):
        module.fail_json(msg="%s not readable" % (fname))

    with open(fname, "r+") as file: #1
        # Mount specification exists?
        spec_exists = False
        # Check if spec already exists in /etc/fstab.
        for line in file: #2
            # Ignore comments.
            if line[0] == '#': #3
                continue
            fields = line.split() #4
            if fields[0] == spec: #5
                spec_exists = True
                break

        # If spec does not exist, add the entry.
        if not spec_exists: #6
            result['changed'] = True
            # Only change if the execution is not in check mode.
            if not module.check_mode:
                entry = f'{spec} {path} {type} {opts} {dump} {passno}\n'
                file.write(entry)

    result['msg'] = f'{spec} on {path} type {type} ({opts})'
    module.exit_json(**result)


if __name__ == '__main__':
    run_module()
