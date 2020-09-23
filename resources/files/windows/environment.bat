@ECHO OFF
REM This is the parent directory of the directory containing this script (resolves to :install_root/Puppet)
SET PL_BASEDIR=%~dp0..
REM Avoid the nasty \..\ littering the paths.
SET PL_BASEDIR=%PL_BASEDIR:\bin\..=%

SET PUPPET_DIR=%PL_BASEDIR%\puppet

REM Set a fact so we can easily source the environment.bat file in the future.
SET FACTER_env_windows_installdir=%PL_BASEDIR%

REM Add puppet's bin to the PATH
SET PATH=%PATH%;%PL_BASEDIR%\bin

REM Set the RUBY LOAD_PATH using the RUBYLIB environment variable
SET RUBYLIB=%PUPPET_DIR%\lib;%RUBYLIB%

REM Translate all slashes to / style to avoid issue #11930
SET RUBYLIB=%RUBYLIB:\=/%

REM Now return to the caller.

REM Set SSL variables to ensure trusted locations are used
SET SSL_CERT_FILE=%PUPPET_DIR%\ssl\cert.pem
SET SSL_CERT_DIR=%PUPPET_DIR%\ssl\certs
SET OPENSSL_CONF=%PUPPET_DIR%\ssl\openssl.cnf
