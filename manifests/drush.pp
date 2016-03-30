class drupal::drush (
  $docroot = $drupal::docroot,
  $version = $drupal::drushversion
) {
  # When drush7 gets packaged, drop this crap
  if $drupal::installtype == 'remote' {
    exec { 'install drush':
      command => "/bin/tar -xf /tmp/drush-${version}.tar.gz -C /usr/local/share && rm /tmp/drush-${version}.tar.gz",
      onlyif  => "/usr/bin/wget http://ftp.drupal.org/files/projects/drush-${version}.tar.gz -O /tmp/drush-${version}.tar.gz",
      creates => '/usr/local/share/drush',
    }
  } else {
    file { "/tmp/drush-${version}.tar.gz":
      ensure => file,
      source => "puppet:///modules/drupal/drush-${version}.tar.gz",
      before => Exec['install drush'],
    }
    exec { 'install drush':
      command => "/bin/tar -xf /tmp/drush-${version}.tar.gz -C /usr/local/share",
      creates => '/usr/local/share/drush',
    }
  }

  file { '/usr/local/bin/drush':
    ensure  => symlink,
    target  => '/usr/local/share/drush/drush',
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

