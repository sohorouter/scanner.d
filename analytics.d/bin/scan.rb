require 'net/http'

def test_auth(host,port,user,pass)
  puts "testing #{host} on port #{port} with #{user} #{pass}"

  Net::HTTP.start(host,port) {|http|
    http.open_timeout=10
    http.read_timeout=30
    req = Net::HTTP::Get.new('/')
    req.basic_auth user,pass
    response = http.request(req)
    case response
    when Net::HTTPSuccess,Net::HTTPRedirection
      puts "ACK http://#{host}:#{port}/"
      open("scan.#{host}.#{port}.html","w").write(response.body)
    else
      puts "NAK #{host} #{port}"
      #res.error!
    end
  }


  #res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
rescue
  puts "ERR #{host} #{port}"
end

fname='router.d.lst'
rr=open(fname).readlines

rr.each{|e|
  r=e.chomp.partition('.')
  p=r[0].sub!('ncp','')
  h=r[2]

  test_auth(h,p,'admin','password')
}
