class Sample < ActiveResource::Base #< CouchFoo::Base
  include CouchPotato::Persistence

  property :a
  property :b

end

