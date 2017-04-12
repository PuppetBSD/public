#This type is supposed to append lines at the end of the given file.
module Puppet
  newtype(:append) do
    @doc = "Ensure that the given line is defined in the file, and append
            the line to the end of the file if the line isn't already in
            the file."
 
    def self.title_patterns
        [ [ /^(.*?)\/*\Z/m, [ [ :path, lambda{|x| x} ] ] ] ]
    end

    newparam(:name) do
      desc "The name of the resource"
    end

    newparam(:path) do
      desc "The file to examine (and possibly modify) for the line."
      isnamevar

      ####Path validation carefully stolen from puppet's file.rb :)
      validate do |value|
        # accept various path syntaxes: lone slash, posix, win32, unc
        unless (Puppet.features.posix? and (value =~ /^\/$/ or value =~ /^\/[^\/]/)) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
          fail Puppet::Error, "File paths must be fully qualified, not '#{value}'"
        end
      end
  
      # convert the current path in an index into the collection and the last
      # path name. The aim is to use less storage for all common paths in a hierarchy
      munge do |value|
        path, name = File.split(value.gsub(/\/+/,'/'))
        { :index => Puppet::FileCollection.collection.index(path), :name => name }
      end
  
      # and the reverse
      unmunge do |value|
        basedir = Puppet::FileCollection.collection.path(value[:index])
        # a lone slash as :name indicates a root dir on windows
        if value[:name] == '/'
          basedir
        else
          File.join( basedir, value[:name] )
        end
      end

    end

    newparam(:lines) do
      desc "The lines we're interested in."
    end

    newparam(:isparameter) do
      desc "Tells to take :lines as parameters, enabling some syntax analysing features."
    end

    newparam(:command) do
      desc "Executes this command if file was changed."
      defaultto 'none'
    end

#    newparam(:keep_order=false) do
#      desc "Should I keep an order of the :lines in file? By default, no."
#    end

    newproperty(:ensure) do
      desc "Whether the resource is in sync or not."

      defaultto :insync

      def retrieve
      	lines_in_sync=true
        if FileTest.exists?(resource[:path])
       		debug "File exists."
		
		resource[:lines].each do |l1|
			included = File.readlines(resource[:path]).map { |l2| l2.chomp}.include?(l1)

			if not included then
				debug "Line in not in sync: " + l1
				lines_in_sync=false
			else
				debug "Line is in sync: " + l1
			end
		end
		lines_in_sync ? :insync : :outofsync
	else
		:outofsync
	end
     end

     newvalue :outofsync

     ####IN SYNC
     newvalue :insync do
 	lines_to_append=Array.new
        if FileTest.exists?(resource[:path])
        debug "File exists for insync."
	else
        debug resource[:path] + " - File NOT exists. Creating."
        	File.open(resource[:path], 'a')
	end
		resource[:lines].each do |l1|
			
			included = File.readlines(resource[:path]).map { |l2|
       		  	l2.chomp}.include?(l1)

			if not included then
            			lines_to_append.push(l1)
				debug "Line does not exist in target file: "+l1
	        	end

		end
		if not lines_to_append.empty? then
			lines_to_append.each do |line|
   				notice "Appending \'"+ line + "\' to " + resource[:path]
        			File.open(resource[:path], 'a') { |fd| fd.puts line }
    			end
		end
	if resource[:command]!='none' then
		notice "Executing \'" + resource[:command] + "\'..."
		result_successfull=system(resource[:command])
		notice (result_successfull ? "OK!" : "FAILED.")
	end
     end
   end
  end
end
