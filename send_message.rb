#!/usr/bin/ruby
require 'cgi'
require 'erb'
require 'net/smtp'

@cgi = CGI.new
@params = @cgi.params

def redirect_to(uri)
	unless uri =~ /^\//
	base_uri = (ENV['REQUEST_URI'] =~ /(.*\/)[^\/]*/ ? $1 : ENV['REQUEST_URI'])
	uri = base_uri+uri
	end
	@cgi.out( 'status'      => 'REDIRECT',
						 'location' => uri,
						 'server'       => ENV['SERVER_SOFTWARE'],
						 'connection' => 'close',
						 'type'         => 'text/html') do
		"Request redirected to: #{uri}"
	end
	@redirected = true
end

def render_template(name, eoutval='_erbout')
	ERB.new( File.read(name+'.erb'), nil, nil, eoutval).result
end

def content_class
	'EmailDeliveryReport'
end

def page_content
	render_template @action
end

begin
	@email = @params['email'].to_s
	@message = @params['message'].to_s
	raise "Nie podano adresu email." if @email==""
	raise "Treść wiadomości jest pusta." if @message==""
	msg = "Subject: Dane ze strony www.pralniapanda.pl (#{@email})\n\n" + @message
	Net::SMTP.start('acchsh.com', 25, 'pralniapanda.pl', 'rafal', 'ccpebdqn', :plain) do |smtp|
		smtp.send_message msg, @email, 'panda@pralniapanda.pl'
	end
	redirect_to "index.html"
rescue
	begin
		@cgi.out do
			@action = "mail_error"
			@error = $!
			render_template 'layout', '_elayout'
		end
	rescue
		@cgi.out do
			$!.message + '<br>' +
			$!.backtrace.join('<br>')		
		end
	end
end