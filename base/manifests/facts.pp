class base::facts ()
{
	cron { "Update_Facter_Yaml":
		command => "/usr/local/bin/runcron -m root /opt/puppetlabs/bin/facter -y > /etc/mcollective/facts.yaml 2>&1",
		user    => "root",
		hour    => "*",
		minute  => "*/30",
		ensure => $ensure,
	}


}
