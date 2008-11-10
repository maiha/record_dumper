require File.dirname(__FILE__) + '/test_helper'

include ActiveRecord::RecordDumper

class HasOneTest < Test::Unit::TestCase
  fixtures :users
  fixtures :addresses
  fixtures :emails

  def setup
    @user = users(:user)
    Email.delete_all
  end

  def test_has_one
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)

Address.create!(
  :id      => 1,
  :city    => "Tokyo",
  :address => "Akihabara",
  :user_id => 1
)
    CODE
    assert_equal expected, @user.record_dumper(:dependent=>true).to_s
  end

  def test_has_one_without_entries
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)
    CODE
    Address.delete_all
    assert_equal expected, @user.record_dumper(:dependent=>true).to_s
  end
end


class HasManyTest < Test::Unit::TestCase
  fixtures :users
  fixtures :addresses
  fixtures :emails

  def setup
    @user = users(:user)
    Address.delete_all
  end

  def test_has_many
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)

Email.create!(
  :id      => 1,
  :email   => "maiha@example.com",
  :user_id => 1
)

Email.create!(
  :id      => 2,
  :email   => "maiha@example.co.jp",
  :user_id => 1
)
    CODE
    assert_equal expected, @user.record_dumper(:dependent=>true).to_s
  end

  def test_has_many_without_entries
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)
    CODE
    Email.delete_all
    assert_equal expected, @user.record_dumper(:dependent=>true).to_s
  end
end


class CompositeAssociationsTest < Test::Unit::TestCase
  fixtures :users
  fixtures :addresses
  fixtures :emails

  def setup
    @user = users(:user)
  end

  def test_composite_associations
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)

Address.create!(
  :id      => 1,
  :city    => "Tokyo",
  :address => "Akihabara",
  :user_id => 1
)

Email.create!(
  :id      => 1,
  :email   => "maiha@example.com",
  :user_id => 1
)

Email.create!(
  :id      => 2,
  :email   => "maiha@example.co.jp",
  :user_id => 1
)
    CODE
    assert_equal expected, @user.record_dumper(:dependent=>true).to_s
  end
end
