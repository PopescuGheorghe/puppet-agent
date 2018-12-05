platform "fedora-29-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"
  plat.dist "fc29"

  packages = %w(gcc gcc-c++ autoconf automake rsync make cmake patch rpm-build)

  plat.provision_with "/usr/bin/dnf install -y --allowerasing #{packages.join(' ')}"
  plat.install_build_dependencies_with "/usr/bin/dnf install -y --allowerasing"
  plat.vmpooler_template "fedora-29-x86_64"
end
