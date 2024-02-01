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
        options=dict(type='str', required=False, default='defaults')
        dump=dict(type='int', required=False, default=0)
        passno=dict(type='int', required=False, default=0)
    )
