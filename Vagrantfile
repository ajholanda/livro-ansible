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
  # [lab]
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
      # Altere para 8192 MB para instalar o AWX.
      'memory' => '1024',
      # Altere para 4 CPUs para instalar o AWX.
      'cpus' => 1,
      'ip' => "#{TYPE2IP['ansible']}",
      'box' => 'ubuntu/jammy64',
      'ssh_port' => 2230
  },
  'almalinux'     => {
      'memory' => '1560',
      'cpus' => 1,
      'ip' => "#{TYPE2IP['almalinux']}",
      'box' => 'almalinux/9',
      'ssh_port' => 2221
  },
  'debian'   => {
      'memory' => '512',
      'cpus' => 1,
      'ip' => "#{TYPE2IP['debian']}",
      'box' => 'debian/bookworm64',
      'ssh_port' => 2222
  },
  'windows'   => {
      'memory' => '4096',
      'cpus' => 2,
      'ip' => "#{TYPE2IP['windows']}",
      'box' => 'gusztavvargadr/windows-server',
      # Porta de comunicação no host: WinRM (5985), não SSH.
      'comm_port' => 2223
  }
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

      if "#{name}" == "windows"
        # Windows Server boxes se comunicam por WinRM, não por SSH.
        k.vm.communicator = 'winrm'
        k.winrm.username = 'vagrant'
        k.winrm.password = 'vagrant'
        k.winrm.transport = :negotiate
        # Encaminha WinRM (5985) e RDP (3389) em vez de SSH.
        k.vm.network 'forwarded_port', guest: 5985, host: conf['comm_port'], id: 'winrm', auto_correct: true
        k.vm.network 'forwarded_port', guest: 3389, host: 33389, id: 'rdp', auto_correct: true
      else
        k.vm.network 'forwarded_port', guest: 22, host: conf['ssh_port'], id: 'ssh'
      end

      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        if "#{name}" == "windows"
          # Economiza disco ao criar várias VMs a partir da mesma box.
          vb.linked_clone = true
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

      # Bootstrap do OpenSSH no Windows para que o Ansible conecte por SSH
      # (group_vars/windows.yml) sem alterar nenhum arquivo do inventario.
      if "#{name}" == "windows"
        k.vm.provision "shell", path: "provision/windows.ps1"
      end

      # Specific to Ansible host controller
      if "#{name}" == "ansible"
        # Expose AWX (kubectl port-forward) ao host
        k.vm.network 'forwarded_port', guest: 8080, host: 8080, id: 'awx'
        # Install additional programs
        k.vm.provision "shell", path: "provision/ansible.sh"
        # Share Ansible examples folder
        k.vm.synced_folder "./", "/home/vagrant/livro", mount_options: ["dmode=755,exec,fmode=644"]
      end

    end
  end
end
