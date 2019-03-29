# SETUP
require 'rubygems'
require 'bundler'

Bundler.setup

require 'pry'
require 'grpc'
require 'google/protobuf'

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, '20190329_user_service_ruby_lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'users_service_services_pb'
#



# model
class User
  USER_DB = [
    { id: 1, email: 'zhitong111@email.com', name: 'zhitong111' },
    { id: 2, email: 'zhitong222@email.com', name: 'zhitong222' },
    { id: 3, email: 'zhitong333@email.com', name: 'zhitong333' }
  ]

  def self.find(id)
    USER_DB.find { |record| record[:id] == id }
  end

  def self.all
    USER_DB
  end
end

class UserServer < Demo::Users::Service
  def find(req, _call)
    sleep 30;
    user = User.find(req.id)
    Demo::User.new(id: user[:id], email: user[:email], name: user[:name])
  end

  def all(req, _call)
    Demo::AllUserReply.new(users: User.all)
  end
end


def main
  puts "On Air"
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:3000', :this_port_is_insecure)
  s.handle(UserServer)
  s.run_till_terminated
end

main
