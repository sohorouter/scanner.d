class SampleTool 
  include CouchPotato::Persistence
  include FileUtils

  def initialize
    self.cnyper_d ||= SampleTool.cnyper_d_default
  end
  def self.cnyper_d_default
    File.expand_path('../')
  end

  property :a
  property :b
  property :c
  property :d
  property :e
  property :cnyper_d

  view :all, :key => :c
  view :show_my_range, :map => "function(doc) { if(doc.b){ c=doc.b.countryip; emit(c.id, {range:[c.start_long,c.end_long]});} }", :include_docs => true, :type => :custom

  view :r1, :key => :c, :properties => [:b], :type => :properties
  view :r2, :key => :c,
    :map => <<-MAP
function(doc) { if (doc.b) { c = doc.b.countryip; emit({ link: [c.id, doc.d] }, { range: [c.start_long, c.end_long] }); } }
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

  def prepare_hostips_from_a
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

  def produce_scanner_d
    Dir.mkdir(scanner_d) if !File.exist?(scanner_d)
  end
  def copy_scanning_bins_to_scanner_d
    self.cnyper_d ||= SampleTool.cnyper_d_default
    bin_d=File.join(self.cnyper_d,'scanning.d','bin').to_s
    Dir.entries(bin_d).each{|e|
      if(e[0]!='.');cp(File.join(bin_d,e).to_s,scanner_d)
      end
    }
  end
  def copy_hl_norm_lst_to_scanner_d(filename='hl.norm.lst')
    self.cnyper_d ||= SampleTool.cnyper_d_default
    cp(File.expand_path('.',filename),scanner_d)
  end

  def prepare_scanning_d
    prepare_hostips_from_a
    produce_hl_norm_lst
    produce_scanner_d
    copy_hl_norm_lst_to_scanner_d
    copy_scanning_bins_to_scanner_d
  end

  private
  def rdir
    rdir="r"
    rdir+=("%04d"%Date.today.year)
    rdir+=("%02d"%Date.today.month)
    rdir+=("%02d"%Date.today.day)
  end
  def scanner_d
    self.cnyper_d ||= SampleTool.cnyper_d_default
    dir=File.join(self.cnyper_d,'scanning.d',rdir+'.'+self.c.to_s+'.d').to_s
  end
end
