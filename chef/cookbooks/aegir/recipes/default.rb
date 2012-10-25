# Add the koumbit package repository
e = execute 'echo "deb http://debian.aegirproject.org stable main" | sudo tee -a /etc/apt/sources.list.d/aegir-stable.list' do
    action :run
end
# Add Koumbit's secure key and update
e = execute 'wget -q http://debian.aegirproject.org/key.asc -O- | sudo apt-key add - && sudo apt-get update' do
    action :run
end

# set the hostname for local development
e = execute "echo 'aegir.loc' > /etc/hostname && hostname aegir.loc" do
    action :run
end
# set hosts file for local development
e = execute "sed -i 's/precise32/aegir/g' /etc/hosts" do
    action :run
end
e = execute "sed -i 's/localhost/aegir.loc localhost/g' /etc/hosts" do
    action :run
end

# Configure debian default selections for Postfix and Aegir
package "debconf-utils" do
    action [:install]
end
# Put debconf.selections.conf in /tmp, then debconf-set-selections it
template "/tmp/debconf.selections.conf" do
    source "debconf.selections.erb"
    mode 0755
    owner "root"
    group "root"
end
e = execute "debconf-set-selections /tmp/debconf.selections.conf" do
    action :run
end

# Add mysql-server first
package "mysql-server" do
    action [:install]
end
e = execute '/usr/bin/mysql -uroot -e "DELETE FROM mysql.user WHERE User=\'\'; DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\'); DELETE FROM mysql.db WHERE Db=\'test\' OR Db=\'test\\_%\'; FLUSH PRIVILEGES;"' do
    action :run
end
e = execute 'mysqladmin -uroot password aegir' do
    action :run
end

# Now see if we can install Aegir with no user input required
#package "aegir" do
#    action [:install]
#end
#
#template "/var/aegir/platforms/incubator-dev.make" do
#    source "incubator-dev.erb"
#    mode 644
#    owner "aegir"
#    group "aegir"
#end

template "/home/vagrant/.bash_aliases" do
    source "bash_aliases.erb"
    mode 0644
    owner "vagrant"
    group "vagrant"
end

template "/etc/vim/vimrc.tiny" do
    source "vimrc.erb"
    mode 0644
    owner "root"
    group "root"
end

template "/etc/vim/vimrc.local" do
    source "vimrc.erb"
    mode 0644
    owner "root"
    group "root"
end

template "/etc/php5/php-local.ini" do
    source "php-local.erb"
    mode 0644
    owner "root"
    group "root"
end

template "/home/vagrant/testsite" do
    source "testsite.erb"
    mode 0744
    owner "vagrant"
    group "vagrant"
end

package "php5-xdebug" do
    action [:install]
end

package "samba" do
    action [:install]
end


