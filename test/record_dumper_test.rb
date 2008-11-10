require File.dirname(__FILE__) + '/test_helper'

include ActiveRecord::RecordDumper

class RecordDumperTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @user = users(:user)
  end

  def test_load_class
    assert_equal CreateBang, @user.record_dumper.class
    assert_equal CreateBang, @user.record_dumper.create!.class
    assert_equal Create    , @user.record_dumper.create.class
    assert_equal SaveBang  , @user.record_dumper.save!.class
    assert_equal Save      , @user.record_dumper.save.class
    assert_equal Sql       , @user.record_dumper.sql.class
  end

  def test_create!
    expected = (<<-CODE).chomp
User.create!(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)
    CODE
    assert_equal expected, @user.record_dumper.to_s
  end

  def test_create
    expected = (<<-CODE).chomp
User.create(
  :id         => 1,
  :name       => "maiha",
  :age        => 14,
  :deleted    => false,
  :created_at => 'Sat Nov 20 00:00:00 +0900 1993'
)
    CODE
    assert_equal expected, @user.record_dumper.create.to_s
  end

  def test_save!
    expected = (<<-CODE).chomp
record = User
record[:id]         = 1
record[:name]       = "maiha"
record[:age]        = 14
record[:deleted]    = false
record[:created_at] = 'Sat Nov 20 00:00:00 +0900 1993'
record.save!
    CODE
    assert_equal expected, @user.record_dumper.save!.to_s
  end

  def test_save
    expected = (<<-CODE).chomp
record = User
record[:id]         = 1
record[:name]       = "maiha"
record[:age]        = 14
record[:deleted]    = false
record[:created_at] = 'Sat Nov 20 00:00:00 +0900 1993'
record.save
    CODE
    assert_equal expected, @user.record_dumper.save.to_s
  end

  def test_save
    expected = (<<-CODE).chomp
record = User
record[:id]         = 1
record[:name]       = "maiha"
record[:age]        = 14
record[:deleted]    = false
record[:created_at] = 'Sat Nov 20 00:00:00 +0900 1993'
record.save
    CODE
    assert_equal expected, @user.record_dumper.save.to_s
  end
end
