require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name: "Test User", email: "test_user@gamil.com",
                     password: "12345678", password_confirmation: "12345678"
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "          "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "        "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "valid emails should be accepted" do
    valid_emails = %w[test@test.com test.abcd@google.com test_1234@foobar.cn]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?
    end
  end

  test "invalid emails should be rejected" do
    invalid_emails = %w[aaaa@b+c testx.example.com 123456@a+.com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?
    end
  end

  test "email address should be unique" do
    duplicate = @user.dup
    duplicate.email = duplicate.email.upcase
    @user.save
    assert_not duplicate.valid?
  end

  test "email address should be saved downcase" do
    input_email = "ExAMple@tESt.CoM"
    @user.email = input_email
    @user.save

    assert_equal input_email.downcase, @user.reload.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = "    "
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user and check followers" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)

    assert archer.followers.include?(michael)

    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end

    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
