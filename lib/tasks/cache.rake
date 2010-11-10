namespace :cache do
  desc 'Lists all caches'
  task :list => :environment do
    files = Dir.glob("#{Rails.root}/tmp/cache/**/*").select { |f| f.include? '/views' }
    caches = files.map { |f| CGI::unescape(File.basename f).color(:green) }
    result = caches.empty? ? 'No caches found.'.color(:red) : caches.sort
    puts result
  end

  desc 'Clears all caches'
  task :clear => :environment do
    result = Rails.cache.clear
    if result.empty?
      puts 'There were no caches.'.color(:red)
    else
      count = result.size.to_s.color(:green)
      puts "Caches cleared: #{count}"
    end
  end
end

task :cache => 'cache:list'
