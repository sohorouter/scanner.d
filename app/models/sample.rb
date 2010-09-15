class Sample #< ActiveResource::Base #< CouchFoo::Base
  include CouchPotato::Persistence

  property :a
  property :b
  property :c
  property :d
  property :ip_start

  view :all, :key => :ip_start


  # quick check couchdb availability
  def self.r_special_first
    self.db.view(Sample.all).first
  end

  def self.db
    CouchPotato.database
  end
  def db
    return Sample.db
  end

  def copy_start_ip_from(st)
    # st isa SampleTool
    ip_start = st.b['countryip']['start_ip']
  end

  def copy_start_ip_from!(st)
    copy_start_ip_from(st)
    db.save(self)
  end

  def cmd_a
    self.a = "nc -q1 -x 127.0.0.1:8118 -X connect #{ip_start} 80 <~/tmp/samplereq"
  end
  def cmd_b
    self.b = "nc -q1 -x 127.0.0.1:8118 -X connect #{ip_start} 8080 <~/tmp/samplereq"
  end
  def cmd_c
    self.c = "proxychains  nmap -sT -PN -n -sV -p21,22,25,80,8080 #{ip_start}"
  end
  def cmd_all
    cmd_a;cmd_b;cmd_c
    db.save(self)
  end
end

