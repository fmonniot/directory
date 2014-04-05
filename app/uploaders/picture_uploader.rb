# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    'pictures/xxxhdpi'
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.picture_src}.jpg" if original_filename
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  ## Create different versions the uploaded file
  # Use android definition of dpi (for reference, the website use the mdpi version, retina version is xhdpi)
  # { mdpi: 160 dpi, hdpi: 1.5*mdpi, xhdpi: 2*mdpi, xxhdpi: 3*mdpi, xxxhdpi: 4*mdpi}
  # The original file is the xxxhdpi version (eg. width:428, height:572)
  version :mdpi do
    process :resize_to_fill => [107,143]

    def store_dir
      'pictures/mdpi'
    end
    def full_filename(for_file = model.picture.file)
    "#{model.picture_src}.jpg"
    end
  end

  version :hdpi do
    process :resize_to_fill => [160,214]
    def store_dir
      'pictures/hdpi'
    end
    def full_filename(for_file = model.picture.file)
      "#{model.picture_src}.jpg"
    end
  end

  version :xhdpi do
    process :resize_to_fill => [214,286]
    def store_dir
      'pictures/xhdpi'
    end
    def full_filename(for_file = model.picture.file)
      "#{model.picture_src}.jpg"
    end
  end

  version :xxhdpi do
    process :resize_to_fill => [321,429]
    def store_dir
      'pictures/xxhdpi'
    end
    def full_filename(for_file = model.picture.file)
      "#{model.picture_src}.jpg"
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

end
