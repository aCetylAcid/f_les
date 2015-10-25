#!/home/aCetylAcid/local/ruby/bin/ruby
require 'rubygems'
require 'sinatra'

$SHARED_DIR = "/Users/aCetylAcid/shared/"

# Handlers
get '/file/list' do
    @files = Dir::entries($SHARED_DIR).select{|f|File::ftype($SHARED_DIR + f) != "directory"}
    erb :index
end

get '/file/get' do
    fname = params[:fn]
    print(fname + "\n")

    if !is_file_downloadable(fname) then
        not_found
    end

    send_file($SHARED_DIR + fname, :filename => fname)
end


# Error handle
not_found do
    erb :error_404
end


# Other
def is_file_downloadable(fname)
    # if file is not exist, cannot download.
    if !(fname and File::exist?($SHARED_DIR + fname)) then
        return false
    end

    # if file is not file, cannot download.
    if !(File::ftype($SHARED_DIR + fname) == "file") then
        return false
    end

    # if file is out of SHARED_DIR, cannot download.
    abs_path_req = File::absolute_path($SHARED_DIR + fname)
    abs_path_shared_dir = File::absolute_path($SHARED_DIR)
    if !(abs_path_req.start_with? abs_path_shared_dir)
        return false
    end

    return true
end