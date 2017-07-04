class User
  def initialize
    @trips = []
    @friends = []
  end

  def get_friends
    @friends
  end

  def add_friend(user)
    @friends << user
  end

  def friend_of(another_user)
    get_friends.each do |friend|
      return true if friend == another_user
    end
    false
  end

  def add_trip(trip)
    @trips << trip
  end

  def trips
    @trips
  end
end
