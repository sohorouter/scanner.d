class SampleTool < Sample 
  include CouchPotato::Persistence

  property :a
  property :b
  property :c
  property :d
  property :e

  view :all, :key => :c

end
