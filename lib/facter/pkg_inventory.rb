
Facter.add(:packages) do
  confine :osfamily => 'RedHat'
  setcode do
    packages = {}

    package_list = Facter::Util::Resolution.exec('/bin/rpm --query --all --qf "%{NAME};;%{VERSION}-%{RELEASE}%|ARCH?{.%{ARCH}}|\n"')
    package_list.split("\n").each do |line|

      pkg_split   = line.split(";;")
      pkg_name    = pkg_split[0].gsub('-', '_')
      pkg_version = pkg_split[1]

      if packages.key?(pkg_name)
        packages[pkg_name].push(pkg_version)
      else
        packages[pkg_name] = [ pkg_version ]
      end

    end

    packages
  end
end
