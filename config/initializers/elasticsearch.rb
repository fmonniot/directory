
prefix = "#{Rails.application.class.parent_name.downcase}_#{Rails.env.to_s.downcase}_"
Tire::Model::Search.index_prefix(prefix)

Tire.configure do
  logger Rails.root + "log/tire_#{Rails.env}.log", level: 'debug'
end