namespace :radiant do
  namespace :extensions do
    namespace :reverb_nation do
      
      desc "Runs the migration of the Reverb Nation extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ReverbNationExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ReverbNationExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Reverb Nation to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[ReverbNationExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ReverbNationExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
