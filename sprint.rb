require 'httparty'
require 'digest/md5'
require 'pp'

class Sprint
  include HTTParty
  base_uri 'www.sprintdevelopersandbox.com'
  
  def initialize(sprint_creds)
    @sprint_creds = sprint_creds
  end
  
  def fourg
    params = {
      'mac' => @sprint_creds['mac'],
      #'mdn' => @sprint_creds['phone'],
      'key' => @sprint_creds['key'],
      'timestamp' => timestamp
    }
    
    sprint_resource = "/developerSandbox/resources/v1/location4g.json?"
    self.class.get(sprint_resource + query_string(params), :format => :json)
  end
  
  
  def devices
    params = {
      'key' => @sprint_creds['key'],
      #'type' => 'a',
      'timestamp' => timestamp
    }

    sprint_resource = "/developerSandbox/resources/v1/devices.json?"
    self.class.get(sprint_resource + query_string(params), :format => :json)
  end
  
  private
  
  def timestamp
    Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SGMT")
  end
  
  def query_string(params)
    sig_key = params.sort_by{|k,v| k}.map{|k,v| "#{k}#{v}"}.join + @sprint_creds['secret']
    puts sig_key
    params['sig'] = Digest::MD5.hexdigest(sig_key)
    puts params['sig']
        
    query_string = params.sort_by{|k,v| k}.map{|k,v| "#{k}=#{v}"}.join('&')
    puts query_string
    query_string
  end
end