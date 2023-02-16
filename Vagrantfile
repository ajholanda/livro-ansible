vms = {
 'ansible'  => {'memory' => '1024', 'cpus' => 1, 'ip' => '8',  'box' => 'ubuntu/focal64'},
 'web'   => {'memory' => '512', 'cpus' => 1, 'ip' => '80', 'box' => 'debian/bullseye64'},
# 'w3'     => {'memory' => '512', 'cpus' => 1, 'ip' => '88', 'box' => 'almalinux/9'},
#'fedora'   => {'memory' => '1024', 'cpus' => 1, 'ip' => '201', 'box' => 'fedora/35-cloud-base'},
#'opensuse' => {'memory' => '1024', 'cpus' => 1, 'ip' => '202', 'box' => 'opensuse/Leap-15.4.x86_64'}
}

Vagrant.configure('2') do |config|

  config.vm.box_check_update = false

  vms.each do |name, conf|

    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{name}.example.net"
      k.vm.network 'private_network', ip: "192.168.32.#{conf['ip']}"
      k.vm.box = conf['box']

      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
      end

      k.vm.provider 'libvirt' do |lv|
        lv.cpus = conf['cpus']
        lv.memory = conf['memory']
        lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => 1
      end
      
      config.vm.provision "shell", path: "provision.sh"
      config.vm.synced_folder "./", "/home/vagrant/ansible", mount_options: ["dmode=755,fmode=644"]
    
    end
  end
end