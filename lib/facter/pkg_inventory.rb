
Facter.add(:packages) do
  confine :osfamily => 'RedHat'
  setcode do
    packages = {}

    package_list = Facter::Util::Resolution.exec('/bin/rpm --query --all --qf "%{NAME};;%{VERSION}\n"')
    package_list.split("\n").each do |line|

      pkg_split   = line.split(";;")
      pkg_name    = pkg_split[0].gsub('-', '_')
      pkg_version = pkg_split[1]

      packages[pkg_name] = pkg_version

    end

    packages
  end
end
