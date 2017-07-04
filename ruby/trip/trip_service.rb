require_relative '../trip/trip_dao'
require_relative '../user/user_session'
require_relative '../user/user'
require_relative '../еxceptions/user_not_logged_in_exception'
require_relative '../еxceptions/dependend_class_call_during_unit_test_exception'

class TripService
  def initialize(session: nil, trip_service: nil)
    @session = session || UserSession.get_instance
    @trip_service = trip_service || TripDAO
  end

  def get_trip_by_user(user)
    logged_user = @session.get_logged_user
    raise UserNotLoggedInException unless logged_user
    friends = user && user.friend_of(logged_user)
    friends ? @trip_service.find_trips_by_user(user) : []
  end
end
