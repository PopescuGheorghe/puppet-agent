platform "el-8-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.provision_with "dnf install -y --allowerasing gcc gcc-c++ autoconf automake createrepo rsync cmake make rpm-libs rpm-build"
  plat.install_build_dependencies_with "dnf install -y --allowerasing "
  plat.vmpooler_template "redhat-8-x86_64"
end
