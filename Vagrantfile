Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'

  # use the insecure key to allow ansible to ssh onto the box
  config.ssh.insert_key = false

  config.vm.network :forwarded_port, host: 8000, guest: 80

  config.vm.define :gitlab do |node|
    node.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 1
    end
    config.vm.provision :ansible do |ansible|
      ansible.playbook = 'playbook.yml'
      ansible.verbose = 'vv'
    end
  end

end
