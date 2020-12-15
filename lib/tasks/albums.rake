namespace :albums do
  task :update => :environment do
    albums = Album.all
    albums.each do |album|
      data = album.data
      new_data = data.inject({}) { |h, (k, v)| h[k] = 1; h }
      album.update_column(:data, new_data)
    end
  end
end