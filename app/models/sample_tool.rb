class SampleTool 
  include CouchPotato::Persistence

  property :a
  property :b
  property :c
  property :d
  property :e

  view :all, :key => :c
  view :show_my_range, :map => "function(doc) { if(doc.b){ c=doc.b.countryip; emit(c.id, {range:[c.start_long,c.end_long]});} }", :include_docs => true, :type => :custom

  view :r1, :key => :c, :properties => [:b], :type => :properties
  view :r2, :key => :c,
    :map => <<-MAP
function(doc) {
  if (doc.b) {
    c = doc.b.countryip;
  emit({
      link: [c.id, doc.d]
    }, {
      range: [c.start_long, c.end_long]
    });
  }
}
  MAP
  def self.db
    CouchPotato.database
  end
  def db
    return SampleTool.db
  end

  def self.r_first
    self.db.view(SampleTool.all).first
  end

  def cmd_a
    s=b['countryip']['start_long']
    e=b['countryip']['end_long']
    self.a=[]
    s.upto(e).each{|e|self.a<<IPAddr.new(e,Socket::AF_INET).to_s}
    self.a.shuffle!
    db.save(self)
  end

  def produce_hl_norm_lst(filename='hl.norm.lst')
    f=open(filename,'w')
    f.write(self.a.join("\n"))
    f.close
  end
end
