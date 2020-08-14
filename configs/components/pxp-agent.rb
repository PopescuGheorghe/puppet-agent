component "pxp-agent" do |pkg, settings, platform|
  unless settings[:pxp_agent_version] && settings[:pxp_agent_location] && settings[:pxp_agent_basename]
    raise "Expected to find :pxp_agent_version, :pxp_agent_location, and :pxp_agent_basename settings; Please set these in your project file before including pxp-agent as a component."
  end

  pkg.version settings[:pxp_agent_version]

  tarball_name = "#{settings[:pxp_agent_basename]}.tar.gz"
  pkg.url File.join(settings[:pxp_agent_location], tarball_name)
  pkg.sha1sum File.join(settings[:pxp_agent_location], "#{tarball_name}.sha1")

  pkg.install_only true

  if platform.is_windows?
    # We need to make sure we're setting permissions correctly for the executables
    # in the ruby bindir since preserving permissions in archives in windows is
    # ... weird, and we need to be able to use cygwin environment variable use
    # so cmd.exe was not working as expected.
    install_command = [
      "gunzip -c #{tarball_name} | tar -k -C /cygdrive/c/ -xf -",
      "chmod 755 #{settings[:bindir].sub(/C:/, '/cygdrive/c')}/*"
    ]
  elsif platform.is_macos?
    # We can't untar into '/' because of SIP on macOS; Just copy the contents
    # of these directories instead:
    install_command = [
      "tar -xzf #{tarball_name}",
      "for d in opt var private; do rsync -ka \"$${d}/\" \"/$${d}/\"; done"
    ]
  else
    install_command = ["gunzip -c #{tarball_name} | #{platform.tar} -k -C / -xf -"]
  end

  pkg.install do
    install_command
  end

    pkg.directory File.join(settings[:sysconfdir], 'pxp-agent')
  if platform.is_windows?
    pkg.directory File.join(settings[:sysconfdir], 'pxp-agent', 'modules')
    pkg.directory File.join(settings[:install_root], 'pxp-agent', 'spool')
    pkg.directory File.join(settings[:install_root], 'pxp-agent', 'tasks-cache')
    pkg.directory File.join(settings[:sysconfdir], 'pxp-agent', 'log')
  else
    # Output directories (spool, tasks-cache, logdir) are restricted to root agent.
    # Modules is left readable so non-root agents can also use the installed modules.
    pkg.directory File.join(settings[:sysconfdir], 'pxp-agent', 'modules'), mode: '0755'
    pkg.directory File.join(settings[:install_root], 'pxp-agent', 'spool'), mode: '0750'
    pkg.directory File.join(settings[:install_root], 'pxp-agent', 'tasks-cache'), mode: '0750'
    pkg.directory File.join(settings[:logdir], 'pxp-agent'), mode: '0750'
  end

  service_conf = settings[:service_conf]

  case platform.servicetype
  when 'systemd'
    pkg.install_service "#{service_conf}/systemd/pxp-agent.service", "#{service_conf}/redhat/pxp-agent.sysconfig"
    pkg.install_configfile "#{service_conf}/systemd/pxp-agent.logrotate", '/etc/logrotate.d/pxp-agent'
    if platform.is_deb?
      pkg.add_postinstall_action ['install'], ['systemctl disable pxp-agent.service >/dev/null || :']
    end
  when 'sysv'
    if platform.is_deb?
      pkg.install_service "#{service_conf}/debian/pxp-agent.init", "#{service_conf}/debian/pxp-agent.default"
      pkg.add_postinstall_action ['install'], ['update-rc.d pxp-agent disable > /dev/null || :']
    elsif platform.is_sles?
      pkg.install_service "#{service_conf}/suse/pxp-agent.init", "#{service_conf}/redhat/pxp-agent.sysconfig"
    elsif platform.is_rpm?
      pkg.install_service "#{service_conf}/redhat/pxp-agent.init", "#{service_conf}/redhat/pxp-agent.sysconfig"
    end
    pkg.install_configfile "#{service_conf}/pxp-agent.logrotate'" '/etc/logrotate.d/pxp-agent'
  when 'launchd'
    pkg.install_service "#{service_conf}/osx/pxp-agent.plist", nil, 'com.puppetlabs.pxp-agent'
  when 'smf'
    pkg.install_service "#{service_conf}/solaris/smf/pxp-agent.xml", service_type: 'network'
  when 'aix'
    pkg.install_service 'resources/aix/pxp-agent.service', nil, 'pxp-agent'
  when 'windows'
    # Note - this definition indicates that the file should be filtered out from the Wix
    # harvest. A corresponding service definition file is also required in resources/windows/wix
    pkg.install_service "SourceDir\\#{settings[:base_dir]}\\#{settings[:company_id]}\\#{settings[:product_id]}\\puppet\\bin\\nssm-pxp-agent.exe"
  else
    fail "need to know where to put #{pkg.get_name} service files"
  end
end
