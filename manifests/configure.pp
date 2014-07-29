class drupal::configure {

  if $drupal::installtype == 'package' {
    file { $drupal::docroot:
      ensure => link,
      target => $drupal::installroot,
    }
  }

  file { "${drupal::docroot}/.htaccess":
    ensure  => file,
    replace => "no",
    source  => 'puppet:///modules/drupal/htaccess',
  }

}
