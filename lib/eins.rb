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
  view :r2, :key => :c, :map => "function(doc) { if(doc.b){ c=doc.b.countryip; emit(c.id, {range:[c.start_long,c.end_long]});} }", :include_docs => true, :type => :raw

  list :range_list, <<-JS
    function(head,req) {
      var row;
      send('{"rows": [');
      while(row=getRow()){
        row.doc.range = row.doc.c;
        send(JSON.stringify(row);
      }
      send(']}');
    }
  JS
end
