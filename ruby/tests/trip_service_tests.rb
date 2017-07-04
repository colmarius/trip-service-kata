require 'test/unit'
require 'mocha/test_unit'
require_relative '../trip/trip_service'
require_relative '../trip/trip_dao'

class NoLoggedUserSession
  def get_logged_user
    nil
  end
end

class MockUserSession
  def initialize(user)
    @user = user
  end

  def get_logged_user
    @user
  end
end

class TripServiceTests < Test::Unit::TestCase
  NO_USER = nil
  ANNA = User.new
  BOB = User.new
  DUMMY_TRIPS = ['Chicago']

  def setup
    ANNA.add_friend(BOB)
    ANNA.add_trip('Chicago')
  end

  def mock_logged_in_as(user)
    UserSession.expects(:get_instance)
               .returns(MockUserSession.new(user))
  end

  def mock_trips_for_user(user, trips)
    TripDAO.expects(:find_trips_by_user)
           .with(user)
           .returns(trips)
  end

  def get_trip_by_user(user)
    trip.get_trip_by_user(user)
  end

  def trip
    @trip ||= TripService.new
  end

  def test_logged_out_user_throws_error
    mock_logged_in_as(NO_USER)
    get_trip_by_user(NO_USER)
  rescue => error
    assert_equal error.class, UserNotLoggedInException
  end

  def test_logged_in_user_get_trips_for_no_user
    mock_logged_in_as(BOB)
    result = get_trip_by_user(NO_USER)
    assert_equal [], result
  end

  def test_logged_in_user_with_no_trips
    mock_logged_in_as(BOB)
    result = get_trip_by_user(BOB)
    assert_equal [], result
  end

  def test_logged_in_user_with_friend_and_no_trips
    mock_logged_in_as(BOB)
    mock_trips_for_user(ANNA, DUMMY_TRIPS)
    result = get_trip_by_user(ANNA)
    assert_equal DUMMY_TRIPS, result
  end
end
