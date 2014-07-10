require 'spec_helper'
require 'carrierwave/test/matchers'

class Picture
  def picture_src
    'somefilename'
  end
end

describe PictureUploader do
  include CarrierWave::Test::Matchers

  before do
    PictureUploader.enable_processing = true
    @uploader = PictureUploader.new(Picture.new)
    @uploader.store!(File.open(File.dirname(__FILE__) + '/../fixtures/photo.jpg'))
  end

  after do
    PictureUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the xxxhdpi version' do
    it 'should be exactly 428 by 572 pixels' do
      expect(@uploader).to have_dimensions(428, 572)
    end

    it 'should store the picture as public/pictures/xxxhdpi/somefilename.jpg' do
      File.exist?(Rails.root + '/public/pictures/xxxhdpi/somefilename.jpg')
    end
  end

  context 'the xxhdpi version' do
    it 'should be exactly 321 by 429 pixels' do
      expect(@uploader.xxhdpi).to have_dimensions(321,429)
    end

    it 'should store the picture as public/pictures/xxhdpi/somefilename.jpg' do
      File.exist?(Rails.root + '/public/pictures/xxhdpi/somefilename.jpg')
    end
  end

  context 'the xhdpi version' do
    it 'should be exactly 214 by 286 pixels' do
      expect(@uploader.xhdpi).to have_dimensions(214,286)
    end

    it 'should store the picture as public/pictures/xhdpi/somefilename.jpg' do
      File.exist?(Rails.root + '/public/pictures/xhdpi/somefilename.jpg')
    end
  end

  context 'the hdpi version' do
    it 'should be exactly 160 by 214 pixels' do
      expect(@uploader.hdpi).to have_dimensions(160,214)
    end

    it 'should store the picture as public/pictures/hdpi/somefilename.jpg' do
      File.exist?(Rails.root + '/public/pictures/hdpi/somefilename.jpg')
    end
  end

  context 'the mdpi version' do
    it 'should be exactly 107 by 143 pixels' do
      expect(@uploader.mdpi).to have_dimensions(107,143)
    end

    it 'should store the picture as public/pictures/mdpi/somefilename.jpg' do
      File.exist?(Rails.root + '/public/pictures/mdpi/somefilename.jpg')
    end
  end

end