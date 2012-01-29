namespace :assets do
  desc 'Removes old compiled assets'
  task :cleanup => :environment do
    Dir.chdir Rails.root.join('public', 'assets')
    all_assets = Dir.glob('**/*.*').reject { |asset| asset.match /\.gz$/ }
    all_assets.delete 'manifest.yml'

    manifest = YAML::load Rails.root.join('public', 'assets', 'manifest.yml')
    manifest_assets = manifest.keys + manifest.values

    (all_assets - manifest_assets).each do |asset|
      FileUtils.rm asset
      puts "Removed: #{asset}"

      if asset.match /\.(js|css)$/
        FileUtils.rm "#{asset}.gz"
        puts "Removed: #{asset}.gz"
      end
    end
  end
end
