class drupal::drush (
  $docroot = $drupal::docroot,
  $version = $drupal::drushversion
) {
  # install composer
  exec { 'install composer':
      command     => '/usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer',
      environment => ['HOME=/root'],
      unless      => '/usr/bin/test -f /usr/local/bin/composer',
  }

  exec { 'install drush':
      command     => "/usr/local/bin/composer global require drush/drush:${version}",
      environment => ['HOME=/root'],
      unless      => '/usr/bin/test -f /root/.composer/vendor/drush/drush/drush',
      require     => Exec['install composer']
  }

  file { '/usr/local/bin/drush':
    ensure  => symlink,
    target  => '/root/.composer/vendor/drush/drush/drush',
    require => Exec['install drush'],
  }

  file { '/etc/drush':
    ensure => directory,
  }

  file { '/etc/drush/drushrc.php':
    ensure  => file,
    content => template('drupal/drushrc.php.erb'),
  }
}

