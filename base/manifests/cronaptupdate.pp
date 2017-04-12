class base::cronaptupdate {

	$runs_per_hour = 1

	# сделаем запуск рестарта размазанным по времени в течении часа
	# чтобы сглаживало картину рестарта по всей ферме в целом
	$minutes_str = inline_template("<%-
		n = @runs_per_hour.to_i
		i = 60/n
		splay = scope.function_fqdn_rand([i]).to_i
		minutes = []
		n.times do |k|
			minute = i*k+splay
			if minute >= 60
				minute = minute - 60
			end
			minutes << minute
		end
	-%><%=minutes.join(',')%>")

	$minutes_arr = split($minutes_str, ',')

	$apt_get_update_cmd = "timeout -s 15 1000 nice -n 19 /usr/bin/apt-get update > /dev/null 2>&1"

	cron { "apt-get update":
		command => $apt_get_update_cmd,
		user    => "root",
		hour    => "*",
		minute  => $minutes_arr,
		ensure  => present,
		environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', 'MAILTO=/dev/null', ]
	}

}
