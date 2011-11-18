require 'net/http/digest_auth'
require 'net/http/post/multipart'

class FileAssetsController < ApplicationController
  include Hydra::FileAssets
  
  # Creates and Saves a File Asset to contain the the Uploaded file 
  # If container_id is provided:
  # * the File Asset will use RELS-EXT to assert that it's a part of the specified container
  # * the method will redirect to the container object's edit view after saving
  def create
    if params.has_key?(:number_of_files) and params[:number_of_files] != "0"
      return redirect_to({:controller => "catalog", :action => "edit", :id => params[:id], :wf_step => :files, :number_of_files => params[:number_of_files]})
    elsif params.has_key?(:number_of_files) and params[:number_of_files] == "0"
      return redirect_to( {:controller => "catalog", :action => "edit", :id => params[:id]}.merge(params_for_next_step_in_wokflow) )
    end
    
    if params.has_key?(:Filedata) and params.has_key?(:original)
	#TODO make call to matterhorn
	sendOriginalToMatterhorn
	flash[:notice] = "The uploaded file has been sent to Matterhorn for processing."
    elsif params.has_key?(:Filedata)
      @file_assets = create_and_save_file_assets_from_params
      notice = []
      @file_assets.each do |file_asset|
        apply_depositor_metadata(file_asset)
        
        notice << "The file #{file_asset.label} has been saved in <a href=\"#{asset_url(file_asset.pid)}\">#{file_asset.pid}</a>."
          
        if !params[:container_id].nil?
          associate_file_asset_with_container(file_asset,'info:fedora/' + params[:container_id])
        end
  
        ## Apply any posted file metadata
        unless params[:asset].nil?
          logger.debug("applying submitted file metadata: #{@sanitized_params.inspect}")
          apply_file_metadata
        end
        # If redirect_params has not been set, use {:action=>:index}
        logger.debug "Created #{file_asset.pid}."
      end
      flash[:notice] = notice.join("<br/>") unless notice.blank?
    else
      flash[:notice] = "You must specify a file to upload."
    end
    
    unless params[:container_id].nil?
      redirect_params = {:controller => "catalog", :action => "edit", :id => params[:container_id]}.merge(params_for_next_step_in_wokflow)
    end
    redirect_params ||= {:controller => "catalog", :action => "index"}
    
    redirect_to redirect_params
  end
  
  def sendOriginalToMatterhorn
	uri = URI.parse 'http://pawpaw.dlib.indiana.edu:8080/welcome.html'
	uri.user = 'matterhorn_system_account'
	uri.password = 'CHANGE_ME'

	h = Net::HTTP.new uri.host, uri.port
	req = Net::HTTP::Head.new uri.request_uri
	req['X-REQUESTED-AUTH'] = 'Digest'
	res = h.request req

	digest_auth = Net::HTTP::DigestAuth.new
	auth = digest_auth.auth_header uri, res['www-authenticate'], 'GET'
	req = Net::HTTP::Post.new uri.request_uri
	req.add_field 'Authorization', auth
	res = h.request req
	uri = URI.parse("http://pawpaw.dlib.indiana.edu:8080/ingest/addMediaPackage/fedora-test")
	uri.user = 'matterhorn_system_account'
	uri.password = 'CHANGE_ME'
	h = Net::HTTP.new uri.host, uri.port
	req = Net::HTTP::Head.new uri.request_uri
	req['X-REQUESTED-AUTH'] = 'Digest'
	res = h.request req
	digest_auth = Net::HTTP::DigestAuth.new
	auth = digest_auth.auth_header uri, res['www-authenticate'], 'POST'
	
	params[:Filedata].each do |file|
	  file_name = file.original_filename
	  reqparams = Array[["wdID", "fedora-test"], ["flavor", "video/source"], ["title", params[:container_id]],
	    ["BODY", UploadIO.new(file, mime_type(file_name), file_name)]]
	  req = Net::HTTP::Post::Multipart.new uri.path, reqparams
	  req.add_field 'Authorization', auth

	  res = Net::HTTP.start(uri.host, uri.port) do |http|
	    res = http.request(req)
	    logger.debug("Request to Matterhorn returned " + res.code)
	  end
	end
   end
end
