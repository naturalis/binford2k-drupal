class drupal::package::remote (
  $docroot = $drupal::docroot,
  $version = $drupal::drupalversion,
) {

  # TODO: This logic is flawed if a user wants to install to an existing directory.
  exec { 'install drupal':
    command => "/bin/tar -xf /tmp/drupal-${version}.tar.gz -C ${docroot} && rm /tmp/drupal-${version}.tar.gz",
    onlyif  => "/usr/bin/wget http://ftp.drupal.org/files/projects/drupal-${version}.tar.gz -O /tmp/drupal-${version}.tar.gz",
    creates => $docroot,
  }

}
