class Hash
  def symbolize_keys
    transform_keys do |key|
      key.to_sym
    rescue StandardError
      key
    end
  end

  def transform_keys
    return enum_for(:transform_keys) unless block_given?

    result = self.class.new
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end
end
