namespace :stats do
  def directory_total(directory)
    total = 0
    directory_glob = Dir.glob Rails.root.join(directory, '**', '*.*')
    directory_glob.each { |file| total += %x(wc -l #{file}).to_i }
    total
  end

  task all: :environment do
    total = 0
    %w(
      app/assets/javascripts
      app/assets/stylesheets
      app/controllers
      app/models
      app/helpers
      app/mailers
      app/observers
      app/sweepers
      app/views
      config
      lib
      spec
    ).each do |directory|
      current_total = directory_total directory
      total += current_total
      puts "#{directory}: #{current_total}"
    end
    puts
    puts "Total: #{total}"
  end
end
