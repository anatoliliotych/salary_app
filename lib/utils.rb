require 'httpi'

module Utils

  include ::FileUtils

  def download_salary_file(params)
    url = Settings.common.url
    file_path = Settings.common.path
    file_dir = File.dirname(file_path)
    Dir.mkdir(file_dir) unless Dir.exists?(file_dir)

    req = HTTPI::Request.new(url)
    req.auth.basic(params[:user], params[:pass])
    res = HTTPI.head(req, :httpclient)
    if res.code == 200 && res.headers['Content-Type'] == "application/vnd.ms-excel"
      the_same = if File.exists?(file_path)
                   File.size(file_path).to_s == res.headers['Content-Length']
                 end
      unless the_same
        res = HTTPI.get(req, :httpclient)
        File.open(file_path, 'wb') { |file| file.write(res.body) }
      end
    else
      raise 'File salary.xls can\'t be downloaded.'
    end
  end
end
