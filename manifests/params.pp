class hue::params {
  $version         = '3.11.0'
  $install_method  = 'bin'
  $install_dir     = "/opt/hue-${version}"
  $install_prefix  = '/usr/local'
  $mirror_url      = 'https://dl.dropboxusercontent.com/u/730827/hue/releases'
  $install_python  = true
  $install_java    = true
  $install_maven   = true
  $install_dependencies = true
  $package_dir     = '/var/tmp/hue'
  $package_name    = undef
  $package_ensure  = 'present'
  $group_id        = undef
  $user_id         = undef

  $config_dir      = '/usr/local/hue/desktop/conf'
  $config_file     = "${config_dir}/hue.ini"
  $pid_location    = '/usr/local/hue/hue.pid'
  $log_dir         = '/var/log/hue'

  $packages_dependencies = [ 'ant', 'asciidoc', 'cyrus-sasl-devel', 'cyrus-sasl-gssapi', 'cyrus-sasl-plain', 'gcc', 'gcc-c++', 'krb5-devel', 'rsync',
  'libffi-devel', 'libxml2-devel', 'libxslt-devel', 'make', 'openldap-devel', 'sqlite-devel', 'openssl-devel', 'gmp-devel', 'mysql-devel', 'mysql' ]


  $service_name    = 'hue-server'
  $service_install = true
  $service_ensure  = 'running'

  $service_restart = true

  $config_defaults = {
    'desktop' => {
      'secret_key' => '',
      'http_host'  => '0.0.0.0',
      'http_port'  => '8000',
      'time_zone'  => 'America/Los_Angeles',
    },
    'notebook' => {
      'interpreters' => {
        'hive' => {
          'name'      => 'Hive',
          'interface' => 'hiveserver2',
        },
        'impala' => {
          'name'      => 'Impala',
          'interface' => 'hiveserver2',
        },
        'spark' => {
          'name'      => 'Scala',
          'interface' => 'livy',
        },
        'pyspark' => {
          'name'      => 'PySpark',
          'interface' => 'livy',
        },
        'r' => {
          'name'      => 'R',
          'interface' => 'livy',
        },
        'jar' => {
          'name'      => 'Spark Submit Jar',
          'interface' => 'livy-batch',
        },
        'py' => {
          'name'      => 'Spark Submit Python',
          'interface' => 'livy-batch',
        },
        'pig' => {
          'name'      => 'Pig',
          'interface' => 'oozie',
        },
        'text' => {
          'name'      => 'Text',
          'interface' => 'text',
        },
        'markdown' => {
          'name'      => 'Markdown',
          'interface' => 'text',
        },
        'mysql' => {
          'name'      => 'MySQL',
          'interface' => 'rdbms',
        },
        'sqlite' => {
          'name'      => 'SQLite',
          'interface' => 'rdbms',
        },
        'postgresql' => {
          'name'      => 'PostgreSQL',
          'interface' => 'rdbms',
        },
        'oracle' => {
          'name'      => 'Oracle',
          'interface' => 'rdbms',
        },
        'solr' => {
          'name'      => 'Solr SQL',
          'interface' => 'solr',
        },
        'java' => {
          'name'      => 'Java',
          'interface' => 'oozie',
        },
        'spark2' => {
          'name'      => 'Spark',
          'interface' => 'oozie',
        },
        'mapreduce' => {
          'name'      => 'MapReduce',
          'interface' => 'oozie',
        },
        'sqoop1' => {
          'name'      => 'Sqoop1',
          'interface' => 'oozie',
        },
        'distcp' => {
          'name'      => 'Distcp',
          'interface' => 'oozie',
        },
        'shell' => {
          'name'      => 'Shell',
          'interface' => 'oozie',
        },
      },
    },
    'hadoop' => {
      'hdfs_clusters' => {
        'default' => {
          'fs_defaultfs' => 'hdfs://localhost:8020',
        },
      },
      'yarn_clusters' => {
        'default' => {
          'submit_to' => 'True',
        },
      },
      'mapred_clusters' => {
        'default' => {
          'submit_to' => 'False',
        },
      },
    },
  }
}
