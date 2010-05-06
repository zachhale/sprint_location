require 'httparty'
require 'digest/md5'
require 'pp'

class Sprint
  include HTTParty
  base_uri 'sprintdevelopersandbox.com'
  
  def initialize(sprint_creds)
    @sprint_creds = sprint_creds
  end
  
  def fourg
    params = {
      'mac' => @sprint_creds['mac'],
      'mdn' => @sprint_creds['phone'],
      'key' => @sprint_creds['key'],
      'timestamp' => timestamp
    }
    
    sig_key = [
      "key#{params['key']}",
      "mac#{params['mac']}",
      "mdn#{params['mdn']}",
      "timestamp#{params['timestamp']}",
      "#{@sprint_creds['secret']}"
    ].join
    params['sig'] = Digest::MD5.hexdigest(sig_key)
    
    pp sig_key
    pp params
    
    self.class.get("/developerSandbox/resources/v1/location4g.xml?#{params.map{|k,v| "#{k}=#{v}"}.join('&')}")
  end
  
  def timestamp
    Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SUTC")
  end
end