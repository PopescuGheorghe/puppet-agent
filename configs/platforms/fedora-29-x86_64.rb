platform "fedora-29-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"
  plat.dist "fc29"


  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/g/gcc-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/l/libgomp-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/c/cpp-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/l/libstdc++-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/g/gcc-c++-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/l/libstdc++-devel-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/l/libquadmath-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora/releases/27/Everything/x86_64/os/Packages/l/libquadmath-devel-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__remote_fedora-cache/updates/27/x86_64/Packages/r/redhat-rpm-config-77-1.fc27.noarch.rpm")



  plat.provision_with("dnf install -y cpp-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y libgomp-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y gcc-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y libstdc++-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y libstdc++-devel-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y gcc-c++-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y libquadmath-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y libquadmath-devel-7.2.1-2.fc27.x86_64.rpm")
  plat.provision_with("dnf install -y redhat-rpm-config-77-1.fc27.noarch.rpm")

  plat.provision_with "/usr/bin/dnf install -y --allowerasing --exclude=gcc --exclude=gcc-c++ autoconf automake rsync make cmake patch rpm-build"
  plat.install_build_dependencies_with "/usr/bin/dnf install -y --allowerasing --exclude=gcc --exclude=gcc-c++"
  plat.vmpooler_template "fedora-29-x86_64"
end
