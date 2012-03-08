class Developer < SourceAdapter
	require 'xmlsimple'
	require 'uri'
	require 'net/http'
  def initialize(source) 
		@base = 'http://apigee:apigee123@192.168.1.113:3000/api/'
    super(source)
  end
 
  def login
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)
		rest_result= RestClient.get("#{@base}developers").body

     if rest_result.code != 200
				raise SourceAdapterException.new("Error connecting!")
			end
			parsed=XmlSimple.xml_in(rest_result)
			@result={}
		
			parsed['developer'].each do |developer|
				developer.keys.each do |k|
					if k.include?("-")
				  developer[k.sub(/-/, '_')] = developer[k] ; developer.delete(k) 
					elsif k.include?("id")
				  developer[k.sub(/id/, 'developer_id')] = developer[k] ; developer.delete(k)
					end
				end
				key = developer['user_name'].to_s
				@result[key]=developer
			end if parsed


		 
    # TODO: Query your backend data source and assign the records 
    # to a nested hash structure called @result. For example:
    # @result = { 
    #   "1"=>{"name"=>"Acme", "industry"=>"Electronics"},
    #   "2"=>{"name"=>"Best", "industry"=>"Software"}
    # }
    #~ raise SourceAdapterException.new("Please provide some code to read records from the backend data source")
		puts "ALL developers"
		puts @result.inspect
		puts "ALL developers"
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
		url='http://apigee:apigee123@192.168.1.113:3000/api/developer/create'
    create_update(create_hash,url) if !create_hash.nil?

    # TODO: Create a new record in your backend data source
    #~ raise "Please provide some code to create a single record in the backend data source using the create_hash"
		#~ developer=XmlSimple.xml_in(response.body)
		#~ developer.keys.each do |k|
			#~ if k.include?("-")
				#~ developer[k.sub(/-/, '_')] = developer[k] ; developer.delete(k) 
			#~ elsif k.include?("id")
				#~ developer[k.sub(/id/, 'developer_id')] = developer[k] ; developer.delete(k)
			#~ end
			#~ end			
  end
 
  def update(update_hash)
		puts "33333333333333333333333333333333333333333"
		puts update_hash.inspect
		puts "33333333333333333333333333333333333333333"
		url='http://apigee:apigee123@192.168.1.113:3000/api/developer/update'
		create_update(update_hash,url) if !update_hash.nil?
    # TODO: Update an existing record in your backend data source
    #~ raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def delete(delete_hash)
		response=RestClient.delete("#{@base}developer/#{delete_hash['user_name']}/delete")
		puts "DELETE API CALL RESULT"
		puts response.code.inspect
		puts "DELETE API CALL RESULT"
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
  
	def create_update(create_hash,d_url)
		 xml="<developer><id>#{create_hash['developer_id']}</id>
		<first-name>#{create_hash['first_name']}</first-name>
		<last-name>#{create_hash['last_name']}</last-name>
		<email>#{create_hash['email']}</email>
		<user-name>#{create_hash['user_name']}</user-name>
		<status>#{create_hash['status']}</status>
		<locale>#{create_hash['locale']}</locale>
		<organization>#{create_hash['organization']}</organization>
		<homepage>#{create_hash['homepage']}</homepage>
		<address>#{create_hash['address']}</address>
		<support-contact>#{create_hash['support_contact']}</support-contact>
		<support-phone>#{create_hash['support_phone']}</support-phone>
		</developer>"
      url = URI.parse(d_url)
			http = Net::HTTP.new(url.host,url.port)
			req = Net::HTTP::Post.new(url.path,initheader = {'Content-Type' =>'application/xml'})
			req.body = xml
			req.content_type="application/xml"
			req.basic_auth "apigee","apigee123"
			response = http.request(req)
			
			puts "Response for"+url
			puts response.body.inspect
			puts "Response for"+url
	end

end