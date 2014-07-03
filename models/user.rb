class User
  include DataMapper::Resource
  has n, :salary_items

  property :id,    Serial
  property :name, String
  property :russian_name, String
  property :start_date, DateTime
  property :email, String

end
