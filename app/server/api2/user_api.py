# standard imports
import logging

# third party imports
from flask import Blueprint, request, make_response, jsonify
from flask.views import MethodView

# platform imports
from server import db
from share.models.user import ExtendedUser
from server.utils.auth import requires_auth
from share import user as extended_user

logg = logging.getLogger()


class UserLocationAPI(MethodView):
    """Handles location-related operations on user

    Documentation is brief since it implmements standard flask blueprint interface
    """

    def get(self, user_id):
        """gets the stored location for the given user
        """
        u = ExtendedUser.query.get(user_id)
        logg.debug('user {} -> {}'.format(user_id, u))
        #u = db.session.query(ExtendedUser).get(user_id)

        response_object={
            'user_id': user_id,
            'location': [],
        }
        location = u.full_location
        while location != None:
            response_object['location'].append({
                    'latitude': location.latitude,
                    'longitude': location.longitude,
                    'common_name': location.common_name,
                })
            location = location.parent

        return make_response(jsonify(response_object)), 200


    def put(self, user_id):
        request_data = request.get_json()
        request_data['user_id'] = user_id

        try:
            extended_user.update(user_id, request_data)
        except:
            return make_response(jsonify({'message': 'invalid update data'})), 400
                
        # TODO: load full user data and return that
        return make_response(jsonify(request_data)), 200



user_blueprint = Blueprint('v2_user_geolocation', __name__)

user_blueprint.add_url_rule(
        '/user/<int:user_id>/geolocation/',
        view_func=UserLocationAPI.as_view('v2_user_geo|ocation_view'),
        methods=['GET', 'PUT'],
        )
