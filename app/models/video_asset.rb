require 'hydra'
require "file_asset"
class VideoAsset < FileAsset
  include ActiveFedora::DatastreamCollections

  def initialize(attrs = {})
    super(attrs)
    add_relationship(:has_model, "info:fedora/afmodel:FileAsset")
  end

  has_datastream :name=>"content", :type=>ActiveFedora::Datastream, :controlGroup=>'E'

end

