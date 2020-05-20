from typing import Callable, Union
from flask import Flask, request, redirect, render_template, make_response, jsonify, g, abort
from flask_executor import Executor
import json
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy, BaseQuery, Pagination
from flask_basicauth import BasicAuth
from celery import Celery
from pusher import Pusher
import boto3
from twilio.rest import Client as TwilioClient
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration
import messagebird
import africastalking
from datetime import datetime
import redis
import config
import i18n
from eth_utils import to_checksum_address
import sys
import os
from web3 import Web3, HTTPProvider


# try:
#     import uwsgi
#     is_running_uwsgi = True
# except ImportError:
#     is_running_uwsgi = False


sys.path.append('../')
import config

# TODO: encapsulate in generic object throughout implementation
i18n.load_path.append(config.SYSTEM_LOCALE_PATH)
i18n.set('fallback', config.LOCALE_FALLBACK)

class ExtendedJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        from decimal import Decimal
        from datetime import datetime
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return str(obj)

        return json.JSONEncoder.default(self, obj)

def create_app():
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)

    app.config.from_object('config')
    app.config['BASEDIR'] = os.path.abspath(os.path.dirname(__file__))
    app.config['EXECUTOR_PROPAGATE_EXCEPTIONS'] = True
    # app.config["SQLALCHEMY_ECHO"] = True

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    register_extensions(app)
    register_blueprints(app)

    app.json_encoder = ExtendedJSONEncoder

    # includes temporary workarounds until cleanup of init file
    import server.ge_custom_init
    ge_custom_init.do(
            app=app,
            )

    return app

def register_extensions(app):
    db.init_app(app)
    executor.init_app(app)
    basic_auth.init_app(app)

    @app.before_request
    def enable_form_raw_cache():
        # Workaround to allow unparsed request body to be be read from cache
        # This is required to validate a signature on webhooks
        # This MUST go before Sentry integration as sentry triggers form parsing
        if not config.IS_TEST and (
                request.path.startswith('/api/v1/slack/') or request.path.startswith('/api/v1/poli_payments_webhook/')):
            if request.content_length > 1024 * 1024:  # 1mb
                # Payload too large
                return make_response(jsonify({'message': 'Payload too large'})), 413
            request.get_data(parse_form_data=False, cache=True)

    # limiter.init_app(app)

    CORS(app, resources={r"/api/*": {"origins": "*"}})

    celery_app.conf.update(app.config)
    if not config.IS_TEST:
        sentry_sdk.init(app.config['SENTRY_SERVER_DSN'], integrations=[FlaskIntegration()], release=config.VERSION)

    print('celery joined on {} at {}'.format(
        app.config['REDIS_URL'], datetime.utcnow()))


def register_blueprints(app):
    @app.before_request
    def before_request():
        # Celery task list. Tasks are added here so that they can be completed after db commit
        g.celery_tasks = []

        if request.url.startswith('http://') and '.withsempo.com' in request.url:
            url = request.url.replace('http://', 'https://', 1)
            code = 301
            return redirect(url, code=code)

        # if is_running_uwsgi:
        #     print("uswgi connections status is:" + str(uwsgi.is_connected(uwsgi.connection_fd())))
        #
        #     if not uwsgi.is_connected(uwsgi.connection_fd()):
        #         return make_response(jsonify({'message': 'Connection Aborted'})), 401

    @app.after_request
    def after_request(response):
            # Execute any async celery tasks

        if response.status_code < 300 and response.status_code >= 200:
            db.session.commit()

        for task in g.celery_tasks:
            try:
                # TODO: Standardize this task (pipe through execute_synchronous_celery)
                task.delay()
            except Exception as e:
                sentry_sdk.capture_exception(e)

        return response

    from .views.index import index_view
    from server.api.auth_api import auth_blueprint
    from server.api.pusher_auth_api import pusher_auth_blueprint
    from server.api.transfer_account_api import transfer_account_blueprint
    from server.api.blockchain_transaction_api import blockchain_transaction_blueprint
    from server.api.geolocation_api import geolocation_blueprint
    from server.api.ip_address_api import ip_address_blueprint
    from server.api.dataset_api import dataset_blueprint
    from server.api.credit_transfer_api import credit_transfer_blueprint
    from server.api.user_api import user_blueprint
    from server.api.kobo_api import user_kobo_blueprint
    from server.me_api import me_blueprint
    from server.api.export_api import export_blueprint
    from server.api.image_uploader_api import image_uploader_blueprint
    from server.api.recognised_face_api import recognised_face_blueprint
    from server.api.filter_api import filter_blueprint
    from server.api.kyc_application_api import kyc_application_blueprint
    from server.api.wyre_api import wyre_blueprint
    from server.api.transfer_usage_api import transfer_usage_blueprint
    from server.api.transfer_card_api import transfer_cards_blueprint
    from server.api.organisation_api import organisation_blueprint
    from server.api.token_api import token_blueprint
    from server.api.search_api import search_blueprint
    from server.api.slack_api import slack_blueprint
    from server.api.poli_payments_api import poli_payments_blueprint
    from server.api.ussd_api import ussd_blueprint
    from server.api.contract_api import contracts_blueprint
    from server.api.ge_migration_api import ge_migration_blueprint

    versioned_url = '/api/v1'

    app.register_blueprint(index_view)
    app.register_blueprint(me_blueprint, url_prefix=versioned_url + '/me')
    app.register_blueprint(auth_blueprint, url_prefix=versioned_url)
    app.register_blueprint(pusher_auth_blueprint, url_prefix=versioned_url)
    app.register_blueprint(user_blueprint, url_prefix=versioned_url)
    app.register_blueprint(user_kobo_blueprint, url_prefix=versioned_url)
    app.register_blueprint(transfer_account_blueprint, url_prefix=versioned_url)
    app.register_blueprint(blockchain_transaction_blueprint, url_prefix=versioned_url)
    app.register_blueprint(geolocation_blueprint, url_prefix=versioned_url)
    app.register_blueprint(ip_address_blueprint, url_prefix=versioned_url)
    app.register_blueprint(dataset_blueprint, url_prefix=versioned_url)
    app.register_blueprint(credit_transfer_blueprint, url_prefix=versioned_url)
    app.register_blueprint(export_blueprint, url_prefix=versioned_url)
    app.register_blueprint(image_uploader_blueprint, url_prefix=versioned_url)
    app.register_blueprint(recognised_face_blueprint, url_prefix=versioned_url)
    app.register_blueprint(filter_blueprint, url_prefix=versioned_url)
    app.register_blueprint(kyc_application_blueprint, url_prefix=versioned_url)
    app.register_blueprint(wyre_blueprint, url_prefix=versioned_url)
    app.register_blueprint(transfer_usage_blueprint, url_prefix=versioned_url)
    app.register_blueprint(transfer_cards_blueprint, url_prefix=versioned_url)
    app.register_blueprint(organisation_blueprint, url_prefix=versioned_url)
    app.register_blueprint(token_blueprint, url_prefix=versioned_url)
    app.register_blueprint(search_blueprint, url_prefix=versioned_url)
    app.register_blueprint(slack_blueprint, url_prefix=versioned_url)
    app.register_blueprint(poli_payments_blueprint, url_prefix=versioned_url)
    app.register_blueprint(ussd_blueprint, url_prefix=versioned_url)
    app.register_blueprint(contracts_blueprint, url_prefix=versioned_url)
    app.register_blueprint(ge_migration_blueprint, url_prefix=versioned_url)

    # 404 handled in react
    @app.errorhandler(404)
    def page_not_found(e):
        return render_template('index.html'), 404


def none_if_exception(f: Callable) -> Union[object, None]:
    """
    A helper function for when you're lacking configs for external packages.
    Use a partial or lambda to delay execution of f.
    :param f: a callable object instantiator
    :return: an initialised package object, or None
    """
    try:
        return f()
    except:
        return None

def encrypt_string(raw_string):
    import base64
    from cryptography.fernet import Fernet
    from eth_utils import keccak

    fernet_encryption_key = base64.b64encode(keccak(text=config.SECRET_KEY))
    cipher_suite = Fernet(fernet_encryption_key)

    return cipher_suite.encrypt(raw_string.encode('utf-8')).decode('utf-8')

class NoCountPaginateQuery(BaseQuery):
    def paginate(self, page=None, per_page=None, error_out=True, max_per_page=None):
        """Returns ``per_page`` items from page ``page``.

        If ``page`` or ``per_page`` are ``None``, they will be retrieved from
        the request query. If ``max_per_page`` is specified, ``per_page`` will
        be limited to that value. If there is no request or they aren't in the
        query, they default to 1 and 20 respectively.

        When ``error_out`` is ``True`` (default), the following rules will
        cause a 404 response:

        * No items are found and ``page`` is not 1.
        * ``page`` is less than 1, or ``per_page`` is negative.
        * ``page`` or ``per_page`` are not ints.

        When ``error_out`` is ``False``, ``page`` and ``per_page`` default to
        1 and 20 respectively.

        Returns a :class:`Pagination` object.
        """

        if request:
            if page is None:
                try:
                    page = int(request.args.get('page', 1))
                except (TypeError, ValueError):
                    if error_out:
                        abort(404)

                    page = 1

            if per_page is None:
                try:
                    per_page = int(request.args.get('per_page', 20))
                except (TypeError, ValueError):
                    if error_out:
                        abort(404)

                    per_page = 20
        else:
            if page is None:
                page = 1

            if per_page is None:
                per_page = 20

        if max_per_page is not None:
            per_page = min(per_page, max_per_page)

        if page < 1:
            if error_out:
                abort(404)
            else:
                page = 1

        if per_page < 0:
            if error_out:
                abort(404)
            else:
                per_page = 20

        items = self.limit(per_page).offset((page - 1) * per_page).all()

        if not items and page != 1 and error_out:
            abort(404)

        # No need to count if we're on the first page and there are fewer
        # items than we expected.
        # if page == 1 and len(items) < per_page:
        #     total = len(items)
        # else:
        #     total = self.order_by(None).count()

        total = 0

        return Pagination(self, page, per_page, total, items)

db = SQLAlchemy(query_class=NoCountPaginateQuery,
                session_options={
                    "expire_on_commit": not config.IS_TEST,
                    # enable_baked_queries prevents the before_compile query from getting trapped on
                    # organisation change. Shouldn't by default but ¯\_(ツ)_/¯
                    # https://docs.sqlalchemy.org/en/13/orm/extensions/baked.html
                    "enable_baked_queries": False,
                })

basic_auth = BasicAuth()
executor = Executor()

# limiter = Limiter(key_func=get_remote_address, default_limits=["20000 per day", "2000 per hour"])

s3 = boto3.client('s3', aws_access_key_id=config.AWS_SES_KEY_ID,
                  aws_secret_access_key=config.AWS_SES_SECRET)

celery_app = Celery('tasks',
                    broker=config.REDIS_URL,
                    backend=config.REDIS_URL,
                    task_serializer='json')


encrypted_private_key = encrypt_string(config.MASTER_WALLET_PRIVATE_KEY)
prior_tasks = None

red = redis.Redis.from_url(config.REDIS_URL)

try:
    pusher_client = Pusher(app_id=config.PUSHER_APP_ID,
                           key=config.PUSHER_KEY,
                           secret=config.PUSHER_SECRET,
                           cluster=config.PUSHER_CLUSTER,
                           ssl=True)
except:
    class PusherMock(object):
        def authenticate(self, *args, **kwargs):
            return ''
        def trigger(self, *args, **kwargs):
            pass
        def trigger_batch(self, *args, **kwargs):
            pass

    pusher_client = PusherMock()


def africas_talking_launcher():
    africastalking.initialize(config.AT_USERNAME, config.AT_API_KEY)
    return africastalking.SMS


twilio_client = none_if_exception(lambda: TwilioClient(config.TWILIO_SID, config.TWILIO_TOKEN))
messagebird_client = none_if_exception(lambda: messagebird.Client(config.MESSAGEBIRD_KEY))
africastalking_client = none_if_exception(africas_talking_launcher)

from server.utils.blockchain_tasks import BlockchainTasker
bt = BlockchainTasker()

from server.utils.misc_tasks import MiscTasker
mt = MiscTasker()

from server.utils.ussd.ussd_tasks import UssdTasker
ussd_tasker = UssdTasker()

ge_w3 = Web3(HTTPProvider(config.GE_HTTP_PROVIDER))


