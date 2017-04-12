class base::locale {

	class { 'locales': 
		default_locale  => 'en_US.UTF-8',
		locales   => ['en_US.UTF-8 UTF-8', 'ru_RU.UTF-8 UTF-8'],
	}

}

