DOMAIN = "example.net"
# IPs' prefix
PREFIP = "192.168.56"
# Map host type with IP
TYPE2IP = {
  'ansible' => "#{PREFIP}.8", # ubuntu
  'debian' => "#{PREFIP}.16",
  'almalinux' => "#{PREFIP}.32",
  'windows' => "#{PREFIP}.128"
}
# We reuse boxes to not exhaust RAM.
# TODO. Sync with hosts.ini
ips = {
  'ansible' => "#{TYPE2IP['ansible']}",
  # [cloud] -> used to install Docker
  'cloud' => "#{TYPE2IP['ansible']}",
  # [dbservers]
  'db' => "#{TYPE2IP['debian']}",
  # [labs]
  'lab01' => "#{TYPE2IP['ansible']}",
  'lab02' => "#{TYPE2IP['ansible']}",
  'lab03' => "#{TYPE2IP['ansible']}",
  # [ti]
  'ti1' => "#{TYPE2IP['ansible']}",
  # [rsyncservers]
  'nas' => "#{TYPE2IP['debian']}",
  # [workstations]
  'simula' => "#{TYPE2IP['ansible']}",
  # [webservers]
  'w3' =>  "#{TYPE2IP['almalinux']}",
  'web' =>  "#{TYPE2IP['debian']}",
  # [windows]
  # [office]
  'off1' => "#{TYPE2IP['windows']}"
}

vms = {
  'ansible'  => {
      'memory' => '2048',
      'cpus' => 1, 'ip' => "#{TYPE2IP['ansible']}",
      'box' => 'ubuntu/jammy64'
  },
  'almalinux'     => {
      'memory' => '512',
      'cpus' => 1, 'ip' => "#{TYPE2IP['almalinux']}",
      'box' => 'almalinux/9'
  },
  'debian'   => {
      'memory' => '512',
      'cpus' => 1,
      'ip' => "#{TYPE2IP['debian']}",
      'box' => 'generic/debian12'
  },
#  'windows'   => {
#      'memory' => '2048',
#      'cpus' => 1, 'ip' => "#{TYPE2IP['windows']}",
#      'box' => 'gusztavvargadr/windows-10'
#  }
}

Vagrant.configure('2') do |config|

  vms.each do |name, conf|
    config.vm.box_check_update = false
    # Issue: https://github.com/hashicorp/vagrant/issues/5186
    config.ssh.insert_key = false
    # Increase timeout due Windows box update during boot
    config.vm.boot_timeout = 1200

    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{name}" #.#{DOMAIN}", don't append the domain
      k.vm.network 'private_network', ip: "#{conf['ip']}"
      k.vm.box = conf['box']

      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        if "#{name}" == "windows"
          # See what's happenning with Windows box.
          vb.gui = true
        end
      end

      k.vm.provider 'libvirt' do |lv|
        lv.cpus = conf['cpus']
        lv.memory = conf['memory']
        lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => 1
      end

      # Common provisioning tasks for Linux boxes
      if "#{name}" != "windows"
        k.vm.provision "shell", path: "provision/default.sh"
        # Append the hostnames in /etc/hosts
        ips.each_pair {|hostname, ip|
          k.vm.provision "shell", inline: "echo \"#{ip} #{hostname}.#{DOMAIN} #{hostname}\" >>/etc/hosts"
        }
      end

      # Specific to Ansible host controller
      if "#{name}" == "ansible"
        # Install additional programs
        k.vm.provision "shell", path: "provision/ansible.sh"
        # Share Ansible examples folder
        k.vm.synced_folder "./", "/home/vagrant/livro", mount_options: ["dmode=755,fmode=644"]
      end

    end
  end
end
