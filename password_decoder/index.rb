require 'sinatra'
require 'digest'
require 'erb'
require 'rubygems'
require 'json'

class Password
	def get_md5 (string)
		md5 = Digest::MD5.hexdigest(string)[0..7]
		return md5
	end	
end	


class ExpertPassword < Password 
	def password(*strings)
		uuid_first_digits = strings[0][0..3]
		challenge_code = strings[1]
		input_for_md5 = uuid_first_digits + challenge_code
		return get_md5(input_for_md5)
	end	
end

class RootPassword < Password
	def password(*strings)
		uuid = strings[0]
		return get_md5(uuid)
	end
end	

set :bind, '0.0.0.0'

get '/' do
  erb :index_password_decoder
end

post '/answer'  do 
	@uuid = params[:uuid]
	@challenge_code = params[:challenge_code]
	@type_password = params[:type_password]
	erb :erb_answer
end

__END__


@@ erb_answer
<% object = eval(@type_password).new %> 
Your  password is <%=  object.password(@uuid, @challenge_code)%>
