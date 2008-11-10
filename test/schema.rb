ActiveRecord::Schema.define(:version => 1) do

  create_table :users, :force => true do |t|
    t.column :name,       :string
    t.column :age,        :integer
    t.column :deleted,    :boolean
    t.column :created_at, :datetime
  end

  create_table :addresses, :force => true do |t|
    t.column :city,       :string
    t.column :address,    :string
    t.column :user_id,    :integer
  end

  create_table :emails, :force => true do |t|
    t.column :email,      :string
    t.column :user_id,    :integer
  end

end
