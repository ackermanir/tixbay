require "omniauth-facebook"
config.omniauth :facebook, '439027159486939', '8dfab9122431cf119056e884d6202287', {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
