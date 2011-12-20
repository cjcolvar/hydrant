require 'net/http/digest_auth'
require 'net/http/post/multipart'
require 'rubyhorn'

class FileAssetsController < ApplicationController
  include Hydra::FileAssets

  skip_before_filter :verify_authenticity_token, :only => [:create]
  
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
	sendOriginalToMatterhorn
	#TODO store Workflow instance id and/or MediaPackage in VideoDCDatastream so we can show processing status on edit page later
	flash[:notice] = "The uploaded file has been sent to Matterhorn for processing."
    elsif params.has_key?(:Filedata)
      notice = process_files
      flash[:notice] = notice.join("<br/>".html_safe) unless notice.blank?
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
	params[:Filedata].each do |file|
	  Rubyhorn.client.addMediaPackage(file, {"title" => params[:container_id], "flavor" => "video/source", "workflow" => "fedora-test", "filename" => file.original_filename})
	end
   end
end
