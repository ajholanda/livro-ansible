DOMAIN = "example.net"
PREFIP = "192.168.64"

# We reuse boxes to not exhaust RAM.
ips = {
  'ansible' => "#{PREFIP}.8",
  'db' => "#{PREFIP}.80",
  'lab00' => "#{PREFIP}.64",
  'lab01' => "#{PREFIP}.64",
  'lab02' => "#{PREFIP}.64",
  'nas' => "#{PREFIP}.80",
  'simula' => "#{PREFIP}.64",
  'w3' => "#{PREFIP}.88",
  'web' => "#{PREFIP}.80",
  'windows' => "#{PREFIP}.128"
}

vms = {
  'ansible'  => {
      'memory' => '512',
      'cpus' => 1, 'ip' => "#{ips['ansible']}",
      'box' => 'ubuntu/focal64'
  },
  'simula'  => {
      'memory' => '512',
      'cpus' => 1, 'ip' => "#{ips['simula']}",
      'box' => 'ubuntu/focal64'
  },
  'w3'     => {
      'memory' => '512',
      'cpus' => 1, 'ip' => "#{ips['w3']}",
      'box' => 'almalinux/9'
  },
  'web'   => {
      'memory' => '512',
      'cpus' => 1,
      'ip' => "#{ips['web']}",
      'box' => 'debian/bullseye64'
  },
  'windows'   => {
      'memory' => '2048',
      'cpus' => 1, 'ip' => "#{ips['windows']}",
      'box' => 'gusztavvargadr/windows-10'
  }
}

Vagrant.configure('2') do |config|

  vms.each do |name, conf|
    config.vm.box_check_update = false
    # Issue: https://github.com/hashicorp/vagrant/issues/5186
    config.ssh.insert_key = false
    # Increase timeout due Windows box update during boot
    config.vm.boot_timeout = 600

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
        k.vm.provision "shell", path: "provision.sh"
      else
        k.vm.provision "shell", path: "provision.ps1", privileged: true, powershell_elevated_interactive: true
      end

      # Specific to Ansible host controller
      if "#{name}" == "ansible"
        # Append the hostnames in /etc/hosts
        ips.each_pair {|hostname, ip|
          k.vm.provision "shell", inline: "echo \"#{ip} #{hostname}.#{DOMAIN} #{hostname}\" >>/etc/hosts"
        }
        # Shared Ansible folder with the examples
        k.vm.synced_folder "./", "/home/vagrant/ansible", mount_options: ["dmode=755,fmode=644"]
      end

    end
  end
end