module ApiMacros

  def do_request(method, path, options = {})
    send method, path, options.merge(format: :json)
  end

end