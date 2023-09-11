set :branch, 'main'
set :server_address, '191.252.196.2'
 
ask(:password, nil, echo: false)

set :stage, :production
server fetch(:server_address), user: 'deploy', roles: %w{app db web}
 
set :nginx_server_name, fetch(:server_address)
set :puma_preload_app, true
